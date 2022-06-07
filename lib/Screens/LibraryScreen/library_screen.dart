// ignore_for_file: deprecated_member_use

import 'package:apple_music/Data/library_list_data.dart';
import 'package:cupertino_lists/cupertino_lists.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:flutter_swipe_action_cell/core/controller.dart';

import 'Pages/library_albums_page.dart';
import 'Pages/library_artists_page.dart';
import 'Pages/library_compilations.dart';
import 'Pages/library_composers.dart';
import 'Pages/library_downloaded.dart';
import 'Pages/library_genres.dart';
import 'Pages/library_madeforyou.dart';
import 'Pages/library_playlists_page.dart';
import 'Pages/library_songs_page.dart';

// ignore: must_be_immutable
class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key,}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  //Default value is false
  bool isEditMode = false;

  /// To controll edit mode, this variable is later initialized
  late SwipeActionController editController;

  ///initState
  @override
  void initState() {
    super.initState();
    editController = SwipeActionController();
  }

  @override
  Widget build(BuildContext context) {
    List<int> selectedIndexes = editController.getSelectedIndexPaths();

    return CupertinoPageScaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                CupertinoSliverNavigationBar(
                  backgroundColor:
                      Theme.of(context).scaffoldBackgroundColor.withAlpha(120),
                  border: const Border(),
                  largeTitle: Text('Library',
                      style: TextStyle(
                          color: Theme.of(context).textSelectionColor)),
                  trailing: CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Text(isEditMode ? '   Done' : '   Edit',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                      onPressed: () {
                        if (isEditMode == true) {
                          setState(() {
                            isEditMode = false;
                            editController.stopEditingMode();
                          });
                        } else {
                          setState(() {
                            isEditMode = true;
                            editController.startEditingMode();
                          });
                        }
                      }),
                )
              ];
            },
            body: ListView.separated(
                separatorBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Divider(
                      height: 2,
                      thickness: .15,
                      color: CupertinoColors.inactiveGray,
                    ),
                  );
                },
                itemCount: isEditMode
                    ? LibraryListData.libraryListData.length
                    : selectedIndexes.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return SwipeActionCell(
                      selectedForegroundColor: Colors.transparent,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      controller: editController,
                      index: index,
                      unselectedIndicator: Icon(CupertinoIcons.circle,
                          color: Theme.of(context).primaryColor),
                      selectedIndicator: Icon(
                          CupertinoIcons.check_mark_circled_solid,
                          color: Theme.of(context).primaryColor),
                      key: ValueKey(LibraryListData.libraryListData[index]),
                      child: CupertinoListTile(
                        backgroundColorActivated:
                            CupertinoColors.systemGrey3.withAlpha(70),
                        leading: Icon(
                            LibraryListData.libraryListData[index][IconData],
                            color: Theme.of(context).primaryColor),
                        title: Text(
                            LibraryListData.libraryListData[index]['title'],
                            style: TextStyle(
                                color: Theme.of(context).textSelectionColor)),
                        trailing: Icon(
                          CupertinoIcons.right_chevron,
                          size: CupertinoTheme.of(context)
                              .textTheme
                              .textStyle
                              .fontSize,
                          color:
                              CupertinoColors.systemGrey2.resolveFrom(context),
                        ),
                        onTap: () {
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) {
                            switch (index) {
                              case 0:
                                return PlaylistsPage(
                                    title: LibraryListData
                                        .libraryListData[index]['title']);
                              case 1:
                                return ArtistsPage(
                                    title: LibraryListData
                                        .libraryListData[index]['title']);
                              case 2:
                                return AlbumsPage(
                                    title: LibraryListData
                                        .libraryListData[index]['title']);
                              case 3:
                                return SongsPage(
                                    title: LibraryListData
                                        .libraryListData[index]['title']);
                              case 4:
                                return MadeForYouPage(
                                    title: LibraryListData
                                        .libraryListData[index]['title']);
                              case 5:
                                return GenresPage(
                                    title: LibraryListData
                                        .libraryListData[index]['title']);
                              case 6:
                                return CompilationsPage(
                                    title: LibraryListData
                                        .libraryListData[index]['title']);
                              case 7:
                                return ComposersPage(
                                    title: LibraryListData
                                        .libraryListData[index]['title']);
                              case 8:
                                return DownloadedPage(
                                    title: LibraryListData
                                        .libraryListData[index]['title']);
                              default:
                                return const Center();
                            }
                          }));
                        },
                      ));
                })));
  }
}
