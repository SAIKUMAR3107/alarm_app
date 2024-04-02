import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'package:alarm/alarm.dart';
import 'package:alarm_clock/model/alarm_model.dart';
import 'package:alarm_clock/database/database_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

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
  int alarmId = 1;
  String valueGetter = "";
  AlarmSettings? alarmSettings;
  TimeOfDay timeOfDay = TimeOfDay(hour: 00, minute: 00);
  List<String> watchFaces = [
    "assets/rolex.jpg",
    "assets/tag_heuer.jpg",
    "assets/ferrari_edition.jpg",
    "assets/apple_watch.jpg",
    "assets/omega.jpg"
  ];
  int index = 0;
  String? values;
  String paths = "assets/ringtone.mp3";
  var name = "default ringtone";
  var alarmTitle = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    now = DateTime.now();
    values = watchFaces[0];
    timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        now = DateTime.now();
        secondsAngle = (pi / 30) * now!.second;
        minutesAngle = (pi / 30) * now!.minute;
        hoursAngle = (pi / 6 * now!.hour) + (pi / 45 * minutesAngle);
      });
    });
  }

  String getter(int time) {
    if (time >= 0 && time < 10) {
      return "0${time}";
    } else {
      return time.toString();
    }
  }

  void getId() async {
    await DatabaseHelper.instance.getLastId().then((value) {
      setState(() {
        if (value.length == 0) {
          alarmId = 1;
        } else {
          alarmId = value[0]["id"] as int;
          alarmId++;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF301934),
        title: Text(
          "A L A R M",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xFF301934),
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Divider(
                color: Colors.white,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Watch face : ",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    values!.substring(7, values?.indexOf(".")).toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white),
                  )
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
                      fit: BoxFit.cover,
                    ),
                  ),
                  //Hours
                  Transform.rotate(
                    angle: hoursAngle,
                    child: Container(
                      alignment: Alignment(0, -0.30),
                      child: Container(
                        height: 70,
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
                      alignment: Alignment(0, -0.37),
                      child: Container(
                        height: 110,
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
              Container(
                child: Text(
                  "${getter(now!.hour % 12) == "00" ? "12" : getter(now!.hour % 12)} : ${getter(now!.minute)} : ${getter(now!.second)}  ${now!.hour >= 12 && now!.hour <= 23 ? "PM" : "AM"}",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Divider(
                color: Colors.white,
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color(0xFF140F21),
                    borderRadius: BorderRadius.circular(20)),
                width: MediaQuery.of(context).size.width,
                child: DropdownButtonHideUnderline(
                    child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: DropdownButton<String>(
                    dropdownColor: Color(0xFF140F21),
                    borderRadius: BorderRadius.circular(20),
                    items: watchFaces
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item.substring(7, item.indexOf(".")),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ))
                        .toList(),
                    onChanged: ((value) => setState(() {
                          values = value;
                          index = watchFaces.indexOf(value!);
                        })),
                    value: values,
                    hint: Text(
                      "Choose watch faces",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )),
              ),
              Divider(
                color: Colors.white,
              ),
              Container(
                height: 600,
                color: Color(0xFF301934),
                child: FutureBuilder<List<AlarmModel>>(
                  future: DatabaseHelper.instance.getAlarm(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<AlarmModel>> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                          child: Text("Loading...",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 30)));
                    }
                    return snapshot.data!.isEmpty
                        ? Center(
                            child: Text("Data base is Empty",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30)))
                        : ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28)),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Color(0xFF140F21)),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                "Alarm title",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              )),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                                snapshot
                                                    .data![index].alarmTitle,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20)),
                                          )
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.white,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "Alarm time",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              snapshot.data![index].timeOfDay,
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          )
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.white,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      "ringtone :",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20),
                                                    )),
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                      snapshot.data![index]
                                                          .ringtoneName,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20)),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStatePropertyAll(
                                                          Colors.red)),
                                              onPressed: () async {
                                                await Alarm.stop(snapshot
                                                    .data![index].alarmId);
                                                print(snapshot
                                                    .data![index].alarmId);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            "Alarm turned off")));
                                              },
                                              child: Text("Stop alarm",
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                          ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Colors.blue)),
                                              onPressed: () async {
                                                await DatabaseHelper.instance.deleteAlarm(snapshot.data![index].alarmId);

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Alarm Deleted from the list")));
                                              },
                                              child: Text("Delete alarm",
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.red)),
                  onPressed: () async {
                    await Alarm.stop(alarmId);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Alarm turned off")));
                  },
                  child: Text("Click to Stop any alarm",
                      style: TextStyle(color: Colors.white))),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, size: 30, color: Color(0xFF140F21), weight: 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () async {
          showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  backgroundColor: Color(0xFF140F21),
                  content: Container(
                    padding: EdgeInsets.all(10),
                    height: 350,
                    width: 350,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Color(0xFF140F21)),
                    child: Column(
                      children: [
                        Text(
                          "Set Alarm",
                          style: TextStyle(
                              fontSize: 23,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: alarmTitle,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.white)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.white)),
                            labelText: "Alarm title",
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            floatingLabelStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            hintStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: "sans-serif-condensed-light",
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now())
                                .then((value) {
                              setState(() {
                                timeOfDay = value!;
                                print(timeOfDay);
                                print(now);
                              });
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(25)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Click to choose time",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                Text(
                                  timeOfDay.format(context).toString(),
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['mp3'],
                            );
                            final files = result?.files;
                            final path = files?.first.path.toString();
                            final file = File(path!);
                            setState(() {
                              paths = path;
                              name = result!.files.single.name;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "ringtone :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        )),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(name,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20)),
                                    )
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: Colors.white,
                                size: 30,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.green)),
                            onPressed: () async {
                              print(timeOfDay);
                              print(now);
                              if (alarmTitle.text.isNotEmpty &&
                                  (timeOfDay.hour >= now!.hour)) {
                                setState(() {
                                  alarmSettings = AlarmSettings(
                                      id: alarmId,
                                      volume: 0.9,
                                      dateTime: DateTime(
                                          now!.year,
                                          now!.month,
                                          now!.day,
                                          timeOfDay.hour,
                                          timeOfDay.minute,
                                          00),
                                      enableNotificationOnKill: true,
                                      assetAudioPath: paths,
                                      notificationTitle: "Alarm",
                                      loopAudio: true,
                                      notificationBody: alarmTitle.text);
                                });
                                await Alarm.set(alarmSettings: alarmSettings!);
                                await DatabaseHelper.instance.addAlarm(
                                    AlarmModel(
                                        alarmId: alarmId,
                                        alarmTitle: alarmTitle.text,
                                        timeOfDay: timeOfDay.format(context),
                                        ringtoneName: name));
                                getId();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Alarm was set at ${timeOfDay.format(context)}")));
                                alarmTitle.clear();
                                timeOfDay = TimeOfDay(hour: 00, minute: 00);
                                name = "default ringtone";
                                Navigator.of(context).pop();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Please set Alarm title and time should be greater than current time and must choose ringtone")));
                              }
                            },
                            child: Text(
                              "Set alarm",
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                    ),
                  ),
                );
              });
            },
          );
        },
      ),
    );
  }
}
