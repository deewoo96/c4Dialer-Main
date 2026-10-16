import 'package:flutter/material.dart';
class TextWidget extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final dynamic premium;

  TextWidget({
    super.key,
    required this.color,
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    this.premium,
  });

  @override
  Widget build(BuildContext context) {
    final premiumValue = num.tryParse(premium?.toString() ?? "");
    final starColor = premiumValue == 0
        ? Colors.amber
        : premiumValue != null && premiumValue >= 1 && premiumValue <= 3
            ? Colors.blueGrey.shade300
            : null;
    final text = Text(
      this.text,
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: "Poppins",
        fontWeight: fontWeight,
        color: color,
        overflow: TextOverflow.ellipsis,
      ),
    );

    if (starColor == null) return text;

    return Row(
      children: [
        Flexible(child: text),
        const SizedBox(width: 4),
        Icon(Icons.star, color: starColor, size: fontSize),
      ],
    );
  }
}
