
class AlarmModel{
  int? id;
  int alarmId;
  String alarmTitle;
  String timeOfDay;
  String ringtoneName;

  AlarmModel({
    this.id,
    required this.alarmId,
    required this.alarmTitle,
    required this.timeOfDay,
    required this.ringtoneName
  });

  factory AlarmModel.fromMap(Map<String,dynamic> e) => AlarmModel(
      alarmId: e["alarmId"],
      alarmTitle: e["alarmTitle"],
      timeOfDay: e["timeOfDay"],
      ringtoneName: e["ringtoneName"]);

  Map<String,dynamic> toMap() {
    return {
      "alarmId" : alarmId,
      "alarmTitle" : alarmTitle,
      "timeOfDay" : timeOfDay,
      "ringtoneName" : ringtoneName
    };
  }
}
