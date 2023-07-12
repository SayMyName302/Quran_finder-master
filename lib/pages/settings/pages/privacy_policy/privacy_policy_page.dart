import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:nour_al_quran/shared/widgets/title_row.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/app_bar.dart';
import '../about_the_app/provider/about_provider.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
          context: context, title: localeText(context, "privacy_policy")),
      body: Consumer<AboutProvider>(
        builder: (context, about, child) {
          final appInfo = about.appInfo;
          final privacyText =
              appInfo.isNotEmpty ? appInfo[0].termsandcondText : null;
          return privacyText != null
              ? Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        HtmlWidget(privacyText),
                        const SizedBox(height: 20.0)
                      ],
                    ),
                  ),
                )
              : const Text('No information available');
        },
      ),
    );
  }
}
