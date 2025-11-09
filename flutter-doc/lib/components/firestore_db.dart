import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/components/user.dart';


class DatabaseService{

  final String uid;
  DatabaseService({required this.uid});
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future<void> updateUserData(String email, int biomesExplored, int status) async {
    return await userCollection.doc(uid).set({
      'email': email,
      'biomesExplored': biomesExplored,
      'status': status,
    });
  }
    Future<void> updateGameProgress({int? biomesExplored, int? status}) async {
    return await userCollection.doc(uid).update({
      if (biomesExplored != null) 'biomesExplored': biomesExplored,
      if (status != null) 'status': status,
    });
    
  }
Future<UserProfile> getUserProfile() async {
    final snapshot = await userCollection.doc(uid).get();
    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      return UserProfile(
        email: data['email'] ?? '',
        biomesExplored: data['biomesExplored'] ?? 0,
        status: data['status'] ?? 0,
      );
    } else {
      throw Exception("User profile not found");
    }
  }

}