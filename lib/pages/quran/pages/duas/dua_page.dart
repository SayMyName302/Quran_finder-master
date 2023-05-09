import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dua_provider.dart';
import '../../../settings/pages/app_colors/app_colors_provider.dart';
import '../../../../shared/utills/app_colors.dart';
import '../../../../shared/widgets/dua_container.dart';
import '../../../../shared/widgets/title_text.dart';
import 'package:provider/provider.dart';

class DuaPage extends StatelessWidget {
  const DuaPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List arguments = ModalRoute.of(context)!.settings.arguments! as List;
    String title = arguments[0];
    String collectionOfDua = arguments[1];
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_outlined),
              padding: EdgeInsets.only(
                  left: 20.w, top: 13.41.h, bottom: 21.4.h, right: 20.w),
              alignment: Alignment.topLeft,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 18.h, left: 20.w, right: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleText(title: title),
                  Text(
                    collectionOfDua,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        fontFamily: "satoshi",
                        color: AppColors.grey4),
                  ),
                ],
              ),
            ),
            Consumer2<DuaProvider, AppColorsProvider>(
              builder: (context, duaValue, appColors, child) {
                return duaValue.duaList.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: duaValue.duaList.length,
                          itemBuilder: (context, index) {
                            return DuaContainer(
                              text: duaValue.duaList[index].duaText,
                              translation: duaValue.duaList[index].translations,
                              ref: duaValue.duaList[index].duaRef,
                            );
                          },
                        ),
                      )
                    : Expanded(
                        child: Center(
                        child: CircularProgressIndicator(
                          color: appColors.mainBrandingColor,
                        ),
                      ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
