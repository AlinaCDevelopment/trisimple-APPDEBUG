import 'dart:io';

import '../helpers/size_helper.dart';
import '../screens/splash_screen.dart';
import '../services/database_service.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../screens/container_screen.dart';
import '../providers/auth_provider.dart';
import '../views/scan_view.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'constants/colors.dart';
import 'providers/locale_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/auth_screen.dart';

//TODO Set at start the screen size instead of using media queries everywhere
//TODO Fix localizations with iOS: https://www.codeandweb.com/babeledit/tutorials/how-to-translate-your-flutter-apps
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
      overlays: []);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});
  var _prefsRead = false;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //  var isConnectedToWifi = false;

    //ref.read(localeProvider.notifier).getLocaleFromPrefs();
    final locale = ref.watch(localeProvider);
    bool _initialized = false;

    return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        debugShowCheckedModeBanner: false,
        title: 'Trisimple 4',
        theme: ThemeData(
            fontFamily: 'Ubuntu',
            brightness: Brightness.dark,
            primarySwatch: primaryMaterialColor,
            scaffoldBackgroundColor: backMaterialColor,
            appBarTheme: const AppBarTheme(
              backgroundColor: appBarColor,
              titleTextStyle: TextStyle(color: appBarTextColor),
              shadowColor: Colors.transparent,
            ),
            backgroundColor: backMaterialColor,
            canvasColor: Colors.white,
            hintColor: hintColor,
            iconTheme: const IconThemeData(color: backMaterialColor)),
        //themeMode: ThemeMode.dark,
        home: _buildHome(ref));
  }

  Widget _buildHome(WidgetRef ref) {
    final auth = ref.read(authProvider);

    return FutureBuilder<bool>(
        future: ref.read(authProvider.notifier).authenticateFromPreviousLogs(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data!) {
              return ContainerScreen();
            } else {
              return AuthScreen();
            }
          }
          return const SplashScreen();
        });
  }
}
