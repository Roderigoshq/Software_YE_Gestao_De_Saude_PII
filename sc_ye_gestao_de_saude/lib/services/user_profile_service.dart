import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserProfileService {
  static final DatabaseReference _userRef =
      FirebaseDatabase.instance.reference().child('usuarios');

  static Future<void> saveProfileImageURL(String imageUrl) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _userRef.child(user.uid).child('profileImageUrl').set(imageUrl);
      }
    } catch (e) {
      print('Error saving profile image URL: $e');
    }
  }

  static Future<String?> getProfileImageURL() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseEvent event =
          await _userRef.child(user.uid).child('profileImageUrl').once();
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        return snapshot.value.toString();
      }
    }
  } catch (e) {
    print('Error getting profile image URL: $e');
  }
  return null;
}


}
