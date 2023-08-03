import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/shared/widgets/brand_button.dart';
import 'package:provider/provider.dart';

import '../../../shared/localization/localization_provider.dart';
import '../../../shared/utills/app_colors.dart';
import '../../featured/models/featured.dart';
import '../../featured/provider/featured_provider.dart';
import '../../sign_in/provider/sign_in_provider.dart';
import '../models/title_custom.dart';
import '../provider/home_provider.dart';
import 'labeled_textfield.dart';
import 'dart:math';
// import 'dart:ui' as ui;

class AppDownloadsSection extends StatelessWidget {
  AppDownloadsSection({Key? key}) : super(key: key);

  //TextField Controllers
  final country = TextEditingController();
  final hijriMonth = TextEditingController();
  final date = TextEditingController();
  final time = TextEditingController();
  final hijriYear = TextEditingController();
  final dayName = TextEditingController();
  final weather = TextEditingController();

  // final feature = Provider.of<FeatureProvider>(context, listen: false);

  void fetchCountryTitle(BuildContext context) async {
    String countryName = country.text.trim().toLowerCase();
    final user = Provider.of<HomeProvider>(context, listen: false);

    List<CustomTitles> titles =
        await user.getTitlesByCountryExplicitly(countryName);

    if (titles.isNotEmpty) {
      int randomIndex = Random().nextInt(titles.length);
      CustomTitles selectedTitle = titles[randomIndex];
      String? selectedTitleText = selectedTitle.titleText;

      user.setSelectedTitleText(selectedTitleText);
    } else {
      user.setSelectedTitleText("Popular Recitations");
    }
  }

  void fetchRainCountryTitle(BuildContext context) async {
    String countryName = country.text.trim().toLowerCase();

    String lowerCaseWeather = weather.text.trim().toLowerCase();
    final user = Provider.of<HomeProvider>(context, listen: false);
    // print(weather.text);
    // print(country.text);

    List<CustomTitles> titles =
        await user.getWeatherCountryTitles(countryName, lowerCaseWeather);

    if (titles.isNotEmpty) {
      int randomIndex = Random().nextInt(titles.length);
      CustomTitles selectedTitle = titles[randomIndex];
      String? selectedTitleText = selectedTitle.titleText;

      user.setSelectedTitleText(selectedTitleText);
    } else {
      user.setSelectedTitleText("Popular Recitations");
    }
  }

  void changeFeatureOrder(BuildContext context) async {}

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<HomeProvider>(context);
    final authProvider = Provider.of<SignInProvider>(context);
    final featureProvider =
        Provider.of<FeatureProvider>(context, listen: false);

    // List<FeaturedModel> featureModels = featureProvider.feature;
    // List<Map<String, dynamic>> mapList = featureModels
    //     .map((model) => featureProvider.featuredModelToMap(model))
    //     .toList();
    // List<Map<String, dynamic>> reorderedStories =
    //     [];

    final userEmail = authProvider.userEmail;
    final isUserYou = userEmail == "u@u.com" ||
        userEmail == "ahsanalikhan200@gmail.com" ||
        userEmail == "ahsanalikhan538@gmail.com" ||
        userEmail == "canzinternal3@gmail.com";

    if (!isUserYou) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        Consumer<LocalizationProvider>(
          builder: (context, language, child) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.95,
              margin: EdgeInsets.only(right: 10.w, left: 20.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(
                  color: AppColors.grey5,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        left: 16.w, bottom: 8.h, right: 6.w, top: 5.h),
                    alignment: language.locale.languageCode == "ur" ||
                            language.locale.languageCode == "ar"
                        ? Alignment.bottomRight
                        : Alignment.bottomLeft,
                    child: StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('app_stats')
                          .doc('vzIEu1gIvltuyDUkhAJO')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          int downloadCount =
                              snapshot.data!.get('download_count');
                          return Center(
                            child: Text(
                              'Total app downloads: $downloadCount',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17.sp,
                                fontFamily: "satoshi",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }
                        return const Text('Loading...');
                      },
                    ),
                  ),
                  LabeledTextField(
                    label: "Region: ${user.country}",
                    controller: country,
                  ),
                  const SizedBox(height: 10),
                  LabeledTextField(
                    label: "Date : ${user.date}",
                    controller: date,
                  ),
                  const SizedBox(height: 10),
                  LabeledTextField(
                    label: "Time: ${user.time}",
                    controller: time,
                  ),
                  const SizedBox(height: 10),
                  LabeledTextField(
                    label: "Hijri month: ${user.hijriMonth}",
                    controller: hijriMonth,
                  ),
                  const SizedBox(height: 10),
                  LabeledTextField(
                    label: "Hijri Year: ${user.hijriYear}",
                    controller: hijriYear,
                  ),
                  const SizedBox(height: 10),
                  LabeledTextField(
                    label: "Day name: ${user.dayName}",
                    controller: dayName,
                  ),
                  const SizedBox(height: 10),
                  LabeledTextField(
                    label: "weather: ${user.weather}",
                    controller: weather,
                  ),
                  const SizedBox(height: 10),
                  BrandButton(
                    text: 'Submit',
                    onTap: () {
                      String lowerCaseCountry =
                          country.text.trim().toLowerCase();
                      String lowerCaseWeather =
                          weather.text.trim().toLowerCase();
                      String lowerCasedayName =
                          dayName.text.trim().toLowerCase();

                      if ((lowerCaseCountry == "pakistan" ||
                                  lowerCaseCountry == "saudi arabia" ||
                                  lowerCaseCountry == "indonesia") &&
                              lowerCaseWeather == "rain" ||
                          lowerCaseWeather == "thunder") {
                        fetchRainCountryTitle(context);
                      } else if (lowerCaseCountry.isNotEmpty) {
                        fetchCountryTitle(context);
                      }
                      // else if (lowerCasedayName.isNotEmpty) {
                      //   featureProvider.setDayName(dayName.text);
                      // }

                      // featureProvider.setDayName(dayName.text);
                      featureProvider.reorderStoriesIfNeeded(lowerCasedayName);
                    },
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
