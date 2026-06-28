// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'SKAPP';

  @override
  String get brandTagline => 'SmartKraft';

  @override
  String get tabHome => 'Home';

  @override
  String get tabDevices => 'Dispositivi';

  @override
  String get tabSkapi => 'SKAPI';

  @override
  String get tabSettings => 'Impostazioni';

  @override
  String get tabSmartKraft => 'SmartKraft';

  @override
  String get comingSoonBadge => 'in arrivo';

  @override
  String get featureComingSoonSnack =>
      'Questa funzione sarà disponibile a breve';

  @override
  String get homeWelcome => 'Benvenuto in SmartKraft';

  @override
  String get homeSubtitle => 'Gestisci i tuoi dispositivi SmartKraft';

  @override
  String get homeAddDevice => 'Aggiungi nuovo dispositivo';

  @override
  String get homeNoDevicesTitle => 'Ancora nessun dispositivo';

  @override
  String get homeNoDevicesHint =>
      'Aggiungi il tuo primo dispositivo SmartKraft per iniziare.';

  @override
  String get homeSummaryTitle => 'Panoramica';

  @override
  String homeDevicesOnline(int count) {
    return '$count connessi';
  }

  @override
  String homeDevicesOffline(int count) {
    return '$count offline';
  }

  @override
  String get homeUpdatesTitle => 'Aggiornamenti disponibili';

  @override
  String homeUpdatesBody(int count) {
    return '$count dispositivo ha un firmware più recente.';
  }

  @override
  String get homeWarningsTitle => 'Avvisi';

  @override
  String homeWarningsBody(int count) {
    return '$count dispositivo ha segnalato un problema.';
  }

  @override
  String get homeAllGood => 'Tutto funziona correttamente.';

  @override
  String get devicesTitle => 'Dispositivi';

  @override
  String get devicesEmpty =>
      'Ancora nessun dispositivo aggiunto.\nTocca il pulsante + per aggiungerne uno.';

  @override
  String get devicesAdd => 'Aggiungi dispositivo';

  @override
  String get devicesAllSection => 'Tutti i dispositivi';

  @override
  String get devicesGroupsTitle => 'I tuoi gruppi';

  @override
  String get devicesGroupsHint =>
      'Crea gruppi per organizzare i tuoi dispositivi come preferisci.';

  @override
  String get devicesGroupsCreate => 'Nuovo gruppo';

  @override
  String get devicesGroupsEmpty => 'Ancora nessun gruppo.';

  @override
  String get skapiTitle => 'SKAPI';

  @override
  String get skapiLibraryHeading => 'Libreria SKAPI';

  @override
  String get skapiLibrarySubtitle =>
      'Scegli la piattaforma che i tuoi dispositivi attiveranno.';

  @override
  String get skapiThisComputer => 'Questo computer';

  @override
  String skapiCategoryCount(int count) {
    return '$count categorie';
  }

  @override
  String get skapiPlatformMac => 'macOS';

  @override
  String get skapiPlatformWin => 'Windows';

  @override
  String get skapiPlatformLinux => 'Linux';

  @override
  String get skapiPlatformOther => 'Altro';

  @override
  String get skapiStarredHeading => 'API preferite';

  @override
  String get skapiStarredEmpty =>
      'Aggiungi ai preferiti i template della libreria: appariranno qui.';

  @override
  String get skapiContributeTitle =>
      'Invia la tua libreria alla community SmartKraft';

  @override
  String get skapiContributeBody =>
      'Questa scheda verrà progettata più avanti.';

  @override
  String get skapiSearchPlaceholder => 'Cerca azioni…';

  @override
  String get skapiSearchDisabledHint =>
      'Si attiverà una volta collegato il parser SKAPI.';

  @override
  String get skapiHelpButtonTooltip => 'Informazioni su SKAPI';

  @override
  String get skapiHelpSheetTitle => 'Informazioni su SKAPI';

  @override
  String get skapiHelpIntro =>
      'SKAPI è una libreria di azioni che i tuoi dispositivi SmartKraft possono attivare sul tuo computer.';

  @override
  String get skapiHelpStep1Title => 'Sfoglia un template';

  @override
  String get skapiHelpStep1Body =>
      'Scegli un punto di partenza dalla libreria SKAPI.';

  @override
  String get skapiHelpStep2Title => 'Configura';

  @override
  String get skapiHelpStep2Body =>
      'Imposta i parametri e scegli quale dispositivo la attiva.';

  @override
  String get skapiHelpStep3Title => 'Invia al dispositivo';

  @override
  String get skapiHelpStep3Body =>
      'Il dispositivo memorizza il trigger API; SKAPP esegue lo script.';

  @override
  String get skapiHelpGlossaryTitle => 'Glossario';

  @override
  String get skapiHelpGlossaryTemplate =>
      'Template: una voce di libreria in sola lettura';

  @override
  String get skapiHelpGlossaryAction =>
      'Azione: una coppia configurata di trigger API + script';

  @override
  String get skapiHelpGlossaryApiTrigger =>
      'Trigger API: ciò che il dispositivo chiama';

  @override
  String get skapiHelpGlossaryScript =>
      'Script: ciò che il tuo computer esegue';

  @override
  String get skapiHelpPhase1Notice =>
      'SKAPI è ancora in fase di sviluppo. Gran parte di questa scheda è uno scheletro; le sezioni contrassegnate come \"non ancora attive\" si abiliteranno man mano che arrivano il parser, il listener e il generatore di moduli.';

  @override
  String get skapiMobileBannerBody =>
      'Questo telefono non può essere una destinazione. Per eseguire le azioni, SKAPP deve essere aperto sul tuo computer.';

  @override
  String get skapiActionsHeading => 'Le mie azioni';

  @override
  String get skapiActionsNoDevicesTitle => 'Ancora nessun dispositivo';

  @override
  String get skapiActionsNoDevicesBody =>
      'Abbina prima un dispositivo SmartKraft; vai alla scheda Dispositivi.';

  @override
  String get skapiActionsCreationDisabled =>
      'La creazione di azioni non è ancora attiva.';

  @override
  String get skapiActionsOfflineDetectionDisabled =>
      'Rilevamento online non ancora attivo';

  @override
  String get skapiActionsMaxLimitNote => 'Fino a 5 azioni per dispositivo.';

  @override
  String get skapiActionsAddCta => 'Aggiungi azione';

  @override
  String skapiHeaderSub(int platforms, int actions) {
    return '$platforms piattaforme · $actions azioni';
  }

  @override
  String get skapiNewActionPill => 'Nuova azione';

  @override
  String skapiActionsSubLine(int count) {
    return 'associazioni dispositivo × script · $count attive';
  }

  @override
  String get skapiActionsEmptyHint =>
      'Ancora nessuna azione. Associa cosa accade quando si preme un pulsante del dispositivo.';

  @override
  String get skapiActionsCreateCta => 'Crea';

  @override
  String skapiActionsGroupTitle(String name) {
    return 'Azioni di $name';
  }

  @override
  String skapiActionsGroupCount(int count) {
    return '$count';
  }

  @override
  String get skapiListenerEndpointTitle =>
      'URL webhook inviato ai dispositivi BF';

  @override
  String get skapiListenerEndpointBody =>
      'Se un BF sulla stessa Wi-Fi non riesce a raggiungere questo URL dopo il conto alla rovescia, la scheda di rete del laptop potrebbe essere errata (es. rete WSL/VirtualBox/Docker). Tocca Aggiorna per inviarlo di nuovo.';

  @override
  String get skapiListenerEndpointResolving => 'Risoluzione IP locale…';

  @override
  String get skapiListenerEndpointUnavailable =>
      'Nessuna interfaccia LAN utilizzabile trovata.';

  @override
  String get skapiListenerEndpointRefresh => 'Aggiorna';

  @override
  String get skapiListenerEndpointRefreshing => 'Invio…';

  @override
  String skapiListenerEndpointPushedAt(String when) {
    return 'Ultimo aggiornamento $when';
  }

  @override
  String get skapiListenerSelfTest => 'Auto-test';

  @override
  String get skapiListenerSelfTestRunning => 'Test in corso…';

  @override
  String get skapiListenerSelfTestPassed =>
      'Auto-test OK: listener raggiungibile da questo host.';

  @override
  String get skapiListenerSelfTestFailed =>
      'Auto-test FALLITO: listener non raggiungibile. Controlla il Windows Firewall.';

  @override
  String get skapiWebhookActivityTitle => 'Webhook recenti';

  @override
  String get skapiWebhookActivityNone =>
      'Ancora nessun webhook ricevuto. Allo scadere del timer del dispositivo, una voce dovrebbe apparire qui entro pochi secondi.';

  @override
  String get skapiWebhookActivityAccepted => 'Accettato';

  @override
  String skapiWebhookActivityRejected(int code) {
    return 'Rifiutato ($code)';
  }

  @override
  String get skapiWebhookActivityMalformed => 'Malformato';

  @override
  String get skapiWebhookActivitySelfTest => 'Auto-test';

  @override
  String get skapiWebhookActivityNoMatch =>
      'Nessuna associazione corrispondente';

  @override
  String get skapiWebhookActivityScriptError => 'Errore script';

  @override
  String skapiWebhookActivityMatched(int count) {
    return '$count script eseguiti';
  }

  @override
  String get skapiBfEndpointsButton => 'Ispeziona endpoint BF';

  @override
  String get skapiBfEndpointsTitle => 'Endpoint memorizzati sui dispositivi BF';

  @override
  String get skapiBfEndpointsHint =>
      'Istantanea in sola lettura di api.endpoint.list da ogni dispositivo abbinato. Confronta l\'URL di ogni slot SYSTEM con l\'URL del listener qui sopra. Devono corrispondere esattamente. Gli slot USER possono appartenere a webhook manuali e potrebbero intercettare il tuo conto alla rovescia se configurati male.';

  @override
  String get skapiBfEndpointsLoading => 'Interrogazione dispositivi BF…';

  @override
  String get skapiBfEndpointsErrorPrefix => 'Interrogazione fallita:';

  @override
  String get skapiBfEndpointsKindSystem => 'SYSTEM';

  @override
  String get skapiBfEndpointsKindUser => 'USER';

  @override
  String get skapiBfEndpointsEmpty =>
      'Nessun endpoint memorizzato su questo dispositivo.';

  @override
  String get skapiBfEndpointsClose => 'Chiudi';

  @override
  String get skapiBfEndpointsRefresh => 'Interroga di nuovo';

  @override
  String skapiStarredCount(int count) {
    return '$count preferiti';
  }

  @override
  String get skapiStarredSlimEmpty =>
      'Aggiungi ai preferiti le voci della libreria per raccogliere qui quelle più usate.';

  @override
  String get skapiCommunityShareTitle =>
      'Condividi la tua libreria con la community SmartKraft';

  @override
  String get skapiCommunityShareBody =>
      'Gli script che scrivi diventano disponibili a tutti nella libreria SKAPI.';

  @override
  String get settingsNetworkIdentityTitle => 'Identità di rete';

  @override
  String get settingsNetworkIdentityName => 'Nome computer';

  @override
  String get settingsNetworkIdentityNameHint => 'Usato come nome istanza mDNS';

  @override
  String get settingsNetworkIdentityNameEdit => 'Rinomina';

  @override
  String get settingsNetworkIdentityNameDialogTitle =>
      'Rinomina questo computer';

  @override
  String get settingsNetworkIdentityNameDialogHelp =>
      'Lettere minuscole, numeri e trattini. Fino a 32 caratteri.';

  @override
  String get settingsNetworkIdentityUuid => 'ID dispositivo';

  @override
  String get settingsNetworkIdentityPort => 'Porta listener';

  @override
  String get settingsNetworkIdentityPortDialogTitle => 'Porta listener';

  @override
  String get settingsNetworkIdentityToken => 'Bearer token';

  @override
  String get settingsNetworkIdentityRegenerateToken => 'Rigenera token';

  @override
  String get settingsNetworkIdentityRegenerateConfirmTitle =>
      'Rigenerare il bearer token?';

  @override
  String get settingsNetworkIdentityRegenerateConfirmBody =>
      'I dispositivi esistenti dovranno essere riabbinati con il nuovo token.';

  @override
  String get settingsNetworkIdentityServerNotRunning =>
      'Server non ancora in esecuzione, si attiverà nella Fase 2.';

  @override
  String get settingsNetworkIdentityCopy => 'Copia';

  @override
  String get settingsNetworkIdentityCopied => 'Copiato';

  @override
  String get settingsNetworkIdentityStaticIpHint =>
      'Suggerimento: una prenotazione DHCP (IP statico) sul router rende le connessioni più affidabili.';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsSectionAppearance => 'Aspetto';

  @override
  String get settingsLanguage => 'Lingua';

  @override
  String get settingsLanguageSystemHint => 'Segui la lingua del sistema';

  @override
  String get settingsLanguagePickerAllSection => 'Tutte le lingue';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeLight => 'Chiaro';

  @override
  String get settingsThemeDark => 'Scuro';

  @override
  String get settingsThemeSystem => 'Sistema';

  @override
  String get settingsSectionAbout => 'Informazioni';

  @override
  String get settingsVersion => 'Versione';

  @override
  String get settingsDeveloper => 'Sviluppatore';

  @override
  String get settingsDeveloperName => 'SmartKraft';

  @override
  String get settingsOpenAbout => 'Informazioni su SKAPP';

  @override
  String get settingsSectionAdvanced => 'Avanzate';

  @override
  String get settingsDeveloperMode => 'Modalità sviluppatore';

  @override
  String get settingsDeveloperToolsTitle => 'Strumenti sviluppatore';

  @override
  String get settingsDeveloperToolsSubtitle =>
      'Console USB, identità di rete, listener, token, registri';

  @override
  String get settingsDeveloperModeInfoTitle =>
      'Cosa sblocca la modalità sviluppatore?';

  @override
  String get settingsDeveloperModeInfoIntro =>
      'Questa modalità rivela funzioni avanzate nascoste nell\'interfaccia predefinita. Tre casi d\'uso principali:';

  @override
  String get settingsDeveloperModeUseCaseCliTitle => 'Console CLI';

  @override
  String get settingsDeveloperModeUseCaseCliBody =>
      'Configura i tuoi dispositivi tramite cavo USB senza stabilire prima una connessione BLE o WiFi.';

  @override
  String get settingsDeveloperModeUseCaseSkapiTitle => 'Editor di codice SKAPI';

  @override
  String get settingsDeveloperModeUseCaseSkapiBody =>
      'Apri e modifica gli script integrati, oppure scrivine di tuoi da zero.';

  @override
  String get settingsDeveloperModeUseCaseMobileTitle =>
      'Attivazione remota da mobile';

  @override
  String get settingsDeveloperModeUseCaseMobileBody =>
      'Esegui le associazioni SKAPI di questo desktop da un SKAPP mobile abbinato.';

  @override
  String get settingsDeveloperModeInfoSurfacesHeader =>
      'Schede extra delle Impostazioni che appaiono quando è attiva:';

  @override
  String get settingsDeveloperModeInfoItem1 =>
      'Scheda identità di rete: modifica UUID, porta, bearer token; copia / rigenera il segreto di installazione SKAPP.';

  @override
  String get settingsDeveloperModeInfoItem2 =>
      'Controlli del listener HTTP locale: avvio/arresto, abbinamento QR, rotazione certificato TLS, visibilità LAN.';

  @override
  String get settingsDeveloperModeInfoItem3 =>
      'Elenco token per peer: vedi ogni SKAPP mobile abbinato e revocalo singolarmente.';

  @override
  String get settingsDeveloperModeInfoItem4 =>
      'Console CLI USB (solo desktop): riga di comando NDJSON grezza verso un dispositivo SmartKraft collegato via USB.';

  @override
  String get settingsDeveloperModeInfoNotPaid =>
      'Non è un upgrade a pagamento. SKAPP è a livello unico e gratuito; questo interruttore nasconde solo le funzioni avanzate per impostazione predefinita, per mantenere tutto semplice. I dispositivi SmartKraft funzionano indipendentemente da questa impostazione.';

  @override
  String get settingsSectionConnectivity => 'Connettività';

  @override
  String get settingsBluetoothStatus => 'Bluetooth';

  @override
  String get settingsBluetoothStatusOn => 'Pronto';

  @override
  String get settingsBluetoothStatusOff => 'Disattivato';

  @override
  String get settingsBluetoothStatusTurningOn => 'Attivazione…';

  @override
  String get settingsBluetoothStatusTurningOff => 'Disattivazione…';

  @override
  String get settingsBluetoothStatusUnauthorized => 'Nessun permesso';

  @override
  String get settingsBluetoothStatusUnsupported => 'Non supportato';

  @override
  String get settingsBluetoothStatusUnknown => 'Verifica…';

  @override
  String get settingsNetworkStatus => 'Rete';

  @override
  String get settingsWifiStatusConnected => 'Wi-Fi';

  @override
  String get settingsWifiStatusEthernet => 'Ethernet';

  @override
  String get settingsWifiStatusMobile => 'Dati mobili';

  @override
  String get settingsWifiStatusDisconnected => 'Disconnesso';

  @override
  String get settingsWifiStatusUnknown => 'Verifica…';

  @override
  String get settingsWifiHint => 'Usato dopo l\'abbinamento iniziale.';

  @override
  String get settingsBluetoothPermissions => 'Permessi';

  @override
  String get settingsBluetoothPermissionsHint =>
      'Accesso a Bluetooth e posizione';

  @override
  String get settingsBluetoothGrantPermission => 'Concedi accesso';

  @override
  String get settingsOpenSystemSettings => 'Apri impostazioni di sistema';

  @override
  String get settingsSectionUpdates => 'Aggiornamenti';

  @override
  String get settingsCheckUpdates => 'Verifica aggiornamenti';

  @override
  String get settingsAutoCheckUpdates => 'Verifica all\'avvio';

  @override
  String get settingsAutoCheckUpdatesHint =>
      'Verifica di avere l\'ultima versione a ogni apertura di SKAPP.';

  @override
  String get settingsUpdateChannel => 'Canale di aggiornamento';

  @override
  String get settingsUpdateChannelStable => 'Stabile';

  @override
  String get settingsUpdateChannelBeta => 'Beta';

  @override
  String get settingsUpdateChannelBetaHint =>
      'Ricevi le novità prima. Potrebbe essere meno stabile.';

  @override
  String get settingsUpToDate => 'Hai l\'ultima versione.';

  @override
  String get settingsUpdateCheckPlaceholder =>
      'La verifica degli aggiornamenti verrà collegata nella Fase 3.';

  @override
  String get settingsSectionLegal => 'Note legali';

  @override
  String get settingsLicense => 'Licenza e ringraziamenti';

  @override
  String get settingsSectionInfo => 'Informazioni';

  @override
  String get settingsThemeCycleHint => 'Tocca per cambiare';

  @override
  String get settingsChannelCycleHint => 'Tocca per cambiare';

  @override
  String get settingsSectionThisNode => 'Questo nodo';

  @override
  String get settingsNodeNameTitle => 'Nome nodo SKAPP';

  @override
  String settingsNodeNameSub(String name) {
    return '$name · gli altri SKAPP vedono questo nome · broadcast mDNS';
  }

  @override
  String get settingsSectionDanger => 'Zona pericolosa';

  @override
  String get settingsResetPairings => 'Reimposta abbinamenti';

  @override
  String get settingsResetPairingsSub =>
      'Rimuove tutti i dispositivi abbinati; impostazioni/lingua/nome nodo conservati';

  @override
  String get settingsFactoryReset => 'Ripristino di fabbrica';

  @override
  String get settingsFactoryResetSub => 'Tutto cancellato, irreversibile';

  @override
  String get settingsSectionAdvancedNetwork => 'Rete avanzata';

  @override
  String get settingsResetPairingsConfirmTitle =>
      'Reimpostare tutti gli abbinamenti?';

  @override
  String settingsResetPairingsConfirmBody(int paired, int bindings, int peers) {
    return '$paired dispositivi abbinati, $bindings azioni SKAPI e $peers peer SKAPP verranno rimossi. Le tue impostazioni, il tema, la lingua e le note vengono conservati. I dispositivi mantengono comunque il loro bond dal loro lato; per scollegarli completamente, reimposta il dispositivo manualmente. Questa azione non può essere annullata.';
  }

  @override
  String get settingsResetPairingsConfirmAction => 'Reimposta';

  @override
  String get settingsFactoryResetConfirmTitle => 'Ripristino di fabbrica?';

  @override
  String get settingsFactoryResetConfirmBody =>
      'Tutto verrà cancellato: tutti gli abbinamenti, le impostazioni, il tema, la lingua, le note, l\'identità di rete, il certificato TLS e la voce di avvio automatico. SKAPP torna allo stato del primo avvio. Questa azione non può essere annullata.';

  @override
  String get settingsFactoryResetConfirmAction => 'Cancella tutto';

  @override
  String get settingsFactoryResetSecondConfirmTitle =>
      'Sei assolutamente sicuro?';

  @override
  String get settingsFactoryResetSecondConfirmBody =>
      'Digita ERASE per confermare.';

  @override
  String get settingsFactoryResetSecondConfirmHint => 'ERASE';

  @override
  String get settingsFactoryResetSecondConfirmAction => 'Ho capito. Cancella.';

  @override
  String get settingsResetInProgress => 'Reimpostazione…';

  @override
  String get settingsResetDoneTitle => 'Reimpostazione completata';

  @override
  String get settingsResetDoneWithWarnings =>
      'Reimpostazione completata (con avvisi)';

  @override
  String settingsResetSummaryPaired(int count) {
    return '$count dispositivi abbinati rimossi';
  }

  @override
  String settingsResetSummaryBindings(int count) {
    return '$count azioni SKAPI rimosse';
  }

  @override
  String settingsResetSummaryPeers(int count) {
    return '$count peer SKAPP rimossi';
  }

  @override
  String settingsResetSummaryBonds(int count) {
    return '$count bond dispositivo cancellati';
  }

  @override
  String get settingsResetSummaryNetworkIdentity =>
      'Identità di rete ripristinata ai valori predefiniti';

  @override
  String get settingsResetSummaryTlsCert => 'Certificato TLS cancellato';

  @override
  String get settingsResetSummaryAutostart =>
      'Voce di avvio automatico rimossa';

  @override
  String get settingsResetSummaryWarningHeader => 'Avvisi:';

  @override
  String get settingsResetRestartHint =>
      'Riavvia SKAPP per applicare completamente le modifiche.';

  @override
  String get settingsResetRestartNow => 'Riavvia ora';

  @override
  String get settingsResetClose => 'Chiudi';

  @override
  String settingsFooterCombined(String version, String node) {
    return 'SKAPP $version · $node';
  }

  @override
  String get langEnglish => 'English';

  @override
  String get langTurkish => 'Türkçe';

  @override
  String get aboutTitle => 'Informazioni su SmartKraft e SKAPP';

  @override
  String get aboutDevicesHeading => 'I nostri dispositivi';

  @override
  String get aboutDevicesBody =>
      'I dispositivi SmartKraft sono progettati per essere innovativi, distintivi e per portare dettagli a cui altri non hanno pensato. Il nostro scopo non è riprodurre ciò che già esiste; è realizzare ciò che non è stato fatto, ciò che è stato lasciato in sospeso. Indicare un problema quotidiano irrisolto e offrirgli una risposta semplice e comprensibile; oppure prendere qualcosa che è stato risolto ma è rimasto costoso, e metterci al suo posto una versione DIY che tutti possono costruire.\n\nOgni dispositivo SmartKraft è progettato e costruito per dare una risposta piccola e semplice a un problema non ancora risolto. Nel progettare un dispositivo, ci poniamo una sola domanda: \"Perché questo problema non è stato risolto finora, o perché è rimasto così costoso?\"';

  @override
  String get aboutSkappRoleHeading => 'Dove si colloca SKAPP';

  @override
  String get aboutSkappRoleBody =>
      'SKAPP è l\'applicazione condivisa per i dispositivi SmartKraft. È una semplice interfaccia utente per abbinare un dispositivo, configurarlo, modificarne il comportamento e riunire più dispositivi in un unico scenario.\n\nSKAPP non è necessario per i tuoi dispositivi; è una comodità. Ogni dispositivo SmartKraft può essere configurato allo stesso modo tramite USB CLI senza SKAPP, e questa strada resta aperta per chi preferisce la riga di comando. Per tutti gli altri che vogliono la rapidità di un\'interfaccia visiva e la comodità di gestire più dispositivi contemporaneamente, c\'è SKAPP.\n\nNessun account cloud. Nessuna pubblicità. Nessuna raccolta dati. È un ponte silenzioso tra il tuo telefono e il tuo dispositivo, niente di più.';

  @override
  String get aboutShowcaseHeading => 'Vetrina maker';

  @override
  String get aboutShowcaseEmpty =>
      'La vetrina è vuota per ora. Il primo dispositivo SmartKraft è in arrivo; i file di progetto, i sorgenti del firmware, gli elenchi dei componenti e le guide di montaggio saranno elencati qui quando saranno pronti. Fino ad allora questa sezione non promette molto, è solo uno spazio riservato a ciò che verrà.';

  @override
  String get aboutConnectHeading => 'Contatti';

  @override
  String get aboutConnectIntro =>
      'Invia un messaggio, guarda il codice sorgente, segui il lavoro mentre cresce.';

  @override
  String get aboutConnectGitHub => 'GitHub';

  @override
  String get aboutConnectWebsite => 'Sito web';

  @override
  String get aboutConnectYouTube => 'YouTube';

  @override
  String get aboutConnectX => 'X';

  @override
  String get aboutConnectEmail => 'Email';

  @override
  String get aboutVersionHeading => 'Versione';

  @override
  String get licenseTitle => 'Licenza e ringraziamenti';

  @override
  String get licenseSmartKraftHeading => 'Informazioni su SmartKraft';

  @override
  String get licenseSmartKraftBody =>
      'SmartKraft è una piccola officina che progetta strumenti elettronici insoliti ma pratici per la vita di tutti i giorni. Dietro ogni dispositivo che ti arriva tra le mani ci sono innumerevoli passaggi: uno schizzo iniziale su un taccuino, un primo prototipo saldato, righe di codice scritte a tarda notte, piccoli dettagli riprovati ancora e ancora. Costruire un dispositivo significa scrivere righe, disegnare circuiti, saldare giunti, trovare bug, ricominciare da capo. A tutti coloro che hanno messo il proprio impegno in questo processo senza lasciarci sopra il proprio nome, grazie, a nome di SmartKraft.\n\nCrediamo nella cultura maker, nell\'open source e nell\'elettronica riparabile e riciclabile. Per questo pubblichiamo i progetti hardware dei nostri dispositivi come open hardware, e il loro firmware sotto AGPL 3.0. Il nostro obiettivo è rendere raggiungibile una versione DIY di quante più parti possibile.\n\nUna nota su cui vogliamo essere onesti: le chiavi di abbinamento e i segreti di comunicazione che proteggono la sicurezza di un dispositivo sono mantenuti privati nel sorgente. Se fossero pubblicati, la fiducia tra il tuo dispositivo e l\'app verrebbe meno. Questa chiusura non è una concessione contro l\'apertura; è una decisione presa per la tua sicurezza.\n\nPer SKAPP e per ogni dispositivo che vi comunica, il nostro principio è la trasparenza: vogliamo che tu possa leggere come funzionano le cose, controllarle e costruire la tua versione. Ciononostante, ogni dispositivo ha la propria sezione di licenza e i termini possono variare. Per vedere il sorgente, gli schemi o i termini d\'uso di un dispositivo, consulta l\'area di licenza di quel dispositivo.\n\nGrazie per averci sostenuto usando questa app. Siamo felici che tu sia qui.';

  @override
  String get licenseOpenSourceHeading => 'Sulle spalle dei giganti';

  @override
  String get licenseOpenSourceBody =>
      'SKAPP è costruito su migliaia di progetti open source scritti prima di esso. Un grazie sentito al team di Flutter e ai suoi contributori per aver reso possibile l\'interfaccia visibile, e a tutti gli sviluppatori open source che hanno dedicato anni a networking, archiviazione, crittografia, Bluetooth e innumerevoli sottosistemi.\n\nPoiché beneficiamo dell\'open source, cerchiamo di mantenere aperti anche l\'hardware e il firmware dei nostri dispositivi, così chi verrà dopo di noi potrà beneficiare di questo lavoro allo stesso modo.\n\nGrazie ancora a tutti coloro che hanno fatto parte di questo impegno.';

  @override
  String get licenseThirdPartyLink =>
      'Licenze di terze parti usate in questa app';

  @override
  String get discoveryTitle => 'Trova dispositivi';

  @override
  String get discoverySearching =>
      'Ricerca di dispositivi SmartKraft nelle vicinanze…';

  @override
  String get discoveryNoResults =>
      'Nessun dispositivo SmartKraft trovato nelle vicinanze.';

  @override
  String get discoveryTapToConnect => 'Tocca un dispositivo per connetterti';

  @override
  String get discoveryRescan => 'Cerca di nuovo';

  @override
  String get pairingTitle => 'Abbina dispositivo';

  @override
  String get pairingEnterPasskey =>
      'Inserisci la passkey stampata sull\'etichetta del dispositivo.';

  @override
  String get pairingPasskeyHint => 'es. K7M9P2AB';

  @override
  String get pairingConnect => 'Connetti';

  @override
  String get pairingMockNotice =>
      'Il firmware del dispositivo non è ancora pronto. In questa build l\'abbinamento è un segnaposto.';

  @override
  String get errorBluetoothPermission =>
      'Il permesso Bluetooth è necessario per cercare i dispositivi.';

  @override
  String get errorBluetoothOff => 'Il Bluetooth è disattivato.';

  @override
  String get errorLocationPermission =>
      'Il permesso di posizione è necessario per cercare dispositivi BLE su Android.';

  @override
  String get actionOpenSettings => 'Apri impostazioni';

  @override
  String get actionGrantPermission => 'Concedi permesso';

  @override
  String get commonCancel => 'Annulla';

  @override
  String get commonConfirm => 'Conferma';

  @override
  String get commonRetry => 'Riprova';

  @override
  String get commonBack => 'Indietro';

  @override
  String get commonRemove => 'Rimuovi';

  @override
  String get commonRefresh => 'Aggiorna';

  @override
  String get commonOk => 'OK';

  @override
  String get commonClose => 'Chiudi';

  @override
  String get commonSave => 'Salva';

  @override
  String get commonDelete => 'Elimina';

  @override
  String get commonConnect => 'Connetti';

  @override
  String get commonAdd => 'Aggiungi';

  @override
  String get commonForget => 'Dimentica';

  @override
  String get commonMore => 'Altro';

  @override
  String get commonError => 'Errore';

  @override
  String get commonOnline => 'online';

  @override
  String get commonOffline => 'offline';

  @override
  String get productBlockingFocus => 'Blocking Focus';

  @override
  String get productLebensSpur => 'LebensSpur';

  @override
  String get productGeneric => 'Dispositivo SmartKraft';

  @override
  String get timeJustNow => 'proprio ora';

  @override
  String timeMinAgo(int count) {
    return '$count min fa';
  }

  @override
  String timeHourAgo(int count) {
    return '$count h fa';
  }

  @override
  String timeDayAgo(int count) {
    return '$count g fa';
  }

  @override
  String get devicesRemoveTitle => 'Rimuovi dispositivo';

  @override
  String devicesRemoveBody(String name) {
    return '$name verrà rimosso. Il dispositivo resta collegato; per aggiungerlo di nuovo dovrai riabbinarlo.';
  }

  @override
  String get devicesUnpair => 'Scollega';

  @override
  String get devicesEmptyHint =>
      'Avvicina il tuo dispositivo SmartKraft e tocca il pulsante qui sotto.';

  @override
  String get devicesEmptyTitleNoPaired => 'Ancora nessun dispositivo abbinato';

  @override
  String devicesLastSeen(String time) {
    return 'Visto l\'\'ultima volta: $time';
  }

  @override
  String devicesPairedAt(String time) {
    return 'Abbinato: $time';
  }

  @override
  String devicesHubSubtitle(int count) {
    return 'Host SKAPP · $count abbinati';
  }

  @override
  String get devicesHubEmptySubtitle => 'in attesa di un dispositivo';

  @override
  String devicesHeaderSub(int paired, int online) {
    return '$paired abbinati · $online online · vista costellazione';
  }

  @override
  String get devicesAddPillLabel => 'Aggiungi dispositivo';

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
    return 'batteria scarica ($count)';
  }

  @override
  String get devicesStatPaired => 'abbinati';

  @override
  String get devicesStatBf => 'BF';

  @override
  String get devicesStatLs => 'LS';

  @override
  String get devicesStatMs => 'telefono';

  @override
  String get devicesEmptyHubLabel => 'Sconosciuto';

  @override
  String get devicesEmptyAddCta => 'Aggiungi primo dispositivo';

  @override
  String get devicesEmptyHintChip =>
      'avvicina il dispositivo, premi il suo pulsante';

  @override
  String devicesNotifOfflineHours(int hours) {
    return 'offline ${hours}h fa';
  }

  @override
  String devicesNotifOfflineMinutes(int minutes) {
    return 'offline ${minutes}m fa';
  }

  @override
  String get devicesNotifLowBattery => 'batteria scarica';

  @override
  String get skappPeersCardTitle => 'SKAPP desktop abbinati';

  @override
  String get skappPeersCardSubtitle =>
      'Telefoni e tablet si abbinano qui così un\'azione BF può eseguire uno script su un SKAPP desktop. Apri SKAPP desktop > Impostazioni > SKAPP HTTP Listener per ottenere un QR.';

  @override
  String get skappPeersCardEmpty => 'Ancora nessun peer abbinato.';

  @override
  String get skappPeersCardPairButton => 'Abbina nuovo';

  @override
  String get skappPeersCardOnline => 'online';

  @override
  String get skappPeersCardOffline => 'offline';

  @override
  String get skappPeersCardNeverSeen => 'mai visto';

  @override
  String skappPeersCardRemoveTitle(String name) {
    return 'Rimuovere $name?';
  }

  @override
  String get skappPeersCardRemoveBody =>
      'SKAPP smetterà di inviare script a questo peer. Potrai riabbinarlo in seguito con lo stesso QR / token.';

  @override
  String get skappPeersCardRemoveConfirm => 'Rimuovi';

  @override
  String get skappPeersCardRemoveCancel => 'Annulla';

  @override
  String skappPeersCardRemovedToast(String name) {
    return '$name scollegato';
  }

  @override
  String get devicesCardLongPressHint => 'Tieni premuto per gestire';

  @override
  String devicesActionsSheetTitle(String name) {
    return '$name';
  }

  @override
  String get devicesActionForget => 'Dimentica dispositivo';

  @override
  String get devicesActionForgetSubtitle =>
      'Rimuovi questo dispositivo da SKAPP. Il dispositivo stesso non viene modificato; potrai riabbinarlo in seguito.';

  @override
  String get devicesActionCancel => 'Annulla';

  @override
  String devicesForgetDialogTitle(String name) {
    return 'Dimenticare $name?';
  }

  @override
  String get devicesForgetDialogBody =>
      'SKAPP smetterà di tracciare questo dispositivo. L\'abbinamento sul lato del dispositivo rimane finché non lo reimposti dal dispositivo.';

  @override
  String devicesForgetDialogBodyWithActions(int count) {
    return 'SKAPP smetterà di tracciare questo dispositivo ed eliminerà $count azioni SKAPI a esso associate. L\'\'abbinamento sul lato del dispositivo rimane finché non lo reimposti dal dispositivo.';
  }

  @override
  String get devicesForgetDialogConfirm => 'Dimentica';

  @override
  String get devicesForgetDialogCancel => 'Annulla';

  @override
  String devicesForgotToast(String name) {
    return '$name rimosso da SKAPP';
  }

  @override
  String get devicesMobileNoDetailHint =>
      'Nessuna pagina di dettaglio per i telefoni · tieni premuto per scollegare';

  @override
  String get devicesDesktopStatLabel => 'desktop';

  @override
  String get devicesDesktopGroupLabel => 'Desktop abbinati';

  @override
  String get devicesDesktopTriggerDialogTitle => 'Inviare un comando SKAPI?';

  @override
  String devicesDesktopTriggerDialogBody(String name) {
    return 'Verranno eseguite tutte le associazioni mobile-touch su $name.';
  }

  @override
  String get devicesDesktopTriggerDialogConfirm => 'Invia comando';

  @override
  String get devicesDesktopTriggerDialogCancel => 'Annulla';

  @override
  String get devicesDesktopForgetDialogTitle => 'Scollega';

  @override
  String devicesDesktopForgetDialogBody(String name) {
    return 'Scollegamento di $name. Dovrai riabbinarlo per inviare di nuovo comandi a questo desktop.';
  }

  @override
  String devicesDesktopForgotToast(String name) {
    return '$name scollegato';
  }

  @override
  String get homeStatDevices => 'Dispositivi';

  @override
  String get homeStatOnline => 'Online';

  @override
  String get homeStatWarning => 'Avviso';

  @override
  String homeWarningMeta(String time) {
    return 'Abbinato ma mai visto · $time';
  }

  @override
  String get homeBrandTotal => 'Totale';

  @override
  String get homeBrandActive => 'Attivi';

  @override
  String get homeBrandActions => 'Azioni';

  @override
  String get homeBrandVersion => 'Versione';

  @override
  String get smartkraftSectionProducts => 'Prodotti';

  @override
  String get smartkraftSectionCommunity => 'Community';

  @override
  String get smartkraftStatusLive => 'LIVE';

  @override
  String get smartkraftStatusDev => 'IN SVILUPPO';

  @override
  String get smartkraftStatusConcept => 'CONCEPT';

  @override
  String get smartkraftBlockingFocusTagline =>
      'La pausa da cui non puoi sfuggire.';

  @override
  String get smartkraftLebensSpurTagline =>
      'Un testimone silenzioso delle tue abitudini.';

  @override
  String get smartkraftSynDimmTagline => 'La luce giusta all\'ora giusta.';

  @override
  String homeStickyDevicesMeta(int count, int warning) {
    return '$count dispositivi · $warning avvisi';
  }

  @override
  String homeStickySkapiMeta(int actions) {
    return '$actions azioni';
  }

  @override
  String homeStickySettingsMeta(String node, String version) {
    return '$node · v$version';
  }

  @override
  String get homeStickyComingSoonMeta => 'contenuti in corso';

  @override
  String get homeStickyNotesLabel => 'Note';

  @override
  String get setupChoiceTitle => 'Aggiungi dispositivo';

  @override
  String get setupChoiceQuestion => 'A che punto siamo?';

  @override
  String get setupChoiceSubtitle =>
      'Il dispositivo è appena uscito dalla scatola, o è già stato configurato via CLI?';

  @override
  String get setupChoiceFreshTitle => 'Configurazione iniziale';

  @override
  String get setupChoiceFreshBody =>
      'Sto aggiungendo per la prima volta un dispositivo SmartKraft nuovo di zecca. L\'abbinamento avverrà via BLE e si aprirà la procedura guidata di configurazione WiFi.';

  @override
  String get setupChoiceExistingTitle =>
      'Aggiungi un dispositivo già configurato';

  @override
  String get setupChoiceExistingBody =>
      'Ho configurato il WiFi del dispositivo via USB/CLI e sono sulla stessa rete. Abbina direttamente via WiFi e salta la procedura guidata.';

  @override
  String get setupChoiceFooter =>
      'Nel dubbio, scegli \"Configurazione iniziale\": è la strada giusta sia per il primo abbinamento sia per i dispositivi ripristinati di fabbrica.';

  @override
  String get wifiDiscoveryTitle => 'Dispositivi su questa rete';

  @override
  String wifiDiscoveryScanError(String error) {
    return 'Errore di scansione: $error';
  }

  @override
  String get wifiDiscoveryHint =>
      'Il dispositivo deve essere su WiFi e il telefono sulla stessa rete. Ti verrà chiesto di premere il pulsante del dispositivo durante l\'abbinamento.';

  @override
  String get wifiDiscoveryScanning => 'Scansione…';

  @override
  String get wifiDiscoveryNotFound => 'Nessun dispositivo trovato';

  @override
  String wifiDiscoveryFoundCount(int count) {
    return '$count dispositivi trovati';
  }

  @override
  String get wifiDiscoveryEmptyTitle =>
      'Ricerca di dispositivi SmartKraft su questa rete…';

  @override
  String get wifiDiscoveryEmptyTitleIdle => 'Nessun dispositivo trovato.';

  @override
  String get wifiDiscoveryEmptyHint =>
      'Assicurati che il dispositivo sia acceso, connesso al WiFi e sulla stessa rete del telefono. Usa il pulsante di aggiornamento per riprovare.';

  @override
  String get wifiDiscoveryPairedBadge => 'abbinato';

  @override
  String get wifiPairingTitle => 'Abbinamento';

  @override
  String wifiPairingConnectFailed(String error) {
    return 'Connessione non riuscita: $error';
  }

  @override
  String wifiPairingInvalidJson(String error) {
    return 'JSON non valido: $error';
  }

  @override
  String get wifiPairingClosedEarly => 'Connessione chiusa (nessuna risposta)';

  @override
  String wifiPairingSendFailed(String error) {
    return 'Impossibile inviare il comando: $error';
  }

  @override
  String get wifiPairingTimeout => 'Il dispositivo non ha risposto (timeout).';

  @override
  String get wifiPairingNotOpen =>
      'Finestra di abbinamento non aperta sul dispositivo. Premi brevemente il pulsante e riprova.';

  @override
  String get skapiBindFixedTriggerLabel => 'Trigger: allo scadere del timer';

  @override
  String get wifiPairingDeviceAlreadyBonded =>
      'Questo dispositivo è già abbinato a un altro SKAPP. L\'aggiunta di un nuovo peer via WiFi non è supportata dal firmware attuale (il TCP accetta solo il primo abbinamento). Usa l\'abbinamento BLE, oppure scollega il peer esistente dal dispositivo.';

  @override
  String wifiPairingRejected(String error) {
    return 'Dispositivo rifiutato: $error';
  }

  @override
  String get wifiPairingMissingPub =>
      'our_pub mancante/danneggiato dal dispositivo.';

  @override
  String wifiPairingHexError(String error) {
    return 'Decodifica hex di our_pub non riuscita: $error';
  }

  @override
  String get wifiPairingStageAwaiting => 'Premi il pulsante sul dispositivo';

  @override
  String get wifiPairingStageConnecting => 'Connessione al dispositivo…';

  @override
  String get wifiPairingStageExchanging => 'Scambio chiavi…';

  @override
  String get wifiPairingStageDone => 'Abbinamento completato';

  @override
  String get wifiPairingStageFailed => 'Abbinamento non riuscito';

  @override
  String get wifiPairingStageAwaitingHelp =>
      'Premi brevemente il pulsante di controllo del dispositivo (meno di 3 secondi). La finestra di abbinamento resta aperta per 60 secondi.';

  @override
  String get wifiPairingStageConnectingHelp => 'Apertura socket TCP.';

  @override
  String get wifiPairingStageExchangingHelp =>
      'pairing.ecdh.exchange inviato, in attesa della risposta del dispositivo.';

  @override
  String get wifiPairingStageDoneHelp =>
      'Apertura della dashboard del dispositivo.';

  @override
  String get wifiPairingStartCta => 'Abbina';

  @override
  String get bfDashboardTitleFallback => 'Dispositivo';

  @override
  String get bfDashboardWifiNone => 'Nessun WiFi';

  @override
  String get bfDashboardLinkBle => 'BLE';

  @override
  String get bfDashboardLinkWifi => 'WiFi';

  @override
  String get bfDashboardLinkUsb => 'USB';

  @override
  String get bfDashboardToggleVibration => 'Vibrazione';

  @override
  String get bfDashboardToggleTilt => 'Avviso inclinazione';

  @override
  String get bfDashboardToggleLowBatt => 'Avviso batteria scarica';

  @override
  String get bfDashboardApiChainTitle => 'Catena API';

  @override
  String bfDashboardApiChainNone(String state) {
    return 'ancora nessun endpoint · master $state';
  }

  @override
  String bfDashboardApiChainSummary(int count, String state) {
    return '$count endpoint · master $state';
  }

  @override
  String get bfDashboardMasterOn => 'attivo';

  @override
  String get bfDashboardMasterOff => 'disattivo';

  @override
  String get bfDashboardNotebookTitle => 'Blocco note utente';

  @override
  String get bfDashboardNotebookSubtitle =>
      'Area crittografata · 100 KB · contenuto libero';

  @override
  String get bfDashboardMoreDeviceInfo => 'Info dispositivo';

  @override
  String get bfDashboardMoreSettings => 'Impostazioni';

  @override
  String bfDashboardWriteFailed(String error) {
    return 'Impossibile scrivere: $error';
  }

  @override
  String get bfDeviceInfoTitle => 'Info dispositivo';

  @override
  String get bfDeviceInfoSectionGeneral => 'GENERALE';

  @override
  String get bfDeviceInfoSectionConnection => 'CONNESSIONE';

  @override
  String get bfDeviceInfoSectionBattery => 'BATTERIA';

  @override
  String get bfDeviceInfoSectionTime => 'ORA';

  @override
  String get bfDeviceInfoSectionLastError => 'ULTIMO ERRORE';

  @override
  String get bfDeviceInfoSectionDiagnostics => 'DIAGNOSTICA';

  @override
  String get bfDeviceInfoSectionDocs => 'DOCUMENTI';

  @override
  String get bfDeviceInfoProduct => 'Prodotto';

  @override
  String get bfDeviceInfoTypeCode => 'Codice tipo';

  @override
  String get bfDeviceInfoIdentity => 'Identità';

  @override
  String get bfDeviceInfoHardware => 'Hardware';

  @override
  String get bfDeviceInfoFirmware => 'Firmware';

  @override
  String get bfDeviceInfoProtocol => 'Protocollo';

  @override
  String get bfDeviceInfoBuild => 'Build';

  @override
  String get bfDeviceInfoUptime => 'Tempo di attività';

  @override
  String get bfDeviceInfoWifiState => 'Stato WiFi';

  @override
  String get bfDeviceInfoIp => 'IP';

  @override
  String get bfDeviceInfoSignal => 'Segnale';

  @override
  String get bfDeviceInfoBleAdvertising => 'Advertising BLE';

  @override
  String get bfDeviceInfoBlePaired => 'Abbinamenti BLE';

  @override
  String bfDeviceInfoPairedClients(int count) {
    return '$count client';
  }

  @override
  String get bfDeviceInfoBattery => 'Batteria';

  @override
  String get bfDeviceInfoBatteryPresent => 'presente';

  @override
  String get bfDeviceInfoBatteryAbsent => 'assente';

  @override
  String get bfDeviceInfoDeviceClock => 'Orologio dispositivo';

  @override
  String get bfDeviceInfoLogs => 'Registri dispositivo';

  @override
  String get bfDeviceInfoLogsSubtitle =>
      'logs.get, avvio, errori, timer, eventi API';

  @override
  String get bfDeviceInfoEvents => 'Cronologia eventi';

  @override
  String get bfDeviceInfoEventsSubtitle =>
      'Locale · timer, cambio faccia, trigger API';

  @override
  String get bfDeviceInfoUserGuide => 'Guida utente';

  @override
  String get bfDeviceInfoUserGuideSubtitle =>
      'Assegnazione facce, timer, trigger API';

  @override
  String get bfDeviceInfoDevNotes => 'Note sviluppatore SK';

  @override
  String get bfDeviceInfoDevNotesSubtitle =>
      'Comandi CLI, architettura, tassonomia eventi';

  @override
  String get bfDeviceInfoLicense => 'Licenza e fonti aperte';

  @override
  String get bfDeviceInfoLicenseSubtitle =>
      'Librerie usate e informazioni sul copyright';

  @override
  String get bfDeviceInfoComingSoon => 'In arrivo';

  @override
  String bfDeviceInfoUptimeSecs(int n) {
    return '$n s';
  }

  @override
  String bfDeviceInfoUptimeMins(int n) {
    return '$n min';
  }

  @override
  String bfDeviceInfoUptimeHours(int h, int m) {
    return '$h h $m min';
  }

  @override
  String bfDeviceInfoUptimeDays(int d, int h) {
    return '$d g $h h';
  }

  @override
  String get bfDeviceInfoYes => 'sì';

  @override
  String get bfDeviceInfoNo => 'no';

  @override
  String get bfSettingsTitle => 'Impostazioni';

  @override
  String get bfSettingsSectionNetwork => 'RETE';

  @override
  String get bfSettingsSectionUpdates => 'AGGIORNAMENTI';

  @override
  String get bfSettingsSectionDanger => 'ZONA PERICOLOSA';

  @override
  String get bfSettingsWifiPrimary => 'WiFi primario';

  @override
  String get bfSettingsWifiSecondary => 'WiFi di riserva';

  @override
  String get bfSettingsWifiUnconfigured => 'Non configurato';

  @override
  String get bfSettingsFirmware => 'Firmware';

  @override
  String get bfSettingsCheckUpdates => 'Verifica aggiornamenti';

  @override
  String get bfSettingsCheckUpdatesSubtitle =>
      'Si attiva una volta impostato un URL del manifest';

  @override
  String get bfOtaTitle => 'Aggiornamento firmware';

  @override
  String get bfOtaCurrentLabel => 'Versione installata';

  @override
  String get bfOtaRunningPartitionLabel => 'Partizione attiva';

  @override
  String get bfOtaCheckCta => 'Verifica aggiornamenti';

  @override
  String get bfOtaIdleHint =>
      'Nessuna verifica di aggiornamento ancora eseguita.';

  @override
  String get bfOtaChecking => 'Verifica del server di aggiornamento…';

  @override
  String get bfOtaUpToDate => 'Il dispositivo è aggiornato.';

  @override
  String bfOtaAvailable(String version) {
    return 'Nuova versione disponibile: $version';
  }

  @override
  String get bfOtaUpdateCta => 'Aggiorna ora';

  @override
  String bfOtaDownloading(int pct) {
    return 'Download… %$pct';
  }

  @override
  String get bfOtaDone => 'Aggiornato. Il dispositivo si sta riavviando…';

  @override
  String bfOtaErrorMsg(String message) {
    return 'Errore: $message';
  }

  @override
  String get bfOtaRollbackCta => 'Torna alla versione precedente';

  @override
  String get bfOtaUpdateConfirmTitle => 'Installare l\'aggiornamento firmware?';

  @override
  String bfOtaUpdateConfirmBody(String version) {
    return 'La versione $version verrà scaricata e installata, poi il dispositivo si riavvierà. Non spegnerlo durante l\'\'aggiornamento.';
  }

  @override
  String get bfOtaRollbackConfirmTitle => 'Tornare al firmware precedente?';

  @override
  String get bfOtaRollbackConfirmBody =>
      'Il dispositivo avvierà il firmware precedente e si riavvierà.';

  @override
  String get bfSettingsReboot => 'Riavvia dispositivo';

  @override
  String get bfSettingsRebootSubtitle =>
      'Spegne e riaccende il dispositivo · annulla qualsiasi timer attivo';

  @override
  String get bfSettingsRebootConfirmTitle => 'Riavviare il dispositivo?';

  @override
  String get bfSettingsRebootConfirmBody =>
      'Il dispositivo si spegnerà e si riaccenderà in pochi secondi.';

  @override
  String get bfSettingsUnpairThisPhone => 'Scollega questo telefono';

  @override
  String get bfSettingsUnpairSubtitle =>
      'Rimuove il bond · il dispositivo dovrà essere riabbinato';

  @override
  String get bfSettingsUnpairConfirmTitle => 'Scollegare questo telefono?';

  @override
  String get bfSettingsFactoryReset => 'Ripristino di fabbrica';

  @override
  String get bfSettingsFactoryResetSubtitle =>
      'Cancella WiFi, endpoint API e abbinamenti';

  @override
  String get bfSettingsFactoryResetConfirmTitle => 'Ripristino di fabbrica?';

  @override
  String get bfSettingsFactoryResetConfirmBody =>
      'Tutte le impostazioni verranno cancellate. Il dispositivo si riavvierà.';

  @override
  String get bfWifiManagementTitle => 'Gestione WiFi';

  @override
  String get bfWifiConnecting => 'Connessione…';

  @override
  String bfWifiConnectionRejected(String error) {
    return 'Connessione rifiutata: $error';
  }

  @override
  String bfWifiConfigure(String label) {
    return 'Configura $label';
  }

  @override
  String get bfWifiPasswordLabel => 'Password';

  @override
  String get bfNotebookTitle => 'Blocco note utente';

  @override
  String get bfNotebookSaveCancel => 'Annulla';

  @override
  String get bfApiChainCancel => 'Annulla';

  @override
  String get bfApiChainRunChain => 'Esegui catena';

  @override
  String get bfApiChainToggleAll => 'Attiva/disattiva tutto';

  @override
  String get bfApiChainFieldName => 'Nome';

  @override
  String get bfApiChainFieldType => 'Tipo';

  @override
  String get bfApiChainFieldHeaderName => 'Nome header';

  @override
  String get bfApiChainFieldNewToken =>
      'Nuovo token (lascia vuoto per mantenere)';

  @override
  String get bfHomeLoadingConnecting => 'Connessione al dispositivo…';

  @override
  String get bfHomeLoadingSecure => 'Apertura canale sicuro…';

  @override
  String get deviceConnUnreachableTitle =>
      'Impossibile raggiungere il dispositivo';

  @override
  String get deviceConnUnreachableBody =>
      'Il dispositivo potrebbe essere spento, fuori portata o in stand-by. Assicurati che sia acceso e vicino, poi riprova.';

  @override
  String get deviceConnRepairTitle => 'L\'abbinamento va rinnovato';

  @override
  String get deviceConnRepairBody =>
      'Sembra che il dispositivo sia stato reimpostato e non riconosca più questo telefono. Abbinalo di nuovo per riconnetterti.';

  @override
  String get deviceConnRepairButton => 'Abbina di nuovo';

  @override
  String get deviceConnTechnicalDetails => 'Dettagli tecnici';

  @override
  String get bfLogsTitle => 'Registri dispositivo';

  @override
  String get bfEventsTitle => 'Cronologia eventi';

  @override
  String get pairingStepConnecting => 'Connessione';

  @override
  String get pairingStepConnectingSubtitle =>
      'Collegamento BLE + scoperta GATT';

  @override
  String get pairingStepMutualAuth => 'Autenticazione reciproca';

  @override
  String get pairingStepDeviceInfo => 'Verifica device.info';

  @override
  String get pairingStepDeviceInfoSubtitle =>
      'Canale crittografato attivo, ping di controllo';

  @override
  String get pairingStepConnected => 'Connessione stabilita';

  @override
  String get pairingStepConnectedSubtitle =>
      'CLI pronta, passaggio alla configurazione';

  @override
  String get pairingStepKeyExchange => 'Scambio chiavi';

  @override
  String get pairingStepKeyExchangeSubtitle =>
      'X25519, chiave pubblica inviata';

  @override
  String get pairingStepVerifying => 'Verifica';

  @override
  String get pairingStepVerifyingSubtitle =>
      'In attesa del dispositivo, derivazione token';

  @override
  String get pairingStepDone => 'Abbinamento completato';

  @override
  String get pairingStepDoneSubtitle =>
      'Bond memorizzato su dispositivo e telefono';

  @override
  String get pairingLogTitle => 'Registro abbinamento';

  @override
  String get pairingLogCopied => 'Registro copiato negli appunti';

  @override
  String get discoveryPreparing => 'Preparazione…';

  @override
  String get discoveryBluetoothOff => 'Il Bluetooth è disattivato';

  @override
  String get wifiPasswordTitle => 'Connetti il dispositivo al WiFi';

  @override
  String get wifiPasswordSsidLabel => 'Nome rete (SSID)';

  @override
  String get wifiPasswordNetworkLabel => 'Rete';

  @override
  String get wifiPasswordPasswordLabel => 'Password';

  @override
  String get wifiPasswordConnect => 'Connetti';

  @override
  String get wifiPasswordLogTitle => 'Registro connessione';

  @override
  String get wifiPasswordLogCopied => 'Registro copiato negli appunti';

  @override
  String get wifiScanTitle => 'Scegli una rete WiFi per il dispositivo';

  @override
  String get wifiScanRescanTooltip =>
      'Chiedi al dispositivo di eseguire di nuovo la scansione';

  @override
  String get wifiScanRunning =>
      'Lo scanner WiFi del dispositivo è in esecuzione…';

  @override
  String get wifiScanNoNetworks =>
      'Il dispositivo non ha trovato reti WiFi nelle vicinanze.';

  @override
  String get wifiScanRescan =>
      'Chiedi al dispositivo di eseguire di nuovo la scansione';

  @override
  String get wifiScanHiddenAdd => 'Aggiungi rete nascosta';

  @override
  String get wifiScanHiddenSubtitle => 'Digita l\'SSID a mano';

  @override
  String get wifiScanLogTitle => 'Registro scansione WiFi';

  @override
  String get wifiSuccessReady => 'Fatto';

  @override
  String get bfEventsClearTooltip => 'Cancella';

  @override
  String get bfEventsEmpty =>
      'Ancora nessun evento. Appariranno qui non appena il dispositivo inizierà a pubblicarli.';

  @override
  String get logsEmptyTooltip => 'Il registro è vuoto.';

  @override
  String logsErrorPrefix(String error) {
    return 'Errore: $error';
  }

  @override
  String get notebookSaved => 'Salvato';

  @override
  String notebookSaveError(String error) {
    return 'Errore: $error';
  }

  @override
  String notebookCapacityExceeded(int used, int capacity) {
    return 'Capacità superata: $used / $capacity byte';
  }

  @override
  String get notebookClearTooltip => 'Svuota blocco note';

  @override
  String get notebookClearConfirmTitle => 'Svuotare l\'intero blocco note?';

  @override
  String get notebookClearConfirmBody =>
      'Tutti i dati utente sul dispositivo verranno cancellati. Non può essere annullato.';

  @override
  String get notebookClearAction => 'Svuota';

  @override
  String get notebookClearedSnack => 'Blocco note svuotato';

  @override
  String notebookClearError(String error) {
    return 'Impossibile svuotare: $error';
  }

  @override
  String get notebookEncryptedHint =>
      'Area crittografata · solo il SKAPP abbinato può leggerla';

  @override
  String get notebookEmptyTitle => 'Il blocco note è vuoto';

  @override
  String get notebookEmptyBody =>
      'Digita note, JSON, definizioni di scena o qualsiasi altro testo qui sotto. Toccando Salva viene memorizzato crittografato sul dispositivo.';

  @override
  String get notebookHint =>
      'Scrivi qui quello che vuoi (note, JSON, il tuo schema). Fino a 100 KB memorizzati sul dispositivo.';

  @override
  String get notebookDirty => 'Modifiche non salvate';

  @override
  String get notebookSaved2 => 'Salvato';

  @override
  String get notebookSyncedDifferent => 'Sincronizzato';

  @override
  String get notebookSaveCta => 'Salva';

  @override
  String wifiPairingHexErrorRaw(String error) {
    return 'Decodifica hex di our_pub non riuscita: $error';
  }

  @override
  String get bfWifiForgetTitle => 'Dimenticare lo slot?';

  @override
  String get bfWifiForgetBody =>
      'Lo slot verrà cancellato. Se il dispositivo è attualmente connesso qui, ripiegherà sull\'altro slot (se presente). Per ripristinarlo è necessaria una riconfigurazione.';

  @override
  String get bfWifiForget => 'Dimentica';

  @override
  String get bfWifiHint =>
      'Il dispositivo prova le due reti in ordine: prima la Primaria, la Riserva se fallisce. Lo slot attivo è contrassegnato con un punto verde.';

  @override
  String get bfWifiActive => 'ATTIVO';

  @override
  String get bfWifiNotConfigured => 'Non configurato';

  @override
  String get bfWifiChange => 'Cambia';

  @override
  String get bfWifiSetUp => 'Configura';

  @override
  String get discoveryStatusChecking => 'Verifica dello stato del Bluetooth.';

  @override
  String get discoveryPermissionsTitle => 'Permesso Bluetooth richiesto';

  @override
  String get discoveryPermissionsBody =>
      'Per trovare i dispositivi SmartKraft nelle vicinanze, abilita il permesso Bluetooth.';

  @override
  String get discoveryPermissionsRetry => 'Richiedi di nuovo i permessi';

  @override
  String get discoveryPermissionsOpenSettings => 'Apri impostazioni';

  @override
  String get discoveryAdapterOffBody =>
      'Attiva il Bluetooth per cercare i dispositivi.';

  @override
  String get discoveryAdapterOffEnable => 'Attiva il Bluetooth';

  @override
  String get discoveryUnsupportedTitle => 'BLE non supportato';

  @override
  String get discoveryUnsupportedBody =>
      'Questo dispositivo non supporta il Bluetooth Low Energy, SKAPP necessita di BLE per funzionare.';

  @override
  String get wifiPasswordHelp =>
      'Il dispositivo si unirà a questa rete. Inserisci la password, digitala con attenzione.';

  @override
  String get wifiPasswordRequired => 'La password è obbligatoria';

  @override
  String get wifiPasswordMinLength => 'Almeno 8 caratteri';

  @override
  String wifiPasswordSendError(String error) {
    return 'Impossibile inviare: $error';
  }

  @override
  String get wifiScanTimeoutHint =>
      'Se la scansione richiede troppo tempo, il dispositivo potrebbe aver perso la copertura WiFi. Tocca riprova.';

  @override
  String get wifiScanFailedTitle => 'Scansione non riuscita';

  @override
  String get wifiScanRetry => 'Riprova';

  @override
  String get wifiSuccessTitle => 'Connesso';

  @override
  String get wifiSuccessBody =>
      'Il dispositivo ora è sul WiFi. Ritorno alla dashboard…';

  @override
  String get deviceNameSectionHeading =>
      'NOME DISPOSITIVO (SOLO IN QUESTA APP)';

  @override
  String get deviceNameLabel => 'Nome personalizzato';

  @override
  String get deviceNameHint => 'es. BF ufficio';

  @override
  String get deviceNameSubtitle =>
      'Mostrato sulle schede di questa installazione di SKAPP. Non inviato al dispositivo.';

  @override
  String get deviceNameClear => 'Cancella';

  @override
  String get deviceNameSave => 'Salva';

  @override
  String get deviceNameSaved => 'Salvato';

  @override
  String get deviceNameEmptyPlaceholder => '(nessun nome personalizzato)';

  @override
  String get settingsUsbConsoleTitle => 'Console CLI USB';

  @override
  String get settingsUsbConsoleSubtitle =>
      'Invia comandi grezzi a un dispositivo collegato via USB';

  @override
  String get usbConsoleAppBarTitle => 'Console USB';

  @override
  String get usbConsolePickPortTitle => 'Seleziona una porta';

  @override
  String get usbConsolePickPortHint =>
      'Collega un dispositivo SmartKraft via USB e tocca aggiorna';

  @override
  String get usbConsolePortRefreshTooltip => 'Aggiorna porte';

  @override
  String get usbConsoleBfBadge => 'SmartKraft';

  @override
  String get usbConsoleConnecting => 'Connessione…';

  @override
  String get usbConsoleConnected => 'Connesso';

  @override
  String get usbConsoleDisconnected => 'Disconnesso';

  @override
  String usbConsoleErrorBanner(String error) {
    return 'Errore: $error';
  }

  @override
  String get usbConsoleReconnect => 'Riconnetti';

  @override
  String get usbConsoleDisconnect => 'Disconnetti';

  @override
  String get usbConsoleClear => 'Svuota console';

  @override
  String get usbConsoleInputHint => 'Digita un comando, es. device.info';

  @override
  String get usbConsoleSend => 'Invia';

  @override
  String get usbConsoleEmptyHint =>
      'Digita un comando e premi Invio, prova device.info';

  @override
  String get usbConsoleEntryEvent => 'evt';

  @override
  String get usbConsoleEntryError => 'errore';

  @override
  String get usbConsoleNotSupportedIos =>
      'La console USB non è supportata su iOS';

  @override
  String get passphraseFieldLabel => 'Passphrase';

  @override
  String get passphraseVerifyButton => 'Verifica';

  @override
  String passphraseAttemptsLeft(int count) {
    return 'Tentativi rimasti: $count';
  }

  @override
  String get passphraseLockoutTriggered =>
      'Troppi tentativi di passphrase errati; il dispositivo si è ripristinato di fabbrica.';

  @override
  String get bondPeerUnnamed => '(senza nome)';

  @override
  String get pairingPassphraseDialogTitle => 'Passphrase dispositivo';

  @override
  String get pairingPassphraseDialogBody =>
      'Questo dispositivo richiede una passphrase per l\'accesso ai contenuti. Inseriscila per completare l\'abbinamento.';

  @override
  String get pairingPassphraseCancelled =>
      'Passphrase non inserita, abbinamento annullato.';

  @override
  String pairingPassphraseSendError(String error) {
    return 'Impossibile inviare la passphrase: $error';
  }

  @override
  String get pairingPassphraseTimeout =>
      'Il dispositivo non ha risposto (verifica passphrase, 8 s).';

  @override
  String get pairingWindowClosedRetry =>
      'Finestra di abbinamento chiusa, premi brevemente il pulsante e riprova.';

  @override
  String pairingPassphraseFailed(String error) {
    return 'Impossibile verificare la passphrase: $error';
  }

  @override
  String get bondStoreFullHeader =>
      'Tutti gli 8 slot di bond sono pieni. Rimuovi un peer esistente per abbinare un nuovo SKAPP:';

  @override
  String bondStoreFullPeerLine(Object slot, String name, String shortPid) {
    return '  • slot $slot, $name [#$shortPid]';
  }

  @override
  String get bondStoreFullFooter =>
      'Da un altro SKAPP abbinato o via USB, esegui\n`bond.remove --slot N`, poi tocca Riprova qui.';

  @override
  String get passphraseGateDialogBody =>
      'Questo dispositivo richiede la passphrase a ogni connessione. Inseriscila per accedere ai contenuti.';

  @override
  String get passphraseGateCancelled =>
      'Passphrase non inserita, la verifica è necessaria per accedere a questa schermata.';

  @override
  String passphraseGateVerifyError(String error) {
    return 'Errore di verifica: $error';
  }

  @override
  String passphraseGateCommError(String error) {
    return 'Errore di comunicazione: $error';
  }

  @override
  String get passphraseGateUnknownError => 'Errore di blocco sconosciuto.';

  @override
  String get bfPassphraseTitle => 'Passphrase dispositivo';

  @override
  String get bfPassphraseSetTitle => 'Imposta passphrase';

  @override
  String get bfPassphraseChangeTitle => 'Cambia passphrase';

  @override
  String get bfPassphraseClearTitle => 'Rimuovi passphrase';

  @override
  String get bfPassphraseChangeSubtitle =>
      'Inserisci la vecchia passphrase, imposta la nuova';

  @override
  String get bfPassphraseClearSubtitle =>
      'Reimposta il blocco contenuti sul dispositivo';

  @override
  String get bfPassphraseModePairing => 'Richiedi durante l\'abbinamento';

  @override
  String get bfPassphraseModePairingSubtitle =>
      'Richiesta quando un nuovo SKAPP si abbina. Ai peer esistenti non viene chiesta.';

  @override
  String get bfPassphraseModeAlways => 'Richiedi a ogni connessione';

  @override
  String get bfPassphraseModeAlwaysSubtitle =>
      'Richiesta ogni volta che si apre una sessione. I contenuti restano bloccati anche se un SKAPP viene rubato.';

  @override
  String get bfPassphraseStatusNone =>
      'Nessuna passphrase, il dispositivo non ha alcun blocco contenuti';

  @override
  String get bfPassphraseStatusActiveOff =>
      'Passphrase impostata · applicazione disattivata (entrambi gli interruttori off)';

  @override
  String get bfPassphraseStatusActivePairing =>
      'Richiesta durante l\'abbinamento';

  @override
  String get bfPassphraseStatusActiveAlways => 'Richiesta a ogni connessione';

  @override
  String get bfPassphraseBadgeActive => 'Passphrase attiva';

  @override
  String get bfPassphraseBadgeNone => 'Nessuna passphrase';

  @override
  String bfPassphraseAttemptsRatio(int left, int total) {
    return 'Tentativi rimasti: $left / $total';
  }

  @override
  String bfPassphraseLengthSubtitle(int min, int max) {
    return 'Lunghezza $min-$max caratteri';
  }

  @override
  String bfPassphraseLengthHint(int min, int max) {
    return 'Lunghezza: $min-$max';
  }

  @override
  String bfPassphraseTooShort(int min) {
    return 'Almeno $min caratteri';
  }

  @override
  String bfPassphraseTooLong(int max) {
    return 'Al massimo $max caratteri';
  }

  @override
  String get bfPassphraseEmpty => 'Non può essere vuota';

  @override
  String get bfPassphraseNewLabel => 'Nuova passphrase';

  @override
  String get bfPassphraseCurrentLabel => 'Passphrase attuale';

  @override
  String get bfPassphraseSetDone => 'Passphrase impostata';

  @override
  String get bfPassphraseChangeDone => 'Passphrase cambiata';

  @override
  String get bfPassphraseClearDone => 'Passphrase rimossa';

  @override
  String bfPassphraseStatusReadError(String error) {
    return 'Impossibile leggere lo stato: $error';
  }

  @override
  String get bfPassphraseNotesTitle => 'Note';

  @override
  String get bfPassphraseNotesBody =>
      '• La passphrase è sottoposta ad hashing sul dispositivo con PBKDF2-SHA256; non viene mai memorizzata in chiaro.\n• 10 tentativi errati ripristinano il dispositivo di fabbrica; tutti i bond e i dati vengono cancellati.\n• Un dispositivo collegato via USB salta la richiesta della passphrase, poiché l\'accesso fisico consente già il ripristino di fabbrica tramite il pulsante.';

  @override
  String bfBondListTitle(int used, int capacity) {
    return 'SKAPP abbinati  ($used/$capacity)';
  }

  @override
  String get bfBondListEmpty => 'Ancora nessun peer abbinato.';

  @override
  String get bfBondListBadgeThisPhone => 'Questo telefono';

  @override
  String get bfBondListBadgeActiveSession => 'Sessione attiva';

  @override
  String bfBondListRowSubtitle(String shortPid, String date) {
    return '#$shortPid · abbinato: $date';
  }

  @override
  String get bfBondListRemoveTooltip => 'Rimuovi questo peer';

  @override
  String get bfBondListRemoveTitle => 'Rimuovere il peer?';

  @override
  String get bfBondListRemoveSelfBody =>
      'Stai rimuovendo il bond di questo telefono. Se confermi, la sessione cade; per raggiungere di nuovo il dispositivo dovrai premere brevemente il pulsante e riabbinare.';

  @override
  String bfBondListRemoveOtherBody(String label, int slot) {
    return '\"$label\" (slot $slot) viene cancellato dal dispositivo. Quel SKAPP dovrà premere brevemente il pulsante e riabbinare per riconnettersi.';
  }

  @override
  String bfBondListSlotRemoved(int slot) {
    return 'Slot $slot rimosso';
  }

  @override
  String bfBondListFetchError(String error) {
    return 'bond.list non riuscito: $error';
  }

  @override
  String get bfSettingsSectionSecurity => 'SICUREZZA';

  @override
  String get bfSettingsPassphraseTitle => 'Passphrase dispositivo';

  @override
  String get bfSettingsBondListTitle => 'SKAPP abbinati';

  @override
  String get bfSettingsPassphraseSubtitleAlways => 'Attiva, ogni connessione';

  @override
  String get bfSettingsPassphraseSubtitlePairing => 'Attiva, all\'abbinamento';

  @override
  String get bfSettingsPassphraseSubtitleOff =>
      'Attiva, applicazione disattivata';

  @override
  String bfSettingsBondsSubtitle(int count, int capacity) {
    return 'Peer abbinati: $count / $capacity';
  }

  @override
  String get skapiHowItWorksTitle => 'Come funziona';

  @override
  String skapiHowItWorksBody(String deviceName) {
    return 'Quando il tuo dispositivo SmartKraft (per esempio $deviceName) registra un evento come la fine di un timer, la pressione di un pulsante o l\'\'attivazione di un sensore, invia un piccolo comando al tuo computer. Il computer riceve quel comando ed esegue lo script che hai scelto.';
  }

  @override
  String get skapiHowItWorksFlowDeviceLabel => 'Dispositivo SmartKraft';

  @override
  String get skapiHowItWorksFlowDeviceSub =>
      'es. Blocking Focus, attiva un evento';

  @override
  String get skapiHowItWorksFlowComputerLabel => 'Computer';

  @override
  String get skapiHowItWorksFlowComputerSub =>
      'SKAPP riceve il comando, lo script viene eseguito';

  @override
  String get skapiHowItWorksFoot =>
      'SKAPP deve essere in esecuzione sul tuo computer. Tutto il traffico resta sulla rete WiFi, non è richiesta alcuna connessione a internet e nessun dato lascia casa tua.';

  @override
  String get skapiPlatformGroupsHeader => 'Categorie di azioni';

  @override
  String skapiPlatformGroupsLoadError(String error) {
    return 'Caricamento dei gruppi non riuscito: $error';
  }

  @override
  String get skapiPlatformEmptyTitle => 'Ancora nessuno script qui';

  @override
  String get skapiPlatformEmptyBody =>
      'Gli script per questa piattaforma sono ancora in arrivo. Ricontrolla dopo il prossimo aggiornamento di SKAPP.';

  @override
  String skapiGroupScriptsLoadError(String error) {
    return 'Caricamento degli script non riuscito: $error';
  }

  @override
  String skapiScriptDetailLoadError(String error) {
    return 'Impossibile caricare questo script: $error';
  }

  @override
  String get skapiBindScreenTitle => 'Associa ad azione';

  @override
  String get skapiBindScreenSubtitle =>
      'Esegui questo script automaticamente quando si verifica un evento del dispositivo.';

  @override
  String get skapiBindFieldDeviceLabel => 'Dispositivo';

  @override
  String get skapiBindFieldDeviceHint =>
      'Scegli quale dispositivo abbinato deve attivare questo script.';

  @override
  String get skapiBindFieldDeviceEmpty =>
      'Ancora nessun dispositivo abbinato. Abbinane uno dalla scheda Dispositivi.';

  @override
  String get skapiBindFieldEventLabel => 'Evento';

  @override
  String get skapiBindFieldEventHint =>
      'Il dispositivo emette questo evento; lo script viene eseguito quando ciò accade.';

  @override
  String get skapiBindEventTimerStarted => 'Timer avviato';

  @override
  String get skapiBindEventTimerExpired => 'Timer scaduto';

  @override
  String get skapiBindEventFaceChanged => 'Faccia del cubo cambiata';

  @override
  String get skapiBindEventButtonPressed => 'Pulsante premuto';

  @override
  String get skapiBindEventButtonHeld => 'Pulsante tenuto premuto';

  @override
  String get skapiBindEventBatteryLow => 'Batteria scarica';

  @override
  String get skapiBindEventBatteryLockout => 'Blocco per batteria';

  @override
  String get skapiBindEventPowerStateChanged => 'Stato alimentazione cambiato';

  @override
  String get skapiBindEventPairingSuccess => 'Abbinamento riuscito';

  @override
  String get skapiBindEventApiSent => 'Chiamata API inviata';

  @override
  String get skapiBindParamsHeader => 'Sovrascritture parametri';

  @override
  String get skapiBindParamsHint =>
      'Lascia vuoto per mantenere i valori predefiniti dello script. Questi valori vengono inviati ogni volta che si attiva l\'associazione.';

  @override
  String get skapiBindButtonSave => 'Salva associazione';

  @override
  String get skapiBindButtonDelete => 'Elimina associazione';

  @override
  String get skapiBindButtonCancel => 'Annulla';

  @override
  String get skapiBindButtonEnable => 'Attiva';

  @override
  String get skapiBindButtonDisable => 'Disattiva';

  @override
  String get skapiBindStatusEnabled => 'Attiva';

  @override
  String get skapiBindStatusDisabled => 'In pausa';

  @override
  String get skapiBindSavedToast => 'Associazione salvata';

  @override
  String get skapiBindDeletedToast => 'Associazione rimossa';

  @override
  String skapiBindBadgeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count associazioni',
      one: '1 associazione',
    );
    return '$_temp0';
  }

  @override
  String get skapiBindNoPairedDeviceWarning =>
      'Abbina prima un dispositivo per creare associazioni.';

  @override
  String skapiBindTriggeredDesktopToast(String script) {
    return 'Attivato: $script';
  }

  @override
  String skapiBindTriggeredMobileToast(String event) {
    return 'Associazione attivata ($event); l\'\'esecuzione arriva nella Fase K.';
  }

  @override
  String skapiBindLoadError(String error) {
    return 'Impossibile caricare le associazioni: $error';
  }

  @override
  String get skapiBindListSectionTitle => 'Associazioni su questo script';

  @override
  String get skapiBindListEmpty =>
      'Ancora nessuna associazione. Tocca Associa ad azione per crearne una.';

  @override
  String get skapiBindNewButton => 'Nuova associazione';

  @override
  String get skapiBasicSettingsTitle => 'Impostazioni';

  @override
  String get skapiBasicEmptyParams =>
      'Questo script non richiede impostazioni. Tocca Esegui ora.';

  @override
  String get skapiBasicUnitSeconds => 'secondi';

  @override
  String get skapiBasicConvHalfMinute => 'mezzo minuto';

  @override
  String get skapiBasicConvLessThanMinute => 'meno di un minuto';

  @override
  String skapiBasicConvMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuti',
      one: '1 minuto',
    );
    return '$_temp0';
  }

  @override
  String skapiBasicConvHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String skapiBasicConvHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ore',
      one: '1 ora',
    );
    return '$_temp0';
  }

  @override
  String get skapiBasicConvImmediate => 'inizia immediatamente';

  @override
  String skapiBasicConvAfter(String time) {
    return 'dopo $time';
  }

  @override
  String get skapiBasicPrerunSectionTitle => 'Ritardo pre-esecuzione';

  @override
  String get skapiBasicPrerunAddCta =>
      'Aggiungi ritardo prima dell\'esecuzione';

  @override
  String get skapiBasicPrerunLabel =>
      'Attendi questo numero di secondi prima dell\'avvio dello script';

  @override
  String get skapiBasicPrerunHelp =>
      'Utile per far apparire prima una notifica, o per concatenare azioni. Il valore predefinito 0 significa avvio immediato.';

  @override
  String get skapiBasicPrerunRemove => 'Rimuovi ritardo';

  @override
  String get skapiBasicListAddPlaceholder => '+ aggiungi';

  @override
  String get skapiRunSheetTitle => 'Esegui script';

  @override
  String get skapiRunSheetStatusRunning => 'In esecuzione';

  @override
  String get skapiRunSheetStatusOk => 'Fatto';

  @override
  String get skapiRunSheetStatusError => 'Non riuscito';

  @override
  String skapiRunSheetExitCode(int code) {
    return 'Codice di uscita: $code';
  }

  @override
  String get skapiRunSheetCancel => 'Annulla';

  @override
  String get skapiRunSheetClose => 'Chiudi';

  @override
  String get skapiRunSheetCopyOutput => 'Copia output';

  @override
  String get skapiRunSheetCopiedDone => 'Copiato';

  @override
  String get skapiRunSheetEmptyOutput => 'In attesa dell\'output...';

  @override
  String get skapiRunSheetDismissConfirmTitle =>
      'Interrompere l\'esecuzione dello script?';

  @override
  String get skapiRunSheetDismissConfirmBody =>
      'Lo script è ancora in esecuzione. Chiudendo questo pannello verrà annullato.';

  @override
  String get skapiRunSheetDismissConfirmStay => 'Continua l\'esecuzione';

  @override
  String get skapiRunSheetDismissConfirmStop => 'Annulla';

  @override
  String get skapiRunErrorPowerShellMissing =>
      'PowerShell non è stato trovato su questo sistema.';

  @override
  String skapiRunErrorTempWrite(String error) {
    return 'Impossibile scrivere lo script nella cartella temporanea: $error';
  }

  @override
  String skapiRunErrorSpawn(String error) {
    return 'Impossibile avviare PowerShell: $error';
  }

  @override
  String skapiRunDurationMs(int ms) {
    return 'Durata $ms ms';
  }

  @override
  String get skapiCopiedToClipboard => 'Copiato';

  @override
  String get skapiFavouriteAddTooltip => 'Aggiungi ai preferiti';

  @override
  String get skapiFavouriteRemoveTooltip => 'Rimuovi dai preferiti';

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
  String get skapiPlatformScreenCategoriesTitle => 'Categorie di azioni';

  @override
  String skapiPlatformScreenCategoriesSub(int groups, int scripts) {
    return '$groups gruppi · $scripts script in totale';
  }

  @override
  String get skapiGroupScriptsHeader => 'Script';

  @override
  String skapiGroupScriptsCount(int count) {
    return '$count script';
  }

  @override
  String skapiGroupItemCount(int count) {
    return '$count script';
  }

  @override
  String get skapiGroupPowerTitle => 'Gestione alimentazione';

  @override
  String get skapiGroupPowerDesc =>
      'Gli script di questo gruppo bloccano, sospendono, ibernano o spengono il computer. Sono utili quando un dispositivo SmartKraft segnala la fine di una sessione di concentrazione o rileva un\'inattività prolungata e vuoi che la macchina faccia altrettanto.';

  @override
  String get skapiGroupPowerFoot =>
      'Uso tipico: blocco quando ti alzi, ibernazione a fine giornata, spegnimento programmato dopo un lungo periodo di inattività.';

  @override
  String get skapiScriptLockTitle => 'Blocca postazione';

  @override
  String get skapiScriptLockSummaryWhat =>
      'Blocca subito Windows e torna alla schermata di accesso. Le app aperte continuano a funzionare.';

  @override
  String get skapiScriptLockSummaryHow =>
      'Chiama la funzione Win32 LockWorkStation di user32. Equivale a premere Win+L.';

  @override
  String get skapiScriptHibernateTitle => 'Iberna';

  @override
  String get skapiScriptHibernateSummaryWhat =>
      'Salva la sessione corrente su disco e spegne la macchina. Alla ripresa torna esattamente dove eri, anche senza batteria.';

  @override
  String get skapiScriptHibernateSummaryHow =>
      'Esegue lo shutdown.exe integrato con il flag /h. L\'ibernazione deve essere abilitata nelle impostazioni di alimentazione di Windows; in caso contrario, Windows ripiega sulla sospensione.';

  @override
  String get skapiScriptHibernateNote =>
      'Esegui powercfg /hibernate on una volta da una shell amministratore se l\'ibernazione manca sul tuo sistema.';

  @override
  String get skapiScriptHibernateParamDelayLabel => 'ritardo';

  @override
  String get skapiScriptHibernateParamDelayHint =>
      'Secondi di attesa prima dell\'ibernazione, nel caso debba apparire prima la notifica del dispositivo.';

  @override
  String get skapiScriptSleepTitle => 'Sospendi';

  @override
  String get skapiScriptSleepSummaryWhat =>
      'Sospende la macchina sulla RAM (S3). La ripresa è veloce ma consuma un po\' di batteria durante la sospensione.';

  @override
  String get skapiScriptSleepSummaryHow =>
      'Chiama System.Windows.Forms.Application.SetSuspendState con PowerState.Suspend. Il sistema operativo può ritardare se un processo in primo piano blocca le transizioni in standby.';

  @override
  String get skapiScriptSleepParamDelayLabel => 'ritardo';

  @override
  String get skapiScriptSleepParamDelayHint =>
      'Secondi di attesa prima della sospensione.';

  @override
  String get skapiScriptShutdownTitle => 'Spegni';

  @override
  String get skapiScriptShutdownSummaryWhat =>
      'Avvia uno spegnimento ordinato di Windows. Alle app aperte viene chiesto di salvare e chiudere.';

  @override
  String get skapiScriptShutdownSummaryHow =>
      'Esegue lo shutdown.exe /s integrato. Con il forzamento abilitato, viene aggiunto /f così le app che non rispondono vengono terminate.';

  @override
  String get skapiScriptShutdownNote =>
      'Un ritardo diverso da zero dà all\'utente il tempo di annullare con shutdown /a da un terminale.';

  @override
  String get skapiScriptShutdownParamDelayLabel => 'ritardo';

  @override
  String get skapiScriptShutdownParamDelayHint =>
      'Secondi che Windows attende prima di spegnersi. 30 è il valore predefinito; scegli 0 per lo spegnimento immediato.';

  @override
  String get skapiScriptShutdownParamForceLabel => 'forza';

  @override
  String get skapiScriptShutdownParamForceHint =>
      'Chiude le app che non rispondono al segnale di spegnimento. Il lavoro non salvato in quelle app potrebbe andare perso.';

  @override
  String get skapiGroupDisplayAudioTitle => 'Schermo, immagine e suono';

  @override
  String get skapiGroupDisplayAudioDesc =>
      'Gli script di questo gruppo regolano lo schermo e l\'uscita audio: luminosità, volume, muto e riproduzione multimediale. Sono utili quando un dispositivo SmartKraft vuole che il computer si attenui durante una pausa di concentrazione o metta in pausa la musica quando ti alzi.';

  @override
  String get skapiGroupDisplayAudioFoot =>
      'Uso tipico: attenuare lo schermo durante una pausa, muto al blocco, mettere in pausa Spotify quando un dispositivo non rileva attività.';

  @override
  String get skapiScriptBrightnessTitle => 'Imposta luminosità';

  @override
  String get skapiScriptBrightnessSummaryWhat =>
      'Imposta la luminosità del display interno a una percentuale tra 0 e 100.';

  @override
  String get skapiScriptBrightnessSummaryHow =>
      'Chiama WmiMonitorBrightnessMethods.WmiSetBrightness di WMI con il livello richiesto. Rispondono solo laptop, tablet e pannelli integrati; i monitor esterni DDC/CI non sono supportati su questo percorso.';

  @override
  String get skapiScriptBrightnessNote =>
      'I monitor esterni non cambieranno. Nelle configurazioni multi-monitor, reagisce solo il pannello che segnala la luminosità tramite WMI.';

  @override
  String get skapiScriptBrightnessParamLevelLabel => 'livello';

  @override
  String get skapiScriptBrightnessParamLevelHint =>
      'Percentuale di luminosità (0-100). Valori più bassi sono più scuri. 70 è un valore predefinito confortevole con illuminazione normale.';

  @override
  String get skapiScriptBrightnessParamTimeoutLabel => 'timeout';

  @override
  String get skapiScriptBrightnessParamTimeoutHint =>
      'Secondi consentiti per il cambio di luminosità. Il sistema operativo effettua una transizione graduale entro questo intervallo.';

  @override
  String get skapiScriptMuteToggleTitle => 'Attiva/disattiva muto';

  @override
  String get skapiScriptMuteToggleSummaryWhat =>
      'Attiva o disattiva il muto generale del sistema. I contenuti multimediali attivi continuano a riprodursi ma non li senti.';

  @override
  String get skapiScriptMuteToggleSummaryHow =>
      'Invia il tasto virtuale VK_VOLUME_MUTE, lo stesso percorso che Windows usa quando l\'utente preme il tasto muto sulla tastiera. Nessuna dipendenza da admin o COM.';

  @override
  String get skapiScriptMuteToggleParamModeLabel => 'modalità';

  @override
  String get skapiScriptMuteToggleParamModeHint =>
      'toggle / on / off. Solo toggle è applicato tramite la semplice pressione del tasto; on e off sono accettati per compatibilità futura.';

  @override
  String get skapiScriptVolumeSetTitle => 'Imposta volume';

  @override
  String get skapiScriptVolumeSetSummaryWhat =>
      'Imposta il volume generale del sistema a un livello preciso tra 0 e 100.';

  @override
  String get skapiScriptVolumeSetSummaryHow =>
      'Chiama IAudioEndpointVolume.SetMasterVolumeLevelScalar di Core Audio tramite interop COM C# inline. Punta all\'endpoint di rendering predefinito.';

  @override
  String get skapiScriptVolumeSetNote =>
      'Livello 2: funziona sui desktop Windows 10/11 standard. Le installazioni ridotte potrebbero non esporre l\'interfaccia COM; gli endpoint per app non sono gestiti da questo percorso.';

  @override
  String get skapiScriptVolumeSetParamLevelLabel => 'livello';

  @override
  String get skapiScriptVolumeSetParamLevelHint =>
      'Percentuale di volume (0-100). 0 silenzia senza attivare il muto; 50 è un valore predefinito confortevole.';

  @override
  String get skapiScriptMediaKeyTitle => 'Tasto multimediale';

  @override
  String get skapiScriptMediaKeySummaryWhat =>
      'Simula la pressione di un tasto multimediale: play-pausa, successivo, precedente o stop. Va a qualunque app possieda attualmente la sessione multimediale.';

  @override
  String get skapiScriptMediaKeySummaryHow =>
      'Invia VK_MEDIA_PLAY_PAUSE / VK_MEDIA_NEXT_TRACK / VK_MEDIA_PREV_TRACK / VK_MEDIA_STOP tramite keybd_event. Windows instrada la pressione attraverso i System Media Transport Controls.';

  @override
  String get skapiScriptMediaKeyNote =>
      'Livello 2: necessita di una sessione multimediale attiva. Se nessuna app è in riproduzione o l\'app in primo piano non si registra con SMTC, la pressione viene ignorata silenziosamente.';

  @override
  String get skapiScriptMediaKeyParamKeyLabel => 'tasto';

  @override
  String get skapiScriptMediaKeyParamKeyHint =>
      'play-pausa / successivo / precedente / stop. Il valore predefinito è play-pausa.';

  @override
  String get skapiGroupWindowAppTitle => 'Finestra e applicazione';

  @override
  String get skapiGroupWindowAppDesc =>
      'Gli script di questo gruppo controllano finestre e applicazioni: riduci a icona, metti a fuoco, chiudi in modo ordinato o termina i processi del tutto. Mantengono ordinato il tuo spazio di lavoro quando un dispositivo SmartKraft vuole che il computer cambi contesto.';

  @override
  String get skapiGroupWindowAppFoot =>
      'Uso tipico: riduci a icona tutto quando inizia una sessione di concentrazione, chiudi il browser a fine lavoro, termina su richiesta un\'app bloccata.';

  @override
  String get skapiScriptMinimizeWindowTitle => 'Riduci a icona finestra';

  @override
  String get skapiScriptMinimizeWindowSummaryWhat =>
      'Riduce a icona una finestra specifica in base al nome del processo. Un nome processo vuoto agisce sulla finestra attualmente a fuoco.';

  @override
  String get skapiScriptMinimizeWindowSummaryHow =>
      'Risolve la prima finestra principale corrispondente tramite Get-Process e chiama ShowWindow di user32 con SW_MINIMIZE.';

  @override
  String get skapiScriptMinimizeWindowNote =>
      'Se sono in esecuzione più istanze, viene ridotta a icona solo la prima finestra corrispondente. Usa il nome del processo senza il suffisso .exe.';

  @override
  String get skapiScriptMinimizeWindowParamProcessLabel => 'processName';

  @override
  String get skapiScriptMinimizeWindowParamProcessHint =>
      'Nome processo senza .exe (chrome, code, winword). Vuoto agisce sulla finestra in primo piano.';

  @override
  String get skapiScriptCloseWindowTitle => 'Chiudi finestra';

  @override
  String get skapiScriptCloseWindowSummaryWhat =>
      'Invia una chiusura ordinata a una finestra così l\'app può mostrare la propria finestra \"salvare le modifiche?\".';

  @override
  String get skapiScriptCloseWindowSummaryHow =>
      'Invia WM_CLOSE tramite SendMessage di user32. Stesso effetto del clic dell\'utente sul pulsante X. Un nome processo vuoto agisce sulla finestra in primo piano.';

  @override
  String get skapiScriptCloseWindowNote =>
      'Le app con lavoro non salvato mostreranno la propria finestra. Lo script non attende né termina le app bloccate.';

  @override
  String get skapiScriptCloseWindowParamProcessLabel => 'processName';

  @override
  String get skapiScriptCloseWindowParamProcessHint =>
      'Nome processo senza .exe. Vuoto agisce sulla finestra in primo piano.';

  @override
  String get skapiScriptKillAppTitle => 'Forza chiusura app';

  @override
  String get skapiScriptKillAppSummaryWhat =>
      'Termina ogni istanza di un processo. Prova prima WM_CLOSE, poi TerminateProcess se l\'app è ancora attiva dopo il timeout.';

  @override
  String get skapiScriptKillAppSummaryHow =>
      'Invia WM_CLOSE a ogni finestra principale, attende il timeout configurato, poi esegue Stop-Process con -Force su tutto ciò che è ancora in esecuzione.';

  @override
  String get skapiScriptKillAppNote =>
      'Il lavoro non salvato nelle app che non rispondono andrà perso alla terminazione forzata. Usa preKillSave per le app tipo editor che rispondono a Ctrl+S.';

  @override
  String get skapiScriptKillAppParamProcessLabel => 'processName';

  @override
  String get skapiScriptKillAppParamProcessHint =>
      'Nome processo senza .exe. Vengono terminate tutte le istanze in esecuzione.';

  @override
  String get skapiScriptKillAppParamTimeoutLabel => 'timeout';

  @override
  String get skapiScriptKillAppParamTimeoutHint =>
      'Secondi di attesa tra WM_CLOSE e la terminazione forzata. Valori più alti danno all\'app più tempo per salvare.';

  @override
  String get skapiScriptKillAppParamPreKillSaveLabel => 'preKillSave';

  @override
  String get skapiScriptKillAppParamPreKillSaveHint =>
      'Invia Ctrl+S alla finestra in primo piano prima di chiudere. Utile per gli editor ma senza effetto sulle app che ignorano Ctrl+S.';

  @override
  String get skapiScriptLaunchAppTitle => 'Avvia app';

  @override
  String get skapiScriptLaunchAppSummaryWhat =>
      'Avvia un eseguibile, apre un URL o lancia un documento con il gestore predefinito.';

  @override
  String get skapiScriptLaunchAppSummaryHow =>
      'Chiama Start-Process di PowerShell con il percorso e un elenco di argomenti opzionale. Il percorso può essere un .exe, un percorso file completo o un URL.';

  @override
  String get skapiScriptLaunchAppNote =>
      'I percorsi con spazi sono accettati. Usa un URL come https://example.com per aprire il browser predefinito.';

  @override
  String get skapiScriptLaunchAppParamPathLabel => 'percorso';

  @override
  String get skapiScriptLaunchAppParamPathHint =>
      'Eseguibile, percorso file completo o URL. notepad / C:\\\\tools\\\\my.exe / https://example.com.';

  @override
  String get skapiScriptLaunchAppParamArgsLabel => 'args';

  @override
  String get skapiScriptLaunchAppParamArgsHint =>
      'Argomenti passati all\'eseguibile. Vuoto per nessuno.';

  @override
  String get skappListenerCardTitle => 'SKAPP HTTP Listener';

  @override
  String skappListenerCardSubtitleRunning(int port) {
    return 'In esecuzione sulla porta $port';
  }

  @override
  String get skappListenerCardSubtitleStopped => 'Arrestato';

  @override
  String get skappListenerCardSubtitleUnsupported =>
      'Questa piattaforma non può ospitare il listener.';

  @override
  String get skappListenerCardEnableSwitch => 'Abilita listener';

  @override
  String get skappListenerCardSecurityNote =>
      'Il listener accetta connessioni solo sulla tua rete locale e richiede il bearer token. HTTP in chiaro, non esporlo a internet pubblico.';

  @override
  String get settingsLanVisibleTitle => 'Visibile sulla LAN';

  @override
  String get settingsLanVisibleSubtitle =>
      'Quando è disattivato, il listener si lega solo a localhost. I dispositivi BF abbinati non possono raggiungere questo desktop.';

  @override
  String get settingsLanVisibleWarnBfBreaks =>
      'Disattivando questa opzione si interrompe la catena webhook BF. Usala solo in un ambiente affidabile o di test.';

  @override
  String get settingsLanVisibleAutoReopenedSnack =>
      'La visibilità LAN è stata riattivata così i dispositivi BF possono raggiungere questo desktop.';

  @override
  String get skapiRunRemoteDeveloperModeDisabled =>
      'Il desktop di destinazione ha la modalità sviluppatore disattivata, quindi l\'esecuzione remota degli script è disattivata lì.';

  @override
  String get skappPeerPairingManualUuidConfirmLabel =>
      'Codice di conferma (ultime 4 cifre dell\'UUID)';

  @override
  String get skappPeerPairingManualUuidConfirmHint =>
      'Leggi il codice di 4 caratteri mostrato nella schermata di abbinamento del desktop.';

  @override
  String get skappPeerPairingManualUuidConfirmError =>
      'Il codice non corrisponde alle ultime 4 cifre dell\'UUID. Controlla lo schermo del desktop.';

  @override
  String get skappListenerCardUuidLast4Label =>
      'Codice di conferma abbinamento';

  @override
  String get skappListenerCardUuidLast4Hint =>
      'Digita questi 4 caratteri nella schermata di abbinamento manuale del telefono.';

  @override
  String get settingsPeerTokensTitle => 'Token peer emessi';

  @override
  String get settingsPeerTokensSubtitle =>
      'Peer mobili abbinati a questo desktop. Revoca una voce per disconnetterla senza influire sulle altre.';

  @override
  String get settingsPeerTokensEmpty => 'Ancora nessun peer abbinato.';

  @override
  String settingsPeerTokensIssuedAt(String when) {
    return 'Abbinato $when';
  }

  @override
  String settingsPeerTokensLastUsed(String when) {
    return 'Usato l\'\'ultima volta $when';
  }

  @override
  String get settingsPeerTokensRevokeButton => 'Revoca';

  @override
  String get settingsPeerTokensRevokeConfirmTitle => 'Revocare questo peer?';

  @override
  String get settingsPeerTokensRevokeConfirmBody =>
      'Il peer verrà disconnesso immediatamente e dovrà riabbinare per raggiungere questo desktop.';

  @override
  String get settingsPeerTokensRevokeConfirmCancel => 'Annulla';

  @override
  String get settingsPeerTokensRevokeConfirmAction => 'Revoca';

  @override
  String settingsPeerTokensRevokedToast(String name) {
    return 'Peer $name revocato';
  }

  @override
  String get skappListenerCardRotateCertButton => 'Ruota certificato TLS';

  @override
  String get skappListenerCardRotateCertConfirmTitle =>
      'Ruotare il certificato?';

  @override
  String get skappListenerCardRotateCertConfirmBody =>
      'Verrà generato un nuovo certificato TLS autofirmato. Ogni peer precedentemente abbinato fallirà l\'handshake finché non si riabbina.';

  @override
  String get skappListenerCardRotateCertConfirmCancel => 'Annulla';

  @override
  String get skappListenerCardRotateCertConfirmAction => 'Ruota';

  @override
  String get skappListenerCardRotateCertDoneSnack =>
      'Certificato TLS ruotato. Riabbina ogni dispositivo.';

  @override
  String get skappListenerCardCertFingerprintLabel => 'Impronta TLS';

  @override
  String skappListenerCardErrorPortInUse(int port) {
    return 'La porta $port è già in uso. Scegli una porta diversa da Identità di rete.';
  }

  @override
  String skappListenerCardErrorGeneric(String error) {
    return 'Impossibile avviare il listener: $error';
  }

  @override
  String get skappPeerPairingTitle => 'Abbina SKAPP desktop';

  @override
  String get skappPeerPairingSubtitle =>
      'Scansiona il QR mostrato nelle Impostazioni del SKAPP desktop, oppure incolla il codice di abbinamento manualmente.';

  @override
  String get skappPeerPairingTabScan => 'Scansiona QR';

  @override
  String get skappPeerPairingTabManual => 'Manuale';

  @override
  String get skappPeerPairingScanHint =>
      'Punta la fotocamera sul QR mostrato in SKAPP desktop > Impostazioni > SKAPP HTTP Listener.';

  @override
  String get skappPeerPairingScanCameraDeniedTitle =>
      'Permesso fotocamera richiesto';

  @override
  String get skappPeerPairingScanCameraDeniedBody =>
      'Consenti l\'accesso alla fotocamera dalle impostazioni del telefono per scansionare il QR di abbinamento. Puoi anche inserire il codice manualmente.';

  @override
  String get skappPeerPairingManualHostLabel => 'IP o hostname del desktop';

  @override
  String get skappPeerPairingManualPortLabel => 'Porta';

  @override
  String get skappPeerPairingManualTokenLabel => 'Bearer token';

  @override
  String get skappPeerPairingManualUuidLabel => 'UUID desktop';

  @override
  String get skappPeerPairingManualNameLabel => 'Nome visualizzato';

  @override
  String get skappPeerPairingManualSubmit => 'Abbina';

  @override
  String skappPeerPairingSavedToast(String name) {
    return 'Abbinato con $name';
  }

  @override
  String skappPeerPairingFailedToast(String reason) {
    return 'Abbinamento non riuscito: $reason';
  }

  @override
  String get skappPeerPairingShowQrTitle =>
      'Abbina un telefono con questo desktop';

  @override
  String get skappPeerPairingShowQrBody =>
      'Apri SKAPP sul telefono, vai su SKAPI > Impostazioni > Abbina desktop e scansiona questo QR. Il QR contiene il bearer token, trattalo come una password.';

  @override
  String get skappPeerPairingShowQrCloseButton => 'Fatto';

  @override
  String get skappPeerListEmpty =>
      'Ancora nessun desktop abbinato. Abbinane uno per eseguire script da questo telefono.';

  @override
  String get skappPeerListSectionTitle => 'SKAPP desktop abbinati';

  @override
  String get skappPeerStatusOnline => 'Online';

  @override
  String get skappPeerStatusOffline => 'Offline';

  @override
  String skappPeerStatusLastSeen(String when) {
    return 'Visto l\'\'ultima volta $when';
  }

  @override
  String get skappPeerRemoveTooltip => 'Rimuovi desktop abbinato';

  @override
  String get skappPeerRemoveConfirmTitle => 'Rimuovere l\'abbinamento?';

  @override
  String skappPeerRemoveConfirmBody(String name) {
    return 'Gli script attivati da questo telefono non verranno più eseguiti su $name finché non riabbini.';
  }

  @override
  String get skappPeerScanRefreshTooltip => 'Aggiorna elenco peer';

  @override
  String skapiRunRemoteSheetTitle(String peerName) {
    return 'Esegui da remoto su $peerName';
  }

  @override
  String get skapiRunRemoteConnecting => 'Connessione al desktop...';

  @override
  String get skapiRunRemoteOfflineError =>
      'Il desktop abbinato è offline. Prova ad aggiornare i peer o controlla il listener del desktop.';

  @override
  String get skapiRunRemoteUnauthorizedError =>
      'Bearer token rifiutato. Il token del desktop potrebbe essere stato ruotato. Riabbina dalle Impostazioni.';

  @override
  String skapiRunRemoteHttpError(String reason) {
    return 'Esecuzione remota non riuscita: $reason';
  }

  @override
  String get skapiRunMobileNoPeerTitle => 'Nessun desktop abbinato';

  @override
  String get skapiRunMobileNoPeerBody =>
      'Abbina un SKAPP desktop dalle Impostazioni per eseguire script da questo telefono.';

  @override
  String get skapiRunMobileNoPeerCta => 'Apri impostazioni';

  @override
  String get skapiRunRemoteNotWhitelisted =>
      'Questo script non è contrassegnato come eseguibile da remoto. Eseguilo direttamente sul desktop.';

  @override
  String get skapiRunRemoteNoPeerHint =>
      'Abbina un SKAPP desktop dalle Impostazioni per eseguire script da questo telefono.';

  @override
  String get skapiRunRemoteNoPeerAction => 'Apri impostazioni';

  @override
  String get skappPeerPickerTitle => 'Su quale computer inviare?';

  @override
  String get skappPeerPickerSubtitle =>
      'Scegli il SKAPP desktop abbinato che deve eseguire questo script.';

  @override
  String get skappPeerPickerOfflineReason => 'Offline';

  @override
  String get skappPeerPickerDevModeOffReason =>
      'Modalità sviluppatore disattivata';

  @override
  String get skappPeerPickerEmpty =>
      'Nessun desktop abbinato tra cui scegliere.';

  @override
  String get skapiRunRemoteCancelButton => 'Annulla';

  @override
  String get skapiRunRemoteCancelledNote => 'Esecuzione annullata';

  @override
  String skapiRunRemoteTooManyRuns(int running, int limit) {
    return 'Quel desktop ha già $running script in esecuzione (massimo $limit). Attendi che uno finisca.';
  }

  @override
  String get skappPeerHealthDevModeBadge => 'Modalità sviluppatore';

  @override
  String get remoteRunActivityCardTitle => 'Esecuzioni remote';

  @override
  String get remoteRunActivityCardSubtitle =>
      'Esecuzioni recenti di script che i peer mobili abbinati hanno chiesto a questo desktop di eseguire.';

  @override
  String get remoteRunActivityCardEmpty => 'Ancora nessuna esecuzione remota.';

  @override
  String get remoteRunActivityCardClear => 'Cancella cronologia';

  @override
  String remoteRunActivityRowOk(int exitCode, int durationMs) {
    return 'uscita $exitCode · $durationMs ms';
  }

  @override
  String get remoteRunActivityRowCancelled => 'annullata';

  @override
  String remoteRunActivityRowRejected(String reason) {
    return 'rifiutata · $reason';
  }

  @override
  String get mobileTriggerCardTitle => 'Trigger';

  @override
  String get mobileTriggerCardSubtitle =>
      'Invia un evento di tocco a un SKAPP desktop abbinato. Qualsiasi associazione in ascolto di questo evento attiverà il suo script su quel desktop.';

  @override
  String get mobileTriggerCardSendButton => 'Invia tocco';

  @override
  String get mobileTriggerCardSending => 'Invio...';

  @override
  String mobileTriggerSentToast(String name) {
    return 'Tocco inviato a $name';
  }

  @override
  String get skapiBindEventMobileTap => 'Tocco mobile';

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
  String get msHomeScreenTitle => 'Peer mobile';

  @override
  String get msHomeScreenNotFound => 'Questo peer mobile non è più abbinato.';

  @override
  String get msHomeScreenEventsHeader => 'Eventi disponibili';

  @override
  String msHomeScreenBindingsHeader(int count) {
    return 'Associazioni ($count)';
  }

  @override
  String get msHomeScreenBindingsEmpty =>
      'Ancora nessuna associazione. Usa SKAPI → script → Associa ad azione per collegare un evento di tocco a uno script.';

  @override
  String get msHomeScreenHint =>
      'I telefoni non eseguono script. Emettono eventi trigger che questo desktop associa agli script.';

  @override
  String msHomeScreenPairedAt(String date) {
    return 'Abbinato $date';
  }

  @override
  String get skapiGroupNotifyTitle => 'Notifiche e finestre di dialogo';

  @override
  String get skapiGroupNotifyDesc =>
      'Gli script di questo gruppo parlano direttamente all\'utente: mostrano un toast, una finestra modale o attendono una risposta sì/no. Usali quando l\'evento di un dispositivo SmartKraft richiede che la persona davanti allo schermo confermi o decida.';

  @override
  String get skapiGroupNotifyFoot =>
      'Uso tipico: finestra di dialogo prima di un\'azione distruttiva, toast per un promemoria leggero, finestra con timeout per proseguire automaticamente.';

  @override
  String get skapiScriptDialogTitle => 'Mostra finestra di dialogo';

  @override
  String get skapiScriptDialogSummaryWhat =>
      'Mostra una MessageBox modale di Windows e restituisce la scelta dell\'utente (ok / cancel / yes / no / timeout).';

  @override
  String get skapiScriptDialogSummaryHow =>
      'Chiama System.Windows.Forms.MessageBox su un runspace figlio così lo script può mettere in competizione la finestra con un timeout opzionale. Il valore scelto viene scritto su stdout per consentire al chiamante di ramificarsi.';

  @override
  String get skapiScriptDialogNote =>
      'stdout è la risposta dell\'utente in minuscolo. timeout=0 attende indefinitamente.';

  @override
  String get skapiScriptDialogParamTitleLabel => 'title';

  @override
  String get skapiScriptDialogParamTitleHint =>
      'Titolo della finestra mostrato nella message box.';

  @override
  String get skapiScriptDialogParamBodyLabel => 'body';

  @override
  String get skapiScriptDialogParamBodyHint =>
      'La domanda o il messaggio mostrato all\'utente.';

  @override
  String get skapiScriptDialogParamButtonsLabel => 'buttons';

  @override
  String get skapiScriptDialogParamButtonsHint =>
      'ok / ok_cancel / yes_no / yes_no_cancel. Predefinito ok_cancel.';

  @override
  String get skapiScriptDialogParamTimeoutLabel => 'timeout';

  @override
  String get skapiScriptDialogParamTimeoutHint =>
      'Secondi di attesa prima di proseguire con \'timeout\'. 0 significa attendere all\'infinito.';

  @override
  String get skapiScriptToastTitle => 'Mostra toast';

  @override
  String get skapiScriptToastSummaryWhat =>
      'Mostra una notifica toast di Windows con titolo e corpo. Scivola dall\'angolo in basso a destra e finisce nel Centro notifiche.';

  @override
  String get skapiScriptToastSummaryHow =>
      'Costruisce un payload XML ToastNotification e lo passa al ToastNotificationManager di WinRT con l\'AppUserModelID configurato.';

  @override
  String get skapiScriptToastNote =>
      'Livello 2: richiede Windows 10+ e un AppUserModelID registrato per l\'esperienza migliore. L\'AUMID predefinito mostra il toast sotto PowerShell nel Centro notifiche.';

  @override
  String get skapiScriptToastParamTitleLabel => 'title';

  @override
  String get skapiScriptToastParamTitleHint =>
      'Prima riga in grassetto del toast.';

  @override
  String get skapiScriptToastParamBodyLabel => 'body';

  @override
  String get skapiScriptToastParamBodyHint =>
      'Seconda riga più piccola. Facoltativa.';

  @override
  String get skapiScriptToastParamAumidLabel => 'aumid';

  @override
  String get skapiScriptToastParamAumidHint =>
      'App User Model ID sotto cui appare il toast. Il valore predefinito ricade su PowerShell.';

  @override
  String get skapiGroupVisualBreakTitle => 'Pausa visiva';

  @override
  String get skapiGroupVisualBreakDesc =>
      'Segnali visivi delicati che allontanano l\'utente dal lavoro intenso: attenua lo schermo, passa a scala di grigi, trova il cursore o mostra il desktop. Gli effetti di questo gruppo sono reversibili e non bloccano mai l\'input in modo rigido.';

  @override
  String get skapiGroupVisualBreakFoot =>
      'Uso tipico: attenuare lo schermo all\'inizio di una pausa di concentrazione, modalità scala di grigi per letture notturne, trova-mouse nelle configurazioni multi-monitor.';

  @override
  String get skapiScriptShowDesktopTitle => 'Mostra desktop';

  @override
  String get skapiScriptShowDesktopSummaryWhat =>
      'Attiva/disattiva \'mostra desktop\'. Come premere Win+D due volte di seguito.';

  @override
  String get skapiScriptShowDesktopSummaryHow =>
      'Chiama Shell.Application.ToggleDesktop tramite COM. Eseguendolo di nuovo ripristina la disposizione precedente delle finestre.';

  @override
  String get skapiScriptFadeScreenTitle => 'Dissolvenza schermo';

  @override
  String get skapiScriptFadeScreenSummaryWhat =>
      'Dissolve la luminosità del display interno dal livello corrente a un livello obiettivo in pochi secondi.';

  @override
  String get skapiScriptFadeScreenSummaryHow =>
      'Legge la luminosità corrente tramite WmiMonitorBrightness di WMI, poi varia WmiSetBrightness con incrementi lineari verso l\'obiettivo così il cambiamento risulta fluido.';

  @override
  String get skapiScriptFadeScreenNote =>
      'Livello 2: la luminosità WMI funziona solo sui pannelli interni. I monitor esterni non rispondono su questo percorso.';

  @override
  String get skapiScriptFadeScreenParamTargetLabel => 'target';

  @override
  String get skapiScriptFadeScreenParamTargetHint =>
      'Percentuale di luminosità finale (0-100).';

  @override
  String get skapiScriptFadeScreenParamDurationLabel => 'durata';

  @override
  String get skapiScriptFadeScreenParamDurationHint =>
      'Secondi che la dissolvenza deve durare. Lo script usa dieci passaggi di luminosità al secondo.';

  @override
  String get skapiScriptGrayscaleTitle => 'Filtro scala di grigi';

  @override
  String get skapiScriptGrayscaleSummaryWhat =>
      'Attiva o disattiva la modalità scala di grigi dei Filtri colore di Windows.';

  @override
  String get skapiScriptGrayscaleSummaryHow =>
      'Scrive le chiavi di registro ColorFiltering, poi invia Win+Ctrl+C così Windows recepisce il cambiamento in tempo reale senza disconnessione.';

  @override
  String get skapiScriptGrayscaleNote =>
      'Livello 2: richiede che Impostazioni > Accessibilità > Filtri colore > \'Consenti il tasto di scelta rapida\' sia attivo perché il toggle in tempo reale funzioni.';

  @override
  String get skapiScriptGrayscaleParamOnLabel => 'on';

  @override
  String get skapiScriptGrayscaleParamOnHint =>
      'true per abilitare la scala di grigi, false per disattivarla.';

  @override
  String get skapiScriptGrayscaleParamDurationLabel => 'durata';

  @override
  String get skapiScriptGrayscaleParamDurationHint =>
      '0 significa solo attiva/disattiva. >0 ripristina automaticamente il colore dopo i secondi indicati. Ideale per le pause visive.';

  @override
  String get skapiScriptFindMouseShakeTitle => 'Trova mouse';

  @override
  String get skapiScriptFindMouseShakeSummaryWhat =>
      'Fa muovere il cursore in un piccolo cerchio per richiamare l\'occhio sulla sua posizione. Il cursore torna al punto di partenza al termine dell\'animazione.';

  @override
  String get skapiScriptFindMouseShakeSummaryHow =>
      'Legge la posizione corrente del cursore con GetCursorPos, poi cicla SetCursorPos lungo un cerchio del raggio configurato. Utile nelle configurazioni multi-monitor e 4K.';

  @override
  String get skapiScriptFindMouseShakeNote =>
      'Livello 2: SetCursorPos può essere bloccato da software di accessibilità e il comportamento varia nelle sessioni di desktop remoto.';

  @override
  String get skapiScriptFindMouseShakeParamRadiusLabel => 'raggio';

  @override
  String get skapiScriptFindMouseShakeParamRadiusHint =>
      'Pixel percorsi dal cursore rispetto alla sua origine durante il ciclo. Più grande è più appariscente.';

  @override
  String get skapiScriptFindMouseShakeParamLoopsLabel => 'cicli';

  @override
  String get skapiScriptFindMouseShakeParamLoopsHint =>
      'Quanti cerchi completi disegnare prima di fermarsi.';

  @override
  String get skapiGroupProgramsTitle => 'Controllo programmi specifici';

  @override
  String get skapiGroupProgramsDesc =>
      'Script mirati per app e browser specifici: salvataggio+chiusura ordinati, arresto multi-istanza, pulizia dell\'intero browser. Comodi quando un dispositivo SmartKraft vuole concludere un flusso di lavoro specifico senza distruggere l\'intero desktop.';

  @override
  String get skapiGroupProgramsFoot =>
      'Uso tipico: salva e chiudi tutti gli editor prima della sospensione, chiudi ogni browser a fine giornata, pulizia mirata di una sola famiglia di processi.';

  @override
  String get skapiScriptCloseWithSaveTitle => 'Salva e chiudi app';

  @override
  String get skapiScriptCloseWithSaveSummaryWhat =>
      'Invia Ctrl+S a un\'app di destinazione per attivare il suo salvataggio, attende, poi chiude la finestra in modo ordinato.';

  @override
  String get skapiScriptCloseWithSaveSummaryHow =>
      'Mette a fuoco ogni istanza in esecuzione, invia Ctrl+S tramite SendKeys, attende il momento configurato, poi invia WM_CLOSE così l\'app può confermare o terminare il salvataggio.';

  @override
  String get skapiScriptCloseWithSaveNote =>
      'Livello 2: si basa sul fatto che l\'app interpreti Ctrl+S come \'salva\'. Alcune app di chat / web lo trattano diversamente. Testa con le app che usi davvero.';

  @override
  String get skapiScriptCloseWithSaveParamProcessLabel => 'processName';

  @override
  String get skapiScriptCloseWithSaveParamProcessHint =>
      'Nome processo senza .exe (winword, excel, code, photoshop). Tutte le istanze in esecuzione vengono salvate e chiuse.';

  @override
  String get skapiScriptCloseWithSaveParamWaitLabel => 'wait';

  @override
  String get skapiScriptCloseWithSaveParamWaitHint =>
      'Secondi di attesa tra Ctrl+S e il segnale di chiusura così l\'app termina il salvataggio.';

  @override
  String get skapiScriptCloseAllInstancesTitle => 'Chiudi tutte le istanze';

  @override
  String get skapiScriptCloseAllInstancesSummaryWhat =>
      'Invia una chiusura ordinata a ogni finestra visibile di un processo. Ogni istanza può mostrare la propria finestra di salvataggio.';

  @override
  String get skapiScriptCloseAllInstancesSummaryHow =>
      'Itera i processi corrispondenti tramite Get-Process e invia WM_CLOSE alla finestra principale di ciascuno. Nessun ripiego forzato.';

  @override
  String get skapiScriptCloseAllInstancesParamProcessLabel => 'processName';

  @override
  String get skapiScriptCloseAllInstancesParamProcessHint =>
      'Nome processo senza .exe. Corrisponde a tutte le istanze.';

  @override
  String get skapiScriptBrowserCloseAllTitle => 'Chiudi tutti i browser';

  @override
  String get skapiScriptBrowserCloseAllSummaryWhat =>
      'Chiude in modo ordinato ogni browser mainstream in esecuzione (Chrome, Edge, Firefox, Brave, Vivaldi, Opera).';

  @override
  String get skapiScriptBrowserCloseAllSummaryHow =>
      'Itera i nomi dei processi dei browser noti e invia WM_CLOSE a ogni finestra principale. I browser moderni preservano la sessione se \'ripristina schede al prossimo avvio\' è abilitato.';

  @override
  String get skapiScriptBrowserCloseAllNote =>
      'La terminazione forzata non viene usata. Per cancellare anche la sessione, usa invece kill-app per ciascun browser.';

  @override
  String get skapiTierBadgeExperimental => 'Sperimentale';

  @override
  String get skapiTierBadgeExperimentalTooltip =>
      'Questo script dipende da un\'API di Windows che potrebbe non essere affidabile su tutte le macchine. Testalo prima di affidartici.';

  @override
  String get skapiTierBadgeBlocked => 'In arrivo';

  @override
  String get skapiTierBadgeBlockedTooltip =>
      'Questo script fa parte della libreria pianificata ma non è ancora implementato.';

  @override
  String get skapiGroupSaveWorkTitle => 'Salva il lavoro';

  @override
  String get skapiGroupSaveWorkDesc =>
      'Gli script di questo gruppo salvano su disco il lavoro aperto prima di una pausa o di uno spegnimento imprevisto. Quando il tuo dispositivo SmartKraft attiva una pausa, lo script scelto salva automaticamente il tuo file in Word, Excel, VS Code o qualsiasi altro editor, così anche se il computer si sospende, si spegne o esegue un altro comando, il tuo lavoro resta al sicuro.';

  @override
  String get skapiGroupSaveWorkFoot =>
      'Uso tipico: salvataggio automatico all\'inizio di una pausa di concentrazione, backup del documento all\'avviso di batteria scarica, o un trigger \"salva tutto\" con un solo pulsante.';

  @override
  String get skapiScriptSaveActiveWindowTitle => 'Salva finestra attiva';

  @override
  String get skapiScriptSaveActiveWindowSummaryWhat =>
      'Invia un Ctrl+S virtuale alla finestra di Windows attualmente a fuoco, attivando il comportamento di \"salvataggio\" di quell\'applicazione.';

  @override
  String get skapiScriptSaveActiveWindowSummaryHow =>
      'Per prima cosa acquisisce l\'handle della finestra attiva e ne registra il titolo. Poi invia Ctrl+S tramite SendKeys. Word salva nel percorso corrente, VS Code scrive il file. Se appare una finestra \"Salva con nome\", attende finché l\'utente non conferma manualmente.';

  @override
  String get skapiScriptSaveActiveWindowParamTimeoutLabel => 'timeout';

  @override
  String get skapiScriptSaveActiveWindowParamTimeoutHint =>
      'Secondi di attesa dopo l\'invio della pressione del tasto così l\'app ha il tempo di scrivere il file.';

  @override
  String get skapiScriptSaveActiveWindowParamVerboseLabel => 'verbose';

  @override
  String get skapiScriptSaveAllOpenTitle => 'Salva tutti i documenti aperti';

  @override
  String get skapiScriptSaveAllOpenSummaryWhat =>
      'Itera una lista consentita di editor in esecuzione e dice a ciascuno di salvare i documenti aperti.';

  @override
  String get skapiScriptSaveAllOpenSummaryHow =>
      'Per ogni processo consentito trovato, mette a fuoco la finestra principale, invia Ctrl+S, poi attende il timeout per app configurato prima di proseguire. Le app non in esecuzione vengono saltate silenziosamente a meno che la modalità verbose non sia attiva.';

  @override
  String get skapiScriptSaveAllOpenNote =>
      'La lista consentita predefinita comprende Word, Excel, PowerPoint e VS Code. Modifica il parametro apps per aggiungere i tuoi.';

  @override
  String get skapiScriptSaveAllOpenParamAppsLabel => 'apps';

  @override
  String get skapiScriptSaveAllOpenParamAppsHint =>
      'Nomi dei processi (senza .exe) a cui inviare il salvataggio. L\'ordine conta: le voci precedenti vengono elaborate per prime.';

  @override
  String get skapiScriptSaveAllOpenParamTimeoutLabel => 'timeoutPerApp';

  @override
  String get skapiScriptSaveAllOpenParamVerboseLabel => 'verbose';

  @override
  String get skapiScriptAutosaveTriggerTitle => 'Attiva salvataggio automatico';

  @override
  String get skapiScriptAutosaveTriggerSummaryWhat =>
      'Trasmette un comando di salvataggio di Windows a ogni finestra di primo livello visibile in un solo passaggio.';

  @override
  String get skapiScriptAutosaveTriggerSummaryHow =>
      'Enumera le finestre visibili, poi invia a ciascuna un WM_COMMAND con l\'id di salvataggio standard. Le app che ascoltano quel messaggio reagiscono come se avessi cliccato la voce Salva del loro menu File. Più veloce di un Ctrl+S per finestra, ma alcune app ignorano il broadcast.';

  @override
  String get skapiScriptAutosaveTriggerNote =>
      'Usalo quando vuoi svuotare ogni editor in una volta e non ti importa che un piccolo numero di app possa non rispondere. Combinalo con save-all-open per una copertura più rigorosa.';

  @override
  String get skapiScriptAutosaveTriggerParamDelayLabel => 'ritardo';

  @override
  String get skapiScriptAutosaveTriggerParamDelayHint =>
      'Secondi di attesa prima del broadcast, utili quando vuoi che la notifica di pausa del dispositivo appaia prima.';

  @override
  String get skapiScriptAutosaveTriggerParamVerboseLabel => 'verbose';

  @override
  String get skapiScriptDetailSummaryWhatLabel => 'Cosa fa:';

  @override
  String get skapiScriptDetailSummaryHowLabel => 'Come funziona:';

  @override
  String get skapiScriptDetailOriginalSectionTitle => 'Script originale';

  @override
  String get skapiScriptDetailOriginalSectionSub => 'sola lettura · inglese';

  @override
  String get skapiScriptDetailEditingSectionTitle => 'Modifiche';

  @override
  String get skapiScriptDetailEditingNotYet => 'Ancora nessuna modifica';

  @override
  String get skapiScriptDetailEditingNotYetSub =>
      'Crea una copia su questo dispositivo senza modificare l\'originale.';

  @override
  String get skapiScriptDetailEditingModified => 'Modificato';

  @override
  String skapiScriptDetailEditingModifiedSub(String date) {
    return 'Ultima modifica $date.';
  }

  @override
  String get skapiScriptDetailEditingOutdated => 'Libreria aggiornata';

  @override
  String get skapiScriptDetailEditingOutdatedSub =>
      'L\'originale è stato modificato da un aggiornamento dell\'app. Confronta o reimposta.';

  @override
  String get skapiScriptDetailParamWarnTitle =>
      'Controlla i parametri prima di eseguire';

  @override
  String get skapiScriptDetailParamWarnHint =>
      'Per modificare questi valori, usa \"Modifica\". I parametri sono definiti nel blocco param() dello script.';

  @override
  String get skapiScriptDetailNotesTitle => 'Note';

  @override
  String get skapiScriptDetailButtonRun => 'Esegui ora';

  @override
  String get skapiScriptDetailButtonBindAction => 'Associa ad azione';

  @override
  String get skapiScriptDetailButtonEdit => 'Modifica';

  @override
  String get skapiScriptDetailButtonView => 'Visualizza';

  @override
  String get skapiScriptDetailButtonReset => 'Reimposta';

  @override
  String get skapiScriptDetailButtonCompare => 'Confronta';

  @override
  String get skapiScriptCopyButton => 'Copia';

  @override
  String get skapiScriptCopyButtonDone => 'Copiato';

  @override
  String get skapiScriptSelectButton => 'Seleziona';

  @override
  String get skapiEditorTitle => 'Modifica';

  @override
  String skapiEditorHint(String scriptId) {
    return '$scriptId · Stai modificando una copia su questo dispositivo. La versione originale della libreria resta invariata. \"Reimposta\" ripristina sempre l\'\'originale.';
  }

  @override
  String get skapiEditorStatusBarTitle => 'POWERSHELL · UTF-8';

  @override
  String get skapiEditorStatusModified => '● Modificato';

  @override
  String get skapiEditorStatusUnmodified => 'Invariato';

  @override
  String skapiEditorFootCursor(int line, int column) {
    return 'Riga $line · Colonna $column';
  }

  @override
  String get skapiEditorFootSaveLabel => 'Salva';

  @override
  String skapiEditorDiffLineCount(int count) {
    return '$count riga modificata';
  }

  @override
  String skapiEditorDiffLinesCount(int count) {
    return '$count righe modificate';
  }

  @override
  String get skapiEditorDiffCompareLink => 'Confronta con l\'originale';

  @override
  String get skapiEditorButtonReset => 'Reimposta';

  @override
  String get skapiEditorButtonSave => 'Salva';

  @override
  String get skapiEditorAfterSaveNote =>
      'Dopo il salvataggio, \"Esegui ora\" eseguirà la versione modificata.';

  @override
  String get skapiLinuxDistroHeading =>
      'Scegli la tua famiglia di distribuzione';

  @override
  String get skapiLinuxDistroSubtitle =>
      'Gli script Linux divergono tra le famiglie basate su Debian (apt, .deb) e quelle basate su Arch (pacman). Scegli quella che corrisponde alla tua macchina.';

  @override
  String get skapiLinuxDistroDebianLabel => 'Basate su Debian';

  @override
  String get skapiLinuxDistroDebianSub =>
      'Debian, Ubuntu, Mint, Pop!_OS, Elementary, Kali, MX, Zorin';

  @override
  String get skapiLinuxDistroArchLabel => 'Basate su Arch';

  @override
  String get skapiLinuxDistroArchSub =>
      'Arch, Manjaro, EndeavourOS, Garuda (in arrivo)';

  @override
  String get skapiNewActionNoDevicesTitle => 'Abbina prima un dispositivo';

  @override
  String get skapiNewActionNoDevicesBody =>
      'Creare un\'azione sul dispositivo richiede almeno un dispositivo SmartKraft abbinato (per ora BF).';

  @override
  String get skapiNewActionNoDevicesCta => 'Apri Dispositivi';

  @override
  String get skapiNewActionPickDeviceTitle => 'Scegli un dispositivo';

  @override
  String get skapiNewActionPickDeviceSubtitle =>
      'Su quale dispositivo deve risiedere questa azione?';

  @override
  String get skapiUserNewTitle => 'Nuovo script';

  @override
  String get skapiUserEditTitle => 'Modifica script';

  @override
  String get skapiUserTitleLabel => 'Titolo';

  @override
  String get skapiUserTitleHint => 'es. Routine mattutina';

  @override
  String get skapiUserDescLabel => 'Descrizione';

  @override
  String get skapiUserDescHint => 'Cosa fa questo script?';

  @override
  String get skapiUserPlatformLabel => 'Piattaforma';

  @override
  String get skapiUserCodeLabel => 'Codice';

  @override
  String get skapiUserCodeHint => '# Il tuo codice PowerShell qui';

  @override
  String get skapiUserSaveCta => 'Salva';

  @override
  String get skapiUserValidationEmpty =>
      'Titolo e codice non possono essere vuoti.';

  @override
  String get skapiUserSavedSnack => 'Script salvato';

  @override
  String get skapiUserSectionHeading => 'I miei script';

  @override
  String skapiUserSectionSub(int count) {
    return '$count script';
  }

  @override
  String get skapiUserEmptyHint =>
      'Ancora nessuno script tuo. Creane uno con il pulsante Nuova azione, in alto a destra.';

  @override
  String get skapiUserDetailCodeHeading => 'Codice';

  @override
  String get skapiUserEditCta => 'Modifica';

  @override
  String get skapiUserDeleteConfirmTitle => 'Eliminare lo script?';

  @override
  String skapiUserDeleteConfirmBody(String name) {
    return '$name verrà eliminato definitivamente.';
  }

  @override
  String get skapiUserDeletedSnack => 'Script eliminato';

  @override
  String get skapiUserRunCta => 'Esegui';

  @override
  String get skapiUserRunUnsupported =>
      'L\'esecuzione degli script è disponibile solo su desktop.';

  @override
  String get skapiUserRunOutputTitle => 'Output esecuzione';

  @override
  String skapiUserRunDone(int code) {
    return 'Terminato (uscita $code)';
  }

  @override
  String get skapiLocalScriptsSubheading => 'Script locali';

  @override
  String get skapiOnDeviceApiSubheading => 'API sul dispositivo';

  @override
  String get skapiOnDeviceApiLoadError => 'Impossibile leggere gli endpoint';

  @override
  String get skapiOnDeviceApiRowHint =>
      'Tocca una riga qualsiasi per aprire l\'editor';

  @override
  String get commonLoading => 'Caricamento...';

  @override
  String get skapiApiTemplateSectionHeader => 'Template';

  @override
  String skapiApiTemplateSectionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count template',
      one: '1 template',
    );
    return '$_temp0';
  }

  @override
  String get skapiApiTemplateUploadCta => 'Carica sul dispositivo';

  @override
  String get skapiApiTemplateUploadHint =>
      'Il caricamento scrive questo template in uno dei 5 slot API USER del dispositivo. Il dispositivo lo attiva con il proprio trigger (BF: fine del conto alla rovescia).';

  @override
  String get skapiApiTemplatePreviewTitle => 'Anteprima endpoint';

  @override
  String get skapiApiTemplatePreviewType => 'Tipo';

  @override
  String get skapiApiTemplatePreviewMethod => 'Metodo';

  @override
  String get skapiApiTemplatePreviewUrl => 'URL';

  @override
  String get skapiApiTemplatePreviewAuth => 'Autenticazione';

  @override
  String get skapiApiTemplatePreviewHeader => 'Header';

  @override
  String get skapiApiTemplatePreviewContentType => 'Content-Type';

  @override
  String get skapiApiTemplatePreviewPayload => 'Payload';

  @override
  String get skapiApiTemplatePreviewDelay => 'Ritardo';

  @override
  String get skapiOtherCategoryHeading => 'Scegli una categoria di dispositivo';

  @override
  String get skapiOtherCategorySubtitle =>
      'I template vengono caricati sul dispositivo abbinato e si attivano con il trigger del dispositivo stesso (nessun laptop coinvolto).';

  @override
  String get skapiOtherSyndimmSub => 'Dimmer smart SmartKraft';

  @override
  String get skapiOtherLebensspurSub => 'Tracker di attività SmartKraft';

  @override
  String get skapiOtherBlockingfocusSub => 'Timer di concentrazione SmartKraft';

  @override
  String get skapiOtherIotSub =>
      'Webhook IoT di terze parti (IFTTT, Home Assistant, REST generico)';

  @override
  String get skapiOtherServerSub =>
      'Ricevitori HTTP self-hosted (n8n, Node-RED, personalizzati)';

  @override
  String get skapiCategoryComingSoon => 'Template in arrivo';

  @override
  String get skapiScriptLockSummaryHowLxDebian =>
      'Chiama loginctl lock-session per l\'XDG_SESSION_ID corrente; ripiega su xdg-screensaver lock quando loginctl non è disponibile.';

  @override
  String get skapiScriptHibernateSummaryHowLxDebian =>
      'Chiama systemctl hibernate. Il ritardo opzionale attende i secondi richiesti prima di sospendere.';

  @override
  String get skapiScriptHibernateNoteLxDebian =>
      'L\'ibernazione deve essere configurata (swap >= RAM e il parametro kernel resume=). Sui sistemi dove non lo è, systemd-logind ripiega sulla sospensione.';

  @override
  String get skapiScriptSleepSummaryHowLxDebian =>
      'Chiama systemctl suspend. Il kernel può ritardare se un inibitore in primo piano blocca le transizioni in standby.';

  @override
  String get skapiScriptShutdownSummaryHowLxDebian =>
      'Pianifica uno spegnimento ordinato tramite /sbin/shutdown -h +N (minuti). Ripiega su systemctl poweroff dopo il ritardo richiesto se shutdown manca.';

  @override
  String get skapiScriptShutdownNoteLxDebian =>
      '/sbin/shutdown accetta solo minuti; i valori sotto 60 vengono arrotondati a 1 minuto. Gli altri utenti collegati vedono un messaggio wall durante il conto alla rovescia.';

  @override
  String get skapiScriptShutdownParamForceHintLxDebian =>
      'Termina la sessione utente prima dello spegnimento così il periodo di grazia SIGTERM di 90s viene saltato.';

  @override
  String get skapiScriptBrightnessSummaryHowLxDebian =>
      'Imposta la retroilluminazione del display interno tramite brightnessctl set N% (preferito) o light -S N come ripiego. Entrambi scrivono su /sys/class/backlight.';

  @override
  String get skapiScriptBrightnessNoteLxDebian =>
      'brightnessctl funziona senza sudo quando l\'utente è nel gruppo video, che è il valore predefinito dopo l\'installazione sulla maggior parte delle configurazioni Debian. I monitor esterni su DDC richiedono ddcutil e non sono gestiti qui.';

  @override
  String get skapiScriptMuteToggleSummaryHowLxDebian =>
      'Attiva/disattiva o imposta il muto del sink principale tramite wpctl (PipeWire su Debian 12+) con un ripiego su pactl per le configurazioni PulseAudio.';

  @override
  String get skapiScriptVolumeSetSummaryHowLxDebian =>
      'Imposta il volume del sink principale a un livello 0-100 tramite wpctl set-volume (PipeWire) o pactl set-sink-volume (PulseAudio).';

  @override
  String get skapiScriptVolumeSetNoteLxDebian =>
      'PipeWire e PulseAudio espongono entrambi il volume per app in modo nativo, quindi questo script è di livello 1 su Linux. L\'uscita oltre il 100% viene limitata per coerenza con le altre piattaforme.';

  @override
  String get skapiScriptMediaKeySummaryHowLxDebian =>
      'Invia un\'azione di tasto multimediale tramite playerctl, che usa MPRIS per comunicare con qualunque app possieda attualmente la sessione (Spotify, Firefox, VLC, mpv, Rhythmbox).';

  @override
  String get skapiScriptMediaKeyNoteLxDebian =>
      'Se nessuna app multimediale compatibile con MPRIS è in esecuzione, il comando non ha effetto. Installa il supporto MPRIS dell\'app se un player noto non risponde.';

  @override
  String get skapiScriptMinimizeWindowSummaryHowLxDebian =>
      'Un processName vuoto riduce a icona la finestra a fuoco tramite xdotool. Altrimenti sceglie la prima finestra il cui WM_CLASS corrisponde e la riduce a icona.';

  @override
  String get skapiScriptMinimizeWindowNoteLxDebian =>
      'Solo X11. La corrispondenza WM_CLASS distingue maiuscole e minuscole e dipende da come l\'app si è dichiarata; controlla xprop WM_CLASS in caso di dubbio.';

  @override
  String get skapiScriptMinimizeWindowParamProcessHintLxDebian =>
      'Nome istanza WM_CLASS (per esempio: firefox, code, gnome-terminal-server). Vuoto agisce sulla finestra attiva.';

  @override
  String get skapiScriptCloseWindowSummaryHowLxDebian =>
      'Invia WM_DELETE_WINDOW tramite wmctrl -x -c (corrisponde a WM_CLASS) con ripiego sul titolo. Equivale a cliccare il pulsante X; l\'app può mostrare la propria finestra di salvataggio.';

  @override
  String get skapiScriptCloseWindowNoteLxDebian =>
      'Solo X11. Per Wayland, preferisci kill-app che usa i segnali invece del protocollo finestra.';

  @override
  String get skapiScriptCloseWindowParamProcessHintLxDebian =>
      'Nome istanza WM_CLASS; vuoto chiude la finestra a fuoco. La corrispondenza per sottostringa del titolo è usata come ripiego.';

  @override
  String get skapiScriptKillAppSummaryHowLxDebian =>
      'pkill -TERM -x per nome comm esatto, attende il timeout richiesto, poi pkill -KILL su tutto ciò che è ancora attivo. Il preKillSave opzionale mette a fuoco la finestra e invia prima Ctrl+S (solo X11).';

  @override
  String get skapiScriptKillAppNoteLxDebian =>
      'I nomi comm di Linux sono limitati a 15 caratteri dal kernel. Usa nomi brevi esatti: firefox (non firefox-esr-bin), code, soffice.bin.';

  @override
  String get skapiScriptKillAppParamProcessHintLxDebian =>
      'Nome comm esatto (limite kernel 15 caratteri). Usa pgrep -l per verificare il nome visibile.';

  @override
  String get skapiScriptKillAppParamPreKillSaveHintLxDebian =>
      'Invia Ctrl+S alla finestra dell\'app prima di SIGTERM. Richiede xdotool e X11; ignorato su Wayland.';

  @override
  String get skapiScriptLaunchAppSummaryHowLxDebian =>
      'Smistamento intelligente: .desktop -> gtk-launch, percorso file reale -> exec, qualsiasi altra cosa -> xdg-open, infine ricerca nel PATH. Il processo figlio è staccato tramite setsid così SKAPP non viene bloccato.';

  @override
  String get skapiScriptLaunchAppNoteLxDebian =>
      'args viene suddiviso sugli spazi. Gli argomenti con virgolette non sono supportati; usa uno script wrapper per righe di comando complesse.';

  @override
  String get skapiScriptLaunchAppParamPathHintLxDebian =>
      'Nome del binario nel PATH, percorso assoluto, file .desktop, URL o percorso file. xdg-open gestisce i tipi MIME.';

  @override
  String get skapiScriptDialogSummaryHowLxDebian =>
      'Apre una finestra modale tramite zenity (GTK) con un ripiego su kdialog (KDE). Scrive uno di ok / cancel / yes / no / timeout su stdout.';

  @override
  String get skapiScriptDialogNoteLxDebian =>
      'Installa con: sudo apt install zenity. Gli utenti KDE Plasma potrebbero avere kdialog. Senza nessuno dei due, lo script esce con codice 2.';

  @override
  String get skapiScriptToastSummaryHowLxDebian =>
      'Invia una notifica desktop tramite notify-send (libnotify). Livello 1 perché libnotify-bin è preinstallato su ogni desktop Debian moderno.';

  @override
  String get skapiScriptToastNoteLxDebian =>
      'icon accetta i nomi del tema icone Freedesktop (dialog-information, dialog-warning, dialog-error). duration in secondi; 0 mantiene il toast finché non viene chiuso.';

  @override
  String get skapiScriptToastParamIconLabelLxDebian => 'Icona';

  @override
  String get skapiScriptToastParamIconHintLxDebian =>
      'Nome icona Freedesktop, per esempio: dialog-information, dialog-warning, dialog-error.';

  @override
  String get skapiScriptToastParamDurationLabelLxDebian => 'Durata';

  @override
  String get skapiScriptToastParamDurationHintLxDebian =>
      'Chiusura automatica dopo questo numero di secondi. 0 significa che il toast resta finché l\'utente non lo chiude.';

  @override
  String get skapiScriptShowDesktopSummaryHowLxDebian =>
      'Legge lo stato show-desktop EWMH tramite wmctrl -m, poi lo attiva/disattiva con wmctrl -k. Riproduce la semantica di Win+D su X11.';

  @override
  String get skapiScriptShowDesktopNoteLxDebian =>
      'Solo X11. Gli equivalenti Wayland sono specifici del compositor (Sway, Hyprland, estensioni di GNOME Shell).';

  @override
  String get skapiScriptFadeScreenSummaryHowLxDebian =>
      'Dissolve linearmente la retroilluminazione del display interno dal valore corrente all\'obiettivo nella durata richiesta tramite brightnessctl con incrementi di 10 passaggi al secondo.';

  @override
  String get skapiScriptFadeScreenNoteLxDebian =>
      'Solo pannelli interni. I monitor esterni su DDC richiedono ddcutil e non sono gestiti qui. Livello 2 perché la lettura della retroilluminazione corrente dipende dalla visibilità di /sys/class/backlight.';

  @override
  String get skapiScriptGrayscaleSummaryHowLxDebian =>
      'Attiva/disattiva la chiave di saturazione colore dell\'ingranditore di accessibilità di GNOME (0.0 scala di grigi, 1.0 colore) tramite gsettings, senza bisogno di estensioni.';

  @override
  String get skapiScriptGrayscaleNoteLxDebian =>
      'Solo GNOME / Unity. KDE Plasma e XFCE non hanno un percorso di sistema equivalente; su quei desktop lo script esce con codice 3 invece di non avere effetto silenziosamente.';

  @override
  String get skapiScriptFindMouseShakeSummaryHowLxDebian =>
      'Legge la posizione del cursore tramite xdotool getmouselocation, poi traccia un cerchio attorno ad esso per il numero di cicli richiesto usando coordinate cos/sin calcolate con awk.';

  @override
  String get skapiScriptFindMouseShakeNoteLxDebian =>
      'Solo X11. Wayland blocca il movimento sintetico del puntatore a livello di protocollo (confine di sicurezza), quindi lo script esce con codice 3.';

  @override
  String get skapiScriptCloseWithSaveSummaryHowLxDebian =>
      'Per ogni finestra visibile corrispondente al WM_CLASS: attiva, Ctrl+S, attendi, poi invia WM_DELETE_WINDOW tramite wmctrl. Solo X11.';

  @override
  String get skapiScriptCloseWithSaveNoteLxDebian =>
      'Livello 2: l\'iniezione del tasto Ctrl+S dipende da locale e fuoco; solo la vera semantica di salvataggio si comporta in modo prevedibile. Le app di chat o web possono mappare Ctrl+S su qualcos\'altro.';

  @override
  String get skapiScriptCloseWithSaveParamProcessHintLxDebian =>
      'Nome istanza WM_CLASS (vedi xprop WM_CLASS). Obbligatorio.';

  @override
  String get skapiScriptCloseAllInstancesSummaryHowLxDebian =>
      'Invia SIGTERM a ogni processo in esecuzione corrispondente al nome comm esatto. Ogni app gestisce la propria sequenza di chiusura (e può mostrare la propria finestra di salvataggio).';

  @override
  String get skapiScriptCloseAllInstancesParamProcessHintLxDebian =>
      'Nome comm esatto come mostrato da pgrep -l. Obbligatorio.';

  @override
  String get skapiScriptBrowserCloseAllSummaryHowLxDebian =>
      'Percorre una lista di binari di browser Debian (firefox, firefox-esr, chromium, google-chrome, brave, vivaldi-bin, opera) e invia SIGTERM a ogni istanza in esecuzione.';

  @override
  String get skapiScriptBrowserCloseAllNoteLxDebian =>
      'I browser preservano la sessione se \"ripristina schede al prossimo avvio\" è attivo, quindi è un soft \"spegni lo schermo\" piuttosto che un\'azione con perdita di dati.';

  @override
  String get skapiScriptSaveActiveWindowSummaryHowLxDebian =>
      'Invia Ctrl+S alla finestra a fuoco tramite xdotool key --clearmodifiers. Solo X11.';

  @override
  String get skapiScriptSaveActiveWindowNoteLxDebian =>
      'Wayland blocca l\'iniezione sintetica dei tasti a livello di protocollo. Usa il ripiego autosave-trigger o affidati al salvataggio automatico dell\'app.';

  @override
  String get skapiScriptSaveAllOpenSummaryHowLxDebian =>
      'Itera la lista delle app, trova le finestre visibili di ciascuna, le attiva a turno e invia Ctrl+S tra le attese.';

  @override
  String get skapiScriptSaveAllOpenNoteLxDebian =>
      'La lista di app predefinita copre LibreOffice (soffice.bin), VS Code (code), gedit e kate. Passa --apps \"name1,name2\" per sovrascrivere. Solo X11.';

  @override
  String get skapiScriptSaveAllOpenParamAppsHintLxDebian =>
      'Nomi comm separati da virgola, per esempio: soffice.bin,code,gedit.';

  @override
  String get skapiScriptAutosaveTriggerSummaryHowLxDebian =>
      'Percorre ogni finestra di primo livello visibile tramite wmctrl -l, attiva ciascuna a turno e inietta Ctrl+S. X11 non dispone del percorso broadcast WIN WM_COMMAND, quindi il ripiego è il fuoco per finestra.';

  @override
  String get skapiScriptAutosaveTriggerNoteLxDebian =>
      'Livello 2: dipende dal fatto che l\'app a fuoco rispetti Ctrl+S come \"salva\". La maggior parte degli editor lo fa; le app di chat possono interpretarlo male. Solo X11.';

  @override
  String get commonReadFailed => 'lettura non riuscita';

  @override
  String get commonUnknown => 'sconosciuto';

  @override
  String get commonComingSoon => 'in arrivo';

  @override
  String get commonDismiss => 'Ignora';

  @override
  String bootstrapBannerError(String error) {
    return 'Impossibile leggere dal dispositivo: $error';
  }

  @override
  String get bootstrapBannerRetry => 'Riprova';

  @override
  String get bfApiChainAuthNone => 'Nessuna';

  @override
  String get bfApiChainAuthBearer => 'Bearer token';

  @override
  String get bfApiChainAuthBasic => 'Autenticazione Basic';

  @override
  String get bfApiChainAuthHeader => 'Header personalizzato';

  @override
  String bfApiChainMasterError(String error) {
    return 'Master: $error';
  }

  @override
  String get bfApiChainChainStarted => 'Catena avviata';

  @override
  String bfApiChainChainError(String error) {
    return 'Errore: $error';
  }

  @override
  String get bfApiChainSaveDialogTitle => 'Salvare l\'endpoint?';

  @override
  String bfApiChainSaveDialogBody(String name) {
    return '\"$name\" verrà reso persistente sul dispositivo. Questo aggiorna l\'\'area dati utente.';
  }

  @override
  String get bfApiChainSaveDialogConfirm => 'Salva';

  @override
  String bfApiChainSavedToast(String name) {
    return '\"$name\" salvato';
  }

  @override
  String bfApiChainSaveFailed(String error) {
    return 'Impossibile salvare: $error';
  }

  @override
  String get bfApiChainDeleteDialogTitle => 'Eliminare?';

  @override
  String bfApiChainDeleteDialogBody(String name) {
    return 'L\'\'endpoint \"$name\" verrà rimosso dal dispositivo. Questa azione non può essere annullata.';
  }

  @override
  String get bfApiChainDeleteDialogConfirm => 'Elimina';

  @override
  String bfApiChainDeletedToast(String name) {
    return '\"$name\" eliminato';
  }

  @override
  String bfApiChainDeleteFailed(String error) {
    return 'Impossibile eliminare: $error';
  }

  @override
  String bfApiChainTestNoReply(String name) {
    return '\"$name\" nessuna risposta (timeout 15 s)';
  }

  @override
  String bfApiChainTestSuccess(String name, String httpSuffix) {
    return '\"$name\" riuscito$httpSuffix';
  }

  @override
  String bfApiChainTestFailure(String name, String error, String httpSuffix) {
    return '\"$name\" errore: $error$httpSuffix';
  }

  @override
  String bfApiChainTestTriggerFailed(String error) {
    return 'Impossibile attivare: $error';
  }

  @override
  String get bfApiChainNewEndpointName => 'Nuovo endpoint';

  @override
  String get bfApiChainEmptyTitle => 'Ancora nessun endpoint registrato';

  @override
  String get bfApiChainEmptyBody =>
      'Usa la scheda \"Aggiungi endpoint\" qui sotto per definire una nuova chiamata HTTP (es. webhook IFTTT, il tuo server, pausa Spotify).';

  @override
  String get bfApiChainSystemSectionTitle => 'Automatico (SKAPP abbinati)';

  @override
  String get bfApiChainSystemSectionSubtitle =>
      'Quando associ uno script tramite SKAPI, si apre automaticamente uno slot per ogni computer. Allo scadere del conto alla rovescia, un webhook firmato viene inviato al SKAPP su quel computer.';

  @override
  String get bfApiChainUserSectionTitle => 'Manuale (dispositivi IoT)';

  @override
  String get bfApiChainUserSectionSubtitle =>
      'Aggiungi a mano URL di terze parti (Shelly, Home Assistant, IFTTT). Allo scadere del conto alla rovescia questa lista si attiva per prima, in ordine.';

  @override
  String get bfApiChainMasterToggleLabel => 'Trigger attivo';

  @override
  String get bfApiChainMasterOnSubtitle =>
      'Master attivo: la catena si attiva sui trigger del dispositivo';

  @override
  String get bfApiChainMasterOffSubtitle =>
      'Master disattivo: nessun endpoint verrà chiamato';

  @override
  String get bfApiChainFieldNameLabel => 'Nome';

  @override
  String get bfApiChainTypeLabel => 'Tipo';

  @override
  String get bfApiChainEventOrApplet => 'Evento / Applet';

  @override
  String get bfApiChainMethodLabel => 'Metodo';

  @override
  String get bfApiChainDelayLabel => 'Attendi dopo (0-300 s)';

  @override
  String get bfApiChainDelayUnit => 's';

  @override
  String get bfApiChainAdvancedHide => 'Nascondi opzioni avanzate';

  @override
  String get bfApiChainAdvancedShow => 'Opzioni avanzate';

  @override
  String get bfApiChainAuthLabel => 'Autenticazione';

  @override
  String bfApiChainCurrentTokenHint(String masked) {
    return 'Token attuale: $masked (scrivi un nuovo valore qui sotto per aggiornarlo)';
  }

  @override
  String get bfApiChainNewTokenLabel =>
      'Nuovo token (lascia vuoto per mantenere)';

  @override
  String get bfApiChainContentTypeLabel => 'Content-Type';

  @override
  String get bfApiChainSaveCta => 'Salva';

  @override
  String get bfApiChainDeleteCta => 'Elimina';

  @override
  String get bfApiChainTestCta => 'Prova';

  @override
  String get bfApiChainAddCardLabel => 'Aggiungi nuovo endpoint';

  @override
  String bfApiChainSavedDelaySeconds(int count) {
    return '$count s di attesa';
  }

  @override
  String get bfApiChainNotSaved => 'non salvato';

  @override
  String bfApiChainSystemRowSignedTooltip(String peer, int delay) {
    return 'peer $peer…  ·  ritardo ${delay}s  ·  firmato (HMAC)';
  }

  @override
  String get bfApiChainTestEndpointTooltip => 'Prova questo endpoint';

  @override
  String get bfLogsBufferEmpty =>
      'Il buffer dei registri del dispositivo è vuoto.';

  @override
  String get bfLogsUnsupported =>
      'Il dispositivo non supporta i registri in questo firmware.';

  @override
  String get deviceLogsNoClockBanner =>
      'Orologio del dispositivo non impostato; i timestamp sono mostrati come secondi dall\'avvio.';

  @override
  String get deviceLogsTruncatedHint =>
      '(output troncato, prova un limite più basso o una severità più alta)';

  @override
  String get bfEventsTimerRunning => 'Conto alla rovescia avviato';

  @override
  String get bfEventsTimerPaused => 'Conto alla rovescia in pausa';

  @override
  String get bfEventsTimerIdle => 'Conto alla rovescia azzerato';

  @override
  String get bfEventsTimerCooldown => 'Pausa';

  @override
  String get bfEventsTimerExpired => 'Conto alla rovescia terminato';

  @override
  String bfEventsFaceChanged(String from, String to) {
    return 'Faccia cambiata: $from → $to';
  }

  @override
  String bfEventsApiTriggered(String type) {
    return '$type attivato';
  }

  @override
  String get bfEventsApiTriggeredFallback => 'API attivata';

  @override
  String bfEventsBatteryLevel(int percent) {
    return 'Livello batteria: %$percent';
  }

  @override
  String get bfEventsDeviceRestarted => 'Dispositivo riavviato';

  @override
  String skapiManifestLoadingRetry(String platform, String scriptId) {
    return 'manifest $platform/$scriptId in caricamento, riprova tra un momento';
  }

  @override
  String get skapiListenerOffMobileTitle =>
      'Questo dispositivo non può eseguire script desktop';

  @override
  String get skapiListenerOffDesktopTitle =>
      'Il listener HTTP di SKAPP è disattivato';

  @override
  String get skapiListenerOffMobileBody =>
      'Allo scadere del conto alla rovescia, gli script verranno eseguiti su Windows / macOS / Linux. SKAPP deve essere aperto e il listener attivo. Questo telefono è solo il lato di configurazione; l\'esecuzione avviene sul desktop.';

  @override
  String skapiListenerOffDesktopBody(String lastErrorSuffix) {
    return 'BF attiverà il webhook, ma nessuno lo riceverà perché il listener è disattivato. Apri Impostazioni → SKAPP HTTP Listener.$lastErrorSuffix';
  }

  @override
  String get skapiSyncBadgeWriting => 'Scrittura su BF…';

  @override
  String get skapiSyncBadgeWritten => 'Salvato su BF';

  @override
  String get skapiSyncBadgeFailed => 'Impossibile scrivere su BF';

  @override
  String skapiSyncBadgeFirmwareCodeTooltip(String code) {
    return 'Codice firmware: $code';
  }

  @override
  String get syncErrUnknownCommand =>
      'Firmware vecchio sul dispositivo. Carica il nuovo firmware';

  @override
  String get syncErrNotAuthenticated =>
      'Sessione del dispositivo non autorizzata (potrebbe servire un riabbinamento)';

  @override
  String get syncErrNotFound => 'Nessun record di abbinamento sul dispositivo';

  @override
  String get syncErrInternal => 'Gli 8 slot SYSTEM potrebbero essere pieni';

  @override
  String get syncErrUnknown => 'errore sconosciuto';

  @override
  String get syncErrTimeout => 'Il dispositivo non ha risposto (offline?)';

  @override
  String get syncErrNoBond => 'Nessun abbinamento con questo dispositivo';

  @override
  String get syncErrConnect => 'Impossibile connettersi al dispositivo';

  @override
  String get discoveryFilterShowAll => 'Mostra tutti i dispositivi';

  @override
  String get discoveryFilterOnlySmartKraft => 'Solo SmartKraft';

  @override
  String discoveryScanningWithCount(int count, String tail) {
    return 'Scansione… $count dispositivi trovati$tail';
  }

  @override
  String discoveryFoundCountWithTail(int count, String tail) {
    return '$count dispositivi trovati$tail';
  }

  @override
  String discoveryFilterOff(int visible, int sk, String tail) {
    return 'Filtro disattivato · $visible dispositivi mostrati ($sk SmartKraft$tail)';
  }

  @override
  String discoveryMdnsTail(int count) {
    return ' + $count in rete';
  }

  @override
  String get discoveryWifiOnlySnack =>
      'Questo dispositivo è attualmente visibile solo via WiFi. L\'abbinamento WiFi non è ancora attivo, premi brevemente il pulsante del dispositivo per aprire la finestra di abbinamento. Una volta visto anche via BLE, questa riga diventa abbinabile.';

  @override
  String get discoveryBadgePairable => 'Abbinabile';

  @override
  String get discoveryBadgeBonded => 'Abbinato a un altro SKAPP';

  @override
  String get pairingTitleConnecting => 'Connessione';

  @override
  String get pairingTitleReconnecting => 'Riconnessione';

  @override
  String get pairingMutualAuthHmacSubtitle => 'Challenge-response HMAC';

  @override
  String pairingBleConnectFailed(String error) {
    return 'Connessione BLE non riuscita.\n\nSoluzione: premi brevemente il pulsante del dispositivo per aprire la finestra di abbinamento di 60 secondi, poi tocca \"Riprova\".\n\nDettagli: $error';
  }

  @override
  String get pairingGattServiceMissing => 'Servizio SKAPP non trovato';

  @override
  String get pairingGattCmdRxMissing => 'Caratteristica cmd_rx mancante';

  @override
  String get pairingGattEventTxMissing => 'Caratteristica event_tx mancante';

  @override
  String pairingGattDiscoveryFailed(String error) {
    return 'Scoperta GATT non riuscita: $error';
  }

  @override
  String pairingKeySendFailed(String error) {
    return 'Impossibile inviare la chiave: $error';
  }

  @override
  String pairingDeviceNoReply(int seconds) {
    return 'Il dispositivo non ha risposto ($seconds s).';
  }

  @override
  String pairingDeviceRejected(String error) {
    return 'Dispositivo rifiutato: $error';
  }

  @override
  String get pairingInvalidReplyMissingPub =>
      'Risposta del dispositivo non valida (our_pub mancante).';

  @override
  String pairingHexDecodeFailed(String error) {
    return 'Decodifica hex di our_pub non riuscita: $error';
  }

  @override
  String get pairingRetryButton => 'Riprova';

  @override
  String pairingReconnectTransient(String error) {
    return 'Impossibile raggiungere il dispositivo; l\'\'abbinamento esistente viene mantenuto.\n\nAssicurati che il dispositivo sia acceso e a portata, poi tocca \"Riprova\".\n\nDettagli: $error';
  }

  @override
  String get pairingRecoveryTitle => 'Rinnova abbinamento';

  @override
  String get pairingRecoveryBody =>
      'Il dispositivo non riconosce l\'abbinamento attuale. Per avviarne uno nuovo, premi il pulsante di abbinamento del dispositivo per aprire la finestra di 60 secondi, poi tocca Continua.';

  @override
  String get pairingRecoveryContinue => 'Continua';

  @override
  String get pairingRecoveryCancelled =>
      'Rinnovo dell\'abbinamento annullato. Il vecchio abbinamento è ancora registrato; tocca \"Riprova\" per tentare un\'altra connessione più tardi.';

  @override
  String get pairingRenewBondButton => 'Rinnova abbinamento';

  @override
  String wifiPasswordConnectionRejected(String error) {
    return 'Connessione rifiutata: $error';
  }

  @override
  String get wifiPasswordTimeout => 'Il dispositivo non ha risposto (timeout).';

  @override
  String wifiScanRejected(String error) {
    return 'Il dispositivo ha rifiutato wifi.scan: $error\n\nIl modulo WiFi del dispositivo potrebbe non essere partito; prova un riavvio.';
  }

  @override
  String wifiScanUnexpectedReply(String data) {
    return 'Risposta wifi.scan imprevista: $data';
  }

  @override
  String wifiScanTimeout(String error) {
    return 'Il dispositivo non ha risposto (timeout: $error).\n\nAvvicinati al dispositivo, premi brevemente il suo pulsante (per attivare l\'\'advertising) e riprova.';
  }

  @override
  String wifiScanConnectionError(String error) {
    return 'Errore di connessione: $error';
  }

  @override
  String get wifiScanHeaderHelp =>
      'Di seguito sono mostrate le reti WiFi **che il dispositivo** vede (non le reti del telefono). Scegli la rete a cui il dispositivo deve unirsi; la password viene richiesta nel passaggio successivo.';

  @override
  String get wifiScanAuthOpen => 'Aperta';

  @override
  String get wifiScanAuthEncrypted => 'Crittografata';

  @override
  String get wifiSuccessSyncing => 'Sincronizzazione ora…';

  @override
  String get wifiSuccessFetchingInfo => 'Recupero info dispositivo…';

  @override
  String get wifiSuccessPreparingUi => 'Preparazione UI dispositivo…';

  @override
  String wifiSuccessManifestRejected(String error) {
    return 'device.manifest rifiutato ($error). Potrebbe essere firmware vecchio; sk_baseline.c deve essere caricato per BF.';
  }

  @override
  String get wifiSuccessTapToContinue => 'Tocca per continuare…';

  @override
  String get deviceHomeUnsupportedTitle => 'Dispositivo non supportato';

  @override
  String deviceHomeUnsupportedBody(String name) {
    return '$name non ha una schermata dispositivo in questa versione di SKAPP. Quando verrà aggiunta una nuova famiglia di dispositivi, questa schermata apparirà automaticamente.';
  }

  @override
  String get lsPairingUnpairTitle => 'Scollega questa APP';

  @override
  String get lsPairingUnpairBody =>
      'Il dispositivo dimenticherà il bond di questa APP. Dovrai riabbinare (pulsante 3 s + seleziona in Dispositivi).';

  @override
  String get skYakindaBadgeDefault => 'in arrivo';

  @override
  String get skapiScriptPulseBrightnessTitle => 'Pulsa luminosità';

  @override
  String get skapiScriptPulseBrightnessSummaryWhat =>
      'Modula la luminosità del display interno su un\'onda coseno fluida tra il 100% e un limite inferiore, ripetuta un numero di volte impostato. La luminosità originale dell\'utente viene ripristinata alla fine.';

  @override
  String get skapiScriptPulseBrightnessSummaryHow =>
      'Legge la luminosità corrente tramite WMI, poi scrive un campione di luminosità 20 volte al secondo seguendo una curva coseno. Ripristina sempre l\'originale acquisito all\'uscita.';

  @override
  String get skapiScriptPulseBrightnessNote =>
      'Solo pannelli interni (laptop, tablet). I monitor esterni DDC/CI non rispondono a questo percorso WMI.';

  @override
  String get skapiScriptPulseBrightnessParamPeriodLabel => 'periodo';

  @override
  String get skapiScriptPulseBrightnessParamPeriodHint =>
      'Secondi per un ciclo completo luminoso -> scuro -> luminoso. Intorno a 2 dà l\'impressione di un impulso chiaro senza essere fastidioso.';

  @override
  String get skapiScriptPulseBrightnessParamLowPercentLabel => '% min';

  @override
  String get skapiScriptPulseBrightnessParamLowPercentHint =>
      'Estremo scuro dell\'impulso, come percentuale della luminosità massima. Numeri più bassi rendono l\'impulso più marcato.';

  @override
  String get skapiScriptPulseBrightnessParamCyclesLabel => 'cicli';

  @override
  String get skapiScriptPulseBrightnessParamCyclesHint =>
      'Quanti cicli completi di impulso eseguire prima di uscire.';

  @override
  String get skapiScriptBlurTimedTitle => 'Pausa sfocata';

  @override
  String get skapiScriptBlurTimedSummaryWhat =>
      'Copre lo schermo con un velo semitrasparente a schermo intero, sempre in primo piano, per il numero di secondi configurato. Al centro viene mostrato un conto alla rovescia.';

  @override
  String get skapiScriptBlurTimedSummaryHow =>
      'Apre una finestra WPF senza bordi con AllowsTransparency e un pennello a tinta unita all\'opacità scelta. Un dispatcher timer gestisce il conto alla rovescia; la finestra si chiude da sola quando il timer arriva a zero.';

  @override
  String get skapiScriptBlurTimedNote =>
      'Soluzione pragmatica provvisoria: una vera sfocatura gaussiana in tempo reale sul desktop richiede un helper C++/Win2D che arriverà più avanti. Nel frattempo il velo a tinta unita crea un attrito simile, \'non riesco a concentrarmi sullo schermo, fai una pausa\'.';

  @override
  String get skapiScriptBlurTimedParamDurationLabel => 'durata';

  @override
  String get skapiScriptBlurTimedParamDurationHint =>
      'Secondi in cui il velo resta visibile prima di chiudersi automaticamente.';

  @override
  String get skapiScriptBlurTimedParamOpacityLabel => 'opacità';

  @override
  String get skapiScriptBlurTimedParamOpacityHint =>
      'Opacità del velo da 0.0 (invisibile) a 1.0 (pieno). Intorno a 0.55 lascia ancora trasparire abbastanza il desktop da farlo sembrare velato, non oscurato.';

  @override
  String get skapiScriptBlurTimedParamColorLabel => 'colore';

  @override
  String get skapiScriptBlurTimedParamColorHint =>
      'Colore del velo in esadecimale #RRGGBB. Il nero della palette #0A0A0A è il valore predefinito; le tinte crema più chiare risultano più rilassanti.';

  @override
  String get skapiScriptBlockingFocusTitle => 'Blocking Focus';

  @override
  String get skapiScriptBlockingFocusSummaryWhat =>
      'Strumento di concentrazione composito: salva tutti i documenti Office e VS Code aperti, poi apre una finestra di conto alla rovescia a schermo intero, sempre in primo piano e senza pulsante di chiusura, mentre il cursore del mouse gira di continuo. Quando il timer arriva a zero tutto viene annullato automaticamente.';

  @override
  String get skapiScriptBlockingFocusSummaryHow =>
      'Tre fasi si susseguono: (1) la fase di salvataggio chiama Office COM e la CLI di VS Code; (2) un runspace parallelo fa girare il cursore in cerchio finché un flag di stop sincronizzato non scatta; (3) una finestra WPF STA mostra il titolo e il conto alla rovescia. Un blocco finally ripristina l\'origine del cursore e smonta entrambi i runspace.';

  @override
  String get skapiScriptBlockingFocusNote =>
      'Modalità soft: Esc e Alt+F4 NON sono bloccati. L\'utente può sempre uscire tramite Task Manager. La modalità rigida con hook globali della tastiera sarà uno script separato.';

  @override
  String get skapiScriptBlockingFocusParamDurationLabel => 'durata';

  @override
  String get skapiScriptBlockingFocusParamDurationHint =>
      'Secondi di durata del blocco. Il conto alla rovescia scende fino a 00:00 poi tutto viene ripulito.';

  @override
  String get skapiScriptBlockingFocusParamTitleLabel => 'titolo';

  @override
  String get skapiScriptBlockingFocusParamTitleHint =>
      'Testo mostrato al centro della finestra a schermo intero. Mantienilo breve - \'Blocking Focus\' è il valore predefinito.';

  @override
  String get skapiScriptBlockingFocusParamShakeRadiusLabel =>
      'raggio movimento';

  @override
  String get skapiScriptBlockingFocusParamShakeRadiusHint =>
      'Pixel percorsi dal cursore rispetto alla sua origine durante il ciclo. Cerchi più grandi richiamano di più l\'attenzione.';

  @override
  String get skapiScriptBlockingFocusParamEnableSaveLabel => 'salva all\'avvio';

  @override
  String get skapiScriptBlockingFocusParamEnableSaveHint =>
      'Esegue la fase di salvataggio Office + VS Code prima del blocco. Disattivala quando non c\'è alcuno stato di documento da proteggere.';

  @override
  String get trayFirstHideToast =>
      'SKAPP continua a funzionare in background. Trovalo nell\'area di notifica; clic destro per Esci.';

  @override
  String devicesOfflineTapHint(String name) {
    return '$name è offline.';
  }

  @override
  String skapiNewActionDeviceOffline(String name) {
    return '$name è offline. Portalo online per creare una nuova azione.';
  }

  @override
  String get bfApiChainRefreshDirtyTitle => 'Modifiche non salvate';

  @override
  String get bfApiChainRefreshDirtyBody =>
      'L\'aggiornamento recupererà l\'ultima lista di endpoint dal dispositivo e scarterà la bozza non ancora salvata.';

  @override
  String get bfApiChainRefreshDirtyConfirm => 'Aggiorna comunque';

  @override
  String get skapiApiEditorTitle => 'API sul dispositivo';

  @override
  String get lsCommonReadFailed => 'Lettura non riuscita';

  @override
  String lsCommonFailedWith(String err) {
    return 'Non riuscito: $err';
  }

  @override
  String get lsVacationStatusOff => 'Disattivo';

  @override
  String lsVacationStatusUntil(String date) {
    return 'Fino al $date';
  }

  @override
  String get lsVacationDaysValidationError =>
      'I giorni devono essere tra 1 e 60';

  @override
  String lsVacationStartedSnack(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Vacanza avviata · $days giorni',
      one: 'Vacanza avviata · 1 giorno',
    );
    return '$_temp0';
  }

  @override
  String get lsVacationCancelledSnack => 'Vacanza annullata';

  @override
  String lsVacationActiveUntilFmt(String date) {
    return 'Attiva fino al $date';
  }

  @override
  String get lsVacationResumeHint =>
      'Il conto alla rovescia riprenderà al termine della vacanza.';

  @override
  String get lsVacationCancellingButton => 'Annullamento…';

  @override
  String get lsVacationCancelButton => 'Annulla vacanza';

  @override
  String get lsVacationDaysLabel => 'Giorni';

  @override
  String get lsVacationDaysHint =>
      'Mette in pausa il conto alla rovescia per questo numero di giorni (da 1 a 60).';

  @override
  String get lsVacationStartingButton => 'Avvio…';

  @override
  String get lsVacationStartButton => 'Avvia vacanza';

  @override
  String get lsCommonSavingButton => 'Salvataggio…';

  @override
  String get lsCommonSaveButton => 'Salva';

  @override
  String lsCommonSaveFailedWith(String err) {
    return 'Salvataggio non riuscito: $err';
  }

  @override
  String get lsDurationValueValidationError =>
      'Il valore deve essere tra 1 e 60';

  @override
  String get lsDurationAlarmsValidationError =>
      'Il numero di allarmi deve essere tra 0 e 10';

  @override
  String get lsDurationConfiguredSnack => 'Timer configurato';

  @override
  String lsDurationUnitMinute(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value minuti',
      one: '1 minuto',
    );
    return '$_temp0';
  }

  @override
  String lsDurationUnitHour(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value ore',
      one: '1 ora',
    );
    return '$_temp0';
  }

  @override
  String lsDurationUnitDay(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value giorni',
      one: '1 giorno',
    );
    return '$_temp0';
  }

  @override
  String lsDurationAlarmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count allarmi',
      one: '1 allarme',
    );
    return '$_temp0';
  }

  @override
  String get lsDurationUnitLabel => 'Unità';

  @override
  String get lsDurationUnitMinutesPlural => 'minuti';

  @override
  String get lsDurationUnitHoursPlural => 'ore';

  @override
  String get lsDurationUnitDaysPlural => 'giorni';

  @override
  String get lsDurationValueLabel => 'Valore';

  @override
  String get lsDurationValueHint => 'Da 1 a 60';

  @override
  String get lsDurationAlarmCountLabel => 'Numero di allarmi';

  @override
  String get lsDurationAlarmCountHint =>
      'Gli allarmi scattano a ritroso dalla fine, a un\'unità di distanza l\'uno dall\'altro.';

  @override
  String get lsSmtpStatusNotConfigured => 'Non configurato';

  @override
  String get lsSmtpHostRequired => 'L\'host è obbligatorio';

  @override
  String get lsSmtpPortValidationError => 'La porta deve essere tra 1 e 65535';

  @override
  String get lsSmtpSenderRequired => 'L\'indirizzo del mittente è obbligatorio';

  @override
  String get lsSmtpFieldHost => 'Host';

  @override
  String get lsSmtpFieldPort => 'Porta';

  @override
  String get lsSmtpFieldSender => 'Mittente';

  @override
  String get lsSmtpFieldKey => 'Chiave';

  @override
  String lsSmtpSaveHaltedOn(String err) {
    return 'Salvataggio interrotto su $err';
  }

  @override
  String get lsSmtpSavedSnack => 'SMTP salvato';

  @override
  String get lsSmtpTestSentSnack => 'Mail di prova inviata';

  @override
  String lsSmtpTestFailedWith(String err) {
    return 'Prova non riuscita: $err';
  }

  @override
  String get lsSmtpUrlCopiedSnack => 'URL copiato negli appunti';

  @override
  String get lsSmtpApiKeyPlaceholder => 'App Password Gmail / chiave API';

  @override
  String get lsSmtpServerLabel => 'Server';

  @override
  String get lsSmtpApiKeyLabel => 'Chiave API';

  @override
  String get lsSmtpApiKeyHint =>
      'Lascia vuoto per mantenere la chiave attuale.';

  @override
  String get lsSmtpAppPasswordHelpLink =>
      'Come ottenere una App Password Gmail';

  @override
  String get lsSmtpSendingButton => 'Invio…';

  @override
  String get lsSmtpSendTestButton => 'Invia prova';

  @override
  String get lsReminderMailRecipientValidation =>
      'Il destinatario deve avere l\'aspetto di un indirizzo email';

  @override
  String get lsReminderMailSavedSnack => 'Promemoria salvato in locale';

  @override
  String get lsReminderMailRecipientFirstSnack =>
      'Imposta prima un destinatario';

  @override
  String get lsReminderMailTestOkSnack =>
      'Prova SMTP OK, le credenziali raggiungono il server';

  @override
  String lsReminderMailTestFailedWith(String err) {
    return 'Prova SMTP non riuscita: $err';
  }

  @override
  String get lsReminderMailRecipientLabel => 'Email destinatario';

  @override
  String get lsReminderMailSubjectLabel => 'Oggetto';

  @override
  String get lsReminderMailBodyLabel => 'Corpo';

  @override
  String get lsReminderMailBodyHint =>
      'Il tuo conto alla rovescia scatterà a breve...';

  @override
  String get lsReminderMailActiveLabel => 'Attivo';

  @override
  String get lsReminderMailFootnote =>
      'Salvato in locale su questo dispositivo. La prova di invio verifica solo che il server SMTP sia raggiungibile; l\'attivazione automatica su timer.alarm è in attesa del supporto del firmware.';

  @override
  String get lsResetApiStatusDisabled => 'Disattivato';

  @override
  String lsResetApiStatusEnabledPort(int port) {
    return 'Attivato · porta $port';
  }

  @override
  String get lsResetApiRegenDialogTitle => 'Rigenerare la chiave API?';

  @override
  String get lsResetApiRegenDialogBody =>
      'Questo invaliderà la chiave attuale. Qualsiasi chiamante che usa la chiave precedente verrà rifiutato finché non la aggiorni. Continuare?';

  @override
  String get lsResetApiRegenConfirm => 'Rigenera';

  @override
  String get lsResetApiKeyRegeneratedSnack => 'Chiave rigenerata';

  @override
  String get lsResetApiEnabledLabel => 'Attivato';

  @override
  String get lsResetApiEnabledHint =>
      'Quando è attivo, una GET HTTP all\'URL dell\'endpoint con la chiave corrispondente azzera il conto alla rovescia.';

  @override
  String get lsResetApiEndpointUrlLabel => 'URL endpoint';

  @override
  String get lsResetApiUrlNotAvailable => '(non disponibile)';

  @override
  String get lsResetApiCopyUrlTooltip => 'Copia URL';

  @override
  String get lsResetApiKeyLabel => 'Chiave API';

  @override
  String get lsResetApiKeyNotSet => '(non impostata)';

  @override
  String get lsResetApiExampleLabel => 'Esempio';

  @override
  String get lsResetApiRegenerateButton => 'Rigenera chiave';

  @override
  String get lsAlarmApiUrlValidation =>
      'L\'URL deve iniziare con http:// o https://';

  @override
  String get lsAlarmApiHeadersValidation =>
      'Il campo Header deve essere JSON valido';

  @override
  String get lsAlarmApiSaveDialogTitle => 'Salvare l\'endpoint webhook?';

  @override
  String lsAlarmApiSaveDialogBody(String name, String url) {
    return 'Memorizza `$name` sul dispositivo puntando a:\n$url';
  }

  @override
  String get lsAlarmApiSavedSnack => 'Webhook salvato';

  @override
  String get lsAlarmApiDisabledSnack => 'Webhook disattivato';

  @override
  String get lsAlarmApiTestQueuedSnack =>
      'Prova in coda, controlla il servizio a monte';

  @override
  String lsAlarmApiTestFailedWith(String err) {
    return 'Prova non riuscita: $err';
  }

  @override
  String get lsAlarmApiRemoveDialogTitle => 'Rimuovere il webhook?';

  @override
  String lsAlarmApiRemoveDialogBody(String name) {
    return 'Elimina `$name` dal dispositivo. La configurazione locale viene mantenuta.';
  }

  @override
  String get lsAlarmApiRemoveButton => 'Rimuovi';

  @override
  String lsAlarmApiRemoveFailedWith(String err) {
    return 'Rimozione non riuscita: $err';
  }

  @override
  String get lsAlarmApiConfiguredStatus => 'Configurato';

  @override
  String lsAlarmApiConfiguredHost(String host) {
    return 'Configurato · $host';
  }

  @override
  String get lsAlarmApiUrlLabel => 'URL';

  @override
  String get lsAlarmApiMethodLabel => 'Metodo HTTP';

  @override
  String get lsAlarmApiHeadersLabel => 'Header (JSON, facoltativo)';

  @override
  String get lsAlarmApiHeadersHint =>
      'Oggetto JSON con header opzionali. Salvato in locale; il firmware lo applica all\'attivazione.';

  @override
  String get lsAlarmApiBodyTemplateLabel => 'Template del corpo (JSON)';

  @override
  String get lsAlarmApiBodyTemplateHint =>
      'I segnaposto device e remaining_sec vengono sostituiti al momento dell\'attivazione.';

  @override
  String get lsAlarmApiBearerLabel => 'Bearer token (facoltativo)';

  @override
  String get lsAlarmApiFootnote =>
      'Il sottoscrittore firmware per l\'evento timer.alarm è in attesa. Questa configurazione memorizza l\'endpoint; non si attiverà automaticamente fino al prossimo aggiornamento del firmware.';

  @override
  String lsRelaySummarySeconds(int seconds) {
    return '${seconds}s';
  }

  @override
  String lsRelaySummaryMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get lsRelayModePulse => 'impulso';

  @override
  String get lsRelayModeSteady => 'fisso';

  @override
  String lsRelaySummaryFmt(int gpio, String duration, String mode) {
    return 'GPIO $gpio · $duration $mode';
  }

  @override
  String get lsRelayGpioValidation => 'Il GPIO deve essere tra 0 e 30';

  @override
  String get lsRelayDurationValidation =>
      'La durata deve essere tra 1 e 3600 secondi';

  @override
  String get lsRelayPulseValidation =>
      'Il semiciclo dell\'impulso deve essere tra 1 e 60';

  @override
  String lsRelayCmdFailedWith(String cmd, String err) {
    return '$cmd non riuscito: $err';
  }

  @override
  String get lsRelayConfiguredSnack => 'Relè configurato';

  @override
  String get lsRelayFireAbortedSnack => 'Attivazione interrotta';

  @override
  String get lsRelayForcedIdleSnack => 'Relè forzato in standby';

  @override
  String get lsRelayGpioLabel => 'Pin GPIO';

  @override
  String get lsRelayGpioHint => 'Pin valido ESP32-C6; predefinito 19 = D8';

  @override
  String get lsRelayInvertLabel => 'Inverti polarità';

  @override
  String get lsRelayStartDelayLabel => 'Ritardo di avvio';

  @override
  String lsRelayStartDelayHint(int sec) {
    return '${sec}s prima che il relè si attivi';
  }

  @override
  String get lsRelayActiveDurationLabel => 'Durata attiva';

  @override
  String get lsRelayUnitSeconds => 'Secondi';

  @override
  String get lsRelayUnitMinutes => 'Minuti';

  @override
  String get lsRelayPulseModeLabel => 'Modalità impulso';

  @override
  String get lsRelayPulseModeHint =>
      'On = semiciclo di 1 s. Personalizzato permette di impostare il semiciclo.';

  @override
  String get lsRelayHalfCycleLabel => 'Secondi del semiciclo';

  @override
  String get lsRelayFiringButton => 'Attivazione…';

  @override
  String get lsRelayTestRelayButton => 'Prova relè';

  @override
  String get lsRelayAbortButton => 'Interrompi';

  @override
  String get lsRelayForceOffButton => 'Forza spegnimento';

  @override
  String get lsRelayPulseOff => 'Off';

  @override
  String get lsRelayPulseOn => 'On';

  @override
  String get lsRelayPulseCustom => 'Personalizzato';

  @override
  String get lsRelayPhaseActiveBadge => 'attiva';

  @override
  String lsRelayPhaseLine(String phase, String elapsed) {
    return 'Fase: $phase$elapsed';
  }

  @override
  String get lsTelegramTokenRequired => 'Il token del bot è obbligatorio';

  @override
  String get lsTelegramChatRequired => 'L\'id della chat è obbligatorio';

  @override
  String get lsTelegramSaveDialogTitle => 'Salvare l\'endpoint Telegram?';

  @override
  String lsTelegramSaveDialogBody(String name) {
    return 'Memorizza `$name` sul dispositivo. Il token è inviato nell\'\'URL.';
  }

  @override
  String get lsTelegramSavedSnack => 'Endpoint Telegram salvato';

  @override
  String get lsTelegramDisabledSnack => 'Endpoint Telegram disattivato';

  @override
  String get lsTelegramTestQueuedSnack =>
      'Prova in coda, controlla la chat Telegram';

  @override
  String get lsTelegramRemoveDialogTitle => 'Rimuovere l\'endpoint Telegram?';

  @override
  String get lsTelegramBotConfiguredStatus => 'Bot configurato';

  @override
  String get lsTelegramBotTokenLabel => 'Token del bot';

  @override
  String get lsTelegramBotTokenHint =>
      'Ottienine uno da @BotFather (ha l\'aspetto di 1234567:AAH...).';

  @override
  String get lsTelegramChatIdLabel => 'ID chat';

  @override
  String get lsTelegramChatIdHint =>
      'Un id numerico (-100...) o un username @canale.';

  @override
  String get lsTelegramMessageTemplateLabel => 'Template del messaggio';

  @override
  String get lsTelegramMessageHint => 'LebensSpur: Allarme attivato.';

  @override
  String get lsLsApiUrlRequired => 'URL obbligatorio';

  @override
  String get lsLsApiUpdatedSnack => 'Webhook aggiornato';

  @override
  String get lsLsApiSavedSnack => 'Webhook salvato';

  @override
  String get lsLsApiSaveFirstSnack => 'Salva prima il webhook';

  @override
  String get lsLsApiTestQueuedSnack => 'Prova in coda, controlla il ricevitore';

  @override
  String get lsLsApiRemoveDialogBody =>
      'Il webhook LS verrà eliminato dal dispositivo. Il conto alla rovescia non lo attiverà più.';

  @override
  String get lsLsApiRemovedSnack => 'Webhook rimosso';

  @override
  String get lsLsApiConfirmCriticalTitle => 'Conferma modifica critica';

  @override
  String lsLsApiConfirmCriticalBody(String cmd, int ttlSec) {
    return 'Il dispositivo chiede di confermare:\n  $cmd\n\nQuesto token scade tra ${ttlSec}s.';
  }

  @override
  String get lsLsApiConfirmButton => 'Conferma';

  @override
  String lsLsApiActiveSlot(String name) {
    return 'Attivo · slot \"$name\"';
  }

  @override
  String lsLsApiActiveWithToken(String name, String token) {
    return 'Attivo · slot \"$name\" · token $token';
  }

  @override
  String get lsLsApiUrlHint =>
      'Attivato quando scatta timer.triggered. Consigliato https://.';

  @override
  String get lsLsApiHeadersLabel => 'Header (JSON)';

  @override
  String get lsLsApiHeadersHint =>
      'Avanzato: non ancora collegato tramite CLI. Riservato per una versione futura.';

  @override
  String get lsLsApiBodyTemplateHint =>
      'Inviato come payload di prova. Il segnaposto device viene sostituito lato server.';

  @override
  String lsLsApiBearerHintExisting(String token) {
    return 'Attualmente impostato: $token. Lascia vuoto per mantenere, o incolla un nuovo valore per sovrascrivere.';
  }

  @override
  String get lsLsApiBearerHintEmpty =>
      'Inviato come `Authorization: Bearer <token>`.';

  @override
  String get lsLsApiUpdateButton => 'Aggiorna';

  @override
  String lsMailGroupsStatusFmt(int count, int max, int recipients) {
    return '$count di $max · $recipients destinatari in totale';
  }

  @override
  String lsMailGroupsReadFailedWith(String err) {
    return 'Lettura non riuscita: $err';
  }

  @override
  String get lsMailGroupsNameValidation =>
      'Il nome deve essere tra 1 e 47 caratteri';

  @override
  String get lsMailGroupsNameSaved => 'Nome salvato';

  @override
  String get lsMailGroupsSubjectValidation =>
      'L\'oggetto deve avere al massimo 127 caratteri';

  @override
  String get lsMailGroupsSubjectSaved => 'Oggetto salvato';

  @override
  String get lsMailGroupsBodyValidation =>
      'Il corpo deve avere al massimo 511 caratteri';

  @override
  String get lsMailGroupsBodySaved => 'Corpo salvato';

  @override
  String get lsMailGroupsEmailValidation => 'Inserisci un\'email valida';

  @override
  String lsMailGroupsMaxReached(int max) {
    return 'Il massimo è $max gruppi';
  }

  @override
  String get lsMailGroupsNameEmpty => 'Il nome non può essere vuoto';

  @override
  String get lsMailGroupsCreatedSnack => 'Gruppo creato';

  @override
  String lsMailGroupsCreateFailedWith(String err) {
    return 'Creazione non riuscita: $err';
  }

  @override
  String get lsMailGroupsDeleteDialogTitle => 'Eliminare il gruppo?';

  @override
  String get lsMailGroupsDeleteDialogBody =>
      'Questo rimuove il gruppo e tutti i suoi destinatari sul dispositivo.';

  @override
  String get lsMailGroupsDeleteConfirm => 'Elimina';

  @override
  String get lsMailGroupsDeletedSnack => 'Gruppo eliminato';

  @override
  String lsMailGroupsDefaultName(int n) {
    return 'Gruppo $n';
  }

  @override
  String get lsMailGroupsNewGroupTitle => 'Nuovo gruppo email';

  @override
  String get lsMailGroupsGroupNameLabel => 'Nome gruppo';

  @override
  String get lsMailGroupsCreateConfirm => 'Crea';

  @override
  String get lsMailGroupsEmptyHint =>
      'Ancora nessun gruppo. Creane uno per inviare mail quando scatta il timer.';

  @override
  String get lsMailGroupsWorkingButton => 'In corso…';

  @override
  String get lsMailGroupsCreateNewButton => '+ Crea nuovo gruppo';

  @override
  String lsMailGroupsHeaderCount(int count, int max) {
    return '$count di $max gruppi configurati';
  }

  @override
  String lsMailGroupsHeaderTotalRecipients(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count destinatari in totale',
      one: '1 destinatario in totale',
    );
    return '· $_temp0';
  }

  @override
  String get lsMailGroupsUnnamed => '(senza nome)';

  @override
  String lsMailGroupsRowSummary(int count, String state) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count destinatari',
      one: '1 destinatario',
    );
    return '$_temp0 · $state';
  }

  @override
  String get lsMailGroupsEnabled => 'attivo';

  @override
  String get lsMailGroupsDisabled => 'disattivato';

  @override
  String get lsMailGroupsNameLabel => 'Nome';

  @override
  String get lsMailGroupsSubjectLabel => 'Oggetto';

  @override
  String get lsMailGroupsSaveBodyButton => 'Salva corpo';

  @override
  String get lsMailGroupsDeleteGroupButton => 'Elimina gruppo';

  @override
  String lsMailGroupsRecipientsHeader(int count) {
    return 'Destinatari ($count)';
  }

  @override
  String get lsMailGroupsNoRecipients => 'Ancora nessun destinatario.';

  @override
  String get lsMailGroupsAddRecipientButton => 'Aggiungi';

  @override
  String get lsHomeStatusLoading => 'Caricamento…';

  @override
  String get lsHomeLogsTooltip => 'Registri';

  @override
  String get lsHomeClusterConfiguration => 'CONFIGURAZIONE';

  @override
  String get lsHomeClusterTriggerActions => 'AZIONI TRIGGER';

  @override
  String get lsHomeClusterEarlyWarning => 'PREAVVISO';

  @override
  String get lsHomeSectionDurationTitle => 'Durata e allarmi';

  @override
  String get lsHomeSectionVacationTitle => 'Modalità vacanza';

  @override
  String get lsHomeSectionSmtpTitle => 'Configurazione mail (SMTP)';

  @override
  String get lsHomeSectionResetApiTitle => 'Endpoint API di reset';

  @override
  String get lsHomeSectionMailGroupsTitle => 'Gruppi email';

  @override
  String get lsHomeSectionRelayTitle => 'Relè';

  @override
  String get lsHomeSectionLsApiTitle => 'Webhook LS API';

  @override
  String get lsHomeSectionTelegramTitle => 'Telegram';

  @override
  String get lsHomeSectionReminderMailTitle => 'Mail di promemoria';

  @override
  String get lsHomeSectionAlarmApiTitle => 'Webhook Alarm API';

  @override
  String get lsHomeStateInactive => 'INATTIVO';

  @override
  String get lsHomeStateRemaining => 'RIMANENTE';

  @override
  String get lsHomeStateVacation => 'VACANZA';

  @override
  String get lsHomeStateTriggered => 'ATTIVATO';

  @override
  String get lsHomeChipBle => 'BLE';

  @override
  String get lsHomeChipMail => 'Mail';

  @override
  String get lsHomeEarlyWarningPendingNote =>
      'Le azioni di preavviso si attivano su timer.alarm. Il sottoscrittore firmware è in attesa; queste configurazioni persistono ma non si attiveranno ancora automaticamente.';

  @override
  String get settingsDiagnosticsTitle => 'Diagnostica';

  @override
  String get settingsDiagnosticsSubtitle =>
      'Registri per aiutare a risolvere i problemi';

  @override
  String get diagnosticsCopyLogs => 'Copia registri';

  @override
  String get diagnosticsOpenFolder => 'Apri cartella';

  @override
  String get diagnosticsOpenFolderFailed =>
      'Impossibile aprire la cartella dei registri.';

  @override
  String get diagnosticsShareLogs => 'Condividi registri';

  @override
  String get diagnosticsClearLogs => 'Cancella registri';

  @override
  String get diagnosticsCopied => 'Registri copiati negli appunti';

  @override
  String get diagnosticsCleared => 'Registri cancellati';

  @override
  String get aboutPrivacyLabel => 'Informativa sulla privacy';

  @override
  String get updateChecking => 'Verifica aggiornamenti…';

  @override
  String get updateUpToDate => 'Hai l\'ultima versione';

  @override
  String get updateCheckFailed => 'Impossibile verificare gli aggiornamenti';

  @override
  String get updateAvailableTitle => 'Aggiornamento disponibile';

  @override
  String updateAvailableBody(String version, String current) {
    return 'È disponibile una nuova versione ($version). Hai la $current.';
  }

  @override
  String get updateDownloadAction => 'Scarica';

  @override
  String get updateLater => 'Più tardi';
}
