import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stephin_mess_management/screens/userlist.dart';
import 'package:stephin_mess_management/screens/homepage.dart';

void main() {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Color(0xfffbb827)));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: const Color(0xfffbb827),backgroundColor: Color(0xff121212)),
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (ctx,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return  const Scaffold(body: Center(child: CircularProgressIndicator(),),);
          }
          else{
            return  const HomePage();
          }

        },
      ),
    );
  }
}

