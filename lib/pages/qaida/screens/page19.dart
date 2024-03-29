import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Page19 extends StatefulWidget {
  bool isMultipleSelectionEnabled;
  final Function(bool) updateMultipleSelectionEnabled;
  Page19({
    Key? key,
    required this.isMultipleSelectionEnabled,
    required this.updateMultipleSelectionEnabled,
  }) : super(key: key);

  @override
  Page19State createState() => Page19State();
}

class Page19State extends State<Page19> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<String> _selectedAudioFiles = [];
  Set<int> _selectedContainers = {};
  List<String> audioFilePaths = [
    'assets/images/qaida/page19/00.mp3',
    'assets/images/qaida/page19/01.mp3',
    'assets/images/qaida/page19/02.mp3',
    'assets/images/qaida/page19/03.mp3',
    'assets/images/qaida/page19/04.mp3',
    'assets/images/qaida/page19/05.mp3',
    'assets/images/qaida/page19/06.mp3',
    'assets/images/qaida/page19/07.mp3',
    'assets/images/qaida/page19/08.mp3',
    'assets/images/qaida/page19/09.mp3',
    'assets/images/qaida/page19/10.mp3',
    'assets/images/qaida/page19/11.mp3',
    'assets/images/qaida/page19/12.mp3',
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
      AudioListHolder19.audioList.clear();
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
      AudioListHolder19.audioList = selectedAudioFiles;
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
      AudioListHolder19.audioList.clear();
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
                                top: BorderSide(width: 1),
                                left: BorderSide(width: 1),
                              ),
                            ),
                            child: InkWell(
                              onTap: widget.isMultipleSelectionEnabled
                                  ? () {
                                      _toggleSelection(1, audioFilePaths[1]);
                                    }
                                  : () async {
                                      await _audioPlayer.stop();
                                      await _audioPlayer
                                          .setAsset(audioFilePaths[1]);
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
                                          'assets/images/qaida/page19/p19img1.png',
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
                                      _toggleSelection(0, audioFilePaths[0]);
                                    }
                                  : () async {
                                      await _audioPlayer.stop();
                                      await _audioPlayer
                                          .setAsset(audioFilePaths[0]);
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
                                          'assets/images/qaida/page19/p19img2.png',
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
                          flex: 2,
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                  right: BorderSide(width: 1),
                                  top: BorderSide(width: 1),
                                  left: BorderSide(width: 1),
                                  bottom: BorderSide(width: .5)),
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
                                          'assets/images/qaida/page19/p19img3.png',
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
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                  right: BorderSide(width: 1),
                                  top: BorderSide(width: 1),
                                  bottom: BorderSide(width: .5)),
                            ),
                            child: InkWell(
                              onTap: widget.isMultipleSelectionEnabled
                                  ? () {
                                      _toggleSelection(3, audioFilePaths[3]);
                                    }
                                  : () async {
                                      await _audioPlayer.stop();
                                      await _audioPlayer
                                          .setAsset(audioFilePaths[3]);
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
                                        aspectRatio: 1.7,
                                        child: Image.asset(
                                          'assets/images/qaida/page19/p19img4.png',
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
                                  bottom: BorderSide(width: .5)),
                            ),
                            child: InkWell(
                              onTap: widget.isMultipleSelectionEnabled
                                  ? () {
                                      _toggleSelection(2, audioFilePaths[2]);
                                    }
                                  : () async {
                                      await _audioPlayer.stop();
                                      await _audioPlayer
                                          .setAsset(audioFilePaths[2]);
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
                                        aspectRatio: 1.7,
                                        child: Image.asset(
                                          'assets/images/qaida/page19/p19img5.png',
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
                                  top: BorderSide(width: 0.5),
                                  right: BorderSide(width: 1),
                                  left: BorderSide(width: 1)),
                            ),
                            child: InkWell(
                              onTap: widget.isMultipleSelectionEnabled
                                  ? () {
                                      _toggleSelection(6, audioFilePaths[6]);
                                    }
                                  : () async {
                                      await _audioPlayer.stop();
                                      await _audioPlayer
                                          .setAsset(audioFilePaths[6]);
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
                                          'assets/images/qaida/page19/p19img6.png',
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
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(width: 0.5),
                                right: BorderSide(width: 1),
                              ),
                            ),
                            child: InkWell(
                              onTap: widget.isMultipleSelectionEnabled
                                  ? () {
                                      _toggleSelection(5, audioFilePaths[5]);
                                    }
                                  : () async {
                                      await _audioPlayer.stop();
                                      await _audioPlayer
                                          .setAsset(audioFilePaths[5]);
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
                                          'assets/images/qaida/page19/p19img7.png',
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
                                      _toggleSelection(10, audioFilePaths[10]);
                                    }
                                  : () async {
                                      await _audioPlayer.stop();
                                      await _audioPlayer
                                          .setAsset(audioFilePaths[10]);
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
                                        aspectRatio: 1.7,
                                        child: Image.asset(
                                          'assets/images/qaida/page19/p19img8.png',
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
                                      _toggleSelection(9, audioFilePaths[9]);
                                    }
                                  : () async {
                                      await _audioPlayer.stop();
                                      await _audioPlayer
                                          .setAsset(audioFilePaths[9]);
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
                                        aspectRatio: 1.7,
                                        child: Image.asset(
                                          'assets/images/qaida/page19/p19img9.png',
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
                                      _toggleSelection(8, audioFilePaths[8]);
                                    }
                                  : () async {
                                      await _audioPlayer.stop();
                                      await _audioPlayer
                                          .setAsset(audioFilePaths[8]);
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
                                        aspectRatio: 1.7,
                                        child: Image.asset(
                                          'assets/images/qaida/page19/p19img10.png',
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
                                        aspectRatio: 1.7,
                                        child: Image.asset(
                                          'assets/images/qaida/page19/p19img11.png',
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
                                        aspectRatio: 2.4,
                                        child: Image.asset(
                                          'assets/images/qaida/page19/p19img12.png',
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
                                          'assets/images/qaida/page19/p19img13.png',
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
                              height: MediaQuery.of(context).size.height * 0.35,
                              decoration:
                                  BoxDecoration(border: Border.all(width: 1)),
                              child: InkWell(
                                onTap: () async {
                                  await _audioPlayer
                                      .setAsset('assets/alif.mp3');
                                  _audioPlayer.play();
                                },
                                child: Image.asset(
                                  'assets/images/qaida/page19/p19img14.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
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

class AudioListHolder19 {
  static List<String> audioList = [];
  static int pageId = 19;
}
