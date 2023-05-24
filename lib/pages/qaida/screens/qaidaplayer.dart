import 'package:flutter/material.dart';

class QaidaPlayer extends StatefulWidget {
  const QaidaPlayer({super.key});

  @override
  _QaidaPlayerState createState() => _QaidaPlayerState();
}

class _QaidaPlayerState extends State<QaidaPlayer> {
  int currentTab = 0;
  double _currentSliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: qaidaplayer(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.play_arrow_sharp),
        onPressed: () {
          // Handle FAB press
        },
      ),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                      //minWidth: 70,
                      onPressed: () {
                        setState(() {
                          print('Share button clicked');
                        });
                      },
                      child: Column(
                        //Settings button
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
                        //Loop Audio
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
                        // Previous Audio Button
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.fast_rewind,
                              color:
                                  currentTab == 0 ? Colors.blue : Colors.grey)
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          // Handle button press
                        });
                      },
                      child: Column(
                        //Next Audio Button
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.fast_forward,
                              color:
                                  currentTab == 0 ? Colors.blue : Colors.grey)
                        ],
                      ),
                    ),
                    // MaterialButton(
                    //   minWidth: 40,
                    //   onPressed: () {
                    //     setState(() {
                    //       // Handle button press
                    //     });
                    //   },
                    //   child: Column(
                    //     //List Button
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Icon(Icons.list,
                    //           color:
                    //               currentTab == 0 ? Colors.blue : Colors.grey)
                    //     ],
                    //   ),
                    // ),
                    // MaterialButton(
                    //   minWidth: 40,
                    //   onPressed: () {
                    //     setState(() {
                    //       // Handle button press
                    //     });
                    //   },
                    //   child: Column(
                    //     //Favourite Button
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Icon(Icons.favorite,
                    //           color:
                    //               currentTab == 0 ? Colors.blue : Colors.grey)
                    //     ],
                    //   ),
                    // ),
                  ],
                )
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
