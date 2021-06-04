import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jiteke/constants/colors.dart';
import 'package:jiteke/views/auth/register_view.dart';
import 'package:jiteke/views/auth/reset_view.dart';
import 'package:page_transition/page_transition.dart';

class LoginView extends StatefulWidget {

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Container(
              child: Text(error),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('Close'))
            ],
          );
        }
    );
  }

  // Create a new user account
  Future<String> _loginAccount() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _loginEmail, password: _loginPassword).then((currentsUser) => FirebaseFirestore.instance.collection("landlord")
          .doc(FirebaseAuth.instance
          .currentUser.uid)
          .get()
          .then((DocumentSnapshot result) {
        Navigator.pushReplacement(
            context,
            PageTransition(
                // child: NavScreen(
                //   title: result['name'],
                //   uid: FirebaseAuth.instance
                //       .currentUser.uid,
                // ),
                type: PageTransitionType.fade)
        );
      })
      );

      return null;
    } on FirebaseAuthException catch(e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  void _submitForm() async {
    // Set the form to loading state
    setState(() {
      _loginFormLoading = true;
    });

    // Run the create account method
    String _loginFeedback = await _loginAccount();

    // If the string is not null, we got error while create account.
    if(_loginFeedback != null) {
      _alertDialogBuilder(_loginFeedback);

      // Set the form to regular state [not loading].
      setState(() {
        _loginFormLoading = false;
      });
    }
  }

  // Default Form Loading State
  bool _loginFormLoading = false;

  // Form Input Field Values
  String _loginEmail = "";
  String _loginPassword = "";

  // Focus Node for input fields
  FocusNode _passwordFocusNode;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/bg.png"), fit: BoxFit.cover),
            ),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Image.asset("assets/images/logo.png"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Karibu", style: TextStyle(color: darkText, fontSize: 30.0,fontFamily: 'Nunito', fontWeight: FontWeight.w500),),
                        Text("Kejani", style: TextStyle(color: whiteColor, fontSize: 30.0,fontFamily: 'Nunito', fontWeight: FontWeight.w500),),
                      ],
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Text("Welcome",style: TextStyle(color: darkText, fontSize: 30.0,fontFamily: 'Nunito', fontWeight: FontWeight.w400),),
                    Text("Your new housing solution",style: TextStyle(color: Colors.grey.shade300, fontSize: 18.0,fontFamily: 'Nunito', ),),
                    Container(
                      child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 28),
                            child: Text("Email",style: TextStyle(color: darkText, fontSize: 13.0,fontFamily: 'Nunito', ),),
                          ),
                          // CustomInput(
                          //   hintText: 'abc@gmail.com',
                          //   onChanged: (value) {
                          //     _loginEmail = value;
                          //   },
                          //   onSubmitted: (value) {
                          //     _passwordFocusNode.requestFocus();
                          //   },
                          //   textInputAction: TextInputAction.next,
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(left: 28),
                            child: Text("Password",style: TextStyle(color: darkText, fontSize: 13.0,fontFamily: 'Nunito', ),),
                          ),
                          // CustomInput(
                          //   hintText: '****',
                          //   onChanged: (value) {
                          //     _loginPassword = value;
                          //   },
                          //   focusNode: _passwordFocusNode,
                          //   isPasswordField: true,
                          //   onSubmitted: (value) {
                          //     _submitForm();
                          //   },
                          // ),

                        ],
                      ),

                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // CustomBtn(
                    //   text: "LOGIN",
                    //   onPressed: () {
                    //     _submitForm();
                    //   },
                    //   isLoading: _loginFormLoading,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ResetView()));
                        }, child: Text('Forgot password?', style: TextStyle(color: Colors.grey.shade400, fontSize: 14.0,),)),
                        TextButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterView()));
                        }, child: Text('Register now!', style: TextStyle(color: darkText, fontSize: 14.0,),)),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Text("Kejani", style: TextStyle(color: darkText, fontSize: 12.0,)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}