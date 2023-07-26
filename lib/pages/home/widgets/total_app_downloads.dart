import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../shared/localization/localization_provider.dart';
import '../../../shared/utills/app_colors.dart';
import '../../sign_in/provider/sign_in_provider.dart';
import '../provider/home_provider.dart';

class AppDownloadsSection extends StatelessWidget {
  const AppDownloadsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<HomeProvider>(context);

    //test
    final authProvider = Provider.of<SignInProvider>(context);

    // Get the user's email from the SignInProvider
    final userEmail = authProvider.userEmail;
    // Check if the user is logged in as "you@you.com"
    final isUserYou = userEmail == "you@you.com";

    print('=====UserEmail{$userEmail}======');

    // Return null if the user is not "you@you.com" to hide the widget
    if (!isUserYou) {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        Consumer<LocalizationProvider>(builder: (context, language, child) {
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
                Text("Region: ${userData.region}"),
                Text("Date and Time: ${userData.dateTime}"),
                Text("Hijri Month: ${userData.hijriMonth}"),
                Text("Hijri Year: ${userData.hijriYear}"),
                Text("Day Name: ${userData.dayName}"),
              ],
            ),
          );
        }),
      ],
    );
  }
}
