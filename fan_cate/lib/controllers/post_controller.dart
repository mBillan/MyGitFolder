import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_cate/controllers/user_controller.dart';
import 'package:fan_cate/flutx/flutx.dart';
import 'package:fan_cate/data/post.dart';
import 'package:flutter/material.dart';
import '../src/engagement.dart';
import 'comment_controller.dart';

class PostController extends FxController {
  bool showLoading = true, uiLoading = true;
  Map<String, Post>? posts;
  Stream<QuerySnapshot>? postsStream;
  CollectionReference? postsCollection;
  GlobalKey<FormState> formKey = GlobalKey();
  UserController userController = FxControllerStore.putOrFind(UserController());

  // A dummy commentController with empty comments for internal use only
  final CommentController _commentController = FxControllerStore.put(CommentController(''));

  @override
  initState() {
    super.save = false;
    super.initState();

    postsCollection = FirebaseFirestore.instance.collection('posts');
    postsStream = postsCollection?.orderBy('timestamp', descending: true).snapshots();

    showLoading = false;
    uiLoading = false;
  }

  void reloadPosts(List<QueryDocumentSnapshot<Object?>> docs) {
    showLoading = true;
    uiLoading = true;

    Map<String, Post> updatedPostsList = {};
    for (int idx = 0; idx < docs.length; idx++) {
      Map<String, dynamic> data = docs[idx].data()! as Map<String, dynamic>;
      // TODO: update it the post with the user's real info after adding a User's record to the Firebase
      Post currPost = Post(
        profileImage: './assets/images/apps/fan_cate/martech_logo.png',
        name: "Marwan Billan",
        // profileImage: user[data['uid']].profileImage,
        // name: user[data['uid']].displayName,
        status: data["status"],
        postImage: './assets/images/apps/fan_cate/meal-${(idx) % 4 + 1}.jpg',
        likes: data["likes"],
        // TODO: write the time in a readable format
        time: data["time"],
        comments: data["comments"],
        // The comments are of type: List<dynamic>?
        likeUids: data["likeUids"], // The likeUids are of type: List<dynamic>?
      );

      updatedPostsList[docs[idx].id] = currPost;
    }

    posts = updatedPostsList;
    showLoading = false;
    uiLoading = false;
  }

  void updateLikes(String postID, EngagementType engage) {
    showLoading = true;
    uiLoading = true;

    int newLikes = posts![postID]!.likes;
    List<dynamic>? newLikeUids = posts![postID]!.likeUids;

    switch (engage) {
      case EngagementType.like:
        newLikes += 1;
        newLikeUids?.add(userController.user!.uid);
        break;

      case EngagementType.unlike:
        newLikes -= 1;
        newLikeUids?.remove(userController.user!.uid);
        break;
      default:
        break;
    }

    postsCollection!.doc(postID).update({
      "likes": newLikes,
      "likeUids": newLikeUids,
    });

    showLoading = false;
    uiLoading = false;
  }

  bool didUserLikedPost(String postID) {
    return posts![postID]!.likeUids?.contains(userController.user!.uid) ??
        false;
  }

  @override
  String getTag() {
    return "post_controller";
  }

  String? validateComment(String? comment) {
    const int minLength = 4, maxLength = 100;
    if (comment == null || comment.isEmpty) {
      return "Please enter a comment";
    }
    if (FxStringValidator.isSpecialCharacterIncluded(comment)) {
      return "Please don't use special characters";
    }
    if (!FxStringValidator.validateStringRange(comment, minLength, maxLength)) {
      return "Comment length must between $minLength and $maxLength";
    }
    return null;
  }

  Future<void> addComment(
      BuildContext context, String comment, String postID) async {
    if (formKey.currentState!.validate()) {
      // TODO: Add the comment to the post list of comments
      String newCommentID = await _commentController.addCommentToFirebase(
          context, comment, postID);
      await addCommentToPost(newCommentID, comment, postID);
    }
  }

  Future<void> addCommentToPost(
      String commentID, String comment, String postID) async {
    // TODO: Update the Comments field of the Posts to be a map
    List<dynamic>? currComments = posts![postID]!.comments;
    // currComments?.add(commentID);
    currComments?.add(comment);

    await postsCollection!.doc(postID).update({"comments": currComments});
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
