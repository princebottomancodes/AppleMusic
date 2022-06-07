// ignore_for_file: deprecated_member_use

import 'package:apple_music/Models/music_model.dart';
import 'package:apple_music/Screens/MainScreen/main_screen.dart';
import 'package:cupertino_lists/cupertino_lists.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongsPage extends StatefulWidget {
  final String title;
  const SongsPage({Key? key, required this.title}) : super(key: key);

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  //define on audio plugin
  final OnAudioQuery _audioQuery = OnAudioQuery();

  //player
  final AudioPlayer _player = AudioPlayer();

  //more variables
  List<SongModel> songs = [];
  String currentSongTitle = '';

  //
  int currentIndex = 0;

  @override
  void initState() {
    MainScreen(songs: songs, currentPlayingSong: currentSongTitle);
    
    requestStoragePermission();
    //update the current playing song index listener
    _player.currentIndexStream.listen((index) {
      if (index != null) {
        _updateCurrentPlayingSongDetails(index);
      }
    });
    super.initState();
  }

  //dispose the player when done
  @override
  void dispose() {
    // _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrollable) => [
                  CupertinoSliverNavigationBar(
                    backgroundColor: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withAlpha(120),
                    leading: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(CupertinoIcons.back,
                                  // size: 26,
                                  color: Theme.of(context).primaryColor),
                              Text(
                                'Library',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              )
                            ]),
                        onPressed: () {
                          Navigator.of(context).maybePop();
                        }),
                    trailing: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Text(
                          'Sort',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        onPressed: () {
                          //ShowPopMenu
                        }),
                    largeTitle: Text(
                      widget.title,
                      style: TextStyle(
                          color: Theme.of(context).textSelectionColor),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: const Padding(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: CupertinoSearchTextField(
                            placeholder: 'Find in Songs',
                          )),
                    ),
                  )
                ],
            body: FutureBuilder<List<SongModel>>(
              //default values
              future: _audioQuery.querySongs(
                orderType: OrderType.ASC_OR_SMALLER,
                uriType: UriType.EXTERNAL,
                ignoreCase: true,
              ),
              builder: (context, item) {
                //loading content indicator
                if (item.data == null) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
                // add songs to the song list
                // songs.clear();
                songs = item.data!;

                return Stack(
                  children: [
                    ListView.separated(
                        separatorBuilder: (context, index) => const Divider(
                            indent: 20, height: 3, color: Colors.grey),
                        padding: EdgeInsets.zero,
                        itemCount: songs.length,
                        itemBuilder: (context, index) {
                          return Expanded(
                            child: CupertinoListTile(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              leading: QueryArtworkWidget(
                                id: songs[index].id,
                                type: ArtworkType.AUDIO,
                              ),
                              title: Text(
                                songs[index].title,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context).textSelectionColor,
                                ),
                              ),
                              subtitle: Text(
                                songs[index].artist!,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                maxLines: 1,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).textSelectionColor),
                              ),
                              trailing: Icon(CupertinoIcons.cloud_download,
                                  color: Theme.of(context).primaryColor),
                              onTap: () async {
                                // Try to load audio from a source and catch any errors.
                                //  String? uri = item.data![index].uri;
                                // await _player.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
                                await _player.setAudioSource(
                                    createPlaylist(item.data!),
                                    initialIndex: index);
                                await _player.play();
                              },
                            ),
                          );
                        }),
                  ],
                );
              },
            )));
  }

  void requestStoragePermission() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await _audioQuery.permissionsRequest();
    }

    //ensure build method is called
    setState(() {});
  }

  //create playlist
  ConcatenatingAudioSource createPlaylist(List<SongModel> songs) {
    List<AudioSource> sources = [];
    for (var song in songs) {
      sources.add(AudioSource.uri(Uri.parse(song.uri!)));
    }
    return ConcatenatingAudioSource(children: sources);
  }

  //update playing song details
  void _updateCurrentPlayingSongDetails(int index) {
    setState(() {
      if (songs.isNotEmpty) {
        currentSongTitle = songs[index].title;
        currentIndex = index;
      }
    });
  }
}
