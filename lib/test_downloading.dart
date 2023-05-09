import 'dart:io';

import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'shared/providers/download_provider.dart';
import 'shared/utills/app_colors.dart';

class DownloadButton extends StatefulWidget {
  @override
  _DownloadButtonState createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  int progress = 0;

  void checkDownloadComplete() async {
    final savedDir = await getApplicationDocumentsDirectory();
    final targetPath = "${savedDir.path}/rashid/001.zip";
    if (await File(targetPath).exists()) {
      // Decode the Zip file.
      final archive =
          ZipDecoder().decodeBytes(File(targetPath).readAsBytesSync());

      // Extract the contents of the Zip archive to disk.
      final surahDirectory = "${savedDir.path}/rashid/001";
      if (!Directory(surahDirectory).existsSync()) {
        Directory(surahDirectory).createSync();
      }

      for (final file in archive) {
        final filePath = '$surahDirectory/${file.name}';
        if (file.isFile) {
          final data = file.content as List<int>;
          final f = File(filePath);
          f.createSync(recursive: true);
          f.writeAsBytesSync(data);
        } else {
          final dir = Directory(filePath);
          dir.createSync(recursive: true);
        }
      }

      // Delete the original Zip file.
      File(targetPath).delete().then((value) {});
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DownloadProvider>(
      builder: (context, value, child) {
        return value.isDownloading
            ? SliderTheme(
                data: const SliderThemeData(
                    thumbColor: AppColors.mainBrandingColor,
                    activeTrackColor: AppColors.mainBrandingColor,
                    inactiveTrackColor: AppColors.lightBrandingColor,
                    thumbShape: RoundSliderThumbShape(
                      elevation: 0.0,
                      enabledThumbRadius: 3,
                    )),
                child: SliderTheme(
                  data: const SliderThemeData(
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 1)),
                  child: Slider(
                    value: value.downloadProgress,
                    min: 0.0,
                    max: 1.0,
                    onChanged: null,
                  ),
                ),
              )
            : ElevatedButton(
                onPressed: _downloadAndExtractZip,
                child: const Text('Download'),
              );
      },
    );
  }

  Future<void> _downloadAndExtractZip() async {
    context.read<DownloadProvider>().setDownloading(true);
    const url = 'https://everyayah.com/data/Alafasy_64kbps/zips/001.zip';

    try {
      final dio = Dio();
      final response = await dio.get(
        url,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = received / total;
            context.read<DownloadProvider>().setDownloadProgress(progress);
          }
        },
        options: Options(responseType: ResponseType.bytes),
      );
      var file = <int>[];
      file.addAll(response.data);
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        var reciterNameDirectory = "${directory.path}/rashid";
        var filePath = "$reciterNameDirectory/001.zip";

        // Create parent directory if it doesn't exist.
        if (!Directory(reciterNameDirectory).existsSync()) {
          Directory(reciterNameDirectory).createSync();
        }

        File(filePath).writeAsBytesSync(file);

        // Decode the Zip file.
        final archive = ZipDecoder().decodeBytes(file);

        // Extract the contents of the Zip archive to disk.
        final surahDirectory = "$reciterNameDirectory/001";
        if (!Directory(surahDirectory).existsSync()) {
          Directory(surahDirectory).createSync();
        }

        for (final file in archive) {
          final filePath = '$surahDirectory/${file.name}';
          if (file.isFile) {
            final data = file.content as List<int>;
            final f = File(filePath);
            f.createSync(recursive: true);
            f.writeAsBytesSync(data);
          } else {
            final dir = Directory(filePath);
            dir.createSync(recursive: true);
          }
        }

        // Delete the original Zip file.
        File(filePath).delete().then((value) {});
        context.read<DownloadProvider>().setDownloading(false);
      }
    } catch (e) {
      // Handle the internet error.
      context.read<DownloadProvider>().setDownloading(false);
      print("Error: $e");
    }
  }
}
