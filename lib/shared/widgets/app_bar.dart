import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/settings/settings_page.dart';
import 'package:nour_al_quran/pages/sign_in/pages/sigin_page.dart';
import 'package:nour_al_quran/shared/widgets/title_text.dart';

import '../../pages/bottom_tabs/provider/bottom_tabs_page_provider.dart';
import '../../pages/more/pages/salah_timer/salah_timer_settings.dart';

AppBar buildAppBar(
    {String? title,
    required BuildContext context,
    double? font,
    String? icon}) {
  return AppBar(
    centerTitle: true,
    elevation: 0.0,
    backgroundColor: Colors.transparent,
    title: TitleText(
      title: title!,
      fontSize: font ?? 22.sp,
    ),
    actions: [
      icon != null
          ? IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SalahTimerSetting()));
              },
              icon: ImageIcon(
                const AssetImage('assets/images/app_icons/settings.png'),
                size: 16.5.h,
              ))
          : const SizedBox.shrink(),
    ],
  );
}

AppBar buildQaidaAppBar({
  String? title,
  required BuildContext context,
  double? font,
  String? icon,
  bool showBackButton = false,
  required BottomTabsPageProvider bottomTabProvider,
}) {
  return AppBar(
    centerTitle: true,
    elevation: 0.0,
    backgroundColor: Colors.transparent,
    leading: showBackButton
        ? IconButton(
            onPressed: () {
              onBackPressed(context, bottomTabProvider);
            },
            icon: const Icon(Icons.arrow_back_outlined),
          )
        : null,
    title: TitleText(
      title: title!,
      fontSize: font ?? 22.sp,
    ),
    actions: [
      icon != null
          ? IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SalahTimerSetting(),
                ));
              },
              icon: ImageIcon(
                const AssetImage('assets/images/app_icons/settings.png'),
                size: 16.5.h,
              ),
            )
          : const SizedBox.shrink(),
    ],
  );
}

AppBar appbarformanageprofile(
    {String? title,
    required BuildContext context,
    double? font,
    String? icon}) {
  return AppBar(
    centerTitle: true,
    elevation: 0.0,
    backgroundColor: Colors.transparent,
    title: TitleText(
      title: title!,
      fontSize: 18.sp,
    ),
    actions: [
      icon != null
          ? IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SettingsPage()));
              },
              icon: ImageIcon(
                const AssetImage('assets/images/app_icons/settings.png'),
                size: 16.5.h,
              ))
          : const SizedBox.shrink(),
    ],
  );
}

AppBar showdegree(
    {String? title,
    required BuildContext context,
    double? font,
    String? icon,
    String? degree}) {
  return AppBar(
    centerTitle: true,
    elevation: 0.0,
    backgroundColor: Colors.transparent,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title!),
        if (degree != null)
          Padding(
            padding: const EdgeInsets.only(right: 52.0),
            child: Text(degree),
          ),
      ],
    ),
    actions: [
      icon != null
          ? IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SalahTimerSetting()));
              },
              icon: ImageIcon(
                const AssetImage('assets/images/app_icons/settings.png'),
                size: 16.5.h,
              ))
          : const SizedBox.shrink(),
    ],
  );
}

AppBar buildpaywallappbar(
    {String? title,
    required BuildContext context,
    double? font,
    String? icon}) {
  return AppBar(
    automaticallyImplyLeading: false,
    centerTitle: true,
    elevation: 0.0,
    backgroundColor: Colors.transparent,
    title: TitleText(
      title: title!,
      fontSize: font ?? 22.sp,
    ),
    actions: [
      icon != null
          ? IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SignInPage()));
              },
              icon: ImageIcon(
                const AssetImage('assets/images/app_icons/close.png'),
                size: 16.5.h,
              ))
          : const SizedBox.shrink(),
    ],
  );
}

void onBackPressed(
    BuildContext context, BottomTabsPageProvider bottomTabProvider) {
  if (bottomTabProvider.currentPage != 0) {
    bottomTabProvider.setCurrentPage(0); // Set the initial page to page 1
    bottomTabProvider
        .setBottomTabVisibility(true); // Show the BottomNavigationBar
  } else {
    Navigator.of(context).pop();
  }
}
