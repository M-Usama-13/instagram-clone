import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              widget.snap['profileUrl']
            ),
          ),
          const SizedBox(width: 16,),
          Expanded(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.snap['username'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: ' ${widget.snap['text']}'
                    ),
                  ]
                ),
                ),
                const SizedBox(height: 5,),
                Text(
                  DateFormat.yMMMd().format(
                    widget.snap['DataPublished'].toDate()
                  ),

                  style: const TextStyle( fontWeight: FontWeight.w400),)
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              onPressed: (){},
              icon: const Icon(Icons.favorite), color: Colors.white,
            ),
          ),
        ],

      ),
    );
  }
}
