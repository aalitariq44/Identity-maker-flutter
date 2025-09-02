import 'package:fluent_ui/fluent_ui.dart';

class AppSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const AppSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: FluentTheme.of(context).scaffoldBackgroundColor,
      child: const Column(
        children: [
          // Sidebar content will be implemented later
          Center(child: Text('Sidebar')),
        ],
      ),
    );
  }
}
