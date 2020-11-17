import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:intl/intl.dart';
import 'package:theme_provider/theme_provider.dart';

class MessageBubble extends StatelessWidget {
  final bool isMe;
  final String message;
  final DateTime time;
  final String imageUrl;

  MessageBubble({
    this.isMe,
    this.message,
    this.time,
    this.imageUrl,
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
                  color: Theme.of(context).cardColor,
                )
              : BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.zero,
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: Theme.of(context).primaryColor.withOpacity(0.8),
                ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              imageUrl == ''
                  ? Text(
                      message,
                      textAlign: TextAlign.start,
                      style: isMe
                          ? Theme.of(context).textTheme.subtitle2
                          : Theme.of(context).textTheme.subtitle1,
                    )
                  : Container(
                      height: 150,
                      width: 150,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
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
