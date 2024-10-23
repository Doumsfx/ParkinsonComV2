// MusicObject Class
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

class MusicObject {
  int id_music;
  String path;

  MusicObject({this.id_music = 0, required this.path});

  MusicObject.fromMap(Map<String, dynamic> data)
      : id_music = data["id_music"],
        path = data["path"];

  Map<String, Object?> toMap() {
    return {"path": path};
  }
}