import 'package:fan_cate/controllers/user_controller.dart';
import 'package:fan_cate/data/user.dart';
import 'package:fan_cate/flutx/flutx.dart';
import 'package:fan_cate/data/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddPostController extends FxController {
  bool showLoading = true,
      uiLoading = false;
  late Post post;
  UserController userController = FxControllerStore.putOrFind(UserController());


  AddPostController() {
    post = Post(
      profileImage: 'assets/images/profile/avatar_2.jpg',
      // profileImage: userController.user?.photoURL,
      name: userController.user?.displayName ?? '',
      status: 'Hello, how can i help you man?', // Take it from the Text Editor
      time: Timestamp.now().toString(),
      postImage: 'assets/images/apps/social/post-1.jpg', // if any, we'll start without it
      comments: [
        "That's a good one",
        "you rock!!",
        "This talk no walk",
        "I have hour order the coffee!",
        "Pain",
        "You've got to do what you've got to do"
      ],
      likes: 52344,
    );
  }




  @override
  String getTag() {
    return "add_post_controller";
  }

  Future<void> addPost(BuildContext context) async {
    uiLoading = true;
    update();

    await addPosToFirebase(context);

    uiLoading = false;
    update();

    // Navigator.of(context, rootNavigator: true).push();
  }

  Future<void> addPosToFirebase(BuildContext context) async {
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');

    // Call the posts CollectionReference to add a new user
    return posts
        .add({
      'uid': userController.user?.uid,
      'status': post.status,
      'time': post.time, //Timestamp.now().toString(),
      'postImage': post.postImage,
      'likes': post.likes,
      'comments': post.comments
    })
        .then((value) => showSnackBar(context, 'Post added'))
        .catchError((error) => showSnackBar(context, "Failed to add post: $error"));
  }

  void showSnackBar(BuildContext context, String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }
}
