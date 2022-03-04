
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Notifications extends StatefulWidget {
  // final int totalNotifications;
  // Notifications({
  //   @required this.totalNotifications,
  // });

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
 

  // void notificationPermision() async {
  //   NotificationSettings settings = await messaging.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );

  // }

  
  List<PushNotification> notifics = [
    PushNotification(title: 'Hello, Moose', body: 'Welcome to Bizi Market!'),
    PushNotification(
        title: 'New message', body: 'Valyo: Hello bro i need a dual core'),
    PushNotification(title: 'New message', body: 'Change the ram')
  ];

  @override
  Widget build(BuildContext context) {
    // void initMessaging() {
    //

    //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //     // showNotification();
    //     print('Got a message whilst in the foreground!');
    //     print('Message data: ${message.data}');

    //     if (message.notification != null) {
    //       print(
    //           'Message also contained a notification: ${message.notification.title}');
    //     }
    //   });
    //   FirebaseMessaging.onMessageOpenedApp.listen((event) {
    //     print(event.data);
    //   });
    //   FirebaseMessaging.onBackgroundMessage((message) async {
    //     print(message.data);
    //   });
    // }

    return Container(
      padding: EdgeInsets.all(20),
      child: Center(
        child: ListView.builder(
          itemCount: notifics.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.yellow,
              ),
              title: Text(
                notifics[index].title,
                style: GoogleFonts.k2d(color: Colors.white),
              ),
              subtitle: Text(
                notifics[index].body,
                style: GoogleFonts.k2d(color: Colors.white),
              ),
              isThreeLine: true,
            );
          },
        ),
      ),
    );
  }
}

class PushNotification {
  PushNotification({
    this.title,
    this.body,
  });

  String title;
  String body;

  factory PushNotification.fromJson(Map<String, dynamic> json) {
    return PushNotification(
      title: json["notification"]["title"],
      body: json["notification"]["body"],
    );
  }
}
