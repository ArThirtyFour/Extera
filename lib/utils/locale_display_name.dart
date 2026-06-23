import 'package:flutter/widgets.dart';

/// Native (endonym) names for the locales the app ships translations for.
///
/// Keys are built from the language code optionally followed by the script
/// and/or country code (see [_localeKey]). Anything that is not listed here
/// falls back to the bare language name and finally to the BCP-47 tag, so a
/// newly added translation still shows up even before it gets a name here.
const Map<String, String> _languageNames = {
  'ar': 'العربية',
  'be': 'Беларуская',
  'bn': 'বাংলা',
  'bo': 'བོད་སྐད་',
  'ca': 'Català',
  'cs': 'Čeština',
  'de': 'Deutsch',
  'el': 'Ελληνικά',
  'en': 'English',
  'eo': 'Esperanto',
  'es': 'Español',
  'et': 'Eesti',
  'eu': 'Euskara',
  'fa': 'فارسی',
  'fi': 'Suomi',
  'fil': 'Filipino',
  'fr': 'Français',
  'ga': 'Gaeilge',
  'gl': 'Galego',
  'he': 'עברית',
  'hi': 'हिन्दी',
  'hr': 'Hrvatski',
  'hu': 'Magyar',
  'ia': 'Interlingua',
  'id': 'Bahasa Indonesia',
  'ie': 'Interlingue',
  'it': 'Italiano',
  'ja': '日本語',
  'ka': 'ქართული',
  'ko': '한국어',
  'lt': 'Lietuvių',
  'lv': 'Latviešu',
  'nb': 'Norsk bokmål',
  'nl': 'Nederlands',
  'pl': 'Polski',
  'pt': 'Português',
  'pt_BR': 'Português (Brasil)',
  'pt_PT': 'Português (Portugal)',
  'ro': 'Română',
  'ru': 'Русский',
  'sk': 'Slovenčina',
  'sl': 'Slovenščina',
  'sr': 'Српски',
  'sv': 'Svenska',
  'ta': 'தமிழ்',
  'te': 'తెలుగు',
  'th': 'ไทย',
  'tr': 'Türkçe',
  'uk': 'Українська',
  'vi': 'Tiếng Việt',
  'zh': '中文',
  'zh_Hant': '中文 (繁體)',
};

String _localeKey(Locale locale) {
  final buffer = StringBuffer(locale.languageCode);
  final script = locale.scriptCode;
  if (script != null && script.isNotEmpty) buffer.write('_$script');
  final country = locale.countryCode;
  if (country != null && country.isNotEmpty) buffer.write('_$country');
  return buffer.toString();
}

/// Native names including the region, used for the "recommended" section where
/// the entries come from the system locale list and therefore carry a country,
/// e.g. `Русский (Россия)`. Anything not listed falls back to the bare language
/// name via [systemLocaleDisplayName].
const Map<String, String> _regionalNames = {
  'ru_RU': 'Русский (Россия)',
  'en_US': 'English (United States)',
  'en_GB': 'English (United Kingdom)',
  'ja_JP': '日本語 (日本)',
  'de_DE': 'Deutsch (Deutschland)',
  'fr_FR': 'Français (France)',
  'uk_UA': 'Українська (Україна)',
  'be_BY': 'Беларуская (Беларусь)',
  'es_ES': 'Español (España)',
  'pt_BR': 'Português (Brasil)',
  'pt_PT': 'Português (Portugal)',
  'zh_CN': '中文 (中国)',
  'zh_TW': '中文 (台灣)',
  'it_IT': 'Italiano (Italia)',
  'pl_PL': 'Polski (Polska)',
  'ko_KR': '한국어 (대한민국)',
  'tr_TR': 'Türkçe (Türkiye)',
  'cs_CZ': 'Čeština (Česko)',
  'nl_NL': 'Nederlands (Nederland)',
};

/// Returns a human readable, native name for [locale] to show in the language
/// picker, e.g. `Deutsch` or `Português (Brasil)`.
String localeDisplayName(Locale locale) {
  return _languageNames[_localeKey(locale)] ??
      _languageNames[locale.languageCode] ??
      locale.toLanguageTag();
}

/// Like [localeDisplayName] but adds the region when known. Used for the
/// system-suggested languages, e.g. `Русский (Россия)`.
String systemLocaleDisplayName(Locale locale) {
  return _regionalNames[_localeKey(locale)] ?? localeDisplayName(locale);
}
