import 'package:onesignal_flutter/onesignal_flutter.dart';

/// A singleton service for managing OneSignal push notifications.
///
/// This class provides methods to initialize OneSignal, log in users, and log them out.
class OneSignalService {
  // The single instance of OneSignalService
  static final OneSignalService _singleton = OneSignalService._internal();

  /// Factory constructor to return the singleton instance of OneSignalService.
  factory OneSignalService() {
    return _singleton;
  }

  // Private constructor for singleton
  OneSignalService._internal();

  /// Initializes OneSignal with the required application ID.
  ///
  /// This method sets up OneSignal for push notifications and requests user permission
  /// to receive notifications.
  Future<void> init() async {
    OneSignal.initialize('b3337413-4dc0-4c0b-8da2-b2238b0b79fc');
    await OneSignal.Notifications.requestPermission(true);
  }

  /// Logs in a user to OneSignal with the provided [userId].
  ///
  /// This method associates the given user ID with the OneSignal account to enable
  /// targeted notifications.
  Future<void> login(String userId) async {
    await OneSignal.login(userId);
  }

  /// Logs out the currently logged-in user from OneSignal.
  ///
  /// This method disassociates the user from their OneSignal account.
  Future<void> logout() async {
    await OneSignal.logout();
  }
}
