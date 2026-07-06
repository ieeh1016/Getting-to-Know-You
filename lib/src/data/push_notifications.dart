import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../domain/alagagi_controller.dart';

class FirebasePushNotificationService
    implements AlagagiPushNotificationService {
  FirebasePushNotificationService({
    FirebaseFirestore? firestore,
    FirebaseMessaging? messaging,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _messaging = messaging ?? FirebaseMessaging.instance;

  final FirebaseFirestore _firestore;
  final FirebaseMessaging _messaging;

  @override
  bool get isSupported {
    if (kIsWeb) {
      return false;
    }
    return switch (defaultTargetPlatform) {
      TargetPlatform.android || TargetPlatform.iOS => true,
      _ => false,
    };
  }

  @override
  Future<PushNotificationSetupState> loadState({
    required AlagagiAuthUser user,
  }) async {
    if (!isSupported) {
      return const PushNotificationSetupState.unsupported();
    }
    try {
      final settingsSnapshot = await _settingsReference(user.uid).get();
      final permissionStatus = await _currentPermissionStatus();
      final enabled = settingsSnapshot.data()?['enabled'] == true;
      return PushNotificationSetupState(
        supported: true,
        enabled: enabled && permissionStatus.allowsNotifications,
        permissionStatus: permissionStatus,
        tokenRegistered: enabled,
      );
    } catch (_) {
      return const PushNotificationSetupState(
        supported: true,
        enabled: false,
        permissionStatus: PushNotificationPermissionStatus.notDetermined,
        message: '푸시 알림 상태를 확인하지 못했어요.',
      );
    }
  }

  @override
  Future<PushNotificationSetupState> enable({
    required AlagagiAuthUser user,
    required AlagagiSession session,
  }) async {
    if (!isSupported) {
      return const PushNotificationSetupState.unsupported();
    }
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      final permissionStatus = _permissionStatusFromSettings(settings);
      if (!permissionStatus.allowsNotifications) {
        await _savePushSetting(user.uid, session.spaceId, enabled: false);
        return PushNotificationSetupState(
          supported: true,
          enabled: false,
          permissionStatus: permissionStatus,
          message: '휴대폰 설정에서 알림 권한을 켜면 다시 받을 수 있어요.',
        );
      }

      final token = await _readRegistrationToken();
      if (token == null) {
        await _savePushSetting(user.uid, session.spaceId, enabled: false);
        return PushNotificationSetupState(
          supported: true,
          enabled: false,
          permissionStatus: permissionStatus,
          message: '알림 토큰을 아직 받지 못했어요. 잠시 후 다시 켜 주세요.',
        );
      }

      await _savePushSetting(user.uid, session.spaceId, enabled: true);
      await _saveToken(
        userId: user.uid,
        spaceId: session.spaceId,
        token: token,
        enabled: true,
      );
      return PushNotificationSetupState(
        supported: true,
        enabled: true,
        permissionStatus: permissionStatus,
        tokenRegistered: true,
        message: '새 기억이 생기면 휴대폰으로 알려드릴게요.',
      );
    } catch (_) {
      return const PushNotificationSetupState(
        supported: true,
        enabled: false,
        permissionStatus: PushNotificationPermissionStatus.notDetermined,
        message: '푸시 알림을 켜지 못했어요. Firebase 설정을 확인해 주세요.',
      );
    }
  }

  @override
  Future<PushNotificationSetupState> disable({
    required AlagagiAuthUser user,
    required AlagagiSession session,
  }) async {
    if (!isSupported) {
      return const PushNotificationSetupState.unsupported();
    }
    try {
      final permissionStatus = await _currentPermissionStatus();
      final settingsSnapshot = await _settingsReference(user.uid).get();
      final spaceId =
          _readString(settingsSnapshot.data(), 'spaceId') ?? session.spaceId;
      await _savePushSetting(user.uid, spaceId, enabled: false);
      final token = await _messaging.getToken();
      if (token != null) {
        await _saveToken(
          userId: user.uid,
          spaceId: spaceId,
          token: token,
          enabled: false,
        );
      }
      return PushNotificationSetupState(
        supported: true,
        enabled: false,
        permissionStatus: permissionStatus,
        message: '푸시 알림을 꺼두었어요.',
      );
    } catch (_) {
      return const PushNotificationSetupState(
        supported: true,
        enabled: false,
        permissionStatus: PushNotificationPermissionStatus.notDetermined,
        message: '푸시 알림을 끄지 못했어요. 잠시 후 다시 시도해 주세요.',
      );
    }
  }

  @override
  Future<void> registerTokenForSession({
    required AlagagiAuthUser user,
    required AlagagiSession session,
    String? token,
  }) async {
    if (!isSupported) {
      return;
    }
    final settingsSnapshot = await _settingsReference(user.uid).get();
    if (settingsSnapshot.data()?['enabled'] != true) {
      return;
    }
    final permissionStatus = await _currentPermissionStatus();
    if (!permissionStatus.allowsNotifications) {
      return;
    }
    final registrationToken = token ?? await _readRegistrationToken();
    if (registrationToken == null) {
      return;
    }
    await _savePushSetting(user.uid, session.spaceId, enabled: true);
    await _saveToken(
      userId: user.uid,
      spaceId: session.spaceId,
      token: registrationToken,
      enabled: true,
    );
  }

  @override
  Future<PushNotificationIntent?> initialIntent() async {
    if (!isSupported) {
      return null;
    }
    final message = await _messaging.getInitialMessage();
    return _intentFromMessage(message);
  }

  @override
  Stream<PushNotificationIntent> openedIntents() {
    if (!isSupported) {
      return const Stream<PushNotificationIntent>.empty();
    }
    return FirebaseMessaging.onMessageOpenedApp
        .map(_intentFromMessage)
        .where((intent) => intent != null)
        .cast<PushNotificationIntent>();
  }

  @override
  Stream<PushNotificationIntent> foregroundIntents() {
    if (!isSupported) {
      return const Stream<PushNotificationIntent>.empty();
    }
    return FirebaseMessaging.onMessage
        .map(_intentFromMessage)
        .where((intent) => intent != null)
        .cast<PushNotificationIntent>();
  }

  @override
  Stream<String> tokenRefreshes() {
    if (!isSupported) {
      return const Stream<String>.empty();
    }
    return _messaging.onTokenRefresh;
  }

  DocumentReference<Map<String, dynamic>> _settingsReference(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notificationSettings')
        .doc('push');
  }

  DocumentReference<Map<String, dynamic>> _tokenReference(
    String userId,
    String token,
  ) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notificationTokens')
        .doc(_tokenDocumentId(token));
  }

  Future<void> _savePushSetting(
    String userId,
    String spaceId, {
    required bool enabled,
  }) {
    return _settingsReference(userId).set({
      'enabled': enabled,
      'spaceId': spaceId,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> _saveToken({
    required String userId,
    required String spaceId,
    required String token,
    required bool enabled,
  }) {
    return _tokenReference(userId, token).set({
      'token': token,
      'platform': _platformKey,
      'spaceId': spaceId,
      'enabled': enabled,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<PushNotificationPermissionStatus> _currentPermissionStatus() async {
    final settings = await _messaging.getNotificationSettings();
    return _permissionStatusFromSettings(settings);
  }

  Future<String?> _readRegistrationToken() async {
    if (_requiresApnsToken) {
      for (var attempt = 0; attempt < 5; attempt += 1) {
        final apnsToken = await _messaging.getAPNSToken();
        if (apnsToken != null) {
          break;
        }
        await Future<void>.delayed(const Duration(milliseconds: 250));
      }
      if (await _messaging.getAPNSToken() == null) {
        return null;
      }
    }
    return _messaging.getToken();
  }

  bool get _requiresApnsToken {
    return defaultTargetPlatform == TargetPlatform.iOS;
  }

  String get _platformKey {
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => 'android',
      TargetPlatform.iOS => 'ios',
      _ => 'unknown',
    };
  }

  PushNotificationPermissionStatus _permissionStatusFromSettings(
    NotificationSettings settings,
  ) {
    return switch (settings.authorizationStatus) {
      AuthorizationStatus.authorized =>
        PushNotificationPermissionStatus.authorized,
      AuthorizationStatus.provisional =>
        PushNotificationPermissionStatus.provisional,
      AuthorizationStatus.denied => PushNotificationPermissionStatus.denied,
      AuthorizationStatus.notDetermined =>
        PushNotificationPermissionStatus.notDetermined,
    };
  }

  PushNotificationIntent? _intentFromMessage(RemoteMessage? message) {
    if (message == null) {
      return null;
    }
    final route = _routeFromData(message.data['route']);
    if (route == null) {
      return null;
    }
    return PushNotificationIntent(
      route: route,
      feature: message.data['feature'] ?? '',
      targetId: message.data['targetId'] ?? '',
      title: message.notification?.title ?? message.data['title'] ?? '',
      body: message.notification?.body ?? message.data['body'] ?? '',
    );
  }

  AlagagiRoute? _routeFromData(String? route) {
    return switch (route) {
      'memoryCards' => AlagagiRoute.memoryCards,
      _ => null,
    };
  }

  String _tokenDocumentId(String token) {
    return base64Url.encode(utf8.encode(token)).replaceAll('=', '');
  }

  String? _readString(Map<String, dynamic>? data, String key) {
    final value = data?[key];
    return value is String ? value : null;
  }
}

extension on PushNotificationPermissionStatus {
  bool get allowsNotifications {
    return this == PushNotificationPermissionStatus.authorized ||
        this == PushNotificationPermissionStatus.provisional;
  }
}
