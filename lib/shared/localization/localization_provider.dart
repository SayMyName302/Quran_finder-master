import 'package:flutter/cupertino.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hive/hive.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import 'languages.dart';

class LocalizationProvider extends ChangeNotifier {
  Locale _locale =
      Hive.box("myBox").get("languageCode") ?? const Locale("en", "US");
  Locale get locale => _locale;

  void setLocale(Languages languages) async {
    switch (languages.languageCode) {
      case "en":
        HijriCalendar.setLocal("en");
        _locale = Locale(languages.languageCode, "US");
        Hive.box("myBox").put("languageCode", _locale);
        OneSignal.shared.sendTag("language", "English");
        notifyListeners();
        break;
      case "ur":
        HijriCalendar.setLocal("ur");
        _locale = Locale(languages.languageCode, "PK");
        Hive.box("myBox").put("languageCode", _locale);
        OneSignal.shared.sendTag("language", "Urdu");
        notifyListeners();
        break;
      case "hi":
        HijriCalendar.setLocal("hi");
        _locale = Locale(languages.languageCode, "IN");
        Hive.box("myBox").put("languageCode", _locale);
        OneSignal.shared.sendTag("language", "Hindi");
        notifyListeners();
        break;
      case "ar":
        HijriCalendar.setLocal("ar");
        _locale = Locale(languages.languageCode, "SA");
        Hive.box("myBox").put("languageCode", _locale);
        OneSignal.shared.sendTag("language", "Arabic");
        notifyListeners();
        break;
      case "id":
        HijriCalendar.setLocal("id");
        _locale = Locale(languages.languageCode, "IN");
        Hive.box("myBox").put("languageCode", _locale);
        OneSignal.shared.sendTag("language", "Indonesian");
        notifyListeners();
        break;
      case "bn":
        HijriCalendar.setLocal("bn");
        _locale = Locale(languages.languageCode, "BD");
        Hive.box("myBox").put("languageCode", _locale);
        OneSignal.shared.sendTag("language", "Bengali");
        notifyListeners();
        break;
      case "zh":
        HijriCalendar.setLocal("zh");
        _locale = Locale(languages.languageCode, "CN");
        Hive.box("myBox").put("languageCode", _locale);
        OneSignal.shared.sendTag("language", "Chinese");
        notifyListeners();
        break;
      case "fr":
        HijriCalendar.setLocal("fr");
        _locale = Locale(languages.languageCode, "BE");
        Hive.box("myBox").put("languageCode", _locale);
        OneSignal.shared.sendTag("language", "French");
        notifyListeners();
        break;
      case "es":
        HijriCalendar.setLocal("es");
        _locale = Locale(languages.languageCode, "AG");
        Hive.box("myBox").put("languageCode", _locale);
        OneSignal.shared.sendTag("language", "Spanish");
        notifyListeners();
        break;
      case "de":
        HijriCalendar.setLocal("de");
        _locale = Locale(languages.languageCode, "DE");
        Hive.box("myBox").put("languageCode", _locale);
        OneSignal.shared.sendTag("language", "Germeny");
        notifyListeners();
        break;
      default:
        HijriCalendar.setLocal("en");
        _locale = const Locale("en", "US");
        Hive.box("myBox").put("languageCode", _locale);
        OneSignal.shared.sendTag("language", "English");
        notifyListeners();
        break;
    }
  }

  checkIsArOrUr() {
    if (_locale.languageCode == "ur" || _locale.languageCode == 'ar') {
      return true;
    } else {
      return false;
    }
  }
}
