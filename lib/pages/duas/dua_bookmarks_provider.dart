import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nour_al_quran/shared/database/quran_db.dart';

import '../../shared/entities/bookmarks_dua.dart';

class BookmarkProviderDua extends ChangeNotifier {
  final List _bookmarkList = Hive.box('myBox').get('bookmarks1') ?? [];
  List get bookmarkList => _bookmarkList;

  void removeBookmark(int duaId, int duaCategory) {
    QuranDatabase().removeduaBookmark(duaId, duaCategory);
    // print(_bookmarkList.indexWhere((element) => element.surahId == surahId && element.verseId == verseId));
    _bookmarkList.removeWhere((element) =>
        element.duaId == duaId && element.duaCategory == duaCategory);
    notifyListeners();
    Hive.box("myBox").put("bookmarks1", _bookmarkList);
  }

  void addBookmark(BookmarksDua bookmarks) {
    QuranDatabase().adduaBookmark(bookmarks.duaId!);
    _bookmarkList.add(bookmarks);
    notifyListeners();
    Hive.box("myBox").put("bookmarks1", _bookmarkList);
  }

  // void goToQuranView(BookmarksDua bookmarks, BuildContext context) async{
  //   if(bookmarks.isFromJuz!){
  //     context.read<QuranProvider>().setJuzText(juzId: bookmarks.juzId!,title: bookmarks.juzName!,fromWhere: 2,isJuz: true,bookmarkPosition: bookmarks.bookmarkPosition);
  //     /// if recitation player is on So this line is used to pause the player
  //     Future.delayed(Duration.zero,()=>context.read<RecitationPlayerProvider>().pause(context));
  //     Navigator.of(context).push(MaterialPageRoute(builder: (context) {
  //       return const QuranTextView();
  //     },));
  //   }else{
  //     // coming from surah so isJuz already false
  //     // coming from surah so JuzId already -1
  //     context.read<QuranProvider>().setSurahText(surahId: bookmarks.surahId!,title:'سورة ${bookmarks.surahArabic}',fromWhere: 2,bookmarkPosition: bookmarks.bookmarkPosition);
  //     /// if recitation player is on So this line is used to pause the player
  //     Future.delayed(Duration.zero,()=>context.read<RecitationPlayerProvider>().pause(context));
  //     Navigator.of(context).push(MaterialPageRoute(builder: (context) {
  //       return const QuranTextView();
  //     },));
  //   }
  // }
}
