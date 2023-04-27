
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nour_al_quran/pages/settings/pages/notifications/notification_services.dart';
import 'package:nour_al_quran/shared/entities/quran_text.dart';
import 'package:nour_al_quran/shared/database/quran_db.dart';
import 'package:http/http.dart' as http;
import 'package:nour_al_quran/shared/utills/app_constants.dart';

class TestingQuran extends StatefulWidget {
  const TestingQuran({Key? key}) : super(key: key);

  @override
  State<TestingQuran> createState() => _TestingQuranState();
}

class _TestingQuranState extends State<TestingQuran> {
  List<QuranTranslations> quranList = [];
  List<QuranText> juzIds = [];
  @override
  void initState() {
    super.initState();
    getIds();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: ()async{
              // print(await QuranDatabase().getJuzIds());
              // List<QuranTranslations> quran = (jsonDecode(Hive.box(appBoxKey).get("translation_ur_jalandhry")) as List<dynamic>).map((e) => QuranTranslations.fromJson(e)).toList();
              // for(int i=1;i<=114;i++){
              //   var surah = quran.where((element) => element.surahId == i).toList();
              //   surah.insert(0, QuranTranslations(surahId: surah[0].surahId, verseId: 0,juzId: surah[0].juzId, verseText: "bismillah"));
              // }
              //
              // for(int i=0;i<quran.length;i++){
              // }
              await NotificationServices().scheduleNotification1(id: 0, title: "title plan", body: "body plan", payload: "");
              await NotificationServices().scheduleNotification(id: 1, title: "", body: "", payload: "", scheduledDateTime: DateTime.now().add(const Duration(seconds: 60),));
              // for(int i=0;i<surah.length;i++){
              //   print("${surah[i].surahId},${surah[i].verseId},${surah[i].juzId},${surah[i].verseText}");
              // }
            }, child: const Text('see')),
            ElevatedButton(onPressed: (){

              // if(juzIds.isNotEmpty){
              //   debugPrint(juzIds[i].surahId.toString(),wrapWidth: 1024);
              // }
              fetchData();
              // print(quranList[621].split("|").length);
            },child: const Text("get"),),
          ],
        )
      ),
    );
  }

  Future<void> getQuran(BuildContext context) async {
    List<QuranText> quranText = await QuranDatabase().getQuranSurahText(surahId: 2);
    if (quranText != []) {
      // context.read<QuranDbProvider>().setQuranTextList(quranText);
    }
  }

  // Future<void> fetchData() async {
  //   final response = await http.get(Uri.parse("https://tanzil.net/trans/en.hilali"));
  //   if (response.statusCode == 200) {
  //     var apiResponse = response.body;
  //     var list = apiResponse.split("\n");
  //     var updated = [];
  //     for(int i = 0;i<6236;i++){
  //       updated.add(list[i].split("|"));
  //     }
  //     await QuranDatabase().updateQuranTranslations(updated,"");
  //     await QuranDatabase().updateBissmillahOfEachTranslation(0, "In the Name of Allah, the Most Beneficent, the Most Merciful.","translation_english_hilali");
  //   } else {
  //     print('Request failed with status: ${response.statusCode}.');
  //   }
  // }

  Future<void> getIds() async {
    juzIds = await QuranDatabase().getJuzIds();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse("https://tanzil.net/trans/ur.maududi"));
    if (response.statusCode == 200) {
      var apiResponse = response.body;
      var list = apiResponse.split("\n");
      var updated = [];
      for(int i = 0;i<6236;i++){
        updated.add(list[i].split("|"));
      }
      List<QuranTranslations> urdu = [];
      if(updated.length > 6000 && juzIds.length > 6000){
        for(int i=0;i<6236;i++){
          if(juzIds[i].juzId != null){
            urdu.add(QuranTranslations(surahId: int.parse(updated[i][0]), verseId: int.parse(updated[i][1]),juzId: juzIds[i].juzId, verseText: updated[i][2]));
          }
        }
      }
      Hive.box(appBoxKey).put("translation_ur_jalandhry", jsonEncode(urdu)).then((value) {
        print(QuranTranslations.fromJson(jsonDecode(Hive.box(appBoxKey).get("translation_ur_jalandhry"))[0]).verseText);
        debugPrint(Hive.box(appBoxKey).get("translation_ur_jalandhry")[0],);
      });
      // QuranDatabase().updateQuranTranslations(updated,"translation_english_hilali",context,0);
      // for(int k = 0;k<100;k++){
      //   QuranDatabase().updateQuranTranslations(int.parse(updated[k][0]), int.parse(updated[k][1]), updated[k][2]);
      // }

    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}


// for (String line in list) {
//   List<String> elements = line.split("|");
//   quranList.add(Quran(
//     ayah: elements[0],
//     surah: elements[1],
//     text: elements[2],
//   ));
// }
class QuranTranslations {
  int? surahId;
  int? verseId;
  int? juzId;
  String? verseText;
  QuranTranslations({required this.surahId, required this.verseId,required juzId,required this.verseText,});

  QuranTranslations.fromJson(Map<String,dynamic> json){
    surahId = json['surahId'];
    verseId = json['verseId'];
    juzId = json['juzId'];
    verseText = json['verseText'];
  }

  Map toJson(){
    return {
      "surahId":surahId,
      "verseId":verseId,
      "verseText":verseText,
      "juzId":juzId
    };
  }
}
