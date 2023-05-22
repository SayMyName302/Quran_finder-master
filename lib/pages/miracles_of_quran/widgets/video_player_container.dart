import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/miracles_of_quran/provider/miracles_of_quran_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../shared/widgets/circle_button.dart';

class VideoPlayerContainer extends StatelessWidget {
  const VideoPlayerContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int network = Provider.of<int>(context);

    return Consumer<MiraclesOfQuranProvider>(
      builder: (context, miraclesOfQuranProvider, child) {
        print(miraclesOfQuranProvider.isNetworkError);
        return Column(
          children: [
            network != 1 ? Container(
              margin: EdgeInsets.only(left: 20.w,right: 20.w),
              color: Colors.black,
              width: double.maxFinite,
              alignment: Alignment.center,
              child: const Text("No Connection",style: TextStyle(color: Colors.white),),
            ) : const SizedBox.shrink(),
            miraclesOfQuranProvider.controller.value.isInitialized ? InkWell(
              onTap: (){
                miraclesOfQuranProvider.playVideo();
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                      height: 200,
                      margin: EdgeInsets.only(left: 20.w,right: 20.w,top: 10.h),
                      width: double.maxFinite,
                      color: Colors.red,
                      child: AspectRatio(
                        aspectRatio: miraclesOfQuranProvider.controller.value.aspectRatio,
                        child: VideoPlayer(miraclesOfQuranProvider.controller),
                      )
                  ),
                  Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                          height: 15.h,
                          margin: EdgeInsets.only(left: 20.w,right: 20.w),
                          child: VideoProgressIndicator(miraclesOfQuranProvider.controller, allowScrubbing: true))),
                  Positioned(
                      left: 0,
                      right: 0,
                      child: !miraclesOfQuranProvider.controller.value.isPlaying ? CircleButton(
                        height: 50.h,
                        width: 50.h,
                        icon: const Icon(Icons.play_arrow_rounded),
                      ) : const SizedBox.shrink())
                ],
              ),
            ) : Container(
                height: 200.h,
                width: double.maxFinite,
                margin: EdgeInsets.only(left: 20.w,right: 20.w),
                color: Colors.black,
                alignment: Alignment.center,
                child: !miraclesOfQuranProvider.isNetworkError ? const CircularProgressIndicator() : InkWell(
                    onTap: (){
                      miraclesOfQuranProvider.setNetworkError(false);
                      miraclesOfQuranProvider.initVideoPlayer();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.restore,color: Colors.white,),
                        SizedBox(width: 5.w,),
                        Text("Reload",style: TextStyle(fontSize: 14.sp,color: Colors.white),),
                      ],
                    ))),
          ],
        );
      },
    );
  }
}
