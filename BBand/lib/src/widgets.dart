//import 'package:audioplayers/audioplayers.dart';
// import 'package:audio_service/audio_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_sound/public/tau.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:just_audio/just_audio.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'dart:io';

class Header extends StatelessWidget {
  const Header(this.heading);
  final String heading;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          heading,
          style: const TextStyle(fontSize: 24),
        ),
      );
}

class Paragraph extends StatelessWidget {
  const Paragraph(this.content);
  final String content;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Container(
          width: 200,
          child: Text(
            content,
            style: const TextStyle(fontSize: 18),
            // overflow: TextOverflow.ellipsis,
          ),
        ),
      );
}

class IconAndDetail extends StatelessWidget {
  const IconAndDetail(
    this.icon,
    this.detail,
  );
  final IconData icon;
  final String detail;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 8),
            Text(
              detail,
              style: const TextStyle(fontSize: 18),
            )
          ],
        ),
      );
}

class StyledButton extends StatelessWidget {
  const StyledButton({required this.child, required this.onPressed});
  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.deepPurple)),
        onPressed: onPressed,
        child: child,
      );
}

class StyledDivider extends StatelessWidget {
  const StyledDivider();

  @override
  Widget build(BuildContext context) => const Divider(
        height: 8,
        thickness: 1,
        indent: 8,
        endIndent: 8,
        color: Colors.grey,
      );
}

// TODO: Move to a new file for aux classes and helper methods
class StyledToast extends Fluttertoast {
  final String message;

  StyledToast(this.message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blueGrey,
        textColor: Colors.lightGreen);
  }
}

/*
class Data extends StatefulWidget {
  Data({required this.profileImage});
  final File? profileImage;

  @override
  _DataState createState() => _DataState();
}

class _DataState extends State<Data> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_DataState');
  final _controller = TextEditingController();
 */

class StyledThumbnail extends StatefulWidget {
  const StyledThumbnail({Key? key, required this.videoLink}) : super(key: key);
  final String videoLink;

  @override
  _StyledThumbnailState createState() => _StyledThumbnailState();
}

class _StyledThumbnailState extends State<StyledThumbnail> {
  late VideoPlayerController _controller;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class StyledVideoPlayer extends StatefulWidget {
  const StyledVideoPlayer({Key? key, required this.videoLink})
      : super(key: key);
  final String videoLink;

  @override
  _StyledVideoPlayerState createState() => _StyledVideoPlayerState();
}

class _StyledVideoPlayerState extends State<StyledVideoPlayer> {
  final _videoKey = GlobalKey<FormState>(debugLabel: '_StyledVideoPlayerState');
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      widget.videoLink,
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: true,
      ),
    )..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

    //
    // cacheFile(widget.videoLink);
    // print("After the cacheFile");

    // _controller = VideoPlayerController.network(widget.videoLink,
    //     videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true,),);
    // _controller.addListener(() {
    //   setState(() {});
    // });
    // _controller.setLooping(true);
    // _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: UniqueKey(),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                key: UniqueKey(),
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    VideoPlayer(_controller),
                    VideoProgressIndicator(_controller, allowScrubbing: true),
                  ],
                ),
              )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        key: UniqueKey(),
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
        heroTag: UniqueKey(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class DefaultPlayer extends StatefulWidget {
  const DefaultPlayer({Key? key, required this.videoLink}) : super(key: key);
  final String videoLink;

  @override
  _DefaultPlayerState createState() => _DefaultPlayerState();
}

class _DefaultPlayerState extends State<DefaultPlayer> {
  late FlickManager flickManager;
  late ImageProvider  imageManager;
  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      autoPlay: false,
      videoPlayerController: VideoPlayerController.network(
        widget.videoLink,
        // closedCaptionFile: _loadCaptions(),
      ),
    );
  }

  // If you have subtitle assets
  // Future<ClosedCaptionFile> _loadCaptions() async {
  //   final String fileContents = await DefaultAssetBundle.of(context)
  //       .loadString('images/bumble_bee_captions.srt');
  //   flickManager.flickControlManager!.toggleSubtitle();
  //   return SubRipCaptionFile(fileContents);
  // }

  //If you have subtitle urls
  // Future<ClosedCaptionFile> _loadCaptions() async {
  //   final url = Uri.parse('SUBTITLE URL LINK');
  //   try {
  //     final data = await http.get(url);
  //     final srtContent = data.body.toString();
  //     print(srtContent);
  //     return SubRipCaptionFile(srtContent);
  //   } catch (e) {
  //     print('Failed to get subtitles for ${e}');
  //     return SubRipCaptionFile('');
  //   }
  //}

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0 && this.mounted) {
          flickManager.flickControlManager?.autoPause();
        } else if (visibility.visibleFraction == 1) {
          flickManager.flickControlManager?.autoResume();
        }
      },
      child: FlickVideoPlayer(
        flickManager: flickManager,
        flickVideoWithControls: const FlickVideoWithControls(
          closedCaptionTextStyle: TextStyle(fontSize: 8),
          controls: FlickPortraitControls(),
        ),
        flickVideoWithControlsFullscreen: const FlickVideoWithControls(
          controls: FlickLandscapeControls(),
        ),
      ),
    );
  }
}


/*
class StyledAudioPlayer extends StatefulWidget {
  const StyledAudioPlayer({Key? key, required this.audioUrl, required this.references}) : super(key: key);
  final String audioUrl;
  final List<Reference> references;

  //const kUrl1 = 'https://luan.xyz/files/audio/ambient_c_motion.mp3';
  // const kUrl2 = 'https://luan.xyz/files/audio/nasa_on_a_mission.mp3';


  @override
  _StyledAudioPlayerState createState() => _StyledAudioPlayerState();
}

class _StyledAudioPlayerState extends State<StyledAudioPlayer> {
  bool? isPlaying;
  AudioPlayer audioPlayer = AudioPlayer();
  // AudioHandler audioPlayer = AudioHandler();



  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    isPlaying = false;
    selectedIndex = -1;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1, //widget.references.length,
      reverse: true,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text("Testing audio"), // Text(widget.references.elementAt(index).name),
          trailing: IconButton(
            icon: isPlaying == true
                ? Icon(Icons.pause)
                : Icon(Icons.play_arrow),
            onPressed: () => _onListTileButtonPressed(index),
          ),
        );
      },
    );

    // return ListView.builder(
    //   itemCount: widget.references.length,
    //   reverse: true,
    //   itemBuilder: (BuildContext context, int index) {
    //     return ListTile(
    //       title: Text(widget.references.elementAt(index).name),
    //       trailing: IconButton(
    //         icon: selectedIndex == index
    //             ? Icon(Icons.pause)
    //             : Icon(Icons.play_arrow),
    //         onPressed: () => _onListTileButtonPressed(index),
    //       ),
    //     );
    //   },
    // );
  }

  Future<void> _onListTileButtonPressed(int index) async {
    Duration? duration = await audioPlayer.setUrl('https://luan.xyz/files/audio/ambient_c_motion.mp3', preload: false);
    if(audioPlayer.playerState.playing){
      await audioPlayer.pause();
    } else {
      await audioPlayer.play();
    }


    // audioPlayer.play(await widget.audioUrl,
    //     isLocal: false);
    //
    // setState(() {
    //   selectedIndex = index;
    //   isPlaying = false;
    // });
    // audioPlayer.onPlayerCompletion.listen((duration) {
    //   setState(() {
    //     selectedIndex = -1;
    //   });
    // });
  }
}
*/