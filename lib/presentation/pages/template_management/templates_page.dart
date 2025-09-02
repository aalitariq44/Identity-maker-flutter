import 'package:fluent_ui/fluent_ui.dart';

class TemplatesPage extends StatelessWidget {
  const TemplatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScaffoldPage(
      content: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FluentIcons.design, size: 48),
            SizedBox(height: 16),
            Text('صفحة إدارة القوالب', style: TextStyle(fontSize: 24)),
            SizedBox(height: 8),
            Text('قريباً...', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
