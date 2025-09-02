import 'package:fluent_ui/fluent_ui.dart';

class IdCreationPage extends StatelessWidget {
  const IdCreationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScaffoldPage(
      content: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FluentIcons.contact, size: 48),
            SizedBox(height: 16),
            Text('صفحة إنشاء الهويات', style: TextStyle(fontSize: 24)),
            SizedBox(height: 8),
            Text('قريباً...', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
