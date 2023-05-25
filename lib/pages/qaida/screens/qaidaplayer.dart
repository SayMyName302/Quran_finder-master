import 'package:flutter/material.dart';

class QaidaPlayer extends StatefulWidget {
  final void Function(bool value) selectWords;
  final void Function() playButton;
  final void Function() stopButton;

  const QaidaPlayer(
      {super.key,
      required this.selectWords,
      required this.playButton,
      required this.stopButton});

  @override
  // ignore: library_private_types_in_public_api
  _QaidaPlayerState createState() => _QaidaPlayerState();
}

class _QaidaPlayerState extends State<QaidaPlayer> {
  int currentTab = 0;
  double _currentSliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: qaidaplayer(),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.play_arrow_sharp),
      //   onPressed: () {
      //     widget.playButton();
      //   },
      // ),
    );
  }

  BottomAppBar qaidaplayer() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 5,
      child: SizedBox(
        height: 80, // increased height to accommodate SeekBar
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // align SeekBar to bottom
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialButton(
                      //minWidth: 70,
                      onPressed: () {
                        setState(() {
                          bool buttonValue = true;
                          widget.selectWords(buttonValue);
                        });
                      },
                      child: Column(
                        ////////////Settings button//////////////
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.settings,
                              color:
                                  currentTab == 0 ? Colors.blue : Colors.grey)
                        ],
                      ),
                    ),
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          // Handle button press
                        });
                      },
                      child: Column(
                        ////////////Loop button//////////////
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.loop,
                              color:
                                  currentTab == 0 ? Colors.blue : Colors.grey)
                        ],
                      ),
                    ),
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          // Handle button press
                        });
                      },
                      child: Column(
                        ////////////Previous Audio Button//////////////
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.fast_rewind,
                              color:
                                  currentTab == 0 ? Colors.blue : Colors.grey)
                        ],
                      ),
                    ),
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          widget.playButton();
                        });
                      },
                      child: Column(
                        ////////////Play Audio Button//////////////
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow_sharp,
                              color:
                                  currentTab == 0 ? Colors.blue : Colors.grey)
                        ],
                      ),
                    ),
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          // Handle button press
                        });
                      },
                      child: Column(
                        ////////////Next Audio Button//////////////
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.fast_forward,
                              color:
                                  currentTab == 0 ? Colors.blue : Colors.grey)
                        ],
                      ),
                    ),
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          widget.stopButton();
                        });
                      },
                      child: Column(
                        //Favourite Button
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.stop_sharp,
                              color:
                                  currentTab == 0 ? Colors.blue : Colors.grey)
                        ],
                      ),
                    ),
                  ],
                ),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     // MaterialButton(
                //     //   minWidth: 40,
                //     //   onPressed: () {
                //     //     setState(() {
                //     //       // Handle button press
                //     //     });
                //     //   },
                //     //   child: Column(
                //     //     ////////////Next Audio Button//////////////
                //     //     mainAxisAlignment: MainAxisAlignment.center,
                //     //     children: [
                //     //       Icon(Icons.fast_forward,
                //     //           color:
                //     //               currentTab == 0 ? Colors.blue : Colors.grey)
                //     //     ],
                //     //   ),
                //     // ),
                //     // MaterialButton(
                //     //   minWidth: 40,
                //     //   onPressed: () {
                //     //     setState(() {
                //     //       // Handle button press
                //     //     });
                //     //   },
                //     //   child: Column(
                //     //     //List Button
                //     //     mainAxisAlignment: MainAxisAlignment.center,
                //     //     children: [
                //     //       Icon(Icons.list,
                //     //           color:
                //     //               currentTab == 0 ? Colors.blue : Colors.grey)
                //     //     ],
                //     //   ),
                //     // ),
                //     // MaterialButton(
                //     //   minWidth: 40,
                //     //   onPressed: () {
                //     //     setState(() {
                //     //       widget.stopButton();
                //     //     });
                //     //   },
                //     //   child: Column(
                //     //     //Favourite Button
                //     //     mainAxisAlignment: MainAxisAlignment.center,
                //     //     children: [
                //     //       Icon(Icons.stop_sharp,
                //     //           color:
                //     //               currentTab == 0 ? Colors.blue : Colors.grey)
                //     //     ],
                //     //   ),
                //     // ),
                //   ],
                // )
              ],
            ),
            // added spacing between buttons and SeekBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 20,
                width: 400,
                child: Slider(
                    value: _currentSliderValue,
                    min: 0,
                    max: 100,
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValue = value;
                      });
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
