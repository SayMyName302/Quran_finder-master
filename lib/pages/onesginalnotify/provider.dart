import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalProvider extends ChangeNotifier {
  final String _onesignalAppId = "cdb0213c-900e-49fc-83b8-b5771db4a960";

  void initializeOneSignal() {
    OneSignal.shared.setAppId(_onesignalAppId);
    OneSignal.shared.setNotificationOpenedHandler((openedResult) {
      // Handle notification opening logic
    });
  }
}
