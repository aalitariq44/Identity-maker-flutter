import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../../providers/locale_provider.dart';

class LanguageSettings extends StatelessWidget {
  const LanguageSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              localeProvider.isRtl ? 'إعدادات اللغة' : 'Language Settings',
              style: FluentTheme.of(context).typography.subtitle?.copyWith(
                fontFamily: localeProvider.isRtl ? 'NotoSansArabic' : 'Roboto',
              ),
              textDirection: localeProvider.textDirection,
            ),
            const SizedBox(height: 16),

            // Arabic Option
            RadioButton(
              checked: localeProvider.isRtl,
              onChanged: (value) {
                if (value == true && !localeProvider.isRtl) {
                  localeProvider.setLocale(const Locale('ar', 'SA'));
                }
              },
              content: Text(
                'العربية',
                style: const TextStyle(fontFamily: 'NotoSansArabic'),
                textDirection: TextDirection.rtl,
              ),
            ),

            const SizedBox(height: 8),

            // English Option
            RadioButton(
              checked: !localeProvider.isRtl,
              onChanged: (value) {
                if (value == true && localeProvider.isRtl) {
                  localeProvider.setLocale(const Locale('en', 'US'));
                }
              },
              content: const Text(
                'English',
                style: TextStyle(fontFamily: 'Roboto'),
              ),
            ),

            const SizedBox(height: 16),

            // Current Direction Info
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: FluentTheme.of(context).accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Row(
                textDirection: localeProvider.textDirection,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    localeProvider.isRtl
                        ? FluentIcons.back
                        : FluentIcons.forward,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    localeProvider.isRtl
                        ? 'من اليمين إلى اليسار'
                        : 'Left to Right',
                    style: TextStyle(
                      fontFamily: localeProvider.isRtl
                          ? 'NotoSansArabic'
                          : 'Roboto',
                      fontSize: 12,
                    ),
                    textDirection: localeProvider.textDirection,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
