import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_cate/flutx/flutx.dart';
import 'package:fan_cate/data/post.dart';

class PostController extends FxController {
  bool showLoading = true, uiLoading = true;
  List<Post>? posts;
  Stream<QuerySnapshot>? postsStream;

  @override
  initState() {
    super.save = false;
    super.initState();

    postsStream = FirebaseFirestore.instance.collection('posts').snapshots();

    showLoading = false;
    uiLoading = false;
    update();
  }

  void updatePosts(List<QueryDocumentSnapshot<Object?>> docs) {
    showLoading = true;
    uiLoading = true;

    print("Updating the posts");
    List<Post> updatedPostsList = [];
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
        comments: data["comments"], // The comments are of type: List<dynamic>?
      );

      updatedPostsList.add(currPost);
    }

    posts = updatedPostsList;
    showLoading = false;
    uiLoading = false;
  }

  @override
  String getTag() {
    return "post_controller";
  }
}
