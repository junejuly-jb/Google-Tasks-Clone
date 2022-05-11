import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rest_auth_login/screens/details.dart';
import 'package:rest_auth_login/screens/home.dart';
import 'package:rest_auth_login/screens/login.dart';
import 'package:rest_auth_login/screens/register.dart';
import 'package:rest_auth_login/screens/wrapper.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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

    return GlobalLoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: const Center(
        child: SpinKitCircle(
          color: Colors.blue,
          size: 50.0
        )
      ),
      child: MaterialApp(
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
          '/register': (context) => const Register(),
          '/details': (context) => const Details()
        },
      ),
    );
  }
}
