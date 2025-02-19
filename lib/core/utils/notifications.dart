import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalService {
  static final OneSignalService _singleton = OneSignalService._internal();

  factory OneSignalService() {
    return _singleton;
  }

  OneSignalService._internal();

  Future<void> init() async {
    OneSignal.initialize('b3337413-4dc0-4c0b-8da2-b2238b0b79fc');

    OneSignal.Notifications.requestPermission(true);
  }

  // login
  Future<void> login(String userId) async {
    OneSignal.login(userId);
  }

  // logout
  Future<void> logout() async {
    OneSignal.logout();
  }


}
