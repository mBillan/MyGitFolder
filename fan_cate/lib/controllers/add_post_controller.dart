import 'package:fan_cate/controllers/user_controller.dart';
import 'package:fan_cate/flutx/flutx.dart';
import 'package:fan_cate/data/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../src/styledDateTime.dart';

class AddPostController extends FxController {
  bool showLoading = true, uiLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();
  UserController userController = FxControllerStore.putOrFind(UserController());
  late TextEditingController statusTE = TextEditingController();

  AddPostController() {
    // TODO: add a postImage controller
    statusTE = TextEditingController(text: '');
  }

  @override
  String getTag() {
    return "add_post_controller";
  }

  String? validateStatus(String? status) {
    const int minLength = 4, maxLength = 200;
    if (status == null || status.isEmpty) {
      return "Please enter your status";
    }
    if (FxStringValidator.isSpecialCharacterIncluded(status)) {
      return "Please don't use special characters";
    }
    if (!FxStringValidator.validateStringRange(status, minLength, maxLength)) {
      return "Status length must between $minLength and $maxLength";
    }
    return null;
  }

  Future<void> addPost(BuildContext context) async {
    uiLoading = true;
    update();

    if (formKey.currentState!.validate()) {
      Post post = Post(
        profileImage: userController.user?.photoURL ??
            './assets/images/profile/avatar_place.png',
        name: userController.user?.displayName ?? '',
        status: statusTE.text,

        time: currTimeStyled(),
        // TODO: add a postImage controller
        postImage: './assets/images/apps/social/post-1.jpg',
      );

      await addPosToFirebase(context, post);
    }
    uiLoading = false;
    update();
  }

  Future<void> addPosToFirebase(BuildContext context, Post post) async {
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');

    // Call the posts CollectionReference to add a new post
    return posts
        .add({
          'uid': userController.user?.uid,
          'status': post.status,
          'time': post.time,
          'postImage': post.postImage,
          'likes': post.likes,
          'likeUids': post.likeUids,
          'comments': post.comments
        })
        .then((value) => showSnackBar(context, 'Post added'))
        .catchError(
            (error) => showSnackBar(context, "Failed to add post: $error"));
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
