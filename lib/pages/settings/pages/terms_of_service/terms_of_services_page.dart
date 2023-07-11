import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/app_bar.dart';
import '../about_the_app/provider/about_provider.dart';

class TermsOfServicesPage extends StatelessWidget {
  const TermsOfServicesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context: context,
        title: localeText(context, "terms_&_conditions"),
      ),
      body: Consumer<AboutProvider>(
        builder: (context, about, child) {
          final appInfo = about.appInfo;
          final termsText =
              appInfo.isNotEmpty ? appInfo[0].termsandcondText : null;
          return termsText != null
              ? Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        HtmlWidget(termsText),
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
