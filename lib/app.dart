import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // for StatusBar control
import 'package:flutter_screenutil/flutter_screenutil.dart'; // for responsive UI
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mindveda/src/navigation/root_navigation.dart.dart';


class CalmflectApp extends HookWidget {
  const CalmflectApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
    ));

    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X baseline
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: isDarkMode ? Brightness.dark : Brightness.light,
          primarySwatch: Colors.deepPurple,
        ),
        home: const RootNavigation(),
      ),
    );
  }
}

