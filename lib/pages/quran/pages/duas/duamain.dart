import 'package:flutter/material.dart';
import 'package:nour_al_quran/pages/quran/pages/duas/dua_categories_page.dart';
import 'package:provider/provider.dart';
import '../../../../shared/localization/localization_constants.dart';
import '../../../../shared/widgets/app_bar.dart';
import '../../../settings/pages/app_colors/app_colors_provider.dart';
import '../../providers/quran_provider.dart';

class DuaCategoriesMain extends StatelessWidget {
  const DuaCategoriesMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context: context, title: localeText(context, "dua")),
      body: Consumer2<QuranProvider, AppColorsProvider>(
          builder: (context, value, appColors, child) {
        return Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(
                child: DuaCategoriesPage(),
              ),
            ]);
      }),
    );
  }
}