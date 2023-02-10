import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vdo_player/db/db_model.dart';
import 'package:vdo_player/splash_screen.dart';
// import 'package:device_preview/device_preview.dart';

void main(List<String> args) async {
  await Hive.initFlutter();
  Hive.registerAdapter(PlaylistModelAdapter());
  // runApp(DevicePreview(enabled: true, builder: (context) => const MyApp()));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const SplashScreen(),
    );
  }
}
