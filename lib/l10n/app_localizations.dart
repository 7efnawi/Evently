import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  bool get isArabic => locale.languageCode == 'ar';

  static const List<String> supportedKeys = [
    'appName',
    'welcomeBack',
    'cairoEgypt',
    'login',
    'register',
    'forgetPassword',
    'forgetPasswordTitle',
    'resetPassword',
    'email',
    'password',
    'rePassword',
    'name',
    'dontHaveAccount',
    'alreadyHaveAccount',
    'createAccount',
    'loginWithGoogle',
    'or',
    'home',
    'map',
    'love',
    'profile',
    'language',
    'theme',
    'english',
    'arabic',
    'light',
    'dark',
    'logout',
    'createEvent',
    'editEvent',
    'eventDetails',
    'title',
    'description',
    'eventDate',
    'eventTime',
    'chooseDate',
    'chooseTime',
    'location',
    'chooseEventLocation',
    'addEvent',
    'updateEvent',
    'deleteEvent',
    'deleteConfirmTitle',
    'deleteConfirmMsg',
    'cancel',
    'delete',
    'searchForEvent',
    'noEventsFound',
    'noFavoritesYet',
    'noFavoritesFound',
    'all',
    'sport',
    'birthday',
    'meeting',
    'gaming',
    'workshop',
    'bookClub',
    'exhibition',
    'holiday',
    'eating',
    'personalizeExperience',
    'personalizeSubtitle',
    'start',
    'chooseAccount',
    'continueToEvently',
    'useAnotherAccount',
    'enterName',
    'enterEmail',
    'signIn',
  ];

  static const Map<String, String> _en = {
    'appName': 'Evently',
    'welcomeBack': 'Welcome Back ✨',
    'cairoEgypt': 'Cairo , Egypt',
    'login': 'Login',
    'register': 'Register',
    'forgetPassword': 'Forget Password?',
    'forgetPasswordTitle': 'Forget Password',
    'resetPassword': 'Reset Password',
    'email': 'Email',
    'password': 'Password',
    'rePassword': 'Re Password',
    'name': 'Name',
    'dontHaveAccount': 'Don’t Have Account ? ',
    'alreadyHaveAccount': 'Already Have Account ? ',
    'createAccount': 'Create Account',
    'loginWithGoogle': 'Login With Google',
    'or': 'Or',
    'home': 'Home',
    'map': 'Map',
    'love': 'Love',
    'profile': 'Profile',
    'language': 'Language',
    'theme': 'Theme',
    'english': 'English',
    'arabic': 'Arabic',
    'light': 'Light',
    'dark': 'Dark',
    'logout': 'Logout',
    'createEvent': 'Create Event',
    'editEvent': 'Edit Event',
    'eventDetails': 'Event Details',
    'title': 'Title',
    'description': 'Description',
    'eventDate': 'Event Date',
    'eventTime': 'Event Time',
    'chooseDate': 'Choose Date',
    'chooseTime': 'Choose Time',
    'location': 'Location',
    'chooseEventLocation': 'Choose Event Location',
    'addEvent': 'Add Event',
    'updateEvent': 'Update Event',
    'deleteEvent': 'Delete Event',
    'deleteConfirmTitle': 'Delete Event',
    'deleteConfirmMsg': 'Are you sure you want to delete this event?',
    'cancel': 'Cancel',
    'delete': 'Delete',
    'searchForEvent': 'Search for Event',
    'noEventsFound': 'No events found',
    'noFavoritesYet': 'No favorite events yet',
    'noFavoritesFound': 'No favorite events found matching your search',
    'all': 'All',
    'sport': 'Sport',
    'birthday': 'Birthday',
    'meeting': 'Meeting',
    'gaming': 'Gaming',
    'workshop': 'Workshop',
    'bookClub': 'Book Club',
    'exhibition': 'Exhibition',
    'holiday': 'Holiday',
    'eating': 'Eating',
    'personalizeExperience': 'Personalize Your Experience',
    'personalizeSubtitle':
        'Choose your preferred theme and language to get started with a comfortable experience that fits your style.',
    'start': 'Let\'s Start',
    'chooseAccount': 'Choose an account',
    'continueToEvently': 'to continue to Evently',
    'useAnotherAccount': 'Use another account',
    'enterName': 'Enter your name',
    'enterEmail': 'Enter your Gmail',
    'signIn': 'Sign In',
  };

  static const Map<String, String> _ar = {
    'appName': 'إيفنتلي',
    'welcomeBack': 'مرحباً بك مجدداً ✨',
    'cairoEgypt': 'القاهرة ، مصر',
    'login': 'تسجيل الدخول',
    'register': 'إنشاء حساب',
    'forgetPassword': 'نسيت كلمة المرور؟',
    'forgetPasswordTitle': 'استعادة كلمة المرور',
    'resetPassword': 'إعادة تعيين كلمة المرور',
    'email': 'البريد الإلكتروني',
    'password': 'كلمة المرور',
    'rePassword': 'تأكيد كلمة المرور',
    'name': 'الاسم',
    'dontHaveAccount': 'ليس لديك حساب؟ ',
    'alreadyHaveAccount': 'هل لديك حساب بالفعل؟ ',
    'createAccount': 'إنشاء حساب',
    'loginWithGoogle': 'تسجيل الدخول عبر Google',
    'or': 'أو',
    'home': 'الرئيسية',
    'map': 'الخريطة',
    'love': 'المفضلة',
    'profile': 'الملف الشخصي',
    'language': 'اللغة',
    'theme': 'المظهر',
    'english': 'الإنجليزية',
    'arabic': 'العربية',
    'light': 'فاتح',
    'dark': 'داكن',
    'logout': 'تسجيل الخروج',
    'createEvent': 'إنشاء فعالية',
    'editEvent': 'تعديل الفعالية',
    'eventDetails': 'تفاصيل الفعالية',
    'title': 'العنوان',
    'description': 'الوصف',
    'eventDate': 'تاريخ الفعالية',
    'eventTime': 'وقت الفعالية',
    'chooseDate': 'اختر التاريخ',
    'chooseTime': 'اختر الوقت',
    'location': 'الموقع',
    'chooseEventLocation': 'اختر موقع الفعالية',
    'addEvent': 'إضافة فعالية',
    'updateEvent': 'تحديث الفعالية',
    'deleteEvent': 'حذف الفعالية',
    'deleteConfirmTitle': 'حذف الفعالية',
    'deleteConfirmMsg': 'هل أنت متأكد من رغبتك في حذف هذه الفعالية؟',
    'cancel': 'إلغاء',
    'delete': 'حذف',
    'searchForEvent': 'البحث عن فعالية',
    'noEventsFound': 'لا توجد فعاليات',
    'noFavoritesYet': 'لا توجد فعاليات مفضلة بعد',
    'noFavoritesFound': 'لم يتم العثور على فعاليات مفضلة مطابقة لبحثك',
    'all': 'الكل',
    'sport': 'رياضة',
    'birthday': 'عيد ميلاد',
    'meeting': 'اجتماع',
    'gaming': 'ألعاب',
    'workshop': 'ورشة عمل',
    'bookClub': 'نادي القراءة',
    'exhibition': 'معرض',
    'holiday': 'عطلة',
    'eating': 'طعام',
    'personalizeExperience': 'خصص تجربتك',
    'personalizeSubtitle':
        'اختر المظهر واللغة المفضلة لديك للبدء بتجربة مريحة تناسب أسلوبك الشخصي.',
    'start': 'ابدأ الآن',
    'chooseAccount': 'اختيار حساب',
    'continueToEvently': 'للمتابعة إلى Evently',
    'useAnotherAccount': 'استخدام حساب آخر',
    'enterName': 'أدخل اسمك',
    'enterEmail': 'أدخل بريدك الإلكتروني',
    'signIn': 'تسجيل الدخول',
  };

  String translate(String key) {
    final map = isArabic ? _ar : _en;
    return map[key] ?? _en[key] ?? key;
  }

  // Typed getters
  String get appName => translate('appName');
  String get welcomeBack => translate('welcomeBack');
  String get cairoEgypt => translate('cairoEgypt');
  String get login => translate('login');
  String get register => translate('register');
  String get forgetPassword => translate('forgetPassword');
  String get forgetPasswordTitle => translate('forgetPasswordTitle');
  String get resetPassword => translate('resetPassword');
  String get email => translate('email');
  String get password => translate('password');
  String get rePassword => translate('rePassword');
  String get name => translate('name');
  String get dontHaveAccount => translate('dontHaveAccount');
  String get alreadyHaveAccount => translate('alreadyHaveAccount');
  String get createAccount => translate('createAccount');
  String get loginWithGoogle => translate('loginWithGoogle');
  String get or => translate('or');
  String get home => translate('home');
  String get map => translate('map');
  String get love => translate('love');
  String get profile => translate('profile');
  String get language => translate('language');
  String get theme => translate('theme');
  String get english => translate('english');
  String get arabic => translate('arabic');
  String get light => translate('light');
  String get dark => translate('dark');
  String get logout => translate('logout');
  String get createEvent => translate('createEvent');
  String get editEvent => translate('editEvent');
  String get eventDetails => translate('eventDetails');
  String get title => translate('title');
  String get description => translate('description');
  String get eventDate => translate('eventDate');
  String get eventTime => translate('eventTime');
  String get chooseDate => translate('chooseDate');
  String get chooseTime => translate('chooseTime');
  String get location => translate('location');
  String get chooseEventLocation => translate('chooseEventLocation');
  String get addEvent => translate('addEvent');
  String get updateEvent => translate('updateEvent');
  String get deleteEvent => translate('deleteEvent');
  String get deleteConfirmTitle => translate('deleteConfirmTitle');
  String get deleteConfirmMsg => translate('deleteConfirmMsg');
  String get cancel => translate('cancel');
  String get delete => translate('delete');
  String get searchForEvent => translate('searchForEvent');
  String get noEventsFound => translate('noEventsFound');
  String get noFavoritesYet => translate('noFavoritesYet');
  String get noFavoritesFound => translate('noFavoritesFound');
  String get all => translate('all');
  String get sport => translate('sport');
  String get birthday => translate('birthday');
  String get meeting => translate('meeting');
  String get gaming => translate('gaming');
  String get workshop => translate('workshop');
  String get bookClub => translate('bookClub');
  String get exhibition => translate('exhibition');
  String get holiday => translate('holiday');
  String get eating => translate('eating');
  String get personalizeExperience => translate('personalizeExperience');
  String get personalizeSubtitle => translate('personalizeSubtitle');
  String get start => translate('start');
  String get chooseAccount => translate('chooseAccount');
  String get continueToEvently => translate('continueToEvently');
  String get useAnotherAccount => translate('useAnotherAccount');
  String get enterName => translate('enterName');
  String get enterEmail => translate('enterEmail');
  String get signIn => translate('signIn');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n =>
      AppLocalizations.of(this) ?? AppLocalizations(const Locale('en'));
  String tr(String key) => l10n.translate(key);
}
