import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/localization/localization_constants.dart';
import '../../../../shared/widgets/title_row.dart';
import 'package:provider/provider.dart';
import 'islam_basics.dart';
import 'islam_basics_provider.dart';

class BasicsOfQuranPage extends StatelessWidget {
  const BasicsOfQuranPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
          context: context, title: localeText(context, "islam_basics")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Consumer<IslamBasicsProvider>(
              builder: (context, islamBasicProvider, child) {
                return islamBasicProvider.islamBasics.isNotEmpty
                    ? GridView.builder(
                        padding: EdgeInsets.only(left: 20.w, right: 20.w),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: islamBasicProvider.islamBasics.length,
                        itemBuilder: (context, index) {
                          IslamBasics model =
                              islamBasicProvider.islamBasics[index];
                          return InkWell(
                            onTap: () async {
                              islamBasicProvider.checkAudioExist(
                                  model.title!, context);
                              // islamBasicProvider.goToIslamTopicPage(index, context);
                            },
                            child: Container(
                              height: 149.h,
                              margin: EdgeInsets.only(right: 9.w, bottom: 9.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  image: DecorationImage(
                                      image: AssetImage(model.image!),
                                      fit: BoxFit.cover)),
                              child: Container(
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color.fromRGBO(0, 0, 0, 0),
                                      Color.fromRGBO(0, 0, 0, 1),
                                    ],
                                    begin: Alignment.center,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Container(
                                  width: double.maxFinite,
                                  margin:
                                      EdgeInsets.only(left: 6.w, bottom: 8.h),
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    localeText(context, model.title!),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontFamily: "satoshi",
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      );
              },
            ),
          )
        ],
      ),
    );
  }
}
