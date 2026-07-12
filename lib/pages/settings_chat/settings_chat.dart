import 'package:flutter/material.dart';

import 'package:extera_next/config/app_settings.dart';
import 'settings_chat_view.dart';

class SettingsChat extends StatefulWidget {
  const SettingsChat({super.key});

  @override
  SettingsChatController createState() => SettingsChatController();
}

class SettingsChatController extends State<SettingsChat> {
  void changeMessageFontSize(double d) {
    AppSettings.messageFontSize.setItem(d);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => SettingsChatView(this);
}
