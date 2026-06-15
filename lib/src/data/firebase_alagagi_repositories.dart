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
        fallbackName: '상대',
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
          'startedDateKey': progress.startedDateKey,
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
    final data = <String, Object?>{
      'questionId': selection.questionId,
      'profileId': selection.profileId,
      'optionId': selection.optionId,
      'reason': selection.reason,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    final resultRevealedAt = selection.resultRevealedAt;
    if (resultRevealedAt != null) {
      data['resultRevealedAt'] = Timestamp.fromDate(resultRevealedAt);
    }
    return _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('balanceSelections')
        .doc('${selection.questionId}_${selection.profileId}')
        .set(data, SetOptions(merge: true));
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
          'category': slot.category,
          'inputHint': slot.inputHint,
          'value': slot.value,
          'locked': slot.locked,
          'unlockHint': slot.unlockHint,
          'skipped': slot.skipped,
          'hidden': slot.hidden,
          'custom': slot.custom,
          'updatedByProfileId': slot.updatedByProfileId ?? profileId,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  @override
  Future<void> deleteProfileSlot(
    String spaceId,
    String profileId,
    String slotId,
  ) {
    return _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('profileCards')
        .doc(profileId)
        .collection('slots')
        .doc(slotId)
        .delete();
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
          'updatedByProfileId':
              wish.updatedByProfileId ?? wish.createdByProfileId,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  @override
  Future<void> saveMusicNote(String spaceId, MusicNote note) {
    return _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('musicNotes')
        .doc(note.id)
        .set({
          'id': note.id,
          'title': note.title,
          'artist': note.artist,
          'link': note.link,
          'note': note.note,
          'mood': note.mood,
          'createdByProfileId': note.createdByProfileId,
          'createdLabel': note.createdLabel,
          'listenedByProfileIds': note.listenedByProfileIds.toList(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  @override
  Future<void> saveMusicNoteListenState(String spaceId, MusicNote note) {
    return _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('musicNotes')
        .doc(note.id)
        .update({'listenedByProfileIds': note.listenedByProfileIds.toList()});
  }

  @override
  Future<void> saveScheduleEntry(String spaceId, ScheduleEntry entry) {
    return _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('scheduleEntries')
        .doc(entry.id)
        .set({
          'dateKey': entry.dateKey,
          'profileId': entry.profileId,
          'availability': _availabilityToData(entry.availability),
          'timeSlots': entry.timeSlots.map(_timeSlotToData).toList(),
          'timeBlocks': entry.timeBlocks.map(_timeBlockToData).toList(),
          'sharedMemo': entry.sharedMemo,
          'isMeetingDay': entry.isMeetingDay,
          'meetingTimeLabel': entry.meetingTimeLabel,
          'meetingNote': entry.meetingNote,
          'meetingPlanItems': entry.meetingPlanItems,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  @override
  Future<void> saveSharedPlace(String spaceId, SharedPlace place) {
    return _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('sharedPlaces')
        .doc(place.id)
        .set({
          'id': place.id,
          'name': place.name,
          'address': place.address,
          'category': _placeCategoryToData(place.category),
          'provider': _mapApiProviderToData(place.provider),
          'providerPlaceId': place.providerPlaceId,
          'latitude': place.latitude,
          'longitude': place.longitude,
          'note': place.note,
          'createdByProfileId': place.createdByProfileId,
          'interestedByProfileIds': place.interestedByProfileIds.toList(),
          'linkedDateKey': place.linkedDateKey ?? '',
          'updatedByProfileId':
              place.updatedByProfileId ?? place.createdByProfileId,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  @override
  Future<void> deleteSharedPlace(String spaceId, String placeId) {
    return _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('sharedPlaces')
        .doc(placeId)
        .delete();
  }

  @override
  Future<void> saveCuriosityCard(String spaceId, CuriosityCard card) {
    return _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('curiosityCards')
        .doc(card.id)
        .set({
          'id': card.id,
          'fromProfileId': card.fromProfileId,
          'toProfileId': card.toProfileId,
          'question': card.question,
          'reply': card.reply ?? '',
          'createdLabel': card.createdLabel,
          'repliedLabel': card.repliedLabel ?? '',
          'updatedByProfileId':
              card.updatedByProfileId ??
              (card.hasReply ? card.toProfileId : card.fromProfileId),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  @override
  Future<void> saveStockStory(String spaceId, StockStory story) {
    return _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('stockStories')
        .doc(story.id)
        .set({
          'id': story.id,
          'symbol': FieldValue.delete(),
          'name': story.name,
          'reason': story.reason,
          'upside': story.upside,
          'risk': story.risk,
          'question': story.question,
          'createdByProfileId': story.createdByProfileId,
          'createdLabel': story.createdLabel,
          'replyTone': story.replyTone ?? '',
          'reply': story.reply ?? '',
          'repliedByProfileId': story.repliedByProfileId ?? '',
          'repliedLabel': story.repliedLabel ?? '',
          'updatedByProfileId':
              story.updatedByProfileId ??
              story.repliedByProfileId ??
              story.createdByProfileId,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  @override
  Future<void> saveStockHolding(String spaceId, StockHolding holding) {
    return _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('stockHoldings')
        .doc(holding.id)
        .set({
          'id': holding.id,
          'symbol': FieldValue.delete(),
          'name': holding.name,
          'status': holding.status,
          'weightLabel': holding.weightLabel,
          'reason': holding.reason,
          'watchPoint': holding.watchPoint,
          'concern': holding.concern,
          'question': holding.question,
          'createdByProfileId': holding.createdByProfileId,
          'createdLabel': holding.createdLabel,
          'replyTone': holding.replyTone ?? '',
          'reply': holding.reply ?? '',
          'repliedByProfileId': holding.repliedByProfileId ?? '',
          'repliedLabel': holding.repliedLabel ?? '',
          'updatedByProfileId':
              holding.updatedByProfileId ??
              holding.repliedByProfileId ??
              holding.createdByProfileId,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  @override
  Future<void> deleteStockHolding(String spaceId, String holdingId) {
    return _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('stockHoldings')
        .doc(holdingId)
        .delete();
  }

  @override
  Future<void> saveImprovementPost(String spaceId, ImprovementPost post) {
    return _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('improvementPosts')
        .doc(post.id)
        .set({
          'id': post.id,
          'title': post.title,
          'body': post.body,
          'category': post.category,
          'createdByProfileId': post.createdByProfileId,
          'createdLabel': post.createdLabel,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  @override
  Future<void> deleteImprovementPost(String spaceId, String postId) {
    return _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('improvementPosts')
        .doc(postId)
        .delete();
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
    final musicNotesSnapshot = await space.collection('musicNotes').get();
    final scheduleEntriesSnapshot = await space
        .collection('scheduleEntries')
        .get();
    final sharedPlacesSnapshot = await space.collection('sharedPlaces').get();
    final curiosityCardsSnapshot = await space
        .collection('curiosityCards')
        .get();
    final stockStoriesSnapshot = await space.collection('stockStories').get();
    final stockHoldingsSnapshot = await space.collection('stockHoldings').get();
    final improvementPostsSnapshot = await space
        .collection('improvementPosts')
        .get();
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
      musicNotes: musicNotesSnapshot.docs
          .map((doc) => _musicNoteFromData(doc.id, doc.data()))
          .nonNulls
          .toList(),
      scheduleEntries: scheduleEntriesSnapshot.docs
          .map((doc) => _scheduleEntryFromData(doc.id, doc.data()))
          .nonNulls
          .toList(),
      sharedPlaces: sharedPlacesSnapshot.docs
          .map((doc) => _sharedPlaceFromData(doc.id, doc.data()))
          .nonNulls
          .toList(),
      curiosityCards: curiosityCardsSnapshot.docs
          .map((doc) => _curiosityCardFromData(doc.id, doc.data()))
          .nonNulls
          .toList(),
      stockStories: stockStoriesSnapshot.docs
          .map((doc) => _stockStoryFromData(doc.id, doc.data()))
          .nonNulls
          .toList(),
      stockHoldings: stockHoldingsSnapshot.docs
          .map((doc) => _stockHoldingFromData(doc.id, doc.data()))
          .nonNulls
          .toList(),
      improvementPosts: improvementPostsSnapshot.docs
          .map((doc) => _improvementPostFromData(doc.id, doc.data()))
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
      startedDateKey: _readString(data, 'startedDateKey') ?? openedDateKey,
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
      reason: _readString(data, 'reason'),
      resultRevealedAt: _readDateTime(data, 'resultRevealedAt'),
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
      category: _readString(data, 'category') ?? '취향',
      inputHint: _readString(data, 'inputHint') ?? '편한 만큼 적어두기',
      value: _readString(data, 'value'),
      locked: data['locked'] == true,
      unlockHint: _readString(data, 'unlockHint'),
      skipped: data['skipped'] == true,
      hidden: data['hidden'] == true,
      custom: data['custom'] == true,
      updatedAt: _readDateTime(data, 'updatedAt'),
      updatedByProfileId: _readString(data, 'updatedByProfileId'),
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
      updatedAt: _readDateTime(data, 'updatedAt'),
      updatedByProfileId: _readString(data, 'updatedByProfileId'),
    );
  }

  MusicNote? _musicNoteFromData(String fallbackId, Map<String, dynamic> data) {
    final title = _readString(data, 'title');
    final artist = _readString(data, 'artist');
    if (title == null || artist == null) {
      return null;
    }
    final createdByProfileId = _readString(data, 'createdByProfileId') ?? '';
    final listenedByProfileIds = _readStringList(
      data,
      'listenedByProfileIds',
    ).toSet();
    if (!data.containsKey('listenedByProfileIds') &&
        createdByProfileId.isNotEmpty) {
      listenedByProfileIds.add(createdByProfileId);
    }
    return MusicNote(
      id: _readString(data, 'id') ?? fallbackId,
      title: title,
      artist: artist,
      link: _readString(data, 'link') ?? '',
      note: _readString(data, 'note') ?? '',
      mood: _readString(data, 'mood') ?? musicMoodOptions.first,
      createdByProfileId: createdByProfileId,
      createdLabel: _readString(data, 'createdLabel') ?? '오늘',
      listenedByProfileIds: listenedByProfileIds,
      updatedAt: _readDateTime(data, 'updatedAt'),
    );
  }

  ScheduleEntry? _scheduleEntryFromData(
    String fallbackId,
    Map<String, dynamic> data,
  ) {
    final dateKey = _readString(data, 'dateKey');
    final profileId = _readString(data, 'profileId');
    if (dateKey == null || profileId == null) {
      return null;
    }
    final timeSlots = _readStringList(
      data,
      'timeSlots',
    ).map(_timeSlotFromData).nonNulls.toSet();
    return ScheduleEntry(
      dateKey: dateKey,
      profileId: profileId,
      availability: _availabilityFromData(_readString(data, 'availability')),
      timeSlots: timeSlots,
      timeBlocks: _readMapList(
        data,
        'timeBlocks',
      ).map(_timeBlockFromData).nonNulls.toList(),
      sharedMemo: _readString(data, 'sharedMemo') ?? '',
      isMeetingDay: _readBool(data, 'isMeetingDay') ?? false,
      meetingTimeLabel: _readString(data, 'meetingTimeLabel') ?? '',
      meetingNote: _readString(data, 'meetingNote') ?? '',
      meetingPlanItems: _readStringList(data, 'meetingPlanItems'),
      updatedAt: _readDateTime(data, 'updatedAt'),
    );
  }

  SharedPlace? _sharedPlaceFromData(
    String fallbackId,
    Map<String, dynamic> data,
  ) {
    final name = _readString(data, 'name');
    if (name == null) {
      return null;
    }
    return SharedPlace(
      id: _readString(data, 'id') ?? fallbackId,
      name: name,
      address: _readString(data, 'address') ?? '',
      category: _placeCategoryFromData(_readString(data, 'category')),
      provider: _mapApiProviderFromData(_readString(data, 'provider')),
      providerPlaceId: _readString(data, 'providerPlaceId') ?? '',
      latitude: _readDouble(data, 'latitude'),
      longitude: _readDouble(data, 'longitude'),
      note: _readString(data, 'note') ?? '',
      createdByProfileId: _readString(data, 'createdByProfileId') ?? '',
      interestedByProfileIds: _readStringList(
        data,
        'interestedByProfileIds',
      ).toSet(),
      linkedDateKey: _readString(data, 'linkedDateKey'),
      updatedAt: _readDateTime(data, 'updatedAt'),
      updatedByProfileId: _readString(data, 'updatedByProfileId'),
    );
  }

  CuriosityCard? _curiosityCardFromData(
    String fallbackId,
    Map<String, dynamic> data,
  ) {
    final fromProfileId = _readString(data, 'fromProfileId');
    final toProfileId = _readString(data, 'toProfileId');
    final question = _readString(data, 'question');
    if (fromProfileId == null || toProfileId == null || question == null) {
      return null;
    }
    return CuriosityCard(
      id: _readString(data, 'id') ?? fallbackId,
      fromProfileId: fromProfileId,
      toProfileId: toProfileId,
      question: question,
      createdLabel: _readString(data, 'createdLabel') ?? '오늘',
      reply: _readString(data, 'reply'),
      repliedLabel: _readString(data, 'repliedLabel'),
      updatedAt: _readDateTime(data, 'updatedAt'),
      updatedByProfileId: _readString(data, 'updatedByProfileId'),
    );
  }

  StockStory? _stockStoryFromData(
    String fallbackId,
    Map<String, dynamic> data,
  ) {
    final name = _readString(data, 'name');
    final reason = _readString(data, 'reason');
    final upside = _readString(data, 'upside');
    final risk = _readString(data, 'risk');
    final question = _readString(data, 'question');
    final createdByProfileId = _readString(data, 'createdByProfileId');
    if (name == null ||
        reason == null ||
        upside == null ||
        risk == null ||
        question == null ||
        createdByProfileId == null) {
      return null;
    }
    return StockStory(
      id: _readString(data, 'id') ?? fallbackId,
      name: name,
      reason: reason,
      upside: upside,
      risk: risk,
      question: question,
      createdByProfileId: createdByProfileId,
      createdLabel: _readString(data, 'createdLabel') ?? '오늘',
      replyTone: _readString(data, 'replyTone'),
      reply: _readString(data, 'reply'),
      repliedByProfileId: _readString(data, 'repliedByProfileId'),
      repliedLabel: _readString(data, 'repliedLabel'),
      updatedAt: _readDateTime(data, 'updatedAt'),
      updatedByProfileId: _readString(data, 'updatedByProfileId'),
    );
  }

  StockHolding? _stockHoldingFromData(
    String fallbackId,
    Map<String, dynamic> data,
  ) {
    final name = _readString(data, 'name');
    final status = _readString(data, 'status');
    final weightLabel = _readString(data, 'weightLabel');
    final reason = _readString(data, 'reason');
    final watchPoint = _readString(data, 'watchPoint');
    final concern = _readString(data, 'concern');
    final question = _readString(data, 'question');
    final createdByProfileId = _readString(data, 'createdByProfileId');
    if (name == null ||
        status == null ||
        weightLabel == null ||
        reason == null ||
        watchPoint == null ||
        concern == null ||
        question == null ||
        createdByProfileId == null) {
      return null;
    }
    return StockHolding(
      id: _readString(data, 'id') ?? fallbackId,
      name: name,
      status: status,
      weightLabel: weightLabel,
      reason: reason,
      watchPoint: watchPoint,
      concern: concern,
      question: question,
      createdByProfileId: createdByProfileId,
      createdLabel: _readString(data, 'createdLabel') ?? '오늘',
      replyTone: _readString(data, 'replyTone'),
      reply: _readString(data, 'reply'),
      repliedByProfileId: _readString(data, 'repliedByProfileId'),
      repliedLabel: _readString(data, 'repliedLabel'),
      updatedAt: _readDateTime(data, 'updatedAt'),
      updatedByProfileId: _readString(data, 'updatedByProfileId'),
    );
  }

  ImprovementPost? _improvementPostFromData(
    String fallbackId,
    Map<String, dynamic> data,
  ) {
    final title = _readString(data, 'title');
    final body = _readString(data, 'body');
    final category = _readString(data, 'category');
    final createdByProfileId = _readString(data, 'createdByProfileId');
    if (title == null ||
        body == null ||
        category == null ||
        createdByProfileId == null) {
      return null;
    }
    return ImprovementPost(
      id: _readString(data, 'id') ?? fallbackId,
      title: title,
      body: body,
      category: category,
      createdByProfileId: createdByProfileId,
      createdLabel: _readString(data, 'createdLabel') ?? '오늘',
      updatedAt: _readDateTime(data, 'updatedAt'),
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

  String _availabilityToData(MeetingAvailability availability) {
    return switch (availability) {
      MeetingAvailability.available => 'available',
      MeetingAvailability.maybe => 'maybe',
      MeetingAvailability.busy => 'busy',
    };
  }

  MeetingAvailability _availabilityFromData(String? value) {
    return switch (value) {
      'available' => MeetingAvailability.available,
      'maybe' => MeetingAvailability.maybe,
      'busy' => MeetingAvailability.busy,
      _ => MeetingAvailability.busy,
    };
  }

  String _timeSlotToData(MeetingTimeSlot slot) {
    return switch (slot) {
      MeetingTimeSlot.morning => 'morning',
      MeetingTimeSlot.afternoon => 'afternoon',
      MeetingTimeSlot.evening => 'evening',
    };
  }

  MeetingTimeSlot? _timeSlotFromData(String value) {
    return switch (value) {
      'morning' => MeetingTimeSlot.morning,
      'afternoon' => MeetingTimeSlot.afternoon,
      'evening' => MeetingTimeSlot.evening,
      _ => null,
    };
  }

  Map<String, Object?> _timeBlockToData(ScheduleTimeBlock block) {
    return {
      'startMinute': block.startMinute,
      'endMinute': block.endMinute,
      'title': block.title,
    };
  }

  ScheduleTimeBlock? _timeBlockFromData(Map<String, dynamic> data) {
    final startMinute = _readInt(data, 'startMinute');
    final endMinute = _readInt(data, 'endMinute');
    final title = _readString(data, 'title');
    if (startMinute == null ||
        endMinute == null ||
        title == null ||
        endMinute <= startMinute) {
      return null;
    }
    return ScheduleTimeBlock(
      startMinute: startMinute,
      endMinute: endMinute,
      title: title,
    );
  }

  String _mapApiProviderToData(MapApiProvider provider) {
    return switch (provider) {
      MapApiProvider.kakao => 'kakao',
    };
  }

  MapApiProvider _mapApiProviderFromData(String? value) {
    return switch (value) {
      'kakao' => MapApiProvider.kakao,
      _ => MapApiProvider.kakao,
    };
  }

  String _placeCategoryToData(PlaceCategory category) {
    return switch (category) {
      PlaceCategory.cafe => 'cafe',
      PlaceCategory.food => 'food',
      PlaceCategory.exhibition => 'exhibition',
      PlaceCategory.walk => 'walk',
      PlaceCategory.activity => 'activity',
    };
  }

  PlaceCategory _placeCategoryFromData(String? value) {
    return switch (value) {
      'cafe' => PlaceCategory.cafe,
      'food' => PlaceCategory.food,
      'exhibition' => PlaceCategory.exhibition,
      'walk' => PlaceCategory.walk,
      'activity' => PlaceCategory.activity,
      _ => PlaceCategory.activity,
    };
  }

  List<String> _readStringList(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is Iterable) {
      return value
          .whereType<String>()
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }
    return const [];
  }

  List<Map<String, dynamic>> _readMapList(
    Map<String, dynamic> data,
    String key,
  ) {
    final value = data[key];
    if (value is Iterable) {
      return value
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    return const [];
  }

  double? _readDouble(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  int? _readInt(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is int) {
      return value;
    }
    if (value is double && value.roundToDouble() == value) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  bool? _readBool(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is bool) {
      return value;
    }
    return null;
  }

  String? _readString(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    return null;
  }

  DateTime? _readDateTime(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}
