import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_cate/flutx/flutx.dart';
import 'package:fan_cate/data/post.dart';
import '../src/engagement.dart';


class PostController extends FxController {
  bool showLoading = true, uiLoading = true;
  Map<String, Post>? posts;
  Stream<QuerySnapshot>? postsStream;
  CollectionReference? postsCollection;

  @override
  initState() {
    super.save = false;
    super.initState();

    postsCollection = FirebaseFirestore.instance.collection('posts');
    postsStream = postsCollection?.snapshots();

    showLoading = false;
    uiLoading = false;
    update();
  }

  void reloadPosts(List<QueryDocumentSnapshot<Object?>> docs) {
    showLoading = true;
    uiLoading = true;

    print("Updating the posts");
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
        comments: data["comments"], // The comments are of type: List<dynamic>?
      );
      updatedPostsList[docs[idx].id] = currPost;
    }

    posts = updatedPostsList;
    showLoading = false;
    uiLoading = false;
  }

  Future<void> updateLikes(String postID, EngagementType engage) async {
    // showLoading = true;
    // uiLoading = true;

    int newLikes = posts![postID]!.likes;

    switch(engage){
      case EngagementType.like:
        newLikes += 1;
        break;
      case EngagementType.dislike:
        newLikes -= 1;
        break;
      default:
        break;
    }

    await postsCollection!.doc(postID).update({"likes": newLikes});

    // postsCollection.
    // showLoading = false;
    // uiLoading = false;
  }
  @override
  String getTag() {
    return "post_controller";
  }
}
