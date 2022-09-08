import 'package:flutter/material.dart';
import 'package:quick_chat/screens/chat/chat_room.dart';

import '../../../app_theme.dart';
import '../../../models/message_model.dart';

class Chats extends StatelessWidget {
  const Chats({
    Key? key,
    required this.kkPrimaryColor,
  }) : super(key: key);

  final Color kkPrimaryColor;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: Row(
              children: [
                Text(
                  'Recent Chats',
                  style: MyTheme.heading2,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.search,
                    color: kkPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: recentChats.length,
            itemBuilder: (context, index) {
              final recentChat = recentChats[index];
              return Container(
                margin: const EdgeInsets.only(top: 15),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage(recentChat.avatar),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigator.of(context).pushNamed(ChatRoom.routeName,arguments: recentChat.sender);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ChatRoom(user: recentChat.sender);
                            },
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            recentChat.sender.name,
                            style: MyTheme.heading2.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            recentChat.text,
                            style: MyTheme.bodyText1,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 8,
                          backgroundColor: MyTheme.kUnreadChatBG,
                          child: Text(
                            recentChat.unreadCount.toString(),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          recentChat.time,
                          style: MyTheme.bodyTextTime,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
