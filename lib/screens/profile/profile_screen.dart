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
  final auth = FirebaseAuth.instance;
  bool isUpdate = false;
  final aboutController = TextEditingController();
  final collegeController = TextEditingController();
  final majorController = TextEditingController();
  final locationController = TextEditingController();

  String about = '';
  String college = '';
  String major = '';
  String location = '';


  Future<void> updateUser(String nabout,String ncollege,String nmajor,String nlocation) {
    
  CollectionReference users = FirebaseFirestore.instance.collection('users');
    return users
        .doc(auth.currentUser!.uid)
        .update({
          'about':nabout,
          'college':ncollege,
          'major':nmajor,
          'location':nlocation,
        })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  void _sendMessage(String a, String c, String m, String l) async {
    FocusScope.of(context).unfocus();
    if(aboutController.text.isNotEmpty) {
      about=aboutController.text;
    }else{
      about=a;
    }
    if(collegeController.text.isNotEmpty) {
      college=collegeController.text;
    }
    else{
      college=c;
    }
    if(majorController.text.isNotEmpty) {
      major=majorController.text;
    }
    else{
      major=m;
    }
    if(locationController.text.isNotEmpty) {
      location=locationController.text;
    }
    else{
      location=l;
    }
    await updateUser(about, college, major, location);
    
    // aboutController.clear();
    // collegeController.clear();
    // majorController.clear();
    // locationController.clear();
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   aboutController.dispose();
  //   collegeController.dispose();
  //   majorController.dispose();
  //   locationController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 200,
                      color: MyTheme.kkPrimaryColor,
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
                      top: 50,
                      left: MediaQuery.of(context).size.width / 2 - 85,
                      child: Text(
                        'QuickChat',
                        style: MyTheme.heading2.copyWith(
                          fontSize: 34,
                          color: Colors.white,
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
                  height: 70,
                ),
                Text(
                  myUser['username'],
                  style: MyTheme.chatSenderName
                      .copyWith(color: MyTheme.kkPrimaryColor, fontSize: 22),
                ),
                Container(
                  height: 350,
                  margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
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
                        if (!isUpdate)
                          Padding(
                            padding: const EdgeInsets.only(top: 7, bottom: 7),
                            child: Text(
                              myUser['about'],
                              style: MyTheme.bodyText1,
                            ),
                          ),
                        if (isUpdate)
                          TextField(
                            style: MyTheme.bodyText1,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: myUser['about'],
                              hintStyle: MyTheme.bodyText1,
                            ),
                            onSubmitted: (value) {
                              setState(() {
                                about = value;
                              });
                            },
                            controller: aboutController,
                          ),
                        Text(
                          'College',
                          style: MyTheme.fieldTitle,
                        ),
                        if (!isUpdate)
                          Padding(
                            padding: const EdgeInsets.only(top: 7.0, bottom: 7),
                            child: Row(
                              children: [
                                Flexible(
                                    child: Text(
                                  myUser['college'],
                                  style: MyTheme.bodyText1,
                                )),
                              ],
                            ),
                          ),
                        if (isUpdate)
                          TextField(
                            style: MyTheme.bodyText1,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: myUser['college'],
                              hintStyle: MyTheme.bodyText1,
                            ),
                            onSubmitted: (value) {
                              setState(() {
                                college=value;
                              });
                            },
                            controller: collegeController,
                          ),
                        Text(
                          'Major',
                          style: MyTheme.fieldTitle,
                        ),
                        if (!isUpdate)
                          Padding(
                            padding: const EdgeInsets.only(top: 7.0, bottom: 7),
                            child: Text(
                              myUser['major'],
                              style: MyTheme.bodyText1,
                            ),
                          ),
                        if (isUpdate)
                          TextField(
                            style: MyTheme.bodyText1,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: myUser['major'],
                              hintStyle: MyTheme.bodyText1,
                            ),
                            onSubmitted: (value) {
                              setState(() {
                                
                              major = value;
                              });
                            },
                            controller: majorController,
                          ),
                        Text(
                          'Location',
                          style: MyTheme.fieldTitle,
                        ),
                        if (!isUpdate)
                          Padding(
                            padding: const EdgeInsets.only(top: 7.0, bottom: 7),
                            child: Text(
                              myUser['location'],
                              style: MyTheme.bodyText1,
                            ),
                          ),
                        if (isUpdate)
                          TextField(
                            style: MyTheme.bodyText1,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: myUser['location'],
                              hintStyle: MyTheme.bodyText1,
                            ),
                            onSubmitted: (value) {
                              setState(() {
                                location=value;
                              });
                            },
                            controller: locationController,
                          ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (!isUpdate)
                      GestureDetector(
                        onTap: () async {
                          await FirebaseAuth.instance.signOut().then(
                                (value) => Navigator.of(context)
                                    .popAndPushNamed(LoginScreen.routeName),
                              );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.red,
                          ),
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Center(
                            child: Text(
                              'LogOut',
                              style: MyTheme.fieldTitle.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    GestureDetector(
                      onTap: () {
                        if(isUpdate) {
                          _sendMessage(myUser['about'], myUser['college'], myUser['major'], myUser['location'],);
                        }
                        setState(() {
                          isUpdate = !isUpdate;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.green,
                        ),
                        height: 40,
                        width: isUpdate
                            ? MediaQuery.of(context).size.width * 0.35
                            : MediaQuery.of(context).size.width * 0.31,
                        child: Center(
                          child: Text(
                            isUpdate ? 'Save  Profile' : 'Edit Profile',
                            style: MyTheme.fieldTitle
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
