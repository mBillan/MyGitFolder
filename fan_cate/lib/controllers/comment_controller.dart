import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_cate/controllers/user_controller.dart';
import 'package:fan_cate/data/comment.dart';
import 'package:fan_cate/flutx/flutx.dart';
import 'package:fan_cate/src/styledDateTime.dart';
import 'package:flutter/material.dart';

class CommentController extends FxController {
  bool showLoading = true, uiLoading = true;
  Map<String, Comment>? comments;
  Stream<QuerySnapshot>? commentsStream;
  CollectionReference? commentsCollection;
  GlobalKey<FormState> formKey = GlobalKey();
  UserController userController = FxControllerStore.putOrFind(UserController());

  @override
  initState() {
    super.save = false;
    super.initState();

    commentsCollection = FirebaseFirestore.instance.collection('comments');
    commentsStream = commentsCollection?.snapshots();

    showLoading = false;
    uiLoading = false;
  }

  @override
  String getTag() {
    return "comment_controller";
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

  Future<String> addCommentToFirebase(
      BuildContext context, String comment, String postID) async {
    CollectionReference comments =
        FirebaseFirestore.instance.collection('comments');

    // Call the posts CollectionReference to add a new comment
    DocumentReference docRef = await comments.add({
      'uid': userController.user?.uid,
      'postID': postID,
      'time': currTimeStyled(),
      'text': comment,
    });

    return docRef.id;
  }

//   void reloadPosts(List<QueryDocumentSnapshot<Object?>> docs) {
  List<dynamic> getCommentsByIDList(List<String> commentIDs) {
    List<dynamic> comments = [];
    for (String id in commentIDs) {
      comments.add(getCommentByID(id));
    }
    return comments;
  }

  Future<Comment> getCommentByID(String commentID) async {
    // Get the comment from the DB and then
    commentID = '0kF92eLuEebe8aVf3deO';
    DocumentSnapshot<dynamic>? res =
        await commentsCollection?.doc('0kF92eLuEebe8aVf3deO').get();

    Comment comment = Comment(text: '', uid: '', time: '', postID: '');
    return comment;
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
