// ignore_for_file: deprecated_member_use

import 'package:apple_music/Models/music_model.dart';
import 'package:apple_music/Screens/Browse%20Screen/browse_screen.dart';
import 'package:apple_music/Screens/ListenNowScreen/lissten_now_screen.dart';
import 'package:apple_music/Screens/RadioScreen/radio_screen.dart';
import 'package:apple_music/Screens/SearchScreen/search_screen.dart';
import 'package:apple_music/Screens/playscreen.dart';
import 'package:apple_music/Widgets/Inherited/MiniPlayer/miniplayer.dart';
import 'package:apple_music/Widgets/Inherited/MiniPlayer/miniplayer_will_pop_scope.dart';
import 'package:apple_music/Widgets/Inherited/MiniPlayer/utils.dart';
import 'package:apple_music/Widgets/Inherited/tab_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../LibraryScreen/library_screen.dart';

class NavKey {
  static final navKey = GlobalKey<NavigatorState>();
  static final secKey = GlobalKey();
}

class MainScreen extends StatefulWidget {
  String? currentPlayingSong;
  List<SongModel>? songs;
  int? index;
  MainScreen({Key? key, this.currentPlayingSong, this.songs, this.index})
      : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedItemIndex = 0;
  late List screens;
  late bool isExpanded;

  @override
  void initState() {
    isExpanded = false;
    screens = [
      const ListenNowScreen(),
      const BrowseScreen(),
      const RadioScreen(),
      const LibraryScreen(),
      const SearchScreen()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double playerMinHeight = 70;
    double playerMaxHeight = MediaQuery.of(context).size.height;
    const miniplayerPercentageDeclaration = 0.2;

    final ValueNotifier<double> playerExpandProgress =
        ValueNotifier(playerMinHeight);

    ValueNotifier<SongModel?> currentlyPlaying = ValueNotifier(null);

    final MiniplayerController controller = MiniplayerController();

    //Persistent Miniplayer With BottomNavBar
    return MiniplayerWillPopScope(
        onWillPop: () async {
          NavigatorState? navigatorState = NavKey.navKey.currentState;
          if (!navigatorState!.canPop()) {
            return true;
          }
          navigatorState.pop();
          return false;
        },
        child: Scaffold(
          body: Stack(children: [
            Navigator(
              key: widget.key,
              onGenerateRoute: (settings) {
                return CupertinoPageRoute(builder: (context) {
                  return screens[selectedItemIndex];
                });
              },
            ),
            Miniplayer(
                valueNotifier: playerExpandProgress,
                minHeight: playerMinHeight,
                maxHeight: playerMaxHeight,
                controller: controller,
                elevation: 4,
                onDismissed: () => currentlyPlaying.value = null,
                curve: Curves.easeOut,
                builder: (height, percentage) {
                  final bool miniplayer =
                      percentage < miniplayerPercentageDeclaration;
                  if (!miniplayer) {
                    return PlayerScreen();
                  }
                  return ValueListenableBuilder(
                      valueListenable: currentlyPlaying,
                      builder: (context, songModel, child) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 10, top: 5, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const DecoratedBox(
                                        decoration:
                                            BoxDecoration(color: Colors.pink),
                                        child: SizedBox(
                                          height: 50,
                                          width: 50,
                                        )),
                                    Flexible(
                                      child: Text(
                                        'jrt',
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Theme.of(context)
                                              .textSelectionColor,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        CupertinoIcons.pause_fill,
                                        color: Theme.of(context)
                                            .textSelectionColor,
                                        size: 35,
                                      )),
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        CupertinoIcons.forward_fill,
                                        color: Theme.of(context)
                                            .textSelectionColor,
                                        size: 35,
                                      ))
                                ],
                              )
                            ],
                          ),
                        );
                      });
                })
          ]),
          bottomNavigationBar: ValueListenableBuilder(
            valueListenable: playerExpandProgress,
            builder: (BuildContext context, double height, Widget? child) {
              final value = percentageFromValueInRange(
                  min: playerMinHeight, max: playerMaxHeight, value: height);

              num opacity = 1 - value;
              if (opacity < 0) opacity = 0;
              if (opacity > 1) opacity = 1;

              return SizedBox(
                height: 105 - kBottomNavigationBarHeight * value,
                child: Transform.translate(
                  offset: Offset(0.0, kBottomNavigationBarHeight * value * 0.5),
                  child: Opacity(
                    opacity: opacity.toDouble(),
                    child: OverflowBox(
                      child: child,
                    ),
                  ),
                ),
              );
            },
            child: CupertinoTabBar(
                backgroundColor: Theme.of(context).backgroundColor,
                activeColor: Theme.of(context).primaryColor,
                currentIndex: selectedItemIndex,
                onTap: (value) {
                  setState(() {
                    selectedItemIndex = value;
                  });
                },
                items: const [
                  BottomNavigationBarItem(
                      label: 'Listen Now',
                      icon: Icon(CupertinoIcons.play_circle_fill)),
                  BottomNavigationBarItem(
                      label: 'Browse',
                      icon: Icon(CupertinoIcons.square_grid_2x2_fill)),
                  BottomNavigationBarItem(
                      label: 'Radio',
                      icon: Icon(CupertinoIcons.dot_radiowaves_left_right)),
                  BottomNavigationBarItem(
                      label: 'Library',
                      icon: Icon(CupertinoIcons.music_albums_fill)),
                  BottomNavigationBarItem(
                      label: 'Search', icon: Icon(CupertinoIcons.search)),
                ]),
          ),
        ));
  }
}
