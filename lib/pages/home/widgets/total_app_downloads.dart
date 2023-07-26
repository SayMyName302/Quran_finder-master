import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../shared/localization/localization_provider.dart';
import '../../../shared/utills/app_colors.dart';
import '../provider/home_provider.dart';

class AppDownloadsSection extends StatelessWidget {
  const AppDownloadsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final downloadCountModel = Provider.of<DownloadCountModel>(context);
    // downloadCountModel.initializePreferences();
    final qiblaProvider = Provider.of<HomeProvider>(context);

    return Column(
      children: [
        // DownloadRowWidget(
        //   text: localeText(context, 'islam_basics'),
        // ),
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
                Center(
                  child: FutureBuilder<String?>(
                    future: qiblaProvider.getUserRegion(),
                    builder: (context, regionSnapshot) {
                      if (regionSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (regionSnapshot.hasData) {
                        String? userRegion = regionSnapshot.data;
                        if (userRegion != null) {
                          return Text(
                            'Region: $userRegion',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17.sp,
                              fontFamily: "satoshi",
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        } else {
                          return const Text('User region not available.');
                        }
                      } else {
                        return const Text('Error retrieving user region.');
                      }
                    },
                  ),
                ),
                Center(
                  child: FutureBuilder<String?>(
                    future: qiblaProvider.getUserDateTime(),
                    builder: (context, dateTimeSnapshot) {
                      if (dateTimeSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (dateTimeSnapshot.hasData) {
                        String? userDateTime = dateTimeSnapshot.data;
                        if (userDateTime != null) {
                          return Text(
                            'Date/Time: $userDateTime',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17.sp,
                              fontFamily: "satoshi",
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        } else {
                          return const Text('User date/time not available.');
                        }
                      } else {
                        return const Text('Error retrieving user date/time.');
                      }
                    },
                  ),
                ),
                Center(
                  child: FutureBuilder<String?>(
                    future: qiblaProvider.getUserHijriMonth(),
                    builder: (context, hijriMonthSnapshot) {
                      if (hijriMonthSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (hijriMonthSnapshot.hasData) {
                        String? userHijriMonth = hijriMonthSnapshot.data;
                        if (userHijriMonth != null) {
                          return Text(
                            'Hijri month: $userHijriMonth',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17.sp,
                              fontFamily: "satoshi",
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        } else {
                          return const Text('User Hijri month not available.');
                        }
                      } else {
                        return const Text('Error retrieving user Hijri month.');
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
