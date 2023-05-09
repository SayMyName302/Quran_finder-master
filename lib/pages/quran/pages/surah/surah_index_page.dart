import 'package:flutter/material.dart';
import 'surah_provider.dart';
import '../../widgets/search_widget.dart';

import '../../../../shared/entities/surah.dart';
import '../../widgets/quran_text_view.dart';
import '../../providers/quran_provider.dart';
import '../../widgets/details_container_widget.dart';
import '../../widgets/subtitle_text.dart';
import '../../../../shared/localization/localization_constants.dart';
import 'package:provider/provider.dart';

class SurahIndexPage extends StatefulWidget {
  const SurahIndexPage({Key? key}) : super(key: key);

  @override
  State<SurahIndexPage> createState() => _SurahIndexPageState();
}

class _SurahIndexPageState extends State<SurahIndexPage> {
  var searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SurahProvider>().getSurahName();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubTitleText(title: localeText(context, "surah_index")),
        SearchWidget(
          hintText: localeText(context, "search_surah_name"),
          searchController: searchController,
          onChange: (value) {
            context.read<SurahProvider>().searchSurah(value);
          },
        ),
        Consumer<SurahProvider>(
          builder: (context, surahValue, child) {
            return surahValue.surahNamesList.isNotEmpty
                ? Expanded(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                        itemCount: surahValue.surahNamesList.length,
                        itemBuilder: (context, index) {
                          Surah surah = surahValue.surahNamesList[index];
                          return InkWell(
                            onTap: () async {
                              // to clear search field
                              searchController.text = "";
                              context.read<QuranProvider>().setSurahText(
                                  surahId: surah.surahId!,
                                  title: 'سورة ${surah.arabicName}',
                                  fromWhere: 1);
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) {
                                  return const QuranTextView();
                                },
                              ));
                            },
                            child: DetailsContainerWidget(
                              title: surah.surahName!,
                              subTitle: surah.englishName!,
                              icon: Icons.remove_red_eye_outlined,
                              imageIcon: "assets/images/app_icons/view.png",
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : const Expanded(
                    child: Center(
                    child: Text('No Result Found'),
                  ));
          },
        )
      ],
    );
  }
}
