import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String profileImage, name, status, postImage;
  final String time;
  final List<String>? comments;
  final int likes;

  Post(
      {required this.profileImage,
      required this.name,
      required this.status,
      required this.postImage,
      required this.time,
      this.likes = 0,
      this.comments = const []});

  static List<Post> postsList() {
    List<Post> list = [];

    list.add(Post(
      profileImage: 'assets/images/profile/avatar_2.jpg',
      name: 'Dr. John Rodriguez',
      status: 'Hello, how can i help you man?',
      time: '14:22 am',
      postImage: 'assets/images/apps/social/post-1.jpg',
      comments: [
        "That's a good one",
        "you rock!!",
        "This talk no walk",
        "I have hour order the coffee!",
        "Pain",
        "You've got to do what you've got to do"
      ],
      likes: 54,
    ));
    list.add(
      Post(
          profileImage: './assets/brand/google.png',
          name: "Google",
          status: "Sponsored",
          postImage: './assets/images/apps/social/post-1.jpg',
          likes: 700,
          time: 'Yesterday',
          comments: [
            "I am already in love with this",
            "your new look is awesome!"
          ]),
    );
    list.add(
      Post(
          profileImage: './assets/images/profile/avatar_3.jpg',
          name: "Gordon Hays",
          status: "Ahmedabad, Gujarat",
          postImage: './assets/images/apps/social/post-l1.jpg',
          likes: 98,
          time: 'Yesterday'),
    );
    return list;
  }

  static Post getOne() {
    return postsList().first;
  }
}
