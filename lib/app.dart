import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/constants/colors.dart';
import 'core/utils/app_localizations.dart';
import 'presentation/providers/school_provider.dart';
import 'presentation/providers/student_provider.dart';
import 'presentation/providers/template_provider.dart';
import 'presentation/providers/export_provider.dart';
import 'presentation/providers/app_provider.dart';
import 'presentation/providers/locale_provider.dart';
import 'presentation/pages/home/home_page.dart';

class IdentityMakerApp extends StatelessWidget {
  const IdentityMakerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => SchoolProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => TemplateProvider()),
        ChangeNotifierProvider(create: (_) => ExportProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return FluentApp(
            title: 'مصمم هويات الطلاب',
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
            locale: localeProvider.locale,
            supportedLocales: const [
              Locale('ar', 'SA'),
              Locale('en', 'US'),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (context, child) {
              return Directionality(
                textDirection: localeProvider.textDirection,
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
