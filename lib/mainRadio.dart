// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_radio_player/flutter_radio_player.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatefulWidget {
//   final playerState = FlutterRadioPlayer.flutter_radio_paused;

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   int _currentIndex = 0;
//   double volume = 0.8;
//   final _flutterRadioPlayer = FlutterRadioPlayer();

//   @override
//   void initState() {
//     super.initState();
//     initRadioService();
//   }

//   Future<void> initRadioService() async {
//     try {
//       await _flutterRadioPlayer.init(
//         "Flutter Radio Example",
//         "Live",
//         "http://209.133.216.3:7018/stream?type=http&nocache=1906",
//         "false",
//       );
//     } on PlatformException {
//       print("Exception occurred while trying to register the services.");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Flutter Radio Player Example'),
//         ),
//         body: Center(
//           child: Column(
//             children: <Widget>[
//               StreamBuilder(
//                 stream: _flutterRadioPlayer.isPlayingStream,
//                 initialData: widget.playerState,
//                 builder: (BuildContext context, snapshot) {
//                   Object? returnData = snapshot.data;
//                   switch (returnData) {
//                     case FlutterRadioPlayer.flutter_radio_stopped:
//                       return ElevatedButton(
//                         style: ElevatedButton.styleFrom(),
//                         child: Text("Start listening now"),
//                         onPressed: () async {
//                           await initRadioService();
//                         },
//                       );
//                     case FlutterRadioPlayer.flutter_radio_loading:
//                       return Text("Loading stream...");
//                     case FlutterRadioPlayer.flutter_radio_error:
//                       return ElevatedButton(
//                         style: ElevatedButton.styleFrom(),
//                         child: Text("Retry ?"),
//                         onPressed: () async {
//                           await initRadioService();
//                         },
//                       );
//                     default:
//                       return Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           IconButton(
//                             onPressed: () async {
//                               await _flutterRadioPlayer.playOrPause();
//                             },
//                             icon: snapshot.data ==
//                                     FlutterRadioPlayer.flutter_radio_playing
//                                 ? Icon(Icons.pause)
//                                 : Icon(Icons.play_arrow),
//                           ),
//                           IconButton(
//                             onPressed: () async {
//                               await _flutterRadioPlayer.stop();
//                             },
//                             icon: Icon(Icons.stop),
//                           )
//                         ],
//                       );
//                   }
//                 },
//               ),
//               Slider(
//                 value: volume,
//                 min: 0,
//                 max: 1.0,
//                 onChanged: (value) => setState(
//                   () {
//                     volume = value;
//                     _flutterRadioPlayer.setVolume(volume);
//                   },
//                 ),
//               ),
//               Text(
//                 "Volume: " + (volume * 100).toStringAsFixed(0),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               Text("Metadata Track "),
//               StreamBuilder(
//                 initialData: "",
//                 stream: _flutterRadioPlayer.metaDataStream,
//                 builder: (context, snapshot) {
//                   return Text(snapshot.data.toString());
//                 },
//               ),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(),
//                 child: Text("Change URL"),
//                 onPressed: () async {
//                   _flutterRadioPlayer.setUrl(
//                     "http://209.133.216.3:7018/;stream.mp3",
//                     "false",
//                   );
//                 },
//               )
//             ],
//           ),
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//           currentIndex: _currentIndex,
//           onTap: (int index) {
//             setState(() {
//               _currentIndex = index;
//             });
//           },
//           items: const [
//             BottomNavigationBarItem(
//               icon:  Icon(Icons.home),
//               label: "Home",
//             ),
//             BottomNavigationBarItem(
//               icon:  Icon(Icons.pages),
//               label: "Second Page",
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
