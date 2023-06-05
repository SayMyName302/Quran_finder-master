import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/localization/localization_constants.dart';
import '../../../../shared/widgets/app_bar.dart';
//import '../quran/providers/quran_provider.dart';
import '../quran/pages/ruqyah/ruqyah_categories_page.dart';
import '../settings/pages/app_colors/app_colors_provider.dart';
import 'dua_categories_page.dart';

class DuaCategoriesMain extends StatelessWidget {
  const DuaCategoriesMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appColors = context.read<AppColorsProvider>().mainBrandingColor;
    return Scaffold(
      appBar: buildAppBar(context: context, title: localeText(context, "dua")),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              indicatorColor: appColors,
              tabs: const [
                Tab(text: 'Dua'),
                Tab(text: 'Al-Ruqyah'),
              ],
            ),
            Expanded(
                child: TabBarView(
              children: [
                Column(
                  children: const [
                    Expanded(
                      child: DuaCategoriesPage(),
                    ),
                  ],
                ),
                Column(
                  children: const [
                    Expanded(
                      child: RuqyahCategoriesPage(),
                    ),
                  ],
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
