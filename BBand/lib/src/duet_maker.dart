import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'widgets.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';

enum MixingProgress {
  onGoing,
  complete,
  none,
  canceled,
  error,
}

class Duets extends StatefulWidget {
  Duets({this.originalVideo, this.originalImage});
  final String? originalVideo;
  final String? originalImage;

  @override
  State<StatefulWidget> createState() {
    return _DuetsState();
  }
}

class _DuetsState extends State<Duets> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_DuetsState');
  final _controller = TextEditingController();

  ImagePicker picker = ImagePicker();
  // final _videoCompress = FlutterVideoCompress();

  File? _image;
  File? _newVideo;
  File? _newVideo2;
  File? _mixedVideo;
  late VideoPlayerController _videoPlayerController;
  MixingProgress _mixingProgress = MixingProgress.none;
  User? currUser = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Creating Duet"),
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Header("Start dueting"),
                StyledDivider(),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        // File image = File(message.imgLink.toString());
                        _showPicker(context, 0);
                        StyledToast("Uploading new image");
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0), //or 15.0
                        child: Container(
                          key: UniqueKey(),
                          height: 170.0,
                          width: 170.0,
                          color: const Color(0xff979797),
                          child: _newVideo == null
                              ? const Icon(Icons.add,
                                  color: Colors.white, size: 40)
                              : DefaultPlayer(videoLink: _newVideo!.path),
                        ),
                      ),
                    ),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(15.0), //or 15.0
                        child: Container(
                          key: UniqueKey(),
                          height: 170.0,
                          width: 170.0,
                          color: const Color(0xff979797),
                          child: widget.originalImage != null
                              ? Image.network(
                                  widget.originalImage.toString(),
                                  // Show a progressive loading circle
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                )
                              : widget.originalVideo != null
                                  ? DefaultPlayer(
                                      videoLink:
                                          widget.originalVideo.toString())
                                  : Container(),
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                StyledButton(
                    child: const IconAndDetail(
                        Icons.audiotrack, "Upload your Audio"),
                    onPressed: () {
                      StyledToast("Open a SafeArea to record/upload audio");
                    }),
                // TODO :Add an option to slightly edit/cut/align the new video
                // TODO: Control both the original and the new video with this play button
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
                            decoration: const InputDecoration(
                              hintText:'Desc...',
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  (_mixedVideo == null)) {
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
              ],
            ),
          ),
          _mixingProgress != MixingProgress.complete && _mixingProgress != MixingProgress.onGoing
          ? Container()
          :
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0), //or 15.0
            child: Container(
              key: UniqueKey(),
              height: 300.0,
              width: 300.0,
              // color: const Color(0xff979797),
              child: _mixingProgress == MixingProgress.complete
                  ? DefaultPlayer(videoLink: _mixedVideo!.path)
                  // Otherwise, the mixing is onGoing
                  : const RefreshProgressIndicator()
            ),
          ),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            StyledButton(
                child: const IconAndDetail(Icons.preview, 'Preview'),
                onPressed: () async {
                  print("Trying to merge the two videos");
                  if(_newVideo == null){
                    StyledToast("Please upload you video first");
                    return;
                  }
                  setState(() {
                    _mixingProgress = MixingProgress.onGoing;
                  });

                  // Create a local temp video file
                  Directory tmpDir = await getTemporaryDirectory();
                  String tmpOutput = tmpDir.path +
                      '/duet' +
                      DateTime.now().millisecondsSinceEpoch.toString() +
                      '.mp4';

                  // Configure the way of mixing the videos
                  const filter =
                      // " [0:v]scale=480:640,setsar=1[l];[1:v]scale=480:640,setsar=1[r];[l][r]hstack;[0][1]amix -vsync 0 ";
                      " [0:v]scale=480:640,setsar=1[l];[1:v]scale=480:640,setsar=1[r];[l][r]hstack;[0][1]amix -vsync 1 ";

                  //-ss 00:00:20
                  // Mix the two video into one
                  await FlutterFFmpeg()
                      .execute(" -y   " +
                          // Left video file
                          " -i '" +
                          _newVideo!.path.toString() +
                          "'" +
                          // Right video file
                          // " -i '" + _newVideo2!.path.toString() + "' " +
                          " -i '" +
                          widget.originalVideo.toString() +
                          "' " +
                          // Mixing configuration
                          "-filter_complex" +
                          filter +
                          // Output file
                          tmpOutput)
                      .then((execution) {
                    print("Mixing result " + execution.toString());
                    //This method returns when execution completes.
                    // Returns zero on successful execution, 255 on user cancel and non-zero on error
                    switch (execution) {
                      case 0:
                        print("Completed the mix");
                        setState(() {
                          _mixingProgress = MixingProgress.complete;
                          _mixedVideo = File(tmpOutput);
                        });
                        break;

                      case 225:
                        print("User Canceled");
                        setState(() {
                          _mixingProgress = MixingProgress.canceled;
                        });
                        break;

                      default:
                        setState(() {
                          _mixingProgress = MixingProgress.error;
                        });
                        break;
                    }
                  });
                }),
            StyledButton(
                child: const IconAndDetail(Icons.post_add, 'Post it'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _uploadData(_controller.text, video: _mixedVideo);
                    // await _uploadData(_controller.text);
                    // if (isProfileView) {
                    //   // Update the app state with the new link of the profile image
                    //   appState
                    //       .updateUserProfile(_image!.path);
                    // }
                    _controller.clear();
                    Navigator.pop(context);
                  }
                }),
          ]),
        ],
      ),
    );
  }

  _imgFromCamera() async {
    File image = File((await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 300,
      maxWidth: 300,
    ))!
        .path);

    setState(() {
      _image = image;
      _newVideo = null;
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
      _newVideo = null;
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

  _videoFromCamera(int setVideo) async {
    File video = File((await picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(seconds: 5),
    ))!
        .path);

    video = await _compressVideo(video);
    // Update the video controller to pause/play/stop the player
    _videoPlayerController = VideoPlayerController.file(video)
      ..initialize().then((_) {
        setState(() {
          if (setVideo == 0) {
            _newVideo = video;
          } else {
            _newVideo2 = video;
          }
          _image = null;
        });
      });
  }

  _videoFromGallery(int setVideo) async {
    File video = File((await picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(seconds: 5),
    ))!
        .path);

    File compressedVideo = await _compressVideo(video);
    _videoPlayerController = VideoPlayerController.file(compressedVideo)
      ..initialize().then((_) {
        setState(() {
          if (setVideo == 0) {
            _newVideo = compressedVideo;
          } else {
            _newVideo2 = compressedVideo;
          }
          _image = null;
        });
      });
  }

  void _showPicker(context, int setVideo) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.video_library),
                    title: Text('Video library'),
                    onTap: () {
                      _videoFromGallery(setVideo);
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.videocam_rounded),
                    title: Text('Video Camera'),
                    onTap: () {
                      _videoFromCamera(setVideo);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }



  // Upload Data

  Future<void> _uploadData(String desc, {File? video}) async {
    assert(video != null);
    File uploadedVideo = File(await _uploadVideo(video!));
    await _uploadNewPost(desc, video: uploadedVideo);
  }

  Future<void> _uploadNewPost(String desc, {File? video, File? image}) {
    return FirebaseFirestore.instance.collection('feed').add(<String, dynamic>{
      'desc': desc,
      // '?.' is  null-aware operator where it returns null if one of the arguments is null
      // '!.' is a null-check operator where it asserts that the value is not null
      'imgLink': image?.path,
      'videoLink': video?.path,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    })
      ..then((value) => StyledToast("Added a new post")).catchError(
              (error) => StyledToast("Failed to add a new post: $error"));
  }


  Future<String> _uploadVideo(File video) async {
    // Establish a connection to the FS
    FirebaseStorage storage = FirebaseStorage.instance;

    String mainDir = 'feedVideos';
    String videoId = DateTime.now().toString();

    Reference ref = storage
        .ref()
        .child(mainDir)
        .child(currUser!.displayName! + currUser!.uid)
        .child("video_$videoId.mp4");

    // File compressedVideo = await _compressVideo(video!);

    // Upload the data to the cloud and wait until it's completed
    UploadTask uploadTask = ref.putFile(video);
    String videoLink = await uploadTask.then((res) async {
      return await res.ref.getDownloadURL();
    });

    // setState(() {});

    StyledToast('Video uploaded successfully');
    return videoLink;
  }
}
