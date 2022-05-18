import 'package:app_localizations/src/data/localization_config.dart';
import 'package:flutter/material.dart';
import 'package:version/version.dart';
import 'localization_data.dart';
import 'localization_local_data_source.dart';
import 'localization_remote_data_source.dart';

class LocalizationRepository {
  final LocalizationLocalDataSource _localDataSource;
  late LocalizationConfig _config;
  LocalizationRemoteDataSource? _remoteDataSource;

  LocalizationRepository(this._localDataSource);

  Future<Locale> initLocalizations(LocalizationConfig config, LocalizationRemoteDataSource? remoteDataSource) async {
    _config = config;
    _remoteDataSource = remoteDataSource;

    final locale = await _localDataSource.initLocalizations(_config);
    if (shouldFetchFromRemoteSource(locale)) {
      await fetchFromRemoteSource(locale);
    }
    return locale;
  }

  Future<bool> fetchFromRemoteSource(Locale locale) async {
    if (shouldFetchFromRemoteSource(locale)) {
      final path = '${_config.remoteTranslationsPath}${locale.toString()}.json';
      final remoteTranslations = await _remoteDataSource!.getLocalizations(path);
      if (remoteTranslations != null) {
        await _localDataSource.saveLocalizations(locale, parseTranslations(remoteTranslations));
        return true;
      }
    }
    return false;
  }

  bool shouldFetchFromRemoteSource(Locale locale) {
    final isRemoteDataSourceAvailable = _config.remoteTranslationsPath != null && _remoteDataSource != null;
    final currentVersion = Version.parse(_localDataSource.getCurrentVersion(locale));
    final latestVersion = Version.parse(_config.latestTranslationsVersion);
    return isRemoteDataSourceAvailable && latestVersion > currentVersion;
  }

  Future<LocalizationData?> getLocalizations(Locale locale) async {
    try {
      final localTranslations = await _localDataSource.getLocalizationsFromRootBundle(locale);
      final cachedTranslations = await _localDataSource.getLocalizationsFromLocalStorage(locale);

      return LocalizationData(
        local: localTranslations,
        cached: cachedTranslations,
      );
    } catch (error) {
      return null;
    }
  }

  void setLocale(Locale locale) {
    _localDataSource.setLocale(locale);
  }
}
