// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get appTitle => 'SKAPP';

  @override
  String get brandTagline => 'SmartKraft';

  @override
  String get tabHome => 'Αρχική';

  @override
  String get tabDevices => 'Συσκευές';

  @override
  String get tabSkapi => 'SKAPI';

  @override
  String get tabSettings => 'Ρυθμίσεις';

  @override
  String get tabSmartKraft => 'SmartKraft';

  @override
  String get comingSoonBadge => 'σύντομα';

  @override
  String get featureComingSoonSnack => 'Αυτή η λειτουργία έρχεται σύντομα';

  @override
  String get homeWelcome => 'Καλώς ήρθατε στο SmartKraft';

  @override
  String get homeSubtitle => 'Διαχειριστείτε τις συσκευές SmartKraft σας';

  @override
  String get homeAddDevice => 'Προσθήκη νέας συσκευής';

  @override
  String get homeNoDevicesTitle => 'Δεν υπάρχουν συσκευές ακόμη';

  @override
  String get homeNoDevicesHint =>
      'Προσθέστε την πρώτη σας συσκευή SmartKraft για να ξεκινήσετε.';

  @override
  String get homeSummaryTitle => 'Επισκόπηση';

  @override
  String homeDevicesOnline(int count) {
    return '$count συνδεδεμένες';
  }

  @override
  String homeDevicesOffline(int count) {
    return '$count εκτός σύνδεσης';
  }

  @override
  String get homeUpdatesTitle => 'Διαθέσιμες ενημερώσεις';

  @override
  String homeUpdatesBody(int count) {
    return '$count συσκευή έχει νεότερο firmware.';
  }

  @override
  String get homeWarningsTitle => 'Προειδοποιήσεις';

  @override
  String homeWarningsBody(int count) {
    return '$count συσκευή ανέφερε πρόβλημα.';
  }

  @override
  String get homeAllGood => 'Όλα λειτουργούν ομαλά.';

  @override
  String get devicesTitle => 'Συσκευές';

  @override
  String get devicesEmpty =>
      'Δεν έχουν προστεθεί συσκευές ακόμη.\nΠατήστε το κουμπί + για να προσθέσετε μία.';

  @override
  String get devicesAdd => 'Προσθήκη συσκευής';

  @override
  String get devicesAllSection => 'Όλες οι συσκευές';

  @override
  String get devicesGroupsTitle => 'Οι ομάδες σας';

  @override
  String get devicesGroupsHint =>
      'Δημιουργήστε ομάδες για να οργανώσετε τις συσκευές σας όπως θέλετε.';

  @override
  String get devicesGroupsCreate => 'Νέα ομάδα';

  @override
  String get devicesGroupsEmpty => 'Δεν υπάρχουν ομάδες ακόμη.';

  @override
  String get skapiTitle => 'SKAPI';

  @override
  String get skapiLibraryHeading => 'Βιβλιοθήκη SKAPI';

  @override
  String get skapiLibrarySubtitle =>
      'Επιλέξτε την πλατφόρμα που θα ενεργοποιούν οι συσκευές σας.';

  @override
  String get skapiThisComputer => 'Αυτός ο υπολογιστής';

  @override
  String skapiCategoryCount(int count) {
    return '$count κατηγορίες';
  }

  @override
  String get skapiPlatformMac => 'macOS';

  @override
  String get skapiPlatformWin => 'Windows';

  @override
  String get skapiPlatformLinux => 'Linux';

  @override
  String get skapiPlatformOther => 'Άλλο';

  @override
  String get skapiStarredHeading => 'Αγαπημένα API';

  @override
  String get skapiStarredEmpty =>
      'Προσθέστε πρότυπα στα αγαπημένα από τη βιβλιοθήκη και θα εμφανιστούν εδώ.';

  @override
  String get skapiContributeTitle =>
      'Στείλτε τη βιβλιοθήκη σας στην κοινότητα SmartKraft';

  @override
  String get skapiContributeBody => 'Αυτή η κάρτα θα σχεδιαστεί αργότερα.';

  @override
  String get skapiSearchPlaceholder => 'Αναζήτηση ενεργειών…';

  @override
  String get skapiSearchDisabledHint =>
      'Θα ενεργοποιηθεί μόλις συνδεθεί ο αναλυτής SKAPI.';

  @override
  String get skapiHelpButtonTooltip => 'Σχετικά με το SKAPI';

  @override
  String get skapiHelpSheetTitle => 'Σχετικά με το SKAPI';

  @override
  String get skapiHelpIntro =>
      'Το SKAPI είναι μια βιβλιοθήκη ενεργειών που οι συσκευές SmartKraft σας μπορούν να ενεργοποιήσουν στον υπολογιστή σας.';

  @override
  String get skapiHelpStep1Title => 'Περιηγηθείτε σε ένα πρότυπο';

  @override
  String get skapiHelpStep1Body =>
      'Επιλέξτε ένα σημείο εκκίνησης από τη βιβλιοθήκη SKAPI.';

  @override
  String get skapiHelpStep2Title => 'Διαμόρφωση';

  @override
  String get skapiHelpStep2Body =>
      'Ορίστε παραμέτρους και επιλέξτε ποια συσκευή θα το ενεργοποιεί.';

  @override
  String get skapiHelpStep3Title => 'Αποστολή στη συσκευή';

  @override
  String get skapiHelpStep3Body =>
      'Η συσκευή αποθηκεύει το trigger του API· το SKAPP εκτελεί το script.';

  @override
  String get skapiHelpGlossaryTitle => 'Γλωσσάρι';

  @override
  String get skapiHelpGlossaryTemplate =>
      'Πρότυπο: μια καταχώριση βιβλιοθήκης μόνο για ανάγνωση';

  @override
  String get skapiHelpGlossaryAction =>
      'Ενέργεια: ένα διαμορφωμένο ζεύγος trigger API + script';

  @override
  String get skapiHelpGlossaryApiTrigger =>
      'Trigger API: αυτό που καλεί η συσκευή';

  @override
  String get skapiHelpGlossaryScript =>
      'Script: αυτό που εκτελεί ο υπολογιστής σας';

  @override
  String get skapiHelpPhase1Notice =>
      'Το SKAPI είναι ακόμη υπό κατασκευή. Το μεγαλύτερο μέρος αυτής της καρτέλας είναι ένας σκελετός· οι ενότητες που φέρουν την ένδειξη «δεν είναι ενεργό ακόμη» θα ενεργοποιηθούν μόλις προστεθούν ο αναλυτής, ο listener και ο κατασκευαστής φορμών.';

  @override
  String get skapiMobileBannerBody =>
      'Αυτό το τηλέφωνο δεν μπορεί να είναι στόχος. Για να εκτελέσετε ενέργειες, το SKAPP πρέπει να είναι ανοιχτό στον υπολογιστή σας.';

  @override
  String get skapiActionsHeading => 'Οι ενέργειές μου';

  @override
  String get skapiActionsNoDevicesTitle => 'Δεν υπάρχουν συσκευές ακόμη';

  @override
  String get skapiActionsNoDevicesBody =>
      'Συζεύξτε πρώτα μια συσκευή SmartKraft· μεταβείτε στην καρτέλα Συσκευές.';

  @override
  String get skapiActionsCreationDisabled =>
      'Η δημιουργία ενεργειών δεν είναι ενεργή ακόμη.';

  @override
  String get skapiActionsOfflineDetectionDisabled =>
      'Ο εντοπισμός σύνδεσης δεν είναι ενεργός ακόμη';

  @override
  String get skapiActionsMaxLimitNote => 'Έως 5 ενέργειες ανά συσκευή.';

  @override
  String get skapiActionsAddCta => 'Προσθήκη ενέργειας';

  @override
  String skapiHeaderSub(int platforms, int actions) {
    return '$platforms πλατφόρμες · $actions ενέργειες';
  }

  @override
  String get skapiNewActionPill => 'Νέα ενέργεια';

  @override
  String skapiActionsSubLine(int count) {
    return 'συνδέσεις συσκευή × script · $count ενεργές';
  }

  @override
  String get skapiActionsEmptyHint =>
      'Δεν υπάρχουν ενέργειες ακόμη. Ορίστε τι συμβαίνει όταν πατηθεί ένα κουμπί της συσκευής.';

  @override
  String get skapiActionsCreateCta => 'Δημιουργία';

  @override
  String skapiActionsGroupTitle(String name) {
    return 'Ενέργειες $name';
  }

  @override
  String skapiActionsGroupCount(int count) {
    return '$count';
  }

  @override
  String get skapiListenerEndpointTitle =>
      'URL webhook που στάλθηκε στις συσκευές BF';

  @override
  String get skapiListenerEndpointBody =>
      'Αν ένα BF στο ίδιο Wi-Fi δεν μπορεί να φτάσει αυτό το URL μετά την αντίστροφη μέτρηση, η επιλογή NIC του φορητού σας μπορεί να είναι λανθασμένη (π.χ. δίκτυο WSL/VirtualBox/Docker). Πατήστε Ανανέωση για να σταλεί ξανά.';

  @override
  String get skapiListenerEndpointResolving => 'Επίλυση τοπικού IP…';

  @override
  String get skapiListenerEndpointUnavailable =>
      'Δεν βρέθηκε χρησιμοποιήσιμη διεπαφή LAN.';

  @override
  String get skapiListenerEndpointRefresh => 'Ανανέωση';

  @override
  String get skapiListenerEndpointRefreshing => 'Αποστολή…';

  @override
  String skapiListenerEndpointPushedAt(String when) {
    return 'Τελευταία ανανέωση $when';
  }

  @override
  String get skapiListenerSelfTest => 'Αυτοέλεγχος';

  @override
  String get skapiListenerSelfTestRunning => 'Έλεγχος…';

  @override
  String get skapiListenerSelfTestPassed =>
      'Αυτοέλεγχος OK: ο listener είναι προσβάσιμος από αυτόν τον υπολογιστή.';

  @override
  String get skapiListenerSelfTestFailed =>
      'Αυτοέλεγχος ΑΠΕΤΥΧΕ: ο listener δεν είναι προσβάσιμος. Ελέγξτε το Τείχος προστασίας των Windows.';

  @override
  String get skapiWebhookActivityTitle => 'Πρόσφατα webhook';

  @override
  String get skapiWebhookActivityNone =>
      'Δεν έχουν ληφθεί webhook ακόμη. Αφού λήξει το χρονόμετρο της συσκευής, μια καταχώριση θα εμφανιστεί εδώ μέσα σε δευτερόλεπτα.';

  @override
  String get skapiWebhookActivityAccepted => 'Αποδεκτό';

  @override
  String skapiWebhookActivityRejected(int code) {
    return 'Απορρίφθηκε ($code)';
  }

  @override
  String get skapiWebhookActivityMalformed => 'Κακοσχηματισμένο';

  @override
  String get skapiWebhookActivitySelfTest => 'Αυτοέλεγχος';

  @override
  String get skapiWebhookActivityNoMatch => 'Καμία αντιστοίχιση';

  @override
  String get skapiWebhookActivityScriptError => 'Σφάλμα script';

  @override
  String skapiWebhookActivityMatched(int count) {
    return 'Εκτελέστηκαν $count script';
  }

  @override
  String get skapiBfEndpointsButton => 'Επιθεώρηση endpoints BF';

  @override
  String get skapiBfEndpointsTitle => 'Endpoints αποθηκευμένα σε συσκευές BF';

  @override
  String get skapiBfEndpointsHint =>
      'Στιγμιότυπο μόνο για ανάγνωση του api.endpoint.list από κάθε συζευγμένη συσκευή. Συγκρίνετε κάθε URL υποδοχής SYSTEM με το URL του listener παραπάνω. Πρέπει να ταιριάζουν ακριβώς. Οι υποδοχές USER μπορεί να ανήκουν σε χειροκίνητα webhook και θα μπορούσαν να παρεμβάλλονται στην αντίστροφη μέτρησή σας αν είναι λανθασμένα διαμορφωμένες.';

  @override
  String get skapiBfEndpointsLoading => 'Ερώτημα σε συσκευές BF…';

  @override
  String get skapiBfEndpointsErrorPrefix => 'Το ερώτημα απέτυχε:';

  @override
  String get skapiBfEndpointsKindSystem => 'SYSTEM';

  @override
  String get skapiBfEndpointsKindUser => 'USER';

  @override
  String get skapiBfEndpointsEmpty =>
      'Δεν υπάρχουν αποθηκευμένα endpoints σε αυτή τη συσκευή.';

  @override
  String get skapiBfEndpointsClose => 'Κλείσιμο';

  @override
  String get skapiBfEndpointsRefresh => 'Επανάληψη ερωτήματος';

  @override
  String skapiStarredCount(int count) {
    return '$count αγαπημένα';
  }

  @override
  String get skapiStarredSlimEmpty =>
      'Προσθέστε καταχωρίσεις της βιβλιοθήκης στα αγαπημένα για να συγκεντρώσετε εδώ τις πιο χρησιμοποιούμενες.';

  @override
  String get skapiCommunityShareTitle =>
      'Μοιραστείτε τη βιβλιοθήκη σας με την κοινότητα SmartKraft';

  @override
  String get skapiCommunityShareBody =>
      'Τα scripts που γράφετε γίνονται διαθέσιμα σε όλους στη βιβλιοθήκη SKAPI.';

  @override
  String get settingsNetworkIdentityTitle => 'Ταυτότητα δικτύου';

  @override
  String get settingsNetworkIdentityName => 'Όνομα υπολογιστή';

  @override
  String get settingsNetworkIdentityNameHint =>
      'Χρησιμοποιείται ως όνομα στιγμιότυπου mDNS';

  @override
  String get settingsNetworkIdentityNameEdit => 'Μετονομασία';

  @override
  String get settingsNetworkIdentityNameDialogTitle =>
      'Μετονομασία αυτού του υπολογιστή';

  @override
  String get settingsNetworkIdentityNameDialogHelp =>
      'Πεζά γράμματα, αριθμοί και παύλες. Έως 32 χαρακτήρες.';

  @override
  String get settingsNetworkIdentityUuid => 'ID συσκευής';

  @override
  String get settingsNetworkIdentityPort => 'Θύρα listener';

  @override
  String get settingsNetworkIdentityPortDialogTitle => 'Θύρα listener';

  @override
  String get settingsNetworkIdentityToken => 'Bearer token';

  @override
  String get settingsNetworkIdentityRegenerateToken => 'Αναδημιουργία token';

  @override
  String get settingsNetworkIdentityRegenerateConfirmTitle =>
      'Αναδημιουργία bearer token;';

  @override
  String get settingsNetworkIdentityRegenerateConfirmBody =>
      'Οι υπάρχουσες συσκευές θα πρέπει να συζευχθούν ξανά με το νέο token.';

  @override
  String get settingsNetworkIdentityServerNotRunning =>
      'Ο διακομιστής δεν εκτελείται ακόμη, θα ενεργοποιηθεί στη Φάση 2.';

  @override
  String get settingsNetworkIdentityCopy => 'Αντιγραφή';

  @override
  String get settingsNetworkIdentityCopied => 'Αντιγράφηκε';

  @override
  String get settingsNetworkIdentityStaticIpHint =>
      'Συμβουλή: μια δέσμευση DHCP (στατικό IP) στον δρομολογητή σας κάνει τις συνδέσεις πιο αξιόπιστες.';

  @override
  String get settingsTitle => 'Ρυθμίσεις';

  @override
  String get settingsSectionAppearance => 'Εμφάνιση';

  @override
  String get settingsLanguage => 'Γλώσσα';

  @override
  String get settingsLanguageSystemHint => 'Ακολουθεί τη γλώσσα του συστήματος';

  @override
  String get settingsLanguagePickerAllSection => 'Όλες οι γλώσσες';

  @override
  String get settingsTheme => 'Θέμα';

  @override
  String get settingsThemeLight => 'Φωτεινό';

  @override
  String get settingsThemeDark => 'Σκούρο';

  @override
  String get settingsThemeSystem => 'Σύστημα';

  @override
  String get settingsSectionAbout => 'Σχετικά';

  @override
  String get settingsVersion => 'Έκδοση';

  @override
  String get settingsDeveloper => 'Προγραμματιστής';

  @override
  String get settingsDeveloperName => 'SmartKraft';

  @override
  String get settingsOpenAbout => 'Σχετικά με το SKAPP';

  @override
  String get settingsSectionAdvanced => 'Για προχωρημένους';

  @override
  String get settingsDeveloperMode => 'Λειτουργία προγραμματιστή';

  @override
  String get settingsDeveloperToolsTitle => 'Εργαλεία προγραμματιστή';

  @override
  String get settingsDeveloperToolsSubtitle =>
      'Κονσόλα USB, ταυτότητα δικτύου, listener, tokens, αρχεία καταγραφής';

  @override
  String get settingsDeveloperModeInfoTitle =>
      'Τι ξεκλειδώνει η Λειτουργία προγραμματιστή;';

  @override
  String get settingsDeveloperModeInfoIntro =>
      'Αυτή η λειτουργία αποκαλύπτει επιφάνειες για προχωρημένους χρήστες που είναι κρυμμένες από το προεπιλεγμένο περιβάλλον. Τρεις βασικές περιπτώσεις χρήσης:';

  @override
  String get settingsDeveloperModeUseCaseCliTitle => 'Κονσόλα CLI';

  @override
  String get settingsDeveloperModeUseCaseCliBody =>
      'Διαμορφώστε τις συσκευές σας μέσω καλωδίου USB χωρίς να δημιουργήσετε πρώτα σύνδεση BLE ή WiFi.';

  @override
  String get settingsDeveloperModeUseCaseSkapiTitle =>
      'Επεξεργαστής κώδικα SKAPI';

  @override
  String get settingsDeveloperModeUseCaseSkapiBody =>
      'Ανοίξτε και τροποποιήστε ενσωματωμένα scripts, ή γράψτε τα δικά σας από την αρχή.';

  @override
  String get settingsDeveloperModeUseCaseMobileTitle =>
      'Απομακρυσμένη ενεργοποίηση από κινητό';

  @override
  String get settingsDeveloperModeUseCaseMobileBody =>
      'Εκτελέστε τις συνδέσεις SKAPI αυτού του υπολογιστή από ένα συζευγμένο SKAPP για κινητά.';

  @override
  String get settingsDeveloperModeInfoSurfacesHeader =>
      'Επιπλέον κάρτες Ρυθμίσεων που εμφανίζονται όταν είναι ενεργή:';

  @override
  String get settingsDeveloperModeInfoItem1 =>
      'Κάρτα ταυτότητας δικτύου: επεξεργασία UUID, θύρας, bearer token· αντιγραφή / αναδημιουργία του μυστικού εγκατάστασης SKAPP.';

  @override
  String get settingsDeveloperModeInfoItem2 =>
      'Στοιχεία ελέγχου τοπικού listener HTTP: εκκίνηση/διακοπή, σύζευξη QR, εναλλαγή πιστοποιητικού TLS, ορατότητα LAN.';

  @override
  String get settingsDeveloperModeInfoItem3 =>
      'Λίστα token ανά peer: δείτε κάθε συζευγμένο SKAPP για κινητά και ανακαλέστε το μεμονωμένα.';

  @override
  String get settingsDeveloperModeInfoItem4 =>
      'Κονσόλα USB CLI (μόνο επιτραπέζιο): απευθείας γραμμή εντολών NDJSON σε μια συσκευή SmartKraft συνδεδεμένη μέσω USB.';

  @override
  String get settingsDeveloperModeInfoNotPaid =>
      'Δεν είναι επί πληρωμή αναβάθμιση. Το SKAPP είναι μονής βαθμίδας και δωρεάν· αυτός ο διακόπτης απλώς κρύβει εξ ορισμού επιφάνειες για προχωρημένους χρήστες για να μένουν τα πράγματα απλά. Οι συσκευές SmartKraft λειτουργούν ανεξάρτητα από αυτή τη ρύθμιση.';

  @override
  String get settingsSectionConnectivity => 'Συνδεσιμότητα';

  @override
  String get settingsBluetoothStatus => 'Bluetooth';

  @override
  String get settingsBluetoothStatusOn => 'Έτοιμο';

  @override
  String get settingsBluetoothStatusOff => 'Απενεργοποιημένο';

  @override
  String get settingsBluetoothStatusTurningOn => 'Ενεργοποίηση…';

  @override
  String get settingsBluetoothStatusTurningOff => 'Απενεργοποίηση…';

  @override
  String get settingsBluetoothStatusUnauthorized => 'Χωρίς άδεια';

  @override
  String get settingsBluetoothStatusUnsupported => 'Δεν υποστηρίζεται';

  @override
  String get settingsBluetoothStatusUnknown => 'Έλεγχος…';

  @override
  String get settingsNetworkStatus => 'Δίκτυο';

  @override
  String get settingsWifiStatusConnected => 'Wi-Fi';

  @override
  String get settingsWifiStatusEthernet => 'Ethernet';

  @override
  String get settingsWifiStatusMobile => 'Δεδομένα κινητής';

  @override
  String get settingsWifiStatusDisconnected => 'Αποσυνδεδεμένο';

  @override
  String get settingsWifiStatusUnknown => 'Έλεγχος…';

  @override
  String get settingsWifiHint => 'Χρησιμοποιείται μετά την αρχική σύζευξη.';

  @override
  String get settingsBluetoothPermissions => 'Άδειες';

  @override
  String get settingsBluetoothPermissionsHint =>
      'Πρόσβαση σε Bluetooth και τοποθεσία';

  @override
  String get settingsBluetoothGrantPermission => 'Παραχώρηση πρόσβασης';

  @override
  String get settingsOpenSystemSettings => 'Άνοιγμα ρυθμίσεων συστήματος';

  @override
  String get settingsSectionUpdates => 'Ενημερώσεις';

  @override
  String get settingsCheckUpdates => 'Έλεγχος για ενημερώσεις';

  @override
  String get settingsAutoCheckUpdates => 'Έλεγχος κατά την εκκίνηση';

  @override
  String get settingsAutoCheckUpdatesHint =>
      'Επιβεβαιώστε ότι έχετε την πιο πρόσφατη έκδοση κάθε φορά που ανοίγει το SKAPP.';

  @override
  String get settingsUpdateChannel => 'Κανάλι ενημερώσεων';

  @override
  String get settingsUpdateChannelStable => 'Σταθερό';

  @override
  String get settingsUpdateChannelBeta => 'Beta';

  @override
  String get settingsUpdateChannelBetaHint =>
      'Αποκτήστε νέες λειτουργίες νωρίτερα. Μπορεί να είναι λιγότερο σταθερό.';

  @override
  String get settingsUpToDate => 'Έχετε την πιο πρόσφατη έκδοση.';

  @override
  String get settingsUpdateCheckPlaceholder =>
      'Ο έλεγχος ενημερώσεων θα συνδεθεί στη Φάση 3.';

  @override
  String get settingsSectionLegal => 'Νομικά';

  @override
  String get settingsLicense => 'Άδεια & Ευχαριστίες';

  @override
  String get settingsSectionInfo => 'Πληροφορίες';

  @override
  String get settingsThemeCycleHint => 'Πατήστε για εναλλαγή';

  @override
  String get settingsChannelCycleHint => 'Πατήστε για εναλλαγή';

  @override
  String get settingsSectionThisNode => 'Αυτός ο κόμβος';

  @override
  String get settingsNodeNameTitle => 'Όνομα κόμβου SKAPP';

  @override
  String settingsNodeNameSub(String name) {
    return '$name · άλλα SKAPP βλέπουν αυτό το όνομα · εκπομπή mDNS';
  }

  @override
  String get settingsSectionDanger => 'Ζώνη κινδύνου';

  @override
  String get settingsResetPairings => 'Επαναφορά συζεύξεων';

  @override
  String get settingsResetPairingsSub =>
      'Αφαίρεση όλων των συζευγμένων συσκευών· ρυθμίσεις/γλώσσα/όνομα κόμβου διατηρούνται';

  @override
  String get settingsFactoryReset => 'Επαναφορά εργοστασιακών';

  @override
  String get settingsFactoryResetSub => 'Όλα διαγράφονται, μη αναστρέψιμο';

  @override
  String get settingsSectionAdvancedNetwork => 'Δίκτυο για προχωρημένους';

  @override
  String get settingsResetPairingsConfirmTitle =>
      'Επαναφορά όλων των συζεύξεων;';

  @override
  String settingsResetPairingsConfirmBody(int paired, int bindings, int peers) {
    return '$paired συζευγμένες συσκευές, $bindings ενέργειες SKAPI και $peers peers SKAPP θα αφαιρεθούν. Οι ρυθμίσεις, το θέμα, η γλώσσα και οι σημειώσεις σας διατηρούνται. Οι συσκευές διατηρούν ακόμη τη σύνδεσή τους στη δική τους πλευρά· για πλήρη αποσύζευξη, επαναφέρετε τη συσκευή χειροκίνητα. Αυτό δεν αναιρείται.';
  }

  @override
  String get settingsResetPairingsConfirmAction => 'Επαναφορά';

  @override
  String get settingsFactoryResetConfirmTitle => 'Επαναφορά εργοστασιακών;';

  @override
  String get settingsFactoryResetConfirmBody =>
      'Όλα θα διαγραφούν: όλες οι συζεύξεις, ρυθμίσεις, θέμα, γλώσσα, σημειώσεις, ταυτότητα δικτύου, πιστοποιητικό TLS και η καταχώριση αυτόματης εκκίνησης. Το SKAPP επιστρέφει στην κατάσταση πρώτης εκκίνησης. Αυτό δεν αναιρείται.';

  @override
  String get settingsFactoryResetConfirmAction => 'Διαγραφή όλων';

  @override
  String get settingsFactoryResetSecondConfirmTitle =>
      'Είστε απολύτως βέβαιοι;';

  @override
  String get settingsFactoryResetSecondConfirmBody =>
      'Πληκτρολογήστε ERASE για επιβεβαίωση.';

  @override
  String get settingsFactoryResetSecondConfirmHint => 'ERASE';

  @override
  String get settingsFactoryResetSecondConfirmAction => 'Κατανοώ. Διαγραφή.';

  @override
  String get settingsResetInProgress => 'Επαναφορά…';

  @override
  String get settingsResetDoneTitle => 'Η επαναφορά ολοκληρώθηκε';

  @override
  String get settingsResetDoneWithWarnings =>
      'Η επαναφορά ολοκληρώθηκε (με προειδοποιήσεις)';

  @override
  String settingsResetSummaryPaired(int count) {
    return 'Αφαιρέθηκαν $count συζευγμένες συσκευές';
  }

  @override
  String settingsResetSummaryBindings(int count) {
    return 'Αφαιρέθηκαν $count ενέργειες SKAPI';
  }

  @override
  String settingsResetSummaryPeers(int count) {
    return 'Αφαιρέθηκαν $count peers SKAPP';
  }

  @override
  String settingsResetSummaryBonds(int count) {
    return 'Εκκαθαρίστηκαν $count συνδέσεις συσκευών';
  }

  @override
  String get settingsResetSummaryNetworkIdentity =>
      'Η ταυτότητα δικτύου επαναφέρθηκε στις προεπιλογές';

  @override
  String get settingsResetSummaryTlsCert =>
      'Το πιστοποιητικό TLS εκκαθαρίστηκε';

  @override
  String get settingsResetSummaryAutostart =>
      'Η καταχώριση αυτόματης εκκίνησης αφαιρέθηκε';

  @override
  String get settingsResetSummaryWarningHeader => 'Προειδοποιήσεις:';

  @override
  String get settingsResetRestartHint =>
      'Επανεκκινήστε το SKAPP για να εφαρμοστούν πλήρως οι αλλαγές.';

  @override
  String get settingsResetRestartNow => 'Επανεκκίνηση τώρα';

  @override
  String get settingsResetClose => 'Κλείσιμο';

  @override
  String settingsFooterCombined(String version, String node) {
    return 'SKAPP $version · $node';
  }

  @override
  String get langEnglish => 'English';

  @override
  String get langTurkish => 'Türkçe';

  @override
  String get aboutTitle => 'Σχετικά με το SmartKraft και το SKAPP';

  @override
  String get aboutDevicesHeading => 'Οι συσκευές μας';

  @override
  String get aboutDevicesBody =>
      'Οι συσκευές SmartKraft σχεδιάζονται για να είναι καινοτόμες, ξεχωριστές και να φέρουν λεπτομέρειες που άλλοι δεν έχουν σκεφτεί. Στόχος μας δεν είναι να αναπαράγουμε ό,τι υπάρχει ήδη· είναι να φτιάξουμε αυτό που δεν έχει φτιαχτεί, αυτό που έμεινε ανολοκλήρωτο. Να δείξουμε ένα άλυτο καθημερινό πρόβλημα και να του προσφέρουμε μια απλή, κατανοητή απάντηση· ή να πάρουμε κάτι που έχει λυθεί αλλά παρέμεινε ακριβό και να βάλουμε στη θέση του μια έκδοση DIY που μπορεί να φτιάξει ο καθένας.\n\nΚάθε συσκευή SmartKraft σχεδιάζεται και κατασκευάζεται για να δίνει μια μικρή, λιτή απάντηση σε ένα πρόβλημα που δεν έχει λυθεί ακόμη. Σχεδιάζοντας μια συσκευή, ρωτάμε τον εαυτό μας ένα μόνο ερώτημα: «Γιατί δεν έχει λυθεί αυτό το πρόβλημα μέχρι τώρα, ή γιατί έχει παραμείνει τόσο ακριβό;»';

  @override
  String get aboutSkappRoleHeading => 'Πού ταιριάζει το SKAPP';

  @override
  String get aboutSkappRoleBody =>
      'Το SKAPP είναι η κοινή εφαρμογή για τις συσκευές SmartKraft. Είναι ένα απλό περιβάλλον χρήστη για τη σύζευξη μιας συσκευής, τη διαμόρφωσή της, την αλλαγή της συμπεριφοράς της και τη συνένωση πολλών συσκευών σε ένα ενιαίο σενάριο.\n\nΤο SKAPP δεν είναι απαραίτητο για τις συσκευές σας· είναι μια ευκολία. Κάθε συσκευή SmartKraft μπορεί να διαμορφωθεί με τον ίδιο τρόπο μέσω USB CLI χωρίς το SKAPP, και αυτή η διαδρομή παραμένει ανοιχτή για όσους προτιμούν τη γραμμή εντολών. Για όλους τους άλλους που θέλουν την ταχύτητα ενός οπτικού περιβάλλοντος και την άνεση της διαχείρισης πολλών συσκευών ταυτόχρονα, το SKAPP είναι εδώ.\n\nΧωρίς λογαριασμό cloud. Χωρίς διαφημίσεις. Χωρίς συλλογή δεδομένων. Είναι μια ήσυχη γέφυρα ανάμεσα στο τηλέφωνό σας και τη συσκευή σας, τίποτα περισσότερο.';

  @override
  String get aboutShowcaseHeading => 'Βιτρίνα Maker';

  @override
  String get aboutShowcaseEmpty =>
      'Η βιτρίνα είναι κενή προς το παρόν. Η πρώτη συσκευή SmartKraft είναι καθ\' οδόν· τα αρχεία σχεδίασης, οι πηγές firmware, οι λίστες εξαρτημάτων και οι οδηγοί συναρμολόγησης θα παρατίθενται εδώ όταν είναι έτοιμα. Μέχρι τότε αυτή η ενότητα δεν υπόσχεται πολλά, απλώς κρατά χώρο για ό,τι έρχεται.';

  @override
  String get aboutConnectHeading => 'Επικοινωνία';

  @override
  String get aboutConnectIntro =>
      'Στείλτε ένα μήνυμα, δείτε τον πηγαίο κώδικα, παρακολουθήστε τη δουλειά καθώς εξελίσσεται.';

  @override
  String get aboutConnectGitHub => 'GitHub';

  @override
  String get aboutConnectWebsite => 'Ιστότοπος';

  @override
  String get aboutConnectYouTube => 'YouTube';

  @override
  String get aboutConnectX => 'X';

  @override
  String get aboutConnectEmail => 'Email';

  @override
  String get aboutVersionHeading => 'Έκδοση';

  @override
  String get licenseTitle => 'Άδεια & Ευχαριστίες';

  @override
  String get licenseSmartKraftHeading => 'Σχετικά με το SmartKraft';

  @override
  String get licenseSmartKraftBody =>
      'Το SmartKraft είναι ένα μικρό εργαστήριο που σχεδιάζει ασυνήθιστα αλλά πρακτικά ηλεκτρονικά εργαλεία για την καθημερινή ζωή. Πίσω από κάθε συσκευή που φτάνει στα χέρια σας κρύβονται αμέτρητα βήματα: ένα πρώιμο σκίτσο σε ένα τετράδιο, ένα πρώτο κολλημένο πρωτότυπο, γραμμές κώδικα γραμμένες αργά τη νύχτα, μικρές λεπτομέρειες που δοκιμάστηκαν ξανά και ξανά. Η κατασκευή μιας συσκευής σημαίνει να γράφεις γραμμές, να σχεδιάζεις κυκλώματα, να κολλάς ενώσεις, να βρίσκεις σφάλματα, να ξεκινάς από την αρχή. Σε όλους όσοι έβαλαν την προσπάθειά τους σε αυτή τη διαδικασία χωρίς να αφήσουν το όνομά τους πάνω της, ευχαριστούμε, εκ μέρους του SmartKraft.\n\nΠιστεύουμε στην κουλτούρα των makers, στο ανοιχτό λογισμικό και στα επισκευάσιμα, ανακυκλώσιμα ηλεκτρονικά. Γι\' αυτό δημοσιεύουμε τα σχέδια υλικού των συσκευών μας ως open hardware και το firmware τους υπό την άδεια AGPL 3.0. Στόχος μας είναι να κάνουμε προσβάσιμη μια έκδοση DIY όσο το δυνατόν περισσότερων εξαρτημάτων.\n\nΜια σημείωση για την οποία θέλουμε να είμαστε ειλικρινείς: τα κλειδιά σύζευξης και τα μυστικά επικοινωνίας που προστατεύουν την ασφάλεια μιας συσκευής διατηρούνται ιδιωτικά στον κώδικα. Αν δημοσιεύονταν, η εμπιστοσύνη μεταξύ της συσκευής σας και της εφαρμογής θα κατέρρεε. Αυτό το κλείσιμο δεν είναι μια υποχώρηση απέναντι στην ανοιχτότητα· είναι μια απόφαση που λάβαμε για την ασφάλειά σας.\n\nΓια το SKAPP και κάθε συσκευή που επικοινωνεί μαζί του, η αρχή μας είναι η διαφάνεια: θέλουμε να μπορείτε να διαβάζετε πώς λειτουργούν τα πράγματα, να τα ελέγχετε και να φτιάχνετε τη δική σας έκδοση. Παρ\' όλα αυτά, κάθε συσκευή έχει τη δική της ενότητα άδειας και οι όροι μπορεί να διαφέρουν. Για να δείτε τον πηγαίο κώδικα, τα σχηματικά ή τους όρους χρήσης μιας συσκευής, ανατρέξτε στη δική της περιοχή άδειας.\n\nΣας ευχαριστούμε που μας στηρίζετε χρησιμοποιώντας αυτή την εφαρμογή. Χαιρόμαστε που είστε εδώ.';

  @override
  String get licenseOpenSourceHeading => 'Πάνω στους ώμους τους';

  @override
  String get licenseOpenSourceBody =>
      'Το SKAPP είναι χτισμένο πάνω σε χιλιάδες έργα ανοιχτού κώδικα που γράφτηκαν πριν από αυτό. Θερμές ευχαριστίες στην ομάδα του Flutter και τους συνεισφέροντές της που κατέστησαν δυνατό το ορατό περιβάλλον, και σε όλους τους προγραμματιστές ανοιχτού κώδικα που έχουν αφιερώσει χρόνια στη δικτύωση, την αποθήκευση, την κρυπτογραφία, το Bluetooth και αμέτρητα υποσυστήματα.\n\nΕπειδή επωφελούμαστε από το ανοιχτό λογισμικό, προσπαθούμε να κρατάμε ανοιχτά και το υλικό και το firmware των δικών μας συσκευών, ώστε όσοι έρθουν μετά από εμάς να μπορούν να επωφεληθούν από αυτό το σύνολο εργασίας με τον ίδιο τρόπο.\n\nΕυχαριστούμε ξανά όλους όσοι ήταν μέρος αυτής της προσπάθειας.';

  @override
  String get licenseThirdPartyLink =>
      'Άδειες τρίτων που χρησιμοποιούνται σε αυτή την εφαρμογή';

  @override
  String get discoveryTitle => 'Εύρεση συσκευών';

  @override
  String get discoverySearching =>
      'Αναζήτηση για κοντινές συσκευές SmartKraft…';

  @override
  String get discoveryNoResults => 'Δεν βρέθηκαν κοντινές συσκευές SmartKraft.';

  @override
  String get discoveryTapToConnect => 'Πατήστε μια συσκευή για σύνδεση';

  @override
  String get discoveryRescan => 'Σάρωση ξανά';

  @override
  String get pairingTitle => 'Σύζευξη συσκευής';

  @override
  String get pairingEnterPasskey =>
      'Εισαγάγετε το κλειδί πρόσβασης που αναγράφεται στην ετικέτα της συσκευής.';

  @override
  String get pairingPasskeyHint => 'π.χ. K7M9P2AB';

  @override
  String get pairingConnect => 'Σύνδεση';

  @override
  String get pairingMockNotice =>
      'Το firmware της συσκευής δεν είναι έτοιμο ακόμη. Η σύζευξη είναι ένα προσωρινό υποκατάστατο σε αυτή την έκδοση.';

  @override
  String get errorBluetoothPermission =>
      'Απαιτείται άδεια Bluetooth για τη σάρωση συσκευών.';

  @override
  String get errorBluetoothOff => 'Το Bluetooth είναι απενεργοποιημένο.';

  @override
  String get errorLocationPermission =>
      'Απαιτείται άδεια τοποθεσίας για τη σάρωση συσκευών BLE στο Android.';

  @override
  String get actionOpenSettings => 'Άνοιγμα ρυθμίσεων';

  @override
  String get actionGrantPermission => 'Παραχώρηση άδειας';

  @override
  String get commonCancel => 'Άκυρο';

  @override
  String get commonConfirm => 'Επιβεβαίωση';

  @override
  String get commonRetry => 'Επανάληψη';

  @override
  String get commonBack => 'Πίσω';

  @override
  String get commonRemove => 'Αφαίρεση';

  @override
  String get commonRefresh => 'Ανανέωση';

  @override
  String get commonOk => 'OK';

  @override
  String get commonClose => 'Κλείσιμο';

  @override
  String get commonSave => 'Αποθήκευση';

  @override
  String get commonDelete => 'Διαγραφή';

  @override
  String get commonConnect => 'Σύνδεση';

  @override
  String get commonAdd => 'Προσθήκη';

  @override
  String get commonForget => 'Διαγραφή';

  @override
  String get commonMore => 'Περισσότερα';

  @override
  String get commonError => 'Σφάλμα';

  @override
  String get commonOnline => 'συνδεδεμένο';

  @override
  String get commonOffline => 'εκτός σύνδεσης';

  @override
  String get productBlockingFocus => 'Blocking Focus';

  @override
  String get productLebensSpur => 'LebensSpur';

  @override
  String get productGeneric => 'Συσκευή SmartKraft';

  @override
  String get timeJustNow => 'μόλις τώρα';

  @override
  String timeMinAgo(int count) {
    return 'πριν $count λεπτά';
  }

  @override
  String timeHourAgo(int count) {
    return 'πριν $count ώ';
  }

  @override
  String timeDayAgo(int count) {
    return 'πριν $count μέρες';
  }

  @override
  String get devicesRemoveTitle => 'Αφαίρεση συσκευής';

  @override
  String devicesRemoveBody(String name) {
    return 'Η συσκευή $name θα αφαιρεθεί. Η συσκευή παραμένει συνδεδεμένη· για να την προσθέσετε ξανά θα χρειαστεί να την συζεύξετε εκ νέου.';
  }

  @override
  String get devicesUnpair => 'Αποσύζευξη';

  @override
  String get devicesEmptyHint =>
      'Φέρτε τη συσκευή SmartKraft σας κοντά και πατήστε το κουμπί παρακάτω.';

  @override
  String get devicesEmptyTitleNoPaired =>
      'Δεν υπάρχουν συζευγμένες συσκευές ακόμη';

  @override
  String devicesLastSeen(String time) {
    return 'Τελευταία εμφάνιση: $time';
  }

  @override
  String devicesPairedAt(String time) {
    return 'Συζεύχθηκε: $time';
  }

  @override
  String devicesHubSubtitle(int count) {
    return 'Κεντρικός υπολογιστής SKAPP · $count συζευγμένες';
  }

  @override
  String get devicesHubEmptySubtitle => 'αναμονή για συσκευή';

  @override
  String devicesHeaderSub(int paired, int online) {
    return '$paired συζευγμένες · $online συνδεδεμένες · προβολή αστερισμού';
  }

  @override
  String get devicesAddPillLabel => 'Προσθήκη συσκευής';

  @override
  String devicesLegendOnline(int count) {
    return 'συνδεδεμένες ($count)';
  }

  @override
  String devicesLegendOffline(int count) {
    return 'εκτός σύνδεσης ($count)';
  }

  @override
  String devicesLegendLowBattery(int count) {
    return 'χαμηλή μπαταρία ($count)';
  }

  @override
  String get devicesStatPaired => 'συζευγμένες';

  @override
  String get devicesStatBf => 'BF';

  @override
  String get devicesStatLs => 'LS';

  @override
  String get devicesStatMs => 'τηλέφωνο';

  @override
  String get devicesEmptyHubLabel => 'Άγνωστο';

  @override
  String get devicesEmptyAddCta => 'Προσθήκη πρώτης συσκευής';

  @override
  String get devicesEmptyHintChip =>
      'φέρτε τη συσκευή κοντά, πατήστε το κουμπί της';

  @override
  String devicesNotifOfflineHours(int hours) {
    return 'εκτός σύνδεσης πριν $hoursώ';
  }

  @override
  String devicesNotifOfflineMinutes(int minutes) {
    return 'εκτός σύνδεσης πριν $minutesλ';
  }

  @override
  String get devicesNotifLowBattery => 'χαμηλή μπαταρία';

  @override
  String get skappPeersCardTitle => 'Συζευγμένα SKAPP επιτραπέζια';

  @override
  String get skappPeersCardSubtitle =>
      'Τα τηλέφωνα και τα tablet συζεύγνυνται εδώ ώστε μια ενέργεια BF να μπορεί να εκτελέσει ένα script σε ένα επιτραπέζιο SKAPP. Ανοίξτε Επιτραπέζιο SKAPP > Ρυθμίσεις > SKAPP HTTP Listener για να λάβετε ένα QR.';

  @override
  String get skappPeersCardEmpty => 'Δεν υπάρχει συζευγμένο peer ακόμη.';

  @override
  String get skappPeersCardPairButton => 'Νέα σύζευξη';

  @override
  String get skappPeersCardOnline => 'συνδεδεμένο';

  @override
  String get skappPeersCardOffline => 'εκτός σύνδεσης';

  @override
  String get skappPeersCardNeverSeen => 'δεν εμφανίστηκε ποτέ';

  @override
  String skappPeersCardRemoveTitle(String name) {
    return 'Αφαίρεση $name;';
  }

  @override
  String get skappPeersCardRemoveBody =>
      'Το SKAPP θα σταματήσει να στέλνει scripts σε αυτό το peer. Μπορείτε να το συζεύξετε ξανά με το ίδιο QR / token αργότερα.';

  @override
  String get skappPeersCardRemoveConfirm => 'Αφαίρεση';

  @override
  String get skappPeersCardRemoveCancel => 'Άκυρο';

  @override
  String skappPeersCardRemovedToast(String name) {
    return 'Το $name αποσυζεύχθηκε';
  }

  @override
  String get devicesCardLongPressHint => 'Παρατεταμένο πάτημα για διαχείριση';

  @override
  String devicesActionsSheetTitle(String name) {
    return '$name';
  }

  @override
  String get devicesActionForget => 'Διαγραφή συσκευής';

  @override
  String get devicesActionForgetSubtitle =>
      'Αφαιρέστε αυτή τη συσκευή από το SKAPP. Η ίδια η συσκευή δεν επηρεάζεται· μπορείτε να την συζεύξετε ξανά αργότερα.';

  @override
  String get devicesActionCancel => 'Άκυρο';

  @override
  String devicesForgetDialogTitle(String name) {
    return 'Διαγραφή $name;';
  }

  @override
  String get devicesForgetDialogBody =>
      'Το SKAPP θα σταματήσει να παρακολουθεί αυτή τη συσκευή. Η σύζευξη στην πλευρά της συσκευής παραμένει μέχρι να την επαναφέρετε από τη συσκευή.';

  @override
  String devicesForgetDialogBodyWithActions(int count) {
    return 'Το SKAPP θα σταματήσει να παρακολουθεί αυτή τη συσκευή και θα διαγράψει $count ενέργειες SKAPI που είναι συνδεδεμένες με αυτήν. Η σύζευξη στην πλευρά της συσκευής παραμένει μέχρι να την επαναφέρετε από τη συσκευή.';
  }

  @override
  String get devicesForgetDialogConfirm => 'Διαγραφή';

  @override
  String get devicesForgetDialogCancel => 'Άκυρο';

  @override
  String devicesForgotToast(String name) {
    return 'Η $name αφαιρέθηκε από το SKAPP';
  }

  @override
  String get devicesMobileNoDetailHint =>
      'Δεν υπάρχει σελίδα λεπτομερειών για τηλέφωνα · παρατεταμένο πάτημα για αποσύζευξη';

  @override
  String get devicesDesktopStatLabel => 'επιτραπέζιο';

  @override
  String get devicesDesktopGroupLabel => 'Συζευγμένα επιτραπέζια';

  @override
  String get devicesDesktopTriggerDialogTitle => 'Αποστολή εντολής SKAPI;';

  @override
  String devicesDesktopTriggerDialogBody(String name) {
    return 'Όλες οι συνδέσεις αφής από κινητό στο $name θα εκτελεστούν.';
  }

  @override
  String get devicesDesktopTriggerDialogConfirm => 'Αποστολή εντολής';

  @override
  String get devicesDesktopTriggerDialogCancel => 'Άκυρο';

  @override
  String get devicesDesktopForgetDialogTitle => 'Αποσύζευξη';

  @override
  String devicesDesktopForgetDialogBody(String name) {
    return 'Αποσύζευξη του $name. Θα χρειαστεί να το συζεύξετε ξανά για να στείλετε εντολές σε αυτό το επιτραπέζιο ξανά.';
  }

  @override
  String devicesDesktopForgotToast(String name) {
    return 'Το $name αποσυζεύχθηκε';
  }

  @override
  String get homeStatDevices => 'Συσκευές';

  @override
  String get homeStatOnline => 'Συνδεδεμένες';

  @override
  String get homeStatWarning => 'Προειδοποίηση';

  @override
  String homeWarningMeta(String time) {
    return 'Συζεύχθηκε αλλά δεν εμφανίστηκε ποτέ · $time';
  }

  @override
  String get homeBrandTotal => 'Σύνολο';

  @override
  String get homeBrandActive => 'Ενεργές';

  @override
  String get homeBrandActions => 'Ενέργειες';

  @override
  String get homeBrandVersion => 'Έκδοση';

  @override
  String get smartkraftSectionProducts => 'Προϊόντα';

  @override
  String get smartkraftSectionCommunity => 'Κοινότητα';

  @override
  String get smartkraftStatusLive => 'ΖΩΝΤΑΝΟ';

  @override
  String get smartkraftStatusDev => 'ΥΠΟ ΑΝΑΠΤΥΞΗ';

  @override
  String get smartkraftStatusConcept => 'ΣΥΛΛΗΨΗ';

  @override
  String get smartkraftBlockingFocusTagline =>
      'Το διάλειμμα που δεν μπορείς να προσπεράσεις.';

  @override
  String get smartkraftLebensSpurTagline =>
      'Ένας ήσυχος μάρτυρας των συνηθειών σου.';

  @override
  String get smartkraftSynDimmTagline => 'Το σωστό φως τη σωστή ώρα.';

  @override
  String homeStickyDevicesMeta(int count, int warning) {
    return '$count συσκευές · $warning ειδοποιήσεις';
  }

  @override
  String homeStickySkapiMeta(int actions) {
    return '$actions ενέργειες';
  }

  @override
  String homeStickySettingsMeta(String node, String version) {
    return '$node · v$version';
  }

  @override
  String get homeStickyComingSoonMeta => 'περιεχόμενο σε εξέλιξη';

  @override
  String get homeStickyNotesLabel => 'Σημειώσεις';

  @override
  String get setupChoiceTitle => 'Προσθήκη συσκευής';

  @override
  String get setupChoiceQuestion => 'Πού βρισκόμαστε;';

  @override
  String get setupChoiceSubtitle =>
      'Είναι η συσκευή ολοκαίνουρια από το κουτί, ή έχει διαμορφωθεί προηγουμένως μέσω CLI;';

  @override
  String get setupChoiceFreshTitle => 'Νέα εγκατάσταση';

  @override
  String get setupChoiceFreshBody =>
      'Προσθέτω μια ολοκαίνουρια συσκευή SmartKraft για πρώτη φορά. Η σύζευξη θα γίνει μέσω BLE και θα ανοίξει ο οδηγός ρύθμισης WiFi.';

  @override
  String get setupChoiceExistingTitle => 'Προσθήκη ήδη διαμορφωμένης συσκευής';

  @override
  String get setupChoiceExistingBody =>
      'Διαμόρφωσα το WiFi της συσκευής μου μέσω USB/CLI και βρίσκομαι στο ίδιο δίκτυο. Σύζευξη απευθείας μέσω WiFi, παράκαμψη του οδηγού.';

  @override
  String get setupChoiceFooter =>
      'Όταν έχετε αμφιβολία, επιλέξτε «Νέα εγκατάσταση», είναι η σωστή διαδρομή τόσο για την πρώτη σύζευξη όσο και για συσκευές με εργοστασιακή επαναφορά.';

  @override
  String get wifiDiscoveryTitle => 'Συσκευές σε αυτό το δίκτυο';

  @override
  String wifiDiscoveryScanError(String error) {
    return 'Σφάλμα σάρωσης: $error';
  }

  @override
  String get wifiDiscoveryHint =>
      'Η συσκευή πρέπει να είναι στο WiFi και το τηλέφωνο στο ίδιο δίκτυο. Θα σας ζητηθεί να πατήσετε το κουμπί της συσκευής κατά τη σύζευξη.';

  @override
  String get wifiDiscoveryScanning => 'Σάρωση…';

  @override
  String get wifiDiscoveryNotFound => 'Δεν βρέθηκαν συσκευές';

  @override
  String wifiDiscoveryFoundCount(int count) {
    return 'Βρέθηκαν $count συσκευές';
  }

  @override
  String get wifiDiscoveryEmptyTitle =>
      'Αναζήτηση για συσκευές SmartKraft σε αυτό το δίκτυο…';

  @override
  String get wifiDiscoveryEmptyTitleIdle => 'Δεν βρέθηκαν συσκευές.';

  @override
  String get wifiDiscoveryEmptyHint =>
      'Βεβαιωθείτε ότι η συσκευή είναι ενεργοποιημένη, συνδεδεμένη στο WiFi και στο ίδιο δίκτυο με το τηλέφωνό σας. Χρησιμοποιήστε το κουμπί ανανέωσης για επανάληψη.';

  @override
  String get wifiDiscoveryPairedBadge => 'συζευγμένη';

  @override
  String get wifiPairingTitle => 'Σύζευξη';

  @override
  String wifiPairingConnectFailed(String error) {
    return 'Δεν ήταν δυνατή η σύνδεση: $error';
  }

  @override
  String wifiPairingInvalidJson(String error) {
    return 'Μη έγκυρο JSON: $error';
  }

  @override
  String get wifiPairingClosedEarly => 'Η σύνδεση έκλεισε (καμία απάντηση)';

  @override
  String wifiPairingSendFailed(String error) {
    return 'Δεν ήταν δυνατή η αποστολή εντολής: $error';
  }

  @override
  String get wifiPairingTimeout => 'Η συσκευή δεν απάντησε (λήξη χρόνου).';

  @override
  String get wifiPairingNotOpen =>
      'Το παράθυρο σύζευξης δεν είναι ανοιχτό στη συσκευή. Πατήστε σύντομα το κουμπί και δοκιμάστε ξανά.';

  @override
  String get skapiBindFixedTriggerLabel => 'Trigger: όταν λήξει το χρονόμετρο';

  @override
  String get wifiPairingDeviceAlreadyBonded =>
      'Αυτή η συσκευή είναι ήδη συζευγμένη με άλλο SKAPP. Η προσθήκη νέου peer μέσω WiFi δεν υποστηρίζεται από το τρέχον firmware (το TCP δέχεται μόνο την πρώτη σύζευξη). Χρησιμοποιήστε σύζευξη BLE, ή αποσυζεύξτε το υπάρχον peer από τη συσκευή.';

  @override
  String wifiPairingRejected(String error) {
    return 'Η συσκευή απέρριψε: $error';
  }

  @override
  String get wifiPairingMissingPub =>
      'Λείπει/είναι κατεστραμμένο το our_pub από τη συσκευή.';

  @override
  String wifiPairingHexError(String error) {
    return 'Η αποκωδικοποίηση hex του our_pub απέτυχε: $error';
  }

  @override
  String get wifiPairingStageAwaiting => 'Πατήστε το κουμπί στη συσκευή';

  @override
  String get wifiPairingStageConnecting => 'Σύνδεση με τη συσκευή…';

  @override
  String get wifiPairingStageExchanging => 'Ανταλλαγή κλειδιών…';

  @override
  String get wifiPairingStageDone => 'Η σύζευξη ολοκληρώθηκε';

  @override
  String get wifiPairingStageFailed => 'Η σύζευξη απέτυχε';

  @override
  String get wifiPairingStageAwaitingHelp =>
      'Πατήστε σύντομα το κουμπί ελέγχου της συσκευής (λιγότερο από 3 δευτερόλεπτα). Το παράθυρο σύζευξης παραμένει ανοιχτό για 60 δευτερόλεπτα.';

  @override
  String get wifiPairingStageConnectingHelp => 'Άνοιγμα υποδοχής TCP.';

  @override
  String get wifiPairingStageExchangingHelp =>
      'Στάλθηκε το pairing.ecdh.exchange, αναμονή για την απάντηση της συσκευής.';

  @override
  String get wifiPairingStageDoneHelp =>
      'Μετάβαση στον πίνακα ελέγχου της συσκευής.';

  @override
  String get wifiPairingStartCta => 'Σύζευξη';

  @override
  String get bfDashboardTitleFallback => 'Συσκευή';

  @override
  String get bfDashboardWifiNone => 'Χωρίς WiFi';

  @override
  String get bfDashboardLinkBle => 'BLE';

  @override
  String get bfDashboardLinkWifi => 'WiFi';

  @override
  String get bfDashboardLinkUsb => 'USB';

  @override
  String get bfDashboardToggleVibration => 'Δόνηση';

  @override
  String get bfDashboardToggleTilt => 'Ειδοποίηση κλίσης';

  @override
  String get bfDashboardToggleLowBatt => 'Ειδοποίηση χαμηλής μπαταρίας';

  @override
  String get bfDashboardApiChainTitle => 'Αλυσίδα API';

  @override
  String bfDashboardApiChainNone(String state) {
    return 'κανένα endpoint ακόμη · κύριος $state';
  }

  @override
  String bfDashboardApiChainSummary(int count, String state) {
    return '$count endpoints · κύριος $state';
  }

  @override
  String get bfDashboardMasterOn => 'ενεργός';

  @override
  String get bfDashboardMasterOff => 'ανενεργός';

  @override
  String get bfDashboardNotebookTitle => 'Σημειωματάριο χρήστη';

  @override
  String get bfDashboardNotebookSubtitle =>
      'Κρυπτογραφημένη περιοχή · 100 KB · ελεύθερο περιεχόμενο';

  @override
  String get bfDashboardMoreDeviceInfo => 'Πληροφορίες συσκευής';

  @override
  String get bfDashboardMoreSettings => 'Ρυθμίσεις';

  @override
  String bfDashboardWriteFailed(String error) {
    return 'Δεν ήταν δυνατή η εγγραφή: $error';
  }

  @override
  String get bfDeviceInfoTitle => 'Πληροφορίες συσκευής';

  @override
  String get bfDeviceInfoSectionGeneral => 'ΓΕΝΙΚΑ';

  @override
  String get bfDeviceInfoSectionConnection => 'ΣΥΝΔΕΣΗ';

  @override
  String get bfDeviceInfoSectionBattery => 'ΜΠΑΤΑΡΙΑ';

  @override
  String get bfDeviceInfoSectionTime => 'ΩΡΑ';

  @override
  String get bfDeviceInfoSectionLastError => 'ΤΕΛΕΥΤΑΙΟ ΣΦΑΛΜΑ';

  @override
  String get bfDeviceInfoSectionDiagnostics => 'ΔΙΑΓΝΩΣΤΙΚΑ';

  @override
  String get bfDeviceInfoSectionDocs => 'ΤΕΚΜΗΡΙΩΣΗ';

  @override
  String get bfDeviceInfoProduct => 'Προϊόν';

  @override
  String get bfDeviceInfoTypeCode => 'Κωδικός τύπου';

  @override
  String get bfDeviceInfoIdentity => 'Ταυτότητα';

  @override
  String get bfDeviceInfoHardware => 'Υλικό';

  @override
  String get bfDeviceInfoFirmware => 'Firmware';

  @override
  String get bfDeviceInfoProtocol => 'Πρωτόκολλο';

  @override
  String get bfDeviceInfoBuild => 'Build';

  @override
  String get bfDeviceInfoUptime => 'Χρόνος λειτουργίας';

  @override
  String get bfDeviceInfoWifiState => 'Κατάσταση WiFi';

  @override
  String get bfDeviceInfoIp => 'IP';

  @override
  String get bfDeviceInfoSignal => 'Σήμα';

  @override
  String get bfDeviceInfoBleAdvertising => 'Εκπομπή BLE';

  @override
  String get bfDeviceInfoBlePaired => 'Συζεύξεις BLE';

  @override
  String bfDeviceInfoPairedClients(int count) {
    return '$count πελάτες';
  }

  @override
  String get bfDeviceInfoBattery => 'Μπαταρία';

  @override
  String get bfDeviceInfoBatteryPresent => 'παρούσα';

  @override
  String get bfDeviceInfoBatteryAbsent => 'απούσα';

  @override
  String get bfDeviceInfoDeviceClock => 'Ρολόι συσκευής';

  @override
  String get bfDeviceInfoLogs => 'Αρχεία καταγραφής συσκευής';

  @override
  String get bfDeviceInfoLogsSubtitle =>
      'logs.get, boot, σφάλμα, χρονόμετρο, συμβάντα API';

  @override
  String get bfDeviceInfoEvents => 'Ιστορικό συμβάντων';

  @override
  String get bfDeviceInfoEventsSubtitle =>
      'Τοπικά · χρονόμετρο, αλλαγή όψης, triggers API';

  @override
  String get bfDeviceInfoUserGuide => 'Οδηγός χρήσης';

  @override
  String get bfDeviceInfoUserGuideSubtitle =>
      'Αντιστοίχιση όψης, χρονόμετρο, triggers API';

  @override
  String get bfDeviceInfoDevNotes => 'Σημειώσεις προγραμματιστή SK';

  @override
  String get bfDeviceInfoDevNotesSubtitle =>
      'Εντολές CLI, αρχιτεκτονική, ταξινομία συμβάντων';

  @override
  String get bfDeviceInfoLicense => 'Άδεια & ανοιχτές πηγές';

  @override
  String get bfDeviceInfoLicenseSubtitle =>
      'Βιβλιοθήκες που χρησιμοποιούνται και πληροφορίες πνευματικών δικαιωμάτων';

  @override
  String get bfDeviceInfoComingSoon => 'Έρχεται σύντομα';

  @override
  String bfDeviceInfoUptimeSecs(int n) {
    return '$n δ';
  }

  @override
  String bfDeviceInfoUptimeMins(int n) {
    return '$n λεπτά';
  }

  @override
  String bfDeviceInfoUptimeHours(int h, int m) {
    return '$h ώ $m λεπτά';
  }

  @override
  String bfDeviceInfoUptimeDays(int d, int h) {
    return '$d μέρες $h ώ';
  }

  @override
  String get bfDeviceInfoYes => 'ναι';

  @override
  String get bfDeviceInfoNo => 'όχι';

  @override
  String get bfSettingsTitle => 'Ρυθμίσεις';

  @override
  String get bfSettingsSectionNetwork => 'ΔΙΚΤΥΟ';

  @override
  String get bfSettingsSectionUpdates => 'ΕΝΗΜΕΡΩΣΕΙΣ';

  @override
  String get bfSettingsSectionDanger => 'ΖΩΝΗ ΚΙΝΔΥΝΟΥ';

  @override
  String get bfSettingsWifiPrimary => 'Κύριο WiFi';

  @override
  String get bfSettingsWifiSecondary => 'Εφεδρικό WiFi';

  @override
  String get bfSettingsWifiUnconfigured => 'Μη διαμορφωμένο';

  @override
  String get bfSettingsFirmware => 'Firmware';

  @override
  String get bfSettingsCheckUpdates => 'Έλεγχος για ενημερώσεις';

  @override
  String get bfSettingsCheckUpdatesSubtitle =>
      'Ενεργοποιείται μόλις οριστεί ένα URL manifest';

  @override
  String get bfOtaTitle => 'Ενημέρωση firmware';

  @override
  String get bfOtaCurrentLabel => 'Εγκατεστημένη έκδοση';

  @override
  String get bfOtaRunningPartitionLabel => 'Ενεργό διαμέρισμα';

  @override
  String get bfOtaCheckCta => 'Έλεγχος για ενημερώσεις';

  @override
  String get bfOtaIdleHint => 'Δεν έχει εκτελεστεί έλεγχος ενημερώσεων ακόμη.';

  @override
  String get bfOtaChecking => 'Έλεγχος του διακομιστή ενημερώσεων…';

  @override
  String get bfOtaUpToDate => 'Η συσκευή είναι ενημερωμένη.';

  @override
  String bfOtaAvailable(String version) {
    return 'Διαθέσιμη νέα έκδοση: $version';
  }

  @override
  String get bfOtaUpdateCta => 'Ενημέρωση τώρα';

  @override
  String bfOtaDownloading(int pct) {
    return 'Λήψη… %$pct';
  }

  @override
  String get bfOtaDone => 'Ενημερώθηκε. Η συσκευή επανεκκινείται…';

  @override
  String bfOtaErrorMsg(String message) {
    return 'Σφάλμα: $message';
  }

  @override
  String get bfOtaRollbackCta => 'Επαναφορά στην προηγούμενη έκδοση';

  @override
  String get bfOtaUpdateConfirmTitle => 'Εγκατάσταση ενημέρωσης firmware;';

  @override
  String bfOtaUpdateConfirmBody(String version) {
    return 'Η έκδοση $version θα ληφθεί και θα εγκατασταθεί, και στη συνέχεια η συσκευή θα επανεκκινήσει. Μην την απενεργοποιήσετε κατά τη διάρκεια της ενημέρωσης.';
  }

  @override
  String get bfOtaRollbackConfirmTitle => 'Επαναφορά firmware;';

  @override
  String get bfOtaRollbackConfirmBody =>
      'Η συσκευή θα εκκινήσει το προηγούμενο firmware και θα επανεκκινήσει.';

  @override
  String get bfSettingsReboot => 'Επανεκκίνηση συσκευής';

  @override
  String get bfSettingsRebootSubtitle =>
      'Επανεκκινεί τη συσκευή · ακυρώνει κάθε ενεργό χρονόμετρο';

  @override
  String get bfSettingsRebootConfirmTitle => 'Επανεκκίνηση συσκευής;';

  @override
  String get bfSettingsRebootConfirmBody =>
      'Η συσκευή θα απενεργοποιηθεί και θα ενεργοποιηθεί ξανά σε λίγα δευτερόλεπτα.';

  @override
  String get bfSettingsUnpairThisPhone => 'Αποσύζευξη αυτού του τηλεφώνου';

  @override
  String get bfSettingsUnpairSubtitle =>
      'Αφαιρεί τη σύνδεση · η συσκευή πρέπει να συζευχθεί ξανά';

  @override
  String get bfSettingsUnpairConfirmTitle => 'Αποσύζευξη αυτού του τηλεφώνου;';

  @override
  String get bfSettingsFactoryReset => 'Επαναφορά εργοστασιακών';

  @override
  String get bfSettingsFactoryResetSubtitle =>
      'Διαγράφει WiFi, endpoints API και συζεύξεις';

  @override
  String get bfSettingsFactoryResetConfirmTitle => 'Επαναφορά εργοστασιακών;';

  @override
  String get bfSettingsFactoryResetConfirmBody =>
      'Όλες οι ρυθμίσεις θα εκκαθαριστούν. Η συσκευή θα επανεκκινήσει.';

  @override
  String get bfWifiManagementTitle => 'Διαχείριση WiFi';

  @override
  String get bfWifiConnecting => 'Σύνδεση…';

  @override
  String bfWifiConnectionRejected(String error) {
    return 'Η σύνδεση απορρίφθηκε: $error';
  }

  @override
  String bfWifiConfigure(String label) {
    return 'Διαμόρφωση $label';
  }

  @override
  String get bfWifiPasswordLabel => 'Κωδικός πρόσβασης';

  @override
  String get bfNotebookTitle => 'Σημειωματάριο χρήστη';

  @override
  String get bfNotebookSaveCancel => 'Άκυρο';

  @override
  String get bfApiChainCancel => 'Άκυρο';

  @override
  String get bfApiChainRunChain => 'Εκτέλεση αλυσίδας';

  @override
  String get bfApiChainToggleAll => 'Ενεργοποίηση/απενεργοποίηση όλων';

  @override
  String get bfApiChainFieldName => 'Όνομα';

  @override
  String get bfApiChainFieldType => 'Τύπος';

  @override
  String get bfApiChainFieldHeaderName => 'Όνομα κεφαλίδας';

  @override
  String get bfApiChainFieldNewToken => 'Νέο token (αφήστε κενό για διατήρηση)';

  @override
  String get bfHomeLoadingConnecting => 'Σύνδεση με τη συσκευή…';

  @override
  String get bfHomeLoadingSecure => 'Άνοιγμα ασφαλούς καναλιού…';

  @override
  String get deviceConnUnreachableTitle =>
      'Δεν είναι δυνατή η προσέγγιση της συσκευής';

  @override
  String get deviceConnUnreachableBody =>
      'Η συσκευή μπορεί να είναι απενεργοποιημένη, εκτός εμβέλειας ή σε αδράνεια. Βεβαιωθείτε ότι είναι ενεργοποιημένη και κοντά, και δοκιμάστε ξανά.';

  @override
  String get deviceConnRepairTitle => 'Η σύζευξη πρέπει να ανανεωθεί';

  @override
  String get deviceConnRepairBody =>
      'Η συσκευή φαίνεται να έχει επαναφερθεί και δεν αναγνωρίζει πλέον αυτό το τηλέφωνο. Συζεύξτε την ξανά για επανασύνδεση.';

  @override
  String get deviceConnRepairButton => 'Σύζευξη ξανά';

  @override
  String get deviceConnTechnicalDetails => 'Τεχνικές λεπτομέρειες';

  @override
  String get bfLogsTitle => 'Αρχεία καταγραφής συσκευής';

  @override
  String get bfEventsTitle => 'Ιστορικό συμβάντων';

  @override
  String get pairingStepConnecting => 'Σύνδεση';

  @override
  String get pairingStepConnectingSubtitle => 'Σύνδεσμος BLE + ανακάλυψη GATT';

  @override
  String get pairingStepMutualAuth => 'Αμοιβαία πιστοποίηση';

  @override
  String get pairingStepDeviceInfo => 'Επαλήθευση device.info';

  @override
  String get pairingStepDeviceInfoSubtitle =>
      'Κρυπτογραφημένο κανάλι ενεργό, έλεγχος ορθότητας';

  @override
  String get pairingStepConnected => 'Η σύνδεση δημιουργήθηκε';

  @override
  String get pairingStepConnectedSubtitle => 'CLI έτοιμο, μετάβαση στη ρύθμιση';

  @override
  String get pairingStepKeyExchange => 'Ανταλλαγή κλειδιών';

  @override
  String get pairingStepKeyExchangeSubtitle =>
      'X25519, στάλθηκε δημόσιο κλειδί';

  @override
  String get pairingStepVerifying => 'Επαλήθευση';

  @override
  String get pairingStepVerifyingSubtitle =>
      'Αναμονή για τη συσκευή, παραγωγή token';

  @override
  String get pairingStepDone => 'Η σύζευξη ολοκληρώθηκε';

  @override
  String get pairingStepDoneSubtitle =>
      'Η σύνδεση αποθηκεύτηκε στη συσκευή και το τηλέφωνο';

  @override
  String get pairingLogTitle => 'Αρχείο καταγραφής σύζευξης';

  @override
  String get pairingLogCopied =>
      'Το αρχείο καταγραφής αντιγράφηκε στο πρόχειρο';

  @override
  String get discoveryPreparing => 'Προετοιμασία…';

  @override
  String get discoveryBluetoothOff => 'Το Bluetooth είναι απενεργοποιημένο';

  @override
  String get wifiPasswordTitle => 'Σύνδεση συσκευής στο WiFi';

  @override
  String get wifiPasswordSsidLabel => 'Όνομα δικτύου (SSID)';

  @override
  String get wifiPasswordNetworkLabel => 'Δίκτυο';

  @override
  String get wifiPasswordPasswordLabel => 'Κωδικός πρόσβασης';

  @override
  String get wifiPasswordConnect => 'Σύνδεση';

  @override
  String get wifiPasswordLogTitle => 'Αρχείο καταγραφής σύνδεσης';

  @override
  String get wifiPasswordLogCopied =>
      'Το αρχείο καταγραφής αντιγράφηκε στο πρόχειρο';

  @override
  String get wifiScanTitle => 'Επιλέξτε ένα δίκτυο WiFi για τη συσκευή';

  @override
  String get wifiScanRescanTooltip => 'Πείτε στη συσκευή να σαρώσει ξανά';

  @override
  String get wifiScanRunning => 'Ο σαρωτής WiFi της συσκευής εκτελείται…';

  @override
  String get wifiScanNoNetworks => 'Η συσκευή δεν βρήκε κοντινό WiFi.';

  @override
  String get wifiScanRescan => 'Πείτε στη συσκευή να σαρώσει ξανά';

  @override
  String get wifiScanHiddenAdd => 'Προσθήκη κρυφού δικτύου';

  @override
  String get wifiScanHiddenSubtitle => 'Πληκτρολογήστε το SSID χειροκίνητα';

  @override
  String get wifiScanLogTitle => 'Αρχείο καταγραφής σάρωσης WiFi';

  @override
  String get wifiSuccessReady => 'Έτοιμο';

  @override
  String get bfEventsClearTooltip => 'Εκκαθάριση';

  @override
  String get bfEventsEmpty =>
      'Δεν υπάρχουν συμβάντα ακόμη. Θα εμφανιστούν εδώ μόλις η συσκευή αρχίσει να τα δημοσιεύει.';

  @override
  String get logsEmptyTooltip => 'Το αρχείο καταγραφής είναι κενό.';

  @override
  String logsErrorPrefix(String error) {
    return 'Σφάλμα: $error';
  }

  @override
  String get notebookSaved => 'Αποθηκεύτηκε';

  @override
  String notebookSaveError(String error) {
    return 'Σφάλμα: $error';
  }

  @override
  String notebookCapacityExceeded(int used, int capacity) {
    return 'Υπέρβαση χωρητικότητας: $used / $capacity bytes';
  }

  @override
  String get notebookClearTooltip => 'Εκκαθάριση σημειωματαρίου';

  @override
  String get notebookClearConfirmTitle =>
      'Εκκαθάριση ολόκληρου του σημειωματαρίου;';

  @override
  String get notebookClearConfirmBody =>
      'Όλα τα δεδομένα χρήστη στη συσκευή θα διαγραφούν. Δεν αναιρείται.';

  @override
  String get notebookClearAction => 'Εκκαθάριση';

  @override
  String get notebookClearedSnack => 'Το σημειωματάριο εκκαθαρίστηκε';

  @override
  String notebookClearError(String error) {
    return 'Δεν ήταν δυνατή η εκκαθάριση: $error';
  }

  @override
  String get notebookEncryptedHint =>
      'Κρυπτογραφημένη περιοχή · μόνο το συζευγμένο SKAPP μπορεί να την διαβάσει';

  @override
  String get notebookEmptyTitle => 'Το σημειωματάριο είναι κενό';

  @override
  String get notebookEmptyBody =>
      'Πληκτρολογήστε σημειώσεις, JSON, ορισμούς σκηνών ή οποιοδήποτε άλλο κείμενο παρακάτω. Πατώντας Αποθήκευση αποθηκεύεται κρυπτογραφημένο στη συσκευή.';

  @override
  String get notebookHint =>
      'Πληκτρολογήστε ό,τι θέλετε εδώ (σημειώσεις, JSON, το δικό σας σχήμα). Έως 100 KB αποθηκεύονται στη συσκευή.';

  @override
  String get notebookDirty => 'Μη αποθηκευμένες αλλαγές';

  @override
  String get notebookSaved2 => 'Αποθηκεύτηκε';

  @override
  String get notebookSyncedDifferent => 'Συγχρονισμένο';

  @override
  String get notebookSaveCta => 'Αποθήκευση';

  @override
  String wifiPairingHexErrorRaw(String error) {
    return 'Η αποκωδικοποίηση hex του our_pub απέτυχε: $error';
  }

  @override
  String get bfWifiForgetTitle => 'Διαγραφή υποδοχής;';

  @override
  String get bfWifiForgetBody =>
      'Η υποδοχή θα διαγραφεί. Αν η συσκευή είναι αυτή τη στιγμή συνδεδεμένη εδώ, θα μεταβεί στην άλλη υποδοχή (αν υπάρχει). Απαιτείται εκ νέου διαμόρφωση για επαναφορά.';

  @override
  String get bfWifiForget => 'Διαγραφή';

  @override
  String get bfWifiHint =>
      'Η συσκευή δοκιμάζει τα δύο δίκτυα με τη σειρά: πρώτα το Κύριο, και το Εφεδρικό αν αποτύχει. Η ενεργή υποδοχή σημειώνεται με μια πράσινη τελεία.';

  @override
  String get bfWifiActive => 'ΕΝΕΡΓΗ';

  @override
  String get bfWifiNotConfigured => 'Μη διαμορφωμένο';

  @override
  String get bfWifiChange => 'Αλλαγή';

  @override
  String get bfWifiSetUp => 'Ρύθμιση';

  @override
  String get discoveryStatusChecking => 'Έλεγχος κατάστασης Bluetooth.';

  @override
  String get discoveryPermissionsTitle => 'Απαιτείται άδεια Bluetooth';

  @override
  String get discoveryPermissionsBody =>
      'Για να βρείτε κοντινές συσκευές SmartKraft, ενεργοποιήστε την άδεια Bluetooth.';

  @override
  String get discoveryPermissionsRetry => 'Αίτημα αδειών ξανά';

  @override
  String get discoveryPermissionsOpenSettings => 'Άνοιγμα ρυθμίσεων';

  @override
  String get discoveryAdapterOffBody =>
      'Ενεργοποιήστε το Bluetooth για να σαρώσετε για συσκευές.';

  @override
  String get discoveryAdapterOffEnable => 'Ενεργοποίηση Bluetooth';

  @override
  String get discoveryUnsupportedTitle => 'Το BLE δεν υποστηρίζεται';

  @override
  String get discoveryUnsupportedBody =>
      'Αυτή η συσκευή δεν υποστηρίζει Bluetooth Low Energy, το SKAPP χρειάζεται BLE για να λειτουργήσει.';

  @override
  String get wifiPasswordHelp =>
      'Η συσκευή θα συνδεθεί σε αυτό το δίκτυο. Εισαγάγετε τον κωδικό πρόσβασης, πληκτρολογήστε τον προσεκτικά.';

  @override
  String get wifiPasswordRequired => 'Απαιτείται κωδικός πρόσβασης';

  @override
  String get wifiPasswordMinLength => 'Τουλάχιστον 8 χαρακτήρες';

  @override
  String wifiPasswordSendError(String error) {
    return 'Δεν ήταν δυνατή η αποστολή: $error';
  }

  @override
  String get wifiScanTimeoutHint =>
      'Αν η σάρωση διαρκεί πολύ, η συσκευή μπορεί να έχει χάσει την εμβέλεια WiFi. Πατήστε επανάληψη.';

  @override
  String get wifiScanFailedTitle => 'Η σάρωση απέτυχε';

  @override
  String get wifiScanRetry => 'Επανάληψη';

  @override
  String get wifiSuccessTitle => 'Συνδέθηκε';

  @override
  String get wifiSuccessBody =>
      'Η συσκευή είναι τώρα στο WiFi. Επιστροφή στον πίνακα ελέγχου…';

  @override
  String get deviceNameSectionHeading =>
      'ΟΝΟΜΑ ΣΥΣΚΕΥΗΣ (ΜΟΝΟ ΣΕ ΑΥΤΗ ΤΗΝ ΕΦΑΡΜΟΓΗ)';

  @override
  String get deviceNameLabel => 'Προσαρμοσμένο όνομα';

  @override
  String get deviceNameHint => 'π.χ. BF Γραφείου';

  @override
  String get deviceNameSubtitle =>
      'Εμφανίζεται στις κάρτες αυτής της εγκατάστασης SKAPP. Δεν στέλνεται στη συσκευή.';

  @override
  String get deviceNameClear => 'Εκκαθάριση';

  @override
  String get deviceNameSave => 'Αποθήκευση';

  @override
  String get deviceNameSaved => 'Αποθηκεύτηκε';

  @override
  String get deviceNameEmptyPlaceholder => '(χωρίς προσαρμοσμένο όνομα)';

  @override
  String get settingsUsbConsoleTitle => 'Κονσόλα USB CLI';

  @override
  String get settingsUsbConsoleSubtitle =>
      'Αποστολή απευθείας εντολών σε συσκευή συνδεδεμένη μέσω USB';

  @override
  String get usbConsoleAppBarTitle => 'Κονσόλα USB';

  @override
  String get usbConsolePickPortTitle => 'Επιλέξτε μια θύρα';

  @override
  String get usbConsolePickPortHint =>
      'Συνδέστε μια συσκευή SmartKraft μέσω USB και πατήστε ανανέωση';

  @override
  String get usbConsolePortRefreshTooltip => 'Ανανέωση θυρών';

  @override
  String get usbConsoleBfBadge => 'SmartKraft';

  @override
  String get usbConsoleConnecting => 'Σύνδεση…';

  @override
  String get usbConsoleConnected => 'Συνδέθηκε';

  @override
  String get usbConsoleDisconnected => 'Αποσυνδέθηκε';

  @override
  String usbConsoleErrorBanner(String error) {
    return 'Σφάλμα: $error';
  }

  @override
  String get usbConsoleReconnect => 'Επανασύνδεση';

  @override
  String get usbConsoleDisconnect => 'Αποσύνδεση';

  @override
  String get usbConsoleClear => 'Εκκαθάριση κονσόλας';

  @override
  String get usbConsoleInputHint =>
      'Πληκτρολογήστε μια εντολή, π.χ. device.info';

  @override
  String get usbConsoleSend => 'Αποστολή';

  @override
  String get usbConsoleEmptyHint =>
      'Πληκτρολογήστε μια εντολή και πατήστε Enter, δοκιμάστε device.info';

  @override
  String get usbConsoleEntryEvent => 'συμβ';

  @override
  String get usbConsoleEntryError => 'σφάλμα';

  @override
  String get usbConsoleNotSupportedIos =>
      'Η κονσόλα USB δεν υποστηρίζεται σε iOS';

  @override
  String get passphraseFieldLabel => 'Φράση πρόσβασης';

  @override
  String get passphraseVerifyButton => 'Επαλήθευση';

  @override
  String passphraseAttemptsLeft(int count) {
    return 'Απομένουν προσπάθειες: $count';
  }

  @override
  String get passphraseLockoutTriggered =>
      'Πάρα πολλές λανθασμένες προσπάθειες φράσης πρόσβασης· η συσκευή επανέφερε τον εαυτό της στις εργοστασιακές ρυθμίσεις.';

  @override
  String get bondPeerUnnamed => '(χωρίς όνομα)';

  @override
  String get pairingPassphraseDialogTitle => 'Φράση πρόσβασης συσκευής';

  @override
  String get pairingPassphraseDialogBody =>
      'Αυτή η συσκευή απαιτεί φράση πρόσβασης για πρόσβαση στο περιεχόμενο. Εισαγάγετέ την για να ολοκληρώσετε τη σύζευξη.';

  @override
  String get pairingPassphraseCancelled =>
      'Δεν εισήχθη φράση πρόσβασης, η σύζευξη ακυρώθηκε.';

  @override
  String pairingPassphraseSendError(String error) {
    return 'Δεν ήταν δυνατή η αποστολή φράσης πρόσβασης: $error';
  }

  @override
  String get pairingPassphraseTimeout =>
      'Η συσκευή δεν απάντησε (επαλήθευση φράσης πρόσβασης, 8 δ).';

  @override
  String get pairingWindowClosedRetry =>
      'Το παράθυρο σύζευξης έκλεισε, πατήστε σύντομα το κουμπί και δοκιμάστε ξανά.';

  @override
  String pairingPassphraseFailed(String error) {
    return 'Δεν ήταν δυνατή η επαλήθευση της φράσης πρόσβασης: $error';
  }

  @override
  String get bondStoreFullHeader =>
      'Και οι 8 υποδοχές σύνδεσης είναι γεμάτες. Αφαιρέστε ένα υπάρχον peer για να συζεύξετε ένα νέο SKAPP:';

  @override
  String bondStoreFullPeerLine(Object slot, String name, String shortPid) {
    return '  • υποδοχή $slot, $name [#$shortPid]';
  }

  @override
  String get bondStoreFullFooter =>
      'Από άλλο συζευγμένο SKAPP ή μέσω USB, εκτελέστε\n`bond.remove --slot N`, και μετά πατήστε Επανάληψη εδώ.';

  @override
  String get passphraseGateDialogBody =>
      'Αυτή η συσκευή ζητά τη φράση πρόσβασης σε κάθε σύνδεση. Εισαγάγετέ την για πρόσβαση στο περιεχόμενο.';

  @override
  String get passphraseGateCancelled =>
      'Δεν εισήχθη φράση πρόσβασης, η επαλήθευση απαιτείται για πρόσβαση σε αυτή την οθόνη.';

  @override
  String passphraseGateVerifyError(String error) {
    return 'Σφάλμα επαλήθευσης: $error';
  }

  @override
  String passphraseGateCommError(String error) {
    return 'Σφάλμα επικοινωνίας: $error';
  }

  @override
  String get passphraseGateUnknownError => 'Άγνωστο σφάλμα κλειδώματος.';

  @override
  String get bfPassphraseTitle => 'Φράση πρόσβασης συσκευής';

  @override
  String get bfPassphraseSetTitle => 'Ορισμός φράσης πρόσβασης';

  @override
  String get bfPassphraseChangeTitle => 'Αλλαγή φράσης πρόσβασης';

  @override
  String get bfPassphraseClearTitle => 'Αφαίρεση φράσης πρόσβασης';

  @override
  String get bfPassphraseChangeSubtitle =>
      'Εισαγάγετε την παλιά φράση πρόσβασης, ορίστε τη νέα';

  @override
  String get bfPassphraseClearSubtitle =>
      'Επαναφορά του κλειδώματος περιεχομένου στη συσκευή';

  @override
  String get bfPassphraseModePairing => 'Ερώτηση κατά τη σύζευξη';

  @override
  String get bfPassphraseModePairingSubtitle =>
      'Ρωτά όταν συζεύγνυται ένα νέο SKAPP. Στα υπάρχοντα peers δεν ζητείται.';

  @override
  String get bfPassphraseModeAlways => 'Ερώτηση σε κάθε σύνδεση';

  @override
  String get bfPassphraseModeAlwaysSubtitle =>
      'Ρωτά κάθε φορά που ανοίγει μια συνεδρία. Το περιεχόμενο παραμένει κλειδωμένο ακόμη κι αν κλαπεί ένα SKAPP.';

  @override
  String get bfPassphraseStatusNone =>
      'Χωρίς φράση πρόσβασης, η συσκευή δεν έχει κλείδωμα περιεχομένου';

  @override
  String get bfPassphraseStatusActiveOff =>
      'Ορίστηκε φράση πρόσβασης · επιβολή ανενεργή (και οι δύο διακόπτες ανενεργοί)';

  @override
  String get bfPassphraseStatusActivePairing => 'Ζητείται κατά τη σύζευξη';

  @override
  String get bfPassphraseStatusActiveAlways => 'Ζητείται σε κάθε σύνδεση';

  @override
  String get bfPassphraseBadgeActive => 'Φράση πρόσβασης ενεργή';

  @override
  String get bfPassphraseBadgeNone => 'Χωρίς φράση πρόσβασης';

  @override
  String bfPassphraseAttemptsRatio(int left, int total) {
    return 'Απομένουν προσπάθειες: $left / $total';
  }

  @override
  String bfPassphraseLengthSubtitle(int min, int max) {
    return 'Μήκος $min-$max χαρακτήρες';
  }

  @override
  String bfPassphraseLengthHint(int min, int max) {
    return 'Μήκος: $min-$max';
  }

  @override
  String bfPassphraseTooShort(int min) {
    return 'Τουλάχιστον $min χαρακτήρες';
  }

  @override
  String bfPassphraseTooLong(int max) {
    return 'Το πολύ $max χαρακτήρες';
  }

  @override
  String get bfPassphraseEmpty => 'Δεν μπορεί να είναι κενό';

  @override
  String get bfPassphraseNewLabel => 'Νέα φράση πρόσβασης';

  @override
  String get bfPassphraseCurrentLabel => 'Τρέχουσα φράση πρόσβασης';

  @override
  String get bfPassphraseSetDone => 'Η φράση πρόσβασης ορίστηκε';

  @override
  String get bfPassphraseChangeDone => 'Η φράση πρόσβασης άλλαξε';

  @override
  String get bfPassphraseClearDone => 'Η φράση πρόσβασης αφαιρέθηκε';

  @override
  String bfPassphraseStatusReadError(String error) {
    return 'Δεν ήταν δυνατή η ανάγνωση της κατάστασης: $error';
  }

  @override
  String get bfPassphraseNotesTitle => 'Σημειώσεις';

  @override
  String get bfPassphraseNotesBody =>
      '• Η φράση πρόσβασης κατακερματίζεται στη συσκευή με PBKDF2-SHA256· δεν αποθηκεύεται ποτέ σε απλό κείμενο.\n• 10 λανθασμένες προσπάθειες επαναφέρουν τη συσκευή στις εργοστασιακές ρυθμίσεις· όλες οι συνδέσεις και τα δεδομένα διαγράφονται.\n• Μια συσκευή συνδεδεμένη μέσω USB παρακάμπτει την ερώτηση φράσης πρόσβασης, η φυσική πρόσβαση παρέχει ήδη εργοστασιακή επαναφορά μέσω του κουμπιού.';

  @override
  String bfBondListTitle(int used, int capacity) {
    return 'Συζευγμένα SKAPP  ($used/$capacity)';
  }

  @override
  String get bfBondListEmpty => 'Δεν υπάρχουν συζευγμένα peers ακόμη.';

  @override
  String get bfBondListBadgeThisPhone => 'Αυτό το τηλέφωνο';

  @override
  String get bfBondListBadgeActiveSession => 'Ενεργή συνεδρία';

  @override
  String bfBondListRowSubtitle(String shortPid, String date) {
    return '#$shortPid · συζεύχθηκε: $date';
  }

  @override
  String get bfBondListRemoveTooltip => 'Αφαίρεση αυτού του peer';

  @override
  String get bfBondListRemoveTitle => 'Αφαίρεση peer;';

  @override
  String get bfBondListRemoveSelfBody =>
      'Αφαιρείτε τη σύνδεση αυτού του τηλεφώνου. Αν επιβεβαιώσετε, η συνεδρία διακόπτεται· για να προσεγγίσετε ξανά τη συσκευή θα χρειαστεί να πατήσετε σύντομα το κουμπί και να συζεύξετε εκ νέου.';

  @override
  String bfBondListRemoveOtherBody(String label, int slot) {
    return 'Το «$label» (υποδοχή $slot) διαγράφεται από τη συσκευή. Αυτό το SKAPP πρέπει να πατήσει σύντομα το κουμπί και να συζευχθεί ξανά για επανασύνδεση.';
  }

  @override
  String bfBondListSlotRemoved(int slot) {
    return 'Η υποδοχή $slot αφαιρέθηκε';
  }

  @override
  String bfBondListFetchError(String error) {
    return 'Το bond.list απέτυχε: $error';
  }

  @override
  String get bfSettingsSectionSecurity => 'ΑΣΦΑΛΕΙΑ';

  @override
  String get bfSettingsPassphraseTitle => 'Φράση πρόσβασης συσκευής';

  @override
  String get bfSettingsBondListTitle => 'Συζευγμένα SKAPP';

  @override
  String get bfSettingsPassphraseSubtitleAlways => 'Ενεργή, κάθε σύνδεση';

  @override
  String get bfSettingsPassphraseSubtitlePairing => 'Ενεργή, κατά τη σύζευξη';

  @override
  String get bfSettingsPassphraseSubtitleOff => 'Ενεργή, επιβολή ανενεργή';

  @override
  String bfSettingsBondsSubtitle(int count, int capacity) {
    return 'Συζευγμένα peers: $count / $capacity';
  }

  @override
  String get skapiHowItWorksTitle => 'Πώς λειτουργεί';

  @override
  String skapiHowItWorksBody(String deviceName) {
    return 'Όταν η συσκευή SmartKraft σας (για παράδειγμα το $deviceName) βιώσει ένα συμβάν όπως η λήξη ενός χρονομέτρου, ένα πάτημα κουμπιού ή ένα trigger αισθητήρα, στέλνει μια μικρή εντολή στον υπολογιστή σας. Ο υπολογιστής σας λαμβάνει αυτή την εντολή και εκτελεί το script που έχετε επιλέξει.';
  }

  @override
  String get skapiHowItWorksFlowDeviceLabel => 'Συσκευή SmartKraft';

  @override
  String get skapiHowItWorksFlowDeviceSub =>
      'π.χ. Blocking Focus, ενεργοποιεί ένα συμβάν';

  @override
  String get skapiHowItWorksFlowComputerLabel => 'Υπολογιστής';

  @override
  String get skapiHowItWorksFlowComputerSub =>
      'Το SKAPP λαμβάνει την εντολή, το script εκτελείται';

  @override
  String get skapiHowItWorksFoot =>
      'Το SKAPP πρέπει να εκτελείται στον υπολογιστή σας. Όλη η κίνηση παραμένει στο δίκτυο WiFi, δεν απαιτείται σύνδεση στο διαδίκτυο, και κανένα δεδομένο δεν φεύγει από το σπίτι σας.';

  @override
  String get skapiPlatformGroupsHeader => 'Κατηγορίες ενεργειών';

  @override
  String skapiPlatformGroupsLoadError(String error) {
    return 'Αποτυχία φόρτωσης ομάδων: $error';
  }

  @override
  String get skapiPlatformEmptyTitle => 'Δεν υπάρχουν scripts εδώ ακόμη';

  @override
  String get skapiPlatformEmptyBody =>
      'Τα scripts για αυτή την πλατφόρμα είναι ακόμη καθ\' οδόν. Ελέγξτε ξανά μετά την επόμενη ενημέρωση του SKAPP.';

  @override
  String skapiGroupScriptsLoadError(String error) {
    return 'Αποτυχία φόρτωσης scripts: $error';
  }

  @override
  String skapiScriptDetailLoadError(String error) {
    return 'Δεν ήταν δυνατή η φόρτωση αυτού του script: $error';
  }

  @override
  String get skapiBindScreenTitle => 'Σύνδεση σε ενέργεια';

  @override
  String get skapiBindScreenSubtitle =>
      'Εκτελέστε αυτό το script αυτόματα όταν ενεργοποιείται ένα συμβάν συσκευής.';

  @override
  String get skapiBindFieldDeviceLabel => 'Συσκευή';

  @override
  String get skapiBindFieldDeviceHint =>
      'Επιλέξτε ποια συζευγμένη συσκευή θα ενεργοποιεί αυτό το script.';

  @override
  String get skapiBindFieldDeviceEmpty =>
      'Δεν υπάρχουν συζευγμένες συσκευές ακόμη. Συζεύξτε μία από την καρτέλα Συσκευές πρώτα.';

  @override
  String get skapiBindFieldEventLabel => 'Συμβάν';

  @override
  String get skapiBindFieldEventHint =>
      'Η συσκευή εκπέμπει αυτό το συμβάν· το script εκτελείται όταν συμβεί.';

  @override
  String get skapiBindEventTimerStarted => 'Έναρξη χρονομέτρου';

  @override
  String get skapiBindEventTimerExpired => 'Λήξη χρονομέτρου';

  @override
  String get skapiBindEventFaceChanged => 'Αλλαγή όψης κύβου';

  @override
  String get skapiBindEventButtonPressed => 'Πάτημα κουμπιού';

  @override
  String get skapiBindEventButtonHeld => 'Παρατεταμένο πάτημα κουμπιού';

  @override
  String get skapiBindEventBatteryLow => 'Χαμηλή μπαταρία';

  @override
  String get skapiBindEventBatteryLockout => 'Κλείδωμα μπαταρίας';

  @override
  String get skapiBindEventPowerStateChanged => 'Αλλαγή κατάστασης ισχύος';

  @override
  String get skapiBindEventPairingSuccess => 'Επιτυχής σύζευξη';

  @override
  String get skapiBindEventApiSent => 'Αποστολή κλήσης API';

  @override
  String get skapiBindParamsHeader => 'Παρακάμψεις παραμέτρων';

  @override
  String get skapiBindParamsHint =>
      'Αφήστε κενό για να διατηρήσετε τις προεπιλογές του script. Αυτές οι τιμές στέλνονται κάθε φορά που ενεργοποιείται η σύνδεση.';

  @override
  String get skapiBindButtonSave => 'Αποθήκευση σύνδεσης';

  @override
  String get skapiBindButtonDelete => 'Διαγραφή σύνδεσης';

  @override
  String get skapiBindButtonCancel => 'Άκυρο';

  @override
  String get skapiBindButtonEnable => 'Ενεργοποίηση';

  @override
  String get skapiBindButtonDisable => 'Απενεργοποίηση';

  @override
  String get skapiBindStatusEnabled => 'Ενεργή';

  @override
  String get skapiBindStatusDisabled => 'Σε παύση';

  @override
  String get skapiBindSavedToast => 'Η σύνδεση αποθηκεύτηκε';

  @override
  String get skapiBindDeletedToast => 'Η σύνδεση αφαιρέθηκε';

  @override
  String skapiBindBadgeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count συνδέσεις',
      one: '1 σύνδεση',
    );
    return '$_temp0';
  }

  @override
  String get skapiBindNoPairedDeviceWarning =>
      'Συζεύξτε πρώτα μια συσκευή για να δημιουργήσετε συνδέσεις.';

  @override
  String skapiBindTriggeredDesktopToast(String script) {
    return 'Ενεργοποιήθηκε: $script';
  }

  @override
  String skapiBindTriggeredMobileToast(String event) {
    return 'Η σύνδεση ενεργοποιήθηκε ($event)· η εκτέλεση έρχεται στη Φάση K.';
  }

  @override
  String skapiBindLoadError(String error) {
    return 'Δεν ήταν δυνατή η φόρτωση των συνδέσεων: $error';
  }

  @override
  String get skapiBindListSectionTitle => 'Συνδέσεις σε αυτό το script';

  @override
  String get skapiBindListEmpty =>
      'Δεν υπάρχουν συνδέσεις ακόμη. Πατήστε Σύνδεση σε ενέργεια για να δημιουργήσετε μία.';

  @override
  String get skapiBindNewButton => 'Νέα σύνδεση';

  @override
  String get skapiBasicSettingsTitle => 'Ρυθμίσεις';

  @override
  String get skapiBasicEmptyParams =>
      'Αυτό το script δεν χρειάζεται ρυθμίσεις. Πατήστε Εκτέλεση τώρα.';

  @override
  String get skapiBasicUnitSeconds => 'δευτερόλεπτα';

  @override
  String get skapiBasicConvHalfMinute => 'μισό λεπτό';

  @override
  String get skapiBasicConvLessThanMinute => 'λιγότερο από ένα λεπτό';

  @override
  String skapiBasicConvMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count λεπτά',
      one: '1 λεπτό',
    );
    return '$_temp0';
  }

  @override
  String skapiBasicConvHoursMinutes(int hours, int minutes) {
    return '$hours ώ $minutes λεπτά';
  }

  @override
  String skapiBasicConvHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ώρες',
      one: '1 ώρα',
    );
    return '$_temp0';
  }

  @override
  String get skapiBasicConvImmediate => 'ξεκινά αμέσως';

  @override
  String skapiBasicConvAfter(String time) {
    return 'μετά από $time';
  }

  @override
  String get skapiBasicPrerunSectionTitle => 'Καθυστέρηση πριν την εκτέλεση';

  @override
  String get skapiBasicPrerunAddCta =>
      'Προσθήκη καθυστέρησης πριν την εκτέλεση';

  @override
  String get skapiBasicPrerunLabel =>
      'Αναμονή τόσων δευτερολέπτων πριν ξεκινήσει το script';

  @override
  String get skapiBasicPrerunHelp =>
      'Χρήσιμο για να εμφανιστεί πρώτα μια ειδοποίηση, ή για αλυσιδωτές ενέργειες. Η προεπιλογή 0 σημαίνει άμεση έναρξη.';

  @override
  String get skapiBasicPrerunRemove => 'Αφαίρεση καθυστέρησης';

  @override
  String get skapiBasicListAddPlaceholder => '+ προσθήκη';

  @override
  String get skapiRunSheetTitle => 'Εκτέλεση script';

  @override
  String get skapiRunSheetStatusRunning => 'Εκτελείται';

  @override
  String get skapiRunSheetStatusOk => 'Ολοκληρώθηκε';

  @override
  String get skapiRunSheetStatusError => 'Απέτυχε';

  @override
  String skapiRunSheetExitCode(int code) {
    return 'Κωδικός εξόδου: $code';
  }

  @override
  String get skapiRunSheetCancel => 'Άκυρο';

  @override
  String get skapiRunSheetClose => 'Κλείσιμο';

  @override
  String get skapiRunSheetCopyOutput => 'Αντιγραφή εξόδου';

  @override
  String get skapiRunSheetCopiedDone => 'Αντιγράφηκε';

  @override
  String get skapiRunSheetEmptyOutput => 'Αναμονή για έξοδο...';

  @override
  String get skapiRunSheetDismissConfirmTitle => 'Διακοπή εκτέλεσης script;';

  @override
  String get skapiRunSheetDismissConfirmBody =>
      'Το script εκτελείται ακόμη. Κλείνοντας αυτό το φύλλο θα ακυρωθεί.';

  @override
  String get skapiRunSheetDismissConfirmStay => 'Συνέχιση εκτέλεσης';

  @override
  String get skapiRunSheetDismissConfirmStop => 'Άκυρο';

  @override
  String get skapiRunErrorPowerShellMissing =>
      'Το PowerShell δεν βρέθηκε σε αυτό το σύστημα.';

  @override
  String skapiRunErrorTempWrite(String error) {
    return 'Δεν ήταν δυνατή η εγγραφή του script στον προσωρινό φάκελο: $error';
  }

  @override
  String skapiRunErrorSpawn(String error) {
    return 'Δεν ήταν δυνατή η εκκίνηση του PowerShell: $error';
  }

  @override
  String skapiRunDurationMs(int ms) {
    return 'Διήρκεσε $ms ms';
  }

  @override
  String get skapiCopiedToClipboard => 'Αντιγράφηκε';

  @override
  String get skapiFavouriteAddTooltip => 'Προσθήκη στα αγαπημένα';

  @override
  String get skapiFavouriteRemoveTooltip => 'Αφαίρεση από τα αγαπημένα';

  @override
  String skapiGroupAppBarSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count scripts',
      one: '1 script',
    );
    return '$_temp0';
  }

  @override
  String get skapiPlatformScreenCategoriesTitle => 'Κατηγορίες ενεργειών';

  @override
  String skapiPlatformScreenCategoriesSub(int groups, int scripts) {
    return '$groups ομάδες · $scripts scripts συνολικά';
  }

  @override
  String get skapiGroupScriptsHeader => 'Scripts';

  @override
  String skapiGroupScriptsCount(int count) {
    return '$count scripts';
  }

  @override
  String skapiGroupItemCount(int count) {
    return '$count scripts';
  }

  @override
  String get skapiGroupPowerTitle => 'Διαχείριση ισχύος';

  @override
  String get skapiGroupPowerDesc =>
      'Τα scripts σε αυτή την ομάδα κλειδώνουν, βάζουν σε αναστολή, αδρανοποιούν ή απενεργοποιούν τον υπολογιστή. Είναι χρήσιμα όταν μια συσκευή SmartKraft σηματοδοτεί το τέλος μιας συνεδρίας εστίασης ή ανιχνεύει παρατεταμένη αδράνεια και θέλετε ο υπολογιστής να ακολουθήσει.';

  @override
  String get skapiGroupPowerFoot =>
      'Τυπική χρήση: κλείδωμα όταν σηκώνεστε, αδρανοποίηση στο τέλος της ημέρας, προγραμματισμένη απενεργοποίηση μετά από μεγάλη περίοδο αδράνειας.';

  @override
  String get skapiScriptLockTitle => 'Κλείδωμα σταθμού εργασίας';

  @override
  String get skapiScriptLockSummaryWhat =>
      'Κλειδώνει τα Windows αμέσως και επιστρέφει στην οθόνη σύνδεσης. Οι ανοιχτές εφαρμογές συνεχίζουν να εκτελούνται.';

  @override
  String get skapiScriptLockSummaryHow =>
      'Καλεί τη συνάρτηση Win32 LockWorkStation του user32. Ισοδύναμο με το πάτημα Win+L.';

  @override
  String get skapiScriptHibernateTitle => 'Αδρανοποίηση';

  @override
  String get skapiScriptHibernateSummaryWhat =>
      'Αποθηκεύει την τρέχουσα συνεδρία στον δίσκο και απενεργοποιεί τον υπολογιστή. Η επαναφορά επιστρέφει εκεί που σταματήσατε, ακόμη και χωρίς μπαταρία.';

  @override
  String get skapiScriptHibernateSummaryHow =>
      'Εκτελεί το ενσωματωμένο shutdown.exe με τη σημαία /h. Η αδρανοποίηση πρέπει να είναι ενεργοποιημένη στις ρυθμίσεις ισχύος των Windows· αν δεν είναι, τα Windows μεταβαίνουν σε αναστολή.';

  @override
  String get skapiScriptHibernateNote =>
      'Εκτελέστε powercfg /hibernate on μία φορά από κέλυφος διαχειριστή αν λείπει η αδρανοποίηση από το σύστημά σας.';

  @override
  String get skapiScriptHibernateParamDelayLabel => 'delay';

  @override
  String get skapiScriptHibernateParamDelayHint =>
      'Δευτερόλεπτα αναμονής πριν την αδρανοποίηση, σε περίπτωση που πρέπει να εμφανιστεί πρώτα η ειδοποίηση της συσκευής.';

  @override
  String get skapiScriptSleepTitle => 'Αναστολή';

  @override
  String get skapiScriptSleepSummaryWhat =>
      'Θέτει τον υπολογιστή σε αναστολή στη RAM (S3). Η επαναφορά είναι γρήγορη αλλά καταναλώνει μικρή ποσότητα μπαταρίας κατά την αναστολή.';

  @override
  String get skapiScriptSleepSummaryHow =>
      'Καλεί το System.Windows.Forms.Application.SetSuspendState με PowerState.Suspend. Το λειτουργικό σύστημα μπορεί να καθυστερήσει αν μια διεργασία στο προσκήνιο εμποδίζει τις μεταβάσεις αδράνειας.';

  @override
  String get skapiScriptSleepParamDelayLabel => 'delay';

  @override
  String get skapiScriptSleepParamDelayHint =>
      'Δευτερόλεπτα αναμονής πριν την αναστολή.';

  @override
  String get skapiScriptShutdownTitle => 'Απενεργοποίηση';

  @override
  String get skapiScriptShutdownSummaryWhat =>
      'Ξεκινά μια ομαλή απενεργοποίηση των Windows. Ζητείται από τις ανοιχτές εφαρμογές να αποθηκεύσουν και να κλείσουν.';

  @override
  String get skapiScriptShutdownSummaryHow =>
      'Εκτελεί το ενσωματωμένο shutdown.exe /s. Με ενεργοποιημένη την εξαναγκαστική λειτουργία, προστίθεται το /f ώστε οι εφαρμογές που δεν αποκρίνονται να τερματιστούν.';

  @override
  String get skapiScriptShutdownNote =>
      'Μια μη μηδενική καθυστέρηση δίνει στον χρήστη χρόνο να ακυρώσει μέσω shutdown /a από ένα τερματικό.';

  @override
  String get skapiScriptShutdownParamDelayLabel => 'delay';

  @override
  String get skapiScriptShutdownParamDelayHint =>
      'Δευτερόλεπτα που περιμένουν τα Windows πριν την απενεργοποίηση. Το 30 είναι η προεπιλογή· επιλέξτε 0 για άμεση απενεργοποίηση.';

  @override
  String get skapiScriptShutdownParamForceLabel => 'force';

  @override
  String get skapiScriptShutdownParamForceHint =>
      'Κλείνει εφαρμογές που δεν αποκρίνονται στο σήμα απενεργοποίησης. Μη αποθηκευμένη εργασία σε αυτές τις εφαρμογές μπορεί να χαθεί.';

  @override
  String get skapiGroupDisplayAudioTitle => 'Οθόνη, Εικόνα & Ήχος';

  @override
  String get skapiGroupDisplayAudioDesc =>
      'Τα scripts σε αυτή την ομάδα ρυθμίζουν την οθόνη και την έξοδο ήχου: φωτεινότητα, ένταση, σίγαση και αναπαραγωγή πολυμέσων. Είναι χρήσιμα όταν μια συσκευή SmartKraft θέλει ο υπολογιστής να χαμηλώσει τη φωτεινότητα κατά τη διάρκεια ενός διαλείμματος εστίασης ή να σταματήσει τη μουσική όταν σηκώνεστε.';

  @override
  String get skapiGroupDisplayAudioFoot =>
      'Τυπική χρήση: χαμήλωμα οθόνης κατά τη διάρκεια ενός διαλείμματος, σίγαση κατά το κλείδωμα, παύση του Spotify όταν μια συσκευή δεν ανιχνεύει δραστηριότητα.';

  @override
  String get skapiScriptBrightnessTitle => 'Ρύθμιση φωτεινότητας';

  @override
  String get skapiScriptBrightnessSummaryWhat =>
      'Ρυθμίζει τη φωτεινότητα της εσωτερικής οθόνης σε ποσοστό μεταξύ 0 και 100.';

  @override
  String get skapiScriptBrightnessSummaryHow =>
      'Καλεί το WmiMonitorBrightnessMethods.WmiSetBrightness του WMI με το ζητούμενο επίπεδο. Αποκρίνονται μόνο φορητοί, tablet και ενσωματωμένες οθόνες· εξωτερικές οθόνες DDC/CI δεν υποστηρίζονται σε αυτή τη διαδρομή.';

  @override
  String get skapiScriptBrightnessNote =>
      'Οι εξωτερικές οθόνες δεν θα αλλάξουν. Για διατάξεις πολλαπλών οθονών, αντιδρά μόνο η οθόνη που αναφέρει φωτεινότητα μέσω WMI.';

  @override
  String get skapiScriptBrightnessParamLevelLabel => 'level';

  @override
  String get skapiScriptBrightnessParamLevelHint =>
      'Ποσοστό φωτεινότητας (0-100). Χαμηλότερες τιμές είναι πιο σκούρες. Το 70 είναι μια άνετη προεπιλογή σε κανονικό φωτισμό.';

  @override
  String get skapiScriptBrightnessParamTimeoutLabel => 'timeout';

  @override
  String get skapiScriptBrightnessParamTimeoutHint =>
      'Δευτερόλεπτα που επιτρέπεται να διαρκέσει η αλλαγή φωτεινότητας. Το λειτουργικό σύστημα μεταβάλλει ομαλά εντός αυτού του παραθύρου.';

  @override
  String get skapiScriptMuteToggleTitle => 'Εναλλαγή σίγασης';

  @override
  String get skapiScriptMuteToggleSummaryWhat =>
      'Εναλλάσσει την κύρια σίγαση του συστήματος. Τα ενεργά πολυμέσα συνεχίζουν να αναπαράγονται αλλά δεν τα ακούτε.';

  @override
  String get skapiScriptMuteToggleSummaryHow =>
      'Στέλνει το εικονικό πλήκτρο VK_VOLUME_MUTE, την ίδια διαδρομή που χρησιμοποιούν τα Windows όταν ο χρήστης πατά το πλήκτρο σίγασης στο πληκτρολόγιο. Χωρίς εξάρτηση από διαχειριστή ή COM.';

  @override
  String get skapiScriptMuteToggleParamModeLabel => 'mode';

  @override
  String get skapiScriptMuteToggleParamModeHint =>
      'toggle / on / off. Μόνο το toggle επιβάλλεται μέσω του απλού πατήματος πλήκτρου· τα on και off γίνονται δεκτά για μελλοντική συμβατότητα.';

  @override
  String get skapiScriptVolumeSetTitle => 'Ρύθμιση έντασης';

  @override
  String get skapiScriptVolumeSetSummaryWhat =>
      'Ρυθμίζει την κύρια ένταση του συστήματος σε ακριβές επίπεδο μεταξύ 0 και 100.';

  @override
  String get skapiScriptVolumeSetSummaryHow =>
      'Καλεί το Core Audio IAudioEndpointVolume.SetMasterVolumeLevelScalar μέσω inline C# COM interop. Στοχεύει το προεπιλεγμένο endpoint απόδοσης.';

  @override
  String get skapiScriptVolumeSetNote =>
      'Tier 2: λειτουργεί σε τυπικούς επιτραπέζιους Windows 10/11. Απλουστευμένες εγκαταστάσεις μπορεί να μην εκθέτουν τη διεπαφή COM· τα endpoints ανά εφαρμογή δεν αντιμετωπίζονται από αυτή τη διαδρομή.';

  @override
  String get skapiScriptVolumeSetParamLevelLabel => 'level';

  @override
  String get skapiScriptVolumeSetParamLevelHint =>
      'Ποσοστό έντασης (0-100). Το 0 σιγά χωρίς να ορίζει σίγαση· το 50 είναι μια άνετη προεπιλογή.';

  @override
  String get skapiScriptMediaKeyTitle => 'Πλήκτρο πολυμέσων';

  @override
  String get skapiScriptMediaKeySummaryWhat =>
      'Προσομοιώνει το πάτημα ενός πλήκτρου πολυμέσων: αναπαραγωγή-παύση, επόμενο, προηγούμενο ή διακοπή. Μεταβαίνει σε όποια εφαρμογή κατέχει αυτή τη στιγμή τη συνεδρία πολυμέσων.';

  @override
  String get skapiScriptMediaKeySummaryHow =>
      'Στέλνει VK_MEDIA_PLAY_PAUSE / VK_MEDIA_NEXT_TRACK / VK_MEDIA_PREV_TRACK / VK_MEDIA_STOP μέσω keybd_event. Τα Windows δρομολογούν το πάτημα μέσω των System Media Transport Controls.';

  @override
  String get skapiScriptMediaKeyNote =>
      'Tier 2: χρειάζεται μια ενεργή συνεδρία πολυμέσων. Αν καμία εφαρμογή δεν αναπαράγει ή η εφαρμογή στο προσκήνιο δεν καταχωρείται στο SMTC, το πάτημα απορρίπτεται σιωπηλά.';

  @override
  String get skapiScriptMediaKeyParamKeyLabel => 'key';

  @override
  String get skapiScriptMediaKeyParamKeyHint =>
      'play-pause / next / previous / stop. Προεπιλογή είναι το play-pause.';

  @override
  String get skapiGroupWindowAppTitle => 'Παράθυρο & Εφαρμογή';

  @override
  String get skapiGroupWindowAppDesc =>
      'Τα scripts σε αυτή την ομάδα ελέγχουν παράθυρα και εφαρμογές: ελαχιστοποίηση, εστίαση, ομαλό κλείσιμο ή απευθείας τερματισμό διεργασιών. Κρατούν τον χώρο εργασίας σας τακτοποιημένο όταν μια συσκευή SmartKraft θέλει ο υπολογιστής να αλλάξει πλαίσιο.';

  @override
  String get skapiGroupWindowAppFoot =>
      'Τυπική χρήση: ελαχιστοποίηση όλων όταν ξεκινά μια συνεδρία εστίασης, κλείσιμο του προγράμματος περιήγησης όταν τελειώνει η εργασία, τερματισμός μιας κολλημένης εφαρμογής κατ\' απαίτηση.';

  @override
  String get skapiScriptMinimizeWindowTitle => 'Ελαχιστοποίηση παραθύρου';

  @override
  String get skapiScriptMinimizeWindowSummaryWhat =>
      'Ελαχιστοποιεί ένα συγκεκριμένο παράθυρο βάσει ονόματος διεργασίας. Κενό όνομα διεργασίας στοχεύει το παράθυρο που έχει αυτή τη στιγμή την εστίαση.';

  @override
  String get skapiScriptMinimizeWindowSummaryHow =>
      'Επιλύει το πρώτο κύριο παράθυρο που ταιριάζει μέσω Get-Process και καλεί το ShowWindow του user32 με SW_MINIMIZE.';

  @override
  String get skapiScriptMinimizeWindowNote =>
      'Αν εκτελούνται πολλαπλά στιγμιότυπα, ελαχιστοποιείται μόνο το πρώτο παράθυρο που ταιριάζει. Χρησιμοποιήστε το όνομα διεργασίας χωρίς την κατάληξη .exe.';

  @override
  String get skapiScriptMinimizeWindowParamProcessLabel => 'processName';

  @override
  String get skapiScriptMinimizeWindowParamProcessHint =>
      'Όνομα διεργασίας χωρίς .exe (chrome, code, winword). Κενό στοχεύει το παράθυρο στο προσκήνιο.';

  @override
  String get skapiScriptCloseWindowTitle => 'Κλείσιμο παραθύρου';

  @override
  String get skapiScriptCloseWindowSummaryWhat =>
      'Στέλνει ένα ομαλό κλείσιμο σε ένα παράθυρο ώστε η εφαρμογή να μπορεί να εμφανίσει το δικό της παράθυρο διαλόγου «αποθήκευση αλλαγών;».';

  @override
  String get skapiScriptCloseWindowSummaryHow =>
      'Δημοσιεύει WM_CLOSE μέσω του SendMessage του user32. Ίδιο αποτέλεσμα με το πάτημα του κουμπιού X από τον χρήστη. Κενό όνομα διεργασίας στοχεύει το παράθυρο στο προσκήνιο.';

  @override
  String get skapiScriptCloseWindowNote =>
      'Οι εφαρμογές με μη αποθηκευμένη εργασία θα εμφανίσουν το δικό τους παράθυρο διαλόγου. Το script δεν περιμένει ούτε τερματίζει κολλημένες εφαρμογές.';

  @override
  String get skapiScriptCloseWindowParamProcessLabel => 'processName';

  @override
  String get skapiScriptCloseWindowParamProcessHint =>
      'Όνομα διεργασίας χωρίς .exe. Κενό στοχεύει το παράθυρο στο προσκήνιο.';

  @override
  String get skapiScriptKillAppTitle => 'Εξαναγκαστικός τερματισμός εφαρμογής';

  @override
  String get skapiScriptKillAppSummaryWhat =>
      'Τερματίζει κάθε στιγμιότυπο μιας διεργασίας. Δοκιμάζει πρώτα WM_CLOSE, και μετά TerminateProcess αν η εφαρμογή είναι ακόμη ενεργή μετά τη λήξη χρόνου.';

  @override
  String get skapiScriptKillAppSummaryHow =>
      'Στέλνει WM_CLOSE σε κάθε κύριο παράθυρο, περιμένει τη ρυθμισμένη λήξη χρόνου, και μετά εκτελεί Stop-Process με -Force σε ό,τι εκτελείται ακόμη.';

  @override
  String get skapiScriptKillAppNote =>
      'Μη αποθηκευμένη εργασία σε εφαρμογές που δεν αποκρίνονται θα χαθεί κατά τον εξαναγκαστικό τερματισμό. Χρησιμοποιήστε το preKillSave για εφαρμογές τύπου επεξεργαστή που αποκρίνονται στο Ctrl+S.';

  @override
  String get skapiScriptKillAppParamProcessLabel => 'processName';

  @override
  String get skapiScriptKillAppParamProcessHint =>
      'Όνομα διεργασίας χωρίς .exe. Όλα τα εκτελούμενα στιγμιότυπα τερματίζονται.';

  @override
  String get skapiScriptKillAppParamTimeoutLabel => 'timeout';

  @override
  String get skapiScriptKillAppParamTimeoutHint =>
      'Δευτερόλεπτα αναμονής μεταξύ WM_CLOSE και εξαναγκαστικού τερματισμού. Υψηλότερες τιμές δίνουν στην εφαρμογή περισσότερο χρόνο για αποθήκευση.';

  @override
  String get skapiScriptKillAppParamPreKillSaveLabel => 'preKillSave';

  @override
  String get skapiScriptKillAppParamPreKillSaveHint =>
      'Στέλνει Ctrl+S στο παράθυρο στο προσκήνιο πριν το κλείσιμο. Χρήσιμο για επεξεργαστές αλλά χωρίς αποτέλεσμα σε εφαρμογές που αγνοούν το Ctrl+S.';

  @override
  String get skapiScriptLaunchAppTitle => 'Εκκίνηση εφαρμογής';

  @override
  String get skapiScriptLaunchAppSummaryWhat =>
      'Εκκινεί ένα εκτελέσιμο, ανοίγει ένα URL ή εκκινεί ένα έγγραφο με τον προεπιλεγμένο χειριστή.';

  @override
  String get skapiScriptLaunchAppSummaryHow =>
      'Καλεί το PowerShell Start-Process με τη διαδρομή και προαιρετική λίστα ορισμάτων. Η διαδρομή μπορεί να είναι ένα .exe, μια πλήρης διαδρομή αρχείου ή ένα URL.';

  @override
  String get skapiScriptLaunchAppNote =>
      'Οι διαδρομές με κενά γίνονται δεκτές. Χρησιμοποιήστε ένα URL όπως https://example.com για να ανοίξετε το προεπιλεγμένο πρόγραμμα περιήγησης.';

  @override
  String get skapiScriptLaunchAppParamPathLabel => 'path';

  @override
  String get skapiScriptLaunchAppParamPathHint =>
      'Εκτελέσιμο, πλήρης διαδρομή αρχείου ή URL. notepad / C:\\\\tools\\\\my.exe / https://example.com.';

  @override
  String get skapiScriptLaunchAppParamArgsLabel => 'args';

  @override
  String get skapiScriptLaunchAppParamArgsHint =>
      'Ορίσματα που περνούν στο εκτελέσιμο. Κενό για κανένα.';

  @override
  String get skappListenerCardTitle => 'SKAPP HTTP Listener';

  @override
  String skappListenerCardSubtitleRunning(int port) {
    return 'Εκτελείται στη θύρα $port';
  }

  @override
  String get skappListenerCardSubtitleStopped => 'Σταματημένος';

  @override
  String get skappListenerCardSubtitleUnsupported =>
      'Αυτή η πλατφόρμα δεν μπορεί να φιλοξενήσει τον listener.';

  @override
  String get skappListenerCardEnableSwitch => 'Ενεργοποίηση listener';

  @override
  String get skappListenerCardSecurityNote =>
      'Ο listener δέχεται συνδέσεις μόνο στο τοπικό σας δίκτυο και απαιτεί το bearer token. Απλό HTTP, μην το εκθέσετε στο δημόσιο διαδίκτυο.';

  @override
  String get settingsLanVisibleTitle => 'Ορατό στο LAN';

  @override
  String get settingsLanVisibleSubtitle =>
      'Όταν είναι ανενεργό, ο listener συνδέεται μόνο στο localhost. Οι συζευγμένες συσκευές BF δεν μπορούν να προσεγγίσουν αυτόν τον υπολογιστή.';

  @override
  String get settingsLanVisibleWarnBfBreaks =>
      'Η απενεργοποίηση αυτού διακόπτει την αλυσίδα webhook του BF. Χρησιμοποιήστε το μόνο σε αξιόπιστο ή δοκιμαστικό περιβάλλον.';

  @override
  String get settingsLanVisibleAutoReopenedSnack =>
      'Η ορατότητα LAN ενεργοποιήθηκε ξανά ώστε οι συσκευές BF να μπορούν να προσεγγίσουν αυτόν τον υπολογιστή.';

  @override
  String get skapiRunRemoteDeveloperModeDisabled =>
      'Ο υπολογιστής-στόχος έχει απενεργοποιημένη τη Λειτουργία προγραμματιστή, οπότε η απομακρυσμένη εκτέλεση scripts είναι ανενεργή εκεί.';

  @override
  String get skappPeerPairingManualUuidConfirmLabel =>
      'Κωδικός επιβεβαίωσης (τελευταία 4 του UUID)';

  @override
  String get skappPeerPairingManualUuidConfirmHint =>
      'Διαβάστε τον τετραψήφιο κωδικό που εμφανίζεται στην οθόνη σύζευξης του υπολογιστή.';

  @override
  String get skappPeerPairingManualUuidConfirmError =>
      'Ο κωδικός δεν ταιριάζει με τα τελευταία 4 του UUID. Ελέγξτε την οθόνη του υπολογιστή.';

  @override
  String get skappListenerCardUuidLast4Label => 'Κωδικός επιβεβαίωσης σύζευξης';

  @override
  String get skappListenerCardUuidLast4Hint =>
      'Πληκτρολογήστε αυτούς τους 4 χαρακτήρες στην οθόνη χειροκίνητης σύζευξης του τηλεφώνου.';

  @override
  String get settingsPeerTokensTitle => 'Εκδοθέντα tokens peer';

  @override
  String get settingsPeerTokensSubtitle =>
      'Peers κινητών που είναι συζευγμένα με αυτόν τον υπολογιστή. Ανακαλέστε οποιαδήποτε καταχώριση για να την αποσυνδέσετε χωρίς να επηρεάσετε τις υπόλοιπες.';

  @override
  String get settingsPeerTokensEmpty => 'Δεν υπάρχουν συζευγμένα peers ακόμη.';

  @override
  String settingsPeerTokensIssuedAt(String when) {
    return 'Συζεύχθηκε $when';
  }

  @override
  String settingsPeerTokensLastUsed(String when) {
    return 'Τελευταία χρήση $when';
  }

  @override
  String get settingsPeerTokensRevokeButton => 'Ανάκληση';

  @override
  String get settingsPeerTokensRevokeConfirmTitle => 'Ανάκληση αυτού του peer;';

  @override
  String get settingsPeerTokensRevokeConfirmBody =>
      'Το peer θα αποσυνδεθεί αμέσως και πρέπει να συζευχθεί ξανά για να προσεγγίσει αυτόν τον υπολογιστή.';

  @override
  String get settingsPeerTokensRevokeConfirmCancel => 'Άκυρο';

  @override
  String get settingsPeerTokensRevokeConfirmAction => 'Ανάκληση';

  @override
  String settingsPeerTokensRevokedToast(String name) {
    return 'Το peer $name ανακλήθηκε';
  }

  @override
  String get skappListenerCardRotateCertButton => 'Εναλλαγή πιστοποιητικού TLS';

  @override
  String get skappListenerCardRotateCertConfirmTitle =>
      'Εναλλαγή πιστοποιητικού;';

  @override
  String get skappListenerCardRotateCertConfirmBody =>
      'Θα δημιουργηθεί ένα νέο αυτο-υπογεγραμμένο πιστοποιητικό TLS. Κάθε προηγουμένως συζευγμένο peer θα αποτυγχάνει στη χειραψία μέχρι να συζευχθεί ξανά.';

  @override
  String get skappListenerCardRotateCertConfirmCancel => 'Άκυρο';

  @override
  String get skappListenerCardRotateCertConfirmAction => 'Εναλλαγή';

  @override
  String get skappListenerCardRotateCertDoneSnack =>
      'Το πιστοποιητικό TLS εναλλάχθηκε. Συζεύξτε ξανά κάθε συσκευή.';

  @override
  String get skappListenerCardCertFingerprintLabel => 'Αποτύπωμα TLS';

  @override
  String skappListenerCardErrorPortInUse(int port) {
    return 'Η θύρα $port χρησιμοποιείται ήδη. Επιλέξτε διαφορετική θύρα από την Ταυτότητα δικτύου.';
  }

  @override
  String skappListenerCardErrorGeneric(String error) {
    return 'Δεν ήταν δυνατή η εκκίνηση του listener: $error';
  }

  @override
  String get skappPeerPairingTitle => 'Σύζευξη επιτραπέζιου SKAPP';

  @override
  String get skappPeerPairingSubtitle =>
      'Σαρώστε το QR που εμφανίζεται στις Ρυθμίσεις του επιτραπέζιου SKAPP, ή επικολλήστε τον κωδικό σύζευξης χειροκίνητα.';

  @override
  String get skappPeerPairingTabScan => 'Σάρωση QR';

  @override
  String get skappPeerPairingTabManual => 'Χειροκίνητα';

  @override
  String get skappPeerPairingScanHint =>
      'Στρέψτε την κάμερά σας στο QR που εμφανίζεται στο Επιτραπέζιο SKAPP > Ρυθμίσεις > SKAPP HTTP Listener.';

  @override
  String get skappPeerPairingScanCameraDeniedTitle =>
      'Απαιτείται άδεια κάμερας';

  @override
  String get skappPeerPairingScanCameraDeniedBody =>
      'Επιτρέψτε την πρόσβαση στην κάμερα από τις ρυθμίσεις του τηλεφώνου σας για να σαρώσετε το QR σύζευξης. Μπορείτε επίσης να εισαγάγετε τον κωδικό χειροκίνητα.';

  @override
  String get skappPeerPairingManualHostLabel =>
      'IP ή όνομα υπολογιστή επιτραπέζιου';

  @override
  String get skappPeerPairingManualPortLabel => 'Θύρα';

  @override
  String get skappPeerPairingManualTokenLabel => 'Bearer token';

  @override
  String get skappPeerPairingManualUuidLabel => 'UUID επιτραπέζιου';

  @override
  String get skappPeerPairingManualNameLabel => 'Εμφανιζόμενο όνομα';

  @override
  String get skappPeerPairingManualSubmit => 'Σύζευξη';

  @override
  String skappPeerPairingSavedToast(String name) {
    return 'Συζεύχθηκε με $name';
  }

  @override
  String skappPeerPairingFailedToast(String reason) {
    return 'Η σύζευξη απέτυχε: $reason';
  }

  @override
  String get skappPeerPairingShowQrTitle =>
      'Σύζευξη τηλεφώνου με αυτό το επιτραπέζιο';

  @override
  String get skappPeerPairingShowQrBody =>
      'Ανοίξτε το SKAPP στο τηλέφωνό σας, μεταβείτε σε SKAPI > Ρυθμίσεις > Σύζευξη επιτραπέζιου, και σαρώστε αυτό το QR. Το QR περιέχει το bearer token, αντιμετωπίστε το σαν κωδικό πρόσβασης.';

  @override
  String get skappPeerPairingShowQrCloseButton => 'Έγινε';

  @override
  String get skappPeerListEmpty =>
      'Δεν υπάρχει συζευγμένο επιτραπέζιο ακόμη. Συζεύξτε ένα για να εκτελείτε scripts από αυτό το τηλέφωνο.';

  @override
  String get skappPeerListSectionTitle => 'Συζευγμένα SKAPP επιτραπέζια';

  @override
  String get skappPeerStatusOnline => 'Συνδεδεμένο';

  @override
  String get skappPeerStatusOffline => 'Εκτός σύνδεσης';

  @override
  String skappPeerStatusLastSeen(String when) {
    return 'Τελευταία εμφάνιση $when';
  }

  @override
  String get skappPeerRemoveTooltip => 'Αφαίρεση συζευγμένου επιτραπέζιου';

  @override
  String get skappPeerRemoveConfirmTitle => 'Αφαίρεση σύζευξης;';

  @override
  String skappPeerRemoveConfirmBody(String name) {
    return 'Τα scripts που ενεργοποιούνται από αυτό το τηλέφωνο δεν θα εκτελούνται πλέον στο $name μέχρι να συζεύξετε ξανά.';
  }

  @override
  String get skappPeerScanRefreshTooltip => 'Ανανέωση λίστας peers';

  @override
  String skapiRunRemoteSheetTitle(String peerName) {
    return 'Απομακρυσμένη εκτέλεση στο $peerName';
  }

  @override
  String get skapiRunRemoteConnecting => 'Σύνδεση με το επιτραπέζιο...';

  @override
  String get skapiRunRemoteOfflineError =>
      'Το συζευγμένο επιτραπέζιο είναι εκτός σύνδεσης. Δοκιμάστε να ανανεώσετε τα peers ή ελέγξτε τον listener του επιτραπέζιου.';

  @override
  String get skapiRunRemoteUnauthorizedError =>
      'Το bearer token απορρίφθηκε. Το token του επιτραπέζιου μπορεί να έχει εναλλαχθεί. Συζεύξτε ξανά από τις Ρυθμίσεις.';

  @override
  String skapiRunRemoteHttpError(String reason) {
    return 'Η απομακρυσμένη εκτέλεση απέτυχε: $reason';
  }

  @override
  String get skapiRunMobileNoPeerTitle => 'Κανένα συζευγμένο επιτραπέζιο';

  @override
  String get skapiRunMobileNoPeerBody =>
      'Συζεύξτε ένα επιτραπέζιο SKAPP από τις Ρυθμίσεις για να εκτελείτε scripts από αυτό το τηλέφωνο.';

  @override
  String get skapiRunMobileNoPeerCta => 'Άνοιγμα ρυθμίσεων';

  @override
  String get skapiRunRemoteNotWhitelisted =>
      'Αυτό το script δεν είναι σημειωμένο ως εκτελέσιμο απομακρυσμένα. Εκτελέστε το απευθείας στο επιτραπέζιο.';

  @override
  String get skapiRunRemoteNoPeerHint =>
      'Συζεύξτε ένα επιτραπέζιο SKAPP από τις Ρυθμίσεις για να εκτελείτε scripts από αυτό το τηλέφωνο.';

  @override
  String get skapiRunRemoteNoPeerAction => 'Άνοιγμα ρυθμίσεων';

  @override
  String get skappPeerPickerTitle => 'Σε ποιον υπολογιστή να σταλεί;';

  @override
  String get skappPeerPickerSubtitle =>
      'Επιλέξτε το συζευγμένο επιτραπέζιο SKAPP που θα εκτελέσει αυτό το script.';

  @override
  String get skappPeerPickerOfflineReason => 'Εκτός σύνδεσης';

  @override
  String get skappPeerPickerDevModeOffReason =>
      'Η Λειτουργία προγραμματιστή είναι ανενεργή';

  @override
  String get skappPeerPickerEmpty =>
      'Δεν υπάρχουν συζευγμένα επιτραπέζια για επιλογή.';

  @override
  String get skapiRunRemoteCancelButton => 'Άκυρο';

  @override
  String get skapiRunRemoteCancelledNote => 'Η εκτέλεση ακυρώθηκε';

  @override
  String skapiRunRemoteTooManyRuns(int running, int limit) {
    return 'Αυτό το επιτραπέζιο εκτελεί ήδη $running scripts (μέγιστο $limit). Περιμένετε να ολοκληρωθεί ένα.';
  }

  @override
  String get skappPeerHealthDevModeBadge => 'Λειτ. προγρ.';

  @override
  String get remoteRunActivityCardTitle => 'Απομακρυσμένες εκτελέσεις';

  @override
  String get remoteRunActivityCardSubtitle =>
      'Πρόσφατες εκτελέσεις scripts που ζήτησαν συζευγμένα peers κινητών από αυτόν τον υπολογιστή.';

  @override
  String get remoteRunActivityCardEmpty =>
      'Δεν υπάρχουν απομακρυσμένες εκτελέσεις ακόμη.';

  @override
  String get remoteRunActivityCardClear => 'Εκκαθάριση ιστορικού';

  @override
  String remoteRunActivityRowOk(int exitCode, int durationMs) {
    return 'έξοδος $exitCode · $durationMs ms';
  }

  @override
  String get remoteRunActivityRowCancelled => 'ακυρώθηκε';

  @override
  String remoteRunActivityRowRejected(String reason) {
    return 'απορρίφθηκε · $reason';
  }

  @override
  String get mobileTriggerCardTitle => 'Ενεργοποίηση';

  @override
  String get mobileTriggerCardSubtitle =>
      'Στείλτε ένα συμβάν αφής σε ένα συζευγμένο επιτραπέζιο SKAPP. Οποιαδήποτε σύνδεση ακούει για αυτό το συμβάν θα εκτελέσει το script της σε εκείνο το επιτραπέζιο.';

  @override
  String get mobileTriggerCardSendButton => 'Αποστολή αφής';

  @override
  String get mobileTriggerCardSending => 'Αποστολή...';

  @override
  String mobileTriggerSentToast(String name) {
    return 'Η αφή στάλθηκε στο $name';
  }

  @override
  String get skapiBindEventMobileTap => 'Αφή κινητού';

  @override
  String get pairedDeviceMobileType => 'SKAPP Mobile';

  @override
  String skappPeersCardHeaderSinglePeer(String title, String name) {
    return '$title · $name';
  }

  @override
  String skappPeersCardHeaderMultiPeer(String title, int count) {
    return '$title · $count';
  }

  @override
  String get msHomeScreenTitle => 'Peer κινητού';

  @override
  String get msHomeScreenNotFound =>
      'Αυτό το peer κινητού δεν είναι πλέον συζευγμένο.';

  @override
  String get msHomeScreenEventsHeader => 'Διαθέσιμα συμβάντα';

  @override
  String msHomeScreenBindingsHeader(int count) {
    return 'Συνδέσεις ($count)';
  }

  @override
  String get msHomeScreenBindingsEmpty =>
      'Δεν υπάρχουν συνδέσεις ακόμη. Χρησιμοποιήστε SKAPI → script → Σύνδεση σε ενέργεια για να συνδέσετε ένα συμβάν αφής με ένα script.';

  @override
  String get msHomeScreenHint =>
      'Τα τηλέφωνα δεν εκτελούν scripts. Εκπέμπουν συμβάντα trigger που αυτό το επιτραπέζιο συνδέει με scripts.';

  @override
  String msHomeScreenPairedAt(String date) {
    return 'Συζεύχθηκε $date';
  }

  @override
  String get skapiGroupNotifyTitle => 'Ειδοποίηση & Διάλογος';

  @override
  String get skapiGroupNotifyDesc =>
      'Τα scripts σε αυτή την ομάδα μιλούν απευθείας στον χρήστη: εμφανίζουν ένα toast, ένα παράθυρο διαλόγου, ή περιμένουν μια απάντηση ναι/όχι. Χρησιμοποιήστε τα όταν το συμβάν μιας συσκευής SmartKraft χρειάζεται τον άνθρωπο μπροστά στην οθόνη να αναγνωρίσει ή να αποφασίσει.';

  @override
  String get skapiGroupNotifyFoot =>
      'Τυπική χρήση: διάλογος πριν από μια καταστροφική ενέργεια, toast για μια απαλή υπενθύμιση, διάλογος με λήξη χρόνου για αυτόματη συνέχιση.';

  @override
  String get skapiScriptDialogTitle => 'Εμφάνιση διαλόγου';

  @override
  String get skapiScriptDialogSummaryWhat =>
      'Εμφανίζει ένα modal παράθυρο μηνύματος των Windows και επιστρέφει την επιλογή του χρήστη (ok / cancel / yes / no / timeout).';

  @override
  String get skapiScriptDialogSummaryHow =>
      'Καλεί το System.Windows.Forms.MessageBox σε ένα θυγατρικό runspace ώστε το script να μπορεί να συναγωνιστεί τον διάλογο με μια προαιρετική λήξη χρόνου. Η επιλεγμένη τιμή γράφεται στο stdout για να διακλαδωθεί ο καλών.';

  @override
  String get skapiScriptDialogNote =>
      'Το stdout είναι η απάντηση του χρήστη με πεζά. timeout=0 περιμένει επ\' αόριστον.';

  @override
  String get skapiScriptDialogParamTitleLabel => 'title';

  @override
  String get skapiScriptDialogParamTitleHint =>
      'Τίτλος παραθύρου που εμφανίζεται στο πλαίσιο μηνύματος.';

  @override
  String get skapiScriptDialogParamBodyLabel => 'body';

  @override
  String get skapiScriptDialogParamBodyHint =>
      'Η ερώτηση ή το μήνυμα που εμφανίζεται στον χρήστη.';

  @override
  String get skapiScriptDialogParamButtonsLabel => 'buttons';

  @override
  String get skapiScriptDialogParamButtonsHint =>
      'ok / ok_cancel / yes_no / yes_no_cancel. Προεπιλογή ok_cancel.';

  @override
  String get skapiScriptDialogParamTimeoutLabel => 'timeout';

  @override
  String get skapiScriptDialogParamTimeoutHint =>
      'Δευτερόλεπτα αναμονής πριν τη συνέχιση με «timeout». Το 0 σημαίνει αναμονή για πάντα.';

  @override
  String get skapiScriptToastTitle => 'Εμφάνιση toast';

  @override
  String get skapiScriptToastSummaryWhat =>
      'Εμφανίζει μια ειδοποίηση toast των Windows με τίτλο και σώμα. Εμφανίζεται από κάτω δεξιά και καταλήγει στο Κέντρο ενεργειών.';

  @override
  String get skapiScriptToastSummaryHow =>
      'Δημιουργεί ένα payload XML ToastNotification και το παραδίδει στο WinRT ToastNotificationManager υπό το ρυθμισμένο AppUserModelID.';

  @override
  String get skapiScriptToastNote =>
      'Tier 2: απαιτεί Windows 10+ και ένα καταχωρημένο AppUserModelID για την καθαρότερη εμπειρία χρήστη. Το προεπιλεγμένο AUMID τοποθετεί το toast κάτω από το PowerShell στο Κέντρο ενεργειών.';

  @override
  String get skapiScriptToastParamTitleLabel => 'title';

  @override
  String get skapiScriptToastParamTitleHint => 'Έντονη πρώτη γραμμή του toast.';

  @override
  String get skapiScriptToastParamBodyLabel => 'body';

  @override
  String get skapiScriptToastParamBodyHint =>
      'Μικρότερη δεύτερη γραμμή. Προαιρετικό.';

  @override
  String get skapiScriptToastParamAumidLabel => 'aumid';

  @override
  String get skapiScriptToastParamAumidHint =>
      'App User Model ID υπό το οποίο εμφανίζεται το toast. Η προεπιλογή επιστρέφει στο PowerShell.';

  @override
  String get skapiGroupVisualBreakTitle => 'Οπτικό διάλειμμα';

  @override
  String get skapiGroupVisualBreakDesc =>
      'Απαλές οπτικές ενδείξεις που απομακρύνουν τον χρήστη από την εντατική εργασία: χαμήλωμα οθόνης, μετάβαση σε κλίμακα του γκρι, εύρεση του δρομέα ή εμφάνιση της επιφάνειας εργασίας. Τα εφέ σε αυτή την ομάδα είναι αναστρέψιμα και ποτέ δεν μπλοκάρουν εντελώς την εισαγωγή.';

  @override
  String get skapiGroupVisualBreakFoot =>
      'Τυπική χρήση: χαμήλωμα οθόνης στην αρχή ενός διαλείμματος εστίασης, λειτουργία κλίμακας του γκρι για νυχτερινή ανάγνωση, εύρεση δρομέα σε διατάξεις πολλαπλών οθονών.';

  @override
  String get skapiScriptShowDesktopTitle => 'Εμφάνιση επιφάνειας εργασίας';

  @override
  String get skapiScriptShowDesktopSummaryWhat =>
      'Εναλλάσσει την «εμφάνιση επιφάνειας εργασίας». Ίδιο με το πάτημα Win+D δύο φορές στη σειρά.';

  @override
  String get skapiScriptShowDesktopSummaryHow =>
      'Καλεί το Shell.Application.ToggleDesktop μέσω COM. Εκτελώντας το ξανά επαναφέρει την προηγούμενη διάταξη παραθύρων.';

  @override
  String get skapiScriptFadeScreenTitle => 'Σταδιακό σβήσιμο οθόνης';

  @override
  String get skapiScriptFadeScreenSummaryWhat =>
      'Σβήνει σταδιακά τη φωτεινότητα της εσωτερικής οθόνης από το τρέχον επίπεδο σε ένα επίπεδο-στόχο μέσα σε λίγα δευτερόλεπτα.';

  @override
  String get skapiScriptFadeScreenSummaryHow =>
      'Διαβάζει την τρέχουσα φωτεινότητα μέσω WMI WmiMonitorBrightness, και μετά ρυθμίζει το WmiSetBrightness σε γραμμικά βήματα προς τον στόχο ώστε η αλλαγή να φαίνεται ομαλή.';

  @override
  String get skapiScriptFadeScreenNote =>
      'Tier 2: η φωτεινότητα WMI λειτουργεί μόνο σε εσωτερικές οθόνες. Οι εξωτερικές οθόνες δεν αποκρίνονται σε αυτή τη διαδρομή.';

  @override
  String get skapiScriptFadeScreenParamTargetLabel => 'target';

  @override
  String get skapiScriptFadeScreenParamTargetHint =>
      'Τελικό ποσοστό φωτεινότητας (0-100).';

  @override
  String get skapiScriptFadeScreenParamDurationLabel => 'duration';

  @override
  String get skapiScriptFadeScreenParamDurationHint =>
      'Δευτερόλεπτα που πρέπει να διαρκέσει το σβήσιμο. Το script χρησιμοποιεί δέκα βήματα φωτεινότητας ανά δευτερόλεπτο.';

  @override
  String get skapiScriptGrayscaleTitle => 'Φίλτρο κλίμακας του γκρι';

  @override
  String get skapiScriptGrayscaleSummaryWhat =>
      'Ενεργοποιεί ή απενεργοποιεί τη λειτουργία κλίμακας του γκρι των Φίλτρων χρωμάτων των Windows.';

  @override
  String get skapiScriptGrayscaleSummaryHow =>
      'Γράφει τα κλειδιά μητρώου ColorFiltering, και μετά στέλνει Win+Ctrl+C ώστε τα Windows να εφαρμόσουν την αλλαγή ζωντανά χωρίς αποσύνδεση.';

  @override
  String get skapiScriptGrayscaleNote =>
      'Tier 2: απαιτεί να είναι ενεργό το Ρυθμίσεις > Προσβασιμότητα > Φίλτρα χρωμάτων > «Να επιτρέπεται το πλήκτρο συντόμευσης» για να λειτουργεί η ζωντανή εναλλαγή.';

  @override
  String get skapiScriptGrayscaleParamOnLabel => 'on';

  @override
  String get skapiScriptGrayscaleParamOnHint =>
      'true για ενεργοποίηση της κλίμακας του γκρι, false για απενεργοποίηση.';

  @override
  String get skapiScriptGrayscaleParamDurationLabel => 'duration';

  @override
  String get skapiScriptGrayscaleParamDurationHint =>
      'Το 0 σημαίνει απλή εναλλαγή. >0 επανέρχεται αυτόματα σε χρώμα μετά τα δοσμένα δευτερόλεπτα. Ιδανικό για οπτικά διαλείμματα.';

  @override
  String get skapiScriptFindMouseShakeTitle => 'Εύρεση ποντικιού';

  @override
  String get skapiScriptFindMouseShakeSummaryWhat =>
      'Κινεί τον δρομέα σε έναν μικρό κύκλο για να τραβήξει το μάτι στη θέση του. Ο δρομέας επιστρέφει στο σημείο εκκίνησής του όταν τελειώνει η κίνηση.';

  @override
  String get skapiScriptFindMouseShakeSummaryHow =>
      'Διαβάζει την τρέχουσα θέση του δρομέα με GetCursorPos, και μετά εκτελεί SetCursorPos γύρω από έναν κύκλο της ρυθμισμένης ακτίνας. Χρήσιμο σε διατάξεις πολλαπλών οθονών και 4K.';

  @override
  String get skapiScriptFindMouseShakeNote =>
      'Tier 2: το SetCursorPos μπορεί να μπλοκαριστεί από λογισμικό προσβασιμότητας, και η συμπεριφορά διαφέρει σε συνεδρίες απομακρυσμένης επιφάνειας εργασίας.';

  @override
  String get skapiScriptFindMouseShakeParamRadiusLabel => 'radius';

  @override
  String get skapiScriptFindMouseShakeParamRadiusHint =>
      'Pixels που διανύει ο δρομέας από την αρχή του κατά τον βρόχο. Μεγαλύτερη ακτίνα τραβά περισσότερο το μάτι.';

  @override
  String get skapiScriptFindMouseShakeParamLoopsLabel => 'loops';

  @override
  String get skapiScriptFindMouseShakeParamLoopsHint =>
      'Πόσους πλήρεις κύκλους να σχεδιάσει πριν σταματήσει.';

  @override
  String get skapiGroupProgramsTitle => 'Έλεγχος συγκεκριμένου προγράμματος';

  @override
  String get skapiGroupProgramsDesc =>
      'Στοχευμένα scripts για συγκεκριμένες εφαρμογές και προγράμματα περιήγησης: ομαλή αποθήκευση+κλείσιμο, τερματισμός πολλαπλών στιγμιότυπων, εκκαθάριση όλου του προγράμματος περιήγησης. Χρήσιμα όταν μια συσκευή SmartKraft θέλει να τερματίσει μια συγκεκριμένη ροή εργασίας χωρίς να κλείσει όλη την επιφάνεια εργασίας.';

  @override
  String get skapiGroupProgramsFoot =>
      'Τυπική χρήση: αποθήκευση και κλείσιμο όλων των επεξεργαστών πριν την αναστολή, κλείσιμο κάθε προγράμματος περιήγησης στο τέλος της ημέρας, στενευμένη εκκαθάριση μιας οικογένειας διεργασιών.';

  @override
  String get skapiScriptCloseWithSaveTitle => 'Αποθήκευση & κλείσιμο εφαρμογής';

  @override
  String get skapiScriptCloseWithSaveSummaryWhat =>
      'Στέλνει Ctrl+S σε μια εφαρμογή-στόχο για να ενεργοποιήσει τη δική της αποθήκευση, περιμένει, και μετά κλείνει το παράθυρο ομαλά.';

  @override
  String get skapiScriptCloseWithSaveSummaryHow =>
      'Εστιάζει κάθε εκτελούμενο στιγμιότυπο, στέλνει Ctrl+S μέσω SendKeys, περιμένει το ρυθμισμένο διάστημα, και μετά δημοσιεύει WM_CLOSE ώστε η εφαρμογή να επιβεβαιώσει ή να ολοκληρώσει την αποθήκευση.';

  @override
  String get skapiScriptCloseWithSaveNote =>
      'Tier 2: βασίζεται στο ότι η εφαρμογή ερμηνεύει το Ctrl+S ως «αποθήκευση». Ορισμένες εφαρμογές συνομιλίας / web το αντιμετωπίζουν διαφορετικά. Δοκιμάστε με τις εφαρμογές που πραγματικά στοχεύετε.';

  @override
  String get skapiScriptCloseWithSaveParamProcessLabel => 'processName';

  @override
  String get skapiScriptCloseWithSaveParamProcessHint =>
      'Όνομα διεργασίας χωρίς .exe (winword, excel, code, photoshop). Όλα τα εκτελούμενα στιγμιότυπα αποθηκεύονται και κλείνουν.';

  @override
  String get skapiScriptCloseWithSaveParamWaitLabel => 'wait';

  @override
  String get skapiScriptCloseWithSaveParamWaitHint =>
      'Δευτερόλεπτα αναμονής μεταξύ Ctrl+S και του σήματος κλεισίματος ώστε η εφαρμογή να ολοκληρώσει την αποθήκευση.';

  @override
  String get skapiScriptCloseAllInstancesTitle =>
      'Κλείσιμο όλων των στιγμιότυπων';

  @override
  String get skapiScriptCloseAllInstancesSummaryWhat =>
      'Στέλνει ένα ομαλό κλείσιμο σε κάθε ορατό παράθυρο μιας διεργασίας. Κάθε στιγμιότυπο μπορεί να εμφανίσει το δικό του παράθυρο αποθήκευσης.';

  @override
  String get skapiScriptCloseAllInstancesSummaryHow =>
      'Διατρέχει τις διεργασίες που ταιριάζουν μέσω Get-Process και δημοσιεύει WM_CLOSE στο κύριο παράθυρο της καθεμιάς. Χωρίς εξαναγκαστική εναλλακτική.';

  @override
  String get skapiScriptCloseAllInstancesParamProcessLabel => 'processName';

  @override
  String get skapiScriptCloseAllInstancesParamProcessHint =>
      'Όνομα διεργασίας χωρίς .exe. Ταιριάζει όλα τα στιγμιότυπα.';

  @override
  String get skapiScriptBrowserCloseAllTitle =>
      'Κλείσιμο όλων των προγραμμάτων περιήγησης';

  @override
  String get skapiScriptBrowserCloseAllSummaryWhat =>
      'Κλείνει ομαλά κάθε εκτελούμενο γνωστό πρόγραμμα περιήγησης (Chrome, Edge, Firefox, Brave, Vivaldi, Opera).';

  @override
  String get skapiScriptBrowserCloseAllSummaryHow =>
      'Διατρέχει τα γνωστά ονόματα διεργασιών προγραμμάτων περιήγησης και δημοσιεύει WM_CLOSE σε κάθε κύριο παράθυρο. Τα σύγχρονα προγράμματα περιήγησης διατηρούν τη συνεδρία αν είναι ενεργό το «επαναφορά καρτελών στην επόμενη εκκίνηση».';

  @override
  String get skapiScriptBrowserCloseAllNote =>
      'Δεν χρησιμοποιείται εξαναγκαστικός τερματισμός. Για να διαγράψετε και τη συνεδρία, χρησιμοποιήστε kill-app ανά πρόγραμμα περιήγησης.';

  @override
  String get skapiTierBadgeExperimental => 'Πειραματικό';

  @override
  String get skapiTierBadgeExperimentalTooltip =>
      'Αυτό το script εξαρτάται από ένα API των Windows που μπορεί να μην είναι αξιόπιστο σε διαφορετικά μηχανήματα. Δοκιμάστε το πριν το εμπιστευτείτε.';

  @override
  String get skapiTierBadgeBlocked => 'Έρχεται σύντομα';

  @override
  String get skapiTierBadgeBlockedTooltip =>
      'Αυτό το script είναι μέρος της σχεδιασμένης βιβλιοθήκης αλλά δεν έχει υλοποιηθεί ακόμη.';

  @override
  String get skapiGroupSaveWorkTitle => 'Αποθήκευση εργασίας';

  @override
  String get skapiGroupSaveWorkDesc =>
      'Τα scripts σε αυτή την ομάδα αποθηκεύουν την ανοιχτή σας εργασία στον δίσκο πριν από ένα διάλειμμα ή μια απρόσμενη απενεργοποίηση. Όταν η συσκευή SmartKraft σας ενεργοποιεί ένα διάλειμμα, το επιλεγμένο script αποθηκεύει αυτόματα το αρχείο σας σε Word, Excel, VS Code ή οποιονδήποτε άλλον επεξεργαστή, ώστε ακόμη κι αν ο υπολογιστής σας μπει σε αναστολή, απενεργοποιηθεί ή εκτελέσει άλλη εντολή, η εργασία σας να μένει ασφαλής.';

  @override
  String get skapiGroupSaveWorkFoot =>
      'Τυπική χρήση: αυτόματη αποθήκευση στην αρχή ενός διαλείμματος εστίασης, αντίγραφο ασφαλείας εγγράφου σε προειδοποίηση χαμηλής μπαταρίας, ή ένα trigger «αποθήκευση όλων» με ένα κουμπί.';

  @override
  String get skapiScriptSaveActiveWindowTitle => 'Αποθήκευση ενεργού παραθύρου';

  @override
  String get skapiScriptSaveActiveWindowSummaryWhat =>
      'Στέλνει ένα εικονικό Ctrl+S σε όποιο παράθυρο των Windows έχει αυτή τη στιγμή την εστίαση, ενεργοποιώντας τη δική του συμπεριφορά «αποθήκευσης» αυτής της εφαρμογής.';

  @override
  String get skapiScriptSaveActiveWindowSummaryHow =>
      'Πρώτα παίρνει τον δείκτη του ενεργού παραθύρου και καταγράφει τον τίτλο του. Έπειτα αποστέλλει Ctrl+S μέσω SendKeys. Το Word αποθηκεύει στην τρέχουσα διαδρομή του, το VS Code γράφει το αρχείο. Αν εμφανιστεί ένα παράθυρο «Αποθήκευση ως», περιμένει μέχρι ο χρήστης να επιβεβαιώσει χειροκίνητα.';

  @override
  String get skapiScriptSaveActiveWindowParamTimeoutLabel => 'timeout';

  @override
  String get skapiScriptSaveActiveWindowParamTimeoutHint =>
      'Δευτερόλεπτα αναμονής μετά την αποστολή του πατήματος ώστε η εφαρμογή να έχει χρόνο να γράψει το αρχείο.';

  @override
  String get skapiScriptSaveActiveWindowParamVerboseLabel => 'verbose';

  @override
  String get skapiScriptSaveAllOpenTitle =>
      'Αποθήκευση όλων των ανοιχτών εγγράφων';

  @override
  String get skapiScriptSaveAllOpenSummaryWhat =>
      'Διατρέχει μια λίστα επιτρεπόμενων εκτελούμενων επεξεργαστών και λέει στον καθένα να αποθηκεύσει τα ανοιχτά του έγγραφα.';

  @override
  String get skapiScriptSaveAllOpenSummaryHow =>
      'Για κάθε επιτρεπόμενη διεργασία που βρίσκεται, εστιάζει στο κύριο παράθυρο, στέλνει Ctrl+S, και μετά περιμένει τη ρυθμισμένη λήξη χρόνου ανά εφαρμογή πριν προχωρήσει. Οι εφαρμογές που δεν εκτελούνται παραλείπονται σιωπηλά εκτός αν είναι ενεργή η αναλυτική λειτουργία.';

  @override
  String get skapiScriptSaveAllOpenNote =>
      'Η λίστα επιτρεπόμενων περιλαμβάνει εξ ορισμού Word, Excel, PowerPoint και VS Code. Επεξεργαστείτε την παράμετρο apps για να προσθέσετε τις δικές σας.';

  @override
  String get skapiScriptSaveAllOpenParamAppsLabel => 'apps';

  @override
  String get skapiScriptSaveAllOpenParamAppsHint =>
      'Ονόματα διεργασιών (χωρίς .exe) στα οποία θα σταλεί αποθήκευση. Η σειρά έχει σημασία: οι προηγούμενες καταχωρίσεις επεξεργάζονται πρώτες.';

  @override
  String get skapiScriptSaveAllOpenParamTimeoutLabel => 'timeoutPerApp';

  @override
  String get skapiScriptSaveAllOpenParamVerboseLabel => 'verbose';

  @override
  String get skapiScriptAutosaveTriggerTitle =>
      'Ενεργοποίηση αυτόματης αποθήκευσης';

  @override
  String get skapiScriptAutosaveTriggerSummaryWhat =>
      'Εκπέμπει μια εντολή αποθήκευσης των Windows σε κάθε ορατό παράθυρο ανώτατου επιπέδου με ένα πέρασμα.';

  @override
  String get skapiScriptAutosaveTriggerSummaryHow =>
      'Απαριθμεί τα ορατά παράθυρα, και μετά στέλνει στο καθένα ένα WM_COMMAND με το τυπικό id αποθήκευσης. Οι εφαρμογές που ακούν για αυτό το μήνυμα αντιδρούν σαν να πατήσατε το στοιχείο Αποθήκευση του μενού Αρχείο τους. Πιο γρήγορο από Ctrl+S ανά παράθυρο, αλλά μερικές εφαρμογές αγνοούν την εκπομπή.';

  @override
  String get skapiScriptAutosaveTriggerNote =>
      'Χρησιμοποιήστε το όταν θέλετε να αποθηκεύσετε κάθε επεξεργαστή ταυτόχρονα και δεν σας πειράζει που ένας μικρός αριθμός εφαρμογών μπορεί να μην αποκριθεί. Συνδυάστε με save-all-open για αυστηρότερη κάλυψη.';

  @override
  String get skapiScriptAutosaveTriggerParamDelayLabel => 'delay';

  @override
  String get skapiScriptAutosaveTriggerParamDelayHint =>
      'Δευτερόλεπτα αναμονής πριν την εκπομπή, χρήσιμο όταν θέλετε να εμφανιστεί πρώτα η ειδοποίηση διαλείμματος της συσκευής.';

  @override
  String get skapiScriptAutosaveTriggerParamVerboseLabel => 'verbose';

  @override
  String get skapiScriptDetailSummaryWhatLabel => 'Τι κάνει:';

  @override
  String get skapiScriptDetailSummaryHowLabel => 'Πώς λειτουργεί:';

  @override
  String get skapiScriptDetailOriginalSectionTitle => 'Αρχικό script';

  @override
  String get skapiScriptDetailOriginalSectionSub =>
      'μόνο για ανάγνωση · Αγγλικά';

  @override
  String get skapiScriptDetailEditingSectionTitle => 'Επεξεργασίες';

  @override
  String get skapiScriptDetailEditingNotYet => 'Καμία επεξεργασία ακόμη';

  @override
  String get skapiScriptDetailEditingNotYetSub =>
      'Δημιουργήστε ένα αντίγραφο σε αυτή τη συσκευή χωρίς να αλλάξετε το πρωτότυπο.';

  @override
  String get skapiScriptDetailEditingModified => 'Επεξεργασμένο';

  @override
  String skapiScriptDetailEditingModifiedSub(String date) {
    return 'Τελευταία αλλαγή $date.';
  }

  @override
  String get skapiScriptDetailEditingOutdated => 'Η βιβλιοθήκη ενημερώθηκε';

  @override
  String get skapiScriptDetailEditingOutdatedSub =>
      'Το πρωτότυπο άλλαξε από μια ενημέρωση της εφαρμογής. Συγκρίνετε ή επαναφέρετε.';

  @override
  String get skapiScriptDetailParamWarnTitle =>
      'Ελέγξτε τις παραμέτρους πριν την εκτέλεση';

  @override
  String get skapiScriptDetailParamWarnHint =>
      'Για να αλλάξετε αυτές τις τιμές, χρησιμοποιήστε «Επεξεργασία». Οι παράμετροι ορίζονται στο μπλοκ param() του script.';

  @override
  String get skapiScriptDetailNotesTitle => 'Σημειώσεις';

  @override
  String get skapiScriptDetailButtonRun => 'Εκτέλεση τώρα';

  @override
  String get skapiScriptDetailButtonBindAction => 'Σύνδεση σε ενέργεια';

  @override
  String get skapiScriptDetailButtonEdit => 'Επεξεργασία';

  @override
  String get skapiScriptDetailButtonView => 'Προβολή';

  @override
  String get skapiScriptDetailButtonReset => 'Επαναφορά';

  @override
  String get skapiScriptDetailButtonCompare => 'Σύγκριση';

  @override
  String get skapiScriptCopyButton => 'Αντιγραφή';

  @override
  String get skapiScriptCopyButtonDone => 'Αντιγράφηκε';

  @override
  String get skapiScriptSelectButton => 'Επιλογή';

  @override
  String get skapiEditorTitle => 'Επεξεργασία';

  @override
  String skapiEditorHint(String scriptId) {
    return '$scriptId · Επεξεργάζεστε ένα αντίγραφο σε αυτή τη συσκευή. Η αρχική έκδοση της βιβλιοθήκης παραμένει αμετάβλητη. Η «Επαναφορά» επαναφέρει πάντα το πρωτότυπο.';
  }

  @override
  String get skapiEditorStatusBarTitle => 'POWERSHELL · UTF-8';

  @override
  String get skapiEditorStatusModified => '● Τροποποιήθηκε';

  @override
  String get skapiEditorStatusUnmodified => 'Αμετάβλητο';

  @override
  String skapiEditorFootCursor(int line, int column) {
    return 'Γραμμή $line · Στήλη $column';
  }

  @override
  String get skapiEditorFootSaveLabel => 'Αποθήκευση';

  @override
  String skapiEditorDiffLineCount(int count) {
    return '$count γραμμή άλλαξε';
  }

  @override
  String skapiEditorDiffLinesCount(int count) {
    return '$count γραμμές άλλαξαν';
  }

  @override
  String get skapiEditorDiffCompareLink => 'Σύγκριση με το πρωτότυπο';

  @override
  String get skapiEditorButtonReset => 'Επαναφορά';

  @override
  String get skapiEditorButtonSave => 'Αποθήκευση';

  @override
  String get skapiEditorAfterSaveNote =>
      'Μετά την αποθήκευση, η «Εκτέλεση τώρα» θα εκτελέσει την επεξεργασμένη έκδοση.';

  @override
  String get skapiLinuxDistroHeading => 'Επιλέξτε την οικογένεια διανομής σας';

  @override
  String get skapiLinuxDistroSubtitle =>
      'Τα scripts Linux διαφέρουν μεταξύ των οικογενειών βασισμένων σε Debian (apt, .deb) και βασισμένων σε Arch (pacman). Επιλέξτε αυτή που ταιριάζει στο μηχάνημά σας.';

  @override
  String get skapiLinuxDistroDebianLabel => 'Βασισμένο σε Debian';

  @override
  String get skapiLinuxDistroDebianSub =>
      'Debian, Ubuntu, Mint, Pop!_OS, Elementary, Kali, MX, Zorin';

  @override
  String get skapiLinuxDistroArchLabel => 'Βασισμένο σε Arch';

  @override
  String get skapiLinuxDistroArchSub =>
      'Arch, Manjaro, EndeavourOS, Garuda (έρχεται αργότερα)';

  @override
  String get skapiNewActionNoDevicesTitle => 'Συζεύξτε πρώτα μια συσκευή';

  @override
  String get skapiNewActionNoDevicesBody =>
      'Η δημιουργία μιας ενέργειας στη συσκευή χρειάζεται τουλάχιστον μία συζευγμένη συσκευή SmartKraft (BF προς το παρόν).';

  @override
  String get skapiNewActionNoDevicesCta => 'Άνοιγμα Συσκευών';

  @override
  String get skapiNewActionPickDeviceTitle => 'Επιλέξτε μια συσκευή';

  @override
  String get skapiNewActionPickDeviceSubtitle =>
      'Σε ποια συσκευή θα βρίσκεται αυτή η ενέργεια;';

  @override
  String get skapiUserNewTitle => 'Νέο script';

  @override
  String get skapiUserEditTitle => 'Επεξεργασία script';

  @override
  String get skapiUserTitleLabel => 'Τίτλος';

  @override
  String get skapiUserTitleHint => 'π.χ. Πρωινή ρουτίνα';

  @override
  String get skapiUserDescLabel => 'Περιγραφή';

  @override
  String get skapiUserDescHint => 'Τι κάνει αυτό το script;';

  @override
  String get skapiUserPlatformLabel => 'Πλατφόρμα';

  @override
  String get skapiUserCodeLabel => 'Κώδικας';

  @override
  String get skapiUserCodeHint => '# Ο κώδικάς σας PowerShell εδώ';

  @override
  String get skapiUserSaveCta => 'Αποθήκευση';

  @override
  String get skapiUserValidationEmpty =>
      'Ο τίτλος και ο κώδικας δεν μπορούν να είναι κενά.';

  @override
  String get skapiUserSavedSnack => 'Το script αποθηκεύτηκε';

  @override
  String get skapiUserSectionHeading => 'Τα scripts μου';

  @override
  String skapiUserSectionSub(int count) {
    return '$count scripts';
  }

  @override
  String get skapiUserEmptyHint =>
      'Δεν υπάρχουν δικά σας scripts ακόμη. Δημιουργήστε ένα με το κουμπί Νέα ενέργεια, πάνω δεξιά.';

  @override
  String get skapiUserDetailCodeHeading => 'Κώδικας';

  @override
  String get skapiUserEditCta => 'Επεξεργασία';

  @override
  String get skapiUserDeleteConfirmTitle => 'Διαγραφή script;';

  @override
  String skapiUserDeleteConfirmBody(String name) {
    return 'Το $name θα διαγραφεί οριστικά.';
  }

  @override
  String get skapiUserDeletedSnack => 'Το script διαγράφηκε';

  @override
  String get skapiUserRunCta => 'Εκτέλεση';

  @override
  String get skapiUserRunUnsupported =>
      'Η εκτέλεση scripts γίνεται μόνο σε επιτραπέζιο.';

  @override
  String get skapiUserRunOutputTitle => 'Έξοδος εκτέλεσης';

  @override
  String skapiUserRunDone(int code) {
    return 'Ολοκληρώθηκε (έξοδος $code)';
  }

  @override
  String get skapiLocalScriptsSubheading => 'Τοπικά scripts';

  @override
  String get skapiOnDeviceApiSubheading => 'API στη συσκευή';

  @override
  String get skapiOnDeviceApiLoadError =>
      'Δεν ήταν δυνατή η ανάγνωση των endpoints';

  @override
  String get skapiOnDeviceApiRowHint =>
      'Πατήστε οποιαδήποτε σειρά για να ανοίξετε τον επεξεργαστή';

  @override
  String get commonLoading => 'Φόρτωση...';

  @override
  String get skapiApiTemplateSectionHeader => 'Πρότυπα';

  @override
  String skapiApiTemplateSectionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count πρότυπα',
      one: '1 πρότυπο',
    );
    return '$_temp0';
  }

  @override
  String get skapiApiTemplateUploadCta => 'Μεταφόρτωση στη συσκευή';

  @override
  String get skapiApiTemplateUploadHint =>
      'Η μεταφόρτωση εγγράφει αυτό το πρότυπο σε μία από τις 5 υποδοχές API USER της συσκευής. Η συσκευή το ενεργοποιεί με το δικό της trigger (BF: τέλος αντίστροφης μέτρησης).';

  @override
  String get skapiApiTemplatePreviewTitle => 'Προεπισκόπηση endpoint';

  @override
  String get skapiApiTemplatePreviewType => 'Τύπος';

  @override
  String get skapiApiTemplatePreviewMethod => 'Μέθοδος';

  @override
  String get skapiApiTemplatePreviewUrl => 'URL';

  @override
  String get skapiApiTemplatePreviewAuth => 'Έλεγχος ταυτότητας';

  @override
  String get skapiApiTemplatePreviewHeader => 'Κεφαλίδα';

  @override
  String get skapiApiTemplatePreviewContentType => 'Content-Type';

  @override
  String get skapiApiTemplatePreviewPayload => 'Payload';

  @override
  String get skapiApiTemplatePreviewDelay => 'Καθυστέρηση';

  @override
  String get skapiOtherCategoryHeading => 'Επιλέξτε μια κατηγορία συσκευής';

  @override
  String get skapiOtherCategorySubtitle =>
      'Τα πρότυπα μεταφορτώνονται στη συζευγμένη συσκευή και ενεργοποιούνται με το δικό της trigger (χωρίς εμπλοκή φορητού).';

  @override
  String get skapiOtherSyndimmSub => 'Έξυπνος dimmer SmartKraft';

  @override
  String get skapiOtherLebensspurSub => 'Ιχνηλάτης δραστηριότητας SmartKraft';

  @override
  String get skapiOtherBlockingfocusSub => 'Χρονόμετρο εστίασης SmartKraft';

  @override
  String get skapiOtherIotSub =>
      'Webhooks IoT τρίτων (IFTTT, Home Assistant, γενικό REST)';

  @override
  String get skapiOtherServerSub =>
      'Αυτο-φιλοξενούμενοι δέκτες HTTP (n8n, Node-RED, προσαρμοσμένοι)';

  @override
  String get skapiCategoryComingSoon => 'Τα πρότυπα έρχονται σύντομα';

  @override
  String get skapiScriptLockSummaryHowLxDebian =>
      'Καλεί loginctl lock-session για το τρέχον XDG_SESSION_ID· επιστρέφει σε xdg-screensaver lock όταν το loginctl δεν είναι διαθέσιμο.';

  @override
  String get skapiScriptHibernateSummaryHowLxDebian =>
      'Καλεί systemctl hibernate. Η προαιρετική καθυστέρηση αναμένει τα ζητούμενα δευτερόλεπτα πριν την αναστολή.';

  @override
  String get skapiScriptHibernateNoteLxDebian =>
      'Η αδρανοποίηση πρέπει να είναι διαμορφωμένη (swap >= RAM και η παράμετρος πυρήνα resume=). Σε συστήματα όπου δεν είναι, το systemd-logind επιστρέφει σε αναστολή.';

  @override
  String get skapiScriptSleepSummaryHowLxDebian =>
      'Καλεί systemctl suspend. Ο πυρήνας μπορεί να καθυστερήσει αν ένας αναστολέας στο προσκήνιο εμποδίζει τις μεταβάσεις αδράνειας.';

  @override
  String get skapiScriptShutdownSummaryHowLxDebian =>
      'Προγραμματίζει μια ομαλή απενεργοποίηση μέσω /sbin/shutdown -h +N (λεπτά). Επιστρέφει σε systemctl poweroff μετά τη ζητούμενη καθυστέρηση αν λείπει το shutdown.';

  @override
  String get skapiScriptShutdownNoteLxDebian =>
      'Το /sbin/shutdown δέχεται μόνο λεπτά· τιμές κάτω από 60 στρογγυλοποιούνται προς τα πάνω σε 1 λεπτό. Άλλοι συνδεδεμένοι χρήστες βλέπουν ένα μήνυμα wall κατά την αντίστροφη μέτρηση.';

  @override
  String get skapiScriptShutdownParamForceHintLxDebian =>
      'Τερματίζει τη συνεδρία χρήστη πριν την απενεργοποίηση ώστε να παρακαμφθεί η περίοδος χάριτος SIGTERM των 90 δ.';

  @override
  String get skapiScriptBrightnessSummaryHowLxDebian =>
      'Ρυθμίζει τον οπίσθιο φωτισμό της εσωτερικής οθόνης μέσω brightnessctl set N% (προτιμώμενο) ή light -S N ως εναλλακτική. Και τα δύο γράφουν στο /sys/class/backlight.';

  @override
  String get skapiScriptBrightnessNoteLxDebian =>
      'Το brightnessctl δεν χρειάζεται sudo όταν ο χρήστης είναι στην ομάδα video, που είναι η προεπιλογή μετά την εγκατάσταση στις περισσότερες διατάξεις Debian. Οι εξωτερικές οθόνες μέσω DDC χρειάζονται ddcutil και δεν αντιμετωπίζονται εδώ.';

  @override
  String get skapiScriptMuteToggleSummaryHowLxDebian =>
      'Εναλλάσσει ή ορίζει τη σίγαση της κύριας εξόδου μέσω wpctl (PipeWire σε Debian 12+) με εναλλακτική pactl για διατάξεις PulseAudio.';

  @override
  String get skapiScriptVolumeSetSummaryHowLxDebian =>
      'Ρυθμίζει την ένταση της κύριας εξόδου σε επίπεδο 0-100 μέσω wpctl set-volume (PipeWire) ή pactl set-sink-volume (PulseAudio).';

  @override
  String get skapiScriptVolumeSetNoteLxDebian =>
      'Το PipeWire και το PulseAudio εκθέτουν και τα δύο ένταση ανά εφαρμογή εγγενώς, οπότε αυτό το script είναι tier 1 σε Linux. Η έξοδος πάνω από 100% περιορίζεται για ισοτιμία με άλλες πλατφόρμες.';

  @override
  String get skapiScriptMediaKeySummaryHowLxDebian =>
      'Στέλνει μια ενέργεια πλήκτρου πολυμέσων μέσω playerctl, που χρησιμοποιεί MPRIS για να επικοινωνήσει με όποια εφαρμογή κατέχει αυτή τη στιγμή τη συνεδρία (Spotify, Firefox, VLC, mpv, Rhythmbox).';

  @override
  String get skapiScriptMediaKeyNoteLxDebian =>
      'Αν δεν εκτελείται καμία εφαρμογή πολυμέσων συμβατή με MPRIS, η εντολή δεν έχει αποτέλεσμα. Εγκαταστήστε την υποστήριξη MPRIS της εφαρμογής αν ένας γνωστός player δεν αποκρίνεται.';

  @override
  String get skapiScriptMinimizeWindowSummaryHowLxDebian =>
      'Κενό processName ελαχιστοποιεί το παράθυρο με εστίαση μέσω xdotool. Διαφορετικά επιλέγει το πρώτο παράθυρο του οποίου το WM_CLASS ταιριάζει και το ελαχιστοποιεί.';

  @override
  String get skapiScriptMinimizeWindowNoteLxDebian =>
      'Μόνο X11. Η αντιστοίχιση WM_CLASS διακρίνει πεζά-κεφαλαία και εξαρτάται από το πώς δήλωσε τον εαυτό της η εφαρμογή· ελέγξτε xprop WM_CLASS αν δεν είστε σίγουροι.';

  @override
  String get skapiScriptMinimizeWindowParamProcessHintLxDebian =>
      'Όνομα στιγμιότυπου WM_CLASS (για παράδειγμα: firefox, code, gnome-terminal-server). Κενό στοχεύει το ενεργό παράθυρο.';

  @override
  String get skapiScriptCloseWindowSummaryHowLxDebian =>
      'Στέλνει WM_DELETE_WINDOW μέσω wmctrl -x -c (ταιριάζει WM_CLASS) με εναλλακτική βάσει τίτλου. Ισοδύναμο με το πάτημα του κουμπιού X· η εφαρμογή μπορεί να εμφανίσει το δικό της παράθυρο αποθήκευσης.';

  @override
  String get skapiScriptCloseWindowNoteLxDebian =>
      'Μόνο X11. Για Wayland, προτιμήστε kill-app που χρησιμοποιεί σήματα αντί για το πρωτόκολλο παραθύρων.';

  @override
  String get skapiScriptCloseWindowParamProcessHintLxDebian =>
      'Όνομα στιγμιότυπου WM_CLASS· κενό κλείνει το παράθυρο με εστίαση. Η αντιστοίχιση υποσυμβολοσειράς τίτλου χρησιμοποιείται ως εναλλακτική.';

  @override
  String get skapiScriptKillAppSummaryHowLxDebian =>
      'pkill -TERM -x βάσει ακριβούς ονόματος comm, περιμένει τη ζητούμενη λήξη χρόνου, και μετά pkill -KILL σε ό,τι είναι ακόμη ζωντανό. Το προαιρετικό preKillSave εστιάζει στο παράθυρο και στέλνει πρώτα Ctrl+S (μόνο X11).';

  @override
  String get skapiScriptKillAppNoteLxDebian =>
      'Τα ονόματα comm στο Linux περιορίζονται σε 15 χαρακτήρες από τον πυρήνα. Χρησιμοποιήστε ακριβή σύντομα ονόματα: firefox (όχι firefox-esr-bin), code, soffice.bin.';

  @override
  String get skapiScriptKillAppParamProcessHintLxDebian =>
      'Ακριβές όνομα comm (όριο πυρήνα 15 χαρακτήρων). Χρησιμοποιήστε pgrep -l για να επαληθεύσετε το ορατό όνομα.';

  @override
  String get skapiScriptKillAppParamPreKillSaveHintLxDebian =>
      'Στέλνει Ctrl+S στο παράθυρο της εφαρμογής πριν το SIGTERM. Απαιτεί xdotool και X11· αγνοείται σε Wayland.';

  @override
  String get skapiScriptLaunchAppSummaryHowLxDebian =>
      'Έξυπνη δρομολόγηση: .desktop -> gtk-launch, πραγματική διαδρομή αρχείου -> exec, οτιδήποτε άλλο -> xdg-open, τέλος αναζήτηση στο PATH. Η θυγατρική διεργασία αποσπάται μέσω setsid ώστε το SKAPP να μην μπλοκάρεται.';

  @override
  String get skapiScriptLaunchAppNoteLxDebian =>
      'Το args διαχωρίζεται σε κενά. Ορίσματα με εισαγωγικά δεν υποστηρίζονται· χρησιμοποιήστε ένα script περιτυλίγματος για σύνθετες γραμμές εντολών.';

  @override
  String get skapiScriptLaunchAppParamPathHintLxDebian =>
      'Όνομα δυαδικού στο PATH, απόλυτη διαδρομή, αρχείο .desktop, URL ή διαδρομή αρχείου. Το xdg-open χειρίζεται τύπους MIME.';

  @override
  String get skapiScriptDialogSummaryHowLxDebian =>
      'Ανοίγει ένα modal παράθυρο διαλόγου μέσω zenity (GTK) με εναλλακτική kdialog (KDE). Γράφει ένα από ok / cancel / yes / no / timeout στο stdout.';

  @override
  String get skapiScriptDialogNoteLxDebian =>
      'Εγκαταστήστε με: sudo apt install zenity. Οι χρήστες KDE Plasma μπορεί να έχουν kdialog αντ\' αυτού. Χωρίς κανένα από τα δύο, το script τερματίζει με κωδικό 2.';

  @override
  String get skapiScriptToastSummaryHowLxDebian =>
      'Στέλνει μια ειδοποίηση επιφάνειας εργασίας μέσω notify-send (libnotify). Tier 1 επειδή το libnotify-bin είναι προεγκατεστημένο σε κάθε σύγχρονη επιφάνεια εργασίας Debian.';

  @override
  String get skapiScriptToastNoteLxDebian =>
      'Το icon δέχεται ονόματα θέματος εικονιδίων Freedesktop (dialog-information, dialog-warning, dialog-error). duration σε δευτερόλεπτα· το 0 κρατά το toast μέχρι να απορριφθεί.';

  @override
  String get skapiScriptToastParamIconLabelLxDebian => 'Εικονίδιο';

  @override
  String get skapiScriptToastParamIconHintLxDebian =>
      'Όνομα εικονιδίου Freedesktop, για παράδειγμα: dialog-information, dialog-warning, dialog-error.';

  @override
  String get skapiScriptToastParamDurationLabelLxDebian => 'Διάρκεια';

  @override
  String get skapiScriptToastParamDurationHintLxDebian =>
      'Αυτόματη απόρριψη μετά από τόσα δευτερόλεπτα. Το 0 σημαίνει ότι το toast παραμένει μέχρι ο χρήστης να το κλείσει.';

  @override
  String get skapiScriptShowDesktopSummaryHowLxDebian =>
      'Διαβάζει την κατάσταση EWMH show-desktop μέσω wmctrl -m, και μετά την εναλλάσσει με wmctrl -k. Αντικατοπτρίζει τη σημασιολογία Win+D σε X11.';

  @override
  String get skapiScriptShowDesktopNoteLxDebian =>
      'Μόνο X11. Τα ισοδύναμα Wayland εξαρτώνται από τον compositor (Sway, Hyprland, επεκτάσεις GNOME Shell).';

  @override
  String get skapiScriptFadeScreenSummaryHowLxDebian =>
      'Σβήνει γραμμικά τον οπίσθιο φωτισμό της εσωτερικής οθόνης από το τρέχον στον στόχο μέσα στη ζητούμενη διάρκεια μέσω brightnessctl σε βήματα 10 ανά δευτερόλεπτο.';

  @override
  String get skapiScriptFadeScreenNoteLxDebian =>
      'Μόνο εσωτερικές οθόνες. Οι εξωτερικές οθόνες μέσω DDC χρειάζονται ddcutil και δεν αντιμετωπίζονται εδώ. Tier 2 επειδή η ανάγνωση του τρέχοντος οπίσθιου φωτισμού εξαρτάται από την ορατότητα του /sys/class/backlight.';

  @override
  String get skapiScriptGrayscaleSummaryHowLxDebian =>
      'Εναλλάσσει το κλειδί κορεσμού χρώματος του μεγεθυντή προσβασιμότητας του GNOME (0.0 κλίμακα του γκρι, 1.0 χρώμα) μέσω gsettings, χωρίς να χρειάζεται επέκταση.';

  @override
  String get skapiScriptGrayscaleNoteLxDebian =>
      'Μόνο GNOME / Unity. Το KDE Plasma και το XFCE δεν έχουν ισοδύναμη διαδρομή συστήματος· σε αυτές τις επιφάνειες εργασίας το script τερματίζει με κωδικό 3 αντί για σιωπηλή αδράνεια.';

  @override
  String get skapiScriptFindMouseShakeSummaryHowLxDebian =>
      'Διαβάζει τη θέση του δρομέα μέσω xdotool getmouselocation, και μετά ιχνηλατεί έναν κύκλο γύρω της για τον ζητούμενο αριθμό βρόχων χρησιμοποιώντας συντεταγμένες cos/sin υπολογισμένες με awk.';

  @override
  String get skapiScriptFindMouseShakeNoteLxDebian =>
      'Μόνο X11. Το Wayland μπλοκάρει τη συνθετική κίνηση δείκτη σε επίπεδο πρωτοκόλλου (όριο ασφαλείας), οπότε το script τερματίζει με κωδικό 3.';

  @override
  String get skapiScriptCloseWithSaveSummaryHowLxDebian =>
      'Για κάθε ορατό παράθυρο που ταιριάζει το WM_CLASS: ενεργοποίηση, Ctrl+S, αναμονή, και μετά αποστολή WM_DELETE_WINDOW μέσω wmctrl. Μόνο X11.';

  @override
  String get skapiScriptCloseWithSaveNoteLxDebian =>
      'Tier 2: η εισαγωγή πλήκτρου Ctrl+S εξαρτάται από τις τοπικές ρυθμίσεις και την εστίαση· μόνο η αληθινή σημασιολογία αποθήκευσης συμπεριφέρεται προβλέψιμα. Οι εφαρμογές συνομιλίας ή web μπορεί να αντιστοιχίσουν το Ctrl+S σε κάτι άλλο.';

  @override
  String get skapiScriptCloseWithSaveParamProcessHintLxDebian =>
      'Όνομα στιγμιότυπου WM_CLASS (βλ. xprop WM_CLASS). Απαιτείται.';

  @override
  String get skapiScriptCloseAllInstancesSummaryHowLxDebian =>
      'Στέλνει SIGTERM σε κάθε εκτελούμενη διεργασία που ταιριάζει το ακριβές όνομα comm. Κάθε εφαρμογή χειρίζεται τη δική της ακολουθία τερματισμού (και μπορεί να εμφανίσει το δικό της παράθυρο αποθήκευσης).';

  @override
  String get skapiScriptCloseAllInstancesParamProcessHintLxDebian =>
      'Ακριβές όνομα comm όπως εμφανίζεται από pgrep -l. Απαιτείται.';

  @override
  String get skapiScriptBrowserCloseAllSummaryHowLxDebian =>
      'Διατρέχει μια λίστα δυαδικών προγραμμάτων περιήγησης Debian (firefox, firefox-esr, chromium, google-chrome, brave, vivaldi-bin, opera) και στέλνει SIGTERM σε κάθε εκτελούμενο στιγμιότυπο.';

  @override
  String get skapiScriptBrowserCloseAllNoteLxDebian =>
      'Τα προγράμματα περιήγησης διατηρούν τη συνεδρία αν είναι ενεργό το «επαναφορά καρτελών στην επόμενη εκκίνηση», οπότε αυτό είναι ένα απαλό «σβήσιμο της οθόνης» παρά μια ενέργεια απώλειας δεδομένων.';

  @override
  String get skapiScriptSaveActiveWindowSummaryHowLxDebian =>
      'Στέλνει Ctrl+S στο παράθυρο με εστίαση μέσω xdotool key --clearmodifiers. Μόνο X11.';

  @override
  String get skapiScriptSaveActiveWindowNoteLxDebian =>
      'Το Wayland μπλοκάρει τη συνθετική εισαγωγή πλήκτρων σε επίπεδο πρωτοκόλλου. Χρησιμοποιήστε την εναλλακτική autosave-trigger ή βασιστείτε στην αυτόματη αποθήκευση της ίδιας της εφαρμογής.';

  @override
  String get skapiScriptSaveAllOpenSummaryHowLxDebian =>
      'Διατρέχει τη λίστα apps, βρίσκει τα ορατά παράθυρα κάθε εφαρμογής, τα ενεργοποιεί με τη σειρά και στέλνει Ctrl+S μεταξύ των αναμονών.';

  @override
  String get skapiScriptSaveAllOpenNoteLxDebian =>
      'Η προεπιλεγμένη λίστα εφαρμογών καλύπτει LibreOffice (soffice.bin), VS Code (code), gedit και kate. Περάστε --apps \"name1,name2\" για παράκαμψη. Μόνο X11.';

  @override
  String get skapiScriptSaveAllOpenParamAppsHintLxDebian =>
      'Ονόματα comm χωρισμένα με κόμμα, για παράδειγμα: soffice.bin,code,gedit.';

  @override
  String get skapiScriptAutosaveTriggerSummaryHowLxDebian =>
      'Διατρέχει κάθε ορατό παράθυρο ανώτατου επιπέδου μέσω wmctrl -l, ενεργοποιεί το καθένα με τη σειρά και εισάγει Ctrl+S. Το X11 δεν διαθέτει τη διαδρομή εκπομπής WIN WM_COMMAND οπότε η εστίαση ανά παράθυρο είναι η εναλλακτική.';

  @override
  String get skapiScriptAutosaveTriggerNoteLxDebian =>
      'Tier 2: εξαρτάται από το αν η εφαρμογή με εστίαση τιμά το Ctrl+S ως «αποθήκευση». Οι περισσότεροι επεξεργαστές το κάνουν· οι εφαρμογές συνομιλίας μπορεί να το παρερμηνεύσουν. Μόνο X11.';

  @override
  String get commonReadFailed => 'δεν ήταν δυνατή η ανάγνωση';

  @override
  String get commonUnknown => 'άγνωστο';

  @override
  String get commonComingSoon => 'σύντομα';

  @override
  String get commonDismiss => 'Απόρριψη';

  @override
  String bootstrapBannerError(String error) {
    return 'Δεν ήταν δυνατή η ανάγνωση από τη συσκευή: $error';
  }

  @override
  String get bootstrapBannerRetry => 'Επανάληψη';

  @override
  String get bfApiChainAuthNone => 'Κανένας';

  @override
  String get bfApiChainAuthBearer => 'Bearer token';

  @override
  String get bfApiChainAuthBasic => 'Βασικός έλεγχος ταυτότητας';

  @override
  String get bfApiChainAuthHeader => 'Προσαρμοσμένη κεφαλίδα';

  @override
  String bfApiChainMasterError(String error) {
    return 'Κύριος: $error';
  }

  @override
  String get bfApiChainChainStarted => 'Η αλυσίδα ξεκίνησε';

  @override
  String bfApiChainChainError(String error) {
    return 'Σφάλμα: $error';
  }

  @override
  String get bfApiChainSaveDialogTitle => 'Αποθήκευση endpoint;';

  @override
  String bfApiChainSaveDialogBody(String name) {
    return 'Το «$name» θα αποθηκευτεί μόνιμα στη συσκευή. Αυτό ενημερώνει την περιοχή δεδομένων χρήστη.';
  }

  @override
  String get bfApiChainSaveDialogConfirm => 'Αποθήκευση';

  @override
  String bfApiChainSavedToast(String name) {
    return 'Το «$name» αποθηκεύτηκε';
  }

  @override
  String bfApiChainSaveFailed(String error) {
    return 'Δεν ήταν δυνατή η αποθήκευση: $error';
  }

  @override
  String get bfApiChainDeleteDialogTitle => 'Διαγραφή;';

  @override
  String bfApiChainDeleteDialogBody(String name) {
    return 'Το endpoint «$name» θα αφαιρεθεί από τη συσκευή. Αυτή η ενέργεια δεν αναιρείται.';
  }

  @override
  String get bfApiChainDeleteDialogConfirm => 'Διαγραφή';

  @override
  String bfApiChainDeletedToast(String name) {
    return 'Το «$name» διαγράφηκε';
  }

  @override
  String bfApiChainDeleteFailed(String error) {
    return 'Δεν ήταν δυνατή η διαγραφή: $error';
  }

  @override
  String bfApiChainTestNoReply(String name) {
    return '«$name» καμία απάντηση (λήξη χρόνου 15 δ)';
  }

  @override
  String bfApiChainTestSuccess(String name, String httpSuffix) {
    return '«$name» επιτυχία$httpSuffix';
  }

  @override
  String bfApiChainTestFailure(String name, String error, String httpSuffix) {
    return '«$name» σφάλμα: $error$httpSuffix';
  }

  @override
  String bfApiChainTestTriggerFailed(String error) {
    return 'Δεν ήταν δυνατή η ενεργοποίηση: $error';
  }

  @override
  String get bfApiChainNewEndpointName => 'Νέο endpoint';

  @override
  String get bfApiChainEmptyTitle => 'Δεν έχουν καταχωρηθεί endpoints ακόμη';

  @override
  String get bfApiChainEmptyBody =>
      'Χρησιμοποιήστε την κάρτα «Προσθήκη endpoint» παρακάτω για να ορίσετε μια νέα κλήση HTTP (π.χ. webhook IFTTT, τον δικό σας διακομιστή, παύση Spotify).';

  @override
  String get bfApiChainSystemSectionTitle => 'Αυτόματο (συζευγμένα SKAPP)';

  @override
  String get bfApiChainSystemSectionSubtitle =>
      'Όταν συνδέετε ένα script μέσω SKAPI, μια υποδοχή ανοίγει αυτόματα για κάθε υπολογιστή. Όταν λήγει η αντίστροφη μέτρηση, ένα υπογεγραμμένο webhook πηγαίνει στο SKAPP εκείνου του υπολογιστή.';

  @override
  String get bfApiChainUserSectionTitle => 'Χειροκίνητο (συσκευές IoT)';

  @override
  String get bfApiChainUserSectionSubtitle =>
      'Προσθέστε URL τρίτων (Shelly, Home Assistant, IFTTT) χειροκίνητα. Όταν λήγει η αντίστροφη μέτρηση αυτή η λίστα ενεργοποιείται πρώτη, με τη σειρά.';

  @override
  String get bfApiChainMasterToggleLabel => 'Trigger ενεργό';

  @override
  String get bfApiChainMasterOnSubtitle =>
      'Κύριος ενεργός: η αλυσίδα ενεργοποιείται στα triggers της συσκευής';

  @override
  String get bfApiChainMasterOffSubtitle =>
      'Κύριος ανενεργός: κανένα endpoint δεν θα κληθεί';

  @override
  String get bfApiChainFieldNameLabel => 'Όνομα';

  @override
  String get bfApiChainTypeLabel => 'Τύπος';

  @override
  String get bfApiChainEventOrApplet => 'Συμβάν / Applet';

  @override
  String get bfApiChainMethodLabel => 'Μέθοδος';

  @override
  String get bfApiChainDelayLabel => 'Αναμονή μετά (0-300 δ)';

  @override
  String get bfApiChainDelayUnit => 'δ';

  @override
  String get bfApiChainAdvancedHide => 'Απόκρυψη επιλογών για προχωρημένους';

  @override
  String get bfApiChainAdvancedShow => 'Επιλογές για προχωρημένους';

  @override
  String get bfApiChainAuthLabel => 'Έλεγχος ταυτότητας';

  @override
  String bfApiChainCurrentTokenHint(String masked) {
    return 'Τρέχον token: $masked (γράψτε μια νέα τιμή παρακάτω για ανανέωση)';
  }

  @override
  String get bfApiChainNewTokenLabel => 'Νέο token (αφήστε κενό για διατήρηση)';

  @override
  String get bfApiChainContentTypeLabel => 'Content-Type';

  @override
  String get bfApiChainSaveCta => 'Αποθήκευση';

  @override
  String get bfApiChainDeleteCta => 'Διαγραφή';

  @override
  String get bfApiChainTestCta => 'Δοκιμή';

  @override
  String get bfApiChainAddCardLabel => 'Προσθήκη νέου endpoint';

  @override
  String bfApiChainSavedDelaySeconds(int count) {
    return 'αναμονή $count δ';
  }

  @override
  String get bfApiChainNotSaved => 'μη αποθηκευμένο';

  @override
  String bfApiChainSystemRowSignedTooltip(String peer, int delay) {
    return 'peer $peer…  ·  καθυστέρηση $delayδ  ·  υπογεγραμμένο (HMAC)';
  }

  @override
  String get bfApiChainTestEndpointTooltip => 'Δοκιμή αυτού του endpoint';

  @override
  String get bfLogsBufferEmpty =>
      'Η ενδιάμεση μνήμη αρχείων καταγραφής της συσκευής είναι κενή.';

  @override
  String get bfLogsUnsupported =>
      'Η συσκευή δεν υποστηρίζει αρχεία καταγραφής σε αυτό το firmware.';

  @override
  String get deviceLogsNoClockBanner =>
      'Το ρολόι της συσκευής δεν έχει ρυθμιστεί· οι χρονικές σημάνσεις εμφανίζονται ως δευτερόλεπτα από την εκκίνηση.';

  @override
  String get deviceLogsTruncatedHint =>
      '(η έξοδος περικόπηκε, δοκιμάστε χαμηλότερο όριο ή υψηλότερη σοβαρότητα)';

  @override
  String get bfEventsTimerRunning => 'Η αντίστροφη μέτρηση ξεκίνησε';

  @override
  String get bfEventsTimerPaused => 'Η αντίστροφη μέτρηση τέθηκε σε παύση';

  @override
  String get bfEventsTimerIdle => 'Η αντίστροφη μέτρηση επανήλθε';

  @override
  String get bfEventsTimerCooldown => 'Αναμονή';

  @override
  String get bfEventsTimerExpired => 'Η αντίστροφη μέτρηση τελείωσε';

  @override
  String bfEventsFaceChanged(String from, String to) {
    return 'Άλλαξε όψη: $from → $to';
  }

  @override
  String bfEventsApiTriggered(String type) {
    return 'Ενεργοποιήθηκε $type';
  }

  @override
  String get bfEventsApiTriggeredFallback => 'Ενεργοποιήθηκε API';

  @override
  String bfEventsBatteryLevel(int percent) {
    return 'Επίπεδο μπαταρίας: %$percent';
  }

  @override
  String get bfEventsDeviceRestarted => 'Η συσκευή επανεκκινήθηκε';

  @override
  String skapiManifestLoadingRetry(String platform, String scriptId) {
    return 'Φόρτωση manifest $platform/$scriptId, δοκιμάστε ξανά σε λίγο';
  }

  @override
  String get skapiListenerOffMobileTitle =>
      'Αυτή η συσκευή δεν μπορεί να εκτελέσει scripts επιτραπέζιου';

  @override
  String get skapiListenerOffDesktopTitle =>
      'Ο listener SKAPP HTTP είναι ανενεργός';

  @override
  String get skapiListenerOffMobileBody =>
      'Όταν λήξει η αντίστροφη μέτρηση, τα scripts θα εκτελεστούν σε Windows / macOS / Linux. Το SKAPP πρέπει να είναι ανοιχτό και ο listener ενεργός. Αυτό το τηλέφωνο είναι μόνο η πλευρά διαμόρφωσης· η εκτέλεση γίνεται στο επιτραπέζιο.';

  @override
  String skapiListenerOffDesktopBody(String lastErrorSuffix) {
    return 'Το BF θα ενεργοποιήσει το webhook, αλλά κανείς δεν θα το πιάσει επειδή ο listener είναι ανενεργός. Ανοίξτε Ρυθμίσεις → SKAPP HTTP Listener.$lastErrorSuffix';
  }

  @override
  String get skapiSyncBadgeWriting => 'Εγγραφή στο BF…';

  @override
  String get skapiSyncBadgeWritten => 'Αποθηκεύτηκε στο BF';

  @override
  String get skapiSyncBadgeFailed => 'Δεν ήταν δυνατή η εγγραφή στο BF';

  @override
  String skapiSyncBadgeFirmwareCodeTooltip(String code) {
    return 'Κωδικός firmware: $code';
  }

  @override
  String get syncErrUnknownCommand =>
      'Παλιό firmware στη συσκευή. Εγκαταστήστε το νέο firmware';

  @override
  String get syncErrNotAuthenticated =>
      'Η συνεδρία της συσκευής δεν είναι εξουσιοδοτημένη (μπορεί να χρειάζεται εκ νέου σύζευξη)';

  @override
  String get syncErrNotFound => 'Δεν υπάρχει εγγραφή σύζευξης στη συσκευή';

  @override
  String get syncErrInternal => 'Οι 8 υποδοχές SYSTEM μπορεί να είναι γεμάτες';

  @override
  String get syncErrUnknown => 'άγνωστο σφάλμα';

  @override
  String get syncErrTimeout => 'Η συσκευή δεν απάντησε (εκτός σύνδεσης;)';

  @override
  String get syncErrNoBond => 'Καμία σύζευξη με αυτή τη συσκευή';

  @override
  String get syncErrConnect => 'Δεν ήταν δυνατή η σύνδεση με τη συσκευή';

  @override
  String get discoveryFilterShowAll => 'Εμφάνιση όλων των συσκευών';

  @override
  String get discoveryFilterOnlySmartKraft => 'Μόνο SmartKraft';

  @override
  String discoveryScanningWithCount(int count, String tail) {
    return 'Σάρωση… βρέθηκαν $count συσκευές$tail';
  }

  @override
  String discoveryFoundCountWithTail(int count, String tail) {
    return 'Βρέθηκαν $count συσκευές$tail';
  }

  @override
  String discoveryFilterOff(int visible, int sk, String tail) {
    return 'Φίλτρο ανενεργό · εμφανίζονται $visible συσκευές ($sk SmartKraft$tail)';
  }

  @override
  String discoveryMdnsTail(int count) {
    return ' + $count στο δίκτυο';
  }

  @override
  String get discoveryWifiOnlySnack =>
      'Αυτή η συσκευή είναι αυτή τη στιγμή ορατή μόνο μέσω WiFi. Η σύζευξη WiFi δεν είναι ενεργή ακόμη, πατήστε σύντομα το κουμπί της συσκευής για να ανοίξετε το παράθυρο σύζευξης. Μόλις γίνει ορατή και μέσω BLE, αυτή η σειρά γίνεται συζεύξιμη.';

  @override
  String get discoveryBadgePairable => 'Συζεύξιμη';

  @override
  String get discoveryBadgeBonded => 'Συζευγμένη με άλλο SKAPP';

  @override
  String get pairingTitleConnecting => 'Σύνδεση';

  @override
  String get pairingTitleReconnecting => 'Επανασύνδεση';

  @override
  String get pairingMutualAuthHmacSubtitle => 'Πρόκληση-απόκριση HMAC';

  @override
  String pairingBleConnectFailed(String error) {
    return 'Η σύνδεση BLE απέτυχε.\n\nΔιόρθωση: πατήστε σύντομα το κουμπί της συσκευής για να ανοίξετε το παράθυρο σύζευξης 60 δευτερολέπτων, και μετά πατήστε «Επανάληψη».\n\nΛεπτομέρειες: $error';
  }

  @override
  String get pairingGattServiceMissing => 'Η υπηρεσία SKAPP δεν βρέθηκε';

  @override
  String get pairingGattCmdRxMissing => 'Λείπει το χαρακτηριστικό cmd_rx';

  @override
  String get pairingGattEventTxMissing => 'Λείπει το χαρακτηριστικό event_tx';

  @override
  String pairingGattDiscoveryFailed(String error) {
    return 'Η ανακάλυψη GATT απέτυχε: $error';
  }

  @override
  String pairingKeySendFailed(String error) {
    return 'Δεν ήταν δυνατή η αποστολή κλειδιού: $error';
  }

  @override
  String pairingDeviceNoReply(int seconds) {
    return 'Η συσκευή δεν απάντησε ($seconds δ).';
  }

  @override
  String pairingDeviceRejected(String error) {
    return 'Η συσκευή απέρριψε: $error';
  }

  @override
  String get pairingInvalidReplyMissingPub =>
      'Μη έγκυρη απάντηση συσκευής (λείπει το our_pub).';

  @override
  String pairingHexDecodeFailed(String error) {
    return 'Η αποκωδικοποίηση hex του our_pub απέτυχε: $error';
  }

  @override
  String get pairingRetryButton => 'Επανάληψη';

  @override
  String pairingReconnectTransient(String error) {
    return 'Δεν ήταν δυνατή η προσέγγιση της συσκευής· η υπάρχουσα σύζευξη διατηρείται.\n\nΒεβαιωθείτε ότι η συσκευή είναι ενεργοποιημένη και εντός εμβέλειας, και μετά πατήστε «Επανάληψη».\n\nΛεπτομέρειες: $error';
  }

  @override
  String get pairingRecoveryTitle => 'Ανανέωση σύζευξης';

  @override
  String get pairingRecoveryBody =>
      'Η συσκευή δεν αναγνωρίζει την τρέχουσα σύζευξη. Για να ξεκινήσετε μια νέα, πατήστε το κουμπί σύζευξης της συσκευής για να ανοίξετε το παράθυρο 60 δευτερολέπτων, και μετά πατήστε Συνέχεια.';

  @override
  String get pairingRecoveryContinue => 'Συνέχεια';

  @override
  String get pairingRecoveryCancelled =>
      'Η ανανέωση σύζευξης ακυρώθηκε. Η παλιά σύζευξη παραμένει καταχωρημένη· πατήστε «Επανάληψη» για να επιχειρήσετε μια άλλη σύνδεση αργότερα.';

  @override
  String get pairingRenewBondButton => 'Ανανέωση σύζευξης';

  @override
  String wifiPasswordConnectionRejected(String error) {
    return 'Η σύνδεση απορρίφθηκε: $error';
  }

  @override
  String get wifiPasswordTimeout => 'Η συσκευή δεν απάντησε (λήξη χρόνου).';

  @override
  String wifiScanRejected(String error) {
    return 'Η συσκευή απέρριψε το wifi.scan: $error\n\nΗ μονάδα WiFi της συσκευής μπορεί να μην έχει ξεκινήσει· δοκιμάστε επανεκκίνηση.';
  }

  @override
  String wifiScanUnexpectedReply(String data) {
    return 'Μη αναμενόμενη απάντηση wifi.scan: $data';
  }

  @override
  String wifiScanTimeout(String error) {
    return 'Η συσκευή δεν απάντησε (λήξη χρόνου: $error).\n\nΠλησιάστε τη συσκευή, πατήστε σύντομα το κουμπί της (για να ενεργοποιήσετε την εκπομπή) και δοκιμάστε ξανά.';
  }

  @override
  String wifiScanConnectionError(String error) {
    return 'Σφάλμα σύνδεσης: $error';
  }

  @override
  String get wifiScanHeaderHelp =>
      'Παρακάτω είναι τα δίκτυα WiFi που μπορεί να δει **η συσκευή** (όχι τα δίκτυα του τηλεφώνου). Επιλέξτε το δίκτυο στο οποίο πρέπει να συνδεθεί η συσκευή· ο κωδικός πρόσβασης ζητείται στο επόμενο βήμα.';

  @override
  String get wifiScanAuthOpen => 'Ανοιχτό';

  @override
  String get wifiScanAuthEncrypted => 'Κρυπτογραφημένο';

  @override
  String get wifiSuccessSyncing => 'Συγχρονισμός ώρας…';

  @override
  String get wifiSuccessFetchingInfo => 'Λήψη πληροφοριών συσκευής…';

  @override
  String get wifiSuccessPreparingUi => 'Προετοιμασία περιβάλλοντος συσκευής…';

  @override
  String wifiSuccessManifestRejected(String error) {
    return 'Το device.manifest απορρίφθηκε ($error). Μπορεί να είναι παλιό firmware· το sk_baseline.c πρέπει να είναι φορτωμένο για το BF.';
  }

  @override
  String get wifiSuccessTapToContinue => 'Πατήστε για συνέχεια…';

  @override
  String get deviceHomeUnsupportedTitle => 'Μη υποστηριζόμενη συσκευή';

  @override
  String deviceHomeUnsupportedBody(String name) {
    return 'Η $name δεν έχει οθόνη συσκευής σε αυτή την έκδοση του SKAPP. Όταν προστεθεί μια νέα οικογένεια συσκευών αυτή η οθόνη θα εμφανιστεί αυτόματα.';
  }

  @override
  String get lsPairingUnpairTitle => 'Αποσύζευξη αυτής της εφαρμογής';

  @override
  String get lsPairingUnpairBody =>
      'Η συσκευή θα ξεχάσει τη σύνδεση αυτής της εφαρμογής. Θα χρειαστεί να συζεύξετε ξανά (3 δ κουμπί + επιλογή στις Συσκευές).';

  @override
  String get skYakindaBadgeDefault => 'σύντομα';

  @override
  String get skapiScriptPulseBrightnessTitle => 'Παλμός φωτεινότητας';

  @override
  String get skapiScriptPulseBrightnessSummaryWhat =>
      'Διαμορφώνει τη φωτεινότητα της εσωτερικής οθόνης σε ένα ομαλό κύμα συνημιτόνου μεταξύ 100% και ενός κατώτερου ορίου, επαναλαμβανόμενο έναν καθορισμένο αριθμό φορών. Η αρχική φωτεινότητα του χρήστη επαναφέρεται στο τέλος.';

  @override
  String get skapiScriptPulseBrightnessSummaryHow =>
      'Διαβάζει την τρέχουσα φωτεινότητα μέσω WMI, και μετά γράφει ένα δείγμα φωτεινότητας 20 φορές ανά δευτερόλεπτο ακολουθώντας μια καμπύλη συνημιτόνου. Επαναφέρει πάντα την καταγεγραμμένη αρχική κατά την έξοδο.';

  @override
  String get skapiScriptPulseBrightnessNote =>
      'Μόνο εσωτερικές οθόνες (φορητοί, tablet). Οι εξωτερικές οθόνες DDC/CI δεν αποκρίνονται σε αυτή τη διαδρομή WMI.';

  @override
  String get skapiScriptPulseBrightnessParamPeriodLabel => 'period';

  @override
  String get skapiScriptPulseBrightnessParamPeriodHint =>
      'Δευτερόλεπτα για έναν πλήρη κύκλο φωτεινό -> σκούρο -> φωτεινό. Περίπου 2 μοιάζει με έναν καθαρό παλμό χωρίς να είναι ενοχλητικό.';

  @override
  String get skapiScriptPulseBrightnessParamLowPercentLabel => 'low %';

  @override
  String get skapiScriptPulseBrightnessParamLowPercentHint =>
      'Σκούρο άκρο του παλμού, ως ποσοστό της πλήρους φωτεινότητας. Χαμηλότεροι αριθμοί κάνουν τον παλμό πιο δραματικό.';

  @override
  String get skapiScriptPulseBrightnessParamCyclesLabel => 'cycles';

  @override
  String get skapiScriptPulseBrightnessParamCyclesHint =>
      'Πόσους πλήρεις κύκλους παλμού να εκτελέσει πριν την έξοδο.';

  @override
  String get skapiScriptBlurTimedTitle => 'Θολό διάλειμμα';

  @override
  String get skapiScriptBlurTimedSummaryWhat =>
      'Καλύπτει την οθόνη με ένα ημιδιαφανές πέπλο πλήρους οθόνης, πάντα στην κορυφή, για τον ρυθμισμένο αριθμό δευτερολέπτων. Μια αντίστροφη μέτρηση εμφανίζεται στο κέντρο.';

  @override
  String get skapiScriptBlurTimedSummaryHow =>
      'Ανοίγει ένα παράθυρο WPF χωρίς περίγραμμα με AllowsTransparency και ένα πινέλο συμπαγούς χρώματος στην επιλεγμένη αδιαφάνεια. Ένα χρονόμετρο dispatcher οδηγεί την αντίστροφη μέτρηση· το παράθυρο κλείνει μόνο του όταν το χρονόμετρο φτάσει στο μηδέν.';

  @override
  String get skapiScriptBlurTimedNote =>
      'Πραγματιστική ενδιάμεση λύση: το πραγματικό θόλωμα Gauss πάνω από την επιφάνεια εργασίας χρειάζεται έναν βοηθό C++/Win2D που έρχεται αργότερα. Το συμπαγές πέπλο δημιουργεί παρόμοια τριβή «δεν μπορώ να εστιάσω στην οθόνη, κάνε διάλειμμα» στο μεταξύ.';

  @override
  String get skapiScriptBlurTimedParamDurationLabel => 'duration';

  @override
  String get skapiScriptBlurTimedParamDurationHint =>
      'Δευτερόλεπτα που το πέπλο παραμένει πριν κλείσει αυτόματα.';

  @override
  String get skapiScriptBlurTimedParamOpacityLabel => 'opacity';

  @override
  String get skapiScriptBlurTimedParamOpacityHint =>
      'Αδιαφάνεια πέπλου 0.0 (αόρατο) έως 1.0 (συμπαγές). Περίπου 0.55 αφήνει ακόμη την επιφάνεια εργασίας να διαφαίνεται αρκετά ώστε να φαίνεται καλυμμένη, όχι μαυρισμένη.';

  @override
  String get skapiScriptBlurTimedParamColorLabel => 'color';

  @override
  String get skapiScriptBlurTimedParamColorHint =>
      'Χρώμα πέπλου σε δεκαεξαδικό #RRGGBB. Το μαύρο παλέτας #0A0A0A είναι η προεπιλογή· πιο ανοιχτοί τόνοι κρεμ φαίνονται πιο ήρεμοι.';

  @override
  String get skapiScriptBlockingFocusTitle => 'Blocking Focus';

  @override
  String get skapiScriptBlockingFocusSummaryWhat =>
      'Σύνθετος επιβολέας εστίασης: αποθηκεύει όλα τα ανοιχτά έγγραφα Office και VS Code, και μετά ανοίγει ένα παράθυρο αντίστροφης μέτρησης πλήρους οθόνης πάντα στην κορυφή χωρίς κουμπί κλεισίματος ενώ ο δρομέας του ποντικιού κάνει συνεχώς κύκλους. Όταν το χρονόμετρο φτάσει στο μηδέν όλα αναιρούνται αυτόματα.';

  @override
  String get skapiScriptBlockingFocusSummaryHow =>
      'Τρεις φάσεις εκτελούνται διαδοχικά: (1) η φάση αποθήκευσης καλεί το Office COM και το VS Code CLI· (2) ένα παράλληλο runspace οδηγεί τον δρομέα σε κύκλο μέχρι να αλλάξει μια συγχρονισμένη σημαία διακοπής· (3) ένα παράθυρο STA WPF εμφανίζει τον τίτλο και την αντίστροφη μέτρηση. Ένα μπλοκ finally επαναφέρει την αρχή του δρομέα και τερματίζει και τα δύο runspaces.';

  @override
  String get skapiScriptBlockingFocusNote =>
      'Απαλή λειτουργία: τα Esc και Alt+F4 ΔΕΝ μπλοκάρονται. Ο χρήστης μπορεί πάντα να διαφύγει μέσω της Διαχείρισης εργασιών. Η αυστηρή λειτουργία με καθολικά hooks πληκτρολογίου θα είναι ξεχωριστό script.';

  @override
  String get skapiScriptBlockingFocusParamDurationLabel => 'duration';

  @override
  String get skapiScriptBlockingFocusParamDurationHint =>
      'Δευτερόλεπτα που διαρκεί το κλείδωμα. Η αντίστροφη μέτρηση μετρά μέχρι το 00:00 και μετά όλα εκκαθαρίζονται.';

  @override
  String get skapiScriptBlockingFocusParamTitleLabel => 'title';

  @override
  String get skapiScriptBlockingFocusParamTitleHint =>
      'Κείμενο που εμφανίζεται στο κέντρο του παραθύρου πλήρους οθόνης. Κρατήστε το σύντομο - το «Blocking Focus» είναι η προεπιλογή.';

  @override
  String get skapiScriptBlockingFocusParamShakeRadiusLabel => 'shake radius';

  @override
  String get skapiScriptBlockingFocusParamShakeRadiusHint =>
      'Pixels που διανύει ο δρομέας από την αρχή του κατά τον βρόχο. Μεγαλύτεροι κύκλοι απαιτούν περισσότερη προσοχή.';

  @override
  String get skapiScriptBlockingFocusParamEnableSaveLabel => 'save on start';

  @override
  String get skapiScriptBlockingFocusParamEnableSaveHint =>
      'Εκτελέστε τη φάση αποθήκευσης Office + VS Code πριν το κλείδωμα. Απενεργοποιήστε όταν δεν υπάρχει κατάσταση εγγράφου προς προστασία.';

  @override
  String get trayFirstHideToast =>
      'Το SKAPP συνεχίζει να εκτελείται στο παρασκήνιο. Βρείτε το στην περιοχή ειδοποιήσεων του συστήματος· δεξί κλικ για Έξοδο.';

  @override
  String devicesOfflineTapHint(String name) {
    return 'Η $name είναι εκτός σύνδεσης.';
  }

  @override
  String skapiNewActionDeviceOffline(String name) {
    return 'Η $name είναι εκτός σύνδεσης. Συνδέστε την για να δημιουργήσετε μια νέα ενέργεια.';
  }

  @override
  String get bfApiChainRefreshDirtyTitle => 'Μη αποθηκευμένες αλλαγές';

  @override
  String get bfApiChainRefreshDirtyBody =>
      'Η ανανέωση θα φέρει την πιο πρόσφατη λίστα endpoints από τη συσκευή και θα απορρίψει το προσχέδιο που δεν έχετε αποθηκεύσει ακόμη.';

  @override
  String get bfApiChainRefreshDirtyConfirm => 'Ανανέωση ούτως ή άλλως';

  @override
  String get skapiApiEditorTitle => 'API στη συσκευή';

  @override
  String get lsCommonReadFailed => 'Η ανάγνωση απέτυχε';

  @override
  String lsCommonFailedWith(String err) {
    return 'Απέτυχε: $err';
  }

  @override
  String get lsVacationStatusOff => 'Ανενεργό';

  @override
  String lsVacationStatusUntil(String date) {
    return 'Έως $date';
  }

  @override
  String get lsVacationDaysValidationError =>
      'Οι μέρες πρέπει να είναι μεταξύ 1 και 60';

  @override
  String lsVacationStartedSnack(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Οι διακοπές ξεκίνησαν · $days μέρες',
      one: 'Οι διακοπές ξεκίνησαν · 1 μέρα',
    );
    return '$_temp0';
  }

  @override
  String get lsVacationCancelledSnack => 'Οι διακοπές ακυρώθηκαν';

  @override
  String lsVacationActiveUntilFmt(String date) {
    return 'Ενεργό έως $date';
  }

  @override
  String get lsVacationResumeHint =>
      'Η αντίστροφη μέτρηση θα συνεχιστεί όταν τελειώσουν οι διακοπές.';

  @override
  String get lsVacationCancellingButton => 'Ακύρωση…';

  @override
  String get lsVacationCancelButton => 'Ακύρωση διακοπών';

  @override
  String get lsVacationDaysLabel => 'Μέρες';

  @override
  String get lsVacationDaysHint =>
      'Θέτει σε παύση την αντίστροφη μέτρηση για τόσες μέρες (1 έως 60).';

  @override
  String get lsVacationStartingButton => 'Έναρξη…';

  @override
  String get lsVacationStartButton => 'Έναρξη διακοπών';

  @override
  String get lsCommonSavingButton => 'Αποθήκευση…';

  @override
  String get lsCommonSaveButton => 'Αποθήκευση';

  @override
  String lsCommonSaveFailedWith(String err) {
    return 'Η αποθήκευση απέτυχε: $err';
  }

  @override
  String get lsDurationValueValidationError =>
      'Η τιμή πρέπει να είναι μεταξύ 1 και 60';

  @override
  String get lsDurationAlarmsValidationError =>
      'Ο αριθμός ξυπνητηριών πρέπει να είναι μεταξύ 0 και 10';

  @override
  String get lsDurationConfiguredSnack => 'Το χρονόμετρο διαμορφώθηκε';

  @override
  String lsDurationUnitMinute(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value λεπτά',
      one: '1 λεπτό',
    );
    return '$_temp0';
  }

  @override
  String lsDurationUnitHour(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value ώρες',
      one: '1 ώρα',
    );
    return '$_temp0';
  }

  @override
  String lsDurationUnitDay(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value μέρες',
      one: '1 μέρα',
    );
    return '$_temp0';
  }

  @override
  String lsDurationAlarmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ξυπνητήρια',
      one: '1 ξυπνητήρι',
    );
    return '$_temp0';
  }

  @override
  String get lsDurationUnitLabel => 'Μονάδα';

  @override
  String get lsDurationUnitMinutesPlural => 'λεπτά';

  @override
  String get lsDurationUnitHoursPlural => 'ώρες';

  @override
  String get lsDurationUnitDaysPlural => 'μέρες';

  @override
  String get lsDurationValueLabel => 'Τιμή';

  @override
  String get lsDurationValueHint => '1 έως 60';

  @override
  String get lsDurationAlarmCountLabel => 'Αριθμός ξυπνητηριών';

  @override
  String get lsDurationAlarmCountHint =>
      'Τα ξυπνητήρια χτυπούν αντίστροφα από το τέλος, με απόσταση μίας μονάδας μεταξύ τους.';

  @override
  String get lsSmtpStatusNotConfigured => 'Μη διαμορφωμένο';

  @override
  String get lsSmtpHostRequired => 'Απαιτείται host';

  @override
  String get lsSmtpPortValidationError =>
      'Η θύρα πρέπει να είναι μεταξύ 1 και 65535';

  @override
  String get lsSmtpSenderRequired => 'Απαιτείται διεύθυνση αποστολέα';

  @override
  String get lsSmtpFieldHost => 'Host';

  @override
  String get lsSmtpFieldPort => 'Θύρα';

  @override
  String get lsSmtpFieldSender => 'Αποστολέας';

  @override
  String get lsSmtpFieldKey => 'Κλειδί';

  @override
  String lsSmtpSaveHaltedOn(String err) {
    return 'Η αποθήκευση σταμάτησε στο $err';
  }

  @override
  String get lsSmtpSavedSnack => 'Το SMTP αποθηκεύτηκε';

  @override
  String get lsSmtpTestSentSnack => 'Το δοκιμαστικό email στάλθηκε';

  @override
  String lsSmtpTestFailedWith(String err) {
    return 'Η δοκιμή απέτυχε: $err';
  }

  @override
  String get lsSmtpUrlCopiedSnack => 'Το URL αντιγράφηκε στο πρόχειρο';

  @override
  String get lsSmtpApiKeyPlaceholder => 'Κωδικός εφαρμογής Gmail / κλειδί API';

  @override
  String get lsSmtpServerLabel => 'Διακομιστής';

  @override
  String get lsSmtpApiKeyLabel => 'Κλειδί API';

  @override
  String get lsSmtpApiKeyHint =>
      'Αφήστε κενό για να διατηρήσετε το τρέχον κλειδί.';

  @override
  String get lsSmtpAppPasswordHelpLink =>
      'Πώς να αποκτήσετε κωδικό εφαρμογής Gmail';

  @override
  String get lsSmtpSendingButton => 'Αποστολή…';

  @override
  String get lsSmtpSendTestButton => 'Αποστολή δοκιμής';

  @override
  String get lsReminderMailRecipientValidation =>
      'Ο παραλήπτης πρέπει να μοιάζει με διεύθυνση email';

  @override
  String get lsReminderMailSavedSnack => 'Η υπενθύμιση αποθηκεύτηκε τοπικά';

  @override
  String get lsReminderMailRecipientFirstSnack => 'Ορίστε πρώτα έναν παραλήπτη';

  @override
  String get lsReminderMailTestOkSnack =>
      'Δοκιμή SMTP OK, τα διαπιστευτήρια φτάνουν στον διακομιστή';

  @override
  String lsReminderMailTestFailedWith(String err) {
    return 'Η δοκιμή SMTP απέτυχε: $err';
  }

  @override
  String get lsReminderMailRecipientLabel => 'Email παραλήπτη';

  @override
  String get lsReminderMailSubjectLabel => 'Θέμα';

  @override
  String get lsReminderMailBodyLabel => 'Σώμα';

  @override
  String get lsReminderMailBodyHint =>
      'Η αντίστροφη μέτρησή σας θα ενεργοποιηθεί σύντομα...';

  @override
  String get lsReminderMailActiveLabel => 'Ενεργό';

  @override
  String get lsReminderMailFootnote =>
      'Αποθηκεύεται τοπικά σε αυτή τη συσκευή. Η δοκιμή αποστολής επαληθεύει μόνο ότι ο διακομιστής SMTP είναι προσβάσιμος· η αυτόματη ενεργοποίηση στο timer.alarm εκκρεμεί υποστήριξη firmware.';

  @override
  String get lsResetApiStatusDisabled => 'Απενεργοποιημένο';

  @override
  String lsResetApiStatusEnabledPort(int port) {
    return 'Ενεργοποιημένο · θύρα $port';
  }

  @override
  String get lsResetApiRegenDialogTitle => 'Αναδημιουργία κλειδιού API;';

  @override
  String get lsResetApiRegenDialogBody =>
      'Αυτό θα ακυρώσει το τρέχον κλειδί. Κάθε καλών που χρησιμοποιεί το προηγούμενο κλειδί θα απορρίπτεται μέχρι να το ενημερώσετε. Συνέχεια;';

  @override
  String get lsResetApiRegenConfirm => 'Αναδημιουργία';

  @override
  String get lsResetApiKeyRegeneratedSnack => 'Το κλειδί αναδημιουργήθηκε';

  @override
  String get lsResetApiEnabledLabel => 'Ενεργοποιημένο';

  @override
  String get lsResetApiEnabledHint =>
      'Όταν είναι ενεργό, ένα HTTP GET στο URL του endpoint με το αντίστοιχο κλειδί επαναφέρει την αντίστροφη μέτρηση.';

  @override
  String get lsResetApiEndpointUrlLabel => 'URL endpoint';

  @override
  String get lsResetApiUrlNotAvailable => '(μη διαθέσιμο)';

  @override
  String get lsResetApiCopyUrlTooltip => 'Αντιγραφή URL';

  @override
  String get lsResetApiKeyLabel => 'Κλειδί API';

  @override
  String get lsResetApiKeyNotSet => '(δεν έχει οριστεί)';

  @override
  String get lsResetApiExampleLabel => 'Παράδειγμα';

  @override
  String get lsResetApiRegenerateButton => 'Αναδημιουργία κλειδιού';

  @override
  String get lsAlarmApiUrlValidation =>
      'Το URL πρέπει να ξεκινά με http:// ή https://';

  @override
  String get lsAlarmApiHeadersValidation =>
      'Το πεδίο κεφαλίδων πρέπει να είναι έγκυρο JSON';

  @override
  String get lsAlarmApiSaveDialogTitle => 'Αποθήκευση endpoint webhook;';

  @override
  String lsAlarmApiSaveDialogBody(String name, String url) {
    return 'Αποθηκεύει το `$name` στη συσκευή με προορισμό:\n$url';
  }

  @override
  String get lsAlarmApiSavedSnack => 'Το webhook αποθηκεύτηκε';

  @override
  String get lsAlarmApiDisabledSnack => 'Το webhook απενεργοποιήθηκε';

  @override
  String get lsAlarmApiTestQueuedSnack =>
      'Η δοκιμή τέθηκε σε ουρά, παρακολουθήστε την ανοδική υπηρεσία';

  @override
  String lsAlarmApiTestFailedWith(String err) {
    return 'Η δοκιμή απέτυχε: $err';
  }

  @override
  String get lsAlarmApiRemoveDialogTitle => 'Αφαίρεση webhook;';

  @override
  String lsAlarmApiRemoveDialogBody(String name) {
    return 'Διαγράφει το `$name` από τη συσκευή. Η τοπική διαμόρφωση διατηρείται.';
  }

  @override
  String get lsAlarmApiRemoveButton => 'Αφαίρεση';

  @override
  String lsAlarmApiRemoveFailedWith(String err) {
    return 'Η αφαίρεση απέτυχε: $err';
  }

  @override
  String get lsAlarmApiConfiguredStatus => 'Διαμορφωμένο';

  @override
  String lsAlarmApiConfiguredHost(String host) {
    return 'Διαμορφωμένο · $host';
  }

  @override
  String get lsAlarmApiUrlLabel => 'URL';

  @override
  String get lsAlarmApiMethodLabel => 'Μέθοδος HTTP';

  @override
  String get lsAlarmApiHeadersLabel => 'Κεφαλίδες (JSON, προαιρετικό)';

  @override
  String get lsAlarmApiHeadersHint =>
      'Αντικείμενο JSON με προαιρετικές κεφαλίδες. Αποθηκεύεται τοπικά· το firmware το εφαρμόζει κατά την ενεργοποίηση.';

  @override
  String get lsAlarmApiBodyTemplateLabel => 'Πρότυπο σώματος (JSON)';

  @override
  String get lsAlarmApiBodyTemplateHint =>
      'Τα σύμβολα κράτησης θέσης device και remaining_sec αντικαθίστανται κατά την ενεργοποίηση.';

  @override
  String get lsAlarmApiBearerLabel => 'Bearer token (προαιρετικό)';

  @override
  String get lsAlarmApiFootnote =>
      'Ο συνδρομητής firmware για το συμβάν timer.alarm εκκρεμεί. Αυτή η διαμόρφωση αποθηκεύει το endpoint· δεν θα ενεργοποιηθεί αυτόματα μέχρι την επόμενη ενημέρωση firmware.';

  @override
  String lsRelaySummarySeconds(int seconds) {
    return '$secondsδ';
  }

  @override
  String lsRelaySummaryMinutes(int minutes) {
    return '$minutes λεπτά';
  }

  @override
  String get lsRelayModePulse => 'παλμός';

  @override
  String get lsRelayModeSteady => 'σταθερό';

  @override
  String lsRelaySummaryFmt(int gpio, String duration, String mode) {
    return 'GPIO $gpio · $duration $mode';
  }

  @override
  String get lsRelayGpioValidation => 'Το GPIO πρέπει να είναι μεταξύ 0 και 30';

  @override
  String get lsRelayDurationValidation =>
      'Η διάρκεια πρέπει να είναι μεταξύ 1 και 3600 δευτερολέπτων';

  @override
  String get lsRelayPulseValidation =>
      'Ο μισός κύκλος παλμού πρέπει να είναι μεταξύ 1 και 60';

  @override
  String lsRelayCmdFailedWith(String cmd, String err) {
    return 'Το $cmd απέτυχε: $err';
  }

  @override
  String get lsRelayConfiguredSnack => 'Το ρελέ διαμορφώθηκε';

  @override
  String get lsRelayFireAbortedSnack => 'Η ενεργοποίηση ματαιώθηκε';

  @override
  String get lsRelayForcedIdleSnack => 'Το ρελέ τέθηκε αναγκαστικά σε αδράνεια';

  @override
  String get lsRelayGpioLabel => 'Ακροδέκτης GPIO';

  @override
  String get lsRelayGpioHint =>
      'Έγκυρος ακροδέκτης ESP32-C6· προεπιλογή 19 = D8';

  @override
  String get lsRelayInvertLabel => 'Αντιστροφή πολικότητας';

  @override
  String get lsRelayStartDelayLabel => 'Καθυστέρηση έναρξης';

  @override
  String lsRelayStartDelayHint(int sec) {
    return '$secδ πριν ενεργοποιηθεί το ρελέ';
  }

  @override
  String get lsRelayActiveDurationLabel => 'Διάρκεια ενεργοποίησης';

  @override
  String get lsRelayUnitSeconds => 'Δευτερόλεπτα';

  @override
  String get lsRelayUnitMinutes => 'Λεπτά';

  @override
  String get lsRelayPulseModeLabel => 'Λειτουργία παλμού';

  @override
  String get lsRelayPulseModeHint =>
      'Ενεργό = μισός κύκλος 1 δ. Το Προσαρμοσμένο σας επιτρέπει να ορίσετε τον μισό κύκλο.';

  @override
  String get lsRelayHalfCycleLabel => 'Δευτερόλεπτα μισού κύκλου';

  @override
  String get lsRelayFiringButton => 'Ενεργοποίηση…';

  @override
  String get lsRelayTestRelayButton => 'Δοκιμή ρελέ';

  @override
  String get lsRelayAbortButton => 'Ματαίωση';

  @override
  String get lsRelayForceOffButton => 'Αναγκαστική απενεργοποίηση';

  @override
  String get lsRelayPulseOff => 'Ανενεργό';

  @override
  String get lsRelayPulseOn => 'Ενεργό';

  @override
  String get lsRelayPulseCustom => 'Προσαρμοσμένο';

  @override
  String get lsRelayPhaseActiveBadge => 'ενεργή';

  @override
  String lsRelayPhaseLine(String phase, String elapsed) {
    return 'Φάση: $phase$elapsed';
  }

  @override
  String get lsTelegramTokenRequired => 'Απαιτείται token bot';

  @override
  String get lsTelegramChatRequired => 'Απαιτείται chat id';

  @override
  String get lsTelegramSaveDialogTitle => 'Αποθήκευση endpoint Telegram;';

  @override
  String lsTelegramSaveDialogBody(String name) {
    return 'Αποθηκεύει το `$name` στη συσκευή. Το token στέλνεται στο URL.';
  }

  @override
  String get lsTelegramSavedSnack => 'Το endpoint Telegram αποθηκεύτηκε';

  @override
  String get lsTelegramDisabledSnack => 'Το endpoint Telegram απενεργοποιήθηκε';

  @override
  String get lsTelegramTestQueuedSnack =>
      'Η δοκιμή τέθηκε σε ουρά, παρακολουθήστε τη συνομιλία Telegram';

  @override
  String get lsTelegramRemoveDialogTitle => 'Αφαίρεση endpoint Telegram;';

  @override
  String get lsTelegramBotConfiguredStatus => 'Το bot διαμορφώθηκε';

  @override
  String get lsTelegramBotTokenLabel => 'Token bot';

  @override
  String get lsTelegramBotTokenHint =>
      'Αποκτήστε ένα από το @BotFather (μοιάζει με 1234567:AAH...).';

  @override
  String get lsTelegramChatIdLabel => 'Chat ID';

  @override
  String get lsTelegramChatIdHint =>
      'Ένα αριθμητικό id (-100...) ή όνομα χρήστη @channel.';

  @override
  String get lsTelegramMessageTemplateLabel => 'Πρότυπο μηνύματος';

  @override
  String get lsTelegramMessageHint => 'LebensSpur: Ενεργοποιήθηκε ξυπνητήρι.';

  @override
  String get lsLsApiUrlRequired => 'Απαιτείται URL';

  @override
  String get lsLsApiUpdatedSnack => 'Το webhook ενημερώθηκε';

  @override
  String get lsLsApiSavedSnack => 'Το webhook αποθηκεύτηκε';

  @override
  String get lsLsApiSaveFirstSnack => 'Αποθηκεύστε πρώτα το webhook';

  @override
  String get lsLsApiTestQueuedSnack =>
      'Η δοκιμή τέθηκε σε ουρά, ελέγξτε τον δέκτη';

  @override
  String get lsLsApiRemoveDialogBody =>
      'Το webhook LS θα διαγραφεί από τη συσκευή. Η αντίστροφη μέτρηση δεν θα το ενεργοποιεί πλέον.';

  @override
  String get lsLsApiRemovedSnack => 'Το webhook αφαιρέθηκε';

  @override
  String get lsLsApiConfirmCriticalTitle => 'Επιβεβαίωση κρίσιμης αλλαγής';

  @override
  String lsLsApiConfirmCriticalBody(String cmd, int ttlSec) {
    return 'Η συσκευή ζητά επιβεβαίωση:\n  $cmd\n\nΑυτό το token λήγει σε $ttlSecδ.';
  }

  @override
  String get lsLsApiConfirmButton => 'Επιβεβαίωση';

  @override
  String lsLsApiActiveSlot(String name) {
    return 'Ενεργή · υποδοχή «$name»';
  }

  @override
  String lsLsApiActiveWithToken(String name, String token) {
    return 'Ενεργή · υποδοχή «$name» · token $token';
  }

  @override
  String get lsLsApiUrlHint =>
      'Ενεργοποιείται όταν ενεργοποιείται το timer.triggered. Συνιστάται https://.';

  @override
  String get lsLsApiHeadersLabel => 'Κεφαλίδες (JSON)';

  @override
  String get lsLsApiHeadersHint =>
      'Για προχωρημένους: δεν έχει ακόμη συνδεθεί μέσω CLI. Δεσμευμένο για μελλοντική έκδοση.';

  @override
  String get lsLsApiBodyTemplateHint =>
      'Στέλνεται ως το δοκιμαστικό payload. Το σύμβολο κράτησης θέσης device αντικαθίσταται στην πλευρά του διακομιστή.';

  @override
  String lsLsApiBearerHintExisting(String token) {
    return 'Τρέχουσα ρύθμιση: $token. Αφήστε κενό για διατήρηση, ή επικολλήστε μια νέα τιμή για αντικατάσταση.';
  }

  @override
  String get lsLsApiBearerHintEmpty =>
      'Στέλνεται ως `Authorization: Bearer <token>`.';

  @override
  String get lsLsApiUpdateButton => 'Ενημέρωση';

  @override
  String lsMailGroupsStatusFmt(int count, int max, int recipients) {
    return '$count από $max · $recipients παραλήπτες συνολικά';
  }

  @override
  String lsMailGroupsReadFailedWith(String err) {
    return 'Η ανάγνωση απέτυχε: $err';
  }

  @override
  String get lsMailGroupsNameValidation =>
      'Το όνομα πρέπει να είναι μεταξύ 1 και 47 χαρακτήρων';

  @override
  String get lsMailGroupsNameSaved => 'Το όνομα αποθηκεύτηκε';

  @override
  String get lsMailGroupsSubjectValidation =>
      'Το θέμα πρέπει να είναι το πολύ 127 χαρακτήρες';

  @override
  String get lsMailGroupsSubjectSaved => 'Το θέμα αποθηκεύτηκε';

  @override
  String get lsMailGroupsBodyValidation =>
      'Το σώμα πρέπει να είναι το πολύ 511 χαρακτήρες';

  @override
  String get lsMailGroupsBodySaved => 'Το σώμα αποθηκεύτηκε';

  @override
  String get lsMailGroupsEmailValidation => 'Εισαγάγετε ένα έγκυρο email';

  @override
  String lsMailGroupsMaxReached(int max) {
    return 'Το μέγιστο είναι $max ομάδες';
  }

  @override
  String get lsMailGroupsNameEmpty => 'Το όνομα δεν μπορεί να είναι κενό';

  @override
  String get lsMailGroupsCreatedSnack => 'Η ομάδα δημιουργήθηκε';

  @override
  String lsMailGroupsCreateFailedWith(String err) {
    return 'Η δημιουργία απέτυχε: $err';
  }

  @override
  String get lsMailGroupsDeleteDialogTitle => 'Διαγραφή ομάδας;';

  @override
  String get lsMailGroupsDeleteDialogBody =>
      'Αυτό αφαιρεί την ομάδα και όλους τους παραλήπτες της στη συσκευή.';

  @override
  String get lsMailGroupsDeleteConfirm => 'Διαγραφή';

  @override
  String get lsMailGroupsDeletedSnack => 'Η ομάδα διαγράφηκε';

  @override
  String lsMailGroupsDefaultName(int n) {
    return 'Ομάδα $n';
  }

  @override
  String get lsMailGroupsNewGroupTitle => 'Νέα ομάδα email';

  @override
  String get lsMailGroupsGroupNameLabel => 'Όνομα ομάδας';

  @override
  String get lsMailGroupsCreateConfirm => 'Δημιουργία';

  @override
  String get lsMailGroupsEmptyHint =>
      'Δεν υπάρχουν ομάδες ακόμη. Δημιουργήστε μία για να στέλνετε email όταν ενεργοποιείται το χρονόμετρο.';

  @override
  String get lsMailGroupsWorkingButton => 'Επεξεργασία…';

  @override
  String get lsMailGroupsCreateNewButton => '+ Δημιουργία νέας ομάδας';

  @override
  String lsMailGroupsHeaderCount(int count, int max) {
    return '$count από $max ομάδες διαμορφωμένες';
  }

  @override
  String lsMailGroupsHeaderTotalRecipients(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count παραλήπτες συνολικά',
      one: '1 παραλήπτης συνολικά',
    );
    return '· $_temp0';
  }

  @override
  String get lsMailGroupsUnnamed => '(χωρίς όνομα)';

  @override
  String lsMailGroupsRowSummary(int count, String state) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count παραλήπτες',
      one: '1 παραλήπτης',
    );
    return '$_temp0 · $state';
  }

  @override
  String get lsMailGroupsEnabled => 'ενεργοποιημένη';

  @override
  String get lsMailGroupsDisabled => 'απενεργοποιημένη';

  @override
  String get lsMailGroupsNameLabel => 'Όνομα';

  @override
  String get lsMailGroupsSubjectLabel => 'Θέμα';

  @override
  String get lsMailGroupsSaveBodyButton => 'Αποθήκευση σώματος';

  @override
  String get lsMailGroupsDeleteGroupButton => 'Διαγραφή ομάδας';

  @override
  String lsMailGroupsRecipientsHeader(int count) {
    return 'Παραλήπτες ($count)';
  }

  @override
  String get lsMailGroupsNoRecipients => 'Δεν υπάρχουν παραλήπτες ακόμη.';

  @override
  String get lsMailGroupsAddRecipientButton => 'Προσθήκη';

  @override
  String get lsHomeStatusLoading => 'Φόρτωση…';

  @override
  String get lsHomeLogsTooltip => 'Αρχεία καταγραφής';

  @override
  String get lsHomeClusterConfiguration => 'ΔΙΑΜΟΡΦΩΣΗ';

  @override
  String get lsHomeClusterTriggerActions => 'ΕΝΕΡΓΕΙΕΣ TRIGGER';

  @override
  String get lsHomeClusterEarlyWarning => 'ΕΓΚΑΙΡΗ ΠΡΟΕΙΔΟΠΟΙΗΣΗ';

  @override
  String get lsHomeSectionDurationTitle => 'Διάρκεια & Ξυπνητήρια';

  @override
  String get lsHomeSectionVacationTitle => 'Λειτουργία διακοπών';

  @override
  String get lsHomeSectionSmtpTitle => 'Ρύθμιση email (SMTP)';

  @override
  String get lsHomeSectionResetApiTitle => 'Endpoint API επαναφοράς';

  @override
  String get lsHomeSectionMailGroupsTitle => 'Ομάδες email';

  @override
  String get lsHomeSectionRelayTitle => 'Ρελέ';

  @override
  String get lsHomeSectionLsApiTitle => 'Webhook LS API';

  @override
  String get lsHomeSectionTelegramTitle => 'Telegram';

  @override
  String get lsHomeSectionReminderMailTitle => 'Email υπενθύμισης';

  @override
  String get lsHomeSectionAlarmApiTitle => 'Webhook Alarm API';

  @override
  String get lsHomeStateInactive => 'ΑΝΕΝΕΡΓΟ';

  @override
  String get lsHomeStateRemaining => 'ΑΠΟΜΕΝΟΥΝ';

  @override
  String get lsHomeStateVacation => 'ΔΙΑΚΟΠΕΣ';

  @override
  String get lsHomeStateTriggered => 'ΕΝΕΡΓΟΠΟΙΗΘΗΚΕ';

  @override
  String get lsHomeChipBle => 'BLE';

  @override
  String get lsHomeChipMail => 'Email';

  @override
  String get lsHomeEarlyWarningPendingNote =>
      'Οι ενέργειες έγκαιρης προειδοποίησης ενεργοποιούνται στο timer.alarm. Ο συνδρομητής firmware εκκρεμεί· αυτές οι διαμορφώσεις διατηρούνται αλλά δεν θα ενεργοποιηθούν αυτόματα ακόμη.';

  @override
  String get settingsDiagnosticsTitle => 'Διαγνωστικά';

  @override
  String get settingsDiagnosticsSubtitle =>
      'Αρχεία καταγραφής για τη διάγνωση προβλημάτων';

  @override
  String get diagnosticsCopyLogs => 'Αντιγραφή αρχείων καταγραφής';

  @override
  String get diagnosticsOpenFolder => 'Άνοιγμα φακέλου';

  @override
  String get diagnosticsOpenFolderFailed =>
      'Δεν ήταν δυνατό το άνοιγμα του φακέλου αρχείων καταγραφής.';

  @override
  String get diagnosticsShareLogs => 'Κοινή χρήση αρχείων καταγραφής';

  @override
  String get diagnosticsClearLogs => 'Εκκαθάριση αρχείων καταγραφής';

  @override
  String get diagnosticsCopied =>
      'Τα αρχεία καταγραφής αντιγράφηκαν στο πρόχειρο';

  @override
  String get diagnosticsCleared => 'Τα αρχεία καταγραφής εκκαθαρίστηκαν';

  @override
  String get aboutPrivacyLabel => 'Πολιτική απορρήτου';

  @override
  String get updateChecking => 'Έλεγχος για ενημερώσεις…';

  @override
  String get updateUpToDate => 'Έχετε την πιο πρόσφατη έκδοση';

  @override
  String get updateCheckFailed => 'Δεν ήταν δυνατός ο έλεγχος για ενημερώσεις';

  @override
  String get updateAvailableTitle => 'Διαθέσιμη ενημέρωση';

  @override
  String updateAvailableBody(String version, String current) {
    return 'Μια νέα έκδοση ($version) είναι διαθέσιμη. Έχετε την $current.';
  }

  @override
  String get updateDownloadAction => 'Λήψη';

  @override
  String get updateLater => 'Αργότερα';
}
