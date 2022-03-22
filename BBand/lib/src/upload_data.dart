import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_compress/video_compress.dart';
import 'app_state.dart';
import 'widgets.dart';

import 'dart:io';
import 'package:video_player/video_player.dart';

import 'package:firebase_auth/firebase_auth.dart';

class Upload extends StatelessWidget {
  const Upload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? currUser = FirebaseAuth.instance.currentUser;
    return Column(children: [
      const Paragraph('Upload new piece of art'),
      IconAndDetail(Icons.verified_user, currUser!.displayName.toString()),
      const StyledDivider(),
      Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Data(
                    profileImage: null,
                  ),
                ));
          },
          child: IconAndDetail(Icons.upload_rounded, 'Upload'),
        ),
      ),
    ]);
  }
}

class Data extends StatefulWidget {
  Data({required this.profileImage});
  final String? profileImage;

  @override
  _DataState createState() => _DataState();
}

class _DataState extends State<Data> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_DataState');
  final _controller = TextEditingController();

  User? currUser = FirebaseAuth.instance.currentUser;

  ImagePicker picker = ImagePicker();
  // final _videoCompress = FlutterVideoCompress();

  File? _image;
  File? _video;
  late VideoPlayerController _videoPlayerController;

  @override
  Widget build(BuildContext context) {
    bool isProfileView = widget.profileImage != null;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Creating"),
        ),
        body: ListView(
          children: [
            Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Header("Fill in the following fields"),
                    StyledDivider(),
                    // TODO: Video/Audio tracks
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          _showPicker(context);
                        },
                        child: CircleAvatar(
                            radius: 105,
                            backgroundColor: Color(0xffFDCF09),
                            child:
                                // _image != null ||
                                //         isProfileView ||
                                //         _video != null
                                //     ?
                                ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: _video != null
                                  ? AspectRatio(
                                      aspectRatio: _videoPlayerController
                                          .value.aspectRatio,
                                      child:
                                          VideoPlayer(_videoPlayerController),
                                    )
                                  : _image != null
                                      ? Image.file(
                                          _image!,
                                          width: 200,
                                          height: 200,
                                          fit: BoxFit.fitHeight,
                                        )
                                      : isProfileView &&
                                              widget.profileImage != ''
                                          ? Image.network(
                                              widget.profileImage.toString(),
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                              width: 200,
                                              height: 200,
                                              child: Icon(
                                                Icons.camera_alt,
                                                color: Colors.grey[800],
                                              ),
                                            ),
                            )),
                      ),
                    ),
                    _video != null
                        ? FloatingActionButton(
                            key: UniqueKey(),
                            onPressed: () {
                              setState(() {
                                _videoPlayerController.value.isPlaying
                                    ? _videoPlayerController.pause()
                                    : _videoPlayerController.play();
                              });
                            },
                            child: Icon(
                              _videoPlayerController.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                            ),
                          )
                        : const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: _controller,
                                decoration: InputDecoration(
                                  hintText:
                                      isProfileView ? 'Bio...' : 'Desc...',
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      (_image == null && _video == null)) {
                                    return 'Complete all the fields to continue';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 80),
                          ],
                        ),
                      ),
                    ),

                    Consumer<ApplicationState>(
                        builder: (context, appState, _) => Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  StyledButton(
                                    onPressed: () async {
                                      if (isProfileView ||
                                          _formKey.currentState!.validate()) {
                                        await _uploadData(_controller.text);
                                        if (isProfileView && _image != null) {
                                          // Update the app state with the new link of the profile image
                                          appState
                                              .updateUserProfile(_image!.path);
                                        }
                                        _controller.clear();
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Row(
                                      children: const [
                                        Icon(Icons.cloud_upload),
                                        SizedBox(width: 4),
                                        Text('Upload'),
                                      ],
                                    ),
                                  ),
                                ],
                        ),
                    ),
                  ]),
            ),
          ],
        ));
  }

  _imgFromCamera() async {
    File image = File((await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 300,
      maxWidth: 300,
    ))!
        .path);
    print("Pickec image is " + image.path);

    setState(() {
      _image = image;
      _video = null;
    });
  }

  _imgFromGallery() async {
    File image = File((await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 300,
      maxWidth: 300,
    ))!
        .path);

    setState(() {
      _image = image;
      _video = null;
    });
  }

  _compressVideo(File video) async {
    final MediaInfo? compressionInfo = await VideoCompress.compressVideo(
      video.path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
      includeAudio: true,
    );
    return File(compressionInfo!.path.toString());
  }

  _videoFromCamera() async {
    File video = File((await picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(seconds: 10),
    ))!
        .path);

    // Update the video controller to pause/play/stop the player
    _videoPlayerController = VideoPlayerController.file(video)
      ..initialize().then((_) {
        setState(() {
          _video = video;
          _image = null;
        });
        _videoPlayerController.play();
      });
  }

  _videoFromGallery() async {
    File video = File((await picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(seconds: 10),
    ))!
        .path);

    _videoPlayerController = VideoPlayerController.file(video)
      ..initialize().then((_) {
        setState(() {
          _video = video;
          _image = null;
        });
        _videoPlayerController.play();
      });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Photo Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.video_library),
                    title: Text('Video library'),
                    onTap: () {
                      _videoFromGallery();
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.videocam_rounded),
                    title: Text('Video Camera'),
                    onTap: () {
                      _videoFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _uploadData(String desc) async {
    // Process the given data
    // Upload it to the firebase
    // TODO: add video/audio
    if (_image == null && _video == null && desc == '') {
      StyledToast('Nothing was updated!');
      return;
    }
    String imageLink = '';
    String videoLink = '';

    if (_image != null) {
      // imageLink = await _uploadImage();
      _image = File(await _uploadImage());
    }

    if (_video != null) {
      // videoLink = await _uploadVideo();
      _video = File(await _uploadVideo());
    }

    if (widget.profileImage == null) {
      // Then we're uploading a new post rather than a profile picture
      await _uploadNewPost(desc);
    } else {
      if (_image == null) {
        await _updateUserProfile(widget.profileImage.toString(), desc);
      } else {
        await _updateUserProfile(_image!.path, desc);
      }
    }
  }

  Future<void> _uploadNewPost(String desc) {
    return FirebaseFirestore.instance.collection('feed').add(<String, dynamic>{
      'desc': desc,
      // '?.' is  null-aware operator where it returns null if one of the arguments is null
      // '!.' is a null-check operator where it asserts that the value is not null
      'imgLink': _image?.path,
      'videoLink': _video?.path,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'likes': [], // This should be a List<String> of uids
      'comments': [], // This should be a List<Comments> of Comments
    })
      ..then((value) => StyledToast("Added a new post")).catchError(
          (error) => StyledToast("Failed to add a new post: $error"));
  }

  Future<void> _updateUserProfile(String imgPath, String bio) {
    return FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(<String, dynamic>{
          'profile': imgPath,
          'bio': bio,
        })
        .then((value) => print("Updated the profile image"))
        .catchError(
            (error) => print("Failed to update the profile image: $error"));
  }

  Future<String> _uploadImage() async {
    assert(_image != null || widget.profileImage != null);

    if (widget.profileImage != null &&
        (_image?.path == widget.profileImage.toString())) {
      StyledToast('Image wasn\'t updated');
      return _image!.path;
    }
    // Establish a connection to the FS
    FirebaseStorage storage = FirebaseStorage.instance;

    String mainDir =
        widget.profileImage == null ? 'feedPictures' : 'profilePictures';

    Reference ref = storage
        .ref()
        .child(mainDir)
        .child(currUser!.displayName! + currUser!.uid)
        .child("img_" + DateTime.now().toString());

    // Upload the data to the cloud and wait until it's completed
    UploadTask uploadTask = ref.putFile(_image!);
    String imageLink = await uploadTask.then((res) async {
      return await res.ref.getDownloadURL();
    });

    // setState(() {});

    StyledToast('Image uploaded successfully');
    return imageLink;
  }

  Future<String> _uploadVideo() async {
    // Establish a connection to the FS
    FirebaseStorage storage = FirebaseStorage.instance;

    String mainDir = 'feedVideos';
    String videoId = DateTime.now().toString();

    Reference ref = storage
        .ref()
        .child(mainDir)
        .child(currUser!.displayName! + currUser!.uid)
        .child("video_$videoId.mp4");

    File compressedVideo = await _compressVideo(_video!);

    // Upload the data to the cloud and wait until it's completed
    UploadTask uploadTask = ref.putFile(compressedVideo);
    String videoLink = await uploadTask.then((res) async {
      return await res.ref.getDownloadURL();
    });

    // setState(() {});

    StyledToast('Video uploaded successfully');
    return videoLink;
  }
}
