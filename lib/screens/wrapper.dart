import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import 'home.dart';
import 'login.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  Future<String?> getSessionToken() async {
    dynamic token = await SessionManager().get('token');
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getSessionToken(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          if(snapshot.connectionState == ConnectionState.done){
            if (snapshot.hasData) {
              print('has data');
              return const Home();
            }
          }
          return const Login();
        }
    );
  }
}
