import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? function;
  final Color backgroundColor;
  final Color borderColor;
  final String text;
  final Color textColor;
  const FollowButton({Key? key, this.function, required this.backgroundColor, required this.borderColor, required this.text, required this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7,horizontal: 7),
      child: TextButton(

        onPressed: function,
        child: Container(
          width: 250,
          height: 30,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(5),
              border: Border.all(color: borderColor)
          ),
          alignment: Alignment.center,
          child: Text(text,
            style: TextStyle(
              color: textColor,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
