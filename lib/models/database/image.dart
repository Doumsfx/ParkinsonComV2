// ImageObject Class
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

class ImageObject {
  int id_image;
  String path;

  ImageObject({this.id_image = 0, required this.path});

  ImageObject.fromMap(Map<String, dynamic> data)
      : id_image = data["id_image"],
        path = data["path"];

  Map<String, Object?> toMap() {
    return {"path": path};
  }
}
