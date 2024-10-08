// Database Manager
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

class Contact {
  int id_contact;
  String last_name;
  String first_name;
  String? email;
  String? phone;
  int priority;

  Contact({this.id_contact = -1, required this.last_name, required this.first_name, this.email, this.phone, required this.priority});

  Contact.fromMap(Map<String, dynamic> data)
      : id_contact = data["id_contact"],
        last_name = data["last_name"],
        first_name = data["first_name"],
        priority = data["priority"],
        email = data["email"],
        phone = data["phone"];

  Map<String, Object?> toMap() {
    if(id_contact == -1) {
      return {"last_name": last_name, "first_name": first_name, "priority": priority, "email": email, "phone": phone};
    }
    else {
      return {"id_contact": id_contact, "last_name": last_name, "first_name": first_name, "priority": priority, "email": email, "phone": phone};
    }
  }

}