import 'dart:typed_data';

class User {
  final String email, name;
  final String? image;
  final Uint8List? imageBytes;

  User({
    required this.name,
    required this.email,
    this.image,
    this.imageBytes,
  });

  static User getOne() {
    return User(
      name: "Marwan Technologies",
      email: "marwan.billan@outlook.com",
      image: "./assets/images/apps/fan_cate/martech_logo.png",
    );
  }
}
