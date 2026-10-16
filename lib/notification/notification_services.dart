import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  FirebaseMessaging? _messaging;
  DatabaseReference? _dbRef;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  FirebaseMessaging get messaging => _messaging ??= FirebaseMessaging.instance;

  DatabaseReference get dbRef =>
      _dbRef ??= FirebaseDatabase.instance.ref().child('allNotifications');

  bool get isFirebaseAvailable => Firebase.apps.isNotEmpty;

  Future<String> getDeviceToken() async {
    if (!isFirebaseAvailable) {
      return '';
    }

    String? token = await messaging.getToken();
    return token ?? '';
  }

  void isRefreshToken() async {
    if (!isFirebaseAvailable) {
      return;
    }

    messaging.onTokenRefresh.listen((event) {
      event.toString();
      debugPrint('Token Refreshed');
    });
  }

  void requestNotificationPermisions() async {
    if (!isFirebaseAvailable) {
      return;
    }

    NotificationSettings notificationSettings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (notificationSettings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('user granted permissions');
    } else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User denied or has not granted permission');
    }
  }

  Future forgroundMessage() async {
    if (!isFirebaseAvailable) {
      return;
    }

    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void firebaseInit(BuildContext context) {
    if (!isFirebaseAvailable) {
      return;
    }

    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;

      debugPrint("Notification On Foreground");
      debugPrint("Notification title: ${notification!.title}");
      debugPrint("Notification title: ${notification.body}");
      debugPrint("Data: ${message.data.toString()}");

      storeNotification(message);
      if (Platform.isIOS) {
        forgroundMessage();
      }

      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotification(message);
      }
    });
  }

  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitSettings = const DarwinInitializationSettings();

    var initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (payload) {
        handleMesssage(context, message);
      },
    );
  }

  void handleMesssage(BuildContext context, RemoteMessage message) {
    debugPrint('In handleMessage function');
    if (message.data['type'] == 'text') {
      // redirect to new screen or take different action based on payload that you receive.
    }
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel androidNotificationChannel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      importance: Importance.max,
      showBadge: true,
      playSound: true,
    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      androidNotificationChannel.id.toString(),
      androidNotificationChannel.name.toString(),
      channelDescription: 'Flutter Notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
      sound: androidNotificationChannel.sound,
    );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    });
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    if (!isFirebaseAvailable) {
      return;
    }

    RemoteMessage? initialMessage = await messaging.getInitialMessage();

    if (initialMessage != null) {
      handleMesssage(context, initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMesssage(context, event);
    });
  }

  Future<void> storeNotification(RemoteMessage message) async {
    if (!isFirebaseAvailable) {
      return;
    }

    try {
      debugPrint(
          "Notification Title From Firebase: ${message.notification?.title ?? 'No Title'}");
      debugPrint(
          "Notification Body From Firebase: ${message.notification?.body ?? 'No Body'}");
      debugPrint("Notification Data From Firebase: ${message.data}");
      debugPrint("Notification Category From Firebase: ${message.category}");
      debugPrint("Message Type From Firebase: ${message.messageType}");
      debugPrint("Notification Message ID From Firebase: ${message.messageId}");
      debugPrint("Notification Sent Time From Firebase: ${message.sentTime}");

      String? title = message.notification?.title ?? 'No Title';
      String? body = message.notification?.body ?? 'No Body';

      if (title != "No Title" && body != "No Body") {
        Map<String, dynamic> data = message.data;
        String? imageUrl = message.notification?.android?.imageUrl ??
            message.notification?.apple?.imageUrl;

        String uniqueId = "${title.hashCode}_${body.hashCode}_${data.hashCode}";

        DataSnapshot snapshot = await dbRef.child(uniqueId).get();

        if (!snapshot.exists) {
          await dbRef.child(uniqueId).set({
            'title': title,
            'imageUrl': imageUrl,
            'body': body,
            'data': data,
            'timestamp': ServerValue.timestamp,
          });
          debugPrint('Notification stored successfully');
        } else {
          debugPrint('Duplicate notification detected. Skipping storage.');
        }
      }
    } catch (e) {
      debugPrint('Error storing notification: $e');
    }
  }

  void notificationInitCall(BuildContext context) {
    requestNotificationPermisions();
    forgroundMessage();
    firebaseInit(context);
    setupInteractMessage(context);
    isRefreshToken();
    getDeviceToken().then((value) {
      debugPrint("FCM Token: $value");
    });
  }
}

