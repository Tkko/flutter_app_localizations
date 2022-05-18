import 'package:app_localizations/src/app_localizations.dart';
import 'package:flutter/cupertino.dart';

extension LocalizationExt on BuildContext {
  List<Locale> get supportedLocales => AppLocalizations.supportedLocales;

  Locale get locale => AppLocalizations.locale;

  String tr(
    String? text, {
    List<String>? args,
    Map<String, String>? namedArgs,
  }) =>
      AppLocalizations.of(this).translate(
        key: text,
        args: args,
        namedArgs: namedArgs,
      );
}
