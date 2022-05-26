import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  static Future<void> createNotifications(title, body) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 0, channelKey: 'basic_channel', title: title, body: body));
  }
}
