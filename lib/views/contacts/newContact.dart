// New Contact Page
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkinson_com_v2/views/customWidgets/customTextField.dart';
import 'package:parkinson_com_v2/views/keyboards/keyboard.dart';
import 'package:parkinson_com_v2/views/keyboards/keyboardPhoneNumber.dart';
import 'package:parkinson_com_v2/models/database/contact.dart';
import 'package:parkinson_com_v2/models/variables.dart';

import '../../models/popupshandler.dart';


class NewContactPage extends StatefulWidget {
  final int idContact;
  const NewContactPage({super.key, this.idContact = -1});

  @override
  State<NewContactPage> createState() => _NewContactPageState();
}

class _NewContactPageState extends State<NewContactPage> {
  // Useful variables
  final Map<String, bool> _buttonAnimations = {
    "BACK ARROW": false,
    "HELP": false,
    "HOME": false,
    "POPUP NO": false,
    "POPUP YES": false,
    "POPUP OK": false,
    "ADD": false,
  };

  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _secondController = TextEditingController();
  final TextEditingController _thirdController = TextEditingController();
  late Contact contact;
  bool mail = false;
  bool phone = false;
  final List<bool> _whichControllerIsActive = [false, false, false];

  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();

  Future<void> initialisation() async {
    // If it's not a new contact, we adjust the interface
    if(widget.idContact != -1){
      // We retrieve all the contacts from the database
      contact = await databaseManager.retrieveContactFromId(widget.idContact);
      setState(() {});

      // We update the interface with the information of the contact
      setState(() {
        _firstController.text = contact.first_name;
        _secondController.text = contact.last_name;
        if(contact.email != null){
          _thirdController.text = contact.email!;
          mail = true;
        }
        else{
          _thirdController.text = contact.phone!;
          phone = true;
        }
      });
    }

    else{
      setState(() {
        mail = true;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    // Initialisation of our variables
    initialisation();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
      FocusScope.of(context).requestFocus(_focusNode2);
      FocusScope.of(context).requestFocus(_focusNode3);
    });

  }

  @override
  void dispose() {
    _focusNode.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(29, 52, 83, 1),
        body: ValueListenableBuilder(
          valueListenable: newContactPageState,
          builder: (context, value, child) {
            if(!value){
              return Stack(
                children: [
                  // The entire page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back Arrow
                      SizedBox(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.013, 0, 0),
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

                                // Button code
                                Navigator.pop(
                                  context,
                                );
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
                      ),

                      // The middle column
                      Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Title
                              Container(
                                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
                                child: Text(
                                  languagesTextsFile.texts["new_contact_title"],
                                  style: GoogleFonts.josefinSans(
                                    color: Colors.white,
                                    fontSize: 35,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              // Subtitle
                              Container(
                                margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.03, 0, MediaQuery.of(context).size.height * 0.05),
                                child: Text(
                                  hasSimCard && wantPhoneFonctionnality ? languagesTextsFile.texts["new_contact_subtitle2"] : languagesTextsFile.texts["new_contact_subtitle"],
                                  style: GoogleFonts.josefinSans(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              // First TextField
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
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
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    maxFontSize: 22,
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
                                          hintText: languagesTextsFile.texts["new_contact_first_name"],
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
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: MediaQuery.of(context).size.height * 0.12,
                                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
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
                                      width: MediaQuery.of(context).size.width * 0.4,
                                      maxFontSize: 22,
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
                                          hintText: languagesTextsFile.texts["new_contact_last_name"],
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

                              // Choice between mail and phone
                              hasSimCard && wantPhoneFonctionnality
                                  ? SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.width * 0.065,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        // Mail
                                        Text(
                                          languagesTextsFile.texts["new_contact_mail"],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),

                                        // Mail Checkbox
                                        Transform.scale(
                                          scale: MediaQuery.of(context).size.width * 0.0025,
                                          child: Checkbox(
                                            value: mail,
                                            shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 60, )),

                                            checkColor: Colors.indigo,
                                            activeColor: const Color.fromRGBO(240, 242, 239, 1),

                                            onChanged: (value) {
                                              setState(() {
                                                phone = false;
                                                mail = true;
                                                _thirdController.clear();
                                              });
                                            },
                                          ),
                                        ),

                                        // Phone
                                        Text(
                                          languagesTextsFile.texts["new_contact_phone"],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),

                                        // Phone Checkbox
                                        Transform.scale(
                                          scale: MediaQuery.of(context).size.width * 0.0025,
                                          child: Checkbox(
                                            value: phone,
                                            shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 60, )),

                                            checkColor: Colors.indigo,
                                            activeColor: const Color.fromRGBO(240, 242, 239, 1),

                                            onChanged: (value) {
                                              setState(() {
                                                phone = true;
                                                mail = false;
                                                _thirdController.clear();
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  : SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.width * 0.065,
                                  ),

                              // Third TextField
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: MediaQuery.of(context).size.height * 0.12,
                                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.002),
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
                                      width: MediaQuery.of(context).size.width * 0.4,
                                      maxFontSize: 22,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        color: Color.fromRGBO(50, 50, 50, 1),
                                        overflow: TextOverflow.ellipsis,
                                      ),

                                      focusNode: _focusNode3,
                                      controller: _thirdController,
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
                                          hintText: mail ? languagesTextsFile.texts["new_contact_hint_mail"] : languagesTextsFile.texts["new_contact_hint_phone"],
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

                              // Add Button
                              Container(
                                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02,),
                                child: AnimatedScale(
                                  scale: _buttonAnimations["ADD"] == true ? 1.1 : 1.0,
                                  duration: const Duration(milliseconds: 100),
                                  curve: Curves.bounceOut,
                                  child: GestureDetector(
                                    // Animation management
                                    onTapDown: (_) {
                                      setState(() {
                                        _buttonAnimations["ADD"] = true;
                                      });
                                    },
                                    onTapUp: (_) async {
                                      setState(() {
                                        _buttonAnimations["ADD"] = false;
                                      });
                                      // Button Code
                                      if(_secondController.text.isEmpty){
                                        Popups.showPopupOk(context, text: languagesTextsFile.texts["new_contact_last_name_error"], textOk: languagesTextsFile.texts["pop_up_ok"], functionOk: Popups.functionToQuit);
                                      }
                                      else if(_thirdController.text.isNotEmpty && mail && !_thirdController.text.contains("@")){
                                        Popups.showPopupOk(context, text: languagesTextsFile.texts["new_contact_mail_error_form"], textOk: languagesTextsFile.texts["pop_up_ok"], functionOk: Popups.functionToQuit);
                                      }
                                      else if(_thirdController.text.isEmpty && mail){
                                        Popups.showPopupOk(context, text: languagesTextsFile.texts["new_contact_mail_error"], textOk: languagesTextsFile.texts["pop_up_ok"], functionOk: Popups.functionToQuit);
                                      }
                                      else if(_thirdController.text.isEmpty && phone){
                                        Popups.showPopupOk(context, text: languagesTextsFile.texts["new_contact_phone_error"], textOk: languagesTextsFile.texts["pop_up_ok"], functionOk: Popups.functionToQuit);
                                      }
                                      else{
                                        if(widget.idContact == -1){
                                          // Adding the contact in the database
                                          await databaseManager.insertContact(Contact(
                                            first_name: _firstController.text,
                                            last_name: _secondController.text,
                                            email: mail ? _thirdController.text : null,
                                            phone: phone ? _thirdController.text : null,
                                            priority: 3,
                                          ));

                                          Popups.showPopupOk(context, text: languagesTextsFile.texts["new_contact_pop_up_success"], textOk: languagesTextsFile.texts["pop_up_ok"], functionOk: Popups.functionToQuit, numberOfExecutionsOk: 2);

                                        }

                                        // Updating the old contact
                                        else{
                                          await databaseManager.updateContact(Contact(
                                            first_name: _firstController.text,
                                            last_name: _secondController.text,
                                            email: mail ? _thirdController.text : null,
                                            phone: phone ? _thirdController.text : null,
                                            priority: contact.priority,
                                            id_contact: widget.idContact,
                                          ));

                                          Navigator.pop(context);
                                        }

                                      }

                                    },
                                    onTapCancel: () {
                                      setState(() {
                                        _buttonAnimations["ADD"] = false;
                                      });
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      height: isThisDeviceATablet ? MediaQuery.of(context).size.width * 0.06 : MediaQuery.of(context).size.width * 0.05,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(30)),
                                        color: Color.fromRGBO(61, 192, 200, 1),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.01),
                                      child: Center(
                                        child: AutoSizeText(
                                          widget.idContact == -1 ? languagesTextsFile.texts["new_contact_add"] : languagesTextsFile.texts["new_contact_modify"] ,
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
                          )
                      ),

                      // Buttons at the right
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.08,
                        child: Container(
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
                      ),
                    ],
                  ),

                  // Text at the left
                  Positioned(
                    left: 0,
                    bottom: MediaQuery.of(context).size.height * 0.38,
                    child: hasSimCard && wantPhoneFonctionnality
                        ? SizedBox(
                      width: MediaQuery.of(context).size.width * 0.29,
                    )
                        : Container(
                      width: MediaQuery.of(context).size.width * 0.26,
                      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
                      child: Text(
                        languagesTextsFile.texts["new_contact_message_left"]!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 6,
                      ),

                    ),
                  ),
                ],
              );
            }
            else{
              return Column(
                children: [
                  // First part
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Space between
                      const Expanded(child: SizedBox()),

                      // Button at the right (Help Button)
                      Container(
                        margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.015),
                        child: AnimatedScale(
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
                      ),
                    ],
                  ),

                  // TextField
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.14,
                    margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.01, MediaQuery.of(context).size.height * 0.04, 0, 0),
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
                          width: MediaQuery.of(context).size.width * 0.95,
                          maxFontSize: 22,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color.fromRGBO(50, 50, 50, 1),
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
                              hintText: _whichControllerIsActive[0] ? languagesTextsFile.texts["new_contact_first_name"] : _whichControllerIsActive[1] ? languagesTextsFile.texts["new_contact_last_name"] : mail ? languagesTextsFile.texts["new_contact_hint_mail"] : languagesTextsFile.texts["new_contact_hint_phone"],
                              hintStyle: const TextStyle(
                                color: Color.fromRGBO(147, 147, 147, 1),
                                fontStyle: FontStyle.italic,
                                fontSize: 22,
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

                  const Expanded(child: SizedBox()),

                  // Keyboard
                  Builder(builder: (context) {
                    if(_whichControllerIsActive[0]){
                      return CustomKeyboard(controller: _firstController, textPredictions: isConnected, forcedPredictionsOff: true,);
                    }
                    else if(_whichControllerIsActive[1]){
                      return CustomKeyboard(controller: _secondController, textPredictions: isConnected, forcedPredictionsOff: true,);
                    }
                    else if(_whichControllerIsActive[2] && mail){
                      return CustomKeyboard(controller: _thirdController, textPredictions: isConnected, forcedPredictionsOff: true, forcedLowerCase: true,);
                    }
                    else{
                      return CustomKeyboardPhoneNumber(controller: _thirdController);
                    }
                  },)

                ],
              );
            }

          },));
  }
}
