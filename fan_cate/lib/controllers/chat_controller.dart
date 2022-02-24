import 'package:fan_cate/flutx/flutx.dart';
import 'package:fan_cate/data/chat.dart';

class ChatController extends FxController {
  bool showLoading = true, uiLoading = true;
  List<Chat>? chats;

  @override
  initState() {
    super.save = false;
    super.initState();
    fetchData();
  }

  void fetchData() async {
    await Future.delayed(Duration(seconds: 1));

    chats = Chat.chatList();

    showLoading = false;
    uiLoading = false;
    update();
  }

  @override
  String getTag() {
    return "chat_controller";
  }
}
