import 'package:firbasenoteapp/pages/home_page.dart';
import 'package:firbasenoteapp/services/auth_service.dart';
import 'package:firbasenoteapp/services/hive_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'sign_up_page.dart';

class SignInPage extends StatefulWidget {
  static const String id = "sign_in_page";

  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool loading = false;

  void _doSignIn() async {
    String email = emailController.text.trim().toString();
    String password = passwordController.text.trim().toString();

    if (email.isEmpty || password.isEmpty) {
      // error msg
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please complete empty fields!')));
      return;
    }
    setState(() {
      loading = true;
    });
    await AuthService.signInUser(context, email, password)
        .then((value) => _getFirebaseUser(value));
  }

  void _getFirebaseUser(User? user) {
    if (user != null) {
      HiveDB.storeU(user.uid);
      Navigator.pushReplacementNamed(context, HomePage.id);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : SingleChildScrollView(
              child: Container(
                color: Colors.black26,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ////// EMAIL
                    TextField(
                      textInputAction: TextInputAction.next,
                      controller: emailController,
                      decoration: const InputDecoration(
                          hintText: "Email",
                          hintStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    // ////PASSWORD
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),

                    // //// BUTTON
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 6), // changes position of shadow
                          ),
                        ],
                      ),
                      child: MaterialButton(
                        height: 50,
                        color: Colors.black54,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        onPressed: _doSignIn,
                        child: const Text(
                          "Sign In",
                          style: TextStyle(color: Colors.white, fontSize: 19,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    // //////TEXT
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500,fontSize: 16),
                        ),
                        const SizedBox(width: 10,),
                        InkWell(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, SignUpPage.id);
                            },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w500,fontSize: 17),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
