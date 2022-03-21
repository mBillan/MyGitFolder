
class User {
  final String email, name;
  final String? image;

  User(this.email, this.name, this.image,);

  static User getOne() {
    return User(
      "marwan.billan@outlook.com",
      "Marwan Technologies",
      "./assets/images/apps/fan_cate/martech_logo.png",
    );
  }
}
