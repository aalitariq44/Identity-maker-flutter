import 'package:fluent_ui/fluent_ui.dart';
import '../../../core/utils/app_localizations.dart';
import '../../../core/utils/rtl_utils.dart';

class LocalizedText extends StatelessWidget {
  final String Function(AppLocalizations) text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const LocalizedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) {
      return const SizedBox.shrink(); // or some error widget
    }
    final defaultStyle = RtlUtils.getTextStyle(context);

    return Text(
      text(localizations),
      style: style ?? defaultStyle,
      textAlign: textAlign ?? RtlUtils.getTextAlign(context),
      maxLines: maxLines,
      overflow: overflow,
      textDirection: RtlUtils.getTextDirection(context),
    );
  }
}

class RtlContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Alignment? alignment;
  final double? width;
  final double? height;
  final Decoration? decoration;

  const RtlContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.alignment,
    this.width,
    this.height,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      alignment: alignment,
      width: width,
      height: height,
      decoration: decoration,
      child: Directionality(
        textDirection: RtlUtils.getTextDirection(context),
        child: child,
      ),
    );
  }
}

class RtlRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  const RtlRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: RtlUtils.getTextDirection(context),
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children,
    );
  }
}

class RtlColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  const RtlColumn({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      textDirection: RtlUtils.getTextDirection(context),
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children,
    );
  }
}

class RtlListTile extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? contentPadding;

  const RtlListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = RtlUtils.isRtl(context);

    return ListTile(
      leading: isRtl ? trailing : leading,
      title: title,
      subtitle: subtitle,
      trailing: isRtl ? leading : trailing,
      onPressed: onTap,
      contentPadding: contentPadding ?? EdgeInsets.zero,
    );
  }
}

class RtlTextFormField extends StatelessWidget {
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool readOnly;

  const RtlTextFormField({
    super.key,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = RtlUtils.isRtl(context);

    return TextFormBox(
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
      controller: controller,
      placeholder: hintText,
      style: RtlUtils.getTextStyle(context),
      textDirection: RtlUtils.getTextDirection(context),
      textAlign: RtlUtils.getTextAlign(context),
      prefix: isRtl ? suffixIcon : prefixIcon,
      suffix: isRtl ? prefixIcon : suffixIcon,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      readOnly: readOnly,
    );
  }
}
