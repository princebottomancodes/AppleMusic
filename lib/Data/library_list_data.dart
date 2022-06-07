import 'package:flutter/cupertino.dart';

class LibraryListData {
  LibraryListData._();

  static final List<Map<dynamic, dynamic>> libraryListData = [
    {'title': 'Playlists', IconData: CupertinoIcons.music_note_list},
    {'title': 'Artists', IconData: CupertinoIcons.music_mic},
    {'title': 'Albums', IconData: CupertinoIcons.square_stack},
    {'title': 'Songs', IconData: CupertinoIcons.music_note},
    {'title': 'Made For You', IconData: CupertinoIcons.person_crop_rectangle},
    {'title': 'Genres', IconData: CupertinoIcons.guitars},
    {'title': 'Compilations', IconData: CupertinoIcons.person_2_square_stack},
    {'title': 'Composers', IconData: CupertinoIcons.music_note_list},
    {'title': 'Downloaded', IconData: CupertinoIcons.arrow_down_circle},
  ];
}
