// Sms Class
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

class Sms {
  int id_sms;
  String content;
  String? timeSms;
  bool isReceived; // In the database, true is 1 and 0 is false
  int id_contact;

  Sms({this.id_sms = 0, required this.content, this.timeSms, required this.isReceived, required this.id_contact});

  Sms.fromMap(Map<String, dynamic> data)
      : id_sms = data["id_sms"],
        content = data["content"],
        timeSms = data["timeSms"],
        isReceived = data["isReceived"] == 1,
        id_contact = data["id_contact"];


  Map<String, Object?> toMap() {
    return {"content" : content, "timeSms" : timeSms, "isReceived" : isReceived ? 1 : 0, "id_contact" : id_contact};
  }
}