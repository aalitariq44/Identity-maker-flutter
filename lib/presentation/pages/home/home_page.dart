import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import '../../../core/constants/dimensions.dart';
import '../../providers/app_provider.dart';
import '../../widgets/sidebar/app_sidebar.dart';
import '../id_creation/id_creation_page.dart';
import '../students_management/students_page.dart';
import '../template_management/templates_page.dart';
import 'widgets/dashboard_stats.dart';
import 'widgets/recent_exports.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AppProvider _appProvider;

  @override
  void initState() {
    super.initState();
    _appProvider = context.read<AppProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return FluentApp(
          home: NavigationView(
            appBar: NavigationAppBar(
              title: const Text(
                AppStrings.appName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              automaticallyImplyLeading: false,
              actions: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      appProvider.isDarkMode
                          ? FluentIcons.sunny
                          : FluentIcons.circle_half_full,
                    ),
                    onPressed: appProvider.toggleTheme,
                  ),
                  const SizedBox(width: AppDimensions.paddingSmall),
                  IconButton(
                    icon: const Icon(FluentIcons.locale_language),
                    onPressed: appProvider.toggleLanguage,
                  ),
                  const SizedBox(width: AppDimensions.paddingMedium),
                ],
              ),
            ),
            pane: NavigationPane(
              selected: appProvider.selectedPageIndex,
              onChanged: appProvider.setSelectedPageIndex,
              displayMode: PaneDisplayMode.open,
              items: [
                PaneItem(
                  icon: const Icon(FluentIcons.home),
                  title: const Text(AppStrings.home),
                  body: _buildHomePage(),
                ),
                PaneItem(
                  icon: const Icon(FluentIcons.contact),
                  title: const Text(AppStrings.idCreation),
                  body: const IdCreationPage(),
                ),
                PaneItem(
                  icon: const Icon(FluentIcons.people),
                  title: const Text(AppStrings.studentsManagement),
                  body: const StudentsPage(),
                ),
                PaneItem(
                  icon: const Icon(FluentIcons.design),
                  title: const Text(AppStrings.templateManagement),
                  body: const TemplatesPage(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHomePage() {
    return ScaffoldPage(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'مرحباً بك في ${AppStrings.appName}',
            style: FluentTheme.of(context).typography.title,
          ),
          const SizedBox(height: AppDimensions.marginMedium),
          Text(
            'قم بإدارة طلابك ومدارسك وتصميم هويات احترافية بسهولة',
            style: FluentTheme.of(context).typography.body,
          ),
          const SizedBox(height: AppDimensions.marginLarge),
          const Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: DashboardStats()),
                SizedBox(width: AppDimensions.marginLarge),
                Expanded(flex: 3, child: RecentExports()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
