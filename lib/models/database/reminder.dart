// Reminder Class
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

class Reminder {
  int id_reminder;
  String title;
  String hour;
  bool ring; //In the database, true is 1 and 0 is false
  String days; //String containing the list of days (example : 'monday friday sunday') --> must be split later as a List if needed

  Reminder({this.id_reminder = 0, required this.title, required this.hour, required this.ring, required this.days});

  Reminder.fromMap(Map<String, dynamic> data)
      : id_reminder = data["id_reminder"],
        title = data["title"],
        hour = data["hour"],
        ring = data["ring"] == 1,
        days = data["days"];

  Map<String, Object?> toMap() {
    return {"title" : title, "hour" : hour, "ring" : ring ? 1 : 0, "days" : days};
  }
}