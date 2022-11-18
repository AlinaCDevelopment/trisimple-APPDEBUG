import 'dart:io';

import 'package:app_4/views/search_view.dart';
import 'package:app_4/views/tagdata_view.dart';

import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import '../views/scan_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/assets_routes.dart';
import '../constants/colors.dart';
import '../widgets/ui/views_container.dart';
import 'auth_screen.dart';

@immutable
class ViewNotifier extends StateNotifier<String> {
  ViewNotifier() : super(ScanView.name);

  void setView(String routeName) async {
    state = routeName;
  }
}

final viewProvider = StateNotifierProvider<ViewNotifier, String>((ref) {
  return ViewNotifier();
});

class ContainerScreen extends ConsumerStatefulWidget {
  const ContainerScreen({super.key});

  @override
  ConsumerState<ContainerScreen> createState() => _ContainerScreenState();
}

class _ContainerScreenState extends ConsumerState<ContainerScreen> {
  bool isFail = true;
  final screens = {
    // TagDataView.name: const SimpleViewContainer(child: TagDataView()),
    ScanView.name: ViewContainer(child: ScanView()),
    SearchView.name: const SimpleViewContainer(child: SearchView()),
  };
  @override
  Widget build(BuildContext context) {
    final _selectedRouteName = ref.watch(viewProvider);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text(
                    'APP DEV',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: appBarTextColor),
                  ),
                  Text(
                    'ALL WE NEED',
                    style:
                        const TextStyle(fontSize: 12, color: appBarTextColor),
                  ),
                ],
              ),
            ],
          ),
          titleSpacing: 0,
          actions: [
            Consumer(builder: (context, ref, _) {
              final isPt = ref.read(localeProvider).languageCode == 'pt';
              return IconButton(
                icon: Padding(
                  padding: const EdgeInsets.only(
                      left: 3.0, right: 5, top: 1, bottom: 1),
                  child: Image.asset(isPt ? ptImgRoute : enImgRoute),
                ),
                onPressed: () {
                  print('pop');
                  ref
                      .read(localeProvider.notifier)
                      .setLocale(isPt ? 'en' : 'pt');
                },
              );
            })
          ],
          leading: Builder(builder: (context) {
            return IconButton(
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(menuImgRoute),
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          }),
        ),
        drawer: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: [
                  SizedBox(
                    height: 100,
                    child: DrawerHeader(
                      decoration: const BoxDecoration(color: Colors.black),
                      padding: const EdgeInsets.only(left: 10),
                      margin: null,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(bottom: 8.0, right: 15),
                          child: Image.asset(
                            logoImageRoute,
                            height: 50,
                          ),
                        ),
                      ),
                    ),
                  ),

                  //============================================================================================
                  //SCAN
                  DrawerTile(
                    onTap: () => _routeTileTapped(ScanView.name),
                    isSelected: ScanView.name == _selectedRouteName,
                    title: AppLocalizations.of(context).scan.toUpperCase(),
                  ),

                  //============================================================================================
                  //SEARCH
                  DrawerTile(
                    onTap: () => _routeTileTapped(SearchView.name),
                    isSelected: 'search' == _selectedRouteName,
                    title: AppLocalizations.of(context).search.toUpperCase(),
                  ),

                  //============================================================================================
                  //EXIT
                  Consumer(
                    builder: (context, ref, child) {
                      return DrawerTile(
                        onTap: () async {
                          ref.read(authProvider.notifier).resetAuth();

                          //In Android¡'s case we exit the app
                          if (Platform.isAndroid) {
                            SystemChannels.platform
                                .invokeMethod('SystemNavigator.pop');
                            //iOS doesn't allow apps to exit themselves so we go to AuthScreen
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AuthScreen()),
                            );
                          }
                        },
                        isSelected: false,
                        title: AppLocalizations.of(context).exit.toUpperCase(),
                      );
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, bottom: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).contactsLabel,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const Text(
                      '+351 962 260 499',
                      style: TextStyle(
                          color: backMaterialColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      'www.trisimple.pt',
                      style: TextStyle(
                          color: backMaterialColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        body: screens[_selectedRouteName]!,
      ),
    );
  }

  void _routeTileTapped(String name) {
    Navigator.pop(context);
    ref.read(viewProvider.notifier).setView(name);
  }
}

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    Key? key,
    required this.isSelected,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final bool isSelected;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: ListTile(
        title: Text(title),
        selectedColor: Colors.white,
        tileColor: Colors.grey.shade200,
        textColor: backMaterialColor,
        selectedTileColor: backMaterialColor,
        selected: isSelected,
        onTap: onTap,
        trailing: const Padding(
          padding: EdgeInsets.all(3.0),
          child: Icon(Icons.arrow_forward_ios_sharp),
        ),
      ),
    );
  }
}
