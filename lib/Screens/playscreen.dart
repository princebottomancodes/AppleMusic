// ignore_for_file: deprecated_member_use

import 'package:apple_music/Models/music_model.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80, bottom: 25),
            // child: Container(
            //     height: MediaQuery.of(context).size.width,
            //     width: MediaQuery.of(context).size.width,
            //     color: Colors.blue),
            // child: QueryArtworkWidget(
            //   id: artworkId,
            //   type: artworkType,
            //   artworkBorder: BorderRadius.circular(15),
            // ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '',
                    style: TextStyle(
                        color: Theme.of(context).textSelectionColor,
                        fontSize: 18),
                  ),
                  Text(
                    '',
                    style: TextStyle(
                        color: Theme.of(context).textSelectionColor,
                        fontSize: 17),
                  )
                ],
              ),
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).backgroundColor),
                child: Center(
                  child: Icon(CupertinoIcons.ellipsis,
                      size: 24, color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const ProgressBar(progress: Duration(), total: Duration()),
          const SizedBox(
            height: 10,
          ),
          Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    CupertinoIcons.backward_fill,
                    color: Theme.of(context).textSelectionColor,
                    size: 50,
                  ),
                  Icon(
                    CupertinoIcons.pause_fill,
                    color: Theme.of(context).textSelectionColor,
                    size: 55,
                  ),
                  Icon(
                    CupertinoIcons.forward_fill,
                    color: Theme.of(context).textSelectionColor,
                    size: 50,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: const [
                  Icon(
                    CupertinoIcons.quote_bubble,
                    color: Colors.grey,
                    size: 22,
                  ),
                  Icon(
                    CupertinoIcons.dot_radiowaves_left_right,
                    color: Colors.grey,
                    size: 22,
                  ),
                  Icon(
                    CupertinoIcons.line_horizontal_3,
                    color: Colors.grey,
                    size: 22,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
