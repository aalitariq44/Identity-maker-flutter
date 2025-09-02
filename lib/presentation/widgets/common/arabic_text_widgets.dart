import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../../providers/locale_provider.dart';

class ArabicText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ArabicText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final isArabic = localeProvider.locale.languageCode == 'ar';

    // Get the appropriate font based on language
    final fontFamily = isArabic ? 'NotoSansArabic' : 'Roboto';

    final defaultStyle = TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    );

    return Text(
      text,
      style: defaultStyle.merge(style),
      textAlign: textAlign ?? (isArabic ? TextAlign.right : TextAlign.left),
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class ArabicRichText extends StatelessWidget {
  final List<TextSpan> children;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ArabicRichText({
    super.key,
    required this.children,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final isArabic = localeProvider.locale.languageCode == 'ar';

    return RichText(
      text: TextSpan(children: children),
      textAlign: textAlign ?? (isArabic ? TextAlign.right : TextAlign.left),
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
    );
  }
}

/// A widget that automatically adjusts layout for RTL
class RtlLayout extends StatelessWidget {
  final Widget child;

  const RtlLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();

    return Directionality(
      textDirection: localeProvider.textDirection,
      child: child,
    );
  }
}

/// Enhanced RTL-aware button with proper text rendering
class RtlButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final Widget? icon;
  final bool isIconAtStart;

  const RtlButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style,
    this.icon,
    this.isIconAtStart = true,
  });

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final isRtl = localeProvider.isRtl;

    if (icon != null) {
      if ((isIconAtStart && !isRtl) || (!isIconAtStart && isRtl)) {
        return Button(
          onPressed: onPressed,
          style: style,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: localeProvider.textDirection,
            children: [icon!, const SizedBox(width: 8), ArabicText(text)],
          ),
        );
      } else {
        return Button(
          onPressed: onPressed,
          style: style,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: localeProvider.textDirection,
            children: [ArabicText(text), const SizedBox(width: 8), icon!],
          ),
        );
      }
    }

    return Button(onPressed: onPressed, style: style, child: ArabicText(text));
  }
}
