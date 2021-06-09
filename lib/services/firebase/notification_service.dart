import 'package:hive/hive.dart';
import 'package:rideon_driver/config/appConfig.dart';
import 'package:rideon_driver/models/notification/notification.dart';
import 'package:rideon_driver/services/helper/hiveService.dart';

class NotificationService {
  Box _box = HiveService().getHiveBox();

  void saveNotification(OfflineNotification notification) {
    List<OfflineNotification> notifications = getSavedNotifications();
    notifications.insert(0, notification);
    _box.put(hkNotification, notifications);
  }

  List<OfflineNotification> getSavedNotifications() {
    List<OfflineNotification> notifications = <OfflineNotification>[];
    List<dynamic> result =
        _box.get(hkNotification, defaultValue: <OfflineNotification>[]);
    notifications = result.cast();
    return notifications.take(50).toList();
  }

  void deleteAllNotification() {
    _box.delete(hkNotification);
  }

  void deleteNotification(OfflineNotification notification) {
    List<OfflineNotification?> notifications = getSavedNotifications();
    notifications.removeWhere((element) => element!.date == notification.date);
    _box.put(hkNotification, notifications);
  }
}
