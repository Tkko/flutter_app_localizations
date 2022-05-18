import 'package:app_localizations/app_localizations.dart';
import 'package:flutter/material.dart';

const tLocale = Locale('ka');
const tVersion = '1.0.0';

final tTranslationsData = {
  'title': 'App Localizations',
};

final tTranslationsData2 = {
  'author': 'Tornike',
};

const tConfig = LocalizationConfig(
  defaultLocale: tLocale,
  localTranslationsPath: '../',
  remoteTranslationsPath: '../',
  latestTranslationsVersion: tVersion,
);
