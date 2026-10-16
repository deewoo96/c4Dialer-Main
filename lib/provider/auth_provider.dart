import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class AuthProvider with ChangeNotifier {

  bool _isEditProfileButtonVisible = false;
  bool get isEditProfileButtonVisible => _isEditProfileButtonVisible;


  bool _isLoading = false;
  bool get isLoading => _isLoading;

  setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set isEditProfileButtonVisible(bool value) {
    _isEditProfileButtonVisible = value;
    notifyListeners();
  }

  Future fetchAdvertisementDataFromFirebase() async{
    setIsLoading(true);
    late DatabaseReference notificationRef = FirebaseDatabase.instance.ref().child("advertiseSection");
    notificationRef.onValue.listen((event) async{
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        isEditProfileButtonVisible = data['isEditProfileButtonVisible'] ;
        debugPrint("data['isEditProfileButtonVisible']: ${data['isEditProfileButtonVisible']}");
        debugPrint("'isEditProfileButtonVisible: $isEditProfileButtonVisible");
        setIsLoading(false);
      }
    });
  }
}