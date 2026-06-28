// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'SKAPP';

  @override
  String get brandTagline => 'SmartKraft';

  @override
  String get tabHome => 'Start';

  @override
  String get tabDevices => 'Geräte';

  @override
  String get tabSkapi => 'SKAPI';

  @override
  String get tabSettings => 'Einstellungen';

  @override
  String get tabSmartKraft => 'SmartKraft';

  @override
  String get comingSoonBadge => 'demnächst';

  @override
  String get featureComingSoonSnack => 'Diese Funktion kommt bald';

  @override
  String get homeWelcome => 'Willkommen bei SmartKraft';

  @override
  String get homeSubtitle => 'Verwalte deine SmartKraft-Geräte';

  @override
  String get homeAddDevice => 'Neues Gerät hinzufügen';

  @override
  String get homeNoDevicesTitle => 'Noch keine Geräte';

  @override
  String get homeNoDevicesHint =>
      'Füge dein erstes SmartKraft-Gerät hinzu, um loszulegen.';

  @override
  String get homeSummaryTitle => 'Übersicht';

  @override
  String homeDevicesOnline(int count) {
    return '$count verbunden';
  }

  @override
  String homeDevicesOffline(int count) {
    return '$count offline';
  }

  @override
  String get homeUpdatesTitle => 'Updates verfügbar';

  @override
  String homeUpdatesBody(int count) {
    return '$count Gerät hat eine neuere Firmware.';
  }

  @override
  String get homeWarningsTitle => 'Warnungen';

  @override
  String homeWarningsBody(int count) {
    return '$count Gerät hat ein Problem gemeldet.';
  }

  @override
  String get homeAllGood => 'Alles läuft reibungslos.';

  @override
  String get devicesTitle => 'Geräte';

  @override
  String get devicesEmpty =>
      'Noch keine Geräte hinzugefügt.\nTippe auf das +, um eines hinzuzufügen.';

  @override
  String get devicesAdd => 'Gerät hinzufügen';

  @override
  String get devicesAllSection => 'Alle Geräte';

  @override
  String get devicesGroupsTitle => 'Deine Gruppen';

  @override
  String get devicesGroupsHint =>
      'Erstelle Gruppen, um deine Geräte ganz nach Wunsch zu ordnen.';

  @override
  String get devicesGroupsCreate => 'Neue Gruppe';

  @override
  String get devicesGroupsEmpty => 'Noch keine Gruppen.';

  @override
  String get skapiTitle => 'SKAPI';

  @override
  String get skapiLibraryHeading => 'SKAPI-Bibliothek';

  @override
  String get skapiLibrarySubtitle =>
      'Wähle die Plattform, die deine Geräte auslösen sollen.';

  @override
  String get skapiThisComputer => 'Dieser Computer';

  @override
  String skapiCategoryCount(int count) {
    return '$count Kategorien';
  }

  @override
  String get skapiPlatformMac => 'macOS';

  @override
  String get skapiPlatformWin => 'Windows';

  @override
  String get skapiPlatformLinux => 'Linux';

  @override
  String get skapiPlatformOther => 'Andere';

  @override
  String get skapiStarredHeading => 'Favorisierte APIs';

  @override
  String get skapiStarredEmpty =>
      'Markiere Vorlagen aus der Bibliothek mit einem Stern, dann erscheinen sie hier.';

  @override
  String get skapiContributeTitle =>
      'Sende deine Bibliothek an die SmartKraft-Community';

  @override
  String get skapiContributeBody => 'Diese Karte wird später gestaltet.';

  @override
  String get skapiSearchPlaceholder => 'Aktionen suchen…';

  @override
  String get skapiSearchDisabledHint =>
      'Wird aktiv, sobald der SKAPI-Parser angebunden ist.';

  @override
  String get skapiHelpButtonTooltip => 'Über SKAPI';

  @override
  String get skapiHelpSheetTitle => 'Über SKAPI';

  @override
  String get skapiHelpIntro =>
      'SKAPI ist eine Bibliothek von Aktionen, die deine SmartKraft-Geräte auf deinem Computer auslösen können.';

  @override
  String get skapiHelpStep1Title => 'Vorlage durchsuchen';

  @override
  String get skapiHelpStep1Body =>
      'Wähle einen Ausgangspunkt aus der SKAPI-Bibliothek.';

  @override
  String get skapiHelpStep2Title => 'Konfigurieren';

  @override
  String get skapiHelpStep2Body =>
      'Lege Parameter fest und wähle, welches Gerät sie auslöst.';

  @override
  String get skapiHelpStep3Title => 'An Gerät senden';

  @override
  String get skapiHelpStep3Body =>
      'Das Gerät speichert den API-Auslöser; SKAPP führt das Skript aus.';

  @override
  String get skapiHelpGlossaryTitle => 'Glossar';

  @override
  String get skapiHelpGlossaryTemplate =>
      'Vorlage: ein schreibgeschützter Bibliothekseintrag';

  @override
  String get skapiHelpGlossaryAction =>
      'Aktion: ein konfiguriertes Paar aus API-Auslöser + Skript';

  @override
  String get skapiHelpGlossaryApiTrigger =>
      'API-Auslöser: was das Gerät aufruft';

  @override
  String get skapiHelpGlossaryScript => 'Skript: was dein Computer ausführt';

  @override
  String get skapiHelpPhase1Notice =>
      'SKAPI ist noch im Aufbau. Der Großteil dieses Tabs ist ein Gerüst; Bereiche mit „noch nicht aktiv“ schalten sich frei, sobald Parser, Listener und Formularbaukasten fertig sind.';

  @override
  String get skapiMobileBannerBody =>
      'Dieses Handy kann kein Ziel sein. Um Aktionen auszuführen, muss SKAPP auf deinem Computer geöffnet sein.';

  @override
  String get skapiActionsHeading => 'Meine Aktionen';

  @override
  String get skapiActionsNoDevicesTitle => 'Noch keine Geräte';

  @override
  String get skapiActionsNoDevicesBody =>
      'Koppele zuerst ein SmartKraft-Gerät; wechsle zum Tab „Geräte“.';

  @override
  String get skapiActionsCreationDisabled =>
      'Das Erstellen von Aktionen ist noch nicht aktiv.';

  @override
  String get skapiActionsOfflineDetectionDisabled =>
      'Online-Erkennung noch nicht aktiv';

  @override
  String get skapiActionsMaxLimitNote => 'Bis zu 5 Aktionen pro Gerät.';

  @override
  String get skapiActionsAddCta => 'Aktion hinzufügen';

  @override
  String skapiHeaderSub(int platforms, int actions) {
    return '$platforms Plattformen · $actions Aktionen';
  }

  @override
  String get skapiNewActionPill => 'Neue Aktion';

  @override
  String skapiActionsSubLine(int count) {
    return 'Gerät × Skript-Bindungen · $count aktiv';
  }

  @override
  String get skapiActionsEmptyHint =>
      'Noch keine Aktionen. Lege fest, was beim Drücken einer Gerätetaste passiert.';

  @override
  String get skapiActionsCreateCta => 'Erstellen';

  @override
  String skapiActionsGroupTitle(String name) {
    return '$name-Aktionen';
  }

  @override
  String skapiActionsGroupCount(int count) {
    return '$count';
  }

  @override
  String get skapiListenerEndpointTitle => 'An BF-Geräte gesendete Webhook-URL';

  @override
  String get skapiListenerEndpointBody =>
      'Wenn ein BF im selben Wi-Fi diese URL nach dem Countdown nicht erreicht, ist womöglich die falsche NIC deines Laptops gewählt (z. B. WSL/VirtualBox/Docker-Netzwerk). Tippe auf Aktualisieren, um sie erneut zu senden.';

  @override
  String get skapiListenerEndpointResolving => 'Lokale IP wird ermittelt…';

  @override
  String get skapiListenerEndpointUnavailable =>
      'Keine nutzbare LAN-Schnittstelle gefunden.';

  @override
  String get skapiListenerEndpointRefresh => 'Aktualisieren';

  @override
  String get skapiListenerEndpointRefreshing => 'Wird gesendet…';

  @override
  String skapiListenerEndpointPushedAt(String when) {
    return 'Zuletzt aktualisiert $when';
  }

  @override
  String get skapiListenerSelfTest => 'Selbsttest';

  @override
  String get skapiListenerSelfTestRunning => 'Test läuft…';

  @override
  String get skapiListenerSelfTestPassed =>
      'Selbsttest OK: Listener von diesem Host erreichbar.';

  @override
  String get skapiListenerSelfTestFailed =>
      'Selbsttest FEHLGESCHLAGEN: Listener nicht erreichbar. Prüfe die Windows-Firewall.';

  @override
  String get skapiWebhookActivityTitle => 'Letzte Webhooks';

  @override
  String get skapiWebhookActivityNone =>
      'Noch keine Webhooks empfangen. Nach Ablauf des Gerätetimers sollte hier innerhalb von Sekunden ein Eintrag erscheinen.';

  @override
  String get skapiWebhookActivityAccepted => 'Angenommen';

  @override
  String skapiWebhookActivityRejected(int code) {
    return 'Abgelehnt ($code)';
  }

  @override
  String get skapiWebhookActivityMalformed => 'Fehlerhaft';

  @override
  String get skapiWebhookActivitySelfTest => 'Selbsttest';

  @override
  String get skapiWebhookActivityNoMatch => 'Keine Bindung passte';

  @override
  String get skapiWebhookActivityScriptError => 'Skriptfehler';

  @override
  String skapiWebhookActivityMatched(int count) {
    return '$count Skript(e) ausgeführt';
  }

  @override
  String get skapiBfEndpointsButton => 'BF-Endpunkte prüfen';

  @override
  String get skapiBfEndpointsTitle => 'Auf BF-Geräten gespeicherte Endpunkte';

  @override
  String get skapiBfEndpointsHint =>
      'Schreibgeschützter Schnappschuss von api.endpoint.list jedes gekoppelten Geräts. Vergleiche jede SYSTEM-Slot-URL mit der Listener-URL oben. Sie müssen exakt übereinstimmen. USER-Slots gehören womöglich zu manuellen Webhooks und könnten bei Fehlkonfiguration deinen Countdown abfangen.';

  @override
  String get skapiBfEndpointsLoading => 'BF-Geräte werden abgefragt…';

  @override
  String get skapiBfEndpointsErrorPrefix => 'Abfrage fehlgeschlagen:';

  @override
  String get skapiBfEndpointsKindSystem => 'SYSTEM';

  @override
  String get skapiBfEndpointsKindUser => 'USER';

  @override
  String get skapiBfEndpointsEmpty =>
      'Keine Endpunkte auf diesem Gerät gespeichert.';

  @override
  String get skapiBfEndpointsClose => 'Schließen';

  @override
  String get skapiBfEndpointsRefresh => 'Erneut abfragen';

  @override
  String skapiStarredCount(int count) {
    return '$count favorisiert';
  }

  @override
  String get skapiStarredSlimEmpty =>
      'Markiere Bibliothekseinträge mit einem Stern, um deine meistgenutzten hier zu sammeln.';

  @override
  String get skapiCommunityShareTitle =>
      'Teile deine Bibliothek mit der SmartKraft-Community';

  @override
  String get skapiCommunityShareBody =>
      'Skripte, die du schreibst, stehen allen in der SKAPI-Bibliothek zur Verfügung.';

  @override
  String get settingsNetworkIdentityTitle => 'Netzwerkidentität';

  @override
  String get settingsNetworkIdentityName => 'Computername';

  @override
  String get settingsNetworkIdentityNameHint =>
      'Wird als mDNS-Instanzname verwendet';

  @override
  String get settingsNetworkIdentityNameEdit => 'Umbenennen';

  @override
  String get settingsNetworkIdentityNameDialogTitle =>
      'Diesen Computer umbenennen';

  @override
  String get settingsNetworkIdentityNameDialogHelp =>
      'Kleinbuchstaben, Zahlen und Bindestriche. Bis zu 32 Zeichen.';

  @override
  String get settingsNetworkIdentityUuid => 'Geräte-ID';

  @override
  String get settingsNetworkIdentityPort => 'Listener-Port';

  @override
  String get settingsNetworkIdentityPortDialogTitle => 'Listener-Port';

  @override
  String get settingsNetworkIdentityToken => 'Bearer-Token';

  @override
  String get settingsNetworkIdentityRegenerateToken => 'Token neu erzeugen';

  @override
  String get settingsNetworkIdentityRegenerateConfirmTitle =>
      'Bearer-Token neu erzeugen?';

  @override
  String get settingsNetworkIdentityRegenerateConfirmBody =>
      'Bestehende Geräte müssen mit dem neuen Token erneut gekoppelt werden.';

  @override
  String get settingsNetworkIdentityServerNotRunning =>
      'Server läuft noch nicht, wird in Phase 2 aktiviert.';

  @override
  String get settingsNetworkIdentityCopy => 'Kopieren';

  @override
  String get settingsNetworkIdentityCopied => 'Kopiert';

  @override
  String get settingsNetworkIdentityStaticIpHint =>
      'Tipp: Eine DHCP-Reservierung (statische IP) auf deinem Router macht Verbindungen zuverlässiger.';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsSectionAppearance => 'Darstellung';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsLanguageSystemHint => 'Der Systemsprache folgen';

  @override
  String get settingsLanguagePickerAllSection => 'Alle Sprachen';

  @override
  String get settingsTheme => 'Design';

  @override
  String get settingsThemeLight => 'Hell';

  @override
  String get settingsThemeDark => 'Dunkel';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsSectionAbout => 'Über';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsDeveloper => 'Entwickler';

  @override
  String get settingsDeveloperName => 'SmartKraft';

  @override
  String get settingsOpenAbout => 'Über SKAPP';

  @override
  String get settingsSectionAdvanced => 'Erweitert';

  @override
  String get settingsDeveloperMode => 'Entwicklermodus';

  @override
  String get settingsDeveloperToolsTitle => 'Entwicklerwerkzeuge';

  @override
  String get settingsDeveloperToolsSubtitle =>
      'USB-Konsole, Netzwerkidentität, Listener, Tokens, Logs';

  @override
  String get settingsDeveloperModeInfoTitle =>
      'Was schaltet der Entwicklermodus frei?';

  @override
  String get settingsDeveloperModeInfoIntro =>
      'Dieser Modus zeigt Profi-Funktionen, die in der Standard-Oberfläche verborgen sind. Drei Haupteinsatzfälle:';

  @override
  String get settingsDeveloperModeUseCaseCliTitle => 'CLI-Konsole';

  @override
  String get settingsDeveloperModeUseCaseCliBody =>
      'Konfiguriere deine Geräte über ein USB-Kabel, ohne zuerst eine BLE- oder WiFi-Verbindung herzustellen.';

  @override
  String get settingsDeveloperModeUseCaseSkapiTitle => 'SKAPI-Code-Editor';

  @override
  String get settingsDeveloperModeUseCaseSkapiBody =>
      'Öffne und ändere integrierte Skripte oder schreibe eigene von Grund auf.';

  @override
  String get settingsDeveloperModeUseCaseMobileTitle => 'Mobiles Fernauslösen';

  @override
  String get settingsDeveloperModeUseCaseMobileBody =>
      'Führe die SKAPI-Bindungen dieses Desktops von einem gekoppelten mobilen SKAPP aus.';

  @override
  String get settingsDeveloperModeInfoSurfacesHeader =>
      'Zusätzliche Einstellungskarten, die dann erscheinen:';

  @override
  String get settingsDeveloperModeInfoItem1 =>
      'Karte „Netzwerkidentität“: UUID, Port und Bearer-Token bearbeiten; SKAPP-Installations-Secret kopieren / neu erzeugen.';

  @override
  String get settingsDeveloperModeInfoItem2 =>
      'Steuerung des lokalen HTTP-Listeners: Start/Stopp, QR-Kopplung, TLS-Zertifikatswechsel, LAN-Sichtbarkeit.';

  @override
  String get settingsDeveloperModeInfoItem3 =>
      'Token-Liste pro Peer: jedes gekoppelte mobile SKAPP sehen und einzeln widerrufen.';

  @override
  String get settingsDeveloperModeInfoItem4 =>
      'USB-CLI-Konsole (nur Desktop): rohe NDJSON-Befehlszeile in ein per USB verbundenes SmartKraft-Gerät.';

  @override
  String get settingsDeveloperModeInfoNotPaid =>
      'Kein kostenpflichtiges Upgrade. SKAPP ist einstufig und kostenlos; dieser Schalter blendet nur standardmäßig Profi-Funktionen aus, um es einfach zu halten. SmartKraft-Geräte funktionieren unabhängig von dieser Einstellung.';

  @override
  String get settingsSectionConnectivity => 'Konnektivität';

  @override
  String get settingsBluetoothStatus => 'Bluetooth';

  @override
  String get settingsBluetoothStatusOn => 'Bereit';

  @override
  String get settingsBluetoothStatusOff => 'Ausgeschaltet';

  @override
  String get settingsBluetoothStatusTurningOn => 'Wird eingeschaltet…';

  @override
  String get settingsBluetoothStatusTurningOff => 'Wird ausgeschaltet…';

  @override
  String get settingsBluetoothStatusUnauthorized => 'Keine Berechtigung';

  @override
  String get settingsBluetoothStatusUnsupported => 'Nicht unterstützt';

  @override
  String get settingsBluetoothStatusUnknown => 'Wird geprüft…';

  @override
  String get settingsNetworkStatus => 'Netzwerk';

  @override
  String get settingsWifiStatusConnected => 'Wi-Fi';

  @override
  String get settingsWifiStatusEthernet => 'Ethernet';

  @override
  String get settingsWifiStatusMobile => 'Mobile Daten';

  @override
  String get settingsWifiStatusDisconnected => 'Getrennt';

  @override
  String get settingsWifiStatusUnknown => 'Wird geprüft…';

  @override
  String get settingsWifiHint => 'Wird nach der ersten Kopplung verwendet.';

  @override
  String get settingsBluetoothPermissions => 'Berechtigungen';

  @override
  String get settingsBluetoothPermissionsHint =>
      'Bluetooth- und Standortzugriff';

  @override
  String get settingsBluetoothGrantPermission => 'Zugriff erteilen';

  @override
  String get settingsOpenSystemSettings => 'Systemeinstellungen öffnen';

  @override
  String get settingsSectionUpdates => 'Updates';

  @override
  String get settingsCheckUpdates => 'Nach Updates suchen';

  @override
  String get settingsAutoCheckUpdates => 'Beim Start prüfen';

  @override
  String get settingsAutoCheckUpdatesHint =>
      'Prüft bei jedem Start von SKAPP, ob du die neueste Version hast.';

  @override
  String get settingsUpdateChannel => 'Update-Kanal';

  @override
  String get settingsUpdateChannelStable => 'Stabil';

  @override
  String get settingsUpdateChannelBeta => 'Beta';

  @override
  String get settingsUpdateChannelBetaHint =>
      'Erhalte neue Funktionen früher. Kann weniger stabil sein.';

  @override
  String get settingsUpToDate => 'Du hast die neueste Version.';

  @override
  String get settingsUpdateCheckPlaceholder =>
      'Die Update-Prüfung wird in Phase 3 angebunden.';

  @override
  String get settingsSectionLegal => 'Rechtliches';

  @override
  String get settingsLicense => 'Lizenz & Dank';

  @override
  String get settingsSectionInfo => 'Informationen';

  @override
  String get settingsThemeCycleHint => 'Zum Wechseln tippen';

  @override
  String get settingsChannelCycleHint => 'Zum Wechseln tippen';

  @override
  String get settingsSectionThisNode => 'Dieser Knoten';

  @override
  String get settingsNodeNameTitle => 'SKAPP-Knotenname';

  @override
  String settingsNodeNameSub(String name) {
    return '$name · andere SKAPPs sehen diesen Namen · mDNS-Broadcast';
  }

  @override
  String get settingsSectionDanger => 'Gefahrenzone';

  @override
  String get settingsResetPairings => 'Kopplungen zurücksetzen';

  @override
  String get settingsResetPairingsSub =>
      'Alle gekoppelten Geräte entfernen; Einstellungen/Sprache/Knotenname bleiben erhalten';

  @override
  String get settingsFactoryReset => 'Werkseinstellungen';

  @override
  String get settingsFactoryResetSub => 'Alles gelöscht, unwiderruflich';

  @override
  String get settingsSectionAdvancedNetwork => 'Erweitertes Netzwerk';

  @override
  String get settingsResetPairingsConfirmTitle =>
      'Alle Kopplungen zurücksetzen?';

  @override
  String settingsResetPairingsConfirmBody(int paired, int bindings, int peers) {
    return '$paired gekoppelte(s) Gerät(e), $bindings SKAPI-Aktion(en) und $peers SKAPP-Peer(s) werden entfernt. Deine Einstellungen, dein Design, deine Sprache und deine Notizen bleiben erhalten. Die Geräte behalten ihre Bindung auf ihrer Seite; um vollständig zu entkoppeln, setze das Gerät manuell zurück. Dies kann nicht rückgängig gemacht werden.';
  }

  @override
  String get settingsResetPairingsConfirmAction => 'Zurücksetzen';

  @override
  String get settingsFactoryResetConfirmTitle => 'Werkseinstellungen?';

  @override
  String get settingsFactoryResetConfirmBody =>
      'Alles wird gelöscht: alle Kopplungen, Einstellungen, das Design, die Sprache, Notizen, die Netzwerkidentität, das TLS-Zertifikat und der Autostart-Eintrag. SKAPP kehrt in den Zustand beim ersten Start zurück. Dies kann nicht rückgängig gemacht werden.';

  @override
  String get settingsFactoryResetConfirmAction => 'Alles löschen';

  @override
  String get settingsFactoryResetSecondConfirmTitle =>
      'Bist du dir absolut sicher?';

  @override
  String get settingsFactoryResetSecondConfirmBody =>
      'Gib ERASE ein, um zu bestätigen.';

  @override
  String get settingsFactoryResetSecondConfirmHint => 'ERASE';

  @override
  String get settingsFactoryResetSecondConfirmAction => 'Verstanden. Löschen.';

  @override
  String get settingsResetInProgress => 'Wird zurückgesetzt…';

  @override
  String get settingsResetDoneTitle => 'Zurücksetzen abgeschlossen';

  @override
  String get settingsResetDoneWithWarnings =>
      'Zurücksetzen abgeschlossen (mit Warnungen)';

  @override
  String settingsResetSummaryPaired(int count) {
    return '$count gekoppelte(s) Gerät(e) entfernt';
  }

  @override
  String settingsResetSummaryBindings(int count) {
    return '$count SKAPI-Aktion(en) entfernt';
  }

  @override
  String settingsResetSummaryPeers(int count) {
    return '$count SKAPP-Peer(s) entfernt';
  }

  @override
  String settingsResetSummaryBonds(int count) {
    return '$count Gerätebindung(en) gelöscht';
  }

  @override
  String get settingsResetSummaryNetworkIdentity =>
      'Netzwerkidentität auf Standard zurückgesetzt';

  @override
  String get settingsResetSummaryTlsCert => 'TLS-Zertifikat gelöscht';

  @override
  String get settingsResetSummaryAutostart => 'Autostart-Eintrag entfernt';

  @override
  String get settingsResetSummaryWarningHeader => 'Warnungen:';

  @override
  String get settingsResetRestartHint =>
      'Starte SKAPP neu, um die Änderungen vollständig zu übernehmen.';

  @override
  String get settingsResetRestartNow => 'Jetzt neu starten';

  @override
  String get settingsResetClose => 'Schließen';

  @override
  String settingsFooterCombined(String version, String node) {
    return 'SKAPP $version · $node';
  }

  @override
  String get langEnglish => 'English';

  @override
  String get langTurkish => 'Türkçe';

  @override
  String get aboutTitle => 'Über SmartKraft und SKAPP';

  @override
  String get aboutDevicesHeading => 'Unsere Geräte';

  @override
  String get aboutDevicesBody =>
      'SmartKraft-Geräte sind darauf ausgelegt, innovativ und unverwechselbar zu sein und Details mitzubringen, an die andere nicht gedacht haben. Unser Ziel ist nicht, nachzubauen, was es schon gibt; es ist, das zu machen, was noch nicht gemacht, was unerledigt geblieben ist. Auf ein ungelöstes Alltagsproblem zu zeigen und ihm eine einfache, verständliche Antwort zu geben; oder etwas zu nehmen, das gelöst, aber teuer geblieben ist, und an seine Stelle eine DIY-Version zu setzen, die jeder bauen kann.\n\nJedes SmartKraft-Gerät ist darauf ausgelegt und gebaut, eine kleine, schlichte Antwort auf ein noch ungelöstes Problem zu geben. Beim Entwerfen eines Geräts stellen wir uns eine einzige Frage: „Warum wurde dieses Problem bisher nicht gelöst, oder warum ist es so teuer geblieben?“';

  @override
  String get aboutSkappRoleHeading => 'Wo SKAPP hineinpasst';

  @override
  String get aboutSkappRoleBody =>
      'SKAPP ist die gemeinsame App für SmartKraft-Geräte. Es ist eine einfache Benutzeroberfläche, um ein Gerät zu koppeln, es zu konfigurieren, sein Verhalten zu ändern und mehrere Geräte in einem einzigen Szenario zusammenzuführen.\n\nSKAPP ist für deine Geräte nicht erforderlich; es ist eine Erleichterung. Jedes SmartKraft-Gerät lässt sich genauso über die USB-CLI ohne SKAPP konfigurieren, und dieser Weg bleibt für alle offen, die die Befehlszeile bevorzugen. Für alle anderen, die das Tempo einer visuellen Oberfläche und den Komfort wollen, mehrere Geräte gleichzeitig zu verwalten, ist SKAPP da.\n\nKein Cloud-Konto. Keine Werbung. Keine Datensammlung. Es ist eine stille Brücke zwischen deinem Handy und deinem Gerät, nicht mehr.';

  @override
  String get aboutShowcaseHeading => 'Maker-Showcase';

  @override
  String get aboutShowcaseEmpty =>
      'Das Showcase ist vorerst leer. Das erste SmartKraft-Gerät ist unterwegs; Designdateien, Firmware-Quellen, Stücklisten und Aufbauanleitungen werden hier aufgeführt, sobald sie fertig sind. Bis dahin verspricht dieser Bereich nicht viel, er hält nur Platz für das, was kommt.';

  @override
  String get aboutConnectHeading => 'Verbinden';

  @override
  String get aboutConnectIntro =>
      'Schreib eine Nachricht, sieh dir den Quellcode an, verfolge die Arbeit, während sie wächst.';

  @override
  String get aboutConnectGitHub => 'GitHub';

  @override
  String get aboutConnectWebsite => 'Website';

  @override
  String get aboutConnectYouTube => 'YouTube';

  @override
  String get aboutConnectX => 'X';

  @override
  String get aboutConnectEmail => 'E-Mail';

  @override
  String get aboutVersionHeading => 'Version';

  @override
  String get licenseTitle => 'Lizenz & Dank';

  @override
  String get licenseSmartKraftHeading => 'Über SmartKraft';

  @override
  String get licenseSmartKraftBody =>
      'SmartKraft ist eine kleine Werkstatt, die ungewöhnliche, aber praktische elektronische Werkzeuge für den Alltag entwirft. Hinter jedem Gerät, das in deine Hand gelangt, liegen unzählige Schritte: eine erste Skizze in einem Notizbuch, ein erster gelöteter Prototyp, spät in der Nacht geschriebene Codezeilen, kleine Details, die immer wieder neu versucht wurden. Ein Gerät zu bauen heißt, Zeilen zu schreiben, Schaltungen zu zeichnen, Lötstellen zu setzen, Fehler zu finden, von vorn zu beginnen. Allen, die ihre Mühe in diesen Prozess gesteckt haben, ohne ihren Namen daraufzuschreiben: danke, im Namen von SmartKraft.\n\nWir glauben an die Maker-Kultur, an Open Source und an reparierbare, recycelbare Elektronik. Deshalb veröffentlichen wir die Hardware-Designs unserer Geräte als Open Hardware und ihre Firmware unter der AGPL 3.0. Unser Ziel ist es, eine DIY-Version von so vielen Teilen wie möglich erreichbar zu machen.\n\nEin Hinweis, bei dem wir ehrlich sein wollen: Die Kopplungsschlüssel und Kommunikations-Secrets, die die Sicherheit eines Geräts schützen, bleiben im Quellcode privat. Würden sie veröffentlicht, bräche das Vertrauen zwischen deinem Gerät und der App zusammen. Diese Geschlossenheit ist kein Zugeständnis gegen Offenheit; sie ist eine Entscheidung für deine Sicherheit.\n\nFür SKAPP und jedes Gerät, das mit ihm spricht, ist unser Grundsatz Transparenz: Wir möchten, dass du nachlesen kannst, wie die Dinge funktionieren, sie prüfen und deine eigene Version bauen kannst. Dennoch hat jedes Gerät seinen eigenen Lizenzabschnitt, und die Bedingungen können variieren. Um Quellcode, Schaltpläne oder Nutzungsbedingungen eines Geräts zu sehen, sieh bitte im Lizenzbereich des jeweiligen Geräts nach.\n\nDanke, dass du uns durch die Nutzung dieser App unterstützt. Wir freuen uns, dass du hier bist.';

  @override
  String get licenseOpenSourceHeading => 'Auf ihren Schultern stehend';

  @override
  String get licenseOpenSourceBody =>
      'SKAPP baut auf tausenden zuvor geschriebenen Open-Source-Projekten auf. Herzlichen Dank an das Flutter-Team und seine Mitwirkenden, die die sichtbare Oberfläche möglich gemacht haben, und an alle Open-Source-Entwickler, die Jahre in Netzwerktechnik, Speicherung, Kryptografie, Bluetooth und unzählige Teilsysteme gesteckt haben.\n\nWeil wir von Open Source profitieren, versuchen wir, auch die Hardware und Firmware unserer eigenen Geräte offen zu halten, damit jene, die nach uns kommen, auf dieselbe Weise von diesem Werk profitieren können.\n\nNochmals Dank an alle, die Teil dieser Arbeit waren.';

  @override
  String get licenseThirdPartyLink =>
      'In dieser App verwendete Drittanbieter-Lizenzen';

  @override
  String get discoveryTitle => 'Geräte finden';

  @override
  String get discoverySearching => 'Suche nach SmartKraft-Geräten in der Nähe…';

  @override
  String get discoveryNoResults =>
      'Keine SmartKraft-Geräte in der Nähe gefunden.';

  @override
  String get discoveryTapToConnect => 'Tippe auf ein Gerät, um zu verbinden';

  @override
  String get discoveryRescan => 'Erneut suchen';

  @override
  String get pairingTitle => 'Gerät koppeln';

  @override
  String get pairingEnterPasskey =>
      'Gib den Passkey ein, der auf dem Geräteetikett aufgedruckt ist.';

  @override
  String get pairingPasskeyHint => 'z. B. K7M9P2AB';

  @override
  String get pairingConnect => 'Verbinden';

  @override
  String get pairingMockNotice =>
      'Geräte-Firmware noch nicht bereit. Die Kopplung ist in diesem Build ein Platzhalter.';

  @override
  String get errorBluetoothPermission =>
      'Zum Suchen von Geräten ist die Bluetooth-Berechtigung erforderlich.';

  @override
  String get errorBluetoothOff => 'Bluetooth ist ausgeschaltet.';

  @override
  String get errorLocationPermission =>
      'Zum Suchen von BLE-Geräten unter Android ist die Standortberechtigung erforderlich.';

  @override
  String get actionOpenSettings => 'Einstellungen öffnen';

  @override
  String get actionGrantPermission => 'Berechtigung erteilen';

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonConfirm => 'Bestätigen';

  @override
  String get commonRetry => 'Wiederholen';

  @override
  String get commonBack => 'Zurück';

  @override
  String get commonRemove => 'Entfernen';

  @override
  String get commonRefresh => 'Aktualisieren';

  @override
  String get commonOk => 'OK';

  @override
  String get commonClose => 'Schließen';

  @override
  String get commonSave => 'Speichern';

  @override
  String get commonDelete => 'Löschen';

  @override
  String get commonConnect => 'Verbinden';

  @override
  String get commonAdd => 'Hinzufügen';

  @override
  String get commonForget => 'Entfernen';

  @override
  String get commonMore => 'Mehr';

  @override
  String get commonError => 'Fehler';

  @override
  String get commonOnline => 'online';

  @override
  String get commonOffline => 'offline';

  @override
  String get productBlockingFocus => 'Blocking Focus';

  @override
  String get productLebensSpur => 'LebensSpur';

  @override
  String get productGeneric => 'SmartKraft-Gerät';

  @override
  String get timeJustNow => 'gerade eben';

  @override
  String timeMinAgo(int count) {
    return 'vor $count Min.';
  }

  @override
  String timeHourAgo(int count) {
    return 'vor $count Std.';
  }

  @override
  String timeDayAgo(int count) {
    return 'vor $count T.';
  }

  @override
  String get devicesRemoveTitle => 'Gerät entfernen';

  @override
  String devicesRemoveBody(String name) {
    return '$name wird entfernt. Das Gerät bleibt angeschlossen; um es erneut hinzuzufügen, musst du es neu koppeln.';
  }

  @override
  String get devicesUnpair => 'Entkoppeln';

  @override
  String get devicesEmptyHint =>
      'Bring dein SmartKraft-Gerät nah heran und tippe auf die Schaltfläche unten.';

  @override
  String get devicesEmptyTitleNoPaired => 'Noch keine gekoppelten Geräte';

  @override
  String devicesLastSeen(String time) {
    return 'Zuletzt gesehen: $time';
  }

  @override
  String devicesPairedAt(String time) {
    return 'Gekoppelt: $time';
  }

  @override
  String devicesHubSubtitle(int count) {
    return 'SKAPP-Host · $count gekoppelt';
  }

  @override
  String get devicesHubEmptySubtitle => 'wartet auf Gerät';

  @override
  String devicesHeaderSub(int paired, int online) {
    return '$paired gekoppelt · $online online · Konstellationsansicht';
  }

  @override
  String get devicesAddPillLabel => 'Gerät hinzufügen';

  @override
  String devicesLegendOnline(int count) {
    return 'online ($count)';
  }

  @override
  String devicesLegendOffline(int count) {
    return 'offline ($count)';
  }

  @override
  String devicesLegendLowBattery(int count) {
    return 'schwacher Akku ($count)';
  }

  @override
  String get devicesStatPaired => 'gekoppelt';

  @override
  String get devicesStatBf => 'BF';

  @override
  String get devicesStatLs => 'LS';

  @override
  String get devicesStatMs => 'Handy';

  @override
  String get devicesEmptyHubLabel => 'Unbekannt';

  @override
  String get devicesEmptyAddCta => 'Erstes Gerät hinzufügen';

  @override
  String get devicesEmptyHintChip =>
      'Gerät nah heranbringen, seine Taste drücken';

  @override
  String devicesNotifOfflineHours(int hours) {
    return 'offline vor $hours Std.';
  }

  @override
  String devicesNotifOfflineMinutes(int minutes) {
    return 'offline vor $minutes Min.';
  }

  @override
  String get devicesNotifLowBattery => 'schwacher Akku';

  @override
  String get skappPeersCardTitle => 'Gekoppelte Desktop-SKAPPs';

  @override
  String get skappPeersCardSubtitle =>
      'Handys und Tablets koppeln sich hier, damit eine BF-Aktion ein Skript auf einem Desktop-SKAPP ausführen kann. Öffne Desktop-SKAPP > Einstellungen > SKAPP-HTTP-Listener, um einen QR zu erhalten.';

  @override
  String get skappPeersCardEmpty => 'Noch kein gekoppelter Peer.';

  @override
  String get skappPeersCardPairButton => 'Neu koppeln';

  @override
  String get skappPeersCardOnline => 'online';

  @override
  String get skappPeersCardOffline => 'offline';

  @override
  String get skappPeersCardNeverSeen => 'nie gesehen';

  @override
  String skappPeersCardRemoveTitle(String name) {
    return '$name entfernen?';
  }

  @override
  String get skappPeersCardRemoveBody =>
      'SKAPP sendet keine Skripte mehr an diesen Peer. Du kannst ihn später mit demselben QR / Token erneut koppeln.';

  @override
  String get skappPeersCardRemoveConfirm => 'Entfernen';

  @override
  String get skappPeersCardRemoveCancel => 'Abbrechen';

  @override
  String skappPeersCardRemovedToast(String name) {
    return '$name entkoppelt';
  }

  @override
  String get devicesCardLongPressHint => 'Lange drücken zum Verwalten';

  @override
  String devicesActionsSheetTitle(String name) {
    return '$name';
  }

  @override
  String get devicesActionForget => 'Gerät entfernen';

  @override
  String get devicesActionForgetSubtitle =>
      'Dieses Gerät aus SKAPP entfernen. Das Gerät selbst ist nicht betroffen; du kannst es später erneut koppeln.';

  @override
  String get devicesActionCancel => 'Abbrechen';

  @override
  String devicesForgetDialogTitle(String name) {
    return '$name entfernen?';
  }

  @override
  String get devicesForgetDialogBody =>
      'SKAPP verfolgt dieses Gerät nicht mehr. Die Kopplung auf der Geräteseite bleibt bestehen, bis du sie am Gerät zurücksetzt.';

  @override
  String devicesForgetDialogBodyWithActions(int count) {
    return 'SKAPP verfolgt dieses Gerät nicht mehr und löscht $count damit verbundene SKAPI-Aktion(en). Die Kopplung auf der Geräteseite bleibt bestehen, bis du sie am Gerät zurücksetzt.';
  }

  @override
  String get devicesForgetDialogConfirm => 'Entfernen';

  @override
  String get devicesForgetDialogCancel => 'Abbrechen';

  @override
  String devicesForgotToast(String name) {
    return '$name aus SKAPP entfernt';
  }

  @override
  String get devicesMobileNoDetailHint =>
      'Keine Detailseite für Handys · lange drücken zum Entkoppeln';

  @override
  String get devicesDesktopStatLabel => 'Desktop';

  @override
  String get devicesDesktopGroupLabel => 'Gekoppelte Desktops';

  @override
  String get devicesDesktopTriggerDialogTitle => 'Einen SKAPI-Befehl senden?';

  @override
  String devicesDesktopTriggerDialogBody(String name) {
    return 'Alle Mobile-Touch-Bindungen auf $name werden ausgeführt.';
  }

  @override
  String get devicesDesktopTriggerDialogConfirm => 'Befehl senden';

  @override
  String get devicesDesktopTriggerDialogCancel => 'Abbrechen';

  @override
  String get devicesDesktopForgetDialogTitle => 'Entkoppeln';

  @override
  String devicesDesktopForgetDialogBody(String name) {
    return '$name wird entkoppelt. Du musst erneut koppeln, um wieder Befehle an diesen Desktop zu senden.';
  }

  @override
  String devicesDesktopForgotToast(String name) {
    return '$name entkoppelt';
  }

  @override
  String get homeStatDevices => 'Geräte';

  @override
  String get homeStatOnline => 'Online';

  @override
  String get homeStatWarning => 'Warnung';

  @override
  String homeWarningMeta(String time) {
    return 'Gekoppelt, aber nie gesehen · $time';
  }

  @override
  String get homeBrandTotal => 'Gesamt';

  @override
  String get homeBrandActive => 'Aktiv';

  @override
  String get homeBrandActions => 'Aktionen';

  @override
  String get homeBrandVersion => 'Version';

  @override
  String get smartkraftSectionProducts => 'Produkte';

  @override
  String get smartkraftSectionCommunity => 'Community';

  @override
  String get smartkraftStatusLive => 'LIVE';

  @override
  String get smartkraftStatusDev => 'IN ENTWICKLUNG';

  @override
  String get smartkraftStatusConcept => 'KONZEPT';

  @override
  String get smartkraftBlockingFocusTagline =>
      'Die Pause, die du nicht überspringen kannst.';

  @override
  String get smartkraftLebensSpurTagline =>
      'Ein stiller Zeuge deiner Gewohnheiten.';

  @override
  String get smartkraftSynDimmTagline =>
      'Das richtige Licht zur richtigen Stunde.';

  @override
  String homeStickyDevicesMeta(int count, int warning) {
    return '$count Geräte · $warning Hinweise';
  }

  @override
  String homeStickySkapiMeta(int actions) {
    return '$actions Aktionen';
  }

  @override
  String homeStickySettingsMeta(String node, String version) {
    return '$node · v$version';
  }

  @override
  String get homeStickyComingSoonMeta => 'Inhalt in Arbeit';

  @override
  String get homeStickyNotesLabel => 'Notizen';

  @override
  String get setupChoiceTitle => 'Gerät hinzufügen';

  @override
  String get setupChoiceQuestion => 'Wo stehen wir?';

  @override
  String get setupChoiceSubtitle =>
      'Ist das Gerät frisch aus der Box, oder wurde es schon einmal per CLI konfiguriert?';

  @override
  String get setupChoiceFreshTitle => 'Neueinrichtung';

  @override
  String get setupChoiceFreshBody =>
      'Ich füge zum ersten Mal ein brandneues SmartKraft-Gerät hinzu. Die Kopplung läuft über BLE, und der WiFi-Einrichtungsassistent öffnet sich.';

  @override
  String get setupChoiceExistingTitle =>
      'Bereits konfiguriertes Gerät hinzufügen';

  @override
  String get setupChoiceExistingBody =>
      'Ich habe das WiFi meines Geräts per USB/CLI konfiguriert und bin im selben Netzwerk. Direkt über WiFi koppeln und den Assistenten überspringen.';

  @override
  String get setupChoiceFooter =>
      'Im Zweifel wähle „Neueinrichtung“; das ist der richtige Weg sowohl für die Erstkopplung als auch für auf Werkseinstellungen zurückgesetzte Geräte.';

  @override
  String get wifiDiscoveryTitle => 'Geräte in diesem Netzwerk';

  @override
  String wifiDiscoveryScanError(String error) {
    return 'Suchfehler: $error';
  }

  @override
  String get wifiDiscoveryHint =>
      'Das Gerät muss im WiFi sein und das Handy im selben Netzwerk. Während der Kopplung wirst du gebeten, die Gerätetaste zu drücken.';

  @override
  String get wifiDiscoveryScanning => 'Suche läuft…';

  @override
  String get wifiDiscoveryNotFound => 'Keine Geräte gefunden';

  @override
  String wifiDiscoveryFoundCount(int count) {
    return '$count Gerät(e) gefunden';
  }

  @override
  String get wifiDiscoveryEmptyTitle =>
      'Suche nach SmartKraft-Geräten in diesem Netzwerk…';

  @override
  String get wifiDiscoveryEmptyTitleIdle => 'Keine Geräte gefunden.';

  @override
  String get wifiDiscoveryEmptyHint =>
      'Stelle sicher, dass das Gerät eingeschaltet, mit dem WiFi verbunden und im selben Netzwerk wie dein Handy ist. Nutze die Aktualisieren-Schaltfläche für einen erneuten Versuch.';

  @override
  String get wifiDiscoveryPairedBadge => 'gekoppelt';

  @override
  String get wifiPairingTitle => 'Kopplung';

  @override
  String wifiPairingConnectFailed(String error) {
    return 'Verbindung nicht möglich: $error';
  }

  @override
  String wifiPairingInvalidJson(String error) {
    return 'Ungültiges JSON: $error';
  }

  @override
  String get wifiPairingClosedEarly => 'Verbindung geschlossen (keine Antwort)';

  @override
  String wifiPairingSendFailed(String error) {
    return 'Befehl konnte nicht gesendet werden: $error';
  }

  @override
  String get wifiPairingTimeout => 'Gerät hat nicht geantwortet (Timeout).';

  @override
  String get wifiPairingNotOpen =>
      'Kopplungsfenster am Gerät nicht offen. Drücke die Taste kurz und versuche es erneut.';

  @override
  String get skapiBindFixedTriggerLabel => 'Auslöser: wenn der Timer abläuft';

  @override
  String get wifiPairingDeviceAlreadyBonded =>
      'Dieses Gerät ist bereits mit einem anderen SKAPP gekoppelt. Das Hinzufügen eines neuen Peers über WiFi wird von der aktuellen Firmware nicht unterstützt (TCP akzeptiert nur die erste Kopplung). Nutze die BLE-Kopplung oder entkoppele den bestehenden Peer vom Gerät.';

  @override
  String wifiPairingRejected(String error) {
    return 'Gerät hat abgelehnt: $error';
  }

  @override
  String get wifiPairingMissingPub => 'our_pub vom Gerät fehlt/ist beschädigt.';

  @override
  String wifiPairingHexError(String error) {
    return 'our_pub Hex-Dekodierung fehlgeschlagen: $error';
  }

  @override
  String get wifiPairingStageAwaiting => 'Drücke die Taste am Gerät';

  @override
  String get wifiPairingStageConnecting => 'Verbinde mit Gerät…';

  @override
  String get wifiPairingStageExchanging => 'Schlüssel werden ausgetauscht…';

  @override
  String get wifiPairingStageDone => 'Kopplung abgeschlossen';

  @override
  String get wifiPairingStageFailed => 'Kopplung fehlgeschlagen';

  @override
  String get wifiPairingStageAwaitingHelp =>
      'Drücke kurz die Steuertaste des Geräts (weniger als 3 Sekunden). Das Kopplungsfenster bleibt 60 Sekunden offen.';

  @override
  String get wifiPairingStageConnectingHelp => 'TCP-Socket wird geöffnet.';

  @override
  String get wifiPairingStageExchangingHelp =>
      'pairing.ecdh.exchange gesendet, warte auf die Antwort des Geräts.';

  @override
  String get wifiPairingStageDoneHelp => 'Weiter zum Geräte-Dashboard.';

  @override
  String get wifiPairingStartCta => 'Koppeln';

  @override
  String get bfDashboardTitleFallback => 'Gerät';

  @override
  String get bfDashboardWifiNone => 'Kein WiFi';

  @override
  String get bfDashboardLinkBle => 'BLE';

  @override
  String get bfDashboardLinkWifi => 'WiFi';

  @override
  String get bfDashboardLinkUsb => 'USB';

  @override
  String get bfDashboardToggleVibration => 'Vibration';

  @override
  String get bfDashboardToggleTilt => 'Kippwarnung';

  @override
  String get bfDashboardToggleLowBatt => 'Warnung bei schwachem Akku';

  @override
  String get bfDashboardApiChainTitle => 'API-Kette';

  @override
  String bfDashboardApiChainNone(String state) {
    return 'noch keine Endpunkte · Master $state';
  }

  @override
  String bfDashboardApiChainSummary(int count, String state) {
    return '$count Endpunkt(e) · Master $state';
  }

  @override
  String get bfDashboardMasterOn => 'an';

  @override
  String get bfDashboardMasterOff => 'aus';

  @override
  String get bfDashboardNotebookTitle => 'Benutzer-Notizbuch';

  @override
  String get bfDashboardNotebookSubtitle =>
      'Verschlüsselter Bereich · 100 KB · freier Inhalt';

  @override
  String get bfDashboardMoreDeviceInfo => 'Geräteinfo';

  @override
  String get bfDashboardMoreSettings => 'Einstellungen';

  @override
  String bfDashboardWriteFailed(String error) {
    return 'Schreiben nicht möglich: $error';
  }

  @override
  String get bfDeviceInfoTitle => 'Geräteinfo';

  @override
  String get bfDeviceInfoSectionGeneral => 'ALLGEMEIN';

  @override
  String get bfDeviceInfoSectionConnection => 'VERBINDUNG';

  @override
  String get bfDeviceInfoSectionBattery => 'AKKU';

  @override
  String get bfDeviceInfoSectionTime => 'ZEIT';

  @override
  String get bfDeviceInfoSectionLastError => 'LETZTER FEHLER';

  @override
  String get bfDeviceInfoSectionDiagnostics => 'DIAGNOSE';

  @override
  String get bfDeviceInfoSectionDocs => 'DOKUMENTE';

  @override
  String get bfDeviceInfoProduct => 'Produkt';

  @override
  String get bfDeviceInfoTypeCode => 'Typcode';

  @override
  String get bfDeviceInfoIdentity => 'Identität';

  @override
  String get bfDeviceInfoHardware => 'Hardware';

  @override
  String get bfDeviceInfoFirmware => 'Firmware';

  @override
  String get bfDeviceInfoProtocol => 'Protokoll';

  @override
  String get bfDeviceInfoBuild => 'Build';

  @override
  String get bfDeviceInfoUptime => 'Laufzeit';

  @override
  String get bfDeviceInfoWifiState => 'WiFi-Status';

  @override
  String get bfDeviceInfoIp => 'IP';

  @override
  String get bfDeviceInfoSignal => 'Signal';

  @override
  String get bfDeviceInfoBleAdvertising => 'BLE-Advertising';

  @override
  String get bfDeviceInfoBlePaired => 'BLE-Kopplungen';

  @override
  String bfDeviceInfoPairedClients(int count) {
    return '$count Client(s)';
  }

  @override
  String get bfDeviceInfoBattery => 'Akku';

  @override
  String get bfDeviceInfoBatteryPresent => 'vorhanden';

  @override
  String get bfDeviceInfoBatteryAbsent => 'nicht vorhanden';

  @override
  String get bfDeviceInfoDeviceClock => 'Geräteuhr';

  @override
  String get bfDeviceInfoLogs => 'Geräte-Logs';

  @override
  String get bfDeviceInfoLogsSubtitle =>
      'logs.get, Boot, Fehler, Timer, API-Ereignisse';

  @override
  String get bfDeviceInfoEvents => 'Ereignisverlauf';

  @override
  String get bfDeviceInfoEventsSubtitle =>
      'Lokal · Timer, Flächenwechsel, API-Auslöser';

  @override
  String get bfDeviceInfoUserGuide => 'Benutzerhandbuch';

  @override
  String get bfDeviceInfoUserGuideSubtitle =>
      'Flächenzuweisung, Timer, API-Auslöser';

  @override
  String get bfDeviceInfoDevNotes => 'SK-Entwicklernotizen';

  @override
  String get bfDeviceInfoDevNotesSubtitle =>
      'CLI-Befehle, Architektur, Ereignis-Taxonomie';

  @override
  String get bfDeviceInfoLicense => 'Lizenz & offene Quellen';

  @override
  String get bfDeviceInfoLicenseSubtitle =>
      'Verwendete Bibliotheken und Urheberrechtsangaben';

  @override
  String get bfDeviceInfoComingSoon => 'Demnächst';

  @override
  String bfDeviceInfoUptimeSecs(int n) {
    return '$n s';
  }

  @override
  String bfDeviceInfoUptimeMins(int n) {
    return '$n Min.';
  }

  @override
  String bfDeviceInfoUptimeHours(int h, int m) {
    return '$h Std. $m Min.';
  }

  @override
  String bfDeviceInfoUptimeDays(int d, int h) {
    return '$d T. $h Std.';
  }

  @override
  String get bfDeviceInfoYes => 'ja';

  @override
  String get bfDeviceInfoNo => 'nein';

  @override
  String get bfSettingsTitle => 'Einstellungen';

  @override
  String get bfSettingsSectionNetwork => 'NETZWERK';

  @override
  String get bfSettingsSectionUpdates => 'UPDATES';

  @override
  String get bfSettingsSectionDanger => 'GEFAHRENZONE';

  @override
  String get bfSettingsWifiPrimary => 'Primäres WiFi';

  @override
  String get bfSettingsWifiSecondary => 'Backup-WiFi';

  @override
  String get bfSettingsWifiUnconfigured => 'Nicht konfiguriert';

  @override
  String get bfSettingsFirmware => 'Firmware';

  @override
  String get bfSettingsCheckUpdates => 'Nach Updates suchen';

  @override
  String get bfSettingsCheckUpdatesSubtitle =>
      'Aktiv, sobald eine Manifest-URL gesetzt ist';

  @override
  String get bfOtaTitle => 'Firmware-Update';

  @override
  String get bfOtaCurrentLabel => 'Installierte Version';

  @override
  String get bfOtaRunningPartitionLabel => 'Aktive Partition';

  @override
  String get bfOtaCheckCta => 'Nach Updates suchen';

  @override
  String get bfOtaIdleHint => 'Es wurde noch keine Update-Prüfung ausgeführt.';

  @override
  String get bfOtaChecking => 'Update-Server wird geprüft…';

  @override
  String get bfOtaUpToDate => 'Das Gerät ist auf dem neuesten Stand.';

  @override
  String bfOtaAvailable(String version) {
    return 'Neue Version verfügbar: $version';
  }

  @override
  String get bfOtaUpdateCta => 'Jetzt aktualisieren';

  @override
  String bfOtaDownloading(int pct) {
    return 'Wird heruntergeladen… %$pct';
  }

  @override
  String get bfOtaDone => 'Aktualisiert. Das Gerät startet neu…';

  @override
  String bfOtaErrorMsg(String message) {
    return 'Fehler: $message';
  }

  @override
  String get bfOtaRollbackCta => 'Zur vorherigen Version zurückkehren';

  @override
  String get bfOtaUpdateConfirmTitle => 'Firmware-Update installieren?';

  @override
  String bfOtaUpdateConfirmBody(String version) {
    return 'Version $version wird heruntergeladen und installiert, anschließend startet das Gerät neu. Schalte es während des Updates nicht aus.';
  }

  @override
  String get bfOtaRollbackConfirmTitle => 'Firmware zurücksetzen?';

  @override
  String get bfOtaRollbackConfirmBody =>
      'Das Gerät bootet die vorherige Firmware und startet neu.';

  @override
  String get bfSettingsReboot => 'Gerät neu starten';

  @override
  String get bfSettingsRebootSubtitle =>
      'Startet das Gerät neu · bricht jeden aktiven Timer ab';

  @override
  String get bfSettingsRebootConfirmTitle => 'Gerät neu starten?';

  @override
  String get bfSettingsRebootConfirmBody =>
      'Das Gerät schaltet sich in wenigen Sekunden aus und wieder ein.';

  @override
  String get bfSettingsUnpairThisPhone => 'Dieses Handy entkoppeln';

  @override
  String get bfSettingsUnpairSubtitle =>
      'Entfernt die Bindung · das Gerät muss erneut gekoppelt werden';

  @override
  String get bfSettingsUnpairConfirmTitle => 'Dieses Handy entkoppeln?';

  @override
  String get bfSettingsFactoryReset => 'Werkseinstellungen';

  @override
  String get bfSettingsFactoryResetSubtitle =>
      'Löscht WiFi, API-Endpunkte und Kopplungen';

  @override
  String get bfSettingsFactoryResetConfirmTitle => 'Werkseinstellungen?';

  @override
  String get bfSettingsFactoryResetConfirmBody =>
      'Alle Einstellungen werden gelöscht. Das Gerät startet neu.';

  @override
  String get bfWifiManagementTitle => 'WiFi-Verwaltung';

  @override
  String get bfWifiConnecting => 'Verbinde…';

  @override
  String bfWifiConnectionRejected(String error) {
    return 'Verbindung abgelehnt: $error';
  }

  @override
  String bfWifiConfigure(String label) {
    return '$label konfigurieren';
  }

  @override
  String get bfWifiPasswordLabel => 'Passwort';

  @override
  String get bfNotebookTitle => 'Benutzer-Notizbuch';

  @override
  String get bfNotebookSaveCancel => 'Abbrechen';

  @override
  String get bfApiChainCancel => 'Abbrechen';

  @override
  String get bfApiChainRunChain => 'Kette ausführen';

  @override
  String get bfApiChainToggleAll => 'Alle aktivieren/deaktivieren';

  @override
  String get bfApiChainFieldName => 'Name';

  @override
  String get bfApiChainFieldType => 'Typ';

  @override
  String get bfApiChainFieldHeaderName => 'Header-Name';

  @override
  String get bfApiChainFieldNewToken =>
      'Neues Token (leer lassen, um es zu behalten)';

  @override
  String get bfHomeLoadingConnecting => 'Verbinde mit Gerät…';

  @override
  String get bfHomeLoadingSecure => 'Sicherer Kanal wird geöffnet…';

  @override
  String get deviceConnUnreachableTitle => 'Gerät nicht erreichbar';

  @override
  String get deviceConnUnreachableBody =>
      'Das Gerät ist möglicherweise aus, außer Reichweite oder im Ruhezustand. Stelle sicher, dass es eingeschaltet und in der Nähe ist, und versuche es erneut.';

  @override
  String get deviceConnRepairTitle => 'Kopplung muss erneuert werden';

  @override
  String get deviceConnRepairBody =>
      'Das Gerät scheint zurückgesetzt worden zu sein und erkennt dieses Handy nicht mehr. Koppele es erneut, um die Verbindung wiederherzustellen.';

  @override
  String get deviceConnRepairButton => 'Erneut koppeln';

  @override
  String get deviceConnTechnicalDetails => 'Technische Details';

  @override
  String get bfLogsTitle => 'Geräte-Logs';

  @override
  String get bfEventsTitle => 'Ereignisverlauf';

  @override
  String get pairingStepConnecting => 'Verbinden';

  @override
  String get pairingStepConnectingSubtitle => 'BLE-Verbindung + GATT-Erkennung';

  @override
  String get pairingStepMutualAuth => 'Gegenseitige Authentifizierung';

  @override
  String get pairingStepDeviceInfo => 'device.info-Verifizierung';

  @override
  String get pairingStepDeviceInfoSubtitle =>
      'Verschlüsselter Kanal steht, Funktionstest';

  @override
  String get pairingStepConnected => 'Verbindung hergestellt';

  @override
  String get pairingStepConnectedSubtitle =>
      'CLI bereit, weiter zur Einrichtung';

  @override
  String get pairingStepKeyExchange => 'Schlüsselaustausch';

  @override
  String get pairingStepKeyExchangeSubtitle =>
      'X25519, öffentlicher Schlüssel gesendet';

  @override
  String get pairingStepVerifying => 'Wird verifiziert';

  @override
  String get pairingStepVerifyingSubtitle => 'Warte auf Gerät, leite Token ab';

  @override
  String get pairingStepDone => 'Kopplung abgeschlossen';

  @override
  String get pairingStepDoneSubtitle =>
      'Bindung auf Gerät und Handy gespeichert';

  @override
  String get pairingLogTitle => 'Kopplungslog';

  @override
  String get pairingLogCopied => 'Log in die Zwischenablage kopiert';

  @override
  String get discoveryPreparing => 'Wird vorbereitet…';

  @override
  String get discoveryBluetoothOff => 'Bluetooth ist aus';

  @override
  String get wifiPasswordTitle => 'Gerät mit WiFi verbinden';

  @override
  String get wifiPasswordSsidLabel => 'Netzwerkname (SSID)';

  @override
  String get wifiPasswordNetworkLabel => 'Netzwerk';

  @override
  String get wifiPasswordPasswordLabel => 'Passwort';

  @override
  String get wifiPasswordConnect => 'Verbinden';

  @override
  String get wifiPasswordLogTitle => 'Verbindungslog';

  @override
  String get wifiPasswordLogCopied => 'Log in die Zwischenablage kopiert';

  @override
  String get wifiScanTitle => 'Ein WiFi-Netzwerk für das Gerät wählen';

  @override
  String get wifiScanRescanTooltip => 'Gerät erneut suchen lassen';

  @override
  String get wifiScanRunning => 'Der WiFi-Scanner des Geräts läuft…';

  @override
  String get wifiScanNoNetworks =>
      'Das Gerät konnte kein WiFi in der Nähe finden.';

  @override
  String get wifiScanRescan => 'Gerät erneut suchen lassen';

  @override
  String get wifiScanHiddenAdd => 'Verstecktes Netzwerk hinzufügen';

  @override
  String get wifiScanHiddenSubtitle => 'SSID von Hand eingeben';

  @override
  String get wifiScanLogTitle => 'WiFi-Suchlog';

  @override
  String get wifiSuccessReady => 'Fertig';

  @override
  String get bfEventsClearTooltip => 'Leeren';

  @override
  String get bfEventsEmpty =>
      'Noch keine Ereignisse. Sie erscheinen hier, sobald das Gerät zu senden beginnt.';

  @override
  String get logsEmptyTooltip => 'Log ist leer.';

  @override
  String logsErrorPrefix(String error) {
    return 'Fehler: $error';
  }

  @override
  String get notebookSaved => 'Gespeichert';

  @override
  String notebookSaveError(String error) {
    return 'Fehler: $error';
  }

  @override
  String notebookCapacityExceeded(int used, int capacity) {
    return 'Kapazität überschritten: $used / $capacity Bytes';
  }

  @override
  String get notebookClearTooltip => 'Notizbuch leeren';

  @override
  String get notebookClearConfirmTitle => 'Gesamtes Notizbuch leeren?';

  @override
  String get notebookClearConfirmBody =>
      'Alle Benutzerdaten auf dem Gerät werden gelöscht. Kann nicht rückgängig gemacht werden.';

  @override
  String get notebookClearAction => 'Leeren';

  @override
  String get notebookClearedSnack => 'Notizbuch geleert';

  @override
  String notebookClearError(String error) {
    return 'Leeren nicht möglich: $error';
  }

  @override
  String get notebookEncryptedHint =>
      'Verschlüsselter Bereich · nur das gekoppelte SKAPP kann ihn lesen';

  @override
  String get notebookEmptyTitle => 'Notizbuch ist leer';

  @override
  String get notebookEmptyBody =>
      'Tippe unten Notizen, JSON, Szenendefinitionen oder beliebigen anderen Text ein. Mit „Speichern“ wird es verschlüsselt auf dem Gerät abgelegt.';

  @override
  String get notebookHint =>
      'Tippe hier ein, was du willst (Notizen, JSON, dein eigenes Schema). Bis zu 100 KB werden auf dem Gerät gespeichert.';

  @override
  String get notebookDirty => 'Nicht gespeicherte Änderungen';

  @override
  String get notebookSaved2 => 'Gespeichert';

  @override
  String get notebookSyncedDifferent => 'Synchron';

  @override
  String get notebookSaveCta => 'Speichern';

  @override
  String wifiPairingHexErrorRaw(String error) {
    return 'our_pub Hex-Dekodierung fehlgeschlagen: $error';
  }

  @override
  String get bfWifiForgetTitle => 'Slot entfernen?';

  @override
  String get bfWifiForgetBody =>
      'Der Slot wird gelöscht. Wenn das Gerät hier aktuell verbunden ist, fällt es auf den anderen Slot zurück (falls vorhanden). Zum Wiederherstellen ist eine erneute Konfiguration nötig.';

  @override
  String get bfWifiForget => 'Entfernen';

  @override
  String get bfWifiHint =>
      'Das Gerät versucht die beiden Netzwerke der Reihe nach: zuerst Primär, bei Misserfolg Backup. Der aktive Slot ist mit einem grünen Punkt markiert.';

  @override
  String get bfWifiActive => 'AKTIV';

  @override
  String get bfWifiNotConfigured => 'Nicht konfiguriert';

  @override
  String get bfWifiChange => 'Ändern';

  @override
  String get bfWifiSetUp => 'Einrichten';

  @override
  String get discoveryStatusChecking => 'Bluetooth-Statusprüfung.';

  @override
  String get discoveryPermissionsTitle => 'Bluetooth-Berechtigung erforderlich';

  @override
  String get discoveryPermissionsBody =>
      'Um SmartKraft-Geräte in der Nähe zu finden, aktiviere bitte die Bluetooth-Berechtigung.';

  @override
  String get discoveryPermissionsRetry => 'Berechtigungen erneut anfordern';

  @override
  String get discoveryPermissionsOpenSettings => 'Einstellungen öffnen';

  @override
  String get discoveryAdapterOffBody =>
      'Schalte Bluetooth ein, um nach Geräten zu suchen.';

  @override
  String get discoveryAdapterOffEnable => 'Bluetooth einschalten';

  @override
  String get discoveryUnsupportedTitle => 'BLE nicht unterstützt';

  @override
  String get discoveryUnsupportedBody =>
      'Dieses Gerät unterstützt kein Bluetooth Low Energy; SKAPP benötigt BLE, um zu funktionieren.';

  @override
  String get wifiPasswordHelp =>
      'Das Gerät tritt diesem Netzwerk bei. Gib das Passwort ein, tippe es sorgfältig.';

  @override
  String get wifiPasswordRequired => 'Passwort ist erforderlich';

  @override
  String get wifiPasswordMinLength => 'Mindestens 8 Zeichen';

  @override
  String wifiPasswordSendError(String error) {
    return 'Senden nicht möglich: $error';
  }

  @override
  String get wifiScanTimeoutHint =>
      'Wenn die Suche zu lange dauert, hat das Gerät womöglich die WiFi-Reichweite verloren. Tippe auf Wiederholen.';

  @override
  String get wifiScanFailedTitle => 'Suche fehlgeschlagen';

  @override
  String get wifiScanRetry => 'Wiederholen';

  @override
  String get wifiSuccessTitle => 'Verbunden';

  @override
  String get wifiSuccessBody =>
      'Das Gerät ist jetzt im WiFi. Zurück zum Dashboard…';

  @override
  String get deviceNameSectionHeading => 'GERÄTENAME (NUR DIESE APP)';

  @override
  String get deviceNameLabel => 'Eigener Name';

  @override
  String get deviceNameHint => 'z. B. Büro-BF';

  @override
  String get deviceNameSubtitle =>
      'Wird auf Karten in dieser SKAPP-Installation angezeigt. Nicht an das Gerät übertragen.';

  @override
  String get deviceNameClear => 'Löschen';

  @override
  String get deviceNameSave => 'Speichern';

  @override
  String get deviceNameSaved => 'Gespeichert';

  @override
  String get deviceNameEmptyPlaceholder => '(kein eigener Name)';

  @override
  String get settingsUsbConsoleTitle => 'USB-CLI-Konsole';

  @override
  String get settingsUsbConsoleSubtitle =>
      'Rohe Befehle an ein per USB verbundenes Gerät senden';

  @override
  String get usbConsoleAppBarTitle => 'USB-Konsole';

  @override
  String get usbConsolePickPortTitle => 'Einen Port wählen';

  @override
  String get usbConsolePickPortHint =>
      'Schließe ein SmartKraft-Gerät per USB an und tippe auf Aktualisieren';

  @override
  String get usbConsolePortRefreshTooltip => 'Ports aktualisieren';

  @override
  String get usbConsoleBfBadge => 'SmartKraft';

  @override
  String get usbConsoleConnecting => 'Verbinde…';

  @override
  String get usbConsoleConnected => 'Verbunden';

  @override
  String get usbConsoleDisconnected => 'Getrennt';

  @override
  String usbConsoleErrorBanner(String error) {
    return 'Fehler: $error';
  }

  @override
  String get usbConsoleReconnect => 'Erneut verbinden';

  @override
  String get usbConsoleDisconnect => 'Trennen';

  @override
  String get usbConsoleClear => 'Konsole leeren';

  @override
  String get usbConsoleInputHint => 'Gib einen Befehl ein, z. B. device.info';

  @override
  String get usbConsoleSend => 'Senden';

  @override
  String get usbConsoleEmptyHint =>
      'Gib einen Befehl ein und drücke Enter, probiere device.info';

  @override
  String get usbConsoleEntryEvent => 'evt';

  @override
  String get usbConsoleEntryError => 'Fehler';

  @override
  String get usbConsoleNotSupportedIos =>
      'Die USB-Konsole wird unter iOS nicht unterstützt';

  @override
  String get passphraseFieldLabel => 'Passphrase';

  @override
  String get passphraseVerifyButton => 'Prüfen';

  @override
  String passphraseAttemptsLeft(int count) {
    return 'Verbleibende Versuche: $count';
  }

  @override
  String get passphraseLockoutTriggered =>
      'Zu viele falsche Passphrase-Versuche; das Gerät hat sich auf Werkseinstellungen zurückgesetzt.';

  @override
  String get bondPeerUnnamed => '(unbenannt)';

  @override
  String get pairingPassphraseDialogTitle => 'Geräte-Passphrase';

  @override
  String get pairingPassphraseDialogBody =>
      'Dieses Gerät benötigt für den Inhaltszugriff eine Passphrase. Gib sie ein, um die Kopplung abzuschließen.';

  @override
  String get pairingPassphraseCancelled =>
      'Passphrase nicht eingegeben, Kopplung abgebrochen.';

  @override
  String pairingPassphraseSendError(String error) {
    return 'Passphrase konnte nicht gesendet werden: $error';
  }

  @override
  String get pairingPassphraseTimeout =>
      'Gerät hat nicht geantwortet (Passphrase-Prüfung, 8 s).';

  @override
  String get pairingWindowClosedRetry =>
      'Kopplungsfenster geschlossen, drücke die Taste kurz und versuche es erneut.';

  @override
  String pairingPassphraseFailed(String error) {
    return 'Passphrase konnte nicht geprüft werden: $error';
  }

  @override
  String get bondStoreFullHeader =>
      'Alle 8 Bindungs-Slots sind belegt. Entferne einen bestehenden Peer, um ein neues SKAPP zu koppeln:';

  @override
  String bondStoreFullPeerLine(Object slot, String name, String shortPid) {
    return '  • Slot $slot, $name [#$shortPid]';
  }

  @override
  String get bondStoreFullFooter =>
      'Führe von einem anderen gekoppelten SKAPP oder per USB\n`bond.remove --slot N` aus und tippe dann hier auf Wiederholen.';

  @override
  String get passphraseGateDialogBody =>
      'Dieses Gerät fragt bei jeder Verbindung nach der Passphrase. Gib sie ein, um auf Inhalte zuzugreifen.';

  @override
  String get passphraseGateCancelled =>
      'Passphrase nicht eingegeben; zum Zugriff auf diesen Bildschirm ist eine Prüfung erforderlich.';

  @override
  String passphraseGateVerifyError(String error) {
    return 'Prüffehler: $error';
  }

  @override
  String passphraseGateCommError(String error) {
    return 'Kommunikationsfehler: $error';
  }

  @override
  String get passphraseGateUnknownError => 'Unbekannter Sperrfehler.';

  @override
  String get bfPassphraseTitle => 'Geräte-Passphrase';

  @override
  String get bfPassphraseSetTitle => 'Passphrase festlegen';

  @override
  String get bfPassphraseChangeTitle => 'Passphrase ändern';

  @override
  String get bfPassphraseClearTitle => 'Passphrase entfernen';

  @override
  String get bfPassphraseChangeSubtitle =>
      'Alte Passphrase eingeben, neue festlegen';

  @override
  String get bfPassphraseClearSubtitle =>
      'Inhaltssperre des Geräts zurücksetzen';

  @override
  String get bfPassphraseModePairing => 'Bei Kopplung fragen';

  @override
  String get bfPassphraseModePairingSubtitle =>
      'Fragt, wenn ein neues SKAPP koppelt. Bestehende Peers werden nicht abgefragt.';

  @override
  String get bfPassphraseModeAlways => 'Bei jeder Verbindung fragen';

  @override
  String get bfPassphraseModeAlwaysSubtitle =>
      'Fragt bei jedem Sitzungsstart. Inhalte bleiben gesperrt, selbst wenn ein SKAPP gestohlen wird.';

  @override
  String get bfPassphraseStatusNone =>
      'Keine Passphrase, das Gerät hat keine Inhaltssperre';

  @override
  String get bfPassphraseStatusActiveOff =>
      'Passphrase gesetzt · Durchsetzung aus (beide Schalter aus)';

  @override
  String get bfPassphraseStatusActivePairing => 'Wird bei Kopplung abgefragt';

  @override
  String get bfPassphraseStatusActiveAlways =>
      'Wird bei jeder Verbindung abgefragt';

  @override
  String get bfPassphraseBadgeActive => 'Passphrase aktiv';

  @override
  String get bfPassphraseBadgeNone => 'Keine Passphrase';

  @override
  String bfPassphraseAttemptsRatio(int left, int total) {
    return 'Verbleibende Versuche: $left / $total';
  }

  @override
  String bfPassphraseLengthSubtitle(int min, int max) {
    return 'Länge $min-$max Zeichen';
  }

  @override
  String bfPassphraseLengthHint(int min, int max) {
    return 'Länge: $min-$max';
  }

  @override
  String bfPassphraseTooShort(int min) {
    return 'Mindestens $min Zeichen';
  }

  @override
  String bfPassphraseTooLong(int max) {
    return 'Höchstens $max Zeichen';
  }

  @override
  String get bfPassphraseEmpty => 'Darf nicht leer sein';

  @override
  String get bfPassphraseNewLabel => 'Neue Passphrase';

  @override
  String get bfPassphraseCurrentLabel => 'Aktuelle Passphrase';

  @override
  String get bfPassphraseSetDone => 'Passphrase festgelegt';

  @override
  String get bfPassphraseChangeDone => 'Passphrase geändert';

  @override
  String get bfPassphraseClearDone => 'Passphrase entfernt';

  @override
  String bfPassphraseStatusReadError(String error) {
    return 'Status konnte nicht gelesen werden: $error';
  }

  @override
  String get bfPassphraseNotesTitle => 'Hinweise';

  @override
  String get bfPassphraseNotesBody =>
      '• Die Passphrase wird auf dem Gerät mit PBKDF2-SHA256 gehasht; sie wird nie im Klartext gespeichert.\n• 10 falsche Versuche setzen das Gerät auf Werkseinstellungen zurück; alle Bindungen und Daten werden gelöscht.\n• Bei einem per USB verbundenen Gerät entfällt die Passphrase-Abfrage, da physischer Zugriff bereits über die Taste einen Werksreset ermöglicht.';

  @override
  String bfBondListTitle(int used, int capacity) {
    return 'Gekoppelte SKAPPs  ($used/$capacity)';
  }

  @override
  String get bfBondListEmpty => 'Noch keine gekoppelten Peers.';

  @override
  String get bfBondListBadgeThisPhone => 'Dieses Handy';

  @override
  String get bfBondListBadgeActiveSession => 'Aktive Sitzung';

  @override
  String bfBondListRowSubtitle(String shortPid, String date) {
    return '#$shortPid · gekoppelt: $date';
  }

  @override
  String get bfBondListRemoveTooltip => 'Diesen Peer entfernen';

  @override
  String get bfBondListRemoveTitle => 'Peer entfernen?';

  @override
  String get bfBondListRemoveSelfBody =>
      'Du entfernst die Bindung dieses Handys. Wenn du bestätigst, bricht die Sitzung ab; um das Gerät wieder zu erreichen, musst du die Taste kurz drücken und neu koppeln.';

  @override
  String bfBondListRemoveOtherBody(String label, int slot) {
    return '„$label“ (Slot $slot) wird vom Gerät gelöscht. Dieses SKAPP muss die Taste kurz drücken und neu koppeln, um sich wieder zu verbinden.';
  }

  @override
  String bfBondListSlotRemoved(int slot) {
    return 'Slot $slot entfernt';
  }

  @override
  String bfBondListFetchError(String error) {
    return 'bond.list fehlgeschlagen: $error';
  }

  @override
  String get bfSettingsSectionSecurity => 'SICHERHEIT';

  @override
  String get bfSettingsPassphraseTitle => 'Geräte-Passphrase';

  @override
  String get bfSettingsBondListTitle => 'Gekoppelte SKAPPs';

  @override
  String get bfSettingsPassphraseSubtitleAlways =>
      'Aktiv, bei jeder Verbindung';

  @override
  String get bfSettingsPassphraseSubtitlePairing => 'Aktiv, bei Kopplung';

  @override
  String get bfSettingsPassphraseSubtitleOff => 'Aktiv, Durchsetzung aus';

  @override
  String bfSettingsBondsSubtitle(int count, int capacity) {
    return 'Gekoppelte Peers: $count / $capacity';
  }

  @override
  String get skapiHowItWorksTitle => 'So funktioniert es';

  @override
  String skapiHowItWorksBody(String deviceName) {
    return 'Wenn dein SmartKraft-Gerät (zum Beispiel $deviceName) ein Ereignis erlebt, etwa das Ablaufen eines Timers, einen Tastendruck oder einen Sensorauslöser, sendet es einen kleinen Befehl an deinen Computer. Dein Computer empfängt diesen Befehl und führt das von dir gewählte Skript aus.';
  }

  @override
  String get skapiHowItWorksFlowDeviceLabel => 'SmartKraft-Gerät';

  @override
  String get skapiHowItWorksFlowDeviceSub =>
      'z. B. Blocking Focus, löst ein Ereignis aus';

  @override
  String get skapiHowItWorksFlowComputerLabel => 'Computer';

  @override
  String get skapiHowItWorksFlowComputerSub =>
      'SKAPP empfängt den Befehl, das Skript läuft';

  @override
  String get skapiHowItWorksFoot =>
      'SKAPP muss auf deinem Computer laufen. Der gesamte Datenverkehr bleibt im WiFi-Netzwerk, es ist keine Internetverbindung nötig, und keine Daten verlassen dein Zuhause.';

  @override
  String get skapiPlatformGroupsHeader => 'Aktionskategorien';

  @override
  String skapiPlatformGroupsLoadError(String error) {
    return 'Gruppen konnten nicht geladen werden: $error';
  }

  @override
  String get skapiPlatformEmptyTitle => 'Noch keine Skripte hier';

  @override
  String get skapiPlatformEmptyBody =>
      'Skripte für diese Plattform sind noch unterwegs. Schau nach dem nächsten SKAPP-Update wieder vorbei.';

  @override
  String skapiGroupScriptsLoadError(String error) {
    return 'Skripte konnten nicht geladen werden: $error';
  }

  @override
  String skapiScriptDetailLoadError(String error) {
    return 'Dieses Skript konnte nicht geladen werden: $error';
  }

  @override
  String get skapiBindScreenTitle => 'An Aktion binden';

  @override
  String get skapiBindScreenSubtitle =>
      'Führe dieses Skript automatisch aus, wenn ein Geräteereignis eintritt.';

  @override
  String get skapiBindFieldDeviceLabel => 'Gerät';

  @override
  String get skapiBindFieldDeviceHint =>
      'Wähle, welches gekoppelte Gerät dieses Skript auslösen soll.';

  @override
  String get skapiBindFieldDeviceEmpty =>
      'Noch keine gekoppelten Geräte. Koppele zuerst eines im Tab „Geräte“.';

  @override
  String get skapiBindFieldEventLabel => 'Ereignis';

  @override
  String get skapiBindFieldEventHint =>
      'Das Gerät sendet dieses Ereignis; das Skript läuft, wenn es eintritt.';

  @override
  String get skapiBindEventTimerStarted => 'Timer gestartet';

  @override
  String get skapiBindEventTimerExpired => 'Timer abgelaufen';

  @override
  String get skapiBindEventFaceChanged => 'Würfelfläche gewechselt';

  @override
  String get skapiBindEventButtonPressed => 'Taste gedrückt';

  @override
  String get skapiBindEventButtonHeld => 'Taste gehalten';

  @override
  String get skapiBindEventBatteryLow => 'Akku schwach';

  @override
  String get skapiBindEventBatteryLockout => 'Akku-Sperre';

  @override
  String get skapiBindEventPowerStateChanged => 'Energiestatus geändert';

  @override
  String get skapiBindEventPairingSuccess => 'Kopplung erfolgreich';

  @override
  String get skapiBindEventApiSent => 'API-Aufruf gesendet';

  @override
  String get skapiBindParamsHeader => 'Parameter-Überschreibungen';

  @override
  String get skapiBindParamsHint =>
      'Leer lassen, um die Skript-Standardwerte zu behalten. Diese Werte werden bei jeder Auslösung der Bindung gesendet.';

  @override
  String get skapiBindButtonSave => 'Bindung speichern';

  @override
  String get skapiBindButtonDelete => 'Bindung löschen';

  @override
  String get skapiBindButtonCancel => 'Abbrechen';

  @override
  String get skapiBindButtonEnable => 'Aktivieren';

  @override
  String get skapiBindButtonDisable => 'Deaktivieren';

  @override
  String get skapiBindStatusEnabled => 'Aktiv';

  @override
  String get skapiBindStatusDisabled => 'Pausiert';

  @override
  String get skapiBindSavedToast => 'Bindung gespeichert';

  @override
  String get skapiBindDeletedToast => 'Bindung entfernt';

  @override
  String skapiBindBadgeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Bindungen',
      one: '1 Bindung',
    );
    return '$_temp0';
  }

  @override
  String get skapiBindNoPairedDeviceWarning =>
      'Koppele zuerst ein Gerät, um Bindungen zu erstellen.';

  @override
  String skapiBindTriggeredDesktopToast(String script) {
    return 'Ausgelöst: $script';
  }

  @override
  String skapiBindTriggeredMobileToast(String event) {
    return 'Bindung ausgelöst ($event); die Ausführung kommt in Phase K.';
  }

  @override
  String skapiBindLoadError(String error) {
    return 'Bindungen konnten nicht geladen werden: $error';
  }

  @override
  String get skapiBindListSectionTitle => 'Bindungen für dieses Skript';

  @override
  String get skapiBindListEmpty =>
      'Noch keine Bindungen. Tippe auf „An Aktion binden“, um eine zu erstellen.';

  @override
  String get skapiBindNewButton => 'Neue Bindung';

  @override
  String get skapiBasicSettingsTitle => 'Einstellungen';

  @override
  String get skapiBasicEmptyParams =>
      'Dieses Skript braucht keine Einstellungen. Tippe auf „Jetzt ausführen“.';

  @override
  String get skapiBasicUnitSeconds => 'Sekunden';

  @override
  String get skapiBasicConvHalfMinute => 'eine halbe Minute';

  @override
  String get skapiBasicConvLessThanMinute => 'weniger als eine Minute';

  @override
  String skapiBasicConvMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Minuten',
      one: '1 Minute',
    );
    return '$_temp0';
  }

  @override
  String skapiBasicConvHoursMinutes(int hours, int minutes) {
    return '$hours Std. $minutes Min.';
  }

  @override
  String skapiBasicConvHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Stunden',
      one: '1 Stunde',
    );
    return '$_temp0';
  }

  @override
  String get skapiBasicConvImmediate => 'startet sofort';

  @override
  String skapiBasicConvAfter(String time) {
    return 'nach $time';
  }

  @override
  String get skapiBasicPrerunSectionTitle => 'Verzögerung vor dem Start';

  @override
  String get skapiBasicPrerunAddCta => 'Verzögerung vor dem Lauf hinzufügen';

  @override
  String get skapiBasicPrerunLabel =>
      'So viele Sekunden warten, bevor das Skript startet';

  @override
  String get skapiBasicPrerunHelp =>
      'Nützlich, um zuerst eine Benachrichtigung anzuzeigen oder Aktionen zu verketten. Standard 0 bedeutet sofortiger Start.';

  @override
  String get skapiBasicPrerunRemove => 'Verzögerung entfernen';

  @override
  String get skapiBasicListAddPlaceholder => '+ hinzufügen';

  @override
  String get skapiRunSheetTitle => 'Skript ausführen';

  @override
  String get skapiRunSheetStatusRunning => 'Läuft';

  @override
  String get skapiRunSheetStatusOk => 'Fertig';

  @override
  String get skapiRunSheetStatusError => 'Fehlgeschlagen';

  @override
  String skapiRunSheetExitCode(int code) {
    return 'Exit-Code: $code';
  }

  @override
  String get skapiRunSheetCancel => 'Abbrechen';

  @override
  String get skapiRunSheetClose => 'Schließen';

  @override
  String get skapiRunSheetCopyOutput => 'Ausgabe kopieren';

  @override
  String get skapiRunSheetCopiedDone => 'Kopiert';

  @override
  String get skapiRunSheetEmptyOutput => 'Warte auf Ausgabe...';

  @override
  String get skapiRunSheetDismissConfirmTitle => 'Laufendes Skript stoppen?';

  @override
  String get skapiRunSheetDismissConfirmBody =>
      'Das Skript läuft noch. Wenn du dieses Sheet schließt, wird es abgebrochen.';

  @override
  String get skapiRunSheetDismissConfirmStay => 'Weiterlaufen lassen';

  @override
  String get skapiRunSheetDismissConfirmStop => 'Abbrechen';

  @override
  String get skapiRunErrorPowerShellMissing =>
      'PowerShell wurde auf diesem System nicht gefunden.';

  @override
  String skapiRunErrorTempWrite(String error) {
    return 'Das Skript konnte nicht in den temporären Ordner geschrieben werden: $error';
  }

  @override
  String skapiRunErrorSpawn(String error) {
    return 'PowerShell konnte nicht gestartet werden: $error';
  }

  @override
  String skapiRunDurationMs(int ms) {
    return 'Dauerte $ms ms';
  }

  @override
  String get skapiCopiedToClipboard => 'Kopiert';

  @override
  String get skapiFavouriteAddTooltip => 'Zu Favoriten hinzufügen';

  @override
  String get skapiFavouriteRemoveTooltip => 'Aus Favoriten entfernen';

  @override
  String skapiGroupAppBarSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Skripte',
      one: '1 Skript',
    );
    return '$_temp0';
  }

  @override
  String get skapiPlatformScreenCategoriesTitle => 'Aktionskategorien';

  @override
  String skapiPlatformScreenCategoriesSub(int groups, int scripts) {
    return '$groups Gruppen · insgesamt $scripts Skripte';
  }

  @override
  String get skapiGroupScriptsHeader => 'Skripte';

  @override
  String skapiGroupScriptsCount(int count) {
    return '$count Skripte';
  }

  @override
  String skapiGroupItemCount(int count) {
    return '$count Skripte';
  }

  @override
  String get skapiGroupPowerTitle => 'Energieverwaltung';

  @override
  String get skapiGroupPowerDesc =>
      'Skripte in dieser Gruppe sperren den Computer, versetzen ihn in den Ruhezustand, in den Tiefschlaf oder fahren ihn herunter. Sie sind nützlich, wenn ein SmartKraft-Gerät das Ende einer Fokus-Sitzung signalisiert oder längere Inaktivität erkennt und der Rechner nachziehen soll.';

  @override
  String get skapiGroupPowerFoot =>
      'Typischer Einsatz: sperren, wenn du aufstehst, Tiefschlaf am Ende des Tages, geplantes Herunterfahren nach langer Inaktivität.';

  @override
  String get skapiScriptLockTitle => 'Arbeitsplatz sperren';

  @override
  String get skapiScriptLockSummaryWhat =>
      'Sperrt Windows sofort und kehrt zum Anmeldebildschirm zurück. Geöffnete Apps laufen weiter.';

  @override
  String get skapiScriptLockSummaryHow =>
      'Ruft die Win32-Funktion LockWorkStation aus user32 auf. Entspricht dem Drücken von Win+L.';

  @override
  String get skapiScriptHibernateTitle => 'Tiefschlaf';

  @override
  String get skapiScriptHibernateSummaryWhat =>
      'Speichert die aktuelle Sitzung auf der Festplatte und fährt den Rechner herunter. Beim Fortsetzen kehrst du dorthin zurück, wo du aufgehört hast, selbst ohne Akku.';

  @override
  String get skapiScriptHibernateSummaryHow =>
      'Führt das integrierte shutdown.exe mit dem Flag /h aus. Der Tiefschlaf muss in den Windows-Energieeinstellungen aktiviert sein; ist er es nicht, weicht Windows auf den Ruhezustand aus.';

  @override
  String get skapiScriptHibernateNote =>
      'Führe einmal powercfg /hibernate on in einer Admin-Shell aus, falls der Tiefschlaf auf deinem System fehlt.';

  @override
  String get skapiScriptHibernateParamDelayLabel => 'delay';

  @override
  String get skapiScriptHibernateParamDelayHint =>
      'Sekunden, die vor dem Tiefschlaf gewartet wird, falls die Benachrichtigung des Geräts zuerst erscheinen soll.';

  @override
  String get skapiScriptSleepTitle => 'Ruhezustand';

  @override
  String get skapiScriptSleepSummaryWhat =>
      'Versetzt den Rechner in den RAM-Ruhezustand (S3). Das Fortsetzen ist schnell, zieht aber im Ruhezustand etwas Akku.';

  @override
  String get skapiScriptSleepSummaryHow =>
      'Ruft System.Windows.Forms.Application.SetSuspendState mit PowerState.Suspend auf. Das Betriebssystem kann verzögern, wenn ein Vordergrundprozess Leerlaufübergänge blockiert.';

  @override
  String get skapiScriptSleepParamDelayLabel => 'delay';

  @override
  String get skapiScriptSleepParamDelayHint =>
      'Sekunden, die vor dem Ruhezustand gewartet wird.';

  @override
  String get skapiScriptShutdownTitle => 'Herunterfahren';

  @override
  String get skapiScriptShutdownSummaryWhat =>
      'Leitet ein geordnetes Herunterfahren von Windows ein. Geöffnete Apps werden zum Speichern und Schließen aufgefordert.';

  @override
  String get skapiScriptShutdownSummaryHow =>
      'Führt das integrierte shutdown.exe /s aus. Mit aktiviertem Erzwingen wird /f hinzugefügt, damit nicht reagierende Apps beendet werden.';

  @override
  String get skapiScriptShutdownNote =>
      'Eine Verzögerung ungleich null gibt dem Benutzer Zeit, über shutdown /a aus einem Terminal abzubrechen.';

  @override
  String get skapiScriptShutdownParamDelayLabel => 'delay';

  @override
  String get skapiScriptShutdownParamDelayHint =>
      'Sekunden, die Windows vor dem Herunterfahren wartet. 30 ist der Standard; wähle 0 für sofortiges Herunterfahren.';

  @override
  String get skapiScriptShutdownParamForceLabel => 'force';

  @override
  String get skapiScriptShutdownParamForceHint =>
      'Schließt Apps, die nicht auf das Herunterfahr-Signal reagieren. Ungespeicherte Arbeit in diesen Apps kann verloren gehen.';

  @override
  String get skapiGroupDisplayAudioTitle => 'Bildschirm, Bild & Ton';

  @override
  String get skapiGroupDisplayAudioDesc =>
      'Skripte in dieser Gruppe passen Bildschirm und Tonausgabe an: Helligkeit, Lautstärke, Stummschaltung und Medienwiedergabe. Sie sind nützlich, wenn ein SmartKraft-Gerät möchte, dass der Computer während einer Fokuspause dimmt oder die Musik pausiert, wenn du aufstehst.';

  @override
  String get skapiGroupDisplayAudioFoot =>
      'Typischer Einsatz: Bildschirm während einer Pause dimmen, beim Sperren stummschalten, Spotify pausieren, wenn ein Gerät keine Aktivität erkennt.';

  @override
  String get skapiScriptBrightnessTitle => 'Helligkeit einstellen';

  @override
  String get skapiScriptBrightnessSummaryWhat =>
      'Stellt die Helligkeit des internen Displays auf einen Prozentwert zwischen 0 und 100 ein.';

  @override
  String get skapiScriptBrightnessSummaryHow =>
      'Ruft die WMI-Methode WmiMonitorBrightnessMethods.WmiSetBrightness mit dem gewünschten Wert auf. Nur Laptops, Tablets und integrierte Panels reagieren; externe DDC/CI-Monitore werden auf diesem Weg nicht unterstützt.';

  @override
  String get skapiScriptBrightnessNote =>
      'Externe Monitore ändern sich nicht. Bei Mehrmonitor-Setups reagiert nur das Panel, das seine Helligkeit über WMI meldet.';

  @override
  String get skapiScriptBrightnessParamLevelLabel => 'level';

  @override
  String get skapiScriptBrightnessParamLevelHint =>
      'Helligkeit in Prozent (0-100). Niedrigere Werte sind dunkler. 70 ist bei normaler Beleuchtung ein angenehmer Standard.';

  @override
  String get skapiScriptBrightnessParamTimeoutLabel => 'timeout';

  @override
  String get skapiScriptBrightnessParamTimeoutHint =>
      'Sekunden, die die Helligkeitsänderung dauern darf. Das Betriebssystem regelt innerhalb dieses Zeitfensters gleichmäßig hoch.';

  @override
  String get skapiScriptMuteToggleTitle => 'Stummschaltung umschalten';

  @override
  String get skapiScriptMuteToggleSummaryWhat =>
      'Schaltet die System-Hauptstummschaltung um. Aktive Medien laufen weiter, du hörst sie aber nicht.';

  @override
  String get skapiScriptMuteToggleSummaryHow =>
      'Sendet die virtuelle Taste VK_VOLUME_MUTE, denselben Weg, den Windows nutzt, wenn der Benutzer die Stummtaste auf der Tastatur drückt. Keine Admin- oder COM-Abhängigkeit.';

  @override
  String get skapiScriptMuteToggleParamModeLabel => 'mode';

  @override
  String get skapiScriptMuteToggleParamModeHint =>
      'toggle / on / off. Nur toggle wird über den einfachen Tastendruck durchgesetzt; on und off werden für künftige Kompatibilität akzeptiert.';

  @override
  String get skapiScriptVolumeSetTitle => 'Lautstärke einstellen';

  @override
  String get skapiScriptVolumeSetSummaryWhat =>
      'Stellt die System-Hauptlautstärke auf einen genauen Wert zwischen 0 und 100 ein.';

  @override
  String get skapiScriptVolumeSetSummaryHow =>
      'Ruft Core Audio IAudioEndpointVolume.SetMasterVolumeLevelScalar über Inline-C#-COM-Interop auf. Zielt auf den Standard-Render-Endpunkt.';

  @override
  String get skapiScriptVolumeSetNote =>
      'Tier 2: funktioniert auf Standard-Desktops mit Windows 10/11. Abgespeckte Installationen stellen die COM-Schnittstelle womöglich nicht bereit; App-spezifische Endpunkte werden auf diesem Weg nicht angesprochen.';

  @override
  String get skapiScriptVolumeSetParamLevelLabel => 'level';

  @override
  String get skapiScriptVolumeSetParamLevelHint =>
      'Lautstärke in Prozent (0-100). 0 schaltet stumm, ohne die Stummschaltung zu setzen; 50 ist ein angenehmer Standard.';

  @override
  String get skapiScriptMediaKeyTitle => 'Medientaste';

  @override
  String get skapiScriptMediaKeySummaryWhat =>
      'Simuliert einen Medientastendruck: Wiedergabe/Pause, Weiter, Zurück oder Stopp. Geht an die App, die gerade die Mediensitzung besitzt.';

  @override
  String get skapiScriptMediaKeySummaryHow =>
      'Sendet VK_MEDIA_PLAY_PAUSE / VK_MEDIA_NEXT_TRACK / VK_MEDIA_PREV_TRACK / VK_MEDIA_STOP über keybd_event. Windows leitet den Druck über die System Media Transport Controls weiter.';

  @override
  String get skapiScriptMediaKeyNote =>
      'Tier 2: benötigt eine aktive Mediensitzung. Wenn keine App spielt oder die Vordergrund-App sich nicht bei SMTC registriert, wird der Druck stillschweigend verworfen.';

  @override
  String get skapiScriptMediaKeyParamKeyLabel => 'key';

  @override
  String get skapiScriptMediaKeyParamKeyHint =>
      'play-pause / next / previous / stop. Standard ist play-pause.';

  @override
  String get skapiGroupWindowAppTitle => 'Fenster & Anwendung';

  @override
  String get skapiGroupWindowAppDesc =>
      'Skripte in dieser Gruppe steuern Fenster und Anwendungen: minimieren, fokussieren, geordnet schließen oder Prozesse direkt beenden. Sie halten deinen Arbeitsbereich aufgeräumt, wenn ein SmartKraft-Gerät möchte, dass der Computer den Kontext wechselt.';

  @override
  String get skapiGroupWindowAppFoot =>
      'Typischer Einsatz: alles minimieren, wenn eine Fokus-Sitzung beginnt, den Browser schließen, wenn die Arbeit vorbei ist, eine hängende App auf Befehl beenden.';

  @override
  String get skapiScriptMinimizeWindowTitle => 'Fenster minimieren';

  @override
  String get skapiScriptMinimizeWindowSummaryWhat =>
      'Minimiert ein bestimmtes Fenster anhand des Prozessnamens. Ein leerer Prozessname zielt auf das aktuell fokussierte Fenster.';

  @override
  String get skapiScriptMinimizeWindowSummaryHow =>
      'Ermittelt das erste passende Hauptfenster über Get-Process und ruft user32 ShowWindow mit SW_MINIMIZE auf.';

  @override
  String get skapiScriptMinimizeWindowNote =>
      'Wenn mehrere Instanzen laufen, wird nur das erste passende Fenster minimiert. Verwende den Prozessnamen ohne die Endung .exe.';

  @override
  String get skapiScriptMinimizeWindowParamProcessLabel => 'processName';

  @override
  String get skapiScriptMinimizeWindowParamProcessHint =>
      'Prozessname ohne .exe (chrome, code, winword). Leer zielt auf das Vordergrundfenster.';

  @override
  String get skapiScriptCloseWindowTitle => 'Fenster schließen';

  @override
  String get skapiScriptCloseWindowSummaryWhat =>
      'Sendet einem Fenster ein geordnetes Schließen, damit die App ihren eigenen Dialog „Änderungen speichern?“ anzeigen kann.';

  @override
  String get skapiScriptCloseWindowSummaryHow =>
      'Sendet WM_CLOSE über user32 SendMessage. Gleicher Effekt wie ein Klick des Benutzers auf das X. Ein leerer Prozessname zielt auf das Vordergrundfenster.';

  @override
  String get skapiScriptCloseWindowNote =>
      'Apps mit ungespeicherter Arbeit zeigen ihren eigenen Dialog. Das Skript wartet nicht auf hängende Apps und beendet sie nicht.';

  @override
  String get skapiScriptCloseWindowParamProcessLabel => 'processName';

  @override
  String get skapiScriptCloseWindowParamProcessHint =>
      'Prozessname ohne .exe. Leer zielt auf das Vordergrundfenster.';

  @override
  String get skapiScriptKillAppTitle => 'App beenden erzwingen';

  @override
  String get skapiScriptKillAppSummaryWhat =>
      'Beendet jede Instanz eines Prozesses. Versucht zuerst WM_CLOSE, dann TerminateProcess, falls die App nach dem Timeout noch läuft.';

  @override
  String get skapiScriptKillAppSummaryHow =>
      'Sendet WM_CLOSE an jedes Hauptfenster, wartet das konfigurierte Timeout ab und führt dann Stop-Process mit -Force für alles noch Laufende aus.';

  @override
  String get skapiScriptKillAppNote =>
      'Ungespeicherte Arbeit in nicht reagierenden Apps geht beim erzwungenen Beenden verloren. Verwende preKillSave für Editor-artige Apps, die auf Strg+S reagieren.';

  @override
  String get skapiScriptKillAppParamProcessLabel => 'processName';

  @override
  String get skapiScriptKillAppParamProcessHint =>
      'Prozessname ohne .exe. Alle laufenden Instanzen werden beendet.';

  @override
  String get skapiScriptKillAppParamTimeoutLabel => 'timeout';

  @override
  String get skapiScriptKillAppParamTimeoutHint =>
      'Sekunden, die zwischen WM_CLOSE und dem erzwungenen Beenden gewartet wird. Höhere Werte geben der App mehr Zeit zum Speichern.';

  @override
  String get skapiScriptKillAppParamPreKillSaveLabel => 'preKillSave';

  @override
  String get skapiScriptKillAppParamPreKillSaveHint =>
      'Sendet vor dem Schließen Strg+S an das Vordergrundfenster. Nützlich für Editoren, aber wirkungslos bei Apps, die Strg+S ignorieren.';

  @override
  String get skapiScriptLaunchAppTitle => 'App starten';

  @override
  String get skapiScriptLaunchAppSummaryWhat =>
      'Startet eine ausführbare Datei, öffnet eine URL oder startet ein Dokument mit dem Standardprogramm.';

  @override
  String get skapiScriptLaunchAppSummaryHow =>
      'Ruft PowerShell Start-Process mit dem Pfad und einer optionalen Argumentliste auf. Der Pfad kann eine .exe, ein vollständiger Dateipfad oder eine URL sein.';

  @override
  String get skapiScriptLaunchAppNote =>
      'Pfade mit Leerzeichen werden akzeptiert. Verwende eine URL wie https://example.com, um den Standardbrowser zu öffnen.';

  @override
  String get skapiScriptLaunchAppParamPathLabel => 'path';

  @override
  String get skapiScriptLaunchAppParamPathHint =>
      'Ausführbare Datei, vollständiger Dateipfad oder URL. notepad / C:\\\\tools\\\\my.exe / https://example.com.';

  @override
  String get skapiScriptLaunchAppParamArgsLabel => 'args';

  @override
  String get skapiScriptLaunchAppParamArgsHint =>
      'An die ausführbare Datei übergebene Argumente. Leer für keine.';

  @override
  String get skappListenerCardTitle => 'SKAPP-HTTP-Listener';

  @override
  String skappListenerCardSubtitleRunning(int port) {
    return 'Läuft auf Port $port';
  }

  @override
  String get skappListenerCardSubtitleStopped => 'Gestoppt';

  @override
  String get skappListenerCardSubtitleUnsupported =>
      'Diese Plattform kann den Listener nicht hosten.';

  @override
  String get skappListenerCardEnableSwitch => 'Listener aktivieren';

  @override
  String get skappListenerCardSecurityNote =>
      'Der Listener akzeptiert Verbindungen nur in deinem lokalen Netzwerk und benötigt den Bearer-Token. Reines HTTP, setze ihn nicht dem öffentlichen Internet aus.';

  @override
  String get settingsLanVisibleTitle => 'Im LAN sichtbar';

  @override
  String get settingsLanVisibleSubtitle =>
      'Wenn aus, bindet sich der Listener nur an localhost. Gekoppelte BF-Geräte können diesen Desktop nicht erreichen.';

  @override
  String get settingsLanVisibleWarnBfBreaks =>
      'Dies auszuschalten unterbricht die BF-Webhook-Kette. Nur in einer vertrauenswürdigen oder Testumgebung verwenden.';

  @override
  String get settingsLanVisibleAutoReopenedSnack =>
      'Die LAN-Sichtbarkeit wurde wieder eingeschaltet, damit BF-Geräte diesen Desktop erreichen können.';

  @override
  String get skapiRunRemoteDeveloperModeDisabled =>
      'Auf dem Ziel-Desktop ist der Entwicklermodus deaktiviert, daher ist dort die Skript-Fernausführung aus.';

  @override
  String get skappPeerPairingManualUuidConfirmLabel =>
      'Bestätigungscode (letzte 4 der UUID)';

  @override
  String get skappPeerPairingManualUuidConfirmHint =>
      'Lies den 4-stelligen Code, der auf dem Kopplungsbildschirm des Desktops angezeigt wird.';

  @override
  String get skappPeerPairingManualUuidConfirmError =>
      'Der Code stimmt nicht mit den letzten 4 der UUID überein. Prüfe den Desktop-Bildschirm.';

  @override
  String get skappListenerCardUuidLast4Label => 'Kopplungs-Bestätigungscode';

  @override
  String get skappListenerCardUuidLast4Hint =>
      'Gib diese 4 Zeichen auf dem manuellen Kopplungsbildschirm des Handys ein.';

  @override
  String get settingsPeerTokensTitle => 'Ausgegebene Peer-Tokens';

  @override
  String get settingsPeerTokensSubtitle =>
      'Mobile Peers, die mit diesem Desktop gekoppelt sind. Widerrufe einen Eintrag, um ihn abzumelden, ohne die anderen zu beeinflussen.';

  @override
  String get settingsPeerTokensEmpty => 'Noch keine Peers gekoppelt.';

  @override
  String settingsPeerTokensIssuedAt(String when) {
    return 'Gekoppelt $when';
  }

  @override
  String settingsPeerTokensLastUsed(String when) {
    return 'Zuletzt verwendet $when';
  }

  @override
  String get settingsPeerTokensRevokeButton => 'Widerrufen';

  @override
  String get settingsPeerTokensRevokeConfirmTitle => 'Diesen Peer widerrufen?';

  @override
  String get settingsPeerTokensRevokeConfirmBody =>
      'Der Peer wird sofort abgemeldet und muss erneut koppeln, um diesen Desktop zu erreichen.';

  @override
  String get settingsPeerTokensRevokeConfirmCancel => 'Abbrechen';

  @override
  String get settingsPeerTokensRevokeConfirmAction => 'Widerrufen';

  @override
  String settingsPeerTokensRevokedToast(String name) {
    return 'Peer $name widerrufen';
  }

  @override
  String get skappListenerCardRotateCertButton => 'TLS-Zertifikat wechseln';

  @override
  String get skappListenerCardRotateCertConfirmTitle => 'Zertifikat wechseln?';

  @override
  String get skappListenerCardRotateCertConfirmBody =>
      'Ein neues selbstsigniertes TLS-Zertifikat wird erzeugt. Jeder zuvor gekoppelte Peer schlägt beim Handshake fehl, bis er erneut koppelt.';

  @override
  String get skappListenerCardRotateCertConfirmCancel => 'Abbrechen';

  @override
  String get skappListenerCardRotateCertConfirmAction => 'Wechseln';

  @override
  String get skappListenerCardRotateCertDoneSnack =>
      'TLS-Zertifikat gewechselt. Koppele jedes Gerät erneut.';

  @override
  String get skappListenerCardCertFingerprintLabel => 'TLS-Fingerabdruck';

  @override
  String skappListenerCardErrorPortInUse(int port) {
    return 'Port $port wird bereits verwendet. Wähle in der Netzwerkidentität einen anderen Port.';
  }

  @override
  String skappListenerCardErrorGeneric(String error) {
    return 'Der Listener konnte nicht gestartet werden: $error';
  }

  @override
  String get skappPeerPairingTitle => 'Desktop-SKAPP koppeln';

  @override
  String get skappPeerPairingSubtitle =>
      'Scanne den QR aus den Einstellungen des Desktop-SKAPP oder füge den Kopplungscode manuell ein.';

  @override
  String get skappPeerPairingTabScan => 'QR scannen';

  @override
  String get skappPeerPairingTabManual => 'Manuell';

  @override
  String get skappPeerPairingScanHint =>
      'Richte deine Kamera auf den QR unter Desktop-SKAPP > Einstellungen > SKAPP-HTTP-Listener.';

  @override
  String get skappPeerPairingScanCameraDeniedTitle =>
      'Kameraberechtigung erforderlich';

  @override
  String get skappPeerPairingScanCameraDeniedBody =>
      'Erlaube in deinen Handy-Einstellungen den Kamerazugriff, um den Kopplungs-QR zu scannen. Du kannst den Code auch manuell eingeben.';

  @override
  String get skappPeerPairingManualHostLabel => 'Desktop-IP oder Hostname';

  @override
  String get skappPeerPairingManualPortLabel => 'Port';

  @override
  String get skappPeerPairingManualTokenLabel => 'Bearer-Token';

  @override
  String get skappPeerPairingManualUuidLabel => 'Desktop-UUID';

  @override
  String get skappPeerPairingManualNameLabel => 'Anzeigename';

  @override
  String get skappPeerPairingManualSubmit => 'Koppeln';

  @override
  String skappPeerPairingSavedToast(String name) {
    return 'Mit $name gekoppelt';
  }

  @override
  String skappPeerPairingFailedToast(String reason) {
    return 'Kopplung fehlgeschlagen: $reason';
  }

  @override
  String get skappPeerPairingShowQrTitle =>
      'Ein Handy mit diesem Desktop koppeln';

  @override
  String get skappPeerPairingShowQrBody =>
      'Öffne SKAPP auf deinem Handy, gehe zu SKAPI > Einstellungen > Desktop koppeln und scanne diesen QR. Der QR enthält den Bearer-Token, behandle ihn wie ein Passwort.';

  @override
  String get skappPeerPairingShowQrCloseButton => 'Fertig';

  @override
  String get skappPeerListEmpty =>
      'Noch kein gekoppelter Desktop. Koppele einen, um Skripte von diesem Handy auszuführen.';

  @override
  String get skappPeerListSectionTitle => 'Gekoppelte Desktop-SKAPPs';

  @override
  String get skappPeerStatusOnline => 'Online';

  @override
  String get skappPeerStatusOffline => 'Offline';

  @override
  String skappPeerStatusLastSeen(String when) {
    return 'Zuletzt gesehen $when';
  }

  @override
  String get skappPeerRemoveTooltip => 'Gekoppelten Desktop entfernen';

  @override
  String get skappPeerRemoveConfirmTitle => 'Kopplung entfernen?';

  @override
  String skappPeerRemoveConfirmBody(String name) {
    return 'Von diesem Handy ausgelöste Skripte laufen nicht mehr auf $name, bis du erneut koppelst.';
  }

  @override
  String get skappPeerScanRefreshTooltip => 'Peer-Liste aktualisieren';

  @override
  String skapiRunRemoteSheetTitle(String peerName) {
    return 'Remote auf $peerName ausführen';
  }

  @override
  String get skapiRunRemoteConnecting => 'Verbinde mit Desktop...';

  @override
  String get skapiRunRemoteOfflineError =>
      'Der gekoppelte Desktop ist offline. Aktualisiere die Peers oder prüfe den Listener des Desktops.';

  @override
  String get skapiRunRemoteUnauthorizedError =>
      'Bearer-Token abgelehnt. Der Token des Desktops wurde möglicherweise gewechselt. Koppele in den Einstellungen erneut.';

  @override
  String skapiRunRemoteHttpError(String reason) {
    return 'Remote-Ausführung fehlgeschlagen: $reason';
  }

  @override
  String get skapiRunMobileNoPeerTitle => 'Kein gekoppelter Desktop';

  @override
  String get skapiRunMobileNoPeerBody =>
      'Koppele in den Einstellungen ein Desktop-SKAPP, um Skripte von diesem Handy auszuführen.';

  @override
  String get skapiRunMobileNoPeerCta => 'Einstellungen öffnen';

  @override
  String get skapiRunRemoteNotWhitelisted =>
      'Dieses Skript ist nicht als remote ausführbar markiert. Führe es direkt auf dem Desktop aus.';

  @override
  String get skapiRunRemoteNoPeerHint =>
      'Koppele in den Einstellungen ein Desktop-SKAPP, um Skripte von diesem Handy auszuführen.';

  @override
  String get skapiRunRemoteNoPeerAction => 'Einstellungen öffnen';

  @override
  String get skappPeerPickerTitle => 'An welchen Computer senden?';

  @override
  String get skappPeerPickerSubtitle =>
      'Wähle das gekoppelte Desktop-SKAPP, das dieses Skript ausführen soll.';

  @override
  String get skappPeerPickerOfflineReason => 'Offline';

  @override
  String get skappPeerPickerDevModeOffReason => 'Entwicklermodus ist aus';

  @override
  String get skappPeerPickerEmpty => 'Keine gekoppelten Desktops zur Auswahl.';

  @override
  String get skapiRunRemoteCancelButton => 'Abbrechen';

  @override
  String get skapiRunRemoteCancelledNote => 'Ausführung abgebrochen';

  @override
  String skapiRunRemoteTooManyRuns(int running, int limit) {
    return 'Auf diesem Desktop laufen bereits $running Skripte ($limit max.). Warte, bis eines fertig ist.';
  }

  @override
  String get skappPeerHealthDevModeBadge => 'Entwicklermodus';

  @override
  String get remoteRunActivityCardTitle => 'Remote-Ausführungen';

  @override
  String get remoteRunActivityCardSubtitle =>
      'Letzte Skript-Ausführungen, die gekoppelte mobile Peers auf diesem Desktop angefordert haben.';

  @override
  String get remoteRunActivityCardEmpty => 'Noch keine Remote-Ausführungen.';

  @override
  String get remoteRunActivityCardClear => 'Verlauf leeren';

  @override
  String remoteRunActivityRowOk(int exitCode, int durationMs) {
    return 'Exit $exitCode · $durationMs ms';
  }

  @override
  String get remoteRunActivityRowCancelled => 'abgebrochen';

  @override
  String remoteRunActivityRowRejected(String reason) {
    return 'abgelehnt · $reason';
  }

  @override
  String get mobileTriggerCardTitle => 'Auslösen';

  @override
  String get mobileTriggerCardSubtitle =>
      'Sende ein Tipp-Ereignis an ein gekoppeltes Desktop-SKAPP. Jede Bindung, die auf dieses Ereignis hört, löst ihr Skript auf diesem Desktop aus.';

  @override
  String get mobileTriggerCardSendButton => 'Tipp senden';

  @override
  String get mobileTriggerCardSending => 'Wird gesendet...';

  @override
  String mobileTriggerSentToast(String name) {
    return 'Tipp an $name gesendet';
  }

  @override
  String get skapiBindEventMobileTap => 'Mobiler Tipp';

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
  String get msHomeScreenTitle => 'Mobiler Peer';

  @override
  String get msHomeScreenNotFound =>
      'Dieser mobile Peer ist nicht mehr gekoppelt.';

  @override
  String get msHomeScreenEventsHeader => 'Verfügbare Ereignisse';

  @override
  String msHomeScreenBindingsHeader(int count) {
    return 'Bindungen ($count)';
  }

  @override
  String get msHomeScreenBindingsEmpty =>
      'Noch keine Bindungen. Verwende SKAPI → Skript → An Aktion binden, um ein Tipp-Ereignis mit einem Skript zu verknüpfen.';

  @override
  String get msHomeScreenHint =>
      'Handys führen keine Skripte aus. Sie senden Auslöser-Ereignisse, die dieser Desktop an Skripte bindet.';

  @override
  String msHomeScreenPairedAt(String date) {
    return 'Gekoppelt $date';
  }

  @override
  String get skapiGroupNotifyTitle => 'Benachrichtigung & Dialog';

  @override
  String get skapiGroupNotifyDesc =>
      'Skripte in dieser Gruppe sprechen direkt mit dem Benutzer: eine Toast-Meldung einblenden, einen modalen Dialog anzeigen oder auf eine Ja/Nein-Antwort warten. Nutze sie, wenn das Ereignis eines SmartKraft-Geräts den Menschen vor dem Bildschirm zum Bestätigen oder Entscheiden braucht.';

  @override
  String get skapiGroupNotifyFoot =>
      'Typischer Einsatz: Dialog vor einer destruktiven Aktion, Toast bei einer sanften Erinnerung, Dialog mit Timeout, der automatisch durchfällt.';

  @override
  String get skapiScriptDialogTitle => 'Dialog anzeigen';

  @override
  String get skapiScriptDialogSummaryWhat =>
      'Zeigt eine modale Windows-MessageBox und gibt die Wahl des Benutzers zurück (ok / cancel / yes / no / timeout).';

  @override
  String get skapiScriptDialogSummaryHow =>
      'Ruft System.Windows.Forms.MessageBox in einem untergeordneten Runspace auf, damit das Skript den Dialog gegen ein optionales Timeout laufen lassen kann. Der gewählte Wert wird für die Verzweigung des Aufrufers nach stdout geschrieben.';

  @override
  String get skapiScriptDialogNote =>
      'stdout ist die Antwort des Benutzers in Kleinbuchstaben. timeout=0 wartet unbegrenzt.';

  @override
  String get skapiScriptDialogParamTitleLabel => 'title';

  @override
  String get skapiScriptDialogParamTitleHint =>
      'In der MessageBox angezeigter Fenstertitel.';

  @override
  String get skapiScriptDialogParamBodyLabel => 'body';

  @override
  String get skapiScriptDialogParamBodyHint =>
      'Die dem Benutzer angezeigte Frage oder Nachricht.';

  @override
  String get skapiScriptDialogParamButtonsLabel => 'buttons';

  @override
  String get skapiScriptDialogParamButtonsHint =>
      'ok / ok_cancel / yes_no / yes_no_cancel. Standard ok_cancel.';

  @override
  String get skapiScriptDialogParamTimeoutLabel => 'timeout';

  @override
  String get skapiScriptDialogParamTimeoutHint =>
      'Sekunden, bis mit „timeout“ durchgefallen wird. 0 bedeutet unbegrenzt warten.';

  @override
  String get skapiScriptToastTitle => 'Toast anzeigen';

  @override
  String get skapiScriptToastSummaryWhat =>
      'Zeigt eine Windows-Toast-Benachrichtigung mit Titel und Text. Schiebt von rechts unten herein und landet im Info-Center.';

  @override
  String get skapiScriptToastSummaryHow =>
      'Baut eine ToastNotification-XML-Nutzlast und übergibt sie dem WinRT ToastNotificationManager unter der konfigurierten AppUserModelID.';

  @override
  String get skapiScriptToastNote =>
      'Tier 2: benötigt Windows 10+ und eine registrierte AppUserModelID für die beste Darstellung. Die Standard-AUMID legt den Toast unter PowerShell im Info-Center ab.';

  @override
  String get skapiScriptToastParamTitleLabel => 'title';

  @override
  String get skapiScriptToastParamTitleHint => 'Fette erste Zeile des Toasts.';

  @override
  String get skapiScriptToastParamBodyLabel => 'body';

  @override
  String get skapiScriptToastParamBodyHint =>
      'Kleinere zweite Zeile. Optional.';

  @override
  String get skapiScriptToastParamAumidLabel => 'aumid';

  @override
  String get skapiScriptToastParamAumidHint =>
      'App User Model ID, unter der der Toast erscheint. Standard fällt auf PowerShell zurück.';

  @override
  String get skapiGroupVisualBreakTitle => 'Visuelle Pause';

  @override
  String get skapiGroupVisualBreakDesc =>
      'Sanfte visuelle Reize, die den Benutzer von intensiver Arbeit weglocken: Bildschirm dimmen, auf Graustufen umschalten, den Cursor finden oder den Desktop anzeigen. Effekte in dieser Gruppe sind umkehrbar und blockieren niemals fest die Eingabe.';

  @override
  String get skapiGroupVisualBreakFoot =>
      'Typischer Einsatz: Bildschirm zu Beginn einer Fokuspause dimmen, Graustufenmodus für nächtliche Lektüre, Maus finden bei Mehrmonitor-Setups.';

  @override
  String get skapiScriptShowDesktopTitle => 'Desktop anzeigen';

  @override
  String get skapiScriptShowDesktopSummaryWhat =>
      'Schaltet „Desktop anzeigen“ um. Wie zweimaliges Drücken von Win+D hintereinander.';

  @override
  String get skapiScriptShowDesktopSummaryHow =>
      'Ruft Shell.Application.ToggleDesktop über COM auf. Erneutes Ausführen stellt die vorherige Fensteranordnung wieder her.';

  @override
  String get skapiScriptFadeScreenTitle => 'Bildschirm überblenden';

  @override
  String get skapiScriptFadeScreenSummaryWhat =>
      'Blendet die Helligkeit des internen Displays über einige Sekunden vom aktuellen auf einen Zielwert über.';

  @override
  String get skapiScriptFadeScreenSummaryHow =>
      'Liest die aktuelle Helligkeit über WMI WmiMonitorBrightness, steuert dann WmiSetBrightness in linearen Schritten zum Ziel, damit der Wechsel gleichmäßig wirkt.';

  @override
  String get skapiScriptFadeScreenNote =>
      'Tier 2: Die WMI-Helligkeit funktioniert nur bei internen Panels. Externe Monitore reagieren auf diesem Weg nicht.';

  @override
  String get skapiScriptFadeScreenParamTargetLabel => 'target';

  @override
  String get skapiScriptFadeScreenParamTargetHint =>
      'Endhelligkeit in Prozent (0-100).';

  @override
  String get skapiScriptFadeScreenParamDurationLabel => 'duration';

  @override
  String get skapiScriptFadeScreenParamDurationHint =>
      'Sekunden, die das Überblenden dauern soll. Das Skript verwendet zehn Helligkeitsschritte pro Sekunde.';

  @override
  String get skapiScriptGrayscaleTitle => 'Graustufenfilter';

  @override
  String get skapiScriptGrayscaleSummaryWhat =>
      'Schaltet den Graustufenmodus der Windows-Farbfilter ein oder aus.';

  @override
  String get skapiScriptGrayscaleSummaryHow =>
      'Schreibt die ColorFiltering-Registry-Schlüssel und sendet dann Win+Strg+C, damit Windows die Änderung live ohne Abmeldung übernimmt.';

  @override
  String get skapiScriptGrayscaleNote =>
      'Tier 2: Für das Live-Umschalten muss Einstellungen > Erleichterte Bedienung > Farbfilter > „Tastenkombination zulassen“ aktiviert sein.';

  @override
  String get skapiScriptGrayscaleParamOnLabel => 'on';

  @override
  String get skapiScriptGrayscaleParamOnHint =>
      'true, um Graustufen zu aktivieren, false, um sie auszuschalten.';

  @override
  String get skapiScriptGrayscaleParamDurationLabel => 'duration';

  @override
  String get skapiScriptGrayscaleParamDurationHint =>
      '0 bedeutet nur umschalten. >0 kehrt nach den angegebenen Sekunden automatisch zu Farbe zurück. Ideal für visuelle Pausen.';

  @override
  String get skapiScriptFindMouseShakeTitle => 'Maus finden';

  @override
  String get skapiScriptFindMouseShakeSummaryWhat =>
      'Wackelt mit dem Cursor in einem kleinen Kreis, um den Blick auf seine Position zu lenken. Der Cursor kehrt zum Ausgangspunkt zurück, wenn die Animation endet.';

  @override
  String get skapiScriptFindMouseShakeSummaryHow =>
      'Liest die aktuelle Cursorposition mit GetCursorPos und durchläuft dann SetCursorPos in einem Kreis mit dem konfigurierten Radius. Nützlich bei Mehrmonitor- und 4K-Setups.';

  @override
  String get skapiScriptFindMouseShakeNote =>
      'Tier 2: SetCursorPos kann von Bedienungshilfen blockiert werden, und das Verhalten variiert in Remotedesktop-Sitzungen.';

  @override
  String get skapiScriptFindMouseShakeParamRadiusLabel => 'radius';

  @override
  String get skapiScriptFindMouseShakeParamRadiusHint =>
      'Pixel, die der Cursor während der Schleife von seinem Ursprung zurücklegt. Größer fällt mehr auf.';

  @override
  String get skapiScriptFindMouseShakeParamLoopsLabel => 'loops';

  @override
  String get skapiScriptFindMouseShakeParamLoopsHint =>
      'Wie viele volle Kreise gezeichnet werden, bevor er zur Ruhe kommt.';

  @override
  String get skapiGroupProgramsTitle => 'Steuerung bestimmter Programme';

  @override
  String get skapiGroupProgramsDesc =>
      'Gezielte Skripte für bestimmte Apps und Browser: geordnetes Speichern+Schließen, Beenden mehrerer Instanzen, browserweite Aufräumaktion. Praktisch, wenn ein SmartKraft-Gerät einen bestimmten Arbeitsablauf herunterfahren möchte, ohne den ganzen Desktop zu sprengen.';

  @override
  String get skapiGroupProgramsFoot =>
      'Typischer Einsatz: vor dem Ruhezustand alle Editoren speichern und schließen, am Tagesende jeden Browser schließen, gezieltes Aufräumen einer Prozessfamilie.';

  @override
  String get skapiScriptCloseWithSaveTitle => 'App speichern & schließen';

  @override
  String get skapiScriptCloseWithSaveSummaryWhat =>
      'Sendet Strg+S an eine Ziel-App, um deren eigenes Speichern auszulösen, wartet und schließt dann das Fenster geordnet.';

  @override
  String get skapiScriptCloseWithSaveSummaryHow =>
      'Fokussiert jede laufende Instanz, sendet Strg+S über SendKeys, wartet die konfigurierte Pause und sendet dann WM_CLOSE, damit die App bestätigen oder das Speichern abschließen kann.';

  @override
  String get skapiScriptCloseWithSaveNote =>
      'Tier 2: setzt voraus, dass die App Strg+S als „speichern“ interpretiert. Manche Chat-/Web-Apps behandeln es anders. Teste es mit den Apps, die du tatsächlich anvisierst.';

  @override
  String get skapiScriptCloseWithSaveParamProcessLabel => 'processName';

  @override
  String get skapiScriptCloseWithSaveParamProcessHint =>
      'Prozessname ohne .exe (winword, excel, code, photoshop). Alle laufenden Instanzen werden gespeichert und geschlossen.';

  @override
  String get skapiScriptCloseWithSaveParamWaitLabel => 'wait';

  @override
  String get skapiScriptCloseWithSaveParamWaitHint =>
      'Sekunden, die zwischen Strg+S und dem Schließen-Signal gewartet wird, damit die App das Speichern abschließt.';

  @override
  String get skapiScriptCloseAllInstancesTitle => 'Alle Instanzen schließen';

  @override
  String get skapiScriptCloseAllInstancesSummaryWhat =>
      'Sendet jedem sichtbaren Fenster eines Prozesses ein geordnetes Schließen. Jede Instanz kann ihren eigenen Speicherdialog anzeigen.';

  @override
  String get skapiScriptCloseAllInstancesSummaryHow =>
      'Durchläuft die passenden Prozesse über Get-Process und sendet WM_CLOSE an das Hauptfenster jedes Prozesses. Kein erzwungenes Beenden als Rückfall.';

  @override
  String get skapiScriptCloseAllInstancesParamProcessLabel => 'processName';

  @override
  String get skapiScriptCloseAllInstancesParamProcessHint =>
      'Prozessname ohne .exe. Passt auf alle Instanzen.';

  @override
  String get skapiScriptBrowserCloseAllTitle => 'Alle Browser schließen';

  @override
  String get skapiScriptBrowserCloseAllSummaryWhat =>
      'Schließt jeden laufenden gängigen Browser (Chrome, Edge, Firefox, Brave, Vivaldi, Opera) geordnet.';

  @override
  String get skapiScriptBrowserCloseAllSummaryHow =>
      'Durchläuft die bekannten Browser-Prozessnamen und sendet WM_CLOSE an jedes Hauptfenster. Moderne Browser bewahren die Sitzung, wenn „Tabs beim nächsten Start wiederherstellen“ aktiviert ist.';

  @override
  String get skapiScriptBrowserCloseAllNote =>
      'Erzwungenes Beenden wird nicht verwendet. Um auch die Sitzung zu löschen, verwende stattdessen kill-app pro Browser.';

  @override
  String get skapiTierBadgeExperimental => 'Experimentell';

  @override
  String get skapiTierBadgeExperimentalTooltip =>
      'Dieses Skript hängt von einer Windows-API ab, die über Rechner hinweg nicht zuverlässig sein kann. Teste es, bevor du dich darauf verlässt.';

  @override
  String get skapiTierBadgeBlocked => 'Demnächst';

  @override
  String get skapiTierBadgeBlockedTooltip =>
      'Dieses Skript gehört zur geplanten Bibliothek, ist aber noch nicht implementiert.';

  @override
  String get skapiGroupSaveWorkTitle => 'Arbeit speichern';

  @override
  String get skapiGroupSaveWorkDesc =>
      'Skripte in dieser Gruppe speichern deine offene Arbeit vor einer Pause oder einem unerwarteten Herunterfahren auf der Festplatte. Wenn dein SmartKraft-Gerät eine Pause auslöst, speichert das gewählte Skript automatisch deine Datei in Word, Excel, VS Code oder einem anderen Editor, damit deine Arbeit auch dann sicher bleibt, wenn dein Computer in den Ruhezustand geht, herunterfährt oder einen anderen Befehl ausführt.';

  @override
  String get skapiGroupSaveWorkFoot =>
      'Typischer Einsatz: automatisches Speichern zu Beginn einer Fokuspause, Dokumentsicherung bei Warnung wegen schwachem Akku oder ein „alles speichern“-Auslöser per Knopfdruck.';

  @override
  String get skapiScriptSaveActiveWindowTitle => 'Aktives Fenster speichern';

  @override
  String get skapiScriptSaveActiveWindowSummaryWhat =>
      'Sendet ein virtuelles Strg+S an das Windows-Fenster, das gerade den Fokus hat, und löst so das eigene „Speichern“-Verhalten dieser Anwendung aus.';

  @override
  String get skapiScriptSaveActiveWindowSummaryHow =>
      'Zuerst greift es das Handle des aktiven Fensters ab und protokolliert dessen Titel. Dann sendet es Strg+S über SendKeys. Word speichert in seinen aktuellen Pfad, VS Code schreibt die Datei. Erscheint ein „Speichern unter“-Dialog, wartet es, bis der Benutzer manuell bestätigt.';

  @override
  String get skapiScriptSaveActiveWindowParamTimeoutLabel => 'timeout';

  @override
  String get skapiScriptSaveActiveWindowParamTimeoutHint =>
      'Sekunden, die nach dem Tastendruck gewartet wird, damit die App Zeit hat, die Datei zu schreiben.';

  @override
  String get skapiScriptSaveActiveWindowParamVerboseLabel => 'verbose';

  @override
  String get skapiScriptSaveAllOpenTitle => 'Alle offenen Dokumente speichern';

  @override
  String get skapiScriptSaveAllOpenSummaryWhat =>
      'Durchläuft eine Whitelist laufender Editoren und weist jeden an, seine offenen Dokumente zu speichern.';

  @override
  String get skapiScriptSaveAllOpenSummaryHow =>
      'Für jeden gefundenen Whitelist-Prozess fokussiert es das Hauptfenster, sendet Strg+S und wartet dann das konfigurierte Timeout pro App ab, bevor es weitergeht. Nicht laufende Apps werden stillschweigend übersprungen, sofern der Verbose-Modus nicht aktiv ist.';

  @override
  String get skapiScriptSaveAllOpenNote =>
      'Die Whitelist umfasst standardmäßig Word, Excel, PowerPoint und VS Code. Bearbeite den Parameter apps, um eigene hinzuzufügen.';

  @override
  String get skapiScriptSaveAllOpenParamAppsLabel => 'apps';

  @override
  String get skapiScriptSaveAllOpenParamAppsHint =>
      'Prozessnamen (ohne .exe), an die das Speichern gesendet wird. Die Reihenfolge zählt: frühere Einträge werden zuerst verarbeitet.';

  @override
  String get skapiScriptSaveAllOpenParamTimeoutLabel => 'timeoutPerApp';

  @override
  String get skapiScriptSaveAllOpenParamVerboseLabel => 'verbose';

  @override
  String get skapiScriptAutosaveTriggerTitle => 'Auto-Speichern auslösen';

  @override
  String get skapiScriptAutosaveTriggerSummaryWhat =>
      'Sendet in einem Durchgang einen Windows-Speicherbefehl an jedes sichtbare Top-Level-Fenster.';

  @override
  String get skapiScriptAutosaveTriggerSummaryHow =>
      'Zählt sichtbare Fenster auf und sendet jedem ein WM_COMMAND mit der Standard-Speicher-ID. Apps, die auf diese Nachricht hören, reagieren, als hättest du im Menü Datei auf Speichern geklickt. Schneller als ein Strg+S pro Fenster, aber einige Apps ignorieren den Broadcast.';

  @override
  String get skapiScriptAutosaveTriggerNote =>
      'Verwende dies, wenn du jeden Editor auf einmal leeren möchtest und es dir nichts ausmacht, dass eine kleine Zahl von Apps nicht reagiert. Kombiniere es für strengere Abdeckung mit save-all-open.';

  @override
  String get skapiScriptAutosaveTriggerParamDelayLabel => 'delay';

  @override
  String get skapiScriptAutosaveTriggerParamDelayHint =>
      'Sekunden, die vor dem Broadcast gewartet wird, nützlich, wenn die Pausenbenachrichtigung des Geräts zuerst erscheinen soll.';

  @override
  String get skapiScriptAutosaveTriggerParamVerboseLabel => 'verbose';

  @override
  String get skapiScriptDetailSummaryWhatLabel => 'Was es tut:';

  @override
  String get skapiScriptDetailSummaryHowLabel => 'So funktioniert es:';

  @override
  String get skapiScriptDetailOriginalSectionTitle => 'Originalskript';

  @override
  String get skapiScriptDetailOriginalSectionSub =>
      'schreibgeschützt · Englisch';

  @override
  String get skapiScriptDetailEditingSectionTitle => 'Bearbeitungen';

  @override
  String get skapiScriptDetailEditingNotYet => 'Noch keine Bearbeitungen';

  @override
  String get skapiScriptDetailEditingNotYetSub =>
      'Erstelle eine Kopie auf diesem Gerät, ohne das Original zu ändern.';

  @override
  String get skapiScriptDetailEditingModified => 'Bearbeitet';

  @override
  String skapiScriptDetailEditingModifiedSub(String date) {
    return 'Zuletzt geändert $date.';
  }

  @override
  String get skapiScriptDetailEditingOutdated => 'Bibliothek aktualisiert';

  @override
  String get skapiScriptDetailEditingOutdatedSub =>
      'Das Original wurde durch ein App-Update geändert. Vergleichen oder zurücksetzen.';

  @override
  String get skapiScriptDetailParamWarnTitle =>
      'Parameter vor dem Ausführen prüfen';

  @override
  String get skapiScriptDetailParamWarnHint =>
      'Um diese Werte zu ändern, verwende „Bearbeiten“. Parameter sind im param()-Block des Skripts definiert.';

  @override
  String get skapiScriptDetailNotesTitle => 'Hinweise';

  @override
  String get skapiScriptDetailButtonRun => 'Jetzt ausführen';

  @override
  String get skapiScriptDetailButtonBindAction => 'An Aktion binden';

  @override
  String get skapiScriptDetailButtonEdit => 'Bearbeiten';

  @override
  String get skapiScriptDetailButtonView => 'Ansehen';

  @override
  String get skapiScriptDetailButtonReset => 'Zurücksetzen';

  @override
  String get skapiScriptDetailButtonCompare => 'Vergleichen';

  @override
  String get skapiScriptCopyButton => 'Kopieren';

  @override
  String get skapiScriptCopyButtonDone => 'Kopiert';

  @override
  String get skapiScriptSelectButton => 'Auswählen';

  @override
  String get skapiEditorTitle => 'Bearbeiten';

  @override
  String skapiEditorHint(String scriptId) {
    return '$scriptId · Du bearbeitest eine Kopie auf diesem Gerät. Die ursprüngliche Bibliotheksversion bleibt unverändert. „Zurücksetzen“ stellt immer das Original wieder her.';
  }

  @override
  String get skapiEditorStatusBarTitle => 'POWERSHELL · UTF-8';

  @override
  String get skapiEditorStatusModified => '● Geändert';

  @override
  String get skapiEditorStatusUnmodified => 'Unverändert';

  @override
  String skapiEditorFootCursor(int line, int column) {
    return 'Zeile $line · Spalte $column';
  }

  @override
  String get skapiEditorFootSaveLabel => 'Speichern';

  @override
  String skapiEditorDiffLineCount(int count) {
    return '$count Zeile geändert';
  }

  @override
  String skapiEditorDiffLinesCount(int count) {
    return '$count Zeilen geändert';
  }

  @override
  String get skapiEditorDiffCompareLink => 'Mit Original vergleichen';

  @override
  String get skapiEditorButtonReset => 'Zurücksetzen';

  @override
  String get skapiEditorButtonSave => 'Speichern';

  @override
  String get skapiEditorAfterSaveNote =>
      'Nach dem Speichern führt „Jetzt ausführen“ die bearbeitete Version aus.';

  @override
  String get skapiLinuxDistroHeading => 'Wähle deine Distributionsfamilie';

  @override
  String get skapiLinuxDistroSubtitle =>
      'Linux-Skripte unterscheiden sich zwischen Debian-basierten (apt, .deb) und Arch-basierten (pacman) Familien. Wähle die, die zu deinem Rechner passt.';

  @override
  String get skapiLinuxDistroDebianLabel => 'Debian-basiert';

  @override
  String get skapiLinuxDistroDebianSub =>
      'Debian, Ubuntu, Mint, Pop!_OS, Elementary, Kali, MX, Zorin';

  @override
  String get skapiLinuxDistroArchLabel => 'Arch-basiert';

  @override
  String get skapiLinuxDistroArchSub =>
      'Arch, Manjaro, EndeavourOS, Garuda (kommt später)';

  @override
  String get skapiNewActionNoDevicesTitle => 'Koppele zuerst ein Gerät';

  @override
  String get skapiNewActionNoDevicesBody =>
      'Das Erstellen einer geräteinternen Aktion benötigt mindestens ein gekoppeltes SmartKraft-Gerät (vorerst BF).';

  @override
  String get skapiNewActionNoDevicesCta => 'Geräte öffnen';

  @override
  String get skapiNewActionPickDeviceTitle => 'Ein Gerät wählen';

  @override
  String get skapiNewActionPickDeviceSubtitle =>
      'Auf welchem Gerät soll diese Aktion liegen?';

  @override
  String get skapiUserNewTitle => 'Neues Skript';

  @override
  String get skapiUserEditTitle => 'Skript bearbeiten';

  @override
  String get skapiUserTitleLabel => 'Titel';

  @override
  String get skapiUserTitleHint => 'z. B. Morgenroutine';

  @override
  String get skapiUserDescLabel => 'Beschreibung';

  @override
  String get skapiUserDescHint => 'Was macht dieses Skript?';

  @override
  String get skapiUserPlatformLabel => 'Plattform';

  @override
  String get skapiUserCodeLabel => 'Code';

  @override
  String get skapiUserCodeHint => '# Dein PowerShell-Code hier';

  @override
  String get skapiUserSaveCta => 'Speichern';

  @override
  String get skapiUserValidationEmpty =>
      'Titel und Code dürfen nicht leer sein.';

  @override
  String get skapiUserSavedSnack => 'Skript gespeichert';

  @override
  String get skapiUserSectionHeading => 'Meine Skripte';

  @override
  String skapiUserSectionSub(int count) {
    return '$count Skripte';
  }

  @override
  String get skapiUserEmptyHint =>
      'Noch keine eigenen Skripte. Erstelle eins mit der Schaltfläche „Neue Aktion“ oben rechts.';

  @override
  String get skapiUserDetailCodeHeading => 'Code';

  @override
  String get skapiUserEditCta => 'Bearbeiten';

  @override
  String get skapiUserDeleteConfirmTitle => 'Skript löschen?';

  @override
  String skapiUserDeleteConfirmBody(String name) {
    return '$name wird endgültig gelöscht.';
  }

  @override
  String get skapiUserDeletedSnack => 'Skript gelöscht';

  @override
  String get skapiUserRunCta => 'Ausführen';

  @override
  String get skapiUserRunUnsupported =>
      'Skripte ausführen geht nur auf dem Desktop.';

  @override
  String get skapiUserRunOutputTitle => 'Ausführungsausgabe';

  @override
  String skapiUserRunDone(int code) {
    return 'Fertig (Exit $code)';
  }

  @override
  String get skapiLocalScriptsSubheading => 'Lokale Skripte';

  @override
  String get skapiOnDeviceApiSubheading => 'Geräteinterne API';

  @override
  String get skapiOnDeviceApiLoadError =>
      'Endpunkte konnten nicht gelesen werden';

  @override
  String get skapiOnDeviceApiRowHint =>
      'Tippe auf eine Zeile, um den Editor zu öffnen';

  @override
  String get commonLoading => 'Wird geladen...';

  @override
  String get skapiApiTemplateSectionHeader => 'Vorlagen';

  @override
  String skapiApiTemplateSectionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Vorlagen',
      one: '1 Vorlage',
    );
    return '$_temp0';
  }

  @override
  String get skapiApiTemplateUploadCta => 'Auf Gerät hochladen';

  @override
  String get skapiApiTemplateUploadHint =>
      'Beim Hochladen wird diese Vorlage in einen der 5 USER-API-Slots des Geräts geschrieben. Das Gerät löst sie über seinen eigenen Auslöser aus (BF: Countdown-Ende).';

  @override
  String get skapiApiTemplatePreviewTitle => 'Endpunkt-Vorschau';

  @override
  String get skapiApiTemplatePreviewType => 'Typ';

  @override
  String get skapiApiTemplatePreviewMethod => 'Methode';

  @override
  String get skapiApiTemplatePreviewUrl => 'URL';

  @override
  String get skapiApiTemplatePreviewAuth => 'Auth';

  @override
  String get skapiApiTemplatePreviewHeader => 'Header';

  @override
  String get skapiApiTemplatePreviewContentType => 'Content-Type';

  @override
  String get skapiApiTemplatePreviewPayload => 'Payload';

  @override
  String get skapiApiTemplatePreviewDelay => 'Verzögerung';

  @override
  String get skapiOtherCategoryHeading => 'Eine Gerätekategorie wählen';

  @override
  String get skapiOtherCategorySubtitle =>
      'Vorlagen werden auf das gekoppelte Gerät hochgeladen und über dessen eigenen Auslöser ausgelöst (kein Laptop beteiligt).';

  @override
  String get skapiOtherSyndimmSub => 'SmartKraft-Smart-Dimmer';

  @override
  String get skapiOtherLebensspurSub => 'SmartKraft-Aktivitätstracker';

  @override
  String get skapiOtherBlockingfocusSub => 'SmartKraft-Fokustimer';

  @override
  String get skapiOtherIotSub =>
      'IoT-Webhooks von Drittanbietern (IFTTT, Home Assistant, generisches REST)';

  @override
  String get skapiOtherServerSub =>
      'Selbst gehostete HTTP-Empfänger (n8n, Node-RED, eigene)';

  @override
  String get skapiCategoryComingSoon => 'Vorlagen kommen bald';

  @override
  String get skapiScriptLockSummaryHowLxDebian =>
      'Ruft loginctl lock-session für die aktuelle XDG_SESSION_ID auf; fällt auf xdg-screensaver lock zurück, wenn loginctl nicht verfügbar ist.';

  @override
  String get skapiScriptHibernateSummaryHowLxDebian =>
      'Ruft systemctl hibernate auf. Eine optionale Verzögerung schläft die angeforderten Sekunden, bevor in den Ruhezustand gewechselt wird.';

  @override
  String get skapiScriptHibernateNoteLxDebian =>
      'Der Tiefschlaf muss konfiguriert sein (Swap >= RAM und der Kernel-Parameter resume=). Auf Systemen, wo das nicht der Fall ist, weicht systemd-logind auf den Ruhezustand aus.';

  @override
  String get skapiScriptSleepSummaryHowLxDebian =>
      'Ruft systemctl suspend auf. Der Kernel kann verzögern, wenn ein Vordergrund-Inhibitor Leerlaufübergänge blockiert.';

  @override
  String get skapiScriptShutdownSummaryHowLxDebian =>
      'Plant ein geordnetes Ausschalten über /sbin/shutdown -h +N (Minuten). Fällt nach der angeforderten Verzögerung auf systemctl poweroff zurück, wenn shutdown fehlt.';

  @override
  String get skapiScriptShutdownNoteLxDebian =>
      '/sbin/shutdown nimmt nur Minuten; Werte unter 60 werden auf 1 Minute aufgerundet. Andere angemeldete Benutzer sehen während des Countdowns eine wall-Nachricht.';

  @override
  String get skapiScriptShutdownParamForceHintLxDebian =>
      'Beendet die Benutzersitzung vor dem Ausschalten, sodass die 90-Sekunden-SIGTERM-Schonfrist übersprungen wird.';

  @override
  String get skapiScriptBrightnessSummaryHowLxDebian =>
      'Stellt die Hintergrundbeleuchtung des internen Displays über brightnessctl set N% (bevorzugt) oder light -S N als Rückfall ein. Beide schreiben nach /sys/class/backlight.';

  @override
  String get skapiScriptBrightnessNoteLxDebian =>
      'brightnessctl kommt ohne sudo aus, wenn der Benutzer in der Gruppe video ist, was nach der Installation auf den meisten Debian-Setups der Standard ist. Externe Monitore über DDC benötigen ddcutil und werden hier nicht behandelt.';

  @override
  String get skapiScriptMuteToggleSummaryHowLxDebian =>
      'Schaltet die Stummschaltung des Master-Sinks über wpctl (PipeWire auf Debian 12+) um oder setzt sie, mit einem pactl-Rückfall für PulseAudio-Setups.';

  @override
  String get skapiScriptVolumeSetSummaryHowLxDebian =>
      'Stellt die Master-Sink-Lautstärke auf einen Wert von 0-100 über wpctl set-volume (PipeWire) oder pactl set-sink-volume (PulseAudio) ein.';

  @override
  String get skapiScriptVolumeSetNoteLxDebian =>
      'PipeWire und PulseAudio stellen beide App-spezifische Lautstärke nativ bereit, daher ist dieses Skript unter Linux Tier 1. Ausgabe über 100 % wird zur Gleichheit mit anderen Plattformen begrenzt.';

  @override
  String get skapiScriptMediaKeySummaryHowLxDebian =>
      'Sendet eine Medientasten-Aktion über playerctl, das per MPRIS mit der App spricht, die gerade die Sitzung besitzt (Spotify, Firefox, VLC, mpv, Rhythmbox).';

  @override
  String get skapiScriptMediaKeyNoteLxDebian =>
      'Wenn keine MPRIS-fähige Medien-App läuft, ist der Befehl wirkungslos. Installiere die MPRIS-Unterstützung der App, falls ein bekannter Player nicht reagiert.';

  @override
  String get skapiScriptMinimizeWindowSummaryHowLxDebian =>
      'Ein leerer processName minimiert das fokussierte Fenster über xdotool. Andernfalls wird das erste Fenster gewählt, dessen WM_CLASS passt, und minimiert.';

  @override
  String get skapiScriptMinimizeWindowNoteLxDebian =>
      'Nur X11. Der WM_CLASS-Abgleich beachtet Groß-/Kleinschreibung und hängt davon ab, wie die App sich deklariert hat; prüfe xprop WM_CLASS im Zweifel.';

  @override
  String get skapiScriptMinimizeWindowParamProcessHintLxDebian =>
      'WM_CLASS-Instanzname (zum Beispiel: firefox, code, gnome-terminal-server). Leer zielt auf das aktive Fenster.';

  @override
  String get skapiScriptCloseWindowSummaryHowLxDebian =>
      'Sendet WM_DELETE_WINDOW über wmctrl -x -c (passt auf WM_CLASS) mit einem Titel-Rückfall. Entspricht einem Klick auf das X; die App kann ihren eigenen Speicherdialog anzeigen.';

  @override
  String get skapiScriptCloseWindowNoteLxDebian =>
      'Nur X11. Für Wayland bevorzuge kill-app, das Signale statt des Fensterprotokolls verwendet.';

  @override
  String get skapiScriptCloseWindowParamProcessHintLxDebian =>
      'WM_CLASS-Instanzname; leer schließt das fokussierte Fenster. Als Rückfall wird ein Titel-Teilstring-Abgleich verwendet.';

  @override
  String get skapiScriptKillAppSummaryHowLxDebian =>
      'pkill -TERM -x nach exaktem comm-Namen, wartet das angeforderte Timeout ab, dann pkill -KILL für alles noch Lebende. Optionales preKillSave fokussiert das Fenster und sendet zuerst Strg+S (nur X11).';

  @override
  String get skapiScriptKillAppNoteLxDebian =>
      'Linux-comm-Namen sind vom Kernel auf 15 Zeichen begrenzt. Verwende exakte Kurznamen: firefox (nicht firefox-esr-bin), code, soffice.bin.';

  @override
  String get skapiScriptKillAppParamProcessHintLxDebian =>
      'Exakter comm-Name (15-Zeichen-Kernel-Limit). Verwende pgrep -l, um den sichtbaren Namen zu prüfen.';

  @override
  String get skapiScriptKillAppParamPreKillSaveHintLxDebian =>
      'Sendet vor SIGTERM Strg+S an das Fenster der App. Benötigt xdotool und X11; unter Wayland ignoriert.';

  @override
  String get skapiScriptLaunchAppSummaryHowLxDebian =>
      'Intelligente Verteilung: .desktop -> gtk-launch, echter Dateipfad -> exec, alles andere -> xdg-open, schließlich PATH-Suche. Der Kindprozess wird über setsid abgekoppelt, damit SKAPP nicht blockiert wird.';

  @override
  String get skapiScriptLaunchAppNoteLxDebian =>
      'args wird an Leerzeichen getrennt. Argumente mit Anführungszeichen werden nicht unterstützt; verwende für komplexe Befehlszeilen ein Wrapper-Skript.';

  @override
  String get skapiScriptLaunchAppParamPathHintLxDebian =>
      'Binärname im PATH, absoluter Pfad, .desktop-Datei, URL oder Dateipfad. xdg-open behandelt MIME-Typen.';

  @override
  String get skapiScriptDialogSummaryHowLxDebian =>
      'Öffnet einen modalen Dialog über zenity (GTK) mit einem kdialog-Rückfall (KDE). Schreibt eines von ok / cancel / yes / no / timeout nach stdout.';

  @override
  String get skapiScriptDialogNoteLxDebian =>
      'Installation mit: sudo apt install zenity. KDE-Plasma-Nutzer haben möglicherweise stattdessen kdialog. Ohne eines von beiden beendet sich das Skript mit Code 2.';

  @override
  String get skapiScriptToastSummaryHowLxDebian =>
      'Sendet eine Desktop-Benachrichtigung über notify-send (libnotify). Tier 1, weil libnotify-bin auf jedem modernen Debian-Desktop vorinstalliert ist.';

  @override
  String get skapiScriptToastNoteLxDebian =>
      'icon akzeptiert Namen aus dem Freedesktop-Icon-Theme (dialog-information, dialog-warning, dialog-error). duration in Sekunden; 0 hält den Toast bis zum Schließen.';

  @override
  String get skapiScriptToastParamIconLabelLxDebian => 'Icon';

  @override
  String get skapiScriptToastParamIconHintLxDebian =>
      'Freedesktop-Icon-Name, zum Beispiel: dialog-information, dialog-warning, dialog-error.';

  @override
  String get skapiScriptToastParamDurationLabelLxDebian => 'Dauer';

  @override
  String get skapiScriptToastParamDurationHintLxDebian =>
      'Automatisch nach so vielen Sekunden ausblenden. 0 bedeutet, der Toast bleibt, bis der Benutzer ihn schließt.';

  @override
  String get skapiScriptShowDesktopSummaryHowLxDebian =>
      'Liest den EWMH-Show-Desktop-Status über wmctrl -m und schaltet ihn dann mit wmctrl -k um. Spiegelt die Win+D-Semantik unter X11.';

  @override
  String get skapiScriptShowDesktopNoteLxDebian =>
      'Nur X11. Wayland-Entsprechungen sind compositor-spezifisch (Sway, Hyprland, GNOME-Shell-Erweiterungen).';

  @override
  String get skapiScriptFadeScreenSummaryHowLxDebian =>
      'Blendet die Hintergrundbeleuchtung des internen Displays über die angeforderte Dauer linear vom aktuellen zum Zielwert über, via brightnessctl in 10-Schritte-pro-Sekunde-Schritten.';

  @override
  String get skapiScriptFadeScreenNoteLxDebian =>
      'Nur interne Panels. Externe Monitore über DDC benötigen ddcutil und werden hier nicht behandelt. Tier 2, weil das Lesen der aktuellen Hintergrundbeleuchtung von der Sichtbarkeit von /sys/class/backlight abhängt.';

  @override
  String get skapiScriptGrayscaleSummaryHowLxDebian =>
      'Schaltet den Farbsättigungsschlüssel der GNOME-Bildschirmlupe (0.0 Graustufen, 1.0 Farbe) über gsettings um, keine Erweiterung nötig.';

  @override
  String get skapiScriptGrayscaleNoteLxDebian =>
      'Nur GNOME / Unity. KDE Plasma und XFCE haben keinen entsprechenden Systemweg; auf diesen Desktops beendet sich das Skript mit Code 3 statt eines stillen No-op.';

  @override
  String get skapiScriptFindMouseShakeSummaryHowLxDebian =>
      'Liest die Cursorposition über xdotool getmouselocation und zeichnet dann für die angeforderte Schleifenzahl einen Kreis darum, mit per awk berechneten cos/sin-Koordinaten.';

  @override
  String get skapiScriptFindMouseShakeNoteLxDebian =>
      'Nur X11. Wayland blockiert synthetische Zeigerbewegung auf Protokollebene (Sicherheitsgrenze), daher beendet sich das Skript mit Code 3.';

  @override
  String get skapiScriptCloseWithSaveSummaryHowLxDebian =>
      'Für jedes sichtbare Fenster, das auf WM_CLASS passt: aktivieren, Strg+S, warten, dann WM_DELETE_WINDOW über wmctrl senden. Nur X11.';

  @override
  String get skapiScriptCloseWithSaveNoteLxDebian =>
      'Tier 2: Die Strg+S-Tasteninjektion hängt von Locale und Fokus ab; nur echte Speichersemantik verhält sich vorhersehbar. Chat- oder Web-Apps belegen Strg+S möglicherweise anders.';

  @override
  String get skapiScriptCloseWithSaveParamProcessHintLxDebian =>
      'WM_CLASS-Instanzname (siehe xprop WM_CLASS). Erforderlich.';

  @override
  String get skapiScriptCloseAllInstancesSummaryHowLxDebian =>
      'Sendet SIGTERM an jeden laufenden Prozess, der auf den exakten comm-Namen passt. Jede App handhabt ihre eigene Beendigungssequenz (und kann ihren eigenen Speicherdialog anzeigen).';

  @override
  String get skapiScriptCloseAllInstancesParamProcessHintLxDebian =>
      'Exakter comm-Name, wie von pgrep -l angezeigt. Erforderlich.';

  @override
  String get skapiScriptBrowserCloseAllSummaryHowLxDebian =>
      'Durchläuft eine Liste von Debian-Browser-Binärdateien (firefox, firefox-esr, chromium, google-chrome, brave, vivaldi-bin, opera) und sendet jeder laufenden Instanz SIGTERM.';

  @override
  String get skapiScriptBrowserCloseAllNoteLxDebian =>
      'Browser bewahren die Sitzung, wenn „Tabs beim nächsten Start wiederherstellen“ aktiviert ist, daher ist dies eher ein sanftes „Bildschirm ausschalten“ als ein Datenverlust.';

  @override
  String get skapiScriptSaveActiveWindowSummaryHowLxDebian =>
      'Sendet Strg+S über xdotool key --clearmodifiers an das fokussierte Fenster. Nur X11.';

  @override
  String get skapiScriptSaveActiveWindowNoteLxDebian =>
      'Wayland blockiert synthetische Tasteninjektion auf Protokollebene. Verwende den autosave-trigger-Rückfall oder verlasse dich auf das eigene Auto-Speichern der App.';

  @override
  String get skapiScriptSaveAllOpenSummaryHowLxDebian =>
      'Durchläuft die apps-Liste, findet die sichtbaren Fenster jeder App, aktiviert sie der Reihe nach und sendet zwischen den Wartezeiten Strg+S.';

  @override
  String get skapiScriptSaveAllOpenNoteLxDebian =>
      'Die Standard-App-Liste deckt LibreOffice (soffice.bin), VS Code (code), gedit und kate ab. Übergib --apps \"name1,name2\" zum Überschreiben. Nur X11.';

  @override
  String get skapiScriptSaveAllOpenParamAppsHintLxDebian =>
      'Kommagetrennte comm-Namen, zum Beispiel: soffice.bin,code,gedit.';

  @override
  String get skapiScriptAutosaveTriggerSummaryHowLxDebian =>
      'Durchläuft jedes sichtbare Top-Level-Fenster über wmctrl -l, aktiviert es der Reihe nach und injiziert Strg+S. X11 fehlt der WIN-WM_COMMAND-Broadcast-Weg, daher ist der Fokus pro Fenster der Rückfall.';

  @override
  String get skapiScriptAutosaveTriggerNoteLxDebian =>
      'Tier 2: hängt davon ab, dass die fokussierte App Strg+S als „speichern“ akzeptiert. Die meisten Editoren tun das; Chat-Apps können es falsch deuten. Nur X11.';

  @override
  String get commonReadFailed => 'konnte nicht gelesen werden';

  @override
  String get commonUnknown => 'unbekannt';

  @override
  String get commonComingSoon => 'demnächst';

  @override
  String get commonDismiss => 'Verwerfen';

  @override
  String bootstrapBannerError(String error) {
    return 'Vom Gerät konnte nicht gelesen werden: $error';
  }

  @override
  String get bootstrapBannerRetry => 'Wiederholen';

  @override
  String get bfApiChainAuthNone => 'Keine';

  @override
  String get bfApiChainAuthBearer => 'Bearer-Token';

  @override
  String get bfApiChainAuthBasic => 'Basic-Auth';

  @override
  String get bfApiChainAuthHeader => 'Eigener Header';

  @override
  String bfApiChainMasterError(String error) {
    return 'Master: $error';
  }

  @override
  String get bfApiChainChainStarted => 'Kette gestartet';

  @override
  String bfApiChainChainError(String error) {
    return 'Fehler: $error';
  }

  @override
  String get bfApiChainSaveDialogTitle => 'Endpunkt speichern?';

  @override
  String bfApiChainSaveDialogBody(String name) {
    return '„$name“ wird auf dem Gerät gespeichert. Dies aktualisiert den Benutzerdatenbereich.';
  }

  @override
  String get bfApiChainSaveDialogConfirm => 'Speichern';

  @override
  String bfApiChainSavedToast(String name) {
    return '„$name“ gespeichert';
  }

  @override
  String bfApiChainSaveFailed(String error) {
    return 'Speichern nicht möglich: $error';
  }

  @override
  String get bfApiChainDeleteDialogTitle => 'Löschen?';

  @override
  String bfApiChainDeleteDialogBody(String name) {
    return 'Der Endpunkt „$name“ wird vom Gerät entfernt. Diese Aktion kann nicht rückgängig gemacht werden.';
  }

  @override
  String get bfApiChainDeleteDialogConfirm => 'Löschen';

  @override
  String bfApiChainDeletedToast(String name) {
    return '„$name“ gelöscht';
  }

  @override
  String bfApiChainDeleteFailed(String error) {
    return 'Löschen nicht möglich: $error';
  }

  @override
  String bfApiChainTestNoReply(String name) {
    return '„$name“ keine Antwort (15 s Timeout)';
  }

  @override
  String bfApiChainTestSuccess(String name, String httpSuffix) {
    return '„$name“ erfolgreich$httpSuffix';
  }

  @override
  String bfApiChainTestFailure(String name, String error, String httpSuffix) {
    return '„$name“ Fehler: $error$httpSuffix';
  }

  @override
  String bfApiChainTestTriggerFailed(String error) {
    return 'Auslösen nicht möglich: $error';
  }

  @override
  String get bfApiChainNewEndpointName => 'Neuer Endpunkt';

  @override
  String get bfApiChainEmptyTitle => 'Noch keine Endpunkte registriert';

  @override
  String get bfApiChainEmptyBody =>
      'Verwende die Karte „Endpunkt hinzufügen“ unten, um einen neuen HTTP-Aufruf zu definieren (z. B. IFTTT-Webhook, deinen eigenen Server, Spotify pausieren).';

  @override
  String get bfApiChainSystemSectionTitle => 'Automatisch (gekoppelte SKAPPs)';

  @override
  String get bfApiChainSystemSectionSubtitle =>
      'Wenn du ein Skript über SKAPI bindest, öffnet sich automatisch ein Slot für jeden Computer. Wenn der Countdown endet, geht ein signierter Webhook an das SKAPP auf diesem Computer.';

  @override
  String get bfApiChainUserSectionTitle => 'Manuell (IoT-Geräte)';

  @override
  String get bfApiChainUserSectionSubtitle =>
      'Füge URLs von Drittanbietern (Shelly, Home Assistant, IFTTT) von Hand hinzu. Wenn der Countdown endet, feuert diese Liste zuerst, der Reihe nach.';

  @override
  String get bfApiChainMasterToggleLabel => 'Auslöser aktiv';

  @override
  String get bfApiChainMasterOnSubtitle =>
      'Master an: Kette feuert bei Geräteauslösern';

  @override
  String get bfApiChainMasterOffSubtitle =>
      'Master aus: kein Endpunkt wird aufgerufen';

  @override
  String get bfApiChainFieldNameLabel => 'Name';

  @override
  String get bfApiChainTypeLabel => 'Typ';

  @override
  String get bfApiChainEventOrApplet => 'Ereignis / Applet';

  @override
  String get bfApiChainMethodLabel => 'Methode';

  @override
  String get bfApiChainDelayLabel => 'Warten danach (0-300 s)';

  @override
  String get bfApiChainDelayUnit => 's';

  @override
  String get bfApiChainAdvancedHide => 'Erweiterte Optionen ausblenden';

  @override
  String get bfApiChainAdvancedShow => 'Erweiterte Optionen';

  @override
  String get bfApiChainAuthLabel => 'Authentifizierung';

  @override
  String bfApiChainCurrentTokenHint(String masked) {
    return 'Aktuelles Token: $masked (unten einen neuen Wert schreiben zum Aktualisieren)';
  }

  @override
  String get bfApiChainNewTokenLabel =>
      'Neues Token (leer lassen, um es zu behalten)';

  @override
  String get bfApiChainContentTypeLabel => 'Content-Type';

  @override
  String get bfApiChainSaveCta => 'Speichern';

  @override
  String get bfApiChainDeleteCta => 'Löschen';

  @override
  String get bfApiChainTestCta => 'Testen';

  @override
  String get bfApiChainAddCardLabel => 'Neuen Endpunkt hinzufügen';

  @override
  String bfApiChainSavedDelaySeconds(int count) {
    return '$count s Wartezeit';
  }

  @override
  String get bfApiChainNotSaved => 'nicht gespeichert';

  @override
  String bfApiChainSystemRowSignedTooltip(String peer, int delay) {
    return 'Peer $peer…  ·  Verzögerung $delay s  ·  signiert (HMAC)';
  }

  @override
  String get bfApiChainTestEndpointTooltip => 'Diesen Endpunkt testen';

  @override
  String get bfLogsBufferEmpty => 'Der Log-Puffer des Geräts ist leer.';

  @override
  String get bfLogsUnsupported =>
      'Das Gerät unterstützt in dieser Firmware keine Logs.';

  @override
  String get deviceLogsNoClockBanner =>
      'Geräteuhr nicht gesetzt; Zeitstempel werden als Sekunden seit dem Start angezeigt.';

  @override
  String get deviceLogsTruncatedHint =>
      '(Ausgabe gekürzt, versuche ein niedrigeres Limit oder einen höheren Schweregrad)';

  @override
  String get bfEventsTimerRunning => 'Countdown gestartet';

  @override
  String get bfEventsTimerPaused => 'Countdown pausiert';

  @override
  String get bfEventsTimerIdle => 'Countdown zurückgesetzt';

  @override
  String get bfEventsTimerCooldown => 'Abkühlphase';

  @override
  String get bfEventsTimerExpired => 'Countdown beendet';

  @override
  String bfEventsFaceChanged(String from, String to) {
    return 'Fläche gewechselt: $from → $to';
  }

  @override
  String bfEventsApiTriggered(String type) {
    return '$type ausgelöst';
  }

  @override
  String get bfEventsApiTriggeredFallback => 'API ausgelöst';

  @override
  String bfEventsBatteryLevel(int percent) {
    return 'Akkustand: %$percent';
  }

  @override
  String get bfEventsDeviceRestarted => 'Gerät neu gestartet';

  @override
  String skapiManifestLoadingRetry(String platform, String scriptId) {
    return 'Manifest $platform/$scriptId wird geladen, versuche es gleich erneut';
  }

  @override
  String get skapiListenerOffMobileTitle =>
      'Dieses Gerät kann keine Desktop-Skripte ausführen';

  @override
  String get skapiListenerOffDesktopTitle => 'SKAPP-HTTP-Listener ist aus';

  @override
  String get skapiListenerOffMobileBody =>
      'Wenn der Countdown endet, laufen Skripte auf Windows / macOS / Linux. SKAPP muss geöffnet und der Listener aktiv sein. Dieses Handy ist nur die Konfigurationsseite; die Ausführung geschieht auf dem Desktop.';

  @override
  String skapiListenerOffDesktopBody(String lastErrorSuffix) {
    return 'BF feuert den Webhook, aber niemand fängt ihn auf, weil der Listener aus ist. Öffne Einstellungen → SKAPP-HTTP-Listener.$lastErrorSuffix';
  }

  @override
  String get skapiSyncBadgeWriting => 'Wird auf BF geschrieben…';

  @override
  String get skapiSyncBadgeWritten => 'Auf BF gespeichert';

  @override
  String get skapiSyncBadgeFailed => 'Schreiben auf BF nicht möglich';

  @override
  String skapiSyncBadgeFirmwareCodeTooltip(String code) {
    return 'Firmware-Code: $code';
  }

  @override
  String get syncErrUnknownCommand =>
      'Alte Firmware auf dem Gerät. Flashe die neue Firmware';

  @override
  String get syncErrNotAuthenticated =>
      'Gerätesitzung nicht autorisiert (erneute Kopplung kann nötig sein)';

  @override
  String get syncErrNotFound => 'Kein Kopplungsdatensatz auf dem Gerät';

  @override
  String get syncErrInternal => '8 SYSTEM-Slots sind womöglich belegt';

  @override
  String get syncErrUnknown => 'unbekannter Fehler';

  @override
  String get syncErrTimeout => 'Gerät hat nicht geantwortet (offline?)';

  @override
  String get syncErrNoBond => 'Keine Kopplung mit diesem Gerät';

  @override
  String get syncErrConnect => 'Verbindung zum Gerät nicht möglich';

  @override
  String get discoveryFilterShowAll => 'Alle Geräte anzeigen';

  @override
  String get discoveryFilterOnlySmartKraft => 'Nur SmartKraft';

  @override
  String discoveryScanningWithCount(int count, String tail) {
    return 'Suche läuft… $count Gerät(e) gefunden$tail';
  }

  @override
  String discoveryFoundCountWithTail(int count, String tail) {
    return '$count Gerät(e) gefunden$tail';
  }

  @override
  String discoveryFilterOff(int visible, int sk, String tail) {
    return 'Filter aus · $visible Gerät(e) angezeigt ($sk SmartKraft$tail)';
  }

  @override
  String discoveryMdnsTail(int count) {
    return ' + $count im Netzwerk';
  }

  @override
  String get discoveryWifiOnlySnack =>
      'Dieses Gerät ist derzeit nur über WiFi sichtbar. Die WiFi-Kopplung ist noch nicht aktiv, drücke kurz die Gerätetaste, um das Kopplungsfenster zu öffnen. Sobald es auch über BLE gesehen wird, wird diese Zeile koppelbar.';

  @override
  String get discoveryBadgePairable => 'Koppelbar';

  @override
  String get discoveryBadgeBonded => 'Mit einem anderen SKAPP gekoppelt';

  @override
  String get pairingTitleConnecting => 'Verbinden';

  @override
  String get pairingTitleReconnecting => 'Erneut verbinden';

  @override
  String get pairingMutualAuthHmacSubtitle => 'HMAC-Challenge-Response';

  @override
  String pairingBleConnectFailed(String error) {
    return 'BLE-Verbindung fehlgeschlagen.\n\nLösung: Drücke kurz die Gerätetaste, um das 60-Sekunden-Kopplungsfenster zu öffnen, und tippe dann auf „Wiederholen“.\n\nDetails: $error';
  }

  @override
  String get pairingGattServiceMissing => 'SKAPP-Dienst nicht gefunden';

  @override
  String get pairingGattCmdRxMissing => 'Charakteristik cmd_rx fehlt';

  @override
  String get pairingGattEventTxMissing => 'Charakteristik event_tx fehlt';

  @override
  String pairingGattDiscoveryFailed(String error) {
    return 'GATT-Erkennung fehlgeschlagen: $error';
  }

  @override
  String pairingKeySendFailed(String error) {
    return 'Schlüssel konnte nicht gesendet werden: $error';
  }

  @override
  String pairingDeviceNoReply(int seconds) {
    return 'Gerät hat nicht geantwortet ($seconds s).';
  }

  @override
  String pairingDeviceRejected(String error) {
    return 'Gerät hat abgelehnt: $error';
  }

  @override
  String get pairingInvalidReplyMissingPub =>
      'Ungültige Geräteantwort (our_pub fehlt).';

  @override
  String pairingHexDecodeFailed(String error) {
    return 'our_pub Hex-Dekodierung fehlgeschlagen: $error';
  }

  @override
  String get pairingRetryButton => 'Wiederholen';

  @override
  String pairingReconnectTransient(String error) {
    return 'Das Gerät konnte nicht erreicht werden; die bestehende Kopplung bleibt erhalten.\n\nStelle sicher, dass das Gerät eingeschaltet und in Reichweite ist, und tippe dann auf „Wiederholen“.\n\nDetails: $error';
  }

  @override
  String get pairingRecoveryTitle => 'Kopplung erneuern';

  @override
  String get pairingRecoveryBody =>
      'Das Gerät erkennt die aktuelle Kopplung nicht. Um eine neue zu starten, drücke die Kopplungstaste des Geräts, um das 60-Sekunden-Fenster zu öffnen, und tippe dann auf Weiter.';

  @override
  String get pairingRecoveryContinue => 'Weiter';

  @override
  String get pairingRecoveryCancelled =>
      'Erneuerung der Kopplung abgebrochen. Die alte Kopplung ist weiterhin gespeichert; tippe auf „Wiederholen“, um später einen erneuten Verbindungsversuch zu starten.';

  @override
  String get pairingRenewBondButton => 'Kopplung erneuern';

  @override
  String wifiPasswordConnectionRejected(String error) {
    return 'Verbindung abgelehnt: $error';
  }

  @override
  String get wifiPasswordTimeout => 'Gerät hat nicht geantwortet (Timeout).';

  @override
  String wifiScanRejected(String error) {
    return 'Gerät hat wifi.scan abgelehnt: $error\n\nDas WiFi-Modul des Geräts ist womöglich nicht gestartet; versuche einen Neustart.';
  }

  @override
  String wifiScanUnexpectedReply(String data) {
    return 'Unerwartete wifi.scan-Antwort: $data';
  }

  @override
  String wifiScanTimeout(String error) {
    return 'Gerät hat nicht geantwortet (Timeout: $error).\n\nGeh näher an das Gerät, drücke kurz seine Taste (um das Advertising auszulösen) und versuche es erneut.';
  }

  @override
  String wifiScanConnectionError(String error) {
    return 'Verbindungsfehler: $error';
  }

  @override
  String get wifiScanHeaderHelp =>
      'Unten sind die WiFi-Netzwerke, die **das Gerät** sehen kann (nicht die Netzwerke des Handys). Wähle das Netzwerk, dem das Gerät beitreten soll; das Passwort wird im nächsten Schritt abgefragt.';

  @override
  String get wifiScanAuthOpen => 'Offen';

  @override
  String get wifiScanAuthEncrypted => 'Verschlüsselt';

  @override
  String get wifiSuccessSyncing => 'Zeit wird synchronisiert…';

  @override
  String get wifiSuccessFetchingInfo => 'Geräteinfo wird abgerufen…';

  @override
  String get wifiSuccessPreparingUi => 'Geräte-UI wird vorbereitet…';

  @override
  String wifiSuccessManifestRejected(String error) {
    return 'device.manifest abgelehnt ($error). Es könnte alte Firmware sein; für BF muss sk_baseline.c geladen sein.';
  }

  @override
  String get wifiSuccessTapToContinue => 'Tippen, um fortzufahren…';

  @override
  String get deviceHomeUnsupportedTitle => 'Nicht unterstütztes Gerät';

  @override
  String deviceHomeUnsupportedBody(String name) {
    return '$name hat in dieser SKAPP-Version keinen Gerätebildschirm. Wenn eine neue Gerätefamilie hinzugefügt wird, erscheint dieser Bildschirm automatisch.';
  }

  @override
  String get lsPairingUnpairTitle => 'Diese APP entkoppeln';

  @override
  String get lsPairingUnpairBody =>
      'Das Gerät vergisst die Bindung dieser APP. Du musst erneut koppeln (3 s Taste + Auswahl unter Geräte).';

  @override
  String get skYakindaBadgeDefault => 'demnächst';

  @override
  String get skapiScriptPulseBrightnessTitle => 'Helligkeit pulsieren';

  @override
  String get skapiScriptPulseBrightnessSummaryWhat =>
      'Moduliert die Helligkeit des internen Displays auf einer sanften Kosinuswelle zwischen 100 % und einer Untergrenze, mehrmals wiederholt. Die ursprüngliche Helligkeit des Benutzers wird am Ende wiederhergestellt.';

  @override
  String get skapiScriptPulseBrightnessSummaryHow =>
      'Liest die aktuelle Helligkeit über WMI und schreibt dann 20-mal pro Sekunde einen Helligkeitswert entlang einer Kosinuskurve. Stellt beim Beenden immer den erfassten Originalwert wieder her.';

  @override
  String get skapiScriptPulseBrightnessNote =>
      'Nur interne Panels (Laptops, Tablets). Externe DDC/CI-Monitore reagieren auf diesen WMI-Weg nicht.';

  @override
  String get skapiScriptPulseBrightnessParamPeriodLabel => 'period';

  @override
  String get skapiScriptPulseBrightnessParamPeriodHint =>
      'Sekunden für einen vollen Zyklus hell -> dunkel -> hell. Etwa 2 wirkt wie ein klarer Puls, ohne zu stören.';

  @override
  String get skapiScriptPulseBrightnessParamLowPercentLabel => 'low %';

  @override
  String get skapiScriptPulseBrightnessParamLowPercentHint =>
      'Dunkles Ende des Pulses, als Prozentsatz der vollen Helligkeit. Niedrigere Zahlen machen den Puls dramatischer.';

  @override
  String get skapiScriptPulseBrightnessParamCyclesLabel => 'cycles';

  @override
  String get skapiScriptPulseBrightnessParamCyclesHint =>
      'Wie viele volle Pulszyklen vor dem Beenden ausgeführt werden.';

  @override
  String get skapiScriptBlurTimedTitle => 'Verschwommene Pause';

  @override
  String get skapiScriptBlurTimedSummaryWhat =>
      'Legt für die konfigurierte Anzahl von Sekunden einen bildschirmfüllenden, stets im Vordergrund liegenden, halbtransparenten Schleier über den Bildschirm. In der Mitte wird ein Countdown angezeigt.';

  @override
  String get skapiScriptBlurTimedSummaryHow =>
      'Öffnet ein randloses WPF-Fenster mit AllowsTransparency und einem einfarbigen Pinsel in der gewählten Deckkraft. Ein Dispatcher-Timer treibt den Countdown an; das Fenster schließt sich selbst, wenn der Timer null erreicht.';

  @override
  String get skapiScriptBlurTimedNote =>
      'Pragmatischer Zwischenschritt: Ein Echtzeit-Weichzeichner (Gauß) über dem Desktop benötigt einen C++/Win2D-Helfer, der später kommt. Der einfarbige Schleier erzeugt in der Zwischenzeit eine ähnliche „Ich kann mich nicht auf den Bildschirm konzentrieren, mach eine Pause“-Wirkung.';

  @override
  String get skapiScriptBlurTimedParamDurationLabel => 'duration';

  @override
  String get skapiScriptBlurTimedParamDurationHint =>
      'Sekunden, die der Schleier oben bleibt, bevor er sich automatisch schließt.';

  @override
  String get skapiScriptBlurTimedParamOpacityLabel => 'opacity';

  @override
  String get skapiScriptBlurTimedParamOpacityHint =>
      'Schleier-Deckkraft 0.0 (unsichtbar) bis 1.0 (deckend). Um 0.55 lässt den Desktop noch genug durchscheinen, um verschleiert statt schwarz zu wirken.';

  @override
  String get skapiScriptBlurTimedParamColorLabel => 'color';

  @override
  String get skapiScriptBlurTimedParamColorHint =>
      'Schleierfarbe als #RRGGBB-Hex. Palettenschwarz #0A0A0A ist der Standard; hellere Cremetöne wirken ruhiger.';

  @override
  String get skapiScriptBlockingFocusTitle => 'Blocking Focus';

  @override
  String get skapiScriptBlockingFocusSummaryWhat =>
      'Zusammengesetzter Fokus-Erzwinger: speichert alle offenen Office- und VS-Code-Dokumente, öffnet dann ein bildschirmfüllendes, stets im Vordergrund liegendes Countdown-Fenster ohne Schließen-Knopf, während der Mauszeiger ununterbrochen kreist. Wenn der Timer null erreicht, wird alles automatisch rückgängig gemacht.';

  @override
  String get skapiScriptBlockingFocusSummaryHow =>
      'Drei Phasen laufen direkt hintereinander: (1) die Speicherphase ruft Office COM und die VS-Code-CLI auf; (2) ein paralleler Runspace führt den Cursor im Kreis, bis ein synchronisiertes Stopp-Flag umschlägt; (3) ein STA-WPF-Fenster zeigt Titel und Countdown. Ein finally-Block stellt den Cursor-Ursprung wieder her und baut beide Runspaces ab.';

  @override
  String get skapiScriptBlockingFocusNote =>
      'Sanfter Modus: Esc und Alt+F4 werden NICHT blockiert. Der Benutzer kann immer über den Task-Manager entkommen. Ein strenger Modus mit globalen Tastatur-Hooks wird ein separates Skript.';

  @override
  String get skapiScriptBlockingFocusParamDurationLabel => 'duration';

  @override
  String get skapiScriptBlockingFocusParamDurationHint =>
      'Sekunden, die die Sperre dauert. Der Countdown läuft bis 00:00 herunter, dann wird alles aufgeräumt.';

  @override
  String get skapiScriptBlockingFocusParamTitleLabel => 'title';

  @override
  String get skapiScriptBlockingFocusParamTitleHint =>
      'Text, der in der Mitte des Vollbildfensters angezeigt wird. Halte ihn kurz – „Blocking Focus“ ist der Standard.';

  @override
  String get skapiScriptBlockingFocusParamShakeRadiusLabel => 'shake radius';

  @override
  String get skapiScriptBlockingFocusParamShakeRadiusHint =>
      'Pixel, die der Cursor während der Schleife von seinem Ursprung zurücklegt. Größere Kreise fordern mehr Aufmerksamkeit.';

  @override
  String get skapiScriptBlockingFocusParamEnableSaveLabel => 'save on start';

  @override
  String get skapiScriptBlockingFocusParamEnableSaveHint =>
      'Führt vor der Sperre die Office- + VS-Code-Speicherphase aus. Aus, wenn es keinen Dokumentstatus zu schützen gibt.';

  @override
  String get trayFirstHideToast =>
      'SKAPP läuft im Hintergrund weiter. Du findest es in der Taskleiste; Rechtsklick zum Beenden.';

  @override
  String devicesOfflineTapHint(String name) {
    return '$name ist offline.';
  }

  @override
  String skapiNewActionDeviceOffline(String name) {
    return '$name ist offline. Bring es online, um eine neue Aktion zu erstellen.';
  }

  @override
  String get bfApiChainRefreshDirtyTitle => 'Nicht gespeicherte Änderungen';

  @override
  String get bfApiChainRefreshDirtyBody =>
      'Beim Aktualisieren wird die neueste Endpunktliste vom Gerät geholt und der noch nicht gespeicherte Entwurf verworfen.';

  @override
  String get bfApiChainRefreshDirtyConfirm => 'Trotzdem aktualisieren';

  @override
  String get skapiApiEditorTitle => 'Geräteinterne API';

  @override
  String get lsCommonReadFailed => 'Lesen fehlgeschlagen';

  @override
  String lsCommonFailedWith(String err) {
    return 'Fehlgeschlagen: $err';
  }

  @override
  String get lsVacationStatusOff => 'Aus';

  @override
  String lsVacationStatusUntil(String date) {
    return 'Bis $date';
  }

  @override
  String get lsVacationDaysValidationError =>
      'Die Tage müssen zwischen 1 und 60 liegen';

  @override
  String lsVacationStartedSnack(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Urlaub gestartet · $days Tage',
      one: 'Urlaub gestartet · 1 Tag',
    );
    return '$_temp0';
  }

  @override
  String get lsVacationCancelledSnack => 'Urlaub abgebrochen';

  @override
  String lsVacationActiveUntilFmt(String date) {
    return 'Aktiv bis $date';
  }

  @override
  String get lsVacationResumeHint =>
      'Der Countdown wird fortgesetzt, wenn der Urlaub endet.';

  @override
  String get lsVacationCancellingButton => 'Wird abgebrochen…';

  @override
  String get lsVacationCancelButton => 'Urlaub abbrechen';

  @override
  String get lsVacationDaysLabel => 'Tage';

  @override
  String get lsVacationDaysHint =>
      'Pausiert den Countdown für diese Anzahl Tage (1 bis 60).';

  @override
  String get lsVacationStartingButton => 'Wird gestartet…';

  @override
  String get lsVacationStartButton => 'Urlaub starten';

  @override
  String get lsCommonSavingButton => 'Wird gespeichert…';

  @override
  String get lsCommonSaveButton => 'Speichern';

  @override
  String lsCommonSaveFailedWith(String err) {
    return 'Speichern fehlgeschlagen: $err';
  }

  @override
  String get lsDurationValueValidationError =>
      'Der Wert muss zwischen 1 und 60 liegen';

  @override
  String get lsDurationAlarmsValidationError =>
      'Die Alarmanzahl muss zwischen 0 und 10 liegen';

  @override
  String get lsDurationConfiguredSnack => 'Timer konfiguriert';

  @override
  String lsDurationUnitMinute(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value Minuten',
      one: '1 Minute',
    );
    return '$_temp0';
  }

  @override
  String lsDurationUnitHour(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value Stunden',
      one: '1 Stunde',
    );
    return '$_temp0';
  }

  @override
  String lsDurationUnitDay(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value Tage',
      one: '1 Tag',
    );
    return '$_temp0';
  }

  @override
  String lsDurationAlarmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Alarme',
      one: '1 Alarm',
    );
    return '$_temp0';
  }

  @override
  String get lsDurationUnitLabel => 'Einheit';

  @override
  String get lsDurationUnitMinutesPlural => 'Minuten';

  @override
  String get lsDurationUnitHoursPlural => 'Stunden';

  @override
  String get lsDurationUnitDaysPlural => 'Tage';

  @override
  String get lsDurationValueLabel => 'Wert';

  @override
  String get lsDurationValueHint => '1 bis 60';

  @override
  String get lsDurationAlarmCountLabel => 'Alarmanzahl';

  @override
  String get lsDurationAlarmCountHint =>
      'Alarme feuern rückwärts vom Ende, jeweils eine Einheit auseinander.';

  @override
  String get lsSmtpStatusNotConfigured => 'Nicht konfiguriert';

  @override
  String get lsSmtpHostRequired => 'Host ist erforderlich';

  @override
  String get lsSmtpPortValidationError =>
      'Der Port muss zwischen 1 und 65535 liegen';

  @override
  String get lsSmtpSenderRequired => 'Absenderadresse ist erforderlich';

  @override
  String get lsSmtpFieldHost => 'Host';

  @override
  String get lsSmtpFieldPort => 'Port';

  @override
  String get lsSmtpFieldSender => 'Absender';

  @override
  String get lsSmtpFieldKey => 'Schlüssel';

  @override
  String lsSmtpSaveHaltedOn(String err) {
    return 'Speichern gestoppt bei $err';
  }

  @override
  String get lsSmtpSavedSnack => 'SMTP gespeichert';

  @override
  String get lsSmtpTestSentSnack => 'Test-Mail gesendet';

  @override
  String lsSmtpTestFailedWith(String err) {
    return 'Test fehlgeschlagen: $err';
  }

  @override
  String get lsSmtpUrlCopiedSnack => 'URL in die Zwischenablage kopiert';

  @override
  String get lsSmtpApiKeyPlaceholder => 'Gmail-App-Passwort / API-Schlüssel';

  @override
  String get lsSmtpServerLabel => 'Server';

  @override
  String get lsSmtpApiKeyLabel => 'API-Schlüssel';

  @override
  String get lsSmtpApiKeyHint =>
      'Leer lassen, um den aktuellen Schlüssel zu behalten.';

  @override
  String get lsSmtpAppPasswordHelpLink =>
      'So erhältst du ein Gmail-App-Passwort';

  @override
  String get lsSmtpSendingButton => 'Wird gesendet…';

  @override
  String get lsSmtpSendTestButton => 'Test senden';

  @override
  String get lsReminderMailRecipientValidation =>
      'Der Empfänger muss wie eine E-Mail-Adresse aussehen';

  @override
  String get lsReminderMailSavedSnack => 'Erinnerung lokal gespeichert';

  @override
  String get lsReminderMailRecipientFirstSnack =>
      'Lege zuerst einen Empfänger fest';

  @override
  String get lsReminderMailTestOkSnack =>
      'SMTP-Test OK, die Zugangsdaten erreichen den Server';

  @override
  String lsReminderMailTestFailedWith(String err) {
    return 'SMTP-Test fehlgeschlagen: $err';
  }

  @override
  String get lsReminderMailRecipientLabel => 'Empfänger-E-Mail';

  @override
  String get lsReminderMailSubjectLabel => 'Betreff';

  @override
  String get lsReminderMailBodyLabel => 'Text';

  @override
  String get lsReminderMailBodyHint => 'Dein Countdown wird bald ausgelöst...';

  @override
  String get lsReminderMailActiveLabel => 'Aktiv';

  @override
  String get lsReminderMailFootnote =>
      'Lokal auf diesem Gerät gespeichert. Der Sendetest prüft nur, ob der SMTP-Server erreichbar ist; das automatische Auslösen bei timer.alarm wartet auf Firmware-Unterstützung.';

  @override
  String get lsResetApiStatusDisabled => 'Deaktiviert';

  @override
  String lsResetApiStatusEnabledPort(int port) {
    return 'Aktiviert · Port $port';
  }

  @override
  String get lsResetApiRegenDialogTitle => 'API-Schlüssel neu erzeugen?';

  @override
  String get lsResetApiRegenDialogBody =>
      'Dies macht den aktuellen Schlüssel ungültig. Jeder Aufrufer, der den vorherigen Schlüssel verwendet, wird abgelehnt, bis du ihn aktualisierst. Fortfahren?';

  @override
  String get lsResetApiRegenConfirm => 'Neu erzeugen';

  @override
  String get lsResetApiKeyRegeneratedSnack => 'Schlüssel neu erzeugt';

  @override
  String get lsResetApiEnabledLabel => 'Aktiviert';

  @override
  String get lsResetApiEnabledHint =>
      'Wenn an, setzt ein HTTP-GET an die Endpunkt-URL mit dem passenden Schlüssel den Countdown zurück.';

  @override
  String get lsResetApiEndpointUrlLabel => 'Endpunkt-URL';

  @override
  String get lsResetApiUrlNotAvailable => '(nicht verfügbar)';

  @override
  String get lsResetApiCopyUrlTooltip => 'URL kopieren';

  @override
  String get lsResetApiKeyLabel => 'API-Schlüssel';

  @override
  String get lsResetApiKeyNotSet => '(nicht gesetzt)';

  @override
  String get lsResetApiExampleLabel => 'Beispiel';

  @override
  String get lsResetApiRegenerateButton => 'Schlüssel neu erzeugen';

  @override
  String get lsAlarmApiUrlValidation =>
      'Die URL muss mit http:// oder https:// beginnen';

  @override
  String get lsAlarmApiHeadersValidation =>
      'Das Feld Headers muss gültiges JSON sein';

  @override
  String get lsAlarmApiSaveDialogTitle => 'Webhook-Endpunkt speichern?';

  @override
  String lsAlarmApiSaveDialogBody(String name, String url) {
    return 'Speichert `$name` auf dem Gerät, gerichtet auf:\n$url';
  }

  @override
  String get lsAlarmApiSavedSnack => 'Webhook gespeichert';

  @override
  String get lsAlarmApiDisabledSnack => 'Webhook deaktiviert';

  @override
  String get lsAlarmApiTestQueuedSnack =>
      'Test eingereiht, beobachte den Upstream-Dienst';

  @override
  String lsAlarmApiTestFailedWith(String err) {
    return 'Test fehlgeschlagen: $err';
  }

  @override
  String get lsAlarmApiRemoveDialogTitle => 'Webhook entfernen?';

  @override
  String lsAlarmApiRemoveDialogBody(String name) {
    return 'Löscht `$name` vom Gerät. Die lokale Konfiguration bleibt erhalten.';
  }

  @override
  String get lsAlarmApiRemoveButton => 'Entfernen';

  @override
  String lsAlarmApiRemoveFailedWith(String err) {
    return 'Entfernen fehlgeschlagen: $err';
  }

  @override
  String get lsAlarmApiConfiguredStatus => 'Konfiguriert';

  @override
  String lsAlarmApiConfiguredHost(String host) {
    return 'Konfiguriert · $host';
  }

  @override
  String get lsAlarmApiUrlLabel => 'URL';

  @override
  String get lsAlarmApiMethodLabel => 'HTTP-Methode';

  @override
  String get lsAlarmApiHeadersLabel => 'Headers (JSON, optional)';

  @override
  String get lsAlarmApiHeadersHint =>
      'JSON-Objekt mit optionalen Headern. Lokal gespeichert; die Firmware wendet sie beim Auslösen an.';

  @override
  String get lsAlarmApiBodyTemplateLabel => 'Body-Vorlage (JSON)';

  @override
  String get lsAlarmApiBodyTemplateHint =>
      'Die Platzhalter device und remaining_sec werden beim Auslösen ersetzt.';

  @override
  String get lsAlarmApiBearerLabel => 'Bearer-Token (optional)';

  @override
  String get lsAlarmApiFootnote =>
      'Der Firmware-Abonnent für das Ereignis timer.alarm steht noch aus. Diese Konfiguration speichert den Endpunkt; sie löst erst beim nächsten Firmware-Update automatisch aus.';

  @override
  String lsRelaySummarySeconds(int seconds) {
    return '$seconds s';
  }

  @override
  String lsRelaySummaryMinutes(int minutes) {
    return '$minutes Min.';
  }

  @override
  String get lsRelayModePulse => 'Puls';

  @override
  String get lsRelayModeSteady => 'dauerhaft';

  @override
  String lsRelaySummaryFmt(int gpio, String duration, String mode) {
    return 'GPIO $gpio · $duration $mode';
  }

  @override
  String get lsRelayGpioValidation => 'GPIO muss zwischen 0 und 30 liegen';

  @override
  String get lsRelayDurationValidation =>
      'Die Dauer muss zwischen 1 und 3600 Sekunden liegen';

  @override
  String get lsRelayPulseValidation =>
      'Der Puls-Halbzyklus muss zwischen 1 und 60 liegen';

  @override
  String lsRelayCmdFailedWith(String cmd, String err) {
    return '$cmd fehlgeschlagen: $err';
  }

  @override
  String get lsRelayConfiguredSnack => 'Relais konfiguriert';

  @override
  String get lsRelayFireAbortedSnack => 'Auslösen abgebrochen';

  @override
  String get lsRelayForcedIdleSnack => 'Relais zwangsweise auf Ruhe gesetzt';

  @override
  String get lsRelayGpioLabel => 'GPIO-Pin';

  @override
  String get lsRelayGpioHint => 'Gültiger ESP32-C6-Pin; Standard 19 = D8';

  @override
  String get lsRelayInvertLabel => 'Polarität umkehren';

  @override
  String get lsRelayStartDelayLabel => 'Startverzögerung';

  @override
  String lsRelayStartDelayHint(int sec) {
    return '$sec s, bevor das Relais aktiviert wird';
  }

  @override
  String get lsRelayActiveDurationLabel => 'Aktive Dauer';

  @override
  String get lsRelayUnitSeconds => 'Sekunden';

  @override
  String get lsRelayUnitMinutes => 'Minuten';

  @override
  String get lsRelayPulseModeLabel => 'Pulsmodus';

  @override
  String get lsRelayPulseModeHint =>
      'An = 1 s Halbzyklus. Benutzerdefiniert lässt dich den Halbzyklus festlegen.';

  @override
  String get lsRelayHalfCycleLabel => 'Halbzyklus in Sekunden';

  @override
  String get lsRelayFiringButton => 'Wird ausgelöst…';

  @override
  String get lsRelayTestRelayButton => 'Relais testen';

  @override
  String get lsRelayAbortButton => 'Abbrechen';

  @override
  String get lsRelayForceOffButton => 'Zwangsweise aus';

  @override
  String get lsRelayPulseOff => 'Aus';

  @override
  String get lsRelayPulseOn => 'An';

  @override
  String get lsRelayPulseCustom => 'Benutzerdefiniert';

  @override
  String get lsRelayPhaseActiveBadge => 'aktiv';

  @override
  String lsRelayPhaseLine(String phase, String elapsed) {
    return 'Phase: $phase$elapsed';
  }

  @override
  String get lsTelegramTokenRequired => 'Bot-Token ist erforderlich';

  @override
  String get lsTelegramChatRequired => 'Chat-ID ist erforderlich';

  @override
  String get lsTelegramSaveDialogTitle => 'Telegram-Endpunkt speichern?';

  @override
  String lsTelegramSaveDialogBody(String name) {
    return 'Speichert `$name` auf dem Gerät. Das Token wird in der URL gesendet.';
  }

  @override
  String get lsTelegramSavedSnack => 'Telegram-Endpunkt gespeichert';

  @override
  String get lsTelegramDisabledSnack => 'Telegram-Endpunkt deaktiviert';

  @override
  String get lsTelegramTestQueuedSnack =>
      'Test eingereiht, beobachte den Telegram-Chat';

  @override
  String get lsTelegramRemoveDialogTitle => 'Telegram-Endpunkt entfernen?';

  @override
  String get lsTelegramBotConfiguredStatus => 'Bot konfiguriert';

  @override
  String get lsTelegramBotTokenLabel => 'Bot-Token';

  @override
  String get lsTelegramBotTokenHint =>
      'Erhältst du von @BotFather (sieht aus wie 1234567:AAH...).';

  @override
  String get lsTelegramChatIdLabel => 'Chat-ID';

  @override
  String get lsTelegramChatIdHint =>
      'Eine numerische ID (-100...) oder ein @kanal-Benutzername.';

  @override
  String get lsTelegramMessageTemplateLabel => 'Nachrichtenvorlage';

  @override
  String get lsTelegramMessageHint => 'LebensSpur: Alarm ausgelöst.';

  @override
  String get lsLsApiUrlRequired => 'URL erforderlich';

  @override
  String get lsLsApiUpdatedSnack => 'Webhook aktualisiert';

  @override
  String get lsLsApiSavedSnack => 'Webhook gespeichert';

  @override
  String get lsLsApiSaveFirstSnack => 'Speichere zuerst den Webhook';

  @override
  String get lsLsApiTestQueuedSnack => 'Test eingereiht, prüfe den Empfänger';

  @override
  String get lsLsApiRemoveDialogBody =>
      'Der LS-Webhook wird vom Gerät gelöscht. Der Countdown löst ihn nicht mehr aus.';

  @override
  String get lsLsApiRemovedSnack => 'Webhook entfernt';

  @override
  String get lsLsApiConfirmCriticalTitle => 'Kritische Änderung bestätigen';

  @override
  String lsLsApiConfirmCriticalBody(String cmd, int ttlSec) {
    return 'Das Gerät bittet um Bestätigung:\n  $cmd\n\nDieses Token läuft in $ttlSec s ab.';
  }

  @override
  String get lsLsApiConfirmButton => 'Bestätigen';

  @override
  String lsLsApiActiveSlot(String name) {
    return 'Aktiv · Slot „$name“';
  }

  @override
  String lsLsApiActiveWithToken(String name, String token) {
    return 'Aktiv · Slot „$name“ · Token $token';
  }

  @override
  String get lsLsApiUrlHint =>
      'Wird ausgelöst, wenn timer.triggered feuert. https:// empfohlen.';

  @override
  String get lsLsApiHeadersLabel => 'Headers (JSON)';

  @override
  String get lsLsApiHeadersHint =>
      'Erweitert: noch nicht über die CLI angebunden. Reserviert für ein künftiges Release.';

  @override
  String get lsLsApiBodyTemplateHint =>
      'Wird als Test-Payload gesendet. Der Platzhalter device wird serverseitig ersetzt.';

  @override
  String lsLsApiBearerHintExisting(String token) {
    return 'Aktuell gesetzt: $token. Leer lassen, um es zu behalten, oder einen neuen Wert einfügen, um es zu überschreiben.';
  }

  @override
  String get lsLsApiBearerHintEmpty =>
      'Wird als `Authorization: Bearer <token>` gesendet.';

  @override
  String get lsLsApiUpdateButton => 'Aktualisieren';

  @override
  String lsMailGroupsStatusFmt(int count, int max, int recipients) {
    return '$count von $max · insgesamt $recipients Empfänger';
  }

  @override
  String lsMailGroupsReadFailedWith(String err) {
    return 'Lesen fehlgeschlagen: $err';
  }

  @override
  String get lsMailGroupsNameValidation =>
      'Der Name muss zwischen 1 und 47 Zeichen lang sein';

  @override
  String get lsMailGroupsNameSaved => 'Name gespeichert';

  @override
  String get lsMailGroupsSubjectValidation =>
      'Der Betreff darf höchstens 127 Zeichen lang sein';

  @override
  String get lsMailGroupsSubjectSaved => 'Betreff gespeichert';

  @override
  String get lsMailGroupsBodyValidation =>
      'Der Text darf höchstens 511 Zeichen lang sein';

  @override
  String get lsMailGroupsBodySaved => 'Text gespeichert';

  @override
  String get lsMailGroupsEmailValidation => 'Gib eine gültige E-Mail ein';

  @override
  String lsMailGroupsMaxReached(int max) {
    return 'Das Maximum sind $max Gruppen';
  }

  @override
  String get lsMailGroupsNameEmpty => 'Der Name darf nicht leer sein';

  @override
  String get lsMailGroupsCreatedSnack => 'Gruppe erstellt';

  @override
  String lsMailGroupsCreateFailedWith(String err) {
    return 'Erstellen fehlgeschlagen: $err';
  }

  @override
  String get lsMailGroupsDeleteDialogTitle => 'Gruppe löschen?';

  @override
  String get lsMailGroupsDeleteDialogBody =>
      'Dies entfernt die Gruppe und alle ihre Empfänger auf dem Gerät.';

  @override
  String get lsMailGroupsDeleteConfirm => 'Löschen';

  @override
  String get lsMailGroupsDeletedSnack => 'Gruppe gelöscht';

  @override
  String lsMailGroupsDefaultName(int n) {
    return 'Gruppe $n';
  }

  @override
  String get lsMailGroupsNewGroupTitle => 'Neue Mail-Gruppe';

  @override
  String get lsMailGroupsGroupNameLabel => 'Gruppenname';

  @override
  String get lsMailGroupsCreateConfirm => 'Erstellen';

  @override
  String get lsMailGroupsEmptyHint =>
      'Noch keine Gruppen. Erstelle eine, um Mails zu senden, wenn der Timer auslöst.';

  @override
  String get lsMailGroupsWorkingButton => 'Wird bearbeitet…';

  @override
  String get lsMailGroupsCreateNewButton => '+ Neue Gruppe erstellen';

  @override
  String lsMailGroupsHeaderCount(int count, int max) {
    return '$count von $max Gruppen konfiguriert';
  }

  @override
  String lsMailGroupsHeaderTotalRecipients(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'insgesamt $count Empfänger',
      one: 'insgesamt 1 Empfänger',
    );
    return '· $_temp0';
  }

  @override
  String get lsMailGroupsUnnamed => '(unbenannt)';

  @override
  String lsMailGroupsRowSummary(int count, String state) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Empfänger',
      one: '1 Empfänger',
    );
    return '$_temp0 · $state';
  }

  @override
  String get lsMailGroupsEnabled => 'aktiviert';

  @override
  String get lsMailGroupsDisabled => 'deaktiviert';

  @override
  String get lsMailGroupsNameLabel => 'Name';

  @override
  String get lsMailGroupsSubjectLabel => 'Betreff';

  @override
  String get lsMailGroupsSaveBodyButton => 'Text speichern';

  @override
  String get lsMailGroupsDeleteGroupButton => 'Gruppe löschen';

  @override
  String lsMailGroupsRecipientsHeader(int count) {
    return 'Empfänger ($count)';
  }

  @override
  String get lsMailGroupsNoRecipients => 'Noch keine Empfänger.';

  @override
  String get lsMailGroupsAddRecipientButton => 'Hinzufügen';

  @override
  String get lsHomeStatusLoading => 'Wird geladen…';

  @override
  String get lsHomeLogsTooltip => 'Logs';

  @override
  String get lsHomeClusterConfiguration => 'KONFIGURATION';

  @override
  String get lsHomeClusterTriggerActions => 'AUSLÖSE-AKTIONEN';

  @override
  String get lsHomeClusterEarlyWarning => 'FRÜHWARNUNG';

  @override
  String get lsHomeSectionDurationTitle => 'Dauer & Alarme';

  @override
  String get lsHomeSectionVacationTitle => 'Urlaubsmodus';

  @override
  String get lsHomeSectionSmtpTitle => 'Mail-Einrichtung (SMTP)';

  @override
  String get lsHomeSectionResetApiTitle => 'Reset-API-Endpunkt';

  @override
  String get lsHomeSectionMailGroupsTitle => 'Mail-Gruppen';

  @override
  String get lsHomeSectionRelayTitle => 'Relais';

  @override
  String get lsHomeSectionLsApiTitle => 'LS-API-Webhook';

  @override
  String get lsHomeSectionTelegramTitle => 'Telegram';

  @override
  String get lsHomeSectionReminderMailTitle => 'Erinnerungs-Mail';

  @override
  String get lsHomeSectionAlarmApiTitle => 'Alarm-API-Webhook';

  @override
  String get lsHomeStateInactive => 'INAKTIV';

  @override
  String get lsHomeStateRemaining => 'VERBLEIBEND';

  @override
  String get lsHomeStateVacation => 'URLAUB';

  @override
  String get lsHomeStateTriggered => 'AUSGELÖST';

  @override
  String get lsHomeChipBle => 'BLE';

  @override
  String get lsHomeChipMail => 'Mail';

  @override
  String get lsHomeEarlyWarningPendingNote =>
      'Frühwarn-Aktionen feuern bei timer.alarm. Der Firmware-Abonnent steht noch aus; diese Konfigurationen bleiben erhalten, lösen aber noch nicht automatisch aus.';

  @override
  String get settingsDiagnosticsTitle => 'Diagnose';

  @override
  String get settingsDiagnosticsSubtitle => 'Logs zur Fehlerbehebung';

  @override
  String get diagnosticsCopyLogs => 'Logs kopieren';

  @override
  String get diagnosticsOpenFolder => 'Ordner öffnen';

  @override
  String get diagnosticsOpenFolderFailed =>
      'Der Log-Ordner konnte nicht geöffnet werden.';

  @override
  String get diagnosticsShareLogs => 'Logs teilen';

  @override
  String get diagnosticsClearLogs => 'Logs leeren';

  @override
  String get diagnosticsCopied => 'Logs in die Zwischenablage kopiert';

  @override
  String get diagnosticsCleared => 'Logs geleert';

  @override
  String get aboutPrivacyLabel => 'Datenschutzerklärung';

  @override
  String get updateChecking => 'Suche nach Updates…';

  @override
  String get updateUpToDate => 'Du hast die neueste Version';

  @override
  String get updateCheckFailed => 'Nach Updates konnte nicht gesucht werden';

  @override
  String get updateAvailableTitle => 'Update verfügbar';

  @override
  String updateAvailableBody(String version, String current) {
    return 'Eine neue Version ($version) ist verfügbar. Du hast $current.';
  }

  @override
  String get updateDownloadAction => 'Herunterladen';

  @override
  String get updateLater => 'Später';
}
