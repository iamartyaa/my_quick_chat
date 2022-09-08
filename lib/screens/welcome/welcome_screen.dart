import 'package:flutter/material.dart';
import 'package:quick_chat/screens/welcome/components/body.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Body(),
    );
  }
}