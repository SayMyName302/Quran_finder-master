import 'package:flutter/material.dart';
import '../../../../shared/database/quran_db.dart';

import 'models/dua.dart';
import 'models/dua_category.dart';

class DuaProvider extends ChangeNotifier {
  List<DuaCategory> _duaCategoryList = [];
  List<DuaCategory> get duaCategoryList => _duaCategoryList;
  List<Dua> _duaList = [];
  List<Dua> get duaList => _duaList;

  Future<void> getDuaCategories() async {
    _duaCategoryList = await QuranDatabase().getDuaCategories();
    notifyListeners();
  }

  Future<void> getDua(int duaCategoryId) async {
    _duaList = await QuranDatabase().getDua(duaCategoryId);
    notifyListeners();
  }
}
