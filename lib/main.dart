import 'package:flutter/material.dart';
import 'package:ukl_login/views/matkul.dart';
import 'package:ukl_login/views/profil.dart';
import 'package:ukl_login/views/register.dart';
import 'views/login.dart';
import 'views/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/register': (context) => RegisterPage(),
        '/login': (context) => Login(),
        '/home': (context) => Home(),
        '/profil': (context) => Profil(),
        '/matkul': (context) =>MataKuliah(),
        
      },
    );
  }
}
