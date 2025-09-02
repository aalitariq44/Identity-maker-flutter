import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // تطبيق
  String get appName => _localizedValues[locale.languageCode]!['appName']!;
  String get appDescription =>
      _localizedValues[locale.languageCode]!['appDescription']!;

  // التنقل
  String get home => _localizedValues[locale.languageCode]!['home']!;
  String get idCreation =>
      _localizedValues[locale.languageCode]!['idCreation']!;
  String get studentsManagement =>
      _localizedValues[locale.languageCode]!['studentsManagement']!;
  String get templateManagement =>
      _localizedValues[locale.languageCode]!['templateManagement']!;
  String get dashboard => _localizedValues[locale.languageCode]!['dashboard']!;
  String get statistics =>
      _localizedValues[locale.languageCode]!['statistics']!;
  String get recentExports =>
      _localizedValues[locale.languageCode]!['recentExports']!;

  // إدارة الطلاب
  String get students => _localizedValues[locale.languageCode]!['students']!;
  String get addStudent =>
      _localizedValues[locale.languageCode]!['addStudent']!;
  String get editStudent =>
      _localizedValues[locale.languageCode]!['editStudent']!;
  String get deleteStudent =>
      _localizedValues[locale.languageCode]!['deleteStudent']!;
  String get studentName =>
      _localizedValues[locale.languageCode]!['studentName']!;
  String get studentBirthDate =>
      _localizedValues[locale.languageCode]!['studentBirthDate']!;
  String get studentGrade =>
      _localizedValues[locale.languageCode]!['studentGrade']!;
  String get studentSchool =>
      _localizedValues[locale.languageCode]!['studentSchool']!;
  String get studentPhoto =>
      _localizedValues[locale.languageCode]!['studentPhoto']!;
  String get studentId => _localizedValues[locale.languageCode]!['studentId']!;
  String get studentClass =>
      _localizedValues[locale.languageCode]!['studentClass']!;

  // إدارة المدارس
  String get schools => _localizedValues[locale.languageCode]!['schools']!;
  String get addSchool => _localizedValues[locale.languageCode]!['addSchool']!;
  String get editSchool =>
      _localizedValues[locale.languageCode]!['editSchool']!;
  String get deleteSchool =>
      _localizedValues[locale.languageCode]!['deleteSchool']!;
  String get schoolNameArabic =>
      _localizedValues[locale.languageCode]!['schoolNameArabic']!;
  String get schoolNameEnglish =>
      _localizedValues[locale.languageCode]!['schoolNameEnglish']!;
  String get schoolAddress =>
      _localizedValues[locale.languageCode]!['schoolAddress']!;
  String get schoolPhone =>
      _localizedValues[locale.languageCode]!['schoolPhone']!;
  String get schoolPrincipal =>
      _localizedValues[locale.languageCode]!['schoolPrincipal']!;
  String get schoolLogo =>
      _localizedValues[locale.languageCode]!['schoolLogo']!;

  // إدارة القوالب
  String get templates => _localizedValues[locale.languageCode]!['templates']!;
  String get addTemplate =>
      _localizedValues[locale.languageCode]!['addTemplate']!;
  String get editTemplate =>
      _localizedValues[locale.languageCode]!['editTemplate']!;
  String get deleteTemplate =>
      _localizedValues[locale.languageCode]!['deleteTemplate']!;
  String get templateName =>
      _localizedValues[locale.languageCode]!['templateName']!;
  String get templateWidth =>
      _localizedValues[locale.languageCode]!['templateWidth']!;
  String get templateHeight =>
      _localizedValues[locale.languageCode]!['templateHeight']!;
  String get templateOrientation =>
      _localizedValues[locale.languageCode]!['templateOrientation']!;
  String get horizontal =>
      _localizedValues[locale.languageCode]!['horizontal']!;
  String get vertical => _localizedValues[locale.languageCode]!['vertical']!;

  // مصمم القوالب
  String get addText => _localizedValues[locale.languageCode]!['addText']!;
  String get addImage => _localizedValues[locale.languageCode]!['addImage']!;
  String get addShape => _localizedValues[locale.languageCode]!['addShape']!;
  String get background =>
      _localizedValues[locale.languageCode]!['background']!;
  String get transparency =>
      _localizedValues[locale.languageCode]!['transparency']!;
  String get fontSize => _localizedValues[locale.languageCode]!['fontSize']!;
  String get fontFamily =>
      _localizedValues[locale.languageCode]!['fontFamily']!;
  String get fontColor => _localizedValues[locale.languageCode]!['fontColor']!;
  String get textAlign => _localizedValues[locale.languageCode]!['textAlign']!;
  String get bold => _localizedValues[locale.languageCode]!['bold']!;
  String get italic => _localizedValues[locale.languageCode]!['italic']!;

  // التصدير
  String get export => _localizedValues[locale.languageCode]!['export']!;
  String get exportToPdf =>
      _localizedValues[locale.languageCode]!['exportToPdf']!;
  String get selectStudents =>
      _localizedValues[locale.languageCode]!['selectStudents']!;
  String get selectTemplate =>
      _localizedValues[locale.languageCode]!['selectTemplate']!;
  String get preview => _localizedValues[locale.languageCode]!['preview']!;
  String get exportSuccess =>
      _localizedValues[locale.languageCode]!['exportSuccess']!;
  String get exportError =>
      _localizedValues[locale.languageCode]!['exportError']!;

  // الأزرار
  String get save => _localizedValues[locale.languageCode]!['save']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get delete => _localizedValues[locale.languageCode]!['delete']!;
  String get edit => _localizedValues[locale.languageCode]!['edit']!;
  String get add => _localizedValues[locale.languageCode]!['add']!;
  String get browse => _localizedValues[locale.languageCode]!['browse']!;
  String get confirm => _localizedValues[locale.languageCode]!['confirm']!;
  String get close => _localizedValues[locale.languageCode]!['close']!;
  String get search => _localizedValues[locale.languageCode]!['search']!;
  String get refresh => _localizedValues[locale.languageCode]!['refresh']!;

  // الرسائل
  String get success => _localizedValues[locale.languageCode]!['success']!;
  String get error => _localizedValues[locale.languageCode]!['error']!;
  String get warning => _localizedValues[locale.languageCode]!['warning']!;
  String get info => _localizedValues[locale.languageCode]!['info']!;
  String get noDataFound =>
      _localizedValues[locale.languageCode]!['noDataFound']!;
  String get loading => _localizedValues[locale.languageCode]!['loading']!;
  String get selectFile =>
      _localizedValues[locale.languageCode]!['selectFile']!;
  String get invalidFile =>
      _localizedValues[locale.languageCode]!['invalidFile']!;
  String get confirmDelete =>
      _localizedValues[locale.languageCode]!['confirmDelete']!;

  // التحقق
  String get fieldRequired =>
      _localizedValues[locale.languageCode]!['fieldRequired']!;
  String get invalidEmail =>
      _localizedValues[locale.languageCode]!['invalidEmail']!;
  String get invalidPhone =>
      _localizedValues[locale.languageCode]!['invalidPhone']!;
  String get invalidDate =>
      _localizedValues[locale.languageCode]!['invalidDate']!;
  String get nameTooShort =>
      _localizedValues[locale.languageCode]!['nameTooShort']!;
  String get nameTooLong =>
      _localizedValues[locale.languageCode]!['nameTooLong']!;

  // إضافية
  String get totalStudents =>
      _localizedValues[locale.languageCode]!['totalStudents']!;
  String get totalSchools =>
      _localizedValues[locale.languageCode]!['totalSchools']!;
  String get totalTemplates =>
      _localizedValues[locale.languageCode]!['totalTemplates']!;
  String get recentActivity =>
      _localizedValues[locale.languageCode]!['recentActivity']!;
  String get quickActions =>
      _localizedValues[locale.languageCode]!['quickActions']!;
  String get settings => _localizedValues[locale.languageCode]!['settings']!;
  String get language => _localizedValues[locale.languageCode]!['language']!;
  String get theme => _localizedValues[locale.languageCode]!['theme']!;

  static const Map<String, Map<String, String>> _localizedValues = {
    'ar': {
      'appName': 'مصمم هويات الطلاب',
      'appDescription': 'تطبيق لتصميم وإنشاء هويات الطلاب',
      'home': 'الرئيسية',
      'idCreation': 'إنشاء الهويات',
      'studentsManagement': 'إدارة الطلاب',
      'templateManagement': 'إدارة القوالب',
      'dashboard': 'لوحة التحكم',
      'statistics': 'الإحصائيات',
      'recentExports': 'التصديرات الحديثة',
      'students': 'الطلاب',
      'addStudent': 'إضافة طالب',
      'editStudent': 'تعديل طالب',
      'deleteStudent': 'حذف طالب',
      'studentName': 'اسم الطالب',
      'studentBirthDate': 'تاريخ الميلاد',
      'studentGrade': 'الصف',
      'studentSchool': 'المدرسة',
      'studentPhoto': 'صورة الطالب',
      'studentId': 'رقم الطالب',
      'studentClass': 'الفصل',
      'schools': 'المدارس',
      'addSchool': 'إضافة مدرسة',
      'editSchool': 'تعديل مدرسة',
      'deleteSchool': 'حذف مدرسة',
      'schoolNameArabic': 'اسم المدرسة بالعربية',
      'schoolNameEnglish': 'اسم المدرسة بالإنجليزية',
      'schoolAddress': 'عنوان المدرسة',
      'schoolPhone': 'رقم هاتف المدرسة',
      'schoolPrincipal': 'اسم مدير المدرسة',
      'schoolLogo': 'شعار المدرسة',
      'templates': 'القوالب',
      'addTemplate': 'إضافة قالب',
      'editTemplate': 'تعديل قالب',
      'deleteTemplate': 'حذف قالب',
      'templateName': 'اسم القالب',
      'templateWidth': 'عرض القالب',
      'templateHeight': 'ارتفاع القالب',
      'templateOrientation': 'اتجاه القالب',
      'horizontal': 'أفقي',
      'vertical': 'عمودي',
      'addText': 'إضافة نص',
      'addImage': 'إضافة صورة',
      'addShape': 'إضافة شكل',
      'background': 'الخلفية',
      'transparency': 'الشفافية',
      'fontSize': 'حجم الخط',
      'fontFamily': 'نوع الخط',
      'fontColor': 'لون الخط',
      'textAlign': 'محاذاة النص',
      'bold': 'عريض',
      'italic': 'مائل',
      'export': 'تصدير',
      'exportToPdf': 'تصدير إلى PDF',
      'selectStudents': 'اختيار الطلاب',
      'selectTemplate': 'اختيار القالب',
      'preview': 'معاينة',
      'exportSuccess': 'تم التصدير بنجاح',
      'exportError': 'خطأ في التصدير',
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'delete': 'حذف',
      'edit': 'تعديل',
      'add': 'إضافة',
      'browse': 'تصفح',
      'confirm': 'تأكيد',
      'close': 'إغلاق',
      'search': 'بحث',
      'refresh': 'تحديث',
      'success': 'تم بنجاح',
      'error': 'حدث خطأ',
      'warning': 'تحذير',
      'info': 'معلومات',
      'noDataFound': 'لا توجد بيانات',
      'loading': 'جارِ التحميل...',
      'selectFile': 'اختر ملف',
      'invalidFile': 'ملف غير صالح',
      'confirmDelete': 'هل أنت متأكد من الحذف؟',
      'fieldRequired': 'هذا الحقل مطلوب',
      'invalidEmail': 'بريد إلكتروني غير صالح',
      'invalidPhone': 'رقم هاتف غير صالح',
      'invalidDate': 'تاريخ غير صالح',
      'nameTooShort': 'الاسم قصير جداً',
      'nameTooLong': 'الاسم طويل جداً',
      'totalStudents': 'إجمالي الطلاب',
      'totalSchools': 'إجمالي المدارس',
      'totalTemplates': 'إجمالي القوالب',
      'recentActivity': 'النشاط الحديث',
      'quickActions': 'إجراءات سريعة',
      'settings': 'الإعدادات',
      'language': 'اللغة',
      'theme': 'السمة',
    },
    'en': {
      'appName': 'Student ID Designer',
      'appDescription':
          'A Flutter application for designing and generating student identity cards',
      'home': 'Home',
      'idCreation': 'ID Creation',
      'studentsManagement': 'Students Management',
      'templateManagement': 'Template Management',
      'dashboard': 'Dashboard',
      'statistics': 'Statistics',
      'recentExports': 'Recent Exports',
      'students': 'Students',
      'addStudent': 'Add Student',
      'editStudent': 'Edit Student',
      'deleteStudent': 'Delete Student',
      'studentName': 'Student Name',
      'studentBirthDate': 'Birth Date',
      'studentGrade': 'Grade',
      'studentSchool': 'School',
      'studentPhoto': 'Student Photo',
      'studentId': 'Student ID',
      'studentClass': 'Class',
      'schools': 'Schools',
      'addSchool': 'Add School',
      'editSchool': 'Edit School',
      'deleteSchool': 'Delete School',
      'schoolNameArabic': 'School Name (Arabic)',
      'schoolNameEnglish': 'School Name (English)',
      'schoolAddress': 'School Address',
      'schoolPhone': 'School Phone',
      'schoolPrincipal': 'Principal Name',
      'schoolLogo': 'School Logo',
      'templates': 'Templates',
      'addTemplate': 'Add Template',
      'editTemplate': 'Edit Template',
      'deleteTemplate': 'Delete Template',
      'templateName': 'Template Name',
      'templateWidth': 'Template Width',
      'templateHeight': 'Template Height',
      'templateOrientation': 'Template Orientation',
      'horizontal': 'Horizontal',
      'vertical': 'Vertical',
      'addText': 'Add Text',
      'addImage': 'Add Image',
      'addShape': 'Add Shape',
      'background': 'Background',
      'transparency': 'Transparency',
      'fontSize': 'Font Size',
      'fontFamily': 'Font Family',
      'fontColor': 'Font Color',
      'textAlign': 'Text Align',
      'bold': 'Bold',
      'italic': 'Italic',
      'export': 'Export',
      'exportToPdf': 'Export to PDF',
      'selectStudents': 'Select Students',
      'selectTemplate': 'Select Template',
      'preview': 'Preview',
      'exportSuccess': 'Export Successful',
      'exportError': 'Export Error',
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'edit': 'Edit',
      'add': 'Add',
      'browse': 'Browse',
      'confirm': 'Confirm',
      'close': 'Close',
      'search': 'Search',
      'refresh': 'Refresh',
      'success': 'Success',
      'error': 'Error',
      'warning': 'Warning',
      'info': 'Information',
      'noDataFound': 'No Data Found',
      'loading': 'Loading...',
      'selectFile': 'Select File',
      'invalidFile': 'Invalid File',
      'confirmDelete': 'Are you sure you want to delete?',
      'fieldRequired': 'This field is required',
      'invalidEmail': 'Invalid email',
      'invalidPhone': 'Invalid phone number',
      'invalidDate': 'Invalid date',
      'nameTooShort': 'Name is too short',
      'nameTooLong': 'Name is too long',
      'totalStudents': 'Total Students',
      'totalSchools': 'Total Schools',
      'totalTemplates': 'Total Templates',
      'recentActivity': 'Recent Activity',
      'quickActions': 'Quick Actions',
      'settings': 'Settings',
      'language': 'Language',
      'theme': 'Theme',
    },
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ar', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
