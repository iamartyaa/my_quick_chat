import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quick_chat/screens/chat/chat_room.dart';
import 'package:intl/intl.dart';

import '../../../app_theme.dart';

class Chats extends StatefulWidget {
  Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final Color kkPrimaryColor = MyTheme.kkPrimaryColor;
  bool isLoading = true;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

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
              if (chatSnapshot.connectionState == ConnectionState.waiting ||
                  isLoading) {
                return SizedBox.shrink();
              }

              final chatDocs = chatSnapshot.data!.docs;

              if (chatDocs.isEmpty) {
                return Center(
                  child: Image.asset(
                    'assets/images/empty.jpeg',
                  ),
                );
              }

              return ListView.builder(
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
                              .collection('chat')
                              .orderBy('createdAt', descending: true)
                              .get(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot> chatSnapshot1) {
                            if (chatSnapshot1.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return const ChatsSkeleton();
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(
                                      height: 10,
                                    );
                                  },
                                  itemCount: 10,
                                ),
                              );
                            }

                            final chatDocs2 = chatSnapshot1.data!.docs;

                            if (chatDocs2.isEmpty) {
                              return SizedBox.shrink();
                            }
                            // if (chatDocs2.isEmpty) {
                            //   return Center(
                            //     child: Image.asset(
                            //       'assets/images/empty.jpeg',
                            //     ),
                            //   );
                            // }
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
                                        fontSize: 19,
                                      ),
                                    ),
                                    Text(
                                      chatDocs2[0]['text'] ?? '',
                                      style: chatDocs2[0]['userId'] ==
                                              auth.currentUser!.uid
                                          ? MyTheme.bodyText1
                                          : MyTheme.bodyText1.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      DateFormat('hh:mm a').format((chatDocs2[0]
                                              ['createdAt'] as Timestamp)
                                          .toDate()),
                                      style: chatDocs2[0]['userId'] ==
                                              auth.currentUser!.uid
                                          ? MyTheme.bodyText1
                                          : MyTheme.bodyText1.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                    ),
                                  ],
                                ),
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

class ChatsSkeleton extends StatelessWidget {
  const ChatsSkeleton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.black.withOpacity(0.04),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Skeleton(
              height: 25,
              width: 200,
            ),
            SizedBox(
              height: 10,
            ),
            Skeleton(
              height: 20,
              width: 250,
            ),
          ],
        )
      ],
    );
  }
}

class Skeleton extends StatelessWidget {
  const Skeleton({
    this.height,
    this.width,
  });

  final double? height;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
