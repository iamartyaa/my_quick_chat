import 'package:flutter/material.dart';
import 'package:quick_chat/app_theme.dart';
import 'package:quick_chat/models/message_model.dart';
import 'package:quick_chat/screens/home/components/search.dart';
import 'package:quick_chat/screens/profile/profile_screen.dart';
import 'components/chats.dart';
import 'components/my_tab_bar.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int currentTabIndex = 0;

  void onTabChange() {
    setState(() {
      currentTabIndex = tabController.index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      onTabChange();
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.addListener(() {
      onTabChange();
    });
    tabController.dispose();
    super.dispose();
  }

  late TabController tabController;

  @override
  Widget build(BuildContext context) {
    var kkPrimaryColor = const Color(0xff7C7B9B);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: kkPrimaryColor,
        // leading: IconButton(
        //   onPressed: () {},
        //   icon: const Icon(Icons.menu),
        // ),
        title: Text(
          'QuickChat',
          style: MyTheme.kAppTitle,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(ProfileScreen.routeName);
            },
            icon: const Icon(
              Icons.settings,
              size: 28,
            ),
          ),
          // IconButton(onPressed: (){}, icon: Icon(Icons.),),
        ],
      ),
      backgroundColor: kkPrimaryColor,
      body: Column(
        children: [
          MyTabBar(tabController: tabController),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: TabBarView(
                controller: tabController,
                children: [
                  Chats(kkPrimaryColor: kkPrimaryColor),
                  const Center(child: Text('Feature Coming Soon')),
                  SearchFriends(),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyTheme.kkAccentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        onPressed: () {},
        child: Icon(
          currentTabIndex == 0
              ? Icons.message_outlined
              : currentTabIndex == 1
                  ? Icons.camera_alt_rounded
                  : Icons.search_sharp,
          color: Colors.white,
        ),
      ),
    );
  }
}
