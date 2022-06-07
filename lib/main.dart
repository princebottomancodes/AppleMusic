import 'package:apple_music/Constants/theme.dart';
import 'package:apple_music/Screens/MainScreen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  windowManager();
}

Future windowManager() async {
  await FlutterWindowManager.addFlags(
      FlutterWindowManager.FLAG_LAYOUT_NO_LIMITS);
  await FlutterWindowManager.addFlags(
      FlutterWindowManager.FLAG_LAYOUT_NO_LIMITS);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    setState(() {
      windowManager();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  MainScreen(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
    );
  }
}
