import 'package:fan_cate/flutx/flutx.dart';
import 'package:fan_cate/data/post.dart';

class PostController extends FxController {
  bool showLoading = true, uiLoading = true;
  List<Post>? posts;

  @override
  initState() {
    super.save = false;
    super.initState();
    fetchData();
  }

  void fetchData() async {
    await Future.delayed(Duration(seconds: 1));

    posts = Post.postsList();

    showLoading = false;
    uiLoading = false;
    update();
  }

  @override
  String getTag() {
    return "post_controller";
  }
}
