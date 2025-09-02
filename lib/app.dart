import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'core/constants/colors.dart';
import 'core/constants/strings.dart';
import 'presentation/providers/school_provider.dart';
import 'presentation/providers/student_provider.dart';
import 'presentation/providers/template_provider.dart';
import 'presentation/providers/export_provider.dart';
import 'presentation/providers/app_provider.dart';
import 'presentation/pages/home/home_page.dart';

class IdentityMakerApp extends StatelessWidget {
  const IdentityMakerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => SchoolProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => TemplateProvider()),
        ChangeNotifierProvider(create: (_) => ExportProvider()),
      ],
      child: FluentApp(
        title: AppStrings.appName,
        theme: FluentThemeData(
          brightness: Brightness.light,
          accentColor: AppColorSchemes.primaryAccent,
          scaffoldBackgroundColor: AppColors.background,
          cardColor: AppColors.surface,
          typography: Typography.fromBrightness(brightness: Brightness.light),
        ),
        darkTheme: FluentThemeData(
          brightness: Brightness.dark,
          accentColor: AppColorSchemes.primaryAccent,
        ),
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
        locale: const Locale('ar', 'SA'),
        supportedLocales: const [Locale('ar', 'SA'), Locale('en', 'US')],
      ),
    );
  }
}
