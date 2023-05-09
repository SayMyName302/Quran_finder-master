import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/database/home_db.dart';
import '../../../../shared/localization/localization_constants.dart';
import '../../../../shared/localization/localization_provider.dart';
import '../../../../shared/routes/routes_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'miracles.dart';

class MiraclesOfQuranProvider extends ChangeNotifier {
  List<Miracles> _miracles = [];
  List<Miracles> get miracles => _miracles;
  Miracles? _selectedMiracle;
  Miracles? get selectedMiracle => _selectedMiracle;
  File? _videoUrl;
  File? get videoUrl => _videoUrl;
  int currentMiracle = 0;
  double downloaded = 0;

  Future<void> getMiracles() async {
    _miracles = await HomeDb().getMiracles();
    notifyListeners();
  }

  Future<void> checkVideoAvailable(
      String miracleTitle, BuildContext context) async {
    currentMiracle =
        _miracles.indexWhere((element) => element.title == miracleTitle);
    _selectedMiracle = _miracles[currentMiracle];
    notifyListeners();
    var directory = await getApplicationDocumentsDirectory();
    var miracleVideoFolder = "${directory.path}/miraclesVideoFolder";
    if (!Directory(miracleVideoFolder).existsSync()) {
      Directory(miracleVideoFolder).createSync();
    }
    var audioPath = File("$miracleVideoFolder/$miracleTitle.mp4");
    if (audioPath.existsSync()) {
      setVideoFile(audioPath);
      Future.delayed(Duration.zero, () {
        goToMiracleDetailsPage(_selectedMiracle!.title!, context);
      });
    } else {
      Future.delayed(Duration.zero, () => downloadStoryAudio(context));
    }
  }

  Future<void> downloadStoryAudio(BuildContext context) async {
    try {
      CancelToken cancelToken = CancelToken();
      showDownloadingDialog(context, cancelToken);
      Dio dio = Dio();
      var response = await dio.get(_selectedMiracle!.videoUrl!,
          onReceiveProgress: (receive, total) {
        downloaded = (receive / total) * 100;
        notifyListeners();
        print(downloaded);
      },
          options: Options(responseType: ResponseType.bytes),
          cancelToken: cancelToken);
      if (response.statusCode == 200) {
        downloaded = 0;
        notifyListeners();
        var file = <int>[];
        file.addAll(response.data);
        var directory = await getApplicationDocumentsDirectory();
        var storiesAudioFolder = "${directory.path}/miraclesVideoFolder";
        if (!Directory(storiesAudioFolder).existsSync()) {
          Directory(storiesAudioFolder).createSync();
        }
        String filePath = "$storiesAudioFolder/${_selectedMiracle!.title}.mp4";
        File(filePath).writeAsBytes(file).then((value) {
          Navigator.of(context).pop();
          setVideoFile(value);
          Future.delayed(Duration.zero,
              () => goToMiracleDetailsPage(_selectedMiracle!.title!, context));
        });
      }
    } on DioError {
      downloaded = 0;
      notifyListeners();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error")));
    } catch (e) {
      downloaded = 0;
      notifyListeners();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error")));
    }
  }

  void setVideoFile(File video) {
    _videoUrl = video;
    notifyListeners();
  }

  Future<void> showDownloadingDialog(
    BuildContext context,
    CancelToken cancelToken,
  ) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            cancelToken.cancel();
            return true;
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r)),
            content: Consumer<MiraclesOfQuranProvider>(
              builder: (context, value, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      alignment: LocalizationProvider().locale.languageCode ==
                                  "ur" ||
                              LocalizationProvider().locale.languageCode == "ar"
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(),
                          SizedBox(
                            width: 10.h,
                          ),
                          Text(localeText(context, "please_wait"))
                        ],
                      ),
                    ),
                    Text("${value.downloaded.toInt().toString()}/100")
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  void goToMiracleDetailsPage(String title, BuildContext context) {
    Navigator.of(context).pushNamed(RouteHelper.miraclesDetails);
  }
}
