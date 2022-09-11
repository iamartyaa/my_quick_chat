import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/app_theme.dart';
import '/screens/chat/components/new_message.dart';
import '/screens/home/home_screen.dart';

class ChatRoom extends StatefulWidget {
  final String friendID;
  final String friendName;

  const ChatRoom({required this.friendID, required this.friendName});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final friendID = widget.friendID;
    final friendName = widget.friendName;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            },
            icon: const Icon(
              Icons.arrow_back_sharp,
              size: 30,
            )),
        backgroundColor: MyTheme.kkPrimaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: MyTheme.kkPrimaryColor,
              child: const Icon(
                Icons.account_circle_rounded,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friendName,
                  style: MyTheme.chatSenderName.copyWith(fontSize: 16),
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
                child: StreamBuilder(
                  stream: FirebaseAuth.instance.userChanges(),
                  builder: (context, AsyncSnapshot<User?> futureSnapshot) {
                    if (futureSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(futureSnapshot.data!.uid)
                          .collection('friends')
                          .doc(friendID)
                          .collection('chat')
                          .orderBy('createdAt', descending: true)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
                        if (chatSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final chatDocs = chatSnapshot.data!.docs;
                        // final user = ;
                        // return Text('Helloi');
                        // chatDocs[index]['usernme,text,usedId==futur']
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          reverse: true,
                          itemCount: chatDocs.length,
                          itemBuilder: (context, index) {
                            // var message = messages[index];
                            bool isMe = chatDocs[index]['userId'] ==
                                futureSnapshot.data!.uid;
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
                                      // backgroundImage: AssetImage(widget.user.avatar),
                                      backgroundColor: MyTheme.kkAccentColor,
                                    ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.all(10),
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isMe
                                          ? MyTheme.kkAccentColor
                                          : Colors.grey[200],
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(16),
                                        topRight: const Radius.circular(16),
                                        bottomLeft:
                                            Radius.circular(!isMe ? 0 : 16),
                                        bottomRight:
                                            Radius.circular(isMe ? 0 : 16),
                                      ),
                                    ),
                                    child: Text(
                                      chatDocs[index]['text'],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
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
                    child: NewMessage(friendId: friendID),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}