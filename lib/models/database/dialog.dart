class DialogObject{
  int id_dialog;
  String sentence;
  String language;
  int id_theme;

  DialogObject({this.id_dialog=0, required this.sentence, required this.language, this.id_theme=1});

  DialogObject.fromMap(Map<String,dynamic> data) :
        id_dialog = data["id_dialog"],
        sentence = data["sentence"],
        language = data["language"],
        id_theme = data["id_theme"];

  Map<String,Object?> toMap(){
    return {"sentence" : sentence, "language" : language, "id_theme" : id_theme};
  }



}