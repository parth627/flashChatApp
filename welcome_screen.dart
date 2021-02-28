//import 'dart:html';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/rounded_button.dart';
//import 'package:firebase_core/firebase_core.dart';


class WelcomeScreen extends StatefulWidget {
  static const String id='welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  @override
  void initState() {
    super.initState();
    controller=AnimationController(duration: Duration(seconds: 1), vsync: this,);//upperBound:1.0 we can change upper bound and lower bound
    animation = ColorTween(begin: Colors.blueGrey, end:Colors.black).animate(controller);

    // animation = CurvedAnimation(parent: controller,curve:Curves.decelerate); // parent has to be animation controller
    // //controller.reverse(from:1.0);
    controller.forward();
    // animation.addStatusListener((status) {
    //   if(status == AnimationStatus.completed)
    //     controller.reverse(from:1.0);
    //   else if(status==AnimationStatus.dismissed)
    //     controller.forward();
    // });
    controller.addListener(() {
      setState(() {});
      //print(animation.value);
    });
  }
  @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ["Flash Chat"],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(title: 'Login',
                colour: Colors.lightBlueAccent,
                onPressed: () {
                Navigator.pushNamed(context,LoginScreen.id);
                //Go to registration screen.
             }
            ),
            RoundedButton(title: 'Register',
                colour: Colors.blueAccent,
                onPressed: () {
                  //Firebase.initializeApp();
                  Navigator.pushNamed(context, RegistrationScreen.id);
                  //Go to registration screen.
                }
            ),
          ],
        ),
      ),
    );
  }
}


