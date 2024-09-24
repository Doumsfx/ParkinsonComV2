// Dico and DicoElement Classes
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

import 'dart:convert';

class Dico {
  late List<DicoElement> dicoElements;

  Dico() {
    dicoElements = List.empty(growable: true);
  }

  ///Sort Dico based on the frequency of each DicoElement
  void sort() {
    dicoElements.sort(((a, b) => a.frequency.compareTo(b.frequency)));
  }

  static Dico fromJson(String json) {
    return jsonDecode(json);
  }

  Map<String, dynamic> toJson() {
    return {
      'dicoElements': dicoElements.map((e) => e.toJson()).toList(),
    };
  }

  ///Add a word [str] to the Dico
  void addWords(String str) {
    //Replace separators for an upcoming split
    List<String> separators = List.from([",", ".", "!", "'", "?", "\n"]);
    for (var s in separators) {
      str = str.replaceAll(s, " ");
    }
    //For each word, we check if it already exists in the list or not
    for (var word in str.split(" ")) {
      DicoElement dicoElement = DicoElement(word);
      if (dicoElements.contains(dicoElement)) continue; //Exist -> skip
      dicoElements.add(dicoElement);
    }
  }

  ///Return the index of a [word] in the dicoElements list.
  ///-1 is returned if the word isn't in the list.
  int searchIndex(String word) {
    for (int i = 0; i < dicoElements.length; i++) {
      if (dicoElements[i].word == word) {
        return i;
      }
    }
    return -1;
  }
}

///Associate a word with a frequency
class DicoElement {
  String word = "";
  int frequency = 1;

  DicoElement(this.word, {this.frequency = 1});

  int compareTo(Object? obj) {
    if (obj == null) return 1;
    DicoElement? dicoElement = obj as DicoElement?;
    if (dicoElement != null) {
      return dicoElement.frequency.compareTo(frequency);
    } else {
      throw ArgumentError("Object is not a DicoElement");
    }
  }

  bool equals(Object? obj) {
    if (obj == null) return false;
    DicoElement? dicoElement = obj as DicoElement?;
    if (dicoElement == null) {
      return false;
    }
    return dicoElement.word.toLowerCase() == word.toLowerCase();
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'frequency': frequency,
    };
  }
}
