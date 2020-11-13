import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final bool isMe;
  final String message;
  final DateTime time;

  MessageBubble({
    this.isMe,
    this.message,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * (2 / 3),
            minWidth: MediaQuery.of(context).size.width * (1 / 5),
          ),
          decoration: isMe
              ? BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomRight: Radius.zero,
                  ),
                  color: Colors.grey[200],
                )
              : BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.zero,
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: Theme.of(context).primaryColor,
                ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                message,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: isMe ? Colors.black : Colors.white,
                    fontFamily: 'Poppins'),
              ),
              Text(
                DateFormat('HH:mm').format(time),
                style: TextStyle(
                  color: isMe ? Colors.grey[600] : Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
