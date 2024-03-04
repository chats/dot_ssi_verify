import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'controllers/navbar_controller.dart';
import 'pages/history_page.dart';
import 'pages/home_page.dart';
import 'pages/settings_page.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    final NavbarController navbarController =
        Get.put(NavbarController(), permanent: false);

    return Scaffold(
      body: Obx(() => IndexedStack(
            index: navbarController.tabIndex.value,
            children: [
              HomePage(),
              HistoryPage(),
              SettingsPage(),
            ],
          )),
      bottomNavigationBar: _buildNavigationBar(context, navbarController),
    );
  }

  Widget _buildNavigationBar(
      BuildContext context, NavbarController controller) {
    /*
    return NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: [
          _navDestination(context, iconData: Symbols.home, label: "Home"),
          _navDestination(context, iconData: Symbols.history, label: "History"),
          _navDestination(context,
              iconData: Symbols.settings, label: "Settings"),
        ]);
    */

    return Obx(() => NavigationBar(
            selectedIndex: controller.tabIndex.value,
            onDestinationSelected: controller.changeTabIndex,
            destinations: [
              _navDestination(context, iconData: Symbols.home, label: "Home"),
              _navDestination(context,
                  iconData: Symbols.history, label: "History"),
              _navDestination(context,
                  iconData: Symbols.settings, label: "Settings"),
            ]));
  }

  Widget _navDestination(BuildContext context,
      {required IconData iconData, String? label = ""}) {
    return NavigationDestination(
      selectedIcon: Icon(iconData, color: Theme.of(context).primaryColor),
      icon: Icon(iconData),
      label: label!,
    );
  }
}
