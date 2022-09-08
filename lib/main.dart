import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_chat/app_theme.dart';
import 'package:quick_chat/screens/home/home_screen.dart';

import 'constants.dart';
import 'screens/drop/drop_screen.dart';
import 'screens/login/login-screen.dart';
import 'screens/signup/signup_screen.dart';
import 'screens/welcome/welcome_screen.dart';

Future<void> main() async {
  // FirebaseFirestore.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuickChat',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
        // accentColor: MyTheme.kAccentColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapShot) {
          if (userSnapShot.hasData) {
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        SignUpScreen.routeName: (context) => const SignUpScreen(),
        HomeScreen.routeName:(context) => const HomeScreen(),
        DropScreen.routeName: (context) => const DropScreen(),
      },
    );
  }
}
