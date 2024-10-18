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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Text
          IntrinsicWidth(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.6,
                minWidth: 0,
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
            ),
          ),

          // Time
          Text(
            " ${time.substring(0,5)}",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: MediaQuery.of(context).size.height * 0.04,
            ),
          )
        ],
      );
    }

    else{
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Time
          Text(
            "${time.substring(0,5)} ",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: MediaQuery.of(context).size.height * 0.04,
            ),
          ),

          // Text
          IntrinsicWidth(
            child: ConstrainedBox(
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
            ),
          ),
        ],
      );
    }

  }
}
