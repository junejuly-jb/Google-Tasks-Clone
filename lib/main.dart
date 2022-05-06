import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rest_auth_login/screens/home.dart';
import 'package:rest_auth_login/screens/login.dart';
import 'package:rest_auth_login/screens/register.dart';
import 'package:rest_auth_login/screens/wrapper.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey[700]
        )
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Wrapper(),
        '/home': (context) => const Home(),
        '/login': (context) => const Login(),
        '/register': (context) => const Register()
      },
    );
  }
}
