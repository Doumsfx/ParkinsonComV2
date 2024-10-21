// List of contacts Page
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:parkinson_com_v2/views/contacts/conversationPage.dart';
import 'package:parkinson_com_v2/views/customWidgets/customImageWithNotification.dart';
import 'package:parkinson_com_v2/views/customWidgets/customTitle.dart';
import 'package:parkinson_com_v2/models/database/contact.dart';
import 'package:parkinson_com_v2/views/contacts/newContact.dart';
import 'package:parkinson_com_v2/models/variables.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../models/popupsHandler.dart';


class ListContactsPage extends StatefulWidget {
  const ListContactsPage({super.key});

  @override
  State<ListContactsPage> createState() => _ListContactsPageState();
}

class _ListContactsPageState extends State<ListContactsPage> {
  // Useful variables
  final Map<String, bool> _buttonAnimations = {
    "BACK ARROW": false,
    "HELP": false,
    "HOME": false,
    "RELAX": false,
    "TOP ARROW": false,
    "BOT ARROW": false,
    "POPUP NO": false,
    "POPUP YES": false,
    "POPUP OK": false,
    "ADD": false,
    "SAVE": false,
  };

  List<Contact> _listContacts = [];
  late List<bool> _contactsAnimations;
  late List<bool> _primaryContacts;
  late List<bool> _secondaryContacts;
  late List<bool> _deleteButtonsAnimations;
  late List<bool> _modifyButtonsAnimations;
  final ScrollController _scrollController = ScrollController();

  /// Function that initialise our variables
  Future<void> initialisation() async {
    // We retrieve all the contacts of the database
    _listContacts = await databaseManager.retrieveContacts();
    setState(() {});
    _contactsAnimations = List.filled(_listContacts.length, false);
    _deleteButtonsAnimations = List.filled(_listContacts.length, false);
    _modifyButtonsAnimations = List.filled(_listContacts.length, false);
    _primaryContacts = List.filled(_listContacts.length, false, growable: true);
    _secondaryContacts = List.filled(_listContacts.length, false, growable: true);

    // Sorting list with first name
    _listContacts.sort((a, b) => a.last_name.compareTo(b.last_name));
    setState(() {});

    // If the list contains only one contact
    if(_listContacts.length == 1){
      await databaseManager.updateContact(Contact(
        first_name: _listContacts[0].first_name,
        last_name: _listContacts[0].last_name,
        email: _listContacts[0].email,
        phone: _listContacts[0].phone,
        priority: 1,
        id_contact: _listContacts[0].id_contact,
      ));

      _primaryContacts[0] = true;
    }
    setState(() {});

    // Updating the lists of priority
    int i = 0;
    for(i; i < _listContacts.length; i += 1){
      if(_listContacts[i].priority == 1){
        _primaryContacts[i] = true;
      }
      else if(_listContacts[i].priority == 2){
        _secondaryContacts[i] = true;
      }
    }
  }

  /// Function to update all values of primaryContacts
  void updateAllPrimaryContacts(bool value) {
    _primaryContacts.fillRange(0, _primaryContacts.length, value);
  }

  /// Function to update all values of secondaryContacts
  void updateAllSecondaryContacts(bool value) {
    _secondaryContacts.fillRange(0, _primaryContacts.length, value);
  }


  @override
  void initState() {
    super.initState();
    // Initialisation of our variables
    initialisation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Used to refresh the UI from the StatefulBuilder
  void _updateParent() {
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(29, 52, 83, 1),
        body: VisibilityDetector(
          key: const Key('ListContacts-key'),
          onVisibilityChanged: (VisibilityInfo info) {
            if(info.visibleFraction > 0) {
              print("callback switched to list contacts");
              smsReceiver.setCallBack(() async {
                if(mounted) {
                  setState(() {
                    print("list");
                  });
                }
              },);
            }
          },
          child: Column(
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

                          // Back Arrow + Texts
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.24,
                              child: Column(
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

                                  // Contacts
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.23,
                                    padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.1, MediaQuery.of(context).size.width * 0.02, 0),
                                    child: Center(
                                      child: Text(
                                        languagesTextsFile.texts["contact_list_contacts"],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: MediaQuery.of(context).size.height * 0.04,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Principal + Secondary
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.21,
                                    margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.1,
                                          child: Center(
                                            child: Text(
                                              languagesTextsFile.texts["contact_list_principal"],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: MediaQuery.of(context).size.height * 0.031,
                                              ),
                                            ),
                                          ),
                                        ),

                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.1,
                                          child: Center(
                                            child: Text(
                                              languagesTextsFile.texts["contact_list_secondary"],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: MediaQuery.of(context).size.height * 0.031,
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  )

                                ],
                              )),

                          // Title
                          Container(
                            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.060, MediaQuery.of(context).size.height / 16, MediaQuery.of(context).size.width * 0.125, 0),
                            child: CustomTitle(
                              text: languagesTextsFile.texts["contact_list_title"]!,
                              image: 'assets/enveloppe.png',
                              imageScale: 0.15,
                              backgroundColor: const Color.fromRGBO(12, 178, 255, 1),
                              textColor: Colors.white,
                              containerWidth: MediaQuery.of(context).size.width * 0.50,
                              containerHeight: MediaQuery.of(context).size.height * 0.12,
                              containerPadding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.height * 0.085, 0, MediaQuery.of(context).size.height * 0.03, 0),
                              circleSize: MediaQuery.of(context).size.height * 0.1875,
                              circlePositionedLeft: MediaQuery.of(context).size.height * 0.1 * -1,
                              fontSize: 50,
                              fontWeight: FontWeight.w600,
                              alignment: const Alignment(-0.2, 0.6),
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
                              // BUTTON CODE
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
                              // BUTTON CODE
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

              // List of contacts
              Expanded(
                child: RawScrollbar(
                  thumbColor: Colors.blue,
                  controller: _scrollController,
                  trackVisibility: true,
                  thumbVisibility: true,
                  thickness: MediaQuery.of(context).size.width * 0.01125,
                  radius: Radius.circular(MediaQuery.of(context).size.width * 0.015),
                  trackColor: const Color.fromRGBO(66, 89, 109, 1),
                  crossAxisMargin: MediaQuery.of(context).size.width * 0.00375,
                  mainAxisMargin: MediaQuery.of(context).size.width * 0.00375,
                  trackRadius: const Radius.circular(20),
                  padding: isThisDeviceATablet ? EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.085, MediaQuery.of(context).size.width * 0.0315, MediaQuery.of(context).size.height * 0.09) : EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.085, MediaQuery.of(context).size.width * 0.027, MediaQuery.of(context).size.height * 0.08),
                  child: Row(
                    children: [
                      // List of contacts
                      Expanded(
                        child: ListView.builder(
                            controller: _scrollController,
                            itemCount: _listContacts.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.21,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // First checkbox
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.1,
                                          height: MediaQuery.of(context).size.width * 0.05,
                                          child: Center(
                                            child:
                                            Container(
                                              margin: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.height * 0.02),
                                              child: Transform.scale(
                                                scale: MediaQuery.of(context).size.width * 0.0025,
                                                child: Checkbox(
                                                  value: _primaryContacts[index],
                                                  shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 60, )),

                                                  checkColor: Colors.indigo,
                                                  activeColor: const Color.fromRGBO(240, 242, 239, 1),

                                                  onChanged: (value) {
                                                    setState(() {
                                                      updateAllPrimaryContacts(false);
                                                      _primaryContacts[index] = true;
                                                      _secondaryContacts[index] = false;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),

                                          ),
                                        ),

                                        // Second Checkbox
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.1,
                                          height: MediaQuery.of(context).size.width * 0.05,
                                          child: Center(
                                            child: Container(
                                              margin: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.height * 0.02),
                                              child: Transform.scale(
                                                scale: MediaQuery.of(context).size.width * 0.0025,
                                                child: Checkbox(
                                                  value: _secondaryContacts[index],
                                                  shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 60, )),

                                                  checkColor: const Color.fromRGBO(61, 191, 199, 1),
                                                  activeColor: const Color.fromRGBO(240, 242, 239, 1),

                                                  onChanged: (value) {
                                                    setState(() {
                                                      if(!_primaryContacts[index]){
                                                        _secondaryContacts[index] = !_secondaryContacts[index];
                                                      }
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          )
                                        ),

                                      ],
                                    ),
                                  ),

                                  // Contact
                                  Expanded(
                                    child: AnimatedScale(
                                      scale: _contactsAnimations[index] ? 1.05 : 1.0,
                                      duration: const Duration(milliseconds: 100),
                                      curve: Curves.bounceOut,
                                      child: GestureDetector(
                                        // Animation management
                                        onTapDown: (_) {
                                          setState(() {
                                            _contactsAnimations[index] = true;
                                          });
                                        },
                                        onTapUp: (_) {
                                          setState(() {
                                            _contactsAnimations[index] = false;
                                          });
                                          // BUTTON CODE
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => NewContactPage(idContact: _listContacts[index].id_contact),
                                              )
                                          ).then((_) => initialisation());
                                        },
                                        onTapCancel: () {
                                          setState(() {
                                            _contactsAnimations[index] = false;
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.height * 0.02),
                                          height: MediaQuery.of(context).size.width * 0.08,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(60)),
                                            color: Color.fromRGBO(61, 191, 199, 1),
                                          ),
                                          child: Container(
                                            width: MediaQuery.of(context).size.width * 0.745,
                                            padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.04, MediaQuery.of(context).size.width * 0.02, MediaQuery.of(context).size.width * 0.02, MediaQuery.of(context).size.width * 0.015),
                                            child: Align(
                                              alignment: const Alignment(-1, 0),
                                              child: AutoSizeText(
                                                "${_listContacts[index].last_name} ${_listContacts[index].first_name} - ${_listContacts[index].email ?? _listContacts[index].phone}",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: MediaQuery.of(context).size.height * 0.0555,
                                                ),
                                                maxLines: 1,
                                                maxFontSize: 50,
                                                minFontSize: 5,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),


                                  // Conversation Buttons
                                  AnimatedScale(
                                    scale: _modifyButtonsAnimations[index] ? 1.1 : 1.0,
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.bounceOut,
                                    child: GestureDetector(
                                      onTapDown: (_) {
                                        setState(() {
                                          _modifyButtonsAnimations[index] = true;
                                        });
                                      },
                                      onTapUp: (_) {
                                        // Button Code
                                        setState(() {
                                          _modifyButtonsAnimations[index] = false;
                                        });

                                        if(_listContacts[index].email != null){
                                          // Can't access to the conversation with a contact saved with an email
                                          Popups.showPopupOk(context, text: languagesTextsFile.texts["pop_up_conversation_cant_with_email"], textOk: languagesTextsFile.texts["pop_up_ok"], functionOk: Popups.functionToQuit);

                                        }
                                        else if(_listContacts[index].phone != null && !wantPhoneFonctionnality){
                                          // Need to activate the phone functionalities
                                          Popups.showPopupOk(context, text: languagesTextsFile.texts["pop_up_conversation_need_phone_functions"], textOk: languagesTextsFile.texts["pop_up_ok"], functionOk: Popups.functionToQuit);
                                        }
                                        else if(_listContacts[index].phone != null && wantPhoneFonctionnality){ //TODO enlever le commentaire une fois qu'on aura fini nos tests
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ConversationPage(contact: _listContacts[index]),
                                              )
                                          ).then((_) => initialisation());
                                        }
                                      },
                                      onTapCancel: () {
                                        setState(() {
                                          _modifyButtonsAnimations[index] = false;
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.01, 0, 0, MediaQuery.of(context).size.height * 0.02),
                                        child: CustomImageWithNotification(
                                          circleSize: MediaQuery.of(context).size.width * 0.062,
                                          circlePadding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.011),
                                          circleColor: const Color.fromRGBO(12, 178, 255, 1),
                                          image: "assets/dialog.png",
                                          nbNotification: 0  ,
                                          sizedBoxWidth: MediaQuery.of(context).size.width * 0.062,
                                          sizedBoxHeight: MediaQuery.of(context).size.width * 0.062,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Delete Contact Buttons
                                  AnimatedScale(
                                    scale: _deleteButtonsAnimations[index] ? 1.1 : 1.0,
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.bounceOut,
                                    child: GestureDetector(
                                      onTapDown: (_) {
                                        setState(() {
                                          _deleteButtonsAnimations[index] = true;
                                        });
                                      },
                                      onTapUp: (_) {
                                        // BUTTON CODE
                                        setState(() {
                                          _deleteButtonsAnimations[index] = false;
                                        });
                                        //Popup to confirm the deletion
                                        Popups.showPopupYesOrNo(context, text: (languagesTextsFile.texts["pop_up_delete_contact"]).toString().replaceAll("...", "\n${_listContacts[index].first_name} ${_listContacts[index].last_name}\n"),
                                            textYes: languagesTextsFile.texts["pop_up_yes"], textNo: languagesTextsFile.texts["pop_up_no"],
                                            functionYes: (p0) async {
                                              await databaseManager.deleteContact(_listContacts[index].id_contact);
                                              // Refresh ui
                                              _listContacts.removeAt(index);
                                              _primaryContacts.removeAt(index);
                                              _secondaryContacts.removeAt(index);
                                              _updateParent();
                                              //Close the popup
                                              Navigator.pop(context);
                                            }, functionNo: Popups.functionToQuit);

                                      },
                                      onTapCancel: () {
                                        setState(() {
                                          _deleteButtonsAnimations[index] = false;
                                        });
                                      },
                                      child: Container(
                                        height: MediaQuery.of(context).size.width * 0.062,
                                        width: MediaQuery.of(context).size.width * 0.062,
                                        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                                        margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.01, 0, MediaQuery.of(context).size.width * 0.01, MediaQuery.of(context).size.height * 0.02),
                                        decoration: const BoxDecoration(
                                          color: Color.fromRGBO(244, 66, 56, 1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.asset(
                                          "assets/trash.png",
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              );
                            }),
                      ),

                      // ScrollWidgets
                      Container(
                        margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.02),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Top Arrow
                            AnimatedScale(
                              scale: _buttonAnimations["TOP ARROW"]! ? 1.1 : 1.0,
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.bounceOut,
                              child: GestureDetector(
                                // Animation management
                                onTap: () {
                                  _scrollController.animateTo(
                                    _scrollController.offset - 120,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeIn,
                                  );
                                },

                                onLongPress: () {
                                  _scrollController.animateTo(
                                    _scrollController.position.minScrollExtent,
                                    duration: const Duration(milliseconds: 1),
                                    curve: Curves.easeIn,
                                  );
                                },

                                onTapDown: (_) {
                                  setState(() {
                                    _buttonAnimations["TOP ARROW"] = true;
                                  });
                                },

                                onTapUp: (_) {
                                  setState(() {
                                    _buttonAnimations["TOP ARROW"] = false;
                                  });
                                },

                                onLongPressEnd: (_) {
                                  setState(() {
                                    _buttonAnimations["TOP ARROW"] = false;
                                  });
                                },

                                child: Container(
                                  width: MediaQuery.of(context).size.height * 0.07,
                                  height: MediaQuery.of(context).size.height * 0.07,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.01),
                                    color: const Color.fromRGBO(101, 72, 254, 1),
                                  ),
                                  child: Transform.rotate(
                                    angle: 1.5708,
                                    child: Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      color: Colors.white,
                                      size: MediaQuery.of(context).size.height * 0.063,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Container for when the scrollbar is empty
                            Expanded(
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.01875,
                                  margin: isThisDeviceATablet ? EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.01, 0, MediaQuery.of(context).size.height * 0.014) : EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.01, 0, MediaQuery.of(context).size.height * 0.011),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color.fromRGBO(66, 89, 109, 1),
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.00375),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.blue,
                                    ),
                                  ),
                                )),

                            // Bot Arrow
                            AnimatedScale(
                              scale: _buttonAnimations["BOT ARROW"]! ? 1.1 : 1.0,
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.bounceOut,
                              child: GestureDetector(
                                // Animation management
                                onTap: () {
                                  _scrollController.animateTo(
                                    _scrollController.offset + 120,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeIn,
                                  );
                                },

                                onLongPress: () {
                                  _scrollController.animateTo(
                                    _scrollController.position.maxScrollExtent,
                                    duration: const Duration(milliseconds: 1),
                                    curve: Curves.easeIn,
                                  );
                                },

                                onTapDown: (_) {
                                  setState(() {
                                    _buttonAnimations["BOT ARROW"] = true;
                                  });
                                },

                                onTapUp: (_) {
                                  setState(() {
                                    _buttonAnimations["BOT ARROW"] = false;
                                  });
                                },

                                onLongPressEnd: (_) {
                                  setState(() {
                                    _buttonAnimations["BOT ARROW"] = false;
                                  });
                                },

                                child: Container(
                                  width: MediaQuery.of(context).size.height * 0.07,
                                  height: MediaQuery.of(context).size.height * 0.07,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.01),
                                    color: const Color.fromRGBO(101, 72, 254, 1),
                                  ),
                                  child: Transform.rotate(
                                    angle: -1.5708,
                                    child: Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      color: Colors.white,
                                      size: MediaQuery.of(context).size.height * 0.063,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Add button
                  Container(
                    margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.02, 0, MediaQuery.of(context).size.height * 0.025),
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
                          // BUTTON CODE
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NewContactPage(),
                              )
                          ).then((_) => initialisation());

                        },
                        onTapCancel: () {
                          setState(() {
                            _buttonAnimations["ADD"] = false;
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.width * 0.06,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            color: Color.fromRGBO(61, 192, 200, 1),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.01),
                          child: Center(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                              child: Center(
                                child: AutoSizeText(
                                  languagesTextsFile.texts["contact_list_add"],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 50,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  minFontSize: 5,
                                  maxFontSize: 50,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Save button
                  Container(
                    margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.02, 0, MediaQuery.of(context).size.height * 0.025),
                    child: AnimatedScale(
                      scale: _buttonAnimations["SAVE"] == true ? 1.1 : 1.0,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.bounceOut,
                      child: GestureDetector(
                        // Animation management
                        onTapDown: (_) {
                          setState(() {
                            _buttonAnimations["SAVE"] = true;
                          });
                        },
                        onTapUp: (_) async {
                          setState(() {
                            _buttonAnimations["SAVE"] = false;
                          });
                          // BUTTON CODE


                          if(_listContacts.isNotEmpty){
                            int i = 0;
                            for(i; i < _listContacts.length; i += 1){
                              if(_primaryContacts[i]){
                                await databaseManager.updateContact(Contact(
                                  first_name: _listContacts[i].first_name,
                                  last_name: _listContacts[i].last_name,
                                  phone: _listContacts[i].phone,
                                  email: _listContacts[i].email,
                                  priority: 1,
                                  id_contact: _listContacts[i].id_contact,
                                )

                                );
                              }

                              else if(_secondaryContacts[i]){
                                await databaseManager.updateContact(Contact(
                                  first_name: _listContacts[i].first_name,
                                  last_name: _listContacts[i].last_name,
                                  phone: _listContacts[i].phone,
                                  email: _listContacts[i].email,
                                  priority: 2,
                                  id_contact: _listContacts[i].id_contact,
                                )

                                );
                              }

                              else{
                                await databaseManager.updateContact(Contact(
                                  first_name: _listContacts[i].first_name,
                                  last_name: _listContacts[i].last_name,
                                  phone: _listContacts[i].phone,
                                  email: _listContacts[i].email,
                                  priority: 3,
                                  id_contact: _listContacts[i].id_contact,
                                )
                                );

                              }
                            }

                            Popups.showPopupOk(context, text: languagesTextsFile.texts["pop_up_contacts_save"], textOk: languagesTextsFile.texts["pop_up_ok"], functionOk: Popups.functionToQuit);
                          }
                          else{
                            Popups.showPopupOk(context, text: languagesTextsFile.texts["pop_up_no_contacts"], textOk: languagesTextsFile.texts["pop_up_ok"], functionOk: Popups.functionToQuit);
                          }


                        },
                        onTapCancel: () {
                          setState(() {
                            _buttonAnimations["SAVE"] = false;
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.width * 0.06,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            color: Color.fromRGBO(61, 192, 200, 1),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.01),
                          child: Center(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                              child: Center(
                                child: AutoSizeText(
                                  languagesTextsFile.texts["contact_list_save"],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 50,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  minFontSize: 5,
                                  maxFontSize: 50,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              )
            ],
          ),
        ));
  }
}
