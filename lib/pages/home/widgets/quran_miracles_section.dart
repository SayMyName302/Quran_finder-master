import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/shared/localization/localization_provider.dart';
import 'package:provider/provider.dart';

import '../../../shared/localization/localization_constants.dart';
import '../../../shared/routes/routes_helper.dart';
import '../../miracles_of_quran/models/miracles.dart';
import '../../miracles_of_quran/provider/miracles_of_quran_provider.dart';
import '../../quran/pages/recitation/reciter/player/player_provider.dart';
import 'home_row_widget.dart';

class QuranMiraclesSection extends StatelessWidget {
  const QuranMiraclesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    return Column(
      children: [
        HomeRowWidget(
          text: localeText(context, 'miracles_of_quran'),
          buttonText: localeText(context, "view_all"),
          onTap: () {
            Navigator.of(context).pushNamed(RouteHelper.miraclesOfQuran);
            analytics.logEvent(
              name: 'quran_miracles_viewall_button',
              parameters: {'title': 'qmicracles_viewall'},
            );
          },
        ),
        Consumer<LocalizationProvider>(
          builder: (context, language, child) {
            return SizedBox(
              height: 150.h,
              child: Consumer<MiraclesOfQuranProvider>(
                builder: (context, miraclesProvider, child) {
                  return ListView.builder(
                    itemCount: miraclesProvider.miracles.length,
                    padding:
                        EdgeInsets.only(left: 20.w, right: 20.w, bottom: 14.h),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      Miracles model = miraclesProvider.miracles[index];
                      if (model.status != 'active') {
                        return Container(); // Skip inactive items
                      }
                      return InkWell(
                        onTap: () {
                          // miraclesProvider.checkVideoAvailable(model.title!, context);
                          Future.delayed(
                              Duration.zero,
                              () => context
                                  .read<RecitationPlayerProvider>()
                                  .pause(context));
                          miraclesProvider.goToMiracleDetailsPage(
                              model.title!, context, index);
                          analytics.logEvent(
                            name: 'quran_miracles',
                            parameters: {'title': model.title},
                          );
                        },
                        child: Container(
                          width: 287.w,
                          margin: EdgeInsets.only(right: 10.w),
                          decoration: BoxDecoration(
                              color: Colors.amberAccent,
                              borderRadius: BorderRadius.circular(8.r),
                              image: DecorationImage(
                                  image: AssetImage('${model.image}'),
                                  fit: BoxFit.cover)),
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 6.w, bottom: 8.h, right: 8.w),
                            alignment: language.locale.languageCode == "ur" ||
                                    language.locale.languageCode == "ar"
                                ? Alignment.bottomRight
                                : Alignment.bottomLeft,
                            child: Text(
                              localeText(context, model.title!.toLowerCase()),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.sp,
                                  fontFamily: "satoshi",
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        )
      ],
    );
  }
}
