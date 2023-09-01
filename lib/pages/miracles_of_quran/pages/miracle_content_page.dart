import 'package:flutter/material.dart';
import 'package:nour_al_quran/pages/miracles_of_quran/widgets/miracles_content_text.dart';
import 'package:nour_al_quran/pages/miracles_of_quran/widgets/video_player_container.dart';
import 'package:nour_al_quran/pages/you_may_also_like/models/youmaylike_model.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../home/models/friday_content.dart';
import '../models/miracles.dart';
import '../provider/miracles_of_quran_provider.dart';

class MiraclesDetailsPage extends StatefulWidget {
  const MiraclesDetailsPage({Key? key}) : super(key: key);

  @override
  State<MiraclesDetailsPage> createState() => _MiraclesDetailsPageState();
}

class _MiraclesDetailsPageState extends State<MiraclesDetailsPage> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final arguments = ModalRoute.of(context)!.settings.arguments;

      if (arguments is Map<String, dynamic> &&
          arguments["source"] == "fromMiracle") {
        Provider.of<MiraclesOfQuranProvider>(context, listen: false)
            .initVideoPlayer();
        setState(() {
          _isInitialized = true;
        });
      } else if (arguments is Map<String, dynamic> &&
          arguments["source"] == "fromFriday") {
        Provider.of<MiraclesOfQuranProvider>(context, listen: false)
            .initVideoPlayerF();
        setState(() {
          _isInitialized = true;
        });
      } else if (arguments is Map<String, dynamic> &&
          arguments["source"] == "fromYmal") {
        Provider.of<MiraclesOfQuranProvider>(context, listen: false)
            .initVideoPlayerY();
        setState(() {
          _isInitialized = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;

    Friday? selectedFriday;
    Miracles? selectedMiracle;
    YouMayAlsoLikeModel? selectedYmal;
    String title = '';

    if (arguments != null) {
      if (arguments is Map<String, dynamic> &&
          arguments["source"] == "fromFriday") {
        var friday = arguments["friday"];
        selectedFriday = friday;
        title = localeText(context, selectedFriday!.title?.toLowerCase() ?? '');
      } else if (arguments is Map<String, dynamic> &&
          arguments["source"] == "fromMiracle") {
        var miracle = arguments["miracle"];
        selectedMiracle = miracle;
        title =
            localeText(context, selectedMiracle!.title?.toLowerCase() ?? '');
      } else if (arguments is Map<String, dynamic> &&
          arguments["source"] == "fromYmal") {
        var ymal = arguments["ymal"];
        selectedYmal = ymal;
        title = localeText(context, selectedYmal!.title?.toLowerCase() ?? '');
      }
    }

    return WillPopScope(
      onWillPop: () async {
        Provider.of<MiraclesOfQuranProvider>(context, listen: false)
            .controller
            .dispose();
        return true;
      },
      child: Scaffold(
        appBar: buildAppBar(context: context, title: title),
        body: const Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            VideoPlayerContainer(),
            MiraclesContentText(),
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
