import 'package:firbasenoteapp/pages/detail_page.dart';
import 'package:firbasenoteapp/pages/home_page.dart';
import 'package:firbasenoteapp/pages/sign_in_page.dart';
import 'package:firbasenoteapp/pages/sign_up_page.dart';
import 'package:firbasenoteapp/services/hive_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox(HiveDB.DB_NAME);


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  Widget _startPage(){

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context,snapshot){
        if(snapshot.hasData){
          HiveDB.storeU(snapshot.data!.uid);
          return const HomePage();
        }
        else{
          HiveDB.removeUid();
          return const SignInPage();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Fire note app",
      theme: ThemeData(
        primaryColor: Colors.blue
      ),
      home: _startPage(),
      routes: {
        HomePage.id: (context) => const HomePage(),
        DetailPage.id: (context) =>  DetailPage(),
        SignUpPage.id: (context) => const SignUpPage(),
        SignInPage.id: (context) => const SignInPage(),
      },
    );
  }
}
