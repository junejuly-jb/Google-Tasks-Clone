import 'package:flutter/material.dart';

import '../services/auth.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String name = '';
  String email = '';
  String password = '';

  register() async {
    var result = await Auth().register(name, email, password);
    if(result["success"]){
      Navigator.pushNamed(context, '/');
    }
      print(result["message"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                onChanged: (value) => setState(() => name = value),
                decoration: const InputDecoration(
                  labelText: 'Name',
                )
              ),
              TextFormField(
                onChanged: (value) => setState(() => email = value),
                decoration: const InputDecoration(
                  labelText: 'Email',
                )
              ),
              TextFormField(
                onChanged: (value) => setState(() => password = value),
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              ElevatedButton(onPressed: register, child: const Text('Sign up'))
            ],
          ),
        ),
      ),
    );
  }
}
