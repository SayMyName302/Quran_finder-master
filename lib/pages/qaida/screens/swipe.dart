import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nour_al_quran/pages/qaida/screens/page1.dart';
import 'package:nour_al_quran/pages/qaida/screens/page2.dart';
import 'package:nour_al_quran/pages/qaida/screens/page3.dart';
import 'package:nour_al_quran/pages/qaida/screens/page4.dart';
import 'package:nour_al_quran/pages/qaida/screens/page5.dart';
import 'package:nour_al_quran/pages/qaida/screens/page6.dart';
import 'package:nour_al_quran/pages/qaida/screens/page7.dart';
import 'package:nour_al_quran/pages/qaida/screens/page8.dart';
import 'package:nour_al_quran/pages/qaida/screens/page9.dart';
import 'package:nour_al_quran/pages/qaida/screens/page10.dart';
import 'package:nour_al_quran/pages/qaida/screens/page11.dart';
import 'package:nour_al_quran/pages/qaida/screens/page12.dart';
import 'package:nour_al_quran/pages/qaida/screens/page13.dart';
import 'package:nour_al_quran/pages/qaida/screens/page14.dart';
import 'package:nour_al_quran/pages/qaida/screens/page15.dart';
import 'package:nour_al_quran/pages/qaida/screens/page16.dart';
import 'package:nour_al_quran/pages/qaida/screens/page17.dart';
import 'package:nour_al_quran/pages/qaida/screens/page18.dart';
import 'package:nour_al_quran/pages/qaida/screens/page19.dart';
import 'package:nour_al_quran/pages/qaida/screens/pageindex.dart';
import 'package:nour_al_quran/pages/qaida/screens/qaidaplayer.dart';

class SwipePages extends StatefulWidget {
  final int initialPage;
  const SwipePages({Key? key, required this.initialPage}) : super(key: key);

  @override
  SwipePagesState createState() => SwipePagesState();
}

class SwipePagesState extends State<SwipePages> {
  final List<GlobalKey<Page1State>> _page1Key = [
    GlobalKey<Page1State>(),
  ];
  final List<GlobalKey<Page2State>> _page2Key = [
    GlobalKey<Page2State>(),
  ];
  final List<GlobalKey<Page3State>> _page3Key = [
    GlobalKey<Page3State>(),
  ];
  final List<GlobalKey<Page4State>> _page4Key = [
    GlobalKey<Page4State>(),
  ];
  final List<GlobalKey<Page5State>> _page5Key = [
    GlobalKey<Page5State>(),
  ];
  final List<GlobalKey<Page6State>> _page6Key = [
    GlobalKey<Page6State>(),
  ];
  final List<GlobalKey<Page7State>> _page7Key = [
    GlobalKey<Page7State>(),
  ];
  final List<GlobalKey<Page8State>> _page8Key = [
    GlobalKey<Page8State>(),
  ];
  final List<GlobalKey<Page9State>> _page9Key = [
    GlobalKey<Page9State>(),
  ];
  final List<GlobalKey<Page10State>> _page10Key = [
    GlobalKey<Page10State>(),
  ];
  final List<GlobalKey<Page11State>> _page11Key = [
    GlobalKey<Page11State>(),
  ];
  final List<GlobalKey<Page12State>> _page12Key = [
    GlobalKey<Page12State>(),
  ];
  final List<GlobalKey<Page13State>> _page13Key = [
    GlobalKey<Page13State>(),
  ];
  final List<GlobalKey<Page14State>> _page14Key = [
    GlobalKey<Page14State>(),
  ];
  final List<GlobalKey<Page15State>> _page15Key = [
    GlobalKey<Page15State>(),
  ];
  final List<GlobalKey<Page16State>> _page16Key = [
    GlobalKey<Page16State>(),
  ];
  final List<GlobalKey<Page17State>> _page17Key = [
    GlobalKey<Page17State>(),
  ];
  final List<GlobalKey<Page18State>> _page18Key = [
    GlobalKey<Page18State>(),
  ];
  final List<GlobalKey<Page19State>> _page19Key = [
    GlobalKey<Page19State>(),
  ];

  int _curr = 0;
  bool _isPlaying = false;
  bool _isPaused = false;
  List<Widget> _list = <Widget>[];
  bool _isMultipleSelectionEnabled = false;
  bool _loop = false;
  int _currentPlayingIndex = 0;
  PageController controller = PageController();
  AudioPlayer _audioPlayer = AudioPlayer();
  List<AudioPlayer> _audioLists = [];
  int _currentPageIndex = 0;

  List<String> audioFiles = [];
  int pageId = -1;
  List<int?> audioIndex = [];

  bool _skipButton = false;
  bool _skipPrevious = false;

  @override
  Widget build(BuildContext context) {
    // final bottomTabProvider = Provider.of<BottomTabsPageProvider>(context);
    final isRTL =
        ['ar', 'ur'].contains(Localizations.localeOf(context).languageCode);

    final pageView = PageView(
      allowImplicitScrolling: true,
      scrollDirection: Axis.horizontal,
      controller: controller,
      reverse: true,
      onPageChanged: onPageSelected,
      children: _list,
    );

    return SafeArea(
      child: Scaffold(
        // appBar: buildQaidaAppBar(
        //   context: context,
        //   title: localeText(context, 'qaida'),
        //   showBackButton: true,
        //   bottomTabProvider: bottomTabProvider,
        // ),
        body: isRTL
            ? Directionality(textDirection: TextDirection.ltr, child: pageView)
            : pageView,
        bottomNavigationBar: SizedBox(
          height: 160,
          child: QaidaPlayer(
            clearstate: _stopPageAudios,
            stopAudio: fetchstop,
            updateLoopVal: _loop,
            playButton: fetchList,
            toggleLoop: toggleLoop,
            selectWords: selectWords,
            skipNext: onSkipButtonPressed,
            skipPrevious: onPreviousButtonPressed,
            isAudioPlaying: _isPlaying && !_isPaused,
            updateMultipleSelectionEnabled: _isMultipleSelectionEnabled,
            selectedIndex: _currentPageIndex,
            onIndexPressed: () async {
              final selectedPage = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          QaidaPageIndex(selectedIndex: _currentPageIndex)));

              // ignore: use_build_context_synchronously
              Navigator.pop(context);
              if (selectedPage != null) {
                controller.jumpToPage(selectedPage);
              }
            },
          ),
        ),
      ),
    );
  }

  void fetchList() {
    if (!_isPlaying && !_isPaused) {
      if (_curr == 0) {
        if (AudioListHolder1.audioList.isEmpty) {
          AudioListHolder1.page1Audios();
        }
        audioFiles = AudioListHolder1.audioList;
        pageId = AudioListHolder1.pageId;
        audioIndex = AudioListHolder1.audioIndexes;
      } else if (_curr == 1) {
        if (AudioListHolder2.audioList.isEmpty) {
          AudioListHolder2.page2Audios();
        }
        audioFiles = AudioListHolder2.audioList;
        pageId = AudioListHolder2.pageId;
        audioIndex = AudioListHolder2.audioIndexes;
      } else if (_curr == 2) {
        if (AudioListHolder3.audioList.isEmpty) {
          AudioListHolder3.page3Audios();
        }
        audioFiles = AudioListHolder3.audioList;
        pageId = AudioListHolder3.pageId;
        audioIndex = AudioListHolder3.audioIndexes;
      } else if (_curr == 3) {
        if (AudioListHolder4.audioList.isEmpty) {
          AudioListHolder4.page4Audios();
        }
        audioFiles = AudioListHolder4.audioList;
        pageId = AudioListHolder4.pageId;
        audioIndex = AudioListHolder4.audioIndexes;
      } else if (_curr == 4) {
        if (AudioListHolder5.audioList.isEmpty) {
          AudioListHolder5.page5Audios();
        }
        audioFiles = AudioListHolder5.audioList;
        pageId = AudioListHolder5.pageId;
        audioIndex = AudioListHolder5.audioIndexes;
      } else if (_curr == 5) {
        if (AudioListHolder6.audioList.isEmpty) {
          AudioListHolder6.page6Audios();
        }
        audioFiles = AudioListHolder6.audioList;
        pageId = AudioListHolder6.pageId;
        audioIndex = AudioListHolder6.audioIndexes;
      } else if (_curr == 6) {
        if (AudioListHolder7.audioList.isEmpty) {
          AudioListHolder7.page7Audios();
        }
        audioFiles = AudioListHolder7.audioList;
        pageId = AudioListHolder7.pageId;
        audioIndex = AudioListHolder7.audioIndexes;
      } else if (_curr == 7) {
        if (AudioListHolder8.audioList.isEmpty) {
          AudioListHolder8.page8Audios();
        }
        audioFiles = AudioListHolder8.audioList;
        pageId = AudioListHolder8.pageId;
        audioIndex = AudioListHolder8.audioIndexes;
      } else if (_curr == 8) {
        if (AudioListHolder9.audioList.isEmpty) {
          AudioListHolder9.page9Audios();
        }
        audioFiles = AudioListHolder9.audioList;
        pageId = AudioListHolder9.pageId;
        audioIndex = AudioListHolder9.audioIndexes;
      } else if (_curr == 9) {
        if (AudioListHolder10.audioList.isEmpty) {
          AudioListHolder10.page10Audios();
        }
        audioFiles = AudioListHolder10.audioList;
        pageId = AudioListHolder10.pageId;
        audioIndex = AudioListHolder10.audioIndexes;
      } else if (_curr == 10) {
        if (AudioListHolder11.audioList.isEmpty) {
          AudioListHolder11.page11Audios();
        }
        audioFiles = AudioListHolder11.audioList;
        pageId = AudioListHolder11.pageId;
        audioIndex = AudioListHolder11.audioIndexes;
      } else if (_curr == 11) {
        if (AudioListHolder12.audioList.isEmpty) {
          AudioListHolder12.page12Audios();
        }
        audioFiles = AudioListHolder12.audioList;
        pageId = AudioListHolder12.pageId;
        audioIndex = AudioListHolder12.audioIndexes;
      } else if (_curr == 12) {
        if (AudioListHolder13.audioList.isEmpty) {
          AudioListHolder13.page13Audios();
        }
        audioFiles = AudioListHolder13.audioList;
        pageId = AudioListHolder13.pageId;
        audioIndex = AudioListHolder13.audioIndexes;
      } else if (_curr == 13) {
        if (AudioListHolder14.audioList.isEmpty) {
          AudioListHolder14.page14Audios();
        }
        audioFiles = AudioListHolder14.audioList;
        pageId = AudioListHolder14.pageId;
        audioIndex = AudioListHolder14.audioIndexes;
      } else if (_curr == 14) {
        if (AudioListHolder15.audioList.isEmpty) {
          AudioListHolder15.page15Audios();
        }
        audioFiles = AudioListHolder15.audioList;
        pageId = AudioListHolder15.pageId;
        audioIndex = AudioListHolder15.audioIndexes;
      } else if (_curr == 15) {
        if (AudioListHolder16.audioList.isEmpty) {
          AudioListHolder16.page16Audios();
        }
        audioFiles = AudioListHolder16.audioList;
        pageId = AudioListHolder16.pageId;
        audioIndex = AudioListHolder16.audioIndexes;
      } else if (_curr == 16) {
        if (AudioListHolder17.audioList.isEmpty) {
          AudioListHolder17.page17Audios();
        }
        audioFiles = AudioListHolder17.audioList;
        pageId = AudioListHolder17.pageId;
        audioIndex = AudioListHolder17.audioIndexes;
      } else if (_curr == 17) {
        if (AudioListHolder18.audioList.isEmpty) {
          AudioListHolder18.page18Audios();
        }
        audioFiles = AudioListHolder18.audioList;
        pageId = AudioListHolder18.pageId;
        audioIndex = AudioListHolder18.audioIndexes;
      } else if (_curr == 18) {
        if (AudioListHolder19.audioList.isEmpty) {
          AudioListHolder19.page19Audios();
        }
        audioFiles = AudioListHolder19.audioList;
        pageId = AudioListHolder19.pageId;
        audioIndex = AudioListHolder19.audioIndexes;
      }

      if (audioFiles.isNotEmpty) {
        if (_isPaused) {
          _audioLists[_currentPlayingIndex].play();
        } else {
          _playPageAudios(pageId, audioFiles);
        }
        setState(() {
          _isPlaying = true;
          _isPaused = false;
        });
      }
    } else if (_isPlaying && !_isPaused) {
      _audioLists[_currentPlayingIndex].pause();
      setState(() {
        _isPaused = true;
      });
    } else {}
    // else if (_isPaused) {
    //   _audioLists[_currentPlayingIndex].play();
    //   setState(() {
    //     _isPaused = false; // Set it to false to resume playback
    //   });
    //   // Auto increment to play the next audio
    //   _audioLists[_currentPlayingIndex]
    //       .playerStateStream
    //       .firstWhere(
    //         (state) =>
    //             state.processingState == ProcessingState.completed || _isPaused,
    //       )
    //       .then((_) {
    //     if (!_isPaused) {
    //       skipToNextAudio();
    //     }
    //   });
    // }
  }

  void skipCurrentAudio() {
    if (_isPlaying && !_isPaused) {
      _audioLists[_currentPlayingIndex].stop();
      _skipButton = true;
    }
  }

  void skipToPreviousAudio() {
    if (_isPlaying && !_isPaused && _currentPlayingIndex > 0) {
      _skipPrevious = true;
      _currentPlayingIndex--;
    }
  }

  void onPreviousButtonPressed() {
    skipToPreviousAudio();
  }

  void onSkipButtonPressed() {
    skipCurrentAudio();
  }

  Future<void> _playPageAudios(int pageId, List<String> audioFiles) async {
    try {
      _audioLists.clear();
      //print("Audio Files: $audioFiles"); // Add this print statement

      switch (pageId) {
        case 1:
          for (int i = 0; i < audioFiles.length; i++) {
            AudioPlayer player = AudioPlayer();
            await player.setAsset(audioFiles[i]);
            _audioLists.add(player);
          }
          break;
        case 2:
          for (int i = 0; i < audioFiles.length; i++) {
            AudioPlayer player = AudioPlayer();
            await player.setAsset(audioFiles[i]);
            _audioLists.add(player);
          }
          break;
        case 3:
          for (int i = 0; i < audioFiles.length; i++) {
            AudioPlayer player = AudioPlayer();
            await player.setAsset(audioFiles[i]);
            _audioLists.add(player);
          }
          break;
        case 4:
          for (int i = 0; i < audioFiles.length; i++) {
            AudioPlayer player = AudioPlayer();
            await player.setAsset(audioFiles[i]);
            _audioLists.add(player);
          }
          break;
        case 5:
          for (int i = 0; i < audioFiles.length; i++) {
            AudioPlayer player = AudioPlayer();
            await player.setAsset(audioFiles[i]);
            _audioLists.add(player);
          }
          break;
        case 6:
          for (int i = 0; i < audioFiles.length; i++) {
            AudioPlayer player = AudioPlayer();
            await player.setAsset(audioFiles[i]);
            _audioLists.add(player);
          }
          break;
        case 7:
          for (int i = 0; i < audioFiles.length; i++) {
            AudioPlayer player = AudioPlayer();
            await player.setAsset(audioFiles[i]);
            _audioLists.add(player);
          }
          break;
        case 8:
          for (int i = 0; i < audioFiles.length; i++) {
            AudioPlayer player = AudioPlayer();
            await player.setAsset(audioFiles[i]);
            _audioLists.add(player);
          }
          break;
        case 9:
          for (int i = 0; i < audioFiles.length; i++) {
            AudioPlayer player = AudioPlayer();
            await player.setAsset(audioFiles[i]);
            _audioLists.add(player);
          }
          break;
        case 10:
          for (int i = 0; i < audioFiles.length; i++) {
            AudioPlayer player = AudioPlayer();
            await player.setAsset(audioFiles[i]);
            _audioLists.add(player);
          }
          break;
        case 11:
          for (int i = 0; i < audioFiles.length; i++) {
            AudioPlayer player = AudioPlayer();
            await player.setAsset(audioFiles[i]);
            _audioLists.add(player);
          }
          break;
        case 12:
          for (int i = 0; i < audioFiles.length; i++) {
            AudioPlayer player = AudioPlayer();
            await player.setAsset(audioFiles[i]);
            _audioLists.add(player);
          }
          break;
        case 13:
          for (int i = 0; i < audioFiles.length; i++) {
            AudioPlayer player = AudioPlayer();
            await player.setAsset(audioFiles[i]);
            _audioLists.add(player);
          }
          break;
        case 14:
          for (int i = 0; i < audioFiles.length; i++) {
            AudioPlayer player = AudioPlayer();
            await player.setAsset(audioFiles[i]);
            _audioLists.add(player);
          }
          break;
        case 15:
          for (int i = 0; i < audioFiles.length; i++) {
            AudioPlayer player = AudioPlayer();
            await player.setAsset(audioFiles[i]);
            _audioLists.add(player);
          }
          break;
        case 16:
          for (int i = 0; i < audioFiles.length; i++) {
            AudioPlayer player = AudioPlayer();
            await player.setAsset(audioFiles[i]);
            _audioLists.add(player);
          }
          break;
        case 17:
          for (int i = 0; i < audioFiles.length; i++) {
            AudioPlayer player = AudioPlayer();
            await player.setAsset(audioFiles[i]);
            _audioLists.add(player);
          }
          break;
        case 18:
          for (int i = 0; i < audioFiles.length; i++) {
            AudioPlayer player = AudioPlayer();
            await player.setAsset(audioFiles[i]);
            _audioLists.add(player);
          }
          break;
        case 19:
          for (int i = 0; i < audioFiles.length; i++) {
            AudioPlayer player = AudioPlayer();
            await player.setAsset(audioFiles[i]);
            _audioLists.add(player);
          }
          break;
      }

      //--- Logic For Audio Play + Highlighting the Container
      for (int i = _currentPlayingIndex; i < _audioLists.length; i++) {
        if (_skipButton) {
          _currentPlayingIndex = i + 1;
          _skipButton = false;
        } else if (_skipPrevious) {
          _currentPlayingIndex = i - 1;
          _skipPrevious = false;
          break;
        }
        if (_isPlaying && !_isPaused) {
          if (_currentPageIndex == 0) {
            int audioIndex0 = AudioListHolder1.audioIndexes[i] ?? -1;
            _page1Key[0].currentState?.updateCurrentlyPlayingIndex(audioIndex0);
            await _audioLists[i].play();
          } else if (_currentPageIndex == 1) {
            int audioIndex1 = AudioListHolder2.audioIndexes[i] ?? -1;
            _page2Key[0].currentState?.updateCurrentlyPlayingIndex(audioIndex1);
            await _audioLists[i].play();
          } else if (_currentPageIndex == 2) {
            int audioIndex1 = AudioListHolder3.audioIndexes[i] ?? -1;
            _page3Key[0].currentState?.updateCurrentlyPlayingIndex(audioIndex1);
            await _audioLists[i].play();
          } else if (_currentPageIndex == 3) {
            int audioIndex1 = AudioListHolder4.audioIndexes[i] ?? -1;
            _page4Key[0].currentState?.updateCurrentlyPlayingIndex(audioIndex1);
            await _audioLists[i].play();
          } else if (_currentPageIndex == 4) {
            int audioIndex1 = AudioListHolder5.audioIndexes[i] ?? -1;
            _page5Key[0].currentState?.updateCurrentlyPlayingIndex(audioIndex1);
            await _audioLists[i].play();
          } else if (_currentPageIndex == 5) {
            int audioIndex1 = AudioListHolder6.audioIndexes[i] ?? -1;
            _page6Key[0].currentState?.updateCurrentlyPlayingIndex(audioIndex1);
            await _audioLists[i].play();
          } else if (_currentPageIndex == 6) {
            int audioIndex1 = AudioListHolder7.audioIndexes[i] ?? -1;
            _page7Key[0].currentState?.updateCurrentlyPlayingIndex(audioIndex1);
            await _audioLists[i].play();
          } else if (_currentPageIndex == 7) {
            int audioIndex1 = AudioListHolder8.audioIndexes[i] ?? -1;
            _page8Key[0].currentState?.updateCurrentlyPlayingIndex(audioIndex1);
            await _audioLists[i].play();
          } else if (_currentPageIndex == 8) {
            int audioIndex1 = AudioListHolder9.audioIndexes[i] ?? -1;
            _page9Key[0].currentState?.updateCurrentlyPlayingIndex(audioIndex1);
            await _audioLists[i].play();
          } else if (_currentPageIndex == 9) {
            int audioIndex1 = AudioListHolder10.audioIndexes[i] ?? -1;
            _page10Key[0]
                .currentState
                ?.updateCurrentlyPlayingIndex(audioIndex1);
            await _audioLists[i].play();
          } else if (_currentPageIndex == 10) {
            int audioIndex1 = AudioListHolder11.audioIndexes[i] ?? -1;
            _page11Key[0]
                .currentState
                ?.updateCurrentlyPlayingIndex(audioIndex1);
            await _audioLists[i].play();
          } else if (_currentPageIndex == 11) {
            int audioIndex1 = AudioListHolder12.audioIndexes[i] ?? -1;
            _page12Key[0]
                .currentState
                ?.updateCurrentlyPlayingIndex(audioIndex1);
            await _audioLists[i].play();
          } else if (_currentPageIndex == 12) {
            int audioIndex1 = AudioListHolder13.audioIndexes[i] ?? -1;
            _page13Key[0]
                .currentState
                ?.updateCurrentlyPlayingIndex(audioIndex1);
            await _audioLists[i].play();
          } else if (_currentPageIndex == 13) {
            int audioIndex1 = AudioListHolder14.audioIndexes[i] ?? -1;
            _page14Key[0]
                .currentState
                ?.updateCurrentlyPlayingIndex(audioIndex1);
            await _audioLists[i].play();
          } else if (_currentPageIndex == 14) {
            int audioIndex1 = AudioListHolder15.audioIndexes[i] ?? -1;
            _page15Key[0]
                .currentState
                ?.updateCurrentlyPlayingIndex(audioIndex1);
            await _audioLists[i].play();
          } else if (_currentPageIndex == 15) {
            int audioIndex1 = AudioListHolder16.audioIndexes[i] ?? -1;
            _page16Key[0]
                .currentState
                ?.updateCurrentlyPlayingIndex(audioIndex1);
            await _audioLists[i].play();
          } else if (_currentPageIndex == 16) {
            int audioIndex1 = AudioListHolder17.audioIndexes[i] ?? -1;
            _page17Key[0]
                .currentState
                ?.updateCurrentlyPlayingIndex(audioIndex1);
            await _audioLists[i].play();
          } else if (_currentPageIndex == 17) {
            int audioIndex1 = AudioListHolder18.audioIndexes[i] ?? -1;
            _page18Key[0]
                .currentState
                ?.updateCurrentlyPlayingIndex(audioIndex1);
            await _audioLists[i].play();
          } else if (_currentPageIndex == 18) {
            int audioIndex1 = AudioListHolder19.audioIndexes[i] ?? -1;
            _page19Key[0]
                .currentState
                ?.updateCurrentlyPlayingIndex(audioIndex1);
            await _audioLists[i].play();
          }
        }

        await _audioLists[i].playerStateStream.firstWhere((state) =>
            state.processingState == ProcessingState.completed ||
            _isPaused ||
            _skipButton ||
            _skipPrevious);

        if (_skipButton) {
          _currentPlayingIndex = i + 1;
          _skipButton = false;
        }
        if (_skipPrevious) {
          _currentPlayingIndex = i - 1;
          _skipPrevious = false;
          break;
        }

        if (i == _audioLists.length - 1) {
          if (_currentPageIndex == 0) {
            _page1Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          } else if (_currentPageIndex == 1) {
            _page2Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          } else if (_currentPageIndex == 2) {
            _page3Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          } else if (_currentPageIndex == 3) {
            _page4Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          } else if (_currentPageIndex == 4) {
            _page5Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          } else if (_currentPageIndex == 5) {
            _page6Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          } else if (_currentPageIndex == 6) {
            _page7Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          } else if (_currentPageIndex == 7) {
            _page8Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          } else if (_currentPageIndex == 8) {
            _page9Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          } else if (_currentPageIndex == 9) {
            _page10Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          } else if (_currentPageIndex == 10) {
            _page11Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          } else if (_currentPageIndex == 11) {
            _page12Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          } else if (_currentPageIndex == 12) {
            _page13Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          } else if (_currentPageIndex == 13) {
            _page14Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          } else if (_currentPageIndex == 14) {
            _page15Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          } else if (_currentPageIndex == 15) {
            _page16Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          } else if (_currentPageIndex == 16) {
            _page17Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          } else if (_currentPageIndex == 17) {
            _page18Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          } else if (_currentPageIndex == 18) {
            _page19Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          }
        }
        //---

        // Logic to Check If audio playback is paused & Loop
        if (_isPaused) {
          _currentPlayingIndex = i + 1;
          setState(() {
            if (i == _audioLists.length - 1) {
              bool isLooping = _loop;
              if (isLooping) {
                _currentPlayingIndex = 0;
                if (!_loop) {
                  setState(() {
                    _isPlaying = false;
                  });
                  if (pageId == 1) {
                    _page1Key[0].currentState?.clearSelection();
                  } else if (pageId == 2) {
                    _page2Key[0].currentState?.clearSelection();
                  } else if (pageId == 3) {
                    _page3Key[0].currentState?.clearSelection();
                  } else if (pageId == 4) {
                    _page4Key[0].currentState?.clearSelection();
                  } else if (pageId == 5) {
                    _page5Key[0].currentState?.clearSelection();
                  } else if (pageId == 6) {
                    _page6Key[0].currentState?.clearSelection();
                  } else if (pageId == 7) {
                    _page7Key[0].currentState?.clearSelection();
                  } else if (pageId == 8) {
                    _page8Key[0].currentState?.clearSelection();
                  } else if (pageId == 9) {
                    _page9Key[0].currentState?.clearSelection();
                  } else if (pageId == 10) {
                    _page10Key[0].currentState?.clearSelection();
                  } else if (pageId == 11) {
                    _page11Key[0].currentState?.clearSelection();
                  } else if (pageId == 12) {
                    _page12Key[0].currentState?.clearSelection();
                  } else if (pageId == 13) {
                    _page13Key[0].currentState?.clearSelection();
                  } else if (pageId == 14) {
                    _page14Key[0].currentState?.clearSelection();
                  } else if (pageId == 15) {
                    _page15Key[0].currentState?.clearSelection();
                  } else if (pageId == 16) {
                    _page16Key[0].currentState?.clearSelection();
                  } else if (pageId == 17) {
                    _page17Key[0].currentState?.clearSelection();
                  } else if (pageId == 18) {
                    _page18Key[0].currentState?.clearSelection();
                  } else if (pageId == 19) {
                    _page19Key[0].currentState?.clearSelection();
                  }
                }
                _playPageAudios(pageId, audioFiles);
              } else {
                _currentPlayingIndex = 0;
                if (pageId == 1) {
                  _page1Key[0].currentState?.clearSelection();
                } else if (pageId == 2) {
                  _page2Key[0].currentState?.clearSelection();
                } else if (pageId == 3) {
                  _page3Key[0].currentState?.clearSelection();
                } else if (pageId == 4) {
                  _page4Key[0].currentState?.clearSelection();
                } else if (pageId == 5) {
                  _page5Key[0].currentState?.clearSelection();
                } else if (pageId == 6) {
                  _page6Key[0].currentState?.clearSelection();
                } else if (pageId == 7) {
                  _page7Key[0].currentState?.clearSelection();
                } else if (pageId == 8) {
                  _page8Key[0].currentState?.clearSelection();
                } else if (pageId == 9) {
                  _page9Key[0].currentState?.clearSelection();
                } else if (pageId == 10) {
                  _page10Key[0].currentState?.clearSelection();
                } else if (pageId == 11) {
                  _page11Key[0].currentState?.clearSelection();
                } else if (pageId == 12) {
                  _page12Key[0].currentState?.clearSelection();
                } else if (pageId == 13) {
                  _page13Key[0].currentState?.clearSelection();
                } else if (pageId == 14) {
                  _page14Key[0].currentState?.clearSelection();
                } else if (pageId == 15) {
                  _page15Key[0].currentState?.clearSelection();
                } else if (pageId == 16) {
                  _page16Key[0].currentState?.clearSelection();
                } else if (pageId == 17) {
                  _page17Key[0].currentState?.clearSelection();
                } else if (pageId == 18) {
                  _page18Key[0].currentState?.clearSelection();
                } else if (pageId == 19) {
                  _page19Key[0].currentState?.clearSelection();
                }
              }
            }
          });
          break;
        }
        //---

        // Reset the player for the next iteration
        await _audioLists[i].stop();
        await _audioLists[i].seek(Duration.zero);

        bool isLooping = _loop;
        if (i == _audioLists.length - 1) {
          if (isLooping) {
            _currentPlayingIndex = 0;
            if (!_loop) {
              setState(() {
                _isPlaying = false;
              });
              if (pageId == 1) {
                _page1Key[0].currentState?.clearSelection();
              } else if (pageId == 2) {
                _page2Key[0].currentState?.clearSelection();
              } else if (pageId == 3) {
                _page3Key[0].currentState?.clearSelection();
              } else if (pageId == 4) {
                _page4Key[0].currentState?.clearSelection();
              } else if (pageId == 5) {
                _page5Key[0].currentState?.clearSelection();
              } else if (pageId == 6) {
                _page6Key[0].currentState?.clearSelection();
              } else if (pageId == 7) {
                _page7Key[0].currentState?.clearSelection();
              } else if (pageId == 8) {
                _page8Key[0].currentState?.clearSelection();
              } else if (pageId == 9) {
                _page9Key[0].currentState?.clearSelection();
              } else if (pageId == 10) {
                _page10Key[0].currentState?.clearSelection();
              } else if (pageId == 11) {
                _page11Key[0].currentState?.clearSelection();
              } else if (pageId == 12) {
                _page12Key[0].currentState?.clearSelection();
              } else if (pageId == 13) {
                _page13Key[0].currentState?.clearSelection();
              } else if (pageId == 14) {
                _page14Key[0].currentState?.clearSelection();
              } else if (pageId == 15) {
                _page15Key[0].currentState?.clearSelection();
              } else if (pageId == 16) {
                _page16Key[0].currentState?.clearSelection();
              } else if (pageId == 17) {
                _page17Key[0].currentState?.clearSelection();
              } else if (pageId == 18) {
                _page18Key[0].currentState?.clearSelection();
              } else if (pageId == 19) {
                _page19Key[0].currentState?.clearSelection();
              }
            }
            await _playPageAudios(pageId, audioFiles);
          } else {
            _currentPlayingIndex = 0;
            if (pageId == 1) {
              _page1Key[0].currentState?.clearSelection();
            } else if (pageId == 2) {
              _page2Key[0].currentState?.clearSelection();
            } else if (pageId == 3) {
              _page3Key[0].currentState?.clearSelection();
            } else if (pageId == 4) {
              _page4Key[0].currentState?.clearSelection();
            } else if (pageId == 5) {
              _page5Key[0].currentState?.clearSelection();
            } else if (pageId == 6) {
              _page6Key[0].currentState?.clearSelection();
            } else if (pageId == 7) {
              _page7Key[0].currentState?.clearSelection();
            } else if (pageId == 8) {
              _page8Key[0].currentState?.clearSelection();
            } else if (pageId == 9) {
              _page9Key[0].currentState?.clearSelection();
            } else if (pageId == 10) {
              _page10Key[0].currentState?.clearSelection();
            } else if (pageId == 11) {
              _page11Key[0].currentState?.clearSelection();
            } else if (pageId == 12) {
              _page12Key[0].currentState?.clearSelection();
            } else if (pageId == 13) {
              _page13Key[0].currentState?.clearSelection();
            } else if (pageId == 14) {
              _page14Key[0].currentState?.clearSelection();
            } else if (pageId == 15) {
              _page15Key[0].currentState?.clearSelection();
            } else if (pageId == 16) {
              _page16Key[0].currentState?.clearSelection();
            } else if (pageId == 17) {
              _page17Key[0].currentState?.clearSelection();
            } else if (pageId == 18) {
              _page18Key[0].currentState?.clearSelection();
            } else if (pageId == 19) {
              _page19Key[0].currentState?.clearSelection();
            }
            break;
          }
        }
      }
      setState(() {
        _isPlaying = false;
        _isPaused = false;
      });
    } catch (e) {
      print('Error playing audios: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: widget.initialPage);
    _curr = widget.initialPage;
    _initList();
    // print('current page index selected is $_currentPageIndex');
  }

  @override
  void dispose() {
    controller.dispose();
    _audioPlayer.dispose();
    for (int i = 0; i < _audioLists.length; i++) {
      _audioLists[i].dispose();
    }
    super.dispose();
  }

  void updateMultipleSelectionEnabled(bool value) {
    setState(() {
      _isMultipleSelectionEnabled = value;
    });
  }

  void selectWords(bool value) {
    if (_isPlaying) {
      stopAudioPlayer();
    }
    setState(() {
      _isMultipleSelectionEnabled = value;
    });
    _updateList();
  }

  void fetchstop() {
    if (_isPlaying) {
      _stopPageAudios();
    }
  }

  void _initList() {
    setState(() {
      _list = [
        Center(
            child: Page1(
          key: _page1Key[0],
          isMultipleSelectionEnabled: false,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        )),
        Center(
            child: Page2(
          key: _page2Key[0],
          isMultipleSelectionEnabled: false,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        )),
        Center(
            child: Page3(
          key: _page3Key[0],
          isMultipleSelectionEnabled: false,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        )),
        Center(
            child: Page4(
          key: _page4Key[0],
          isMultipleSelectionEnabled: false,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        )),
        Center(
            child: Page5(
          key: _page5Key[0],
          isMultipleSelectionEnabled: false,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        )),
        Center(
            child: Page6(
          key: _page6Key[0],
          isMultipleSelectionEnabled: false,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        )),
        Center(
            child: Page7(
          key: _page7Key[0],
          isMultipleSelectionEnabled: false,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        )),
        Center(
            child: Page8(
          key: _page8Key[0],
          isMultipleSelectionEnabled: false,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        )),
        Center(
            child: Page9(
          key: _page9Key[0],
          isMultipleSelectionEnabled: false,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        )),
        Center(
            child: Page10(
          key: _page10Key[0],
          isMultipleSelectionEnabled: false,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        )),
        Center(
            child: Page11(
          key: _page11Key[0],
          isMultipleSelectionEnabled: false,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        )),
        Center(
            child: Page12(
          key: _page12Key[0],
          isMultipleSelectionEnabled: false,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        )),
        Center(
            child: Page13(
          key: _page13Key[0],
          isMultipleSelectionEnabled: false,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        )),
        Center(
            child: Page14(
          key: _page14Key[0],
          isMultipleSelectionEnabled: false,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        )),
        Center(
            child: Page15(
          key: _page15Key[0],
          isMultipleSelectionEnabled: false,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        )),
        Center(
            child: Page16(
          key: _page16Key[0],
          isMultipleSelectionEnabled: false,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        )),
        Center(
            child: Page17(
          key: _page17Key[0],
          isMultipleSelectionEnabled: false,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        )),
        Center(
            child: Page18(
          key: _page18Key[0],
          isMultipleSelectionEnabled: false,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        )),
        Center(
            child: Page19(
          key: _page19Key[0],
          isMultipleSelectionEnabled: false,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        )),
      ];
    });
  }

  void _updateList() {
    setState(() {
      _list = List.generate(19, (index) {
        if (index == controller.page?.round()) {
          // If the index matches the current page index, pass the _isMultipleSelectionEnabled value
          return Center(
            child: _getPage(index, _isMultipleSelectionEnabled),
          );
        } else {
          // Otherwise, pass false as the value
          return Center(
            child: _getPage(index, false),
          );
        }
      });
    });
  }

  Widget _getPage(int index, bool isMultipleSelectionEnabled) {
    switch (index) {
      case 0:
        return Page1(
          key: _page1Key[0],
          isMultipleSelectionEnabled: isMultipleSelectionEnabled,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        );
      case 1:
        return Page2(
          key: _page2Key[0],
          isMultipleSelectionEnabled: isMultipleSelectionEnabled,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        );
      case 2:
        return Page3(
          key: _page3Key[0],
          isMultipleSelectionEnabled: isMultipleSelectionEnabled,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        );
      case 3:
        return Page4(
          key: _page4Key[0],
          isMultipleSelectionEnabled: isMultipleSelectionEnabled,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        );
      case 4:
        return Page5(
          key: _page5Key[0],
          isMultipleSelectionEnabled: isMultipleSelectionEnabled,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        );
      case 5:
        return Page6(
          key: _page6Key[0],
          isMultipleSelectionEnabled: isMultipleSelectionEnabled,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        );
      case 6:
        return Page7(
          key: _page7Key[0],
          isMultipleSelectionEnabled: isMultipleSelectionEnabled,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        );
      case 7:
        return Page8(
          key: _page8Key[0],
          isMultipleSelectionEnabled: isMultipleSelectionEnabled,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        );
      case 8:
        return Page9(
          key: _page9Key[0],
          isMultipleSelectionEnabled: isMultipleSelectionEnabled,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        );
      case 9:
        return Page10(
          key: _page10Key[0],
          isMultipleSelectionEnabled: isMultipleSelectionEnabled,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        );
      case 10:
        return Page11(
          key: _page11Key[0],
          isMultipleSelectionEnabled: isMultipleSelectionEnabled,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        );
      case 11:
        return Page12(
          key: _page12Key[0],
          isMultipleSelectionEnabled: isMultipleSelectionEnabled,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        );
      case 12:
        return Page13(
          key: _page13Key[0],
          isMultipleSelectionEnabled: isMultipleSelectionEnabled,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        );
      case 13:
        return Page14(
          key: _page14Key[0],
          isMultipleSelectionEnabled: isMultipleSelectionEnabled,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        );
      case 14:
        return Page15(
          key: _page15Key[0],
          isMultipleSelectionEnabled: isMultipleSelectionEnabled,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        );
      case 15:
        return Page16(
          key: _page16Key[0],
          isMultipleSelectionEnabled: isMultipleSelectionEnabled,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        );
      case 16:
        return Page17(
          key: _page17Key[0],
          isMultipleSelectionEnabled: isMultipleSelectionEnabled,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        );
      case 17:
        return Page18(
          key: _page18Key[0],
          isMultipleSelectionEnabled: isMultipleSelectionEnabled,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        );
      case 18:
        return Page19(
          key: _page19Key[0],
          isMultipleSelectionEnabled: isMultipleSelectionEnabled,
          updateMultipleSelectionEnabled: updateMultipleSelectionEnabled,
        );
      default:
        throw Exception("Invalid page index: $index");
    }
  }

  Future<void> _stopPageAudios() async {
    for (int i = 0; i < _audioLists.length; i++) {
      await _audioLists[i].stop();
    }
    _page1Key[0].currentState?.clearSelection();
    _page1Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
    _page2Key[0].currentState?.clearSelection();
    _page2Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
    _page3Key[0].currentState?.clearSelection();
    _page3Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
    _page4Key[0].currentState?.clearSelection();
    _page1Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
    _page5Key[0].currentState?.clearSelection();
    _page5Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
    _page6Key[0].currentState?.clearSelection();
    _page6Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
    _page7Key[0].currentState?.clearSelection();
    _page7Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
    _page8Key[0].currentState?.clearSelection();
    _page8Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
    _page9Key[0].currentState?.clearSelection();
    _page9Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
    _page10Key[0].currentState?.clearSelection();
    _page10Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
    _page11Key[0].currentState?.clearSelection();
    _page11Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
    _page12Key[0].currentState?.clearSelection();
    _page12Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
    _page13Key[0].currentState?.clearSelection();
    _page13Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
    _page14Key[0].currentState?.clearSelection();
    _page14Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
    _page15Key[0].currentState?.clearSelection();
    _page15Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
    _page16Key[0].currentState?.clearSelection();
    _page16Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
    _page17Key[0].currentState?.clearSelection();
    _page17Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
    _page18Key[0].currentState?.clearSelection();
    _page18Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
    _page19Key[0].currentState?.clearSelection();
    _page19Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
    _isPlaying = false;
  }

  //To Update loop variable Value
  void toggleLoop(bool value) {
    setState(() {
      _loop = value;
    });
  }

  //OnPageChange this method is called to clear the variables
  void updateCurrentPage(int pageIndex) {
    if (controller.page?.toInt() == pageIndex) {
      switch (pageIndex) {
        case 0:
          _page1Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          _page1Key[0].currentState?.clearSelection();
          break;
        case 1:
          _page2Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          _page2Key[0].currentState?.clearSelection();
          break;
        case 2:
          _page3Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          _page3Key[0].currentState?.clearSelection();
          break;
        case 3:
          _page4Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          _page4Key[0].currentState?.clearSelection();
          break;
        case 4:
          _page5Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          _page5Key[0].currentState?.clearSelection();
          break;
        case 5:
          _page6Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          _page6Key[0].currentState?.clearSelection();
          break;
        case 6:
          _page7Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          _page7Key[0].currentState?.clearSelection();
          break;
        case 7:
          _page8Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          _page8Key[0].currentState?.clearSelection();
          break;
        case 8:
          _page9Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          _page9Key[0].currentState?.clearSelection();
          break;
        case 9:
          _page10Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          _page10Key[0].currentState?.clearSelection();
          break;
        case 10:
          _page11Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          _page11Key[0].currentState?.clearSelection();
          break;
        case 11:
          _page12Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          _page12Key[0].currentState?.clearSelection();
          break;
        case 12:
          _page13Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          _page13Key[0].currentState?.clearSelection();
          break;
        case 13:
          _page14Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          _page14Key[0].currentState?.clearSelection();
          break;
        case 14:
          _page15Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          _page15Key[0].currentState?.clearSelection();
          break;
        case 15:
          _page16Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          _page16Key[0].currentState?.clearSelection();
          break;
        case 16:
          _page17Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          _page17Key[0].currentState?.clearSelection();
          break;
        case 17:
          _page18Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          _page18Key[0].currentState?.clearSelection();
          break;
        case 18:
          _page19Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          _page19Key[0].currentState?.clearSelection();
          break;
      }
    }
  }

  //This method is to clear the audio that is playing without selection
  Future<void> stopAudioPlayer() async {
    for (int i = 0; i < _audioLists.length; i++) {
      await _audioLists[i].stop();
    }
    if (controller.page?.toInt() == _curr) {
      switch (_curr) {
        case 0:
          _page1Key[0].currentState?.clearAudioList();
          _page1Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          break;
        case 1:
          _page2Key[0].currentState?.clearAudioList();
          _page2Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          break;
        case 2:
          _page3Key[0].currentState?.clearAudioList();
          _page3Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          break;
        case 3:
          _page4Key[0].currentState?.clearAudioList();
          _page4Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          break;
        case 4:
          _page5Key[0].currentState?.clearAudioList();
          _page5Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          break;
        case 5:
          _page6Key[0].currentState?.clearAudioList();
          _page6Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          break;
        case 6:
          _page7Key[0].currentState?.clearAudioList();
          _page7Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          break;
        case 7:
          _page8Key[0].currentState?.clearAudioList();
          _page8Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          break;
        case 8:
          _page9Key[0].currentState?.clearAudioList();
          _page9Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          break;
        case 9:
          _page10Key[0].currentState?.clearAudioList();
          _page10Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          break;
        case 10:
          _page11Key[0].currentState?.clearAudioList();
          _page11Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          break;
        case 11:
          _page12Key[0].currentState?.clearAudioList();
          _page12Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          break;
        case 12:
          _page13Key[0].currentState?.clearAudioList();
          _page13Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          break;
        case 13:
          _page14Key[0].currentState?.clearAudioList();
          _page14Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          break;
        case 14:
          _page15Key[0].currentState?.clearAudioList();
          _page15Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          break;
        case 15:
          _page16Key[0].currentState?.clearAudioList();
          _page16Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          break;
        case 16:
          _page17Key[0].currentState?.clearAudioList();
          _page17Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          break;
        case 17:
          _page18Key[0].currentState?.clearAudioList();
          _page18Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          break;
        case 18:
          _page19Key[0].currentState?.clearAudioList();
          _page19Key[0].currentState?.updateCurrentlyPlayingIndex(-1);
          break;
      }
    }

    setState(() {
      _isPlaying = false;
    });
  }

  void onPageSelected(int page) {
    setState(() {
      _curr = page;
      _loop = false;
      _isMultipleSelectionEnabled = false;
      _currentPageIndex = page;
      _currentPlayingIndex = 0;
      fetchstop();
      updateCurrentPage(_currentPageIndex);
    });
  }
}
