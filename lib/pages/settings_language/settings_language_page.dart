import 'package:flutter/material.dart';

import 'package:extera_next/config/app_config.dart';
import 'package:extera_next/generated/l10n/l10n.dart';
import 'package:extera_next/utils/locale_display_name.dart';
import 'package:extera_next/widgets/theme_builder.dart';

/// Full screen language picker shown from Settings → Appearance.
///
/// Mirrors the system "per app language" layout: an app header, a
/// "Recommended" section built from the device locales and an "All languages"
/// section with every shipped translation. Picking an entry overrides the app
/// language independently of the system locale (see [ThemeController.setLocale]).
class SettingsLanguagePage extends StatefulWidget {
  const SettingsLanguagePage({super.key});

  @override
  State<SettingsLanguagePage> createState() => _SettingsLanguagePageState();
}

class _SettingsLanguagePageState extends State<SettingsLanguagePage> {
  bool _searching = false;
  String _query = '';

  /// Finds the shipped translation that best matches a system [locale],
  /// preferring an exact match, then language + script, then language only.
  Locale? _resolveSupported(Locale locale) {
    final supported = L10n.supportedLocales;
    for (final s in supported) {
      if (s == locale) return s;
    }
    for (final s in supported) {
      if (s.languageCode == locale.languageCode &&
          (s.scriptCode ?? '') == (locale.scriptCode ?? '')) {
        return s;
      }
    }
    for (final s in supported) {
      if (s.languageCode == locale.languageCode) return s;
    }
    return null;
  }

  /// System suggested locales, paired as (display, resolved translation),
  /// deduplicated by the resolved translation.
  List<(Locale, Locale)> get _recommended {
    final result = <(Locale, Locale)>[];
    final seen = <String>{};
    for (final system in WidgetsBinding.instance.platformDispatcher.locales) {
      final resolved = _resolveSupported(system);
      if (resolved == null) continue;
      if (seen.add(resolved.toLanguageTag())) {
        result.add((system, resolved));
      }
    }
    return result;
  }

  bool _isSelected(Locale locale) {
    final current = ThemeController.of(context).locale;
    if (current == null) return false;
    return current.languageCode == locale.languageCode &&
        (current.scriptCode ?? '') == (locale.scriptCode ?? '') &&
        (current.countryCode ?? '') == (locale.countryCode ?? '');
  }

  void _select(Locale? locale) {
    ThemeController.of(context).setLocale(locale);
    setState(() {});
  }

  Iterable<Locale> get _filteredAll {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return L10n.supportedLocales;
    return L10n.supportedLocales.where((locale) {
      final name = localeDisplayName(locale).toLowerCase();
      final tag = locale.toLanguageTag().toLowerCase();
      return name.contains(query) || tag.contains(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSearching = _searching;
    final systemSelected = ThemeController.of(context).locale == null;

    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                autofocus: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: L10n.of(context).searchLanguages,
                ),
                onChanged: (value) => setState(() => _query = value),
              )
            : Text(L10n.of(context).appLanguageTitle),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () => setState(() {
              _searching = !_searching;
              _query = '';
            }),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        children: [
          if (!isSearching) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Image.asset('assets/logo.png', width: 72, height: 72),
                  const SizedBox(height: 12),
                  Text(
                    AppConfig.applicationName,
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            _SectionHeader(L10n.of(context).recommended),
            _GroupCard(
              children: [
                _RadioTile(
                  label: L10n.of(context).systemLanguage,
                  selected: systemSelected,
                  onTap: () => _select(null),
                ),
                for (final (display, resolved) in _recommended)
                  _RadioTile(
                    label: systemLocaleDisplayName(display),
                    selected: _isSelected(resolved),
                    onTap: () => _select(resolved),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _SectionHeader(L10n.of(context).allLanguages),
          ],
          for (final locale in _filteredAll)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _GroupCard(
                children: [
                  ListTile(
                    title: Text(localeDisplayName(locale)),
                    subtitle: Text(locale.toLanguageTag()),
                    trailing: _isSelected(locale)
                        ? Icon(
                            Icons.check_circle,
                            color: theme.colorScheme.primary,
                          )
                        : null,
                    onTap: () => _select(locale),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Text(
        title,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final List<Widget> children;

  const _GroupCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerHigh,
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(AppConfig.borderRadius),
      child: Column(children: children),
    );
  }
}

class _RadioTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RadioTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: selected ? theme.colorScheme.primary : null,
      ),
      title: Text(label),
      selected: selected,
      onTap: onTap,
    );
  }
}
