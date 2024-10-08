// List of dialogs filtered by themes Page
// Code by Alexis Pagnon and Sanchez Adam
// ParkinsonCom V2

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:parkinson_com_v2/keyboard.dart';
import 'package:parkinson_com_v2/models/database/contact.dart';
import 'package:parkinson_com_v2/variables.dart';
import 'package:permission_handler/permission_handler.dart';

import 'models/popupshandler.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Useful variables
  final Map<String, bool> _buttonAnimations = {
    "POPUP NO": false,
    "POPUP YES": false,
    "POPUP OK": false,
    "START": false,
    "FR": false,
    "NL": false,
  };

  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _secondController = TextEditingController();
  bool _isFirstControllerActive = false;
  bool phone = true;

  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNode2 = FocusNode();

  late PermissionStatus permissionPhone;

  void initialisationAsync() async {
    permissionPhone = await Permission.phone.status;
  }

  @override
  void initState() {
    super.initState();
    // Initialisation of our variables
    initialisationAsync();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
      FocusScope.of(context).requestFocus(_focusNode2);
    });

  }

  @override
  void dispose() {
    _focusNode.dispose();
    _focusNode2.dispose();
    super.dispose();
  }

  Future<bool> startChecks() async {
    // SIM card presence check
    if (phone) {
      //Ask for the phone permissions in order to read the phone state
      if (permissionPhone.isDenied) {
        await _checkPermissionsPhone();
      }
      //Permission granted
      if (permissionPhone.isGranted) {
        //Check the sim card presence
        bool sim = await smsHandler.checkSim();
        if (!sim) {
          phone = false;
          Popups.showPopupOk(context, text: languagesTextsFile.texts["sim_card_absent"], textOk: languagesTextsFile.texts["pop_up_ok"], functionOk: Popups.functionToQuit);
          return false;
        }
      }
      //Permission denied
      else {
        phone = false;
        Popups.showPopupOk(context, text: languagesTextsFile.texts["missing_permissions"], textOk: languagesTextsFile.texts["pop_up_ok"], functionOk: Popups.functionToQuit);
        return false;
      }
    }
    // No error during SIM card verifications (or not needed to be checked)
    // E-Mail Check
    bool email = await emailHandler.checkCode(context, _secondController.text);
    print("Email : $email");
    if(email) {
      return true;
    }
    else {
      return false;
    }
  }

  ///Check if the permissions to read the phone state are given, and ask for them if it's not the case
  Future<bool> _checkPermissionsPhone() async {

    ///Function that is used by the OK button of the popup
    void askPermissions(BuildContext context) async {
      permissionPhone = await Permission.phone.request();
      if (permissionPhone.isGranted) {
        Navigator.of(context).pop(true);
      } else {
        Navigator.of(context).pop(false);
      }
    }
    return await Popups.showPopupOk(context, text: languagesTextsFile.texts["ask_permissions"], textOk: languagesTextsFile.texts["pop_up_ok"], functionOk: askPermissions).then((value) {
        return value ?? false;
    },);
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(29, 52, 83, 1),
        body: ValueListenableBuilder(
          valueListenable: newContactPageState,
          builder: (context, value, child) {
            if(!value){
              return Column(
                children: [
                  // First Part
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Row(
                      children: [
                        // Logo ParkinsonCom
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: Image.asset(
                                'assets/logo-Interreg.png',
                                scale: MediaQuery.of(context).size.width / 1025.64,
                              ),
                            ),
                          ),
                        ),

                        // TextFields and Start Button
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // First TextField
                              Container(
                                width: MediaQuery.of(context).size.width * 0.38,
                                height: MediaQuery.of(context).size.height * 0.11,
                                margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(MediaQuery.of(context).size.width * 0.02),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    MediaQuery.of(context).size.width * 0.02,
                                    0,
                                    MediaQuery.of(context).size.width * 0.02,
                                    0,
                                  ),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        // Icon
                                        SizedBox(
                                          height: MediaQuery.of(context).size.height * 0.06,
                                          width: MediaQuery.of(context).size.height * 0.06,
                                          child: Image.asset(
                                            'assets/padlock.png',
                                          ),
                                        ),

                                        // TextField
                                        Expanded(
                                          child: TextField(
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w800,
                                              color: Color.fromRGBO(50, 50, 50, 1),
                                              overflow: TextOverflow.ellipsis,
                                            ),

                                            focusNode: _focusNode,
                                            controller: _firstController,
                                            readOnly: true,
                                            showCursor: true,
                                            enableInteractiveSelection: true,
                                            maxLines: 1,
                                            textAlign: TextAlign.left,
                                            textAlignVertical: TextAlignVertical.center,

                                            decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                iconColor: Colors.white,
                                                focusColor: Colors.white,
                                                hoverColor: Colors.white,
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Colors.white,
                                                  ),
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(MediaQuery.of(context).size.width * 0.02),
                                                  ),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Colors.white,
                                                  ),
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(MediaQuery.of(context).size.width * 0.02),
                                                  ),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Colors.white,
                                                  ),
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(MediaQuery.of(context).size.width * 0.02),
                                                  ),
                                                ),
                                                hintText: languagesTextsFile.texts["login_page_first_name"],
                                                hintStyle: const TextStyle(
                                                  color: Color.fromRGBO(147, 147, 147, 1),
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 19,
                                                )
                                            ),

                                            onTap: () {
                                              setState(() {
                                                _isFirstControllerActive = true;
                                                newContactPageState.value = true;
                                              });
                                              print("TOUCHEEEEEEEEEEEEEEE");
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Second TextField
                              Container(
                                width: MediaQuery.of(context).size.width * 0.38,
                                height: MediaQuery.of(context).size.height * 0.11,
                                margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(MediaQuery.of(context).size.width * 0.02),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    MediaQuery.of(context).size.width * 0.02,
                                    0,
                                    MediaQuery.of(context).size.width * 0.02,
                                    0,
                                  ),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        // Icon
                                        SizedBox(
                                          height: MediaQuery.of(context).size.height * 0.06,
                                          width: MediaQuery.of(context).size.height * 0.06,
                                          child: Image.asset(
                                            'assets/email.png',
                                          ),
                                        ),

                                        // TextField
                                        Expanded(
                                          child: TextField(
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w800,
                                              color: Color.fromRGBO(50, 50, 50, 1),
                                              overflow: TextOverflow.ellipsis,
                                            ),

                                            focusNode: _focusNode2,
                                            controller: _secondController,
                                            readOnly: true,
                                            showCursor: true,
                                            enableInteractiveSelection: true,
                                            maxLines: 1,
                                            textAlign: TextAlign.left,
                                            textAlignVertical: TextAlignVertical.center,

                                            decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                iconColor: Colors.white,
                                                focusColor: Colors.white,
                                                hoverColor: Colors.white,
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Colors.white,
                                                  ),
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(MediaQuery.of(context).size.width * 0.02),
                                                  ),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Colors.white,
                                                  ),
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(MediaQuery.of(context).size.width * 0.02),
                                                  ),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Colors.white,
                                                  ),
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(MediaQuery.of(context).size.width * 0.02),
                                                  ),
                                                ),
                                                hintText: languagesTextsFile.texts["login_page_mail"],
                                                hintStyle: const TextStyle(
                                                  color: Color.fromRGBO(147, 147, 147, 1),
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 19,
                                                )
                                            ),

                                            onTap: () {
                                              setState(() {
                                                _isFirstControllerActive = false;
                                                newContactPageState.value = true;

                                              });
                                              print("TOUCHEEEEEEEEEEEEEEE");
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Phone
                              Container(
                                width: MediaQuery.of(context).size.width * 0.38,
                                height: MediaQuery.of(context).size.height * 0.11,
                                margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(MediaQuery.of(context).size.width * 0.02),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    MediaQuery.of(context).size.width * 0.02,
                                    0,
                                    MediaQuery.of(context).size.width * 0.02,
                                    0,
                                  ),
                                  child: Row(
                                    children: [
                                      // Icon
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height * 0.06,
                                        width: MediaQuery.of(context).size.height * 0.06,
                                        child: Image.asset(
                                          'assets/phone-call.png',
                                        ),
                                      ),

                                      // Text
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.01),
                                          child: AutoSizeText(
                                            languagesTextsFile.texts["login_page_phone"],
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800,
                                              color: Color.fromRGBO(50, 50, 50, 1),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            maxLines: 1,
                                            minFontSize: 5,
                                            maxFontSize: 20,
                                          ),
                                        )
                                      ),

                                      // Checkbox
                                      Transform.scale(
                                        scale: MediaQuery.of(context).size.width * 0.0025,
                                        child: Checkbox(
                                          value: phone,
                                          shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 60, )),

                                          checkColor: Colors.white,
                                          activeColor: const Color.fromRGBO(50, 50, 50, 1),

                                          onChanged: (value) {
                                            setState(() {
                                              phone = !phone;
                                            });
                                          },
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),

                              // Start Button
                              Container(
                                margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.035),
                                child: AnimatedScale(
                                  scale: _buttonAnimations["START"] == true ? 1.1 : 1.0,
                                  duration: const Duration(milliseconds: 100),
                                  curve: Curves.bounceOut,
                                  child: GestureDetector(
                                    // Animation management
                                    onTapDown: (_) {
                                      setState(() {
                                        _buttonAnimations["START"] = true;
                                      });
                                    },
                                    onTapUp: (_) async {
                                      setState(() {
                                        _buttonAnimations["START"] = false;
                                      });
                                      // BUTTON CODE
                                      if(_firstController.text.isEmpty){
                                        _showGenericPopupOK(languagesTextsFile.texts["login_page_error_first_name"], 1);
                                      }
                                      else if(_secondController.text.isEmpty){
                                        _showGenericPopupOK(languagesTextsFile.texts["login_page_error_mail"], 1);
                                      }
                                      else if(_secondController.text.isNotEmpty && !_secondController.text.contains('@')){
                                        _showGenericPopupOK(languagesTextsFile.texts["login_page_error_form_mail"], 1);
                                      }
                                      else{
                                        // MONTRER LA POP UP AVEC CODE DE VERIFICATION
                                        bool checks = await startChecks();

                                        // SEULEMENT APRES ON AJOUTE A LA DATABASE UNE FOIS QUE LE CODE EST BON
                                        if(checks) {
                                          // Adding in the database
                                          await databaseManager.insertContact(Contact(
                                            first_name: _firstController.text,
                                            last_name: "",
                                            email: _secondController.text,
                                            phone: phone ? null : "1",
                                            priority: 0,
                                            id_contact: 0,
                                          ));
                                          //todo changer de page
                                        }

                                      }

                                    },
                                    onTapCancel: () {
                                      setState(() {
                                        _buttonAnimations["START"] = false;
                                      });
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width * 0.37,
                                      height: MediaQuery.of(context).size.height > 600 ? MediaQuery.of(context).size.width * 0.06 : MediaQuery.of(context).size.width * 0.05,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(30)),
                                        color: Color.fromRGBO(61, 192, 200, 1),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.01),
                                      child: Center(
                                        child: AutoSizeText(
                                          languagesTextsFile.texts["login_page_start"],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 18,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          minFontSize: 5,
                                          maxFontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.012),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // France
                              AnimatedScale(
                                scale: _buttonAnimations["FR"]! ? 1.1 : 1.0,
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.bounceOut,
                                child: GestureDetector(
                                  // Animation management
                                  onTapDown: (_) {
                                    setState(() {
                                      _buttonAnimations["FR"] = true;
                                    });
                                  },
                                  onTapUp: (_) {
                                    setState(() {
                                      _buttonAnimations["FR"] = false;
                                    });
                                    // BUTTON CODE
                                    print("FRAAAAAAAAAAAANCE");
                                    language = "fr";
                                    ttsHandler.setVoiceFrOrNl(language, 'female');
                                    languagesTextsFile.setNewLanguage(language);

                                  },
                                  onTapCancel: () {
                                    setState(() {
                                      _buttonAnimations["FR"] = false;
                                    });
                                  },

                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.03, 0, MediaQuery.of(context).size.height * 0.03),
                                    child: Image.asset(
                                      "assets/france.png",
                                      height: MediaQuery.of(context).size.width * 0.06,
                                      width: MediaQuery.of(context).size.width * 0.06,
                                    ),
                                  ),
                                ),
                              ),

                              // Netherlands
                              AnimatedScale(
                                scale: _buttonAnimations["NL"]! ? 1.1 : 1.0,
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.bounceOut,
                                child: GestureDetector(
                                  // Animation management
                                  onTapDown: (_) {
                                    setState(() {
                                      _buttonAnimations["NL"] = true;
                                    });
                                  },
                                  onTapUp: (_) {
                                    setState(() {
                                      _buttonAnimations["NL"] = false;
                                    });
                                    // BUTTON CODE
                                    print("NETHERLANDSSSSS");
                                    setState(() {
                                      language = "nl";
                                      ttsHandler.setVoiceFrOrNl(language, 'female');
                                      languagesTextsFile.setNewLanguage(language);
                                    });

                                  },
                                  onTapCancel: () {
                                    setState(() {
                                      _buttonAnimations["NL"] = false;
                                    });
                                  },

                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.
                                    of(context).size.height * 0.03),
                                    child: Image.asset(
                                      "assets/pays-bas.png",
                                      height: MediaQuery.of(context).size.width * 0.06,
                                      width: MediaQuery.of(context).size.width * 0.06,
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),


                      ],
                    ),
                  ),

                  // Second Part
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
                          child: Center(
                            child: AutoSizeText(
                              languagesTextsFile.texts["login_page_text"],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                              maxFontSize: 20,
                              minFontSize: 5,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.325,
                              child: Image.asset(
                                'assets/aviq.jpg',
                                scale: MediaQuery.of(context).size.width / 1025.64,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            }
            else{
              return Column(
                children: [
                  // First Part
                  Expanded(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Row(
                        children: [
                          // Logo ParkinsonCom
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.35,
                                child: Image.asset(
                                  'assets/logo-Interreg.png',
                                  scale: MediaQuery.of(context).size.width / 1025.64,
                                ),
                              ),
                            ),
                          ),
                    
                          // TextField
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.38,
                                    height: MediaQuery.of(context).size.height * 0.11,
                                    margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(MediaQuery.of(context).size.width * 0.02),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        MediaQuery.of(context).size.width * 0.02,
                                        0,
                                        MediaQuery.of(context).size.width * 0.02,
                                        0,
                                      ),
                                      child: Center(
                                        child: Row(
                                          children: [
                                            // Icon
                                            SizedBox(
                                              height: MediaQuery.of(context).size.height * 0.06,
                                              width: MediaQuery.of(context).size.height * 0.06,
                                              child: Image.asset(
                                                _isFirstControllerActive ? 'assets/padlock.png' : 'assets/email.png',
                                              ),
                                            ),
                    
                                            // TextField
                                            Expanded(
                                              child: TextField(
                                                style: const TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w800,
                                                  color: Color.fromRGBO(50, 50, 50, 1),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                    
                                                focusNode: _focusNode,
                                                controller: _isFirstControllerActive ? _firstController : _secondController,
                                                readOnly: true,
                                                showCursor: true,
                                                enableInteractiveSelection: true,
                                                maxLines: 1,
                                                textAlign: TextAlign.left,
                                                textAlignVertical: TextAlignVertical.center,
                    
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    iconColor: Colors.white,
                                                    focusColor: Colors.white,
                                                    hoverColor: Colors.white,
                                                    border: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                        color: Colors.white,
                                                      ),
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(MediaQuery.of(context).size.width * 0.02),
                                                      ),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                        color: Colors.white,
                                                      ),
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(MediaQuery.of(context).size.width * 0.02),
                                                      ),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                        color: Colors.white,
                                                      ),
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(MediaQuery.of(context).size.width * 0.02),
                                                      ),
                                                    ),
                                                    hintText: _isFirstControllerActive ? languagesTextsFile.texts["login_page_first_name"] : languagesTextsFile.texts["login_page_mail"],
                                                    hintStyle: const TextStyle(
                                                      color: Color.fromRGBO(147, 147, 147, 1),
                                                      fontStyle: FontStyle.italic,
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 19,
                                                    )
                                                ),
                    
                                                onTap: () {
                                                  setState(() {
                                                    newContactPageState.value = true;
                    
                                                  });
                                                  print("TOUCHEEEEEEEEEEEEEEE");
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                    
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Keyboard
                  Builder(builder: (context) {
                    if(_isFirstControllerActive){
                      return CustomKeyboard(controller: _firstController, textPredictions: isConnected, forcedPredictionsOff: true, );
                    }
                    else {
                      return CustomKeyboard(controller: _secondController, textPredictions: isConnected, forcedPredictionsOff: true, forcedLowerCase: true,);
                    }
                  },)
                ],
              );
            }

          },));
  }


  /// Generic popup to display a specific [text] from the JSON and with an "OK" button
  void _showGenericPopupOK(String text, int nbPopContext) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          double screenHeight = MediaQuery.of(context).size.height;
          double screenWidth = MediaQuery.of(context).size.width;
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.black87,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: screenWidth * 0.95, height: screenHeight * 0.15),
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: screenHeight * 0.2),
                    //Button to quit
                    AnimatedScale(
                      scale: _buttonAnimations["POPUP OK"]! ? 1.1 : 1.0,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.bounceOut,
                      child: GestureDetector(
                        // Animation management
                        onTapDown: (_) {
                          setState(() {
                            _buttonAnimations["POPUP OK"] = true;
                          });
                        },
                        onTapUp: (_) {
                          setState(() {
                            _buttonAnimations["POPUP OK"] = false;
                          });
                          // BUTTON CODE
                          int i = 0;
                          for(i; i < nbPopContext; i += 1){
                            Navigator.pop(context);
                          }
                        },
                        onTapCancel: () {
                          setState(() {
                            _buttonAnimations["POPUP OK"] = false;
                          });
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(60)),
                            color: Colors.lightGreen,
                          ),
                          padding: EdgeInsets.fromLTRB(screenWidth * 0.1, 8.0, screenWidth * 0.1, 8.0),
                          child: Text(
                            languagesTextsFile.texts["pop_up_ok"]!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                  ],
                ),
              ),
            );
          });
        });
  }
}
