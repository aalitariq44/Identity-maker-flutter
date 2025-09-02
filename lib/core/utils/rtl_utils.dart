import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/providers/locale_provider.dart';

class RtlUtils {
  static bool isRtl(BuildContext context) {
    return context.read<LocaleProvider>().isRtl;
  }

  static TextDirection getTextDirection(BuildContext context) {
    return context.read<LocaleProvider>().textDirection;
  }

  static Alignment getAlignment(BuildContext context, {bool isStart = true}) {
    final isRtl = context.read<LocaleProvider>().isRtl;
    if (isStart) {
      return isRtl ? Alignment.centerRight : Alignment.centerLeft;
    } else {
      return isRtl ? Alignment.centerLeft : Alignment.centerRight;
    }
  }

  static EdgeInsetsGeometry getPadding(BuildContext context, {
    double start = 0,
    double top = 0,
    double end = 0,
    double bottom = 0,
  }) {
    final isRtl = context.read<LocaleProvider>().isRtl;
    if (isRtl) {
      return EdgeInsets.only(
        left: end,
        top: top,
        right: start,
        bottom: bottom,
      );
    } else {
      return EdgeInsets.only(
        left: start,
        top: top,
        right: end,
        bottom: bottom,
      );
    }
  }

  static EdgeInsetsGeometry getMargin(BuildContext context, {
    double start = 0,
    double top = 0,
    double end = 0,
    double bottom = 0,
  }) {
    return getPadding(context, start: start, top: top, end: end, bottom: bottom);
  }

  static String getFontFamily(BuildContext context) {
    final isRtl = context.read<LocaleProvider>().isRtl;
    return isRtl ? 'NotoSansArabic' : 'Roboto';
  }

  static TextStyle getTextStyle(BuildContext context, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: getFontFamily(context),
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static CrossAxisAlignment getCrossAxisAlignment(BuildContext context, {bool isStart = true}) {
    final isRtl = context.read<LocaleProvider>().isRtl;
    if (isStart) {
      return isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    } else {
      return isRtl ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    }
  }

  static MainAxisAlignment getMainAxisAlignment(BuildContext context, {bool isStart = true}) {
    final isRtl = context.read<LocaleProvider>().isRtl;
    if (isStart) {
      return isRtl ? MainAxisAlignment.end : MainAxisAlignment.start;
    } else {
      return isRtl ? MainAxisAlignment.start : MainAxisAlignment.end;
    }
  }

  static TextAlign getTextAlign(BuildContext context, {bool isStart = true}) {
    final isRtl = context.read<LocaleProvider>().isRtl;
    if (isStart) {
      return isRtl ? TextAlign.right : TextAlign.left;
    } else {
      return isRtl ? TextAlign.left : TextAlign.right;
    }
  }
}
