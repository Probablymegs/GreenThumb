import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_thumb/models/plant.dart';
import 'package:green_thumb/models/trefle_plant.dart';
import 'package:green_thumb/models/user.dart';
import 'package:green_thumb/models/water_schedule.dart';
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

  Future<List<Plant>> getAllUserPlants() async {
    List<Plant> plants = [];
    String? userId = auth.currentUser?.uid;
    if (userId == null) {
      NotificationSnackBar(text: 'You need to be logged in to view plants.')
          .show();
      return plants;
    }

    try {
      QuerySnapshot plantCollectionSnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('plants')
          .get();

      for (var doc in plantCollectionSnapshot.docs) {
        plants.add(Plant.fromJson(doc.data() as Map<String, dynamic>, doc.id));
      }
      return plants;
    } catch (e) {
      NotificationSnackBar(text: 'Failed to get plants: ${e.toString()}')
          .show();
      return plants;
    }
  }

  Future<void> setWateringSchedule(String plantId, String frequency) async {
    String? userId = auth.currentUser?.uid;
    if (userId == null) {
      NotificationSnackBar(
              text: 'You need to be logged in to set watering schedules.')
          .show();
      return;
    }

    try {
      DateTime nextWateringDate = calculateNextWateringDate(frequency);

      await firestore
          .collection('users')
          .doc(userId)
          .collection('plants')
          .doc(plantId)
          .update({
        'wateringSchedule': {
          'frequency': frequency,
          'nextWateringDate': nextWateringDate,
        },
      });

      NotificationSnackBar(text: 'Watering schedule set successfully!').show();
    } catch (e) {
      NotificationSnackBar(
              text: 'Failed to set watering schedule: ${e.toString()}')
          .show();
    }
  }

  DateTime calculateNextWateringDate(String frequency) {
    final now = DateTime.now();

    switch (frequency.toLowerCase()) {
      case 'daily':
        return now.add(const Duration(days: 1));
      case 'weekly':
        return now.add(const Duration(days: 7));
      case 'bi-weekly':
        return now.add(const Duration(days: 14));
      default:
        return now.add(const Duration(days: 1));
    }
  }

  Future<List<WateringSchedule>> getAllUserWateringSchedules() async {
    List<WateringSchedule> schedules = [];
    String? userId = auth.currentUser?.uid;
    if (userId == null) {
      NotificationSnackBar(
              text: 'You need to be logged in to view watering schedules.')
          .show();
      return schedules;
    }

    try {
      QuerySnapshot scheduleCollectionSnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('plants')
          .get();

      for (var doc in scheduleCollectionSnapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          Map<String, dynamic>? wateringData =
              data['wateringSchedule'] as Map<String, dynamic>?;
          if (wateringData != null &&
              wateringData['frequency'] != null &&
              wateringData['nextWateringDate'] != null) {
            schedules.add(WateringSchedule(
              plantId: doc.id,
              frequency: wateringData['frequency']!,
              nextWateringDate:
                  (wateringData['nextWateringDate']! as Timestamp).toDate(),
            ));
          }
        }
      }

      return schedules;
    } catch (e) {
      NotificationSnackBar(
              text: 'Failed to get watering schedules: ${e.toString()}')
          .show();
      return schedules;
    }
  }
}
