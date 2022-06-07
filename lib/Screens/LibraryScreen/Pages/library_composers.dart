// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ComposersPage extends StatefulWidget {
  final String title;
  const ComposersPage({Key? key, required this.title}) : super(key: key);

  @override
  State<ComposersPage> createState() => _ComposersPageState();
}

class _ComposersPageState extends State<ComposersPage> {
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
