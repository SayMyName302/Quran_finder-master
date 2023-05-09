import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
void onBackGround(NotificationResponse response) {
  NotificationServices.onNotification.add(response.payload);
  // Fluttertoast.showToast(msg: "onBack");
  // if(response.payload != null){
  //   print(response.payload);
  //   if(response.payload == "recite"){
  //     gotoQuranTextView();
  //   }else if(response.payload == "home"){
  //     Navigator.of(RouteHelper.currentContext).pushNamedAndRemoveUntil(RouteHelper.application, (route) => false);
  //   }
  // }
}

class NotificationServices {
  static final _notificationPlugin = FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String?>();
  var channel = const AndroidNotificationChannel(
    'daily_notifications',
    'Daily Notifications',
    description: 'Channel for daily notifications',
    importance: Importance.high,
  );

  init() async {
    await _initTimeZone();
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('drawable/icon');
    DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            onDidReceiveLocalNotification: (int? id, String? title,
                String? body, String? payload) async {});

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: iosInitializationSettings);

    /// when app is Closed
    final details = await _notificationPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      print("is Lunch ${details.didNotificationLaunchApp}");
      print(details.notificationResponse!.payload);
      onNotification.add(details.notificationResponse!.payload);
    }

    await _notificationPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onBackGround);

    await _notificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    if (Platform.isIOS) {
      await _notificationPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  Future getNotifications() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await _notificationPlugin.pendingNotificationRequests();
    return pendingNotificationRequests;
  }

  _initTimeZone() async {
    tz.initializeTimeZones();
    final location = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(location));
  }

  _notificationDetails(String icon,
      {required String channelId,
      required String channelName,
      required String channelDes}) {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDes,
      icon: icon,
      importance: Importance.max,
      priority: Priority.max,
    );
    DarwinNotificationDetails iosNotificationDetails =
        const DarwinNotificationDetails();
    return NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);
  }

  Future showNotification(
      {var id = 0,
      String? title = "title",
      String? body = "body",
      String? icon,
      String? navigateToScreen = ""}) async {
    await _notificationPlugin.show(
        id,
        title,
        body,
        _notificationDetails(icon ?? "drawable/icon",
            channelId: channel.id,
            channelName: channel.name,
            channelDes: channel.description!),
        payload: navigateToScreen);
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    required DateTime scheduledDateTime,
  }) async {
    await _notificationPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDateTime, tz.local),
      _notificationDetails("drawable/icon",
          channelId: channel.id,
          channelName: channel.name,
          channelDes: channel.description!),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  Future<void> dailyNotifications(
      {required int id,
      required String title,
      required String body,
      required String payload,
      required Time dailyNotifyTime}) async {
    await _notificationPlugin.zonedSchedule(
        id,
        title,
        body,
        _scheduleDaily(dailyNotifyTime),
        _notificationDetails("drawable/icon",
            channelId: channel.id,
            channelName: channel.name,
            channelDes: channel.description!),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
        matchDateTimeComponents: DateTimeComponents.time,
        androidAllowWhileIdle: true);
  }

  tz.TZDateTime _scheduleDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        time.hour, time.minute, time.second);
    return scheduledDate.isBefore(now)
        ? scheduledDate.add(const Duration(days: 1))
        : scheduledDate;
  }

  Future<void> scheduleNotification1({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    await _notificationPlugin.periodicallyShow(
      id,
      title,
      body,
      RepeatInterval.daily,
      const NotificationDetails(
          android: AndroidNotificationDetails(
        'daily_notification_channel',
        'Daily Notification Channel',
        channelDescription: 'Channel for daily notifications',
        icon: "drawable/icon",
        importance: Importance.max,
        priority: Priority.max,
        ongoing: true,
      )),
      androidAllowWhileIdle: true,
      payload: payload,
    );
  }

  Future<void> cancelNotifications(int id) async {
    await _notificationPlugin.cancel(id);
  }
}
