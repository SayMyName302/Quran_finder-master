import 'package:flutter/material.dart';
import 'package:nour_al_quran/pages/featured/models/featured.dart';
import 'package:nour_al_quran/pages/featured/provider/featured_provider.dart';
import 'package:nour_al_quran/pages/featured/provider/featurevideoProvider.dart';
import 'package:nour_al_quran/pages/featured/widgets/feature_videocontent.dart';
import 'package:nour_al_quran/pages/miracles_of_quran/widgets/miracles_content_text.dart';
import 'package:nour_al_quran/pages/miracles_of_quran/widgets/video_player_container.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../settings/pages/notifications/notification_services.dart';

class favoriteMiraclesDetailsPage extends StatefulWidget {
  const favoriteMiraclesDetailsPage({Key? key}) : super(key: key);

  @override
  State<favoriteMiraclesDetailsPage> createState() =>
      _favoriteMiraclesDetailsPageState();
}

class _favoriteMiraclesDetailsPageState
    extends State<favoriteMiraclesDetailsPage> {
  @override
  void initState() {
    super.initState();
    //  NotificationServices().showNotification();
    Provider.of<FeatureVideoProvider>(context, listen: false).initVideoPlayer();
  }

  @override
  Widget build(BuildContext context) {
    FeaturedModel featuretitle =
        context.read<FeatureVideoProvider>().selectedFeatureStory!;
    return WillPopScope(
      onWillPop: () async {
        Provider.of<FeatureVideoProvider>(context, listen: false)
            .controller
            .dispose();
        return true;
      },
      child: Scaffold(
        appBar: buildAppBar(
            context: context,
            title: localeText(context, featuretitle.storyTitle!.toLowerCase())),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: const [
            VideoPlayerContainer(),
            FeaturedMiraclesContentText(),
          ],
        ),
      ),
    );
  }

  // checkNetwork() async{
  //   final Connectivity connectivity = Connectivity();
  //   ConnectivityResult connectivityResult = await connectivity.checkConnectivity();
  //   connectivity.onConnectivityChanged.listen((ConnectivityResult result) async{
  //     connectivityResult = result;
  //     if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
  //       Future.delayed(const Duration(seconds: 2),(){
  //         NetworksCheck(
  //             onComplete: (){
  //               print(callOnce);
  //               if(!callOnce){
  //                 print("===========================");
  //                 _initVideoPlayer();
  //                 callOnce = true;
  //               }
  //             },
  //             onError: (){
  //               callOnce = false;
  //               Fluttertoast.showToast(msg: NetworksCheck().error!);
  //             }
  //         ).doRequest();
  //       });
  //
  //     }
  //   });
  // }
  //
  // void _initVideoPlayer() async {
  //   try{
  //     // context.read<MiraclesOfQuranProvider>().selectedMiracle!.videoUrl!
  //     _controller = VideoPlayerController.network(
  //         context.read<MiraclesOfQuranProvider>().selectedMiracle!.videoUrl!,
  //         httpHeaders: {
  //           'Range': 'bytes=1000', // Specify the byte range you want to load
  //         }
  //     )
  //       ..initialize().then((_) {
  //         setState(() {
  //           if(lastPosition != Duration.zero){
  //             _controller.seekTo(lastPosition);
  //           }
  //         });
  //       })..addListener(() async{
  //         // setState(() {
  //         //   isBuffering = _controller.value.isBuffering;
  //         // });
  //         if(_controller.value.hasError){
  //           // Fluttertoast.showToast(msg: _controller.value.errorDescription!);
  //           _controller.pause();
  //           lastPosition = (await _controller.position)!;
  //           checkNetwork();
  //         }
  //       });
  //   }catch(e){
  //     Fluttertoast.showToast(msg: e.toString());
  //   }
  // }
}
