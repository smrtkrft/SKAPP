// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SKAPP';

  @override
  String get brandTagline => 'SmartKraft';

  @override
  String get tabHome => 'Home';

  @override
  String get tabDevices => 'Devices';

  @override
  String get tabSkapi => 'SKAPI';

  @override
  String get tabSettings => 'Settings';

  @override
  String get tabSmartKraft => 'SmartKraft';

  @override
  String get comingSoonBadge => 'coming soon';

  @override
  String get featureComingSoonSnack => 'This feature is coming soon';

  @override
  String get homeWelcome => 'Welcome to SmartKraft';

  @override
  String get homeSubtitle => 'Manage your SmartKraft devices';

  @override
  String get homeAddDevice => 'Add new device';

  @override
  String get homeNoDevicesTitle => 'No devices yet';

  @override
  String get homeNoDevicesHint =>
      'Add your first SmartKraft device to get started.';

  @override
  String get homeSummaryTitle => 'Overview';

  @override
  String homeDevicesOnline(int count) {
    return '$count connected';
  }

  @override
  String homeDevicesOffline(int count) {
    return '$count offline';
  }

  @override
  String get homeUpdatesTitle => 'Updates available';

  @override
  String homeUpdatesBody(int count) {
    return '$count device has a newer firmware.';
  }

  @override
  String get homeWarningsTitle => 'Warnings';

  @override
  String homeWarningsBody(int count) {
    return '$count device reported an issue.';
  }

  @override
  String get homeAllGood => 'Everything is running smoothly.';

  @override
  String get devicesTitle => 'Devices';

  @override
  String get devicesEmpty =>
      'No devices added yet.\nTap the + button to add one.';

  @override
  String get devicesAdd => 'Add device';

  @override
  String get devicesAllSection => 'All devices';

  @override
  String get devicesGroupsTitle => 'Your groups';

  @override
  String get devicesGroupsHint =>
      'Create groups to organize your devices however you like.';

  @override
  String get devicesGroupsCreate => 'New group';

  @override
  String get devicesGroupsEmpty => 'No groups yet.';

  @override
  String get skapiTitle => 'SKAPI';

  @override
  String get skapiLibraryHeading => 'SKAPI Library';

  @override
  String get skapiLibrarySubtitle =>
      'Pick the platform your devices will trigger.';

  @override
  String get skapiThisComputer => 'This computer';

  @override
  String skapiCategoryCount(int count) {
    return '$count categories';
  }

  @override
  String get skapiPlatformMac => 'macOS';

  @override
  String get skapiPlatformWin => 'Windows';

  @override
  String get skapiPlatformLinux => 'Linux';

  @override
  String get skapiPlatformOther => 'Other';

  @override
  String get skapiStarredHeading => 'Starred APIs';

  @override
  String get skapiStarredEmpty =>
      'Star templates from the library, they\'ll show up here.';

  @override
  String get skapiContributeTitle =>
      'Send your library to the SmartKraft community';

  @override
  String get skapiContributeBody => 'This card will be designed later.';

  @override
  String get skapiSearchPlaceholder => 'Search actions…';

  @override
  String get skapiSearchDisabledHint =>
      'Will activate once the SKAPI parser is wired.';

  @override
  String get skapiHelpButtonTooltip => 'About SKAPI';

  @override
  String get skapiHelpSheetTitle => 'About SKAPI';

  @override
  String get skapiHelpIntro =>
      'SKAPI is a library of actions your SmartKraft devices can trigger on your computer.';

  @override
  String get skapiHelpStep1Title => 'Browse a template';

  @override
  String get skapiHelpStep1Body =>
      'Pick a starting point from the SKAPI library.';

  @override
  String get skapiHelpStep2Title => 'Configure';

  @override
  String get skapiHelpStep2Body =>
      'Set parameters and choose which device fires it.';

  @override
  String get skapiHelpStep3Title => 'Push to device';

  @override
  String get skapiHelpStep3Body =>
      'The device stores the API trigger; SKAPP runs the script.';

  @override
  String get skapiHelpGlossaryTitle => 'Glossary';

  @override
  String get skapiHelpGlossaryTemplate => 'Template: a read-only library entry';

  @override
  String get skapiHelpGlossaryAction =>
      'Action: a configured pair of API trigger + script';

  @override
  String get skapiHelpGlossaryApiTrigger =>
      'API trigger: what the device calls';

  @override
  String get skapiHelpGlossaryScript => 'Script: what your computer runs';

  @override
  String get skapiHelpPhase1Notice =>
      'SKAPI is still being built. Most of this tab is a skeleton; sections marked \'not active yet\' will turn on as the parser, listener and form builder land.';

  @override
  String get skapiMobileBannerBody =>
      'This phone can\'t be a target. To run actions, SKAPP must be open on your computer.';

  @override
  String get skapiActionsHeading => 'My Actions';

  @override
  String get skapiActionsNoDevicesTitle => 'No devices yet';

  @override
  String get skapiActionsNoDevicesBody =>
      'Pair a SmartKraft device first; head over to the Devices tab.';

  @override
  String get skapiActionsCreationDisabled =>
      'Action creation is not active yet.';

  @override
  String get skapiActionsOfflineDetectionDisabled =>
      'Online detection not active yet';

  @override
  String get skapiActionsMaxLimitNote => 'Up to 5 actions per device.';

  @override
  String get skapiActionsAddCta => 'Add action';

  @override
  String skapiHeaderSub(int platforms, int actions) {
    return '$platforms platforms · $actions actions';
  }

  @override
  String get skapiNewActionPill => 'New action';

  @override
  String skapiActionsSubLine(int count) {
    return 'device × script bindings · $count active';
  }

  @override
  String get skapiActionsEmptyHint =>
      'No actions yet. Bind what happens when a device button is pressed.';

  @override
  String get skapiActionsCreateCta => 'Create';

  @override
  String skapiActionsGroupTitle(String name) {
    return '$name actions';
  }

  @override
  String skapiActionsGroupCount(int count) {
    return '$count';
  }

  @override
  String get skapiListenerEndpointTitle => 'Webhook URL pushed to BF devices';

  @override
  String get skapiListenerEndpointBody =>
      'If a BF on the same Wi-Fi cannot reach this URL after countdown, your laptop\'s NIC choice may be wrong (e.g. WSL/VirtualBox/Docker network). Tap Refresh to re-push.';

  @override
  String get skapiListenerEndpointResolving => 'Resolving local IP…';

  @override
  String get skapiListenerEndpointUnavailable =>
      'No usable LAN interface found.';

  @override
  String get skapiListenerEndpointRefresh => 'Refresh';

  @override
  String get skapiListenerEndpointRefreshing => 'Pushing…';

  @override
  String skapiListenerEndpointPushedAt(String when) {
    return 'Last refreshed $when';
  }

  @override
  String get skapiListenerSelfTest => 'Self-test';

  @override
  String get skapiListenerSelfTestRunning => 'Testing…';

  @override
  String get skapiListenerSelfTestPassed =>
      'Self-test OK: listener reachable from this host.';

  @override
  String get skapiListenerSelfTestFailed =>
      'Self-test FAILED: listener not reachable. Check Windows Firewall.';

  @override
  String get skapiWebhookActivityTitle => 'Recent webhooks';

  @override
  String get skapiWebhookActivityNone =>
      'No webhooks received yet. After the device timer expires, an entry should appear here within seconds.';

  @override
  String get skapiWebhookActivityAccepted => 'Accepted';

  @override
  String skapiWebhookActivityRejected(int code) {
    return 'Rejected ($code)';
  }

  @override
  String get skapiWebhookActivityMalformed => 'Malformed';

  @override
  String get skapiWebhookActivitySelfTest => 'Self-test';

  @override
  String get skapiWebhookActivityNoMatch => 'No binding matched';

  @override
  String get skapiWebhookActivityScriptError => 'Script error';

  @override
  String skapiWebhookActivityMatched(int count) {
    return '$count script(s) ran';
  }

  @override
  String get skapiBfEndpointsButton => 'Inspect BF endpoints';

  @override
  String get skapiBfEndpointsTitle => 'Endpoints stored on BF devices';

  @override
  String get skapiBfEndpointsHint =>
      'Read-only snapshot of api.endpoint.list from each paired device. Compare each SYSTEM slot URL with the listener URL above. They must match exactly. USER slots may belong to manual webhooks and could capture your countdown if misconfigured.';

  @override
  String get skapiBfEndpointsLoading => 'Querying BF devices…';

  @override
  String get skapiBfEndpointsErrorPrefix => 'Query failed:';

  @override
  String get skapiBfEndpointsKindSystem => 'SYSTEM';

  @override
  String get skapiBfEndpointsKindUser => 'USER';

  @override
  String get skapiBfEndpointsEmpty => 'No endpoints stored on this device.';

  @override
  String get skapiBfEndpointsClose => 'Close';

  @override
  String get skapiBfEndpointsRefresh => 'Re-query';

  @override
  String skapiStarredCount(int count) {
    return '$count starred';
  }

  @override
  String get skapiStarredSlimEmpty =>
      'Star library entries to gather your most-used here.';

  @override
  String get skapiCommunityShareTitle =>
      'Share your library with the SmartKraft community';

  @override
  String get skapiCommunityShareBody =>
      'Scripts you write become available to everyone in the SKAPI library.';

  @override
  String get settingsNetworkIdentityTitle => 'Network identity';

  @override
  String get settingsNetworkIdentityName => 'Computer name';

  @override
  String get settingsNetworkIdentityNameHint =>
      'Used as the mDNS instance name';

  @override
  String get settingsNetworkIdentityNameEdit => 'Rename';

  @override
  String get settingsNetworkIdentityNameDialogTitle => 'Rename this computer';

  @override
  String get settingsNetworkIdentityNameDialogHelp =>
      'Lowercase letters, numbers and dashes. Up to 32 characters.';

  @override
  String get settingsNetworkIdentityUuid => 'Device ID';

  @override
  String get settingsNetworkIdentityPort => 'Listener port';

  @override
  String get settingsNetworkIdentityPortDialogTitle => 'Listener port';

  @override
  String get settingsNetworkIdentityToken => 'Bearer token';

  @override
  String get settingsNetworkIdentityRegenerateToken => 'Regenerate token';

  @override
  String get settingsNetworkIdentityRegenerateConfirmTitle =>
      'Regenerate bearer token?';

  @override
  String get settingsNetworkIdentityRegenerateConfirmBody =>
      'Existing devices will need to be re-paired with the new token.';

  @override
  String get settingsNetworkIdentityServerNotRunning =>
      'Server not running yet, will activate in Phase 2.';

  @override
  String get settingsNetworkIdentityCopy => 'Copy';

  @override
  String get settingsNetworkIdentityCopied => 'Copied';

  @override
  String get settingsNetworkIdentityStaticIpHint =>
      'Tip: a DHCP reservation (static IP) on your router makes connections more reliable.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSectionAppearance => 'Appearance';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystemHint => 'Follow the system language';

  @override
  String get settingsLanguagePickerAllSection => 'All languages';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsSectionAbout => 'About';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsDeveloper => 'Developer';

  @override
  String get settingsDeveloperName => 'SmartKraft';

  @override
  String get settingsOpenAbout => 'About SKAPP';

  @override
  String get settingsSectionAdvanced => 'Advanced';

  @override
  String get settingsDeveloperMode => 'Developer mode';

  @override
  String get settingsDeveloperToolsTitle => 'Developer tools';

  @override
  String get settingsDeveloperToolsSubtitle =>
      'USB console, network identity, listener, tokens, logs';

  @override
  String get settingsDeveloperModeInfoTitle =>
      'What does Developer mode unlock?';

  @override
  String get settingsDeveloperModeInfoIntro =>
      'This mode reveals power-user surfaces hidden from the default UI. Three main use cases:';

  @override
  String get settingsDeveloperModeUseCaseCliTitle => 'CLI console';

  @override
  String get settingsDeveloperModeUseCaseCliBody =>
      'Configure your devices over a USB cable without establishing a BLE or WiFi connection first.';

  @override
  String get settingsDeveloperModeUseCaseSkapiTitle => 'SKAPI code editor';

  @override
  String get settingsDeveloperModeUseCaseSkapiBody =>
      'Open and modify built-in scripts, or write your own from scratch.';

  @override
  String get settingsDeveloperModeUseCaseMobileTitle =>
      'Mobile remote triggering';

  @override
  String get settingsDeveloperModeUseCaseMobileBody =>
      'Run this desktop\'s SKAPI bindings from a paired mobile SKAPP.';

  @override
  String get settingsDeveloperModeInfoSurfacesHeader =>
      'Extra Settings cards that appear when it\'s on:';

  @override
  String get settingsDeveloperModeInfoItem1 =>
      'Network identity card: edit UUID, port, bearer token; copy / regenerate the SKAPP install secret.';

  @override
  String get settingsDeveloperModeInfoItem2 =>
      'Local HTTP listener controls: start/stop, QR pairing, TLS cert rotation, LAN visibility.';

  @override
  String get settingsDeveloperModeInfoItem3 =>
      'Per-peer token list: see every paired mobile SKAPP and revoke individually.';

  @override
  String get settingsDeveloperModeInfoItem4 =>
      'USB CLI console (desktop only): raw NDJSON command line into a USB-connected SmartKraft device.';

  @override
  String get settingsDeveloperModeInfoNotPaid =>
      'Not a paid upgrade. SKAPP is single-tier and free; this switch only hides power-user surfaces by default to keep things simple. SmartKraft devices work independently of this setting.';

  @override
  String get settingsSectionConnectivity => 'Connectivity';

  @override
  String get settingsBluetoothStatus => 'Bluetooth';

  @override
  String get settingsBluetoothStatusOn => 'Ready';

  @override
  String get settingsBluetoothStatusOff => 'Turned off';

  @override
  String get settingsBluetoothStatusTurningOn => 'Turning on…';

  @override
  String get settingsBluetoothStatusTurningOff => 'Turning off…';

  @override
  String get settingsBluetoothStatusUnauthorized => 'No permission';

  @override
  String get settingsBluetoothStatusUnsupported => 'Not supported';

  @override
  String get settingsBluetoothStatusUnknown => 'Checking…';

  @override
  String get settingsNetworkStatus => 'Network';

  @override
  String get settingsWifiStatusConnected => 'Wi-Fi';

  @override
  String get settingsWifiStatusEthernet => 'Ethernet';

  @override
  String get settingsWifiStatusMobile => 'Mobile data';

  @override
  String get settingsWifiStatusDisconnected => 'Disconnected';

  @override
  String get settingsWifiStatusUnknown => 'Checking…';

  @override
  String get settingsWifiHint => 'Used after initial pairing.';

  @override
  String get settingsBluetoothPermissions => 'Permissions';

  @override
  String get settingsBluetoothPermissionsHint =>
      'Bluetooth and location access';

  @override
  String get settingsBluetoothGrantPermission => 'Grant access';

  @override
  String get settingsOpenSystemSettings => 'Open system settings';

  @override
  String get settingsSectionUpdates => 'Updates';

  @override
  String get settingsCheckUpdates => 'Check for updates';

  @override
  String get settingsAutoCheckUpdates => 'Check on launch';

  @override
  String get settingsAutoCheckUpdatesHint =>
      'Verify you\'re on the latest release each time SKAPP opens.';

  @override
  String get settingsUpdateChannel => 'Update channel';

  @override
  String get settingsUpdateChannelStable => 'Stable';

  @override
  String get settingsUpdateChannelBeta => 'Beta';

  @override
  String get settingsUpdateChannelBetaHint =>
      'Get new features earlier. May be less stable.';

  @override
  String get settingsUpToDate => 'You\'re on the latest version.';

  @override
  String get settingsUpdateCheckPlaceholder =>
      'Update check will be wired in Phase 3.';

  @override
  String get settingsSectionLegal => 'Legal';

  @override
  String get settingsLicense => 'License & Thanks';

  @override
  String get settingsSectionInfo => 'Information';

  @override
  String get settingsThemeCycleHint => 'Tap to switch';

  @override
  String get settingsChannelCycleHint => 'Tap to switch';

  @override
  String get settingsSectionThisNode => 'This Node';

  @override
  String get settingsNodeNameTitle => 'SKAPP node name';

  @override
  String settingsNodeNameSub(String name) {
    return '$name · other SKAPPs see this name · mDNS broadcast';
  }

  @override
  String get settingsSectionDanger => 'Danger zone';

  @override
  String get settingsResetPairings => 'Reset pairings';

  @override
  String get settingsResetPairingsSub =>
      'Remove all paired devices; settings/language/node name preserved';

  @override
  String get settingsFactoryReset => 'Factory reset';

  @override
  String get settingsFactoryResetSub => 'Everything erased, irreversible';

  @override
  String get settingsSectionAdvancedNetwork => 'Advanced network';

  @override
  String get settingsResetPairingsConfirmTitle => 'Reset all pairings?';

  @override
  String settingsResetPairingsConfirmBody(int paired, int bindings, int peers) {
    return '$paired paired device(s), $bindings SKAPI action(s), and $peers SKAPP peer(s) will be removed. Your settings, theme, language, and notes are kept. Devices still hold their bond on their end; to fully unpair, reset the device manually. This cannot be undone.';
  }

  @override
  String get settingsResetPairingsConfirmAction => 'Reset';

  @override
  String get settingsFactoryResetConfirmTitle => 'Factory reset?';

  @override
  String get settingsFactoryResetConfirmBody =>
      'Everything will be erased: all pairings, settings, theme, language, notes, network identity, TLS certificate, and the auto-start entry. SKAPP returns to first-launch state. This cannot be undone.';

  @override
  String get settingsFactoryResetConfirmAction => 'Erase everything';

  @override
  String get settingsFactoryResetSecondConfirmTitle =>
      'Are you absolutely sure?';

  @override
  String get settingsFactoryResetSecondConfirmBody => 'Type ERASE to confirm.';

  @override
  String get settingsFactoryResetSecondConfirmHint => 'ERASE';

  @override
  String get settingsFactoryResetSecondConfirmAction => 'I understand. Erase.';

  @override
  String get settingsResetInProgress => 'Resetting…';

  @override
  String get settingsResetDoneTitle => 'Reset complete';

  @override
  String get settingsResetDoneWithWarnings => 'Reset complete (with warnings)';

  @override
  String settingsResetSummaryPaired(int count) {
    return '$count paired device(s) removed';
  }

  @override
  String settingsResetSummaryBindings(int count) {
    return '$count SKAPI action(s) removed';
  }

  @override
  String settingsResetSummaryPeers(int count) {
    return '$count SKAPP peer(s) removed';
  }

  @override
  String settingsResetSummaryBonds(int count) {
    return '$count device bond(s) cleared';
  }

  @override
  String get settingsResetSummaryNetworkIdentity =>
      'Network identity reset to defaults';

  @override
  String get settingsResetSummaryTlsCert => 'TLS certificate cleared';

  @override
  String get settingsResetSummaryAutostart => 'Auto-start entry removed';

  @override
  String get settingsResetSummaryWarningHeader => 'Warnings:';

  @override
  String get settingsResetRestartHint =>
      'Restart SKAPP to fully apply changes.';

  @override
  String get settingsResetRestartNow => 'Restart now';

  @override
  String get settingsResetClose => 'Close';

  @override
  String settingsFooterCombined(String version, String node) {
    return 'SKAPP $version · $node';
  }

  @override
  String get langEnglish => 'English';

  @override
  String get langTurkish => 'Türkçe';

  @override
  String get aboutTitle => 'About SmartKraft and SKAPP';

  @override
  String get aboutDevicesHeading => 'Our Devices';

  @override
  String get aboutDevicesBody =>
      'SmartKraft devices are designed to be innovative, distinctive, and to carry details others have not thought of. Our aim is not to reproduce what already exists; it is to make what hasn\'t been made, what has been left undone. To point at an unsolved everyday problem and offer it a simple, understandable answer; or to take something that has been solved but stayed expensive, and put a DIY version everyone can build in its place.\n\nEvery SmartKraft device is designed and built to give a small, plain answer to a problem that hasn\'t been solved yet. Designing a device, we ask ourselves a single question: \"Why hasn\'t this problem been solved until now, or why has it stayed so expensive?\"';

  @override
  String get aboutSkappRoleHeading => 'Where SKAPP Fits';

  @override
  String get aboutSkappRoleBody =>
      'SKAPP is the shared application for SmartKraft devices. It is a simple user interface for pairing a device, configuring it, changing its behaviour, and bringing several devices together in a single scenario.\n\nSKAPP is not required for your devices; it is a convenience. Every SmartKraft device can be configured the same way over USB CLI without SKAPP, and that path stays open for those who prefer the command line. For everyone else who wants the speed of a visual interface and the comfort of managing several devices at once, SKAPP is here.\n\nNo cloud account. No advertising. No data collection. It is a quiet bridge between your phone and your device, nothing more.';

  @override
  String get aboutShowcaseHeading => 'Maker Showcase';

  @override
  String get aboutShowcaseEmpty =>
      'The showcase is empty for now. The first SmartKraft device is on its way; design files, firmware sources, parts lists, and assembly guides will be listed here when they\'re ready. Until then this section doesn\'t promise much, it is just holding space for what\'s to come.';

  @override
  String get aboutConnectHeading => 'Connect';

  @override
  String get aboutConnectIntro =>
      'Send a message, look at the source code, follow the work as it grows.';

  @override
  String get aboutConnectGitHub => 'GitHub';

  @override
  String get aboutConnectWebsite => 'Website';

  @override
  String get aboutConnectYouTube => 'YouTube';

  @override
  String get aboutConnectX => 'X';

  @override
  String get aboutConnectEmail => 'Email';

  @override
  String get aboutVersionHeading => 'Version';

  @override
  String get licenseTitle => 'License & Thanks';

  @override
  String get licenseSmartKraftHeading => 'About SmartKraft';

  @override
  String get licenseSmartKraftBody =>
      'SmartKraft is a small workshop that designs unusual but practical electronic tools for everyday life. Behind every device that reaches your hand lie countless steps: an early sketch on a notebook, a first soldered prototype, lines of code written late at night, small details retried again and again. Building a device means writing lines, drawing circuits, soldering joints, finding bugs, starting over. To everyone who has put their effort into this process without leaving a name on it, thank you, on behalf of SmartKraft.\n\nWe believe in maker culture, in open source, and in repairable, recyclable electronics. That is why we publish the hardware designs of our devices as open hardware, and their firmware under AGPL 3.0. Our goal is to make a DIY version of as many parts as possible reachable.\n\nA note we want to be honest about: the pairing keys and communication secrets that protect a device\'s security are kept private in source. If they were published, the trust between your device and the app would break. This closure is not a concession against openness; it is a decision made for your safety.\n\nFor SKAPP and every device that talks to it, our principle is transparency: we want you to be able to read how things work, audit them, and build your own version. Even so, every device has its own license section and the terms may vary. To see a device\'s source, schematics, or terms of use, please look at that device\'s own license area.\n\nThank you for supporting us by using this app. We are glad you are here.';

  @override
  String get licenseOpenSourceHeading => 'Standing on Their Shoulders';

  @override
  String get licenseOpenSourceBody =>
      'SKAPP is built on top of thousands of open-source projects written before it. Heartfelt thanks to the Flutter team and its contributors for making the visible interface possible, and to all open-source developers who have given years to networking, storage, cryptography, Bluetooth, and countless subsystems.\n\nBecause we benefit from open source, we try to keep the hardware and firmware of our own devices open as well, so those who come after us can benefit from this body of work the same way.\n\nThanks again to everyone who has been part of this effort.';

  @override
  String get licenseThirdPartyLink => 'Third-party licenses used in this app';

  @override
  String get discoveryTitle => 'Find devices';

  @override
  String get discoverySearching => 'Searching for nearby SmartKraft devices…';

  @override
  String get discoveryNoResults => 'No SmartKraft devices found nearby.';

  @override
  String get discoveryTapToConnect => 'Tap a device to connect';

  @override
  String get discoveryRescan => 'Scan again';

  @override
  String get pairingTitle => 'Pair device';

  @override
  String get pairingEnterPasskey =>
      'Enter the passkey printed on the device label.';

  @override
  String get pairingPasskeyHint => 'e.g. K7M9P2AB';

  @override
  String get pairingConnect => 'Connect';

  @override
  String get pairingMockNotice =>
      'Device firmware not ready yet. Pairing is a placeholder in this build.';

  @override
  String get errorBluetoothPermission =>
      'Bluetooth permission is required to scan for devices.';

  @override
  String get errorBluetoothOff => 'Bluetooth is turned off.';

  @override
  String get errorLocationPermission =>
      'Location permission is required to scan for BLE devices on Android.';

  @override
  String get actionOpenSettings => 'Open settings';

  @override
  String get actionGrantPermission => 'Grant permission';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonBack => 'Back';

  @override
  String get commonRemove => 'Remove';

  @override
  String get commonRefresh => 'Refresh';

  @override
  String get commonOk => 'OK';

  @override
  String get commonClose => 'Close';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonConnect => 'Connect';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonForget => 'Forget';

  @override
  String get commonMore => 'More';

  @override
  String get commonError => 'Error';

  @override
  String get commonOnline => 'online';

  @override
  String get commonOffline => 'offline';

  @override
  String get productBlockingFocus => 'Blocking Focus';

  @override
  String get productLebensSpur => 'LebensSpur';

  @override
  String get productGeneric => 'SmartKraft device';

  @override
  String get timeJustNow => 'just now';

  @override
  String timeMinAgo(int count) {
    return '$count min ago';
  }

  @override
  String timeHourAgo(int count) {
    return '$count h ago';
  }

  @override
  String timeDayAgo(int count) {
    return '$count d ago';
  }

  @override
  String get devicesRemoveTitle => 'Remove device';

  @override
  String devicesRemoveBody(String name) {
    return '$name will be removed. The device stays plugged in; to add it again you\'ll need to re-pair.';
  }

  @override
  String get devicesUnpair => 'Unpair';

  @override
  String get devicesEmptyHint =>
      'Bring your SmartKraft device close and tap the button below.';

  @override
  String get devicesEmptyTitleNoPaired => 'No paired devices yet';

  @override
  String devicesLastSeen(String time) {
    return 'Last seen: $time';
  }

  @override
  String devicesPairedAt(String time) {
    return 'Paired: $time';
  }

  @override
  String devicesHubSubtitle(int count) {
    return 'SKAPP host · $count paired';
  }

  @override
  String get devicesHubEmptySubtitle => 'waiting for device';

  @override
  String devicesHeaderSub(int paired, int online) {
    return '$paired paired · $online online · constellation view';
  }

  @override
  String get devicesAddPillLabel => 'Add device';

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
    return 'low battery ($count)';
  }

  @override
  String get devicesStatPaired => 'paired';

  @override
  String get devicesStatBf => 'BF';

  @override
  String get devicesStatLs => 'LS';

  @override
  String get devicesStatMs => 'phone';

  @override
  String get devicesEmptyHubLabel => 'Unknown';

  @override
  String get devicesEmptyAddCta => 'Add first device';

  @override
  String get devicesEmptyHintChip => 'bring device close, press its button';

  @override
  String devicesNotifOfflineHours(int hours) {
    return 'offline ${hours}h ago';
  }

  @override
  String devicesNotifOfflineMinutes(int minutes) {
    return 'offline ${minutes}m ago';
  }

  @override
  String get devicesNotifLowBattery => 'low battery';

  @override
  String get skappPeersCardTitle => 'Paired Desktop SKAPPs';

  @override
  String get skappPeersCardSubtitle =>
      'Phones and tablets pair here so a BF action can run a script on a Desktop SKAPP. Open Desktop SKAPP > Settings > SKAPP HTTP Listener to get a QR.';

  @override
  String get skappPeersCardEmpty => 'No paired peer yet.';

  @override
  String get skappPeersCardPairButton => 'Pair new';

  @override
  String get skappPeersCardOnline => 'online';

  @override
  String get skappPeersCardOffline => 'offline';

  @override
  String get skappPeersCardNeverSeen => 'never seen';

  @override
  String skappPeersCardRemoveTitle(String name) {
    return 'Remove $name?';
  }

  @override
  String get skappPeersCardRemoveBody =>
      'SKAPP will stop sending scripts to this peer. You can re-pair with the same QR / token later.';

  @override
  String get skappPeersCardRemoveConfirm => 'Remove';

  @override
  String get skappPeersCardRemoveCancel => 'Cancel';

  @override
  String skappPeersCardRemovedToast(String name) {
    return '$name unpaired';
  }

  @override
  String get devicesCardLongPressHint => 'Long press to manage';

  @override
  String devicesActionsSheetTitle(String name) {
    return '$name';
  }

  @override
  String get devicesActionForget => 'Forget device';

  @override
  String get devicesActionForgetSubtitle =>
      'Remove this device from SKAPP. The device itself is not affected; you can pair it again later.';

  @override
  String get devicesActionCancel => 'Cancel';

  @override
  String devicesForgetDialogTitle(String name) {
    return 'Forget $name?';
  }

  @override
  String get devicesForgetDialogBody =>
      'SKAPP will stop tracking this device. The pairing on the device side stays until you reset it from the device.';

  @override
  String devicesForgetDialogBodyWithActions(int count) {
    return 'SKAPP will stop tracking this device and delete $count SKAPI action(s) bound to it. The pairing on the device side stays until you reset it from the device.';
  }

  @override
  String get devicesForgetDialogConfirm => 'Forget';

  @override
  String get devicesForgetDialogCancel => 'Cancel';

  @override
  String devicesForgotToast(String name) {
    return '$name removed from SKAPP';
  }

  @override
  String get devicesMobileNoDetailHint =>
      'No detail page for phones · long-press to unpair';

  @override
  String get devicesDesktopStatLabel => 'desktop';

  @override
  String get devicesDesktopGroupLabel => 'Paired Desktops';

  @override
  String get devicesDesktopTriggerDialogTitle => 'Send a SKAPI command?';

  @override
  String devicesDesktopTriggerDialogBody(String name) {
    return 'All mobile-touch bindings on $name will run.';
  }

  @override
  String get devicesDesktopTriggerDialogConfirm => 'Send command';

  @override
  String get devicesDesktopTriggerDialogCancel => 'Cancel';

  @override
  String get devicesDesktopForgetDialogTitle => 'Unpair';

  @override
  String devicesDesktopForgetDialogBody(String name) {
    return 'Unpairing $name. You\'ll need to re-pair to send commands to this desktop again.';
  }

  @override
  String devicesDesktopForgotToast(String name) {
    return '$name unpaired';
  }

  @override
  String get homeStatDevices => 'Devices';

  @override
  String get homeStatOnline => 'Online';

  @override
  String get homeStatWarning => 'Warning';

  @override
  String homeWarningMeta(String time) {
    return 'Paired but never seen · $time';
  }

  @override
  String get homeBrandTotal => 'Total';

  @override
  String get homeBrandActive => 'Active';

  @override
  String get homeBrandActions => 'Actions';

  @override
  String get homeBrandVersion => 'Version';

  @override
  String get smartkraftSectionProducts => 'Products';

  @override
  String get smartkraftSectionCommunity => 'Community';

  @override
  String get smartkraftStatusLive => 'LIVE';

  @override
  String get smartkraftStatusDev => 'IN DEV';

  @override
  String get smartkraftStatusConcept => 'CONCEPT';

  @override
  String get smartkraftBlockingFocusTagline =>
      'The break you cannot skip out of.';

  @override
  String get smartkraftLebensSpurTagline => 'A quiet witness to your habits.';

  @override
  String get smartkraftSynDimmTagline => 'The right light at the right hour.';

  @override
  String homeStickyDevicesMeta(int count, int warning) {
    return '$count devices · $warning alerts';
  }

  @override
  String homeStickySkapiMeta(int actions) {
    return '$actions actions';
  }

  @override
  String homeStickySettingsMeta(String node, String version) {
    return '$node · v$version';
  }

  @override
  String get homeStickyComingSoonMeta => 'content in progress';

  @override
  String get homeStickyNotesLabel => 'Notes';

  @override
  String get setupChoiceTitle => 'Add device';

  @override
  String get setupChoiceQuestion => 'Where are we?';

  @override
  String get setupChoiceSubtitle =>
      'Is the device fresh from the box, or has it been configured via CLI before?';

  @override
  String get setupChoiceFreshTitle => 'Fresh setup';

  @override
  String get setupChoiceFreshBody =>
      'I\'m adding a brand-new SmartKraft device for the first time. Pairing will run over BLE and the WiFi setup wizard will open.';

  @override
  String get setupChoiceExistingTitle => 'Add an already-configured device';

  @override
  String get setupChoiceExistingBody =>
      'I configured my device\'s WiFi via USB/CLI and I\'m on the same network. Pair directly over WiFi and skip the wizard.';

  @override
  String get setupChoiceFooter =>
      'When in doubt, pick \"Fresh setup\", it\'s the right path for both first-time pairing and factory-reset devices.';

  @override
  String get wifiDiscoveryTitle => 'Devices on this network';

  @override
  String wifiDiscoveryScanError(String error) {
    return 'Scan error: $error';
  }

  @override
  String get wifiDiscoveryHint =>
      'The device must be on WiFi and the phone on the same network. You\'ll be asked to press the device\'s button during pairing.';

  @override
  String get wifiDiscoveryScanning => 'Scanning…';

  @override
  String get wifiDiscoveryNotFound => 'No devices found';

  @override
  String wifiDiscoveryFoundCount(int count) {
    return '$count device(s) found';
  }

  @override
  String get wifiDiscoveryEmptyTitle =>
      'Looking for SmartKraft devices on this network…';

  @override
  String get wifiDiscoveryEmptyTitleIdle => 'No devices found.';

  @override
  String get wifiDiscoveryEmptyHint =>
      'Make sure the device is powered on, connected to WiFi, and on the same network as your phone. Use the refresh button to retry.';

  @override
  String get wifiDiscoveryPairedBadge => 'paired';

  @override
  String get wifiPairingTitle => 'Pairing';

  @override
  String wifiPairingConnectFailed(String error) {
    return 'Couldn\'t connect: $error';
  }

  @override
  String wifiPairingInvalidJson(String error) {
    return 'Invalid JSON: $error';
  }

  @override
  String get wifiPairingClosedEarly => 'Connection closed (no answer)';

  @override
  String wifiPairingSendFailed(String error) {
    return 'Couldn\'t send command: $error';
  }

  @override
  String get wifiPairingTimeout => 'Device didn\'t reply (timeout).';

  @override
  String get wifiPairingNotOpen =>
      'Pairing window not open on the device. Press the button briefly and try again.';

  @override
  String get skapiBindFixedTriggerLabel => 'Trigger: when the timer expires';

  @override
  String get wifiPairingDeviceAlreadyBonded =>
      'This device is already paired with another SKAPP. Adding a new peer over WiFi is not supported by the current firmware (TCP only accepts the first pair). Use BLE pairing, or unpair the existing peer from the device.';

  @override
  String wifiPairingRejected(String error) {
    return 'Device rejected: $error';
  }

  @override
  String get wifiPairingMissingPub => 'Missing/corrupt our_pub from device.';

  @override
  String wifiPairingHexError(String error) {
    return 'our_pub hex decode failed: $error';
  }

  @override
  String get wifiPairingStageAwaiting => 'Press the button on the device';

  @override
  String get wifiPairingStageConnecting => 'Connecting to device…';

  @override
  String get wifiPairingStageExchanging => 'Exchanging keys…';

  @override
  String get wifiPairingStageDone => 'Pairing complete';

  @override
  String get wifiPairingStageFailed => 'Pairing failed';

  @override
  String get wifiPairingStageAwaitingHelp =>
      'Briefly press the device\'s control button (less than 3 seconds). The pairing window stays open for 60 seconds.';

  @override
  String get wifiPairingStageConnectingHelp => 'Opening TCP socket.';

  @override
  String get wifiPairingStageExchangingHelp =>
      'pairing.ecdh.exchange sent, waiting for the device\'s reply.';

  @override
  String get wifiPairingStageDoneHelp => 'Heading to the device dashboard.';

  @override
  String get wifiPairingStartCta => 'Pair';

  @override
  String get bfDashboardTitleFallback => 'Device';

  @override
  String get bfDashboardWifiNone => 'No WiFi';

  @override
  String get bfDashboardLinkBle => 'BLE';

  @override
  String get bfDashboardLinkWifi => 'WiFi';

  @override
  String get bfDashboardLinkUsb => 'USB';

  @override
  String get bfDashboardToggleVibration => 'Vibration';

  @override
  String get bfDashboardToggleTilt => 'Tilt alert';

  @override
  String get bfDashboardToggleLowBatt => 'Low battery alert';

  @override
  String get bfDashboardApiChainTitle => 'API chain';

  @override
  String bfDashboardApiChainNone(String state) {
    return 'no endpoints yet · master $state';
  }

  @override
  String bfDashboardApiChainSummary(int count, String state) {
    return '$count endpoint(s) · master $state';
  }

  @override
  String get bfDashboardMasterOn => 'on';

  @override
  String get bfDashboardMasterOff => 'off';

  @override
  String get bfDashboardNotebookTitle => 'User Notebook';

  @override
  String get bfDashboardNotebookSubtitle =>
      'Encrypted area · 100 KB · free-form content';

  @override
  String get bfDashboardMoreDeviceInfo => 'Device info';

  @override
  String get bfDashboardMoreSettings => 'Settings';

  @override
  String bfDashboardWriteFailed(String error) {
    return 'Couldn\'t write: $error';
  }

  @override
  String get bfDeviceInfoTitle => 'Device info';

  @override
  String get bfDeviceInfoSectionGeneral => 'GENERAL';

  @override
  String get bfDeviceInfoSectionConnection => 'CONNECTION';

  @override
  String get bfDeviceInfoSectionBattery => 'BATTERY';

  @override
  String get bfDeviceInfoSectionTime => 'TIME';

  @override
  String get bfDeviceInfoSectionLastError => 'LAST ERROR';

  @override
  String get bfDeviceInfoSectionDiagnostics => 'DIAGNOSTICS';

  @override
  String get bfDeviceInfoSectionDocs => 'DOCS';

  @override
  String get bfDeviceInfoProduct => 'Product';

  @override
  String get bfDeviceInfoTypeCode => 'Type code';

  @override
  String get bfDeviceInfoIdentity => 'Identity';

  @override
  String get bfDeviceInfoHardware => 'Hardware';

  @override
  String get bfDeviceInfoFirmware => 'Firmware';

  @override
  String get bfDeviceInfoProtocol => 'Protocol';

  @override
  String get bfDeviceInfoBuild => 'Build';

  @override
  String get bfDeviceInfoUptime => 'Uptime';

  @override
  String get bfDeviceInfoWifiState => 'WiFi state';

  @override
  String get bfDeviceInfoIp => 'IP';

  @override
  String get bfDeviceInfoSignal => 'Signal';

  @override
  String get bfDeviceInfoBleAdvertising => 'BLE advertising';

  @override
  String get bfDeviceInfoBlePaired => 'BLE pairings';

  @override
  String bfDeviceInfoPairedClients(int count) {
    return '$count client(s)';
  }

  @override
  String get bfDeviceInfoBattery => 'Battery';

  @override
  String get bfDeviceInfoBatteryPresent => 'present';

  @override
  String get bfDeviceInfoBatteryAbsent => 'absent';

  @override
  String get bfDeviceInfoDeviceClock => 'Device clock';

  @override
  String get bfDeviceInfoLogs => 'Device logs';

  @override
  String get bfDeviceInfoLogsSubtitle =>
      'logs.get, boot, error, timer, API events';

  @override
  String get bfDeviceInfoEvents => 'Event history';

  @override
  String get bfDeviceInfoEventsSubtitle =>
      'Local · timer, face change, API triggers';

  @override
  String get bfDeviceInfoUserGuide => 'User guide';

  @override
  String get bfDeviceInfoUserGuideSubtitle =>
      'Face assignment, timer, API triggers';

  @override
  String get bfDeviceInfoDevNotes => 'SK developer notes';

  @override
  String get bfDeviceInfoDevNotesSubtitle =>
      'CLI commands, architecture, event taxonomy';

  @override
  String get bfDeviceInfoLicense => 'License & open sources';

  @override
  String get bfDeviceInfoLicenseSubtitle =>
      'Libraries used and copyright information';

  @override
  String get bfDeviceInfoComingSoon => 'Coming soon';

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
    return '$d d $h h';
  }

  @override
  String get bfDeviceInfoYes => 'yes';

  @override
  String get bfDeviceInfoNo => 'no';

  @override
  String get bfSettingsTitle => 'Settings';

  @override
  String get bfSettingsSectionNetwork => 'NETWORK';

  @override
  String get bfSettingsSectionUpdates => 'UPDATES';

  @override
  String get bfSettingsSectionDanger => 'DANGER ZONE';

  @override
  String get bfSettingsWifiPrimary => 'Primary WiFi';

  @override
  String get bfSettingsWifiSecondary => 'Backup WiFi';

  @override
  String get bfSettingsWifiUnconfigured => 'Not configured';

  @override
  String get bfSettingsFirmware => 'Firmware';

  @override
  String get bfSettingsCheckUpdates => 'Check for updates';

  @override
  String get bfSettingsCheckUpdatesSubtitle =>
      'Activates once a manifest URL is set';

  @override
  String get bfOtaTitle => 'Firmware update';

  @override
  String get bfOtaCurrentLabel => 'Installed version';

  @override
  String get bfOtaRunningPartitionLabel => 'Active partition';

  @override
  String get bfOtaCheckCta => 'Check for updates';

  @override
  String get bfOtaIdleHint => 'No update check has run yet.';

  @override
  String get bfOtaChecking => 'Checking the update server…';

  @override
  String get bfOtaUpToDate => 'The device is up to date.';

  @override
  String bfOtaAvailable(String version) {
    return 'New version available: $version';
  }

  @override
  String get bfOtaUpdateCta => 'Update now';

  @override
  String bfOtaDownloading(int pct) {
    return 'Downloading… %$pct';
  }

  @override
  String get bfOtaDone => 'Updated. The device is rebooting…';

  @override
  String bfOtaErrorMsg(String message) {
    return 'Error: $message';
  }

  @override
  String get bfOtaRollbackCta => 'Roll back to previous version';

  @override
  String get bfOtaUpdateConfirmTitle => 'Install firmware update?';

  @override
  String bfOtaUpdateConfirmBody(String version) {
    return 'Version $version will be downloaded and installed, then the device reboots. Do not power it off during the update.';
  }

  @override
  String get bfOtaRollbackConfirmTitle => 'Roll back firmware?';

  @override
  String get bfOtaRollbackConfirmBody =>
      'The device will boot the previous firmware and restart.';

  @override
  String get bfSettingsReboot => 'Restart device';

  @override
  String get bfSettingsRebootSubtitle =>
      'Power-cycles the device · cancels any active timer';

  @override
  String get bfSettingsRebootConfirmTitle => 'Restart device?';

  @override
  String get bfSettingsRebootConfirmBody =>
      'The device will turn off and back on in a few seconds.';

  @override
  String get bfSettingsUnpairThisPhone => 'Unpair this phone';

  @override
  String get bfSettingsUnpairSubtitle =>
      'Removes the bond · the device must be paired again';

  @override
  String get bfSettingsUnpairConfirmTitle => 'Unpair this phone?';

  @override
  String get bfSettingsFactoryReset => 'Factory reset';

  @override
  String get bfSettingsFactoryResetSubtitle =>
      'Wipes WiFi, API endpoints and pairings';

  @override
  String get bfSettingsFactoryResetConfirmTitle => 'Factory reset?';

  @override
  String get bfSettingsFactoryResetConfirmBody =>
      'All settings will be cleared. The device will reboot.';

  @override
  String get bfWifiManagementTitle => 'WiFi management';

  @override
  String get bfWifiConnecting => 'Connecting…';

  @override
  String bfWifiConnectionRejected(String error) {
    return 'Connection rejected: $error';
  }

  @override
  String bfWifiConfigure(String label) {
    return 'Configure $label';
  }

  @override
  String get bfWifiPasswordLabel => 'Password';

  @override
  String get bfNotebookTitle => 'User Notebook';

  @override
  String get bfNotebookSaveCancel => 'Cancel';

  @override
  String get bfApiChainCancel => 'Cancel';

  @override
  String get bfApiChainRunChain => 'Run chain';

  @override
  String get bfApiChainToggleAll => 'Enable/disable all';

  @override
  String get bfApiChainFieldName => 'Name';

  @override
  String get bfApiChainFieldType => 'Type';

  @override
  String get bfApiChainFieldHeaderName => 'Header name';

  @override
  String get bfApiChainFieldNewToken => 'New token (leave blank to keep)';

  @override
  String get bfHomeLoadingConnecting => 'Connecting to device…';

  @override
  String get bfHomeLoadingSecure => 'Opening secure channel…';

  @override
  String get deviceConnUnreachableTitle => 'Can\'t reach the device';

  @override
  String get deviceConnUnreachableBody =>
      'The device may be off, out of range, or asleep. Make sure it is powered on and nearby, then try again.';

  @override
  String get deviceConnRepairTitle => 'Pairing needs to be renewed';

  @override
  String get deviceConnRepairBody =>
      'The device looks like it was reset and no longer recognises this phone. Pair with it again to reconnect.';

  @override
  String get deviceConnRepairButton => 'Pair again';

  @override
  String get deviceConnTechnicalDetails => 'Technical details';

  @override
  String get bfLogsTitle => 'Device logs';

  @override
  String get bfEventsTitle => 'Event history';

  @override
  String get pairingStepConnecting => 'Connecting';

  @override
  String get pairingStepConnectingSubtitle => 'BLE link + GATT discovery';

  @override
  String get pairingStepMutualAuth => 'Mutual authentication';

  @override
  String get pairingStepDeviceInfo => 'device.info verification';

  @override
  String get pairingStepDeviceInfoSubtitle =>
      'Encrypted channel up, sanity ping';

  @override
  String get pairingStepConnected => 'Connection established';

  @override
  String get pairingStepConnectedSubtitle => 'CLI ready, moving to setup';

  @override
  String get pairingStepKeyExchange => 'Key exchange';

  @override
  String get pairingStepKeyExchangeSubtitle => 'X25519, public key sent';

  @override
  String get pairingStepVerifying => 'Verifying';

  @override
  String get pairingStepVerifyingSubtitle =>
      'Waiting for device, deriving token';

  @override
  String get pairingStepDone => 'Pairing complete';

  @override
  String get pairingStepDoneSubtitle => 'Bond stored on device and phone';

  @override
  String get pairingLogTitle => 'Pairing log';

  @override
  String get pairingLogCopied => 'Log copied to clipboard';

  @override
  String get discoveryPreparing => 'Preparing…';

  @override
  String get discoveryBluetoothOff => 'Bluetooth is off';

  @override
  String get wifiPasswordTitle => 'Connect device to WiFi';

  @override
  String get wifiPasswordSsidLabel => 'Network name (SSID)';

  @override
  String get wifiPasswordNetworkLabel => 'Network';

  @override
  String get wifiPasswordPasswordLabel => 'Password';

  @override
  String get wifiPasswordConnect => 'Connect';

  @override
  String get wifiPasswordLogTitle => 'Connection log';

  @override
  String get wifiPasswordLogCopied => 'Log copied to clipboard';

  @override
  String get wifiScanTitle => 'Pick a WiFi network for the device';

  @override
  String get wifiScanRescanTooltip => 'Tell the device to scan again';

  @override
  String get wifiScanRunning => 'Device\'s WiFi scanner is running…';

  @override
  String get wifiScanNoNetworks => 'Device couldn\'t find any nearby WiFi.';

  @override
  String get wifiScanRescan => 'Tell the device to scan again';

  @override
  String get wifiScanHiddenAdd => 'Add hidden network';

  @override
  String get wifiScanHiddenSubtitle => 'Type the SSID by hand';

  @override
  String get wifiScanLogTitle => 'WiFi scan log';

  @override
  String get wifiSuccessReady => 'Done';

  @override
  String get bfEventsClearTooltip => 'Clear';

  @override
  String get bfEventsEmpty =>
      'No events yet. They\'ll appear here once the device starts publishing.';

  @override
  String get logsEmptyTooltip => 'Log is empty.';

  @override
  String logsErrorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get notebookSaved => 'Saved';

  @override
  String notebookSaveError(String error) {
    return 'Error: $error';
  }

  @override
  String notebookCapacityExceeded(int used, int capacity) {
    return 'Capacity exceeded: $used / $capacity bytes';
  }

  @override
  String get notebookClearTooltip => 'Clear notebook';

  @override
  String get notebookClearConfirmTitle => 'Clear the entire notebook?';

  @override
  String get notebookClearConfirmBody =>
      'All user data on the device will be erased. Cannot be undone.';

  @override
  String get notebookClearAction => 'Clear';

  @override
  String get notebookClearedSnack => 'Notebook cleared';

  @override
  String notebookClearError(String error) {
    return 'Couldn\'t clear: $error';
  }

  @override
  String get notebookEncryptedHint =>
      'Encrypted area · only the paired SKAPP can read it';

  @override
  String get notebookEmptyTitle => 'Notebook is empty';

  @override
  String get notebookEmptyBody =>
      'Type notes, JSON, scene definitions or any other text below. Tapping Save stores it encrypted on the device.';

  @override
  String get notebookHint =>
      'Type whatever you want here (notes, JSON, your own schema). Up to 100 KB stored on the device.';

  @override
  String get notebookDirty => 'Unsaved changes';

  @override
  String get notebookSaved2 => 'Saved';

  @override
  String get notebookSyncedDifferent => 'In sync';

  @override
  String get notebookSaveCta => 'Save';

  @override
  String wifiPairingHexErrorRaw(String error) {
    return 'our_pub hex decode failed: $error';
  }

  @override
  String get bfWifiForgetTitle => 'Forget slot?';

  @override
  String get bfWifiForgetBody =>
      'The slot will be wiped. If the device is currently connected here it will fall back to the other slot (if any). Reconfiguration is required to restore.';

  @override
  String get bfWifiForget => 'Forget';

  @override
  String get bfWifiHint =>
      'The device tries the two networks in order: Primary first, Backup if it fails. The active slot is marked with a green dot.';

  @override
  String get bfWifiActive => 'ACTIVE';

  @override
  String get bfWifiNotConfigured => 'Not configured';

  @override
  String get bfWifiChange => 'Change';

  @override
  String get bfWifiSetUp => 'Set up';

  @override
  String get discoveryStatusChecking => 'Bluetooth status check.';

  @override
  String get discoveryPermissionsTitle => 'Bluetooth permission required';

  @override
  String get discoveryPermissionsBody =>
      'To find nearby SmartKraft devices, please enable the Bluetooth permission.';

  @override
  String get discoveryPermissionsRetry => 'Request permissions again';

  @override
  String get discoveryPermissionsOpenSettings => 'Open settings';

  @override
  String get discoveryAdapterOffBody =>
      'Turn Bluetooth on to scan for devices.';

  @override
  String get discoveryAdapterOffEnable => 'Turn Bluetooth on';

  @override
  String get discoveryUnsupportedTitle => 'BLE not supported';

  @override
  String get discoveryUnsupportedBody =>
      'This device does not support Bluetooth Low Energy, SKAPP needs BLE to work.';

  @override
  String get wifiPasswordHelp =>
      'The device will join this network. Enter the password, type it carefully.';

  @override
  String get wifiPasswordRequired => 'Password is required';

  @override
  String get wifiPasswordMinLength => 'At least 8 characters';

  @override
  String wifiPasswordSendError(String error) {
    return 'Couldn\'t send: $error';
  }

  @override
  String get wifiScanTimeoutHint =>
      'If the scan takes too long the device may have lost WiFi reach. Tap retry.';

  @override
  String get wifiScanFailedTitle => 'Scan failed';

  @override
  String get wifiScanRetry => 'Retry';

  @override
  String get wifiSuccessTitle => 'Connected';

  @override
  String get wifiSuccessBody =>
      'The device is on WiFi now. Returning to the dashboard…';

  @override
  String get deviceNameSectionHeading => 'DEVICE NAME (THIS APP ONLY)';

  @override
  String get deviceNameLabel => 'Custom name';

  @override
  String get deviceNameHint => 'e.g. Office BF';

  @override
  String get deviceNameSubtitle =>
      'Shown on cards in this SKAPP install. Not pushed to the device.';

  @override
  String get deviceNameClear => 'Clear';

  @override
  String get deviceNameSave => 'Save';

  @override
  String get deviceNameSaved => 'Saved';

  @override
  String get deviceNameEmptyPlaceholder => '(no custom name)';

  @override
  String get settingsUsbConsoleTitle => 'USB CLI console';

  @override
  String get settingsUsbConsoleSubtitle =>
      'Send raw commands to a USB-connected device';

  @override
  String get usbConsoleAppBarTitle => 'USB Console';

  @override
  String get usbConsolePickPortTitle => 'Select a port';

  @override
  String get usbConsolePickPortHint =>
      'Plug a SmartKraft device via USB and tap refresh';

  @override
  String get usbConsolePortRefreshTooltip => 'Refresh ports';

  @override
  String get usbConsoleBfBadge => 'SmartKraft';

  @override
  String get usbConsoleConnecting => 'Connecting…';

  @override
  String get usbConsoleConnected => 'Connected';

  @override
  String get usbConsoleDisconnected => 'Disconnected';

  @override
  String usbConsoleErrorBanner(String error) {
    return 'Error: $error';
  }

  @override
  String get usbConsoleReconnect => 'Reconnect';

  @override
  String get usbConsoleDisconnect => 'Disconnect';

  @override
  String get usbConsoleClear => 'Clear console';

  @override
  String get usbConsoleInputHint => 'Type a command, e.g. device.info';

  @override
  String get usbConsoleSend => 'Send';

  @override
  String get usbConsoleEmptyHint =>
      'Type a command and press Enter, try device.info';

  @override
  String get usbConsoleEntryEvent => 'evt';

  @override
  String get usbConsoleEntryError => 'error';

  @override
  String get usbConsoleNotSupportedIos => 'USB console is not supported on iOS';

  @override
  String get passphraseFieldLabel => 'Passphrase';

  @override
  String get passphraseVerifyButton => 'Verify';

  @override
  String passphraseAttemptsLeft(int count) {
    return 'Attempts left: $count';
  }

  @override
  String get passphraseLockoutTriggered =>
      'Too many wrong passphrase attempts; the device factory-reset itself.';

  @override
  String get bondPeerUnnamed => '(unnamed)';

  @override
  String get pairingPassphraseDialogTitle => 'Device passphrase';

  @override
  String get pairingPassphraseDialogBody =>
      'This device requires a passphrase for content access. Enter it to complete pairing.';

  @override
  String get pairingPassphraseCancelled =>
      'Passphrase not entered, pairing cancelled.';

  @override
  String pairingPassphraseSendError(String error) {
    return 'Couldn\'t send passphrase: $error';
  }

  @override
  String get pairingPassphraseTimeout =>
      'Device didn\'t reply (passphrase verify, 8 s).';

  @override
  String get pairingWindowClosedRetry =>
      'Pairing window closed, short-press the button and try again.';

  @override
  String pairingPassphraseFailed(String error) {
    return 'Couldn\'t verify passphrase: $error';
  }

  @override
  String get bondStoreFullHeader =>
      'All 8 bond slots are full. Remove an existing peer to pair a new SKAPP:';

  @override
  String bondStoreFullPeerLine(Object slot, String name, String shortPid) {
    return '  • slot $slot, $name [#$shortPid]';
  }

  @override
  String get bondStoreFullFooter =>
      'From another paired SKAPP or via USB, run\n`bond.remove --slot N`, then tap Retry here.';

  @override
  String get passphraseGateDialogBody =>
      'This device asks for the passphrase on every connection. Enter it to access content.';

  @override
  String get passphraseGateCancelled =>
      'Passphrase not entered, verification is required to access this screen.';

  @override
  String passphraseGateVerifyError(String error) {
    return 'Verify error: $error';
  }

  @override
  String passphraseGateCommError(String error) {
    return 'Communication error: $error';
  }

  @override
  String get passphraseGateUnknownError => 'Unknown lock error.';

  @override
  String get bfPassphraseTitle => 'Device Passphrase';

  @override
  String get bfPassphraseSetTitle => 'Set passphrase';

  @override
  String get bfPassphraseChangeTitle => 'Change passphrase';

  @override
  String get bfPassphraseClearTitle => 'Remove passphrase';

  @override
  String get bfPassphraseChangeSubtitle =>
      'Enter the old passphrase, set the new one';

  @override
  String get bfPassphraseClearSubtitle =>
      'Reset the content lock on the device';

  @override
  String get bfPassphraseModePairing => 'Ask during pairing';

  @override
  String get bfPassphraseModePairingSubtitle =>
      'Asks when a new SKAPP pairs. Existing peers aren\'t prompted.';

  @override
  String get bfPassphraseModeAlways => 'Ask on every connection';

  @override
  String get bfPassphraseModeAlwaysSubtitle =>
      'Asks every time a session opens. Content stays locked even if a SKAPP is stolen.';

  @override
  String get bfPassphraseStatusNone =>
      'No passphrase, the device has no content lock';

  @override
  String get bfPassphraseStatusActiveOff =>
      'Passphrase set · enforcement off (both toggles off)';

  @override
  String get bfPassphraseStatusActivePairing => 'Asked during pairing';

  @override
  String get bfPassphraseStatusActiveAlways => 'Asked on every connection';

  @override
  String get bfPassphraseBadgeActive => 'Passphrase active';

  @override
  String get bfPassphraseBadgeNone => 'No passphrase';

  @override
  String bfPassphraseAttemptsRatio(int left, int total) {
    return 'Attempts left: $left / $total';
  }

  @override
  String bfPassphraseLengthSubtitle(int min, int max) {
    return 'Length $min-$max characters';
  }

  @override
  String bfPassphraseLengthHint(int min, int max) {
    return 'Length: $min-$max';
  }

  @override
  String bfPassphraseTooShort(int min) {
    return 'At least $min characters';
  }

  @override
  String bfPassphraseTooLong(int max) {
    return 'At most $max characters';
  }

  @override
  String get bfPassphraseEmpty => 'Can\'t be empty';

  @override
  String get bfPassphraseNewLabel => 'New passphrase';

  @override
  String get bfPassphraseCurrentLabel => 'Current passphrase';

  @override
  String get bfPassphraseSetDone => 'Passphrase set';

  @override
  String get bfPassphraseChangeDone => 'Passphrase changed';

  @override
  String get bfPassphraseClearDone => 'Passphrase removed';

  @override
  String bfPassphraseStatusReadError(String error) {
    return 'Couldn\'t read status: $error';
  }

  @override
  String get bfPassphraseNotesTitle => 'Notes';

  @override
  String get bfPassphraseNotesBody =>
      '• The passphrase is hashed on-device with PBKDF2-SHA256; it is never stored in plaintext.\n• 10 wrong attempts factory-reset the device; all bonds and data are wiped.\n• A USB-connected device skips the passphrase prompt, physical access already grants factory-reset via the button.';

  @override
  String bfBondListTitle(int used, int capacity) {
    return 'Paired SKAPPs  ($used/$capacity)';
  }

  @override
  String get bfBondListEmpty => 'No paired peers yet.';

  @override
  String get bfBondListBadgeThisPhone => 'This phone';

  @override
  String get bfBondListBadgeActiveSession => 'Active session';

  @override
  String bfBondListRowSubtitle(String shortPid, String date) {
    return '#$shortPid · paired: $date';
  }

  @override
  String get bfBondListRemoveTooltip => 'Remove this peer';

  @override
  String get bfBondListRemoveTitle => 'Remove peer?';

  @override
  String get bfBondListRemoveSelfBody =>
      'You\'re removing this phone\'s bond. If you confirm, the session drops; to reach the device again you\'ll need to short-press the button and re-pair.';

  @override
  String bfBondListRemoveOtherBody(String label, int slot) {
    return '\"$label\" (slot $slot) is wiped from the device. That SKAPP must short-press the button and re-pair to reconnect.';
  }

  @override
  String bfBondListSlotRemoved(int slot) {
    return 'Slot $slot removed';
  }

  @override
  String bfBondListFetchError(String error) {
    return 'bond.list failed: $error';
  }

  @override
  String get bfSettingsSectionSecurity => 'SECURITY';

  @override
  String get bfSettingsPassphraseTitle => 'Device passphrase';

  @override
  String get bfSettingsBondListTitle => 'Paired SKAPPs';

  @override
  String get bfSettingsPassphraseSubtitleAlways => 'Active, every connection';

  @override
  String get bfSettingsPassphraseSubtitlePairing => 'Active, at pairing';

  @override
  String get bfSettingsPassphraseSubtitleOff => 'Active, enforcement off';

  @override
  String bfSettingsBondsSubtitle(int count, int capacity) {
    return 'Paired peers: $count / $capacity';
  }

  @override
  String get skapiHowItWorksTitle => 'How it works';

  @override
  String skapiHowItWorksBody(String deviceName) {
    return 'When your SmartKraft device (for example $deviceName) experiences an event such as a timer ending, a button press, or a sensor trigger, it sends a small command to your computer. Your computer receives that command and runs the script you have chosen.';
  }

  @override
  String get skapiHowItWorksFlowDeviceLabel => 'SmartKraft Device';

  @override
  String get skapiHowItWorksFlowDeviceSub =>
      'e.g. Blocking Focus, triggers an event';

  @override
  String get skapiHowItWorksFlowComputerLabel => 'Computer';

  @override
  String get skapiHowItWorksFlowComputerSub =>
      'SKAPP receives the command, the script runs';

  @override
  String get skapiHowItWorksFoot =>
      'SKAPP must be running on your computer. All traffic stays on the WiFi network, no internet connection is required, and no data leaves your home.';

  @override
  String get skapiPlatformGroupsHeader => 'Action Categories';

  @override
  String skapiPlatformGroupsLoadError(String error) {
    return 'Failed to load groups: $error';
  }

  @override
  String get skapiPlatformEmptyTitle => 'No scripts here yet';

  @override
  String get skapiPlatformEmptyBody =>
      'Scripts for this platform are still on the way. Check back after the next SKAPP update.';

  @override
  String skapiGroupScriptsLoadError(String error) {
    return 'Failed to load scripts: $error';
  }

  @override
  String skapiScriptDetailLoadError(String error) {
    return 'Could not load this script: $error';
  }

  @override
  String get skapiBindScreenTitle => 'Bind to Action';

  @override
  String get skapiBindScreenSubtitle =>
      'Run this script automatically when a device event fires.';

  @override
  String get skapiBindFieldDeviceLabel => 'Device';

  @override
  String get skapiBindFieldDeviceHint =>
      'Pick which paired device should fire this script.';

  @override
  String get skapiBindFieldDeviceEmpty =>
      'No paired devices yet. Pair one from the Devices tab first.';

  @override
  String get skapiBindFieldEventLabel => 'Event';

  @override
  String get skapiBindFieldEventHint =>
      'The device emits this event; the script runs when it does.';

  @override
  String get skapiBindEventTimerStarted => 'Timer started';

  @override
  String get skapiBindEventTimerExpired => 'Timer expired';

  @override
  String get skapiBindEventFaceChanged => 'Cube face changed';

  @override
  String get skapiBindEventButtonPressed => 'Button pressed';

  @override
  String get skapiBindEventButtonHeld => 'Button held';

  @override
  String get skapiBindEventBatteryLow => 'Battery low';

  @override
  String get skapiBindEventBatteryLockout => 'Battery lockout';

  @override
  String get skapiBindEventPowerStateChanged => 'Power state changed';

  @override
  String get skapiBindEventPairingSuccess => 'Pairing succeeded';

  @override
  String get skapiBindEventApiSent => 'API call sent';

  @override
  String get skapiBindParamsHeader => 'Parameter overrides';

  @override
  String get skapiBindParamsHint =>
      'Leave empty to keep the script defaults. These values are sent every time the binding fires.';

  @override
  String get skapiBindButtonSave => 'Save binding';

  @override
  String get skapiBindButtonDelete => 'Delete binding';

  @override
  String get skapiBindButtonCancel => 'Cancel';

  @override
  String get skapiBindButtonEnable => 'Enable';

  @override
  String get skapiBindButtonDisable => 'Disable';

  @override
  String get skapiBindStatusEnabled => 'Active';

  @override
  String get skapiBindStatusDisabled => 'Paused';

  @override
  String get skapiBindSavedToast => 'Binding saved';

  @override
  String get skapiBindDeletedToast => 'Binding removed';

  @override
  String skapiBindBadgeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bindings',
      one: '1 binding',
    );
    return '$_temp0';
  }

  @override
  String get skapiBindNoPairedDeviceWarning =>
      'Pair a device first to create bindings.';

  @override
  String skapiBindTriggeredDesktopToast(String script) {
    return 'Triggered: $script';
  }

  @override
  String skapiBindTriggeredMobileToast(String event) {
    return 'Bind fired ($event); execution arrives in Phase K.';
  }

  @override
  String skapiBindLoadError(String error) {
    return 'Could not load bindings: $error';
  }

  @override
  String get skapiBindListSectionTitle => 'Bindings on this script';

  @override
  String get skapiBindListEmpty =>
      'No bindings yet. Tap Bind to Action to create one.';

  @override
  String get skapiBindNewButton => 'New binding';

  @override
  String get skapiBasicSettingsTitle => 'Settings';

  @override
  String get skapiBasicEmptyParams =>
      'This script needs no settings. Tap Run Now.';

  @override
  String get skapiBasicUnitSeconds => 'seconds';

  @override
  String get skapiBasicConvHalfMinute => 'half a minute';

  @override
  String get skapiBasicConvLessThanMinute => 'less than a minute';

  @override
  String skapiBasicConvMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes',
      one: '1 minute',
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
      other: '$count hours',
      one: '1 hour',
    );
    return '$_temp0';
  }

  @override
  String get skapiBasicConvImmediate => 'starts immediately';

  @override
  String skapiBasicConvAfter(String time) {
    return 'after $time';
  }

  @override
  String get skapiBasicPrerunSectionTitle => 'Pre-run delay';

  @override
  String get skapiBasicPrerunAddCta => 'Add delay before run';

  @override
  String get skapiBasicPrerunLabel =>
      'Wait this many seconds before the script starts';

  @override
  String get skapiBasicPrerunHelp =>
      'Useful for letting a notification show first, or chaining actions. Default 0 means start immediately.';

  @override
  String get skapiBasicPrerunRemove => 'Remove delay';

  @override
  String get skapiBasicListAddPlaceholder => '+ add';

  @override
  String get skapiRunSheetTitle => 'Run script';

  @override
  String get skapiRunSheetStatusRunning => 'Running';

  @override
  String get skapiRunSheetStatusOk => 'Done';

  @override
  String get skapiRunSheetStatusError => 'Failed';

  @override
  String skapiRunSheetExitCode(int code) {
    return 'Exit code: $code';
  }

  @override
  String get skapiRunSheetCancel => 'Cancel';

  @override
  String get skapiRunSheetClose => 'Close';

  @override
  String get skapiRunSheetCopyOutput => 'Copy output';

  @override
  String get skapiRunSheetCopiedDone => 'Copied';

  @override
  String get skapiRunSheetEmptyOutput => 'Waiting for output...';

  @override
  String get skapiRunSheetDismissConfirmTitle => 'Stop running script?';

  @override
  String get skapiRunSheetDismissConfirmBody =>
      'The script is still running. Closing this sheet will cancel it.';

  @override
  String get skapiRunSheetDismissConfirmStay => 'Keep running';

  @override
  String get skapiRunSheetDismissConfirmStop => 'Cancel';

  @override
  String get skapiRunErrorPowerShellMissing =>
      'PowerShell was not found on this system.';

  @override
  String skapiRunErrorTempWrite(String error) {
    return 'Could not write the script to the temp folder: $error';
  }

  @override
  String skapiRunErrorSpawn(String error) {
    return 'Could not start PowerShell: $error';
  }

  @override
  String skapiRunDurationMs(int ms) {
    return 'Took $ms ms';
  }

  @override
  String get skapiCopiedToClipboard => 'Copied';

  @override
  String get skapiFavouriteAddTooltip => 'Add to favourites';

  @override
  String get skapiFavouriteRemoveTooltip => 'Remove from favourites';

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
  String get skapiPlatformScreenCategoriesTitle => 'Action Categories';

  @override
  String skapiPlatformScreenCategoriesSub(int groups, int scripts) {
    return '$groups groups · $scripts scripts total';
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
  String get skapiGroupPowerTitle => 'Power Management';

  @override
  String get skapiGroupPowerDesc =>
      'Scripts in this group lock, sleep, hibernate, or shut down the computer. They are useful when a SmartKraft device signals the end of a focus session or detects extended idle time and you want the machine to follow suit.';

  @override
  String get skapiGroupPowerFoot =>
      'Typical use: lock when you stand up, hibernate at the end of the day, scheduled shutdown after a long idle period.';

  @override
  String get skapiScriptLockTitle => 'Lock Workstation';

  @override
  String get skapiScriptLockSummaryWhat =>
      'Locks Windows immediately and returns to the sign-in screen. Open apps keep running.';

  @override
  String get skapiScriptLockSummaryHow =>
      'Calls the user32 LockWorkStation Win32 function. Equivalent to pressing Win+L.';

  @override
  String get skapiScriptHibernateTitle => 'Hibernate';

  @override
  String get skapiScriptHibernateSummaryWhat =>
      'Saves the current session to disk and powers the machine down. Resuming returns to where you left off, even with no battery.';

  @override
  String get skapiScriptHibernateSummaryHow =>
      'Runs the built-in shutdown.exe with the /h flag. Hibernation must be enabled in Windows power settings; if it is not, Windows falls back to sleep.';

  @override
  String get skapiScriptHibernateNote =>
      'Run powercfg /hibernate on once from an admin shell if hibernate is missing on your system.';

  @override
  String get skapiScriptHibernateParamDelayLabel => 'delay';

  @override
  String get skapiScriptHibernateParamDelayHint =>
      'Seconds to wait before hibernating, in case the device\'s notification should appear first.';

  @override
  String get skapiScriptSleepTitle => 'Sleep';

  @override
  String get skapiScriptSleepSummaryWhat =>
      'Suspends the machine to RAM (S3). Resuming is fast but draws a small amount of battery while suspended.';

  @override
  String get skapiScriptSleepSummaryHow =>
      'Calls System.Windows.Forms.Application.SetSuspendState with PowerState.Suspend. The OS may delay if a foreground process is blocking idle transitions.';

  @override
  String get skapiScriptSleepParamDelayLabel => 'delay';

  @override
  String get skapiScriptSleepParamDelayHint =>
      'Seconds to wait before sleeping.';

  @override
  String get skapiScriptShutdownTitle => 'Shutdown';

  @override
  String get skapiScriptShutdownSummaryWhat =>
      'Initiates a graceful Windows shutdown. Open apps are asked to save and close.';

  @override
  String get skapiScriptShutdownSummaryHow =>
      'Runs the built-in shutdown.exe /s. With force enabled, /f is added so unresponsive apps are terminated.';

  @override
  String get skapiScriptShutdownNote =>
      'A non-zero delay gives the user time to cancel via shutdown /a from a terminal.';

  @override
  String get skapiScriptShutdownParamDelayLabel => 'delay';

  @override
  String get skapiScriptShutdownParamDelayHint =>
      'Seconds Windows waits before powering down. 30 is the default; pick 0 for immediate shutdown.';

  @override
  String get skapiScriptShutdownParamForceLabel => 'force';

  @override
  String get skapiScriptShutdownParamForceHint =>
      'Closes apps that do not respond to the shutdown signal. Unsaved work in those apps may be lost.';

  @override
  String get skapiGroupDisplayAudioTitle => 'Display, Image & Sound';

  @override
  String get skapiGroupDisplayAudioDesc =>
      'Scripts in this group adjust the screen and audio output: brightness, volume, mute, and media playback. They are useful when a SmartKraft device wants the computer to dim during a focus break or pause music when you stand up.';

  @override
  String get skapiGroupDisplayAudioFoot =>
      'Typical use: dim screen during a break, mute on lock, pause Spotify when a device detects no activity.';

  @override
  String get skapiScriptBrightnessTitle => 'Set Brightness';

  @override
  String get skapiScriptBrightnessSummaryWhat =>
      'Sets the brightness of the internal display to a percentage between 0 and 100.';

  @override
  String get skapiScriptBrightnessSummaryHow =>
      'Calls the WMI WmiMonitorBrightnessMethods.WmiSetBrightness with the requested level. Only laptops, tablets, and built-in panels respond; external DDC/CI monitors are not supported on this path.';

  @override
  String get skapiScriptBrightnessNote =>
      'External monitors will not change. For multi-monitor setups, only the panel reporting brightness through WMI reacts.';

  @override
  String get skapiScriptBrightnessParamLevelLabel => 'level';

  @override
  String get skapiScriptBrightnessParamLevelHint =>
      'Brightness percentage (0-100). Lower values are dimmer. 70 is a comfortable default in normal lighting.';

  @override
  String get skapiScriptBrightnessParamTimeoutLabel => 'timeout';

  @override
  String get skapiScriptBrightnessParamTimeoutHint =>
      'Seconds the brightness change is allowed to take. The OS smoothly ramps within this window.';

  @override
  String get skapiScriptMuteToggleTitle => 'Toggle Mute';

  @override
  String get skapiScriptMuteToggleSummaryWhat =>
      'Toggles the system master mute. Active media keeps playing but you do not hear it.';

  @override
  String get skapiScriptMuteToggleSummaryHow =>
      'Sends the VK_VOLUME_MUTE virtual key, the same path Windows uses when the user presses the mute key on a keyboard. No admin or COM dependency.';

  @override
  String get skapiScriptMuteToggleParamModeLabel => 'mode';

  @override
  String get skapiScriptMuteToggleParamModeHint =>
      'toggle / on / off. Only toggle is enforced through the simple keystroke; on and off are accepted for forward compatibility.';

  @override
  String get skapiScriptVolumeSetTitle => 'Set Volume';

  @override
  String get skapiScriptVolumeSetSummaryWhat =>
      'Sets the system master volume to a precise level between 0 and 100.';

  @override
  String get skapiScriptVolumeSetSummaryHow =>
      'Calls the Core Audio IAudioEndpointVolume.SetMasterVolumeLevelScalar through inline C# COM interop. Targets the default render endpoint.';

  @override
  String get skapiScriptVolumeSetNote =>
      'Tier 2: works on standard Windows 10/11 desktops. Stripped-down installs may not expose the COM interface; per-app endpoints are not addressed by this path.';

  @override
  String get skapiScriptVolumeSetParamLevelLabel => 'level';

  @override
  String get skapiScriptVolumeSetParamLevelHint =>
      'Volume percentage (0-100). 0 silences without setting mute; 50 is a comfortable default.';

  @override
  String get skapiScriptMediaKeyTitle => 'Media Key';

  @override
  String get skapiScriptMediaKeySummaryWhat =>
      'Simulates a media key press: play-pause, next, previous, or stop. Goes to whichever app currently owns the media session.';

  @override
  String get skapiScriptMediaKeySummaryHow =>
      'Sends VK_MEDIA_PLAY_PAUSE / VK_MEDIA_NEXT_TRACK / VK_MEDIA_PREV_TRACK / VK_MEDIA_STOP through keybd_event. Windows routes the press through the System Media Transport Controls.';

  @override
  String get skapiScriptMediaKeyNote =>
      'Tier 2: needs an active media session. If no app is playing or the foreground app does not register with SMTC, the press is silently dropped.';

  @override
  String get skapiScriptMediaKeyParamKeyLabel => 'key';

  @override
  String get skapiScriptMediaKeyParamKeyHint =>
      'play-pause / next / previous / stop. Default is play-pause.';

  @override
  String get skapiGroupWindowAppTitle => 'Window & Application';

  @override
  String get skapiGroupWindowAppDesc =>
      'Scripts in this group control windows and applications: minimise, focus, close gracefully, or kill processes outright. They keep your workspace tidy when a SmartKraft device wants the computer to switch context.';

  @override
  String get skapiGroupWindowAppFoot =>
      'Typical use: minimise everything when a focus session starts, close the browser when work is over, kill a stuck app on demand.';

  @override
  String get skapiScriptMinimizeWindowTitle => 'Minimise Window';

  @override
  String get skapiScriptMinimizeWindowSummaryWhat =>
      'Minimises a specific window by process name. Empty process name targets the currently focused window.';

  @override
  String get skapiScriptMinimizeWindowSummaryHow =>
      'Resolves the first matching main window via Get-Process and calls user32 ShowWindow with SW_MINIMIZE.';

  @override
  String get skapiScriptMinimizeWindowNote =>
      'If multiple instances are running, only the first matching window is minimised. Use the process name without the .exe suffix.';

  @override
  String get skapiScriptMinimizeWindowParamProcessLabel => 'processName';

  @override
  String get skapiScriptMinimizeWindowParamProcessHint =>
      'Process name without .exe (chrome, code, winword). Empty targets the foreground window.';

  @override
  String get skapiScriptCloseWindowTitle => 'Close Window';

  @override
  String get skapiScriptCloseWindowSummaryWhat =>
      'Sends a graceful close to a window so the app can show its own \"save changes?\" dialog.';

  @override
  String get skapiScriptCloseWindowSummaryHow =>
      'Posts WM_CLOSE through user32 SendMessage. Same effect as the user clicking the X button. Empty process name targets the foreground window.';

  @override
  String get skapiScriptCloseWindowNote =>
      'Apps with unsaved work will pop their own dialog. The script does not wait for or terminate hung apps.';

  @override
  String get skapiScriptCloseWindowParamProcessLabel => 'processName';

  @override
  String get skapiScriptCloseWindowParamProcessHint =>
      'Process name without .exe. Empty targets the foreground window.';

  @override
  String get skapiScriptKillAppTitle => 'Force Quit App';

  @override
  String get skapiScriptKillAppSummaryWhat =>
      'Terminates every instance of a process. Tries WM_CLOSE first, then TerminateProcess if the app is still alive after the timeout.';

  @override
  String get skapiScriptKillAppSummaryHow =>
      'Sends WM_CLOSE to each main window, waits the configured timeout, then issues Stop-Process with -Force on anything still running.';

  @override
  String get skapiScriptKillAppNote =>
      'Unsaved work in unresponsive apps will be lost on force-terminate. Use preKillSave for editor-style apps that respond to Ctrl+S.';

  @override
  String get skapiScriptKillAppParamProcessLabel => 'processName';

  @override
  String get skapiScriptKillAppParamProcessHint =>
      'Process name without .exe. All running instances are terminated.';

  @override
  String get skapiScriptKillAppParamTimeoutLabel => 'timeout';

  @override
  String get skapiScriptKillAppParamTimeoutHint =>
      'Seconds to wait between WM_CLOSE and force-terminate. Higher values give the app more time to save.';

  @override
  String get skapiScriptKillAppParamPreKillSaveLabel => 'preKillSave';

  @override
  String get skapiScriptKillAppParamPreKillSaveHint =>
      'Sends Ctrl+S to the foreground window before closing. Useful for editors but a no-op on apps that ignore Ctrl+S.';

  @override
  String get skapiScriptLaunchAppTitle => 'Launch App';

  @override
  String get skapiScriptLaunchAppSummaryWhat =>
      'Starts an executable, opens a URL, or launches a document with the default handler.';

  @override
  String get skapiScriptLaunchAppSummaryHow =>
      'Calls PowerShell Start-Process with the path and optional argument list. Path may be an .exe, a full file path, or a URL.';

  @override
  String get skapiScriptLaunchAppNote =>
      'Paths with spaces are accepted. Use a URL like https://example.com to open the default browser.';

  @override
  String get skapiScriptLaunchAppParamPathLabel => 'path';

  @override
  String get skapiScriptLaunchAppParamPathHint =>
      'Executable, full file path, or URL. notepad / C:\\\\tools\\\\my.exe / https://example.com.';

  @override
  String get skapiScriptLaunchAppParamArgsLabel => 'args';

  @override
  String get skapiScriptLaunchAppParamArgsHint =>
      'Arguments passed to the executable. Empty for none.';

  @override
  String get skappListenerCardTitle => 'SKAPP HTTP Listener';

  @override
  String skappListenerCardSubtitleRunning(int port) {
    return 'Running on port $port';
  }

  @override
  String get skappListenerCardSubtitleStopped => 'Stopped';

  @override
  String get skappListenerCardSubtitleUnsupported =>
      'This platform cannot host the listener.';

  @override
  String get skappListenerCardEnableSwitch => 'Enable listener';

  @override
  String get skappListenerCardSecurityNote =>
      'The listener accepts connections only on your local network and requires the bearer token. Plain HTTP, do not expose it to the public internet.';

  @override
  String get settingsLanVisibleTitle => 'Visible on LAN';

  @override
  String get settingsLanVisibleSubtitle =>
      'When off, the listener only binds to localhost. Paired BF devices cannot reach this desktop.';

  @override
  String get settingsLanVisibleWarnBfBreaks =>
      'Turning this off breaks the BF webhook chain. Use only in a trusted or test environment.';

  @override
  String get settingsLanVisibleAutoReopenedSnack =>
      'LAN visibility was turned back on so BF devices can reach this desktop.';

  @override
  String get skapiRunRemoteDeveloperModeDisabled =>
      'The target desktop has Developer mode disabled, so remote script execution is off there.';

  @override
  String get skappPeerPairingManualUuidConfirmLabel =>
      'Confirmation code (last 4 of UUID)';

  @override
  String get skappPeerPairingManualUuidConfirmHint =>
      'Read the 4-character code shown on the desktop\'s pairing screen.';

  @override
  String get skappPeerPairingManualUuidConfirmError =>
      'The code doesn\'t match the last 4 of the UUID. Check the desktop screen.';

  @override
  String get skappListenerCardUuidLast4Label => 'Pairing confirmation code';

  @override
  String get skappListenerCardUuidLast4Hint =>
      'Type these 4 characters on the phone\'s manual pairing screen.';

  @override
  String get settingsPeerTokensTitle => 'Issued peer tokens';

  @override
  String get settingsPeerTokensSubtitle =>
      'Mobile peers paired with this desktop. Revoke any entry to log it out without affecting the others.';

  @override
  String get settingsPeerTokensEmpty => 'No peers paired yet.';

  @override
  String settingsPeerTokensIssuedAt(String when) {
    return 'Paired $when';
  }

  @override
  String settingsPeerTokensLastUsed(String when) {
    return 'Last used $when';
  }

  @override
  String get settingsPeerTokensRevokeButton => 'Revoke';

  @override
  String get settingsPeerTokensRevokeConfirmTitle => 'Revoke this peer?';

  @override
  String get settingsPeerTokensRevokeConfirmBody =>
      'The peer will be logged out immediately and has to pair again to reach this desktop.';

  @override
  String get settingsPeerTokensRevokeConfirmCancel => 'Cancel';

  @override
  String get settingsPeerTokensRevokeConfirmAction => 'Revoke';

  @override
  String settingsPeerTokensRevokedToast(String name) {
    return 'Peer $name revoked';
  }

  @override
  String get skappListenerCardRotateCertButton => 'Rotate TLS certificate';

  @override
  String get skappListenerCardRotateCertConfirmTitle => 'Rotate certificate?';

  @override
  String get skappListenerCardRotateCertConfirmBody =>
      'A fresh self-signed TLS certificate will be generated. Every previously paired peer will fail handshake until it re-pairs.';

  @override
  String get skappListenerCardRotateCertConfirmCancel => 'Cancel';

  @override
  String get skappListenerCardRotateCertConfirmAction => 'Rotate';

  @override
  String get skappListenerCardRotateCertDoneSnack =>
      'TLS certificate rotated. Re-pair every device.';

  @override
  String get skappListenerCardCertFingerprintLabel => 'TLS fingerprint';

  @override
  String skappListenerCardErrorPortInUse(int port) {
    return 'Port $port is already in use. Pick a different port from Network identity.';
  }

  @override
  String skappListenerCardErrorGeneric(String error) {
    return 'Could not start the listener: $error';
  }

  @override
  String get skappPeerPairingTitle => 'Pair Desktop SKAPP';

  @override
  String get skappPeerPairingSubtitle =>
      'Scan the QR shown in the Desktop SKAPP\'s Settings, or paste the pairing code manually.';

  @override
  String get skappPeerPairingTabScan => 'Scan QR';

  @override
  String get skappPeerPairingTabManual => 'Manual';

  @override
  String get skappPeerPairingScanHint =>
      'Point your camera at the QR shown on Desktop SKAPP > Settings > SKAPP HTTP Listener.';

  @override
  String get skappPeerPairingScanCameraDeniedTitle =>
      'Camera permission required';

  @override
  String get skappPeerPairingScanCameraDeniedBody =>
      'Allow camera access from your phone settings to scan the pairing QR. You can also enter the code manually.';

  @override
  String get skappPeerPairingManualHostLabel => 'Desktop IP or hostname';

  @override
  String get skappPeerPairingManualPortLabel => 'Port';

  @override
  String get skappPeerPairingManualTokenLabel => 'Bearer token';

  @override
  String get skappPeerPairingManualUuidLabel => 'Desktop UUID';

  @override
  String get skappPeerPairingManualNameLabel => 'Display name';

  @override
  String get skappPeerPairingManualSubmit => 'Pair';

  @override
  String skappPeerPairingSavedToast(String name) {
    return 'Paired with $name';
  }

  @override
  String skappPeerPairingFailedToast(String reason) {
    return 'Pairing failed: $reason';
  }

  @override
  String get skappPeerPairingShowQrTitle => 'Pair a phone with this Desktop';

  @override
  String get skappPeerPairingShowQrBody =>
      'Open SKAPP on your phone, go to SKAPI > Settings > Pair Desktop, and scan this QR. The QR contains the bearer token, treat it like a password.';

  @override
  String get skappPeerPairingShowQrCloseButton => 'Done';

  @override
  String get skappPeerListEmpty =>
      'No paired Desktop yet. Pair one to run scripts from this phone.';

  @override
  String get skappPeerListSectionTitle => 'Paired Desktop SKAPPs';

  @override
  String get skappPeerStatusOnline => 'Online';

  @override
  String get skappPeerStatusOffline => 'Offline';

  @override
  String skappPeerStatusLastSeen(String when) {
    return 'Last seen $when';
  }

  @override
  String get skappPeerRemoveTooltip => 'Remove paired Desktop';

  @override
  String get skappPeerRemoveConfirmTitle => 'Remove pairing?';

  @override
  String skappPeerRemoveConfirmBody(String name) {
    return 'Scripts triggered from this phone will no longer run on $name until you pair again.';
  }

  @override
  String get skappPeerScanRefreshTooltip => 'Refresh peer list';

  @override
  String skapiRunRemoteSheetTitle(String peerName) {
    return 'Run remotely on $peerName';
  }

  @override
  String get skapiRunRemoteConnecting => 'Connecting to Desktop...';

  @override
  String get skapiRunRemoteOfflineError =>
      'The paired Desktop is offline. Try refreshing peers or check the Desktop\'s listener.';

  @override
  String get skapiRunRemoteUnauthorizedError =>
      'Bearer token rejected. The Desktop\'s token may have rotated. Re-pair from Settings.';

  @override
  String skapiRunRemoteHttpError(String reason) {
    return 'Remote run failed: $reason';
  }

  @override
  String get skapiRunMobileNoPeerTitle => 'No paired Desktop';

  @override
  String get skapiRunMobileNoPeerBody =>
      'Pair a Desktop SKAPP from Settings to run scripts from this phone.';

  @override
  String get skapiRunMobileNoPeerCta => 'Open Settings';

  @override
  String get skapiRunRemoteNotWhitelisted =>
      'This script isn\'t marked as remotely runnable. Run it on the desktop directly.';

  @override
  String get skapiRunRemoteNoPeerHint =>
      'Pair a Desktop SKAPP from Settings to run scripts from this phone.';

  @override
  String get skapiRunRemoteNoPeerAction => 'Open settings';

  @override
  String get skappPeerPickerTitle => 'Send to which computer?';

  @override
  String get skappPeerPickerSubtitle =>
      'Pick the paired Desktop SKAPP that should run this script.';

  @override
  String get skappPeerPickerOfflineReason => 'Offline';

  @override
  String get skappPeerPickerDevModeOffReason => 'Developer mode is off';

  @override
  String get skappPeerPickerEmpty => 'No paired desktops to pick from.';

  @override
  String get skapiRunRemoteCancelButton => 'Cancel';

  @override
  String get skapiRunRemoteCancelledNote => 'Run cancelled';

  @override
  String skapiRunRemoteTooManyRuns(int running, int limit) {
    return 'That desktop already has $running scripts running ($limit max). Wait for one to finish.';
  }

  @override
  String get skappPeerHealthDevModeBadge => 'Dev mode';

  @override
  String get remoteRunActivityCardTitle => 'Remote runs';

  @override
  String get remoteRunActivityCardSubtitle =>
      'Recent script runs paired mobile peers asked this desktop to perform.';

  @override
  String get remoteRunActivityCardEmpty => 'No remote runs yet.';

  @override
  String get remoteRunActivityCardClear => 'Clear history';

  @override
  String remoteRunActivityRowOk(int exitCode, int durationMs) {
    return 'exit $exitCode · $durationMs ms';
  }

  @override
  String get remoteRunActivityRowCancelled => 'cancelled';

  @override
  String remoteRunActivityRowRejected(String reason) {
    return 'rejected · $reason';
  }

  @override
  String get mobileTriggerCardTitle => 'Trigger';

  @override
  String get mobileTriggerCardSubtitle =>
      'Send a tap event to a paired Desktop SKAPP. Any binding listening for this event will fire its script on that desktop.';

  @override
  String get mobileTriggerCardSendButton => 'Send tap';

  @override
  String get mobileTriggerCardSending => 'Sending...';

  @override
  String mobileTriggerSentToast(String name) {
    return 'Tap sent to $name';
  }

  @override
  String get skapiBindEventMobileTap => 'Mobile tap';

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
  String get msHomeScreenTitle => 'Mobile peer';

  @override
  String get msHomeScreenNotFound => 'This mobile peer is no longer paired.';

  @override
  String get msHomeScreenEventsHeader => 'Available events';

  @override
  String msHomeScreenBindingsHeader(int count) {
    return 'Bindings ($count)';
  }

  @override
  String get msHomeScreenBindingsEmpty =>
      'No bindings yet. Use SKAPI → script → Bind to action to wire a tap event to a script.';

  @override
  String get msHomeScreenHint =>
      'Phones don\'t run scripts. They emit trigger events that this desktop binds to scripts.';

  @override
  String msHomeScreenPairedAt(String date) {
    return 'Paired $date';
  }

  @override
  String get skapiGroupNotifyTitle => 'Notify & Dialog';

  @override
  String get skapiGroupNotifyDesc =>
      'Scripts in this group talk to the user directly: pop a toast, show a modal dialog, or wait for a yes/no answer. Use these when a SmartKraft device\'s event needs the human in front of the screen to acknowledge or decide.';

  @override
  String get skapiGroupNotifyFoot =>
      'Typical use: dialog before a destructive action, toast on a soft reminder, dialog with timeout to fall through automatically.';

  @override
  String get skapiScriptDialogTitle => 'Show Dialog';

  @override
  String get skapiScriptDialogSummaryWhat =>
      'Shows a modal Windows MessageBox and returns the user\'s choice (ok / cancel / yes / no / timeout).';

  @override
  String get skapiScriptDialogSummaryHow =>
      'Calls System.Windows.Forms.MessageBox on a child runspace so the script can race the dialog against an optional timeout. The chosen value is written to stdout for the caller to branch on.';

  @override
  String get skapiScriptDialogNote =>
      'stdout is the user\'s answer in lowercase. timeout=0 waits indefinitely.';

  @override
  String get skapiScriptDialogParamTitleLabel => 'title';

  @override
  String get skapiScriptDialogParamTitleHint =>
      'Window title shown in the message box.';

  @override
  String get skapiScriptDialogParamBodyLabel => 'body';

  @override
  String get skapiScriptDialogParamBodyHint =>
      'The question or message shown to the user.';

  @override
  String get skapiScriptDialogParamButtonsLabel => 'buttons';

  @override
  String get skapiScriptDialogParamButtonsHint =>
      'ok / ok_cancel / yes_no / yes_no_cancel. Default ok_cancel.';

  @override
  String get skapiScriptDialogParamTimeoutLabel => 'timeout';

  @override
  String get skapiScriptDialogParamTimeoutHint =>
      'Seconds to wait before falling through with \'timeout\'. 0 means wait forever.';

  @override
  String get skapiScriptToastTitle => 'Show Toast';

  @override
  String get skapiScriptToastSummaryWhat =>
      'Shows a Windows toast notification with a title and body. Slides in from the bottom right and lands in Action Center.';

  @override
  String get skapiScriptToastSummaryHow =>
      'Builds a ToastNotification XML payload and hands it to the WinRT ToastNotificationManager under the configured AppUserModelID.';

  @override
  String get skapiScriptToastNote =>
      'Tier 2: requires Windows 10+ and a registered AppUserModelID for the cleanest UX. The default AUMID puts the toast under PowerShell in Action Center.';

  @override
  String get skapiScriptToastParamTitleLabel => 'title';

  @override
  String get skapiScriptToastParamTitleHint => 'Bold first line of the toast.';

  @override
  String get skapiScriptToastParamBodyLabel => 'body';

  @override
  String get skapiScriptToastParamBodyHint => 'Smaller second line. Optional.';

  @override
  String get skapiScriptToastParamAumidLabel => 'aumid';

  @override
  String get skapiScriptToastParamAumidHint =>
      'App User Model ID under which the toast appears. Default falls back to PowerShell.';

  @override
  String get skapiGroupVisualBreakTitle => 'Visual Break';

  @override
  String get skapiGroupVisualBreakDesc =>
      'Soft visual cues that nudge the user away from intense work: dim the screen, switch to grayscale, find the cursor, or show the desktop. Effects in this group are reversible and never hard-block input.';

  @override
  String get skapiGroupVisualBreakFoot =>
      'Typical use: dim screen at the start of a focus break, grayscale mode for late-night reads, find-mouse on multi-monitor setups.';

  @override
  String get skapiScriptShowDesktopTitle => 'Show Desktop';

  @override
  String get skapiScriptShowDesktopSummaryWhat =>
      'Toggles \'show desktop\'. Same as pressing Win+D twice in a row.';

  @override
  String get skapiScriptShowDesktopSummaryHow =>
      'Calls Shell.Application.ToggleDesktop through COM. Running it again restores the previous window arrangement.';

  @override
  String get skapiScriptFadeScreenTitle => 'Fade Screen';

  @override
  String get skapiScriptFadeScreenSummaryWhat =>
      'Fades the internal display brightness from its current level to a target level over a few seconds.';

  @override
  String get skapiScriptFadeScreenSummaryHow =>
      'Reads current brightness via WMI WmiMonitorBrightness, then steps WmiSetBrightness in linear increments toward the target so the change feels smooth.';

  @override
  String get skapiScriptFadeScreenNote =>
      'Tier 2: WMI brightness only works on internal panels. External monitors do not respond on this path.';

  @override
  String get skapiScriptFadeScreenParamTargetLabel => 'target';

  @override
  String get skapiScriptFadeScreenParamTargetHint =>
      'Final brightness percentage (0-100).';

  @override
  String get skapiScriptFadeScreenParamDurationLabel => 'duration';

  @override
  String get skapiScriptFadeScreenParamDurationHint =>
      'Seconds the fade should take. The script uses ten brightness steps per second.';

  @override
  String get skapiScriptGrayscaleTitle => 'Grayscale Filter';

  @override
  String get skapiScriptGrayscaleSummaryWhat =>
      'Turns the Windows Color Filters grayscale mode on or off.';

  @override
  String get skapiScriptGrayscaleSummaryHow =>
      'Writes the ColorFiltering registry keys, then sends Win+Ctrl+C so Windows picks up the change live without a sign-out.';

  @override
  String get skapiScriptGrayscaleNote =>
      'Tier 2: requires Settings > Accessibility > Color filters > \'Allow the shortcut key\' to be on for the live toggle to work.';

  @override
  String get skapiScriptGrayscaleParamOnLabel => 'on';

  @override
  String get skapiScriptGrayscaleParamOnHint =>
      'true to enable grayscale, false to turn it off.';

  @override
  String get skapiScriptGrayscaleParamDurationLabel => 'duration';

  @override
  String get skapiScriptGrayscaleParamDurationHint =>
      '0 means just toggle. >0 auto-reverts back to color after the given seconds. Ideal for visual breaks.';

  @override
  String get skapiScriptFindMouseShakeTitle => 'Find Mouse';

  @override
  String get skapiScriptFindMouseShakeSummaryWhat =>
      'Wiggles the cursor in a small circle to draw the eye to its position. The cursor returns to its starting point when the animation ends.';

  @override
  String get skapiScriptFindMouseShakeSummaryHow =>
      'Reads the current cursor position with GetCursorPos, then loops SetCursorPos around a circle of the configured radius. Useful on multi-monitor and 4K setups.';

  @override
  String get skapiScriptFindMouseShakeNote =>
      'Tier 2: SetCursorPos can be blocked by accessibility software, and behaviour varies under remote-desktop sessions.';

  @override
  String get skapiScriptFindMouseShakeParamRadiusLabel => 'radius';

  @override
  String get skapiScriptFindMouseShakeParamRadiusHint =>
      'Pixels the cursor travels from its origin during the loop. Bigger is more eye-catching.';

  @override
  String get skapiScriptFindMouseShakeParamLoopsLabel => 'loops';

  @override
  String get skapiScriptFindMouseShakeParamLoopsHint =>
      'How many full circles to draw before settling.';

  @override
  String get skapiGroupProgramsTitle => 'Specific Program Control';

  @override
  String get skapiGroupProgramsDesc =>
      'Targeted scripts for specific apps and browsers: graceful save+close, multi-instance shutdown, browser-wide cleanup. Handy when a SmartKraft device wants to wind a particular workflow down without nuking the whole desktop.';

  @override
  String get skapiGroupProgramsFoot =>
      'Typical use: save and close all editors before sleep, shut every browser at end-of-day, narrowed cleanup of one process family.';

  @override
  String get skapiScriptCloseWithSaveTitle => 'Save & Close App';

  @override
  String get skapiScriptCloseWithSaveSummaryWhat =>
      'Sends Ctrl+S to a target app to trigger its own save, waits, then closes the window gracefully.';

  @override
  String get skapiScriptCloseWithSaveSummaryHow =>
      'Focuses each running instance, sends Ctrl+S via SendKeys, waits the configured beat, then posts WM_CLOSE so the app can confirm or finish saving.';

  @override
  String get skapiScriptCloseWithSaveNote =>
      'Tier 2: relies on the app interpreting Ctrl+S as \'save\'. Some chat / web apps treat it differently. Test with the apps you actually target.';

  @override
  String get skapiScriptCloseWithSaveParamProcessLabel => 'processName';

  @override
  String get skapiScriptCloseWithSaveParamProcessHint =>
      'Process name without .exe (winword, excel, code, photoshop). All running instances are saved and closed.';

  @override
  String get skapiScriptCloseWithSaveParamWaitLabel => 'wait';

  @override
  String get skapiScriptCloseWithSaveParamWaitHint =>
      'Seconds to wait between Ctrl+S and the close signal so the app finishes saving.';

  @override
  String get skapiScriptCloseAllInstancesTitle => 'Close All Instances';

  @override
  String get skapiScriptCloseAllInstancesSummaryWhat =>
      'Sends a graceful close to every visible window of a process. Each instance can show its own save dialog.';

  @override
  String get skapiScriptCloseAllInstancesSummaryHow =>
      'Iterates the matching processes via Get-Process and posts WM_CLOSE to each one\'s main window. No force fallback.';

  @override
  String get skapiScriptCloseAllInstancesParamProcessLabel => 'processName';

  @override
  String get skapiScriptCloseAllInstancesParamProcessHint =>
      'Process name without .exe. Matches all instances.';

  @override
  String get skapiScriptBrowserCloseAllTitle => 'Close All Browsers';

  @override
  String get skapiScriptBrowserCloseAllSummaryWhat =>
      'Closes every running mainstream browser (Chrome, Edge, Firefox, Brave, Vivaldi, Opera) gracefully.';

  @override
  String get skapiScriptBrowserCloseAllSummaryHow =>
      'Iterates the well-known browser process names and posts WM_CLOSE to each main window. Modern browsers preserve the session if \'restore tabs on next launch\' is enabled.';

  @override
  String get skapiScriptBrowserCloseAllNote =>
      'Force-terminate is not used. To wipe the session as well, use kill-app per browser instead.';

  @override
  String get skapiTierBadgeExperimental => 'Experimental';

  @override
  String get skapiTierBadgeExperimentalTooltip =>
      'This script depends on a Windows API that may not be reliable across machines. Test it before relying on it.';

  @override
  String get skapiTierBadgeBlocked => 'Coming soon';

  @override
  String get skapiTierBadgeBlockedTooltip =>
      'This script is part of the planned library but not implemented yet.';

  @override
  String get skapiGroupSaveWorkTitle => 'Save Work';

  @override
  String get skapiGroupSaveWorkDesc =>
      'Scripts in this group save your open work to disk before a break or unexpected shutdown. When your SmartKraft device triggers a break, the chosen script automatically saves your file in Word, Excel, VS Code or any other editor, so even if your computer sleeps, shuts down, or runs another command, your work stays safe.';

  @override
  String get skapiGroupSaveWorkFoot =>
      'Typical use: auto-save at the start of a focus break, document backup on low-battery warning, or a one-button \"save everything\" trigger.';

  @override
  String get skapiScriptSaveActiveWindowTitle => 'Save Active Window';

  @override
  String get skapiScriptSaveActiveWindowSummaryWhat =>
      'Sends a virtual Ctrl+S to whichever Windows window currently has focus, triggering that application\'s own \"save\" behavior.';

  @override
  String get skapiScriptSaveActiveWindowSummaryHow =>
      'First it grabs the active window\'s handle and logs its title. Then it dispatches Ctrl+S via SendKeys. Word saves to its current path, VS Code writes the file. If a \"Save As\" dialog appears, it waits until the user manually confirms.';

  @override
  String get skapiScriptSaveActiveWindowParamTimeoutLabel => 'timeout';

  @override
  String get skapiScriptSaveActiveWindowParamTimeoutHint =>
      'Seconds to wait after sending the keystroke so the app has time to write the file.';

  @override
  String get skapiScriptSaveActiveWindowParamVerboseLabel => 'verbose';

  @override
  String get skapiScriptSaveAllOpenTitle => 'Save All Open Documents';

  @override
  String get skapiScriptSaveAllOpenSummaryWhat =>
      'Iterates through a whitelist of running editors and tells each one to save its open documents.';

  @override
  String get skapiScriptSaveAllOpenSummaryHow =>
      'For every whitelisted process found, it focuses the main window, sends Ctrl+S, then waits the configured per-app timeout before moving on. Apps that aren\'t running are skipped silently unless verbose mode is on.';

  @override
  String get skapiScriptSaveAllOpenNote =>
      'The whitelist defaults to Word, Excel, PowerPoint and VS Code. Edit the apps parameter to add your own.';

  @override
  String get skapiScriptSaveAllOpenParamAppsLabel => 'apps';

  @override
  String get skapiScriptSaveAllOpenParamAppsHint =>
      'Process names (without .exe) to send save to. Order matters: earlier entries are processed first.';

  @override
  String get skapiScriptSaveAllOpenParamTimeoutLabel => 'timeoutPerApp';

  @override
  String get skapiScriptSaveAllOpenParamVerboseLabel => 'verbose';

  @override
  String get skapiScriptAutosaveTriggerTitle => 'Trigger Auto-Save';

  @override
  String get skapiScriptAutosaveTriggerSummaryWhat =>
      'Broadcasts a Windows save command to every visible top-level window in one pass.';

  @override
  String get skapiScriptAutosaveTriggerSummaryHow =>
      'Enumerates visible windows, then sends each one a WM_COMMAND with the standard save id. Apps that listen for that message react as if you clicked their File menu\'s Save item. Faster than a per-window Ctrl+S, but a few apps ignore the broadcast.';

  @override
  String get skapiScriptAutosaveTriggerNote =>
      'Use this when you want to flush every editor at once and don\'t mind that a small number of apps may not respond. Combine with save-all-open for stricter coverage.';

  @override
  String get skapiScriptAutosaveTriggerParamDelayLabel => 'delay';

  @override
  String get skapiScriptAutosaveTriggerParamDelayHint =>
      'Seconds to wait before broadcasting, useful when you want the device\'s break notification to appear first.';

  @override
  String get skapiScriptAutosaveTriggerParamVerboseLabel => 'verbose';

  @override
  String get skapiScriptDetailSummaryWhatLabel => 'What it does:';

  @override
  String get skapiScriptDetailSummaryHowLabel => 'How it works:';

  @override
  String get skapiScriptDetailOriginalSectionTitle => 'Original Script';

  @override
  String get skapiScriptDetailOriginalSectionSub => 'read-only · English';

  @override
  String get skapiScriptDetailEditingSectionTitle => 'Edits';

  @override
  String get skapiScriptDetailEditingNotYet => 'No edits yet';

  @override
  String get skapiScriptDetailEditingNotYetSub =>
      'Create a copy on this device without changing the original.';

  @override
  String get skapiScriptDetailEditingModified => 'Edited';

  @override
  String skapiScriptDetailEditingModifiedSub(String date) {
    return 'Last changed $date.';
  }

  @override
  String get skapiScriptDetailEditingOutdated => 'Library updated';

  @override
  String get skapiScriptDetailEditingOutdatedSub =>
      'The original was changed by an app update. Compare or reset.';

  @override
  String get skapiScriptDetailParamWarnTitle =>
      'Check parameters before running';

  @override
  String get skapiScriptDetailParamWarnHint =>
      'To change these values, use \"Edit\". Parameters are defined in the script\'s param() block.';

  @override
  String get skapiScriptDetailNotesTitle => 'Notes';

  @override
  String get skapiScriptDetailButtonRun => 'Run Now';

  @override
  String get skapiScriptDetailButtonBindAction => 'Bind to Action';

  @override
  String get skapiScriptDetailButtonEdit => 'Edit';

  @override
  String get skapiScriptDetailButtonView => 'View';

  @override
  String get skapiScriptDetailButtonReset => 'Reset';

  @override
  String get skapiScriptDetailButtonCompare => 'Compare';

  @override
  String get skapiScriptCopyButton => 'Copy';

  @override
  String get skapiScriptCopyButtonDone => 'Copied';

  @override
  String get skapiScriptSelectButton => 'Select';

  @override
  String get skapiEditorTitle => 'Edit';

  @override
  String skapiEditorHint(String scriptId) {
    return '$scriptId · You are editing a copy on this device. The original library version is unchanged. \"Reset\" always restores the original.';
  }

  @override
  String get skapiEditorStatusBarTitle => 'POWERSHELL · UTF-8';

  @override
  String get skapiEditorStatusModified => '● Modified';

  @override
  String get skapiEditorStatusUnmodified => 'Unchanged';

  @override
  String skapiEditorFootCursor(int line, int column) {
    return 'Line $line · Column $column';
  }

  @override
  String get skapiEditorFootSaveLabel => 'Save';

  @override
  String skapiEditorDiffLineCount(int count) {
    return '$count line changed';
  }

  @override
  String skapiEditorDiffLinesCount(int count) {
    return '$count lines changed';
  }

  @override
  String get skapiEditorDiffCompareLink => 'Compare with original';

  @override
  String get skapiEditorButtonReset => 'Reset';

  @override
  String get skapiEditorButtonSave => 'Save';

  @override
  String get skapiEditorAfterSaveNote =>
      'After saving, \"Run Now\" will execute the edited version.';

  @override
  String get skapiLinuxDistroHeading => 'Pick your distribution family';

  @override
  String get skapiLinuxDistroSubtitle =>
      'Linux scripts diverge between Debian-based (apt, .deb) and Arch-based (pacman) families. Pick the one that matches your machine.';

  @override
  String get skapiLinuxDistroDebianLabel => 'Debian-based';

  @override
  String get skapiLinuxDistroDebianSub =>
      'Debian, Ubuntu, Mint, Pop!_OS, Elementary, Kali, MX, Zorin';

  @override
  String get skapiLinuxDistroArchLabel => 'Arch-based';

  @override
  String get skapiLinuxDistroArchSub =>
      'Arch, Manjaro, EndeavourOS, Garuda (coming later)';

  @override
  String get skapiNewActionNoDevicesTitle => 'Pair a device first';

  @override
  String get skapiNewActionNoDevicesBody =>
      'Creating an on-device action needs at least one paired SmartKraft device (BF for now).';

  @override
  String get skapiNewActionNoDevicesCta => 'Open Devices';

  @override
  String get skapiNewActionPickDeviceTitle => 'Pick a device';

  @override
  String get skapiNewActionPickDeviceSubtitle =>
      'Which device should this action live on?';

  @override
  String get skapiUserNewTitle => 'New script';

  @override
  String get skapiUserEditTitle => 'Edit script';

  @override
  String get skapiUserTitleLabel => 'Title';

  @override
  String get skapiUserTitleHint => 'e.g. Morning routine';

  @override
  String get skapiUserDescLabel => 'Description';

  @override
  String get skapiUserDescHint => 'What does this script do?';

  @override
  String get skapiUserPlatformLabel => 'Platform';

  @override
  String get skapiUserCodeLabel => 'Code';

  @override
  String get skapiUserCodeHint => '# Your PowerShell code here';

  @override
  String get skapiUserSaveCta => 'Save';

  @override
  String get skapiUserValidationEmpty => 'Title and code can\'t be empty.';

  @override
  String get skapiUserSavedSnack => 'Script saved';

  @override
  String get skapiUserSectionHeading => 'My scripts';

  @override
  String skapiUserSectionSub(int count) {
    return '$count scripts';
  }

  @override
  String get skapiUserEmptyHint =>
      'No scripts of your own yet. Create one with the New action button, top-right.';

  @override
  String get skapiUserDetailCodeHeading => 'Code';

  @override
  String get skapiUserEditCta => 'Edit';

  @override
  String get skapiUserDeleteConfirmTitle => 'Delete script?';

  @override
  String skapiUserDeleteConfirmBody(String name) {
    return '$name will be permanently deleted.';
  }

  @override
  String get skapiUserDeletedSnack => 'Script deleted';

  @override
  String get skapiUserRunCta => 'Run';

  @override
  String get skapiUserRunUnsupported => 'Running scripts is desktop-only.';

  @override
  String get skapiUserRunOutputTitle => 'Run output';

  @override
  String skapiUserRunDone(int code) {
    return 'Finished (exit $code)';
  }

  @override
  String get skapiLocalScriptsSubheading => 'Local scripts';

  @override
  String get skapiOnDeviceApiSubheading => 'On-device API';

  @override
  String get skapiOnDeviceApiLoadError => 'Could not read endpoints';

  @override
  String get skapiOnDeviceApiRowHint => 'Tap any row to open the editor';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get skapiApiTemplateSectionHeader => 'Templates';

  @override
  String skapiApiTemplateSectionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count templates',
      one: '1 template',
    );
    return '$_temp0';
  }

  @override
  String get skapiApiTemplateUploadCta => 'Upload to device';

  @override
  String get skapiApiTemplateUploadHint =>
      'Uploading writes this template into one of the device\'s 5 USER API slots. The device fires it on its own trigger (BF: countdown end).';

  @override
  String get skapiApiTemplatePreviewTitle => 'Endpoint preview';

  @override
  String get skapiApiTemplatePreviewType => 'Type';

  @override
  String get skapiApiTemplatePreviewMethod => 'Method';

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
  String get skapiApiTemplatePreviewDelay => 'Delay';

  @override
  String get skapiOtherCategoryHeading => 'Pick a device category';

  @override
  String get skapiOtherCategorySubtitle =>
      'Templates upload onto the paired device and fire on the device\'s own trigger (no laptop involved).';

  @override
  String get skapiOtherSyndimmSub => 'SmartKraft smart dimmer';

  @override
  String get skapiOtherLebensspurSub => 'SmartKraft activity tracker';

  @override
  String get skapiOtherBlockingfocusSub => 'SmartKraft focus timer';

  @override
  String get skapiOtherIotSub =>
      'Third-party IoT webhooks (IFTTT, Home Assistant, generic REST)';

  @override
  String get skapiOtherServerSub =>
      'Self-hosted HTTP receivers (n8n, Node-RED, custom)';

  @override
  String get skapiCategoryComingSoon => 'Templates coming soon';

  @override
  String get skapiScriptLockSummaryHowLxDebian =>
      'Calls loginctl lock-session for the current XDG_SESSION_ID; falls back to xdg-screensaver lock when loginctl is not available.';

  @override
  String get skapiScriptHibernateSummaryHowLxDebian =>
      'Calls systemctl hibernate. Optional delay sleeps for the requested seconds before suspending.';

  @override
  String get skapiScriptHibernateNoteLxDebian =>
      'Hibernation needs to be configured (swap >= RAM and the resume= kernel parameter). On systems where it is not, systemd-logind falls back to suspend.';

  @override
  String get skapiScriptSleepSummaryHowLxDebian =>
      'Calls systemctl suspend. The kernel may delay if a foreground inhibitor is blocking idle transitions.';

  @override
  String get skapiScriptShutdownSummaryHowLxDebian =>
      'Schedules a graceful poweroff via /sbin/shutdown -h +N (minutes). Falls back to systemctl poweroff after the requested delay if shutdown is missing.';

  @override
  String get skapiScriptShutdownNoteLxDebian =>
      '/sbin/shutdown only takes minutes; values under 60 round up to 1 minute. Other logged-in users see a wall message during the countdown.';

  @override
  String get skapiScriptShutdownParamForceHintLxDebian =>
      'Terminates the user session before powering off so the 90s SIGTERM grace period is skipped.';

  @override
  String get skapiScriptBrightnessSummaryHowLxDebian =>
      'Sets internal display backlight via brightnessctl set N% (preferred) or light -S N as a fallback. Both write to /sys/class/backlight.';

  @override
  String get skapiScriptBrightnessNoteLxDebian =>
      'brightnessctl is sudoless when the user is in the video group, which is the default after install on most Debian setups. External monitors over DDC need ddcutil and are not handled here.';

  @override
  String get skapiScriptMuteToggleSummaryHowLxDebian =>
      'Toggles or sets the master sink mute via wpctl (PipeWire on Debian 12+) with a pactl fallback for PulseAudio setups.';

  @override
  String get skapiScriptVolumeSetSummaryHowLxDebian =>
      'Sets the master sink volume to a 0-100 level via wpctl set-volume (PipeWire) or pactl set-sink-volume (PulseAudio).';

  @override
  String get skapiScriptVolumeSetNoteLxDebian =>
      'PipeWire and PulseAudio both expose per-app volume natively, so this script is tier 1 on Linux. Output above 100% is clamped for parity with other platforms.';

  @override
  String get skapiScriptMediaKeySummaryHowLxDebian =>
      'Sends a media-key action via playerctl, which uses MPRIS to talk to whatever app currently owns the session (Spotify, Firefox, VLC, mpv, Rhythmbox).';

  @override
  String get skapiScriptMediaKeyNoteLxDebian =>
      'If no MPRIS-aware media app is running, the command is a no-op. Install the app\'s MPRIS support if a known player does not respond.';

  @override
  String get skapiScriptMinimizeWindowSummaryHowLxDebian =>
      'Empty processName minimises the focused window via xdotool. Otherwise picks the first window whose WM_CLASS matches and minimises it.';

  @override
  String get skapiScriptMinimizeWindowNoteLxDebian =>
      'X11 only. WM_CLASS matching is case-sensitive and depends on how the app declared itself; check xprop WM_CLASS if uncertain.';

  @override
  String get skapiScriptMinimizeWindowParamProcessHintLxDebian =>
      'WM_CLASS instance name (for example: firefox, code, gnome-terminal-server). Empty targets the active window.';

  @override
  String get skapiScriptCloseWindowSummaryHowLxDebian =>
      'Sends WM_DELETE_WINDOW via wmctrl -x -c (matches WM_CLASS) with a title fallback. Equivalent to clicking the X button; the app may show its own save dialog.';

  @override
  String get skapiScriptCloseWindowNoteLxDebian =>
      'X11 only. For Wayland, prefer kill-app which uses signals instead of the window protocol.';

  @override
  String get skapiScriptCloseWindowParamProcessHintLxDebian =>
      'WM_CLASS instance name; empty closes the focused window. Title-substring match is used as a fallback.';

  @override
  String get skapiScriptKillAppSummaryHowLxDebian =>
      'pkill -TERM -x by exact comm name, waits the requested timeout, then pkill -KILL on anything still alive. Optional preKillSave focuses the window and sends Ctrl+S first (X11 only).';

  @override
  String get skapiScriptKillAppNoteLxDebian =>
      'Linux comm names are limited to 15 characters by the kernel. Use exact short names: firefox (not firefox-esr-bin), code, soffice.bin.';

  @override
  String get skapiScriptKillAppParamProcessHintLxDebian =>
      'Exact comm name (15 char kernel limit). Use pgrep -l to verify the visible name.';

  @override
  String get skapiScriptKillAppParamPreKillSaveHintLxDebian =>
      'Send Ctrl+S to the app\'s window before SIGTERM. Requires xdotool and X11; ignored on Wayland.';

  @override
  String get skapiScriptLaunchAppSummaryHowLxDebian =>
      'Smart dispatch: .desktop -> gtk-launch, real file path -> exec, anything else -> xdg-open, finally PATH lookup. The child is detached via setsid so SKAPP is not blocked.';

  @override
  String get skapiScriptLaunchAppNoteLxDebian =>
      'args is split on spaces. Quote-bearing arguments are not supported; use a wrapper script for complex command lines.';

  @override
  String get skapiScriptLaunchAppParamPathHintLxDebian =>
      'Binary name on PATH, absolute path, .desktop file, URL, or file path. xdg-open handles MIME types.';

  @override
  String get skapiScriptDialogSummaryHowLxDebian =>
      'Opens a modal dialog via zenity (GTK) with a kdialog (KDE) fallback. Writes one of ok / cancel / yes / no / timeout to stdout.';

  @override
  String get skapiScriptDialogNoteLxDebian =>
      'Install with: sudo apt install zenity. KDE Plasma users may have kdialog instead. Without either, the script exits with code 2.';

  @override
  String get skapiScriptToastSummaryHowLxDebian =>
      'Sends a desktop notification via notify-send (libnotify). Tier 1 because libnotify-bin is preinstalled on every modern Debian desktop.';

  @override
  String get skapiScriptToastNoteLxDebian =>
      'icon accepts Freedesktop icon-theme names (dialog-information, dialog-warning, dialog-error). duration in seconds; 0 keeps the toast until dismissed.';

  @override
  String get skapiScriptToastParamIconLabelLxDebian => 'Icon';

  @override
  String get skapiScriptToastParamIconHintLxDebian =>
      'Freedesktop icon name, for example: dialog-information, dialog-warning, dialog-error.';

  @override
  String get skapiScriptToastParamDurationLabelLxDebian => 'Duration';

  @override
  String get skapiScriptToastParamDurationHintLxDebian =>
      'Auto-dismiss after this many seconds. 0 means the toast stays until the user closes it.';

  @override
  String get skapiScriptShowDesktopSummaryHowLxDebian =>
      'Reads the EWMH show-desktop state via wmctrl -m, then toggles it with wmctrl -k. Mirrors Win+D semantics on X11.';

  @override
  String get skapiScriptShowDesktopNoteLxDebian =>
      'X11 only. Wayland equivalents are compositor-specific (Sway, Hyprland, GNOME Shell extensions).';

  @override
  String get skapiScriptFadeScreenSummaryHowLxDebian =>
      'Linearly fades the internal display backlight from current to target over the requested duration via brightnessctl in 10-step-per-second increments.';

  @override
  String get skapiScriptFadeScreenNoteLxDebian =>
      'Internal panels only. External monitors over DDC need ddcutil and are not handled here. Tier 2 because reading the current backlight depends on /sys/class/backlight visibility.';

  @override
  String get skapiScriptGrayscaleSummaryHowLxDebian =>
      'Toggles GNOME\'s accessibility magnifier color-saturation key (0.0 grayscale, 1.0 color) via gsettings, no extension needed.';

  @override
  String get skapiScriptGrayscaleNoteLxDebian =>
      'GNOME / Unity only. KDE Plasma and XFCE have no equivalent system path; on those desktops the script exits with code 3 instead of a silent no-op.';

  @override
  String get skapiScriptFindMouseShakeSummaryHowLxDebian =>
      'Reads the cursor position via xdotool getmouselocation, then traces a circle around it for the requested loop count using awk-computed cos/sin coordinates.';

  @override
  String get skapiScriptFindMouseShakeNoteLxDebian =>
      'X11 only. Wayland blocks synthetic pointer motion at the protocol level (security boundary), so the script exits with code 3.';

  @override
  String get skapiScriptCloseWithSaveSummaryHowLxDebian =>
      'For each visible window matching WM_CLASS: activate, Ctrl+S, wait, then send WM_DELETE_WINDOW via wmctrl. X11 only.';

  @override
  String get skapiScriptCloseWithSaveNoteLxDebian =>
      'Tier 2: Ctrl+S key injection is locale and focus dependent; only true save semantics behave predictably. Chat or web apps may map Ctrl+S to something else.';

  @override
  String get skapiScriptCloseWithSaveParamProcessHintLxDebian =>
      'WM_CLASS instance name (see xprop WM_CLASS). Required.';

  @override
  String get skapiScriptCloseAllInstancesSummaryHowLxDebian =>
      'Sends SIGTERM to every running process matching the exact comm name. Each app handles its own shutdown sequence (and may show its own save dialog).';

  @override
  String get skapiScriptCloseAllInstancesParamProcessHintLxDebian =>
      'Exact comm name as shown by pgrep -l. Required.';

  @override
  String get skapiScriptBrowserCloseAllSummaryHowLxDebian =>
      'Walks a list of Debian browser binaries (firefox, firefox-esr, chromium, google-chrome, brave, vivaldi-bin, opera) and sends SIGTERM to each running instance.';

  @override
  String get skapiScriptBrowserCloseAllNoteLxDebian =>
      'Browsers preserve the session if \"restore tabs on next launch\" is on, so this is a soft \"switch off the screen\" rather than a data-loss action.';

  @override
  String get skapiScriptSaveActiveWindowSummaryHowLxDebian =>
      'Sends Ctrl+S to the focused window via xdotool key --clearmodifiers. X11 only.';

  @override
  String get skapiScriptSaveActiveWindowNoteLxDebian =>
      'Wayland blocks synthetic key injection at the protocol level. Use autosave-trigger fallback or rely on the app\'s own autosave.';

  @override
  String get skapiScriptSaveAllOpenSummaryHowLxDebian =>
      'Iterates the apps list, finds each app\'s visible windows, activates them in turn and sends Ctrl+S between waits.';

  @override
  String get skapiScriptSaveAllOpenNoteLxDebian =>
      'Default app list covers LibreOffice (soffice.bin), VS Code (code), gedit and kate. Pass --apps \"name1,name2\" to override. X11 only.';

  @override
  String get skapiScriptSaveAllOpenParamAppsHintLxDebian =>
      'Comma-separated comm names, for example: soffice.bin,code,gedit.';

  @override
  String get skapiScriptAutosaveTriggerSummaryHowLxDebian =>
      'Walks every visible top-level window via wmctrl -l, activates each in turn and injects Ctrl+S. X11 lacks the WIN WM_COMMAND broadcast path so per-window focus is the fallback.';

  @override
  String get skapiScriptAutosaveTriggerNoteLxDebian =>
      'Tier 2: depends on the focused app honouring Ctrl+S as \"save\". Most editors do; chat apps may misinterpret. X11 only.';

  @override
  String get commonReadFailed => 'couldn\'t read';

  @override
  String get commonUnknown => 'unknown';

  @override
  String get commonComingSoon => 'coming soon';

  @override
  String get commonDismiss => 'Dismiss';

  @override
  String bootstrapBannerError(String error) {
    return 'Couldn\'t read from device: $error';
  }

  @override
  String get bootstrapBannerRetry => 'Retry';

  @override
  String get bfApiChainAuthNone => 'None';

  @override
  String get bfApiChainAuthBearer => 'Bearer token';

  @override
  String get bfApiChainAuthBasic => 'Basic auth';

  @override
  String get bfApiChainAuthHeader => 'Custom header';

  @override
  String bfApiChainMasterError(String error) {
    return 'Master: $error';
  }

  @override
  String get bfApiChainChainStarted => 'Chain started';

  @override
  String bfApiChainChainError(String error) {
    return 'Error: $error';
  }

  @override
  String get bfApiChainSaveDialogTitle => 'Save endpoint?';

  @override
  String bfApiChainSaveDialogBody(String name) {
    return '\"$name\" will be persisted on the device. This updates the user data area.';
  }

  @override
  String get bfApiChainSaveDialogConfirm => 'Save';

  @override
  String bfApiChainSavedToast(String name) {
    return '\"$name\" saved';
  }

  @override
  String bfApiChainSaveFailed(String error) {
    return 'Couldn\'t save: $error';
  }

  @override
  String get bfApiChainDeleteDialogTitle => 'Delete?';

  @override
  String bfApiChainDeleteDialogBody(String name) {
    return '\"$name\" endpoint will be removed from the device. This action cannot be undone.';
  }

  @override
  String get bfApiChainDeleteDialogConfirm => 'Delete';

  @override
  String bfApiChainDeletedToast(String name) {
    return '\"$name\" deleted';
  }

  @override
  String bfApiChainDeleteFailed(String error) {
    return 'Couldn\'t delete: $error';
  }

  @override
  String bfApiChainTestNoReply(String name) {
    return '\"$name\" no reply (15 s timeout)';
  }

  @override
  String bfApiChainTestSuccess(String name, String httpSuffix) {
    return '\"$name\" success$httpSuffix';
  }

  @override
  String bfApiChainTestFailure(String name, String error, String httpSuffix) {
    return '\"$name\" error: $error$httpSuffix';
  }

  @override
  String bfApiChainTestTriggerFailed(String error) {
    return 'Couldn\'t trigger: $error';
  }

  @override
  String get bfApiChainNewEndpointName => 'New endpoint';

  @override
  String get bfApiChainEmptyTitle => 'No endpoints registered yet';

  @override
  String get bfApiChainEmptyBody =>
      'Use the \"Add endpoint\" card below to define a new HTTP call (e.g. IFTTT webhook, your own server, Spotify pause).';

  @override
  String get bfApiChainSystemSectionTitle => 'Automatic (paired SKAPPs)';

  @override
  String get bfApiChainSystemSectionSubtitle =>
      'When you bind a script via SKAPI, a slot opens automatically for each computer. When the countdown ends, a signed webhook goes to the SKAPP on that computer.';

  @override
  String get bfApiChainUserSectionTitle => 'Manual (IoT devices)';

  @override
  String get bfApiChainUserSectionSubtitle =>
      'Add third-party URLs (Shelly, Home Assistant, IFTTT) by hand. When the countdown ends this list fires first, in order.';

  @override
  String get bfApiChainMasterToggleLabel => 'Trigger active';

  @override
  String get bfApiChainMasterOnSubtitle =>
      'Master on: chain fires on device triggers';

  @override
  String get bfApiChainMasterOffSubtitle =>
      'Master off: no endpoint will be called';

  @override
  String get bfApiChainFieldNameLabel => 'Name';

  @override
  String get bfApiChainTypeLabel => 'Type';

  @override
  String get bfApiChainEventOrApplet => 'Event / Applet';

  @override
  String get bfApiChainMethodLabel => 'Method';

  @override
  String get bfApiChainDelayLabel => 'Wait after (0-300 s)';

  @override
  String get bfApiChainDelayUnit => 's';

  @override
  String get bfApiChainAdvancedHide => 'Hide advanced options';

  @override
  String get bfApiChainAdvancedShow => 'Advanced options';

  @override
  String get bfApiChainAuthLabel => 'Authentication';

  @override
  String bfApiChainCurrentTokenHint(String masked) {
    return 'Current token: $masked (write a new value below to refresh)';
  }

  @override
  String get bfApiChainNewTokenLabel => 'New token (leave blank to keep)';

  @override
  String get bfApiChainContentTypeLabel => 'Content-Type';

  @override
  String get bfApiChainSaveCta => 'Save';

  @override
  String get bfApiChainDeleteCta => 'Delete';

  @override
  String get bfApiChainTestCta => 'Test';

  @override
  String get bfApiChainAddCardLabel => 'Add new endpoint';

  @override
  String bfApiChainSavedDelaySeconds(int count) {
    return '$count s wait';
  }

  @override
  String get bfApiChainNotSaved => 'not saved';

  @override
  String bfApiChainSystemRowSignedTooltip(String peer, int delay) {
    return 'peer $peer…  ·  delay ${delay}s  ·  signed (HMAC)';
  }

  @override
  String get bfApiChainTestEndpointTooltip => 'Test this endpoint';

  @override
  String get bfLogsBufferEmpty => 'Device log buffer is empty.';

  @override
  String get bfLogsUnsupported =>
      'Device does not support logs in this firmware.';

  @override
  String get deviceLogsNoClockBanner =>
      'Device clock not set; timestamps are shown as seconds since boot.';

  @override
  String get deviceLogsTruncatedHint =>
      '(output truncated, try a lower limit or a higher severity)';

  @override
  String get bfEventsTimerRunning => 'Countdown started';

  @override
  String get bfEventsTimerPaused => 'Countdown paused';

  @override
  String get bfEventsTimerIdle => 'Countdown reset';

  @override
  String get bfEventsTimerCooldown => 'Cooldown';

  @override
  String get bfEventsTimerExpired => 'Countdown finished';

  @override
  String bfEventsFaceChanged(String from, String to) {
    return 'Face changed: $from → $to';
  }

  @override
  String bfEventsApiTriggered(String type) {
    return '$type triggered';
  }

  @override
  String get bfEventsApiTriggeredFallback => 'API triggered';

  @override
  String bfEventsBatteryLevel(int percent) {
    return 'Battery level: %$percent';
  }

  @override
  String get bfEventsDeviceRestarted => 'Device restarted';

  @override
  String skapiManifestLoadingRetry(String platform, String scriptId) {
    return '$platform/$scriptId manifest loading, try again in a moment';
  }

  @override
  String get skapiListenerOffMobileTitle =>
      'This device cannot run Desktop scripts';

  @override
  String get skapiListenerOffDesktopTitle => 'SKAPP HTTP listener is off';

  @override
  String get skapiListenerOffMobileBody =>
      'When the countdown ends, scripts will run on Windows / macOS / Linux. SKAPP must be open and the listener active. This phone is only the configuration side; execution happens on the desktop.';

  @override
  String skapiListenerOffDesktopBody(String lastErrorSuffix) {
    return 'BF will fire the webhook, but no one will catch it because the listener is off. Open Settings → SKAPP HTTP Listener.$lastErrorSuffix';
  }

  @override
  String get skapiSyncBadgeWriting => 'Writing to BF…';

  @override
  String get skapiSyncBadgeWritten => 'Saved on BF';

  @override
  String get skapiSyncBadgeFailed => 'Couldn\'t write to BF';

  @override
  String skapiSyncBadgeFirmwareCodeTooltip(String code) {
    return 'Firmware code: $code';
  }

  @override
  String get syncErrUnknownCommand =>
      'Old firmware on the device. Flash the new firmware';

  @override
  String get syncErrNotAuthenticated =>
      'Device session not authorised (re-pair may be needed)';

  @override
  String get syncErrNotFound => 'No pairing record on the device';

  @override
  String get syncErrInternal => '8 SYSTEM slots may be full';

  @override
  String get syncErrUnknown => 'unknown error';

  @override
  String get syncErrTimeout => 'Device didn\'t reply (offline?)';

  @override
  String get syncErrNoBond => 'No pairing with this device';

  @override
  String get syncErrConnect => 'Couldn\'t connect to device';

  @override
  String get discoveryFilterShowAll => 'Show all devices';

  @override
  String get discoveryFilterOnlySmartKraft => 'SmartKraft only';

  @override
  String discoveryScanningWithCount(int count, String tail) {
    return 'Scanning… $count device(s) found$tail';
  }

  @override
  String discoveryFoundCountWithTail(int count, String tail) {
    return '$count device(s) found$tail';
  }

  @override
  String discoveryFilterOff(int visible, int sk, String tail) {
    return 'Filter off · $visible device(s) shown ($sk SmartKraft$tail)';
  }

  @override
  String discoveryMdnsTail(int count) {
    return ' + $count on network';
  }

  @override
  String get discoveryWifiOnlySnack =>
      'This device is currently only visible over WiFi. WiFi pairing isn\'t active yet, briefly press the device\'s button to open the pairing window. Once it\'s also seen over BLE, this row becomes pairable.';

  @override
  String get discoveryBadgePairable => 'Pairable';

  @override
  String get discoveryBadgeBonded => 'Paired with another SKAPP';

  @override
  String get pairingTitleConnecting => 'Connecting';

  @override
  String get pairingTitleReconnecting => 'Reconnecting';

  @override
  String get pairingMutualAuthHmacSubtitle => 'HMAC challenge-response';

  @override
  String pairingBleConnectFailed(String error) {
    return 'BLE connection failed.\n\nFix: briefly press the device\'s button to open the 60-second pairing window, then tap \"Retry\".\n\nDetails: $error';
  }

  @override
  String get pairingGattServiceMissing => 'SKAPP service not found';

  @override
  String get pairingGattCmdRxMissing => 'cmd_rx characteristic missing';

  @override
  String get pairingGattEventTxMissing => 'event_tx characteristic missing';

  @override
  String pairingGattDiscoveryFailed(String error) {
    return 'GATT discovery failed: $error';
  }

  @override
  String pairingKeySendFailed(String error) {
    return 'Couldn\'t send key: $error';
  }

  @override
  String pairingDeviceNoReply(int seconds) {
    return 'Device didn\'t reply ($seconds s).';
  }

  @override
  String pairingDeviceRejected(String error) {
    return 'Device rejected: $error';
  }

  @override
  String get pairingInvalidReplyMissingPub =>
      'Invalid device reply (our_pub missing).';

  @override
  String pairingHexDecodeFailed(String error) {
    return 'our_pub hex decode failed: $error';
  }

  @override
  String get pairingRetryButton => 'Retry';

  @override
  String pairingReconnectTransient(String error) {
    return 'Couldn\'t reach the device; the existing pairing is kept.\n\nMake sure the device is powered on and within range, then tap \"Retry\".\n\nDetails: $error';
  }

  @override
  String get pairingRecoveryTitle => 'Renew pairing';

  @override
  String get pairingRecoveryBody =>
      'The device doesn\'t recognize the current pairing. To start a fresh one, press the device\'s pairing button to open the 60-second window, then tap Continue.';

  @override
  String get pairingRecoveryContinue => 'Continue';

  @override
  String get pairingRecoveryCancelled =>
      'Pairing renewal cancelled. The old pairing is still on file; tap \"Retry\" to attempt another connection later.';

  @override
  String get pairingRenewBondButton => 'Renew pairing';

  @override
  String wifiPasswordConnectionRejected(String error) {
    return 'Connection rejected: $error';
  }

  @override
  String get wifiPasswordTimeout => 'Device didn\'t reply (timeout).';

  @override
  String wifiScanRejected(String error) {
    return 'Device rejected wifi.scan: $error\n\nThe device\'s WiFi module may not have started; try a reboot.';
  }

  @override
  String wifiScanUnexpectedReply(String data) {
    return 'Unexpected wifi.scan reply: $data';
  }

  @override
  String wifiScanTimeout(String error) {
    return 'Device didn\'t reply (timeout: $error).\n\nGet closer to the device, briefly press its button (to trigger advertising) and try again.';
  }

  @override
  String wifiScanConnectionError(String error) {
    return 'Connection error: $error';
  }

  @override
  String get wifiScanHeaderHelp =>
      'Below are the WiFi networks **the device** can see (not the phone\'s networks). Pick the network the device should join; the password is requested in the next step.';

  @override
  String get wifiScanAuthOpen => 'Open';

  @override
  String get wifiScanAuthEncrypted => 'Encrypted';

  @override
  String get wifiSuccessSyncing => 'Syncing time…';

  @override
  String get wifiSuccessFetchingInfo => 'Fetching device info…';

  @override
  String get wifiSuccessPreparingUi => 'Preparing device UI…';

  @override
  String wifiSuccessManifestRejected(String error) {
    return 'device.manifest rejected ($error). It may be old firmware; sk_baseline.c must be loaded for BF.';
  }

  @override
  String get wifiSuccessTapToContinue => 'Tap to continue…';

  @override
  String get deviceHomeUnsupportedTitle => 'Unsupported device';

  @override
  String deviceHomeUnsupportedBody(String name) {
    return '$name has no device screen in this SKAPP version. When a new device family is added this screen will appear automatically.';
  }

  @override
  String get lsPairingUnpairTitle => 'Unpair this APP';

  @override
  String get lsPairingUnpairBody =>
      'The device will forget this APP\'s bond. You\'ll need to pair again (3 s button + select in Devices).';

  @override
  String get skYakindaBadgeDefault => 'coming soon';

  @override
  String get skapiScriptPulseBrightnessTitle => 'Pulse Brightness';

  @override
  String get skapiScriptPulseBrightnessSummaryWhat =>
      'Modulates internal display brightness on a smooth cosine wave between 100% and a lower bound, repeated a set number of times. The user\'s original brightness is restored at the end.';

  @override
  String get skapiScriptPulseBrightnessSummaryHow =>
      'Reads the current brightness through WMI, then writes a brightness sample 20 times per second following a cosine curve. Always restores the captured original on exit.';

  @override
  String get skapiScriptPulseBrightnessNote =>
      'Internal panels only (laptops, tablets). External DDC/CI monitors do not respond to this WMI path.';

  @override
  String get skapiScriptPulseBrightnessParamPeriodLabel => 'period';

  @override
  String get skapiScriptPulseBrightnessParamPeriodHint =>
      'Seconds for one full bright -> dim -> bright cycle. Around 2 feels like a clear pulse without being jarring.';

  @override
  String get skapiScriptPulseBrightnessParamLowPercentLabel => 'low %';

  @override
  String get skapiScriptPulseBrightnessParamLowPercentHint =>
      'Dim end of the pulse, as a percentage of full brightness. Lower numbers make the pulse more dramatic.';

  @override
  String get skapiScriptPulseBrightnessParamCyclesLabel => 'cycles';

  @override
  String get skapiScriptPulseBrightnessParamCyclesHint =>
      'How many full pulse cycles to run before exiting.';

  @override
  String get skapiScriptBlurTimedTitle => 'Blurred Break';

  @override
  String get skapiScriptBlurTimedSummaryWhat =>
      'Covers the screen with a fullscreen, always-on-top semi-transparent veil for the configured number of seconds. A countdown is shown in the middle.';

  @override
  String get skapiScriptBlurTimedSummaryHow =>
      'Opens a borderless WPF window with AllowsTransparency and a solid colour brush at the chosen opacity. A dispatcher timer drives the countdown; the window closes itself when the timer hits zero.';

  @override
  String get skapiScriptBlurTimedNote =>
      'Pragmatic interim: real-time Gaussian blur over the desktop needs a C++/Win2D helper that ships later. The solid veil creates similar \'I can\'t focus on the screen, take a break\' friction in the meantime.';

  @override
  String get skapiScriptBlurTimedParamDurationLabel => 'duration';

  @override
  String get skapiScriptBlurTimedParamDurationHint =>
      'Seconds the veil stays up before closing automatically.';

  @override
  String get skapiScriptBlurTimedParamOpacityLabel => 'opacity';

  @override
  String get skapiScriptBlurTimedParamOpacityHint =>
      'Veil opacity 0.0 (invisible) to 1.0 (solid). Around 0.55 still lets the desktop bleed through enough to feel veiled, not blacked out.';

  @override
  String get skapiScriptBlurTimedParamColorLabel => 'color';

  @override
  String get skapiScriptBlurTimedParamColorHint =>
      'Veil colour in #RRGGBB hex. Palette black #0A0A0A is the default; lighter cream tones feel calmer.';

  @override
  String get skapiScriptBlockingFocusTitle => 'Blocking Focus';

  @override
  String get skapiScriptBlockingFocusSummaryWhat =>
      'Composite focus enforcer: saves all open Office and VS Code documents, then opens a fullscreen always-on-top countdown window with no close button while the mouse cursor circles continuously. When the timer hits zero everything is undone automatically.';

  @override
  String get skapiScriptBlockingFocusSummaryHow =>
      'Three phases run back to back: (1) save phase calls Office COM and VS Code CLI; (2) a parallel runspace drives the cursor in a circle until a synchronized stop flag flips; (3) an STA WPF window shows the title and countdown. A finally block restores cursor origin and tears down both runspaces.';

  @override
  String get skapiScriptBlockingFocusNote =>
      'Soft mode: Esc and Alt+F4 are NOT blocked. The user can always escape via Task Manager. Strict mode with global keyboard hooks will be a separate script.';

  @override
  String get skapiScriptBlockingFocusParamDurationLabel => 'duration';

  @override
  String get skapiScriptBlockingFocusParamDurationHint =>
      'Seconds the lockdown lasts. The countdown ticks down to 00:00 then everything cleans up.';

  @override
  String get skapiScriptBlockingFocusParamTitleLabel => 'title';

  @override
  String get skapiScriptBlockingFocusParamTitleHint =>
      'Text shown in the middle of the fullscreen window. Keep it short - \'Blocking Focus\' is the default.';

  @override
  String get skapiScriptBlockingFocusParamShakeRadiusLabel => 'shake radius';

  @override
  String get skapiScriptBlockingFocusParamShakeRadiusHint =>
      'Pixels the cursor travels from its origin while looping. Bigger circles feel more demanding of attention.';

  @override
  String get skapiScriptBlockingFocusParamEnableSaveLabel => 'save on start';

  @override
  String get skapiScriptBlockingFocusParamEnableSaveHint =>
      'Run the Office + VS Code save phase before the lockdown. Turn off when there is no document state to protect.';

  @override
  String get trayFirstHideToast =>
      'SKAPP keeps running in the background. Find it in the system tray; right-click for Quit.';

  @override
  String devicesOfflineTapHint(String name) {
    return '$name is offline.';
  }

  @override
  String skapiNewActionDeviceOffline(String name) {
    return '$name is offline. Bring it online to create a new action.';
  }

  @override
  String get bfApiChainRefreshDirtyTitle => 'Unsaved changes';

  @override
  String get bfApiChainRefreshDirtyBody =>
      'Refresh will pull the latest endpoint list from the device and discard the draft you haven\'t saved yet.';

  @override
  String get bfApiChainRefreshDirtyConfirm => 'Refresh anyway';

  @override
  String get skapiApiEditorTitle => 'On-device API';

  @override
  String get lsCommonReadFailed => 'Read failed';

  @override
  String lsCommonFailedWith(String err) {
    return 'Failed: $err';
  }

  @override
  String get lsVacationStatusOff => 'Off';

  @override
  String lsVacationStatusUntil(String date) {
    return 'Until $date';
  }

  @override
  String get lsVacationDaysValidationError => 'Days must be between 1 and 60';

  @override
  String lsVacationStartedSnack(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Vacation started · $days days',
      one: 'Vacation started · 1 day',
    );
    return '$_temp0';
  }

  @override
  String get lsVacationCancelledSnack => 'Vacation cancelled';

  @override
  String lsVacationActiveUntilFmt(String date) {
    return 'Active until $date';
  }

  @override
  String get lsVacationResumeHint =>
      'Countdown will resume when vacation ends.';

  @override
  String get lsVacationCancellingButton => 'Cancelling…';

  @override
  String get lsVacationCancelButton => 'Cancel vacation';

  @override
  String get lsVacationDaysLabel => 'Days';

  @override
  String get lsVacationDaysHint =>
      'Pauses the countdown for this many days (1 to 60).';

  @override
  String get lsVacationStartingButton => 'Starting…';

  @override
  String get lsVacationStartButton => 'Start vacation';

  @override
  String get lsCommonSavingButton => 'Saving…';

  @override
  String get lsCommonSaveButton => 'Save';

  @override
  String lsCommonSaveFailedWith(String err) {
    return 'Save failed: $err';
  }

  @override
  String get lsDurationValueValidationError => 'Value must be between 1 and 60';

  @override
  String get lsDurationAlarmsValidationError =>
      'Alarm count must be between 0 and 10';

  @override
  String get lsDurationConfiguredSnack => 'Timer configured';

  @override
  String lsDurationUnitMinute(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value minutes',
      one: '1 minute',
    );
    return '$_temp0';
  }

  @override
  String lsDurationUnitHour(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value hours',
      one: '1 hour',
    );
    return '$_temp0';
  }

  @override
  String lsDurationUnitDay(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String lsDurationAlarmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alarms',
      one: '1 alarm',
    );
    return '$_temp0';
  }

  @override
  String get lsDurationUnitLabel => 'Unit';

  @override
  String get lsDurationUnitMinutesPlural => 'minutes';

  @override
  String get lsDurationUnitHoursPlural => 'hours';

  @override
  String get lsDurationUnitDaysPlural => 'days';

  @override
  String get lsDurationValueLabel => 'Value';

  @override
  String get lsDurationValueHint => '1 to 60';

  @override
  String get lsDurationAlarmCountLabel => 'Alarm count';

  @override
  String get lsDurationAlarmCountHint =>
      'Alarms fire backwards from the end, one unit apart.';

  @override
  String get lsSmtpStatusNotConfigured => 'Not configured';

  @override
  String get lsSmtpHostRequired => 'Host is required';

  @override
  String get lsSmtpPortValidationError => 'Port must be between 1 and 65535';

  @override
  String get lsSmtpSenderRequired => 'Sender address is required';

  @override
  String get lsSmtpFieldHost => 'Host';

  @override
  String get lsSmtpFieldPort => 'Port';

  @override
  String get lsSmtpFieldSender => 'Sender';

  @override
  String get lsSmtpFieldKey => 'Key';

  @override
  String lsSmtpSaveHaltedOn(String err) {
    return 'Save halted on $err';
  }

  @override
  String get lsSmtpSavedSnack => 'SMTP saved';

  @override
  String get lsSmtpTestSentSnack => 'Test mail sent';

  @override
  String lsSmtpTestFailedWith(String err) {
    return 'Test failed: $err';
  }

  @override
  String get lsSmtpUrlCopiedSnack => 'URL copied to clipboard';

  @override
  String get lsSmtpApiKeyPlaceholder => 'Gmail App Password / API key';

  @override
  String get lsSmtpServerLabel => 'Server';

  @override
  String get lsSmtpApiKeyLabel => 'API key';

  @override
  String get lsSmtpApiKeyHint => 'Leave blank to keep the current key.';

  @override
  String get lsSmtpAppPasswordHelpLink => 'How to get a Gmail App Password';

  @override
  String get lsSmtpSendingButton => 'Sending…';

  @override
  String get lsSmtpSendTestButton => 'Send test';

  @override
  String get lsReminderMailRecipientValidation =>
      'Recipient must look like an email address';

  @override
  String get lsReminderMailSavedSnack => 'Reminder saved locally';

  @override
  String get lsReminderMailRecipientFirstSnack => 'Set a recipient first';

  @override
  String get lsReminderMailTestOkSnack =>
      'SMTP test OK, credentials reach the server';

  @override
  String lsReminderMailTestFailedWith(String err) {
    return 'SMTP test failed: $err';
  }

  @override
  String get lsReminderMailRecipientLabel => 'Recipient email';

  @override
  String get lsReminderMailSubjectLabel => 'Subject';

  @override
  String get lsReminderMailBodyLabel => 'Body';

  @override
  String get lsReminderMailBodyHint => 'Your countdown will trigger soon...';

  @override
  String get lsReminderMailActiveLabel => 'Active';

  @override
  String get lsReminderMailFootnote =>
      'Saved locally on this device. Send-test only verifies the SMTP server is reachable; auto-fire on timer.alarm is pending firmware support.';

  @override
  String get lsResetApiStatusDisabled => 'Disabled';

  @override
  String lsResetApiStatusEnabledPort(int port) {
    return 'Enabled · port $port';
  }

  @override
  String get lsResetApiRegenDialogTitle => 'Regenerate API key?';

  @override
  String get lsResetApiRegenDialogBody =>
      'This will invalidate the current key. Any caller using the previous key will be rejected until you update it. Continue?';

  @override
  String get lsResetApiRegenConfirm => 'Regenerate';

  @override
  String get lsResetApiKeyRegeneratedSnack => 'Key regenerated';

  @override
  String get lsResetApiEnabledLabel => 'Enabled';

  @override
  String get lsResetApiEnabledHint =>
      'When on, an HTTP GET to the endpoint URL with the matching key resets the countdown.';

  @override
  String get lsResetApiEndpointUrlLabel => 'Endpoint URL';

  @override
  String get lsResetApiUrlNotAvailable => '(not available)';

  @override
  String get lsResetApiCopyUrlTooltip => 'Copy URL';

  @override
  String get lsResetApiKeyLabel => 'API key';

  @override
  String get lsResetApiKeyNotSet => '(not set)';

  @override
  String get lsResetApiExampleLabel => 'Example';

  @override
  String get lsResetApiRegenerateButton => 'Regenerate key';

  @override
  String get lsAlarmApiUrlValidation =>
      'URL must start with http:// or https://';

  @override
  String get lsAlarmApiHeadersValidation => 'Headers field must be valid JSON';

  @override
  String get lsAlarmApiSaveDialogTitle => 'Save webhook endpoint?';

  @override
  String lsAlarmApiSaveDialogBody(String name, String url) {
    return 'Stores `$name` on the device pointing at:\n$url';
  }

  @override
  String get lsAlarmApiSavedSnack => 'Webhook saved';

  @override
  String get lsAlarmApiDisabledSnack => 'Webhook disabled';

  @override
  String get lsAlarmApiTestQueuedSnack =>
      'Test queued, watch the upstream service';

  @override
  String lsAlarmApiTestFailedWith(String err) {
    return 'Test failed: $err';
  }

  @override
  String get lsAlarmApiRemoveDialogTitle => 'Remove webhook?';

  @override
  String lsAlarmApiRemoveDialogBody(String name) {
    return 'Deletes `$name` from the device. Local config is kept.';
  }

  @override
  String get lsAlarmApiRemoveButton => 'Remove';

  @override
  String lsAlarmApiRemoveFailedWith(String err) {
    return 'Remove failed: $err';
  }

  @override
  String get lsAlarmApiConfiguredStatus => 'Configured';

  @override
  String lsAlarmApiConfiguredHost(String host) {
    return 'Configured · $host';
  }

  @override
  String get lsAlarmApiUrlLabel => 'URL';

  @override
  String get lsAlarmApiMethodLabel => 'HTTP method';

  @override
  String get lsAlarmApiHeadersLabel => 'Headers (JSON, optional)';

  @override
  String get lsAlarmApiHeadersHint =>
      'JSON object with optional headers. Saved locally; firmware applies on fire.';

  @override
  String get lsAlarmApiBodyTemplateLabel => 'Body template (JSON)';

  @override
  String get lsAlarmApiBodyTemplateHint =>
      'Placeholders device and remaining_sec substitute at fire time.';

  @override
  String get lsAlarmApiBearerLabel => 'Bearer token (optional)';

  @override
  String get lsAlarmApiFootnote =>
      'Firmware subscriber for the timer.alarm event is pending. This config stores the endpoint; it will not auto-fire until the next firmware update.';

  @override
  String lsRelaySummarySeconds(int seconds) {
    return '${seconds}s';
  }

  @override
  String lsRelaySummaryMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get lsRelayModePulse => 'pulse';

  @override
  String get lsRelayModeSteady => 'steady';

  @override
  String lsRelaySummaryFmt(int gpio, String duration, String mode) {
    return 'GPIO $gpio · $duration $mode';
  }

  @override
  String get lsRelayGpioValidation => 'GPIO must be between 0 and 30';

  @override
  String get lsRelayDurationValidation =>
      'Duration must be between 1 and 3600 seconds';

  @override
  String get lsRelayPulseValidation =>
      'Pulse half-cycle must be between 1 and 60';

  @override
  String lsRelayCmdFailedWith(String cmd, String err) {
    return '$cmd failed: $err';
  }

  @override
  String get lsRelayConfiguredSnack => 'Relay configured';

  @override
  String get lsRelayFireAbortedSnack => 'Fire aborted';

  @override
  String get lsRelayForcedIdleSnack => 'Relay forced idle';

  @override
  String get lsRelayGpioLabel => 'GPIO pin';

  @override
  String get lsRelayGpioHint => 'ESP32-C6 valid pin; default 19 = D8';

  @override
  String get lsRelayInvertLabel => 'Invert polarity';

  @override
  String get lsRelayStartDelayLabel => 'Start delay';

  @override
  String lsRelayStartDelayHint(int sec) {
    return '${sec}s before relay activates';
  }

  @override
  String get lsRelayActiveDurationLabel => 'Active duration';

  @override
  String get lsRelayUnitSeconds => 'Seconds';

  @override
  String get lsRelayUnitMinutes => 'Minutes';

  @override
  String get lsRelayPulseModeLabel => 'Pulse mode';

  @override
  String get lsRelayPulseModeHint =>
      'On = 1 s half-cycle. Custom lets you set the half-cycle.';

  @override
  String get lsRelayHalfCycleLabel => 'Half-cycle seconds';

  @override
  String get lsRelayFiringButton => 'Firing…';

  @override
  String get lsRelayTestRelayButton => 'Test relay';

  @override
  String get lsRelayAbortButton => 'Abort';

  @override
  String get lsRelayForceOffButton => 'Force off';

  @override
  String get lsRelayPulseOff => 'Off';

  @override
  String get lsRelayPulseOn => 'On';

  @override
  String get lsRelayPulseCustom => 'Custom';

  @override
  String get lsRelayPhaseActiveBadge => 'active';

  @override
  String lsRelayPhaseLine(String phase, String elapsed) {
    return 'Phase: $phase$elapsed';
  }

  @override
  String get lsTelegramTokenRequired => 'Bot token is required';

  @override
  String get lsTelegramChatRequired => 'Chat id is required';

  @override
  String get lsTelegramSaveDialogTitle => 'Save Telegram endpoint?';

  @override
  String lsTelegramSaveDialogBody(String name) {
    return 'Stores `$name` on the device. Token is sent in the URL.';
  }

  @override
  String get lsTelegramSavedSnack => 'Telegram endpoint saved';

  @override
  String get lsTelegramDisabledSnack => 'Telegram endpoint disabled';

  @override
  String get lsTelegramTestQueuedSnack =>
      'Test queued, watch the Telegram chat';

  @override
  String get lsTelegramRemoveDialogTitle => 'Remove Telegram endpoint?';

  @override
  String get lsTelegramBotConfiguredStatus => 'Bot configured';

  @override
  String get lsTelegramBotTokenLabel => 'Bot token';

  @override
  String get lsTelegramBotTokenHint =>
      'Get one from @BotFather (looks like 1234567:AAH...).';

  @override
  String get lsTelegramChatIdLabel => 'Chat ID';

  @override
  String get lsTelegramChatIdHint =>
      'A numeric id (-100...) or @channel username.';

  @override
  String get lsTelegramMessageTemplateLabel => 'Message template';

  @override
  String get lsTelegramMessageHint => 'LebensSpur: Alarm triggered.';

  @override
  String get lsLsApiUrlRequired => 'URL required';

  @override
  String get lsLsApiUpdatedSnack => 'Webhook updated';

  @override
  String get lsLsApiSavedSnack => 'Webhook saved';

  @override
  String get lsLsApiSaveFirstSnack => 'Save the webhook first';

  @override
  String get lsLsApiTestQueuedSnack => 'Test queued, check the receiver';

  @override
  String get lsLsApiRemoveDialogBody =>
      'The LS webhook will be deleted from the device. The countdown will no longer fire it.';

  @override
  String get lsLsApiRemovedSnack => 'Webhook removed';

  @override
  String get lsLsApiConfirmCriticalTitle => 'Confirm critical change';

  @override
  String lsLsApiConfirmCriticalBody(String cmd, int ttlSec) {
    return 'The device asks to confirm:\n  $cmd\n\nThis token expires in ${ttlSec}s.';
  }

  @override
  String get lsLsApiConfirmButton => 'Confirm';

  @override
  String lsLsApiActiveSlot(String name) {
    return 'Active · slot \"$name\"';
  }

  @override
  String lsLsApiActiveWithToken(String name, String token) {
    return 'Active · slot \"$name\" · token $token';
  }

  @override
  String get lsLsApiUrlHint =>
      'Fired when timer.triggered fires. https:// recommended.';

  @override
  String get lsLsApiHeadersLabel => 'Headers (JSON)';

  @override
  String get lsLsApiHeadersHint =>
      'Advanced: not yet wired through CLI. Reserved for a future release.';

  @override
  String get lsLsApiBodyTemplateHint =>
      'Sent as the test payload. The device placeholder is replaced server-side.';

  @override
  String lsLsApiBearerHintExisting(String token) {
    return 'Currently set: $token. Leave blank to keep, or paste a new value to overwrite.';
  }

  @override
  String get lsLsApiBearerHintEmpty =>
      'Sent as `Authorization: Bearer <token>`.';

  @override
  String get lsLsApiUpdateButton => 'Update';

  @override
  String lsMailGroupsStatusFmt(int count, int max, int recipients) {
    return '$count of $max · $recipients recipients total';
  }

  @override
  String lsMailGroupsReadFailedWith(String err) {
    return 'Read failed: $err';
  }

  @override
  String get lsMailGroupsNameValidation =>
      'Name must be between 1 and 47 characters';

  @override
  String get lsMailGroupsNameSaved => 'Name saved';

  @override
  String get lsMailGroupsSubjectValidation =>
      'Subject must be at most 127 characters';

  @override
  String get lsMailGroupsSubjectSaved => 'Subject saved';

  @override
  String get lsMailGroupsBodyValidation =>
      'Body must be at most 511 characters';

  @override
  String get lsMailGroupsBodySaved => 'Body saved';

  @override
  String get lsMailGroupsEmailValidation => 'Enter a valid email';

  @override
  String lsMailGroupsMaxReached(int max) {
    return 'Maximum is $max groups';
  }

  @override
  String get lsMailGroupsNameEmpty => 'Name cannot be empty';

  @override
  String get lsMailGroupsCreatedSnack => 'Group created';

  @override
  String lsMailGroupsCreateFailedWith(String err) {
    return 'Create failed: $err';
  }

  @override
  String get lsMailGroupsDeleteDialogTitle => 'Delete group?';

  @override
  String get lsMailGroupsDeleteDialogBody =>
      'This removes the group and all its recipients on the device.';

  @override
  String get lsMailGroupsDeleteConfirm => 'Delete';

  @override
  String get lsMailGroupsDeletedSnack => 'Group deleted';

  @override
  String lsMailGroupsDefaultName(int n) {
    return 'Group $n';
  }

  @override
  String get lsMailGroupsNewGroupTitle => 'New mail group';

  @override
  String get lsMailGroupsGroupNameLabel => 'Group name';

  @override
  String get lsMailGroupsCreateConfirm => 'Create';

  @override
  String get lsMailGroupsEmptyHint =>
      'No groups yet. Create one to send mail when the timer triggers.';

  @override
  String get lsMailGroupsWorkingButton => 'Working…';

  @override
  String get lsMailGroupsCreateNewButton => '+ Create new group';

  @override
  String lsMailGroupsHeaderCount(int count, int max) {
    return '$count of $max groups configured';
  }

  @override
  String lsMailGroupsHeaderTotalRecipients(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recipients total',
      one: '1 recipient total',
    );
    return '· $_temp0';
  }

  @override
  String get lsMailGroupsUnnamed => '(unnamed)';

  @override
  String lsMailGroupsRowSummary(int count, String state) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recipients',
      one: '1 recipient',
    );
    return '$_temp0 · $state';
  }

  @override
  String get lsMailGroupsEnabled => 'enabled';

  @override
  String get lsMailGroupsDisabled => 'disabled';

  @override
  String get lsMailGroupsNameLabel => 'Name';

  @override
  String get lsMailGroupsSubjectLabel => 'Subject';

  @override
  String get lsMailGroupsSaveBodyButton => 'Save body';

  @override
  String get lsMailGroupsDeleteGroupButton => 'Delete group';

  @override
  String lsMailGroupsRecipientsHeader(int count) {
    return 'Recipients ($count)';
  }

  @override
  String get lsMailGroupsNoRecipients => 'No recipients yet.';

  @override
  String get lsMailGroupsAddRecipientButton => 'Add';

  @override
  String get lsHomeStatusLoading => 'Loading…';

  @override
  String get lsHomeLogsTooltip => 'Logs';

  @override
  String get lsHomeClusterConfiguration => 'CONFIGURATION';

  @override
  String get lsHomeClusterTriggerActions => 'TRIGGER ACTIONS';

  @override
  String get lsHomeClusterEarlyWarning => 'EARLY WARNING';

  @override
  String get lsHomeSectionDurationTitle => 'Duration & Alarms';

  @override
  String get lsHomeSectionVacationTitle => 'Vacation Mode';

  @override
  String get lsHomeSectionSmtpTitle => 'Mail Setup (SMTP)';

  @override
  String get lsHomeSectionResetApiTitle => 'Reset API endpoint';

  @override
  String get lsHomeSectionMailGroupsTitle => 'Mail Groups';

  @override
  String get lsHomeSectionRelayTitle => 'Relay';

  @override
  String get lsHomeSectionLsApiTitle => 'LS API webhook';

  @override
  String get lsHomeSectionTelegramTitle => 'Telegram';

  @override
  String get lsHomeSectionReminderMailTitle => 'Reminder Mail';

  @override
  String get lsHomeSectionAlarmApiTitle => 'Alarm API webhook';

  @override
  String get lsHomeStateInactive => 'INACTIVE';

  @override
  String get lsHomeStateRemaining => 'REMAINING';

  @override
  String get lsHomeStateVacation => 'VACATION';

  @override
  String get lsHomeStateTriggered => 'TRIGGERED';

  @override
  String get lsHomeChipBle => 'BLE';

  @override
  String get lsHomeChipMail => 'Mail';

  @override
  String get lsHomeEarlyWarningPendingNote =>
      'Early warning actions fire on timer.alarm. Firmware subscriber is pending; these configs persist but will not auto-fire yet.';

  @override
  String get settingsDiagnosticsTitle => 'Diagnostics';

  @override
  String get settingsDiagnosticsSubtitle => 'Logs to help debug issues';

  @override
  String get diagnosticsCopyLogs => 'Copy logs';

  @override
  String get diagnosticsOpenFolder => 'Open folder';

  @override
  String get diagnosticsOpenFolderFailed => 'Could not open the log folder.';

  @override
  String get diagnosticsShareLogs => 'Share logs';

  @override
  String get diagnosticsClearLogs => 'Clear logs';

  @override
  String get diagnosticsCopied => 'Logs copied to clipboard';

  @override
  String get diagnosticsCleared => 'Logs cleared';

  @override
  String get aboutPrivacyLabel => 'Privacy policy';

  @override
  String get updateChecking => 'Checking for updates…';

  @override
  String get updateUpToDate => 'You\'re on the latest version';

  @override
  String get updateCheckFailed => 'Could not check for updates';

  @override
  String get updateAvailableTitle => 'Update available';

  @override
  String updateAvailableBody(String version, String current) {
    return 'A new version ($version) is available. You\'re on $current.';
  }

  @override
  String get updateDownloadAction => 'Download';

  @override
  String get updateLater => 'Later';
}
