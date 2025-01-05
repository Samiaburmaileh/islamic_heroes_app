class AppTranslations {
  static final Map<String, Map<String, String>> _translations = {
    'en': {
      // Auth Screens
      'login': 'Login',
      'register': 'Register',
      'email': 'Email',
      'password': 'Password',
      'confirmPassword': 'Confirm Password',
      'signIn': 'Sign In',
      'signUp': 'Sign Up',
      'forgotPassword': 'Forgot Password?',
      'noAccount': "Don't have an account?",
      'hasAccount': 'Already have an account?',
      'verifyEmail': 'Verify Email',

      // Main Navigation
      'home': 'Home',
      'search': 'Search',
      'favorites': 'Favorites',
      'profile': 'Profile',

      // Settings
      'settings': 'Settings',
      'theme': 'Theme',
      'language': 'Language',
      'fontSize': 'Font Size',
      'systemTheme': 'System',
      'lightTheme': 'Light',
      'darkTheme': 'Dark',
      'offlineMode': 'Offline Mode',
      'notifications': 'Notifications',
      'clearCache': 'Clear Cache',
      'about': 'About',
      'version': 'Version',
      'termsOfService': 'Terms of Service',
      'privacyPolicy': 'Privacy Policy',

      // Profile
      'stats': 'Your Stats',
      'readingHistory': 'Reading History',
      'signOut': 'Sign Out',

      // Empty States
      'noFavorites': 'No Favorites Yet',
      'noHeroes': 'No Heroes Found',
      'noResults': 'No Results Found',

      // Actions
      'retry': 'Retry',
      'cancel': 'Cancel',
      'clear': 'Clear',
      'save': 'Save',
    },
    'ar': {
      // Auth Screens
      'login': 'تسجيل الدخول',
      'register': 'إنشاء حساب',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'confirmPassword': 'تأكيد كلمة المرور',
      'signIn': 'دخول',
      'signUp': 'تسجيل',
      'forgotPassword': 'نسيت كلمة المرور؟',
      'noAccount': 'ليس لديك حساب؟',
      'hasAccount': 'لديك حساب بالفعل؟',
      'verifyEmail': 'تأكيد البريد الإلكتروني',

      // Main Navigation
      'home': 'الرئيسية',
      'search': 'البحث',
      'favorites': 'المفضلة',
      'profile': 'الملف الشخصي',

      // Settings
      'settings': 'الإعدادات',
      'theme': 'المظهر',
      'language': 'اللغة',
      'fontSize': 'حجم الخط',
      'systemTheme': 'النظام',
      'lightTheme': 'فاتح',
      'darkTheme': 'داكن',
      'offlineMode': 'وضع عدم الاتصال',
      'notifications': 'الإشعارات',
      'clearCache': 'مسح التخزين المؤقت',
      'about': 'حول',
      'version': 'الإصدار',
      'termsOfService': 'شروط الخدمة',
      'privacyPolicy': 'سياسة الخصوصية',

      // Profile
      'stats': 'إحصائياتك',
      'readingHistory': 'سجل القراءة',
      'signOut': 'تسجيل الخروع',

      // Empty States
      'noFavorites': 'لا توجد مفضلات حتى الآن',
      'noHeroes': 'لم يتم العثور على أبطال',
      'noResults': 'لم يتم العثور على نتائج',

      // Actions
      'retry': 'إعادة المحاولة',
      'cancel': 'إلغاء',
      'clear': 'مسح',
      'save': 'حفظ',
    },
  };

  static String get(String key, String languageCode) {
    return _translations[languageCode]?[key] ?? key;
  }
}