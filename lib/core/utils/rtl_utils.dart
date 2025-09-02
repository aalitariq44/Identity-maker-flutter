import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/providers/locale_provider.dart';

class RtlUtils {
  static bool isRtl(BuildContext context) {
    try {
      return context.watch<LocaleProvider>().isRtl;
    } catch (e) {
      // fallback if provider is not available
      return Directionality.of(context) == TextDirection.rtl;
    }
  }

  static TextDirection getTextDirection(BuildContext context) {
    try {
      return context.watch<LocaleProvider>().textDirection;
    } catch (e) {
      // fallback if provider is not available
      return Directionality.of(context);
    }
  }

  static Alignment getAlignment(BuildContext context, {bool isStart = true}) {
    final isRtlDirection = isRtl(context);
    if (isStart) {
      return isRtlDirection ? Alignment.centerRight : Alignment.centerLeft;
    } else {
      return isRtlDirection ? Alignment.centerLeft : Alignment.centerRight;
    }
  }

  static EdgeInsetsGeometry getPadding(
    BuildContext context, {
    double start = 0,
    double top = 0,
    double end = 0,
    double bottom = 0,
  }) {
    final isRtlDirection = isRtl(context);
    if (isRtlDirection) {
      return EdgeInsets.only(left: end, top: top, right: start, bottom: bottom);
    } else {
      return EdgeInsets.only(left: start, top: top, right: end, bottom: bottom);
    }
  }

  static EdgeInsetsGeometry getMargin(
    BuildContext context, {
    double start = 0,
    double top = 0,
    double end = 0,
    double bottom = 0,
  }) {
    return getPadding(
      context,
      start: start,
      top: top,
      end: end,
      bottom: bottom,
    );
  }

  static String getFontFamily(BuildContext context) {
    final isRtlDirection = isRtl(context);
    return isRtlDirection ? 'NotoSansArabic' : 'Roboto';
  }

  static TextStyle getTextStyle(
    BuildContext context, {
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

  static CrossAxisAlignment getCrossAxisAlignment(
    BuildContext context, {
    bool isStart = true,
  }) {
    final isRtlDirection = isRtl(context);
    if (isStart) {
      return isRtlDirection ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    } else {
      return isRtlDirection ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    }
  }

  static MainAxisAlignment getMainAxisAlignment(
    BuildContext context, {
    bool isStart = true,
  }) {
    final isRtlDirection = isRtl(context);
    if (isStart) {
      return isRtlDirection ? MainAxisAlignment.end : MainAxisAlignment.start;
    } else {
      return isRtlDirection ? MainAxisAlignment.start : MainAxisAlignment.end;
    }
  }

  static TextAlign getTextAlign(BuildContext context, {bool isStart = true}) {
    final isRtlDirection = isRtl(context);
    if (isStart) {
      return isRtlDirection ? TextAlign.right : TextAlign.left;
    } else {
      return isRtlDirection ? TextAlign.left : TextAlign.right;
    }
  }
}
