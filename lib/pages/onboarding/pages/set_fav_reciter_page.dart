import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nour_al_quran/pages/onboarding/provider/on_boarding_provider.dart';
import 'package:nour_al_quran/pages/onboarding/widgets/skip_button.dart';
import 'package:nour_al_quran/pages/onboarding/widgets/on_boarding_text_widgets.dart';
import 'package:nour_al_quran/pages/quran/pages/recitation/recitation_provider.dart';
import 'package:nour_al_quran/pages/settings/pages/app_colors/app_colors_provider.dart';
import 'package:nour_al_quran/pages/settings/pages/app_them/them_provider.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:nour_al_quran/shared/routes/routes_helper.dart';
import 'package:nour_al_quran/shared/utills/app_colors.dart';
import 'package:nour_al_quran/shared/widgets/brand_button.dart';
import 'package:provider/provider.dart';

import '../../settings/pages/profile/profile_provider.dart';
import '../models/fav_reciter.dart';

class SetFavReciter extends StatefulWidget {
  const SetFavReciter({Key? key}) : super(key: key);

  @override
  State<SetFavReciter> createState() => _SetFavReciterState();
}

class _SetFavReciterState extends State<SetFavReciter> {
  @override
  void initState() {
    super.initState();
    context.read<RecitationProvider>().getAllReciters();
  }

  @override
  Widget build(BuildContext context) {
    var isDark = context.read<ThemProvider>().isDark;
    var appColors = context.read<AppColorsProvider>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OnBoardingTitleText(
                    title: localeText(context,
                        "beautiful_recitations_from_around_the_world")),
                OnBoardingSubTitleText(
                    title: localeText(context, "set_your_favorite_reciter")),
                Consumer<OnBoardingProvider>(
                  builder: (context, setReciter, child) {
                    return MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      removeBottom: true,
                      child: GridView.builder(
                        itemCount: setReciter.reciterList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Number of columns
                          childAspectRatio: 175 / 145, // Width / Height
                        ),
                        itemBuilder: (context, index) {
                          FavReciter reciter = setReciter.reciterList[index];
                          return InkWell(
                            onTap: () {
                              setReciter.setFavReciter(index);
                            },
                            child: _buildReciterNameContainer(
                              reciter,
                              setReciter,
                              isDark,
                              appColors,
                              index,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 50),
                BrandButton(
                    text: localeText(context, "continue"),
                    onTap: () async {
                      var provider = Provider.of<OnBoardingProvider>(context,
                          listen: false);
                      List<FavReciter> reciterList = provider.reciterList;
                      int index = reciterList.indexWhere(
                          (element) => element.title == provider.favReciter);
                      Provider.of<ProfileProvider>(context, listen: false)
                          .addReciterFavOrRemove(reciterList[index].reciterId!);
                      // Provider.of<RecitationProvider>(context,listen: false).addReciterFavOrRemove(reciterList[index].reciterId!);
                      // var selectedReciterIds = context.read<OnBoardingProvider>().reciterList.where((reciter) => reciter.title == context.read<OnBoardingProvider>().favReciter).map((reciter) => reciter.reciterId).toList();
                      // Assuming you have access to the DBHelper instance
                      // var dbHelper = QuranDatabase();

                      // Iterate over the selected reciter IDs and update the is_fav value
                      // for (var reciterId in selectedReciterIds) {
                      /// we will update this with hive

                      // await dbHelper.updateReciterIsFav(
                      //     reciterId!, 1); // Set the value to 1 for true
                      // }

                      // Navigator.of(context).pushNamed(RouteHelper.quranReminder);
                      Navigator.of(context)
                          .pushNamed(RouteHelper.notificationSetup);
                    }),
                SizedBox(
                  height: 16.h,
                ),
                SkipButton(onTap: () {
                  Navigator.of(context)
                      .pushNamed(RouteHelper.notificationSetup);
                  // Navigator.of(context).pushNamed(RouteHelper.quranReminder);
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _buildReciterNameContainer(
    FavReciter reciter,
    OnBoardingProvider setReciter,
    bool isDark,
    AppColorsProvider appColors,
    int index,
    // Add height parameter
  ) {
    bool isSelected = reciter.title == setReciter.favReciter;
    Color selectedBackgroundColor =
        const Color.fromRGBO(253, 191, 71, 0.75); // Golden color

    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(10), // Round edges of the outer container
      ),
      child: InkWell(
        child: Card(
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            // side: BorderSide(
            //   color: isSelected
            //       ? appColors.mainBrandingColor
            //       : isDark
            //           ? AppColors.grey3
            //           : AppColors.grey5,
            // ),
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    isSelected
                        ? ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.6),
                              BlendMode.darken,
                            ),
                            child: Image.asset(
                              reciter.imageUrl ?? "",
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error),
                            ),
                          )
                        : Image.asset(
                            reciter.imageUrl ?? "",
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error),
                          ),
                    if (isSelected)
                      Center(
                        child: SvgPicture.asset(
                            'assets/images/app_icons/audiobus.svg',

                            /// Replace with your SVG asset path
                            width: 105.w,
                            height: 105.h,
                            fit: BoxFit.cover,
                            color: selectedBackgroundColor
                            // Optional: You can apply color to the SVG
                            ),
                      ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: isSelected
                      ? selectedBackgroundColor
                      : Colors
                          .white, // Change background color based on selection
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        reciter.title!,
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : Colors
                                  .black, // Change text color based on selection
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
