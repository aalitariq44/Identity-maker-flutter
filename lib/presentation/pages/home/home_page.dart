import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/utils/app_localizations.dart';
import '../../providers/app_provider.dart';
import '../../providers/locale_provider.dart';
import '../../widgets/common/rtl_widgets.dart';
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
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return FluentApp(
          home: NavigationView(
            appBar: NavigationAppBar(
              title: LocalizedText((l) => l.appName),
              automaticallyImplyLeading: false,
              actions: RtlRow(
                mainAxisAlignment: MainAxisAlignment.end,
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
                    onPressed: () {
                      context.read<LocaleProvider>().toggleLanguage();
                    },
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
                  title: LocalizedText((l) => l.home),
                  body: _buildHomePage(),
                ),
                PaneItem(
                  icon: const Icon(FluentIcons.contact),
                  title: LocalizedText((l) => l.idCreation),
                  body: const IdCreationPage(),
                ),
                PaneItem(
                  icon: const Icon(FluentIcons.people),
                  title: LocalizedText((l) => l.studentsManagement),
                  body: const StudentsPage(),
                ),
                PaneItem(
                  icon: const Icon(FluentIcons.design),
                  title: LocalizedText((l) => l.templateManagement),
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
      content: RtlColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocalizedText(
            (l) => 'مرحباً بك في ${l.appName}',
            style: FluentTheme.of(context).typography.title,
          ),
          const SizedBox(height: AppDimensions.marginMedium),
          LocalizedText(
            (l) => 'قم بإدارة طلابك ومدارسك وتصميم هويات احترافية بسهولة',
            style: FluentTheme.of(context).typography.body,
          ),
          const SizedBox(height: AppDimensions.marginLarge),
          const Expanded(
            child: RtlRow(
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
