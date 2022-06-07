import 'package:apple_music/Data/search_grid_data.dart';
import 'package:flutter/material.dart';

class SearchGridView extends StatelessWidget {
  const SearchGridView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: const EdgeInsets.only(left: 15,right:15),
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 15,
            childAspectRatio: 1.5),
        itemCount: SearchGridData.gridList.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                    centerSlice: Rect.largest,
                    image: AssetImage(SearchGridData.gridList[index])),
                borderRadius: BorderRadius.circular(15)),
          );
        });
  }
}
