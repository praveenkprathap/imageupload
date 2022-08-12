import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imageupload/pages/homepage.dart';
import 'package:imageupload/pages/login_page.dart';
import 'package:imageupload/providers/login_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => LoginProvider()),
    ], child: const MyApp()));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        //This method will use streamBuilder() to get Firebase instance from
        //the Firebase server and help the app stay connected with Firebase.
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                return const HomePage();
              } else {
                return const LoginPage();
              }
            }));
  }
}
