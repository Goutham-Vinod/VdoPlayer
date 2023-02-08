import 'package:fetch_all_videos/fetch_all_videos.dart';
import 'package:flutter/material.dart';
import 'package:vdo_player/db/db_functions.dart';
import 'package:vdo_player/home_screen.dart';
import 'package:vdo_player/common.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 61, 0, 121),
      body: Center(
        child: SizedBox(height: 100, child: Image.asset("assets/logo.png")),
      ),
    );
  }

  @override
  void initState() {
    splashScreenFunctions();
    super.initState();
  }

  Future<void> splashScreenFunctions() async {
    await Future.delayed(const Duration(seconds: 3));
    FetchAllVideos ob = FetchAllVideos();
    videosGlobalNotifier.value = await ob.getAllVideos();

    addDefaultsToDb();
    selectedNaviBarIndexNotifierGlobal.value = 0;
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) {
      return HomeScreen();
    }));
  }
}
