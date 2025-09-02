import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../../providers/locale_provider.dart';
import '../../widgets/settings/language_settings.dart';

class TestRtlPage extends StatelessWidget {
  const TestRtlPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();

    return ScaffoldPage(
      header: const PageHeader(title: Text('اختبار الاتجاه والخطوط')),
      content: Directionality(
        textDirection: localeProvider.textDirection,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Test Arabic Text
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'اختبار النص العربي',
                        style: FluentTheme.of(context).typography.subtitle
                            ?.copyWith(
                              fontFamily: localeProvider.isRtl
                                  ? 'NotoSansArabic'
                                  : 'Roboto',
                            ),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'هذا نص تجريبي للتأكد من ظهور الخط العربي بشكل صحيح',
                        style: TextStyle(
                          fontFamily: localeProvider.isRtl
                              ? 'NotoSansArabic'
                              : 'Roboto',
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 16),
                      Button(
                        onPressed: () {
                          localeProvider.toggleLanguage();
                        },
                        child: Text(
                          'تبديل اللغة',
                          style: TextStyle(
                            fontFamily: localeProvider.isRtl
                                ? 'NotoSansArabic'
                                : 'Roboto',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Test English Text
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'English Text Test',
                        style: FluentTheme.of(context).typography.subtitle
                            ?.copyWith(
                              fontFamily: localeProvider.isRtl
                                  ? 'NotoSansArabic'
                                  : 'Roboto',
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This is a test text to ensure the English font displays correctly',
                        style: TextStyle(
                          fontFamily: localeProvider.isRtl
                              ? 'NotoSansArabic'
                              : 'Roboto',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Button(
                        onPressed: () {
                          localeProvider.toggleLanguage();
                        },
                        child: Text(
                          'Toggle Language',
                          style: TextStyle(
                            fontFamily: localeProvider.isRtl
                                ? 'NotoSansArabic'
                                : 'Roboto',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Language Settings
              const LanguageSettings(),

              const SizedBox(height: 20),

              // Layout Direction Test
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'اختبار اتجاه التخطيط',
                        style: FluentTheme.of(context).typography.subtitle
                            ?.copyWith(fontFamily: 'NotoSansArabic'),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        textDirection: localeProvider.textDirection,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            color: Colors.red,
                            child: const Center(
                              child: Text(
                                '1',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 50,
                            height: 50,
                            color: Colors.green,
                            child: const Center(
                              child: Text(
                                '2',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 50,
                            height: 50,
                            color: Colors.blue,
                            child: const Center(
                              child: Text(
                                '3',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        localeProvider.isRtl
                            ? 'الاتجاه: من اليمين إلى اليسار (صحيح للعربية)'
                            : 'Direction: Left to Right (Correct for English)',
                        style: TextStyle(
                          fontFamily: localeProvider.isRtl
                              ? 'NotoSansArabic'
                              : 'Roboto',
                        ),
                        textDirection: localeProvider.textDirection,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
