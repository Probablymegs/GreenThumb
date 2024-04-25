import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_thumb/models/trefle_plant.dart';
import 'package:green_thumb/models/user.dart';
import 'package:green_thumb/widgets/snackbar.dart';

class Database {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> createUser(GreenThumbUser user) async {
    try {
      await firestore.collection('users').doc(user.uid).set({
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
      });
      NotificationSnackBar(text: 'User profile created successfully!').show();
    } catch (e) {
      NotificationSnackBar(
              text: 'Failed to create user profile: ${e.toString()}')
          .show();
    }
  }

  Future<void> addToCollection(TreflePlant plant) async {
    String? userId = auth.currentUser?.uid;
    if (userId == null) {
      NotificationSnackBar(text: 'You need to be logged in to add plants.')
          .show();
      return;
    }

    try {
      await firestore.collection('users').doc(userId).collection('plants').add({
        'commonName': plant.commonName,
        'scientificName': plant.scientificName,
        'imageUrl': plant.imageUrl
      });
      NotificationSnackBar(text: 'Plant added to your collection!').show();
    } catch (e) {
      NotificationSnackBar(text: 'Failed to add plant: ${e.toString()}').show();
    }
  }

  Future<void> deleteFromCollection(String plantId) async {
    String? userId = auth.currentUser?.uid;
    if (userId == null) {
      NotificationSnackBar(text: 'You need to be logged in to delete plants.')
          .show();
      return;
    }

    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('plants')
          .doc(plantId)
          .delete();
      NotificationSnackBar(text: 'Plant removed from your collection!').show();
    } catch (e) {
      NotificationSnackBar(text: 'Failed to remove plant: ${e.toString()}')
          .show();
    }
  }
}
