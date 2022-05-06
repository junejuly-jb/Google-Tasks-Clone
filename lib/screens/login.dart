import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../services/auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = '';
  String password = '';

login() async {
    try {
      var result = await Auth().login(email, password);
      if (result["success"]) {
        var sessionManager = SessionManager();
        await sessionManager.set('token', result["token"]);
        Navigator.popAndPushNamed(context, '/home');
      }
      else{
        print(result);
      }
    } catch (e) {
      print(e);
    }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 50),
          Text(
            'Welcome back!',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800]),
          ),
          const SizedBox(height: 20),
          Form(
            child: Column(
              children: <Widget>[
                TextFormField(
                    onChanged: (value) => setState(() => email = value),
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    )),
                TextFormField(
                  onChanged: (value) => setState(() => password = value),
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: login, child: const Text('Login')),
                    const SizedBox(width: 20),
                    ElevatedButton(
                        onPressed: () {
                          print('hello');
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text('Register'))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    )));
  }
}
