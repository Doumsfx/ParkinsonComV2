// User Settings Page
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2


import 'package:flutter/material.dart';
import 'package:parkinson_com_v2/models/database/contact.dart';
import 'package:parkinson_com_v2/views/customWidgets/customTextField.dart';
import 'package:parkinson_com_v2/views/customWidgets/customTitle.dart';
import 'package:parkinson_com_v2/models/variables.dart';
import 'package:parkinson_com_v2/views/keyboards/keyboard.dart';


class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({super.key});

  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  // Useful variables
  final Map<String, bool> _buttonAnimations = {
    "BACK ARROW": false,
    "HELP": false,
    "HOME": false,
    "SAVE": false,
  };
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _secondController = TextEditingController();
  final TextEditingController _thirdController = TextEditingController();
  final List<bool> _whichControllerIsActive = [false, false, false];
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  bool phone = wantPhoneFonctionnality;
  late Contact currentInfo;
  bool isPhoneOK = true;

  /// Function to initialise our variables
  Future<void> initialisation() async {
    // Retrieve the current information
    currentInfo = await databaseManager.retrieveContactFromId(0);

    // Update the UI
    setState(() {
      if(currentInfo.first_name != ""){
        _firstController.text = currentInfo.first_name;
      }
      _secondController.text = currentInfo.last_name;
      if(currentInfo.email != null){
        _thirdController.text = currentInfo.email!;
      }
    });

  }

  @override
  void initState() {
    super.initState();

    initialisation();

    userSettingsPageState.value = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
      FocusScope.of(context).requestFocus(_focusNode2);
      FocusScope.of(context).requestFocus(_focusNode3);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(29, 52, 83, 1),
        body: ValueListenableBuilder(
            valueListenable: userSettingsPageState,
            builder: (context, value, child) {
              if(!value){
                return Stack(
                  children: [
                    // The page
                    Column(
                      children: [
                        // First part
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title and buttons
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // First part
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Back Arrow
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.013, MediaQuery.of(context).size.width * 0.02, 0),
                                      child: AnimatedScale(
                                        scale: _buttonAnimations["BACK ARROW"]! ? 1.1 : 1.0,
                                        duration: const Duration(milliseconds: 100),
                                        curve: Curves.bounceOut,
                                        child: GestureDetector(
                                          onTapDown: (_) {
                                            setState(() {
                                              _buttonAnimations["BACK ARROW"] = true;
                                            });
                                          },
                                          onTapUp: (_) {
                                            setState(() {
                                              _buttonAnimations["BACK ARROW"] = false;
                                            });

                                            Navigator.pop(context);

                                          },
                                          onTapCancel: () {
                                            setState(() {
                                              _buttonAnimations["BACK ARROW"] = false;
                                            });
                                          },
                                          child: Image.asset(
                                            "assets/fleche.png",
                                            height: MediaQuery.of(context).size.width * 0.05,
                                            width: MediaQuery.of(context).size.width * 0.07,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Title
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.835,
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.19, MediaQuery.of(context).size.height / 16, 0, MediaQuery.of(context).size.height * 0.07),
                                        child: CustomTitle(
                                          text: languagesTextsFile.texts["user_settings_title"]!,
                                          image: 'assets/profile-user.png',
                                          imageScale: 1,
                                          backgroundColor: const Color.fromRGBO(244, 107, 55, 1),
                                          textColor: Colors.white,
                                          containerWidth: MediaQuery.of(context).size.width * 0.50,
                                          containerHeight: MediaQuery.of(context).size.height * 0.12,
                                          containerPadding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.07, MediaQuery.of(context).size.height * 0.01, MediaQuery.of(context).size.width * 0.02, 0),
                                          fontSize: 100,
                                          circleSize: MediaQuery.of(context).size.height * 0.1875,
                                          circlePositionedLeft: MediaQuery.of(context).size.height * 0.0625 * -1,
                                          fontWeight: FontWeight.w600,
                                          alignment: const Alignment(0.07, 0),

                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // Buttons at the right
                            Container(
                              margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.012),
                              child: Column(
                                children: [
                                  // Help Button
                                  AnimatedScale(
                                    scale: _buttonAnimations["HELP"]! ? 1.1 : 1.0,
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.bounceOut,
                                    child: GestureDetector(
                                      // Animation management
                                      onTapDown: (_) {
                                        setState(() {
                                          _buttonAnimations["HELP"] = true;
                                        });
                                      },
                                      onTapUp: (_) {
                                        setState(() {
                                          _buttonAnimations["HELP"] = false;
                                        });
                                        // Button Code
                                        print("HELLLLLLLLLLP");
                                        emergencyRequest.sendEmergencyRequest(context);
                                      },
                                      onTapCancel: () {
                                        setState(() {
                                          _buttonAnimations["HELP"] = false;
                                        });
                                      },

                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.03, 0, MediaQuery.of(context).size.height * 0.03),
                                        child: Image.asset(
                                          "assets/helping_icon.png",
                                          height: MediaQuery.of(context).size.width * 0.06,
                                          width: MediaQuery.of(context).size.width * 0.06,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Home Button
                                  AnimatedScale(
                                    scale: _buttonAnimations["HOME"]! ? 1.1 : 1.0,
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.bounceOut,
                                    child: GestureDetector(
                                      onTapDown: (_) {
                                        setState(() {
                                          _buttonAnimations["HOME"] = true;
                                        });
                                      },
                                      onTapUp: (_) {
                                        setState(() {
                                          _buttonAnimations["HOME"] = false;
                                        });
                                        // Button Code
                                        Navigator.popUntil(
                                          context,
                                              (route) => route.isFirst,
                                        );
                                      },
                                      onTapCancel: () {
                                        setState(() {
                                          _buttonAnimations["HOME"] = false;
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.height * 0.03),
                                        child: Image.asset(
                                          "assets/home.png",
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

                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // First TextField
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  height: MediaQuery.of(context).size.height * 0.12,
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
                                      child: CustomTextField(
                                        context: context,
                                        width: MediaQuery.of(context).size.width * 0.5,
                                        maxFontSize: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.05 : MediaQuery.of(context).size.height * 0.06,
                                        style: TextStyle(
                                          fontSize: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.05 : MediaQuery.of(context).size.height * 0.06,
                                          fontWeight: FontWeight.w800,
                                          color: const Color.fromRGBO(50, 50, 50, 1),
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                        focusNode: _focusNode,
                                        controller: _firstController,
                                        readOnly: true,
                                        showCursor: true,
                                        enableInteractiveSelection: true,
                                        maxLines: 1,
                                        textAlign: TextAlign.left,
                                        textAlignVertical: TextAlignVertical.bottom,

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
                                            hintText: languagesTextsFile.texts["new_contact_first_name"],
                                            hintStyle: TextStyle(
                                              color: const Color.fromRGBO(147, 147, 147, 1),
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w700,
                                              fontSize: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.05 : MediaQuery.of(context).size.height * 0.06,
                                            )
                                        ),

                                        onTap: () {
                                          setState(() {
                                            userSettingsPageState.value = true;
                                            _whichControllerIsActive[0] = true;
                                            _whichControllerIsActive[1] = false;
                                            _whichControllerIsActive[2] = false;

                                          });
                                          print("TOUCHEEEEEEEEEEEEEEE");
                                        },
                                      ),
                                    ),
                                  ),
                                ),

                                // Second TextField
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  height: MediaQuery.of(context).size.height * 0.12,
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
                                      child: CustomTextField(
                                        context: context,
                                        width: MediaQuery.of(context).size.width * 0.5,
                                        maxFontSize: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.05 : MediaQuery.of(context).size.height * 0.06,
                                        style: TextStyle(
                                          fontSize: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.05 : MediaQuery.of(context).size.height * 0.06,
                                          fontWeight: FontWeight.w800,
                                          color: const Color.fromRGBO(50, 50, 50, 1),
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                        focusNode: _focusNode2,
                                        controller: _secondController,
                                        readOnly: true,
                                        showCursor: true,
                                        enableInteractiveSelection: true,
                                        maxLines: 1,
                                        textAlign: TextAlign.left,
                                        textAlignVertical: TextAlignVertical.bottom,

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
                                            hintText: languagesTextsFile.texts["new_contact_last_name"],
                                            hintStyle: TextStyle(
                                              color: const Color.fromRGBO(147, 147, 147, 1),
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w700,
                                              fontSize: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.05 : MediaQuery.of(context).size.height * 0.06,
                                            )
                                        ),

                                        onTap: () {
                                          setState(() {
                                            userSettingsPageState.value = true;
                                            _whichControllerIsActive[0] = false;
                                            _whichControllerIsActive[1] = true;
                                            _whichControllerIsActive[2] = false;
                                          });
                                          print("TOUCHEEEEEEEEEEEEEEE");
                                        },
                                      ),
                                    ),
                                  ),
                                ),

                                // Third TextField
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  height: MediaQuery.of(context).size.height * 0.12,
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
                                      child: CustomTextField(
                                        context: context,
                                        width: MediaQuery.of(context).size.width * 0.5,
                                        maxFontSize: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.05 : MediaQuery.of(context).size.height * 0.06,
                                        style: TextStyle(
                                          fontSize: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.05 : MediaQuery.of(context).size.height * 0.06,
                                          fontWeight: FontWeight.w800,
                                          color: const Color.fromRGBO(50, 50, 50, 1),
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                        focusNode: _focusNode3,
                                        controller: _thirdController,
                                        readOnly: true,
                                        showCursor: true,
                                        enableInteractiveSelection: true,
                                        maxLines: 1,
                                        textAlign: TextAlign.left,
                                        textAlignVertical: TextAlignVertical.bottom,

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
                                            hintText: languagesTextsFile.texts["new_contact_mail"],
                                            hintStyle: TextStyle(
                                              color: const Color.fromRGBO(147, 147, 147, 1),
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w700,
                                              fontSize: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.05 : MediaQuery.of(context).size.height * 0.06,
                                            )
                                        ),

                                        onTap: () {
                                          setState(() {
                                            userSettingsPageState.value = true;
                                            _whichControllerIsActive[0] = false;
                                            _whichControllerIsActive[1] = false;
                                            _whichControllerIsActive[2] = true;
                                          });
                                          print("TOUCHEEEEEEEEEEEEEEE");
                                        },
                                      ),
                                    ),
                                  ),
                                ),

                                // Phone functionality
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  height: MediaQuery.of(context).size.height * 0.12,
                                  margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.465),
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
                                                  child: Text(
                                                    languagesTextsFile.texts["login_page_phone"],
                                                    style: TextStyle(
                                                      fontSize: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.05 : MediaQuery.of(context).size.height * 0.06,
                                                      fontWeight: FontWeight.w800,
                                                      color: const Color.fromRGBO(50, 50, 50, 1),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    maxLines: 1,
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )

                      ],
                    ),

                    // Save Icon
                    Positioned(
                      bottom: MediaQuery.of(context).size.width * 0.02,
                      right: MediaQuery.of(context).size.width * 0.02,
                      child: AnimatedScale(
                        scale: _buttonAnimations["SAVE"]! ? 1.1 : 1.0,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.bounceOut,
                        child: GestureDetector(
                          onTapDown: (_) {
                            setState(() {
                              _buttonAnimations["SAVE"] = true;
                            });
                          },
                          onTapUp: (_) {
                            setState(() {
                              _buttonAnimations["SAVE"] = false;
                            });
                            // Button Code
                            print("SAVEEEEEEEEEEEEEEEEE");

                            // D AILLEURS JE CROIS QUE CES POP UP ONT LES A DEJA POUR LA LOGIN PAGE (tu peux effacer ce commentaire)
                            
                            if(_firstController.text.isEmpty){
                              // TODO pop up qui dis qu'on ne peux pas laisser le nom vide
                            }
                            else if(_thirdController.text.isEmpty){
                              // TODO pop up qui dis qu'on ne peux pas laisser l'adresse mail vide
                            }
                            else if(_thirdController.text.isNotEmpty && !_thirdController.text.contains("@")){
                              // TODO pop up qui dis qu'on doit rentrer une adresse email valide
                            }
                            else if(_thirdController.text.isNotEmpty && _thirdController.text != currentInfo.email){
                              // TODO pop up avec code verif qu'on envoie par mail
                            }
                            if(phone && !wantPhoneFonctionnality){

                              isPhoneOK = false;

                              // TODO truc de verif de SIM + autorisations

                              // If everything is ok
                              isPhoneOK = true;

                            }
                            if(isPhoneOK){
                              // Updating the info of the user
                              databaseManager.updateContact(
                                Contact(
                                  first_name: _firstController.text,
                                  last_name: _secondController.text,
                                  email: _thirdController.text,
                                  id_contact: 0,
                                  priority: currentInfo.priority,
                                )
                              );
                              wantPhoneFonctionnality = phone;

                              // TODO pop up qui dis que les informations ont bien été enregistré

                              Navigator.pop(context);

                            }

                          },
                          onTapCancel: () {
                            setState(() {
                              _buttonAnimations["SAVE"] = false;
                            });
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.width * 0.085,
                            width: MediaQuery.of(context).size.width * 0.085,
                            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.015),
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(74, 239, 221, 1),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              "assets/save.png",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              else{
                return Column(
                  children: [
                    // TextField
                    Expanded(
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.height * 0.12,
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
                                child: CustomTextField(
                                  context: context,
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  maxFontSize: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.05 : MediaQuery.of(context).size.height * 0.06,
                                  style: TextStyle(
                                    fontSize: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.05 : MediaQuery.of(context).size.height * 0.06,
                                    fontWeight: FontWeight.w800,
                                    color: const Color.fromRGBO(50, 50, 50, 1),
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  focusNode: _whichControllerIsActive[0] ? _focusNode : _whichControllerIsActive[1] ? _focusNode2 : _focusNode3,
                                  controller: _whichControllerIsActive[0] ? _firstController : _whichControllerIsActive[1] ? _secondController : _thirdController,
                                  readOnly: true,
                                  showCursor: true,
                                  enableInteractiveSelection: true,
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                  textAlignVertical: TextAlignVertical.bottom,

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
                                      hintText: _whichControllerIsActive[0] ? languagesTextsFile.texts["new_contact_first_name"] : _whichControllerIsActive[1] ? languagesTextsFile.texts["new_contact_last_name"] : languagesTextsFile.texts["new_contact_mail"],
                                      hintStyle: TextStyle(
                                        color: const Color.fromRGBO(147, 147, 147, 1),
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w700,
                                        fontSize: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.05 : MediaQuery.of(context).size.height * 0.06,
                                      )
                                  ),

                                  onTap: () {
                                    setState(() {

                                    });
                                    print("TOUCHEEEEEEEEEEEEEEE");
                                  },
                                ),
                              ),
                            ),
                          ),
                        )
                    ),

                    // Keyboard
                    CustomKeyboard(controller: _whichControllerIsActive[0] ? _firstController : _whichControllerIsActive[1] ? _secondController : _thirdController, textPredictions: isConnected, forcedPredictionsOff: true, forcedLowerCase: _whichControllerIsActive[2] ? true : false,),

                  ],
                );
              }
            },
        )
    );
  }
}
