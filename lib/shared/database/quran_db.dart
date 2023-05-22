import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:nour_al_quran/pages/settings/pages/translation_manager/translation_manager_provider.dart';
import 'package:nour_al_quran/shared/entities/bookmarks.dart';
import 'package:nour_al_quran/shared/entities/juz.dart';
import 'package:nour_al_quran/shared/entities/quran_text.dart';
import 'package:nour_al_quran/pages/quran/pages/duas/models/dua.dart';
import 'package:nour_al_quran/pages/quran/pages/duas/models/dua_category.dart';
import 'package:nour_al_quran/shared/entities/reciters.dart';
import 'package:nour_al_quran/shared/entities/surah.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class QuranDatabase{
  Database? database;
  final String _quranTextTable = "quran_text";
  final String _surahNameTable = "surah";
  final String _duaAllTable = "duas_all";
  final String _duaCategoryTable = "dua_category";
  final String _reciterTable = "reciters";

  final String _juzListTable = "juz_list";
  final String _bookmarkNameTable = "BookMarksList";

  // initDb() async {
  //   database = await openDatabase('assets/fullquran.db');
  //   var dbPath = await getDatabasesPath();
  //   var path = join(dbPath, 'fullquran.db');
  //   // Check if Db Exists
  //   var exists = await databaseExists(path);
  //   if(!exists) {
  //     // print('not exist');
  //     try{
  //       await Directory(dirname(path)).create(recursive:true);
  //     }catch(_){}
  //     // copy form assets folder
  //     ByteData data = await rootBundle.load(join('assets','fullquran.db'));
  //     List<int> bytes = data.buffer.asUint8List(data.offsetInBytes,data.lengthInBytes);
  //
  //     // write and flush the bytes
  //     await File(path).writeAsBytes(bytes,flush: true);
  //   }else{
  //     // print('exist');
  //     // Get the current version of the database from the assets folder
  //     ByteData data = await rootBundle.load(join('assets', 'fullquran.db'));
  //     List<int> currentDbBytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  //     // Get the existing version of the database from the device
  //     List<int> existingDbBytes = await File(path).readAsBytes();
  //     // Compare the versions
  //     if (!listEquals(existingDbBytes, currentDbBytes)) {
  //       // print('different');
  //       // Write the current version of the database to the device
  //       await File(path).writeAsBytes(currentDbBytes, flush: true).then((value) {
  //         List bookmarksList = Hive.box('myBox').get('bookmarks') ?? [];
  //         if(bookmarksList.isNotEmpty){
  //           for(int i=0;i<bookmarksList.length;i++){
  //             Bookmarks bookmarks = bookmarksList[i];
  //             addBookmark(bookmarks.surahId!, bookmarks.verseId!);
  //           }
  //         }
  //       });
  //     }
  //   }
  //   // open db
  //   database = await openDatabase(path);
  // }

// Initialize and save the database file in the documents directory
  Future<void> initAndSaveDb() async {
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, 'fullquran.db');
    // Check if the database file already exists in the documents directory
    var exists = await databaseExists(path);
    if (!exists) {
      print('Database file does not exist in documents directory');
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      // Copy the database file from the assets folder
      ByteData data = await rootBundle.load(join('assets', 'fullquran.db'));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // Write and flush the bytes to the documents directory
      await File(path).writeAsBytes(bytes, flush: true).then((value) async{
        List bookmarkList = [
          Bookmarks(surahId: 36, verseId: 1, surahName: "Ya-seen", surahArabic: "يس", juzId: 23, juzName: "", isFromJuz: false, bookmarkPosition: 1),
          Bookmarks(surahId: 18, verseId: 1, surahName: "Al-Kahf", surahArabic: "الكهف", juzId: 15, juzName: "", isFromJuz: false, bookmarkPosition: 1),
        ];
        Hive.box("myBox").put("bookmarks", bookmarkList);
      });
      print('Database file copied to documents directory');
    } else {
      print('Database file already exists in documents directory');
    }
  }

// Open the database
  Future<Database> openDb() async {
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, 'fullquran.db');
    return await openDatabase(path,readOnly: false);
  }

  // to load all quran text
  Future<List<QuranText>> getQuranSurahText({required int surahId}) async {
    database = await openDb();
    var quranTextList = <QuranText> [];
    var table = await database!.query(_quranTextTable,where: "surah_id= ?",whereArgs: [surahId],orderBy: "verse_id");
    for(var rows in table){
      var ayahText = QuranText.fromJson(rows);
      quranTextList.add(ayahText);
    }
    return quranTextList;
  }


  // to load all quran text
  Future<List<QuranText>> getQuranJuzText({required int juzId}) async {
    database = await openDb();
    var quranTextList = <QuranText> [];
    var table = await database!.query(_quranTextTable,where: "juz_id= ?",whereArgs: [juzId],orderBy: "surah_id, verse_id");
    // print(table);
    for(var rows in table){
      var ayahText = QuranText.fromJson(rows);
      quranTextList.add(ayahText);
    }
    return quranTextList;
  }

  // get verse of the day
  Future<QuranText?> getVerseOfTheDay() async{
    var quranTextList = <QuranText> [];
    database = await openDb();
    var randomSurahId = Random().nextInt(114) + 1;
    var table = await database!.query(_quranTextTable,where: "surah_id= ?",whereArgs: [randomSurahId],orderBy: "verse_id");
    for(var rows in table){
      var ayahText = QuranText.fromJson(rows);
      quranTextList.add(ayahText);
    }
    if(quranTextList.isNotEmpty){
      var randomVerse = Random().nextInt(quranTextList.length);
      return quranTextList[randomVerse];
    }else{
      return null;
    }
  }

  Future<QuranText> getVerse(QuranText quranText) async{
    QuranText quranVerse = quranText;
    database = await openDb();
    var table = await database!.rawQuery("select * from $_quranTextTable where surah_id = ${quranText.surahId} and verse_id = ${quranText.verseId}");
    for(var rows in table){
      quranVerse = QuranText.fromJson(rows);
    }
    return quranVerse;
  }

  // to load all surah names
  Future<List<Surah>> getSurahName() async {
    database = await openDb();
    var surahList = <Surah>[];
    var cursor = await database!.query(_surahNameTable);
    for(var maps in cursor){
      var surahNames = Surah.fromJson(maps);
      surahList.add(surahNames);
    }
    return surahList;
  }

  // to load all surah names
  Future<Surah?> getSpecificSurahName(int surahId) async {
    database = await openDb();
    var cursor = await database!.query(_surahNameTable, where:"Id=?", whereArgs: [surahId]);
    for(var maps in cursor){
      return Surah.fromJson(maps);
    }
    return null;
  }

  // to load all duas category names
  Future<List<DuaCategory>> getDuaCategories() async {
    // await initDb();
    database = await openDb();
    var duaCategoryList = <DuaCategory>[];
    var cursor = await database!.query(_duaCategoryTable);
    for(var maps in cursor){
      var duaCategory = DuaCategory.fromJson(maps);
      duaCategoryList.add(duaCategory);
    }
    return duaCategoryList;
  }

  // to load all duas category names
  Future<List<Dua>> getDua(int categoryId) async {
    database = await openDb();
    var duaList = <Dua>[];
    var cursor = await database!.query(_duaAllTable,where: "category_id = ?",whereArgs: [categoryId]);
    for(var maps in cursor){
      var dua = Dua.fromJson(maps);
      duaList.add(dua);
    }
    return duaList;
  }

  // to load all Reciter names
  Future<List<Reciters>> getReciter() async {
    // await initDb();
    database = await openDb();
    var reciterList = <Reciters>[];
    var cursor = await database!.query(_reciterTable);
    for(var maps in cursor){
      var reciter = Reciters.fromJson(maps);
      reciterList.add(reciter);
    }
    return reciterList;
  }

  Future<void> updateReciterIsFav(int reciterId,int value) async {
    database = await openDb();
    await database!.execute("update $_reciterTable set is_fav = $value where reciter_id = $reciterId");
  }

  Future<List<Reciters>> getFavReciters() async {
    database = await openDb();
    List<Reciters> reciters = [];
    var table = await database!.query(_reciterTable,where: "is_fav = ?",whereArgs: [1]);
    for(var map in table){
      reciters.add(Reciters.fromJson(map));
    }
    return reciters;
  }

  Future<void> updateReciterDownloadList(int reciterId, Reciters reciters) async {
    database = await openDb();
    await database!.update(_reciterTable, reciters.toJson(),where: "reciter_id = ?",whereArgs: [reciterId]);
  }

  // for bismillah
  Future<void> updateBissmillahOfEachTranslation(String text,String translationName) async {
    database = await openDb();
    await database!.transaction((txn) async {
      await txn.rawUpdate(
        "update $_quranTextTable set $translationName = ? where verse_id = ?",
        [text, 0],
      );
    });
  }


  // Future<void> updateQuranTranslations(List translations,String translationName,BuildContext context,int index) async {
  //   database = await openDb();
  //   await database!.transaction((txn) async {
  //     Batch batch1 = txn.batch();
  //     for(int k = 0; k < translations.length; k++){
  //       batch1.rawUpdate(
  //           "update $_quranTextTable set $translationName = ? where surah_id = ? and verse_id = ?",
  //           [translations[k][2], int.parse(translations[k][0]), int.parse(translations[k][1])]
  //       );
  //     }
  //     await batch1.commit().then((value) =>print("done1"));
  //     Future.delayed(Duration.zero,()=>context.read<TranslationManagerProvider>().updateState(index, context));
  //   });
  // }


  Future<void> updateQuranTranslations(List translations,String translationName,BuildContext context,int index) async {
    database = await openDb();

    // create indexes on surah_id and verse_id columns
    await database!.execute("CREATE INDEX IF NOT EXISTS surah_id_idx ON $_quranTextTable (surah_id)");
    await database!.execute("CREATE INDEX IF NOT EXISTS verse_id_idx ON $_quranTextTable (verse_id)");

    await database!.transaction((txn) async {
      for(int k = 0;k<translations.length;k++){
        await txn.execute(
          "update $_quranTextTable set $translationName = ? where surah_id = ? and verse_id = ?",
          [translations[k][2], int.parse(translations[k][0]), int.parse(translations[k][1])],
        );
      }
    }).then((value) {
      Future.delayed(Duration.zero,()=>context.read<TranslationManagerProvider>().updateState(index, context));
    });
  }


  
  Future<void> addNew(List translations,String translationName) async {
    database = await openDb();
    await database!.transaction((txn) async {
      for(int k = 0;k<translations.length;k++){
        trans transa = trans(int.parse(translations[k][0]), int.parse(translations[k][1]), translations[k][2]);
        await txn.insert('testing', transa.toJson());
        print(k);
      }
    });
  }

  // to load all Para Name
  Future<List<Juz>> getJuzNames() async {
    // await initDb();
    database = await openDb();
    var juzList = <Juz> [];
    var cursor = await database!.query(_juzListTable);
    for(var result in cursor){
      var data = Juz.fromJson(result);
      juzList.add(data);
    }
    return juzList;
  }

  Future<List<QuranText>> getJuzIds() async {
    database = await openDb();
    List<QuranText> juzIds = [];
    var cursor = await database!.query(_quranTextTable);
    for(var ids in cursor){
      var data = QuranText.fromJson(ids);
      juzIds.add(data);
    }
    return juzIds;
  }


  //add a bookmark
  void addBookmark(int surahId, int verseId) async {
    database = await openDb();
    await database!.rawUpdate("update $_quranTextTable set is_bookmark = 1 where surah_id = $surahId AND verse_id = $verseId");
  }

  //delete bookmark
  void removeBookmark(int surahId, int verseId) async {
    database = await openDb();
    await database!.rawUpdate("update $_quranTextTable set is_bookmark = 0 where surah_id = $surahId AND verse_id = $verseId");
  }

  Future<List<QuranText>> getBookmarks() async {
    database = await openDb();
    List<QuranText> quranTextList = [];
    var table = await database!.query(_quranTextTable,where: "is_bookmark= ?",whereArgs: [1]);
    for(var rows in table){
      var ayahText = QuranText.fromJson(rows);
      quranTextList.add(ayahText);
    }
    return quranTextList;
  }

  // List<String> words = normalizedText.trim().split(RegExp(r'\s+'));

  // Future<List<QuranText>> searchQuranText(String searchTerm) async {
  //   // Remove Tajweedi marks from the Arabic text
  //   database = await openDb();
  //   List<QuranText> fullQuranText = [];
  //   var table = await database!.query(_quranTextTable);
  //   for (var map in table) {
  //     fullQuranText.add(QuranText.fromJson(map));
  //   }
  //
  //   // Filter the Quran text based on the search term
  //   List<QuranText> filteredQuranText = [];
  //   if (fullQuranText.isNotEmpty) {
  //     for (var quranText in fullQuranText) {
  //       String verseText = quranText.verseText!;
  //       String normalizedText = verseText.replaceAll(RegExp(r'[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED]'), '');
  //       List<String> words = normalizedText.trim().split(RegExp(r'\s+'));
  //
  //       // Check if the search term matches any word in the verse text
  //       for (var word in words) {
  //         if (word.contains(searchTerm)) {
  //           // Highlight the matching search term in the verse text
  //           // String highlightedText = verseText.replaceAll(searchTerm, '<b>$searchTerm</b>');
  //           QuranText filtered = QuranText(surahId: quranText.surahId!, verseId: quranText.verseId, verseText: quranText.verseText, translationText: quranText.translationText, isBookmark: quranText.isBookmark);
  //           filteredQuranText.add(filtered);
  //           break;
  //         }else{
  //           filteredQuranText = [];
  //         }
  //       }
  //     }
  //   }
  //   return filteredQuranText;
  // }


  // do searching in quran
  // Future<List<QuranText>> searchQuranText(String word) async{
  //   // Remove Tajweedi marks from the Arabic text
  //   database = await openDb();
  //   List<QuranText> fullQuranText = [];
  //   List<QuranText> filteredQuranText = [];
  //   var table = await database!.query(_quranTextTable);
  //   for(var map in table){
  //     fullQuranText.add(QuranText.fromJson(map));
  //   }
  //   if(fullQuranText.isNotEmpty){
  //     for(var quranText in fullQuranText){
  //       String normalizedText = quranText.verseText!.replaceAll(RegExp(r'[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED]'), '');
  //
  //     }
  //   }
  //   return filteredQuranText;
  // }
}

class trans{
  int surahId;
  int id2;
  String text;

  trans(this.surahId, this.id2, this.text);

  Map<String, Object?> toJson() {
    return {
      "surahId":surahId,
      "verseId":id2,
      "text":text
    };
  }

}