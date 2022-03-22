import 'dart:ffi';
import 'dart:math';

import 'package:bband/src/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "authentication.dart";

// ChangeNotifier is a Listenable class in which we can use async flows
// below we implement the sign in/up/out flow using async messages
// Starting from the init state (loggedout) the RSVP is presented.
// onPressed, it'll call startLoginFlow, which updates the logingstate.
// Then it notifies the listeners, triggering each client's/listener's job.
// in our case, each time we call notifyListeners, the Authentication class constructor is called :)
class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        getProfileImage();
        _loginState = ApplicationLoginState.loggedIn;
        _feedMessagesSubscription = FirebaseFirestore.instance
            .collection('feed')
            .orderBy('timestamp', descending: true)
            .limit(5)
            .snapshots()
            .listen((snapshot) {
          _feedMessages = [];
          snapshot.docs.forEach((document) async {
            print("I am getting this message: ${document.data()}");
            Map<String, dynamic> data = document.data();
            List<Comment> commentsMap = [];
            // TODO: move the getComments call out from  this listener
            // if (data.containsKey("comments") && data['comments'] != null) {
            //   commentsMap = await getComments(List.from(data['comments']));
            // }
            _feedMessages.add(
              Post(
                  postId: document.id,
                  userId: data['userId'],
                  name: data['name'],
                  desc: data['desc'],
                  multiMedia: MultiMedia(
                    imageController: data['imgLink'],
                    videoController: data['videoLink'],
                    audioController: '',
                  ),
                  likes: List.from(data['likes']),
                  comments: commentsMap),
            );

            // _feedMessages.add(FeedMessage(
            //                 docId: document.id,
            //                 userId: data['userId'],
            //                 name: data['name'],
            //                 desc: data['desc'],
            //                 imgLink: data['imgLink'],
            //                 videoLink: data['videoLink'],
            //                 likes: List.from(data['likes']),
            //             ));
          });
          notifyListeners();

        });
        FirebaseFirestore.instance
            .collection('user')
            .orderBy('timestamp', descending: true)
            // .limit(5)
            .snapshots()
            .listen((snapshot) {
          _musicians = {};
          snapshot.docs.forEach((document) async {
            print("Loading this musician: ${document.data()}");
            Map<String, dynamic> data = document.data();
            _musicians[document.id] = Musician(
              name: data['name'],
              bio: data['bio'],
              profile: data['profile'],
              followers: List.from(data['followers']),
              following: List.from(data['following']),
            );
          });
          notifyListeners();

        });

      } else {
        _loginState = ApplicationLoginState.loggedOut;
        _feedMessages = [];
        _feedMessagesSubscription?.cancel();
        _musicians = {};
      }
      notifyListeners();
    });
  }

  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;

  String? _email;
  String? get email => _email;

  String _profileImageLink = '';
  String get profileImageLink => _profileImageLink;

  StreamSubscription<QuerySnapshot>? _feedMessagesSubscription;
  // TODO: Update it to be a map from postId to the Post
  List<Post> _feedMessages = [];
  List<Post> get feedMessages => _feedMessages;

  Map<String, Musician> _musicians = {};
  Map<String, Musician> get musicians => _musicians;

  int _selectedPost = 0;
  int get selectedPost => _selectedPost;

  void startLoginFlow() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  void verifyEmail(
    String email,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      var methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.contains('password')) {
        _loginState = ApplicationLoginState.password;
      } else {
        _loginState = ApplicationLoginState.register;
      }
      _email = email;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signInWithEmailAndPassword(
    String email,
    String password,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void cancelRegistration() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  void registerAccount(String email, String displayName, String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(displayName);
      await addMusician(credential.user!.uid);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  Future<void> addMusician(String uid) {
    return FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(<String, dynamic>{
          'profile': '',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'name': FirebaseAuth.instance.currentUser!.displayName,
          'bio': '',
          'followers': [],
          'following': [],
        })
        .then((value) => print("Added new user $uid"))
        .catchError(
            (error) => print("Failed to update the profile image: $error"));
  }

  Future<void> followUser(String toFollowId, String followerId) async {
    // Add the follower to the list of followers of the toFollow
    FirebaseFirestore.instance
        .collection('user')
        .doc(toFollowId)
        .update(<String, dynamic>{
      'followers': FieldValue.arrayUnion([followerId]),
    }).then((value) {
      print("$followerId is added to the followers list of $toFollowId");
      notifyListeners();
    }).catchError((error) => print("Failed to follow"));

    // Add the toFollow to the list of following of the follower
    FirebaseFirestore.instance
        .collection('user')
        .doc(followerId)
        .update(<String, dynamic>{
      'following': FieldValue.arrayUnion([toFollowId]),
    }).then((value) {
      print("$toFollowId is now added to the following list of $followerId");
      notifyListeners();
    }).catchError((error) => print("Failed to follow"));
  }

  Future<void> unFollowUser(String toFollowId, String followerId) async {
    // Add the follower to the list of followers of the toFollow
    FirebaseFirestore.instance
        .collection('user')
        .doc(toFollowId)
        .update(<String, dynamic>{
      'followers': FieldValue.arrayRemove([followerId]),
    }).then((value) {
      print("$followerId is added to the followers list of $toFollowId");
      notifyListeners();
    }).catchError((error) => print("Failed to follow"));

    // Add the toFollow to the list of following of the follower
    FirebaseFirestore.instance
        .collection('user')
        .doc(followerId)
        .update(<String, dynamic>{
      'following': FieldValue.arrayRemove([toFollowId]),
    }).then((value) {
      print("$toFollowId is now added to the following list of $followerId");
      notifyListeners();
    }).catchError((error) => print("Failed to follow"));
  }

  Future<DocumentReference> addFeedData(String message) {
    // TODO: add image/video/audio
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance.collection('feed').add(<String, dynamic>{
      'desc': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  Future<void> updateProfileImage() async {
    User? currUser = FirebaseAuth.instance.currentUser;

    ListResult result = await FirebaseStorage.instance
        .ref('profilePictures/' +
            currUser!.displayName.toString() +
            currUser.uid)
        .list(const ListOptions(maxResults: 2));
    // TODO: sort the result to get the latest profile image
    String link = await result.items[0].getDownloadURL();
    _profileImageLink = link;
    // await updateUserProfile();
    notifyListeners();
  }

  // Future<void> getProfileImage() async {
  //   FirebaseFirestore.instance
  //       .collection('user')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       // .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //       // .limit(1)
  //       .get()
  //   .then((value) {
  //     _profileImageLink = value['profile'];
  //     notifyListeners();
  //   })
  //   .catchError((error) {
  //     print("No profile image available. Setting it to ''");
  //     _profileImageLink = null;
  //     notifyListeners();
  //   });
  // }

  Future<void> getProfileImage({String uid = ''}) async {
    uid = uid != '' ? uid : FirebaseAuth.instance.currentUser!.uid;
    return await FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .get()
        .then((value) {
      print("Got this profile image: " + value['profile']);

      _profileImageLink = value['profile'];
      notifyListeners();
    }).catchError((error) {
      print("No profile image available. Setting it to ''");
    });
  }

  void updateUserProfile(String imgPath) {
    // TODO: add image/video/audio
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }
    _profileImageLink = imgPath;
    notifyListeners();

    // return FirebaseFirestore.instance
    //     .collection('user').doc(FirebaseAuth.instance.currentUser!.uid).set(<String, dynamic>{
    //       'profile': imgPath,
    //       'timestamp': DateTime.now().millisecondsSinceEpoch,
    //       'name': FirebaseAuth.instance.currentUser!.displayName,
    //     })
    //     .then((value) => print("Updated the profile image"))
    //     .catchError(
    //         (error) => print("Failed to update the profile image: $error"));
  }

  void loadNextPost() {
    // TODO: the selected post should be picked based on an AI model that recommends what post should be shown next to each user

    // Random random = Random();
    // _selectedPost = random.nextInt(_feedMessages.length - 1);
    _selectedPost = (selectedPost + 1) % feedMessages.length;
    notifyListeners();
  }

  void loadBeforePost() {
    // Random random = Random();
    // _selectedPost = random.nextInt(_feedMessages.length - 1);
    _selectedPost = (selectedPost - 1) % feedMessages.length;
    notifyListeners();
  }

  void resetPostIterator() {
    _selectedPost = 0;
    notifyListeners();
  }

  Future<void> likePost(String postId) async {
    FirebaseFirestore.instance
        .collection('feed')
        .doc(postId)
        .update(<String, dynamic>{
      'likes': FieldValue.arrayUnion([
        FirebaseAuth.instance.currentUser!.uid
      ]), // Add FirebaseAuth.instance.currentUser!.uid to the list of likes
    }).then((value) {
      print("liked");
      notifyListeners();
    }).catchError((error) => print("Failed to like"));
  }

  Future<void> unlikePost(String postId) async {
    FirebaseFirestore.instance
        .collection('feed')
        .doc(postId)
        .update(<String, dynamic>{
      'likes': FieldValue.arrayRemove([
        FirebaseAuth.instance.currentUser!.uid
      ]), // Add FirebaseAuth.instance.currentUser!.uid to the list of likes
    }).then((value) {
      print("unliked");
      notifyListeners();
    }).catchError((error) => print("Falit to unlike"));
  }

  // Comments
  Future<void> addComment(
    String text,
    String postId,
  ) async {
    // Add the comment to the DB
    DocumentReference comment = await FirebaseFirestore.instance
        .collection('comments')
        .add(<String, dynamic>{
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'postId': postId,
      'text': text,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    }); //.catchError((error) => print("Failed to add a new comment: $error"));

    if (comment != null) {
      print("Added a new comment " + comment.id);
      // Update the comments list of the post with the new comment id
      await FirebaseFirestore.instance
          .collection('feed')
          .doc(postId)
          .update(<String, dynamic>{
        'comments': FieldValue.arrayUnion([
          comment.id
        ]), // Add FirebaseAuth.instance.currentUser!.uid to the list of likes
      }).then((value) {
        notifyListeners();
      }).catchError((error) => print("Falit to unlike"));
    }
  }

  Future<List<Comment>> getComments(
    List<dynamic> commentIds,
  ) async {
    List<Comment> commentsMap = [];
    print("Dealing with the comments");

    for (var id in commentIds) {
      // TODO: reverse the call, call Firebase once to get all the comments for all the ids
      print("Dealing with $id");
      DocumentSnapshot commentSnap = await FirebaseFirestore.instance
          .collection('comments')
          .doc(id)
          .get()
          .catchError((error) {
        print("No profile image available. Setting it to '' ");
      });

      commentsMap.add(Comment(
        uid: commentSnap['uid'],
        text: commentSnap['text'],
        timestamp: commentSnap['timestamp'].toString(),
        postId: commentSnap['postId'],
      ));
    }
    return commentsMap;

    //     DocumentSnapshot comment = await FirebaseFirestore.instance
    //     .collection('comments')
    //     .doc(commentId)
    //     .get()
    //     .catchError((error) {
    //   print("No profile image available. Setting it to ''");
    // });
    // return Comment(
    //   uid: comment['uid'],
    //   text: comment['text'],
    //   timestamp: comment['timestamp'],
    //   postId: comment['postId'],
    // );
  }
}

class FeedMessage {
  FeedMessage({
    required this.docId,
    required this.userId,
    required this.name,
    required this.desc,
    required this.imgLink,
    required this.videoLink,
    required this.likes,
  });
  final String docId;
  final String userId;
  final String name;
  final String desc;
  final String? imgLink;
  final String? videoLink;
  final List<dynamic> likes;
}

class Post {
  Post({
    required this.postId,
    required this.userId,
    required this.name,
    required this.desc,
    required this.multiMedia,
    required this.likes,
    required this.comments,
  });
  final String postId;
  final String userId;
  final String name;
  final String desc;
  final MultiMedia? multiMedia;
  final List<dynamic> likes;
  final List<dynamic> comments;
}

class Musician {
  Musician({
    required this.profile,
    required this.name,
    required this.bio,
    required this.followers,
    required this.following,
  });
  final String profile;
  final String name;
  final String bio;
  final List<dynamic> followers;
  final List<dynamic> following;
}

class MultiMedia {
  MultiMedia({
    required this.imageController,
    required this.videoController,
    required this.audioController,
  });
  // TODO: update the types of these params to be controllers rather than String
  // final Image? imageController;
  // final FlickManager? videoController;
  final String? imageController;
  final String? videoController;
  final String? audioController;
}

class Comment {
  Comment({
    required this.uid,
    required this.postId,
    required this.text,
    required this.timestamp,
  });
  final String uid;
  final String postId;
  final String text;
  final String timestamp;
}
