import 'package:fan_cate/loading_effect.dart';
import 'package:fan_cate/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fan_cate/flutx/flutx.dart';

import 'package:fan_cate/controllers/chat_controller.dart';
import 'package:fan_cate/data/chat.dart';
import 'package:fan_cate/screens/single_chat_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ThemeData theme;
  late CustomTheme customTheme;

  late ChatController chatController;

  @override
  void initState() {
    super.initState();
    chatController = FxControllerStore.putOrFind(ChatController());
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
  }

  List<Widget> _buildChatList() {
    List<Widget> list = [];

    list.add(FxSpacing.width(16));

    for (Chat chat in chatController.chats!) {
      list.add(_buildSingleChat(chat));
    }
    return list;
  }

  Widget _buildSingleChat(Chat chat) {
    return FxContainer(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (context) => SingleChatScreen(chat)));
      },
      margin: FxSpacing.bottom(16),
      paddingAll: 16,
      borderRadiusAll: 16,
      child: Row(
        children: [
          Stack(
            children: [
              FxContainer.rounded(
                paddingAll: 0,
                child: Image(
                  height: 54,
                  width: 54,
                  image: AssetImage(chat.image),
                ),
              ),
              // Green rounded icon to hint that the user is online
              Positioned(
                right: 4,
                bottom: 2,
                child: FxContainer.rounded(
                  paddingAll: 5,
                  child: Container(),
                  color: customTheme.groceryPrimary, //green
                ),
              )
            ],
          ),
          FxSpacing.width(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxText.b2(
                  chat.name,
                  fontWeight: 600,
                ),
                FxSpacing.height(4),
                FxText.b3(
                  chat.chat,
                  xMuted: chat.replied,
                  muted: !chat.replied,
                  fontWeight: chat.replied ? 400 : 600,
                ),
              ],
            ),
          ),
          FxSpacing.width(8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FxText.b3(
                chat.time,
                fontSize: 10,
                color: theme.colorScheme.onBackground,
                xMuted: true,
              ),
              chat.replied
                  ? FxSpacing.height(16)
                  : FxContainer.rounded(
                      paddingAll: 6,
                      color: customTheme.estatePrimary,
                      child: FxText.b3(
                        chat.messages,
                        fontSize: 10,
                        color: customTheme.estateOnPrimary,
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<ChatController>(
        controller: chatController,
        builder: (estateHomeController) {
          return SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  Container(
                    height: 2,
                    child: estateHomeController.showLoading
                        ? LinearProgressIndicator(
                            color: customTheme.estatePrimary,
                            minHeight: 2,
                          )
                        : Container(
                            height: 2,
                          ),
                  ),
                  Expanded(
                    child: _buildBody(),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildBody() {
    if (chatController.uiLoading) {
      return Container(
          margin: FxSpacing.top(16),
          child: LoadingEffect.getSearchLoadingScreen(
            context,

          ));
    } else {
      return ListView(
        padding: FxSpacing.horizontal(
          24,
        ),
        children: [
          FxSpacing.height(16),
          Center(
            child: FxText.b1(
              'Chats',
              fontWeight: 700,
            ),
          ),
          FxSpacing.height(16),
          FxTextField(
            textFieldStyle: FxTextFieldStyle.outlined,
            labelText: 'Search your agent',
            focusedBorderColor: customTheme.estatePrimary,
            cursorColor: customTheme.estatePrimary,
            labelStyle: FxTextStyle.b3(
                color: theme.colorScheme.onBackground, xMuted: true),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: customTheme.estatePrimary.withAlpha(40),
            suffixIcon: Icon(
              FeatherIcons.search,
              color: customTheme.estatePrimary,
              size: 20,
            ),
          ),
          FxSpacing.height(20),
          Column(
            children: _buildChatList(),
          ),
        ],
      );
    }
  }
}
