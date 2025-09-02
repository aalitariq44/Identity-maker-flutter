import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In ar, this message translates to:
  /// **'مصمم هويات الطلاب'**
  String get appName;

  /// No description provided for @appDescription.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق لتصميم وإنشاء هويات الطلاب'**
  String get appDescription;

  /// No description provided for @home.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get home;

  /// No description provided for @idCreation.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء الهويات'**
  String get idCreation;

  /// No description provided for @studentsManagement.
  ///
  /// In ar, this message translates to:
  /// **'إدارة الطلاب'**
  String get studentsManagement;

  /// No description provided for @templateManagement.
  ///
  /// In ar, this message translates to:
  /// **'إدارة القوالب'**
  String get templateManagement;

  /// No description provided for @dashboard.
  ///
  /// In ar, this message translates to:
  /// **'لوحة التحكم'**
  String get dashboard;

  /// No description provided for @statistics.
  ///
  /// In ar, this message translates to:
  /// **'الإحصائيات'**
  String get statistics;

  /// No description provided for @recentExports.
  ///
  /// In ar, this message translates to:
  /// **'التصديرات الحديثة'**
  String get recentExports;

  /// No description provided for @students.
  ///
  /// In ar, this message translates to:
  /// **'الطلاب'**
  String get students;

  /// No description provided for @addStudent.
  ///
  /// In ar, this message translates to:
  /// **'إضافة طالب'**
  String get addStudent;

  /// No description provided for @editStudent.
  ///
  /// In ar, this message translates to:
  /// **'تعديل طالب'**
  String get editStudent;

  /// No description provided for @deleteStudent.
  ///
  /// In ar, this message translates to:
  /// **'حذف طالب'**
  String get deleteStudent;

  /// No description provided for @studentName.
  ///
  /// In ar, this message translates to:
  /// **'اسم الطالب'**
  String get studentName;

  /// No description provided for @studentBirthDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الميلاد'**
  String get studentBirthDate;

  /// No description provided for @studentGrade.
  ///
  /// In ar, this message translates to:
  /// **'الصف'**
  String get studentGrade;

  /// No description provided for @studentSchool.
  ///
  /// In ar, this message translates to:
  /// **'المدرسة'**
  String get studentSchool;

  /// No description provided for @studentPhoto.
  ///
  /// In ar, this message translates to:
  /// **'صورة الطالب'**
  String get studentPhoto;

  /// No description provided for @studentId.
  ///
  /// In ar, this message translates to:
  /// **'رقم الطالب'**
  String get studentId;

  /// No description provided for @studentClass.
  ///
  /// In ar, this message translates to:
  /// **'الفصل'**
  String get studentClass;

  /// No description provided for @schools.
  ///
  /// In ar, this message translates to:
  /// **'المدارس'**
  String get schools;

  /// No description provided for @addSchool.
  ///
  /// In ar, this message translates to:
  /// **'إضافة مدرسة'**
  String get addSchool;

  /// No description provided for @editSchool.
  ///
  /// In ar, this message translates to:
  /// **'تعديل مدرسة'**
  String get editSchool;

  /// No description provided for @deleteSchool.
  ///
  /// In ar, this message translates to:
  /// **'حذف مدرسة'**
  String get deleteSchool;

  /// No description provided for @schoolNameArabic.
  ///
  /// In ar, this message translates to:
  /// **'اسم المدرسة بالعربية'**
  String get schoolNameArabic;

  /// No description provided for @schoolNameEnglish.
  ///
  /// In ar, this message translates to:
  /// **'اسم المدرسة بالإنجليزية'**
  String get schoolNameEnglish;

  /// No description provided for @schoolAddress.
  ///
  /// In ar, this message translates to:
  /// **'عنوان المدرسة'**
  String get schoolAddress;

  /// No description provided for @schoolPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم هاتف المدرسة'**
  String get schoolPhone;

  /// No description provided for @schoolPrincipal.
  ///
  /// In ar, this message translates to:
  /// **'اسم مدير المدرسة'**
  String get schoolPrincipal;

  /// No description provided for @schoolLogo.
  ///
  /// In ar, this message translates to:
  /// **'شعار المدرسة'**
  String get schoolLogo;

  /// No description provided for @templates.
  ///
  /// In ar, this message translates to:
  /// **'القوالب'**
  String get templates;

  /// No description provided for @addTemplate.
  ///
  /// In ar, this message translates to:
  /// **'إضافة قالب'**
  String get addTemplate;

  /// No description provided for @editTemplate.
  ///
  /// In ar, this message translates to:
  /// **'تعديل قالب'**
  String get editTemplate;

  /// No description provided for @deleteTemplate.
  ///
  /// In ar, this message translates to:
  /// **'حذف قالب'**
  String get deleteTemplate;

  /// No description provided for @templateName.
  ///
  /// In ar, this message translates to:
  /// **'اسم القالب'**
  String get templateName;

  /// No description provided for @templateWidth.
  ///
  /// In ar, this message translates to:
  /// **'عرض القالب'**
  String get templateWidth;

  /// No description provided for @templateHeight.
  ///
  /// In ar, this message translates to:
  /// **'ارتفاع القالب'**
  String get templateHeight;

  /// No description provided for @templateOrientation.
  ///
  /// In ar, this message translates to:
  /// **'اتجاه القالب'**
  String get templateOrientation;

  /// No description provided for @horizontal.
  ///
  /// In ar, this message translates to:
  /// **'أفقي'**
  String get horizontal;

  /// No description provided for @vertical.
  ///
  /// In ar, this message translates to:
  /// **'عمودي'**
  String get vertical;

  /// No description provided for @addText.
  ///
  /// In ar, this message translates to:
  /// **'إضافة نص'**
  String get addText;

  /// No description provided for @addImage.
  ///
  /// In ar, this message translates to:
  /// **'إضافة صورة'**
  String get addImage;

  /// No description provided for @addShape.
  ///
  /// In ar, this message translates to:
  /// **'إضافة شكل'**
  String get addShape;

  /// No description provided for @background.
  ///
  /// In ar, this message translates to:
  /// **'الخلفية'**
  String get background;

  /// No description provided for @transparency.
  ///
  /// In ar, this message translates to:
  /// **'الشفافية'**
  String get transparency;

  /// No description provided for @fontSize.
  ///
  /// In ar, this message translates to:
  /// **'حجم الخط'**
  String get fontSize;

  /// No description provided for @fontFamily.
  ///
  /// In ar, this message translates to:
  /// **'نوع الخط'**
  String get fontFamily;

  /// No description provided for @fontColor.
  ///
  /// In ar, this message translates to:
  /// **'لون الخط'**
  String get fontColor;

  /// No description provided for @textAlign.
  ///
  /// In ar, this message translates to:
  /// **'محاذاة النص'**
  String get textAlign;

  /// No description provided for @bold.
  ///
  /// In ar, this message translates to:
  /// **'عريض'**
  String get bold;

  /// No description provided for @italic.
  ///
  /// In ar, this message translates to:
  /// **'مائل'**
  String get italic;

  /// No description provided for @export.
  ///
  /// In ar, this message translates to:
  /// **'تصدير'**
  String get export;

  /// No description provided for @exportToPdf.
  ///
  /// In ar, this message translates to:
  /// **'تصدير إلى PDF'**
  String get exportToPdf;

  /// No description provided for @selectStudents.
  ///
  /// In ar, this message translates to:
  /// **'اختيار الطلاب'**
  String get selectStudents;

  /// No description provided for @selectTemplate.
  ///
  /// In ar, this message translates to:
  /// **'اختيار القالب'**
  String get selectTemplate;

  /// No description provided for @preview.
  ///
  /// In ar, this message translates to:
  /// **'معاينة'**
  String get preview;

  /// No description provided for @exportSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم التصدير بنجاح'**
  String get exportSuccess;

  /// No description provided for @exportError.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في التصدير'**
  String get exportError;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In ar, this message translates to:
  /// **'إضافة'**
  String get add;

  /// No description provided for @browse.
  ///
  /// In ar, this message translates to:
  /// **'تصفح'**
  String get browse;

  /// No description provided for @confirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد'**
  String get confirm;

  /// No description provided for @close.
  ///
  /// In ar, this message translates to:
  /// **'إغلاق'**
  String get close;

  /// No description provided for @search.
  ///
  /// In ar, this message translates to:
  /// **'بحث'**
  String get search;

  /// No description provided for @refresh.
  ///
  /// In ar, this message translates to:
  /// **'تحديث'**
  String get refresh;

  /// No description provided for @success.
  ///
  /// In ar, this message translates to:
  /// **'تم بنجاح'**
  String get success;

  /// No description provided for @error.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ'**
  String get error;

  /// No description provided for @warning.
  ///
  /// In ar, this message translates to:
  /// **'تحذير'**
  String get warning;

  /// No description provided for @info.
  ///
  /// In ar, this message translates to:
  /// **'معلومات'**
  String get info;

  /// No description provided for @noDataFound.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بيانات'**
  String get noDataFound;

  /// No description provided for @loading.
  ///
  /// In ar, this message translates to:
  /// **'جارِ التحميل...'**
  String get loading;

  /// No description provided for @selectFile.
  ///
  /// In ar, this message translates to:
  /// **'اختر ملف'**
  String get selectFile;

  /// No description provided for @invalidFile.
  ///
  /// In ar, this message translates to:
  /// **'ملف غير صالح'**
  String get invalidFile;

  /// No description provided for @confirmDelete.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من الحذف؟'**
  String get confirmDelete;

  /// No description provided for @fieldRequired.
  ///
  /// In ar, this message translates to:
  /// **'هذا الحقل مطلوب'**
  String get fieldRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In ar, this message translates to:
  /// **'بريد إلكتروني غير صالح'**
  String get invalidEmail;

  /// No description provided for @invalidPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم هاتف غير صالح'**
  String get invalidPhone;

  /// No description provided for @invalidDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ غير صالح'**
  String get invalidDate;

  /// No description provided for @nameTooShort.
  ///
  /// In ar, this message translates to:
  /// **'الاسم قصير جداً'**
  String get nameTooShort;

  /// No description provided for @nameTooLong.
  ///
  /// In ar, this message translates to:
  /// **'الاسم طويل جداً'**
  String get nameTooLong;

  /// No description provided for @totalStudents.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي الطلاب'**
  String get totalStudents;

  /// No description provided for @totalSchools.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي المدارس'**
  String get totalSchools;

  /// No description provided for @totalTemplates.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي القوالب'**
  String get totalTemplates;

  /// No description provided for @recentActivity.
  ///
  /// In ar, this message translates to:
  /// **'النشاط الحديث'**
  String get recentActivity;

  /// No description provided for @quickActions.
  ///
  /// In ar, this message translates to:
  /// **'إجراءات سريعة'**
  String get quickActions;

  /// No description provided for @settings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In ar, this message translates to:
  /// **'السمة'**
  String get theme;

  /// No description provided for @notifications.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get notifications;

  /// No description provided for @about.
  ///
  /// In ar, this message translates to:
  /// **'حول'**
  String get about;

  /// No description provided for @help.
  ///
  /// In ar, this message translates to:
  /// **'مساعدة'**
  String get help;

  /// No description provided for @version.
  ///
  /// In ar, this message translates to:
  /// **'الإصدار'**
  String get version;

  /// No description provided for @darkMode.
  ///
  /// In ar, this message translates to:
  /// **'الوضع المظلم'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In ar, this message translates to:
  /// **'الوضع المضيء'**
  String get lightMode;

  /// No description provided for @systemTheme.
  ///
  /// In ar, this message translates to:
  /// **'سمة النظام'**
  String get systemTheme;

  /// No description provided for @createNewTemplate.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء قالب جديد'**
  String get createNewTemplate;

  /// No description provided for @importTemplate.
  ///
  /// In ar, this message translates to:
  /// **'استيراد قالب'**
  String get importTemplate;

  /// No description provided for @exportTemplate.
  ///
  /// In ar, this message translates to:
  /// **'تصدير قالب'**
  String get exportTemplate;

  /// No description provided for @selectAll.
  ///
  /// In ar, this message translates to:
  /// **'تحديد الكل'**
  String get selectAll;

  /// No description provided for @deselectAll.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء تحديد الكل'**
  String get deselectAll;

  /// No description provided for @selectedItems.
  ///
  /// In ar, this message translates to:
  /// **'العناصر المحددة'**
  String get selectedItems;

  /// No description provided for @position.
  ///
  /// In ar, this message translates to:
  /// **'الموضع'**
  String get position;

  /// No description provided for @size.
  ///
  /// In ar, this message translates to:
  /// **'الحجم'**
  String get size;

  /// No description provided for @rotation.
  ///
  /// In ar, this message translates to:
  /// **'الدوران'**
  String get rotation;

  /// No description provided for @opacity.
  ///
  /// In ar, this message translates to:
  /// **'الشفافية'**
  String get opacity;

  /// No description provided for @left.
  ///
  /// In ar, this message translates to:
  /// **'يسار'**
  String get left;

  /// No description provided for @right.
  ///
  /// In ar, this message translates to:
  /// **'يمين'**
  String get right;

  /// No description provided for @center.
  ///
  /// In ar, this message translates to:
  /// **'وسط'**
  String get center;

  /// No description provided for @top.
  ///
  /// In ar, this message translates to:
  /// **'أعلى'**
  String get top;

  /// No description provided for @bottom.
  ///
  /// In ar, this message translates to:
  /// **'أسفل'**
  String get bottom;

  /// No description provided for @middle.
  ///
  /// In ar, this message translates to:
  /// **'منتصف'**
  String get middle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
