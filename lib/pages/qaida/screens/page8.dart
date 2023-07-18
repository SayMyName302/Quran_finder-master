import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../../../shared/utills/app_colors.dart';
import '../../settings/pages/app_colors/app_colors_provider.dart';

class Page8 extends StatefulWidget {
  bool isMultipleSelectionEnabled;
  final Function(bool) updateMultipleSelectionEnabled;
  Page8({
    Key? key,
    required this.isMultipleSelectionEnabled,
    required this.updateMultipleSelectionEnabled,
  }) : super(key: key);

  @override
  Page8State createState() => Page8State();
}

class Page8State extends State<Page8> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<String> _selectedAudioFiles = [];
  Set<int> _selectedContainers = {};
  List<String> audioFilePaths = [
    'assets/images/qaida/page8/00.mp3',
    'assets/images/qaida/page8/01.mp3',
    'assets/images/qaida/page8/02.mp3',
    'assets/images/qaida/page8/03.mp3',
    'assets/images/qaida/page8/04.mp3',
    'assets/images/qaida/page8/05.mp3',
    'assets/images/qaida/page8/06.mp3',
    'assets/images/qaida/page8/07.mp3',
    'assets/images/qaida/page8/08.mp3',
    'assets/images/qaida/page8/09.mp3',
    'assets/images/qaida/page8/10.mp3',
    'assets/images/qaida/page8/11.mp3',
    'assets/images/qaida/page8/12.mp3',
    'assets/images/qaida/page8/13.mp3',
    'assets/images/qaida/page8/14.mp3',
    'assets/images/qaida/page8/15.mp3',
    'assets/images/qaida/page8/16.mp3',
    'assets/images/qaida/page8/17.mp3',
    'assets/images/qaida/page8/18.mp3',
    'assets/images/qaida/page8/19.mp3',
    'assets/images/qaida/page8/20.mp3',
    'assets/images/qaida/page8/21.mp3',
    'assets/images/qaida/page8/22.mp3',
    'assets/images/qaida/page8/23.mp3',
    'assets/images/qaida/page8/24.mp3',
  ];
  Map<String, int> audioIndexMap = {
    'assets/images/qaida/page8/00.mp3': 0,
    'assets/images/qaida/page8/01.mp3': 1,
    'assets/images/qaida/page8/02.mp3': 2,
    'assets/images/qaida/page8/03.mp3': 3,
    'assets/images/qaida/page8/04.mp3': 4,
    'assets/images/qaida/page8/05.mp3': 5,
    'assets/images/qaida/page8/06.mp3': 6,
    'assets/images/qaida/page8/07.mp3': 7,
    'assets/images/qaida/page8/08.mp3': 8,
    'assets/images/qaida/page8/09.mp3': 9,
    'assets/images/qaida/page8/10.mp3': 10,
    'assets/images/qaida/page8/11.mp3': 11,
    'assets/images/qaida/page8/12.mp3': 12,
    'assets/images/qaida/page8/13.mp3': 13,
    'assets/images/qaida/page8/14.mp3': 14,
    'assets/images/qaida/page8/15.mp3': 15,
    'assets/images/qaida/page8/16.mp3': 16,
    'assets/images/qaida/page8/17.mp3': 17,
    'assets/images/qaida/page8/18.mp3': 18,
    'assets/images/qaida/page8/19.mp3': 19,
    'assets/images/qaida/page8/20.mp3': 20,
    'assets/images/qaida/page8/21.mp3': 21,
    'assets/images/qaida/page8/22.mp3': 22,
    'assets/images/qaida/page8/23.mp3': 23,
    'assets/images/qaida/page8/24.mp3': 24,
  };
  int? _startIndex;
  int? _endIndex;

  List<bool> containerAudioPlayingStates = List.generate(25, (_) => false);
  int currentlyPlayingIndex = -1;

  void playSingleAudio(int index) async {
    if (containerAudioPlayingStates[index]) {
      await _audioPlayer.stop();
      setState(() {
        containerAudioPlayingStates[index] = false;
      });
    } else {
      final String audioPath = audioFilePaths[index];

      if (_audioPlayer.playing) {
        await _audioPlayer.stop();
      }

      await _audioPlayer.setAsset(audioPath);

      _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            containerAudioPlayingStates[index] = false;
            if (currentlyPlayingIndex == index) {
              currentlyPlayingIndex = -1;
            }
          });
        }
      });

      setState(() {
        if (currentlyPlayingIndex != -1) {
          containerAudioPlayingStates[currentlyPlayingIndex] = false;
        }
        containerAudioPlayingStates[index] = true;
        currentlyPlayingIndex = index;
      });

      await _audioPlayer.play();
    }
  }

  void updateCurrentlyPlayingIndex(int index) {
    setState(() {
      currentlyPlayingIndex = index;
    });
  }

  void _toggleSelection(int index, String filePath) {
    if (_startIndex != null && _endIndex != null) {
      _selectedContainers.clear();
      _selectedAudioFiles.clear();
      _startIndex = null;
      _endIndex = null;
      AudioListHolder8.audioList.clear();
      widget.isMultipleSelectionEnabled = false;

      widget.updateMultipleSelectionEnabled(false);
    } else if (_startIndex == null) {
      _selectedContainers.clear();
      _selectedAudioFiles.clear();
      _selectedContainers.add(index);
      _startIndex = index;
    } else {
      _selectedContainers.clear();
      _selectedAudioFiles.clear();
      int start = _startIndex!;
      int end = index;
      for (int i = start; i <= end; i++) {
        _selectedContainers.add(i);
      }
      _endIndex = index;
      List<String> selectedAudioFiles = [];
      for (int i = start; i <= end; i++) {
        selectedAudioFiles.add(audioFilePaths[i]);
        // print('_selectedAudioFiles: $selectedAudioFiles');
      }
      List<int?> audioIndexes = selectedAudioFiles
          .map((filePath) => audioIndexMap[filePath])
          .toList();
      AudioListHolder8.audioList = selectedAudioFiles;
      AudioListHolder8.audioIndexes = audioIndexes;

      widget.isMultipleSelectionEnabled = true;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadAudioFiles();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> loadAudioFiles() async {
    for (final filePath in audioFilePaths) {
      await _audioPlayer.setAsset(filePath);
    }
  }

  void clearSelection() {
    setState(() {
      _selectedContainers.clear();
      _selectedAudioFiles.clear();
      _startIndex = null;
      _endIndex = null;
      AudioListHolder8.audioList.clear();
      widget.isMultipleSelectionEnabled = false;
      widget.updateMultipleSelectionEnabled(false);
    });
  }

  void clearAudioList() {
    setState(() {
      AudioListHolder8.audioList.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    Color appColor = context.read<AppColorsProvider>().mainBrandingColor;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                            color: Colors.blue, border: Border.all(width: 1)),
                        child: const Text(
                          ' مركبات',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                color: containerAudioPlayingStates[3]
                                    ? appColor.withOpacity(0.3)
                                    : (currentlyPlayingIndex == 3
                                        ? appColor.withOpacity(0.3)
                                        : Colors.transparent),
                                border: const Border(
                                    left: BorderSide(width: 1),
                                    right: BorderSide(width: 1),
                                    bottom: BorderSide(width: 1)),
                              ),
                              child: InkWell(
                                  onTap: widget.isMultipleSelectionEnabled
                                      ? () {
                                          _toggleSelection(
                                              3, audioFilePaths[3]);
                                        }
                                      : () async {
                                          playSingleAudio(3);
                                        },
                                  child: Stack(children: [
                                    Center(
                                      child: Image.asset(
                                        'assets/images/qaida/page8/p8img111.png',
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    if (_selectedContainers.contains(3))
                                      if (_startIndex == 3)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_left.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                      else if (_endIndex == 3)
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_right.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                  ]))),
                        ),
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                color: containerAudioPlayingStates[2]
                                    ? appColor.withOpacity(0.3)
                                    : (currentlyPlayingIndex == 2
                                        ? appColor.withOpacity(0.3)
                                        : Colors.transparent),
                                border: const Border(
                                    right: BorderSide(width: 1),
                                    bottom: BorderSide(width: 1)),
                              ),
                              child: InkWell(
                                  onTap: widget.isMultipleSelectionEnabled
                                      ? () {
                                          _toggleSelection(
                                              2, audioFilePaths[2]);
                                        }
                                      : () async {
                                          playSingleAudio(2);
                                        },
                                  child: Stack(children: [
                                    Image.asset(
                                      'assets/images/qaida/page8/p8img222.png',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                                    if (_selectedContainers.contains(2))
                                      if (_startIndex == 2)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_left.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                      else if (_endIndex == 2)
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_right.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                  ]))),
                        ),
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                color: containerAudioPlayingStates[1]
                                    ? appColor.withOpacity(0.3)
                                    : (currentlyPlayingIndex == 1
                                        ? appColor.withOpacity(0.3)
                                        : Colors.transparent),
                                border: const Border(
                                    right: BorderSide(width: 1),
                                    bottom: BorderSide(width: 1)),
                              ),
                              child: InkWell(
                                  onTap: widget.isMultipleSelectionEnabled
                                      ? () {
                                          _toggleSelection(
                                              1, audioFilePaths[1]);
                                        }
                                      : () async {
                                          playSingleAudio(1);
                                        },
                                  child: Stack(children: [
                                    Image.asset(
                                      'assets/images/qaida/page8/p8img333.png',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                                    if (_selectedContainers.contains(1))
                                      if (_startIndex == 1)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_left.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                      else if (_endIndex == 1)
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_right.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                  ]))),
                        ),
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                color: containerAudioPlayingStates[0]
                                    ? appColor.withOpacity(0.3)
                                    : (currentlyPlayingIndex == 0
                                        ? appColor.withOpacity(0.3)
                                        : Colors.transparent),
                                border: const Border(
                                    right: BorderSide(width: 1),
                                    bottom: BorderSide(width: 1)),
                              ),
                              child: InkWell(
                                  onTap: widget.isMultipleSelectionEnabled
                                      ? () {
                                          _toggleSelection(
                                              0, audioFilePaths[0]);
                                        }
                                      : () async {
                                          playSingleAudio(0);
                                        },
                                  child: Stack(children: [
                                    Image.asset(
                                      'assets/images/qaida/page8/p8img444.png',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                                    if (_selectedContainers.contains(0))
                                      if (_startIndex == 0)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_left.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                      else if (_endIndex == 0)
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_right.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                  ]))),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                color: containerAudioPlayingStates[6]
                                    ? appColor.withOpacity(0.3)
                                    : (currentlyPlayingIndex == 6
                                        ? appColor.withOpacity(0.3)
                                        : Colors.transparent),
                                border: const Border(
                                    right: BorderSide(width: 1),
                                    left: BorderSide(width: 1),
                                    bottom: BorderSide(width: 1)),
                              ),
                              child: InkWell(
                                  onTap: widget.isMultipleSelectionEnabled
                                      ? () {
                                          _toggleSelection(
                                              6, audioFilePaths[6]);
                                        }
                                      : () async {
                                          playSingleAudio(6);
                                        },
                                  child: Stack(children: [
                                    Image.asset(
                                      'assets/images/qaida/page8/p8img555.png',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                                    if (_selectedContainers.contains(6))
                                      if (_startIndex == 6)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_left.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                      else if (_endIndex == 6)
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_right.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                  ]))),
                        ),
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                color: containerAudioPlayingStates[5]
                                    ? appColor.withOpacity(0.3)
                                    : (currentlyPlayingIndex == 5
                                        ? appColor.withOpacity(0.3)
                                        : Colors.transparent),
                                border: const Border(
                                    right: BorderSide(width: 1),
                                    bottom: BorderSide(width: 1)),
                              ),
                              child: InkWell(
                                  onTap: widget.isMultipleSelectionEnabled
                                      ? () {
                                          _toggleSelection(
                                              5, audioFilePaths[5]);
                                        }
                                      : () async {
                                          playSingleAudio(5);
                                        },
                                  child: Stack(children: [
                                    Image.asset(
                                      'assets/images/qaida/page8/p8img666.png',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                                    if (_selectedContainers.contains(5))
                                      if (_startIndex == 5)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_left.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                      else if (_endIndex == 5)
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_right.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                  ]))),
                        ),
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                color: containerAudioPlayingStates[4]
                                    ? appColor.withOpacity(0.3)
                                    : (currentlyPlayingIndex == 4
                                        ? appColor.withOpacity(0.3)
                                        : Colors.transparent),
                                border: const Border(
                                    right: BorderSide(width: 1),
                                    bottom: BorderSide(width: 1)),
                              ),
                              child: InkWell(
                                  onTap: widget.isMultipleSelectionEnabled
                                      ? () {
                                          _toggleSelection(
                                              4, audioFilePaths[4]);
                                        }
                                      : () async {
                                          playSingleAudio(4);
                                        },
                                  child: Stack(children: [
                                    Image.asset(
                                      'assets/images/qaida/page8/p8img777.png',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                                    if (_selectedContainers.contains(4))
                                      if (_startIndex == 4)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_left.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                      else if (_endIndex == 4)
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_right.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                  ]))),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                              decoration: BoxDecoration(
                                color: containerAudioPlayingStates[9]
                                    ? appColor.withOpacity(0.3)
                                    : (currentlyPlayingIndex == 9
                                        ? appColor.withOpacity(0.3)
                                        : Colors.transparent),
                                border: const Border(
                                    right: BorderSide(width: 1),
                                    left: BorderSide(width: 1),
                                    bottom: BorderSide(width: 1)),
                              ),
                              child: InkWell(
                                  onTap: widget.isMultipleSelectionEnabled
                                      ? () {
                                          _toggleSelection(
                                              9, audioFilePaths[9]);
                                        }
                                      : () async {
                                          playSingleAudio(9);
                                        },
                                  child: Stack(children: [
                                    Image.asset(
                                      'assets/images/qaida/page8/p8img888.png',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                                    if (_selectedContainers.contains(9))
                                      if (_startIndex == 9)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_left.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                      else if (_endIndex == 9)
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_right.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                  ]))),
                        ),
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                color: containerAudioPlayingStates[8]
                                    ? appColor.withOpacity(0.3)
                                    : (currentlyPlayingIndex == 8
                                        ? appColor.withOpacity(0.3)
                                        : Colors.transparent),
                                border: const Border(
                                    right: BorderSide(width: 1),
                                    bottom: BorderSide(width: 1)),
                              ),
                              child: InkWell(
                                  onTap: widget.isMultipleSelectionEnabled
                                      ? () {
                                          _toggleSelection(
                                              8, audioFilePaths[8]);
                                        }
                                      : () async {
                                          playSingleAudio(8);
                                        },
                                  child: Stack(children: [
                                    Image.asset(
                                      'assets/images/qaida/page8/p8img999.png',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                                    if (_selectedContainers.contains(8))
                                      if (_startIndex == 8)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_left.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                      else if (_endIndex == 8)
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_right.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                  ]))),
                        ),
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                color: containerAudioPlayingStates[7]
                                    ? appColor.withOpacity(0.3)
                                    : (currentlyPlayingIndex == 7
                                        ? appColor.withOpacity(0.3)
                                        : Colors.transparent),
                                border: const Border(
                                    right: BorderSide(width: 1),
                                    bottom: BorderSide(width: 1)),
                              ),
                              child: InkWell(
                                  onTap: widget.isMultipleSelectionEnabled
                                      ? () {
                                          _toggleSelection(
                                              7, audioFilePaths[7]);
                                        }
                                      : () async {
                                          playSingleAudio(7);
                                        },
                                  child: Stack(children: [
                                    Image.asset(
                                      'assets/images/qaida/page8/p8img100.png',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                                    if (_selectedContainers.contains(7))
                                      if (_startIndex == 7)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_left.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                      else if (_endIndex == 7)
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_right.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                  ]))),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                color: containerAudioPlayingStates[13]
                                    ? appColor.withOpacity(0.3)
                                    : (currentlyPlayingIndex == 13
                                        ? appColor.withOpacity(0.3)
                                        : Colors.transparent),
                                border: const Border(
                                    right: BorderSide(width: 1),
                                    left: BorderSide(width: 1),
                                    bottom: BorderSide(width: 1)),
                              ),
                              child: InkWell(
                                  onTap: widget.isMultipleSelectionEnabled
                                      ? () {
                                          _toggleSelection(
                                              13, audioFilePaths[13]);
                                        }
                                      : () async {
                                          playSingleAudio(13);
                                        },
                                  child: Stack(children: [
                                    Image.asset(
                                      'assets/images/qaida/page8/p8img11a.png',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                                    if (_selectedContainers.contains(13))
                                      if (_startIndex == 13)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_left.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                      else if (_endIndex == 13)
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_right.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                  ]))),
                        ),
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                color: containerAudioPlayingStates[12]
                                    ? appColor.withOpacity(0.3)
                                    : (currentlyPlayingIndex == 12
                                        ? appColor.withOpacity(0.3)
                                        : Colors.transparent),
                                border: const Border(
                                    right: BorderSide(width: 1),
                                    bottom: BorderSide(width: 1)),
                              ),
                              child: InkWell(
                                  onTap: widget.isMultipleSelectionEnabled
                                      ? () {
                                          _toggleSelection(
                                              12, audioFilePaths[12]);
                                        }
                                      : () async {
                                          playSingleAudio(12);
                                        },
                                  child: Stack(children: [
                                    Image.asset(
                                      'assets/images/qaida/page8/p8img12a.png',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                                    if (_selectedContainers.contains(12))
                                      if (_startIndex == 12)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_left.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                      else if (_endIndex == 12)
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_right.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                  ]))),
                        ),
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                color: containerAudioPlayingStates[11]
                                    ? appColor.withOpacity(0.3)
                                    : (currentlyPlayingIndex == 11
                                        ? appColor.withOpacity(0.3)
                                        : Colors.transparent),
                                border: const Border(
                                    right: BorderSide(width: 1),
                                    bottom: BorderSide(width: 1)),
                              ),
                              child: InkWell(
                                  onTap: widget.isMultipleSelectionEnabled
                                      ? () {
                                          _toggleSelection(
                                              11, audioFilePaths[11]);
                                        }
                                      : () async {
                                          playSingleAudio(11);
                                        },
                                  child: Stack(children: [
                                    Image.asset(
                                      'assets/images/qaida/page8/p8img13a.png',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                                    if (_selectedContainers.contains(11))
                                      if (_startIndex == 11)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_left.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                      else if (_endIndex == 11)
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_right.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                  ]))),
                        ),
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                color: containerAudioPlayingStates[10]
                                    ? appColor.withOpacity(0.3)
                                    : (currentlyPlayingIndex == 10
                                        ? appColor.withOpacity(0.3)
                                        : Colors.transparent),
                                border: const Border(
                                    right: BorderSide(width: 1),
                                    bottom: BorderSide(width: 1)),
                              ),
                              child: InkWell(
                                  onTap: widget.isMultipleSelectionEnabled
                                      ? () {
                                          _toggleSelection(
                                              10, audioFilePaths[10]);
                                        }
                                      : () async {
                                          playSingleAudio(10);
                                        },
                                  child: Stack(children: [
                                    Image.asset(
                                      'assets/images/qaida/page8/p8img14a.png',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                                    if (_selectedContainers.contains(10))
                                      if (_startIndex == 10)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_left.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                      else if (_endIndex == 10)
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_right.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                  ]))),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                color: containerAudioPlayingStates[17]
                                    ? appColor.withOpacity(0.3)
                                    : (currentlyPlayingIndex == 17
                                        ? appColor.withOpacity(0.3)
                                        : Colors.transparent),
                                border: const Border(
                                    right: BorderSide(width: 1),
                                    left: BorderSide(width: 1),
                                    bottom: BorderSide(width: .5)),
                              ),
                              child: InkWell(
                                  onTap: widget.isMultipleSelectionEnabled
                                      ? () {
                                          _toggleSelection(
                                              17, audioFilePaths[17]);
                                        }
                                      : () async {
                                          playSingleAudio(17);
                                        },
                                  child: Stack(children: [
                                    Image.asset(
                                      'assets/images/qaida/page8/p8img15a.png',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                                    if (_selectedContainers.contains(17))
                                      if (_startIndex == 17)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_left.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                      else if (_endIndex == 17)
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_right.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                  ]))),
                        ),
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                color: containerAudioPlayingStates[16]
                                    ? appColor.withOpacity(0.3)
                                    : (currentlyPlayingIndex == 16
                                        ? appColor.withOpacity(0.3)
                                        : Colors.transparent),
                                border: const Border(
                                    right: BorderSide(width: 1),
                                    bottom: BorderSide(width: .5)),
                              ),
                              child: InkWell(
                                  onTap: widget.isMultipleSelectionEnabled
                                      ? () {
                                          _toggleSelection(
                                              16, audioFilePaths[16]);
                                        }
                                      : () async {
                                          playSingleAudio(16);
                                        },
                                  child: Stack(children: [
                                    Image.asset(
                                      'assets/images/qaida/page8/p8img16a.png',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                                    if (_selectedContainers.contains(16))
                                      if (_startIndex == 16)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_left.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                      else if (_endIndex == 16)
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_right.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                  ]))),
                        ),
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                color: containerAudioPlayingStates[15]
                                    ? appColor.withOpacity(0.3)
                                    : (currentlyPlayingIndex == 15
                                        ? appColor.withOpacity(0.3)
                                        : Colors.transparent),
                                border: const Border(
                                    right: BorderSide(width: 1),
                                    bottom: BorderSide(width: .5)),
                              ),
                              child: InkWell(
                                  onTap: widget.isMultipleSelectionEnabled
                                      ? () {
                                          _toggleSelection(
                                              15, audioFilePaths[15]);
                                        }
                                      : () async {
                                          playSingleAudio(15);
                                        },
                                  child: Stack(children: [
                                    Image.asset(
                                      'assets/images/qaida/page8/p8img17a.png',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                                    if (_selectedContainers.contains(15))
                                      if (_startIndex == 15)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_left.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                      else if (_endIndex == 15)
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_right.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                  ]))),
                        ),
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                color: containerAudioPlayingStates[14]
                                    ? appColor.withOpacity(0.3)
                                    : (currentlyPlayingIndex == 14
                                        ? appColor.withOpacity(0.3)
                                        : Colors.transparent),
                                border: const Border(
                                    right: BorderSide(width: 1),
                                    bottom: BorderSide(width: .5)),
                              ),
                              child: InkWell(
                                  onTap: widget.isMultipleSelectionEnabled
                                      ? () {
                                          _toggleSelection(
                                              14, audioFilePaths[14]);
                                        }
                                      : () async {
                                          playSingleAudio(14);
                                        },
                                  child: Stack(children: [
                                    Image.asset(
                                      'assets/images/qaida/page8/p8img18a.png',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                                    if (_selectedContainers.contains(14))
                                      if (_startIndex == 14)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_left.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                      else if (_endIndex == 14)
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_right.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                  ]))),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                              decoration: BoxDecoration(
                                color: containerAudioPlayingStates[20]
                                    ? appColor.withOpacity(0.3)
                                    : (currentlyPlayingIndex == 20
                                        ? appColor.withOpacity(0.3)
                                        : Colors.transparent),
                                border: const Border(
                                    right: BorderSide(width: 1),
                                    left: BorderSide(width: 1),
                                    bottom: BorderSide(width: .5)),
                              ),
                              child: InkWell(
                                  onTap: widget.isMultipleSelectionEnabled
                                      ? () {
                                          _toggleSelection(
                                              20, audioFilePaths[20]);
                                        }
                                      : () async {
                                          playSingleAudio(20);
                                        },
                                  child: Stack(children: [
                                    Image.asset(
                                      'assets/images/qaida/page8/p8img19a.png',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                                    if (_selectedContainers.contains(20))
                                      if (_startIndex == 20)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_left.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                      else if (_endIndex == 20)
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_right.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                  ]))),
                        ),
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                color: containerAudioPlayingStates[19]
                                    ? appColor.withOpacity(0.3)
                                    : (currentlyPlayingIndex == 19
                                        ? appColor.withOpacity(0.3)
                                        : Colors.transparent),
                                border: const Border(
                                    right: BorderSide(width: 1),
                                    bottom: BorderSide(width: .5)),
                              ),
                              child: InkWell(
                                  onTap: widget.isMultipleSelectionEnabled
                                      ? () {
                                          _toggleSelection(
                                              19, audioFilePaths[19]);
                                        }
                                      : () async {
                                          playSingleAudio(19);
                                        },
                                  child: Stack(children: [
                                    Image.asset(
                                      'assets/images/qaida/page8/p8img20a.png',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                                    if (_selectedContainers.contains(19))
                                      if (_startIndex == 19)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_left.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                      else if (_endIndex == 19)
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_right.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                  ]))),
                        ),
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                color: containerAudioPlayingStates[18]
                                    ? appColor.withOpacity(0.3)
                                    : (currentlyPlayingIndex == 18
                                        ? appColor.withOpacity(0.3)
                                        : Colors.transparent),
                                border: const Border(
                                    right: BorderSide(width: 1),
                                    bottom: BorderSide(width: .5)),
                              ),
                              child: InkWell(
                                  onTap: widget.isMultipleSelectionEnabled
                                      ? () {
                                          _toggleSelection(
                                              18, audioFilePaths[18]);
                                        }
                                      : () async {
                                          playSingleAudio(18);
                                        },
                                  child: Stack(children: [
                                    Image.asset(
                                      'assets/images/qaida/page8/p8img21a.png',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                                    if (_selectedContainers.contains(18))
                                      if (_startIndex == 18)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_left.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                      else if (_endIndex == 18)
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_right.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                  ]))),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                color: containerAudioPlayingStates[24]
                                    ? appColor.withOpacity(0.3)
                                    : (currentlyPlayingIndex == 24
                                        ? appColor.withOpacity(0.3)
                                        : Colors.transparent),
                                border: const Border(
                                    right: BorderSide(width: 1.5),
                                    left: BorderSide(width: 1),
                                    bottom: BorderSide(width: 1)),
                              ),
                              child: InkWell(
                                  onTap: widget.isMultipleSelectionEnabled
                                      ? () {
                                          _toggleSelection(
                                              24, audioFilePaths[24]);
                                        }
                                      : () async {
                                          playSingleAudio(24);
                                        },
                                  child: Stack(children: [
                                    Image.asset(
                                      'assets/images/qaida/page8/p8img22a.png',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                                    if (_selectedContainers.contains(24))
                                      if (_startIndex == 24)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_left.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                      else if (_endIndex == 24)
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_right.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                  ]))),
                        ),
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                color: containerAudioPlayingStates[23]
                                    ? appColor.withOpacity(0.3)
                                    : (currentlyPlayingIndex == 23
                                        ? appColor.withOpacity(0.3)
                                        : Colors.transparent),
                                border: const Border(
                                    right: BorderSide(width: 1),
                                    bottom: BorderSide(width: 1)),
                              ),
                              child: InkWell(
                                  onTap: widget.isMultipleSelectionEnabled
                                      ? () {
                                          _toggleSelection(
                                              23, audioFilePaths[23]);
                                        }
                                      : () async {
                                          playSingleAudio(23);
                                        },
                                  child: Stack(children: [
                                    Image.asset(
                                      'assets/images/qaida/page8/p8img23a.png',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                                    if (_selectedContainers.contains(23))
                                      if (_startIndex == 23)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_left.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                      else if (_endIndex == 23)
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_right.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                  ]))),
                        ),
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                color: containerAudioPlayingStates[22]
                                    ? appColor.withOpacity(0.3)
                                    : (currentlyPlayingIndex == 22
                                        ? appColor.withOpacity(0.3)
                                        : Colors.transparent),
                                border: const Border(
                                    right: BorderSide(width: 1),
                                    bottom: BorderSide(width: 1)),
                              ),
                              child: InkWell(
                                  onTap: widget.isMultipleSelectionEnabled
                                      ? () {
                                          _toggleSelection(
                                              22, audioFilePaths[22]);
                                        }
                                      : () async {
                                          playSingleAudio(22);
                                        },
                                  child: Stack(children: [
                                    Image.asset(
                                      'assets/images/qaida/page8/p8img24a.png',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                                    if (_selectedContainers.contains(22))
                                      if (_startIndex == 22)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_left.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                      else if (_endIndex == 22)
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_right.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                  ]))),
                        ),
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                color: containerAudioPlayingStates[21]
                                    ? appColor.withOpacity(0.3)
                                    : (currentlyPlayingIndex == 21
                                        ? appColor.withOpacity(0.3)
                                        : Colors.transparent),
                                border: const Border(
                                    right: BorderSide(width: 1),
                                    bottom: BorderSide(width: 1)),
                              ),
                              child: InkWell(
                                  onTap: widget.isMultipleSelectionEnabled
                                      ? () {
                                          _toggleSelection(
                                              21, audioFilePaths[21]);
                                        }
                                      : () async {
                                          playSingleAudio(21);
                                        },
                                  child: Stack(children: [
                                    Image.asset(
                                      'assets/images/qaida/page8/p8img25a.png',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                                    if (_selectedContainers.contains(21))
                                      if (_startIndex == 21)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_left.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                      else if (_endIndex == 21)
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            'assets/images/qaida/arrow_right.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                  ]))),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AudioListHolder8 {
  static List<String> audioList = [];
  static List<int?> audioIndexes = [];
  static int pageId = 8;
  static void page8Audios() {
    if (audioList.isEmpty) {
      audioList.addAll([
        'assets/images/qaida/page8/00.mp3',
        'assets/images/qaida/page8/01.mp3',
        'assets/images/qaida/page8/02.mp3',
        'assets/images/qaida/page8/03.mp3',
        'assets/images/qaida/page8/04.mp3',
        'assets/images/qaida/page8/05.mp3',
        'assets/images/qaida/page8/06.mp3',
        'assets/images/qaida/page8/07.mp3',
        'assets/images/qaida/page8/08.mp3',
        'assets/images/qaida/page8/09.mp3',
        'assets/images/qaida/page8/10.mp3',
        'assets/images/qaida/page8/11.mp3',
        'assets/images/qaida/page8/12.mp3',
        'assets/images/qaida/page8/13.mp3',
        'assets/images/qaida/page8/14.mp3',
        'assets/images/qaida/page8/15.mp3',
        'assets/images/qaida/page8/16.mp3',
        'assets/images/qaida/page8/17.mp3',
        'assets/images/qaida/page8/18.mp3',
        'assets/images/qaida/page8/19.mp3',
        'assets/images/qaida/page8/20.mp3',
        'assets/images/qaida/page8/21.mp3',
        'assets/images/qaida/page8/22.mp3',
        'assets/images/qaida/page8/23.mp3',
        'assets/images/qaida/page8/24.mp3',
      ]);

      audioIndexes = [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        20,
        21,
        22,
        23,
        24
      ];
    }
  }
}
