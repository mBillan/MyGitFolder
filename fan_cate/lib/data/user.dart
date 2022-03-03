import 'package:firebase_auth/firebase_auth.dart';

class User {
  final String email, name, image;
  final FirebaseAuth auth;

  User(this.email, this.name, this.image, this.auth);

  static User getOne() {
    return User(
      "marwan.billan@outlook.com",
      "Marwan Technologies",
      "./assets/images/apps/fan_cate/martech_logo.png",
      FirebaseAuth.instance,
    );
  }
}
