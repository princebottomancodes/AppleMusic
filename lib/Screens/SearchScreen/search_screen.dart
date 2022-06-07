// ignore_for_file: deprecated_member_use
import 'package:apple_music/Screens/SearchScreen/search_gridview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: NestedScrollView(
            physics: const ClampingScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                CupertinoSliverNavigationBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor.withAlpha(150),
                    border: const Border(),
                    largeTitle: Text('Search',
                        style: TextStyle(
                            color: Theme.of(context).textSelectionColor))),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 15, left: 15, right: 15),
                    child: CupertinoSearchTextField(
                      placeholder: 'Artists, Songs, Lyrics and more',
                    ),
                  ),
                )
              ];
            },
            body: const SearchGridView()));
  }
}
