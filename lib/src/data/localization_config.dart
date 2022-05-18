import 'package:flutter/material.dart';

class LocalizationConfig {
  final String? localTranslationsPath;
  final String? remoteTranslationsPath;
  final String latestTranslationsVersion;
  final Locale defaultLocale;

  const LocalizationConfig({
    this.localTranslationsPath,
    this.remoteTranslationsPath,
    this.latestTranslationsVersion = '1.0.0',
    required this.defaultLocale,
  }) : assert(localTranslationsPath != null || remoteTranslationsPath != null, '');

  LocalizationConfig copyWith({
    String? localTranslationsPath,
    String? remoteTranslationsPath,
    String? latestTranslationsVersion,
    Locale? defaultLocale,
  }) {
    return LocalizationConfig(
      localTranslationsPath: localTranslationsPath ?? this.localTranslationsPath,
      remoteTranslationsPath: remoteTranslationsPath ?? this.remoteTranslationsPath,
      latestTranslationsVersion: latestTranslationsVersion ?? this.latestTranslationsVersion,
      defaultLocale: defaultLocale ?? this.defaultLocale,
    );
  }
}
