import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DownloadCountModel extends ChangeNotifier {
  late SharedPreferences _prefs;
  bool _isDownloadCountIncremented = false;
  int _downloadCount = 0;
  bool get isDownloadCountIncremented => _isDownloadCountIncremented;
  int get downloadCount => _downloadCount;
  String _deviceIdentifier = ""; // Store the device identifier here.

  Future<void> initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _isDownloadCountIncremented =
        _prefs.getBool('isDownloadCountIncremented') ?? false;
    _deviceIdentifier = _prefs.getString('deviceIdentifier') ??
        await _generateDeviceIdentifier();

    if (!_isDownloadCountIncremented) {
      final docRef = FirebaseFirestore.instance
          .collection('app_stats')
          .doc(_deviceIdentifier);

      // Get the snapshot of the document with ID vzIEu1gIvltuyDUkhAJO
      final existingDocRef = FirebaseFirestore.instance
          .collection('app_stats')
          .doc('vzIEu1gIvltuyDUkhAJO');

      final snapshot = await docRef.get();
      final existingSnapshot = await existingDocRef.get();

      if (!snapshot.exists) {
        await incrementDownloadCount(); // Make sure to await the incrementDownloadCount method call.
        _isDownloadCountIncremented = true;
        await _prefs.setBool('isDownloadCountIncremented', true);
        await _prefs.setString('deviceIdentifier', _deviceIdentifier);
      } else {
        // The document with the device identifier exists; fetch and update the local count.
        _downloadCount = snapshot.get('download_count');
        notifyListeners(); // Notify listeners about the state change.
      }

      if (existingSnapshot.exists) {
        // Perform the update only if a new document was inserted
        await existingDocRef.update({
          'download_count': _downloadCount,
        });
      }
    }
  }

  Future<String> _generateDeviceIdentifier() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String identifier = "";

    try {
      if (kIsWeb) {
        identifier = 'web-${DateTime.now().millisecondsSinceEpoch}';
      } else {
        if (defaultTargetPlatform == TargetPlatform.android) {
          AndroidDeviceInfo? androidInfo = await deviceInfo.androidInfo;
          if (androidInfo != null) {
            // Generate the identifier using available properties.
            identifier = 'android-${androidInfo.brand}-${androidInfo.model}';
          } else {
            // Fallback: Use a combination of timestamp and UniqueKey.
            identifier =
                'android-fallback-${DateTime.now().millisecondsSinceEpoch}-${UniqueKey().toString()}';
          }
        } else if (defaultTargetPlatform == TargetPlatform.iOS) {
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          identifier = 'ios-${iosInfo.identifierForVendor}';
        } else {
          identifier =
              'other-${DateTime.now().millisecondsSinceEpoch}-${UniqueKey().toString()}';
        }
      }
    } catch (e) {
      print('Error generating device identifier: $e');
      identifier =
          '${DateTime.now().millisecondsSinceEpoch}-${UniqueKey().toString()}';
    }

    return identifier;
  }

  Future<void> incrementDownloadCount() async {
    final docRef = FirebaseFirestore.instance
        .collection('app_stats')
        .doc(_deviceIdentifier);

    try {
      final snapshot = await docRef.get();

      if (!snapshot.exists) {
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          transaction.set(docRef, {'download_count': 1});
        });
        _downloadCount = 1;
      }

      notifyListeners();
    } catch (e) {
      print('Error incrementing download count: $e');
    }
  }
}
