import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quick_chat/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_chat/constants.dart';

import '../../../components/text_field_container.dart';

class SearchFriends extends StatefulWidget {
  const SearchFriends({super.key});

  @override
  State<SearchFriends> createState() => _SearchFriendsState();
}

class _SearchFriendsState extends State<SearchFriends> {
  String name = '';
  String myName = '';
  bool random = false;

  final auth = FirebaseAuth.instance;

  final friends = [];

  @override
  void initState() {
    // TODO: implement initState
    FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          myName = documentSnapshot['username'];
          // print(myName);
        });
      }
    });

    FirebaseFirestore.instance
        .collection(auth.currentUser!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        friends.add(doc['username']);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> addUser(String id, String fname) {
      CollectionReference users =
          FirebaseFirestore.instance.collection('${auth.currentUser!.uid}');
      return users
          .add({
            'friend_id': id,
            'name': fname,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
            top: 10,
          ),
          child: Row(
            children: [
              Text(
                'Find Friends',
                style: MyTheme.heading2,
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  color: MyTheme.kkPrimaryColor,
                ),
              ),
            ],
          ),
        ),
        TextFieldContainer(
          child: TextFormField(
            key: const ValueKey('search'),
            keyboardType: TextInputType.visiblePassword,
            decoration: const InputDecoration(
              hintText: 'Type Name/ College Name',
              border: InputBorder.none,
            ),
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          ),
        ),
        Expanded(
          child: Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: (name != '')
                  ? FirebaseFirestore.instance
                      .collection('users')
                      .where('username', isEqualTo: name, isNotEqualTo: myName)
                      .snapshots()
                  : FirebaseFirestore.instance.collection("users").snapshots(),
              builder: (context, snapshot) {
                return (snapshot.connectionState == ConnectionState.waiting)
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        // shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot data = snapshot.data!.docs[index];
                          return Card(
                            elevation: 0,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: MyTheme.kkAccentColor,
                                child: const Icon(
                                  Icons.account_circle_sharp,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                data['username'],
                                style:
                                    MyTheme.fieldTitle.copyWith(fontSize: 16),
                              ),
                              subtitle: Text(
                                  data['major'] + ' at ' + data['college']),
                              trailing: IconButton(
                                onPressed: () {
                                  !friends.contains(data['username'])
                                      ? addUser(data.id, data['username'])
                                      : null;
                                  if (!friends.contains(data['username'])) {
                                    setState(() {
                                      friends.add(data['username']);
                                    });
                                  }
                                },
                                icon: !friends.contains(data['username'])
                                    ? const Icon(Icons.person_add)
                                    : const Icon(Icons.done_sharp),
                              ),
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        ),
      ],
    );
  }
}
