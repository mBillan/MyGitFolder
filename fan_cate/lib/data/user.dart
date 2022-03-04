import 'package:fan_cate/controllers/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  final String email, name, image;

  User(this.email, this.name, this.image,);

  static User getOne() {
    return User(
      "marwan.billan@outlook.com",
      "Marwan Technologies",
      "./assets/images/apps/fan_cate/martech_logo.png",
    );
  }
}
