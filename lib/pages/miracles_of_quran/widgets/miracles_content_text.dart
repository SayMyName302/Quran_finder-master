import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:nour_al_quran/pages/settings/pages/app_colors/app_colors_provider.dart';
import 'package:nour_al_quran/pages/settings/pages/fonts/font_provider.dart';
import 'package:nour_al_quran/pages/you_may_also_like/models/youmaylike_model.dart';
import 'package:provider/provider.dart';

import '../../home/models/friday_content.dart';
import '../models/miracles.dart';

class MiraclesContentText extends StatelessWidget {
  const MiraclesContentText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FontProvider fontProvider = Provider.of<FontProvider>(context);
    // Miracles miracles =
    //     context.read<MiraclesOfQuranProvider>().selectedMiracle!;
    var arguments = ModalRoute.of(context)?.settings.arguments;

    Friday? friday;
    Miracles? miracles;
    YouMayAlsoLikeModel? ymal;

    if (arguments != null) {
      if (arguments is Friday) {
        friday = arguments;
        // print(friday.text);
      } else if (arguments is Miracles) {
        miracles = arguments;
      } else if (arguments is YouMayAlsoLikeModel) {
        ymal = arguments;
      }
    }
    try {
      return Expanded(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 16.h,
              bottom: 16.h,
            ),
            alignment: Alignment.center,
            child: FutureBuilder<String>(
              future:
                  Future<String>.delayed(const Duration(milliseconds: 100), () {
                // Simulating an asynchronous operation
                if (friday != null) {
                  if (friday.text == null) {
                    throw Exception('Text is null');
                  }
                  return friday.text!;
                } else if (miracles != null) {
                  if (miracles.text == null) {
                    throw Exception('Text is null');
                  }
                  return miracles.text!;
                } else if (ymal != null) {
                  if (ymal.text == null) {
                    throw Exception('Text is null');
                  }
                  return ymal.text!;
                } else {
                  return ''; // Return empty string if neither friday nor miracles is available
                }
              }),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasError) {
                  final error = snapshot.error.toString();
                  showErrorSnackBar('An error occurred: $error', context);
                  return const SizedBox
                      .shrink(); // Return an empty widget in case of an error
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                final text = snapshot.data!;
                return HtmlWidget(
                  text,
                  textStyle: TextStyle(
                    fontFamily: 'satoshi',
                    fontSize: fontProvider.fontSizeTranslation.sp,
                  ),
                  customStylesBuilder: (element) {
                    if (element.localName == 'em') {
                      final appColorsProvider =
                          Provider.of<AppColorsProvider>(context);
                      final brandingColor = appColorsProvider.mainBrandingColor;
                      final colorValue =
                          '#${brandingColor.value.toRadixString(16).substring(2)}';
                      return {
                        'color': colorValue
                      }; // Apply mainBrandingColor to the text color
                    }
                    if (element.localName == 'p' &&
                        element.classes.contains('arabic')) {
                      final appColorsProvider =
                          Provider.of<AppColorsProvider>(context);
                      final brandingColor = appColorsProvider.mainBrandingColor;
                      final colorValue =
                          '#${brandingColor.value.toRadixString(16).substring(2)}';
                      return {
                        'color': colorValue,
                        'font-family': 'Scheherazade Font',
                      };
                    }
                    return null;
                    // Custom styles logic
                  },
                );
              },
            ),
          ),
        ),
      );
    } catch (e) {
      showErrorSnackBar('An error occurred: $e', context);
      return const SizedBox.shrink();
    }
  }
}

void showErrorSnackBar(String msg, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

bool checkIfArabic(String text) {
  final arabicPattern = RegExp(
      r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFBC1\uFE70-\uFEFF]');
  return arabicPattern.hasMatch(text);
}
