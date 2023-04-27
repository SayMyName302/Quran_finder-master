import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:nour_al_quran/shared/widgets/title_text.dart';
import 'package:provider/provider.dart';

import 'quran_stories.dart';
import 'quran_stories_provider.dart';

class QuranStoriesPage extends StatelessWidget {
  const QuranStoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.only(left: 20.w, top: 60.h,bottom: 12.h,right: 20.w),
              child: TitleText(title: localeText(context, "quran_stories"),)),
          Expanded(
            child: Consumer<QuranStoriesProvider>(
              builder: (context, storiesProvider, child) {
                return storiesProvider.stories.isNotEmpty ? GridView.builder(
                  padding: EdgeInsets.only(left: 20.w,right: 20.w),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: storiesProvider.stories.length,
                  itemBuilder: (context, index) {
                    QuranStories model = storiesProvider.stories[index];
                    return InkWell(
                      onTap: (){
                        // Provider.of<StoryPlayerProvider>(context,listen: false).initPlayer(model.image!);
                        // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        //   return const StoryPlayer();
                        // },));
                        // storiesProvider.goToChaptersListPage(model.storyId!, context,model.storyTitle!);
                        storiesProvider.goToStoryDetailsPage(index,context);
                      },
                      child: Container(
                        height: 149.h,
                        margin: EdgeInsets.only(right: 9.w,bottom: 9.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            image: DecorationImage(image: AssetImage("assets/images/quran_stories/${model.image!}"),fit: BoxFit.cover)
                        ),
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
                            margin: EdgeInsets.only(left: 6.w,bottom: 8.h,right: 9.w),
                            alignment: Alignment.bottomLeft,
                            child: Text(localeText(context, model.storyTitle!.toLowerCase()),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontFamily: "satoshi",
                                  fontWeight: FontWeight.w900),),
                          ),
                        ),
                      ),
                    );
                  },
                ) : const Center(child: CircularProgressIndicator(color: Colors.red,),);
              },
            ),
          )
        ],
      ),
    );
  }
}
