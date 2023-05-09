import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import '../../pages/onboarding/on_boarding.dart';

class OnBoardingAdopter extends TypeAdapter<OnBoardingInformation> {
  @override
  int get typeId => 5;

  @override
  OnBoardingInformation read(BinaryReader reader) {
    List<String> purposeOfQuran = reader.read();
    String favReciter = reader.read();
    String whenToReciterQuran = reader.read();
    DateTime recitationReminder = reader.read();
    String dailyQuranReadTime = reader.read();
    Locale preferredLanguage = reader.read();
    return OnBoardingInformation(
        purposeOfQuran: purposeOfQuran,
        favReciter: favReciter,
        whenToReciterQuran: whenToReciterQuran,
        recitationReminder: recitationReminder,
        dailyQuranReadTime: dailyQuranReadTime,
        preferredLanguage: preferredLanguage);
  }

  @override
  void write(BinaryWriter writer, OnBoardingInformation obj) {
    writer.write(obj.purposeOfQuran);
    writer.write(obj.favReciter);
    writer.write(obj.whenToReciterQuran);
    writer.write(obj.recitationReminder);
    writer.write(obj.dailyQuranReadTime);
    writer.write(obj.preferredLanguage);
  }
}
