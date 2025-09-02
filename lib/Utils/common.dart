import 'package:flutter/material.dart';
import 'package:ivf/Utils/app_colors.dart';

class CommonPack {
  Widget regularText(
      {required String text,
      String fontfamily = 'outfit', double letterSpacing = 0,
      double fontsize = 20,
      fontWeight = FontWeight.w400,
      color = Colors.black,
      TextAlign? textAlign = TextAlign.start, double lineHeight=0.0}) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          color: color,
          fontFamily: fontfamily,
          fontSize: fontsize,
          letterSpacing: letterSpacing,
          fontWeight: fontWeight, height: lineHeight),
    );
  }
}
