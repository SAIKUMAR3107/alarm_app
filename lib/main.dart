import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'home_screen.dart';
import 'notification_functionality.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //await AndroidAlarmManager.initialize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Alarm.init();
  runApp(const MyApp());
  //NotificationService().initNotification();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}


