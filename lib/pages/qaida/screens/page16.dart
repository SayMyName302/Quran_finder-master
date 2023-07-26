import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../../settings/pages/app_colors/app_colors_provider.dart';

class Page16 extends StatefulWidget {
  bool isMultipleSelectionEnabled;
  final Function(bool) updateMultipleSelectionEnabled;
  Page16({
    Key? key,
    required this.isMultipleSelectionEnabled,
    required this.updateMultipleSelectionEnabled,
  }) : super(key: key);

  @override
  Page16State createState() => Page16State();
}

class Page16State extends State<Page16> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<String> _selectedAudioFiles = [];
  final Set<int> _selectedContainers = {};
  List<String> audioFilePaths = [
    'assets/images/qaida/page16/00.mp3',
    'assets/images/qaida/page16/01.mp3',
    'assets/images/qaida/page16/02.mp3',
    'assets/images/qaida/page16/03.mp3',
    'assets/images/qaida/page16/04.mp3',
    'assets/images/qaida/page16/05.mp3',
    'assets/images/qaida/page16/06.mp3',
    'assets/images/qaida/page16/07.mp3',
    'assets/images/qaida/page16/08.mp3',
    'assets/images/qaida/page16/09.mp3',
    'assets/images/qaida/page16/10.mp3',
    'assets/images/qaida/page16/11.mp3',
    'assets/images/qaida/page16/12.mp3',
    'assets/images/qaida/page16/13.mp3',
  ];
  Map<String, int> audioIndexMap = {
    'assets/images/qaida/page16/00.mp3': 0,
    'assets/images/qaida/page16/01.mp3': 1,
    'assets/images/qaida/page16/02.mp3': 2,
    'assets/images/qaida/page16/03.mp3': 3,
    'assets/images/qaida/page16/04.mp3': 4,
    'assets/images/qaida/page16/05.mp3': 5,
    'assets/images/qaida/page16/06.mp3': 6,
    'assets/images/qaida/page16/07.mp3': 7,
    'assets/images/qaida/page16/08.mp3': 8,
    'assets/images/qaida/page16/09.mp3': 9,
    'assets/images/qaida/page16/10.mp3': 10,
    'assets/images/qaida/page16/11.mp3': 11,
    'assets/images/qaida/page16/12.mp3': 12,
    'assets/images/qaida/page16/13.mp3': 13,
  };

  int? _startIndex;
  int? _endIndex;
  final bool _isPlaying = false;

  List<bool> containerAudioPlayingStates = List.generate(14, (_) => false);
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
      AudioListHolder16.audioList.clear();
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
      AudioListHolder16.audioList = selectedAudioFiles;
      AudioListHolder16.audioIndexes = audioIndexes;

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
      AudioListHolder16.audioList.clear();
      widget.isMultipleSelectionEnabled = false;
      widget.updateMultipleSelectionEnabled(false);
    });
  }

  void clearAudioList() {
    setState(() {
      AudioListHolder16.audioList.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    Color appColor = context.read<AppColorsProvider>().mainBrandingColor;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        decoration: BoxDecoration(border: Border.all(width: 1)),
                        child: Image.asset(
                          'assets/images/qaida/page16/p16img1.png',
                          fit: BoxFit.fill,
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
                                color: containerAudioPlayingStates[1]
                                    ? appColor.withOpacity(0.3)
                                    : (currentlyPlayingIndex == 1
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
                                              1, audioFilePaths[1]);
                                        }
                                      : () async {
                                          playSingleAudio(1);
                                        },
                                  child: Stack(children: [
                                    FractionallySizedBox(
                                      widthFactor: 1.0,
                                      heightFactor: 1,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: AspectRatio(
                                          aspectRatio: 2.4,
                                          child: Image.asset(
                                            'assets/images/qaida/page16/p16img2.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
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
                                    FractionallySizedBox(
                                      widthFactor: 1.0,
                                      heightFactor: 1,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: AspectRatio(
                                          aspectRatio: 2.4,
                                          child: Image.asset(
                                            'assets/images/qaida/page16/p16img3.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
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
                                color: containerAudioPlayingStates[3]
                                    ? appColor.withOpacity(0.3)
                                    : (currentlyPlayingIndex == 3
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
                                              3, audioFilePaths[3]);
                                        }
                                      : () async {
                                          playSingleAudio(3);
                                        },
                                  child: Stack(children: [
                                    FractionallySizedBox(
                                      widthFactor: 1.0,
                                      heightFactor: 1,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: AspectRatio(
                                          aspectRatio: 2.4,
                                          child: Image.asset(
                                            'assets/images/qaida/page16/p16img4.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
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
                                    FractionallySizedBox(
                                      widthFactor: 1.0,
                                      heightFactor: 1,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: AspectRatio(
                                          aspectRatio: 2.4,
                                          child: Image.asset(
                                            'assets/images/qaida/page16/p16img5.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
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
                                color: containerAudioPlayingStates[5]
                                    ? appColor.withOpacity(0.3)
                                    : (currentlyPlayingIndex == 5
                                        ? appColor.withOpacity(0.3)
                                        : Colors.transparent),
                                border: const Border(
                                    right: BorderSide(width: 1),
                                    left: BorderSide(width: 1)),
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
                                    FractionallySizedBox(
                                      widthFactor: 1.0,
                                      heightFactor: 1,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: AspectRatio(
                                          aspectRatio: 2.4,
                                          child: Image.asset(
                                            'assets/images/qaida/page16/p16img6.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
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
                                border:
                                    const Border(right: BorderSide(width: 1)),
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
                                    FractionallySizedBox(
                                      widthFactor: 1.0,
                                      heightFactor: 1,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: AspectRatio(
                                          aspectRatio: 2.4,
                                          child: Image.asset(
                                            'assets/images/qaida/page16/p16img7.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
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
                          child: Container(
                              decoration: BoxDecoration(
                                color: containerAudioPlayingStates[7]
                                    ? appColor.withOpacity(0.3)
                                    : (currentlyPlayingIndex == 7
                                        ? appColor.withOpacity(0.3)
                                        : Colors.transparent),
                                border: const Border(
                                    right: BorderSide(width: 1),
                                    top: BorderSide(width: 1),
                                    left: BorderSide(width: 1)),
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
                                    FractionallySizedBox(
                                      widthFactor: 1.0,
                                      heightFactor: 1,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: AspectRatio(
                                          aspectRatio: 2.4,
                                          child: Image.asset(
                                            'assets/images/qaida/page16/p16img8.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
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
                                  top: BorderSide(width: 1),
                                ),
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
                                    FractionallySizedBox(
                                      widthFactor: 1.0,
                                      heightFactor: 1,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: AspectRatio(
                                          aspectRatio: 2.4,
                                          child: Image.asset(
                                            'assets/images/qaida/page16/p16img9.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
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
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.1,
                              decoration:
                                  BoxDecoration(border: Border.all(width: 1)),
                              child: InkWell(
                                onTap: () async {
                                  await _audioPlayer
                                      .setAsset('assets/alif.mp3');
                                  _audioPlayer.play();
                                },
                                child: Image.asset(
                                  'assets/images/qaida/page16/p16img10.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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
                                    left: BorderSide(width: 1),
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
                                    FractionallySizedBox(
                                      widthFactor: 1.0,
                                      heightFactor: 1,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: AspectRatio(
                                          aspectRatio: 1.6,
                                          child: Image.asset(
                                            'assets/images/qaida/page16/p16img11.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
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
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                color: containerAudioPlayingStates[9]
                                    ? appColor.withOpacity(0.3)
                                    : (currentlyPlayingIndex == 9
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
                                              9, audioFilePaths[9]);
                                        }
                                      : () async {
                                          playSingleAudio(9);
                                        },
                                  child: Stack(children: [
                                    FractionallySizedBox(
                                      widthFactor: 1.0,
                                      heightFactor: 1,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: AspectRatio(
                                          aspectRatio: 1.6,
                                          child: Image.asset(
                                            'assets/images/qaida/page16/p16img12.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
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
                                    FractionallySizedBox(
                                      widthFactor: 1.0,
                                      heightFactor: 1,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: AspectRatio(
                                          aspectRatio: 1.6,
                                          child: Image.asset(
                                            'assets/images/qaida/page16/p16img13.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
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
                                    FractionallySizedBox(
                                      widthFactor: 1.0,
                                      heightFactor: 1,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: AspectRatio(
                                          aspectRatio: 1.6,
                                          child: Image.asset(
                                            'assets/images/qaida/page16/p16img14.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
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
                                    FractionallySizedBox(
                                      widthFactor: 1.0,
                                      heightFactor: 1,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: AspectRatio(
                                          aspectRatio: 1.6,
                                          child: Image.asset(
                                            'assets/images/qaida/page16/p16img15.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
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
                                    FractionallySizedBox(
                                      widthFactor: 1.0,
                                      heightFactor: 1,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: AspectRatio(
                                          aspectRatio: 1.6,
                                          child: Image.asset(
                                            'assets/images/qaida/page16/p16img16.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
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

class AudioListHolder16 {
  static List<String> audioList = [];
  static List<int?> audioIndexes = [];
  static int pageId = 16;
  static void page16Audios() {
    if (audioList.isEmpty) {
      audioList.addAll([
        'assets/images/qaida/page16/00.mp3',
        'assets/images/qaida/page16/01.mp3',
        'assets/images/qaida/page16/02.mp3',
        'assets/images/qaida/page16/03.mp3',
        'assets/images/qaida/page16/04.mp3',
        'assets/images/qaida/page16/05.mp3',
        'assets/images/qaida/page16/06.mp3',
        'assets/images/qaida/page16/07.mp3',
        'assets/images/qaida/page16/08.mp3',
        'assets/images/qaida/page16/09.mp3',
        'assets/images/qaida/page16/10.mp3',
        'assets/images/qaida/page16/11.mp3',
        'assets/images/qaida/page16/12.mp3',
        'assets/images/qaida/page16/13.mp3',
      ]);

      audioIndexes = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13];
    }
  }
}
