import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quick_chat/app_theme.dart';
import 'package:quick_chat/screens/login/login-screen.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // final name = FirebaseFirestore.instance.collection('users').doc('uid').get();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: false,
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      //   // title: const Text(
      //   //   'Profile',
      //   //   // style: MyTheme.heading2,
      //   // ),
      // ),
      // backgroundColor: MyTheme.kkPrimaryColor,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final chatDocs = chatSnapshot.data!.docs;
          final myUser = chatDocs
              .firstWhere((element) => element.id == auth.currentUser!.uid);

          // print(myUser['username']);
          return Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 200,
                    color: MyTheme.kkAccentColor,
                  ),
                  Positioned(
                    top: 135,
                    left: MediaQuery.of(context).size.width / 2 - 70,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      radius: 70,
                      child: const Icon(
                        Icons.account_circle,
                        size: 140,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 15,
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back_sharp,
                          size: 30,
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 80,
              ),
              Text(
                myUser['username'],
                style: MyTheme.chatSenderName
                    .copyWith(color: MyTheme.kkPrimaryColor),
              ),
              Container(
                height: 250,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color.fromARGB(109, 217, 217, 217),
                ),
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About',
                        style: MyTheme.fieldTitle,
                      ),
                      Text(myUser['about']),
                      Text(
                        'College',
                        style: MyTheme.fieldTitle,
                      ),
                      Row(
                        children: [
                          Flexible(child: Text(myUser['college'])),
                        ],
                      ),
                      Text(
                        'Major',
                        style: MyTheme.fieldTitle,
                      ),
                      Text(myUser['major']),
                      Text(
                        'Location',
                        style: MyTheme.fieldTitle,
                      ),
                      Text(myUser['location']),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await FirebaseAuth.instance.signOut().then(
                        (value) => Navigator.of(context)
                            .popAndPushNamed(LoginScreen.routeName),
                      );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: MyTheme.kkAccentColor,
                  ),
                  height: 50,
                  // color: Colors.amber,
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: Center(
                    child: Text(
                      'LogOut',
                      style: MyTheme.fieldTitle,
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
