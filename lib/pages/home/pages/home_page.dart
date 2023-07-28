import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:nour_al_quran/pages/home/widgets/featured_section.dart';
import 'package:nour_al_quran/pages/home/widgets/islam_basics_section.dart';
import 'package:nour_al_quran/pages/home/widgets/popular_section.dart';
import 'package:nour_al_quran/pages/home/widgets/quran_miracles_section.dart';
import 'package:nour_al_quran/pages/home/widgets/quran_stories_section.dart';
import 'package:nour_al_quran/pages/home/widgets/user_picture.dart';
import 'package:nour_al_quran/pages/settings/pages/subscriptions/on_board/free_trial.dart';
import 'package:nour_al_quran/shared/entities/last_seen.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:nour_al_quran/pages/quran/pages/resume/where_you_left_off_widget.dart';
import 'package:provider/provider.dart';
import '../../sign_in/provider/sign_in_provider.dart';
import '../provider/home_provider.dart';
import '../widgets/total_app_downloads.dart';
import '../widgets/verse_of_the_day.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LastSeen? lastSeen = Hive.box('myBox').get("lastSeen");

  @override
  void initState() {
    super.initState();
    _getLocationPermissionAndRegion();

    // Future.delayed(const Duration(seconds: 5),()=>showInAppPurchaseBottomSheet());
  }

  Future<void> _getLocationPermissionAndRegion() async {
    HomeProvider getCountry = Provider.of<HomeProvider>(context, listen: false);
    SignInProvider signInProvider =
        Provider.of<SignInProvider>(context, listen: false);
    try {
      await signInProvider.initUserEmail();
      String? userEmail = signInProvider.userEmail;
      bool isUser = userEmail == "asdf@a.com";

      String userRegion = getCountry.country;
      if (userRegion.isNotEmpty) {
      } else {
        if (isUser) {
          await getCountry.getLocationPermission(context);
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// user picture, home title and islamic date widget
            const UserPicture(),

            /// your engagement feature
            //const YourEngagementSection(),

            /// ayah last seen container
            lastSeen != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                        margin: EdgeInsets.only(
                            left: 20.w, bottom: 8.h, right: 20.w),
                        child: Text(
                          localeText(context, 'continue_where_you_left_off'),
                          style: TextStyle(
                              fontSize: 17.sp,
                              fontFamily: 'satoshi',
                              fontWeight: FontWeight.w900),
                        )),
                  )
                : const SizedBox.shrink(),
            lastSeen != null
                ? const WhereULeftOffWidget()
                : const SizedBox.shrink(),
            const FeaturedSection(),
            const VerseOfTheDayContainer(),
            const PopularSection(),

            /// quran Stories Section
            const QuranStoriesSection(),

            /// verse of the day Container

            /// Quran Miracles Section
            const QuranMiraclesSection(),

            /// Islam Basics Section
            const IslamBasicsSection(),

            AppDownloadsSection(),

            // const RecitationCategorySection(),
          ],
        ),
      ),
    );
  }

  showInAppPurchaseBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) {
        return const FreeTrial();
      },
    );
  }
}
