import 'package:flutter/material.dart';
import '../extensions/color.dart';

class ZButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final bool isCancel;

  const ZButton({
    required this.text,
    this.width,
    required this.onPressed,
    this.isCancel = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Color buttonColor = isCancel ? Colors.red : ZephiiColors.zephPurp;

    return Container(
      width: width,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isCancel ? Colors.red.shade400 : Colors.white,
          width: 2.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: buttonColor,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
