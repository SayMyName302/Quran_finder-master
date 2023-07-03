// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nour_al_quran/pages/featured/models/featured.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import 'package:nour_al_quran/shared/database/home_db.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:nour_al_quran/shared/localization/localization_provider.dart';
import 'package:nour_al_quran/shared/routes/routes_helper.dart';

class FeatureVideoProvider extends ChangeNotifier {
  List<FeaturedModel> _feature = [];
  SharedPreferences? _preferences;
  List<FeaturedModel> get feature => _feature;
  FeaturedModel? _selectedFeatureStory;
  FeaturedModel? get selectedFeatureStory => _selectedFeatureStory;
  File? _videoUrl;
  File? get videoUrl => _videoUrl;
  int _currentFeatureIndex = 0;
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  set isPlaying(bool newValue) {
    _isPlaying = newValue;
    notifyListeners();
  }

  /// this method will get miracles from home.db
  Future<void> getMiracles() async {
    _feature = await HomeDb().getFeatured();
    _loadMiraclesOrder();
    notifyListeners();
  }

  FeatureVideoProvider() {
    _initSharedPreferences();
  }
  Future<void> _initSharedPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  void goToFeatureMiracleDetailsPage(
      String title, BuildContext context, int index) {
    _selectedFeatureStory = _feature[index];
    notifyListeners();
    Navigator.of(context).pushNamed(RouteHelper.favortiesmiraclesDetails);
    _moveMiracleToEnd(index);
  }

  void setVideoFile(File video) {
    _videoUrl = video;
    notifyListeners();
  }

  /// video player logic
  late VideoPlayerController controller;
  bool isNetworkError = false;
  Duration lastPosition = Duration.zero;
  bool isBuffering = false;

  void initVideoPlayer() async {
    try {
      controller = VideoPlayerController.network(
        _selectedFeatureStory!.videoUrl!,
      )
        ..initialize().then((_) {
          setNetworkError(false);

          /// if user internet connection lost during video
          /// so after connection resolve so user can seek to the same point of video
          if (lastPosition != Duration.zero) {
            controller.seekTo(lastPosition);
          }
          notifyListeners();
        })
        ..addListener(() async {
          /// if there will be any error so this block will trigger error and resolve error during video
          if (controller.value.hasError) {
            controller.pause();
            setNetworkError(true);
            lastPosition = (await controller.position)!;
            notifyListeners();
          }
        });
    } on PlatformException catch (e) {
      setNetworkError(true);
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      setNetworkError(true);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  setNetworkError(value) {
    isNetworkError = value;
    notifyListeners();
  }

  /// this method will play if video is pause if pause so it will play
  /// based on condition
  playVideo() {
    controller.value.isPlaying ? controller.pause() : controller.play();
    notifyListeners();
  }

  void _moveMiracleToEnd(int index) {
    Future.delayed(Duration(milliseconds: 300), () {
      _feature.removeAt(index);
      _feature.add(_selectedFeatureStory!);
      notifyListeners();
      _saveMiraclesOrder();
    });
  }

  void _saveMiraclesOrder() {
    final List<String> order =
        _feature.map((feature) => feature.storyTitle!).toList();
    _preferences?.setStringList('miracles_order', order);
  }

  void _loadMiraclesOrder() {
    final List<String>? order = _preferences?.getStringList('miracles_order');
    if (order != null && order.isNotEmpty) {
      // Add a check for non-empty order
      final List<FeaturedModel> sortedMiracles = [];
      for (final title in order) {
        final miracle = _feature.firstWhere(
          (m) => m.storyTitle == title,
        );
        if (miracle != null) {
          sortedMiracles.add(miracle);
        }
      }
      _feature = sortedMiracles;
      notifyListeners();
    }
  }

  /// login to download Video From Internet
// Future<void> checkVideoAvailable(String miracleTitle,BuildContext context) async {
//   currentMiracle = _miracles.indexWhere((element) => element.title == miracleTitle);
//   _selectedMiracle = _miracles[currentMiracle];
//   notifyListeners();
//   var directory = await getApplicationDocumentsDirectory();
//   var miracleVideoFolder = "${directory.path}/miraclesVideoFolder";
//   if(!Directory(miracleVideoFolder).existsSync()){
//     Directory(miracleVideoFolder).createSync();
//   }
//   var audioPath = File("$miracleVideoFolder/$miracleTitle.mp4");
//   if(audioPath.existsSync()){
//     setVideoFile(audioPath);
//     Future.delayed(Duration.zero,(){
//       Navigator.of(context).pushNamed(RouteHelper.miraclesDetails);
//     });
//   }else{
//     Future.delayed(Duration.zero,()=>downloadStoryAudio(context));
//   }
// }
//
// Future<void> downloadVideo(BuildContext context) async {
//   try{
//     CancelToken cancelToken = CancelToken();
//     showDownloadingDialog(context,cancelToken);
//     Dio dio = Dio();
//     var response = await dio.get(
//         _selectedMiracle!.videoUrl!,
//         onReceiveProgress: (receive,total){
//           downloaded = (receive/total)*100;
//           notifyListeners();
//         },
//         options: Options(responseType: ResponseType.bytes),
//         cancelToken: cancelToken
//     );
//     if(response.statusCode == 200){
//       var file = <int>[];
//       file.addAll(response.data);
//       var directory  = await getApplicationDocumentsDirectory();
//       var storiesAudioFolder = "${directory.path}/miraclesVideoFolder";
//       if(!Directory(storiesAudioFolder).existsSync()){
//         Directory(storiesAudioFolder).createSync();
//       }
//       String filePath = "$storiesAudioFolder/${_selectedMiracle!.title}.mp4";
//       File(filePath).writeAsBytes(file).then((value) {
//         Navigator.of(context).pop();
//         downloaded = 0;
//         notifyListeners();
//         setVideoFile(value);
//         Future.delayed(Duration.zero,()=> Navigator.of(context).pushNamed(RouteHelper.miraclesDetails));
//       });
//     }
//   }on DioError catch(e){
//     if(e.type == DioErrorType.cancel){
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Download Canceled')));
//     }else{
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error")));
//     }
//     Navigator.of(context).pop();
//     downloaded = 0;
//     notifyListeners();
//
//   }catch(e){
//     Navigator.of(context).pop();
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error")));
//     downloaded = 0;
//     notifyListeners();
//   }
// }
//
// Future<void> showDownloadingDialog(BuildContext context, CancelToken cancelToken,) async {
//   await showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (context) {
//       return WillPopScope(
//         onWillPop: ()async{
//           cancelToken.cancel();
//
//           return false;
//         },
//         child: AlertDialog(
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(6.r)
//           ),
//           content: Consumer<MiraclesOfQuranProvider>(
//             builder: (context, value, child) {
//               return Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Container(
//                     alignment: LocalizationProvider().locale.languageCode == "ur" || LocalizationProvider().locale.languageCode == "ar" ? Alignment.centerRight:Alignment.centerLeft,
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const CircularProgressIndicator(),
//                         SizedBox(width: 10.h,),
//                         Text(localeText(context, "please_wait"))
//                       ],
//                     ),
//                   ),
//                   Text("${value.downloaded.toInt().toString()}/100")
//                 ],
//               );
//             },
//           ),
//         ),
//       );
//     },);
// }
}
