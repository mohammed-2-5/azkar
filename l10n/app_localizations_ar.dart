// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'أذكار';

  @override
  String get navPrayer => 'الصلاة';

  @override
  String get navQiblah => 'القبلة';

  @override
  String get navAzkar => 'الأذكار';

  @override
  String get navQuran => 'القرآن';

  @override
  String get prayerTitle => 'مواقيت الصلاة';

  @override
  String get currentLocation => 'الموقع الحالي';

  @override
  String get next => 'التالي';

  @override
  String get settings => 'الإعدادات';

  @override
  String get appearance => 'المظهر';

  @override
  String get calcTitle => 'حساب المواقيت';

  @override
  String get location => 'الموقع';

  @override
  String get useDevice => 'استخدام الجهاز';

  @override
  String get chooseCity => 'اختر مدينة';

  @override
  String get method => 'طريقة الحساب';

  @override
  String get madhab => 'المذهب';

  @override
  String get highLatitude => 'خطوط العرض العالية';

  @override
  String get hour24 => 'نظام 24 ساعة';

  @override
  String previewTitle(Object days) =>
      'معاينة (الأيام القادمة: ${_digits(days)})';

  @override
  String get previewUnavailable => 'المعاينة غير متاحة، حدّد موقعك أولاً.';

  @override
  String get perPrayerLeadTitle => 'تذكير مخصص لكل صلاة';

  @override
  String get perPrayerLeadInfo =>
      'غيّر وقت التذكير الافتراضي لصلوات معينة حسب احتياجك.';

  @override
  String get leadDefaultLabel => 'استخدام الإعداد الافتراضي';

  @override
  String get quietHours => 'أوقات الصمت';

  @override
  String get quietInfo => 'كتم التذكيرات بين هذين الوقتين (وفق توقيت الجهاز).';

  @override
  String get quietStartLabel => 'البداية';

  @override
  String get quietEndLabel => 'النهاية';

  @override
  String get quietOff => 'متوقفة';

  @override
  String get quietClear => 'مسح أوقات الصمت';

  @override
  String cachedLocationWarning(Object date) =>
      'يتم استخدام موقع محفوظ بتاريخ ${_digits(date)}. حدّث للحصول على أحدث البيانات.';

  @override
  String get timezoneWarning =>
      'منطقة الجهاز الزمنية تختلف عن هذا الموقع. تحقق من الإعدادات.';

  @override
  String get unknownDate => 'تاريخ غير معروف';

  @override
  String get snoozeLabel => 'تفعيل زر الغفوة';

  @override
  String get snoozeInfo =>
      'إضافة تذكير سريع بالصلاة التالية عند استخدام الغفوة.';

  @override
  String get snoozeMinutesLabel => 'مدة الغفوة';

  @override
  String get snoozeAction => 'غفوة';

  @override
  String snoozeScheduled(Object minutes) =>
      'تمت الغفوة لمدة ${_digits(minutes)} دقيقة.';

  @override
  String get snoozeUnavailable => 'فعّل تذكيرات الغفوة من الإعدادات';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get enableReminders => 'تفعيل تذكيرات الصلاة';

  @override
  String get leadTime => 'وقت التذكير';

  @override
  String minutes(Object m) => '${_digits(m)} دقيقة';

  @override
  String get favorites => 'المفضلة';

  @override
  String get searchDuas => 'ابحث في الأذكار...';

  @override
  String get azkarNoResults => 'لا توجد أذكار مطابقة لخيارات التصفية.';

  @override
  String get azkarTitle => 'الأذكار';

  @override
  String get qiblahTitle => 'القبلة';

  @override
  String get qiblahSubtitle => 'اعرف اتجاه الكعبة';

  @override
  String get qiblahAlignmentStatus => 'حالة المحاذاة';

  @override
  String get qiblahAligned => 'الاتجاه مضبوط تماماً نحو القبلة.';

  @override
  String qiblahRotateLeft(Object degrees) => 'أدر لليسار ${_digits(degrees)}°';

  @override
  String qiblahRotateRight(Object degrees) => 'أدر لليمين ${_digits(degrees)}°';

  @override
  String get qiblahCalibrationTips => 'نصائح لمعايرة البوصلة';

  @override
  String get qiblahCalibrationBody =>
      'حرّك الهاتف على شكل رقم 8 وابتعد عن المعادن لتحسين الدقة.';

  @override
  String get language => 'اللغة';

  @override
  String get appearanceTitle => 'المظهر';

  @override
  String get primaryColor => 'اللون الأساسي';

  @override
  String get appearanceTextScale => 'حجم الخط';

  @override
  String get appearanceTextScaleDescription =>
      'اضبط حجم النص المستخدم في جميع أنحاء التطبيق.';

  @override
  String get appearancePreviewTitle => 'معاينة النص';

  @override
  String get appearancePreviewBody =>
      'تعرض هذه البطاقة شكل النص بالحجم الذي اخترته.';

  @override
  String get appearanceTelemetryTitle => 'مشاركة بيانات تشخيصية مجهولة';

  @override
  String get appearanceTelemetryBody =>
      'ساعدنا على فهم الأعطال وأنماط الاستخدام. لا نجمع بيانات شخصية.';

  @override
  String get appearanceTelemetryCardTitle => 'مشاركة بيانات التشخيص';

  @override
  String get appearanceTelemetryViewLogs => 'عرض السجلات';

  @override
  String get save => 'حفظ';

  @override
  String get rescheduleNow => 'إعادة الجدولة الآن';

  @override
  String get chooseCityTitle => 'اختر مدينة';

  @override
  String get hubTitle => 'الأذكار والمعرفة';

  @override
  String get hubSubtitle => 'اختر ما تود استكشافه اليوم.';

  @override
  String get hubAzkarTitle => 'الأذكار اليومية';

  @override
  String get hubAzkarDescription =>
      'تصفح أذكار الصباح والمساء وما بعد الصلاة المنتقاة.';

  @override
  String get hubAzkarAction => 'افتح الأذكار';

  @override
  String get hubHadithTitle => 'مكتبة الحديث';

  @override
  String get hubHadithDescription =>
      'استكشف مجموعات البخاري ومسلم ومالك وأحمد المعتمدة.';

  @override
  String get hubHadithAction => 'عرض المجموعات';

  @override
  String get hubFortyTitle => 'الأربعون حديثاً';

  @override
  String get hubFortyDescription =>
      'اقرأ مجموعات النووي والقدسي والشاه ولي الله المختارة.';

  @override
  String get hubFortyAction => 'عرض الأربعين';

  @override
  String get fajr => 'الفجر';

  @override
  String get sunrise => 'الشروق';

  @override
  String get dhuhr => 'الظهر';

  @override
  String get asr => 'العصر';

  @override
  String get maghrib => 'المغرب';

  @override
  String get isha => 'العشاء';

  @override
  String get catMorning => 'الصباح';

  @override
  String get catEvening => 'المساء';

  @override
  String get catAfterPrayer => 'بعد الصلاة';

  @override
  String get catSleep => 'النوم';

  @override
  String get catDoaa => 'أدعية';

  @override
  String todayHijri(Object date) => 'هجري: ${_digits(date)}';

  @override
  String qiblahLabel(Object deg) => 'القبلة ${_digits(deg)}°';

  @override
  String headingLabel(Object deg) => 'الاتجاه ${_digits(deg)}°';

  @override
  String get timeRemaining => 'الوقت المتبقي';

  @override
  String get progressLabel => 'التقدم';

  @override
  String favoritesCount(Object count) => 'المفضلة (${_digits(count)})';

  @override
  String get favoritesScreenTitle => 'المفضلة';

  @override
  String get noFavorites => 'لا توجد أذكار مفضلة بعد.';

  @override
  String prayerForecast(Object days) =>
      'مواقيت الأيام القادمة (${_digits(days)})';

  @override
  String get calibrationHint => 'حرّك الهاتف على شكل رقم 8 للمعايرة عند الحاجة';

  @override
  String get qrToggleTr => 'إظهار/إخفاء الترجمة';

  @override
  String get qrToggleTrans => 'إظهار/إخفاء النطق';

  @override
  String get continueReading => 'تابع القراءة';

  @override
  String get search => 'ابحث...';

  @override
  String get bookmark => 'إشارة مرجعية';

  @override
  String get copy => 'نسخ';

  @override
  String get copied => 'تم النسخ';

  @override
  String get viewMushaf => 'عرض المصحف';

  @override
  String get viewTiles => 'عرض البطاقات';

  @override
  String get hadithCollectionsTitle => 'مكتبة الحديث';

  @override
  String get fortiesCollectionsTitle => 'الأربعون حديثاً';

  @override
  String collectionLoadError(Object error) => 'تعذر التحميل: $error';

  @override
  String collectionEntriesLoadError(Object error) =>
      'تعذر تحميل الروايات: $error';

  @override
  String get collectionEmpty => 'لا توجد مجموعات متاحة.';

  @override
  String get collectionNotFound => 'المجموعة غير موجودة.';

  @override
  String get collectionSearchHint => 'ابحث في الروايات';

  @override
  String get collectionNoEntries => 'لا توجد روايات مطابقة لبحثك.';

  @override
  String collectionNarrationsLabel(Object count) => '${_digits(count)} رواية';

  @override
  String collectionChaptersLabel(Object count) => '${_digits(count)} فصول';

  String _digits(Object value) {
    const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    final input = value.toString();
    final buffer = StringBuffer();
    for (final rune in input.runes) {
      final char = String.fromCharCode(rune);
      final idx = western.indexOf(char);
      buffer.write(idx >= 0 ? eastern[idx] : char);
    }
    return buffer.toString();
  }
}
