import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/settings/pages/app_them/them_provider.dart';
import 'package:nour_al_quran/shared/utills/app_colors.dart';
import 'package:nour_al_quran/shared/widgets/circle_button.dart';
import 'package:provider/provider.dart';

import '../../settings/pages/app_colors/app_colors_provider.dart';

class DetailsContainerWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final String? imageIcon;
  final IconData icon;
  final VoidCallback? onTapIcon;
  const DetailsContainerWidget(
      {Key? key,
      required this.title,
      required this.subTitle,
      required this.icon,
      this.imageIcon = "",
      this.onTapIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDark = context.read<ThemProvider>().isDark;

    return Container(
      margin: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        bottom: 8.h,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: isDark ? AppColors.grey3 : AppColors.grey5,
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10.w, right: 10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp,
                        fontFamily: "satoshi",
                        color: isDark ? AppColors.grey5 : AppColors.grey2),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      subTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: "satoshi",
                          color: isDark ? AppColors.grey3 : AppColors.grey4),
                    ),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: onTapIcon,
            child: Container(
              margin: EdgeInsets.only(
                  right: 10.h, top: 17.h, bottom: 16.h, left: 10.w),
              child: CircleButton(
                  height: 21.h,
                  width: 21.h,
                  icon: imageIcon == ""
                      ? Icon(
                          icon,
                          size: 9.h,
                          color: Colors.white,
                        )
                      : ImageIcon(
                          AssetImage(imageIcon!),
                          size: 9.h,
                          color: Colors.white,
                        )),
            ),
          )
        ],
      ),
    );
  }
}

class DetailsContainerWidget1 extends StatelessWidget {
  final int index;
  final String title;
  final String subTitle;
  final String? imageIcon;
  final IconData icon;
  final VoidCallback? onTapIcon;
  const DetailsContainerWidget1(
      {Key? key,
      required this.index,
      required this.title,
      required this.subTitle,
      required this.icon,
      this.imageIcon = "",
      this.onTapIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDark = context.read<ThemProvider>().isDark;
    final appcolor = Provider.of<AppColorsProvider>(context);
    //   final bottomTabProvider = Provider.of<BottomTabsPageProvider>(context);

    return Container(
      margin: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        bottom: 8.h,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: isDark ? AppColors.grey3 : AppColors.grey5,
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
            child: CircleAvatar(
              radius: 17,
              backgroundColor: appcolor.mainBrandingColor,
              child: Container(
                width: 25,
                height: 25,
                alignment: Alignment.center,
                child: Text(
                  index.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10.w, right: 10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp,
                        fontFamily: "satoshi",
                        color: isDark ? AppColors.grey5 : AppColors.grey2),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      subTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: "satoshi",
                          color: isDark ? AppColors.grey3 : AppColors.grey4),
                    ),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: onTapIcon,
            child: Container(
              margin: EdgeInsets.only(
                  right: 10.h, top: 17.h, bottom: 16.h, left: 10.w),
              child: CircleButton(
                  height: 21.h,
                  width: 21.h,
                  icon: imageIcon == ""
                      ? Icon(
                          icon,
                          size: 9.h,
                          color: Colors.white,
                        )
                      : ImageIcon(
                          AssetImage(imageIcon!),
                          size: 9.h,
                          color: Colors.white,
                        )),
            ),
          )
        ],
      ),
    );
  }
}
