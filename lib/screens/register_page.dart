import 'package:estoa1_app/screens/login_page.dart';
import 'package:estoa1_app/widgets/custom_btn.dart';
import 'package:estoa1_app/widgets/custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../constants.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  Future<void> _alertDialogueBuilder(String error) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context){
        return AlertDialog(
          title: Text("Error"),
          content: Container(
            child: Text(error),
          ),
          actions: [
            FlatButton(
              child: Text("Close Dialog"),
              onPressed: (){
                Navigator.pop(context);
              },
              )
          ],
        );
      }
    );
  }

  Future<String> _createAccount() async{
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _registerEmail, password: _registerPassword);
      return null;
    } on FirebaseException catch(e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return'The account already exists for that email.';
      }
      return e.message;
    } catch (e){
      return e.toString();
    }
  }

  void _submitForm() async{
    setState(() {
      _registerFormLoading = true;
    });

    String _createAccountFeedback = await _createAccount();
    if(_createAccountFeedback != null){
      _alertDialogueBuilder(_createAccountFeedback);

      setState(() {
        _registerFormLoading = false;
      });
    } else {
      Navigator.pop(context);
    }
  }

  bool _registerFormLoading = false;

  String _registerEmail = "";
  String _registerPassword = "";

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
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    top: 24.0,
                  ),
                  child: Text(
                    "Create A New Account",
                    textAlign: TextAlign.center,
                    style: Constants.boldHeading,
                  ),
                ),
                Column(
                  children: <Widget>[
                    CustomInput(
                      hintText: "Email...",
                      onChanged: (value){
                        _registerEmail = value;
                      },
                      onSubmitted: (value){
                        _passwordFocusNode.requestFocus();
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    CustomInput(
                      hintText: "Password...",
                      onChanged: (value){
                        _registerPassword = value;
                      },
                      focusNode: _passwordFocusNode,
                      isPasswordField: true,
                      onSubmitted: (value){
                        _submitForm();
                      },
                    ),
                    CustomBtn(
                      text: "Create New Account",
                      onPressed: (){
                        _submitForm();
                      },
                      isLoading: _registerFormLoading,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 16.0,
                  ),
                  child: CustomBtn(
                    text: "Back To Login",
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    outlineBtn: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );;
  }
}

