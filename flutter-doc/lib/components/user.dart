import 'package:firebase_auth/firebase_auth.dart';

class UserProfile{
  int biomesExplored = 0;
  int status = 0;
  String email;

  UserProfile({
    required this.biomesExplored,
    required this.status,
    required this.email});

     factory UserProfile.fromMap(Map<String, dynamic> data) {
    return UserProfile(
      email: data['email'] ?? '',
      biomesExplored: data['biomesExplored'] ?? 0,
      status: data['status'] ?? 0,
    );
  }
}
  UserProfile currentUserProfile = UserProfile(
  email: FirebaseAuth.instance.currentUser?.email ?? 'guest@example.com',
  status: 0,
  biomesExplored: 0,
);