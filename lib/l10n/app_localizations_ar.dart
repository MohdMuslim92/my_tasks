// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appLogo => 'مهامي';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get confirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get showPassword => 'إظهار كلمة المرور';

  @override
  String get hidePassword => 'إخفاء كلمة المرور';

  @override
  String get emailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get enterValidEmail => 'أدخل بريداً إلكترونياً صحيحاً';

  @override
  String get passwordRequired => 'كلمة المرور مطلوبة';

  @override
  String passwordMinLength(Object min) {
    return 'يجب أن تكون كلمة المرور على الأقل $min حروف';
  }

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get submit => 'إرسال';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get useDemoCredentials => 'استخدام حساب تجريبي';

  @override
  String get authInvalidCredentials => 'بريد إلكتروني أو كلمة مرور غير صحيحة.';

  @override
  String get authTooManyRequests => 'محاولات كثيرة. الرجاء المحاولة لاحقاً.';

  @override
  String get authGenericFailure => 'فشل في المصادقة. تحقق من بياناتك.';

  @override
  String get registerEmailInUse =>
      'هذا البريد مستخدم بالفعل. حاول تسجيل الدخول أو استخدم بريداً آخر.';

  @override
  String get registerInvalidEmail => 'أدخل عنوان بريد إلكتروني صالحًا.';

  @override
  String get registerWeakPassword =>
      'كلمة المرور ضعيفة. استخدم كلمة أقوى (6 أحرف على الأقل).';

  @override
  String get registerOperationNotAllowed =>
      'تسجيل الدخول بالبريد/كلمة المرور غير مفعل.';

  @override
  String get registerGenericFailure => 'فشل في التسجيل. حاول مرة أخرى.';

  @override
  String get unexpectedError => 'حدث خطأ ما. حاول مرة أخرى.';

  @override
  String get alreadyHaveAccount => 'هل لديك حساب؟ سجّل الدخول';

  @override
  String get tasksTitle => 'المهام';

  @override
  String get deleteTaskTitle => 'حذف المهمة';

  @override
  String get deleteTaskContent => 'هل أنت متأكد أنك تريد حذف هذه المهمة؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get taskDeleted => 'تم حذف المهمة';

  @override
  String get noTasksYet => 'لا توجد مهام بعد';

  @override
  String get createTasksHint => 'قم بإنشاء مهام لتظهر هنا.';

  @override
  String get addTask => 'إضافة مهمة';

  @override
  String get refreshMessage => 'تم التحديث';

  @override
  String get logoutTooltip => 'تسجيل الخروج';

  @override
  String get taskTitleLabel => 'العنوان';

  @override
  String get taskTitleRequired => 'العنوان مطلوب';

  @override
  String get taskDescriptionLabel => 'الوصف';

  @override
  String get taskStatusLabel => 'الحالة';

  @override
  String get taskStatusPending => 'قيد الانتظار';

  @override
  String get taskStatusInProgress => 'قيد التنفيذ';

  @override
  String get taskStatusDone => 'تم';

  @override
  String get save => 'حفظ';

  @override
  String get editTaskLabel => 'تعديل المهمة';

  @override
  String get loadingTaskMessage =>
      'جارٍ تحميل المهمة… إذا استمر هذا الأمر، فقد لا تكون المهمة موجودة.';
}
