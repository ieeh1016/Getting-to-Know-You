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
          'kind': switch (wish.kind) {
            WishKind.place => 'place',
            WishKind.activity => 'activity',
          },
          'likedByProfileIds': wish.likedByProfileIds.toList(),
          'done': wish.done,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
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

  String? _readString(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    return null;
  }
}
