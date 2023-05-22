import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../shared/localization/localization_constants.dart';
import '../../../shared/widgets/dua_container.dart';
import '../provider/home_provider.dart';
import 'home_row_widget.dart';

class VerseOfTheDayContainer extends StatelessWidget {
  const VerseOfTheDayContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, value, child) {
        return Column(
          children: [
            HomeRowWidget(text: localeText(context,'verse_of_the_day'), buttonText: localeText(context,'share'), onTap: () {
              Share.share("${value.verseOfTheDay.verseText}\n${value.verseOfTheDay.translationText}\n-- ${value.verseOfTheDay.surahId}:${value.verseOfTheDay.verseId} --\nhttps://play.google.com/store/apps/details?id=com.fanzetech.holyquran");
            },),
            DuaContainer(ref: "${value.verseOfTheDay.surahId}:${value.verseOfTheDay.verseId}" ,text: value.verseOfTheDay.verseText,translation: value.verseOfTheDay.translationText,)
          ],
        );
      },
    );;
  }
}
