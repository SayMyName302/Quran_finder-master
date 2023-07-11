import 'package:flutter/material.dart';
import 'package:nour_al_quran/pages/settings/pages/about_the_app/model/about_model.dart';

import '../../../../../shared/database/home_db.dart';

class AboutProvider extends ChangeNotifier {
  List<AboutModel> _appInfo = [];
  List<AboutModel> get appInfo => _appInfo;

  Future<void> getInfo() async {
    _appInfo = await HomeDb().getAppInfo();
    notifyListeners();
  }
}
