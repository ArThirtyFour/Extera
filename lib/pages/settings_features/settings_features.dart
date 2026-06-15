import 'package:extera_next/config/setting_keys.dart';
import 'package:extera_next/generated/l10n/l10n.dart';
import 'package:extera_next/widgets/adaptive_dialogs/show_list_choose_dialog.dart';
import 'package:extera_next/widgets/adaptive_dialogs/show_text_input_dialog.dart';
import 'package:flutter/material.dart';

import 'settings_features_view.dart';

class SettingsFeatures extends StatefulWidget {
  const SettingsFeatures({super.key});

  @override
  SettingsFeaturesController createState() => SettingsFeaturesController();
}

class SettingsFeaturesController extends State<SettingsFeatures> {
  void editUIFont() async {
    final newFont = await showTextInputDialog(
      context: context,
      title: L10n.of(context).uiFont,
      maxLines: 1,
      initialText: AppSettings.uiFont.value,
    );
    if (newFont == null) {
      return;
    }
    AppSettings.uiFont.setItem(newFont);
  }

  void editMonospaceFont() async {
    final newFont = await showTextInputDialog(
      context: context,
      title: L10n.of(context).monospaceFont,
      maxLines: 1,
      initialText: AppSettings.monospaceFont.value,
    );
    if (newFont == null) {
      return;
    }
    AppSettings.monospaceFont.setItem(newFont);
  }

  void editChatFont() async {
    final newFont = await showTextInputDialog(
      context: context,
      title: L10n.of(context).chatFont,
      maxLines: 1,
      initialText: AppSettings.chatFont.value,
    );
    if (newFont == null) {
      return;
    }
    AppSettings.chatFont.setItem(newFont);
  }

  void editUIFallbackFonts() async {
    final newFonts = await showListChooseDialog(
      context: context,
      title: L10n.of(context).uiFontFallback,
      initialItems: AppSettings.fallbackFonts.value.split(','),
    );
    if (newFonts == null) {
      return;
    }
    AppSettings.fallbackFonts.setItem(newFonts.join(','));
  }

  void editMonospaceFallbackFonts() async {
    final newFonts = await showListChooseDialog(
      context: context,
      title: L10n.of(context).monospaceFontFallback,
      initialItems: AppSettings.monospaceFallbackFonts.value.split(','),
    );
    if (newFonts == null) {
      return;
    }
    AppSettings.monospaceFallbackFonts.setItem(newFonts.join(','));
  }

  void editChatFallbackFonts() async {
    final newFonts = await showListChooseDialog(
      context: context,
      title: L10n.of(context).chatFontFallback,
      initialItems: AppSettings.chatFallbackFonts.value.split(','),
    );
    if (newFonts == null) {
      return;
    }
    AppSettings.chatFallbackFonts.setItem(newFonts.join(','));
  }

  @override
  Widget build(BuildContext context) => SettingsFeaturesView(this);
}
