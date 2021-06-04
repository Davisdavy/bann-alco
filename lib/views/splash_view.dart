import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jiteke/constants/colors.dart';
import 'package:jiteke/views/auth/login_view.dart';
import 'package:page_transition/page_transition.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  /*
  Firebase init
   */
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        //error in the snapshot
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: bgColor,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/images/splash_logo.png"),
                ],
              ),
            ),
          );
        }
        //Connection initialized Firebase app is running
        if (snapshot.connectionState == ConnectionState.done) {
          //Streambuilder can check the login state (live)
          return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, streamSnapshot) {
                //if stream snapshot has error
                if (streamSnapshot.hasError) {
                  Scaffold(
                    backgroundColor: bgColor,
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/splash_logo.png"),
                        ],
                      ),
                    ),
                  );
                }
                //Connection state active - Do the user login check
                if (streamSnapshot.connectionState == ConnectionState.active) {
                  //Get the user
                  //User _user = streamSnapshot.data;

                  //If the user is null, we're not logged in
                  if (FirebaseAuth.instance
                      .currentUser  == null) {
                    /*
  Use timer for meta navigation
   */
                    Timer(
                        Duration(seconds: 2),
                            () => Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: LoginView(),
                                type: PageTransitionType.fade)));
                    return Scaffold(
                      backgroundColor: bgColor,
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/splash_logo.png"),
                          ],
                        ),
                      ),
                    );
                  } else {
                    //Then the user id logged in, we head to home page
                    /*
  Use timer for meta navigation
   */
                    FirebaseFirestore.instance
                        .collection("landlord")
                        .doc(FirebaseAuth.instance
                        .currentUser.uid)
                        .get()
                        .then((DocumentSnapshot result) {
                      // Timer(
                      //     Duration(seconds: 2),
                      //         () => Navigator.pushReplacement(
                      //         context,
                      //         PageTransition(
                      //             child: NavScreen(
                      //               title: result['name'],
                      //               uid: FirebaseAuth.instance
                      //                   .currentUser.uid,),
                      //             type: PageTransitionType.fade))
                      // );

                    });

                    Scaffold(
                      backgroundColor: bgColor,
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/splash_logo.png"),
                          ],
                        ),
                      ),
                    );
                  }
                }
                return Scaffold(
                  backgroundColor: bgColor,
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/splash_logo.png"),
                      ],
                    ),
                  ),
                );
              });
        }
        return Scaffold(
          backgroundColor: bgColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/images/splash_logo.png"),
              ],
            ),
          ),
        );
      },
    );
  }
}