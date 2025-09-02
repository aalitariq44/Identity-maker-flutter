import 'package:fluent_ui/fluent_ui.dart';

class StudentsPage extends StatelessWidget {
  const StudentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScaffoldPage(
      content: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FluentIcons.people, size: 48),
            SizedBox(height: 16),
            Text('صفحة إدارة الطلاب', style: TextStyle(fontSize: 24)),
            SizedBox(height: 8),
            Text('قريباً...', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
