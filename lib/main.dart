
import 'package:app_debug/services/l10n/app_localizations.dart';

import '../helpers/size_helper.dart';
import '../screens/splash_screen.dart';

import '../screens/container_screen.dart';
import '../providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'constants/colors.dart';
import 'providers/locale_provider.dart';
import 'screens/auth_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
      overlays: []);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

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
            colorScheme: ColorScheme.fromSwatch(
                accentColor: Colors.white,
                brightness: Brightness.dark,
                primarySwatch: backMaterialColor),
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
        home: _buildHome(ref, locale));
  }

  Widget _buildHome(WidgetRef ref, Locale locale) {
    return FutureBuilder<bool>(
        future:
          ref.read(authProvider.notifier).authenticateFromPreviousLogs(),
        builder: (context, snapshot) {
          SizeConfig.init(context);

          if (snapshot.hasData &&
              snapshot.data != null) {
            if (snapshot.data==true) {
              return const ContainerScreen();
            } else {
              return AuthScreen();
            }
          }
          return const SplashScreen();
        });
  }
}
