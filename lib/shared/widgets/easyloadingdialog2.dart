import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/settings/pages/app_colors/app_colors_provider.dart';
import 'package:provider/provider.dart';

class EasyLoadingDialog2 {
  static Future<void> show(
      {required BuildContext context,
      double? radius = 15.0,
      Widget? indicator = const CircularProgressIndicator(
        strokeWidth: 2,
        color: Colors.white,
      )}) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        var appColors = context.watch<AppColorsProvider>().mainBrandingColor;
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            backgroundColor: appColors,
            shape: const CircleBorder(),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: appColors,
                  radius: radius,
                  child: SizedBox(height: 30.h, width: 30.w, child: indicator),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void dismiss(BuildContext context) {
    Navigator.of(context).pop();
  }
}
