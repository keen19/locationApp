import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MessagePush{
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  //离开推送
  showNotification(String username) async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.high,importance: Importance.max
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
        0, '老人疑似离开监控', '请查看$username老人的情况', platform,
        payload: 'Nitish Kumar Singh is part time Youtuber');
  }

  //摔倒和紧急情况推送
  showEmergencyNotification(String username,String bed) async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.high,importance: Importance.max
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
        0, '老人疑似发生紧急情况', '请查看$username老人的情况,床号:$bed', platform,
        payload: 'Nitish Kumar Singh is part time Youtuber');
  }
}