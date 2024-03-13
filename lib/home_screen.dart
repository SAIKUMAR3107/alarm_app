import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

import 'notification_functionality.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var secondsAngle = 0.0;
  var minutesAngle = 0.0;
  var hoursAngle = 0.0;
  late Timer timer;
  DateTime? now;
  int alarmId = 2;
  String valueGetter = "";
  AlarmSettings? alarmSettings;
  TimeOfDay timeOfDay = TimeOfDay(hour: 00, minute: 00);
  List<String> watchFaces = ["assets/rolex.jpg","assets/tag_heuer.jpg","assets/ferrari_edition.jpg"];
  int index = 0;
  String? values;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    now = DateTime.now();
    timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        now = DateTime.now();
        secondsAngle = (pi / 30) * now!.second;
        minutesAngle = (pi / 30) * now!.minute;
        hoursAngle = (pi / 6 * now!.hour) + (pi / 45 * minutesAngle);
      });
    });
  }

  String getter(int time){
    if(time>=0 && time<10){
      return "0${time}";
    }
    else{
      return time.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "A L A R M",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Watch face : ",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                  Text(values!.substring(7,values?.indexOf(".")).toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),)
                ],
              ),
              Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment(0, 0),
                width: 340,
                height: 340,
                child: Stack(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(190),
                    child: Image.asset(
                      watchFaces[index],
                      height: 400,
                    ),
                  ),
                  //Hours
                  Transform.rotate(
                    angle: hoursAngle,
                    child: Container(
                      alignment: Alignment(0, -0.32),
                      child: Container(
                        height: 90,
                        width: 8,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  //minutes
                  Transform.rotate(
                    angle: minutesAngle,
                    child: Container(
                      alignment: Alignment(0, -0.35),
                      child: Container(
                        height: 100,
                        width: 5,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  //Dot
                  Container(
                    alignment: Alignment(0, 0),
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)),
                    ),
                  ),
                  //seconds
                  Transform.rotate(
                    angle: secondsAngle,
                    child: Container(
                      alignment: Alignment(0, -0.4),
                      child: Container(
                        height: 140,
                        width: 3,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ]),
              ),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.orange.shade300,borderRadius: BorderRadius.circular(20)),
                width: MediaQuery.of(context).size.width,

                child: DropdownButtonHideUnderline(
                    child: Container(
                      padding: EdgeInsets.only(left: 10,right: 10),
                      child: DropdownButton<String>(
                        dropdownColor: Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                        items: watchFaces.map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item,style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),)).toList(),
                        onChanged: ((value) => setState(() {
                          values = value;
                          index = watchFaces.indexOf(value!);
                        })),
                        value: values,
                        hint: Text("Choose watch faces",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Text(
                  "${getter(now!.hour%12)} : ${getter(now!.minute)} : ${getter(now!.second)}  ${now!.hour>=12 && now!.hour<=23 ? "PM" : "AM"}",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(onPressed: (){
                    showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) {
                      setState(() {
                        timeOfDay = value!;
                      });
                    });

                  }, child: Text("Choose time for alarm")),
                  Text(timeOfDay.format(context).toString(),style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)
                ],
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.green)),
                      onPressed: () async{
                        setState(() {
                          alarmSettings  = AlarmSettings(id: alarmId, dateTime: DateTime(now!.year,now!.month,now!.day,timeOfDay.hour,timeOfDay.minute,00) , enableNotificationOnKill: true,assetAudioPath: "assets/ringtone.mp3", notificationTitle: "Alarm",loopAudio: true, notificationBody: "Wake up Early");
                        });
                        await Alarm.set(alarmSettings: alarmSettings!);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Alaram was set at ${timeOfDay.format(context)}")));
                      },
                      child: Text(
                        "Set alarm",
                        style: TextStyle(color: Colors.white),
                      )),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Colors.red)),
                      onPressed: () async{
                        await Alarm.stop(alarmId);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Alarm turned off")));
                      },
                      child: Text("Stop alarm",
                          style: TextStyle(color: Colors.white))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
