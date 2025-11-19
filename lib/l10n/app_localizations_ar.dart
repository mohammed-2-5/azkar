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
  String get navAzkar => 'أذكار';

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
  String get calcTitle => 'إعدادات الحساب';

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
  String get highLatitude => 'خط العرض العالي';

  @override
  String get hour24 => 'نظام 24 ساعة';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get enableReminders => 'تفعيل تذكيرات الصلاة';

  @override
  String get leadTime => 'الوقت المسبق';

  @override
  String minutes(Object m) {
    return '$m دقيقة';
  }

  @override
  String get favorites => 'المفضلة';

  @override
  String get searchDuas => 'ابحث عن الدعاء...';

  @override
  String get azkarTitle => 'أذكار';

  @override
  String get qiblahTitle => 'القبلة';

  @override
  String get qiblahSubtitle => 'اعثر على اتجاه الكعبة';

  @override
  String get language => 'اللغة';

  @override
  String get appearanceTitle => 'المظهر';

  @override
  String get primaryColor => 'اللون الأساسي';

  @override
  String get save => 'حفظ';

  @override
  String get rescheduleNow => 'إعادة الجدولة الآن';

  @override
  String get chooseCityTitle => 'اختيار مدينة';

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
  String get catMorning => 'صباح';

  @override
  String get catEvening => 'مساء';

  @override
  String get catAfterPrayer => 'بعد الصلاة';

  @override
  String get catSleep => 'النوم';

  @override
  String get catDoaa => 'أدعية';

  @override
  String todayHijri(Object date) {
    return 'هجري: $date';
  }

  @override
  String qiblahLabel(Object deg) {
    return 'القبلة $deg°';
  }

  @override
  String headingLabel(Object deg) {
    return 'الاتجاه $deg°';
  }

  @override
  String get timeRemaining => 'الوقت المتبقي';

  @override
  String get progressLabel => 'التقدم';

  @override
  String favoritesCount(Object count) {
    return 'المفضلة ($count)';
  }

  @override
  String get favoritesScreenTitle => 'المفضلة';

  @override
  String get noFavorites => 'لا توجد عناصر مفضلة بعد.';

  @override
  String prayerForecast(Object days) {
    return 'الصلاة خلال $days يومًا القادمة';
  }

  @override
  String get calibrationHint => 'حرّك الهاتف بشكل رقم 8 للمعايرة عند الحاجة';

  @override
  String get qrToggleTr => 'إظهار/إخفاء الترجمة';

  @override
  String get qrToggleTrans => 'إظهار/إخفاء الترجمة الصوتية';

  @override
  String get continueReading => 'متابعة القراءة';

  @override
  String get search => 'بحث...';

  @override
  String get bookmark => 'علامة';

  @override
  String get copy => 'نسخ';

  @override
  String get copied => 'تم النسخ';

  @override
  String get viewMushaf => 'عرض المصحف';

  @override
  String get viewTiles => 'عرض البطاقات';

  @override
  String get permissionTitle => 'مطلوب إذن الموقع';

  @override
  String get permissionAcquiring => 'جارٍ الحصول على موقعك الحالي...';

  @override
  String get permissionGps => 'فعّل خدمات الموقع (GPS) للمتابعة.';

  @override
  String get permissionWhy => 'نستخدم موقعك لحساب مواقيت الصلاة بدقة وتحديد اتجاه القبلة.';

  @override
  String get permissionLocationError => 'تعذّر الحصول على الموقع. تأكد من تشغيل GPS ثم حاول مرة أخرى.';

  @override
  String get permissionGrant => 'منح الإذن';

  @override
  String get permissionGetLocation => 'الحصول على موقعي الحالي';

  @override
  String get permissionOpenSettings => 'فتح الإعدادات';

  @override
  String get permissionRetry => 'إعادة المحاولة';

  @override
  String get appearanceThemeMode => 'وضع المظهر';

  @override
  String get appearanceModeSystem => 'النظام';

  @override
  String get appearanceModeLight => 'فاتح';

  @override
  String get appearanceModeDark => 'داكن';

  @override
  String get appearanceColorDarkGrey => 'رمادي داكن';

  @override
  String get appearanceColorEmerald => 'زمردي';

  @override
  String get appearanceColorTeal => 'تركوازي';

  @override
  String get appearanceColorIndigo => 'نيلي';

  @override
  String get appearanceColorPurple => 'أرجواني';

  @override
  String get appearanceColorAmber => 'كهرماني';

  @override
  String get appearanceColorPink => 'وردي';

  @override
  String get appearanceColorBrown => 'بني';

  @override
  String get apply => 'تطبيق';

  @override
  String get prayerSettingsOpenNotifications => 'الإشعارات';

  @override
  String get notificationsSaved => 'تم حفظ إعدادات الإشعارات';

  @override
  String get notificationsTestScheduledTitle => 'تم جدولة الاختبار';

  @override
  String get notificationsTestScheduledBody => 'سيتم تشغيل الإشعار والصوت بعد 15 ثانية.';

  @override
  String get notificationsTestScheduledSnack => 'تمت جدولة الاختبار! ستصلك إشعار وتسمع الأذان بعد 15 ثانية.';

  @override
  String get notificationsButtonTestScheduled => 'اختبار إشعار الأذان (15 ثانية)';

  @override
  String get notificationsInstantTitle => 'اختبار فوري';

  @override
  String get notificationsInstantBody => 'إذا رأيت هذا الإشعار فالإعدادات تعمل بشكل صحيح!';

  @override
  String get notificationsInstantSnack => 'تم إرسال إشعار فوري (بدون صوت).';

  @override
  String get notificationsButtonInstant => 'اختبار فوري الآن';

  @override
  String get notificationsSoundPlaying => 'يتم تشغيل الصوت مباشرة (بدون إشعار).';

  @override
  String get notificationsSoundSelectVoice => 'اختر صوت أذان مخصص أولاً.';

  @override
  String notificationsSoundFailed(Object error) {
    return 'فشل التشغيل: $error';
  }

  @override
  String get notificationsButtonSoundOnly => 'اختبار الصوت فقط (بدون إشعار)';

  @override
  String get notificationsPreviewUnavailable => 'لا يمكن معاينة صوت النظام.';

  @override
  String notificationsPreviewFailed(Object error) {
    return 'فشلت المعاينة: $error';
  }

  @override
  String get notificationsVoiceLabel => 'صوت الأذان';

  @override
  String get notificationsPreview => 'معاينة';

  @override
  String get notificationsStop => 'إيقاف';

  @override
  String get leadDefaultLabel => 'استخدام الافتراضي';

  @override
  String get quietHours => 'ساعات الهدوء';

  @override
  String get quietInfo => 'اكتم صوت التذكيرات ضمن الفترة المحددة.';

  @override
  String get quietStartLabel => 'البداية';

  @override
  String get quietEndLabel => 'النهاية';

  @override
  String get quietClear => 'مسح ساعات الهدوء';

  @override
  String get quietOff => 'إيقاف';

  @override
  String get snoozeLabel => 'غفوة';

  @override
  String get snoozeInfo => 'جدولة تذكير إضافي بعد بضع دقائق.';

  @override
  String get snoozeMinutesLabel => 'مدة الغفوة';

  @override
  String get telemetryTitle => 'التشخيصات';

  @override
  String get telemetryEnabledBody => 'تُسجَّل الأحداث والأخطاء المجهولة للمساعدة في حل المشكلات. تبقى السجلات على جهازك ما لم تشاركها.';

  @override
  String get telemetryDisabledBody => 'التشخيصات غير مفعّلة. فعّلها من إعدادات المظهر لالتقاط السجلات.';

  @override
  String get telemetryFilterAll => 'الكل';

  @override
  String get telemetryFilterEvents => 'الأحداث';

  @override
  String get telemetryFilterErrors => 'الأخطاء';

  @override
  String get telemetryEmpty => 'لم يتم التقاط سجلات بعد.';

  @override
  String get telemetryEmptyFilter => 'لا توجد سجلات لهذا المرشح.';

  @override
  String get telemetryCopyLogs => 'نسخ السجلات';

  @override
  String get telemetryClearLogs => 'مسح السجلات';

  @override
  String get telemetrySaveLogs => 'حفظ ملف';

  @override
  String get telemetryCopySuccess => 'تم نسخ السجلات إلى الحافظة';

  @override
  String get telemetryClearConfirmTitle => 'مسح سجل التشخيص؟';

  @override
  String get telemetryClearConfirmBody => 'السجلات محفوظة محليًا. سيؤدي المسح إلى حذف جميع الأحداث.';

  @override
  String get telemetryClearConfirmCancel => 'إلغاء';

  @override
  String get telemetryClearConfirmAction => 'مسح';

  @override
  String get telemetryLogCleared => 'تم مسح سجل التشخيص';

  @override
  String get telemetryNoData => 'لا توجد بيانات إضافية';

  @override
  String get telemetryEntryCopied => 'تم نسخ السجل';

  @override
  String telemetrySaveSuccess(Object path) {
    return 'تم حفظ السجل في $path';
  }

  @override
  String get telemetrySaveError => 'تعذّر حفظ السجل';

  @override
  String get telemetryEnableTitle => 'تفعيل التشخيصات؟';

  @override
  String get telemetryEnableBody => 'تُسجَّل الأحداث والأخطاء المجهولة للمساعدة في معالجة المشاكل. تبقى السجلات على جهازك ما لم تشاركها.';

  @override
  String get telemetryEnableAccept => 'تفعيل';

  @override
  String get telemetryEnableDecline => 'لاحقًا';

  @override
  String get telemetryEnabled => 'تم تفعيل التشخيصات';

  @override
  String get telemetryDisabled => 'تم إيقاف التشخيصات';

  @override
  String get appearancePreviewTitle => 'معاينة';

  @override
  String get appearancePreviewBody => 'تعرف على شكل العناوين والنصوص مع الإعداد الحالي.';

  @override
  String get appearanceTelemetryCardTitle => 'سجل التشخيص';

  @override
  String get appearanceTelemetryBody => 'تسجيل الأحداث والأخطاء لمساعدتنا في حل المشكلات.';

  @override
  String get appearanceTelemetryViewLogs => 'عرض السجلات';

  @override
  String get appearanceTextScale => 'حجم النص';

  @override
  String get appearanceTextScaleDescription => 'اسحب المؤشر لتغيير حجم النص المستخدم في التطبيق.';

  @override
  String get azkarNoResults => 'لا توجد أذكار مطابقة لعوامل التصفية.';

  @override
  String cachedLocationWarning(Object label) {
    return 'يتم استخدام موقع محفوظ: $label. حدّث الموقع للحصول على دقة أعلى.';
  }

  @override
  String get collectionAllLabel => 'الكل';

  @override
  String collectionChaptersLabel(Object count) {
    return '$count فصل';
  }

  @override
  String get collectionEmpty => 'لا توجد مجموعات متاحة حاليًا.';

  @override
  String collectionEntriesLoadError(Object error) {
    return 'تعذّر تحميل الأحاديث: $error';
  }

  @override
  String collectionLoadError(Object error) {
    return 'تعذّر تحميل المجموعات: $error';
  }

  @override
  String collectionNarrationsLabel(Object count) {
    return '$count رواية';
  }

  @override
  String get collectionNoEntries => 'لا توجد مواد للعرض.';

  @override
  String get collectionNotFound => 'التجميعة غير موجودة.';

  @override
  String get collectionSearchHint => 'ابحث داخل هذه التجميعة...';

  @override
  String get fortiesCollectionsTitle => 'مجموعات الأربعين';

  @override
  String get hadithCollectionsTitle => 'مجموعات الحديث';

  @override
  String get hubTitle => 'الأساسيات اليومية';

  @override
  String get hubSubtitle => 'تنقّل بين الأذكار والأحاديث ومجموعات الأربعين.';

  @override
  String get hubAzkarTitle => 'الأذكار';

  @override
  String get hubAzkarDescription => 'أذكار الصباح والمساء مع عوامل تصفية مريحة.';

  @override
  String get hubAzkarAction => 'استعرض الأذكار';

  @override
  String get hubHadithTitle => 'مجموعات الحديث';

  @override
  String get hubHadithDescription => 'اقرأ مجموعات الحديث المنتقاة بدون اتصال.';

  @override
  String get hubHadithAction => 'فتح الحديث';

  @override
  String get hubFortyTitle => 'الأربعين';

  @override
  String get hubFortyDescription => 'مجموعات كلاسيكية تضم أربعين رواية.';

  @override
  String get hubFortyAction => 'فتح الأربعين';

  @override
  String get perPrayerLeadTitle => 'الوقت المسبق لكل صلاة';

  @override
  String get perPrayerLeadInfo => 'غيّر الوقت المسبق الافتراضي لكل صلاة على حدة.';

  @override
  String previewTitle(Object count) {
    return 'معاينة (الأيام $count القادمة)';
  }

  @override
  String get previewUnavailable => 'المعاينة غير متاحة لهذا الموقع.';

  @override
  String get qiblahAligned => 'تم الاصطفاف مع اتجاه القبلة.';

  @override
  String get qiblahAlignmentStatus => 'حالة الاصطفاف';

  @override
  String get qiblahCalibrationBody => 'حرّك هاتفك على شكل رقم 8 لمعايرة البوصلة.';

  @override
  String get qiblahCalibrationTips => 'نصائح المعايرة';

  @override
  String qiblahRotateLeft(Object deg) {
    return 'أدر لليسار بمقدار $deg°';
  }

  @override
  String qiblahRotateRight(Object deg) {
    return 'أدر لليمين بمقدار $deg°';
  }

  @override
  String get snoozeAction => 'غفوة';

  @override
  String snoozeScheduled(Object minutes) {
    return 'تم تأجيل التذكير لمدة $minutes دقيقة.';
  }

  @override
  String get snoozeUnavailable => 'الغفوة غير متاحة لهذه الصلاة.';

  @override
  String get timezoneWarning => 'توقيت الجهاز يختلف عن التوقيت المستخدم للحساب. تحقق من الإعدادات.';

  @override
  String get unknownDate => 'تاريخ غير معروف';

  @override
  String get localeName => 'ar';
}
