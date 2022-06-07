// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BrowseScreen extends StatelessWidget {
  const BrowseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                CupertinoSliverNavigationBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    border: const Border(),
                    largeTitle: Text('Browse',
                        style: TextStyle(
                            color: Theme.of(context).textSelectionColor)))
              ];
            },
            body: Container()));
  }
}
