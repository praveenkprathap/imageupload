import 'package:flutter/material.dart';
import 'package:imageupload/providers/login_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Google Login"),
        backgroundColor: Colors.green,
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(3),
              color: Colors.white,
              child: const Image(
                  height: 150, image: AssetImage('assets/images/logo.jpeg')),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 30, bottom: 20),
              child: Text(
                "Hello, \nsign in with Google for Uploading Images",
                style: TextStyle(fontSize: 27),
                textAlign: TextAlign.center,
              ),
            ),
            GestureDetector(
                onTap: () {
                  context.read<LoginProvider>().signInWithGoogle();
                  // AuthService().signInWithGoogle();
                },
                child: Container(
                  margin: const EdgeInsets.only(
                      left: 20, right: 20, top: 20, bottom: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(3),
                        color: Colors.white,
                        child: const Image(
                            height: 50,
                            image: AssetImage('assets/images/googleLogo.png')),
                      ),
                      const Text(
                        "Sign in with google",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
