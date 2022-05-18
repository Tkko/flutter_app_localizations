import 'dart:convert';

import 'package:app_localizations/app_localizations.dart';
import 'package:app_localizations/src/data/localization_data.dart';
import 'package:app_localizations/src/data/localization_local_data_source.dart';
import 'package:app_localizations/src/data/localization_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'test_data.dart';

class MockedLocalizationLocalDataSource extends Mock implements LocalizationLocalDataSource {}

class LocalizationRemoteDataSourceImpls implements LocalizationRemoteDataSource {
  @override
  Future<String?> getLocalizations(_) async {
    return jsonEncode(tTranslationsData2);
  }
}

void main() {
  late LocalizationLocalDataSource localDataSource;
  late LocalizationRepository repository;

  setUp(() {
    localDataSource = MockedLocalizationLocalDataSource();
    repository = LocalizationRepository(localDataSource);
  });

  group('A group of tests', () {
    test('initLocalizations', () async {
      when(() => localDataSource.initLocalizations(tConfig)).thenAnswer((_) async => tLocale);
      when(() => localDataSource.getCurrentVersion(tLocale)).thenReturn(tVersion);

      final result = await repository.initLocalizations(tConfig, null);

      expect(result, tLocale);
    });

    test('getLocalizations without remote source', () async {
      when(() => localDataSource.getLocalizationsFromRootBundle(tLocale)).thenAnswer((_) async => tTranslationsData);
      when(() => localDataSource.getLocalizationsFromLocalStorage(tLocale)).thenAnswer((_) async => tTranslationsData2);

      final result = await repository.getLocalizations(tLocale);

      expect(
        result,
        LocalizationData(
          local: tTranslationsData,
          cached: tTranslationsData2,
        ),
      );
    });

    test('getLocalizations with remote source', () async {
      Map<String, String> savedTranslations = {};
      when(() => localDataSource.initLocalizations(tConfig)).thenAnswer((_) async => tLocale);
      when(() => localDataSource.getCurrentVersion(tLocale)).thenReturn('0.0.1');
      when(() => localDataSource.saveLocalizations(tLocale, tTranslationsData2)).thenAnswer((_) async {
        savedTranslations = tTranslationsData2;
        return Future.value();
      });

      await repository.initLocalizations(tConfig, LocalizationRemoteDataSourceImpls());

      expect(savedTranslations, tTranslationsData2);
    });

    // test('shouldFetchFromRemoteSource is false', () async {
    //   when(() => localDataSource.getCurrentVersion(tLocale)).thenReturn('1.0.0');
    //
    //   final result = repository.shouldFetchFromRemoteSource(
    //       tConfig.copyWith(latestTranslationsVersion: '1.0.0'), tLocale, LocalizationRemoteDataSourceImpls());
    //
    //   expect(result, false);
    // });
    //
    // test('shouldFetchFromRemoteSource is false', () async {
    //   when(() => localDataSource.getCurrentVersion(tLocale)).thenReturn('1.0.0');
    //
    //   final result = repository.shouldFetchFromRemoteSource(
    //       tConfig.copyWith(latestTranslationsVersion: '0.1.0'), tLocale, LocalizationRemoteDataSourceImpls());
    //
    //   expect(result, false);
    // });
    //
    // test('shouldFetchFromRemoteSource is true', () async {
    //   when(() => localDataSource.getCurrentVersion(tLocale)).thenReturn('1.0.0');
    //
    //   final result = repository.shouldFetchFromRemoteSource(
    //       tConfig.copyWith(latestTranslationsVersion: '1.1.0'), tLocale, LocalizationRemoteDataSourceImpls());
    //
    //   expect(result, true);
    // });
  });
}
