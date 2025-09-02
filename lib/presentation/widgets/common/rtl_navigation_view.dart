import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/rtl_utils.dart';
import '../../providers/locale_provider.dart';

class RtlNavigationView extends StatelessWidget {
  final NavigationAppBar? appBar;
  final NavigationPane pane;
  final Widget? content;

  const RtlNavigationView({
    super.key,
    this.appBar,
    required this.pane,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();

    return Directionality(
      textDirection: localeProvider.textDirection,
      child: NavigationView(appBar: appBar, pane: pane, content: content),
    );
  }
}
