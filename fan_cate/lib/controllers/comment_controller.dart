import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_cate/controllers/user_controller.dart';
import 'package:fan_cate/data/comment.dart';
import 'package:fan_cate/flutx/flutx.dart';
import 'package:fan_cate/src/styledDateTime.dart';
import 'package:flutter/material.dart';

class CommentController extends FxController {
  CommentController(this.postID);

  final String postID;

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
    commentsStream = commentsCollection
        ?.where('postID', isEqualTo: postID)
        ?.orderBy('timestamp', descending: false)
        .snapshots();

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
      'timestamp': timeSinceEpoch()
    });

    return docRef.id;
  }

  void reloadComments(List<QueryDocumentSnapshot<Object?>> docs) {
    showLoading = true;
    uiLoading = true;

    Map<String, Comment> updatedComments = {};
    for (int idx = 0; idx < docs.length; idx++) {
      Map<String, dynamic> data = docs[idx].data()! as Map<String, dynamic>;
      Comment currComment = Comment(
        text: data["text"],
        postID: data["postID"],
        uid: data["uid"],
        time: data["time"],
      );

      updatedComments[docs[idx].id] = currComment;
    }

    comments = updatedComments;
    showLoading = false;
    uiLoading = false;
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
