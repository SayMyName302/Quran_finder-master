import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:nour_al_quran/pages/featured/provider/featured_provider.dart';
import 'package:nour_al_quran/pages/popular_section/provider/popular_provider.dart';
import 'package:nour_al_quran/pages/settings/pages/app_colors/app_colors_provider.dart';
import 'package:nour_al_quran/pages/settings/pages/app_them/them_provider.dart';
import 'package:nour_al_quran/pages/settings/pages/fonts/font_provider.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:provider/provider.dart';

import '../../../shared/widgets/app_bar.dart';

class FeaturedDetailsPage extends StatelessWidget {
  const FeaturedDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer3<FeatureProvider, PopularProvider, AppColorsProvider>(
      builder: (context, story, popular, appColors, child) {
        return Scaffold(
            appBar: buildAppBar(
                context: context,
                title: story.selectedFeatureStory != null
                    ? localeText(
                        context, story.selectedFeatureStory!.storyTitle!)
                    : localeText(
                        context, popular.selectedFeatureStory!.title!)),
            body: buildBody(story, popular, context));
      },
    );
  }

  buildBody(
      FeatureProvider story, PopularProvider popular, BuildContext context) {
    FontProvider fontProvider = Provider.of<FontProvider>(context);
    String? text = story.selectedFeatureStory != null
        ? story.selectedFeatureStory!.text
        : popular.selectedFeatureStory!.text;

    if (text == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final isArabic = checkIfArabic(text);

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Consumer2<ThemProvider, FontProvider>(
            builder: (context, themProvider, font, child) {
          return isArabic
              ? Directionality(
                  textDirection: TextDirection.rtl,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: text,
                          style: TextStyle(
                            fontFamily:
                                font.finalFont, // Replace with your Quran font
                            fontSize: font.fontSizeArabic.sp,
                            fontWeight: FontWeight.normal,
                            color: Colors.black, // Adjust color as needed
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : HtmlWidget(
                  text,
                  textStyle: TextStyle(
                    fontFamily:
                        'Scheherazade Font', // Replace with your Quran font
                    fontSize: fontProvider.fontSizeTranslation.sp,
                    fontWeight: FontWeight.normal,
                    color: Colors.black, // Adjust color as needed
                  ),
                  customStylesBuilder: (element) {
                    // Apply custom styles for <strong> and <em> tags if needed
                    if (element.localName == 'strong') {
                      return {
                        'color': '#FF0000', // Example color
                        'font-weight': 'bold',
                      };
                    } else if (element.localName == 'em') {
                      return {
                        'color': '#00FF00', // Example color
                        'font-style': 'italic',
                      };
                    }
                    return null;
                  },
                );
        }),
      ),
    );
  }
}

bool checkIfArabic(String text) {
  final arabicPattern = RegExp(
      r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFBC1\uFE70-\uFEFF]');
  return arabicPattern.hasMatch(text);
}
//testing push