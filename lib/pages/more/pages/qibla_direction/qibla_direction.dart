import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/more/pages/qibla_direction/provider.dart';
import 'package:nour_al_quran/pages/more/pages/qibla_direction/qibla_direction_map.dart';

import 'package:nour_al_quran/shared/widgets/title_row.dart';
import 'package:nour_al_quran/pages/settings/pages/app_colors/app_colors_provider.dart';
import 'package:nour_al_quran/pages/settings/pages/app_them/them_provider.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:nour_al_quran/shared/utills/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../../shared/utills/dimensions.dart';

class QiblaDirectionPage extends StatefulWidget {
  const QiblaDirectionPage({Key? key}) : super(key: key);

  @override
  State<QiblaDirectionPage> createState() => _QiblaDirectionPageState();
}

class _QiblaDirectionPageState extends State<QiblaDirectionPage>
    with SingleTickerProviderStateMixin {
  String _imagePath = 'assets/images/app_icons/qibla_campass.png';
  void _showArrowimage() {
    setState(() {
      _imagePath = 'assets/images/app_icons/qiblaa_arrow.png';
    });
  }

  void _showQiblaImage() {
    setState(() {
      _imagePath = 'assets/images/app_icons/qibla_campass.png';
    });
  }

  Animation<double>? animation;
  AnimationController? _animationController;
  double begin = 0.0;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    animation = Tween(begin: 0.0, end: 0.0).animate(_animationController!);
    print(Dimensions.width);
    super.initState();
  }

  @override
  dispose() {
    _animationController!.dispose();
    FlutterQiblah().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
          context: context, title: localeText(context, "qibla_direction")),
      body: Consumer3<QiblaProvider, AppColorsProvider, ThemProvider>(
        builder: (context, qibla, appColors, them, child) {
          var textStyle = TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: 'satoshi',
              fontSize: 14.sp,
              color: them.isDark ? AppColors.grey6 : AppColors.grey2);
          return SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(right: 20.w, left: 20.w),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 60.h, // Set height of the tab buttons
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _showQiblaImage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.r),
                                  bottomLeft: Radius.circular(8.r),
                                ),
                                side: BorderSide(
                                    color: appColors.mainBrandingColor),
                              ),
                            ),
                            child: Text(
                              'Compass',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'satoshi',
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _showArrowimage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                                side: BorderSide(
                                    color: appColors.mainBrandingColor),
                              ),
                            ),
                            child: Text(
                              'Arrow',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'satoshi',
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => QiblahMaps()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(8.r),
                                  topRight: Radius.circular(8.r),
                                ),
                                side: BorderSide(
                                    color: appColors.mainBrandingColor),
                              ),
                            ),
                            child: Text(
                              'Map',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'satoshi',
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    padding: EdgeInsets.only(top: 14.h, bottom: 14.h),
                    decoration: BoxDecoration(
                        color: them.isDark ? AppColors.darkColor : Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: const [
                          BoxShadow(
                              offset: Offset(0, 5),
                              blurRadius: 15,
                              color: Color.fromRGBO(0, 0, 0, 0.08))
                        ]),
                    child: Row(
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 17.w, right: 22.w),
                            child: Image.asset(
                              'assets/images/app_icons/send.png',
                              height: 15.h,
                              width: 15.h,
                              color: appColors.mainBrandingColor,
                            )),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Dimensions.width < 330
                                  ? qibla.address.substring(
                                      0,
                                      qibla.address.contains(",")
                                          ? qibla.address.indexOf(",")
                                          : 15)
                                  : qibla.address,
                              style: TextStyle(
                                color: them.isDark
                                    ? AppColors.grey6
                                    : AppColors.grey2,
                                fontFamily: 'satoshi',
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Text(
                              localeText(context, 'your_current_location'),
                              style: TextStyle(
                                  color: them.isDark
                                      ? AppColors.grey5
                                      : AppColors.grey3,
                                  fontFamily: 'satoshi',
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  StreamBuilder(
                      stream: FlutterQiblah.qiblahStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final qiblaDirection = snapshot.data;
                          int degree = qiblaDirection!.offset.toInt();
                          animation = Tween(
                                  begin: begin,
                                  end:
                                      (qiblaDirection.qiblah) * (pi / 180) * -1)
                              .animate(_animationController!);
                          begin = (qiblaDirection.qiblah * (pi / 180) * -1);
                          _animationController!.forward(from: 0);
                          return Column(
                            children: [
                              Container(
                                margin:
                                    EdgeInsets.only(top: 40.h, bottom: 10.h),
                                child: AnimatedBuilder(
                                  animation: animation!,
                                  builder: (context, child) {
                                    return Transform.rotate(
                                      angle: animation!.value,
                                      child: Image.asset(
                                        _imagePath,
                                        height: 294.h,
                                        width: 284.w,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      localeText(
                                          context, "degree_of_the_qibla"),
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          fontFamily: 'satoshi',
                                          fontWeight: FontWeight.w700)),
                                  Container(
                                    height: 34.h,
                                    width: 34.w,
                                    alignment: Alignment.center,
                                    margin:
                                        EdgeInsets.only(left: 9.w, right: 9.w),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(4.r),
                                        color: Colors.green),
                                    child: Text(
                                      degree.toString(),
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.white,
                                          fontFamily: 'satoshi',
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          return Container(
                              margin: EdgeInsets.all(20.h),
                              child: CircularProgressIndicator(
                                color: them.isDark
                                    ? Colors.white
                                    : appColors.mainBrandingColor,
                              ));
                        }
                      }),
                  Container(
                    margin: EdgeInsets.only(top: 24.h, bottom: 24.h),
                    padding: EdgeInsets.only(
                        left: 13.w, right: 13.w, top: 13.h, bottom: 12.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: them.isDark ? AppColors.darkColor : Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              offset: Offset(0, 5),
                              blurRadius: 15,
                              color: Color.fromRGBO(0, 0, 0, 0.08))
                        ]),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              localeText(context, 'distance_to_qibla'),
                              style: textStyle,
                            ),
                            Text(
                              '${qibla.qiblaDistance} ${localeText(context, "km")}',
                              style: textStyle,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              localeText(context, 'longitude'),
                              style: textStyle,
                            ),
                            Text(
                              qibla.lng.toString(),
                              style: textStyle,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              localeText(context, 'latitude'),
                              style: textStyle,
                            ),
                            Text(
                              qibla.lat.toString(),
                              style: textStyle,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  // BrandButton(text: "Switch to 3D VIEW",onTap: (){},)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
