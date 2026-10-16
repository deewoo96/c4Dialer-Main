import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class NotificationProvider with ChangeNotifier {
  DatabaseReference? _notificationRef;

  NotificationProvider() {
    _listenForNotifications();
  }

  bool get isFirebaseAvailable => Firebase.apps.isNotEmpty;

  DatabaseReference get notificationRef =>
      _notificationRef ??= FirebaseDatabase.instance.ref().child('allNotifications');

  Stream<DatabaseEvent> get notificationStream =>
      isFirebaseAvailable ? notificationRef.onValue : const Stream.empty();

  int _notificationCount = 0;
  int get notificationCount => _notificationCount;

  void _listenForNotifications() {
    if (!isFirebaseAvailable) {
      return;
    }

    notificationRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        _notificationCount = event.snapshot.children.length;
        notifyListeners();
      }
    });
  }

  void clearNotificationCount() {
    _notificationCount = 0;
    notifyListeners();
  }

  String formatTimestamp(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var formattedDate = DateFormat('dd MMMM yyyy, hh:mm:ss a').format(date);
    return formattedDate;
  }
}
