import 'package:flutter/material.dart';

import 'package:theme_provider/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSwitches extends StatefulWidget {
  @override
  _ProfileSwitchesState createState() => _ProfileSwitchesState();
}

class _ProfileSwitchesState extends State<ProfileSwitches> {
  bool isDark = false;
  bool noti = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile.adaptive(
          title: Text(
            'Dark Theme',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          activeColor: Theme.of(context).primaryColor,
          value: isDark,
          onChanged: (value) {
            setState(() {
              isDark = value;
            });
            ThemeProvider.controllerOf(context).setTheme(
              isDark ? 'dark_theme' : 'light_theme',
            );
            ThemeProvider.controllerOf(context).saveThemeToDisk();
          },
        ),
        SwitchListTile.adaptive(
          title: Text(
            'Notifications',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          activeColor: Theme.of(context).primaryColor,
          value: noti,
          onChanged: (value) {
            setState(() {
              noti = value;
            });
          },
        )
      ],
    );
  }
}
