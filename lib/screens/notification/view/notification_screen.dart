import 'package:flutter/material.dart';
import 'package:rideon_driver/config/appConfig.dart';
import 'package:rideon_driver/config/constant.dart';
import 'package:rideon_driver/models/notification/notification.dart';
import 'package:rideon_driver/services/firebase/notification_service.dart';
import 'package:rideon_driver/widget/customCard.dart';
import 'package:rideon_driver/widget/custom_dialog.dart';
import 'package:rideon_driver/widget/error_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationScreen extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => NotificationScreen());
  }

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<OfflineNotification> originalNotification = <OfflineNotification>[];
  @override
  void initState() {
    super.initState();
    originalNotification = NotificationService().getSavedNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
        actions: [
          if (originalNotification.isNotEmpty)
            IconButton(
                icon: Icon(
                  Icons.delete_sweep,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  CustomDialog().showCustomDialog(
                      content: 'Do you want to clear all notifications?',
                      actions: [
                        CustomDialog().dialogButton(
                          color: Colors.black12,
                          text: 'No',
                          onPressed: () => Navigator.pop(context),
                        ),
                        CustomDialog().dialogButton(
                          text: "Yes",
                          onPressed: () {
                            setState(() {
                              originalNotification.clear();
                            });
                            NotificationService().deleteAllNotification();
                            Navigator.pop(context);
                          },
                        )
                      ]);
                })
        ],
      ),
      body: originalNotification.isEmpty
          ? ErrorEmptyWidget(message: "No Notification")
          : Container(child: _listView(originalNotification)

              /*  child: originalNotification.length > 0
              ? _listView(originalNotification)
              : _listView(notifications) */
              ),
    );
  }

  ListView _listView(var notifications) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      itemCount: notifications.length,
      itemBuilder: (context, index) => Dismissible(
        onDismissed: (_) {
          setState(() {
            OfflineNotification deletedItem = notifications.removeAt(index);
            bool _undo = false;
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text("Deleted ${deletedItem.title}"),
                  duration: Duration(seconds: 3),
                  action: SnackBarAction(
                      label: "UNDO",
                      onPressed: () => setState(() {
                            notifications.insert(index, deletedItem);
                            _undo = true;
                          })),
                ),
              );
            Future.delayed(Duration(seconds: 4), () {
              if (!_undo) NotificationService().deleteNotification(deletedItem);
            });
          });
        },
        key: UniqueKey(),
        child: CustomCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Material(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.notifications_active,
                      size: 14,
                    ),
                  ),
                  shape: CircleBorder(),
                  color: Colors.tealAccent,
                  elevation: 1,
                ),
              ),
              Flexible(
                child: InkWell(
                  onTap: () async {
                    if (notifications[index].link != null) {
                      if (await canLaunch(notifications[index].link)) {
                        launch(notifications[index].link);
                      }
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notifications[index].title,
                        style: subTitle,
                      ),
                      Text(notifications[index].description),
                      Align(
                        alignment: Alignment.center,
                        child: Hero(
                          tag: index,
                          child: Image.network(
                            notifications[index].image ?? ' ',
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, url, error) => Container(),
                          ), /* OptimizedCacheImage(
                            imageUrl: notifications[index].image ?? ' ',
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              width: 60.0,
                              height: 60.0,
                              color: Colors.grey.shade400,
                              child: Center(
                                child: Container(
                                  height: 10,
                                  width: 10,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 0.5),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                                ),
                          ), */
                        ),
                      ),
                      Row(
                        children: [
                          Text(AppConfig().dateWithoutTime.format(
                              notifications[index].date ??
                                  DateTime.now().add(Duration(hours: index)))),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.circle,
                              size: 10,
                              color: Colors.redAccent,
                            ),
                          ),
                          Text(AppConfig().dateOnlyTime.format(
                              notifications[index].date ??
                                  DateTime.now().add(Duration(hours: index))))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
