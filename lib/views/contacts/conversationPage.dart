// Conversation Page
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

import 'package:flutter/material.dart';
import 'package:parkinson_com_v2/models/database/contact.dart';
import 'package:parkinson_com_v2/models/database/sms.dart';
import 'package:parkinson_com_v2/views/customWidgets/customTitle.dart';
import 'package:parkinson_com_v2/models/variables.dart';
import 'package:parkinson_com_v2/views/keyboards/keyboard.dart';

class ConversationPage extends StatefulWidget {
  final Contact contact;
  const ConversationPage({super.key, required this.contact});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  // Useful variables
  final Map<String, bool> _buttonAnimations = {
    "BACK ARROW": false,
    "HELP": false,
    "HOME": false,
    "SEND": false,
    "CANCEL": false,
    "TTS": false,
    "ERASE": false,
    "BOT ARROW": false,
    "TOP ARROW": false,
  };
  final TextEditingController _controller = TextEditingController();
  //final ScrollController _conversationScrollController = ScrollController();
  final ScrollController _newMessageScrollController = ScrollController();
  late CustomKeyboard customKeyboard;

  @override
  void initState() {
    super.initState();
    // Initialisation of our variables
    customKeyboard = CustomKeyboard(controller: _controller, textPredictions: isConnected);
    conversationPageState.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(29, 52, 83, 1),
      body: ValueListenableBuilder<bool>(
          valueListenable: conversationPageState,
          builder: (context, value, child) {
            if (!value) {
              return Column(
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
                                width: MediaQuery.of(context).size.width * 0.838,
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.19, MediaQuery.of(context).size.height / 16, 0, MediaQuery.of(context).size.height * 0.07),
                                  child: CustomTitle(
                                    text: languagesTextsFile.texts["conversation_page_title"]!,
                                    image: 'assets/themeIcon.png',
                                    imageScale: 1,
                                    backgroundColor: Colors.white,
                                    textColor: const Color.fromRGBO(29, 52, 83, 1),
                                    containerWidth: MediaQuery.of(context).size.width * 0.50,
                                    containerHeight: MediaQuery.of(context).size.height * 0.12,
                                    containerPadding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                                    fontSize: MediaQuery.of(context).size.height * 0.1,
                                    circleSize: MediaQuery.of(context).size.height * 0.1875,
                                    circlePositionedLeft: MediaQuery.of(context).size.height * 0.0625 * -1,
                                    fontWeight: FontWeight.w700,
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

                  // List of messages.
                  Expanded(
                    child: Center(
                      child: Container(color: Colors.blue),
                    ),
                  ),

                  // Third Part
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // TextField + TTS
                        Expanded(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.14,
                            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.01, MediaQuery.of(context).size.height * 0.02, 0, MediaQuery.of(context).size.height * 0.02),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(MediaQuery.of(context).size.width * 0.045),
                              ),
                            ),
                            child: Row(
                              children: [
                                // TextField
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                      MediaQuery.of(context).size.width * 0.02,
                                      0,
                                      MediaQuery.of(context).size.width * 0.02,
                                      0,
                                    ),
                                    child: Center(
                                      child: TextField(
                                        style: TextStyle(
                                          fontSize: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.05 : MediaQuery.of(context).size.height * 0.06,
                                          fontWeight: FontWeight.w800,
                                          color: const Color.fromRGBO(50, 50, 50, 1),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        controller: _controller,
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
                                                Radius.circular(MediaQuery.of(context).size.width * 0.045),
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Colors.white,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(MediaQuery.of(context).size.width * 0.045),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Colors.white,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(MediaQuery.of(context).size.width * 0.045),
                                              ),
                                            ),
                                            hintText: "test",
                                            hintStyle: TextStyle(
                                              color: const Color.fromRGBO(147, 147, 147, 1),
                                              fontStyle: FontStyle.italic,
                                              fontSize: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.05 : MediaQuery.of(context).size.height * 0.06,
                                            )),
                                        onTap: () {
                                          setState(() {
                                            conversationPageState.value = true;
                                          });
                                          print("TOUCHEEEEEEEEEEEEEEE");
                                        },
                                      ),
                                    ),
                                  ),
                                ),

                                // TTS
                                Container(
                                  margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.02),
                                  child: AnimatedScale(
                                    scale: _buttonAnimations["TTS"]! ? 1.1 : 1.0,
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.bounceOut,
                                    child: GestureDetector(
                                      // Animation management
                                      onTapDown: (_) {
                                        setState(() {
                                          _buttonAnimations["TTS"] = true;
                                        });
                                      },
                                      onTapUp: (_) {
                                        setState(() {
                                          _buttonAnimations["TTS"] = false;
                                        });
                                        // Button Code
                                        // TTS
                                        ttsHandler.setText(_controller.text);
                                        ttsHandler.speak();
                                      },
                                      onTapCancel: () {
                                        setState(() {
                                          _buttonAnimations["TTS"] = false;
                                        });
                                      },
                                      child: Image.asset(
                                        'assets/sound.png',
                                        height: MediaQuery.of(context).size.height * 0.085,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Send Button
                        AnimatedScale(
                          scale: _buttonAnimations["SEND"]! ? 1.1 : 1.0,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.bounceOut,
                          child: GestureDetector(
                            onTapDown: (_) {
                              setState(() {
                                _buttonAnimations["SEND"] = true;
                              });
                            },
                            onTapUp: (_) async {
                              setState(() {
                                _buttonAnimations["SEND"] = false;
                              });
                              // Button Code
                              print("SEEEEEEEEEEEEEEEND");


                              final int result = await smsHandler.checkPermissionAndSendSMS(_controller.text, [widget.contact.phone!]);

                              // If the SMS has been sent -> save it into the database
                              if(result == 1) {

                                // Format the timestamp of the sms
                                DateTime timeNow = DateTime.now();
                                String hourNow = "${formatWithTwoDigits(timeNow.hour)}:${formatWithTwoDigits(timeNow.minute)}:${formatWithTwoDigits(timeNow.second)}";

                                await databaseManager.insertSms(Sms(
                                  content: _controller.text,
                                  isReceived: false,
                                  id_contact: widget.contact.id_contact,
                                  timeSms: hourNow,
                                ));

                                // We only keep the 50 last SMS exchanged with each contact
                                List<Sms> listSms = await databaseManager.retrieveSmsFromContact(widget.contact.id_contact);
                                if(listSms.length > 50) {
                                  // Loop for removing multiple SMS (ex : can happen when sending messages to ourself)
                                  for(int i = 0; i < (listSms.length - 50); i++) {
                                    // Remove the older SMS
                                    await databaseManager.deleteSms(listSms[i].id_sms);
                                  }
                                }
                              }

                              _controller.clear();

                              setState(() {
                              });

                            },
                            onTapCancel: () {
                              setState(() {
                                _buttonAnimations["SEND"] = false;
                              });
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.width * 0.060,
                              width: MediaQuery.of(context).size.width * 0.060,
                              padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.009, MediaQuery.of(context).size.width * 0.014, MediaQuery.of(context).size.width * 0.013,
                                  MediaQuery.of(context).size.width * 0.008),
                              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.008),
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(160, 208, 86, 1),
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                "assets/send.png",
                              ),
                            ),
                          ),
                        ),

                        // Cancel Button
                        AnimatedScale(
                          scale: _buttonAnimations["CANCEL"]! ? 1.1 : 1.0,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.bounceOut,
                          child: GestureDetector(
                            onTapDown: (_) {
                              setState(() {
                                _buttonAnimations["CANCEL"] = true;
                              });
                            },
                            onTapUp: (_) {
                              setState(() {
                                _buttonAnimations["CANCEL"] = false;
                              });
                              // Button Code
                              print("CAAAAAAAAAAAAAAAAANCEL");
                              _controller.clear();
                            },
                            onTapCancel: () {
                              setState(() {
                                _buttonAnimations["CANCEL"] = false;
                              });
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.width * 0.060,
                              width: MediaQuery.of(context).size.width * 0.060,
                              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.012),
                              margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.008),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                "assets/croix.png",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }
            else {
              return Column(
                children: [
                  // First part
                  Expanded(
                    child: RawScrollbar(
                      thumbColor: Colors.blue,
                      controller: _newMessageScrollController,
                      trackVisibility: true,
                      thumbVisibility: true,
                      thickness: MediaQuery.of(context).size.width * 0.01125,
                      radius: Radius.circular(MediaQuery.of(context).size.width * 0.015),
                      trackColor: const Color.fromRGBO(66, 89, 109, 1),
                      crossAxisMargin: MediaQuery.of(context).size.width * 0.00375,
                      mainAxisMargin: MediaQuery.of(context).size.width * 0.00375,
                      trackRadius: const Radius.circular(20),
                      padding: isThisDeviceATablet
                          ? EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.1, MediaQuery.of(context).size.width * 0.0995, MediaQuery.of(context).size.width * 0.018 * -1)
                          : EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.1, MediaQuery.of(context).size.width * 0.1045, MediaQuery.of(context).size.width * 0.02 * -1),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Titles and TextField
                          Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.03,
                                width: MediaQuery.of(context).size.width * 0.86,
                              ),

                              // TextField
                              Expanded(
                                child: SizedBox(
                                  width: isThisDeviceATablet ? MediaQuery.of(context).size.width * 0.86 : MediaQuery.of(context).size.width * 0.85,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.03, 0, 0, MediaQuery.of(context).size.height * 0.03),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(MediaQuery.of(context).size.width * 0.045),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          // TextField
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.73,
                                            height: MediaQuery.of(context).size.width * 0.5,
                                            child: TextField(
                                              scrollController: _newMessageScrollController,
                                              scrollPhysics: const BouncingScrollPhysics(
                                                decelerationRate: ScrollDecelerationRate.normal,
                                              ),
                                              style: TextStyle(
                                                fontSize: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.051 : MediaQuery.of(context).size.height * 0.058,
                                                fontWeight: FontWeight.bold,
                                                color: const Color.fromRGBO(50, 50, 50, 1),
                                              ),
                                              controller: _controller,
                                              readOnly: true,
                                              showCursor: true,
                                              onTap: () {
                                                setState(() {
                                                  dialogPageState.value = true;
                                                });
                                              },
                                              enableInteractiveSelection: true,
                                              minLines: isThisDeviceATablet ? 3 : 2,
                                              maxLines: null,
                                              cursorWidth: isThisDeviceATablet ? 3 : 2,
                                              cursorColor: const Color.fromRGBO(0, 0, 0, 1),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                iconColor: Colors.white,
                                                disabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                focusColor: Colors.white,
                                                hoverColor: Colors.white,
                                                contentPadding: EdgeInsets.fromLTRB(
                                                  MediaQuery.of(context).size.width * 0.03,
                                                  0,
                                                  MediaQuery.of(context).size.width * 0.03,
                                                  MediaQuery.of(context).size.width * 0.04,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(color: Colors.white),
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(MediaQuery.of(context).size.width * 0.045),
                                                  ),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(color: Colors.white),
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(MediaQuery.of(context).size.width * 0.045),
                                                  ),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(color: Colors.white),
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(MediaQuery.of(context).size.width * 0.045),
                                                  ),
                                                ),
                                                hintText: languagesTextsFile.texts["dialog_hint_text"]!,
                                              ),
                                            ),
                                          ),

                                          // Spacing between the TextField and the image
                                          SizedBox(width: MediaQuery.of(context).size.width * 0.01),

                                          // Erase and TTS
                                          Column(
                                            children: [
                                              // Spacing
                                              SizedBox(
                                                height: MediaQuery.of(context).size.height * 0.01,
                                              ),

                                              // Erase
                                              AnimatedScale(
                                                scale: _buttonAnimations["ERASE"]! ? 1.1 : 1.0,
                                                duration: const Duration(milliseconds: 100),
                                                curve: Curves.bounceIn,
                                                child: GestureDetector(
                                                  // Animation management
                                                  onTapDown: (_) {
                                                    setState(() {
                                                      _buttonAnimations["ERASE"] = true;
                                                    });
                                                  },
                                                  onTapUp: (_) {
                                                    setState(() {
                                                      _buttonAnimations["ERASE"] = false;

                                                      customKeyboard.predictionsHandler?.clearText();
                                                    });
                                                  },
                                                  onTapCancel: () {
                                                    setState(() {
                                                      _buttonAnimations["ERASE"] = false;
                                                    });
                                                  },

                                                  child: Image.asset(
                                                    'assets/pageBlanche.png',
                                                    height: MediaQuery.of(context).size.height * 0.09,
                                                    width: MediaQuery.of(context).size.height * 0.09,
                                                  ),
                                                ),
                                              ),

                                              // Space between
                                              const Expanded(child: SizedBox()),

                                              // TTS
                                              AnimatedScale(
                                                scale: _buttonAnimations["TTS"]! ? 1.1 : 1.0,
                                                duration: const Duration(milliseconds: 100),
                                                curve: Curves.bounceIn,
                                                child: GestureDetector(
                                                  // Animation management
                                                  onTapDown: (_) {
                                                    setState(() {
                                                      _buttonAnimations["TTS"] = true;
                                                    });
                                                  },
                                                  onTapUp: (_) {
                                                    setState(() {
                                                      _buttonAnimations["TTS"] = false;
                                                      //TTS
                                                      ttsHandler.setText(_controller.text);
                                                      ttsHandler.speak();
                                                    });
                                                  },
                                                  onTapCancel: () {
                                                    setState(() {
                                                      _buttonAnimations["TTS"] = false;
                                                    });
                                                  },

                                                  child: Image.asset(
                                                    'assets/sound.png',
                                                    height: MediaQuery.of(context).size.height * 0.1,
                                                    width: MediaQuery.of(context).size.height * 0.1,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Scroll Widgets + Navigation Icons
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.14,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Scroll widgets
                                Container(
                                  margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.01, MediaQuery.of(context).size.height * 0.00, MediaQuery.of(context).size.width * 0.015, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // Top Arrow
                                      AnimatedScale(
                                        scale: _buttonAnimations["TOP ARROW"]! ? 1.1 : 1.0,
                                        duration: const Duration(milliseconds: 100),
                                        curve: Curves.bounceOut,
                                        child: GestureDetector(
                                          // Animation management
                                          onTap: () {
                                            _newMessageScrollController.animateTo(
                                              _newMessageScrollController.offset - 50,
                                              duration: const Duration(milliseconds: 500),
                                              curve: Curves.easeIn,
                                            );
                                          },

                                          onLongPress: () {
                                            _newMessageScrollController.animateTo(
                                              _newMessageScrollController.position.minScrollExtent,
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
                                            margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.01, 0, MediaQuery.of(context).size.height * 0.005),
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
                                      Container(
                                        height: isThisDeviceATablet ? MediaQuery.of(context).size.height * 0.257 : MediaQuery.of(context).size.height * 0.22,
                                        width: MediaQuery.of(context).size.width * 0.01875,
                                        margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.01, 0, MediaQuery.of(context).size.height * 0.01),
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
                                      ),

                                      // Bot Arrow
                                      AnimatedScale(
                                        scale: _buttonAnimations["BOT ARROW"]! ? 1.1 : 1.0,
                                        duration: const Duration(milliseconds: 100),
                                        curve: Curves.bounceOut,
                                        child: GestureDetector(
                                          // Animation management
                                          onTap: () {
                                            _newMessageScrollController.animateTo(
                                              _newMessageScrollController.offset + 50,
                                              duration: const Duration(milliseconds: 500),
                                              curve: Curves.easeIn,
                                            );
                                          },

                                          onLongPress: () {
                                            _newMessageScrollController.animateTo(
                                              _newMessageScrollController.position.maxScrollExtent,
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
                                            margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.005, 0, MediaQuery.of(context).size.height * 0.01),
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
                                ),

                                const Expanded(child: SizedBox()),

                                // Navigation Icons
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
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Second part
                  customKeyboard,
                ],
              );
            }
          }),
    );
  }

  /// Function to format a [number] into a two format digit, for example '2' becomes '02'
  String formatWithTwoDigits(int number) {
    return number.toString().padLeft(2, '0');
  }

}