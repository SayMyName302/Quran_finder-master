import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nour_al_quran/pages/qaida/screens/custompage.dart';
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
import 'package:nour_al_quran/pages/qaida/screens/qaidaplayer.dart';

class SwipePages extends StatefulWidget {
  const SwipePages({super.key});

  @override
  State<SwipePages> createState() => _SwipePagesState();
}

class _SwipePagesState extends State<SwipePages>
    with SingleTickerProviderStateMixin {
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
  bool _toggleValue = false;
  bool _isExpanded = false;
  bool _clearSelection = false;
  List<Widget> _list = <Widget>[];
  late Animation<double> _animation;
  late AnimationController _controller;
  bool _isMultipleSelectionEnabled = false;
  AudioPlayer _audioPlayer = AudioPlayer();
  List<AudioPlayer> _audioLists = [];
  PageController controller = PageController();
  final TextStyle _buttonTextStyle = const TextStyle(color: Colors.black);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    controller = PageController(initialPage: _curr);
    _initList();
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

  void _showMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.15,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // const SizedBox(height: 16),
                // Row(
                //   children: [
                //     const Text(
                //       'Non-stop reading',
                //       style: TextStyle(fontSize: 16),
                //     ),
                //     const SizedBox(width: 16),
                //     Switch(
                //       value: _toggleValue,
                //       onChanged: (value) {
                //         setState(() {
                //           _toggleValue = value;
                //         });
                //       },
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isMultipleSelectionEnabled =
                            !_isMultipleSelectionEnabled;
                      });
                      _updateList();
                      Navigator.pop(context);
                    },
                    style: _isMultipleSelectionEnabled
                        ? ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            textStyle: const TextStyle(color: Colors.white),
                          )
                        : ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            textStyle: _buttonTextStyle,
                          ),
                    child: const Text('Select the words'),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Future<void> _playPageAudios(int pageId, List<String> audioFiles) async {
    try {
      _audioLists.clear();
      List<AudioPlayer> audioPlayer = [];
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
      int finishedCount = 0;
      for (int i = 0; i < _audioLists.length; i++) {
        setState(() {
          _isPlaying = true;
        });
        await _audioLists[i].play();
        await _audioLists[i].playerStateStream.firstWhere(
            (state) => state.processingState == ProcessingState.completed);
        finishedCount++;
        // Call clearSelection() when all audio files have finished playing
        if (finishedCount == _audioLists.length) {
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
      _isPlaying = false;
    } catch (e) {
      print('Error playing audios: $e');
    }
  }

  Future<void> _stopPageAudios() async {
    for (int i = 0; i < _audioLists.length; i++) {
      await _audioLists[i].stop();
    }
    _page1Key[0].currentState?.clearSelection();
    _page2Key[0].currentState?.clearSelection();
    _page3Key[0].currentState?.clearSelection();
    _page4Key[0].currentState?.clearSelection();
    _page5Key[0].currentState?.clearSelection();
    _page6Key[0].currentState?.clearSelection();
    _page7Key[0].currentState?.clearSelection();
    _page8Key[0].currentState?.clearSelection();
    _page9Key[0].currentState?.clearSelection();
    _page10Key[0].currentState?.clearSelection();
    _page11Key[0].currentState?.clearSelection();
    _page12Key[0].currentState?.clearSelection();
    _page13Key[0].currentState?.clearSelection();
    _page14Key[0].currentState?.clearSelection();
    _page15Key[0].currentState?.clearSelection();
    _page16Key[0].currentState?.clearSelection();
    _page17Key[0].currentState?.clearSelection();
    _page18Key[0].currentState?.clearSelection();
    _page19Key[0].currentState?.clearSelection();
    _isPlaying = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Qaida'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Stack(
        children: [
          PageView(
            allowImplicitScrolling: true,
            scrollDirection: Axis.horizontal,
            controller: controller,
            reverse: true,
            // ignore: avoid_types_as_parameter_names
            onPageChanged: (int num) {
              setState(() {
                _curr = num;
                _isMultipleSelectionEnabled = false;
                _page1Key[0].currentState?.clearSelection();

                _stopPageAudios();
              });
            },
            children: _list,
          ),
          Positioned(
            top: 10,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.settings),
              iconSize: 30,
              onPressed: () {
                _showMenu();
              },
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * .75,
            right: _isExpanded ? 0 : MediaQuery.of(context).size.width,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: MediaQuery.of(context).size.width,
              height: _isExpanded ? 65 : 0,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 100),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: IconButton(
                      onPressed: () async {
                        List<String> audioFiles = [];
                        int pageId = -1;
                        if (_curr == 0) {
                          audioFiles = AudioListHolder1.audioList;
                          pageId = AudioListHolder1.pageId;
                        } else if (_curr == 1) {
                          audioFiles = AudioListHolder2.audioList;
                          pageId = AudioListHolder2.pageId;
                        } else if (_curr == 2) {
                          audioFiles = AudioListHolder3.audioList;
                          pageId = AudioListHolder3.pageId;
                        } else if (_curr == 3) {
                          audioFiles = AudioListHolder4.audioList;
                          pageId = AudioListHolder4.pageId;
                        } else if (_curr == 4) {
                          audioFiles = AudioListHolder5.audioList;
                          pageId = AudioListHolder5.pageId;
                        } else if (_curr == 5) {
                          audioFiles = AudioListHolder6.audioList;
                          pageId = AudioListHolder6.pageId;
                        } else if (_curr == 6) {
                          audioFiles = AudioListHolder7.audioList;
                          pageId = AudioListHolder7.pageId;
                        } else if (_curr == 7) {
                          audioFiles = AudioListHolder8.audioList;
                          pageId = AudioListHolder8.pageId;
                        } else if (_curr == 8) {
                          audioFiles = AudioListHolder9.audioList;
                          pageId = AudioListHolder9.pageId;
                        } else if (_curr == 9) {
                          audioFiles = AudioListHolder10.audioList;
                          pageId = AudioListHolder10.pageId;
                        } else if (_curr == 10) {
                          audioFiles = AudioListHolder11.audioList;
                          pageId = AudioListHolder11.pageId;
                        } else if (_curr == 11) {
                          audioFiles = AudioListHolder12.audioList;
                          pageId = AudioListHolder12.pageId;
                        } else if (_curr == 12) {
                          audioFiles = AudioListHolder13.audioList;
                          pageId = AudioListHolder13.pageId;
                        } else if (_curr == 13) {
                          audioFiles = AudioListHolder14.audioList;
                          pageId = AudioListHolder14.pageId;
                        } else if (_curr == 14) {
                          audioFiles = AudioListHolder15.audioList;
                          pageId = AudioListHolder15.pageId;
                        } else if (_curr == 15) {
                          audioFiles = AudioListHolder16.audioList;
                          pageId = AudioListHolder16.pageId;
                        } else if (_curr == 16) {
                          audioFiles = AudioListHolder17.audioList;
                          pageId = AudioListHolder17.pageId;
                        } else if (_curr == 17) {
                          audioFiles = AudioListHolder18.audioList;
                          pageId = AudioListHolder18.pageId;
                        } else if (_curr == 18) {
                          audioFiles = AudioListHolder19.audioList;
                          pageId = AudioListHolder19.pageId;
                        }
                        if (audioFiles.isNotEmpty) {
                          //       print("List of audio files: $audioFiles");
                          await _playPageAudios(pageId, audioFiles);
                        }
                        //  print('Curr = $_curr');
                      },
                      icon: const Icon(
                        Icons.play_arrow,
                        size: 18,
                      ),
                      color: Colors.white,
                      iconSize: 0.0,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(width: 50),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: IconButton(
                      onPressed: _isPlaying
                          ? () async {
                              await _stopPageAudios();
                            }
                          : () {},
                      icon: const Icon(
                        Icons.stop,
                        size: 18,
                      ),
                      color: Colors.white,
                      iconSize: 0.0,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Positioned(
          //   top: MediaQuery.of(context).size.height * .78,
          //   right: MediaQuery.of(context).size.width * .06,
          //   child: SizedBox(
          //     height: 20,
          //     width: 20,
          //     child: FloatingActionButton(
          //       backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          //       onPressed: () {
          //         setState(() {
          //           _isExpanded = !_isExpanded;
          //         });
          //       },
          //       child: Icon(
          //         _isExpanded ? Icons.close : Icons.menu,
          //         size: 18,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
      // bottomNavigationBar: CustomPageIndicator(
      //   total: _list.length,
      //   controller: controller,
      // ),
      bottomNavigationBar: const SizedBox(
        height: 90,
        child: QaidaPlayer(),
      ),
    );
  }
}

//-> Implemented Correctly!!!
//-> On Page Change The Select words button is setting to FALSE :)
//-> _isMultipleSelectionEnabled getting updated back in SwipePage
//->    when the selection is cleared.
//-> _isMultipleSelectionEnabled value is Passed to only current Page!