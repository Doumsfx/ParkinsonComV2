// Predictions Manager
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

import 'dart:collection';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:parkinson_com_v2/variables.dart';
import 'package:xml/xml.dart' as xml;

import 'dico.dart';

class PredictionsHandler {
  final TextEditingController controller;
  String prediLanguage;
  late ValueNotifier<List<String>> suggestedWordsList;
  late Dico _dictionnary;

  Timer? _debounce; //This will prevent the the predictions request to trigger twice (because of the controller and event listener)

  PredictionsHandler({required this.controller, this.prediLanguage = "fr"}) {
    suggestedWordsList = ValueNotifier(List<String>.empty());
    controller.addListener(_onTextChanged);
    isConnected.addListener(_refreshPredictions);
    //Initialization with empty query for the starting words
    if (isConnected.value) {
      if (prediLanguage == "fr") {
        predictFR(controller.text); //FR
      } else if(prediLanguage == "nl") {
        initDicoNL(controller.text); //NL
      }
    }
  }

  /// Method to remove the listener
  void removeListener() {
    controller.removeListener(_onTextChanged);
  }

  /// Method to re-add the listener
  void addListener() {
    controller.addListener(_onTextChanged);
  }

  void _refreshPredictions() {
    if (isConnected.value) {
      if (prediLanguage == "fr") {
        predictFR(controller.text); //FR
      } else if(prediLanguage == "nl"){
        initDicoNL(controller.text); //NL
      }
    }
  }

  /// Method to clear the text and manage listeners.
  void clearText() {
    /* Before using this method, we were using the _controller.clear() in the TextField onTap
    But it was creating multiples listeners on the controller, so this method is a fix
     */
    removeListener(); // Remove listener to prevent triggering
    controller.clear(); // Clear the text field

    //Prediction with empty sentence
    if (isConnected.value) {
      if (prediLanguage == "fr") {
        predictFR(""); //FR
      } else if(prediLanguage == "nl"){
        predictNL(""); //NL
      }
    }

    addListener(); // Re-add listener after clearing
  }

  ///Complete the [sentence] with the selected [word] (autocomplete if we started the word, add it if we didn't)
  void completeSentence(String sentence, String word) {
    List<String> wordsList = sentence.split(" ");
    wordsList.last = word;
    controller.text = "${wordsList.join(' ')} ";
  }

  ///Event listener that will update the [suggestedWordsList] based on the new text of the [PredictionsHandler.controller]
  void _onTextChanged() {
    if(isConnected.value) {
      //Debouncing, avoid to be triggered twice
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 400), () {
        //Duration can be changed
        if (prediLanguage == "fr") {
          predictFR(controller.text); //FR
        } else if(prediLanguage == "nl"){
          predictNL(controller.text); //NL
        }
      });
    }
  }

  ///Initialization of the dictionnary of NL words before the first attempts to predict words
  void initDicoNL(String query) async {
    await buildDictionnary();
    predictNL(query);
  }

  /* French Prediction, can be re-used for other languages that are managed by Typewise */

  ///Update [PredictionsHandler.suggestedWordsList] to get a prediction of French words based on the [query]
  Future<void> predictFR(String query) async {
    List<String> wordList = List.empty(growable: true);
    const url = 'https://api.typewise.ai/latest/completion/complete';
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'text': query,
      'languages': ["fr"],
      'correctTypoInPartialWord': 'true'
    });
    //Get JSON Data (Typewise not available for NL)
    final response = await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      final document = jsonDecode(utf8.decode(response.bodyBytes)); //UTF8 for accentuated characters
      //document contains a list of predicted words
      final suggestions = document["predictions"];
      for (var sugges in suggestions) {
        wordList.add(sugges["text"]);
      }
      //Update the suggestedWordsList with the new words
      suggestedWordsList.value = wordList;
    } else {
      throw Exception('Failed to load Json data');
    }
  }

  /* Dutch Prediction */
  /* Typewise API don't manage NL sentences
  *  We will use the former Unity code that give an autocompletion of the words
  * */

  ///Initialization of [dictionnary] with the frequency of each words from the nl_words.txt file
  Future<void> buildDictionnary() async {
    try {
      //Access to nl_words (rootBundle and File because File uses the paths after the app wrapping, the path will change after the wrap)
      String fileContent = await rootBundle.loadString('assets/nl_words.txt');
      List<String> lines = fileContent.split('\n');
      //Instance and init of dictionnary
      _dictionnary = Dico();
      for (int i = 0; i < lines.length; i++) {
        //Each line follows the format :
        //word(s) frequency
        var data = lines[i].split(' ');
        String word = "";
        for (int j = 0; j < data.length - 1; j++) {
          word += data[j];
          if (j != data.length - 2) word += " ";
        }
        //Add the line into dictionnary as DicoElement
        _dictionnary.dicoElements.insert(i, DicoElement(word, frequency: int.parse(data[data.length - 1])));
      }
    } catch (e) {
      throw Exception("Error loading file: $e");
    }
  }

  ///Update [PredictionsHandler.suggestedWordsList] to get a prediction of Dutch words based on the [query] (~ autocompletion)
  Future<void> predictNL(String query) async {
    //Predictions list
    List<String> results = List.empty(growable: true);
    //Can't use Google SuggestQueries without a query
    if (query != "") {
      //SuggestQueries
      final response = await http.get(Uri.parse('https://suggestqueries.google.com/complete/search?output=toolbar&hl=be-NL&q=$query'));

      if (response.statusCode == 200) {
        //Treat the XML response
        List<String> wordList = List.empty(growable: true); //List of received predictions

        final document = xml.XmlDocument.parse(response.body); //XML body
        final suggestions = document.findAllElements('CompleteSuggestion'); //<CompleteSuggestion>
        for (var sugges in suggestions) {
          final suggesElement = sugges.findElements('suggestion').first; //<suggestion>
          final data = suggesElement.getAttribute('data'); //"data" attribute
          if (data != null) {
            wordList.add(data); //Add prediction
          }
        }
        //XML done
        //Sort predictions
        List<String> sortedResult = sortList(wordList, query);

        //We take the first 3 predictions
        for (int i = 0; i < 3 && i < sortedResult.length; i++) {
          results.add(sortedResult[i]);
        }
        //Word completion from a root (ex: "to" -> "total" or "too")
        fillPrediction(results, query);
      } else {
        throw Exception('Failed to load XML data');
      }
    }
    //No query => 3 first words from dictionnary
    else {
      for (int i = 0; i < 3; i++) {
        results.add(_dictionnary.dicoElements[i].word.substring(0, 1).toUpperCase() + _dictionnary.dicoElements[i].word.substring(1));
      }
    }
    //Final predictions list
    suggestedWordsList.value = results;
  }

  ///Sort [nodeList] which is a list of predicted sentences and return a list of word that can follow our [sentence]
  List<String> sortList(List<String> nodeList, String sentence) {
    List<String> sorted = List.empty(growable: true);
    //HashMap between each word and its position in the file
    HashMap<String, int> nodes = HashMap();

    for (var node in nodeList) {
      //Split the predicted sentences
      List<String> words = node.split(' ');
      int sentenceLength = sentence.split(' ').length;
      //Si on a + de mots dans la prédiction que dans la phrase saisie (initiale)
      //If we have more words in the prediction than in our query (? -> the prediction contains the query)
      if (words.length >= sentenceLength) {
        //Get the word from the prediction that follows the query
        String data = words[sentenceLength - 1];

        //Don't write multiple times the same word in the predictions list
        if (nodes.containsKey(data)) continue;

        //Get the index of the word predicted in the file
        int index = _dictionnary.searchIndex(data.toLowerCase());
        if (index == -1) _dictionnary.searchIndex(data);
        nodes.addAll({data: index});
      }
    }

    //SplayTreeMap is an automatically sorted structure based on the keys
    var orderedNode = SplayTreeMap.of(nodes);

    for (var ordered in orderedNode.entries) {
      //If the word is in the file -> We add it in the sorted list
      //This condition permit to manage which words we are allowing from Google Suggest
      if (ordered.value != -1) {
        nodes.remove(ordered.key);
        sorted.add(ordered.key);
      }
    }
    return sorted;
  }

  /// Complete the [predictions] list with words that have the same root as the last word in the [sentence]
  /// (only when we have less than 3 words predicted).
  /// Ex: "to" -> "total" or "too"
  void fillPrediction(List<String> predictions, String sentence) {
    for (var dicoElement in _dictionnary.dicoElements) {
      if (predictions.length >= 3) break; //Don't predict more than 3 words
      var splitted = sentence.split(' ');
      var lastWord = splitted[splitted.length - 1];
      //If a word of the dictionnary start with the end of the sentence -> Add it to the predictions
      if (dicoElement.word.toLowerCase().startsWith(lastWord.toLowerCase())) {
        predictions.add(lastWord + dicoElement.word.substring(lastWord.length));
      }
    }
  }
}
