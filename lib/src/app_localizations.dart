import 'package:app_localizations/src/data/localization_config.dart';
import 'package:app_localizations/src/data/localization_data.dart';
import 'package:app_localizations/src/data/localization_local_data_source.dart';
import 'package:app_localizations/src/data/localization_repository.dart';
import 'package:flutter/material.dart';

import 'data/localization_remote_data_source.dart';

// ignore_for_file: prefer_constructors_over_static_methods
class AppLocalizations {
  AppLocalizations._();

  static AppLocalizations getInstance(Locale locale) {
    AppLocalizations.locale = locale;
    return _instance ??= AppLocalizations._();
  }

  static final _repository = LocalizationRepository(LocalizationLocalDataSource());
  static AppLocalizations? _instance;
  static late Locale locale;
  static late List<Locale> supportedLocales;
  LocalizationData localizationData = LocalizationData();

  static Future<Locale> init(LocalizationConfig config, {LocalizationRemoteDataSource? remoteDataSource}) async {
    return _repository.initLocalizations(config, remoteDataSource);
  }

  static bool shouldFetchFromRemoteSource(Locale locale) {
    return _repository.shouldFetchFromRemoteSource(locale);
  }

  static Future<bool> fetchFromRemoteSource(Locale locale) {
    return _repository.fetchFromRemoteSource(locale);
  }

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // Static member to have a simple access to the delegate from the MaterialApp
  static LocalizationsDelegate<AppLocalizations> delegate(List<Locale> supportedLocales) {
    AppLocalizations.supportedLocales = supportedLocales;
    return _AppLocalizationsDelegate(supportedLocales);
  }

  Future<bool> load() async {
    final result = await _repository.getLocalizations(locale);
    if (result != null) {
      localizationData = result;
      _repository.setLocale(locale);
      return true;
    }
    return false;
  }

  String translate({
    String? key,
    List<String>? args,
    Map<String, String>? namedArgs,
  }) =>
      localizationData.get(key, args, namedArgs);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  final List<Locale> supportedLocales;

  const _AppLocalizationsDelegate(this.supportedLocales);

  @override
  bool isSupported(Locale locale) {
    return supportedLocales.contains(locale);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations.getInstance(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
