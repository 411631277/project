import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'account': 'Account',
      'password': 'Password',
      'login': 'Login',
      'language': 'Language',
    },
    'zh': {
      'account': '帳號',
      'password': '密碼',
      'login': '登入',
      'language': '語言',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  String? translate(String key) {
    return _localizedValues[locale.languageCode]?[key];
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // 靜態 delegate
  static const LocalizationsDelegate<AppLocalizations> delegate =
      AppLocalizationsDelegate();
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
