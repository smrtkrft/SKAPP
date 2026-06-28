// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'SKAPP';

  @override
  String get brandTagline => 'SmartKraft';

  @override
  String get tabHome => 'Ana Sayfa';

  @override
  String get tabDevices => 'Cihazlarım';

  @override
  String get tabSkapi => 'SKAPI';

  @override
  String get tabSettings => 'Ayarlar';

  @override
  String get tabSmartKraft => 'SmartKraft';

  @override
  String get comingSoonBadge => 'yakında';

  @override
  String get featureComingSoonSnack => 'Bu özellik yakında gelecek';

  @override
  String get homeWelcome => 'SmartKraft\'a Hoş Geldiniz';

  @override
  String get homeSubtitle => 'SmartKraft cihazlarınızı yönetin';

  @override
  String get homeAddDevice => 'Yeni cihaz ekle';

  @override
  String get homeNoDevicesTitle => 'Henüz cihaz yok';

  @override
  String get homeNoDevicesHint =>
      'Başlamak için ilk SmartKraft cihazınızı ekleyin.';

  @override
  String get homeSummaryTitle => 'Genel durum';

  @override
  String homeDevicesOnline(int count) {
    return '$count bağlı';
  }

  @override
  String homeDevicesOffline(int count) {
    return '$count çevrimdışı';
  }

  @override
  String get homeUpdatesTitle => 'Güncelleme mevcut';

  @override
  String homeUpdatesBody(int count) {
    return '$count cihazın yeni firmware\'i var.';
  }

  @override
  String get homeWarningsTitle => 'Uyarılar';

  @override
  String homeWarningsBody(int count) {
    return '$count cihaz bir sorun bildirdi.';
  }

  @override
  String get homeAllGood => 'Her şey yolunda.';

  @override
  String get devicesTitle => 'Cihazlarım';

  @override
  String get devicesEmpty =>
      'Henüz cihaz eklenmedi.\nEklemek için + düğmesine dokunun.';

  @override
  String get devicesAdd => 'Cihaz ekle';

  @override
  String get devicesAllSection => 'Tüm cihazlar';

  @override
  String get devicesGroupsTitle => 'Gruplarınız';

  @override
  String get devicesGroupsHint =>
      'Cihazlarınızı istediğiniz gibi gruplandırmak için grup oluşturun.';

  @override
  String get devicesGroupsCreate => 'Yeni grup';

  @override
  String get devicesGroupsEmpty => 'Henüz grup yok.';

  @override
  String get skapiTitle => 'SKAPI';

  @override
  String get skapiLibraryHeading => 'SKAPI Kütüphanesi';

  @override
  String get skapiLibrarySubtitle =>
      'Cihazlarının tetikleyeceği platformu seç.';

  @override
  String get skapiThisComputer => 'Bu bilgisayar';

  @override
  String skapiCategoryCount(int count) {
    return '$count kategori';
  }

  @override
  String get skapiPlatformMac => 'macOS';

  @override
  String get skapiPlatformWin => 'Windows';

  @override
  String get skapiPlatformLinux => 'Linux';

  @override
  String get skapiPlatformOther => 'Diğer';

  @override
  String get skapiStarredHeading => 'Yıldızlı APIler';

  @override
  String get skapiStarredEmpty =>
      'Kütüphaneden şablon yıldızla, burada görünür.';

  @override
  String get skapiContributeTitle => 'SmartKraft topluluğuna kütüphane gönder';

  @override
  String get skapiContributeBody => 'Bu kart daha sonra tasarlanacak.';

  @override
  String get skapiSearchPlaceholder => 'Aksiyon ara…';

  @override
  String get skapiSearchDisabledHint =>
      'SKAPI parser bağlandığında aktifleşecek.';

  @override
  String get skapiHelpButtonTooltip => 'SKAPI hakkında';

  @override
  String get skapiHelpSheetTitle => 'SKAPI hakkında';

  @override
  String get skapiHelpIntro =>
      'SKAPI, SmartKraft cihazlarının bilgisayarında tetikleyebileceği aksiyon kütüphanesidir.';

  @override
  String get skapiHelpStep1Title => 'Şablon bul';

  @override
  String get skapiHelpStep1Body =>
      'SKAPI kütüphanesinden bir başlangıç noktası seç.';

  @override
  String get skapiHelpStep2Title => 'Yapılandır';

  @override
  String get skapiHelpStep2Body =>
      'Parametreleri doldur ve hangi cihazın tetikleyeceğini seç.';

  @override
  String get skapiHelpStep3Title => 'Cihaza yükle';

  @override
  String get skapiHelpStep3Body =>
      'Cihaz API tetikleyiciyi saklar; SKAPP bilgisayarda scripti çalıştırır.';

  @override
  String get skapiHelpGlossaryTitle => 'Sözlük';

  @override
  String get skapiHelpGlossaryTemplate =>
      'Şablon: kütüphanedeki salt-okunur örnek';

  @override
  String get skapiHelpGlossaryAction =>
      'Aksiyon: API tetikleyici + script çifti';

  @override
  String get skapiHelpGlossaryApiTrigger =>
      'API tetikleyici: cihazın çağırdığı';

  @override
  String get skapiHelpGlossaryScript => 'Script: bilgisayarın çalıştırdığı';

  @override
  String get skapiHelpPhase1Notice =>
      'SKAPI hâlâ inşa ediliyor. Bu sekmenin büyük kısmı iskelet; \'henüz aktif değil\' işaretli bölümler parser, listener ve form builder geldikçe açılacak.';

  @override
  String get skapiMobileBannerBody =>
      'Bu telefon hedef olarak kullanılamaz. Aksiyonların çalışması için bilgisayarında SKAPP açık olmalı.';

  @override
  String get skapiActionsHeading => 'Aksiyonlarım';

  @override
  String get skapiActionsNoDevicesTitle => 'Henüz cihaz yok';

  @override
  String get skapiActionsNoDevicesBody =>
      'Önce bir SmartKraft cihazı eşleştir, Cihazlarım sekmesine git.';

  @override
  String get skapiActionsCreationDisabled =>
      'Aksiyon oluşturma henüz aktif değil.';

  @override
  String get skapiActionsOfflineDetectionDisabled =>
      'Çevrimiçi algılama henüz aktif değil';

  @override
  String get skapiActionsMaxLimitNote => 'Cihaz başına en fazla 5 aksiyon.';

  @override
  String get skapiActionsAddCta => 'Aksiyon ekle';

  @override
  String skapiHeaderSub(int platforms, int actions) {
    return '$platforms platform · $actions aksiyon';
  }

  @override
  String get skapiNewActionPill => 'Yeni Aksiyon';

  @override
  String skapiActionsSubLine(int count) {
    return 'cihaz × script bağlantıları · $count aktif';
  }

  @override
  String get skapiActionsEmptyHint =>
      'Henüz aksiyon yok. Cihaz butonuna basıldığında ne olacağını buradan bağlarsın.';

  @override
  String get skapiActionsCreateCta => 'Oluştur';

  @override
  String skapiActionsGroupTitle(String name) {
    return '$name aksiyonları';
  }

  @override
  String skapiActionsGroupCount(int count) {
    return '$count';
  }

  @override
  String get skapiListenerEndpointTitle =>
      'BF cihazlarına gönderilen webhook URL\'i';

  @override
  String get skapiListenerEndpointBody =>
      'Sayım bittiğinde BF bu URL\'e bağlanamıyorsa laptop\'un yanlış ağ arayüzü seçilmiş olabilir (örn. WSL/VirtualBox/Docker ağı). Yenile butonuyla tekrar gönder.';

  @override
  String get skapiListenerEndpointResolving => 'Yerel IP çözülüyor…';

  @override
  String get skapiListenerEndpointUnavailable =>
      'Kullanılabilir bir LAN arayüzü bulunamadı.';

  @override
  String get skapiListenerEndpointRefresh => 'Yenile';

  @override
  String get skapiListenerEndpointRefreshing => 'Gönderiliyor…';

  @override
  String skapiListenerEndpointPushedAt(String when) {
    return 'Son yenileme $when';
  }

  @override
  String get skapiListenerSelfTest => 'Kendini test et';

  @override
  String get skapiListenerSelfTestRunning => 'Test ediliyor…';

  @override
  String get skapiListenerSelfTestPassed =>
      'Self-test OK: listener bu cihazdan erişilebilir.';

  @override
  String get skapiListenerSelfTestFailed =>
      'Self-test BAŞARISIZ: listener\'a erişilemiyor. Windows Güvenlik Duvarını kontrol et.';

  @override
  String get skapiWebhookActivityTitle => 'Son gelen webhook\'lar';

  @override
  String get skapiWebhookActivityNone =>
      'Henüz webhook alınmadı. Cihaz zamanlayıcısı bittiğinde burada saniyeler içinde bir kayıt görünmeli.';

  @override
  String get skapiWebhookActivityAccepted => 'Kabul edildi';

  @override
  String skapiWebhookActivityRejected(int code) {
    return 'Reddedildi ($code)';
  }

  @override
  String get skapiWebhookActivityMalformed => 'Bozuk';

  @override
  String get skapiWebhookActivitySelfTest => 'Self-test';

  @override
  String get skapiWebhookActivityNoMatch => 'Eşleşen binding yok';

  @override
  String get skapiWebhookActivityScriptError => 'Script hatası';

  @override
  String skapiWebhookActivityMatched(int count) {
    return '$count script çalıştı';
  }

  @override
  String get skapiBfEndpointsButton => 'BF\'deki endpoint\'leri göster';

  @override
  String get skapiBfEndpointsTitle => 'BF cihazlarında kayıtlı endpoint\'ler';

  @override
  String get skapiBfEndpointsHint =>
      'Her eşli cihazın api.endpoint.list çıktısının salt-okunur kopyası. Her SYSTEM slot URL\'i yukarıdaki listener URL\'i ile birebir eşleşmeli. USER slotları manuel eklenmiş webhook\'lara ait olabilir ve yanlış yapılandırılmışsa sayım sonu tetiklemesini kaçırırlar.';

  @override
  String get skapiBfEndpointsLoading => 'BF cihazları sorgulanıyor…';

  @override
  String get skapiBfEndpointsErrorPrefix => 'Sorgu başarısız:';

  @override
  String get skapiBfEndpointsKindSystem => 'SYSTEM';

  @override
  String get skapiBfEndpointsKindUser => 'USER';

  @override
  String get skapiBfEndpointsEmpty => 'Bu cihazda kayıtlı endpoint yok.';

  @override
  String get skapiBfEndpointsClose => 'Kapat';

  @override
  String get skapiBfEndpointsRefresh => 'Yeniden sorgula';

  @override
  String skapiStarredCount(int count) {
    return '$count favori';
  }

  @override
  String get skapiStarredSlimEmpty =>
      'Kütüphaneden yıldız tıkla, en sık kullandıkların burada toplansın.';

  @override
  String get skapiCommunityShareTitle =>
      'Kütüphaneni SmartKraft topluluğu ile paylaş';

  @override
  String get skapiCommunityShareBody =>
      'Yazdığın scriptler SKAPI kütüphanesinde herkese ulaşır.';

  @override
  String get settingsNetworkIdentityTitle => 'Ağ kimliği';

  @override
  String get settingsNetworkIdentityName => 'Bilgisayar adı';

  @override
  String get settingsNetworkIdentityNameHint =>
      'mDNS yayın adı olarak kullanılır';

  @override
  String get settingsNetworkIdentityNameEdit => 'Yeniden adlandır';

  @override
  String get settingsNetworkIdentityNameDialogTitle =>
      'Bilgisayarı yeniden adlandır';

  @override
  String get settingsNetworkIdentityNameDialogHelp =>
      'Küçük harfler, rakamlar ve tire. En fazla 32 karakter.';

  @override
  String get settingsNetworkIdentityUuid => 'Cihaz ID';

  @override
  String get settingsNetworkIdentityPort => 'Dinleyici portu';

  @override
  String get settingsNetworkIdentityPortDialogTitle => 'Dinleyici portu';

  @override
  String get settingsNetworkIdentityToken => 'Bearer token';

  @override
  String get settingsNetworkIdentityRegenerateToken => 'Token\'ı yenile';

  @override
  String get settingsNetworkIdentityRegenerateConfirmTitle =>
      'Token yenilensin mi?';

  @override
  String get settingsNetworkIdentityRegenerateConfirmBody =>
      'Eşleşmiş cihazların yeni token ile yeniden eşleştirilmesi gerekecek.';

  @override
  String get settingsNetworkIdentityServerNotRunning =>
      'Sunucu henüz başlatılmadı, Faz 2\'de aktifleşecek.';

  @override
  String get settingsNetworkIdentityCopy => 'Kopyala';

  @override
  String get settingsNetworkIdentityCopied => 'Kopyalandı';

  @override
  String get settingsNetworkIdentityStaticIpHint =>
      'İpucu: router\'da DHCP rezervasyonu (statik IP) bağlantıları daha güvenilir kılar.';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsSectionAppearance => 'Görünüm';

  @override
  String get settingsLanguage => 'Dil';

  @override
  String get settingsLanguageSystemHint => 'Sistem dilini takip et';

  @override
  String get settingsLanguagePickerAllSection => 'Tüm diller';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeLight => 'Açık';

  @override
  String get settingsThemeDark => 'Koyu';

  @override
  String get settingsThemeSystem => 'Sistem';

  @override
  String get settingsSectionAbout => 'Hakkında';

  @override
  String get settingsVersion => 'Sürüm';

  @override
  String get settingsDeveloper => 'Geliştirici';

  @override
  String get settingsDeveloperName => 'SmartKraft';

  @override
  String get settingsOpenAbout => 'SKAPP Hakkında';

  @override
  String get settingsSectionAdvanced => 'Gelişmiş';

  @override
  String get settingsDeveloperMode => 'Geliştirici modu';

  @override
  String get settingsDeveloperToolsTitle => 'Geliştirici araçları';

  @override
  String get settingsDeveloperToolsSubtitle =>
      'USB konsolu, ağ kimliği, dinleyici, token\'lar, loglar';

  @override
  String get settingsDeveloperModeInfoTitle => 'Geliştirici modu neyi açar?';

  @override
  String get settingsDeveloperModeInfoIntro =>
      'Bu mod, varsayılan arayüzde gizli tutulan gelişmiş yüzeyleri ortaya çıkarır. Üç ana kullanım için var:';

  @override
  String get settingsDeveloperModeUseCaseCliTitle => 'CLI konsolu';

  @override
  String get settingsDeveloperModeUseCaseCliBody =>
      'BLE veya WiFi bağlantısı kurmadan, cihazlarını doğrudan USB kablo üzerinden yapılandırmak için.';

  @override
  String get settingsDeveloperModeUseCaseSkapiTitle => 'SKAPI kod editörü';

  @override
  String get settingsDeveloperModeUseCaseSkapiBody =>
      'Hazır script\'leri açıp düzenlemek veya sıfırdan kendi script\'lerini yazmak için.';

  @override
  String get settingsDeveloperModeUseCaseMobileTitle => 'Mobil uzak tetikleme';

  @override
  String get settingsDeveloperModeUseCaseMobileBody =>
      'Bu masaüstündeki SKAPI bağlamalarını eşli mobil SKAPP\'tan çalıştırmak için.';

  @override
  String get settingsDeveloperModeInfoSurfacesHeader =>
      'Açık olduğunda Ayarlar\'da şu ek kartlar görünür:';

  @override
  String get settingsDeveloperModeInfoItem1 =>
      'Ağ kimliği kartı: UUID, port, bearer token düzenleme; SKAPP kurulumu sırrı kopyala / yenile.';

  @override
  String get settingsDeveloperModeInfoItem2 =>
      'Yerel HTTP dinleyici kontrolleri: başlat/durdur, QR ile eşleme, TLS sertifika yenileme, LAN görünürlüğü.';

  @override
  String get settingsDeveloperModeInfoItem3 =>
      'Peer token listesi: eşleşmiş her mobil SKAPP görünür, tek tek iptal edilebilir.';

  @override
  String get settingsDeveloperModeInfoItem4 =>
      'USB CLI Konsolu (sadece masaüstü): USB ile bağlı SmartKraft cihazına ham NDJSON komut satırı.';

  @override
  String get settingsDeveloperModeInfoNotPaid =>
      'Ücretli bir yükseltme değil. SKAPP tek sürümlü ve ücretsiz; bu anahtar yalnız gelişmiş yüzeyleri varsayılanda saklayarak arayüzü sade tutar. SmartKraft cihazları bu ayardan bağımsız çalışır.';

  @override
  String get settingsSectionConnectivity => 'Bağlantı';

  @override
  String get settingsBluetoothStatus => 'Bluetooth';

  @override
  String get settingsBluetoothStatusOn => 'Açık';

  @override
  String get settingsBluetoothStatusOff => 'Kapalı';

  @override
  String get settingsBluetoothStatusTurningOn => 'Açılıyor…';

  @override
  String get settingsBluetoothStatusTurningOff => 'Kapanıyor…';

  @override
  String get settingsBluetoothStatusUnauthorized => 'İzin yok';

  @override
  String get settingsBluetoothStatusUnsupported => 'Desteklenmiyor';

  @override
  String get settingsBluetoothStatusUnknown => 'Kontrol ediliyor…';

  @override
  String get settingsNetworkStatus => 'Ağ';

  @override
  String get settingsWifiStatusConnected => 'Wi-Fi';

  @override
  String get settingsWifiStatusEthernet => 'Ethernet';

  @override
  String get settingsWifiStatusMobile => 'Mobil veri';

  @override
  String get settingsWifiStatusDisconnected => 'Bağlı değil';

  @override
  String get settingsWifiStatusUnknown => 'Kontrol ediliyor…';

  @override
  String get settingsWifiHint => 'İlk eşleştirmeden sonra kullanılır.';

  @override
  String get settingsBluetoothPermissions => 'İzinler';

  @override
  String get settingsBluetoothPermissionsHint => 'Bluetooth ve konum erişimi';

  @override
  String get settingsBluetoothGrantPermission => 'İzin ver';

  @override
  String get settingsOpenSystemSettings => 'Sistem ayarlarını aç';

  @override
  String get settingsSectionUpdates => 'Güncellemeler';

  @override
  String get settingsCheckUpdates => 'Güncellemeleri kontrol et';

  @override
  String get settingsAutoCheckUpdates => 'Açılışta kontrol et';

  @override
  String get settingsAutoCheckUpdatesHint =>
      'SKAPP her açıldığında son sürümde olduğunu doğrula.';

  @override
  String get settingsUpdateChannel => 'Güncelleme kanalı';

  @override
  String get settingsUpdateChannelStable => 'Kararlı';

  @override
  String get settingsUpdateChannelBeta => 'Beta';

  @override
  String get settingsUpdateChannelBetaHint =>
      'Yeni özellikleri daha erken görürsünüz, kararlılık düşük olabilir.';

  @override
  String get settingsUpToDate => 'En son sürümdesiniz.';

  @override
  String get settingsUpdateCheckPlaceholder =>
      'Güncelleme kontrolü Faz 3\'te bağlanacak.';

  @override
  String get settingsSectionLegal => 'Yasal';

  @override
  String get settingsLicense => 'Lisans ve Teşekkür';

  @override
  String get settingsSectionInfo => 'Bilgi';

  @override
  String get settingsThemeCycleHint => 'Tıkla ve değiştir';

  @override
  String get settingsChannelCycleHint => 'Tıkla ve değiştir';

  @override
  String get settingsSectionThisNode => 'Bu Node';

  @override
  String get settingsNodeNameTitle => 'SKAPP node adı';

  @override
  String settingsNodeNameSub(String name) {
    return '$name · diğer SKAPP\'ler bu adla görür · mDNS yayını';
  }

  @override
  String get settingsSectionDanger => 'Tehlikeli';

  @override
  String get settingsResetPairings => 'Eşleşmeleri sıfırla';

  @override
  String get settingsResetPairingsSub =>
      'Tüm eşli cihazları kaldır, ayarlar/dil/node adı korunur';

  @override
  String get settingsFactoryReset => 'Fabrika ayarları';

  @override
  String get settingsFactoryResetSub => 'Her şey silinir, geri alınmaz';

  @override
  String get settingsSectionAdvancedNetwork => 'Gelişmiş ağ';

  @override
  String get settingsResetPairingsConfirmTitle =>
      'Tüm eşleşmeler sıfırlansın mı?';

  @override
  String settingsResetPairingsConfirmBody(int paired, int bindings, int peers) {
    return '$paired eşli cihaz, $bindings SKAPI aksiyonu ve $peers SKAPP peer\'ı silinecek. Ayarlar, tema, dil ve notlar korunur. Cihazlar kendi tarafında eşleşmeyi tutmaya devam eder; tamamen eşleşmeyi kaldırmak için cihazı manuel sıfırlayın. Bu işlem geri alınamaz.';
  }

  @override
  String get settingsResetPairingsConfirmAction => 'Sıfırla';

  @override
  String get settingsFactoryResetConfirmTitle =>
      'Fabrika ayarlarına dönülsün mü?';

  @override
  String get settingsFactoryResetConfirmBody =>
      'Her şey silinecek: tüm eşleşmeler, ayarlar, tema, dil, notlar, ağ kimliği, TLS sertifikası ve otomatik başlatma girdisi. SKAPP ilk açılış durumuna döner. Bu işlem geri alınamaz.';

  @override
  String get settingsFactoryResetConfirmAction => 'Her şeyi sil';

  @override
  String get settingsFactoryResetSecondConfirmTitle => 'Kesin emin misiniz?';

  @override
  String get settingsFactoryResetSecondConfirmBody =>
      'Onaylamak için SIL yazın.';

  @override
  String get settingsFactoryResetSecondConfirmHint => 'SIL';

  @override
  String get settingsFactoryResetSecondConfirmAction => 'Anladım, sil.';

  @override
  String get settingsResetInProgress => 'Sıfırlanıyor…';

  @override
  String get settingsResetDoneTitle => 'Sıfırlama tamamlandı';

  @override
  String get settingsResetDoneWithWarnings =>
      'Sıfırlama tamamlandı (uyarı ile)';

  @override
  String settingsResetSummaryPaired(int count) {
    return '$count eşli cihaz silindi';
  }

  @override
  String settingsResetSummaryBindings(int count) {
    return '$count SKAPI aksiyonu silindi';
  }

  @override
  String settingsResetSummaryPeers(int count) {
    return '$count SKAPP peer silindi';
  }

  @override
  String settingsResetSummaryBonds(int count) {
    return '$count cihaz bağı silindi';
  }

  @override
  String get settingsResetSummaryNetworkIdentity =>
      'Ağ kimliği varsayılana döndü';

  @override
  String get settingsResetSummaryTlsCert => 'TLS sertifikası temizlendi';

  @override
  String get settingsResetSummaryAutostart =>
      'Otomatik başlatma girdisi silindi';

  @override
  String get settingsResetSummaryWarningHeader => 'Uyarılar:';

  @override
  String get settingsResetRestartHint =>
      'Değişikliklerin tam uygulanması için SKAPP\'i yeniden başlatın.';

  @override
  String get settingsResetRestartNow => 'Şimdi yeniden başlat';

  @override
  String get settingsResetClose => 'Kapat';

  @override
  String settingsFooterCombined(String version, String node) {
    return 'SKAPP $version · $node';
  }

  @override
  String get langEnglish => 'English';

  @override
  String get langTurkish => 'Türkçe';

  @override
  String get aboutTitle => 'SmartKraft ve SKAPP Hakkında';

  @override
  String get aboutDevicesHeading => 'Cihazlarımız';

  @override
  String get aboutDevicesBody =>
      'SmartKraft cihazları yenilikçi olmak, fark yaratmak ve benzerlerinin düşünmediği detayları taşımak üzere tasarlanır. Amacımız var olanı yeniden üretmek değil, yapılmayanı, eksik bırakılanı yapmaktır. Çözülmemiş bir gündelik sorunu işaret edip ona basit, anlaşılır bir cevap üretmek; ya da çözülmüş ama pahalı kalan bir şeyin herkesin yapabileceği ucuz bir DIY versiyonunu ortaya koymak.\n\nHer SmartKraft cihazı, henüz çözülmemiş bir soruna küçük ve sade bir cevap vermek için tasarlanır ve üretilir. Bir cihaz tasarlarken kendimize tek bir soru sorarız: \"Bu sorun şu ana kadar neden çözülmemişti, ya da neden bu kadar pahalıydı?\"';

  @override
  String get aboutSkappRoleHeading => 'SKAPP\'in Yeri';

  @override
  String get aboutSkappRoleBody =>
      'SKAPP, SmartKraft cihazlarının ortak uygulamasıdır. Bir cihazı eşleştirmek, ayarlamak, davranışını değiştirmek ve birden fazla cihazı tek bir senaryoda buluşturmak için tasarlanmış basit bir kullanıcı arayüzüdür.\n\nSKAPP cihazlarınız için zorunlu değildir, kolaylaştırıcı bir araçtır. Her SmartKraft cihazı, SKAPP olmadan da USB üzerinden CLI erişimiyle aynı şekilde yapılandırılabilir; komut satırını tercih edenlere bu yol her zaman açıktır. Görsel arayüzün hızı ve birden fazla cihazı bir arada yönetme rahatlığı arayanlar içinse SKAPP burada durur.\n\nBulut hesabı istemez. Reklam göstermez. Veri toplamaz. Telefonunuzla cihazınız arasında sessiz bir köprüdür, başka bir şey değil.';

  @override
  String get aboutShowcaseHeading => 'Yapımcı Vitrini';

  @override
  String get aboutShowcaseEmpty =>
      'Şimdilik vitrin boş. İlk SmartKraft cihazı yolda; tasarım dosyaları, gömülü yazılım kaynakları, parça listeleri ve montaj rehberleri çıktığında burada listelenecekler. O ana kadar bu sayfa size çok şey vaat etmiyor, sadece gelecek için yer ayırıyor.';

  @override
  String get aboutConnectHeading => 'Bağlantı Kur';

  @override
  String get aboutConnectIntro =>
      'Mesaj atabilir, kaynak kodlarına bakabilir, gelişimi takip edebilirsiniz.';

  @override
  String get aboutConnectGitHub => 'GitHub';

  @override
  String get aboutConnectWebsite => 'Web sitesi';

  @override
  String get aboutConnectYouTube => 'YouTube';

  @override
  String get aboutConnectX => 'X';

  @override
  String get aboutConnectEmail => 'E-posta';

  @override
  String get aboutVersionHeading => 'Sürüm';

  @override
  String get licenseTitle => 'Lisans ve Teşekkür';

  @override
  String get licenseSmartKraftHeading => 'SmartKraft Üzerine';

  @override
  String get licenseSmartKraftBody =>
      'SmartKraft, gündelik hayata küçük ama kendine özgü pratik araçlar katmaya çalışan bir atölyedir. Burada bir cihaz raftan inip elinize ulaşana kadar pek çok adımdan geçer; tahta üzerine çizilen ilk taslak, lehimlenen ilk prototip, gece yarısı yazılan kod satırları, defalarca yeniden denenen küçük ayrıntılar. Bir cihazı üretmek; satır yazmak, devre çizmek, lehim sürmek, hatayı bulmak, baştan başlamak demektir. Tüm bu sürece adını koymadan emek veren herkese SmartKraft adına teşekkür ederiz.\n\nMaker kültürüne, açık kaynağa ve onarılabilir, geri dönüştürülebilir elektroniğe inanırız. Bu yüzden ürettiğimiz cihazların donanım tasarımlarını açık donanım olarak, gömülü yazılımlarını ise AGPL 3.0 altında yayımlamayı ilke ediniriz. Amacımız, mümkün olduğunca çok parçanın bir DIY versiyonunun da elde edilebilir olmasıdır.\n\nBir noktayı açıkça söylemek isteriz: cihazın güvenliğini sağlayan eşleşme anahtarları ve haberleşme şifreleri kaynak kodda gizli tutulur. Bunlar yayımlansa cihazınızla uygulama arasındaki güven bozulur. Bu kapalılık, açıklığa karşı bir taviz değil, sizin güvenliğiniz için verilmiş bir karardır.\n\nSKAPP ve onunla çalışan tüm cihazlar için ilkemiz şeffaflıktır: neyin nasıl çalıştığını okuyabilmenizi, denetleyebilmenizi, kendi versiyonunuzu üretebilmenizi isteriz. Yine de her cihazın kendi lisans bölümü vardır ve koşullar farklılık gösterebilir. Bir cihazın koduna, şemasına veya kullanım koşullarına bakmak için lütfen o cihazın kendi lisans alanına göz atın.\n\nBu uygulamayı kullanarak bize destek olduğunuz için teşekkür ederiz. İyi ki varsınız.';

  @override
  String get licenseOpenSourceHeading => 'Omuzunda Durduğumuz İnsanlar';

  @override
  String get licenseOpenSourceBody =>
      'SKAPP, kendisinden önce yazılmış binlerce açık kaynak projenin üstüne kurulmuştur. Görünen arayüzü mümkün kılan Flutter ekibine ve katkıcılarına; iletişim, depolama, kriptografi, Bluetooth ve sayısız alt sistem için yıllarını veren bütün açık kaynak geliştiricilerine içtenlikle teşekkürlerimizi sunarız.\n\nAçık kaynaktan yararlandığımız için biz de geliştirdiğimiz cihazların donanım ve yazılımlarını açık olarak paylaşmaya çalışıyoruz; bizden sonra gelenler de bu birikimden yararlansın istiyoruz.\n\nBu emeğin parçası olan herkese yeniden teşekkürler.';

  @override
  String get licenseThirdPartyLink =>
      'Bu uygulamada kullanılan üçüncü-parti lisanslar';

  @override
  String get discoveryTitle => 'Cihaz bul';

  @override
  String get discoverySearching => 'Yakındaki SmartKraft cihazları aranıyor…';

  @override
  String get discoveryNoResults => 'Yakında SmartKraft cihazı bulunamadı.';

  @override
  String get discoveryTapToConnect => 'Bağlanmak için bir cihaza dokunun';

  @override
  String get discoveryRescan => 'Yeniden ara';

  @override
  String get pairingTitle => 'Cihaz eşleştir';

  @override
  String get pairingEnterPasskey =>
      'Cihaz etiketinde yazan eşleştirme kodunu girin.';

  @override
  String get pairingPasskeyHint => 'örn. K7M9P2AB';

  @override
  String get pairingConnect => 'Bağlan';

  @override
  String get pairingMockNotice =>
      'Cihaz yazılımı henüz hazır değil. Bu derlemede eşleştirme geçici olarak pasiftir.';

  @override
  String get errorBluetoothPermission =>
      'Cihazları taramak için Bluetooth izni gerekli.';

  @override
  String get errorBluetoothOff => 'Bluetooth kapalı.';

  @override
  String get errorLocationPermission =>
      'Android\'de BLE cihaz taraması için konum izni gerekli.';

  @override
  String get actionOpenSettings => 'Ayarları aç';

  @override
  String get actionGrantPermission => 'İzin ver';

  @override
  String get commonCancel => 'İptal';

  @override
  String get commonConfirm => 'Onayla';

  @override
  String get commonRetry => 'Tekrar dene';

  @override
  String get commonBack => 'Geri';

  @override
  String get commonRemove => 'Kaldır';

  @override
  String get commonRefresh => 'Yenile';

  @override
  String get commonOk => 'Tamam';

  @override
  String get commonClose => 'Kapat';

  @override
  String get commonSave => 'Kaydet';

  @override
  String get commonDelete => 'Sil';

  @override
  String get commonConnect => 'Bağlan';

  @override
  String get commonAdd => 'Ekle';

  @override
  String get commonForget => 'Unut';

  @override
  String get commonMore => 'Daha fazla';

  @override
  String get commonError => 'Hata';

  @override
  String get commonOnline => 'çevrimiçi';

  @override
  String get commonOffline => 'çevrimdışı';

  @override
  String get productBlockingFocus => 'Blocking Focus';

  @override
  String get productLebensSpur => 'LebensSpur';

  @override
  String get productGeneric => 'SmartKraft cihazı';

  @override
  String get timeJustNow => 'az önce';

  @override
  String timeMinAgo(int count) {
    return '$count dk önce';
  }

  @override
  String timeHourAgo(int count) {
    return '$count sa önce';
  }

  @override
  String timeDayAgo(int count) {
    return '$count gün önce';
  }

  @override
  String get devicesRemoveTitle => 'Cihazı kaldır';

  @override
  String devicesRemoveBody(String name) {
    return '$name kaldırılacak. Cihaz yerinde kalır; tekrar eklemek için yeniden eşleştirmen gerekir.';
  }

  @override
  String get devicesUnpair => 'Eşleşmeyi kaldır';

  @override
  String get devicesEmptyHint =>
      'SmartKraft cihazını yakına getir ve aşağıdaki düğmeye dokun.';

  @override
  String get devicesEmptyTitleNoPaired => 'Henüz eşleşmiş cihaz yok';

  @override
  String devicesLastSeen(String time) {
    return 'Son görülme: $time';
  }

  @override
  String devicesPairedAt(String time) {
    return 'Eşleşme: $time';
  }

  @override
  String devicesHubSubtitle(int count) {
    return 'SKAPP host · $count bağlı';
  }

  @override
  String get devicesHubEmptySubtitle => 'cihaz bekliyor';

  @override
  String devicesHeaderSub(int paired, int online) {
    return '$paired bağlı · $online çevrimiçi · takımyıldız görünümü';
  }

  @override
  String get devicesAddPillLabel => 'Yeni Cihaz Ekle';

  @override
  String devicesLegendOnline(int count) {
    return 'çevrimiçi ($count)';
  }

  @override
  String devicesLegendOffline(int count) {
    return 'çevrimdışı ($count)';
  }

  @override
  String devicesLegendLowBattery(int count) {
    return 'pil düşük ($count)';
  }

  @override
  String get devicesStatPaired => 'bağlı';

  @override
  String get devicesStatBf => 'BF';

  @override
  String get devicesStatLs => 'LS';

  @override
  String get devicesStatMs => 'telefon';

  @override
  String get devicesEmptyHubLabel => 'Bilinmeyen';

  @override
  String get devicesEmptyAddCta => 'İlk Cihazı Ekle';

  @override
  String get devicesEmptyHintChip => 'cihazını yakına getir, butonuna bas';

  @override
  String devicesNotifOfflineHours(int hours) {
    return '$hours saat önce çevrimdışı';
  }

  @override
  String devicesNotifOfflineMinutes(int minutes) {
    return '$minutes dk önce çevrimdışı';
  }

  @override
  String get devicesNotifLowBattery => 'pil düştü';

  @override
  String get skappPeersCardTitle => 'Eşleşmiş Desktop SKAPP\'lar';

  @override
  String get skappPeersCardSubtitle =>
      'Telefon/tablet buradan eşleşir; BF aksiyonu Desktop SKAPP\'ta script çalıştırabilsin diye. Desktop SKAPP > Ayarlar > SKAPP HTTP Dinleyici altından QR\'ı aç.';

  @override
  String get skappPeersCardEmpty => 'Henüz eşleşmiş peer yok.';

  @override
  String get skappPeersCardPairButton => 'Yeni eşle';

  @override
  String get skappPeersCardOnline => 'çevrimiçi';

  @override
  String get skappPeersCardOffline => 'çevrimdışı';

  @override
  String get skappPeersCardNeverSeen => 'görülmedi';

  @override
  String skappPeersCardRemoveTitle(String name) {
    return '$name kaldırılsın mı?';
  }

  @override
  String get skappPeersCardRemoveBody =>
      'SKAPP bu peer\'a script göndermeyi bırakacak. Aynı QR / token ile sonra yeniden eşleştirebilirsin.';

  @override
  String get skappPeersCardRemoveConfirm => 'Kaldır';

  @override
  String get skappPeersCardRemoveCancel => 'Vazgeç';

  @override
  String skappPeersCardRemovedToast(String name) {
    return '$name eşleşmesi kaldırıldı';
  }

  @override
  String get devicesCardLongPressHint => 'Yönetmek için uzun bas';

  @override
  String devicesActionsSheetTitle(String name) {
    return '$name';
  }

  @override
  String get devicesActionForget => 'Cihazı sil';

  @override
  String get devicesActionForgetSubtitle =>
      'Cihazı SKAPP\'tan kaldır. Cihazın kendisi etkilenmez; ileride yeniden eşleştirebilirsin.';

  @override
  String get devicesActionCancel => 'Vazgeç';

  @override
  String devicesForgetDialogTitle(String name) {
    return '$name silinsin mi?';
  }

  @override
  String get devicesForgetDialogBody =>
      'SKAPP bu cihazı izlemeyi bırakacak. Cihazdaki eşleşme, cihazı kendin sıfırlayana kadar yerinde kalır.';

  @override
  String devicesForgetDialogBodyWithActions(int count) {
    return 'SKAPP bu cihazı izlemeyi bırakacak ve cihaza bağlı $count SKAPI aksiyonunu da silecek. Cihazdaki eşleşme, cihazı kendin sıfırlayana kadar yerinde kalır.';
  }

  @override
  String get devicesForgetDialogConfirm => 'Sil';

  @override
  String get devicesForgetDialogCancel => 'Vazgeç';

  @override
  String devicesForgotToast(String name) {
    return '$name SKAPP\'tan kaldırıldı';
  }

  @override
  String get devicesMobileNoDetailHint =>
      'Telefon için detay sayfası yok · uzun basarak eşleşmeyi kaldır';

  @override
  String get devicesDesktopStatLabel => 'desktop';

  @override
  String get devicesDesktopGroupLabel => 'Eşli Desktop\'lar';

  @override
  String get devicesDesktopTriggerDialogTitle => 'SKAPI komutu gönderilsin mi?';

  @override
  String devicesDesktopTriggerDialogBody(String name) {
    return '$name üzerinde bağlı olan tüm mobile-touch binding\'leri çalıştırılacak.';
  }

  @override
  String get devicesDesktopTriggerDialogConfirm => 'Komutu gönder';

  @override
  String get devicesDesktopTriggerDialogCancel => 'Vazgeç';

  @override
  String get devicesDesktopForgetDialogTitle => 'Eşleşmeyi kaldır';

  @override
  String devicesDesktopForgetDialogBody(String name) {
    return '$name ile eşleşme kaldırılacak. Bu masaüstüne tekrar komut göndermek için yeniden eşleşmen gerekir.';
  }

  @override
  String devicesDesktopForgotToast(String name) {
    return '$name eşleşmesi kaldırıldı';
  }

  @override
  String get homeStatDevices => 'Cihaz';

  @override
  String get homeStatOnline => 'Çevrimiçi';

  @override
  String get homeStatWarning => 'Uyarı';

  @override
  String homeWarningMeta(String time) {
    return 'Eşleşti, hiç görülmedi · $time';
  }

  @override
  String get homeBrandTotal => 'Toplam';

  @override
  String get homeBrandActive => 'Aktif';

  @override
  String get homeBrandActions => 'Aksiyon';

  @override
  String get homeBrandVersion => 'Sürüm';

  @override
  String get smartkraftSectionProducts => 'Ürünler';

  @override
  String get smartkraftSectionCommunity => 'Topluluk';

  @override
  String get smartkraftStatusLive => 'YAYINDA';

  @override
  String get smartkraftStatusDev => 'GELİŞTİRİLİYOR';

  @override
  String get smartkraftStatusConcept => 'KONSEPT';

  @override
  String get smartkraftBlockingFocusTagline =>
      'Kaçışı olmayan zorunlu mola verme aracınız.';

  @override
  String get smartkraftLebensSpurTagline =>
      'Alışkanlıklarına bakan sessiz tanık.';

  @override
  String get smartkraftSynDimmTagline =>
      'Doğru saatte, doğru ışıkla seni tutar.';

  @override
  String homeStickyDevicesMeta(int count, int warning) {
    return '$count cihaz · $warning uyarı';
  }

  @override
  String homeStickySkapiMeta(int actions) {
    return '$actions aksiyon';
  }

  @override
  String homeStickySettingsMeta(String node, String version) {
    return '$node · v$version';
  }

  @override
  String get homeStickyComingSoonMeta => 'içerik hazırlanıyor';

  @override
  String get homeStickyNotesLabel => 'Notlar';

  @override
  String get setupChoiceTitle => 'Cihaz ekle';

  @override
  String get setupChoiceQuestion => 'Hangi durumdasın?';

  @override
  String get setupChoiceSubtitle =>
      'Cihaz fabrikadan yeni mi geldi, yoksa daha önce CLI ile WiFi\'a bağlanmış mı?';

  @override
  String get setupChoiceFreshTitle => 'Sıfırdan kurulum';

  @override
  String get setupChoiceFreshBody =>
      'Yeni bir SmartKraft cihazını ilk kez ekliyorum. BLE üzerinden eşleştirme yapılacak ve WiFi kurulum sihirbazı açılacak.';

  @override
  String get setupChoiceExistingTitle => 'Hazır cihazı SKAPP\'a ekle';

  @override
  String get setupChoiceExistingBody =>
      'Cihazımı USB/CLI ile WiFi\'a önceden bağladım, aynı ağdayım. Doğrudan WiFi üzerinden eşleştir, kurulum sihirbazını atla.';

  @override
  String get setupChoiceFooter =>
      'Emin değilsen \"Sıfırdan kurulum\"u seç, hem ilk cihaz hem de fabrika ayarlarına dönmüş cihaz için doğru yol budur.';

  @override
  String get wifiDiscoveryTitle => 'Bu ağdaki cihazlar';

  @override
  String wifiDiscoveryScanError(String error) {
    return 'Tarama hatası: $error';
  }

  @override
  String get wifiDiscoveryHint =>
      'Cihazın WiFi\'da, telefonun da aynı ağda olması gerekiyor. Eşleştirme sırasında cihazın butonuna basman istenecek.';

  @override
  String get wifiDiscoveryScanning => 'Taranıyor…';

  @override
  String get wifiDiscoveryNotFound => 'Cihaz bulunamadı';

  @override
  String wifiDiscoveryFoundCount(int count) {
    return '$count cihaz bulundu';
  }

  @override
  String get wifiDiscoveryEmptyTitle =>
      'Bu ağdaki SmartKraft cihazları aranıyor…';

  @override
  String get wifiDiscoveryEmptyTitleIdle => 'Cihaz bulunamadı.';

  @override
  String get wifiDiscoveryEmptyHint =>
      'Cihazın açık, WiFi\'a bağlı ve telefonunla aynı ağda olduğundan emin ol. Yeniden taramak için yenile düğmesini kullan.';

  @override
  String get wifiDiscoveryPairedBadge => 'eşleşmiş';

  @override
  String get wifiPairingTitle => 'Eşleştirme';

  @override
  String wifiPairingConnectFailed(String error) {
    return 'Bağlanılamadı: $error';
  }

  @override
  String wifiPairingInvalidJson(String error) {
    return 'Geçersiz JSON: $error';
  }

  @override
  String get wifiPairingClosedEarly => 'Bağlantı kapatıldı (yanıt yok)';

  @override
  String wifiPairingSendFailed(String error) {
    return 'Komut gönderilemedi: $error';
  }

  @override
  String get wifiPairingTimeout => 'Cihaz yanıt vermedi (zaman aşımı).';

  @override
  String get wifiPairingNotOpen =>
      'Cihazda eşleştirme penceresi açık değil. Butona kısaca bas ve tekrar dene.';

  @override
  String get skapiBindFixedTriggerLabel =>
      'Tetikleyici: zamanlayıcı bittiğinde';

  @override
  String get wifiPairingDeviceAlreadyBonded =>
      'Bu cihaz zaten başka bir SKAPP ile eşleşmiş. Mevcut firmware WiFi üzerinden ek peer eklemeyi desteklemiyor (TCP sadece ilk eşleşmeyi kabul ediyor). BLE üzerinden eşleştir, ya da cihazdaki mevcut eşleşmeyi sil.';

  @override
  String wifiPairingRejected(String error) {
    return 'Cihaz reddetti: $error';
  }

  @override
  String get wifiPairingMissingPub => 'Cihazdan our_pub eksik/bozuk.';

  @override
  String wifiPairingHexError(String error) {
    return 'our_pub hex çözümlenemedi: $error';
  }

  @override
  String get wifiPairingStageAwaiting => 'Cihazın butonuna bas';

  @override
  String get wifiPairingStageConnecting => 'Cihaza bağlanılıyor…';

  @override
  String get wifiPairingStageExchanging => 'Anahtarlar değişiliyor…';

  @override
  String get wifiPairingStageDone => 'Eşleştirme tamamlandı';

  @override
  String get wifiPairingStageFailed => 'Eşleştirme başarısız';

  @override
  String get wifiPairingStageAwaitingHelp =>
      'Cihazın kontrol butonuna kısa bir süre bas (3 saniyeden az). Eşleştirme penceresi 60 saniye açık kalır.';

  @override
  String get wifiPairingStageConnectingHelp => 'TCP soketi açılıyor.';

  @override
  String get wifiPairingStageExchangingHelp =>
      'pairing.ecdh.exchange gönderildi, cihazın yanıtı bekleniyor.';

  @override
  String get wifiPairingStageDoneHelp => 'Cihaz paneline yönlendiriliyor.';

  @override
  String get wifiPairingStartCta => 'Eşleştir';

  @override
  String get bfDashboardTitleFallback => 'Cihaz';

  @override
  String get bfDashboardWifiNone => 'WiFi yok';

  @override
  String get bfDashboardLinkBle => 'BLE';

  @override
  String get bfDashboardLinkWifi => 'WiFi';

  @override
  String get bfDashboardLinkUsb => 'USB';

  @override
  String get bfDashboardToggleVibration => 'Titreşim';

  @override
  String get bfDashboardToggleTilt => 'Eğim uyarısı';

  @override
  String get bfDashboardToggleLowBatt => 'Düşük pil uyarısı';

  @override
  String get bfDashboardApiChainTitle => 'API zinciri';

  @override
  String bfDashboardApiChainNone(String state) {
    return 'henüz endpoint yok · master $state';
  }

  @override
  String bfDashboardApiChainSummary(int count, String state) {
    return '$count endpoint · master $state';
  }

  @override
  String get bfDashboardMasterOn => 'açık';

  @override
  String get bfDashboardMasterOff => 'kapalı';

  @override
  String get bfDashboardNotebookTitle => 'Kullanıcı Defteri';

  @override
  String get bfDashboardNotebookSubtitle =>
      'Şifreli alan · 100 KB · serbest içerik';

  @override
  String get bfDashboardMoreDeviceInfo => 'Cihaz bilgisi';

  @override
  String get bfDashboardMoreSettings => 'Ayarlar';

  @override
  String bfDashboardWriteFailed(String error) {
    return 'Yazılamadı: $error';
  }

  @override
  String get bfDeviceInfoTitle => 'Cihaz bilgisi';

  @override
  String get bfDeviceInfoSectionGeneral => 'GENEL';

  @override
  String get bfDeviceInfoSectionConnection => 'BAĞLANTI';

  @override
  String get bfDeviceInfoSectionBattery => 'PİL';

  @override
  String get bfDeviceInfoSectionTime => 'ZAMAN';

  @override
  String get bfDeviceInfoSectionLastError => 'SON HATA';

  @override
  String get bfDeviceInfoSectionDiagnostics => 'TANILAMA';

  @override
  String get bfDeviceInfoSectionDocs => 'BELGELER';

  @override
  String get bfDeviceInfoProduct => 'Ürün';

  @override
  String get bfDeviceInfoTypeCode => 'Tip kodu';

  @override
  String get bfDeviceInfoIdentity => 'Kimlik';

  @override
  String get bfDeviceInfoHardware => 'Donanım';

  @override
  String get bfDeviceInfoFirmware => 'Firmware';

  @override
  String get bfDeviceInfoProtocol => 'Protokol';

  @override
  String get bfDeviceInfoBuild => 'Build';

  @override
  String get bfDeviceInfoUptime => 'Çalışma süresi';

  @override
  String get bfDeviceInfoWifiState => 'WiFi durumu';

  @override
  String get bfDeviceInfoIp => 'IP';

  @override
  String get bfDeviceInfoSignal => 'Sinyal';

  @override
  String get bfDeviceInfoBleAdvertising => 'BLE yayını';

  @override
  String get bfDeviceInfoBlePaired => 'BLE eşleşmeleri';

  @override
  String bfDeviceInfoPairedClients(int count) {
    return '$count istemci';
  }

  @override
  String get bfDeviceInfoBattery => 'Pil';

  @override
  String get bfDeviceInfoBatteryPresent => 'var';

  @override
  String get bfDeviceInfoBatteryAbsent => 'yok';

  @override
  String get bfDeviceInfoDeviceClock => 'Cihaz saati';

  @override
  String get bfDeviceInfoLogs => 'Cihaz logları';

  @override
  String get bfDeviceInfoLogsSubtitle =>
      'logs.get, boot, hata, timer, API olayları';

  @override
  String get bfDeviceInfoEvents => 'Olay geçmişi';

  @override
  String get bfDeviceInfoEventsSubtitle =>
      'Yerel · timer, yüz değişimi, API tetikleri';

  @override
  String get bfDeviceInfoUserGuide => 'Kullanım kılavuzu';

  @override
  String get bfDeviceInfoUserGuideSubtitle =>
      'Yüz ataması, timer, API tetikleyiciler';

  @override
  String get bfDeviceInfoDevNotes => 'SK geliştirici notları';

  @override
  String get bfDeviceInfoDevNotesSubtitle =>
      'CLI komutları, mimari, olay taksonomisi';

  @override
  String get bfDeviceInfoLicense => 'Lisans ve açık kaynaklar';

  @override
  String get bfDeviceInfoLicenseSubtitle =>
      'Kullanılan kütüphaneler ve telif bilgileri';

  @override
  String get bfDeviceInfoComingSoon => 'Yakında';

  @override
  String bfDeviceInfoUptimeSecs(int n) {
    return '$n sn';
  }

  @override
  String bfDeviceInfoUptimeMins(int n) {
    return '$n dk';
  }

  @override
  String bfDeviceInfoUptimeHours(int h, int m) {
    return '$h sa $m dk';
  }

  @override
  String bfDeviceInfoUptimeDays(int d, int h) {
    return '$d gün $h sa';
  }

  @override
  String get bfDeviceInfoYes => 'evet';

  @override
  String get bfDeviceInfoNo => 'hayır';

  @override
  String get bfSettingsTitle => 'Ayarlar';

  @override
  String get bfSettingsSectionNetwork => 'AĞ';

  @override
  String get bfSettingsSectionUpdates => 'GÜNCELLEMELER';

  @override
  String get bfSettingsSectionDanger => 'TEHLİKELİ İŞLEMLER';

  @override
  String get bfSettingsWifiPrimary => 'Birincil WiFi';

  @override
  String get bfSettingsWifiSecondary => 'Yedek WiFi';

  @override
  String get bfSettingsWifiUnconfigured => 'Yapılandırılmamış';

  @override
  String get bfSettingsFirmware => 'Firmware';

  @override
  String get bfSettingsCheckUpdates => 'Güncellemeyi başlat';

  @override
  String get bfSettingsCheckUpdatesSubtitle =>
      'Manifest URL tanımlanınca aktif olur';

  @override
  String get bfOtaTitle => 'Firmware güncelleme';

  @override
  String get bfOtaCurrentLabel => 'Yüklü sürüm';

  @override
  String get bfOtaRunningPartitionLabel => 'Aktif bölüm';

  @override
  String get bfOtaCheckCta => 'Güncellemeleri kontrol et';

  @override
  String get bfOtaIdleHint => 'Henüz güncelleme kontrolü yapılmadı.';

  @override
  String get bfOtaChecking => 'Güncelleme sunucusu kontrol ediliyor…';

  @override
  String get bfOtaUpToDate => 'Cihaz güncel.';

  @override
  String bfOtaAvailable(String version) {
    return 'Yeni sürüm mevcut: $version';
  }

  @override
  String get bfOtaUpdateCta => 'Şimdi güncelle';

  @override
  String bfOtaDownloading(int pct) {
    return 'İndiriliyor… %$pct';
  }

  @override
  String get bfOtaDone => 'Güncellendi. Cihaz yeniden başlatılıyor…';

  @override
  String bfOtaErrorMsg(String message) {
    return 'Hata: $message';
  }

  @override
  String get bfOtaRollbackCta => 'Önceki sürüme dön';

  @override
  String get bfOtaUpdateConfirmTitle => 'Firmware güncellensin mi?';

  @override
  String bfOtaUpdateConfirmBody(String version) {
    return '$version sürümü indirilip kurulacak, ardından cihaz yeniden başlayacak. Bu sırada cihazı kapatma.';
  }

  @override
  String get bfOtaRollbackConfirmTitle => 'Önceki firmware\'e dönülsün mü?';

  @override
  String get bfOtaRollbackConfirmBody =>
      'Cihaz önceki firmware sürümünü açıp yeniden başlayacak.';

  @override
  String get bfSettingsReboot => 'Yeniden başlat';

  @override
  String get bfSettingsRebootSubtitle =>
      'Cihazı kapat ve aç · aktif sayım iptal olur';

  @override
  String get bfSettingsRebootConfirmTitle => 'Yeniden başlat?';

  @override
  String get bfSettingsRebootConfirmBody =>
      'Cihaz birkaç saniye kapanıp açılacak.';

  @override
  String get bfSettingsUnpairThisPhone => 'Bu telefonun eşleşmesini kaldır';

  @override
  String get bfSettingsUnpairSubtitle =>
      'Bond silinir; cihazı yeniden eşleştirmek gerekir';

  @override
  String get bfSettingsUnpairConfirmTitle => 'Eşleşmeyi kaldır?';

  @override
  String get bfSettingsFactoryReset => 'Fabrika ayarlarına dön';

  @override
  String get bfSettingsFactoryResetSubtitle =>
      'WiFi, API uçları, eşleşme, hepsi silinir';

  @override
  String get bfSettingsFactoryResetConfirmTitle => 'Fabrika ayarlarına dön?';

  @override
  String get bfSettingsFactoryResetConfirmBody =>
      'Tüm ayarlar silinecek. Cihaz yeniden başlatılacak.';

  @override
  String get bfWifiManagementTitle => 'WiFi yönetimi';

  @override
  String get bfWifiConnecting => 'Bağlanıyor…';

  @override
  String bfWifiConnectionRejected(String error) {
    return 'Bağlantı reddedildi: $error';
  }

  @override
  String bfWifiConfigure(String label) {
    return '$label yapılandır';
  }

  @override
  String get bfWifiPasswordLabel => 'Şifre';

  @override
  String get bfNotebookTitle => 'Kullanıcı Defteri';

  @override
  String get bfNotebookSaveCancel => 'Vazgeç';

  @override
  String get bfApiChainCancel => 'Vazgeç';

  @override
  String get bfApiChainRunChain => 'Zinciri çalıştır';

  @override
  String get bfApiChainToggleAll => 'Tümünü aç/kapat';

  @override
  String get bfApiChainFieldName => 'İsim';

  @override
  String get bfApiChainFieldType => 'Tür';

  @override
  String get bfApiChainFieldHeaderName => 'Header adı';

  @override
  String get bfApiChainFieldNewToken => 'Yeni token (boş bırakılırsa değişmez)';

  @override
  String get bfHomeLoadingConnecting => 'Cihaza bağlanılıyor…';

  @override
  String get bfHomeLoadingSecure => 'Güvenli kanal açılıyor…';

  @override
  String get deviceConnUnreachableTitle => 'Cihaza ulaşılamıyor';

  @override
  String get deviceConnUnreachableBody =>
      'Cihaz kapalı, menzil dışında veya uyku modunda olabilir. Açık ve yakın olduğundan emin olup tekrar deneyin.';

  @override
  String get deviceConnRepairTitle => 'Eşleşme yenilenmeli';

  @override
  String get deviceConnRepairBody =>
      'Cihaz sıfırlanmış ve bu telefonu artık tanımıyor görünüyor. Yeniden bağlanmak için tekrar eşleştirin.';

  @override
  String get deviceConnRepairButton => 'Yeniden eşleştir';

  @override
  String get deviceConnTechnicalDetails => 'Teknik ayrıntılar';

  @override
  String get bfLogsTitle => 'Cihaz günlükleri';

  @override
  String get bfEventsTitle => 'Olay geçmişi';

  @override
  String get pairingStepConnecting => 'Bağlanılıyor';

  @override
  String get pairingStepConnectingSubtitle => 'BLE bağlantısı + GATT keşfi';

  @override
  String get pairingStepMutualAuth => 'Karşılıklı doğrulama';

  @override
  String get pairingStepDeviceInfo => 'device.info doğrulaması';

  @override
  String get pairingStepDeviceInfoSubtitle =>
      'Şifreli kanal canlı, sanity ping';

  @override
  String get pairingStepConnected => 'Bağlantı kuruldu';

  @override
  String get pairingStepConnectedSubtitle =>
      'CLI hazır, yapılandırmaya geçiliyor';

  @override
  String get pairingStepKeyExchange => 'Anahtar değişimi';

  @override
  String get pairingStepKeyExchangeSubtitle =>
      'X25519, public anahtar gönderildi';

  @override
  String get pairingStepVerifying => 'Doğrulanıyor';

  @override
  String get pairingStepVerifyingSubtitle =>
      'Cihaz cevabı bekleniyor, token üretiliyor';

  @override
  String get pairingStepDone => 'Eşleşme tamamlandı';

  @override
  String get pairingStepDoneSubtitle => 'Bond cihazda ve telefonda saklandı';

  @override
  String get pairingLogTitle => 'Eşleşme günlüğü';

  @override
  String get pairingLogCopied => 'Günlük panoya kopyalandı';

  @override
  String get discoveryPreparing => 'Hazırlanıyor…';

  @override
  String get discoveryBluetoothOff => 'Bluetooth kapalı';

  @override
  String get wifiPasswordTitle => 'Cihazı WiFi\'a bağla';

  @override
  String get wifiPasswordSsidLabel => 'Ağ adı (SSID)';

  @override
  String get wifiPasswordNetworkLabel => 'Ağ';

  @override
  String get wifiPasswordPasswordLabel => 'Şifre';

  @override
  String get wifiPasswordConnect => 'Bağlan';

  @override
  String get wifiPasswordLogTitle => 'Bağlantı günlüğü';

  @override
  String get wifiPasswordLogCopied => 'Günlük panoya kopyalandı';

  @override
  String get wifiScanTitle => 'Cihaz için WiFi ağı seç';

  @override
  String get wifiScanRescanTooltip => 'Cihaz tekrar tarasın';

  @override
  String get wifiScanRunning => 'Cihazın WiFi tarayıcısı çalışıyor…';

  @override
  String get wifiScanNoNetworks => 'Cihaz çevresinde WiFi ağı bulamadı.';

  @override
  String get wifiScanRescan => 'Cihaz tekrar tarasın';

  @override
  String get wifiScanHiddenAdd => 'Gizli ağ ekle';

  @override
  String get wifiScanHiddenSubtitle => 'SSID el ile yazılır';

  @override
  String get wifiScanLogTitle => 'WiFi tarama günlüğü';

  @override
  String get wifiSuccessReady => 'Hazır';

  @override
  String get bfEventsClearTooltip => 'Temizle';

  @override
  String get bfEventsEmpty =>
      'Henüz olay yok. Cihaz olay yayınlamaya başladığında burada listelenecek.';

  @override
  String get logsEmptyTooltip => 'Günlük boş.';

  @override
  String logsErrorPrefix(String error) {
    return 'Hata: $error';
  }

  @override
  String get notebookSaved => 'Kaydedildi';

  @override
  String notebookSaveError(String error) {
    return 'Hata: $error';
  }

  @override
  String notebookCapacityExceeded(int used, int capacity) {
    return 'Kapasite aşıldı: $used / $capacity bayt';
  }

  @override
  String get notebookClearTooltip => 'Defteri temizle';

  @override
  String get notebookClearConfirmTitle => 'Defteri tamamen temizle?';

  @override
  String get notebookClearConfirmBody =>
      'Cihazdaki tüm kullanıcı verisi silinir. Geri alınamaz.';

  @override
  String get notebookClearAction => 'Temizle';

  @override
  String get notebookClearedSnack => 'Defter temizlendi';

  @override
  String notebookClearError(String error) {
    return 'Temizlenemedi: $error';
  }

  @override
  String get notebookEncryptedHint =>
      'Şifrelenmiş alan · sadece eşleşmiş SKAPP erişebilir';

  @override
  String get notebookEmptyTitle => 'Defter boş';

  @override
  String get notebookEmptyBody =>
      'Aşağıdaki alana not, JSON, scene tanımı ya da herhangi bir metin yazabilirsin. Kaydet\'e basınca cihazda şifreli olarak saklanır.';

  @override
  String get notebookHint =>
      'İstediğin içeriği buraya yaz (notlar, JSON, kendi şeman). Cihazda 100 KB\'a kadar saklanır.';

  @override
  String get notebookDirty => 'Kaydedilmemiş değişiklik var';

  @override
  String get notebookSaved2 => 'Kayıtlı';

  @override
  String get notebookSyncedDifferent => 'Senkron';

  @override
  String get notebookSaveCta => 'Kaydet';

  @override
  String wifiPairingHexErrorRaw(String error) {
    return 'our_pub hex çözümlenemedi: $error';
  }

  @override
  String get bfWifiForgetTitle => 'Slotu unut?';

  @override
  String get bfWifiForgetBody =>
      'Slot tamamen silinir. Eğer aktif bağlantı buradaysa cihaz bu ağdan ayrılır ve diğer slota düşer (varsa). Geri almak için yeniden yapılandırma gerekir.';

  @override
  String get bfWifiForget => 'Unut';

  @override
  String get bfWifiHint =>
      'Cihaz iki ağı sıraya alır: önce Birincil, başarısız olursa Yedek. Aktif slot yeşil noktayla işaretli.';

  @override
  String get bfWifiActive => 'AKTİF';

  @override
  String get bfWifiNotConfigured => 'Yapılandırılmamış';

  @override
  String get bfWifiChange => 'Değiştir';

  @override
  String get bfWifiSetUp => 'Yapılandır';

  @override
  String get discoveryStatusChecking => 'Bluetooth durumu kontrol ediliyor.';

  @override
  String get discoveryPermissionsTitle => 'Bluetooth izni gerekli';

  @override
  String get discoveryPermissionsBody =>
      'Yakındaki SmartKraft cihazlarını bulabilmek için Bluetooth iznini etkinleştirmelisiniz.';

  @override
  String get discoveryPermissionsRetry => 'İzinleri yeniden iste';

  @override
  String get discoveryPermissionsOpenSettings => 'Ayarları aç';

  @override
  String get discoveryAdapterOffBody =>
      'Cihazları arayabilmek için Bluetooth\'u açın.';

  @override
  String get discoveryAdapterOffEnable => 'Bluetooth\'u aç';

  @override
  String get discoveryUnsupportedTitle => 'BLE desteklenmiyor';

  @override
  String get discoveryUnsupportedBody =>
      'Bu cihaz Bluetooth Low Energy desteklemiyor, SKAPP çalışmak için BLE\'ye ihtiyaç duyar.';

  @override
  String get wifiPasswordHelp =>
      'Cihaz bu ağa bağlanacak. Şifreyi gir, dikkatlice yaz.';

  @override
  String get wifiPasswordRequired => 'Şifre gerekli';

  @override
  String get wifiPasswordMinLength => 'En az 8 karakter';

  @override
  String wifiPasswordSendError(String error) {
    return 'Gönderilemedi: $error';
  }

  @override
  String get wifiScanTimeoutHint =>
      'Tarama uzun sürerse cihaz WiFi menzilini kaybetmiş olabilir. Tekrar dene.';

  @override
  String get wifiScanFailedTitle => 'Tarama başarısız';

  @override
  String get wifiScanRetry => 'Tekrar dene';

  @override
  String get wifiSuccessTitle => 'Bağlandı';

  @override
  String get wifiSuccessBody => 'Cihaz WiFi\'da artık. Panele dönülüyor…';

  @override
  String get deviceNameSectionHeading => 'CİHAZ İSMİ (SADECE BU UYGULAMADA)';

  @override
  String get deviceNameLabel => 'Özel isim';

  @override
  String get deviceNameHint => 'örn. Ofis BF';

  @override
  String get deviceNameSubtitle =>
      'Bu SKAPP\'taki kartlarda görünür. Cihaza gönderilmez.';

  @override
  String get deviceNameClear => 'Temizle';

  @override
  String get deviceNameSave => 'Kaydet';

  @override
  String get deviceNameSaved => 'Kaydedildi';

  @override
  String get deviceNameEmptyPlaceholder => '(özel isim yok)';

  @override
  String get settingsUsbConsoleTitle => 'USB CLI konsolu';

  @override
  String get settingsUsbConsoleSubtitle =>
      'USB ile takılı cihaza ham komut gönder';

  @override
  String get usbConsoleAppBarTitle => 'USB Konsol';

  @override
  String get usbConsolePickPortTitle => 'Port seç';

  @override
  String get usbConsolePickPortHint =>
      'USB ile cihaz bağla ve yenile düğmesine bas';

  @override
  String get usbConsolePortRefreshTooltip => 'Portları yenile';

  @override
  String get usbConsoleBfBadge => 'SmartKraft';

  @override
  String get usbConsoleConnecting => 'Bağlanılıyor…';

  @override
  String get usbConsoleConnected => 'Bağlı';

  @override
  String get usbConsoleDisconnected => 'Bağlantı kesildi';

  @override
  String usbConsoleErrorBanner(String error) {
    return 'Hata: $error';
  }

  @override
  String get usbConsoleReconnect => 'Yeniden bağlan';

  @override
  String get usbConsoleDisconnect => 'Bağlantıyı kes';

  @override
  String get usbConsoleClear => 'Konsolu temizle';

  @override
  String get usbConsoleInputHint => 'Komut yaz, örn: device.info';

  @override
  String get usbConsoleSend => 'Gönder';

  @override
  String get usbConsoleEmptyHint =>
      'Komut yaz ve Enter\'a bas, dene: device.info';

  @override
  String get usbConsoleEntryEvent => 'evt';

  @override
  String get usbConsoleEntryError => 'hata';

  @override
  String get usbConsoleNotSupportedIos => 'USB konsol iOS\'ta desteklenmiyor';

  @override
  String get passphraseFieldLabel => 'Şifre';

  @override
  String get passphraseVerifyButton => 'Doğrula';

  @override
  String passphraseAttemptsLeft(int count) {
    return 'Kalan deneme: $count';
  }

  @override
  String get passphraseLockoutTriggered =>
      'Yanlış şifre limiti aşıldı; cihaz fabrika ayarlarına döndü.';

  @override
  String get bondPeerUnnamed => '(isimsiz)';

  @override
  String get pairingPassphraseDialogTitle => 'Cihaz şifresi';

  @override
  String get pairingPassphraseDialogBody =>
      'Bu cihaz içerik erişimi için şifre istiyor. Eşleşmenin tamamlanması için şifreyi gir.';

  @override
  String get pairingPassphraseCancelled =>
      'Şifre girilmedi, eşleşme iptal edildi.';

  @override
  String pairingPassphraseSendError(String error) {
    return 'Şifre gönderilemedi: $error';
  }

  @override
  String get pairingPassphraseTimeout =>
      'Cihaz cevap vermedi (şifre verify, 8 sn).';

  @override
  String get pairingWindowClosedRetry =>
      'Eşleşme penceresi kapandı, butona kısa bas, tekrar dene.';

  @override
  String pairingPassphraseFailed(String error) {
    return 'Şifre doğrulanamadı: $error';
  }

  @override
  String get bondStoreFullHeader =>
      'Cihazda 8 bond slotu da dolu. Yeni bir SKAPP eşleştirebilmek için önce mevcut peer\'lerden birini kaldır:';

  @override
  String bondStoreFullPeerLine(Object slot, String name, String shortPid) {
    return '  • slot $slot, $name [#$shortPid]';
  }

  @override
  String get bondStoreFullFooter =>
      'Eşleşmiş başka bir SKAPP\'tan veya USB üzerinden\n`bond.remove --slot N` çalıştır, sonra burada Tekrar dene\'ye bas.';

  @override
  String get passphraseGateDialogBody =>
      'Bu cihaz her bağlantıda şifre istiyor. İçeriğe erişmek için şifreyi gir.';

  @override
  String get passphraseGateCancelled =>
      'Şifre girilmedi, ekrana erişim için doğrulama gerekli.';

  @override
  String passphraseGateVerifyError(String error) {
    return 'Doğrulama hatası: $error';
  }

  @override
  String passphraseGateCommError(String error) {
    return 'İletişim hatası: $error';
  }

  @override
  String get passphraseGateUnknownError => 'Bilinmeyen kilit hatası.';

  @override
  String get bfPassphraseTitle => 'Cihaz Şifresi';

  @override
  String get bfPassphraseSetTitle => 'Şifre belirle';

  @override
  String get bfPassphraseChangeTitle => 'Şifreyi değiştir';

  @override
  String get bfPassphraseClearTitle => 'Şifreyi kaldır';

  @override
  String get bfPassphraseChangeSubtitle => 'Eski şifreyi gir, yenisini belirle';

  @override
  String get bfPassphraseClearSubtitle => 'Cihazdan içerik kilidini sıfırla';

  @override
  String get bfPassphraseModePairing => 'Pairing\'de iste';

  @override
  String get bfPassphraseModePairingSubtitle =>
      'Yeni bir SKAPP eşleştiğinde şifre sorulur. Mevcut peer\'lerden istemez.';

  @override
  String get bfPassphraseModeAlways => 'Her bağlantıda iste';

  @override
  String get bfPassphraseModeAlwaysSubtitle =>
      'Her oturum açılışında şifre sorulur. SKAPP çalınsa bile içerik kilitli kalır.';

  @override
  String get bfPassphraseStatusNone =>
      'Şifre yok, cihaza içerik kilidi konmamış';

  @override
  String get bfPassphraseStatusActiveOff =>
      'Şifre var · enforcement kapalı (her iki toggle off)';

  @override
  String get bfPassphraseStatusActivePairing => 'Pairing\'de istenir';

  @override
  String get bfPassphraseStatusActiveAlways => 'Her bağlantıda istenir';

  @override
  String get bfPassphraseBadgeActive => 'Şifre aktif';

  @override
  String get bfPassphraseBadgeNone => 'Şifre yok';

  @override
  String bfPassphraseAttemptsRatio(int left, int total) {
    return 'Kalan deneme: $left / $total';
  }

  @override
  String bfPassphraseLengthSubtitle(int min, int max) {
    return 'Uzunluk $min-$max karakter';
  }

  @override
  String bfPassphraseLengthHint(int min, int max) {
    return 'Uzunluk: $min-$max';
  }

  @override
  String bfPassphraseTooShort(int min) {
    return 'En az $min karakter';
  }

  @override
  String bfPassphraseTooLong(int max) {
    return 'En fazla $max karakter';
  }

  @override
  String get bfPassphraseEmpty => 'Boş olamaz';

  @override
  String get bfPassphraseNewLabel => 'Yeni şifre';

  @override
  String get bfPassphraseCurrentLabel => 'Mevcut şifre';

  @override
  String get bfPassphraseSetDone => 'Şifre belirlendi';

  @override
  String get bfPassphraseChangeDone => 'Şifre değiştirildi';

  @override
  String get bfPassphraseClearDone => 'Şifre kaldırıldı';

  @override
  String bfPassphraseStatusReadError(String error) {
    return 'Durum okunamadı: $error';
  }

  @override
  String get bfPassphraseNotesTitle => 'Notlar';

  @override
  String get bfPassphraseNotesBody =>
      '• Şifre cihazda PBKDF2-SHA256 ile hash\'lenir, hiç plaintext saklanmaz.\n• 10 yanlış denemede cihaz fabrika ayarlarına döner; tüm eşleşmeler ve veriler silinir.\n• USB ile takılı cihaz şifre sormaz, fiziksel erişim zaten butonla factory-reset hakkı veriyor.';

  @override
  String bfBondListTitle(int used, int capacity) {
    return 'Eşleşmiş SKAPP\'lar  ($used/$capacity)';
  }

  @override
  String get bfBondListEmpty => 'Henüz eşleşmiş peer yok.';

  @override
  String get bfBondListBadgeThisPhone => 'Bu telefon';

  @override
  String get bfBondListBadgeActiveSession => 'Aktif oturum';

  @override
  String bfBondListRowSubtitle(String shortPid, String date) {
    return '#$shortPid · eşleşme: $date';
  }

  @override
  String get bfBondListRemoveTooltip => 'Bu eşleşmeyi kaldır';

  @override
  String get bfBondListRemoveTitle => 'Eşleşmeyi kaldır?';

  @override
  String get bfBondListRemoveSelfBody =>
      'Bu telefonun eşleşmesini kaldırıyorsun. Onaylarsan oturum kopar; cihaza tekrar ulaşmak için butona kısa basıp yeniden eşleştirmen gerekir.';

  @override
  String bfBondListRemoveOtherBody(String label, int slot) {
    return '\"$label\" (slot $slot) eşleşmesi cihazdan silinir. O SKAPP\'ın yeniden bağlanması için butona kısa basıp yeniden eşleşmesi gerekir.';
  }

  @override
  String bfBondListSlotRemoved(int slot) {
    return 'Slot $slot kaldırıldı';
  }

  @override
  String bfBondListFetchError(String error) {
    return 'bond.list başarısız: $error';
  }

  @override
  String get bfSettingsSectionSecurity => 'GÜVENLİK';

  @override
  String get bfSettingsPassphraseTitle => 'Cihaz şifresi';

  @override
  String get bfSettingsBondListTitle => 'Eşleşmiş SKAPP\'lar';

  @override
  String get bfSettingsPassphraseSubtitleAlways => 'Aktif, her bağlantıda';

  @override
  String get bfSettingsPassphraseSubtitlePairing => 'Aktif, pairing\'de';

  @override
  String get bfSettingsPassphraseSubtitleOff => 'Aktif, enforcement kapalı';

  @override
  String bfSettingsBondsSubtitle(int count, int capacity) {
    return 'Eşleşmiş peer: $count / $capacity';
  }

  @override
  String get skapiHowItWorksTitle => 'Nasıl Çalışır';

  @override
  String skapiHowItWorksBody(String deviceName) {
    return 'SmartKraft cihazınız (örneğin $deviceName) bir olay yaşadığında, mesela zamanlayıcı dolduğunda, bir butona basıldığında veya bir sensör tetiklendiğinde, bilgisayarınıza küçük bir komut yollar. Bilgisayarınız bu komutu alır ve seçtiğiniz script\'i çalıştırır.';
  }

  @override
  String get skapiHowItWorksFlowDeviceLabel => 'SmartKraft Cihazı';

  @override
  String get skapiHowItWorksFlowDeviceSub =>
      'örn. Blocking Focus, olay tetikler';

  @override
  String get skapiHowItWorksFlowComputerLabel => 'Bilgisayar';

  @override
  String get skapiHowItWorksFlowComputerSub =>
      'SKAPP komutu alır, script çalışır';

  @override
  String get skapiHowItWorksFoot =>
      'Bilgisayarınızda SKAPP açık olmalı. Tüm trafik wifi ağında kalır, internet gerekmez, hiçbir veri dışarı çıkmaz.';

  @override
  String get skapiPlatformGroupsHeader => 'Aksiyon Kategorileri';

  @override
  String skapiPlatformGroupsLoadError(String error) {
    return 'Gruplar yüklenemedi: $error';
  }

  @override
  String get skapiPlatformEmptyTitle => 'Bu platform için henüz script yok';

  @override
  String get skapiPlatformEmptyBody =>
      'Bu platforma özel script\'ler hazırlanıyor. Sonraki SKAPP güncellemesiyle gelecek.';

  @override
  String skapiGroupScriptsLoadError(String error) {
    return 'Script\'ler yüklenemedi: $error';
  }

  @override
  String skapiScriptDetailLoadError(String error) {
    return 'Bu script yüklenemedi: $error';
  }

  @override
  String get skapiBindScreenTitle => 'Aksiyona Bağla';

  @override
  String get skapiBindScreenSubtitle =>
      'Bir cihaz olayı tetiklendiğinde bu script\'i otomatik çalıştır.';

  @override
  String get skapiBindFieldDeviceLabel => 'Cihaz';

  @override
  String get skapiBindFieldDeviceHint =>
      'Bu script\'i hangi eşleşmiş cihazın tetikleyeceğini seç.';

  @override
  String get skapiBindFieldDeviceEmpty =>
      'Henüz eşleşmiş cihaz yok. Önce Cihazlarım sekmesinden bir cihaz eşle.';

  @override
  String get skapiBindFieldEventLabel => 'Olay';

  @override
  String get skapiBindFieldEventHint =>
      'Cihaz bu olayı yayınlar; gerçekleştiğinde script çalışır.';

  @override
  String get skapiBindEventTimerStarted => 'Zamanlayıcı başladı';

  @override
  String get skapiBindEventTimerExpired => 'Zamanlayıcı doldu';

  @override
  String get skapiBindEventFaceChanged => 'Küp yüzü değişti';

  @override
  String get skapiBindEventButtonPressed => 'Butona basıldı';

  @override
  String get skapiBindEventButtonHeld => 'Buton basılı tutuldu';

  @override
  String get skapiBindEventBatteryLow => 'Pil düşük';

  @override
  String get skapiBindEventBatteryLockout => 'Pil kilidi';

  @override
  String get skapiBindEventPowerStateChanged => 'Güç durumu değişti';

  @override
  String get skapiBindEventPairingSuccess => 'Eşleştirme başarılı';

  @override
  String get skapiBindEventApiSent => 'API çağrısı gönderildi';

  @override
  String get skapiBindParamsHeader => 'Parametre değerleri';

  @override
  String get skapiBindParamsHint =>
      'Boş bırakırsan script varsayılanları kullanılır. Bağlama her tetiklendiğinde bu değerler gönderilir.';

  @override
  String get skapiBindButtonSave => 'Bağlamayı kaydet';

  @override
  String get skapiBindButtonDelete => 'Bağlamayı sil';

  @override
  String get skapiBindButtonCancel => 'İptal';

  @override
  String get skapiBindButtonEnable => 'Etkinleştir';

  @override
  String get skapiBindButtonDisable => 'Duraklat';

  @override
  String get skapiBindStatusEnabled => 'Aktif';

  @override
  String get skapiBindStatusDisabled => 'Duraklatıldı';

  @override
  String get skapiBindSavedToast => 'Bağlama kaydedildi';

  @override
  String get skapiBindDeletedToast => 'Bağlama silindi';

  @override
  String skapiBindBadgeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bağlama',
      one: '1 bağlama',
    );
    return '$_temp0';
  }

  @override
  String get skapiBindNoPairedDeviceWarning =>
      'Bağlama oluşturmak için önce bir cihaz eşle.';

  @override
  String skapiBindTriggeredDesktopToast(String script) {
    return 'Tetiklendi: $script';
  }

  @override
  String skapiBindTriggeredMobileToast(String event) {
    return 'Bağlama tetiklendi ($event); çalıştırma Faz K\'de gelecek.';
  }

  @override
  String skapiBindLoadError(String error) {
    return 'Bağlamalar yüklenemedi: $error';
  }

  @override
  String get skapiBindListSectionTitle => 'Bu script üzerindeki bağlamalar';

  @override
  String get skapiBindListEmpty =>
      'Henüz bağlama yok. Aksiyona Bağla\'ya basarak oluştur.';

  @override
  String get skapiBindNewButton => 'Yeni bağlama';

  @override
  String get skapiBasicSettingsTitle => 'Ayarlar';

  @override
  String get skapiBasicEmptyParams =>
      'Bu script ayar istemez. Şimdi Çalıştır\'a basın.';

  @override
  String get skapiBasicUnitSeconds => 'saniye';

  @override
  String get skapiBasicConvHalfMinute => 'yarım dakika';

  @override
  String get skapiBasicConvLessThanMinute => '1 dakikadan az';

  @override
  String skapiBasicConvMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dakika',
      one: '1 dakika',
    );
    return '$_temp0';
  }

  @override
  String skapiBasicConvHoursMinutes(int hours, int minutes) {
    return '$hours saat $minutes dakika';
  }

  @override
  String skapiBasicConvHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saat',
      one: '1 saat',
    );
    return '$_temp0';
  }

  @override
  String get skapiBasicConvImmediate => 'hemen çalışır';

  @override
  String skapiBasicConvAfter(String time) {
    return '$time sonra';
  }

  @override
  String get skapiBasicPrerunSectionTitle => 'Çalıştırmadan önce bekleme';

  @override
  String get skapiBasicPrerunAddCta => 'Geciktirme ekle';

  @override
  String get skapiBasicPrerunLabel =>
      'Script başlamadan önce bu kadar saniye beklensin';

  @override
  String get skapiBasicPrerunHelp =>
      'Bildirim önce görünsün veya aksiyonları zincirlemek istediğinde işe yarar. Varsayılan 0 hemen başlatır.';

  @override
  String get skapiBasicPrerunRemove => 'Geciktirmeyi kaldır';

  @override
  String get skapiBasicListAddPlaceholder => '+ ekle';

  @override
  String get skapiRunSheetTitle => 'Script Çalıştır';

  @override
  String get skapiRunSheetStatusRunning => 'Çalışıyor';

  @override
  String get skapiRunSheetStatusOk => 'Tamamlandı';

  @override
  String get skapiRunSheetStatusError => 'Başarısız';

  @override
  String skapiRunSheetExitCode(int code) {
    return 'Çıkış kodu: $code';
  }

  @override
  String get skapiRunSheetCancel => 'İptal';

  @override
  String get skapiRunSheetClose => 'Kapat';

  @override
  String get skapiRunSheetCopyOutput => 'Çıktıyı kopyala';

  @override
  String get skapiRunSheetCopiedDone => 'Kopyalandı';

  @override
  String get skapiRunSheetEmptyOutput => 'Çıktı bekleniyor...';

  @override
  String get skapiRunSheetDismissConfirmTitle => 'Script\'i durdur?';

  @override
  String get skapiRunSheetDismissConfirmBody =>
      'Script hâlâ çalışıyor. Bu paneli kapatmak çalışmayı iptal eder.';

  @override
  String get skapiRunSheetDismissConfirmStay => 'Çalışmaya devam et';

  @override
  String get skapiRunSheetDismissConfirmStop => 'İptal et';

  @override
  String get skapiRunErrorPowerShellMissing =>
      'Bu sistemde PowerShell bulunamadı.';

  @override
  String skapiRunErrorTempWrite(String error) {
    return 'Script geçici klasöre yazılamadı: $error';
  }

  @override
  String skapiRunErrorSpawn(String error) {
    return 'PowerShell başlatılamadı: $error';
  }

  @override
  String skapiRunDurationMs(int ms) {
    return 'Süre: $ms ms';
  }

  @override
  String get skapiCopiedToClipboard => 'Kopyalandı';

  @override
  String get skapiFavouriteAddTooltip => 'Favorilere ekle';

  @override
  String get skapiFavouriteRemoveTooltip => 'Favorilerden çıkar';

  @override
  String skapiGroupAppBarSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count script',
      one: '1 script',
    );
    return '$_temp0';
  }

  @override
  String get skapiPlatformScreenCategoriesTitle => 'Aksiyon Kategorileri';

  @override
  String skapiPlatformScreenCategoriesSub(int groups, int scripts) {
    return '$groups grup · toplam $scripts script';
  }

  @override
  String get skapiGroupScriptsHeader => 'Script\'ler';

  @override
  String skapiGroupScriptsCount(int count) {
    return '$count script';
  }

  @override
  String skapiGroupItemCount(int count) {
    return '$count script';
  }

  @override
  String get skapiGroupPowerTitle => 'Güç Yönetimi';

  @override
  String get skapiGroupPowerDesc =>
      'Bu gruptaki script\'ler bilgisayarı kilitler, uyutur, hazırda bekletir veya kapatır. SmartKraft cihazınız bir odak seansının sonunu bildirdiğinde veya uzun süreli boşta kalma tespit ettiğinde makinenin de ona uymasını istediğinizde işe yarar.';

  @override
  String get skapiGroupPowerFoot =>
      'Tipik kullanım: ayağa kalkarken kilitle, gün sonunda hazırda beklet, uzun boşta kalmadan sonra zamanlanmış kapatma.';

  @override
  String get skapiScriptLockTitle => 'Bilgisayarı Kilitle';

  @override
  String get skapiScriptLockSummaryWhat =>
      'Windows\'u anında kilitler ve oturum açma ekranına döner. Açık uygulamalar çalışmaya devam eder.';

  @override
  String get skapiScriptLockSummaryHow =>
      'user32 LockWorkStation Win32 fonksiyonunu çağırır. Win+L tuş kombinasyonuyla aynıdır.';

  @override
  String get skapiScriptHibernateTitle => 'Hazırda Beklet';

  @override
  String get skapiScriptHibernateSummaryWhat =>
      'Mevcut oturumu diske kaydeder ve makineyi kapatır. Yeniden başlatıldığında bıraktığınız yere döner, batarya bitse bile.';

  @override
  String get skapiScriptHibernateSummaryHow =>
      'Yerleşik shutdown.exe komutunu /h bayrağıyla çalıştırır. Windows güç ayarlarında hazırda bekletme açık olmalı; değilse Windows uyku moduna geçer.';

  @override
  String get skapiScriptHibernateNote =>
      'Sisteminizde hazırda bekletme yoksa yönetici terminalinde bir kez powercfg /hibernate on çalıştırın.';

  @override
  String get skapiScriptHibernateParamDelayLabel => 'delay';

  @override
  String get skapiScriptHibernateParamDelayHint =>
      'Hazırda bekletmeden önce beklenecek saniye, cihazın bildiriminin önce görünmesi gerekiyorsa.';

  @override
  String get skapiScriptSleepTitle => 'Uyku';

  @override
  String get skapiScriptSleepSummaryWhat =>
      'Makineyi RAM\'e askıya alır (S3). Devam etmek hızlıdır ama askıdayken biraz batarya çeker.';

  @override
  String get skapiScriptSleepSummaryHow =>
      'System.Windows.Forms.Application.SetSuspendState\'i PowerState.Suspend ile çağırır. Bir ön plan süreci boşta kalmayı engelliyorsa OS gecikebilir.';

  @override
  String get skapiScriptSleepParamDelayLabel => 'delay';

  @override
  String get skapiScriptSleepParamDelayHint =>
      'Uyku moduna geçmeden önce beklenecek saniye.';

  @override
  String get skapiScriptShutdownTitle => 'Kapat';

  @override
  String get skapiScriptShutdownSummaryWhat =>
      'Windows\'un düzgün kapanmasını başlatır. Açık uygulamalardan kaydetmeleri ve kapanmaları istenir.';

  @override
  String get skapiScriptShutdownSummaryHow =>
      'Yerleşik shutdown.exe /s komutunu çalıştırır. force etkinse /f eklenir, yanıt vermeyen uygulamalar sonlandırılır.';

  @override
  String get skapiScriptShutdownNote =>
      'Sıfırdan büyük gecikme, kullanıcıya bir terminalden shutdown /a ile iptal etme süresi verir.';

  @override
  String get skapiScriptShutdownParamDelayLabel => 'delay';

  @override
  String get skapiScriptShutdownParamDelayHint =>
      'Windows kapanmadan önce beklediği saniye. Varsayılan 30; anında kapatma için 0 seçin.';

  @override
  String get skapiScriptShutdownParamForceLabel => 'force';

  @override
  String get skapiScriptShutdownParamForceHint =>
      'Kapatma sinyaline yanıt vermeyen uygulamaları kapatır. O uygulamalardaki kaydedilmemiş işler kaybolabilir.';

  @override
  String get skapiGroupDisplayAudioTitle => 'Ekran, Görüntü ve Ses';

  @override
  String get skapiGroupDisplayAudioDesc =>
      'Bu gruptaki script\'ler ekran ve ses çıkışını ayarlar: parlaklık, ses seviyesi, sessize alma ve medya kontrolü. SmartKraft cihazınız odak molasında ekranın kararmasını veya ayağa kalktığınızda müziğin durmasını istediğinde işe yarar.';

  @override
  String get skapiGroupDisplayAudioFoot =>
      'Tipik kullanım: molada ekranı karart, kilitlenince sesi kapat, cihaz hareketsizlik tespit edince Spotify\'ı duraklat.';

  @override
  String get skapiScriptBrightnessTitle => 'Parlaklık Ayarla';

  @override
  String get skapiScriptBrightnessSummaryWhat =>
      'Dahili ekranın parlaklığını 0-100 arası yüzde olarak ayarlar.';

  @override
  String get skapiScriptBrightnessSummaryHow =>
      'WMI WmiMonitorBrightnessMethods.WmiSetBrightness fonksiyonunu istenen seviyeyle çağırır. Sadece laptop, tablet ve dahili panellerde çalışır; harici DDC/CI monitörler bu yol üzerinden desteklenmez.';

  @override
  String get skapiScriptBrightnessNote =>
      'Harici monitörler değişmez. Çoklu monitör kurulumlarında yalnızca WMI üzerinden parlaklık raporlayan panel tepki verir.';

  @override
  String get skapiScriptBrightnessParamLevelLabel => 'level';

  @override
  String get skapiScriptBrightnessParamLevelHint =>
      'Parlaklık yüzdesi (0-100). Düşük değerler daha karanlıktır. Normal aydınlatmada 70 rahat bir varsayılandır.';

  @override
  String get skapiScriptBrightnessParamTimeoutLabel => 'timeout';

  @override
  String get skapiScriptBrightnessParamTimeoutHint =>
      'Parlaklık değişiminin tamamlanması için verilen saniye. OS bu süre içinde yumuşak rampa yapar.';

  @override
  String get skapiScriptMuteToggleTitle => 'Sessiz Aç/Kapat';

  @override
  String get skapiScriptMuteToggleSummaryWhat =>
      'Sistem ana sessize alma durumunu değiştirir. Aktif medya çalmaya devam eder ama ses duymazsınız.';

  @override
  String get skapiScriptMuteToggleSummaryHow =>
      'VK_VOLUME_MUTE sanal tuşunu gönderir; klavyede mute tuşuna basıldığında Windows\'un kullandığı yolun aynısı. Admin veya COM bağımlılığı yok.';

  @override
  String get skapiScriptMuteToggleParamModeLabel => 'mode';

  @override
  String get skapiScriptMuteToggleParamModeHint =>
      'toggle / on / off. Yalnızca toggle basit tuş gönderimiyle uygulanır; on ve off ileri uyumluluk için kabul edilir.';

  @override
  String get skapiScriptVolumeSetTitle => 'Ses Seviyesi Ayarla';

  @override
  String get skapiScriptVolumeSetSummaryWhat =>
      'Sistem ana ses seviyesini 0-100 arası net bir değere ayarlar.';

  @override
  String get skapiScriptVolumeSetSummaryHow =>
      'Inline C# COM interop ile Core Audio IAudioEndpointVolume.SetMasterVolumeLevelScalar fonksiyonunu çağırır. Varsayılan render endpoint\'ini hedefler.';

  @override
  String get skapiScriptVolumeSetNote =>
      'Tier 2: standart Windows 10/11 masaüstünde çalışır. Soyulmuş kurulumlarda COM arayüzü açık olmayabilir; uygulama bazlı endpoint\'ler bu yolda ele alınmaz.';

  @override
  String get skapiScriptVolumeSetParamLevelLabel => 'level';

  @override
  String get skapiScriptVolumeSetParamLevelHint =>
      'Ses seviyesi yüzdesi (0-100). 0 sessize almayı set etmeden susturur; 50 rahat bir varsayılandır.';

  @override
  String get skapiScriptMediaKeyTitle => 'Medya Tuşu';

  @override
  String get skapiScriptMediaKeySummaryWhat =>
      'Bir medya tuşu tetikler: play-pause, next, previous veya stop. Hangi uygulama o an medya oturumunun sahibiyse ona gider.';

  @override
  String get skapiScriptMediaKeySummaryHow =>
      'keybd_event ile VK_MEDIA_PLAY_PAUSE / VK_MEDIA_NEXT_TRACK / VK_MEDIA_PREV_TRACK / VK_MEDIA_STOP gönderir. Windows tuşu System Media Transport Controls üzerinden yönlendirir.';

  @override
  String get skapiScriptMediaKeyNote =>
      'Tier 2: aktif bir medya oturumu gerekir. Hiçbir uygulama oynatmıyorsa veya ön plandaki uygulama SMTC\'ye kayıtlı değilse tuş sessizce yutulur.';

  @override
  String get skapiScriptMediaKeyParamKeyLabel => 'key';

  @override
  String get skapiScriptMediaKeyParamKeyHint =>
      'play-pause / next / previous / stop. Varsayılan play-pause.';

  @override
  String get skapiGroupWindowAppTitle => 'Pencere ve Uygulama';

  @override
  String get skapiGroupWindowAppDesc =>
      'Bu gruptaki script\'ler pencereleri ve uygulamaları kontrol eder: küçült, odaklan, düzgünce kapat veya işlemi sonlandır. SmartKraft cihazınız bilgisayarın bağlamını değiştirmesini istediğinde çalışma alanınızı toparlar.';

  @override
  String get skapiGroupWindowAppFoot =>
      'Tipik kullanım: odak seansı başlayınca her şeyi küçült, iş bitince tarayıcıyı kapat, takılan bir uygulamayı manuel sonlandır.';

  @override
  String get skapiScriptMinimizeWindowTitle => 'Pencere Küçült';

  @override
  String get skapiScriptMinimizeWindowSummaryWhat =>
      'Belirli bir pencereyi process adıyla küçültür. Boş process adı odaklı pencereyi hedefler.';

  @override
  String get skapiScriptMinimizeWindowSummaryHow =>
      'Get-Process ile eşleşen ilk ana pencereyi bulur ve user32 ShowWindow\'u SW_MINIMIZE ile çağırır.';

  @override
  String get skapiScriptMinimizeWindowNote =>
      'Birden çok örnek çalışıyorsa yalnızca ilk eşleşen pencere küçültülür. Process adını .exe uzantısı olmadan girin.';

  @override
  String get skapiScriptMinimizeWindowParamProcessLabel => 'processName';

  @override
  String get skapiScriptMinimizeWindowParamProcessHint =>
      '.exe olmadan process adı (chrome, code, winword). Boş değer ön plan penceresini hedefler.';

  @override
  String get skapiScriptCloseWindowTitle => 'Pencereyi Kapat';

  @override
  String get skapiScriptCloseWindowSummaryWhat =>
      'Bir pencereye düzgün kapanma sinyali gönderir, böylece uygulama kendi \"değişiklikleri kaydet?\" diyaloğunu gösterebilir.';

  @override
  String get skapiScriptCloseWindowSummaryHow =>
      'user32 SendMessage üzerinden WM_CLOSE postlar. Kullanıcının X düğmesine basmasıyla aynı etki. Boş process adı ön plan penceresini hedefler.';

  @override
  String get skapiScriptCloseWindowNote =>
      'Kaydedilmemiş işi olan uygulamalar kendi diyaloğunu çıkarır. Script kilitlenmiş uygulamaları beklemez veya sonlandırmaz.';

  @override
  String get skapiScriptCloseWindowParamProcessLabel => 'processName';

  @override
  String get skapiScriptCloseWindowParamProcessHint =>
      '.exe olmadan process adı. Boş değer ön plan penceresini hedefler.';

  @override
  String get skapiScriptKillAppTitle => 'Uygulamayı Zorla Kapat';

  @override
  String get skapiScriptKillAppSummaryWhat =>
      'Bir process\'in tüm örneklerini sonlandırır. Önce WM_CLOSE dener, timeout sonra hâlâ ayaktaysa TerminateProcess.';

  @override
  String get skapiScriptKillAppSummaryHow =>
      'Her ana pencereye WM_CLOSE gönderir, belirlenen timeout kadar bekler, hâlâ çalışan her şeyi Stop-Process -Force ile sonlandırır.';

  @override
  String get skapiScriptKillAppNote =>
      'Yanıt vermeyen uygulamalardaki kaydedilmemiş iş zorla sonlandırmada kaybolur. Ctrl+S yanıt veren editör tarzı uygulamalar için preKillSave kullanın.';

  @override
  String get skapiScriptKillAppParamProcessLabel => 'processName';

  @override
  String get skapiScriptKillAppParamProcessHint =>
      '.exe olmadan process adı. Çalışan tüm örnekler sonlandırılır.';

  @override
  String get skapiScriptKillAppParamTimeoutLabel => 'timeout';

  @override
  String get skapiScriptKillAppParamTimeoutHint =>
      'WM_CLOSE ile zorla sonlandırma arasında beklenecek saniye. Yüksek değerler uygulamaya kayıt için daha çok süre verir.';

  @override
  String get skapiScriptKillAppParamPreKillSaveLabel => 'preKillSave';

  @override
  String get skapiScriptKillAppParamPreKillSaveHint =>
      'Kapatmadan önce ön plan penceresine Ctrl+S gönderir. Editörler için faydalı, Ctrl+S yok sayan uygulamalarda etkisiz.';

  @override
  String get skapiScriptLaunchAppTitle => 'Uygulama Başlat';

  @override
  String get skapiScriptLaunchAppSummaryWhat =>
      'Bir yürütülebilir dosyayı başlatır, URL açar veya varsayılan işleyici ile bir belgeyi açar.';

  @override
  String get skapiScriptLaunchAppSummaryHow =>
      'PowerShell Start-Process\'i path ve isteğe bağlı argüman listesiyle çağırır. Path; .exe, tam dosya yolu veya URL olabilir.';

  @override
  String get skapiScriptLaunchAppNote =>
      'Boşluklu yollar kabul edilir. Varsayılan tarayıcıyı açmak için https://example.com gibi bir URL kullanın.';

  @override
  String get skapiScriptLaunchAppParamPathLabel => 'path';

  @override
  String get skapiScriptLaunchAppParamPathHint =>
      'Yürütülebilir dosya, tam dosya yolu veya URL. notepad / C:\\\\tools\\\\my.exe / https://example.com.';

  @override
  String get skapiScriptLaunchAppParamArgsLabel => 'args';

  @override
  String get skapiScriptLaunchAppParamArgsHint =>
      'Yürütülebilir dosyaya gönderilen argümanlar. Boşsa hiçbiri.';

  @override
  String get skappListenerCardTitle => 'SKAPP HTTP Dinleyici';

  @override
  String skappListenerCardSubtitleRunning(int port) {
    return 'Port $port\'da çalışıyor';
  }

  @override
  String get skappListenerCardSubtitleStopped => 'Durduruldu';

  @override
  String get skappListenerCardSubtitleUnsupported =>
      'Bu platform dinleyiciyi barındıramaz.';

  @override
  String get skappListenerCardEnableSwitch => 'Dinleyiciyi etkinleştir';

  @override
  String get skappListenerCardSecurityNote =>
      'Dinleyici sadece yerel ağdan bağlantı kabul eder ve bearer token gerektirir. Düz HTTP\'dir, açık internete maruz bırakmayın.';

  @override
  String get settingsLanVisibleTitle => 'LAN\'da görünür';

  @override
  String get settingsLanVisibleSubtitle =>
      'Kapalıyken dinleyici sadece localhost\'a bağlanır. Eşleşmiş BF cihazlar bu masaüstüne ulaşamaz.';

  @override
  String get settingsLanVisibleWarnBfBreaks =>
      'Kapatmak BF webhook zincirini kırar. Sadece güvenli veya test ortamında kapat.';

  @override
  String get settingsLanVisibleAutoReopenedSnack =>
      'BF cihazlarının masaüstüne ulaşabilmesi için LAN görünürlüğü yeniden açıldı.';

  @override
  String get skapiRunRemoteDeveloperModeDisabled =>
      'Hedef masaüstünde geliştirici modu kapalı; uzaktan script çalıştırma orada devre dışı.';

  @override
  String get skappPeerPairingManualUuidConfirmLabel =>
      'Onay kodu (UUID son 4 karakter)';

  @override
  String get skappPeerPairingManualUuidConfirmHint =>
      'Masaüstünün eşleşme ekranındaki 4 karakterlik kodu oku.';

  @override
  String get skappPeerPairingManualUuidConfirmError =>
      'Kod UUID\'nin son 4 karakteri ile eşleşmiyor. Masaüstü ekranını kontrol et.';

  @override
  String get skappListenerCardUuidLast4Label => 'Eşleşme onay kodu';

  @override
  String get skappListenerCardUuidLast4Hint =>
      'Bu 4 karakteri telefonun manuel eşleşme ekranına yaz.';

  @override
  String get settingsPeerTokensTitle => 'Verilmiş peer token\'ları';

  @override
  String get settingsPeerTokensSubtitle =>
      'Bu masaüstüyle eşleşmiş mobil cihazlar. Bir kaydı iptal ederek diğerlerini etkilemeden o cihazı çıkış ettirebilirsin.';

  @override
  String get settingsPeerTokensEmpty => 'Henüz eşleşmiş cihaz yok.';

  @override
  String settingsPeerTokensIssuedAt(String when) {
    return 'Eşleşme $when';
  }

  @override
  String settingsPeerTokensLastUsed(String when) {
    return 'Son kullanım $when';
  }

  @override
  String get settingsPeerTokensRevokeButton => 'İptal et';

  @override
  String get settingsPeerTokensRevokeConfirmTitle => 'Bu cihazı iptal et?';

  @override
  String get settingsPeerTokensRevokeConfirmBody =>
      'Cihaz hemen çıkış yapar ve masaüstüne tekrar ulaşmak için yeniden eşleşmesi gerekir.';

  @override
  String get settingsPeerTokensRevokeConfirmCancel => 'Vazgeç';

  @override
  String get settingsPeerTokensRevokeConfirmAction => 'İptal et';

  @override
  String settingsPeerTokensRevokedToast(String name) {
    return '$name eşleşmesi iptal edildi';
  }

  @override
  String get skappListenerCardRotateCertButton => 'TLS sertifikasını yenile';

  @override
  String get skappListenerCardRotateCertConfirmTitle => 'Sertifikayı yenile?';

  @override
  String get skappListenerCardRotateCertConfirmBody =>
      'Yeni self-signed TLS sertifikası üretilir. Daha önce eşleşmiş tüm cihazlar yeniden eşleşene kadar handshake hatası alır.';

  @override
  String get skappListenerCardRotateCertConfirmCancel => 'Vazgeç';

  @override
  String get skappListenerCardRotateCertConfirmAction => 'Yenile';

  @override
  String get skappListenerCardRotateCertDoneSnack =>
      'TLS sertifikası yenilendi. Eşleşmiş tüm cihazları yeniden eşle.';

  @override
  String get skappListenerCardCertFingerprintLabel => 'TLS sertifika izi';

  @override
  String skappListenerCardErrorPortInUse(int port) {
    return '$port portu zaten kullanılıyor. Ağ kimliğinden farklı bir port seç.';
  }

  @override
  String skappListenerCardErrorGeneric(String error) {
    return 'Dinleyici başlatılamadı: $error';
  }

  @override
  String get skappPeerPairingTitle => 'Desktop SKAPP Eşle';

  @override
  String get skappPeerPairingSubtitle =>
      'Desktop SKAPP\'in Ayarlarında gösterilen QR\'ı tara veya eşleştirme kodunu manuel gir.';

  @override
  String get skappPeerPairingTabScan => 'QR Tara';

  @override
  String get skappPeerPairingTabManual => 'Manuel';

  @override
  String get skappPeerPairingScanHint =>
      'Kameranı Desktop SKAPP > Ayarlar > SKAPP HTTP Dinleyici\'de gösterilen QR\'a yönelt.';

  @override
  String get skappPeerPairingScanCameraDeniedTitle => 'Kamera izni gerekli';

  @override
  String get skappPeerPairingScanCameraDeniedBody =>
      'Eşleşme QR\'ını taramak için telefon ayarlarından kamera erişimine izin ver. Kodu manuel de girebilirsin.';

  @override
  String get skappPeerPairingManualHostLabel => 'Desktop IP veya host adı';

  @override
  String get skappPeerPairingManualPortLabel => 'Port';

  @override
  String get skappPeerPairingManualTokenLabel => 'Bearer token';

  @override
  String get skappPeerPairingManualUuidLabel => 'Desktop UUID';

  @override
  String get skappPeerPairingManualNameLabel => 'Görünen isim';

  @override
  String get skappPeerPairingManualSubmit => 'Eşle';

  @override
  String skappPeerPairingSavedToast(String name) {
    return '$name ile eşlendi';
  }

  @override
  String skappPeerPairingFailedToast(String reason) {
    return 'Eşleşme başarısız: $reason';
  }

  @override
  String get skappPeerPairingShowQrTitle => 'Bu Desktop\'la bir telefon eşle';

  @override
  String get skappPeerPairingShowQrBody =>
      'Telefonunda SKAPP\'i aç, SKAPI > Ayarlar > Desktop Eşle bölümüne git ve bu QR\'ı tarat. QR bearer token içerir, parola gibi koru.';

  @override
  String get skappPeerPairingShowQrCloseButton => 'Tamam';

  @override
  String get skappPeerListEmpty =>
      'Henüz eşli Desktop yok. Bu telefondan script çalıştırmak için bir tane eşle.';

  @override
  String get skappPeerListSectionTitle => 'Eşli Desktop SKAPP\'ler';

  @override
  String get skappPeerStatusOnline => 'Çevrimiçi';

  @override
  String get skappPeerStatusOffline => 'Çevrimdışı';

  @override
  String skappPeerStatusLastSeen(String when) {
    return 'Son görülme: $when';
  }

  @override
  String get skappPeerRemoveTooltip => 'Eşli Desktop\'u kaldır';

  @override
  String get skappPeerRemoveConfirmTitle => 'Eşleşme kaldırılsın mı?';

  @override
  String skappPeerRemoveConfirmBody(String name) {
    return 'Bu telefondan tetiklenen script\'ler tekrar eşleyene kadar $name üzerinde çalışmaz.';
  }

  @override
  String get skappPeerScanRefreshTooltip => 'Peer listesini yenile';

  @override
  String skapiRunRemoteSheetTitle(String peerName) {
    return '$peerName üzerinde uzaktan çalıştır';
  }

  @override
  String get skapiRunRemoteConnecting => 'Desktop\'a bağlanılıyor...';

  @override
  String get skapiRunRemoteOfflineError =>
      'Eşli Desktop çevrimdışı. Peer\'ları yenile veya Desktop\'un dinleyicisini kontrol et.';

  @override
  String get skapiRunRemoteUnauthorizedError =>
      'Bearer token reddedildi. Desktop\'un token\'ı yenilenmiş olabilir. Ayarlardan tekrar eşle.';

  @override
  String skapiRunRemoteHttpError(String reason) {
    return 'Uzaktan çalıştırma başarısız: $reason';
  }

  @override
  String get skapiRunMobileNoPeerTitle => 'Eşli Desktop yok';

  @override
  String get skapiRunMobileNoPeerBody =>
      'Bu telefondan script çalıştırmak için Ayarlardan bir Desktop SKAPP eşle.';

  @override
  String get skapiRunMobileNoPeerCta => 'Ayarları Aç';

  @override
  String get skapiRunRemoteNotWhitelisted =>
      'Bu script uzaktan çalıştırma için işaretli değil. Doğrudan masaüstünde çalıştır.';

  @override
  String get skapiRunRemoteNoPeerHint =>
      'Bu telefondan script çalıştırmak için önce Ayarlardan bir Desktop SKAPP eşle.';

  @override
  String get skapiRunRemoteNoPeerAction => 'Ayarlara git';

  @override
  String get skappPeerPickerTitle => 'Hangi bilgisayara gönderelim?';

  @override
  String get skappPeerPickerSubtitle =>
      'Bu script\'i çalıştıracak eşli Desktop SKAPP\'ı seç.';

  @override
  String get skappPeerPickerOfflineReason => 'Çevrimdışı';

  @override
  String get skappPeerPickerDevModeOffReason => 'Geliştirici modu kapalı';

  @override
  String get skappPeerPickerEmpty => 'Seçilebilecek eşli bilgisayar yok.';

  @override
  String get skapiRunRemoteCancelButton => 'İptal';

  @override
  String get skapiRunRemoteCancelledNote => 'Çalıştırma iptal edildi';

  @override
  String skapiRunRemoteTooManyRuns(int running, int limit) {
    return 'Bu bilgisayarda zaten $running script çalışıyor (en fazla $limit). Biri tamamlanana kadar bekle.';
  }

  @override
  String get skappPeerHealthDevModeBadge => 'Dev modu';

  @override
  String get remoteRunActivityCardTitle => 'Uzaktan çalıştırmalar';

  @override
  String get remoteRunActivityCardSubtitle =>
      'Eşli mobil peer\'ların bu bilgisayardan istediği son script çalıştırmaları.';

  @override
  String get remoteRunActivityCardEmpty => 'Henüz uzaktan çalıştırma yok.';

  @override
  String get remoteRunActivityCardClear => 'Geçmişi temizle';

  @override
  String remoteRunActivityRowOk(int exitCode, int durationMs) {
    return 'çıkış $exitCode · $durationMs ms';
  }

  @override
  String get remoteRunActivityRowCancelled => 'iptal edildi';

  @override
  String remoteRunActivityRowRejected(String reason) {
    return 'reddedildi · $reason';
  }

  @override
  String get mobileTriggerCardTitle => 'Tetikle';

  @override
  String get mobileTriggerCardSubtitle =>
      'Eşli Desktop SKAPP\'e bir dokunma olayı gönder. Bu olayı bekleyen bir binding, o masaüstünde script\'i çalıştırır.';

  @override
  String get mobileTriggerCardSendButton => 'Dokunma gönder';

  @override
  String get mobileTriggerCardSending => 'Gönderiliyor...';

  @override
  String mobileTriggerSentToast(String name) {
    return 'Dokunma $name cihazına gönderildi';
  }

  @override
  String get skapiBindEventMobileTap => 'Mobil dokunma';

  @override
  String get pairedDeviceMobileType => 'SKAPP Mobil';

  @override
  String skappPeersCardHeaderSinglePeer(String title, String name) {
    return '$title · $name';
  }

  @override
  String skappPeersCardHeaderMultiPeer(String title, int count) {
    return '$title · $count';
  }

  @override
  String get msHomeScreenTitle => 'Mobil peer';

  @override
  String get msHomeScreenNotFound => 'Bu mobil peer artık eşli değil.';

  @override
  String get msHomeScreenEventsHeader => 'Yayınlanabilir olaylar';

  @override
  String msHomeScreenBindingsHeader(int count) {
    return 'Bağlantılar ($count)';
  }

  @override
  String get msHomeScreenBindingsEmpty =>
      'Henüz bağlantı yok. SKAPI → script → Aksiyon ata yolu ile bir dokunma olayını script\'e bağla.';

  @override
  String get msHomeScreenHint =>
      'Telefonlar script çalıştırmaz. Bu masaüstünün script\'lere bağladığı tetik olaylarını yayarlar.';

  @override
  String msHomeScreenPairedAt(String date) {
    return 'Eşleşme: $date';
  }

  @override
  String get skapiGroupNotifyTitle => 'Bildirim ve Diyalog';

  @override
  String get skapiGroupNotifyDesc =>
      'Bu gruptaki script\'ler kullanıcıyla doğrudan konuşur: toast bildirim göster, modal diyalog aç veya evet/hayır cevabı bekle. SmartKraft cihazının bir olayı kullanıcının onaylamasını ya da karar vermesini gerektirdiğinde kullan.';

  @override
  String get skapiGroupNotifyFoot =>
      'Tipik kullanım: yıkıcı bir aksiyon öncesinde diyalog, yumuşak hatırlatmada toast, otomatik akış için timeout\'lu diyalog.';

  @override
  String get skapiScriptDialogTitle => 'Diyalog Göster';

  @override
  String get skapiScriptDialogSummaryWhat =>
      'Modal Windows MessageBox açar ve kullanıcının seçimini döndürür (ok / cancel / yes / no / timeout).';

  @override
  String get skapiScriptDialogSummaryHow =>
      'System.Windows.Forms.MessageBox\'ı alt runspace\'te çalıştırarak diyaloğu opsiyonel timeout ile yarıştırır. Seçilen değer caller\'ın dallanması için stdout\'a yazılır.';

  @override
  String get skapiScriptDialogNote =>
      'stdout küçük harfle kullanıcının cevabıdır. timeout=0 sınırsız bekler.';

  @override
  String get skapiScriptDialogParamTitleLabel => 'title';

  @override
  String get skapiScriptDialogParamTitleHint => 'Mesaj kutusu başlığı.';

  @override
  String get skapiScriptDialogParamBodyLabel => 'body';

  @override
  String get skapiScriptDialogParamBodyHint =>
      'Kullanıcıya gösterilen soru veya mesaj.';

  @override
  String get skapiScriptDialogParamButtonsLabel => 'buttons';

  @override
  String get skapiScriptDialogParamButtonsHint =>
      'ok / ok_cancel / yes_no / yes_no_cancel. Varsayılan ok_cancel.';

  @override
  String get skapiScriptDialogParamTimeoutLabel => 'timeout';

  @override
  String get skapiScriptDialogParamTimeoutHint =>
      '\'timeout\' ile akışı bırakmadan önce beklenecek saniye. 0 sonsuz bekler.';

  @override
  String get skapiScriptToastTitle => 'Toast Göster';

  @override
  String get skapiScriptToastSummaryWhat =>
      'Başlık ve gövde ile bir Windows toast bildirimi gösterir. Sağ alttan kayar, sonra Action Center\'a düşer.';

  @override
  String get skapiScriptToastSummaryHow =>
      'ToastNotification XML payload\'unu oluşturur ve yapılandırılmış AppUserModelID altında WinRT ToastNotificationManager\'a gönderir.';

  @override
  String get skapiScriptToastNote =>
      'Tier 2: en temiz UX için Windows 10+ ve kayıtlı bir AppUserModelID gerektirir. Varsayılan AUMID toast\'u Action Center\'da PowerShell altına koyar.';

  @override
  String get skapiScriptToastParamTitleLabel => 'title';

  @override
  String get skapiScriptToastParamTitleHint => 'Toast\'ın koyu ilk satırı.';

  @override
  String get skapiScriptToastParamBodyLabel => 'body';

  @override
  String get skapiScriptToastParamBodyHint =>
      'Daha küçük ikinci satır. İsteğe bağlı.';

  @override
  String get skapiScriptToastParamAumidLabel => 'aumid';

  @override
  String get skapiScriptToastParamAumidHint =>
      'Toast\'un altında göründüğü App User Model ID. Varsayılan PowerShell\'e düşer.';

  @override
  String get skapiGroupVisualBreakTitle => 'Görsel Mola';

  @override
  String get skapiGroupVisualBreakDesc =>
      'Kullanıcıyı yoğun çalışmadan uzaklaştıran yumuşak görsel ipuçları: ekranı karart, tonlamayı griye çevir, imleci bul veya masaüstünü göster. Bu gruptaki efektler geri alınabilir ve girdiyi sert şekilde bloke etmez.';

  @override
  String get skapiGroupVisualBreakFoot =>
      'Tipik kullanım: odak molasının başında ekranı karart, geç saatte gri tonlama, çoklu monitörde imleç bulma.';

  @override
  String get skapiScriptShowDesktopTitle => 'Masaüstünü Göster';

  @override
  String get skapiScriptShowDesktopSummaryWhat =>
      '\'Masaüstünü göster\'i değiştirir. Win+D\'ye iki kez basmakla aynıdır.';

  @override
  String get skapiScriptShowDesktopSummaryHow =>
      'COM üzerinden Shell.Application.ToggleDesktop\'u çağırır. Tekrar çalıştırılınca önceki pencere yerleşimi geri gelir.';

  @override
  String get skapiScriptFadeScreenTitle => 'Ekranı Karart';

  @override
  String get skapiScriptFadeScreenSummaryWhat =>
      'Dahili ekran parlaklığını mevcut seviyeden hedef seviyeye birkaç saniye içinde yumuşakça düşürür.';

  @override
  String get skapiScriptFadeScreenSummaryHow =>
      'WMI WmiMonitorBrightness ile mevcut parlaklığı okur, sonra WmiSetBrightness\'i hedefe doğru lineer adımlarla çağırır; değişim yumuşak hissedilir.';

  @override
  String get skapiScriptFadeScreenNote =>
      'Tier 2: WMI parlaklığı yalnızca dahili panellerde çalışır. Harici monitörler bu yolda yanıt vermez.';

  @override
  String get skapiScriptFadeScreenParamTargetLabel => 'target';

  @override
  String get skapiScriptFadeScreenParamTargetHint =>
      'Hedef parlaklık yüzdesi (0-100).';

  @override
  String get skapiScriptFadeScreenParamDurationLabel => 'duration';

  @override
  String get skapiScriptFadeScreenParamDurationHint =>
      'Karartmanın alacağı saniye. Script saniyede on parlaklık adımı kullanır.';

  @override
  String get skapiScriptGrayscaleTitle => 'Gri Tonlama Filtresi';

  @override
  String get skapiScriptGrayscaleSummaryWhat =>
      'Windows Color Filters gri tonlama modunu açar veya kapatır.';

  @override
  String get skapiScriptGrayscaleSummaryHow =>
      'ColorFiltering registry anahtarlarını yazar, sonra Windows\'un değişikliği oturum açma olmadan canlı görmesi için Win+Ctrl+C gönderir.';

  @override
  String get skapiScriptGrayscaleNote =>
      'Tier 2: canlı toggle için Ayarlar > Erişilebilirlik > Renk filtreleri > \'Kısayol tuşuna izin ver\' açık olmalı.';

  @override
  String get skapiScriptGrayscaleParamOnLabel => 'on';

  @override
  String get skapiScriptGrayscaleParamOnHint =>
      'true gri tonlamayı açar, false kapatır.';

  @override
  String get skapiScriptGrayscaleParamDurationLabel => 'süre';

  @override
  String get skapiScriptGrayscaleParamDurationHint =>
      '0 ise sadece açar/kapatır. >0 ise belirtilen saniye sonra otomatik olarak renge döner. Görsel mola için idealdir.';

  @override
  String get skapiScriptFindMouseShakeTitle => 'İmleci Bul';

  @override
  String get skapiScriptFindMouseShakeSummaryWhat =>
      'İmleç pozisyonunu vurgulamak için imleci küçük bir daire boyunca oynatır. Animasyon bittiğinde imleç başlangıç noktasına döner.';

  @override
  String get skapiScriptFindMouseShakeSummaryHow =>
      'GetCursorPos ile mevcut imleç pozisyonunu okur, sonra SetCursorPos\'u yapılandırılmış yarıçaplı bir dairede döner. Çoklu monitör ve 4K kurulumlarında faydalı.';

  @override
  String get skapiScriptFindMouseShakeNote =>
      'Tier 2: SetCursorPos erişilebilirlik yazılımları tarafından engellenebilir, davranış uzak masaüstü oturumlarında değişebilir.';

  @override
  String get skapiScriptFindMouseShakeParamRadiusLabel => 'radius';

  @override
  String get skapiScriptFindMouseShakeParamRadiusHint =>
      'İmlecin döngü sırasında orijininden uzaklaşacağı piksel sayısı. Daha büyük daha dikkat çekici.';

  @override
  String get skapiScriptFindMouseShakeParamLoopsLabel => 'loops';

  @override
  String get skapiScriptFindMouseShakeParamLoopsHint =>
      'Yerleşmeden önce kaç tam daire çizileceği.';

  @override
  String get skapiGroupProgramsTitle => 'Belirli Program Kontrolü';

  @override
  String get skapiGroupProgramsDesc =>
      'Belirli uygulama ve tarayıcılar için hedefli script\'ler: düzgün kaydet+kapat, çoklu örnek kapama, tarayıcı genelinde temizlik. SmartKraft cihazı belirli bir akışı tüm masaüstünü etkilemeden bitirmek istediğinde kullanışlı.';

  @override
  String get skapiGroupProgramsFoot =>
      'Tipik kullanım: uyumadan önce tüm editörleri kaydedip kapat, gün sonunda her tarayıcıyı kapat, tek bir process ailesinin daraltılmış temizliği.';

  @override
  String get skapiScriptCloseWithSaveTitle => 'Kaydet ve Kapat';

  @override
  String get skapiScriptCloseWithSaveSummaryWhat =>
      'Hedef uygulamaya Ctrl+S göndererek kendi kaydetmesini tetikler, bekler, sonra pencereyi düzgünce kapatır.';

  @override
  String get skapiScriptCloseWithSaveSummaryHow =>
      'Her çalışan örneğe odaklanır, SendKeys ile Ctrl+S yollar, ayarlı saniye bekler, sonra WM_CLOSE postlar; uygulama kayıt onayı verebilir.';

  @override
  String get skapiScriptCloseWithSaveNote =>
      'Tier 2: uygulamanın Ctrl+S\'i \'kaydet\' olarak yorumlamasına bağlıdır. Bazı sohbet / web uygulamaları farklı yorumlar. Hedeflediğiniz uygulamalarla test edin.';

  @override
  String get skapiScriptCloseWithSaveParamProcessLabel => 'processName';

  @override
  String get skapiScriptCloseWithSaveParamProcessHint =>
      '.exe olmadan process adı (winword, excel, code, photoshop). Çalışan tüm örnekler kaydedilip kapatılır.';

  @override
  String get skapiScriptCloseWithSaveParamWaitLabel => 'wait';

  @override
  String get skapiScriptCloseWithSaveParamWaitHint =>
      'Ctrl+S ile kapatma sinyali arasında uygulamanın kaydetmesini bitirmesi için beklenecek saniye.';

  @override
  String get skapiScriptCloseAllInstancesTitle => 'Tüm Örnekleri Kapat';

  @override
  String get skapiScriptCloseAllInstancesSummaryWhat =>
      'Bir process\'in görünür her penceresine düzgün kapanma sinyali gönderir. Her örnek kendi kayıt diyaloğunu gösterebilir.';

  @override
  String get skapiScriptCloseAllInstancesSummaryHow =>
      'Get-Process ile eşleşen process\'leri tarar, her birinin ana penceresine WM_CLOSE postlar. Force fallback yok.';

  @override
  String get skapiScriptCloseAllInstancesParamProcessLabel => 'processName';

  @override
  String get skapiScriptCloseAllInstancesParamProcessHint =>
      '.exe olmadan process adı. Tüm örnekleri eşler.';

  @override
  String get skapiScriptBrowserCloseAllTitle => 'Tüm Tarayıcıları Kapat';

  @override
  String get skapiScriptBrowserCloseAllSummaryWhat =>
      'Çalışan her ana tarayıcıyı (Chrome, Edge, Firefox, Brave, Vivaldi, Opera) düzgünce kapatır.';

  @override
  String get skapiScriptBrowserCloseAllSummaryHow =>
      'Bilinen tarayıcı process isimlerini tarar, her ana pencereye WM_CLOSE postlar. Modern tarayıcılar \'sonraki açılışta sekmeleri geri yükle\' aktifse oturumu korur.';

  @override
  String get skapiScriptBrowserCloseAllNote =>
      'Force-terminate kullanılmaz. Oturumu da silmek için her tarayıcıya ayrı kill-app kullanın.';

  @override
  String get skapiTierBadgeExperimental => 'Deneysel';

  @override
  String get skapiTierBadgeExperimentalTooltip =>
      'Bu script, makinede güvenilir olmayabilecek bir Windows API\'sine bağlıdır. Güvenmeden önce test edin.';

  @override
  String get skapiTierBadgeBlocked => 'Yakında';

  @override
  String get skapiTierBadgeBlockedTooltip =>
      'Bu script planlanan kütüphanenin parçası ama henüz uygulanmadı.';

  @override
  String get skapiGroupSaveWorkTitle => 'Çalışmaları Kaydet';

  @override
  String get skapiGroupSaveWorkDesc =>
      'Bu gruptaki script\'ler, mola veya beklenmedik kapanma öncesinde açık çalışmalarınızın diske kaydedilmesini sağlar. SmartKraft cihazınız bir mola tetiklediğinde, seçtiğiniz script otomatik olarak Word, Excel, VS Code veya diğer düzenleyicilerdeki dosyanızı kaydeder. Böylece bilgisayarınız uyusa, kapansa veya başka bir komut çalışsa bile çalışmanız güvende kalır.';

  @override
  String get skapiGroupSaveWorkFoot =>
      'Tipik kullanım: odak molası başlangıcında otomatik kayıt, düşük pil uyarısında belge yedekleme veya butonla \"her şeyi kaydet\" tetikleme.';

  @override
  String get skapiScriptSaveActiveWindowTitle => 'Aktif Pencereyi Kaydet';

  @override
  String get skapiScriptSaveActiveWindowSummaryWhat =>
      'Şu an Windows\'ta odakta olan pencereye sanal Ctrl+S tuş kombinasyonu gönderir, uygulamanın kendi \"kaydet\" davranışını tetikler.';

  @override
  String get skapiScriptSaveActiveWindowSummaryHow =>
      'Önce aktif pencerenin handle\'ını alıp başlığını loglar, sonra SendKeys ile Ctrl+S yollar. Word kendi yolunda kaydeder, VS Code dosyayı yazar. \"Save As\" diyaloğu çıkarsa kullanıcı manuel onay verene kadar bekler.';

  @override
  String get skapiScriptSaveActiveWindowParamTimeoutLabel => 'timeout';

  @override
  String get skapiScriptSaveActiveWindowParamTimeoutHint =>
      'Tuş kombinasyonu gönderildikten sonra uygulamanın dosyayı yazmasını beklemek için saniye cinsinden süre.';

  @override
  String get skapiScriptSaveActiveWindowParamVerboseLabel => 'verbose';

  @override
  String get skapiScriptSaveAllOpenTitle => 'Tüm Açık Belgeleri Kaydet';

  @override
  String get skapiScriptSaveAllOpenSummaryWhat =>
      'Çalışan editörlerin whitelist\'inde gezinir ve her birine açık belgelerini kaydetmesini söyler.';

  @override
  String get skapiScriptSaveAllOpenSummaryHow =>
      'Whitelist\'te bulunan her uygulama için ana pencereye odaklanır, Ctrl+S gönderir ve uygulama başına belirlenen timeout süresince bekler. Çalışmayan uygulamalar verbose mod kapalıysa sessizce atlanır.';

  @override
  String get skapiScriptSaveAllOpenNote =>
      'Whitelist varsayılan olarak Word, Excel, PowerPoint ve VS Code\'u içerir. Kendi uygulamalarınızı eklemek için apps parametresini düzenleyin.';

  @override
  String get skapiScriptSaveAllOpenParamAppsLabel => 'apps';

  @override
  String get skapiScriptSaveAllOpenParamAppsHint =>
      'Kayıt komutu gönderilecek process isimleri (.exe olmadan). Sıra önemli: önceki girdiler önce işlenir.';

  @override
  String get skapiScriptSaveAllOpenParamTimeoutLabel => 'timeoutPerApp';

  @override
  String get skapiScriptSaveAllOpenParamVerboseLabel => 'verbose';

  @override
  String get skapiScriptAutosaveTriggerTitle => 'Otomatik Kayıt Tetikle';

  @override
  String get skapiScriptAutosaveTriggerSummaryWhat =>
      'Görünür her üst düzey pencereye tek seferde Windows kaydet komutu yayınlar.';

  @override
  String get skapiScriptAutosaveTriggerSummaryHow =>
      'Görünür pencereleri tarar, sonra her birine standart kaydet id\'siyle WM_COMMAND mesajı gönderir. Bu mesajı dinleyen uygulamalar, sanki Dosya menüsündeki Kaydet öğesine tıklamışsınız gibi tepki verir. Pencere başına Ctrl+S\'ten daha hızlıdır ama bazı uygulamalar bu yayını göz ardı eder.';

  @override
  String get skapiScriptAutosaveTriggerNote =>
      'Tüm editörleri tek seferde temizlemek istediğinizde kullanın; az sayıda uygulamanın yanıt vermemesi sorun değilse uygundur. Daha sıkı kapsama için save-all-open ile birleştirin.';

  @override
  String get skapiScriptAutosaveTriggerParamDelayLabel => 'delay';

  @override
  String get skapiScriptAutosaveTriggerParamDelayHint =>
      'Yayından önce beklenecek saniye; cihazın mola bildiriminin önce görünmesini istediğinizde faydalı.';

  @override
  String get skapiScriptAutosaveTriggerParamVerboseLabel => 'verbose';

  @override
  String get skapiScriptDetailSummaryWhatLabel => 'Ne yapar:';

  @override
  String get skapiScriptDetailSummaryHowLabel => 'Nasıl çalışır:';

  @override
  String get skapiScriptDetailOriginalSectionTitle => 'Original Script';

  @override
  String get skapiScriptDetailOriginalSectionSub => 'read-only · English';

  @override
  String get skapiScriptDetailEditingSectionTitle => 'Düzenleme';

  @override
  String get skapiScriptDetailEditingNotYet => 'Henüz düzenlenmedi';

  @override
  String get skapiScriptDetailEditingNotYetSub =>
      'Orijinali değiştirmeden bu cihaza özel bir kopya oluşturabilirsiniz.';

  @override
  String get skapiScriptDetailEditingModified => 'Düzenlendi';

  @override
  String skapiScriptDetailEditingModifiedSub(String date) {
    return 'Son değişiklik $date.';
  }

  @override
  String get skapiScriptDetailEditingOutdated => 'Kütüphane güncellendi';

  @override
  String get skapiScriptDetailEditingOutdatedSub =>
      'Orijinal, uygulama güncellemesiyle değişmiş. Karşılaştırın veya sıfırlayın.';

  @override
  String get skapiScriptDetailParamWarnTitle =>
      'Çalıştırmadan önce parametreleri kontrol edin';

  @override
  String get skapiScriptDetailParamWarnHint =>
      'Bu değerleri değiştirmek için \"Düzenle\"yi kullanın. Parametreler kodun param() bloğunda tanımlıdır.';

  @override
  String get skapiScriptDetailNotesTitle => 'Notlar';

  @override
  String get skapiScriptDetailButtonRun => 'Şimdi Çalıştır';

  @override
  String get skapiScriptDetailButtonBindAction => 'Aksiyona Bağla';

  @override
  String get skapiScriptDetailButtonEdit => 'Düzenle';

  @override
  String get skapiScriptDetailButtonView => 'Görüntüle';

  @override
  String get skapiScriptDetailButtonReset => 'Sıfırla';

  @override
  String get skapiScriptDetailButtonCompare => 'Karşılaştır';

  @override
  String get skapiScriptCopyButton => 'Kopyala';

  @override
  String get skapiScriptCopyButtonDone => 'Kopyalandı';

  @override
  String get skapiScriptSelectButton => 'Seç';

  @override
  String get skapiEditorTitle => 'Düzenle';

  @override
  String skapiEditorHint(String scriptId) {
    return '$scriptId · Bu cihaza özel bir kopyayı düzenliyorsunuz. Orijinal kütüphane sürümü değişmez. \"Sıfırla\" her zaman orijinale geri döndürür.';
  }

  @override
  String get skapiEditorStatusBarTitle => 'POWERSHELL · UTF-8';

  @override
  String get skapiEditorStatusModified => '● Değiştirildi';

  @override
  String get skapiEditorStatusUnmodified => 'Değişmedi';

  @override
  String skapiEditorFootCursor(int line, int column) {
    return 'Satır $line · Sütun $column';
  }

  @override
  String get skapiEditorFootSaveLabel => 'Kaydet';

  @override
  String skapiEditorDiffLineCount(int count) {
    return '$count satır değişti';
  }

  @override
  String skapiEditorDiffLinesCount(int count) {
    return '$count satır değişti';
  }

  @override
  String get skapiEditorDiffCompareLink => 'Orijinalle karşılaştır';

  @override
  String get skapiEditorButtonReset => 'Sıfırla';

  @override
  String get skapiEditorButtonSave => 'Kaydet';

  @override
  String get skapiEditorAfterSaveNote =>
      'Kaydedildikten sonra \"Şimdi Çalıştır\" düzenlenmiş sürümü çalıştırır.';

  @override
  String get skapiLinuxDistroHeading => 'Dağıtım ailenizi seçin';

  @override
  String get skapiLinuxDistroSubtitle =>
      'Linux scriptleri Debian tabanlı (apt, .deb) ve Arch tabanlı (pacman) ailelerde farklılaşır. Makinenize uyanı seçin.';

  @override
  String get skapiLinuxDistroDebianLabel => 'Debian tabanlı';

  @override
  String get skapiLinuxDistroDebianSub =>
      'Debian, Ubuntu, Mint, Pop!_OS, Elementary, Kali, MX, Zorin';

  @override
  String get skapiLinuxDistroArchLabel => 'Arch tabanlı';

  @override
  String get skapiLinuxDistroArchSub =>
      'Arch, Manjaro, EndeavourOS, Garuda (sonra eklenecek)';

  @override
  String get skapiNewActionNoDevicesTitle => 'Önce bir cihaz eşle';

  @override
  String get skapiNewActionNoDevicesBody =>
      'Cihaz üstünde çalışan bir aksiyon oluşturmak için en az bir eşli SmartKraft cihazı gerekli (şimdilik BF).';

  @override
  String get skapiNewActionNoDevicesCta => 'Cihazlarım\'a git';

  @override
  String get skapiNewActionPickDeviceTitle => 'Cihaz seçin';

  @override
  String get skapiNewActionPickDeviceSubtitle =>
      'Bu aksiyon hangi cihazda çalışsın?';

  @override
  String get skapiUserNewTitle => 'Yeni Script';

  @override
  String get skapiUserEditTitle => 'Script\'i Düzenle';

  @override
  String get skapiUserTitleLabel => 'Başlık';

  @override
  String get skapiUserTitleHint => 'Örn. Sabah rutini';

  @override
  String get skapiUserDescLabel => 'Açıklama';

  @override
  String get skapiUserDescHint => 'Bu script ne yapar?';

  @override
  String get skapiUserPlatformLabel => 'Platform';

  @override
  String get skapiUserCodeLabel => 'Kod';

  @override
  String get skapiUserCodeHint => '# PowerShell kodunuz buraya';

  @override
  String get skapiUserSaveCta => 'Kaydet';

  @override
  String get skapiUserValidationEmpty => 'Başlık ve kod boş olamaz.';

  @override
  String get skapiUserSavedSnack => 'Script kaydedildi';

  @override
  String get skapiUserSectionHeading => 'Benim Script\'lerim';

  @override
  String skapiUserSectionSub(int count) {
    return '$count script';
  }

  @override
  String get skapiUserEmptyHint =>
      'Henüz kendi script\'in yok. Sağ üstteki Yeni Aksiyon ile oluştur.';

  @override
  String get skapiUserDetailCodeHeading => 'Kod';

  @override
  String get skapiUserEditCta => 'Düzenle';

  @override
  String get skapiUserDeleteConfirmTitle => 'Script silinsin mi?';

  @override
  String skapiUserDeleteConfirmBody(String name) {
    return '$name kalıcı olarak silinecek.';
  }

  @override
  String get skapiUserDeletedSnack => 'Script silindi';

  @override
  String get skapiUserRunCta => 'Çalıştır';

  @override
  String get skapiUserRunUnsupported =>
      'Script çalıştırma yalnızca masaüstünde.';

  @override
  String get skapiUserRunOutputTitle => 'Çıktı';

  @override
  String skapiUserRunDone(int code) {
    return 'Bitti (çıkış $code)';
  }

  @override
  String get skapiLocalScriptsSubheading => 'Yerel scriptler';

  @override
  String get skapiOnDeviceApiSubheading => 'Cihaz üstü API';

  @override
  String get skapiOnDeviceApiLoadError => 'Endpoint\'ler okunamadı';

  @override
  String get skapiOnDeviceApiRowHint => 'Düzenlemek için bir satıra dokunun';

  @override
  String get commonLoading => 'Yükleniyor...';

  @override
  String get skapiApiTemplateSectionHeader => 'Şablonlar';

  @override
  String skapiApiTemplateSectionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count şablon',
      one: '1 şablon',
    );
    return '$_temp0';
  }

  @override
  String get skapiApiTemplateUploadCta => 'Cihaza yükle';

  @override
  String get skapiApiTemplateUploadHint =>
      'Yükleme bu şablonu cihazın 5 USER API slot\'undan birine yazar. Cihaz kendi tetikleyicisiyle çalıştırır (BF: geri sayım bitince).';

  @override
  String get skapiApiTemplatePreviewTitle => 'Endpoint önizleme';

  @override
  String get skapiApiTemplatePreviewType => 'Tür';

  @override
  String get skapiApiTemplatePreviewMethod => 'Metod';

  @override
  String get skapiApiTemplatePreviewUrl => 'URL';

  @override
  String get skapiApiTemplatePreviewAuth => 'Yetkilendirme';

  @override
  String get skapiApiTemplatePreviewHeader => 'Header';

  @override
  String get skapiApiTemplatePreviewContentType => 'Content-Type';

  @override
  String get skapiApiTemplatePreviewPayload => 'Payload';

  @override
  String get skapiApiTemplatePreviewDelay => 'Gecikme';

  @override
  String get skapiOtherCategoryHeading => 'Cihaz kategorisi seçin';

  @override
  String get skapiOtherCategorySubtitle =>
      'Şablonlar eşli cihaza yüklenir ve cihazın kendi tetikleyicisiyle çalışır (bilgisayar devre dışı).';

  @override
  String get skapiOtherSyndimmSub => 'SmartKraft akıllı dimer';

  @override
  String get skapiOtherLebensspurSub => 'SmartKraft aktivite takipçisi';

  @override
  String get skapiOtherBlockingfocusSub => 'SmartKraft odak zamanlayıcısı';

  @override
  String get skapiOtherIotSub =>
      'Üçüncü taraf IoT webhook\'ları (IFTTT, Home Assistant, jenerik REST)';

  @override
  String get skapiOtherServerSub =>
      'Self-hosted HTTP alıcıları (n8n, Node-RED, özel)';

  @override
  String get skapiCategoryComingSoon => 'Şablonlar yakında';

  @override
  String get skapiScriptLockSummaryHowLxDebian =>
      'Aktif XDG_SESSION_ID için loginctl lock-session çağırır; loginctl yoksa xdg-screensaver lock\'a düşer.';

  @override
  String get skapiScriptHibernateSummaryHowLxDebian =>
      'systemctl hibernate çağırır. İsteğe bağlı gecikme parametresi, askıya almadan önce belirtilen saniye kadar bekler.';

  @override
  String get skapiScriptHibernateNoteLxDebian =>
      'Hazırda beklet için yapılandırma gerekir (swap >= RAM ve resume= kernel parametresi). Yapılandırılmamış sistemlerde systemd-logind suspend\'e düşer.';

  @override
  String get skapiScriptSleepSummaryHowLxDebian =>
      'systemctl suspend çağırır. Bir ön plan inhibitor idle geçişini engelliyorsa kernel gecikmeli askıya alabilir.';

  @override
  String get skapiScriptShutdownSummaryHowLxDebian =>
      '/sbin/shutdown -h +N (dakika) ile kibar bir poweroff zamanlar. shutdown yoksa belirtilen gecikme sonrası systemctl poweroff\'a düşer.';

  @override
  String get skapiScriptShutdownNoteLxDebian =>
      '/sbin/shutdown sadece dakika alır; 60 saniyenin altı 1 dakikaya yuvarlanır. Geri sayım sırasında diğer giriş yapmış kullanıcılar wall mesajı görür.';

  @override
  String get skapiScriptShutdownParamForceHintLxDebian =>
      'Kapatmadan önce kullanıcı oturumunu sonlandırarak 90s SIGTERM bekleme süresini atlatır.';

  @override
  String get skapiScriptBrightnessSummaryHowLxDebian =>
      'Dahili ekran arka aydınlatmasını brightnessctl set N% (tercih edilen) veya light -S N (yedek) ile ayarlar. Her ikisi de /sys/class/backlight\'e yazar.';

  @override
  String get skapiScriptBrightnessNoteLxDebian =>
      'Kullanıcı video grubundaysa brightnessctl sudo\'suz çalışır; çoğu Debian kurulumunda varsayılan budur. DDC üzerinden harici monitörler ddcutil gerektirir, burada ele alınmaz.';

  @override
  String get skapiScriptMuteToggleSummaryHowLxDebian =>
      'Ana ses çıkışı sessizliğini wpctl (Debian 12+ PipeWire) üzerinden değiştirir veya ayarlar; PulseAudio kurulumlarında pactl yedeği devreye girer.';

  @override
  String get skapiScriptVolumeSetSummaryHowLxDebian =>
      'Ana ses çıkışı seviyesini 0-100 aralığında wpctl set-volume (PipeWire) veya pactl set-sink-volume (PulseAudio) ile ayarlar.';

  @override
  String get skapiScriptVolumeSetNoteLxDebian =>
      'PipeWire ve PulseAudio uygulama bazlı sesi yerel olarak destekler, bu yüzden bu script Linux\'ta tier 1. %100 üzerindeki çıkış diğer platformlarla parite için sınırlanır.';

  @override
  String get skapiScriptMediaKeySummaryHowLxDebian =>
      'playerctl üzerinden bir medya tuşu aksiyonu gönderir; playerctl o anda oturumu sahiplenen uygulamaya MPRIS ile konuşur (Spotify, Firefox, VLC, mpv, Rhythmbox).';

  @override
  String get skapiScriptMediaKeyNoteLxDebian =>
      'MPRIS uyumlu bir medya uygulaması çalışmıyorsa komut etkisiz kalır. Bilinen bir oynatıcı yanıt vermiyorsa o uygulamanın MPRIS desteğini kurun.';

  @override
  String get skapiScriptMinimizeWindowSummaryHowLxDebian =>
      'Boş processName, xdotool ile aktif pencereyi minimize eder. Aksi halde WM_CLASS\'ı eşleşen ilk pencere bulunur ve minimize edilir.';

  @override
  String get skapiScriptMinimizeWindowNoteLxDebian =>
      'Sadece X11. WM_CLASS eşleştirmesi büyük/küçük harfe duyarlıdır ve uygulamanın kendini nasıl tanımladığına bağlıdır; emin değilseniz xprop WM_CLASS bakın.';

  @override
  String get skapiScriptMinimizeWindowParamProcessHintLxDebian =>
      'WM_CLASS instance adı (örn: firefox, code, gnome-terminal-server). Boş bırakılırsa aktif pencere hedeflenir.';

  @override
  String get skapiScriptCloseWindowSummaryHowLxDebian =>
      'wmctrl -x -c (WM_CLASS eşleşmesi) ile WM_DELETE_WINDOW gönderir, başlık eşleşmesi yedeği vardır. X düğmesine tıklamakla aynıdır; uygulama kendi kaydet diyaloğunu gösterebilir.';

  @override
  String get skapiScriptCloseWindowNoteLxDebian =>
      'Sadece X11. Wayland için pencere protokolü yerine sinyal kullanan kill-app tercih edilmeli.';

  @override
  String get skapiScriptCloseWindowParamProcessHintLxDebian =>
      'WM_CLASS instance adı; boş bırakılırsa aktif pencere kapatılır. Yedek olarak başlık alt-string eşleşmesi kullanılır.';

  @override
  String get skapiScriptKillAppSummaryHowLxDebian =>
      'Eksak comm adıyla pkill -TERM -x gönderir, belirtilen timeout kadar bekler, ardından hâlâ açık olanlara pkill -KILL atar. İsteğe bağlı preKillSave önce pencereyi odaklayıp Ctrl+S gönderir (sadece X11).';

  @override
  String get skapiScriptKillAppNoteLxDebian =>
      'Linux comm adları kernel tarafından 15 karakterle sınırlıdır. Eksak kısa adları kullanın: firefox (firefox-esr-bin değil), code, soffice.bin.';

  @override
  String get skapiScriptKillAppParamProcessHintLxDebian =>
      'Eksak comm adı (15 karakter kernel sınırı). Görünen adı doğrulamak için pgrep -l kullanın.';

  @override
  String get skapiScriptKillAppParamPreKillSaveHintLxDebian =>
      'SIGTERM öncesi uygulama penceresine Ctrl+S gönderir. xdotool ve X11 gerekir; Wayland\'da yok sayılır.';

  @override
  String get skapiScriptLaunchAppSummaryHowLxDebian =>
      'Akıllı dağıtım: .desktop -> gtk-launch, gerçek dosya yolu -> exec, başka her şey -> xdg-open, son olarak PATH araması. setsid ile alt süreç ayrıştırılır, böylece SKAPP bloke olmaz.';

  @override
  String get skapiScriptLaunchAppNoteLxDebian =>
      'args boşluklara göre bölünür. Tırnaklı argümanlar desteklenmez; karmaşık komut satırları için sarmalayıcı script kullanın.';

  @override
  String get skapiScriptLaunchAppParamPathHintLxDebian =>
      'PATH\'teki binary adı, mutlak yol, .desktop dosyası, URL veya dosya yolu. MIME tiplerini xdg-open ele alır.';

  @override
  String get skapiScriptDialogSummaryHowLxDebian =>
      'Modal diyalogu zenity (GTK) ile, kdialog (KDE) yedeğiyle açar. stdout\'a ok / cancel / yes / no / timeout değerlerinden birini yazar.';

  @override
  String get skapiScriptDialogNoteLxDebian =>
      'Kurulum: sudo apt install zenity. KDE Plasma kullanıcılarında kdialog olabilir. İkisi de yoksa script exit kodu 2 ile çıkar.';

  @override
  String get skapiScriptToastSummaryHowLxDebian =>
      'notify-send (libnotify) üzerinden masaüstü bildirimi gönderir. libnotify-bin her modern Debian masaüstünde önyüklü olduğu için tier 1.';

  @override
  String get skapiScriptToastNoteLxDebian =>
      'icon Freedesktop tema isimlerini kabul eder (dialog-information, dialog-warning, dialog-error). duration saniye cinsindendir; 0 ise toast kapatılana kadar kalır.';

  @override
  String get skapiScriptToastParamIconLabelLxDebian => 'İkon';

  @override
  String get skapiScriptToastParamIconHintLxDebian =>
      'Freedesktop ikon adı, örn: dialog-information, dialog-warning, dialog-error.';

  @override
  String get skapiScriptToastParamDurationLabelLxDebian => 'Süre';

  @override
  String get skapiScriptToastParamDurationHintLxDebian =>
      'Bu kadar saniye sonra otomatik kapanır. 0 ise kullanıcı kapatana kadar toast ekranda kalır.';

  @override
  String get skapiScriptShowDesktopSummaryHowLxDebian =>
      'wmctrl -m ile EWMH show-desktop durumunu okur, ardından wmctrl -k ile değiştirir. X11\'de Win+D semantiğinin aynısıdır.';

  @override
  String get skapiScriptShowDesktopNoteLxDebian =>
      'Sadece X11. Wayland karşılıkları compositor\'a özgüdür (Sway, Hyprland, GNOME Shell eklentileri).';

  @override
  String get skapiScriptFadeScreenSummaryHowLxDebian =>
      'Dahili ekran arka aydınlatmasını brightnessctl ile, saniyede 10 adımlık artışlarla mevcut değerden hedefe doğrusal olarak soldurur.';

  @override
  String get skapiScriptFadeScreenNoteLxDebian =>
      'Sadece dahili paneller. DDC üzerinden harici monitörler ddcutil gerektirir, burada ele alınmaz. /sys/class/backlight okuma izinine bağlı olduğu için tier 2.';

  @override
  String get skapiScriptGrayscaleSummaryHowLxDebian =>
      'GNOME erişilebilirlik büyütecinin renk doygunluk anahtarını gsettings ile değiştirir (0.0 gri tonlama, 1.0 renkli); eklenti gerekmez.';

  @override
  String get skapiScriptGrayscaleNoteLxDebian =>
      'Sadece GNOME / Unity. KDE Plasma ve XFCE\'de eşdeğer sistem yolu yoktur; o masaüstlerinde script sessiz no-op yerine exit kodu 3 ile çıkar.';

  @override
  String get skapiScriptFindMouseShakeSummaryHowLxDebian =>
      'İmleç konumunu xdotool getmouselocation ile okur, ardından awk ile hesaplanmış cos/sin koordinatları kullanarak istenen tur sayısı kadar etrafında daire çizdirir.';

  @override
  String get skapiScriptFindMouseShakeNoteLxDebian =>
      'Sadece X11. Wayland synthetic pointer hareketini protokol seviyesinde engeller (güvenlik sınırı), bu yüzden script exit kodu 3 ile çıkar.';

  @override
  String get skapiScriptCloseWithSaveSummaryHowLxDebian =>
      'WM_CLASS eşleşen her görünür pencere için: aktive, Ctrl+S, bekle, ardından wmctrl ile WM_DELETE_WINDOW gönder. Sadece X11.';

  @override
  String get skapiScriptCloseWithSaveNoteLxDebian =>
      'Tier 2: Ctrl+S tuş enjeksiyonu yerel ayar ve odağa bağımlıdır; sadece gerçek kaydet semantiği öngörülebilir davranır. Sohbet veya web uygulamaları Ctrl+S\'i başka bir şeye bağlamış olabilir.';

  @override
  String get skapiScriptCloseWithSaveParamProcessHintLxDebian =>
      'WM_CLASS instance adı (xprop WM_CLASS bakın). Zorunlu.';

  @override
  String get skapiScriptCloseAllInstancesSummaryHowLxDebian =>
      'Eksak comm adıyla eşleşen her çalışan sürece SIGTERM gönderir. Her uygulama kendi kapanış sürecini yönetir (kendi kaydet diyaloğunu gösterebilir).';

  @override
  String get skapiScriptCloseAllInstancesParamProcessHintLxDebian =>
      'pgrep -l ile gösterilen eksak comm adı. Zorunlu.';

  @override
  String get skapiScriptBrowserCloseAllSummaryHowLxDebian =>
      'Debian tarayıcı binary listesini (firefox, firefox-esr, chromium, google-chrome, brave, vivaldi-bin, opera) gezer ve her çalışan instance\'a SIGTERM gönderir.';

  @override
  String get skapiScriptBrowserCloseAllNoteLxDebian =>
      '\"Bir sonraki açılışta sekmeleri geri yükle\" açıksa tarayıcılar oturumu korur, bu yüzden bu işlem veri kaybı değil yumuşak bir \"ekranı kapat\" hareketidir.';

  @override
  String get skapiScriptSaveActiveWindowSummaryHowLxDebian =>
      'Odaklanmış pencereye xdotool key --clearmodifiers ile Ctrl+S gönderir. Sadece X11.';

  @override
  String get skapiScriptSaveActiveWindowNoteLxDebian =>
      'Wayland synthetic tuş enjeksiyonunu protokol seviyesinde engeller. autosave-trigger yedeğini kullanın veya uygulamanın kendi otomatik kaydetmesine güvenin.';

  @override
  String get skapiScriptSaveAllOpenSummaryHowLxDebian =>
      'apps listesini gezer, her uygulamanın görünür pencerelerini bulur, sırayla aktive eder ve aralara bekleme koyarak Ctrl+S gönderir.';

  @override
  String get skapiScriptSaveAllOpenNoteLxDebian =>
      'Varsayılan uygulama listesi LibreOffice (soffice.bin), VS Code (code), gedit ve kate\'i kapsar. Geçersiz kılmak için --apps \"ad1,ad2\" geçin. Sadece X11.';

  @override
  String get skapiScriptSaveAllOpenParamAppsHintLxDebian =>
      'Virgülle ayrılmış comm adları, örn: soffice.bin,code,gedit.';

  @override
  String get skapiScriptAutosaveTriggerSummaryHowLxDebian =>
      'wmctrl -l üzerinden her görünür üst düzey pencereyi gezer, sırayla aktive eder ve Ctrl+S enjekte eder. X11\'de WIN\'in WM_COMMAND broadcast yolu yoktur, yedek olarak pencere bazlı odak kullanılır.';

  @override
  String get skapiScriptAutosaveTriggerNoteLxDebian =>
      'Tier 2: odaklanmış uygulamanın Ctrl+S\'i \"kaydet\" olarak yorumlamasına bağlıdır. Çoğu editör yorumlar; sohbet uygulamaları yanlış anlayabilir. Sadece X11.';

  @override
  String get commonReadFailed => 'okunamadı';

  @override
  String get commonUnknown => 'bilinmiyor';

  @override
  String get commonComingSoon => 'yakında';

  @override
  String get commonDismiss => 'Kapat';

  @override
  String bootstrapBannerError(String error) {
    return 'Cihazdan okunamadı: $error';
  }

  @override
  String get bootstrapBannerRetry => 'Tekrar dene';

  @override
  String get bfApiChainAuthNone => 'Yok';

  @override
  String get bfApiChainAuthBearer => 'Bearer token';

  @override
  String get bfApiChainAuthBasic => 'Basic auth';

  @override
  String get bfApiChainAuthHeader => 'Özel header';

  @override
  String bfApiChainMasterError(String error) {
    return 'Master: $error';
  }

  @override
  String get bfApiChainChainStarted => 'Zincir başlatıldı';

  @override
  String bfApiChainChainError(String error) {
    return 'Hata: $error';
  }

  @override
  String get bfApiChainSaveDialogTitle => 'Endpoint kaydedilsin mi?';

  @override
  String bfApiChainSaveDialogBody(String name) {
    return '\"$name\" cihazda kalıcı olarak yazılacak. Bu işlem kullanıcı verisi alanını günceller.';
  }

  @override
  String get bfApiChainSaveDialogConfirm => 'Kaydet';

  @override
  String bfApiChainSavedToast(String name) {
    return '\"$name\" kaydedildi';
  }

  @override
  String bfApiChainSaveFailed(String error) {
    return 'Kaydedilemedi: $error';
  }

  @override
  String get bfApiChainDeleteDialogTitle => 'Silinsin mi?';

  @override
  String bfApiChainDeleteDialogBody(String name) {
    return '\"$name\" endpoint\'i cihazdan silinir. Bu işlem geri alınamaz.';
  }

  @override
  String get bfApiChainDeleteDialogConfirm => 'Sil';

  @override
  String bfApiChainDeletedToast(String name) {
    return '\"$name\" silindi';
  }

  @override
  String bfApiChainDeleteFailed(String error) {
    return 'Silinemedi: $error';
  }

  @override
  String bfApiChainTestNoReply(String name) {
    return '\"$name\" cevap gelmedi (15 sn timeout)';
  }

  @override
  String bfApiChainTestSuccess(String name, String httpSuffix) {
    return '\"$name\" başarılı$httpSuffix';
  }

  @override
  String bfApiChainTestFailure(String name, String error, String httpSuffix) {
    return '\"$name\" hata: $error$httpSuffix';
  }

  @override
  String bfApiChainTestTriggerFailed(String error) {
    return 'Tetiklenemedi: $error';
  }

  @override
  String get bfApiChainNewEndpointName => 'Yeni endpoint';

  @override
  String get bfApiChainEmptyTitle => 'Henüz endpoint kayıtlı değil';

  @override
  String get bfApiChainEmptyBody =>
      'Aşağıdaki \"Endpoint ekle\" kartıyla yeni bir HTTP çağrısı tanımlayabilirsin (örn. IFTTT webhook, kendi sunucun, Spotify pause).';

  @override
  String get bfApiChainSystemSectionTitle => 'Otomatik (paired SKAPP\'lar)';

  @override
  String get bfApiChainSystemSectionSubtitle =>
      'SKAPI üzerinden script bağladığında her bilgisayar için bir slot otomatik açılır. Sayım bittiğinde imzalı webhook ile bilgisayardaki SKAPP\'a istek gider.';

  @override
  String get bfApiChainUserSectionTitle => 'Manuel (IoT cihazlar)';

  @override
  String get bfApiChainUserSectionSubtitle =>
      'Shelly, Home Assistant, IFTTT gibi üçüncü taraf URL\'leri elle eklersin. Sayım bittiğinde önce bu listenin sırasıyla tetiklenir.';

  @override
  String get bfApiChainMasterToggleLabel => 'Tetikleme aktif';

  @override
  String get bfApiChainMasterOnSubtitle =>
      'Master açık: zincir cihaz tetiklemelerinde fire eder';

  @override
  String get bfApiChainMasterOffSubtitle =>
      'Master kapalı: hiçbir endpoint çağrılmaz';

  @override
  String get bfApiChainFieldNameLabel => 'İsim';

  @override
  String get bfApiChainTypeLabel => 'Tür';

  @override
  String get bfApiChainEventOrApplet => 'Event / Applet';

  @override
  String get bfApiChainMethodLabel => 'Method';

  @override
  String get bfApiChainDelayLabel => 'Sonra bekleme (0-300 sn)';

  @override
  String get bfApiChainDelayUnit => 'sn';

  @override
  String get bfApiChainAdvancedHide => 'Gelişmiş seçenekleri gizle';

  @override
  String get bfApiChainAdvancedShow => 'Gelişmiş seçenekler';

  @override
  String get bfApiChainAuthLabel => 'Yetkilendirme';

  @override
  String bfApiChainCurrentTokenHint(String masked) {
    return 'Mevcut token: $masked (yenilemek için aşağıya yeni değer yaz)';
  }

  @override
  String get bfApiChainNewTokenLabel => 'Yeni token (boş bırakılırsa değişmez)';

  @override
  String get bfApiChainContentTypeLabel => 'Content-Type';

  @override
  String get bfApiChainSaveCta => 'Kaydet';

  @override
  String get bfApiChainDeleteCta => 'Sil';

  @override
  String get bfApiChainTestCta => 'Test';

  @override
  String get bfApiChainAddCardLabel => 'Yeni endpoint ekle';

  @override
  String bfApiChainSavedDelaySeconds(int count) {
    return '$count sn bekle';
  }

  @override
  String get bfApiChainNotSaved => 'kaydedilmedi';

  @override
  String bfApiChainSystemRowSignedTooltip(String peer, int delay) {
    return 'peer $peer…  ·  delay ${delay}sn  ·  imzalı (HMAC)';
  }

  @override
  String get bfApiChainTestEndpointTooltip => 'Bu endpoint\'i test et';

  @override
  String get bfLogsBufferEmpty => 'Cihazın günlük tamponu boş.';

  @override
  String get bfLogsUnsupported => 'Cihaz bu sürümde günlükleri desteklemiyor.';

  @override
  String get deviceLogsNoClockBanner =>
      'Cihaz saati yok, zaman damgaları boot anından itibaren saniye olarak gösteriliyor.';

  @override
  String get deviceLogsTruncatedHint =>
      '(çıktı kısaltıldı, daha düşük limit veya daha yüksek severity deneyin)';

  @override
  String get bfEventsTimerRunning => 'Sayım başladı';

  @override
  String get bfEventsTimerPaused => 'Sayım duraklatıldı';

  @override
  String get bfEventsTimerIdle => 'Sayım sıfırlandı';

  @override
  String get bfEventsTimerCooldown => 'Soğuma';

  @override
  String get bfEventsTimerExpired => 'Sayım tamamlandı';

  @override
  String bfEventsFaceChanged(String from, String to) {
    return 'Yüz değişti: $from → $to';
  }

  @override
  String bfEventsApiTriggered(String type) {
    return '$type tetiklendi';
  }

  @override
  String get bfEventsApiTriggeredFallback => 'API tetiklendi';

  @override
  String bfEventsBatteryLevel(int percent) {
    return 'Pil seviyesi: %$percent';
  }

  @override
  String get bfEventsDeviceRestarted => 'Cihaz yeniden başladı';

  @override
  String skapiManifestLoadingRetry(String platform, String scriptId) {
    return '$platform/$scriptId manifest yükleniyor, biraz sonra tekrar dene';
  }

  @override
  String get skapiListenerOffMobileTitle =>
      'Bu cihaz Desktop script çalıştıramaz';

  @override
  String get skapiListenerOffDesktopTitle => 'SKAPP HTTP dinleyicisi kapalı';

  @override
  String get skapiListenerOffMobileBody =>
      'Sayım bittiğinde script çalışacak Windows / macOS / Linux üzerinde SKAPP açık ve dinleyici aktif olmalı. Bu telefon sadece yapılandırma tarafıdır; çalıştırma masaüstünde olur.';

  @override
  String skapiListenerOffDesktopBody(String lastErrorSuffix) {
    return 'BF webhook\'u atacak ama dinleyici kapalı olduğu için isteği kimse yakalamaz. Settings → SKAPP HTTP Dinleyici\'yi aç.$lastErrorSuffix';
  }

  @override
  String get skapiSyncBadgeWriting => 'BF\'ye yazılıyor…';

  @override
  String get skapiSyncBadgeWritten => 'BF\'ye kayıtlı';

  @override
  String get skapiSyncBadgeFailed => 'BF\'ye yazılamadı';

  @override
  String skapiSyncBadgeFirmwareCodeTooltip(String code) {
    return 'Firmware kodu: $code';
  }

  @override
  String get syncErrUnknownCommand =>
      'Cihazda eski firmware. Yeni firmware\'i flash\'la';

  @override
  String get syncErrNotAuthenticated =>
      'Cihaz oturumu yetkilenmedi (yeniden eşleşme gerekebilir)';

  @override
  String get syncErrNotFound => 'Cihazda eşleşme kaydı yok';

  @override
  String get syncErrInternal => '8 SYSTEM slot dolu olabilir';

  @override
  String get syncErrUnknown => 'bilinmeyen hata';

  @override
  String get syncErrTimeout => 'Cihaz cevap vermedi (offline?)';

  @override
  String get syncErrNoBond => 'Bu cihazla eşleşme yok';

  @override
  String get syncErrConnect => 'Cihaza bağlanılamadı';

  @override
  String get discoveryFilterShowAll => 'Tüm cihazları göster';

  @override
  String get discoveryFilterOnlySmartKraft => 'Yalnız SmartKraft';

  @override
  String discoveryScanningWithCount(int count, String tail) {
    return 'Aranıyor… $count cihaz bulundu$tail';
  }

  @override
  String discoveryFoundCountWithTail(int count, String tail) {
    return '$count cihaz bulundu$tail';
  }

  @override
  String discoveryFilterOff(int visible, int sk, String tail) {
    return 'Filtre kapalı · $visible cihaz görünüyor ($sk SmartKraft$tail)';
  }

  @override
  String discoveryMdnsTail(int count) {
    return ' + ağda $count';
  }

  @override
  String get discoveryWifiOnlySnack =>
      'Bu cihaz şu an yalnız WiFi üzerinden görünüyor. WiFi üzerinden eşleşme henüz aktif değil, cihazın butonuna kısa basıp eşleşme penceresini açın, BLE üzerinden bulunduğunda bu satır eşleşmeye uygun olur.';

  @override
  String get discoveryBadgePairable => 'Eşleşmeye açık';

  @override
  String get discoveryBadgeBonded => 'Başka SKAPP ile eşli';

  @override
  String get pairingTitleConnecting => 'Bağlanılıyor';

  @override
  String get pairingTitleReconnecting => 'Yeniden bağlanılıyor';

  @override
  String get pairingMutualAuthHmacSubtitle => 'HMAC challenge-response';

  @override
  String pairingBleConnectFailed(String error) {
    return 'BLE bağlantısı kurulamadı.\n\nÇözüm: Cihazın butonuna **kısa bas**, eşleşme penceresi 60 sn açılır, sonra \"Tekrar dene\" butonuna tıkla.\n\nDetay: $error';
  }

  @override
  String get pairingGattServiceMissing => 'SKAPP servisi bulunamadı';

  @override
  String get pairingGattCmdRxMissing => 'cmd_rx karakteristiği yok';

  @override
  String get pairingGattEventTxMissing => 'event_tx karakteristiği yok';

  @override
  String pairingGattDiscoveryFailed(String error) {
    return 'GATT keşfi başarısız: $error';
  }

  @override
  String pairingKeySendFailed(String error) {
    return 'Anahtar gönderilemedi: $error';
  }

  @override
  String pairingDeviceNoReply(int seconds) {
    return 'Cihaz cevap vermedi ($seconds sn).';
  }

  @override
  String pairingDeviceRejected(String error) {
    return 'Cihaz reddetti: $error';
  }

  @override
  String get pairingInvalidReplyMissingPub =>
      'Geçersiz cihaz cevabı (our_pub eksik).';

  @override
  String pairingHexDecodeFailed(String error) {
    return 'our_pub hex çözülemedi: $error';
  }

  @override
  String get pairingRetryButton => 'Tekrar dene';

  @override
  String pairingReconnectTransient(String error) {
    return 'Cihaza bağlanılamadı, eşleşme korundu.\n\nCihazın açık ve menzilde olduğundan emin olun, sonra \"Tekrar dene\" butonuna tıklayın.\n\nDetay: $error';
  }

  @override
  String get pairingRecoveryTitle => 'Eşleşmeyi yenile';

  @override
  String get pairingRecoveryBody =>
      'Cihaz mevcut eşleşmeyi tanımıyor. Yeni bir eşleşme için cihazın pairing butonuna basıp 60 saniyelik pencereyi açın, sonra Devam\'a tıklayın.';

  @override
  String get pairingRecoveryContinue => 'Devam';

  @override
  String get pairingRecoveryCancelled =>
      'Eşleşme yenileme iptal edildi. Eski eşleşme dosyada duruyor; istediğinde \"Tekrar dene\" ile başka bir bağlantı denemesi yapabilirsin.';

  @override
  String get pairingRenewBondButton => 'Eşleşmeyi yenile';

  @override
  String wifiPasswordConnectionRejected(String error) {
    return 'Bağlantı reddedildi: $error';
  }

  @override
  String get wifiPasswordTimeout => 'Cihaz cevap vermedi (zaman aşımı).';

  @override
  String wifiScanRejected(String error) {
    return 'Cihaz wifi.scan reddetti: $error\n\nCihazın WiFi modülü başlamamış olabilir; reboot deneyin.';
  }

  @override
  String wifiScanUnexpectedReply(String data) {
    return 'Beklenmeyen wifi.scan cevabı: $data';
  }

  @override
  String wifiScanTimeout(String error) {
    return 'Cihaz cevap vermedi (zaman aşımı: $error).\n\nCihaza yakın olun, butona kısa bas (advertising tetiklensin) ve tekrar deneyin.';
  }

  @override
  String wifiScanConnectionError(String error) {
    return 'Bağlantı hatası: $error';
  }

  @override
  String get wifiScanHeaderHelp =>
      'Aşağıda **cihazın** çevresinde gördüğü WiFi ağları listelenir (telefonun ağlarıyla alakalı değildir). Cihaz hangi ağa bağlanacaksa onu seç; şifre sonraki adımda istenecek.';

  @override
  String get wifiScanAuthOpen => 'Açık';

  @override
  String get wifiScanAuthEncrypted => 'Şifreli';

  @override
  String get wifiSuccessSyncing => 'Saat senkronlanıyor…';

  @override
  String get wifiSuccessFetchingInfo => 'Cihaz bilgisi alınıyor…';

  @override
  String get wifiSuccessPreparingUi => 'Cihaz arayüzü hazırlanıyor…';

  @override
  String wifiSuccessManifestRejected(String error) {
    return 'device.manifest reddedildi ($error). Eski firmware olabilir; BF için sk_baseline.c yüklenmiş olmalı.';
  }

  @override
  String get wifiSuccessTapToContinue => 'Devam etmek için dokun…';

  @override
  String get deviceHomeUnsupportedTitle => 'Desteklenmeyen cihaz';

  @override
  String deviceHomeUnsupportedBody(String name) {
    return '$name için bu SKAPP sürümünde bir cihaz ekranı yok. Yeni cihaz ailesi eklendiğinde bu ekran otomatik görünecek.';
  }

  @override
  String get lsPairingUnpairTitle => 'Bu APP\'in eşleşmesini kaldır';

  @override
  String get lsPairingUnpairBody =>
      'Cihaz bu APP\'in bond\'unu unutacak. Yeniden eşleşmen gerekecek (Cihazlarım\'da 3 sn buton + seç).';

  @override
  String get skYakindaBadgeDefault => 'yakında';

  @override
  String get skapiScriptPulseBrightnessTitle => 'Parlaklık Nabız';

  @override
  String get skapiScriptPulseBrightnessSummaryWhat =>
      'Dahili ekran parlaklığını yumuşak bir kosinüs eğrisinde %100 ile alt sınır arasında nabız gibi titretir, ayarlı sayıda tekrar eder. Bittiğinde kullanıcının orijinal parlaklık değeri geri yüklenir.';

  @override
  String get skapiScriptPulseBrightnessSummaryHow =>
      'WMI üzerinden mevcut parlaklığı okur, sonra saniyede 20 kez kosinüs eğrisini takip eden bir parlaklık örneği yazar. Çıkışta yakalanan orijinal değeri her zaman geri yükler.';

  @override
  String get skapiScriptPulseBrightnessNote =>
      'Yalnızca dahili paneller (laptop, tablet). Harici DDC/CI monitörler bu WMI yoluna tepki vermez.';

  @override
  String get skapiScriptPulseBrightnessParamPeriodLabel => 'periyot';

  @override
  String get skapiScriptPulseBrightnessParamPeriodHint =>
      'Tek bir aydınlık -> karanlık -> aydınlık döngüsünün saniyesi. Yaklaşık 2 sn net bir nabız hissi verir.';

  @override
  String get skapiScriptPulseBrightnessParamLowPercentLabel => 'alt %';

  @override
  String get skapiScriptPulseBrightnessParamLowPercentHint =>
      'Nabzın karanlık ucu, tam parlaklığın yüzdesi olarak. Düşük değerler nabzı daha dramatik yapar.';

  @override
  String get skapiScriptPulseBrightnessParamCyclesLabel => 'döngü';

  @override
  String get skapiScriptPulseBrightnessParamCyclesHint =>
      'Çıkmadan önce kaç tam nabız döngüsü çalıştırılacak.';

  @override
  String get skapiScriptBlurTimedTitle => 'Bulanık Mola';

  @override
  String get skapiScriptBlurTimedSummaryWhat =>
      'Belirlenen süre boyunca ekranı tam ekran, her zaman önde, yarı saydam bir tülle örter. Ortada bir geri sayım gösterilir.';

  @override
  String get skapiScriptBlurTimedSummaryHow =>
      'AllowsTransparency açık bir WPF penceresi seçilen opaklıkta katı bir renk fırçası ile çizer. Dispatcher timer geri sayımı sürdürür; sıfıra ulaşınca pencere kendini kapatır.';

  @override
  String get skapiScriptBlurTimedNote =>
      'Pragmatik ara çözüm: masaüstü üzerine gerçek zamanlı Gaussian blur için C++/Win2D yardımcı binary gerekli, sonradan eklenecek. Katı tül o zamana kadar \'ekrana odaklanamıyorum, ara verim\' hissini benzer şekilde verir.';

  @override
  String get skapiScriptBlurTimedParamDurationLabel => 'süre';

  @override
  String get skapiScriptBlurTimedParamDurationHint =>
      'Tülün otomatik kapanmadan önce ekranda kalacağı saniye.';

  @override
  String get skapiScriptBlurTimedParamOpacityLabel => 'opaklık';

  @override
  String get skapiScriptBlurTimedParamOpacityHint =>
      'Tül opaklığı 0.0 (görünmez) - 1.0 (tam). Yaklaşık 0.55 masaüstünü yarı şeffaf hissettirir, tam karartmaz.';

  @override
  String get skapiScriptBlurTimedParamColorLabel => 'renk';

  @override
  String get skapiScriptBlurTimedParamColorHint =>
      '#RRGGBB hex formatında tül rengi. Palette siyah #0A0A0A varsayılan; krem tonları daha sakin hisseder.';

  @override
  String get skapiScriptBlockingFocusTitle => 'Blocking Focus';

  @override
  String get skapiScriptBlockingFocusSummaryWhat =>
      'Birleşik odak zorlayıcı: önce tüm açık Office ve VS Code belgelerini kaydeder, sonra tam ekran kapatma butonsuz geri sayım penceresi açar ve fare sürekli daire çizer. Süre bittiğinde her şey otomatik geri alınır.';

  @override
  String get skapiScriptBlockingFocusSummaryHow =>
      'Üç aşama art arda: (1) kayıt fazı Office COM ve VS Code CLI çağırır; (2) paralel runspace bir senkronize stop bayrağı düşene kadar imleci daire içinde sürdürür; (3) STA WPF pencere başlık ve geri sayımı gösterir. Finally bloğu imleç origin\'i ve iki runspace\'i tertemiz toparlar.';

  @override
  String get skapiScriptBlockingFocusNote =>
      'Yumuşak mod: Esc ve Alt+F4 engellenmez. Kullanıcı her zaman Görev Yöneticisi ile çıkabilir. Sıkı mod (global klavye hook) ayrı bir script olacak.';

  @override
  String get skapiScriptBlockingFocusParamDurationLabel => 'süre';

  @override
  String get skapiScriptBlockingFocusParamDurationHint =>
      'Kilitlenmenin süresi (saniye). Geri sayım 00:00\'a iner, sonra her şey temizlenir.';

  @override
  String get skapiScriptBlockingFocusParamTitleLabel => 'başlık';

  @override
  String get skapiScriptBlockingFocusParamTitleHint =>
      'Tam ekran penceresinin ortasında gösterilen yazı. Kısa tut - \'Blocking Focus\' varsayılan.';

  @override
  String get skapiScriptBlockingFocusParamShakeRadiusLabel => 'shake yarıçapı';

  @override
  String get skapiScriptBlockingFocusParamShakeRadiusHint =>
      'İmleç döngü sırasında origin\'inden ne kadar piksel uzaklaşacak. Büyük daireler daha çok dikkat çeker.';

  @override
  String get skapiScriptBlockingFocusParamEnableSaveLabel =>
      'başlangıçta kaydet';

  @override
  String get skapiScriptBlockingFocusParamEnableSaveHint =>
      'Kilit öncesi Office + VS Code kayıt fazını çalıştır. Belge state\'i korunmayacaksa kapat.';

  @override
  String get trayFirstHideToast =>
      'SKAPP arka planda çalışmaya devam ediyor. Sistem tepsisinden ulaşabilir, çıkmak için sağ tıklayabilirsin.';

  @override
  String devicesOfflineTapHint(String name) {
    return '$name çevrimdışı.';
  }

  @override
  String skapiNewActionDeviceOffline(String name) {
    return '$name çevrimdışı. Yeni aksiyon oluşturmak için cihazı çevrim içine al.';
  }

  @override
  String get bfApiChainRefreshDirtyTitle => 'Kaydedilmemiş değişiklikler';

  @override
  String get bfApiChainRefreshDirtyBody =>
      'Yenileme cihazdan güncel endpoint listesini çeker, henüz kaydetmediğin taslak silinir.';

  @override
  String get bfApiChainRefreshDirtyConfirm => 'Yine de yenile';

  @override
  String get skapiApiEditorTitle => 'Cihaz Üzeri API';

  @override
  String get lsCommonReadFailed => 'Okunamadı';

  @override
  String lsCommonFailedWith(String err) {
    return 'Başarısız: $err';
  }

  @override
  String get lsVacationStatusOff => 'Kapalı';

  @override
  String lsVacationStatusUntil(String date) {
    return '$date tarihine kadar';
  }

  @override
  String get lsVacationDaysValidationError =>
      'Gün sayısı 1 ile 60 arasında olmalı';

  @override
  String lsVacationStartedSnack(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Tatil başladı · $days gün',
      one: 'Tatil başladı · 1 gün',
    );
    return '$_temp0';
  }

  @override
  String get lsVacationCancelledSnack => 'Tatil iptal edildi';

  @override
  String lsVacationActiveUntilFmt(String date) {
    return '$date tarihine kadar aktif';
  }

  @override
  String get lsVacationResumeHint => 'Geri sayım tatil bittiğinde devam eder.';

  @override
  String get lsVacationCancellingButton => 'İptal ediliyor…';

  @override
  String get lsVacationCancelButton => 'Tatili iptal et';

  @override
  String get lsVacationDaysLabel => 'Gün';

  @override
  String get lsVacationDaysHint =>
      'Geri sayımı bu kadar gün duraklatır (1 ile 60 arası).';

  @override
  String get lsVacationStartingButton => 'Başlatılıyor…';

  @override
  String get lsVacationStartButton => 'Tatili başlat';

  @override
  String get lsCommonSavingButton => 'Kaydediliyor…';

  @override
  String get lsCommonSaveButton => 'Kaydet';

  @override
  String lsCommonSaveFailedWith(String err) {
    return 'Kaydetme başarısız: $err';
  }

  @override
  String get lsDurationValueValidationError => 'Değer 1 ile 60 arasında olmalı';

  @override
  String get lsDurationAlarmsValidationError =>
      'Alarm sayısı 0 ile 10 arasında olmalı';

  @override
  String get lsDurationConfiguredSnack => 'Zamanlayıcı ayarlandı';

  @override
  String lsDurationUnitMinute(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value dakika',
      one: '1 dakika',
    );
    return '$_temp0';
  }

  @override
  String lsDurationUnitHour(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value saat',
      one: '1 saat',
    );
    return '$_temp0';
  }

  @override
  String lsDurationUnitDay(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value gün',
      one: '1 gün',
    );
    return '$_temp0';
  }

  @override
  String lsDurationAlarmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alarm',
      one: '1 alarm',
    );
    return '$_temp0';
  }

  @override
  String get lsDurationUnitLabel => 'Birim';

  @override
  String get lsDurationUnitMinutesPlural => 'dakika';

  @override
  String get lsDurationUnitHoursPlural => 'saat';

  @override
  String get lsDurationUnitDaysPlural => 'gün';

  @override
  String get lsDurationValueLabel => 'Değer';

  @override
  String get lsDurationValueHint => '1 ile 60 arası';

  @override
  String get lsDurationAlarmCountLabel => 'Alarm sayısı';

  @override
  String get lsDurationAlarmCountHint =>
      'Alarmlar sondan başa doğru, birer birim aralıkla çalar.';

  @override
  String get lsSmtpStatusNotConfigured => 'Yapılandırılmamış';

  @override
  String get lsSmtpHostRequired => 'Sunucu adı gerekli';

  @override
  String get lsSmtpPortValidationError => 'Port 1 ile 65535 arasında olmalı';

  @override
  String get lsSmtpSenderRequired => 'Gönderen adresi gerekli';

  @override
  String get lsSmtpFieldHost => 'Sunucu';

  @override
  String get lsSmtpFieldPort => 'Port';

  @override
  String get lsSmtpFieldSender => 'Gönderen';

  @override
  String get lsSmtpFieldKey => 'Anahtar';

  @override
  String lsSmtpSaveHaltedOn(String err) {
    return 'Kaydetme durdu: $err';
  }

  @override
  String get lsSmtpSavedSnack => 'SMTP kaydedildi';

  @override
  String get lsSmtpTestSentSnack => 'Test e-postası gönderildi';

  @override
  String lsSmtpTestFailedWith(String err) {
    return 'Test başarısız: $err';
  }

  @override
  String get lsSmtpUrlCopiedSnack => 'Bağlantı panoya kopyalandı';

  @override
  String get lsSmtpApiKeyPlaceholder => 'Gmail Uygulama Şifresi / API anahtarı';

  @override
  String get lsSmtpServerLabel => 'Sunucu';

  @override
  String get lsSmtpApiKeyLabel => 'API anahtarı';

  @override
  String get lsSmtpApiKeyHint => 'Mevcut anahtarı korumak için boş bırak.';

  @override
  String get lsSmtpAppPasswordHelpLink => 'Gmail Uygulama Şifresi nasıl alınır';

  @override
  String get lsSmtpSendingButton => 'Gönderiliyor…';

  @override
  String get lsSmtpSendTestButton => 'Test gönder';

  @override
  String get lsReminderMailRecipientValidation =>
      'Alıcı bir e-posta adresi olmalı';

  @override
  String get lsReminderMailSavedSnack => 'Hatırlatma yerel olarak kaydedildi';

  @override
  String get lsReminderMailRecipientFirstSnack => 'Önce alıcı adresi gir';

  @override
  String get lsReminderMailTestOkSnack =>
      'SMTP testi başarılı, kimlik bilgileri sunucuya ulaşıyor';

  @override
  String lsReminderMailTestFailedWith(String err) {
    return 'SMTP testi başarısız: $err';
  }

  @override
  String get lsReminderMailRecipientLabel => 'Alıcı e-postası';

  @override
  String get lsReminderMailSubjectLabel => 'Konu';

  @override
  String get lsReminderMailBodyLabel => 'İçerik';

  @override
  String get lsReminderMailBodyHint => 'Geri sayım yakında tetiklenecek...';

  @override
  String get lsReminderMailActiveLabel => 'Aktif';

  @override
  String get lsReminderMailFootnote =>
      'Bu cihazda yerel olarak kaydedildi. Test gönderme yalnız SMTP sunucusuna erişimi doğrular; timer.alarm üzerinde otomatik tetikleme firmware desteği bekliyor.';

  @override
  String get lsResetApiStatusDisabled => 'Devre dışı';

  @override
  String lsResetApiStatusEnabledPort(int port) {
    return 'Etkin · port $port';
  }

  @override
  String get lsResetApiRegenDialogTitle => 'API anahtarı yenilensin mi?';

  @override
  String get lsResetApiRegenDialogBody =>
      'Mevcut anahtar geçersiz olur. Eski anahtarı kullanan tüm istemciler güncellenene kadar reddedilir. Devam edilsin mi?';

  @override
  String get lsResetApiRegenConfirm => 'Yenile';

  @override
  String get lsResetApiKeyRegeneratedSnack => 'Anahtar yenilendi';

  @override
  String get lsResetApiEnabledLabel => 'Etkin';

  @override
  String get lsResetApiEnabledHint =>
      'Açıkken, eşleşen anahtarla endpoint URL\'ine yapılan HTTP GET geri sayımı sıfırlar.';

  @override
  String get lsResetApiEndpointUrlLabel => 'Endpoint URL\'i';

  @override
  String get lsResetApiUrlNotAvailable => '(mevcut değil)';

  @override
  String get lsResetApiCopyUrlTooltip => 'URL\'i kopyala';

  @override
  String get lsResetApiKeyLabel => 'API anahtarı';

  @override
  String get lsResetApiKeyNotSet => '(belirtilmemiş)';

  @override
  String get lsResetApiExampleLabel => 'Örnek';

  @override
  String get lsResetApiRegenerateButton => 'Anahtarı yenile';

  @override
  String get lsAlarmApiUrlValidation =>
      'URL http:// veya https:// ile başlamalı';

  @override
  String get lsAlarmApiHeadersValidation => 'Header alanı geçerli JSON olmalı';

  @override
  String get lsAlarmApiSaveDialogTitle => 'Webhook endpoint kaydedilsin mi?';

  @override
  String lsAlarmApiSaveDialogBody(String name, String url) {
    return '`$name` cihazda şu adrese yönlendirilerek kaydedilecek:\n$url';
  }

  @override
  String get lsAlarmApiSavedSnack => 'Webhook kaydedildi';

  @override
  String get lsAlarmApiDisabledSnack => 'Webhook devre dışı bırakıldı';

  @override
  String get lsAlarmApiTestQueuedSnack =>
      'Test kuyruğa alındı, alıcı servisi izle';

  @override
  String lsAlarmApiTestFailedWith(String err) {
    return 'Test başarısız: $err';
  }

  @override
  String get lsAlarmApiRemoveDialogTitle => 'Webhook silinsin mi?';

  @override
  String lsAlarmApiRemoveDialogBody(String name) {
    return '`$name` cihazdan silinir. Yerel yapılandırma korunur.';
  }

  @override
  String get lsAlarmApiRemoveButton => 'Sil';

  @override
  String lsAlarmApiRemoveFailedWith(String err) {
    return 'Silme başarısız: $err';
  }

  @override
  String get lsAlarmApiConfiguredStatus => 'Yapılandırıldı';

  @override
  String lsAlarmApiConfiguredHost(String host) {
    return 'Yapılandırıldı · $host';
  }

  @override
  String get lsAlarmApiUrlLabel => 'URL';

  @override
  String get lsAlarmApiMethodLabel => 'HTTP metodu';

  @override
  String get lsAlarmApiHeadersLabel => 'Header\'lar (JSON, opsiyonel)';

  @override
  String get lsAlarmApiHeadersHint =>
      'Opsiyonel başlıkları içeren JSON nesnesi. Yerel kaydedilir; firmware tetiklemede uygular.';

  @override
  String get lsAlarmApiBodyTemplateLabel => 'Body şablonu (JSON)';

  @override
  String get lsAlarmApiBodyTemplateHint =>
      'device ve remaining_sec yer tutucuları tetikleme anında yerine konur.';

  @override
  String get lsAlarmApiBearerLabel => 'Bearer token (opsiyonel)';

  @override
  String get lsAlarmApiFootnote =>
      'timer.alarm olayı için firmware subscriber bekliyor. Bu yapılandırma endpoint\'i kaydeder; bir sonraki firmware güncellemesine kadar otomatik tetiklenmez.';

  @override
  String lsRelaySummarySeconds(int seconds) {
    return '$seconds sn';
  }

  @override
  String lsRelaySummaryMinutes(int minutes) {
    return '$minutes dk';
  }

  @override
  String get lsRelayModePulse => 'darbe';

  @override
  String get lsRelayModeSteady => 'sabit';

  @override
  String lsRelaySummaryFmt(int gpio, String duration, String mode) {
    return 'GPIO $gpio · $duration $mode';
  }

  @override
  String get lsRelayGpioValidation => 'GPIO 0 ile 30 arasında olmalı';

  @override
  String get lsRelayDurationValidation =>
      'Süre 1 ile 3600 saniye arasında olmalı';

  @override
  String get lsRelayPulseValidation =>
      'Darbe yarım periyodu 1 ile 60 arasında olmalı';

  @override
  String lsRelayCmdFailedWith(String cmd, String err) {
    return '$cmd başarısız: $err';
  }

  @override
  String get lsRelayConfiguredSnack => 'Röle yapılandırıldı';

  @override
  String get lsRelayFireAbortedSnack => 'Tetikleme iptal edildi';

  @override
  String get lsRelayForcedIdleSnack => 'Röle zorla boşa alındı';

  @override
  String get lsRelayGpioLabel => 'GPIO pini';

  @override
  String get lsRelayGpioHint => 'ESP32-C6 geçerli pin; varsayılan 19 = D8';

  @override
  String get lsRelayInvertLabel => 'Polariteyi tersine çevir';

  @override
  String get lsRelayStartDelayLabel => 'Başlangıç gecikmesi';

  @override
  String lsRelayStartDelayHint(int sec) {
    return 'Röle aktifleşmeden $sec sn önce';
  }

  @override
  String get lsRelayActiveDurationLabel => 'Aktif süre';

  @override
  String get lsRelayUnitSeconds => 'Saniye';

  @override
  String get lsRelayUnitMinutes => 'Dakika';

  @override
  String get lsRelayPulseModeLabel => 'Darbe modu';

  @override
  String get lsRelayPulseModeHint =>
      'On = 1 sn yarım periyot. Custom yarım periyodu sen belirlersin.';

  @override
  String get lsRelayHalfCycleLabel => 'Yarım periyot (sn)';

  @override
  String get lsRelayFiringButton => 'Tetikleniyor…';

  @override
  String get lsRelayTestRelayButton => 'Röleyi test et';

  @override
  String get lsRelayAbortButton => 'İptal';

  @override
  String get lsRelayForceOffButton => 'Zorla kapat';

  @override
  String get lsRelayPulseOff => 'Kapalı';

  @override
  String get lsRelayPulseOn => 'Açık';

  @override
  String get lsRelayPulseCustom => 'Özel';

  @override
  String get lsRelayPhaseActiveBadge => 'aktif';

  @override
  String lsRelayPhaseLine(String phase, String elapsed) {
    return 'Faz: $phase$elapsed';
  }

  @override
  String get lsTelegramTokenRequired => 'Bot token gerekli';

  @override
  String get lsTelegramChatRequired => 'Sohbet ID gerekli';

  @override
  String get lsTelegramSaveDialogTitle => 'Telegram endpoint kaydedilsin mi?';

  @override
  String lsTelegramSaveDialogBody(String name) {
    return '`$name` cihazda kaydedilir. Token URL\'in içinde gönderilir.';
  }

  @override
  String get lsTelegramSavedSnack => 'Telegram endpoint kaydedildi';

  @override
  String get lsTelegramDisabledSnack =>
      'Telegram endpoint devre dışı bırakıldı';

  @override
  String get lsTelegramTestQueuedSnack =>
      'Test kuyruğa alındı, Telegram sohbetini izle';

  @override
  String get lsTelegramRemoveDialogTitle => 'Telegram endpoint silinsin mi?';

  @override
  String get lsTelegramBotConfiguredStatus => 'Bot yapılandırıldı';

  @override
  String get lsTelegramBotTokenLabel => 'Bot token';

  @override
  String get lsTelegramBotTokenHint =>
      '@BotFather\'dan al (1234567:AAH... biçiminde).';

  @override
  String get lsTelegramChatIdLabel => 'Sohbet ID';

  @override
  String get lsTelegramChatIdHint =>
      'Sayısal id (-100...) veya @kanal kullanıcı adı.';

  @override
  String get lsTelegramMessageTemplateLabel => 'Mesaj şablonu';

  @override
  String get lsTelegramMessageHint => 'LebensSpur: Alarm tetiklendi.';

  @override
  String get lsLsApiUrlRequired => 'URL gerekli';

  @override
  String get lsLsApiUpdatedSnack => 'Webhook güncellendi';

  @override
  String get lsLsApiSavedSnack => 'Webhook kaydedildi';

  @override
  String get lsLsApiSaveFirstSnack => 'Önce webhook\'u kaydet';

  @override
  String get lsLsApiTestQueuedSnack =>
      'Test kuyruğa alındı, alıcıyı kontrol et';

  @override
  String get lsLsApiRemoveDialogBody =>
      'LS webhook\'u cihazdan silinecek. Geri sayım artık onu tetiklemeyecek.';

  @override
  String get lsLsApiRemovedSnack => 'Webhook silindi';

  @override
  String get lsLsApiConfirmCriticalTitle => 'Kritik değişikliği onayla';

  @override
  String lsLsApiConfirmCriticalBody(String cmd, int ttlSec) {
    return 'Cihaz onay istiyor:\n  $cmd\n\nBu token $ttlSec sn içinde dolacak.';
  }

  @override
  String get lsLsApiConfirmButton => 'Onayla';

  @override
  String lsLsApiActiveSlot(String name) {
    return 'Aktif · slot \"$name\"';
  }

  @override
  String lsLsApiActiveWithToken(String name, String token) {
    return 'Aktif · slot \"$name\" · token $token';
  }

  @override
  String get lsLsApiUrlHint =>
      'timer.triggered tetiklenince çağrılır. https:// önerilir.';

  @override
  String get lsLsApiHeadersLabel => 'Header\'lar (JSON)';

  @override
  String get lsLsApiHeadersHint =>
      'İleri: CLI üzerinden henüz bağlı değil. Bir sonraki sürüm için ayrılmış.';

  @override
  String get lsLsApiBodyTemplateHint =>
      'Test payload olarak gönderilir. device yer tutucusu sunucu tarafında değiştirilir.';

  @override
  String lsLsApiBearerHintExisting(String token) {
    return 'Mevcut: $token. Korumak için boş bırak veya üzerine yazmak için yeni değer yapıştır.';
  }

  @override
  String get lsLsApiBearerHintEmpty =>
      '`Authorization: Bearer <token>` olarak gönderilir.';

  @override
  String get lsLsApiUpdateButton => 'Güncelle';

  @override
  String lsMailGroupsStatusFmt(int count, int max, int recipients) {
    return '$count/$max · toplam $recipients alıcı';
  }

  @override
  String lsMailGroupsReadFailedWith(String err) {
    return 'Okuma başarısız: $err';
  }

  @override
  String get lsMailGroupsNameValidation =>
      'İsim 1 ile 47 karakter arasında olmalı';

  @override
  String get lsMailGroupsNameSaved => 'İsim kaydedildi';

  @override
  String get lsMailGroupsSubjectValidation =>
      'Konu en fazla 127 karakter olmalı';

  @override
  String get lsMailGroupsSubjectSaved => 'Konu kaydedildi';

  @override
  String get lsMailGroupsBodyValidation =>
      'İçerik en fazla 511 karakter olmalı';

  @override
  String get lsMailGroupsBodySaved => 'İçerik kaydedildi';

  @override
  String get lsMailGroupsEmailValidation => 'Geçerli bir e-posta gir';

  @override
  String lsMailGroupsMaxReached(int max) {
    return 'En fazla $max grup olabilir';
  }

  @override
  String get lsMailGroupsNameEmpty => 'İsim boş olamaz';

  @override
  String get lsMailGroupsCreatedSnack => 'Grup oluşturuldu';

  @override
  String lsMailGroupsCreateFailedWith(String err) {
    return 'Oluşturma başarısız: $err';
  }

  @override
  String get lsMailGroupsDeleteDialogTitle => 'Grup silinsin mi?';

  @override
  String get lsMailGroupsDeleteDialogBody =>
      'Cihazdaki grup ve tüm alıcıları silinir.';

  @override
  String get lsMailGroupsDeleteConfirm => 'Sil';

  @override
  String get lsMailGroupsDeletedSnack => 'Grup silindi';

  @override
  String lsMailGroupsDefaultName(int n) {
    return 'Grup $n';
  }

  @override
  String get lsMailGroupsNewGroupTitle => 'Yeni posta grubu';

  @override
  String get lsMailGroupsGroupNameLabel => 'Grup adı';

  @override
  String get lsMailGroupsCreateConfirm => 'Oluştur';

  @override
  String get lsMailGroupsEmptyHint =>
      'Henüz grup yok. Zamanlayıcı tetiklendiğinde posta göndermek için bir grup oluştur.';

  @override
  String get lsMailGroupsWorkingButton => 'İşleniyor…';

  @override
  String get lsMailGroupsCreateNewButton => '+ Yeni grup oluştur';

  @override
  String lsMailGroupsHeaderCount(int count, int max) {
    return '$count/$max grup yapılandırıldı';
  }

  @override
  String lsMailGroupsHeaderTotalRecipients(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alıcı',
      one: '1 alıcı',
    );
    return '· toplam $_temp0';
  }

  @override
  String get lsMailGroupsUnnamed => '(isimsiz)';

  @override
  String lsMailGroupsRowSummary(int count, String state) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alıcı',
      one: '1 alıcı',
    );
    return '$_temp0 · $state';
  }

  @override
  String get lsMailGroupsEnabled => 'etkin';

  @override
  String get lsMailGroupsDisabled => 'devre dışı';

  @override
  String get lsMailGroupsNameLabel => 'İsim';

  @override
  String get lsMailGroupsSubjectLabel => 'Konu';

  @override
  String get lsMailGroupsSaveBodyButton => 'İçeriği kaydet';

  @override
  String get lsMailGroupsDeleteGroupButton => 'Grubu sil';

  @override
  String lsMailGroupsRecipientsHeader(int count) {
    return 'Alıcılar ($count)';
  }

  @override
  String get lsMailGroupsNoRecipients => 'Henüz alıcı yok.';

  @override
  String get lsMailGroupsAddRecipientButton => 'Ekle';

  @override
  String get lsHomeStatusLoading => 'Yükleniyor…';

  @override
  String get lsHomeLogsTooltip => 'Loglar';

  @override
  String get lsHomeClusterConfiguration => 'YAPILANDIRMA';

  @override
  String get lsHomeClusterTriggerActions => 'TETİK AKSİYONLARI';

  @override
  String get lsHomeClusterEarlyWarning => 'ERKEN UYARI';

  @override
  String get lsHomeSectionDurationTitle => 'Süre ve Alarmlar';

  @override
  String get lsHomeSectionVacationTitle => 'Tatil Modu';

  @override
  String get lsHomeSectionSmtpTitle => 'Posta Kurulumu (SMTP)';

  @override
  String get lsHomeSectionResetApiTitle => 'Reset API endpoint';

  @override
  String get lsHomeSectionMailGroupsTitle => 'Posta Grupları';

  @override
  String get lsHomeSectionRelayTitle => 'Röle';

  @override
  String get lsHomeSectionLsApiTitle => 'LS API webhook';

  @override
  String get lsHomeSectionTelegramTitle => 'Telegram';

  @override
  String get lsHomeSectionReminderMailTitle => 'Hatırlatma Postası';

  @override
  String get lsHomeSectionAlarmApiTitle => 'Alarm API webhook';

  @override
  String get lsHomeStateInactive => 'DURMUŞ';

  @override
  String get lsHomeStateRemaining => 'KALAN';

  @override
  String get lsHomeStateVacation => 'TATİL';

  @override
  String get lsHomeStateTriggered => 'TETİKLENDİ';

  @override
  String get lsHomeChipBle => 'BLE';

  @override
  String get lsHomeChipMail => 'Posta';

  @override
  String get lsHomeEarlyWarningPendingNote =>
      'Erken uyarı aksiyonları timer.alarm üzerinde tetiklenir. Firmware subscriber bekliyor; yapılandırmalar saklanır ama henüz otomatik tetiklenmez.';

  @override
  String get settingsDiagnosticsTitle => 'Tanılama';

  @override
  String get settingsDiagnosticsSubtitle =>
      'Sorunları ayıklamaya yardımcı loglar';

  @override
  String get diagnosticsCopyLogs => 'Logları kopyala';

  @override
  String get diagnosticsOpenFolder => 'Klasörü aç';

  @override
  String get diagnosticsOpenFolderFailed => 'Log klasörü açılamadı.';

  @override
  String get diagnosticsShareLogs => 'Logları paylaş';

  @override
  String get diagnosticsClearLogs => 'Logları temizle';

  @override
  String get diagnosticsCopied => 'Loglar panoya kopyalandı';

  @override
  String get diagnosticsCleared => 'Loglar temizlendi';

  @override
  String get aboutPrivacyLabel => 'Gizlilik politikası';

  @override
  String get updateChecking => 'Güncellemeler denetleniyor…';

  @override
  String get updateUpToDate => 'En güncel sürümdesin';

  @override
  String get updateCheckFailed => 'Güncellemeler denetlenemedi';

  @override
  String get updateAvailableTitle => 'Güncelleme mevcut';

  @override
  String updateAvailableBody(String version, String current) {
    return 'Yeni bir sürüm ($version) mevcut. Sen $current kullanıyorsun.';
  }

  @override
  String get updateDownloadAction => 'İndir';

  @override
  String get updateLater => 'Sonra';
}
