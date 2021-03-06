import 'package:bizi/Logic/check_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:bizi/screens/flashpage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  //Initialising Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
          icon: 'launch_background',
        ),
      ));
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  runApp(Bizi());
}

class Bizi extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _BiziState createState() => _BiziState();
}

class _BiziState extends State<Bizi> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flNotification;
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message.data);
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            message.hashCode,
            message.data['title'],
            message.data['body'],
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: 'launch_background',
              ),
            ));
      }
    });

    getToken();
  }

  void getToken() async {
    print(await messaging.getToken());
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: ChangeNotifierProvider<CheckProvider>(
        create: (context) => CheckProvider(),
        child: MaterialApp(
          title: 'Bizi Network',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Color(0xFF000929),
            // primaryColor: Color(0xFFF0FFFF),
            secondaryHeaderColor: Color(0xFF0D415D),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: FlashPage(),
        ),
      ),
    );
  }
}
