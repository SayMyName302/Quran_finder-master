import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';

class InAppRating extends StatefulWidget {
  const InAppRating({super.key});

  @override
  State<InAppRating> createState() => _InAppRatingState();
}

class _InAppRatingState extends State<InAppRating> {
  final RateMyApp _rateMyApp = RateMyApp(
      preferencesPrefix: 'rateMyApp_',
      minDays: 3,
      minLaunches: 7,
      remindDays: 2,
      remindLaunches: 5,
      googlePlayIdentifier: '');

  @override
  void initState() {
    super.initState();
    _rateMyApp.init().then((_) {
      _rateMyApp.conditions.forEach((condition) {
        if (condition is DebuggableCondition) {
          print(condition.valuesAsString);
        }
      });

      if (_rateMyApp.shouldOpenDialog) {
        _rateMyApp.showRateDialog(
          context,
          title: 'Enjoying Quran App?',
          message: 'Please leave a rating!',
          onDismissed: () =>
              _rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Center(
        child: Icon(
          Icons.clear,
          size: 48,
          color: Colors.white,
        ),
      ),
    );
  }
}
