import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/shared/widgets/brand_button.dart';
import 'package:provider/provider.dart';

import '../../../shared/localization/localization_provider.dart';
import '../../../shared/utills/app_colors.dart';
import '../../sign_in/provider/sign_in_provider.dart';
import '../provider/home_provider.dart';
import 'labeled_textfield.dart';
// import 'dart:ui' as ui;

class RecitationTestSection extends StatelessWidget {
  RecitationTestSection({Key? key}) : super(key: key);

  //TextField Controllers
  final country = TextEditingController();
  final tod = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<HomeProvider>(context);
    final authProvider = Provider.of<SignInProvider>(context);

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
                  const SizedBox(height: 10),
                  LabeledTextField(
                    label: "Country: ${user.rCountryName}",
                    controller: country,
                  ),
                  const SizedBox(height: 10),
                  LabeledTextField(
                    label: "Time of the Day: ${user.rTimeOfTheDay}",
                    controller: tod,
                  ),
                  const SizedBox(height: 10),
                  BrandButton(
                    text: 'Test',
                    onTap: () {
                      String lowerCaseCountry =
                          country.text.trim().toLowerCase();
                      String lowerCaseWeather = tod.text.trim().toLowerCase();

                      HomeProvider homeProvider =
                          Provider.of<HomeProvider>(context, listen: false);
                      homeProvider.updateInput(
                          lowerCaseCountry, lowerCaseWeather);
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
