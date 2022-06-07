// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlaylistsPage extends StatefulWidget {
  final String title;
  const PlaylistsPage({Key? key, required this.title}) : super(key: key);

  @override
  State<PlaylistsPage> createState() => _PlaylistsPageState();
}

class _PlaylistsPageState extends State<PlaylistsPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrollable) => [
                  CupertinoSliverNavigationBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    largeTitle: Text(
                      widget.title,
                      style: TextStyle(
                          color: Theme.of(context).textSelectionColor),
                    ),
                  )
                ],
            body: Container()));
  }
}
