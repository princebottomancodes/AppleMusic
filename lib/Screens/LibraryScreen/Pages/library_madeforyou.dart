// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MadeForYouPage extends StatefulWidget {
  final String title;
  const MadeForYouPage({Key? key, required this.title}) : super(key: key);

  @override
  State<MadeForYouPage> createState() => _MadeForYouPageState();
}

class _MadeForYouPageState extends State<MadeForYouPage> {
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
