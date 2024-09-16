// Main Page
// Code by Alexis Pagnon and Sanchez Adam
// ParkinsonCom V2

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_com_v2/listDialogsPage.dart';
import 'package:parkinson_com_v2/variables.dart';


void main() {
  // We put the game in full screen mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky );

  // First initialization of the database manager when launching the app
  databaseManager.initDB();

  // Initialization of the TTS handler when launching the app
  ttsHandler.initTts();

  // We ensure that the phone preserve the landscape mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(29, 52, 83, 1),
      body: ValueListenableBuilder<bool>(
          valueListenable: dialogPageState,
          builder: (context, value, child) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ListDialogsPage()),
                    );
                  }, child:
                  Text(
                    langFR
                        ? "Dialogue"
                        : "Dialoog",
                    style: const TextStyle(
                      backgroundColor: Colors.white,
                      color: Colors.black,
                      fontSize: 30,
                    ),
                  )),
                  TextButton(
                      onPressed: () {
                    setState(() {
                      langFR = !langFR;
                    });
                  },
                      child: Text(
                    langFR
                      ? "Changer de langue"
                      : "Taal wijzigen",
                    style: TextStyle(
                      backgroundColor: Colors.white,
                      color: Colors.black,
                      fontSize: 30,
                    ),
                  )),
                ],
              ),
            );
          }),
    );
  }
}
