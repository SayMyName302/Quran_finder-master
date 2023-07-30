import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/settings/pages/app_colors/app_colors_provider.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
//import 'package:nour_al_quran/shared/widgets/title_row.dart';
import 'package:nour_al_quran/pages/quran/pages/recitation/recitation_provider.dart';
import 'package:nour_al_quran/pages/quran/pages/recitation/reciter/reciter_provider.dart';
import 'package:nour_al_quran/shared/entities/reciters.dart';
import 'package:nour_al_quran/shared/routes/routes_helper.dart';
import 'package:nour_al_quran/shared/utills/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../../../shared/widgets/app_bar.dart';

class AllReciters extends StatefulWidget {
  const AllReciters({Key? key}) : super(key: key);

  @override
  _AllRecitersState createState() => _AllRecitersState();
}

class _AllRecitersState extends State<AllReciters> {
  bool _isImagesLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImages();
  }

  Future<void> precacheImages() async {
    final recitersValue =
        Provider.of<RecitationProvider>(context, listen: false);
    await Future.wait(
      recitersValue.recommendedReciterList.map((reciter) {
        return precacheImage(
            CachedNetworkImageProvider(reciter.imageUrl!), context);
      }),
    );
    setState(() {
      _isImagesLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appColors = context.watch<AppColorsProvider>().mainBrandingColor;
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

    return Scaffold(
        appBar: buildAppBar(
          context: context,
          title: localeText(context, "all_reciters"),
          font: 16.sp,
        ),
        body: _isImagesLoaded
            ? Consumer<RecitationProvider>(
                builder: (context, recitersValue, child) {
                  return GridView.builder(
                    padding: EdgeInsets.only(left: 20.w, right: 20.w),
                    itemCount: recitersValue.recommendedReciterList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisExtent: 116.87.h,
                      mainAxisSpacing: 10.h,
                      crossAxisSpacing: 5.w,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      Reciters reciter = recitersValue.recommendedReciterList[index];
                      return InkWell(
                        onTap: () async {
                          recitersValue.getSurahName();
                          // context.read<ReciterProvider>().resetDownloadSurahList();
                          context
                              .read<ReciterProvider>()
                              .setReciterList(reciter.downloadSurahList!);
                          Navigator.of(context).pushNamed(RouteHelper.reciter,
                              arguments: reciter);
                          analytics
                              .logEvent(name: 'all_reciters_page', parameters: {
                            'reciterId': reciter.reciterId,
                            'reciter_name': reciter.reciterName.toString(),
                          });
                        },
                        child: buildReciterDetailsContainer(reciter),
                      );
                    },
                  );
                },
              )
            : Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: appColors,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: appColors,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ));
  }

  Container buildReciterDetailsContainer(Reciters reciter) {
    return Container(
      margin: EdgeInsets.only(right: 7.w),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 71.18.h,
            width: 71.18.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35.59.r),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: reciter.imageUrl!,
                placeholder: (context, url) => const CircularProgressIndicator(
                  color: AppColors.mainBrandingColor,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.person),
              ),
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            reciter.reciterName!,
            softWrap: true,
            maxLines: 3,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 11.sp,
              height: 1.3.h,
              fontFamily: "satoshi",
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
