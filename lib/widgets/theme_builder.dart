import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:extera_next/utils/color_value.dart';

class ThemeBuilder extends StatefulWidget {
  final Widget Function(
    BuildContext context,
    ThemeMode themeMode,
    Color? primaryColor,
    DynamicSchemeVariant schemeVariant,
    bool pureBlack,
    bool twemoji,
    Locale? locale,
  )
  builder;

  final String themeModeSettingsKey;
  final String primaryColorSettingsKey;
  final String pureBlackSettingsKey;
  final String twemojiSettingsKey;
  final String schemeVariantSettingsKey;
  final String localeSettingsKey;

  const ThemeBuilder({
    required this.builder,
    this.themeModeSettingsKey = 'xyz.extera.next.themeMode',
    this.primaryColorSettingsKey = 'xyz.extera.next.colorSchemeSeed',
    this.pureBlackSettingsKey = 'xyz.extera.next.pureBlack',
    this.twemojiSettingsKey = 'xyz.extera.next.twemojiFont',
    this.schemeVariantSettingsKey = 'xyz.extera.next.schemeVariant',
    this.localeSettingsKey = 'xyz.extera.next.appLanguage',
    super.key,
  });

  @override
  State<ThemeBuilder> createState() => ThemeController();
}

class ThemeController extends State<ThemeBuilder> {
  SharedPreferences? _sharedPreferences;
  ThemeMode? _themeMode;
  Color? _primaryColor;
  bool? _pureBlack;
  bool? _twemoji;
  DynamicSchemeVariant? _variant;
  Locale? _locale;

  ThemeMode get themeMode => _themeMode ?? ThemeMode.system;

  Color? get primaryColor => _primaryColor;

  bool get pureBlack => _pureBlack ?? false;

  bool get twemoji => _twemoji ?? false;

  /// The user selected app language, or `null` to follow the system locale.
  Locale? get locale => _locale;

  DynamicSchemeVariant get variant =>
      _variant ?? DynamicSchemeVariant.tonalSpot;

  static ThemeController of(BuildContext context) =>
      Provider.of<ThemeController>(context, listen: false);

  void _loadData(_) async {
    final preferences = _sharedPreferences ??=
        await SharedPreferences.getInstance();

    final rawThemeMode = preferences.getString(widget.themeModeSettingsKey);
    final rawColor = preferences.getInt(widget.primaryColorSettingsKey);
    final rawPureBlack = preferences.getBool(widget.pureBlackSettingsKey);
    final rawTwemoji = preferences.getBool(widget.twemojiSettingsKey);
    final rawVariant =
        preferences.getInt(widget.schemeVariantSettingsKey) ??
        DynamicSchemeVariant.values.indexOf(.tonalSpot);
    final rawLocale = preferences.getString(widget.localeSettingsKey);

    setState(() {
      _themeMode = ThemeMode.values.singleWhereOrNull(
        (value) => value.name == rawThemeMode,
      );
      _primaryColor = rawColor == null ? null : Color(rawColor);
      _pureBlack = rawPureBlack;
      _twemoji = rawTwemoji;
      _variant = .values[rawVariant];
      _locale = _localeFromString(rawLocale);
    });
  }

  Future<void> setThemeMode(ThemeMode newThemeMode) async {
    final preferences = _sharedPreferences ??=
        await SharedPreferences.getInstance();
    await preferences.setString(widget.themeModeSettingsKey, newThemeMode.name);
    setState(() {
      _themeMode = newThemeMode;
    });
  }

  Future<void> setPrimaryColor(Color? newPrimaryColor) async {
    final preferences = _sharedPreferences ??=
        await SharedPreferences.getInstance();
    if (newPrimaryColor == null) {
      await preferences.remove(widget.primaryColorSettingsKey);
    } else {
      await preferences.setInt(
        widget.primaryColorSettingsKey,
        newPrimaryColor.hexValue,
      );
    }
    setState(() {
      _primaryColor = newPrimaryColor;
    });
  }

  Future<void> setSchemeVariant(DynamicSchemeVariant? newVariant) async {
    final preferences = _sharedPreferences ??=
        await SharedPreferences.getInstance();
    if (newVariant == null) {
      await preferences.remove(widget.schemeVariantSettingsKey);
    } else {
      await preferences.setInt(
        widget.schemeVariantSettingsKey,
        DynamicSchemeVariant.values.indexOf(newVariant),
      );
    }
    setState(() {
      _variant = newVariant;
    });
  }

  Future<void> setPureBlack(bool newPureBlack) async {
    final preferences = _sharedPreferences ??=
        await SharedPreferences.getInstance();
    await preferences.setBool(widget.pureBlackSettingsKey, newPureBlack);
    setState(() {
      _pureBlack = newPureBlack;
    });
  }

  Future<void> setTwemoji(bool newTwemoji) async {
    final preferences = _sharedPreferences ??=
        await SharedPreferences.getInstance();
    await preferences.setBool(widget.twemojiSettingsKey, newTwemoji);
    setState(() {
      _twemoji = newTwemoji;
    });
  }

  Future<void> setLocale(Locale? newLocale) async {
    final preferences = _sharedPreferences ??=
        await SharedPreferences.getInstance();
    final value = _localeToString(newLocale);
    if (value.isEmpty) {
      await preferences.remove(widget.localeSettingsKey);
    } else {
      await preferences.setString(widget.localeSettingsKey, value);
    }
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_loadData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => this,
      child: DynamicColorBuilder(
        builder: (light, _) => widget.builder(
          context,
          themeMode,
          primaryColor ?? light?.primary,
          variant,
          pureBlack,
          twemoji,
          locale,
        ),
      ),
    );
  }
}

/// Parses a stored locale string such as `en`, `pt_BR` or `zh_Hant` back into
/// a [Locale]. Returns `null` for an empty/missing value (follow the system).
Locale? _localeFromString(String? code) {
  if (code == null || code.isEmpty) return null;
  final parts = code.replaceAll('-', '_').split('_');
  return switch (parts.length) {
    1 => Locale(parts[0]),
    // Distinguish a 4 letter script (e.g. Hant) from a country code.
    >= 2 when parts[1].length == 4 => Locale.fromSubtags(
      languageCode: parts[0],
      scriptCode: parts[1],
    ),
    _ => Locale(parts[0], parts[1]),
  };
}

/// Serializes a [Locale] for storage. Mirrors [_localeFromString].
String _localeToString(Locale? locale) {
  if (locale == null) return '';
  final script = locale.scriptCode;
  if (script != null && script.isNotEmpty) {
    return '${locale.languageCode}_$script';
  }
  final country = locale.countryCode;
  if (country != null && country.isNotEmpty) {
    return '${locale.languageCode}_$country';
  }
  return locale.languageCode;
}
