import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quick_chat/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../components/text_field_container.dart';

class SearchFriends extends StatefulWidget {
  const SearchFriends({super.key});

  @override
  State<SearchFriends> createState() => _SearchFriendsState();
}

class _SearchFriendsState extends State<SearchFriends> {
  String name = '';
  bool random = false;

  final auth = FirebaseAuth.instance;
  final friends = [];

  final collectionStream = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('friends')
      .snapshots();

  final documentStream = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();

  Future<void> addFriend(String id, String name, String myName) {
    friends.add(name);
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('friends')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'friendName': myName,
    });
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('friends')
        .doc(id)
        .set({
      'friendName': name,
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('friends')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        friends.add(doc['friendName']);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: documentStream,
      builder:
          ((BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> myUser =
              snapshot.data!.data() as Map<String, dynamic>;

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
                child: StreamBuilder<QuerySnapshot>(
                  stream: (name != '')
                      ? FirebaseFirestore.instance
                          .collection('users')
                          .where('username',
                              isEqualTo: name, isNotEqualTo: myUser['username'])
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection("users")
                          .where('username', isNotEqualTo: myUser['username'])
                          .snapshots(),
                  builder: (context, snapshot2) {
                    return (snapshot2.connectionState ==
                                ConnectionState.waiting ||
                            snapshot.connectionState == ConnectionState.waiting)
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : snapshot2.data!.docs.isEmpty? Center(child: Image.asset('assets/images/noResult.jpeg'),) :ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            // shrinkWrap: true,
                            itemCount: snapshot2.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot data =
                                  snapshot2.data!.docs[index];

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
                                    style: MyTheme.fieldTitle
                                        .copyWith(fontSize: 16),
                                  ),
                                  subtitle: Text(
                                      data['major'] + ' at ' + data['college']),
                                  trailing: IconButton(
                                    onPressed: () {
                                      addFriend(data.id, data['username'],
                                          myUser['username']);
                                      setState(() {});
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
            ],
          );
        }

        return Center(child: const CircularProgressIndicator());
      }),
    );
  }
}
