import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Page18 extends StatefulWidget {
  bool isMultipleSelectionEnabled;
  final Function(bool) updateMultipleSelectionEnabled;
  Page18({
    Key? key,
    required this.isMultipleSelectionEnabled,
    required this.updateMultipleSelectionEnabled,
  }) : super(key: key);

  @override
  Page18State createState() => Page18State();
}

class Page18State extends State<Page18> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<String> _selectedAudioFiles = [];
  Set<int> _selectedContainers = {};
  List<String> audioFilePaths = [
    'assets/images/qaida/page18/00.mp3',
    'assets/images/qaida/page18/01.mp3',
    'assets/images/qaida/page18/02.mp3',
    'assets/images/qaida/page18/03.mp3',
    'assets/images/qaida/page18/04.mp3',
    'assets/images/qaida/page18/05.mp3',
    'assets/images/qaida/page18/06.mp3',
    'assets/images/qaida/page18/07.mp3',
    'assets/images/qaida/page18/08.mp3',
    'assets/images/qaida/page18/09.mp3',
    'assets/images/qaida/page18/10.mp3',
    'assets/images/qaida/page18/11.mp3',
    'assets/images/qaida/page18/12.mp3',
    'assets/images/qaida/page18/13.mp3',
    'assets/images/qaida/page18/14.mp3',
    'assets/images/qaida/page18/15.mp3',
    'assets/images/qaida/page18/16.mp3',
    'assets/images/qaida/page18/17.mp3',
    'assets/images/qaida/page18/18.mp3',
  ];

  int? _startIndex;
  int? _endIndex;
  bool _isPlaying = false;

  void _toggleSelection(int index, String filePath) {
    if (_startIndex != null && _endIndex != null) {
      _selectedContainers.clear();
      _selectedAudioFiles.clear();
      _startIndex = null;
      _endIndex = null;
      AudioListHolder18.audioList.clear();
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
      }
      AudioListHolder18.audioList = selectedAudioFiles;
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
      AudioListHolder18.audioList.clear();
      widget.isMultipleSelectionEnabled = false;
      widget.updateMultipleSelectionEnabled(false);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                          'assets/images/qaida/page18/p18img1.png',
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
                              decoration: const BoxDecoration(
                                border: Border(
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
                                          await _audioPlayer.stop();
                                          await _audioPlayer
                                              .setAsset(audioFilePaths[3]);
                                          await _audioPlayer.play();
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
                                            'assets/images/qaida/page18/p18img2.png',
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
                              decoration: const BoxDecoration(
                                border: Border(
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
                                          await _audioPlayer.stop();
                                          await _audioPlayer
                                              .setAsset(audioFilePaths[2]);
                                          await _audioPlayer.play();
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
                                            'assets/images/qaida/page18/p18img3.png',
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
                        Expanded(
                          child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
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
                                          await _audioPlayer.stop();
                                          await _audioPlayer
                                              .setAsset(audioFilePaths[1]);
                                          await _audioPlayer.play();
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
                                            'assets/images/qaida/page18/p18img4.png',
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
                              decoration: const BoxDecoration(
                                border: Border(
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
                                          await _audioPlayer.stop();
                                          await _audioPlayer
                                              .setAsset(audioFilePaths[0]);
                                          await _audioPlayer.play();
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
                                            'assets/images/qaida/page18/p18img5.png',
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
                              decoration: const BoxDecoration(
                                border: Border(
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
                                          await _audioPlayer.stop();
                                          await _audioPlayer
                                              .setAsset(audioFilePaths[6]);
                                          await _audioPlayer.play();
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
                                            'assets/images/qaida/page18/p18img6.png',
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
                        Expanded(
                          child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
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
                                          await _audioPlayer.stop();
                                          await _audioPlayer
                                              .setAsset(audioFilePaths[5]);
                                          await _audioPlayer.play();
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
                                            'assets/images/qaida/page18/p18img7.png',
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
                          flex: 2,
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                  right: BorderSide(width: 1),
                                  bottom: BorderSide(width: 1)),
                            ),
                            child: InkWell(
                              onTap: widget.isMultipleSelectionEnabled
                                  ? () {
                                      _toggleSelection(4, audioFilePaths[4]);
                                    }
                                  : () async {
                                      await _audioPlayer.stop();
                                      await _audioPlayer
                                          .setAsset(audioFilePaths[4]);
                                      await _audioPlayer.play();
                                    },
                              child: Stack(
                                children: [
                                  FractionallySizedBox(
                                    widthFactor: 1.0,
                                    heightFactor: 1,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: AspectRatio(
                                        aspectRatio: 2.4,
                                        child: Image.asset(
                                          'assets/images/qaida/page18/p18img8.png',
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
                                ],
                              ),
                            ),
                          ),
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
                              decoration: const BoxDecoration(
                                border: Border(
                                    right: BorderSide(width: 1),
                                    left: BorderSide(width: 1)),
                              ),
                              child: InkWell(
                                  onTap: widget.isMultipleSelectionEnabled
                                      ? () {
                                          _toggleSelection(
                                              10, audioFilePaths[10]);
                                        }
                                      : () async {
                                          await _audioPlayer.stop();
                                          await _audioPlayer
                                              .setAsset(audioFilePaths[10]);
                                          await _audioPlayer.play();
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
                                            'assets/images/qaida/page18/p18img9.png',
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
                              decoration: const BoxDecoration(
                                border: Border(
                                  right: BorderSide(width: 1),
                                ),
                              ),
                              child: InkWell(
                                  onTap: widget.isMultipleSelectionEnabled
                                      ? () {
                                          _toggleSelection(
                                              9, audioFilePaths[9]);
                                        }
                                      : () async {
                                          await _audioPlayer.stop();
                                          await _audioPlayer
                                              .setAsset(audioFilePaths[9]);
                                          await _audioPlayer.play();
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
                                            'assets/images/qaida/page18/p18img10.png',
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
                              decoration: const BoxDecoration(
                                border: Border(
                                  right: BorderSide(width: 1),
                                ),
                              ),
                              child: InkWell(
                                  onTap: widget.isMultipleSelectionEnabled
                                      ? () {
                                          _toggleSelection(
                                              8, audioFilePaths[8]);
                                        }
                                      : () async {
                                          await _audioPlayer.stop();
                                          await _audioPlayer
                                              .setAsset(audioFilePaths[8]);
                                          await _audioPlayer.play();
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
                                            'assets/images/qaida/page18/p18img11.png',
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
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(width: 1),
                              ),
                            ),
                            child: InkWell(
                              onTap: widget.isMultipleSelectionEnabled
                                  ? () {
                                      _toggleSelection(7, audioFilePaths[7]);
                                    }
                                  : () async {
                                      await _audioPlayer.stop();
                                      await _audioPlayer
                                          .setAsset(audioFilePaths[7]);
                                      await _audioPlayer.play();
                                    },
                              child: Stack(
                                children: [
                                  FractionallySizedBox(
                                    widthFactor: 1.0,
                                    heightFactor: 1,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: AspectRatio(
                                        aspectRatio: 1.6,
                                        child: Image.asset(
                                          'assets/images/qaida/page18/p18img12.png',
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
                                ],
                              ),
                            ),
                          ),
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
                            decoration: const BoxDecoration(
                              border: Border(
                                  right: BorderSide(width: 1),
                                  top: BorderSide(width: 1),
                                  left: BorderSide(width: 1)),
                            ),
                            child: InkWell(
                              onTap: widget.isMultipleSelectionEnabled
                                  ? () {
                                      _toggleSelection(13, audioFilePaths[13]);
                                    }
                                  : () async {
                                      await _audioPlayer.stop();
                                      await _audioPlayer
                                          .setAsset(audioFilePaths[13]);
                                      await _audioPlayer.play();
                                    },
                              child: Stack(
                                children: [
                                  FractionallySizedBox(
                                    widthFactor: 1.0,
                                    heightFactor: 1,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: AspectRatio(
                                        aspectRatio: 1.6,
                                        child: Image.asset(
                                          'assets/images/qaida/page18/p18img13.png',
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
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(width: 1),
                                top: BorderSide(width: 1),
                              ),
                            ),
                            child: InkWell(
                              onTap: widget.isMultipleSelectionEnabled
                                  ? () {
                                      _toggleSelection(12, audioFilePaths[12]);
                                    }
                                  : () async {
                                      await _audioPlayer.stop();
                                      await _audioPlayer
                                          .setAsset(audioFilePaths[12]);
                                      await _audioPlayer.play();
                                    },
                              child: Stack(
                                children: [
                                  FractionallySizedBox(
                                    widthFactor: 1.0,
                                    heightFactor: 1,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: AspectRatio(
                                        aspectRatio: 1.6,
                                        child: Image.asset(
                                          'assets/images/qaida/page18/p18img14.png',
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
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(width: 1),
                                top: BorderSide(width: 1),
                              ),
                            ),
                            child: InkWell(
                              onTap: widget.isMultipleSelectionEnabled
                                  ? () {
                                      _toggleSelection(11, audioFilePaths[11]);
                                    }
                                  : () async {
                                      await _audioPlayer.stop();
                                      await _audioPlayer
                                          .setAsset(audioFilePaths[11]);
                                      await _audioPlayer.play();
                                    },
                              child: Stack(
                                children: [
                                  FractionallySizedBox(
                                    widthFactor: 1.0,
                                    heightFactor: 1,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: AspectRatio(
                                        aspectRatio: 2.4,
                                        child: Image.asset(
                                          'assets/images/qaida/page18/p18img15.png',
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
                                ],
                              ),
                            ),
                          ),
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
                                  'assets/images/qaida/page18/p18img16.png',
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
                          flex: 2,
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                  right: BorderSide(width: 1),
                                  left: BorderSide(width: 1),
                                  bottom: BorderSide(width: 1)),
                            ),
                            child: InkWell(
                              onTap: widget.isMultipleSelectionEnabled
                                  ? () {
                                      _toggleSelection(16, audioFilePaths[16]);
                                    }
                                  : () async {
                                      await _audioPlayer.stop();
                                      await _audioPlayer
                                          .setAsset(audioFilePaths[16]);
                                      await _audioPlayer.play();
                                    },
                              child: Stack(
                                children: [
                                  FractionallySizedBox(
                                    widthFactor: 1.0,
                                    heightFactor: 1,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: AspectRatio(
                                        aspectRatio: 2.4,
                                        child: Image.asset(
                                          'assets/images/qaida/page18/p18img17.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
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
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                  right: BorderSide(width: 1),
                                  // left: BorderSide(width: 1),
                                  bottom: BorderSide(width: 1)),
                            ),
                            child: InkWell(
                              onTap: widget.isMultipleSelectionEnabled
                                  ? () {
                                      _toggleSelection(15, audioFilePaths[15]);
                                    }
                                  : () async {
                                      await _audioPlayer.stop();
                                      await _audioPlayer
                                          .setAsset(audioFilePaths[15]);
                                      await _audioPlayer.play();
                                    },
                              child: Stack(
                                children: [
                                  FractionallySizedBox(
                                    widthFactor: 1.0,
                                    heightFactor: 1,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: AspectRatio(
                                        aspectRatio: 1.6,
                                        child: Image.asset(
                                          'assets/images/qaida/page18/p18img18.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
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
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                  right: BorderSide(width: 1),
                                  bottom: BorderSide(width: 1)),
                            ),
                            child: InkWell(
                              onTap: widget.isMultipleSelectionEnabled
                                  ? () {
                                      _toggleSelection(14, audioFilePaths[14]);
                                    }
                                  : () async {
                                      await _audioPlayer.stop();
                                      await _audioPlayer
                                          .setAsset(audioFilePaths[14]);
                                      await _audioPlayer.play();
                                    },
                              child: Stack(
                                children: [
                                  FractionallySizedBox(
                                    widthFactor: 1.0,
                                    heightFactor: 1,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: AspectRatio(
                                        aspectRatio: 1.6,
                                        child: Image.asset(
                                          'assets/images/qaida/page18/p18img19.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
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
                                ],
                              ),
                            ),
                          ),
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
                            decoration: const BoxDecoration(
                              border: Border(
                                  right: BorderSide(width: 1),
                                  left: BorderSide(width: 1),
                                  bottom: BorderSide(width: 1)),
                            ),
                            child: InkWell(
                              onTap: widget.isMultipleSelectionEnabled
                                  ? () {
                                      _toggleSelection(18, audioFilePaths[18]);
                                    }
                                  : () async {
                                      await _audioPlayer.stop();
                                      await _audioPlayer
                                          .setAsset(audioFilePaths[18]);
                                      await _audioPlayer.play();
                                    },
                              child: Stack(
                                children: [
                                  FractionallySizedBox(
                                    widthFactor: 1.0,
                                    heightFactor: 1,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: AspectRatio(
                                        aspectRatio: 2.4,
                                        child: Image.asset(
                                          'assets/images/qaida/page18/p18img20.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
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
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                  right: BorderSide(width: 1),
                                  bottom: BorderSide(width: 1)),
                            ),
                            child: InkWell(
                              onTap: widget.isMultipleSelectionEnabled
                                  ? () {
                                      _toggleSelection(17, audioFilePaths[17]);
                                    }
                                  : () async {
                                      await _audioPlayer.stop();
                                      await _audioPlayer
                                          .setAsset(audioFilePaths[17]);
                                      await _audioPlayer.play();
                                    },
                              child: Stack(
                                children: [
                                  FractionallySizedBox(
                                    widthFactor: 1.0,
                                    heightFactor: 1,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: AspectRatio(
                                        aspectRatio: 2.4,
                                        child: Image.asset(
                                          'assets/images/qaida/page18/p18img21.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
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
                                ],
                              ),
                            ),
                          ),
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

class AudioListHolder18 {
  static List<String> audioList = [];
  static int pageId = 18;
}
