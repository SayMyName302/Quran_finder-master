// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nour_al_quran/pages/home/models/friday_content.dart';
import 'package:nour_al_quran/pages/you_may_also_like/models/youmaylike_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import 'package:nour_al_quran/shared/database/home_db.dart';
import 'package:nour_al_quran/shared/routes/routes_helper.dart';

import '../../../main.dart';
import '../../featured/provider/featured_provider.dart';
import '../models/miracles.dart';

class MiraclesOfQuranProvider extends ChangeNotifier {
  List<Miracles> _miracles = [];
  List<Miracles> _featureMiraclesList = [];
  List<Friday> _friday = [];
  List<Friday> get friday => _friday;
  SharedPreferences? _preferences;
  List<Miracles> get miracles => _miracles;
  Miracles? _selectedMiracle;
  Miracles? get selectedMiracle => _selectedMiracle;

  Friday? _selectedFriday;
  Friday? get selectedFriday => _selectedFriday;
  File? _videoUrl;
  File? get videoUrl => _videoUrl;
  int currentMiracle = 0;
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  set isPlaying(bool newValue) {
    _isPlaying = newValue;
    notifyListeners();
  }

  getMiracles() async {
    _miracles = await HomeDb().getMiracles();
    _ymal = await HomeDb().getYouMayLike();

    Friday fridayItem = await HomeDb().fridayFilter();
    _friday = [];
    _friday.add(fridayItem);
    _featureMiraclesList = await HomeDb().getFeatured3();
    _loadMiraclesOrder();
    notifyListeners();
    Provider.of<FeatureProvider>(navigatorKey.currentContext!, listen: false)
        .updateFridayList(_friday);
  }

  List<YouMayAlsoLikeModel> _ymal = [];
  List<YouMayAlsoLikeModel> get ymal => _ymal;
  YouMayAlsoLikeModel? _selectedymal;
  YouMayAlsoLikeModel? get selectedymal => _selectedymal;

  void goToMiracleDetailsPageY(String title, BuildContext context, int index) {
    int miracleIndex = _ymal.indexWhere((element) => element.title == title);
    _selectedymal = _ymal[miracleIndex];
    notifyListeners();
    Navigator.of(context)
        .pushNamed(RouteHelper.miraclesDetails, arguments: _ymal);
    //_moveMiracleToEnd(index);
  }

  MiraclesOfQuranProvider() {
    _initSharedPreferences();
  }
  Future<void> _initSharedPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  void gotoMiracleDetailsPage(String title, BuildContext context, int index) {
    // _selectedFriday =
    //     _friday.firstWhere((friday) => friday.recitationId == index);
    int fridayIndex = _friday.indexWhere((element) => element.title == title);
    _selectedFriday = _friday[fridayIndex];
    notifyListeners();
    Navigator.of(context)
        .pushNamed(RouteHelper.miraclesDetails, arguments: _selectedFriday);
  }

  void goToMiracleDetailsPage(String title, BuildContext context, int index) {
    _selectedMiracle = _miracles[index];
    notifyListeners();
    Navigator.of(context)
        .pushNamed(RouteHelper.miraclesDetails, arguments: _selectedMiracle);
    _moveMiracleToEnd(index);
  }

  void goToMiracleDetailsPageFromFeatured(
      String title, BuildContext context, int index) {
    int miracleIndex =
    _featureMiraclesList.indexWhere((element) => element.title == title);
    _selectedMiracle = _featureMiraclesList[miracleIndex];
    notifyListeners();
    Navigator.of(context).pushNamed(RouteHelper.miraclesDetails);
    //_moveMiracleToEnd(index);
  }

  void goToMiracleDetailsPageFromPopular(
      String title, BuildContext context, int index) {
    int miracleIndex =
    _featureMiraclesList.indexWhere((element) => element.title == title);
    _selectedMiracle = _featureMiraclesList[miracleIndex];
    notifyListeners();
    Navigator.of(context).pushNamed(RouteHelper.miraclesDetails);
    //_moveMiracleToEnd(index);
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
      Future.delayed(Duration.zero, () {
        controller = VideoPlayerController.networkUrl(
          Uri.parse(_selectedMiracle!.videoUrl!),
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
      });
    } on PlatformException catch (e) {
      Future.delayed(Duration.zero, () {
        setNetworkError(true);
      });
      // setNetworkError(true);
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      Future.delayed(Duration.zero, () {
        setNetworkError(true);
      });
      // setNetworkError(true);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  //initForFriday
  void initVideoPlayerF() async {
    try {
      Future.delayed(Duration.zero, () {
        controller = VideoPlayerController.networkUrl(
          Uri.parse(_selectedFriday!.contentUrl!),
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
      });
    } on PlatformException catch (e) {
      Future.delayed(Duration.zero, () {
        setNetworkError(true);
      });
      // setNetworkError(true);
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      Future.delayed(Duration.zero, () {
        setNetworkError(true);
      });
      // setNetworkError(true);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void initVideoPlayerY() async {
    try {
      Future.delayed(Duration.zero, () {
        print('URL >>>${_selectedymal!.contentUrl!}');
        controller = VideoPlayerController.networkUrl(
          Uri.parse(_selectedymal!.contentUrl!),
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
      });
    } on PlatformException catch (e) {
      Future.delayed(Duration.zero, () {
        setNetworkError(true);
      });
      // setNetworkError(true);
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      Future.delayed(Duration.zero, () {
        setNetworkError(true);
      });
      // setNetworkError(true);
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
    Future.delayed(const Duration(milliseconds: 300), () {
      final selectedMiracle = _miracles.removeAt(index);
      _miracles.add(selectedMiracle);
      notifyListeners();
      _saveMiraclesOrder();
    });
  }

  void _saveMiraclesOrder() {
    final List<String> order =
    _miracles.map((miracle) => miracle.title!).toList();
    _preferences?.setStringList('miracles_order', order);
  }

  void _loadMiraclesOrder() {
    final List<String>? order = _preferences?.getStringList('miracles_order');
    if (order != null && order.isNotEmpty) {
      // Add a check for non-empty order
      final List<Miracles> sortedMiracles = [];
      for (final title in order) {
        final miracle = _miracles.firstWhere(
              (m) => m.title == title,
        );
        sortedMiracles.add(miracle);
      }
      _miracles = sortedMiracles;
      notifyListeners();
    }
  }

  void favoriteMiraclesDetailsPage(String s, BuildContext context, int index) {}

/// logic to download Video From Internet
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