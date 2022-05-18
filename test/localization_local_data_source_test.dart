import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';

class MockedHive extends Mock implements HiveInterface {
  static Future<void> initFlutter([String? subDir]) async {
    return;
  }
}

class MockedBox extends Mock implements Box {}

void main() {
  // late HiveInterface hive;
  // late MockedBox box;
  // late LocalizationLocalDataSource localDataSource;
  //
  // setUpAll(() {
  //   hive = MockedHive();
  //   box = MockedBox();
  //   localDataSource = LocalizationLocalDataSource();
  // });

  // group('A group of tests', () {
  // test('getCurrentVersion', () async {
  //   when(() => box.get(captureAny())).thenReturn(tVersion);
  //
  //   final result = localDataSource.getCurrentVersion();
  //
  //   expect(result, tVersion);
  // });

  // test('getCurrentVersion', () async {
  //   when(() => box.get(captureAny())).thenReturn(tTranslationsData);
  //
  //   final result = localDataSource.getLocalizationsFromLocalStorage(tDefaultLocale);
  //
  //   expect(result, tTranslationsData);
  // });

  // test('First Test', () async {
  //   // when(() => hive.initFlutter()).thenAnswer((_) async => Future.value());
  //   when(() => hive.openBox(captureAny())).thenAnswer((_) async => MockedBox());
  //   when(() => box.get(_hiveLocaleKey)).thenReturn(null);
  //   when(() => box.put(_hiveLocaleKey, tDefaultLocale.toString())).thenAnswer((_) async => Future.value());
  //
  //   final locale = await localDataSource.initLocalizations(tConfig);
  //
  //   expect(locale, tDefaultLocale);
  // });
  // });
}
