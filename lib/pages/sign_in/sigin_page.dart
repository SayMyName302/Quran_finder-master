import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../shared/localization/localization_constants.dart';
import '../../shared/routes/routes_helper.dart';
import '../../shared/utills/app_colors.dart';
import '../../shared/widgets/brand_button.dart';
import '../../shared/widgets/text_field_column.dart';
import '../settings/pages/app_colors/app_colors_provider.dart';
import 'sign_in_provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var email = TextEditingController();
  var password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                Container(
                  margin: EdgeInsets.only(
                    bottom: 16.h,
                    top: 25.h,
                  ),
                  child: Text(
                    localeText(context, "login_to_get_started"),
                    style: TextStyle(
                        fontFamily: "satoshi",
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                TextFieldColumn(
                  titleText: localeText(context, "enter_your_email"),
                  controller: email,
                  hintText: localeText(context, "enter_your_email"),
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextFieldColumn(
                  titleText: localeText(context, 'password'),
                  controller: password,
                  hintText: localeText(context, 'password'),
                  isPasswordField: true,
                ),
                Container(
                    margin: EdgeInsets.only(top: 13.h, bottom: 20.h),
                    child: Text(
                      localeText(context, "forgot_password"),
                      style: TextStyle(
                          fontFamily: 'satoshi',
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                          color: AppColors.mainBrandingColor),
                    )),
                BrandButton(
                    text: localeText(context, "continue"),
                    onTap: () {
                      Provider.of<SignInProvider>(context, listen: false)
                          .signInWithEmailPassword(email.text, password.text);
                    }),
                Container(
                    margin: EdgeInsets.only(top: 16.h),
                    width: double.maxFinite,
                    child: Text(
                      localeText(context, 'or_login_using'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'satoshi',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500),
                    )),
                Container(
                  margin: EdgeInsets.only(top: 16.h, bottom: 30.h),
                  child: Row(children: [
                    _buildThirdPartyLoginContainers('facebook', () {
                      context.read<SignInProvider>().signInWithFaceBook();
                    }),
                    _buildThirdPartyLoginContainers('google', () async {
                      context.read<SignInProvider>().signInWithGoogle(context);
                    }),
                    Platform.isIOS
                        ? _buildThirdPartyLoginContainers('apple', () {
                            context.read<SignInProvider>().signInWithApple();
                          })
                        : const SizedBox.shrink(),
                  ]),
                ),
                buildRegisterOrHaveAccountContainer(
                    title:
                        localeText(context, "don't_have_an_account_register"),
                    onPress: () {
                      Navigator.of(context).pushNamed(RouteHelper.signUp);
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThirdPartyLoginContainers(String loginType, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 46.h,
          margin: EdgeInsets.only(right: 12.w),
          padding: EdgeInsets.only(top: 13.h, bottom: 13.h),
          decoration: BoxDecoration(
              color: loginType == "facebook"
                  ? AppColors.facebookColor
                  : loginType == "google"
                      ? AppColors.googleColor
                      : Colors.black,
              borderRadius: BorderRadius.circular(6.r)),
          child: Image.asset(
            'assets/images/app_icons/$loginType.png',
            height: 20.h,
            width: 20.w,
          ),
        ),
      ),
    );
  }
}

buildRegisterOrHaveAccountContainer(
    {required String title, required VoidCallback onPress}) {
  Color color =
      Provider.of<AppColorsProvider>(RouteHelper.currentContext, listen: false)
          .mainBrandingColor;
  return InkWell(
    onTap: onPress,
    child: Container(
      width: double.maxFinite,
      padding: EdgeInsets.only(top: 16.h, bottom: 15.h),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color),
      ),
      child: Text(
        title,
        style: TextStyle(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: 14.sp,
            fontFamily: 'satoshi'),
      ),
    ),
  );
}
