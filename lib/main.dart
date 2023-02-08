import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vdo_player/db/db_model.dart';
import 'package:vdo_player/splash_screen.dart';

void main(List<String> args) async {
  await Hive.initFlutter();
  Hive.registerAdapter(PlaylistModelAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const SplashScreen(),
    );
  }
}
