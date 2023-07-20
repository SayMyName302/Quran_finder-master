import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadCountModel extends ChangeNotifier {
  late SharedPreferences _prefs;
  bool _isDownloadCountIncremented = false;
  int _downloadCount = 0;

  bool get isDownloadCountIncremented => _isDownloadCountIncremented;
  int get downloadCount => _downloadCount;

  Future<void> initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _isDownloadCountIncremented =
        _prefs.getBool('isDownloadCountIncremented') ?? false;

    if (!_isDownloadCountIncremented) {
      incrementDownloadCount();
      _isDownloadCountIncremented = true;
      await _prefs.setBool('isDownloadCountIncremented', true);
    }
  }

  Future<void> incrementDownloadCount() async {
    final docRef = FirebaseFirestore.instance
        .collection('app_stats')
        .doc('vzIEu1gIvltuyDUkhAJO');

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
          transaction.set(docRef, {'download_count': 1});
        } else {
          final currentCount = snapshot.get('download_count');
          transaction.update(docRef, {'download_count': currentCount + 1});
        }
      });
      _downloadCount++; // Update the local count.
      notifyListeners(); // Notify listeners about the state change.
    } catch (e) {
      print('Error incrementing download count: $e');
    }
  }
}
