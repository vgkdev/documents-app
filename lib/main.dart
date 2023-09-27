import 'package:documents_app/themes/global_colors.dart';
import 'package:documents_app/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'controllers/settings_controller.dart';
import 'screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void configLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.light
    ..userInteractions = true
    ..textColor = Colors.black;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Preferences.initPref();
  runApp(const MyApp());
  configLoading();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Documents App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme:
            const AppBarTheme(iconTheme: IconThemeData(color: Colors.black)),
        primaryColor: GlobalColors.lightTheme,
        scaffoldBackgroundColor: GlobalColors.lightTheme,
        // fontFamily: 'PTSerif',
      ),
      // localizationsDelegates: const [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ], // package: flutter_localizations
      builder: EasyLoading.init(),
      home: GetBuilder(
        init: SettingsController(),
        builder: (controller) {
          return const SplashScreen();
        },
      ),
    );
  }
}
