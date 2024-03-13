/*
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async{
    //For Android
    AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings("@mipmap/ic_launcher");

    //For IOS
    var initializationSettingIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (int id,String? title,String? body,String? payload) async{}
    );

    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid,iOS: initializationSettingIOS);
    await notificationsPlugin.initialize(initializationSettings,onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async{} ,);
  }

  Future<void> showNotification({int id = 0,String? title,String? body,String? payload}) async{
    return notificationsPlugin.show(id, title, body, await notificationDetails());

  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('Channel Id', "Channel Name"),
        iOS: DarwinNotificationDetails()
    );
  }
}*/
