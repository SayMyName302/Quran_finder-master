import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/settings/pages/app_colors/app_colors_provider.dart';
import 'package:provider/provider.dart';

class BrandButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double? height;
  const BrandButton({Key? key, required this.text, required this.onTap,this.height = 44})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Consumer<AppColorsProvider>(
        builder: (context, value, child) {
          return Container(
              height: height?.h,
              width: double.maxFinite,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  color: value.mainBrandingColor,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0,4),
                      blurRadius: 15,
                      color: Colors.black.withOpacity(0.25)
                    )
                  ]
              ),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ));
        },
      ),
    );
  }
}
