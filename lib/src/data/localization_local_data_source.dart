import 'dart:convert';
import 'package:app_localizations/src/data/localization_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _hiveBox = 'app_localizations_box';
const _hiveLocaleKey = 'locale';
const _hiveVersionKey = 'version';
const _hiveTranslationsKey = 'translations';
const _defaultVersion = '1.0.0';

class LocalizationLocalDataSource {
  final HiveInterface _hive = Hive;
  late LocalizationConfig _config;
  late Box _box;

  LocalizationLocalDataSource();

  Future<Locale> initLocalizations(LocalizationConfig config) async {
    _config = config;
    await _hive.initFlutter();
    _box = await _hive.openBox(_hiveBox);
    String localeStr = _config.defaultLocale.toString();
    if (_box.containsKey(_hiveLocaleKey)) {
      localeStr = await _box.get(_hiveLocaleKey);
    } else {
      await _box.put(_hiveLocaleKey, localeStr);
    }
    return localeStr.toLocale();
  }

  String getCurrentVersion(Locale locale) {
    return _box.get(_versionKey(locale), defaultValue: _defaultVersion) as String;
  }

  Future<Map<String, String>> getLocalizationsFromRootBundle(Locale locale) async {
    try {
      final path = '${_config.localTranslationsPath}${locale.toString()}.json';
      final translationsStringData = await rootBundle.loadString(path);
      return parseTranslations(translationsStringData);
    } catch (error) {
      return {};
    }
  }

  String _versionKey(Locale locale) => '$_hiveVersionKey-${locale.toString()}';

  String _translationsKey(Locale locale) => '$_hiveTranslationsKey-${locale.toString()}';

  Future<Map<String, String>> getLocalizationsFromLocalStorage(Locale locale) async {
    final translationsStringData = _box.get(_translationsKey(locale));
    if (translationsStringData is String) {
      return parseTranslations(translationsStringData);
    }
    return {};
  }

  Future<void> saveLocalizations(Locale locale, Map<String, String> data) async {
    await _box.put(_translationsKey(locale), data);
    await _box.put(_versionKey(locale), _config.latestTranslationsVersion);
  }

  Future<void> setLocale(Locale locale) async {
    await _box.put(_hiveLocaleKey, locale.toString());
  }
}

Map<String, String> parseTranslations(String translationsStringData) {
  final translationsJsonData = jsonDecode(translationsStringData) as Map<String, dynamic>;
  translationsJsonData.removeWhere((_, value) => value == null);
  return translationsJsonData.map<String, String>((key, value) => MapEntry(key, value.toString()));
}

extension StringExt on String {
  Locale toLocale() {
    final codes = this.split('_');
    if (codes.length == 1) return Locale(codes.first);
    return Locale(codes.first, codes.last);
  }
}
