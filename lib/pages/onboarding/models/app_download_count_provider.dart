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
  String _deviceIdentifier = "";

  Future<void> initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _isDownloadCountIncremented =
        _prefs.getBool('isDownloadCountIncremented') ?? false;
    _deviceIdentifier = _prefs.getString('deviceIdentifier') ??
        await _generateDeviceIdentifier();

    if (!_isDownloadCountIncremented) {
      _isDownloadCountIncremented = true;
      await _prefs.setBool('isDownloadCountIncremented', true);
      await _prefs.setString('deviceIdentifier', _deviceIdentifier);

      final docRef = FirebaseFirestore.instance
          .collection('app_stats')
          .doc('vzIEu1gIvltuyDUkhAJO');

      final snapshot = await docRef.get();

      if (!snapshot.exists) {
        // If the document does not exist, create it with download_count = 1 and devices = [_deviceIdentifier].
        await docRef.set({
          'download_count': 1,
          'devices': [_deviceIdentifier]
        });
        _downloadCount = 1;
      } else {
        // If the document exists, check if the 'devices' field exists.
        if (snapshot.data()!.containsKey('devices')) {
          // If the 'devices' field exists, check if the device identifier is already in the 'devices' list.
          List<dynamic> devices = snapshot.get('devices');
          if (devices.contains(_deviceIdentifier)) {
            // The device has already been counted, so don't increment the download count.
            _downloadCount = snapshot.get('download_count');
          } else {
            // The device is unique, so increment the download count and add the device to the list.
            _downloadCount = snapshot.get('download_count') + 1;
            devices.add(_deviceIdentifier);
            await docRef
                .update({'download_count': _downloadCount, 'devices': devices});
          }
        } else {
          // If the 'devices' field does not exist, create it with download_count = 1 and devices = [_deviceIdentifier].
          await docRef.set({
            'download_count': 1,
            'devices': [_deviceIdentifier]
          });
          _downloadCount = 1;
        }
      }
      notifyListeners();
    }
  }

  Future<void> incrementDownloadCount() async {
    final docRef = FirebaseFirestore.instance
        .collection('app_stats')
        .doc(_deviceIdentifier);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
          transaction.set(docRef, {'download_count': 1});
          _downloadCount = 1;
        } else {
          _downloadCount = snapshot.get('download_count') + 1;
          transaction.update(docRef, {'download_count': _downloadCount});
        }
      });

      notifyListeners();
    } catch (e) {
      print('Error incrementing download count: $e');
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
            identifier = 'android-${androidInfo.brand}-${androidInfo.model}';
          } else {
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
}
