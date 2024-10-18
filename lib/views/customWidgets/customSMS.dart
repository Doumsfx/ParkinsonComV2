// Custom SMS Widget
// Code by Pagnon Alexis and Sanchez Adam
// ParkinsonCom V2

import 'package:flutter/material.dart';

class CustomSMS extends StatelessWidget {
  final String text;
  final String time;
  final bool isReceive;

  const CustomSMS({super.key, required this.text, required this.time, required this.isReceive,});

  @override
  Widget build(BuildContext context) {
    if(isReceive){
      return Row(
        children: [
          // Text
          LayoutBuilder(
              builder: (context, constraints) {
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6,
                  ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.height * 0.015)),
                    color: Colors.blue,
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01, horizontal: MediaQuery.of(context).size.width * 0.01),
                      child: Text(
                        text,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: MediaQuery.of(context).size.height * 0.05,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        maxLines: null,
                      ),
                    ),
                  ),
                ),
              );
            }
          ),

          // Time
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              " $time",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: MediaQuery.of(context).size.height * 0.04,
              ),
            ),
          )
        ],
      );
    }

    else{
      return Row(
        children: [
          // Time
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              "$time ",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: MediaQuery.of(context).size.height * 0.04,
              ),
            ),
          ),

          // Text
          LayoutBuilder(
              builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.6,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.height * 0.015)),
                    color: Colors.blueGrey,
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01, horizontal: MediaQuery.of(context).size.width * 0.01),
                      child: Text(
                        text,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: MediaQuery.of(context).size.height * 0.05,

                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        maxLines: null,
                      ),
                    ),
                  ),
                ),
              );
            }
          ),
        ],
      );
    }

  }
}
