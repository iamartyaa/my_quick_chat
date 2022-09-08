import 'package:flutter/material.dart';
import 'package:quick_chat/app_theme.dart';
import 'package:quick_chat/models/message_model.dart';
import 'package:quick_chat/models/user_model.dart';

class ChatRoom extends StatefulWidget {
  // static const routeName = '/chat-room';
  const ChatRoom({
    super.key,
    required this.user,
  });
  // final User user = ModalRoute.of(context)!.settings.arguments as User;
  final User user;
  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        backgroundColor: MyTheme.kkPrimaryColor,
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage(widget.user.avatar),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.name,
                  style: MyTheme.chatSenderName,
                ),
                Text(
                  'online',
                  style: MyTheme.bodyText1.copyWith(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.videocam_outlined,
              size: 28,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.call,
              size: 26,
            ),
          ),
        ],
        elevation: 0,
      ),
      backgroundColor: MyTheme.kkPrimaryColor,
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(29),
                  topRight: Radius.circular(29),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(29),
                  topRight: Radius.circular(29),
                ),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    bool isMe = message.sender.id == widget.user.id;
                    return Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: isMe
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (!isMe)
                            CircleAvatar(
                              radius: 15,
                              backgroundImage: AssetImage(widget.user.avatar),
                            ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(10),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.5,
                            ),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? MyTheme.kkAccentColor
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: Radius.circular(!isMe ? 0 : 16),
                                bottomRight: Radius.circular(isMe ? 0 : 16),
                              ),
                            ),
                            child: Text(
                              message.text,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            color: Colors.white,
            height: 75,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    height: 60,
                    // margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey[200],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.emoji_emotions_outlined,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Type your message...',
                              hintStyle: TextStyle(
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.attach_file_rounded,
                          color: Colors.grey[500],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                CircleAvatar(
                  backgroundColor: MyTheme.kkAccentColor,
                  child: const Icon(
                    Icons.send_sharp,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
