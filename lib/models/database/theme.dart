// ThemeObject Class
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

class ThemeObject {
  int id_theme;
  String title;
  String language;

  ThemeObject({this.id_theme = 0, required this.title, required this.language});

  ThemeObject.fromMap(Map<String, dynamic> data)
      : id_theme = data["id_theme"],
        title = data["title"],
        language = data["language"];

  Map<String, Object?> toMap() {
    return {"title": title, "language": language};
  }
}
