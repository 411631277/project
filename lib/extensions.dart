import 'package:flutter/material.dart';
import 'l10n/generated/l10n.dart';

extension LocalizationExtension on BuildContext {
  String t(String key) {
    return AppLocalizations.of(this).get(key);
  }
}
