import 'dart:async';

import 'package:alarm_clock/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Color(0xFF301934),
            child: Center(
              child: Icon(Icons.alarm,size: 90,color: Colors.white,),
            ),),
        Positioned(
          bottom: 10,
          child: Container(
              width: MediaQuery.of(context).size.width,
              alignment:Alignment.center,child: Text("A L A R M",style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold,fontFamily: "sans-serif-condensed-light"))),
        ),
        ],
      ),
    );
  }
}
