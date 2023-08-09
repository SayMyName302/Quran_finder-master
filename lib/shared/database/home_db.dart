import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nour_al_quran/pages/featured/models/featured.dart';
import 'package:nour_al_quran/pages/featured/models/miracles.dart';
import 'package:nour_al_quran/pages/popular_section/models/PopularModel';
import 'package:nour_al_quran/pages/recitation_category/models/RecitationCategory.dart';
import 'package:nour_al_quran/pages/recitation_category/models/recitation_all_category_model.dart';
import 'package:nour_al_quran/pages/settings/pages/about_the_app/model/about_model.dart';
import 'package:nour_al_quran/pages/tranquil_tales/models/TranquilCategory.dart';
import 'package:nour_al_quran/pages/tranquil_tales/models/TranquilModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../pages/basics_of_quran/models/islam_basics.dart';
import '../../pages/miracles_of_quran/models/miracles.dart';
import '../../pages/quran stories/models/quran_stories.dart';

class HomeDb {
  Database? _database;
  final String _appInfo = "app_info";
  //tables
  final String _miraclesOfQuranTb = "miracles_of_quran";
  final String _storiesInQuran = "stories_in_quran";
  final String _islamBasicsTb = "islam_basics";
  final String _featured = "featured_all";
  // final String _appinfo = "app_info";
  // final String _recitationCategoryTb = "recitation_category";
  // final String _recitationAllTb = "recitation_all";
  final String _popular = "popular_recitation";
  final String _tranquil = "tranquil_tales";
  final String _tranquilCategory = "tranquil_tales_category";
  final String _recitationPlaylists = "recitation_playlists";
  final String _recitationPlaylistitems = "recitation_playlist_items";
  initDb() async {
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, 'masterdb.db');

    // Check if the database file already exists in the documents directory
    var exists = await databaseExists(path);

    if (!exists) {
      print('Database file does not exist in documents directory');
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      // Copy the database file from the assets folder
      ByteData data = await rootBundle.load(join('assets', 'masterdb.db'));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // Write and flush the bytes to the documents directory
      await File(path).writeAsBytes(bytes, flush: true);
      print('Database file copied to documents directory');
    } else {
      print('Database file already exists in documents directory');

      // Check for differences between the existing and assets database files
      ByteData assetsData =
      await rootBundle.load(join('assets', 'masterdb.db'));
      List<int> assetsBytes = assetsData.buffer
          .asUint8List(assetsData.offsetInBytes, assetsData.lengthInBytes);

      List<int> existingBytes = await File(path).readAsBytes();

      if (!listEquals(assetsBytes, existingBytes)) {
        // Delete the existing database file
        await File(path).delete();

        // Copy the updated database file from the assets folder
        ByteData newData = await rootBundle.load(join('assets', 'masterdb.db'));
        List<int> newBytes = newData.buffer
            .asUint8List(newData.offsetInBytes, newData.lengthInBytes);

        // Write and flush the new bytes to the documents directory
        await File(path).writeAsBytes(newBytes, flush: true);
        print('Updated database file copied to documents directory');
      } else {
        print(
            'Database file in assets is the same as the one in documents directory');
      }
    }
  }

  Future<Database> openDb() async {
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, 'masterdb.db');
    return await openDatabase(path, readOnly: false);
  }

  Future<List<RecitationAllCategoryModel>> getSelectedAll(
      int playlistId) async {
    _database = await openDb();
    List<RecitationAllCategoryModel> selectedRecitationAll = [];
    var cursor = await _database!.query(_recitationPlaylistitems,
        where: "playlist_id = ? AND status = 'active'",
        whereArgs: [playlistId],
        orderBy: 'order_by');
    for (var map in cursor) {
      selectedRecitationAll.add(RecitationAllCategoryModel.fromJson(map));
    }
    return selectedRecitationAll;
  }

  Future<List<TranquilTalesModel>> getSelectedAllTranquil(
      int categoryId) async {
    _database = await openDb();
    List<TranquilTalesModel> selectedRecitationAll = [];
    var cursor = await _database!.query(_tranquil,
        where: "category_id = ? AND status = 'active'",
        whereArgs: [categoryId]);
    for (var map in cursor) {
      selectedRecitationAll.add(TranquilTalesModel.fromJson(map));
    }
    return selectedRecitationAll;
  }

  Future<List<AboutModel>> getAppInfo() async {
    List<AboutModel> appinfo = [];
    _database = await openDb();
    var table = await _database!.query(_appInfo);
    for (var map in table) {
      appinfo.add(AboutModel.fromJson(map));
    }
    return appinfo;
  }

  Future<List<QuranStories>> getQuranStories() async {
    List<QuranStories> stories = [];
    _database = await openDb();
    var table = await _database!.query(
      _storiesInQuran,
      orderBy: 'view_order_by', // Add the 'ORDER BY' clause here
    );
    for (var map in table) {
      stories.add(QuranStories.fromJson(map));
    }
    return stories;
  }

  Future<List<FeaturedModel>> getFeatured() async {
    List<FeaturedModel> feature = [];
    _database = await openDb();
    var table = await _database!.query(_featured, orderBy: 'view_order_by');

    for (var map in table) {
      feature.add(FeaturedModel.fromJson(map));
      // print("Row Data:");
      // print("view_order_by: ${map['view_order_by']}");
      // print("day: ${map['day']}");
    }
    return feature;
  }

// Method to filter the list based on islamic_date
  List<FeaturedModel> filterFeaturesByIslamicDate(
      List<FeaturedModel> featureList, String targetDate, String targetMonth) {
    List<FeaturedModel> filteredList = [];

    for (var feature in featureList) {
      // Assuming 'hijriDate' and 'hijriMonth' are properties in your FeaturedModel class
      if (feature.islamicDate == targetDate &&
          feature.monthDisplay == targetMonth) {
        filteredList.add(feature);
      }
    }
    print("FILTERED LIST: ${filteredList}");

    return filteredList;
  }

  Future<List<FeaturedModel>> getTranquil() async {
    List<FeaturedModel> feature = [];
    _database = await openDb();
    var table = await _database!.query(_featured, orderBy: 'view_order_by');
    for (var map in table) {
      feature.add(FeaturedModel.fromJson(map));
    }
    return feature;
  }

  Future<List<PopularModelClass>> getPopular() async {
    List<PopularModelClass> feature = [];
    _database = await openDb();
    var table = await _database!.query(_popular, orderBy: 'order_by');
    // print(
    //     "Table Length: ${table.length}"); // Print the number of rows retrieved from the table
    for (var map in table) {
      feature.add(PopularModelClass.fromJson(map));
    }
    // print(
    //     "Feature Length: ${feature.length}"); // Print the number of FeaturedModel objects added to the list
    return feature;
  }

  Future<List<RecitationCategoryModel>> getRecitationCategory() async {
    List<RecitationCategoryModel> recitationCategory = [];
    _database = await openDb();
    var table = await _database!.query(_recitationPlaylists);
    print(
        "Table Length of recitation playlist: ${table.length}"); // Print the number of rows retrieved from the table
    for (var map in table) {
      recitationCategory.add(RecitationCategoryModel.fromJson(map));
    }
    print(
        "Recitation playlist Length: ${recitationCategory.length}"); // Print the number of FeaturedModel objects added to the list
    return recitationCategory;
  }

  Future<List<RecitationCategoryModel>> getRecitationBasedOnTime() async {
    List<RecitationCategoryModel> recitationCategory = [];
    _database = await openDb();

    DateTime now = DateTime.now();
    String currentTimePeriod = 'morning';

    // Determine the current time period based on the time of day
    if (now.hour >= 5 && now.hour < 12) {
      currentTimePeriod = 'morning';
    } else if (now.hour >= 12 && now.hour < 18) {
      currentTimePeriod = 'afternoon';
    } else if (now.hour >= 18 && now.hour < 22) {
      currentTimePeriod = 'evening';
    } else {
      currentTimePeriod = 'night';
    }

    var table = await _database!.query(_recitationPlaylists,
        where: 'play_period = ?', whereArgs: [currentTimePeriod]);

    // Print the number of rows retrieved from the table

    for (var map in table) {
      recitationCategory.add(RecitationCategoryModel.fromJson(map));
    }

    print("Recitation playlist Length: ${recitationCategory.length}"); // Print the number of FeaturedModel objects added to the list

    return recitationCategory;
  }

  Future<List<TranquilTalesCategoryModel>> getTranquilCategory() async {
    List<TranquilTalesCategoryModel> recitationCategory = [];
    _database = await openDb();
    var table = await _database!.query(_tranquilCategory);
    print(
        "Table Length of recitation Category: ${table.length}"); // Print the number of rows retrieved from the table
    for (var map in table) {
      recitationCategory.add(TranquilTalesCategoryModel.fromJson(map));
    }
    print(
        "Recitation Category Length: ${recitationCategory.length}"); // Print the number of FeaturedModel objects added to the list
    return recitationCategory;
  }

  Future<List<RecitationAllCategoryModel>> getRecitationAll() async {
    List<RecitationAllCategoryModel> recitationAll = [];
    _database = await openDb();
    var table = await _database!.query(_recitationPlaylistitems);
    print(
        "Table Length of recitation All Category: ${table.length}"); // Print the number of rows retrieved from the table
    for (var map in table) {
      recitationAll.add(RecitationAllCategoryModel.fromJson(map));
    }
    print(
        "Recitation All Length: ${recitationAll.length}"); // Print the number of FeaturedModel objects added to the list
    return recitationAll;
  }

  Future<List<TranquilTalesModel>> getTranquilAll() async {
    List<TranquilTalesModel> recitationAll = [];
    _database = await openDb();
    var table = await _database!.query(_tranquilCategory);
    print(
        "Table Length of recitation All Category: ${table.length}"); // Print the number of rows retrieved from the table
    for (var map in table) {
      recitationAll.add(TranquilTalesModel.fromJson(map));
    }
    print(
        "Recitation All Length: ${recitationAll.length}"); // Print the number of FeaturedModel objects added to the list
    return recitationAll;
  }

  Future<List<Miracles2>> getFeatured2() async {
    List<Miracles2> feature = [];
    _database = await openDb();
    var table = await _database!
        .query(_featured, where: "content_type = ?", whereArgs: ["Video"]);
    // print(
    //     "Table Length: ${table.length}"); // Print the number of rows retrieved from the table
    for (var map in table) {
      feature.add(Miracles2.fromJson(map));
    }
    // print(
    //     "Feature Length: ${feature.length}"); // Print the number of FeaturedModel objects added to the list
    return feature;
  }

  // by waqas
  /// i create this for getting only videos
  Future<List<Miracles>> getFeatured3() async {
    List<Miracles> feature = [];
    _database = await openDb();
    var table = await _database!.query(_featured,
        where: "content_type = ?",
        whereArgs: ["Video"],
        orderBy: 'view_order_by');
    // print("Table Length: ${table.length}");
    for (var map in table) {
      feature.add(Miracles.fromJson(map));
    }
    // print("Feature Length: ${feature.length}");
    return feature;
  }

  // Future<List<Chapters>> getChapters(int id) async {
  //   List<Chapters> chapters = [];
  //   _database = await openDb();
  //   var table = await _database!.rawQuery("SELECT Chapter_id,Chapter_name,text from stories_in_quran WHERE story_id = $id");
  //   for(var map in table){
  //     chapters.add(Chapters.fromJson(map));
  //   }
  //   return chapters;
  // }

  Future<List<Miracles>> getMiracles() async {
    List<Miracles> miracles = [];
    _database = await openDb();
    var table =
    await _database!.query(_miraclesOfQuranTb, orderBy: 'view_order_by');
    for (var map in table) {
      miracles.add(Miracles.fromJson(map));
    }
    return miracles;
  }

  Future<List<IslamBasics>> getIslamBasics() async {
    List<IslamBasics> islamBasics = [];
    _database = await openDb();
    var table =
    await _database!.query(_islamBasicsTb, orderBy: 'view_order_by');
    for (var map in table) {
      islamBasics.add(IslamBasics.fromJson(map));
    }
    return islamBasics;
  }
}