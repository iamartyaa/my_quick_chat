
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quick_chat/main.dart';
import '../../../components/already_account_check.dart';
import '../../../components/rounded_button.dart';
import '../../../components/text_field_container.dart';
import '../../../constants.dart';
import '../../login/login-screen.dart';
import 'background.dart';

class Body extends StatefulWidget {
  const Body({
    super.key,
  });

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;
  var userEmail = '';
  var userName = '';
  var userPassword = '';

  void submitAuthForm(
    String email,
    String password,
    String username,
  ) async {
    UserCredential authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      print(_auth.toString());
      authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user!.uid)
          .set({
        'username': username,
        'email': email,
        'location': 'Not Available',
        'about': 'Can\'t talk, QuickChat only!',
        'college': 'Harcourt Butler Technical University, Kanpur',
        'major': 'Information Technology',
        
      });
      setState(() {
        _isLoading = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MyApp(),
        ),
      );
    } on PlatformException catch (err) {
      var message = 'An error occured, please check your credentials';
      print(message);
      if (err.message != null) {
        message = err.message!;
      }
      print(message);

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    // FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      print(userPassword);
    }

    submitAuthForm(
      userEmail.toString().trim(),
      userPassword.toString().trim(),
      userName.toString().trim(),
    );
    
    //once validated we can send to firebase
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/signup.svg',
                width: size.height * 0.3,
              ),
              TextFieldContainer(
                child: TextFormField(
                  key: const ValueKey('email'),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.person,
                      color: kPrimaryColor,
                    ),
                    hintText: 'Your Email',
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    userEmail = value!;
                  },
                ),
              ),
              TextFieldContainer(
                child: TextFormField(
                  key: const ValueKey('name'),
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.person,
                      color: kPrimaryColor,
                    ),
                    hintText: 'Username',
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 4) {
                      return 'Please enter at least 4 characters';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    userName = value!;
                  },
                ),
              ),
              TextFieldContainer(
                child: TextFormField(
                  key: const ValueKey('password'),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.lock,
                      color: kPrimaryColor,
                    ),
                    hintText: 'Password',
                    border: InputBorder.none,
                    suffixIcon: Icon(
                      Icons.visibility,
                      color: kPrimaryColor,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 7) {
                      return 'Password must be atleast 7 characters long';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    userPassword = value!;
                  },
                ),
              ),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              if (!_isLoading)
                RoundedButton(text: 'SIGN UP', press: _trySubmit),
              SizedBox(
                height: size.height * 0.015,
              ),
              AlreadyAccountCheck(
                login: false,
                press: () {
                  Navigator.of(context)
                      .popAndPushNamed(LoginScreen.routeName);
                },
              ),
              const OrDivider(),
              SizedBox(
                height: size.height * 0.02,
              ),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(29),
                splashColor: kPrimaryLightColor,
                focusColor: kPrimaryLightColor,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 2, color: kPrimaryLightColor),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/google-plus.svg',
                    width: size.width * 0.06,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      width: size.width * 0.6,
      child: Row(
        children: const [
          Expanded(
            child: Divider(
              color: Color(0xFFD9D9D9),
              height: 1.5,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'OR',
              style:
                  TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Divider(
              color: Color(0xFFD9D9D9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
