import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/alagagi_controller.dart';

class FirebaseAlagagiAuthRepository implements AlagagiAuthRepository {
  FirebaseAlagagiAuthRepository({FirebaseAuth? auth})
    : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  @override
  Stream<AlagagiAuthUser?> authStateChanges() {
    return _auth.authStateChanges().map((user) {
      if (user == null) {
        return null;
      }
      return _authUserFromFirebase(user);
    });
  }

  @override
  Future<AlagagiAuthUser> signInWithIdAndPassword({
    required String loginId,
    required String password,
  }) async {
    try {
      final email = firebaseEmailForLoginId(loginId);
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AlagagiAuthException('로그인 정보를 다시 확인해 주세요.');
      }
      return _authUserFromFirebase(user);
    } on FirebaseAuthException catch (error) {
      throw AlagagiAuthException(_authErrorMessage(error.code));
    }
  }

  @override
  Future<void> signOut() {
    return _auth.signOut();
  }

  AlagagiAuthUser _authUserFromFirebase(User user) {
    final email = user.email ?? '';
    return AlagagiAuthUser(
      uid: user.uid,
      loginId: _loginIdFromEmail(email),
      email: email,
    );
  }

  String _loginIdFromEmail(String email) {
    const suffix = '@gettoknow.local';
    if (email.endsWith(suffix)) {
      return email.substring(0, email.length - suffix.length);
    }
    return email;
  }

  String _authErrorMessage(String code) {
    return switch (code) {
      'invalid-email' => '아이디를 다시 확인해 주세요.',
      'user-disabled' => '잠시 들어올 수 없는 계정이에요.',
      'user-not-found' ||
      'wrong-password' ||
      'invalid-credential' => '아이디 또는 비밀번호를 다시 확인해 주세요.',
      'too-many-requests' => '잠시 후에 다시 시도해 주세요.',
      _ => '로그인 중 문제가 생겼어요. 잠시 후 다시 시도해 주세요.',
    };
  }
}

class FirestoreAlagagiDataRepository implements AlagagiDataRepository {
  FirestoreAlagagiDataRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<AlagagiSession?> loadSession(AlagagiAuthUser user) async {
    final users = _firestore.collection('users');
    final meSnapshot = await users.doc(user.uid).get();
    final meData = meSnapshot.data();
    if (!meSnapshot.exists || meData == null) {
      return null;
    }

    final partnerUid = _readString(meData, 'partnerUid');
    final partnerSnapshot = partnerUid == null
        ? null
        : await users.doc(partnerUid).get();
    final partnerData = partnerSnapshot?.data();
    final spaceId = _readString(meData, 'spaceId') ?? 'main';
    final spaceData = await _loadSpaceData(
      spaceId: spaceId,
      meId: user.uid,
      partnerId: partnerUid,
    );

    return AlagagiSession(
      spaceId: spaceId,
      me: _profileFromData(
        id: user.uid,
        data: meData,
        fallbackName: user.loginId,
        fallbackAvatar: '🌿',
        isMe: true,
      ),
      partner: _profileFromData(
        id: partnerUid ?? 'partner',
        data: partnerData ?? const {},
        fallbackName: '그대',
        fallbackAvatar: '🪻',
        isMe: false,
      ),
      data: spaceData,
    );
  }

  @override
  Future<void> saveAnswer(String spaceId, Answer answer) {
    return _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('answers')
        .doc('${answer.questionId}_${answer.profileId}')
        .set({
          'questionId': answer.questionId,
          'profileId': answer.profileId,
          'body': answer.body,
          'createdLabel': answer.createdLabel,
          'skipped': answer.skipped,
          'edited': answer.edited,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  @override
  Future<void> saveAnswerComment(String spaceId, AnswerComment comment) {
    return _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('answerComments')
        .doc(
          '${comment.questionId}_${comment.answerOwnerProfileId}_${comment.commenterProfileId}',
        )
        .set({
          'questionId': comment.questionId,
          'answerOwnerProfileId': comment.answerOwnerProfileId,
          'commenterProfileId': comment.commenterProfileId,
          'body': comment.body,
          'createdLabel': comment.createdLabel,
          'edited': comment.edited,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  @override
  Future<void> saveDailyQuestionProgress(
    String spaceId,
    DailyQuestionProgress progress,
  ) {
    return _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('progress')
        .doc('daily')
        .set({
          'currentQuestionId': progress.currentQuestionId,
          'openedDateKey': progress.openedDateKey,
          'catalogVersion': progress.catalogVersion,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  @override
  Future<void> saveSpacePersonalization(
    String spaceId,
    SpacePersonalization personalization,
  ) {
    return _firestore.collection('spaces').doc(spaceId).set({
      'personalization': _personalizationToData(personalization),
      'personalizationUpdatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> saveBalanceSelection(
    String spaceId,
    BalanceSelection selection,
  ) {
    return _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('balanceSelections')
        .doc('${selection.questionId}_${selection.profileId}')
        .set({
          'questionId': selection.questionId,
          'profileId': selection.profileId,
          'optionId': selection.optionId,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  @override
  Future<void> saveProfileSlot(
    String spaceId,
    String profileId,
    ProfileSlot slot,
  ) {
    return _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('profileCards')
        .doc(profileId)
        .collection('slots')
        .doc(slot.id)
        .set({
          'id': slot.id,
          'label': slot.label,
          'icon': slot.icon,
          'value': slot.value,
          'locked': slot.locked,
          'unlockHint': slot.unlockHint,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  @override
  Future<void> saveWish(String spaceId, WishItem wish) {
    return _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('wishes')
        .doc(wish.id)
        .set({
          'id': wish.id,
          'icon': wish.icon,
          'title': wish.title,
          'createdByProfileId': wish.createdByProfileId,
          'kind': switch (wish.kind) {
            WishKind.place => 'place',
            WishKind.activity => 'activity',
          },
          'likedByProfileIds': wish.likedByProfileIds.toList(),
          'done': wish.done,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  Future<AlagagiSpaceData> _loadSpaceData({
    required String spaceId,
    required String meId,
    required String? partnerId,
  }) async {
    final space = _firestore.collection('spaces').doc(spaceId);
    final spaceSnapshot = await space.get();
    final answersSnapshot = await space.collection('answers').get();
    final commentsSnapshot = await space.collection('answerComments').get();
    final balanceSnapshot = await space.collection('balanceSelections').get();
    final wishesSnapshot = await space.collection('wishes').get();
    final progressSnapshot = await space
        .collection('progress')
        .doc('daily')
        .get();

    final profileSlots = <ProfileSlotValue>[];
    for (final profileId in {meId, ?partnerId}) {
      final slotsSnapshot = await space
          .collection('profileCards')
          .doc(profileId)
          .collection('slots')
          .get();
      for (final doc in slotsSnapshot.docs) {
        final slot = _profileSlotFromData(doc.data(), fallbackId: doc.id);
        if (slot != null) {
          profileSlots.add(ProfileSlotValue(profileId: profileId, slot: slot));
        }
      }
    }

    return AlagagiSpaceData(
      answers: answersSnapshot.docs
          .map((doc) => _answerFromData(doc.data()))
          .nonNulls
          .toList(),
      answerComments: commentsSnapshot.docs
          .map((doc) => _answerCommentFromData(doc.data()))
          .nonNulls
          .toList(),
      balanceSelections: balanceSnapshot.docs
          .map((doc) => _balanceSelectionFromData(doc.data()))
          .nonNulls
          .toList(),
      profileSlots: profileSlots,
      wishes: wishesSnapshot.docs
          .map((doc) => _wishFromData(doc.id, doc.data()))
          .nonNulls
          .toList(),
      dailyProgress: _dailyProgressFromData(progressSnapshot.data()),
      personalization: _personalizationFromData(spaceSnapshot.data()),
    );
  }

  Answer? _answerFromData(Map<String, dynamic> data) {
    final questionId = _readString(data, 'questionId');
    final profileId = _readString(data, 'profileId');
    if (questionId == null || profileId == null) {
      return null;
    }
    return Answer(
      questionId: questionId,
      profileId: profileId,
      body: _readString(data, 'body') ?? '',
      createdLabel: _readString(data, 'createdLabel') ?? '오늘',
      skipped: data['skipped'] == true,
      edited: data['edited'] == true,
    );
  }

  AnswerComment? _answerCommentFromData(Map<String, dynamic> data) {
    final questionId = _readString(data, 'questionId');
    final answerOwnerProfileId = _readString(data, 'answerOwnerProfileId');
    final commenterProfileId = _readString(data, 'commenterProfileId');
    final body = _readString(data, 'body');
    if (questionId == null ||
        answerOwnerProfileId == null ||
        commenterProfileId == null ||
        body == null) {
      return null;
    }
    return AnswerComment(
      questionId: questionId,
      answerOwnerProfileId: answerOwnerProfileId,
      commenterProfileId: commenterProfileId,
      body: body,
      createdLabel: _readString(data, 'createdLabel') ?? '오늘',
      edited: data['edited'] == true,
    );
  }

  DailyQuestionProgress? _dailyProgressFromData(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }
    final currentQuestionId = _readString(data, 'currentQuestionId');
    final openedDateKey = _readString(data, 'openedDateKey');
    if (currentQuestionId == null || openedDateKey == null) {
      return null;
    }
    return DailyQuestionProgress(
      currentQuestionId: currentQuestionId,
      openedDateKey: openedDateKey,
      catalogVersion: _readString(data, 'catalogVersion') ?? 'v1',
    );
  }

  BalanceSelection? _balanceSelectionFromData(Map<String, dynamic> data) {
    final questionId = _readString(data, 'questionId');
    final profileId = _readString(data, 'profileId');
    final optionId = _readString(data, 'optionId');
    if (questionId == null || profileId == null || optionId == null) {
      return null;
    }
    return BalanceSelection(
      questionId: questionId,
      profileId: profileId,
      optionId: optionId,
    );
  }

  ProfileSlot? _profileSlotFromData(
    Map<String, dynamic> data, {
    required String fallbackId,
  }) {
    final label = _readString(data, 'label');
    if (label == null) {
      return null;
    }
    return ProfileSlot(
      id: _readString(data, 'id') ?? fallbackId,
      label: label,
      icon: _readString(data, 'icon') ?? '🌿',
      value: _readString(data, 'value'),
      locked: data['locked'] == true,
      unlockHint: _readString(data, 'unlockHint'),
    );
  }

  WishItem? _wishFromData(String fallbackId, Map<String, dynamic> data) {
    final title = _readString(data, 'title');
    if (title == null) {
      return null;
    }
    final likedByRaw = data['likedByProfileIds'];
    final likedBy = likedByRaw is Iterable
        ? likedByRaw.whereType<String>().toSet()
        : <String>{};
    final kind = switch (_readString(data, 'kind')) {
      'place' => WishKind.place,
      'activity' => WishKind.activity,
      _ => WishKind.activity,
    };
    return WishItem(
      id: _readString(data, 'id') ?? fallbackId,
      icon: _readString(data, 'icon') ?? '🌿',
      title: title,
      kind: kind,
      createdByProfileId:
          _readString(data, 'createdByProfileId') ??
          (likedBy.isEmpty ? '' : likedBy.first),
      likedByProfileIds: likedBy,
      done: data['done'] == true,
    );
  }

  AppProfile _profileFromData({
    required String id,
    required Map<String, dynamic> data,
    required String fallbackName,
    required String fallbackAvatar,
    required bool isMe,
  }) {
    return AppProfile(
      id: id,
      nickname: _readString(data, 'displayName') ?? fallbackName,
      avatar: _readString(data, 'avatar') ?? fallbackAvatar,
      isMe: isMe,
    );
  }

  SpacePersonalization _personalizationFromData(Map<String, dynamic>? data) {
    final raw = data?['personalization'];
    if (raw is! Map<String, dynamic>) {
      return const SpacePersonalization();
    }
    const defaults = SpacePersonalization();
    return SpacePersonalization(
      appTitle: _readString(raw, 'appTitle') ?? defaults.appTitle,
      homeLine: _readString(raw, 'homeLine') ?? defaults.homeLine,
      inviteLine: _readString(raw, 'inviteLine') ?? defaults.inviteLine,
      accentEmoji: _readString(raw, 'accentEmoji') ?? defaults.accentEmoji,
    );
  }

  Map<String, dynamic> _personalizationToData(
    SpacePersonalization personalization,
  ) {
    return {
      'appTitle': personalization.appTitle,
      'homeLine': personalization.homeLine,
      'inviteLine': personalization.inviteLine,
      'accentEmoji': personalization.accentEmoji,
    };
  }

  String? _readString(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    return null;
  }
}
