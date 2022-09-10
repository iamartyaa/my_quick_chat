import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quick_chat/screens/chat/chat_room.dart';
import 'package:intl/intl.dart';

import '../../../app_theme.dart';

class Chats extends StatelessWidget {
  final Color kkPrimaryColor = MyTheme.kkPrimaryColor;
  final auth = FirebaseAuth.instance;

  Chats({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(auth.currentUser!.uid)
                .collection('friends')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (chatSnapshot.connectionState == ConnectionState.done &&
                  !chatSnapshot.hasData) {
                return const Center(
                  child: Text('No Chats yet! Start using QuickChat'),
                );
              }
              final chatDocs = chatSnapshot.data!.docs;
              // return chatDocs.length ==0 ? Center(child: Text('No Chats yet! Start using QuickChat'),):
              return
               ListView.builder(
                physics: const BouncingScrollPhysics(),
                // shrinkWrap: true,
                itemCount: chatDocs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot data = chatDocs[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatRoom(
                              friendID: data.id,
                              friendName: data['friendName']),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      child: FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(auth.currentUser!.uid)
                              .collection('friends')
                              .doc(data.id)
                              .collection('chat').orderBy('createdAt', descending: true)
                              .get(),
                          // .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot> chatSnapshot1) {
                            if (chatSnapshot1.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            
                            final chatDocs = chatSnapshot1.data!.docs;

                            if(chatDocs.isEmpty) {
                              return const Center(child: Text('No Chats yet!'));
                            }
                            return Row(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: MyTheme.kkAccentColor,
                                  child: const Icon(
                                    Icons.account_circle_sharp,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      data['friendName'],
                                      style: MyTheme.heading2.copyWith(
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      chatDocs[0]['text'] ?? '',
                                      style: MyTheme.bodyText1,
                                    ),
                                  ],
                                ),
                                // Text(DateTime.fromMillisecondsSinceEpoch(chatDocs[0]['createdAt'] * 1000).toString()),
                              ],
                            );
                          }),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
