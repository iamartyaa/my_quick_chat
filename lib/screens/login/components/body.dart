import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quick_chat/main.dart';
import '../../../components/already_account_check.dart';
import '../../../components/rounded_button.dart';
import '../../../components/text_field_container.dart';
import '../../../constants.dart';
import '../../signup/signup_screen.dart';
import 'background.dart';

class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;
  var userEmail = '';
  var userPassword = '';
  bool isObs = true;
  void submitAuthForm(
    String email,
    String password,
  ) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });

      authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print('success');
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

      if (err.message != null) {
        message = err.message!;
      }

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
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
    }

    submitAuthForm(
      userEmail.toString().trim(),
      userPassword.toString().trim(),
    );
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
                'assets/icons/login.svg',
                height: size.height * 0.3,
              ),
              
              SizedBox(
                height: size.height * 0.03,
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
                  key: const ValueKey('password'),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: isObs,
                  decoration: InputDecoration(
                    icon: const Icon(
                      Icons.lock,
                      color: kPrimaryColor,
                    ),
                    hintText: 'Password',
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isObs != isObs;
                        });
                      },
                      icon: const Icon(Icons.visibility),
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
              if (!_isLoading) RoundedButton(text: 'LOGIN', press: _trySubmit),
              SizedBox(
                height: size.height * 0.015,
              ),
              AlreadyAccountCheck(
                login: true,
                press: () {
                  Navigator.of(context).popAndPushNamed(SignUpScreen.routeName);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
