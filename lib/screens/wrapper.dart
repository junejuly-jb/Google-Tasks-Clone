import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';


class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  void initState() {
    super.initState();
    _navigateTo();
  }

  _navigateTo() async {
    await Future.delayed(const Duration(seconds: 2));
    dynamic token = await SessionManager().get('token');
    if(token != null){
      Navigator.pushReplacementNamed(context, '/home');
    }
    else{
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark
      ),
      child: Scaffold(
        body: SafeArea(
          child: Center( 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 110.0,
                  width: 110.0,
                  decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage('assets/images/splash.png'))
                  ),
                ),
                const SizedBox(height: 20.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Please wait'),
                    SizedBox(width: 20.0),
                    SizedBox(
                      height: 20.0,
                      width: 20.0,
                      child: CircularProgressIndicator()
                    )
                  ],
                )
              ]
            ),
          ),
        ),
      ),
    );
  }
}
