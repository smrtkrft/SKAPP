import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'SKAPP'**
  String get appTitle;

  /// No description provided for @brandTagline.
  ///
  /// In en, this message translates to:
  /// **'SmartKraft'**
  String get brandTagline;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabDevices.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get tabDevices;

  /// No description provided for @tabSkapi.
  ///
  /// In en, this message translates to:
  /// **'SKAPI'**
  String get tabSkapi;

  /// No description provided for @tabSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tabSettings;

  /// No description provided for @tabSmartKraft.
  ///
  /// In en, this message translates to:
  /// **'SmartKraft'**
  String get tabSmartKraft;

  /// No description provided for @comingSoonBadge.
  ///
  /// In en, this message translates to:
  /// **'coming soon'**
  String get comingSoonBadge;

  /// No description provided for @featureComingSoonSnack.
  ///
  /// In en, this message translates to:
  /// **'This feature is coming soon'**
  String get featureComingSoonSnack;

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to SmartKraft'**
  String get homeWelcome;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your SmartKraft devices'**
  String get homeSubtitle;

  /// No description provided for @homeAddDevice.
  ///
  /// In en, this message translates to:
  /// **'Add new device'**
  String get homeAddDevice;

  /// No description provided for @homeNoDevicesTitle.
  ///
  /// In en, this message translates to:
  /// **'No devices yet'**
  String get homeNoDevicesTitle;

  /// No description provided for @homeNoDevicesHint.
  ///
  /// In en, this message translates to:
  /// **'Add your first SmartKraft device to get started.'**
  String get homeNoDevicesHint;

  /// No description provided for @homeSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get homeSummaryTitle;

  /// No description provided for @homeDevicesOnline.
  ///
  /// In en, this message translates to:
  /// **'{count} connected'**
  String homeDevicesOnline(int count);

  /// No description provided for @homeDevicesOffline.
  ///
  /// In en, this message translates to:
  /// **'{count} offline'**
  String homeDevicesOffline(int count);

  /// No description provided for @homeUpdatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Updates available'**
  String get homeUpdatesTitle;

  /// No description provided for @homeUpdatesBody.
  ///
  /// In en, this message translates to:
  /// **'{count} device has a newer firmware.'**
  String homeUpdatesBody(int count);

  /// No description provided for @homeWarningsTitle.
  ///
  /// In en, this message translates to:
  /// **'Warnings'**
  String get homeWarningsTitle;

  /// No description provided for @homeWarningsBody.
  ///
  /// In en, this message translates to:
  /// **'{count} device reported an issue.'**
  String homeWarningsBody(int count);

  /// No description provided for @homeAllGood.
  ///
  /// In en, this message translates to:
  /// **'Everything is running smoothly.'**
  String get homeAllGood;

  /// No description provided for @devicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get devicesTitle;

  /// No description provided for @devicesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No devices added yet.\nTap the + button to add one.'**
  String get devicesEmpty;

  /// No description provided for @devicesAdd.
  ///
  /// In en, this message translates to:
  /// **'Add device'**
  String get devicesAdd;

  /// No description provided for @devicesAllSection.
  ///
  /// In en, this message translates to:
  /// **'All devices'**
  String get devicesAllSection;

  /// No description provided for @devicesGroupsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your groups'**
  String get devicesGroupsTitle;

  /// No description provided for @devicesGroupsHint.
  ///
  /// In en, this message translates to:
  /// **'Create groups to organize your devices however you like.'**
  String get devicesGroupsHint;

  /// No description provided for @devicesGroupsCreate.
  ///
  /// In en, this message translates to:
  /// **'New group'**
  String get devicesGroupsCreate;

  /// No description provided for @devicesGroupsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No groups yet.'**
  String get devicesGroupsEmpty;

  /// No description provided for @skapiTitle.
  ///
  /// In en, this message translates to:
  /// **'SKAPI'**
  String get skapiTitle;

  /// No description provided for @skapiLibraryHeading.
  ///
  /// In en, this message translates to:
  /// **'SKAPI Library'**
  String get skapiLibraryHeading;

  /// No description provided for @skapiLibrarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick the platform your devices will trigger.'**
  String get skapiLibrarySubtitle;

  /// No description provided for @skapiThisComputer.
  ///
  /// In en, this message translates to:
  /// **'This computer'**
  String get skapiThisComputer;

  /// No description provided for @skapiCategoryCount.
  ///
  /// In en, this message translates to:
  /// **'{count} categories'**
  String skapiCategoryCount(int count);

  /// No description provided for @skapiPlatformMac.
  ///
  /// In en, this message translates to:
  /// **'macOS'**
  String get skapiPlatformMac;

  /// No description provided for @skapiPlatformWin.
  ///
  /// In en, this message translates to:
  /// **'Windows'**
  String get skapiPlatformWin;

  /// No description provided for @skapiPlatformLinux.
  ///
  /// In en, this message translates to:
  /// **'Linux'**
  String get skapiPlatformLinux;

  /// No description provided for @skapiPlatformOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get skapiPlatformOther;

  /// No description provided for @skapiStarredHeading.
  ///
  /// In en, this message translates to:
  /// **'Starred APIs'**
  String get skapiStarredHeading;

  /// No description provided for @skapiStarredEmpty.
  ///
  /// In en, this message translates to:
  /// **'Star templates from the library, they\'ll show up here.'**
  String get skapiStarredEmpty;

  /// No description provided for @skapiContributeTitle.
  ///
  /// In en, this message translates to:
  /// **'Send your library to the SmartKraft community'**
  String get skapiContributeTitle;

  /// No description provided for @skapiContributeBody.
  ///
  /// In en, this message translates to:
  /// **'This card will be designed later.'**
  String get skapiContributeBody;

  /// No description provided for @skapiSearchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search actions…'**
  String get skapiSearchPlaceholder;

  /// No description provided for @skapiSearchDisabledHint.
  ///
  /// In en, this message translates to:
  /// **'Will activate once the SKAPI parser is wired.'**
  String get skapiSearchDisabledHint;

  /// No description provided for @skapiHelpButtonTooltip.
  ///
  /// In en, this message translates to:
  /// **'About SKAPI'**
  String get skapiHelpButtonTooltip;

  /// No description provided for @skapiHelpSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'About SKAPI'**
  String get skapiHelpSheetTitle;

  /// No description provided for @skapiHelpIntro.
  ///
  /// In en, this message translates to:
  /// **'SKAPI is a library of actions your SmartKraft devices can trigger on your computer.'**
  String get skapiHelpIntro;

  /// No description provided for @skapiHelpStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Browse a template'**
  String get skapiHelpStep1Title;

  /// No description provided for @skapiHelpStep1Body.
  ///
  /// In en, this message translates to:
  /// **'Pick a starting point from the SKAPI library.'**
  String get skapiHelpStep1Body;

  /// No description provided for @skapiHelpStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Configure'**
  String get skapiHelpStep2Title;

  /// No description provided for @skapiHelpStep2Body.
  ///
  /// In en, this message translates to:
  /// **'Set parameters and choose which device fires it.'**
  String get skapiHelpStep2Body;

  /// No description provided for @skapiHelpStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Push to device'**
  String get skapiHelpStep3Title;

  /// No description provided for @skapiHelpStep3Body.
  ///
  /// In en, this message translates to:
  /// **'The device stores the API trigger; SKAPP runs the script.'**
  String get skapiHelpStep3Body;

  /// No description provided for @skapiHelpGlossaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Glossary'**
  String get skapiHelpGlossaryTitle;

  /// No description provided for @skapiHelpGlossaryTemplate.
  ///
  /// In en, this message translates to:
  /// **'Template: a read-only library entry'**
  String get skapiHelpGlossaryTemplate;

  /// No description provided for @skapiHelpGlossaryAction.
  ///
  /// In en, this message translates to:
  /// **'Action: a configured pair of API trigger + script'**
  String get skapiHelpGlossaryAction;

  /// No description provided for @skapiHelpGlossaryApiTrigger.
  ///
  /// In en, this message translates to:
  /// **'API trigger: what the device calls'**
  String get skapiHelpGlossaryApiTrigger;

  /// No description provided for @skapiHelpGlossaryScript.
  ///
  /// In en, this message translates to:
  /// **'Script: what your computer runs'**
  String get skapiHelpGlossaryScript;

  /// No description provided for @skapiHelpPhase1Notice.
  ///
  /// In en, this message translates to:
  /// **'SKAPI is still being built. Most of this tab is a skeleton; sections marked \'not active yet\' will turn on as the parser, listener and form builder land.'**
  String get skapiHelpPhase1Notice;

  /// No description provided for @skapiMobileBannerBody.
  ///
  /// In en, this message translates to:
  /// **'This phone can\'t be a target. To run actions, SKAPP must be open on your computer.'**
  String get skapiMobileBannerBody;

  /// No description provided for @skapiActionsHeading.
  ///
  /// In en, this message translates to:
  /// **'My Actions'**
  String get skapiActionsHeading;

  /// No description provided for @skapiActionsNoDevicesTitle.
  ///
  /// In en, this message translates to:
  /// **'No devices yet'**
  String get skapiActionsNoDevicesTitle;

  /// No description provided for @skapiActionsNoDevicesBody.
  ///
  /// In en, this message translates to:
  /// **'Pair a SmartKraft device first; head over to the Devices tab.'**
  String get skapiActionsNoDevicesBody;

  /// No description provided for @skapiActionsCreationDisabled.
  ///
  /// In en, this message translates to:
  /// **'Action creation is not active yet.'**
  String get skapiActionsCreationDisabled;

  /// No description provided for @skapiActionsOfflineDetectionDisabled.
  ///
  /// In en, this message translates to:
  /// **'Online detection not active yet'**
  String get skapiActionsOfflineDetectionDisabled;

  /// No description provided for @skapiActionsMaxLimitNote.
  ///
  /// In en, this message translates to:
  /// **'Up to 5 actions per device.'**
  String get skapiActionsMaxLimitNote;

  /// No description provided for @skapiActionsAddCta.
  ///
  /// In en, this message translates to:
  /// **'Add action'**
  String get skapiActionsAddCta;

  /// No description provided for @skapiHeaderSub.
  ///
  /// In en, this message translates to:
  /// **'{platforms} platforms · {actions} actions'**
  String skapiHeaderSub(int platforms, int actions);

  /// No description provided for @skapiNewActionPill.
  ///
  /// In en, this message translates to:
  /// **'New action'**
  String get skapiNewActionPill;

  /// No description provided for @skapiActionsSubLine.
  ///
  /// In en, this message translates to:
  /// **'device × script bindings · {count} active'**
  String skapiActionsSubLine(int count);

  /// No description provided for @skapiActionsEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'No actions yet. Bind what happens when a device button is pressed.'**
  String get skapiActionsEmptyHint;

  /// No description provided for @skapiActionsCreateCta.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get skapiActionsCreateCta;

  /// No description provided for @skapiActionsGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} actions'**
  String skapiActionsGroupTitle(String name);

  /// No description provided for @skapiActionsGroupCount.
  ///
  /// In en, this message translates to:
  /// **'{count}'**
  String skapiActionsGroupCount(int count);

  /// No description provided for @skapiListenerEndpointTitle.
  ///
  /// In en, this message translates to:
  /// **'Webhook URL pushed to BF devices'**
  String get skapiListenerEndpointTitle;

  /// No description provided for @skapiListenerEndpointBody.
  ///
  /// In en, this message translates to:
  /// **'If a BF on the same Wi-Fi cannot reach this URL after countdown, your laptop\'s NIC choice may be wrong (e.g. WSL/VirtualBox/Docker network). Tap Refresh to re-push.'**
  String get skapiListenerEndpointBody;

  /// No description provided for @skapiListenerEndpointResolving.
  ///
  /// In en, this message translates to:
  /// **'Resolving local IP…'**
  String get skapiListenerEndpointResolving;

  /// No description provided for @skapiListenerEndpointUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No usable LAN interface found.'**
  String get skapiListenerEndpointUnavailable;

  /// No description provided for @skapiListenerEndpointRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get skapiListenerEndpointRefresh;

  /// No description provided for @skapiListenerEndpointRefreshing.
  ///
  /// In en, this message translates to:
  /// **'Pushing…'**
  String get skapiListenerEndpointRefreshing;

  /// No description provided for @skapiListenerEndpointPushedAt.
  ///
  /// In en, this message translates to:
  /// **'Last refreshed {when}'**
  String skapiListenerEndpointPushedAt(String when);

  /// No description provided for @skapiListenerSelfTest.
  ///
  /// In en, this message translates to:
  /// **'Self-test'**
  String get skapiListenerSelfTest;

  /// No description provided for @skapiListenerSelfTestRunning.
  ///
  /// In en, this message translates to:
  /// **'Testing…'**
  String get skapiListenerSelfTestRunning;

  /// No description provided for @skapiListenerSelfTestPassed.
  ///
  /// In en, this message translates to:
  /// **'Self-test OK: listener reachable from this host.'**
  String get skapiListenerSelfTestPassed;

  /// No description provided for @skapiListenerSelfTestFailed.
  ///
  /// In en, this message translates to:
  /// **'Self-test FAILED: listener not reachable. Check Windows Firewall.'**
  String get skapiListenerSelfTestFailed;

  /// No description provided for @skapiWebhookActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent webhooks'**
  String get skapiWebhookActivityTitle;

  /// No description provided for @skapiWebhookActivityNone.
  ///
  /// In en, this message translates to:
  /// **'No webhooks received yet. After the device timer expires, an entry should appear here within seconds.'**
  String get skapiWebhookActivityNone;

  /// No description provided for @skapiWebhookActivityAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get skapiWebhookActivityAccepted;

  /// No description provided for @skapiWebhookActivityRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected ({code})'**
  String skapiWebhookActivityRejected(int code);

  /// No description provided for @skapiWebhookActivityMalformed.
  ///
  /// In en, this message translates to:
  /// **'Malformed'**
  String get skapiWebhookActivityMalformed;

  /// No description provided for @skapiWebhookActivitySelfTest.
  ///
  /// In en, this message translates to:
  /// **'Self-test'**
  String get skapiWebhookActivitySelfTest;

  /// No description provided for @skapiWebhookActivityNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No binding matched'**
  String get skapiWebhookActivityNoMatch;

  /// No description provided for @skapiWebhookActivityScriptError.
  ///
  /// In en, this message translates to:
  /// **'Script error'**
  String get skapiWebhookActivityScriptError;

  /// No description provided for @skapiWebhookActivityMatched.
  ///
  /// In en, this message translates to:
  /// **'{count} script(s) ran'**
  String skapiWebhookActivityMatched(int count);

  /// No description provided for @skapiBfEndpointsButton.
  ///
  /// In en, this message translates to:
  /// **'Inspect BF endpoints'**
  String get skapiBfEndpointsButton;

  /// No description provided for @skapiBfEndpointsTitle.
  ///
  /// In en, this message translates to:
  /// **'Endpoints stored on BF devices'**
  String get skapiBfEndpointsTitle;

  /// No description provided for @skapiBfEndpointsHint.
  ///
  /// In en, this message translates to:
  /// **'Read-only snapshot of api.endpoint.list from each paired device. Compare each SYSTEM slot URL with the listener URL above. They must match exactly. USER slots may belong to manual webhooks and could capture your countdown if misconfigured.'**
  String get skapiBfEndpointsHint;

  /// No description provided for @skapiBfEndpointsLoading.
  ///
  /// In en, this message translates to:
  /// **'Querying BF devices…'**
  String get skapiBfEndpointsLoading;

  /// No description provided for @skapiBfEndpointsErrorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Query failed:'**
  String get skapiBfEndpointsErrorPrefix;

  /// No description provided for @skapiBfEndpointsKindSystem.
  ///
  /// In en, this message translates to:
  /// **'SYSTEM'**
  String get skapiBfEndpointsKindSystem;

  /// No description provided for @skapiBfEndpointsKindUser.
  ///
  /// In en, this message translates to:
  /// **'USER'**
  String get skapiBfEndpointsKindUser;

  /// No description provided for @skapiBfEndpointsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No endpoints stored on this device.'**
  String get skapiBfEndpointsEmpty;

  /// No description provided for @skapiBfEndpointsClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get skapiBfEndpointsClose;

  /// No description provided for @skapiBfEndpointsRefresh.
  ///
  /// In en, this message translates to:
  /// **'Re-query'**
  String get skapiBfEndpointsRefresh;

  /// No description provided for @skapiStarredCount.
  ///
  /// In en, this message translates to:
  /// **'{count} starred'**
  String skapiStarredCount(int count);

  /// No description provided for @skapiStarredSlimEmpty.
  ///
  /// In en, this message translates to:
  /// **'Star library entries to gather your most-used here.'**
  String get skapiStarredSlimEmpty;

  /// No description provided for @skapiCommunityShareTitle.
  ///
  /// In en, this message translates to:
  /// **'Share your library with the SmartKraft community'**
  String get skapiCommunityShareTitle;

  /// No description provided for @skapiCommunityShareBody.
  ///
  /// In en, this message translates to:
  /// **'Scripts you write become available to everyone in the SKAPI library.'**
  String get skapiCommunityShareBody;

  /// No description provided for @settingsNetworkIdentityTitle.
  ///
  /// In en, this message translates to:
  /// **'Network identity'**
  String get settingsNetworkIdentityTitle;

  /// No description provided for @settingsNetworkIdentityName.
  ///
  /// In en, this message translates to:
  /// **'Computer name'**
  String get settingsNetworkIdentityName;

  /// No description provided for @settingsNetworkIdentityNameHint.
  ///
  /// In en, this message translates to:
  /// **'Used as the mDNS instance name'**
  String get settingsNetworkIdentityNameHint;

  /// No description provided for @settingsNetworkIdentityNameEdit.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get settingsNetworkIdentityNameEdit;

  /// No description provided for @settingsNetworkIdentityNameDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename this computer'**
  String get settingsNetworkIdentityNameDialogTitle;

  /// No description provided for @settingsNetworkIdentityNameDialogHelp.
  ///
  /// In en, this message translates to:
  /// **'Lowercase letters, numbers and dashes. Up to 32 characters.'**
  String get settingsNetworkIdentityNameDialogHelp;

  /// No description provided for @settingsNetworkIdentityUuid.
  ///
  /// In en, this message translates to:
  /// **'Device ID'**
  String get settingsNetworkIdentityUuid;

  /// No description provided for @settingsNetworkIdentityPort.
  ///
  /// In en, this message translates to:
  /// **'Listener port'**
  String get settingsNetworkIdentityPort;

  /// No description provided for @settingsNetworkIdentityPortDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Listener port'**
  String get settingsNetworkIdentityPortDialogTitle;

  /// No description provided for @settingsNetworkIdentityToken.
  ///
  /// In en, this message translates to:
  /// **'Bearer token'**
  String get settingsNetworkIdentityToken;

  /// No description provided for @settingsNetworkIdentityRegenerateToken.
  ///
  /// In en, this message translates to:
  /// **'Regenerate token'**
  String get settingsNetworkIdentityRegenerateToken;

  /// No description provided for @settingsNetworkIdentityRegenerateConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Regenerate bearer token?'**
  String get settingsNetworkIdentityRegenerateConfirmTitle;

  /// No description provided for @settingsNetworkIdentityRegenerateConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Existing devices will need to be re-paired with the new token.'**
  String get settingsNetworkIdentityRegenerateConfirmBody;

  /// No description provided for @settingsNetworkIdentityServerNotRunning.
  ///
  /// In en, this message translates to:
  /// **'Server not running yet, will activate in Phase 2.'**
  String get settingsNetworkIdentityServerNotRunning;

  /// No description provided for @settingsNetworkIdentityCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get settingsNetworkIdentityCopy;

  /// No description provided for @settingsNetworkIdentityCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get settingsNetworkIdentityCopied;

  /// No description provided for @settingsNetworkIdentityStaticIpHint.
  ///
  /// In en, this message translates to:
  /// **'Tip: a DHCP reservation (static IP) on your router makes connections more reliable.'**
  String get settingsNetworkIdentityStaticIpHint;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsSectionAppearance;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSystemHint.
  ///
  /// In en, this message translates to:
  /// **'Follow the system language'**
  String get settingsLanguageSystemHint;

  /// No description provided for @settingsLanguagePickerAllSection.
  ///
  /// In en, this message translates to:
  /// **'All languages'**
  String get settingsLanguagePickerAllSection;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsSectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsSectionAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsDeveloper.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get settingsDeveloper;

  /// No description provided for @settingsDeveloperName.
  ///
  /// In en, this message translates to:
  /// **'SmartKraft'**
  String get settingsDeveloperName;

  /// No description provided for @settingsOpenAbout.
  ///
  /// In en, this message translates to:
  /// **'About SKAPP'**
  String get settingsOpenAbout;

  /// No description provided for @settingsSectionAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get settingsSectionAdvanced;

  /// No description provided for @settingsDeveloperMode.
  ///
  /// In en, this message translates to:
  /// **'Developer mode'**
  String get settingsDeveloperMode;

  /// No description provided for @settingsDeveloperModeInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'What does Developer mode unlock?'**
  String get settingsDeveloperModeInfoTitle;

  /// No description provided for @settingsDeveloperModeInfoIntro.
  ///
  /// In en, this message translates to:
  /// **'This mode reveals power-user surfaces hidden from the default UI. Three main use cases:'**
  String get settingsDeveloperModeInfoIntro;

  /// No description provided for @settingsDeveloperModeUseCaseCliTitle.
  ///
  /// In en, this message translates to:
  /// **'CLI console'**
  String get settingsDeveloperModeUseCaseCliTitle;

  /// No description provided for @settingsDeveloperModeUseCaseCliBody.
  ///
  /// In en, this message translates to:
  /// **'Configure your devices over a USB cable without establishing a BLE or WiFi connection first.'**
  String get settingsDeveloperModeUseCaseCliBody;

  /// No description provided for @settingsDeveloperModeUseCaseSkapiTitle.
  ///
  /// In en, this message translates to:
  /// **'SKAPI code editor'**
  String get settingsDeveloperModeUseCaseSkapiTitle;

  /// No description provided for @settingsDeveloperModeUseCaseSkapiBody.
  ///
  /// In en, this message translates to:
  /// **'Open and modify built-in scripts, or write your own from scratch.'**
  String get settingsDeveloperModeUseCaseSkapiBody;

  /// No description provided for @settingsDeveloperModeUseCaseMobileTitle.
  ///
  /// In en, this message translates to:
  /// **'Mobile remote triggering'**
  String get settingsDeveloperModeUseCaseMobileTitle;

  /// No description provided for @settingsDeveloperModeUseCaseMobileBody.
  ///
  /// In en, this message translates to:
  /// **'Run this desktop\'s SKAPI bindings from a paired mobile SKAPP.'**
  String get settingsDeveloperModeUseCaseMobileBody;

  /// No description provided for @settingsDeveloperModeInfoSurfacesHeader.
  ///
  /// In en, this message translates to:
  /// **'Extra Settings cards that appear when it\'s on:'**
  String get settingsDeveloperModeInfoSurfacesHeader;

  /// No description provided for @settingsDeveloperModeInfoItem1.
  ///
  /// In en, this message translates to:
  /// **'Network identity card: edit UUID, port, bearer token; copy / regenerate the SKAPP install secret.'**
  String get settingsDeveloperModeInfoItem1;

  /// No description provided for @settingsDeveloperModeInfoItem2.
  ///
  /// In en, this message translates to:
  /// **'Local HTTP listener controls: start/stop, QR pairing, TLS cert rotation, LAN visibility.'**
  String get settingsDeveloperModeInfoItem2;

  /// No description provided for @settingsDeveloperModeInfoItem3.
  ///
  /// In en, this message translates to:
  /// **'Per-peer token list: see every paired mobile SKAPP and revoke individually.'**
  String get settingsDeveloperModeInfoItem3;

  /// No description provided for @settingsDeveloperModeInfoItem4.
  ///
  /// In en, this message translates to:
  /// **'USB CLI console (desktop only): raw NDJSON command line into a USB-connected SmartKraft device.'**
  String get settingsDeveloperModeInfoItem4;

  /// No description provided for @settingsDeveloperModeInfoNotPaid.
  ///
  /// In en, this message translates to:
  /// **'Not a paid upgrade. SKAPP is single-tier and free; this switch only hides power-user surfaces by default to keep things simple. SmartKraft devices work independently of this setting.'**
  String get settingsDeveloperModeInfoNotPaid;

  /// No description provided for @settingsSectionConnectivity.
  ///
  /// In en, this message translates to:
  /// **'Connectivity'**
  String get settingsSectionConnectivity;

  /// No description provided for @settingsBluetoothStatus.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth'**
  String get settingsBluetoothStatus;

  /// No description provided for @settingsBluetoothStatusOn.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get settingsBluetoothStatusOn;

  /// No description provided for @settingsBluetoothStatusOff.
  ///
  /// In en, this message translates to:
  /// **'Turned off'**
  String get settingsBluetoothStatusOff;

  /// No description provided for @settingsBluetoothStatusTurningOn.
  ///
  /// In en, this message translates to:
  /// **'Turning on…'**
  String get settingsBluetoothStatusTurningOn;

  /// No description provided for @settingsBluetoothStatusTurningOff.
  ///
  /// In en, this message translates to:
  /// **'Turning off…'**
  String get settingsBluetoothStatusTurningOff;

  /// No description provided for @settingsBluetoothStatusUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'No permission'**
  String get settingsBluetoothStatusUnauthorized;

  /// No description provided for @settingsBluetoothStatusUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Not supported'**
  String get settingsBluetoothStatusUnsupported;

  /// No description provided for @settingsBluetoothStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get settingsBluetoothStatusUnknown;

  /// No description provided for @settingsNetworkStatus.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get settingsNetworkStatus;

  /// No description provided for @settingsWifiStatusConnected.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi'**
  String get settingsWifiStatusConnected;

  /// No description provided for @settingsWifiStatusEthernet.
  ///
  /// In en, this message translates to:
  /// **'Ethernet'**
  String get settingsWifiStatusEthernet;

  /// No description provided for @settingsWifiStatusMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile data'**
  String get settingsWifiStatusMobile;

  /// No description provided for @settingsWifiStatusDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get settingsWifiStatusDisconnected;

  /// No description provided for @settingsWifiStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get settingsWifiStatusUnknown;

  /// No description provided for @settingsWifiHint.
  ///
  /// In en, this message translates to:
  /// **'Used after initial pairing.'**
  String get settingsWifiHint;

  /// No description provided for @settingsBluetoothPermissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get settingsBluetoothPermissions;

  /// No description provided for @settingsBluetoothPermissionsHint.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth and location access'**
  String get settingsBluetoothPermissionsHint;

  /// No description provided for @settingsBluetoothGrantPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant access'**
  String get settingsBluetoothGrantPermission;

  /// No description provided for @settingsOpenSystemSettings.
  ///
  /// In en, this message translates to:
  /// **'Open system settings'**
  String get settingsOpenSystemSettings;

  /// No description provided for @settingsSectionUpdates.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get settingsSectionUpdates;

  /// No description provided for @settingsCheckUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check for updates'**
  String get settingsCheckUpdates;

  /// No description provided for @settingsAutoCheckUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check on launch'**
  String get settingsAutoCheckUpdates;

  /// No description provided for @settingsAutoCheckUpdatesHint.
  ///
  /// In en, this message translates to:
  /// **'Verify you\'re on the latest release each time SKAPP opens.'**
  String get settingsAutoCheckUpdatesHint;

  /// No description provided for @settingsUpdateChannel.
  ///
  /// In en, this message translates to:
  /// **'Update channel'**
  String get settingsUpdateChannel;

  /// No description provided for @settingsUpdateChannelStable.
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get settingsUpdateChannelStable;

  /// No description provided for @settingsUpdateChannelBeta.
  ///
  /// In en, this message translates to:
  /// **'Beta'**
  String get settingsUpdateChannelBeta;

  /// No description provided for @settingsUpdateChannelBetaHint.
  ///
  /// In en, this message translates to:
  /// **'Get new features earlier. May be less stable.'**
  String get settingsUpdateChannelBetaHint;

  /// No description provided for @settingsUpToDate.
  ///
  /// In en, this message translates to:
  /// **'You\'re on the latest version.'**
  String get settingsUpToDate;

  /// No description provided for @settingsUpdateCheckPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Update check will be wired in Phase 3.'**
  String get settingsUpdateCheckPlaceholder;

  /// No description provided for @settingsSectionLegal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get settingsSectionLegal;

  /// No description provided for @settingsLicense.
  ///
  /// In en, this message translates to:
  /// **'License & Thanks'**
  String get settingsLicense;

  /// No description provided for @settingsSectionInfo.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get settingsSectionInfo;

  /// No description provided for @settingsThemeCycleHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to switch'**
  String get settingsThemeCycleHint;

  /// No description provided for @settingsChannelCycleHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to switch'**
  String get settingsChannelCycleHint;

  /// No description provided for @settingsSectionThisNode.
  ///
  /// In en, this message translates to:
  /// **'This Node'**
  String get settingsSectionThisNode;

  /// No description provided for @settingsNodeNameTitle.
  ///
  /// In en, this message translates to:
  /// **'SKAPP node name'**
  String get settingsNodeNameTitle;

  /// No description provided for @settingsNodeNameSub.
  ///
  /// In en, this message translates to:
  /// **'{name} · other SKAPPs see this name · mDNS broadcast'**
  String settingsNodeNameSub(String name);

  /// No description provided for @settingsSectionDanger.
  ///
  /// In en, this message translates to:
  /// **'Danger zone'**
  String get settingsSectionDanger;

  /// No description provided for @settingsResetPairings.
  ///
  /// In en, this message translates to:
  /// **'Reset pairings'**
  String get settingsResetPairings;

  /// No description provided for @settingsResetPairingsSub.
  ///
  /// In en, this message translates to:
  /// **'Remove all paired devices; settings/language/node name preserved'**
  String get settingsResetPairingsSub;

  /// No description provided for @settingsFactoryReset.
  ///
  /// In en, this message translates to:
  /// **'Factory reset'**
  String get settingsFactoryReset;

  /// No description provided for @settingsFactoryResetSub.
  ///
  /// In en, this message translates to:
  /// **'Everything erased, irreversible'**
  String get settingsFactoryResetSub;

  /// No description provided for @settingsSectionAdvancedNetwork.
  ///
  /// In en, this message translates to:
  /// **'Advanced network'**
  String get settingsSectionAdvancedNetwork;

  /// No description provided for @settingsResetPairingsConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset all pairings?'**
  String get settingsResetPairingsConfirmTitle;

  /// No description provided for @settingsResetPairingsConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'{paired} paired device(s), {bindings} SKAPI action(s), and {peers} SKAPP peer(s) will be removed. Your settings, theme, language, and notes are kept. Devices still hold their bond on their end; to fully unpair, reset the device manually. This cannot be undone.'**
  String settingsResetPairingsConfirmBody(int paired, int bindings, int peers);

  /// No description provided for @settingsResetPairingsConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get settingsResetPairingsConfirmAction;

  /// No description provided for @settingsFactoryResetConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Factory reset?'**
  String get settingsFactoryResetConfirmTitle;

  /// No description provided for @settingsFactoryResetConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Everything will be erased: all pairings, settings, theme, language, notes, network identity, TLS certificate, and the auto-start entry. SKAPP returns to first-launch state. This cannot be undone.'**
  String get settingsFactoryResetConfirmBody;

  /// No description provided for @settingsFactoryResetConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Erase everything'**
  String get settingsFactoryResetConfirmAction;

  /// No description provided for @settingsFactoryResetSecondConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you absolutely sure?'**
  String get settingsFactoryResetSecondConfirmTitle;

  /// No description provided for @settingsFactoryResetSecondConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Type ERASE to confirm.'**
  String get settingsFactoryResetSecondConfirmBody;

  /// No description provided for @settingsFactoryResetSecondConfirmHint.
  ///
  /// In en, this message translates to:
  /// **'ERASE'**
  String get settingsFactoryResetSecondConfirmHint;

  /// No description provided for @settingsFactoryResetSecondConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'I understand. Erase.'**
  String get settingsFactoryResetSecondConfirmAction;

  /// No description provided for @settingsResetInProgress.
  ///
  /// In en, this message translates to:
  /// **'Resetting…'**
  String get settingsResetInProgress;

  /// No description provided for @settingsResetDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset complete'**
  String get settingsResetDoneTitle;

  /// No description provided for @settingsResetDoneWithWarnings.
  ///
  /// In en, this message translates to:
  /// **'Reset complete (with warnings)'**
  String get settingsResetDoneWithWarnings;

  /// No description provided for @settingsResetSummaryPaired.
  ///
  /// In en, this message translates to:
  /// **'{count} paired device(s) removed'**
  String settingsResetSummaryPaired(int count);

  /// No description provided for @settingsResetSummaryBindings.
  ///
  /// In en, this message translates to:
  /// **'{count} SKAPI action(s) removed'**
  String settingsResetSummaryBindings(int count);

  /// No description provided for @settingsResetSummaryPeers.
  ///
  /// In en, this message translates to:
  /// **'{count} SKAPP peer(s) removed'**
  String settingsResetSummaryPeers(int count);

  /// No description provided for @settingsResetSummaryBonds.
  ///
  /// In en, this message translates to:
  /// **'{count} device bond(s) cleared'**
  String settingsResetSummaryBonds(int count);

  /// No description provided for @settingsResetSummaryNetworkIdentity.
  ///
  /// In en, this message translates to:
  /// **'Network identity reset to defaults'**
  String get settingsResetSummaryNetworkIdentity;

  /// No description provided for @settingsResetSummaryTlsCert.
  ///
  /// In en, this message translates to:
  /// **'TLS certificate cleared'**
  String get settingsResetSummaryTlsCert;

  /// No description provided for @settingsResetSummaryAutostart.
  ///
  /// In en, this message translates to:
  /// **'Auto-start entry removed'**
  String get settingsResetSummaryAutostart;

  /// No description provided for @settingsResetSummaryWarningHeader.
  ///
  /// In en, this message translates to:
  /// **'Warnings:'**
  String get settingsResetSummaryWarningHeader;

  /// No description provided for @settingsResetRestartHint.
  ///
  /// In en, this message translates to:
  /// **'Restart SKAPP to fully apply changes.'**
  String get settingsResetRestartHint;

  /// No description provided for @settingsResetRestartNow.
  ///
  /// In en, this message translates to:
  /// **'Restart now'**
  String get settingsResetRestartNow;

  /// No description provided for @settingsResetClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get settingsResetClose;

  /// No description provided for @settingsFooterCombined.
  ///
  /// In en, this message translates to:
  /// **'SKAPP {version} · {node}'**
  String settingsFooterCombined(String version, String node);

  /// No description provided for @langEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @langTurkish.
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get langTurkish;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About SmartKraft and SKAPP'**
  String get aboutTitle;

  /// No description provided for @aboutDevicesHeading.
  ///
  /// In en, this message translates to:
  /// **'Our Devices'**
  String get aboutDevicesHeading;

  /// No description provided for @aboutDevicesBody.
  ///
  /// In en, this message translates to:
  /// **'SmartKraft devices are designed to be innovative, distinctive, and to carry details others have not thought of. Our aim is not to reproduce what already exists; it is to make what hasn\'t been made, what has been left undone. To point at an unsolved everyday problem and offer it a simple, understandable answer; or to take something that has been solved but stayed expensive, and put a DIY version everyone can build in its place.\n\nEvery SmartKraft device is designed and built to give a small, plain answer to a problem that hasn\'t been solved yet. Designing a device, we ask ourselves a single question: \"Why hasn\'t this problem been solved until now, or why has it stayed so expensive?\"'**
  String get aboutDevicesBody;

  /// No description provided for @aboutSkappRoleHeading.
  ///
  /// In en, this message translates to:
  /// **'Where SKAPP Fits'**
  String get aboutSkappRoleHeading;

  /// No description provided for @aboutSkappRoleBody.
  ///
  /// In en, this message translates to:
  /// **'SKAPP is the shared application for SmartKraft devices. It is a simple user interface for pairing a device, configuring it, changing its behaviour, and bringing several devices together in a single scenario.\n\nSKAPP is not required for your devices; it is a convenience. Every SmartKraft device can be configured the same way over USB CLI without SKAPP, and that path stays open for those who prefer the command line. For everyone else who wants the speed of a visual interface and the comfort of managing several devices at once, SKAPP is here.\n\nNo cloud account. No advertising. No data collection. It is a quiet bridge between your phone and your device, nothing more.'**
  String get aboutSkappRoleBody;

  /// No description provided for @aboutShowcaseHeading.
  ///
  /// In en, this message translates to:
  /// **'Maker Showcase'**
  String get aboutShowcaseHeading;

  /// No description provided for @aboutShowcaseEmpty.
  ///
  /// In en, this message translates to:
  /// **'The showcase is empty for now. The first SmartKraft device is on its way; design files, firmware sources, parts lists, and assembly guides will be listed here when they\'re ready. Until then this section doesn\'t promise much, it is just holding space for what\'s to come.'**
  String get aboutShowcaseEmpty;

  /// No description provided for @aboutConnectHeading.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get aboutConnectHeading;

  /// No description provided for @aboutConnectIntro.
  ///
  /// In en, this message translates to:
  /// **'Send a message, look at the source code, follow the work as it grows.'**
  String get aboutConnectIntro;

  /// No description provided for @aboutConnectGitHub.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get aboutConnectGitHub;

  /// No description provided for @aboutConnectWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get aboutConnectWebsite;

  /// No description provided for @aboutConnectYouTube.
  ///
  /// In en, this message translates to:
  /// **'YouTube'**
  String get aboutConnectYouTube;

  /// No description provided for @aboutConnectX.
  ///
  /// In en, this message translates to:
  /// **'X'**
  String get aboutConnectX;

  /// No description provided for @aboutConnectEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get aboutConnectEmail;

  /// No description provided for @aboutVersionHeading.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get aboutVersionHeading;

  /// No description provided for @licenseTitle.
  ///
  /// In en, this message translates to:
  /// **'License & Thanks'**
  String get licenseTitle;

  /// No description provided for @licenseSmartKraftHeading.
  ///
  /// In en, this message translates to:
  /// **'About SmartKraft'**
  String get licenseSmartKraftHeading;

  /// No description provided for @licenseSmartKraftBody.
  ///
  /// In en, this message translates to:
  /// **'SmartKraft is a small workshop that designs unusual but practical electronic tools for everyday life. Behind every device that reaches your hand lie countless steps: an early sketch on a notebook, a first soldered prototype, lines of code written late at night, small details retried again and again. Building a device means writing lines, drawing circuits, soldering joints, finding bugs, starting over. To everyone who has put their effort into this process without leaving a name on it, thank you, on behalf of SmartKraft.\n\nWe believe in maker culture, in open source, and in repairable, recyclable electronics. That is why we publish the hardware designs of our devices as open hardware, and their firmware under AGPL 3.0. Our goal is to make a DIY version of as many parts as possible reachable.\n\nA note we want to be honest about: the pairing keys and communication secrets that protect a device\'s security are kept private in source. If they were published, the trust between your device and the app would break. This closure is not a concession against openness; it is a decision made for your safety.\n\nFor SKAPP and every device that talks to it, our principle is transparency: we want you to be able to read how things work, audit them, and build your own version. Even so, every device has its own license section and the terms may vary. To see a device\'s source, schematics, or terms of use, please look at that device\'s own license area.\n\nThank you for supporting us by using this app. We are glad you are here.'**
  String get licenseSmartKraftBody;

  /// No description provided for @licenseOpenSourceHeading.
  ///
  /// In en, this message translates to:
  /// **'Standing on Their Shoulders'**
  String get licenseOpenSourceHeading;

  /// No description provided for @licenseOpenSourceBody.
  ///
  /// In en, this message translates to:
  /// **'SKAPP is built on top of thousands of open-source projects written before it. Heartfelt thanks to the Flutter team and its contributors for making the visible interface possible, and to all open-source developers who have given years to networking, storage, cryptography, Bluetooth, and countless subsystems.\n\nBecause we benefit from open source, we try to keep the hardware and firmware of our own devices open as well, so those who come after us can benefit from this body of work the same way.\n\nThanks again to everyone who has been part of this effort.'**
  String get licenseOpenSourceBody;

  /// No description provided for @licenseThirdPartyLink.
  ///
  /// In en, this message translates to:
  /// **'Third-party licenses used in this app'**
  String get licenseThirdPartyLink;

  /// No description provided for @discoveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Find devices'**
  String get discoveryTitle;

  /// No description provided for @discoverySearching.
  ///
  /// In en, this message translates to:
  /// **'Searching for nearby SmartKraft devices…'**
  String get discoverySearching;

  /// No description provided for @discoveryNoResults.
  ///
  /// In en, this message translates to:
  /// **'No SmartKraft devices found nearby.'**
  String get discoveryNoResults;

  /// No description provided for @discoveryTapToConnect.
  ///
  /// In en, this message translates to:
  /// **'Tap a device to connect'**
  String get discoveryTapToConnect;

  /// No description provided for @discoveryRescan.
  ///
  /// In en, this message translates to:
  /// **'Scan again'**
  String get discoveryRescan;

  /// No description provided for @pairingTitle.
  ///
  /// In en, this message translates to:
  /// **'Pair device'**
  String get pairingTitle;

  /// No description provided for @pairingEnterPasskey.
  ///
  /// In en, this message translates to:
  /// **'Enter the passkey printed on the device label.'**
  String get pairingEnterPasskey;

  /// No description provided for @pairingPasskeyHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. K7M9P2AB'**
  String get pairingPasskeyHint;

  /// No description provided for @pairingConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get pairingConnect;

  /// No description provided for @pairingMockNotice.
  ///
  /// In en, this message translates to:
  /// **'Device firmware not ready yet. Pairing is a placeholder in this build.'**
  String get pairingMockNotice;

  /// No description provided for @errorBluetoothPermission.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth permission is required to scan for devices.'**
  String get errorBluetoothPermission;

  /// No description provided for @errorBluetoothOff.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth is turned off.'**
  String get errorBluetoothOff;

  /// No description provided for @errorLocationPermission.
  ///
  /// In en, this message translates to:
  /// **'Location permission is required to scan for BLE devices on Android.'**
  String get errorLocationPermission;

  /// No description provided for @actionOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get actionOpenSettings;

  /// No description provided for @actionGrantPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant permission'**
  String get actionGrantPermission;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get commonRemove;

  /// No description provided for @commonRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get commonRefresh;

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get commonConnect;

  /// No description provided for @commonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// No description provided for @commonForget.
  ///
  /// In en, this message translates to:
  /// **'Forget'**
  String get commonForget;

  /// No description provided for @commonMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get commonMore;

  /// No description provided for @commonError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get commonError;

  /// No description provided for @commonOnline.
  ///
  /// In en, this message translates to:
  /// **'online'**
  String get commonOnline;

  /// No description provided for @commonOffline.
  ///
  /// In en, this message translates to:
  /// **'offline'**
  String get commonOffline;

  /// No description provided for @productBlockingFocus.
  ///
  /// In en, this message translates to:
  /// **'Blocking Focus'**
  String get productBlockingFocus;

  /// No description provided for @productLebensSpur.
  ///
  /// In en, this message translates to:
  /// **'LebensSpur'**
  String get productLebensSpur;

  /// No description provided for @productGeneric.
  ///
  /// In en, this message translates to:
  /// **'SmartKraft device'**
  String get productGeneric;

  /// No description provided for @timeJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get timeJustNow;

  /// No description provided for @timeMinAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} min ago'**
  String timeMinAgo(int count);

  /// No description provided for @timeHourAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} h ago'**
  String timeHourAgo(int count);

  /// No description provided for @timeDayAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} d ago'**
  String timeDayAgo(int count);

  /// No description provided for @devicesRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove device'**
  String get devicesRemoveTitle;

  /// No description provided for @devicesRemoveBody.
  ///
  /// In en, this message translates to:
  /// **'{name} will be removed. The device stays plugged in; to add it again you\'ll need to re-pair.'**
  String devicesRemoveBody(String name);

  /// No description provided for @devicesUnpair.
  ///
  /// In en, this message translates to:
  /// **'Unpair'**
  String get devicesUnpair;

  /// No description provided for @devicesEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Bring your SmartKraft device close and tap the button below.'**
  String get devicesEmptyHint;

  /// No description provided for @devicesEmptyTitleNoPaired.
  ///
  /// In en, this message translates to:
  /// **'No paired devices yet'**
  String get devicesEmptyTitleNoPaired;

  /// No description provided for @devicesLastSeen.
  ///
  /// In en, this message translates to:
  /// **'Last seen: {time}'**
  String devicesLastSeen(String time);

  /// No description provided for @devicesPairedAt.
  ///
  /// In en, this message translates to:
  /// **'Paired: {time}'**
  String devicesPairedAt(String time);

  /// No description provided for @devicesHubSubtitle.
  ///
  /// In en, this message translates to:
  /// **'SKAPP host · {count} paired'**
  String devicesHubSubtitle(int count);

  /// No description provided for @devicesHubEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'waiting for device'**
  String get devicesHubEmptySubtitle;

  /// No description provided for @devicesHeaderSub.
  ///
  /// In en, this message translates to:
  /// **'{paired} paired · {online} online · constellation view'**
  String devicesHeaderSub(int paired, int online);

  /// No description provided for @devicesAddPillLabel.
  ///
  /// In en, this message translates to:
  /// **'Add device'**
  String get devicesAddPillLabel;

  /// No description provided for @devicesLegendOnline.
  ///
  /// In en, this message translates to:
  /// **'online ({count})'**
  String devicesLegendOnline(int count);

  /// No description provided for @devicesLegendOffline.
  ///
  /// In en, this message translates to:
  /// **'offline ({count})'**
  String devicesLegendOffline(int count);

  /// No description provided for @devicesLegendLowBattery.
  ///
  /// In en, this message translates to:
  /// **'low battery ({count})'**
  String devicesLegendLowBattery(int count);

  /// No description provided for @devicesStatPaired.
  ///
  /// In en, this message translates to:
  /// **'paired'**
  String get devicesStatPaired;

  /// No description provided for @devicesStatBf.
  ///
  /// In en, this message translates to:
  /// **'BF'**
  String get devicesStatBf;

  /// No description provided for @devicesStatLs.
  ///
  /// In en, this message translates to:
  /// **'LS'**
  String get devicesStatLs;

  /// No description provided for @devicesStatMs.
  ///
  /// In en, this message translates to:
  /// **'phone'**
  String get devicesStatMs;

  /// No description provided for @devicesEmptyHubLabel.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get devicesEmptyHubLabel;

  /// No description provided for @devicesEmptyAddCta.
  ///
  /// In en, this message translates to:
  /// **'Add first device'**
  String get devicesEmptyAddCta;

  /// No description provided for @devicesEmptyHintChip.
  ///
  /// In en, this message translates to:
  /// **'bring device close, press its button'**
  String get devicesEmptyHintChip;

  /// No description provided for @devicesNotifOfflineHours.
  ///
  /// In en, this message translates to:
  /// **'offline {hours}h ago'**
  String devicesNotifOfflineHours(int hours);

  /// No description provided for @devicesNotifOfflineMinutes.
  ///
  /// In en, this message translates to:
  /// **'offline {minutes}m ago'**
  String devicesNotifOfflineMinutes(int minutes);

  /// No description provided for @devicesNotifLowBattery.
  ///
  /// In en, this message translates to:
  /// **'low battery'**
  String get devicesNotifLowBattery;

  /// No description provided for @skappPeersCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Paired Desktop SKAPPs'**
  String get skappPeersCardTitle;

  /// No description provided for @skappPeersCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Phones and tablets pair here so a BF action can run a script on a Desktop SKAPP. Open Desktop SKAPP > Settings > SKAPP HTTP Listener to get a QR.'**
  String get skappPeersCardSubtitle;

  /// No description provided for @skappPeersCardEmpty.
  ///
  /// In en, this message translates to:
  /// **'No paired peer yet.'**
  String get skappPeersCardEmpty;

  /// No description provided for @skappPeersCardPairButton.
  ///
  /// In en, this message translates to:
  /// **'Pair new'**
  String get skappPeersCardPairButton;

  /// No description provided for @skappPeersCardOnline.
  ///
  /// In en, this message translates to:
  /// **'online'**
  String get skappPeersCardOnline;

  /// No description provided for @skappPeersCardOffline.
  ///
  /// In en, this message translates to:
  /// **'offline'**
  String get skappPeersCardOffline;

  /// No description provided for @skappPeersCardNeverSeen.
  ///
  /// In en, this message translates to:
  /// **'never seen'**
  String get skappPeersCardNeverSeen;

  /// No description provided for @skappPeersCardRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String skappPeersCardRemoveTitle(String name);

  /// No description provided for @skappPeersCardRemoveBody.
  ///
  /// In en, this message translates to:
  /// **'SKAPP will stop sending scripts to this peer. You can re-pair with the same QR / token later.'**
  String get skappPeersCardRemoveBody;

  /// No description provided for @skappPeersCardRemoveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get skappPeersCardRemoveConfirm;

  /// No description provided for @skappPeersCardRemoveCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get skappPeersCardRemoveCancel;

  /// No description provided for @skappPeersCardRemovedToast.
  ///
  /// In en, this message translates to:
  /// **'{name} unpaired'**
  String skappPeersCardRemovedToast(String name);

  /// No description provided for @devicesCardLongPressHint.
  ///
  /// In en, this message translates to:
  /// **'Long press to manage'**
  String get devicesCardLongPressHint;

  /// No description provided for @devicesActionsSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'{name}'**
  String devicesActionsSheetTitle(String name);

  /// No description provided for @devicesActionForget.
  ///
  /// In en, this message translates to:
  /// **'Forget device'**
  String get devicesActionForget;

  /// No description provided for @devicesActionForgetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Remove this device from SKAPP. The device itself is not affected; you can pair it again later.'**
  String get devicesActionForgetSubtitle;

  /// No description provided for @devicesActionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get devicesActionCancel;

  /// No description provided for @devicesForgetDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Forget {name}?'**
  String devicesForgetDialogTitle(String name);

  /// No description provided for @devicesForgetDialogBody.
  ///
  /// In en, this message translates to:
  /// **'SKAPP will stop tracking this device. The pairing on the device side stays until you reset it from the device.'**
  String get devicesForgetDialogBody;

  /// No description provided for @devicesForgetDialogBodyWithActions.
  ///
  /// In en, this message translates to:
  /// **'SKAPP will stop tracking this device and delete {count} SKAPI action(s) bound to it. The pairing on the device side stays until you reset it from the device.'**
  String devicesForgetDialogBodyWithActions(int count);

  /// No description provided for @devicesForgetDialogConfirm.
  ///
  /// In en, this message translates to:
  /// **'Forget'**
  String get devicesForgetDialogConfirm;

  /// No description provided for @devicesForgetDialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get devicesForgetDialogCancel;

  /// No description provided for @devicesForgotToast.
  ///
  /// In en, this message translates to:
  /// **'{name} removed from SKAPP'**
  String devicesForgotToast(String name);

  /// No description provided for @devicesMobileNoDetailHint.
  ///
  /// In en, this message translates to:
  /// **'No detail page for phones · long-press to unpair'**
  String get devicesMobileNoDetailHint;

  /// No description provided for @devicesDesktopStatLabel.
  ///
  /// In en, this message translates to:
  /// **'desktop'**
  String get devicesDesktopStatLabel;

  /// No description provided for @devicesDesktopGroupLabel.
  ///
  /// In en, this message translates to:
  /// **'Paired Desktops'**
  String get devicesDesktopGroupLabel;

  /// No description provided for @devicesDesktopTriggerDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Send a SKAPI command?'**
  String get devicesDesktopTriggerDialogTitle;

  /// No description provided for @devicesDesktopTriggerDialogBody.
  ///
  /// In en, this message translates to:
  /// **'All mobile-touch bindings on {name} will run.'**
  String devicesDesktopTriggerDialogBody(String name);

  /// No description provided for @devicesDesktopTriggerDialogConfirm.
  ///
  /// In en, this message translates to:
  /// **'Send command'**
  String get devicesDesktopTriggerDialogConfirm;

  /// No description provided for @devicesDesktopTriggerDialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get devicesDesktopTriggerDialogCancel;

  /// No description provided for @devicesDesktopForgetDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Unpair'**
  String get devicesDesktopForgetDialogTitle;

  /// No description provided for @devicesDesktopForgetDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Unpairing {name}. You\'ll need to re-pair to send commands to this desktop again.'**
  String devicesDesktopForgetDialogBody(String name);

  /// No description provided for @devicesDesktopForgotToast.
  ///
  /// In en, this message translates to:
  /// **'{name} unpaired'**
  String devicesDesktopForgotToast(String name);

  /// No description provided for @homeStatDevices.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get homeStatDevices;

  /// No description provided for @homeStatOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get homeStatOnline;

  /// No description provided for @homeStatWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get homeStatWarning;

  /// No description provided for @homeWarningMeta.
  ///
  /// In en, this message translates to:
  /// **'Paired but never seen · {time}'**
  String homeWarningMeta(String time);

  /// No description provided for @homeBrandTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get homeBrandTotal;

  /// No description provided for @homeBrandActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get homeBrandActive;

  /// No description provided for @homeBrandActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get homeBrandActions;

  /// No description provided for @homeBrandVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get homeBrandVersion;

  /// No description provided for @smartkraftSectionProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get smartkraftSectionProducts;

  /// No description provided for @smartkraftSectionCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get smartkraftSectionCommunity;

  /// No description provided for @smartkraftStatusLive.
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get smartkraftStatusLive;

  /// No description provided for @smartkraftStatusDev.
  ///
  /// In en, this message translates to:
  /// **'IN DEV'**
  String get smartkraftStatusDev;

  /// No description provided for @smartkraftStatusConcept.
  ///
  /// In en, this message translates to:
  /// **'CONCEPT'**
  String get smartkraftStatusConcept;

  /// No description provided for @smartkraftBlockingFocusTagline.
  ///
  /// In en, this message translates to:
  /// **'The break you cannot skip out of.'**
  String get smartkraftBlockingFocusTagline;

  /// No description provided for @smartkraftLebensSpurTagline.
  ///
  /// In en, this message translates to:
  /// **'A quiet witness to your habits.'**
  String get smartkraftLebensSpurTagline;

  /// No description provided for @smartkraftSynDimmTagline.
  ///
  /// In en, this message translates to:
  /// **'The right light at the right hour.'**
  String get smartkraftSynDimmTagline;

  /// No description provided for @homeStickyDevicesMeta.
  ///
  /// In en, this message translates to:
  /// **'{count} devices · {warning} alerts'**
  String homeStickyDevicesMeta(int count, int warning);

  /// No description provided for @homeStickySkapiMeta.
  ///
  /// In en, this message translates to:
  /// **'{actions} actions'**
  String homeStickySkapiMeta(int actions);

  /// No description provided for @homeStickySettingsMeta.
  ///
  /// In en, this message translates to:
  /// **'{node} · v{version}'**
  String homeStickySettingsMeta(String node, String version);

  /// No description provided for @homeStickyComingSoonMeta.
  ///
  /// In en, this message translates to:
  /// **'content in progress'**
  String get homeStickyComingSoonMeta;

  /// No description provided for @homeStickyNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get homeStickyNotesLabel;

  /// No description provided for @setupChoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Add device'**
  String get setupChoiceTitle;

  /// No description provided for @setupChoiceQuestion.
  ///
  /// In en, this message translates to:
  /// **'Where are we?'**
  String get setupChoiceQuestion;

  /// No description provided for @setupChoiceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Is the device fresh from the box, or has it been configured via CLI before?'**
  String get setupChoiceSubtitle;

  /// No description provided for @setupChoiceFreshTitle.
  ///
  /// In en, this message translates to:
  /// **'Fresh setup'**
  String get setupChoiceFreshTitle;

  /// No description provided for @setupChoiceFreshBody.
  ///
  /// In en, this message translates to:
  /// **'I\'m adding a brand-new SmartKraft device for the first time. Pairing will run over BLE and the WiFi setup wizard will open.'**
  String get setupChoiceFreshBody;

  /// No description provided for @setupChoiceExistingTitle.
  ///
  /// In en, this message translates to:
  /// **'Add an already-configured device'**
  String get setupChoiceExistingTitle;

  /// No description provided for @setupChoiceExistingBody.
  ///
  /// In en, this message translates to:
  /// **'I configured my device\'s WiFi via USB/CLI and I\'m on the same network. Pair directly over WiFi and skip the wizard.'**
  String get setupChoiceExistingBody;

  /// No description provided for @setupChoiceFooter.
  ///
  /// In en, this message translates to:
  /// **'When in doubt, pick \"Fresh setup\", it\'s the right path for both first-time pairing and factory-reset devices.'**
  String get setupChoiceFooter;

  /// No description provided for @wifiDiscoveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Devices on this network'**
  String get wifiDiscoveryTitle;

  /// No description provided for @wifiDiscoveryScanError.
  ///
  /// In en, this message translates to:
  /// **'Scan error: {error}'**
  String wifiDiscoveryScanError(String error);

  /// No description provided for @wifiDiscoveryHint.
  ///
  /// In en, this message translates to:
  /// **'The device must be on WiFi and the phone on the same network. You\'ll be asked to press the device\'s button during pairing.'**
  String get wifiDiscoveryHint;

  /// No description provided for @wifiDiscoveryScanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning…'**
  String get wifiDiscoveryScanning;

  /// No description provided for @wifiDiscoveryNotFound.
  ///
  /// In en, this message translates to:
  /// **'No devices found'**
  String get wifiDiscoveryNotFound;

  /// No description provided for @wifiDiscoveryFoundCount.
  ///
  /// In en, this message translates to:
  /// **'{count} device(s) found'**
  String wifiDiscoveryFoundCount(int count);

  /// No description provided for @wifiDiscoveryEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Looking for SmartKraft devices on this network…'**
  String get wifiDiscoveryEmptyTitle;

  /// No description provided for @wifiDiscoveryEmptyTitleIdle.
  ///
  /// In en, this message translates to:
  /// **'No devices found.'**
  String get wifiDiscoveryEmptyTitleIdle;

  /// No description provided for @wifiDiscoveryEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Make sure the device is powered on, connected to WiFi, and on the same network as your phone. Use the refresh button to retry.'**
  String get wifiDiscoveryEmptyHint;

  /// No description provided for @wifiDiscoveryPairedBadge.
  ///
  /// In en, this message translates to:
  /// **'paired'**
  String get wifiDiscoveryPairedBadge;

  /// No description provided for @wifiPairingTitle.
  ///
  /// In en, this message translates to:
  /// **'Pairing'**
  String get wifiPairingTitle;

  /// No description provided for @wifiPairingConnectFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t connect: {error}'**
  String wifiPairingConnectFailed(String error);

  /// No description provided for @wifiPairingInvalidJson.
  ///
  /// In en, this message translates to:
  /// **'Invalid JSON: {error}'**
  String wifiPairingInvalidJson(String error);

  /// No description provided for @wifiPairingClosedEarly.
  ///
  /// In en, this message translates to:
  /// **'Connection closed (no answer)'**
  String get wifiPairingClosedEarly;

  /// No description provided for @wifiPairingSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send command: {error}'**
  String wifiPairingSendFailed(String error);

  /// No description provided for @wifiPairingTimeout.
  ///
  /// In en, this message translates to:
  /// **'Device didn\'t reply (timeout).'**
  String get wifiPairingTimeout;

  /// No description provided for @wifiPairingNotOpen.
  ///
  /// In en, this message translates to:
  /// **'Pairing window not open on the device. Press the button briefly and try again.'**
  String get wifiPairingNotOpen;

  /// No description provided for @skapiBindFixedTriggerLabel.
  ///
  /// In en, this message translates to:
  /// **'Trigger: when the timer expires'**
  String get skapiBindFixedTriggerLabel;

  /// No description provided for @wifiPairingDeviceAlreadyBonded.
  ///
  /// In en, this message translates to:
  /// **'This device is already paired with another SKAPP. Adding a new peer over WiFi is not supported by the current firmware (TCP only accepts the first pair). Use BLE pairing, or unpair the existing peer from the device.'**
  String get wifiPairingDeviceAlreadyBonded;

  /// No description provided for @wifiPairingRejected.
  ///
  /// In en, this message translates to:
  /// **'Device rejected: {error}'**
  String wifiPairingRejected(String error);

  /// No description provided for @wifiPairingMissingPub.
  ///
  /// In en, this message translates to:
  /// **'Missing/corrupt our_pub from device.'**
  String get wifiPairingMissingPub;

  /// No description provided for @wifiPairingHexError.
  ///
  /// In en, this message translates to:
  /// **'our_pub hex decode failed: {error}'**
  String wifiPairingHexError(String error);

  /// No description provided for @wifiPairingStageAwaiting.
  ///
  /// In en, this message translates to:
  /// **'Press the button on the device'**
  String get wifiPairingStageAwaiting;

  /// No description provided for @wifiPairingStageConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting to device…'**
  String get wifiPairingStageConnecting;

  /// No description provided for @wifiPairingStageExchanging.
  ///
  /// In en, this message translates to:
  /// **'Exchanging keys…'**
  String get wifiPairingStageExchanging;

  /// No description provided for @wifiPairingStageDone.
  ///
  /// In en, this message translates to:
  /// **'Pairing complete'**
  String get wifiPairingStageDone;

  /// No description provided for @wifiPairingStageFailed.
  ///
  /// In en, this message translates to:
  /// **'Pairing failed'**
  String get wifiPairingStageFailed;

  /// No description provided for @wifiPairingStageAwaitingHelp.
  ///
  /// In en, this message translates to:
  /// **'Briefly press the device\'s control button (less than 3 seconds). The pairing window stays open for 60 seconds.'**
  String get wifiPairingStageAwaitingHelp;

  /// No description provided for @wifiPairingStageConnectingHelp.
  ///
  /// In en, this message translates to:
  /// **'Opening TCP socket.'**
  String get wifiPairingStageConnectingHelp;

  /// No description provided for @wifiPairingStageExchangingHelp.
  ///
  /// In en, this message translates to:
  /// **'pairing.ecdh.exchange sent, waiting for the device\'s reply.'**
  String get wifiPairingStageExchangingHelp;

  /// No description provided for @wifiPairingStageDoneHelp.
  ///
  /// In en, this message translates to:
  /// **'Heading to the device dashboard.'**
  String get wifiPairingStageDoneHelp;

  /// No description provided for @wifiPairingStartCta.
  ///
  /// In en, this message translates to:
  /// **'Pair'**
  String get wifiPairingStartCta;

  /// No description provided for @bfDashboardTitleFallback.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get bfDashboardTitleFallback;

  /// No description provided for @bfDashboardWifiNone.
  ///
  /// In en, this message translates to:
  /// **'No WiFi'**
  String get bfDashboardWifiNone;

  /// No description provided for @bfDashboardLinkBle.
  ///
  /// In en, this message translates to:
  /// **'BLE'**
  String get bfDashboardLinkBle;

  /// No description provided for @bfDashboardLinkWifi.
  ///
  /// In en, this message translates to:
  /// **'WiFi'**
  String get bfDashboardLinkWifi;

  /// No description provided for @bfDashboardLinkUsb.
  ///
  /// In en, this message translates to:
  /// **'USB'**
  String get bfDashboardLinkUsb;

  /// No description provided for @bfDashboardToggleVibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get bfDashboardToggleVibration;

  /// No description provided for @bfDashboardToggleTilt.
  ///
  /// In en, this message translates to:
  /// **'Tilt alert'**
  String get bfDashboardToggleTilt;

  /// No description provided for @bfDashboardToggleLowBatt.
  ///
  /// In en, this message translates to:
  /// **'Low battery alert'**
  String get bfDashboardToggleLowBatt;

  /// No description provided for @bfDashboardApiChainTitle.
  ///
  /// In en, this message translates to:
  /// **'API chain'**
  String get bfDashboardApiChainTitle;

  /// No description provided for @bfDashboardApiChainNone.
  ///
  /// In en, this message translates to:
  /// **'no endpoints yet · master {state}'**
  String bfDashboardApiChainNone(String state);

  /// No description provided for @bfDashboardApiChainSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} endpoint(s) · master {state}'**
  String bfDashboardApiChainSummary(int count, String state);

  /// No description provided for @bfDashboardMasterOn.
  ///
  /// In en, this message translates to:
  /// **'on'**
  String get bfDashboardMasterOn;

  /// No description provided for @bfDashboardMasterOff.
  ///
  /// In en, this message translates to:
  /// **'off'**
  String get bfDashboardMasterOff;

  /// No description provided for @bfDashboardNotebookTitle.
  ///
  /// In en, this message translates to:
  /// **'User Notebook'**
  String get bfDashboardNotebookTitle;

  /// No description provided for @bfDashboardNotebookSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Encrypted area · 100 KB · free-form content'**
  String get bfDashboardNotebookSubtitle;

  /// No description provided for @bfDashboardMoreDeviceInfo.
  ///
  /// In en, this message translates to:
  /// **'Device info'**
  String get bfDashboardMoreDeviceInfo;

  /// No description provided for @bfDashboardMoreSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get bfDashboardMoreSettings;

  /// No description provided for @bfDashboardWriteFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t write: {error}'**
  String bfDashboardWriteFailed(String error);

  /// No description provided for @bfDeviceInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Device info'**
  String get bfDeviceInfoTitle;

  /// No description provided for @bfDeviceInfoSectionGeneral.
  ///
  /// In en, this message translates to:
  /// **'GENERAL'**
  String get bfDeviceInfoSectionGeneral;

  /// No description provided for @bfDeviceInfoSectionConnection.
  ///
  /// In en, this message translates to:
  /// **'CONNECTION'**
  String get bfDeviceInfoSectionConnection;

  /// No description provided for @bfDeviceInfoSectionBattery.
  ///
  /// In en, this message translates to:
  /// **'BATTERY'**
  String get bfDeviceInfoSectionBattery;

  /// No description provided for @bfDeviceInfoSectionTime.
  ///
  /// In en, this message translates to:
  /// **'TIME'**
  String get bfDeviceInfoSectionTime;

  /// No description provided for @bfDeviceInfoSectionLastError.
  ///
  /// In en, this message translates to:
  /// **'LAST ERROR'**
  String get bfDeviceInfoSectionLastError;

  /// No description provided for @bfDeviceInfoSectionDiagnostics.
  ///
  /// In en, this message translates to:
  /// **'DIAGNOSTICS'**
  String get bfDeviceInfoSectionDiagnostics;

  /// No description provided for @bfDeviceInfoSectionDocs.
  ///
  /// In en, this message translates to:
  /// **'DOCS'**
  String get bfDeviceInfoSectionDocs;

  /// No description provided for @bfDeviceInfoProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get bfDeviceInfoProduct;

  /// No description provided for @bfDeviceInfoTypeCode.
  ///
  /// In en, this message translates to:
  /// **'Type code'**
  String get bfDeviceInfoTypeCode;

  /// No description provided for @bfDeviceInfoIdentity.
  ///
  /// In en, this message translates to:
  /// **'Identity'**
  String get bfDeviceInfoIdentity;

  /// No description provided for @bfDeviceInfoHardware.
  ///
  /// In en, this message translates to:
  /// **'Hardware'**
  String get bfDeviceInfoHardware;

  /// No description provided for @bfDeviceInfoFirmware.
  ///
  /// In en, this message translates to:
  /// **'Firmware'**
  String get bfDeviceInfoFirmware;

  /// No description provided for @bfDeviceInfoProtocol.
  ///
  /// In en, this message translates to:
  /// **'Protocol'**
  String get bfDeviceInfoProtocol;

  /// No description provided for @bfDeviceInfoBuild.
  ///
  /// In en, this message translates to:
  /// **'Build'**
  String get bfDeviceInfoBuild;

  /// No description provided for @bfDeviceInfoUptime.
  ///
  /// In en, this message translates to:
  /// **'Uptime'**
  String get bfDeviceInfoUptime;

  /// No description provided for @bfDeviceInfoWifiState.
  ///
  /// In en, this message translates to:
  /// **'WiFi state'**
  String get bfDeviceInfoWifiState;

  /// No description provided for @bfDeviceInfoIp.
  ///
  /// In en, this message translates to:
  /// **'IP'**
  String get bfDeviceInfoIp;

  /// No description provided for @bfDeviceInfoSignal.
  ///
  /// In en, this message translates to:
  /// **'Signal'**
  String get bfDeviceInfoSignal;

  /// No description provided for @bfDeviceInfoBleAdvertising.
  ///
  /// In en, this message translates to:
  /// **'BLE advertising'**
  String get bfDeviceInfoBleAdvertising;

  /// No description provided for @bfDeviceInfoBlePaired.
  ///
  /// In en, this message translates to:
  /// **'BLE pairings'**
  String get bfDeviceInfoBlePaired;

  /// No description provided for @bfDeviceInfoPairedClients.
  ///
  /// In en, this message translates to:
  /// **'{count} client(s)'**
  String bfDeviceInfoPairedClients(int count);

  /// No description provided for @bfDeviceInfoBattery.
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get bfDeviceInfoBattery;

  /// No description provided for @bfDeviceInfoBatteryPresent.
  ///
  /// In en, this message translates to:
  /// **'present'**
  String get bfDeviceInfoBatteryPresent;

  /// No description provided for @bfDeviceInfoBatteryAbsent.
  ///
  /// In en, this message translates to:
  /// **'absent'**
  String get bfDeviceInfoBatteryAbsent;

  /// No description provided for @bfDeviceInfoDeviceClock.
  ///
  /// In en, this message translates to:
  /// **'Device clock'**
  String get bfDeviceInfoDeviceClock;

  /// No description provided for @bfDeviceInfoLogs.
  ///
  /// In en, this message translates to:
  /// **'Device logs'**
  String get bfDeviceInfoLogs;

  /// No description provided for @bfDeviceInfoLogsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'logs.get, boot, error, timer, API events'**
  String get bfDeviceInfoLogsSubtitle;

  /// No description provided for @bfDeviceInfoEvents.
  ///
  /// In en, this message translates to:
  /// **'Event history'**
  String get bfDeviceInfoEvents;

  /// No description provided for @bfDeviceInfoEventsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Local · timer, face change, API triggers'**
  String get bfDeviceInfoEventsSubtitle;

  /// No description provided for @bfDeviceInfoUserGuide.
  ///
  /// In en, this message translates to:
  /// **'User guide'**
  String get bfDeviceInfoUserGuide;

  /// No description provided for @bfDeviceInfoUserGuideSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Face assignment, timer, API triggers'**
  String get bfDeviceInfoUserGuideSubtitle;

  /// No description provided for @bfDeviceInfoDevNotes.
  ///
  /// In en, this message translates to:
  /// **'SK developer notes'**
  String get bfDeviceInfoDevNotes;

  /// No description provided for @bfDeviceInfoDevNotesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'CLI commands, architecture, event taxonomy'**
  String get bfDeviceInfoDevNotesSubtitle;

  /// No description provided for @bfDeviceInfoLicense.
  ///
  /// In en, this message translates to:
  /// **'License & open sources'**
  String get bfDeviceInfoLicense;

  /// No description provided for @bfDeviceInfoLicenseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Libraries used and copyright information'**
  String get bfDeviceInfoLicenseSubtitle;

  /// No description provided for @bfDeviceInfoComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get bfDeviceInfoComingSoon;

  /// No description provided for @bfDeviceInfoUptimeSecs.
  ///
  /// In en, this message translates to:
  /// **'{n} s'**
  String bfDeviceInfoUptimeSecs(int n);

  /// No description provided for @bfDeviceInfoUptimeMins.
  ///
  /// In en, this message translates to:
  /// **'{n} min'**
  String bfDeviceInfoUptimeMins(int n);

  /// No description provided for @bfDeviceInfoUptimeHours.
  ///
  /// In en, this message translates to:
  /// **'{h} h {m} min'**
  String bfDeviceInfoUptimeHours(int h, int m);

  /// No description provided for @bfDeviceInfoUptimeDays.
  ///
  /// In en, this message translates to:
  /// **'{d} d {h} h'**
  String bfDeviceInfoUptimeDays(int d, int h);

  /// No description provided for @bfDeviceInfoYes.
  ///
  /// In en, this message translates to:
  /// **'yes'**
  String get bfDeviceInfoYes;

  /// No description provided for @bfDeviceInfoNo.
  ///
  /// In en, this message translates to:
  /// **'no'**
  String get bfDeviceInfoNo;

  /// No description provided for @bfSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get bfSettingsTitle;

  /// No description provided for @bfSettingsSectionNetwork.
  ///
  /// In en, this message translates to:
  /// **'NETWORK'**
  String get bfSettingsSectionNetwork;

  /// No description provided for @bfSettingsSectionUpdates.
  ///
  /// In en, this message translates to:
  /// **'UPDATES'**
  String get bfSettingsSectionUpdates;

  /// No description provided for @bfSettingsSectionDanger.
  ///
  /// In en, this message translates to:
  /// **'DANGER ZONE'**
  String get bfSettingsSectionDanger;

  /// No description provided for @bfSettingsWifiPrimary.
  ///
  /// In en, this message translates to:
  /// **'Primary WiFi'**
  String get bfSettingsWifiPrimary;

  /// No description provided for @bfSettingsWifiSecondary.
  ///
  /// In en, this message translates to:
  /// **'Backup WiFi'**
  String get bfSettingsWifiSecondary;

  /// No description provided for @bfSettingsWifiUnconfigured.
  ///
  /// In en, this message translates to:
  /// **'Not configured'**
  String get bfSettingsWifiUnconfigured;

  /// No description provided for @bfSettingsFirmware.
  ///
  /// In en, this message translates to:
  /// **'Firmware'**
  String get bfSettingsFirmware;

  /// No description provided for @bfSettingsCheckUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check for updates'**
  String get bfSettingsCheckUpdates;

  /// No description provided for @bfSettingsCheckUpdatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Activates once a manifest URL is set'**
  String get bfSettingsCheckUpdatesSubtitle;

  /// No description provided for @bfOtaTitle.
  ///
  /// In en, this message translates to:
  /// **'Firmware update'**
  String get bfOtaTitle;

  /// No description provided for @bfOtaCurrentLabel.
  ///
  /// In en, this message translates to:
  /// **'Installed version'**
  String get bfOtaCurrentLabel;

  /// No description provided for @bfOtaRunningPartitionLabel.
  ///
  /// In en, this message translates to:
  /// **'Active partition'**
  String get bfOtaRunningPartitionLabel;

  /// No description provided for @bfOtaCheckCta.
  ///
  /// In en, this message translates to:
  /// **'Check for updates'**
  String get bfOtaCheckCta;

  /// No description provided for @bfOtaIdleHint.
  ///
  /// In en, this message translates to:
  /// **'No update check has run yet.'**
  String get bfOtaIdleHint;

  /// No description provided for @bfOtaChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking the update server…'**
  String get bfOtaChecking;

  /// No description provided for @bfOtaUpToDate.
  ///
  /// In en, this message translates to:
  /// **'The device is up to date.'**
  String get bfOtaUpToDate;

  /// No description provided for @bfOtaAvailable.
  ///
  /// In en, this message translates to:
  /// **'New version available: {version}'**
  String bfOtaAvailable(String version);

  /// No description provided for @bfOtaUpdateCta.
  ///
  /// In en, this message translates to:
  /// **'Update now'**
  String get bfOtaUpdateCta;

  /// No description provided for @bfOtaDownloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading… %{pct}'**
  String bfOtaDownloading(int pct);

  /// No description provided for @bfOtaDone.
  ///
  /// In en, this message translates to:
  /// **'Updated. The device is rebooting…'**
  String get bfOtaDone;

  /// No description provided for @bfOtaErrorMsg.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String bfOtaErrorMsg(String message);

  /// No description provided for @bfOtaRollbackCta.
  ///
  /// In en, this message translates to:
  /// **'Roll back to previous version'**
  String get bfOtaRollbackCta;

  /// No description provided for @bfOtaUpdateConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Install firmware update?'**
  String get bfOtaUpdateConfirmTitle;

  /// No description provided for @bfOtaUpdateConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Version {version} will be downloaded and installed, then the device reboots. Do not power it off during the update.'**
  String bfOtaUpdateConfirmBody(String version);

  /// No description provided for @bfOtaRollbackConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Roll back firmware?'**
  String get bfOtaRollbackConfirmTitle;

  /// No description provided for @bfOtaRollbackConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'The device will boot the previous firmware and restart.'**
  String get bfOtaRollbackConfirmBody;

  /// No description provided for @bfSettingsReboot.
  ///
  /// In en, this message translates to:
  /// **'Restart device'**
  String get bfSettingsReboot;

  /// No description provided for @bfSettingsRebootSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Power-cycles the device · cancels any active timer'**
  String get bfSettingsRebootSubtitle;

  /// No description provided for @bfSettingsRebootConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Restart device?'**
  String get bfSettingsRebootConfirmTitle;

  /// No description provided for @bfSettingsRebootConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'The device will turn off and back on in a few seconds.'**
  String get bfSettingsRebootConfirmBody;

  /// No description provided for @bfSettingsUnpairThisPhone.
  ///
  /// In en, this message translates to:
  /// **'Unpair this phone'**
  String get bfSettingsUnpairThisPhone;

  /// No description provided for @bfSettingsUnpairSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Removes the bond · the device must be paired again'**
  String get bfSettingsUnpairSubtitle;

  /// No description provided for @bfSettingsUnpairConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Unpair this phone?'**
  String get bfSettingsUnpairConfirmTitle;

  /// No description provided for @bfSettingsFactoryReset.
  ///
  /// In en, this message translates to:
  /// **'Factory reset'**
  String get bfSettingsFactoryReset;

  /// No description provided for @bfSettingsFactoryResetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Wipes WiFi, API endpoints and pairings'**
  String get bfSettingsFactoryResetSubtitle;

  /// No description provided for @bfSettingsFactoryResetConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Factory reset?'**
  String get bfSettingsFactoryResetConfirmTitle;

  /// No description provided for @bfSettingsFactoryResetConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'All settings will be cleared. The device will reboot.'**
  String get bfSettingsFactoryResetConfirmBody;

  /// No description provided for @bfWifiManagementTitle.
  ///
  /// In en, this message translates to:
  /// **'WiFi management'**
  String get bfWifiManagementTitle;

  /// No description provided for @bfWifiConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get bfWifiConnecting;

  /// No description provided for @bfWifiConnectionRejected.
  ///
  /// In en, this message translates to:
  /// **'Connection rejected: {error}'**
  String bfWifiConnectionRejected(String error);

  /// No description provided for @bfWifiConfigure.
  ///
  /// In en, this message translates to:
  /// **'Configure {label}'**
  String bfWifiConfigure(String label);

  /// No description provided for @bfWifiPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get bfWifiPasswordLabel;

  /// No description provided for @bfNotebookTitle.
  ///
  /// In en, this message translates to:
  /// **'User Notebook'**
  String get bfNotebookTitle;

  /// No description provided for @bfNotebookSaveCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get bfNotebookSaveCancel;

  /// No description provided for @bfApiChainCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get bfApiChainCancel;

  /// No description provided for @bfApiChainRunChain.
  ///
  /// In en, this message translates to:
  /// **'Run chain'**
  String get bfApiChainRunChain;

  /// No description provided for @bfApiChainToggleAll.
  ///
  /// In en, this message translates to:
  /// **'Enable/disable all'**
  String get bfApiChainToggleAll;

  /// No description provided for @bfApiChainFieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get bfApiChainFieldName;

  /// No description provided for @bfApiChainFieldType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get bfApiChainFieldType;

  /// No description provided for @bfApiChainFieldHeaderName.
  ///
  /// In en, this message translates to:
  /// **'Header name'**
  String get bfApiChainFieldHeaderName;

  /// No description provided for @bfApiChainFieldNewToken.
  ///
  /// In en, this message translates to:
  /// **'New token (leave blank to keep)'**
  String get bfApiChainFieldNewToken;

  /// No description provided for @bfHomeLoadingConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting to device…'**
  String get bfHomeLoadingConnecting;

  /// No description provided for @bfHomeLoadingSecure.
  ///
  /// In en, this message translates to:
  /// **'Opening secure channel…'**
  String get bfHomeLoadingSecure;

  /// No description provided for @deviceConnUnreachableTitle.
  ///
  /// In en, this message translates to:
  /// **'Can\'t reach the device'**
  String get deviceConnUnreachableTitle;

  /// No description provided for @deviceConnUnreachableBody.
  ///
  /// In en, this message translates to:
  /// **'The device may be off, out of range, or asleep. Make sure it is powered on and nearby, then try again.'**
  String get deviceConnUnreachableBody;

  /// No description provided for @deviceConnRepairTitle.
  ///
  /// In en, this message translates to:
  /// **'Pairing needs to be renewed'**
  String get deviceConnRepairTitle;

  /// No description provided for @deviceConnRepairBody.
  ///
  /// In en, this message translates to:
  /// **'The device looks like it was reset and no longer recognises this phone. Pair with it again to reconnect.'**
  String get deviceConnRepairBody;

  /// No description provided for @deviceConnRepairButton.
  ///
  /// In en, this message translates to:
  /// **'Pair again'**
  String get deviceConnRepairButton;

  /// No description provided for @deviceConnTechnicalDetails.
  ///
  /// In en, this message translates to:
  /// **'Technical details'**
  String get deviceConnTechnicalDetails;

  /// No description provided for @bfLogsTitle.
  ///
  /// In en, this message translates to:
  /// **'Device logs'**
  String get bfLogsTitle;

  /// No description provided for @bfEventsTitle.
  ///
  /// In en, this message translates to:
  /// **'Event history'**
  String get bfEventsTitle;

  /// No description provided for @pairingStepConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting'**
  String get pairingStepConnecting;

  /// No description provided for @pairingStepConnectingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'BLE link + GATT discovery'**
  String get pairingStepConnectingSubtitle;

  /// No description provided for @pairingStepMutualAuth.
  ///
  /// In en, this message translates to:
  /// **'Mutual authentication'**
  String get pairingStepMutualAuth;

  /// No description provided for @pairingStepDeviceInfo.
  ///
  /// In en, this message translates to:
  /// **'device.info verification'**
  String get pairingStepDeviceInfo;

  /// No description provided for @pairingStepDeviceInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Encrypted channel up, sanity ping'**
  String get pairingStepDeviceInfoSubtitle;

  /// No description provided for @pairingStepConnected.
  ///
  /// In en, this message translates to:
  /// **'Connection established'**
  String get pairingStepConnected;

  /// No description provided for @pairingStepConnectedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'CLI ready, moving to setup'**
  String get pairingStepConnectedSubtitle;

  /// No description provided for @pairingStepKeyExchange.
  ///
  /// In en, this message translates to:
  /// **'Key exchange'**
  String get pairingStepKeyExchange;

  /// No description provided for @pairingStepKeyExchangeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'X25519, public key sent'**
  String get pairingStepKeyExchangeSubtitle;

  /// No description provided for @pairingStepVerifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying'**
  String get pairingStepVerifying;

  /// No description provided for @pairingStepVerifyingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Waiting for device, deriving token'**
  String get pairingStepVerifyingSubtitle;

  /// No description provided for @pairingStepDone.
  ///
  /// In en, this message translates to:
  /// **'Pairing complete'**
  String get pairingStepDone;

  /// No description provided for @pairingStepDoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Bond stored on device and phone'**
  String get pairingStepDoneSubtitle;

  /// No description provided for @pairingLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Pairing log'**
  String get pairingLogTitle;

  /// No description provided for @pairingLogCopied.
  ///
  /// In en, this message translates to:
  /// **'Log copied to clipboard'**
  String get pairingLogCopied;

  /// No description provided for @discoveryPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing…'**
  String get discoveryPreparing;

  /// No description provided for @discoveryBluetoothOff.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth is off'**
  String get discoveryBluetoothOff;

  /// No description provided for @wifiPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect device to WiFi'**
  String get wifiPasswordTitle;

  /// No description provided for @wifiPasswordSsidLabel.
  ///
  /// In en, this message translates to:
  /// **'Network name (SSID)'**
  String get wifiPasswordSsidLabel;

  /// No description provided for @wifiPasswordNetworkLabel.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get wifiPasswordNetworkLabel;

  /// No description provided for @wifiPasswordPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get wifiPasswordPasswordLabel;

  /// No description provided for @wifiPasswordConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get wifiPasswordConnect;

  /// No description provided for @wifiPasswordLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Connection log'**
  String get wifiPasswordLogTitle;

  /// No description provided for @wifiPasswordLogCopied.
  ///
  /// In en, this message translates to:
  /// **'Log copied to clipboard'**
  String get wifiPasswordLogCopied;

  /// No description provided for @wifiScanTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a WiFi network for the device'**
  String get wifiScanTitle;

  /// No description provided for @wifiScanRescanTooltip.
  ///
  /// In en, this message translates to:
  /// **'Tell the device to scan again'**
  String get wifiScanRescanTooltip;

  /// No description provided for @wifiScanRunning.
  ///
  /// In en, this message translates to:
  /// **'Device\'s WiFi scanner is running…'**
  String get wifiScanRunning;

  /// No description provided for @wifiScanNoNetworks.
  ///
  /// In en, this message translates to:
  /// **'Device couldn\'t find any nearby WiFi.'**
  String get wifiScanNoNetworks;

  /// No description provided for @wifiScanRescan.
  ///
  /// In en, this message translates to:
  /// **'Tell the device to scan again'**
  String get wifiScanRescan;

  /// No description provided for @wifiScanHiddenAdd.
  ///
  /// In en, this message translates to:
  /// **'Add hidden network'**
  String get wifiScanHiddenAdd;

  /// No description provided for @wifiScanHiddenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Type the SSID by hand'**
  String get wifiScanHiddenSubtitle;

  /// No description provided for @wifiScanLogTitle.
  ///
  /// In en, this message translates to:
  /// **'WiFi scan log'**
  String get wifiScanLogTitle;

  /// No description provided for @wifiSuccessReady.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get wifiSuccessReady;

  /// No description provided for @bfEventsClearTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get bfEventsClearTooltip;

  /// No description provided for @bfEventsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No events yet. They\'ll appear here once the device starts publishing.'**
  String get bfEventsEmpty;

  /// No description provided for @logsEmptyTooltip.
  ///
  /// In en, this message translates to:
  /// **'Log is empty.'**
  String get logsEmptyTooltip;

  /// No description provided for @logsErrorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String logsErrorPrefix(String error);

  /// No description provided for @notebookSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get notebookSaved;

  /// No description provided for @notebookSaveError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String notebookSaveError(String error);

  /// No description provided for @notebookCapacityExceeded.
  ///
  /// In en, this message translates to:
  /// **'Capacity exceeded: {used} / {capacity} bytes'**
  String notebookCapacityExceeded(int used, int capacity);

  /// No description provided for @notebookClearTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear notebook'**
  String get notebookClearTooltip;

  /// No description provided for @notebookClearConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear the entire notebook?'**
  String get notebookClearConfirmTitle;

  /// No description provided for @notebookClearConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'All user data on the device will be erased. Cannot be undone.'**
  String get notebookClearConfirmBody;

  /// No description provided for @notebookClearAction.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get notebookClearAction;

  /// No description provided for @notebookClearedSnack.
  ///
  /// In en, this message translates to:
  /// **'Notebook cleared'**
  String get notebookClearedSnack;

  /// No description provided for @notebookClearError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t clear: {error}'**
  String notebookClearError(String error);

  /// No description provided for @notebookEncryptedHint.
  ///
  /// In en, this message translates to:
  /// **'Encrypted area · only the paired SKAPP can read it'**
  String get notebookEncryptedHint;

  /// No description provided for @notebookEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Notebook is empty'**
  String get notebookEmptyTitle;

  /// No description provided for @notebookEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Type notes, JSON, scene definitions or any other text below. Tapping Save stores it encrypted on the device.'**
  String get notebookEmptyBody;

  /// No description provided for @notebookHint.
  ///
  /// In en, this message translates to:
  /// **'Type whatever you want here (notes, JSON, your own schema). Up to 100 KB stored on the device.'**
  String get notebookHint;

  /// No description provided for @notebookDirty.
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes'**
  String get notebookDirty;

  /// No description provided for @notebookSaved2.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get notebookSaved2;

  /// No description provided for @notebookSyncedDifferent.
  ///
  /// In en, this message translates to:
  /// **'In sync'**
  String get notebookSyncedDifferent;

  /// No description provided for @notebookSaveCta.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get notebookSaveCta;

  /// No description provided for @wifiPairingHexErrorRaw.
  ///
  /// In en, this message translates to:
  /// **'our_pub hex decode failed: {error}'**
  String wifiPairingHexErrorRaw(String error);

  /// No description provided for @bfWifiForgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Forget slot?'**
  String get bfWifiForgetTitle;

  /// No description provided for @bfWifiForgetBody.
  ///
  /// In en, this message translates to:
  /// **'The slot will be wiped. If the device is currently connected here it will fall back to the other slot (if any). Reconfiguration is required to restore.'**
  String get bfWifiForgetBody;

  /// No description provided for @bfWifiForget.
  ///
  /// In en, this message translates to:
  /// **'Forget'**
  String get bfWifiForget;

  /// No description provided for @bfWifiHint.
  ///
  /// In en, this message translates to:
  /// **'The device tries the two networks in order: Primary first, Backup if it fails. The active slot is marked with a green dot.'**
  String get bfWifiHint;

  /// No description provided for @bfWifiActive.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get bfWifiActive;

  /// No description provided for @bfWifiNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Not configured'**
  String get bfWifiNotConfigured;

  /// No description provided for @bfWifiChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get bfWifiChange;

  /// No description provided for @bfWifiSetUp.
  ///
  /// In en, this message translates to:
  /// **'Set up'**
  String get bfWifiSetUp;

  /// No description provided for @discoveryStatusChecking.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth status check.'**
  String get discoveryStatusChecking;

  /// No description provided for @discoveryPermissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth permission required'**
  String get discoveryPermissionsTitle;

  /// No description provided for @discoveryPermissionsBody.
  ///
  /// In en, this message translates to:
  /// **'To find nearby SmartKraft devices, please enable the Bluetooth permission.'**
  String get discoveryPermissionsBody;

  /// No description provided for @discoveryPermissionsRetry.
  ///
  /// In en, this message translates to:
  /// **'Request permissions again'**
  String get discoveryPermissionsRetry;

  /// No description provided for @discoveryPermissionsOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get discoveryPermissionsOpenSettings;

  /// No description provided for @discoveryAdapterOffBody.
  ///
  /// In en, this message translates to:
  /// **'Turn Bluetooth on to scan for devices.'**
  String get discoveryAdapterOffBody;

  /// No description provided for @discoveryAdapterOffEnable.
  ///
  /// In en, this message translates to:
  /// **'Turn Bluetooth on'**
  String get discoveryAdapterOffEnable;

  /// No description provided for @discoveryUnsupportedTitle.
  ///
  /// In en, this message translates to:
  /// **'BLE not supported'**
  String get discoveryUnsupportedTitle;

  /// No description provided for @discoveryUnsupportedBody.
  ///
  /// In en, this message translates to:
  /// **'This device does not support Bluetooth Low Energy, SKAPP needs BLE to work.'**
  String get discoveryUnsupportedBody;

  /// No description provided for @wifiPasswordHelp.
  ///
  /// In en, this message translates to:
  /// **'The device will join this network. Enter the password, type it carefully.'**
  String get wifiPasswordHelp;

  /// No description provided for @wifiPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get wifiPasswordRequired;

  /// No description provided for @wifiPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get wifiPasswordMinLength;

  /// No description provided for @wifiPasswordSendError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send: {error}'**
  String wifiPasswordSendError(String error);

  /// No description provided for @wifiScanTimeoutHint.
  ///
  /// In en, this message translates to:
  /// **'If the scan takes too long the device may have lost WiFi reach. Tap retry.'**
  String get wifiScanTimeoutHint;

  /// No description provided for @wifiScanFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan failed'**
  String get wifiScanFailedTitle;

  /// No description provided for @wifiScanRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get wifiScanRetry;

  /// No description provided for @wifiSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get wifiSuccessTitle;

  /// No description provided for @wifiSuccessBody.
  ///
  /// In en, this message translates to:
  /// **'The device is on WiFi now. Returning to the dashboard…'**
  String get wifiSuccessBody;

  /// No description provided for @deviceNameSectionHeading.
  ///
  /// In en, this message translates to:
  /// **'DEVICE NAME (THIS APP ONLY)'**
  String get deviceNameSectionHeading;

  /// No description provided for @deviceNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom name'**
  String get deviceNameLabel;

  /// No description provided for @deviceNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Office BF'**
  String get deviceNameHint;

  /// No description provided for @deviceNameSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shown on cards in this SKAPP install. Not pushed to the device.'**
  String get deviceNameSubtitle;

  /// No description provided for @deviceNameClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get deviceNameClear;

  /// No description provided for @deviceNameSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get deviceNameSave;

  /// No description provided for @deviceNameSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get deviceNameSaved;

  /// No description provided for @deviceNameEmptyPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'(no custom name)'**
  String get deviceNameEmptyPlaceholder;

  /// No description provided for @settingsUsbConsoleTitle.
  ///
  /// In en, this message translates to:
  /// **'USB CLI console'**
  String get settingsUsbConsoleTitle;

  /// No description provided for @settingsUsbConsoleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Send raw commands to a USB-connected device'**
  String get settingsUsbConsoleSubtitle;

  /// No description provided for @usbConsoleAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'USB Console'**
  String get usbConsoleAppBarTitle;

  /// No description provided for @usbConsolePickPortTitle.
  ///
  /// In en, this message translates to:
  /// **'Select a port'**
  String get usbConsolePickPortTitle;

  /// No description provided for @usbConsolePickPortHint.
  ///
  /// In en, this message translates to:
  /// **'Plug a SmartKraft device via USB and tap refresh'**
  String get usbConsolePickPortHint;

  /// No description provided for @usbConsolePortRefreshTooltip.
  ///
  /// In en, this message translates to:
  /// **'Refresh ports'**
  String get usbConsolePortRefreshTooltip;

  /// No description provided for @usbConsoleBfBadge.
  ///
  /// In en, this message translates to:
  /// **'SmartKraft'**
  String get usbConsoleBfBadge;

  /// No description provided for @usbConsoleConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get usbConsoleConnecting;

  /// No description provided for @usbConsoleConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get usbConsoleConnected;

  /// No description provided for @usbConsoleDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get usbConsoleDisconnected;

  /// No description provided for @usbConsoleErrorBanner.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String usbConsoleErrorBanner(String error);

  /// No description provided for @usbConsoleReconnect.
  ///
  /// In en, this message translates to:
  /// **'Reconnect'**
  String get usbConsoleReconnect;

  /// No description provided for @usbConsoleDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get usbConsoleDisconnect;

  /// No description provided for @usbConsoleClear.
  ///
  /// In en, this message translates to:
  /// **'Clear console'**
  String get usbConsoleClear;

  /// No description provided for @usbConsoleInputHint.
  ///
  /// In en, this message translates to:
  /// **'Type a command, e.g. device.info'**
  String get usbConsoleInputHint;

  /// No description provided for @usbConsoleSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get usbConsoleSend;

  /// No description provided for @usbConsoleEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Type a command and press Enter, try device.info'**
  String get usbConsoleEmptyHint;

  /// No description provided for @usbConsoleEntryEvent.
  ///
  /// In en, this message translates to:
  /// **'evt'**
  String get usbConsoleEntryEvent;

  /// No description provided for @usbConsoleEntryError.
  ///
  /// In en, this message translates to:
  /// **'error'**
  String get usbConsoleEntryError;

  /// No description provided for @usbConsoleNotSupportedIos.
  ///
  /// In en, this message translates to:
  /// **'USB console is not supported on iOS'**
  String get usbConsoleNotSupportedIos;

  /// No description provided for @passphraseFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Passphrase'**
  String get passphraseFieldLabel;

  /// No description provided for @passphraseVerifyButton.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get passphraseVerifyButton;

  /// No description provided for @passphraseAttemptsLeft.
  ///
  /// In en, this message translates to:
  /// **'Attempts left: {count}'**
  String passphraseAttemptsLeft(int count);

  /// No description provided for @passphraseLockoutTriggered.
  ///
  /// In en, this message translates to:
  /// **'Too many wrong passphrase attempts; the device factory-reset itself.'**
  String get passphraseLockoutTriggered;

  /// No description provided for @bondPeerUnnamed.
  ///
  /// In en, this message translates to:
  /// **'(unnamed)'**
  String get bondPeerUnnamed;

  /// No description provided for @pairingPassphraseDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Device passphrase'**
  String get pairingPassphraseDialogTitle;

  /// No description provided for @pairingPassphraseDialogBody.
  ///
  /// In en, this message translates to:
  /// **'This device requires a passphrase for content access. Enter it to complete pairing.'**
  String get pairingPassphraseDialogBody;

  /// No description provided for @pairingPassphraseCancelled.
  ///
  /// In en, this message translates to:
  /// **'Passphrase not entered, pairing cancelled.'**
  String get pairingPassphraseCancelled;

  /// No description provided for @pairingPassphraseSendError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send passphrase: {error}'**
  String pairingPassphraseSendError(String error);

  /// No description provided for @pairingPassphraseTimeout.
  ///
  /// In en, this message translates to:
  /// **'Device didn\'t reply (passphrase verify, 8 s).'**
  String get pairingPassphraseTimeout;

  /// No description provided for @pairingWindowClosedRetry.
  ///
  /// In en, this message translates to:
  /// **'Pairing window closed, short-press the button and try again.'**
  String get pairingWindowClosedRetry;

  /// No description provided for @pairingPassphraseFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t verify passphrase: {error}'**
  String pairingPassphraseFailed(String error);

  /// No description provided for @bondStoreFullHeader.
  ///
  /// In en, this message translates to:
  /// **'All 8 bond slots are full. Remove an existing peer to pair a new SKAPP:'**
  String get bondStoreFullHeader;

  /// No description provided for @bondStoreFullPeerLine.
  ///
  /// In en, this message translates to:
  /// **'  • slot {slot}, {name} [#{shortPid}]'**
  String bondStoreFullPeerLine(Object slot, String name, String shortPid);

  /// No description provided for @bondStoreFullFooter.
  ///
  /// In en, this message translates to:
  /// **'From another paired SKAPP or via USB, run\n`bond.remove --slot N`, then tap Retry here.'**
  String get bondStoreFullFooter;

  /// No description provided for @passphraseGateDialogBody.
  ///
  /// In en, this message translates to:
  /// **'This device asks for the passphrase on every connection. Enter it to access content.'**
  String get passphraseGateDialogBody;

  /// No description provided for @passphraseGateCancelled.
  ///
  /// In en, this message translates to:
  /// **'Passphrase not entered, verification is required to access this screen.'**
  String get passphraseGateCancelled;

  /// No description provided for @passphraseGateVerifyError.
  ///
  /// In en, this message translates to:
  /// **'Verify error: {error}'**
  String passphraseGateVerifyError(String error);

  /// No description provided for @passphraseGateCommError.
  ///
  /// In en, this message translates to:
  /// **'Communication error: {error}'**
  String passphraseGateCommError(String error);

  /// No description provided for @passphraseGateUnknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown lock error.'**
  String get passphraseGateUnknownError;

  /// No description provided for @bfPassphraseTitle.
  ///
  /// In en, this message translates to:
  /// **'Device Passphrase'**
  String get bfPassphraseTitle;

  /// No description provided for @bfPassphraseSetTitle.
  ///
  /// In en, this message translates to:
  /// **'Set passphrase'**
  String get bfPassphraseSetTitle;

  /// No description provided for @bfPassphraseChangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Change passphrase'**
  String get bfPassphraseChangeTitle;

  /// No description provided for @bfPassphraseClearTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove passphrase'**
  String get bfPassphraseClearTitle;

  /// No description provided for @bfPassphraseChangeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the old passphrase, set the new one'**
  String get bfPassphraseChangeSubtitle;

  /// No description provided for @bfPassphraseClearSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reset the content lock on the device'**
  String get bfPassphraseClearSubtitle;

  /// No description provided for @bfPassphraseModePairing.
  ///
  /// In en, this message translates to:
  /// **'Ask during pairing'**
  String get bfPassphraseModePairing;

  /// No description provided for @bfPassphraseModePairingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Asks when a new SKAPP pairs. Existing peers aren\'t prompted.'**
  String get bfPassphraseModePairingSubtitle;

  /// No description provided for @bfPassphraseModeAlways.
  ///
  /// In en, this message translates to:
  /// **'Ask on every connection'**
  String get bfPassphraseModeAlways;

  /// No description provided for @bfPassphraseModeAlwaysSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Asks every time a session opens. Content stays locked even if a SKAPP is stolen.'**
  String get bfPassphraseModeAlwaysSubtitle;

  /// No description provided for @bfPassphraseStatusNone.
  ///
  /// In en, this message translates to:
  /// **'No passphrase, the device has no content lock'**
  String get bfPassphraseStatusNone;

  /// No description provided for @bfPassphraseStatusActiveOff.
  ///
  /// In en, this message translates to:
  /// **'Passphrase set · enforcement off (both toggles off)'**
  String get bfPassphraseStatusActiveOff;

  /// No description provided for @bfPassphraseStatusActivePairing.
  ///
  /// In en, this message translates to:
  /// **'Asked during pairing'**
  String get bfPassphraseStatusActivePairing;

  /// No description provided for @bfPassphraseStatusActiveAlways.
  ///
  /// In en, this message translates to:
  /// **'Asked on every connection'**
  String get bfPassphraseStatusActiveAlways;

  /// No description provided for @bfPassphraseBadgeActive.
  ///
  /// In en, this message translates to:
  /// **'Passphrase active'**
  String get bfPassphraseBadgeActive;

  /// No description provided for @bfPassphraseBadgeNone.
  ///
  /// In en, this message translates to:
  /// **'No passphrase'**
  String get bfPassphraseBadgeNone;

  /// No description provided for @bfPassphraseAttemptsRatio.
  ///
  /// In en, this message translates to:
  /// **'Attempts left: {left} / {total}'**
  String bfPassphraseAttemptsRatio(int left, int total);

  /// No description provided for @bfPassphraseLengthSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Length {min}-{max} characters'**
  String bfPassphraseLengthSubtitle(int min, int max);

  /// No description provided for @bfPassphraseLengthHint.
  ///
  /// In en, this message translates to:
  /// **'Length: {min}-{max}'**
  String bfPassphraseLengthHint(int min, int max);

  /// No description provided for @bfPassphraseTooShort.
  ///
  /// In en, this message translates to:
  /// **'At least {min} characters'**
  String bfPassphraseTooShort(int min);

  /// No description provided for @bfPassphraseTooLong.
  ///
  /// In en, this message translates to:
  /// **'At most {max} characters'**
  String bfPassphraseTooLong(int max);

  /// No description provided for @bfPassphraseEmpty.
  ///
  /// In en, this message translates to:
  /// **'Can\'t be empty'**
  String get bfPassphraseEmpty;

  /// No description provided for @bfPassphraseNewLabel.
  ///
  /// In en, this message translates to:
  /// **'New passphrase'**
  String get bfPassphraseNewLabel;

  /// No description provided for @bfPassphraseCurrentLabel.
  ///
  /// In en, this message translates to:
  /// **'Current passphrase'**
  String get bfPassphraseCurrentLabel;

  /// No description provided for @bfPassphraseSetDone.
  ///
  /// In en, this message translates to:
  /// **'Passphrase set'**
  String get bfPassphraseSetDone;

  /// No description provided for @bfPassphraseChangeDone.
  ///
  /// In en, this message translates to:
  /// **'Passphrase changed'**
  String get bfPassphraseChangeDone;

  /// No description provided for @bfPassphraseClearDone.
  ///
  /// In en, this message translates to:
  /// **'Passphrase removed'**
  String get bfPassphraseClearDone;

  /// No description provided for @bfPassphraseStatusReadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t read status: {error}'**
  String bfPassphraseStatusReadError(String error);

  /// No description provided for @bfPassphraseNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get bfPassphraseNotesTitle;

  /// No description provided for @bfPassphraseNotesBody.
  ///
  /// In en, this message translates to:
  /// **'• The passphrase is hashed on-device with PBKDF2-SHA256; it is never stored in plaintext.\n• 10 wrong attempts factory-reset the device; all bonds and data are wiped.\n• A USB-connected device skips the passphrase prompt, physical access already grants factory-reset via the button.'**
  String get bfPassphraseNotesBody;

  /// No description provided for @bfBondListTitle.
  ///
  /// In en, this message translates to:
  /// **'Paired SKAPPs  ({used}/{capacity})'**
  String bfBondListTitle(int used, int capacity);

  /// No description provided for @bfBondListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No paired peers yet.'**
  String get bfBondListEmpty;

  /// No description provided for @bfBondListBadgeThisPhone.
  ///
  /// In en, this message translates to:
  /// **'This phone'**
  String get bfBondListBadgeThisPhone;

  /// No description provided for @bfBondListBadgeActiveSession.
  ///
  /// In en, this message translates to:
  /// **'Active session'**
  String get bfBondListBadgeActiveSession;

  /// No description provided for @bfBondListRowSubtitle.
  ///
  /// In en, this message translates to:
  /// **'#{shortPid} · paired: {date}'**
  String bfBondListRowSubtitle(String shortPid, String date);

  /// No description provided for @bfBondListRemoveTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove this peer'**
  String get bfBondListRemoveTooltip;

  /// No description provided for @bfBondListRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove peer?'**
  String get bfBondListRemoveTitle;

  /// No description provided for @bfBondListRemoveSelfBody.
  ///
  /// In en, this message translates to:
  /// **'You\'re removing this phone\'s bond. If you confirm, the session drops; to reach the device again you\'ll need to short-press the button and re-pair.'**
  String get bfBondListRemoveSelfBody;

  /// No description provided for @bfBondListRemoveOtherBody.
  ///
  /// In en, this message translates to:
  /// **'\"{label}\" (slot {slot}) is wiped from the device. That SKAPP must short-press the button and re-pair to reconnect.'**
  String bfBondListRemoveOtherBody(String label, int slot);

  /// No description provided for @bfBondListSlotRemoved.
  ///
  /// In en, this message translates to:
  /// **'Slot {slot} removed'**
  String bfBondListSlotRemoved(int slot);

  /// No description provided for @bfBondListFetchError.
  ///
  /// In en, this message translates to:
  /// **'bond.list failed: {error}'**
  String bfBondListFetchError(String error);

  /// No description provided for @bfSettingsSectionSecurity.
  ///
  /// In en, this message translates to:
  /// **'SECURITY'**
  String get bfSettingsSectionSecurity;

  /// No description provided for @bfSettingsPassphraseTitle.
  ///
  /// In en, this message translates to:
  /// **'Device passphrase'**
  String get bfSettingsPassphraseTitle;

  /// No description provided for @bfSettingsBondListTitle.
  ///
  /// In en, this message translates to:
  /// **'Paired SKAPPs'**
  String get bfSettingsBondListTitle;

  /// No description provided for @bfSettingsPassphraseSubtitleAlways.
  ///
  /// In en, this message translates to:
  /// **'Active, every connection'**
  String get bfSettingsPassphraseSubtitleAlways;

  /// No description provided for @bfSettingsPassphraseSubtitlePairing.
  ///
  /// In en, this message translates to:
  /// **'Active, at pairing'**
  String get bfSettingsPassphraseSubtitlePairing;

  /// No description provided for @bfSettingsPassphraseSubtitleOff.
  ///
  /// In en, this message translates to:
  /// **'Active, enforcement off'**
  String get bfSettingsPassphraseSubtitleOff;

  /// No description provided for @bfSettingsBondsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Paired peers: {count} / {capacity}'**
  String bfSettingsBondsSubtitle(int count, int capacity);

  /// No description provided for @skapiHowItWorksTitle.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get skapiHowItWorksTitle;

  /// No description provided for @skapiHowItWorksBody.
  ///
  /// In en, this message translates to:
  /// **'When your SmartKraft device (for example {deviceName}) experiences an event such as a timer ending, a button press, or a sensor trigger, it sends a small command to your computer. Your computer receives that command and runs the script you have chosen.'**
  String skapiHowItWorksBody(String deviceName);

  /// No description provided for @skapiHowItWorksFlowDeviceLabel.
  ///
  /// In en, this message translates to:
  /// **'SmartKraft Device'**
  String get skapiHowItWorksFlowDeviceLabel;

  /// No description provided for @skapiHowItWorksFlowDeviceSub.
  ///
  /// In en, this message translates to:
  /// **'e.g. Blocking Focus, triggers an event'**
  String get skapiHowItWorksFlowDeviceSub;

  /// No description provided for @skapiHowItWorksFlowComputerLabel.
  ///
  /// In en, this message translates to:
  /// **'Computer'**
  String get skapiHowItWorksFlowComputerLabel;

  /// No description provided for @skapiHowItWorksFlowComputerSub.
  ///
  /// In en, this message translates to:
  /// **'SKAPP receives the command, the script runs'**
  String get skapiHowItWorksFlowComputerSub;

  /// No description provided for @skapiHowItWorksFoot.
  ///
  /// In en, this message translates to:
  /// **'SKAPP must be running on your computer. All traffic stays on the WiFi network, no internet connection is required, and no data leaves your home.'**
  String get skapiHowItWorksFoot;

  /// No description provided for @skapiPlatformGroupsHeader.
  ///
  /// In en, this message translates to:
  /// **'Action Categories'**
  String get skapiPlatformGroupsHeader;

  /// No description provided for @skapiPlatformGroupsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load groups: {error}'**
  String skapiPlatformGroupsLoadError(String error);

  /// No description provided for @skapiPlatformEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No scripts here yet'**
  String get skapiPlatformEmptyTitle;

  /// No description provided for @skapiPlatformEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Scripts for this platform are still on the way. Check back after the next SKAPP update.'**
  String get skapiPlatformEmptyBody;

  /// No description provided for @skapiGroupScriptsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load scripts: {error}'**
  String skapiGroupScriptsLoadError(String error);

  /// No description provided for @skapiScriptDetailLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load this script: {error}'**
  String skapiScriptDetailLoadError(String error);

  /// No description provided for @skapiBindScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Bind to Action'**
  String get skapiBindScreenTitle;

  /// No description provided for @skapiBindScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Run this script automatically when a device event fires.'**
  String get skapiBindScreenSubtitle;

  /// No description provided for @skapiBindFieldDeviceLabel.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get skapiBindFieldDeviceLabel;

  /// No description provided for @skapiBindFieldDeviceHint.
  ///
  /// In en, this message translates to:
  /// **'Pick which paired device should fire this script.'**
  String get skapiBindFieldDeviceHint;

  /// No description provided for @skapiBindFieldDeviceEmpty.
  ///
  /// In en, this message translates to:
  /// **'No paired devices yet. Pair one from the Devices tab first.'**
  String get skapiBindFieldDeviceEmpty;

  /// No description provided for @skapiBindFieldEventLabel.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get skapiBindFieldEventLabel;

  /// No description provided for @skapiBindFieldEventHint.
  ///
  /// In en, this message translates to:
  /// **'The device emits this event; the script runs when it does.'**
  String get skapiBindFieldEventHint;

  /// No description provided for @skapiBindEventTimerStarted.
  ///
  /// In en, this message translates to:
  /// **'Timer started'**
  String get skapiBindEventTimerStarted;

  /// No description provided for @skapiBindEventTimerExpired.
  ///
  /// In en, this message translates to:
  /// **'Timer expired'**
  String get skapiBindEventTimerExpired;

  /// No description provided for @skapiBindEventFaceChanged.
  ///
  /// In en, this message translates to:
  /// **'Cube face changed'**
  String get skapiBindEventFaceChanged;

  /// No description provided for @skapiBindEventButtonPressed.
  ///
  /// In en, this message translates to:
  /// **'Button pressed'**
  String get skapiBindEventButtonPressed;

  /// No description provided for @skapiBindEventButtonHeld.
  ///
  /// In en, this message translates to:
  /// **'Button held'**
  String get skapiBindEventButtonHeld;

  /// No description provided for @skapiBindEventBatteryLow.
  ///
  /// In en, this message translates to:
  /// **'Battery low'**
  String get skapiBindEventBatteryLow;

  /// No description provided for @skapiBindEventBatteryLockout.
  ///
  /// In en, this message translates to:
  /// **'Battery lockout'**
  String get skapiBindEventBatteryLockout;

  /// No description provided for @skapiBindEventPowerStateChanged.
  ///
  /// In en, this message translates to:
  /// **'Power state changed'**
  String get skapiBindEventPowerStateChanged;

  /// No description provided for @skapiBindEventPairingSuccess.
  ///
  /// In en, this message translates to:
  /// **'Pairing succeeded'**
  String get skapiBindEventPairingSuccess;

  /// No description provided for @skapiBindEventApiSent.
  ///
  /// In en, this message translates to:
  /// **'API call sent'**
  String get skapiBindEventApiSent;

  /// No description provided for @skapiBindParamsHeader.
  ///
  /// In en, this message translates to:
  /// **'Parameter overrides'**
  String get skapiBindParamsHeader;

  /// No description provided for @skapiBindParamsHint.
  ///
  /// In en, this message translates to:
  /// **'Leave empty to keep the script defaults. These values are sent every time the binding fires.'**
  String get skapiBindParamsHint;

  /// No description provided for @skapiBindButtonSave.
  ///
  /// In en, this message translates to:
  /// **'Save binding'**
  String get skapiBindButtonSave;

  /// No description provided for @skapiBindButtonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete binding'**
  String get skapiBindButtonDelete;

  /// No description provided for @skapiBindButtonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get skapiBindButtonCancel;

  /// No description provided for @skapiBindButtonEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get skapiBindButtonEnable;

  /// No description provided for @skapiBindButtonDisable.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get skapiBindButtonDisable;

  /// No description provided for @skapiBindStatusEnabled.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get skapiBindStatusEnabled;

  /// No description provided for @skapiBindStatusDisabled.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get skapiBindStatusDisabled;

  /// No description provided for @skapiBindSavedToast.
  ///
  /// In en, this message translates to:
  /// **'Binding saved'**
  String get skapiBindSavedToast;

  /// No description provided for @skapiBindDeletedToast.
  ///
  /// In en, this message translates to:
  /// **'Binding removed'**
  String get skapiBindDeletedToast;

  /// No description provided for @skapiBindBadgeCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 binding} other{{count} bindings}}'**
  String skapiBindBadgeCount(int count);

  /// No description provided for @skapiBindNoPairedDeviceWarning.
  ///
  /// In en, this message translates to:
  /// **'Pair a device first to create bindings.'**
  String get skapiBindNoPairedDeviceWarning;

  /// No description provided for @skapiBindTriggeredDesktopToast.
  ///
  /// In en, this message translates to:
  /// **'Triggered: {script}'**
  String skapiBindTriggeredDesktopToast(String script);

  /// No description provided for @skapiBindTriggeredMobileToast.
  ///
  /// In en, this message translates to:
  /// **'Bind fired ({event}); execution arrives in Phase K.'**
  String skapiBindTriggeredMobileToast(String event);

  /// No description provided for @skapiBindLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load bindings: {error}'**
  String skapiBindLoadError(String error);

  /// No description provided for @skapiBindListSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Bindings on this script'**
  String get skapiBindListSectionTitle;

  /// No description provided for @skapiBindListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No bindings yet. Tap Bind to Action to create one.'**
  String get skapiBindListEmpty;

  /// No description provided for @skapiBindNewButton.
  ///
  /// In en, this message translates to:
  /// **'New binding'**
  String get skapiBindNewButton;

  /// No description provided for @skapiBasicSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get skapiBasicSettingsTitle;

  /// No description provided for @skapiBasicEmptyParams.
  ///
  /// In en, this message translates to:
  /// **'This script needs no settings. Tap Run Now.'**
  String get skapiBasicEmptyParams;

  /// No description provided for @skapiBasicUnitSeconds.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get skapiBasicUnitSeconds;

  /// No description provided for @skapiBasicConvHalfMinute.
  ///
  /// In en, this message translates to:
  /// **'half a minute'**
  String get skapiBasicConvHalfMinute;

  /// No description provided for @skapiBasicConvLessThanMinute.
  ///
  /// In en, this message translates to:
  /// **'less than a minute'**
  String get skapiBasicConvLessThanMinute;

  /// No description provided for @skapiBasicConvMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute} other{{count} minutes}}'**
  String skapiBasicConvMinutes(int count);

  /// No description provided for @skapiBasicConvHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String skapiBasicConvHoursMinutes(int hours, int minutes);

  /// No description provided for @skapiBasicConvHours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour} other{{count} hours}}'**
  String skapiBasicConvHours(int count);

  /// No description provided for @skapiBasicConvImmediate.
  ///
  /// In en, this message translates to:
  /// **'starts immediately'**
  String get skapiBasicConvImmediate;

  /// No description provided for @skapiBasicConvAfter.
  ///
  /// In en, this message translates to:
  /// **'after {time}'**
  String skapiBasicConvAfter(String time);

  /// No description provided for @skapiBasicPrerunSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Pre-run delay'**
  String get skapiBasicPrerunSectionTitle;

  /// No description provided for @skapiBasicPrerunAddCta.
  ///
  /// In en, this message translates to:
  /// **'Add delay before run'**
  String get skapiBasicPrerunAddCta;

  /// No description provided for @skapiBasicPrerunLabel.
  ///
  /// In en, this message translates to:
  /// **'Wait this many seconds before the script starts'**
  String get skapiBasicPrerunLabel;

  /// No description provided for @skapiBasicPrerunHelp.
  ///
  /// In en, this message translates to:
  /// **'Useful for letting a notification show first, or chaining actions. Default 0 means start immediately.'**
  String get skapiBasicPrerunHelp;

  /// No description provided for @skapiBasicPrerunRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove delay'**
  String get skapiBasicPrerunRemove;

  /// No description provided for @skapiBasicListAddPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'+ add'**
  String get skapiBasicListAddPlaceholder;

  /// No description provided for @skapiRunSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Run script'**
  String get skapiRunSheetTitle;

  /// No description provided for @skapiRunSheetStatusRunning.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get skapiRunSheetStatusRunning;

  /// No description provided for @skapiRunSheetStatusOk.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get skapiRunSheetStatusOk;

  /// No description provided for @skapiRunSheetStatusError.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get skapiRunSheetStatusError;

  /// No description provided for @skapiRunSheetExitCode.
  ///
  /// In en, this message translates to:
  /// **'Exit code: {code}'**
  String skapiRunSheetExitCode(int code);

  /// No description provided for @skapiRunSheetCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get skapiRunSheetCancel;

  /// No description provided for @skapiRunSheetClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get skapiRunSheetClose;

  /// No description provided for @skapiRunSheetCopyOutput.
  ///
  /// In en, this message translates to:
  /// **'Copy output'**
  String get skapiRunSheetCopyOutput;

  /// No description provided for @skapiRunSheetCopiedDone.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get skapiRunSheetCopiedDone;

  /// No description provided for @skapiRunSheetEmptyOutput.
  ///
  /// In en, this message translates to:
  /// **'Waiting for output...'**
  String get skapiRunSheetEmptyOutput;

  /// No description provided for @skapiRunSheetDismissConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Stop running script?'**
  String get skapiRunSheetDismissConfirmTitle;

  /// No description provided for @skapiRunSheetDismissConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'The script is still running. Closing this sheet will cancel it.'**
  String get skapiRunSheetDismissConfirmBody;

  /// No description provided for @skapiRunSheetDismissConfirmStay.
  ///
  /// In en, this message translates to:
  /// **'Keep running'**
  String get skapiRunSheetDismissConfirmStay;

  /// No description provided for @skapiRunSheetDismissConfirmStop.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get skapiRunSheetDismissConfirmStop;

  /// No description provided for @skapiRunErrorPowerShellMissing.
  ///
  /// In en, this message translates to:
  /// **'PowerShell was not found on this system.'**
  String get skapiRunErrorPowerShellMissing;

  /// No description provided for @skapiRunErrorTempWrite.
  ///
  /// In en, this message translates to:
  /// **'Could not write the script to the temp folder: {error}'**
  String skapiRunErrorTempWrite(String error);

  /// No description provided for @skapiRunErrorSpawn.
  ///
  /// In en, this message translates to:
  /// **'Could not start PowerShell: {error}'**
  String skapiRunErrorSpawn(String error);

  /// No description provided for @skapiRunDurationMs.
  ///
  /// In en, this message translates to:
  /// **'Took {ms} ms'**
  String skapiRunDurationMs(int ms);

  /// No description provided for @skapiCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get skapiCopiedToClipboard;

  /// No description provided for @skapiFavouriteAddTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add to favourites'**
  String get skapiFavouriteAddTooltip;

  /// No description provided for @skapiFavouriteRemoveTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove from favourites'**
  String get skapiFavouriteRemoveTooltip;

  /// No description provided for @skapiGroupAppBarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 script} other{{count} scripts}}'**
  String skapiGroupAppBarSubtitle(int count);

  /// No description provided for @skapiPlatformScreenCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Action Categories'**
  String get skapiPlatformScreenCategoriesTitle;

  /// No description provided for @skapiPlatformScreenCategoriesSub.
  ///
  /// In en, this message translates to:
  /// **'{groups} groups · {scripts} scripts total'**
  String skapiPlatformScreenCategoriesSub(int groups, int scripts);

  /// No description provided for @skapiGroupScriptsHeader.
  ///
  /// In en, this message translates to:
  /// **'Scripts'**
  String get skapiGroupScriptsHeader;

  /// No description provided for @skapiGroupScriptsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} scripts'**
  String skapiGroupScriptsCount(int count);

  /// No description provided for @skapiGroupItemCount.
  ///
  /// In en, this message translates to:
  /// **'{count} scripts'**
  String skapiGroupItemCount(int count);

  /// No description provided for @skapiGroupPowerTitle.
  ///
  /// In en, this message translates to:
  /// **'Power Management'**
  String get skapiGroupPowerTitle;

  /// No description provided for @skapiGroupPowerDesc.
  ///
  /// In en, this message translates to:
  /// **'Scripts in this group lock, sleep, hibernate, or shut down the computer. They are useful when a SmartKraft device signals the end of a focus session or detects extended idle time and you want the machine to follow suit.'**
  String get skapiGroupPowerDesc;

  /// No description provided for @skapiGroupPowerFoot.
  ///
  /// In en, this message translates to:
  /// **'Typical use: lock when you stand up, hibernate at the end of the day, scheduled shutdown after a long idle period.'**
  String get skapiGroupPowerFoot;

  /// No description provided for @skapiScriptLockTitle.
  ///
  /// In en, this message translates to:
  /// **'Lock Workstation'**
  String get skapiScriptLockTitle;

  /// No description provided for @skapiScriptLockSummaryWhat.
  ///
  /// In en, this message translates to:
  /// **'Locks Windows immediately and returns to the sign-in screen. Open apps keep running.'**
  String get skapiScriptLockSummaryWhat;

  /// No description provided for @skapiScriptLockSummaryHow.
  ///
  /// In en, this message translates to:
  /// **'Calls the user32 LockWorkStation Win32 function. Equivalent to pressing Win+L.'**
  String get skapiScriptLockSummaryHow;

  /// No description provided for @skapiScriptHibernateTitle.
  ///
  /// In en, this message translates to:
  /// **'Hibernate'**
  String get skapiScriptHibernateTitle;

  /// No description provided for @skapiScriptHibernateSummaryWhat.
  ///
  /// In en, this message translates to:
  /// **'Saves the current session to disk and powers the machine down. Resuming returns to where you left off, even with no battery.'**
  String get skapiScriptHibernateSummaryWhat;

  /// No description provided for @skapiScriptHibernateSummaryHow.
  ///
  /// In en, this message translates to:
  /// **'Runs the built-in shutdown.exe with the /h flag. Hibernation must be enabled in Windows power settings; if it is not, Windows falls back to sleep.'**
  String get skapiScriptHibernateSummaryHow;

  /// No description provided for @skapiScriptHibernateNote.
  ///
  /// In en, this message translates to:
  /// **'Run powercfg /hibernate on once from an admin shell if hibernate is missing on your system.'**
  String get skapiScriptHibernateNote;

  /// No description provided for @skapiScriptHibernateParamDelayLabel.
  ///
  /// In en, this message translates to:
  /// **'delay'**
  String get skapiScriptHibernateParamDelayLabel;

  /// No description provided for @skapiScriptHibernateParamDelayHint.
  ///
  /// In en, this message translates to:
  /// **'Seconds to wait before hibernating, in case the device\'s notification should appear first.'**
  String get skapiScriptHibernateParamDelayHint;

  /// No description provided for @skapiScriptSleepTitle.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get skapiScriptSleepTitle;

  /// No description provided for @skapiScriptSleepSummaryWhat.
  ///
  /// In en, this message translates to:
  /// **'Suspends the machine to RAM (S3). Resuming is fast but draws a small amount of battery while suspended.'**
  String get skapiScriptSleepSummaryWhat;

  /// No description provided for @skapiScriptSleepSummaryHow.
  ///
  /// In en, this message translates to:
  /// **'Calls System.Windows.Forms.Application.SetSuspendState with PowerState.Suspend. The OS may delay if a foreground process is blocking idle transitions.'**
  String get skapiScriptSleepSummaryHow;

  /// No description provided for @skapiScriptSleepParamDelayLabel.
  ///
  /// In en, this message translates to:
  /// **'delay'**
  String get skapiScriptSleepParamDelayLabel;

  /// No description provided for @skapiScriptSleepParamDelayHint.
  ///
  /// In en, this message translates to:
  /// **'Seconds to wait before sleeping.'**
  String get skapiScriptSleepParamDelayHint;

  /// No description provided for @skapiScriptShutdownTitle.
  ///
  /// In en, this message translates to:
  /// **'Shutdown'**
  String get skapiScriptShutdownTitle;

  /// No description provided for @skapiScriptShutdownSummaryWhat.
  ///
  /// In en, this message translates to:
  /// **'Initiates a graceful Windows shutdown. Open apps are asked to save and close.'**
  String get skapiScriptShutdownSummaryWhat;

  /// No description provided for @skapiScriptShutdownSummaryHow.
  ///
  /// In en, this message translates to:
  /// **'Runs the built-in shutdown.exe /s. With force enabled, /f is added so unresponsive apps are terminated.'**
  String get skapiScriptShutdownSummaryHow;

  /// No description provided for @skapiScriptShutdownNote.
  ///
  /// In en, this message translates to:
  /// **'A non-zero delay gives the user time to cancel via shutdown /a from a terminal.'**
  String get skapiScriptShutdownNote;

  /// No description provided for @skapiScriptShutdownParamDelayLabel.
  ///
  /// In en, this message translates to:
  /// **'delay'**
  String get skapiScriptShutdownParamDelayLabel;

  /// No description provided for @skapiScriptShutdownParamDelayHint.
  ///
  /// In en, this message translates to:
  /// **'Seconds Windows waits before powering down. 30 is the default; pick 0 for immediate shutdown.'**
  String get skapiScriptShutdownParamDelayHint;

  /// No description provided for @skapiScriptShutdownParamForceLabel.
  ///
  /// In en, this message translates to:
  /// **'force'**
  String get skapiScriptShutdownParamForceLabel;

  /// No description provided for @skapiScriptShutdownParamForceHint.
  ///
  /// In en, this message translates to:
  /// **'Closes apps that do not respond to the shutdown signal. Unsaved work in those apps may be lost.'**
  String get skapiScriptShutdownParamForceHint;

  /// No description provided for @skapiGroupDisplayAudioTitle.
  ///
  /// In en, this message translates to:
  /// **'Display, Image & Sound'**
  String get skapiGroupDisplayAudioTitle;

  /// No description provided for @skapiGroupDisplayAudioDesc.
  ///
  /// In en, this message translates to:
  /// **'Scripts in this group adjust the screen and audio output: brightness, volume, mute, and media playback. They are useful when a SmartKraft device wants the computer to dim during a focus break or pause music when you stand up.'**
  String get skapiGroupDisplayAudioDesc;

  /// No description provided for @skapiGroupDisplayAudioFoot.
  ///
  /// In en, this message translates to:
  /// **'Typical use: dim screen during a break, mute on lock, pause Spotify when a device detects no activity.'**
  String get skapiGroupDisplayAudioFoot;

  /// No description provided for @skapiScriptBrightnessTitle.
  ///
  /// In en, this message translates to:
  /// **'Set Brightness'**
  String get skapiScriptBrightnessTitle;

  /// No description provided for @skapiScriptBrightnessSummaryWhat.
  ///
  /// In en, this message translates to:
  /// **'Sets the brightness of the internal display to a percentage between 0 and 100.'**
  String get skapiScriptBrightnessSummaryWhat;

  /// No description provided for @skapiScriptBrightnessSummaryHow.
  ///
  /// In en, this message translates to:
  /// **'Calls the WMI WmiMonitorBrightnessMethods.WmiSetBrightness with the requested level. Only laptops, tablets, and built-in panels respond; external DDC/CI monitors are not supported on this path.'**
  String get skapiScriptBrightnessSummaryHow;

  /// No description provided for @skapiScriptBrightnessNote.
  ///
  /// In en, this message translates to:
  /// **'External monitors will not change. For multi-monitor setups, only the panel reporting brightness through WMI reacts.'**
  String get skapiScriptBrightnessNote;

  /// No description provided for @skapiScriptBrightnessParamLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'level'**
  String get skapiScriptBrightnessParamLevelLabel;

  /// No description provided for @skapiScriptBrightnessParamLevelHint.
  ///
  /// In en, this message translates to:
  /// **'Brightness percentage (0-100). Lower values are dimmer. 70 is a comfortable default in normal lighting.'**
  String get skapiScriptBrightnessParamLevelHint;

  /// No description provided for @skapiScriptBrightnessParamTimeoutLabel.
  ///
  /// In en, this message translates to:
  /// **'timeout'**
  String get skapiScriptBrightnessParamTimeoutLabel;

  /// No description provided for @skapiScriptBrightnessParamTimeoutHint.
  ///
  /// In en, this message translates to:
  /// **'Seconds the brightness change is allowed to take. The OS smoothly ramps within this window.'**
  String get skapiScriptBrightnessParamTimeoutHint;

  /// No description provided for @skapiScriptMuteToggleTitle.
  ///
  /// In en, this message translates to:
  /// **'Toggle Mute'**
  String get skapiScriptMuteToggleTitle;

  /// No description provided for @skapiScriptMuteToggleSummaryWhat.
  ///
  /// In en, this message translates to:
  /// **'Toggles the system master mute. Active media keeps playing but you do not hear it.'**
  String get skapiScriptMuteToggleSummaryWhat;

  /// No description provided for @skapiScriptMuteToggleSummaryHow.
  ///
  /// In en, this message translates to:
  /// **'Sends the VK_VOLUME_MUTE virtual key, the same path Windows uses when the user presses the mute key on a keyboard. No admin or COM dependency.'**
  String get skapiScriptMuteToggleSummaryHow;

  /// No description provided for @skapiScriptMuteToggleParamModeLabel.
  ///
  /// In en, this message translates to:
  /// **'mode'**
  String get skapiScriptMuteToggleParamModeLabel;

  /// No description provided for @skapiScriptMuteToggleParamModeHint.
  ///
  /// In en, this message translates to:
  /// **'toggle / on / off. Only toggle is enforced through the simple keystroke; on and off are accepted for forward compatibility.'**
  String get skapiScriptMuteToggleParamModeHint;

  /// No description provided for @skapiScriptVolumeSetTitle.
  ///
  /// In en, this message translates to:
  /// **'Set Volume'**
  String get skapiScriptVolumeSetTitle;

  /// No description provided for @skapiScriptVolumeSetSummaryWhat.
  ///
  /// In en, this message translates to:
  /// **'Sets the system master volume to a precise level between 0 and 100.'**
  String get skapiScriptVolumeSetSummaryWhat;

  /// No description provided for @skapiScriptVolumeSetSummaryHow.
  ///
  /// In en, this message translates to:
  /// **'Calls the Core Audio IAudioEndpointVolume.SetMasterVolumeLevelScalar through inline C# COM interop. Targets the default render endpoint.'**
  String get skapiScriptVolumeSetSummaryHow;

  /// No description provided for @skapiScriptVolumeSetNote.
  ///
  /// In en, this message translates to:
  /// **'Tier 2: works on standard Windows 10/11 desktops. Stripped-down installs may not expose the COM interface; per-app endpoints are not addressed by this path.'**
  String get skapiScriptVolumeSetNote;

  /// No description provided for @skapiScriptVolumeSetParamLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'level'**
  String get skapiScriptVolumeSetParamLevelLabel;

  /// No description provided for @skapiScriptVolumeSetParamLevelHint.
  ///
  /// In en, this message translates to:
  /// **'Volume percentage (0-100). 0 silences without setting mute; 50 is a comfortable default.'**
  String get skapiScriptVolumeSetParamLevelHint;

  /// No description provided for @skapiScriptMediaKeyTitle.
  ///
  /// In en, this message translates to:
  /// **'Media Key'**
  String get skapiScriptMediaKeyTitle;

  /// No description provided for @skapiScriptMediaKeySummaryWhat.
  ///
  /// In en, this message translates to:
  /// **'Simulates a media key press: play-pause, next, previous, or stop. Goes to whichever app currently owns the media session.'**
  String get skapiScriptMediaKeySummaryWhat;

  /// No description provided for @skapiScriptMediaKeySummaryHow.
  ///
  /// In en, this message translates to:
  /// **'Sends VK_MEDIA_PLAY_PAUSE / VK_MEDIA_NEXT_TRACK / VK_MEDIA_PREV_TRACK / VK_MEDIA_STOP through keybd_event. Windows routes the press through the System Media Transport Controls.'**
  String get skapiScriptMediaKeySummaryHow;

  /// No description provided for @skapiScriptMediaKeyNote.
  ///
  /// In en, this message translates to:
  /// **'Tier 2: needs an active media session. If no app is playing or the foreground app does not register with SMTC, the press is silently dropped.'**
  String get skapiScriptMediaKeyNote;

  /// No description provided for @skapiScriptMediaKeyParamKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'key'**
  String get skapiScriptMediaKeyParamKeyLabel;

  /// No description provided for @skapiScriptMediaKeyParamKeyHint.
  ///
  /// In en, this message translates to:
  /// **'play-pause / next / previous / stop. Default is play-pause.'**
  String get skapiScriptMediaKeyParamKeyHint;

  /// No description provided for @skapiGroupWindowAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Window & Application'**
  String get skapiGroupWindowAppTitle;

  /// No description provided for @skapiGroupWindowAppDesc.
  ///
  /// In en, this message translates to:
  /// **'Scripts in this group control windows and applications: minimise, focus, close gracefully, or kill processes outright. They keep your workspace tidy when a SmartKraft device wants the computer to switch context.'**
  String get skapiGroupWindowAppDesc;

  /// No description provided for @skapiGroupWindowAppFoot.
  ///
  /// In en, this message translates to:
  /// **'Typical use: minimise everything when a focus session starts, close the browser when work is over, kill a stuck app on demand.'**
  String get skapiGroupWindowAppFoot;

  /// No description provided for @skapiScriptMinimizeWindowTitle.
  ///
  /// In en, this message translates to:
  /// **'Minimise Window'**
  String get skapiScriptMinimizeWindowTitle;

  /// No description provided for @skapiScriptMinimizeWindowSummaryWhat.
  ///
  /// In en, this message translates to:
  /// **'Minimises a specific window by process name. Empty process name targets the currently focused window.'**
  String get skapiScriptMinimizeWindowSummaryWhat;

  /// No description provided for @skapiScriptMinimizeWindowSummaryHow.
  ///
  /// In en, this message translates to:
  /// **'Resolves the first matching main window via Get-Process and calls user32 ShowWindow with SW_MINIMIZE.'**
  String get skapiScriptMinimizeWindowSummaryHow;

  /// No description provided for @skapiScriptMinimizeWindowNote.
  ///
  /// In en, this message translates to:
  /// **'If multiple instances are running, only the first matching window is minimised. Use the process name without the .exe suffix.'**
  String get skapiScriptMinimizeWindowNote;

  /// No description provided for @skapiScriptMinimizeWindowParamProcessLabel.
  ///
  /// In en, this message translates to:
  /// **'processName'**
  String get skapiScriptMinimizeWindowParamProcessLabel;

  /// No description provided for @skapiScriptMinimizeWindowParamProcessHint.
  ///
  /// In en, this message translates to:
  /// **'Process name without .exe (chrome, code, winword). Empty targets the foreground window.'**
  String get skapiScriptMinimizeWindowParamProcessHint;

  /// No description provided for @skapiScriptCloseWindowTitle.
  ///
  /// In en, this message translates to:
  /// **'Close Window'**
  String get skapiScriptCloseWindowTitle;

  /// No description provided for @skapiScriptCloseWindowSummaryWhat.
  ///
  /// In en, this message translates to:
  /// **'Sends a graceful close to a window so the app can show its own \"save changes?\" dialog.'**
  String get skapiScriptCloseWindowSummaryWhat;

  /// No description provided for @skapiScriptCloseWindowSummaryHow.
  ///
  /// In en, this message translates to:
  /// **'Posts WM_CLOSE through user32 SendMessage. Same effect as the user clicking the X button. Empty process name targets the foreground window.'**
  String get skapiScriptCloseWindowSummaryHow;

  /// No description provided for @skapiScriptCloseWindowNote.
  ///
  /// In en, this message translates to:
  /// **'Apps with unsaved work will pop their own dialog. The script does not wait for or terminate hung apps.'**
  String get skapiScriptCloseWindowNote;

  /// No description provided for @skapiScriptCloseWindowParamProcessLabel.
  ///
  /// In en, this message translates to:
  /// **'processName'**
  String get skapiScriptCloseWindowParamProcessLabel;

  /// No description provided for @skapiScriptCloseWindowParamProcessHint.
  ///
  /// In en, this message translates to:
  /// **'Process name without .exe. Empty targets the foreground window.'**
  String get skapiScriptCloseWindowParamProcessHint;

  /// No description provided for @skapiScriptKillAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Force Quit App'**
  String get skapiScriptKillAppTitle;

  /// No description provided for @skapiScriptKillAppSummaryWhat.
  ///
  /// In en, this message translates to:
  /// **'Terminates every instance of a process. Tries WM_CLOSE first, then TerminateProcess if the app is still alive after the timeout.'**
  String get skapiScriptKillAppSummaryWhat;

  /// No description provided for @skapiScriptKillAppSummaryHow.
  ///
  /// In en, this message translates to:
  /// **'Sends WM_CLOSE to each main window, waits the configured timeout, then issues Stop-Process with -Force on anything still running.'**
  String get skapiScriptKillAppSummaryHow;

  /// No description provided for @skapiScriptKillAppNote.
  ///
  /// In en, this message translates to:
  /// **'Unsaved work in unresponsive apps will be lost on force-terminate. Use preKillSave for editor-style apps that respond to Ctrl+S.'**
  String get skapiScriptKillAppNote;

  /// No description provided for @skapiScriptKillAppParamProcessLabel.
  ///
  /// In en, this message translates to:
  /// **'processName'**
  String get skapiScriptKillAppParamProcessLabel;

  /// No description provided for @skapiScriptKillAppParamProcessHint.
  ///
  /// In en, this message translates to:
  /// **'Process name without .exe. All running instances are terminated.'**
  String get skapiScriptKillAppParamProcessHint;

  /// No description provided for @skapiScriptKillAppParamTimeoutLabel.
  ///
  /// In en, this message translates to:
  /// **'timeout'**
  String get skapiScriptKillAppParamTimeoutLabel;

  /// No description provided for @skapiScriptKillAppParamTimeoutHint.
  ///
  /// In en, this message translates to:
  /// **'Seconds to wait between WM_CLOSE and force-terminate. Higher values give the app more time to save.'**
  String get skapiScriptKillAppParamTimeoutHint;

  /// No description provided for @skapiScriptKillAppParamPreKillSaveLabel.
  ///
  /// In en, this message translates to:
  /// **'preKillSave'**
  String get skapiScriptKillAppParamPreKillSaveLabel;

  /// No description provided for @skapiScriptKillAppParamPreKillSaveHint.
  ///
  /// In en, this message translates to:
  /// **'Sends Ctrl+S to the foreground window before closing. Useful for editors but a no-op on apps that ignore Ctrl+S.'**
  String get skapiScriptKillAppParamPreKillSaveHint;

  /// No description provided for @skapiScriptLaunchAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Launch App'**
  String get skapiScriptLaunchAppTitle;

  /// No description provided for @skapiScriptLaunchAppSummaryWhat.
  ///
  /// In en, this message translates to:
  /// **'Starts an executable, opens a URL, or launches a document with the default handler.'**
  String get skapiScriptLaunchAppSummaryWhat;

  /// No description provided for @skapiScriptLaunchAppSummaryHow.
  ///
  /// In en, this message translates to:
  /// **'Calls PowerShell Start-Process with the path and optional argument list. Path may be an .exe, a full file path, or a URL.'**
  String get skapiScriptLaunchAppSummaryHow;

  /// No description provided for @skapiScriptLaunchAppNote.
  ///
  /// In en, this message translates to:
  /// **'Paths with spaces are accepted. Use a URL like https://example.com to open the default browser.'**
  String get skapiScriptLaunchAppNote;

  /// No description provided for @skapiScriptLaunchAppParamPathLabel.
  ///
  /// In en, this message translates to:
  /// **'path'**
  String get skapiScriptLaunchAppParamPathLabel;

  /// No description provided for @skapiScriptLaunchAppParamPathHint.
  ///
  /// In en, this message translates to:
  /// **'Executable, full file path, or URL. notepad / C:\\\\tools\\\\my.exe / https://example.com.'**
  String get skapiScriptLaunchAppParamPathHint;

  /// No description provided for @skapiScriptLaunchAppParamArgsLabel.
  ///
  /// In en, this message translates to:
  /// **'args'**
  String get skapiScriptLaunchAppParamArgsLabel;

  /// No description provided for @skapiScriptLaunchAppParamArgsHint.
  ///
  /// In en, this message translates to:
  /// **'Arguments passed to the executable. Empty for none.'**
  String get skapiScriptLaunchAppParamArgsHint;

  /// No description provided for @skappListenerCardTitle.
  ///
  /// In en, this message translates to:
  /// **'SKAPP HTTP Listener'**
  String get skappListenerCardTitle;

  /// No description provided for @skappListenerCardSubtitleRunning.
  ///
  /// In en, this message translates to:
  /// **'Running on port {port}'**
  String skappListenerCardSubtitleRunning(int port);

  /// No description provided for @skappListenerCardSubtitleStopped.
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get skappListenerCardSubtitleStopped;

  /// No description provided for @skappListenerCardSubtitleUnsupported.
  ///
  /// In en, this message translates to:
  /// **'This platform cannot host the listener.'**
  String get skappListenerCardSubtitleUnsupported;

  /// No description provided for @skappListenerCardEnableSwitch.
  ///
  /// In en, this message translates to:
  /// **'Enable listener'**
  String get skappListenerCardEnableSwitch;

  /// No description provided for @skappListenerCardSecurityNote.
  ///
  /// In en, this message translates to:
  /// **'The listener accepts connections only on your local network and requires the bearer token. Plain HTTP, do not expose it to the public internet.'**
  String get skappListenerCardSecurityNote;

  /// No description provided for @settingsLanVisibleTitle.
  ///
  /// In en, this message translates to:
  /// **'Visible on LAN'**
  String get settingsLanVisibleTitle;

  /// No description provided for @settingsLanVisibleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'When off, the listener only binds to localhost. Paired BF devices cannot reach this desktop.'**
  String get settingsLanVisibleSubtitle;

  /// No description provided for @settingsLanVisibleWarnBfBreaks.
  ///
  /// In en, this message translates to:
  /// **'Turning this off breaks the BF webhook chain. Use only in a trusted or test environment.'**
  String get settingsLanVisibleWarnBfBreaks;

  /// No description provided for @settingsLanVisibleAutoReopenedSnack.
  ///
  /// In en, this message translates to:
  /// **'LAN visibility was turned back on so BF devices can reach this desktop.'**
  String get settingsLanVisibleAutoReopenedSnack;

  /// No description provided for @skapiRunRemoteDeveloperModeDisabled.
  ///
  /// In en, this message translates to:
  /// **'The target desktop has Developer mode disabled, so remote script execution is off there.'**
  String get skapiRunRemoteDeveloperModeDisabled;

  /// No description provided for @skappPeerPairingManualUuidConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirmation code (last 4 of UUID)'**
  String get skappPeerPairingManualUuidConfirmLabel;

  /// No description provided for @skappPeerPairingManualUuidConfirmHint.
  ///
  /// In en, this message translates to:
  /// **'Read the 4-character code shown on the desktop\'s pairing screen.'**
  String get skappPeerPairingManualUuidConfirmHint;

  /// No description provided for @skappPeerPairingManualUuidConfirmError.
  ///
  /// In en, this message translates to:
  /// **'The code doesn\'t match the last 4 of the UUID. Check the desktop screen.'**
  String get skappPeerPairingManualUuidConfirmError;

  /// No description provided for @skappListenerCardUuidLast4Label.
  ///
  /// In en, this message translates to:
  /// **'Pairing confirmation code'**
  String get skappListenerCardUuidLast4Label;

  /// No description provided for @skappListenerCardUuidLast4Hint.
  ///
  /// In en, this message translates to:
  /// **'Type these 4 characters on the phone\'s manual pairing screen.'**
  String get skappListenerCardUuidLast4Hint;

  /// No description provided for @settingsPeerTokensTitle.
  ///
  /// In en, this message translates to:
  /// **'Issued peer tokens'**
  String get settingsPeerTokensTitle;

  /// No description provided for @settingsPeerTokensSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Mobile peers paired with this desktop. Revoke any entry to log it out without affecting the others.'**
  String get settingsPeerTokensSubtitle;

  /// No description provided for @settingsPeerTokensEmpty.
  ///
  /// In en, this message translates to:
  /// **'No peers paired yet.'**
  String get settingsPeerTokensEmpty;

  /// No description provided for @settingsPeerTokensIssuedAt.
  ///
  /// In en, this message translates to:
  /// **'Paired {when}'**
  String settingsPeerTokensIssuedAt(String when);

  /// No description provided for @settingsPeerTokensLastUsed.
  ///
  /// In en, this message translates to:
  /// **'Last used {when}'**
  String settingsPeerTokensLastUsed(String when);

  /// No description provided for @settingsPeerTokensRevokeButton.
  ///
  /// In en, this message translates to:
  /// **'Revoke'**
  String get settingsPeerTokensRevokeButton;

  /// No description provided for @settingsPeerTokensRevokeConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Revoke this peer?'**
  String get settingsPeerTokensRevokeConfirmTitle;

  /// No description provided for @settingsPeerTokensRevokeConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'The peer will be logged out immediately and has to pair again to reach this desktop.'**
  String get settingsPeerTokensRevokeConfirmBody;

  /// No description provided for @settingsPeerTokensRevokeConfirmCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsPeerTokensRevokeConfirmCancel;

  /// No description provided for @settingsPeerTokensRevokeConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Revoke'**
  String get settingsPeerTokensRevokeConfirmAction;

  /// No description provided for @settingsPeerTokensRevokedToast.
  ///
  /// In en, this message translates to:
  /// **'Peer {name} revoked'**
  String settingsPeerTokensRevokedToast(String name);

  /// No description provided for @skappListenerCardRotateCertButton.
  ///
  /// In en, this message translates to:
  /// **'Rotate TLS certificate'**
  String get skappListenerCardRotateCertButton;

  /// No description provided for @skappListenerCardRotateCertConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Rotate certificate?'**
  String get skappListenerCardRotateCertConfirmTitle;

  /// No description provided for @skappListenerCardRotateCertConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'A fresh self-signed TLS certificate will be generated. Every previously paired peer will fail handshake until it re-pairs.'**
  String get skappListenerCardRotateCertConfirmBody;

  /// No description provided for @skappListenerCardRotateCertConfirmCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get skappListenerCardRotateCertConfirmCancel;

  /// No description provided for @skappListenerCardRotateCertConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Rotate'**
  String get skappListenerCardRotateCertConfirmAction;

  /// No description provided for @skappListenerCardRotateCertDoneSnack.
  ///
  /// In en, this message translates to:
  /// **'TLS certificate rotated. Re-pair every device.'**
  String get skappListenerCardRotateCertDoneSnack;

  /// No description provided for @skappListenerCardCertFingerprintLabel.
  ///
  /// In en, this message translates to:
  /// **'TLS fingerprint'**
  String get skappListenerCardCertFingerprintLabel;

  /// No description provided for @skappListenerCardErrorPortInUse.
  ///
  /// In en, this message translates to:
  /// **'Port {port} is already in use. Pick a different port from Network identity.'**
  String skappListenerCardErrorPortInUse(int port);

  /// No description provided for @skappListenerCardErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Could not start the listener: {error}'**
  String skappListenerCardErrorGeneric(String error);

  /// No description provided for @skappPeerPairingTitle.
  ///
  /// In en, this message translates to:
  /// **'Pair Desktop SKAPP'**
  String get skappPeerPairingTitle;

  /// No description provided for @skappPeerPairingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR shown in the Desktop SKAPP\'s Settings, or paste the pairing code manually.'**
  String get skappPeerPairingSubtitle;

  /// No description provided for @skappPeerPairingTabScan.
  ///
  /// In en, this message translates to:
  /// **'Scan QR'**
  String get skappPeerPairingTabScan;

  /// No description provided for @skappPeerPairingTabManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get skappPeerPairingTabManual;

  /// No description provided for @skappPeerPairingScanHint.
  ///
  /// In en, this message translates to:
  /// **'Point your camera at the QR shown on Desktop SKAPP > Settings > SKAPP HTTP Listener.'**
  String get skappPeerPairingScanHint;

  /// No description provided for @skappPeerPairingScanCameraDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera permission required'**
  String get skappPeerPairingScanCameraDeniedTitle;

  /// No description provided for @skappPeerPairingScanCameraDeniedBody.
  ///
  /// In en, this message translates to:
  /// **'Allow camera access from your phone settings to scan the pairing QR. You can also enter the code manually.'**
  String get skappPeerPairingScanCameraDeniedBody;

  /// No description provided for @skappPeerPairingManualHostLabel.
  ///
  /// In en, this message translates to:
  /// **'Desktop IP or hostname'**
  String get skappPeerPairingManualHostLabel;

  /// No description provided for @skappPeerPairingManualPortLabel.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get skappPeerPairingManualPortLabel;

  /// No description provided for @skappPeerPairingManualTokenLabel.
  ///
  /// In en, this message translates to:
  /// **'Bearer token'**
  String get skappPeerPairingManualTokenLabel;

  /// No description provided for @skappPeerPairingManualUuidLabel.
  ///
  /// In en, this message translates to:
  /// **'Desktop UUID'**
  String get skappPeerPairingManualUuidLabel;

  /// No description provided for @skappPeerPairingManualNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get skappPeerPairingManualNameLabel;

  /// No description provided for @skappPeerPairingManualSubmit.
  ///
  /// In en, this message translates to:
  /// **'Pair'**
  String get skappPeerPairingManualSubmit;

  /// No description provided for @skappPeerPairingSavedToast.
  ///
  /// In en, this message translates to:
  /// **'Paired with {name}'**
  String skappPeerPairingSavedToast(String name);

  /// No description provided for @skappPeerPairingFailedToast.
  ///
  /// In en, this message translates to:
  /// **'Pairing failed: {reason}'**
  String skappPeerPairingFailedToast(String reason);

  /// No description provided for @skappPeerPairingShowQrTitle.
  ///
  /// In en, this message translates to:
  /// **'Pair a phone with this Desktop'**
  String get skappPeerPairingShowQrTitle;

  /// No description provided for @skappPeerPairingShowQrBody.
  ///
  /// In en, this message translates to:
  /// **'Open SKAPP on your phone, go to SKAPI > Settings > Pair Desktop, and scan this QR. The QR contains the bearer token, treat it like a password.'**
  String get skappPeerPairingShowQrBody;

  /// No description provided for @skappPeerPairingShowQrCloseButton.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get skappPeerPairingShowQrCloseButton;

  /// No description provided for @skappPeerListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No paired Desktop yet. Pair one to run scripts from this phone.'**
  String get skappPeerListEmpty;

  /// No description provided for @skappPeerListSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Paired Desktop SKAPPs'**
  String get skappPeerListSectionTitle;

  /// No description provided for @skappPeerStatusOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get skappPeerStatusOnline;

  /// No description provided for @skappPeerStatusOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get skappPeerStatusOffline;

  /// No description provided for @skappPeerStatusLastSeen.
  ///
  /// In en, this message translates to:
  /// **'Last seen {when}'**
  String skappPeerStatusLastSeen(String when);

  /// No description provided for @skappPeerRemoveTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove paired Desktop'**
  String get skappPeerRemoveTooltip;

  /// No description provided for @skappPeerRemoveConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove pairing?'**
  String get skappPeerRemoveConfirmTitle;

  /// No description provided for @skappPeerRemoveConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Scripts triggered from this phone will no longer run on {name} until you pair again.'**
  String skappPeerRemoveConfirmBody(String name);

  /// No description provided for @skappPeerScanRefreshTooltip.
  ///
  /// In en, this message translates to:
  /// **'Refresh peer list'**
  String get skappPeerScanRefreshTooltip;

  /// No description provided for @skapiRunRemoteSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Run remotely on {peerName}'**
  String skapiRunRemoteSheetTitle(String peerName);

  /// No description provided for @skapiRunRemoteConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting to Desktop...'**
  String get skapiRunRemoteConnecting;

  /// No description provided for @skapiRunRemoteOfflineError.
  ///
  /// In en, this message translates to:
  /// **'The paired Desktop is offline. Try refreshing peers or check the Desktop\'s listener.'**
  String get skapiRunRemoteOfflineError;

  /// No description provided for @skapiRunRemoteUnauthorizedError.
  ///
  /// In en, this message translates to:
  /// **'Bearer token rejected. The Desktop\'s token may have rotated. Re-pair from Settings.'**
  String get skapiRunRemoteUnauthorizedError;

  /// No description provided for @skapiRunRemoteHttpError.
  ///
  /// In en, this message translates to:
  /// **'Remote run failed: {reason}'**
  String skapiRunRemoteHttpError(String reason);

  /// No description provided for @skapiRunMobileNoPeerTitle.
  ///
  /// In en, this message translates to:
  /// **'No paired Desktop'**
  String get skapiRunMobileNoPeerTitle;

  /// No description provided for @skapiRunMobileNoPeerBody.
  ///
  /// In en, this message translates to:
  /// **'Pair a Desktop SKAPP from Settings to run scripts from this phone.'**
  String get skapiRunMobileNoPeerBody;

  /// No description provided for @skapiRunMobileNoPeerCta.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get skapiRunMobileNoPeerCta;

  /// No description provided for @skapiRunRemoteNotWhitelisted.
  ///
  /// In en, this message translates to:
  /// **'This script isn\'t marked as remotely runnable. Run it on the desktop directly.'**
  String get skapiRunRemoteNotWhitelisted;

  /// No description provided for @skapiRunRemoteNoPeerHint.
  ///
  /// In en, this message translates to:
  /// **'Pair a Desktop SKAPP from Settings to run scripts from this phone.'**
  String get skapiRunRemoteNoPeerHint;

  /// No description provided for @skapiRunRemoteNoPeerAction.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get skapiRunRemoteNoPeerAction;

  /// No description provided for @skappPeerPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Send to which computer?'**
  String get skappPeerPickerTitle;

  /// No description provided for @skappPeerPickerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick the paired Desktop SKAPP that should run this script.'**
  String get skappPeerPickerSubtitle;

  /// No description provided for @skappPeerPickerOfflineReason.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get skappPeerPickerOfflineReason;

  /// No description provided for @skappPeerPickerDevModeOffReason.
  ///
  /// In en, this message translates to:
  /// **'Developer mode is off'**
  String get skappPeerPickerDevModeOffReason;

  /// No description provided for @skappPeerPickerEmpty.
  ///
  /// In en, this message translates to:
  /// **'No paired desktops to pick from.'**
  String get skappPeerPickerEmpty;

  /// No description provided for @skapiRunRemoteCancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get skapiRunRemoteCancelButton;

  /// No description provided for @skapiRunRemoteCancelledNote.
  ///
  /// In en, this message translates to:
  /// **'Run cancelled'**
  String get skapiRunRemoteCancelledNote;

  /// No description provided for @skapiRunRemoteTooManyRuns.
  ///
  /// In en, this message translates to:
  /// **'That desktop already has {running} scripts running ({limit} max). Wait for one to finish.'**
  String skapiRunRemoteTooManyRuns(int running, int limit);

  /// No description provided for @skappPeerHealthDevModeBadge.
  ///
  /// In en, this message translates to:
  /// **'Dev mode'**
  String get skappPeerHealthDevModeBadge;

  /// No description provided for @remoteRunActivityCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Remote runs'**
  String get remoteRunActivityCardTitle;

  /// No description provided for @remoteRunActivityCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recent script runs paired mobile peers asked this desktop to perform.'**
  String get remoteRunActivityCardSubtitle;

  /// No description provided for @remoteRunActivityCardEmpty.
  ///
  /// In en, this message translates to:
  /// **'No remote runs yet.'**
  String get remoteRunActivityCardEmpty;

  /// No description provided for @remoteRunActivityCardClear.
  ///
  /// In en, this message translates to:
  /// **'Clear history'**
  String get remoteRunActivityCardClear;

  /// No description provided for @remoteRunActivityRowOk.
  ///
  /// In en, this message translates to:
  /// **'exit {exitCode} · {durationMs} ms'**
  String remoteRunActivityRowOk(int exitCode, int durationMs);

  /// No description provided for @remoteRunActivityRowCancelled.
  ///
  /// In en, this message translates to:
  /// **'cancelled'**
  String get remoteRunActivityRowCancelled;

  /// No description provided for @remoteRunActivityRowRejected.
  ///
  /// In en, this message translates to:
  /// **'rejected · {reason}'**
  String remoteRunActivityRowRejected(String reason);

  /// No description provided for @mobileTriggerCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Trigger'**
  String get mobileTriggerCardTitle;

  /// No description provided for @mobileTriggerCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Send a tap event to a paired Desktop SKAPP. Any binding listening for this event will fire its script on that desktop.'**
  String get mobileTriggerCardSubtitle;

  /// No description provided for @mobileTriggerCardSendButton.
  ///
  /// In en, this message translates to:
  /// **'Send tap'**
  String get mobileTriggerCardSendButton;

  /// No description provided for @mobileTriggerCardSending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get mobileTriggerCardSending;

  /// No description provided for @mobileTriggerSentToast.
  ///
  /// In en, this message translates to:
  /// **'Tap sent to {name}'**
  String mobileTriggerSentToast(String name);

  /// No description provided for @skapiBindEventMobileTap.
  ///
  /// In en, this message translates to:
  /// **'Mobile tap'**
  String get skapiBindEventMobileTap;

  /// No description provided for @pairedDeviceMobileType.
  ///
  /// In en, this message translates to:
  /// **'SKAPP Mobile'**
  String get pairedDeviceMobileType;

  /// No description provided for @skappPeersCardHeaderSinglePeer.
  ///
  /// In en, this message translates to:
  /// **'{title} · {name}'**
  String skappPeersCardHeaderSinglePeer(String title, String name);

  /// No description provided for @skappPeersCardHeaderMultiPeer.
  ///
  /// In en, this message translates to:
  /// **'{title} · {count}'**
  String skappPeersCardHeaderMultiPeer(String title, int count);

  /// No description provided for @msHomeScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Mobile peer'**
  String get msHomeScreenTitle;

  /// No description provided for @msHomeScreenNotFound.
  ///
  /// In en, this message translates to:
  /// **'This mobile peer is no longer paired.'**
  String get msHomeScreenNotFound;

  /// No description provided for @msHomeScreenEventsHeader.
  ///
  /// In en, this message translates to:
  /// **'Available events'**
  String get msHomeScreenEventsHeader;

  /// No description provided for @msHomeScreenBindingsHeader.
  ///
  /// In en, this message translates to:
  /// **'Bindings ({count})'**
  String msHomeScreenBindingsHeader(int count);

  /// No description provided for @msHomeScreenBindingsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No bindings yet. Use SKAPI → script → Bind to action to wire a tap event to a script.'**
  String get msHomeScreenBindingsEmpty;

  /// No description provided for @msHomeScreenHint.
  ///
  /// In en, this message translates to:
  /// **'Phones don\'t run scripts. They emit trigger events that this desktop binds to scripts.'**
  String get msHomeScreenHint;

  /// No description provided for @msHomeScreenPairedAt.
  ///
  /// In en, this message translates to:
  /// **'Paired {date}'**
  String msHomeScreenPairedAt(String date);

  /// No description provided for @skapiGroupNotifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Notify & Dialog'**
  String get skapiGroupNotifyTitle;

  /// No description provided for @skapiGroupNotifyDesc.
  ///
  /// In en, this message translates to:
  /// **'Scripts in this group talk to the user directly: pop a toast, show a modal dialog, or wait for a yes/no answer. Use these when a SmartKraft device\'s event needs the human in front of the screen to acknowledge or decide.'**
  String get skapiGroupNotifyDesc;

  /// No description provided for @skapiGroupNotifyFoot.
  ///
  /// In en, this message translates to:
  /// **'Typical use: dialog before a destructive action, toast on a soft reminder, dialog with timeout to fall through automatically.'**
  String get skapiGroupNotifyFoot;

  /// No description provided for @skapiScriptDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Show Dialog'**
  String get skapiScriptDialogTitle;

  /// No description provided for @skapiScriptDialogSummaryWhat.
  ///
  /// In en, this message translates to:
  /// **'Shows a modal Windows MessageBox and returns the user\'s choice (ok / cancel / yes / no / timeout).'**
  String get skapiScriptDialogSummaryWhat;

  /// No description provided for @skapiScriptDialogSummaryHow.
  ///
  /// In en, this message translates to:
  /// **'Calls System.Windows.Forms.MessageBox on a child runspace so the script can race the dialog against an optional timeout. The chosen value is written to stdout for the caller to branch on.'**
  String get skapiScriptDialogSummaryHow;

  /// No description provided for @skapiScriptDialogNote.
  ///
  /// In en, this message translates to:
  /// **'stdout is the user\'s answer in lowercase. timeout=0 waits indefinitely.'**
  String get skapiScriptDialogNote;

  /// No description provided for @skapiScriptDialogParamTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'title'**
  String get skapiScriptDialogParamTitleLabel;

  /// No description provided for @skapiScriptDialogParamTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Window title shown in the message box.'**
  String get skapiScriptDialogParamTitleHint;

  /// No description provided for @skapiScriptDialogParamBodyLabel.
  ///
  /// In en, this message translates to:
  /// **'body'**
  String get skapiScriptDialogParamBodyLabel;

  /// No description provided for @skapiScriptDialogParamBodyHint.
  ///
  /// In en, this message translates to:
  /// **'The question or message shown to the user.'**
  String get skapiScriptDialogParamBodyHint;

  /// No description provided for @skapiScriptDialogParamButtonsLabel.
  ///
  /// In en, this message translates to:
  /// **'buttons'**
  String get skapiScriptDialogParamButtonsLabel;

  /// No description provided for @skapiScriptDialogParamButtonsHint.
  ///
  /// In en, this message translates to:
  /// **'ok / ok_cancel / yes_no / yes_no_cancel. Default ok_cancel.'**
  String get skapiScriptDialogParamButtonsHint;

  /// No description provided for @skapiScriptDialogParamTimeoutLabel.
  ///
  /// In en, this message translates to:
  /// **'timeout'**
  String get skapiScriptDialogParamTimeoutLabel;

  /// No description provided for @skapiScriptDialogParamTimeoutHint.
  ///
  /// In en, this message translates to:
  /// **'Seconds to wait before falling through with \'timeout\'. 0 means wait forever.'**
  String get skapiScriptDialogParamTimeoutHint;

  /// No description provided for @skapiScriptToastTitle.
  ///
  /// In en, this message translates to:
  /// **'Show Toast'**
  String get skapiScriptToastTitle;

  /// No description provided for @skapiScriptToastSummaryWhat.
  ///
  /// In en, this message translates to:
  /// **'Shows a Windows toast notification with a title and body. Slides in from the bottom right and lands in Action Center.'**
  String get skapiScriptToastSummaryWhat;

  /// No description provided for @skapiScriptToastSummaryHow.
  ///
  /// In en, this message translates to:
  /// **'Builds a ToastNotification XML payload and hands it to the WinRT ToastNotificationManager under the configured AppUserModelID.'**
  String get skapiScriptToastSummaryHow;

  /// No description provided for @skapiScriptToastNote.
  ///
  /// In en, this message translates to:
  /// **'Tier 2: requires Windows 10+ and a registered AppUserModelID for the cleanest UX. The default AUMID puts the toast under PowerShell in Action Center.'**
  String get skapiScriptToastNote;

  /// No description provided for @skapiScriptToastParamTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'title'**
  String get skapiScriptToastParamTitleLabel;

  /// No description provided for @skapiScriptToastParamTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Bold first line of the toast.'**
  String get skapiScriptToastParamTitleHint;

  /// No description provided for @skapiScriptToastParamBodyLabel.
  ///
  /// In en, this message translates to:
  /// **'body'**
  String get skapiScriptToastParamBodyLabel;

  /// No description provided for @skapiScriptToastParamBodyHint.
  ///
  /// In en, this message translates to:
  /// **'Smaller second line. Optional.'**
  String get skapiScriptToastParamBodyHint;

  /// No description provided for @skapiScriptToastParamAumidLabel.
  ///
  /// In en, this message translates to:
  /// **'aumid'**
  String get skapiScriptToastParamAumidLabel;

  /// No description provided for @skapiScriptToastParamAumidHint.
  ///
  /// In en, this message translates to:
  /// **'App User Model ID under which the toast appears. Default falls back to PowerShell.'**
  String get skapiScriptToastParamAumidHint;

  /// No description provided for @skapiGroupVisualBreakTitle.
  ///
  /// In en, this message translates to:
  /// **'Visual Break'**
  String get skapiGroupVisualBreakTitle;

  /// No description provided for @skapiGroupVisualBreakDesc.
  ///
  /// In en, this message translates to:
  /// **'Soft visual cues that nudge the user away from intense work: dim the screen, switch to grayscale, find the cursor, or show the desktop. Effects in this group are reversible and never hard-block input.'**
  String get skapiGroupVisualBreakDesc;

  /// No description provided for @skapiGroupVisualBreakFoot.
  ///
  /// In en, this message translates to:
  /// **'Typical use: dim screen at the start of a focus break, grayscale mode for late-night reads, find-mouse on multi-monitor setups.'**
  String get skapiGroupVisualBreakFoot;

  /// No description provided for @skapiScriptShowDesktopTitle.
  ///
  /// In en, this message translates to:
  /// **'Show Desktop'**
  String get skapiScriptShowDesktopTitle;

  /// No description provided for @skapiScriptShowDesktopSummaryWhat.
  ///
  /// In en, this message translates to:
  /// **'Toggles \'show desktop\'. Same as pressing Win+D twice in a row.'**
  String get skapiScriptShowDesktopSummaryWhat;

  /// No description provided for @skapiScriptShowDesktopSummaryHow.
  ///
  /// In en, this message translates to:
  /// **'Calls Shell.Application.ToggleDesktop through COM. Running it again restores the previous window arrangement.'**
  String get skapiScriptShowDesktopSummaryHow;

  /// No description provided for @skapiScriptFadeScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Fade Screen'**
  String get skapiScriptFadeScreenTitle;

  /// No description provided for @skapiScriptFadeScreenSummaryWhat.
  ///
  /// In en, this message translates to:
  /// **'Fades the internal display brightness from its current level to a target level over a few seconds.'**
  String get skapiScriptFadeScreenSummaryWhat;

  /// No description provided for @skapiScriptFadeScreenSummaryHow.
  ///
  /// In en, this message translates to:
  /// **'Reads current brightness via WMI WmiMonitorBrightness, then steps WmiSetBrightness in linear increments toward the target so the change feels smooth.'**
  String get skapiScriptFadeScreenSummaryHow;

  /// No description provided for @skapiScriptFadeScreenNote.
  ///
  /// In en, this message translates to:
  /// **'Tier 2: WMI brightness only works on internal panels. External monitors do not respond on this path.'**
  String get skapiScriptFadeScreenNote;

  /// No description provided for @skapiScriptFadeScreenParamTargetLabel.
  ///
  /// In en, this message translates to:
  /// **'target'**
  String get skapiScriptFadeScreenParamTargetLabel;

  /// No description provided for @skapiScriptFadeScreenParamTargetHint.
  ///
  /// In en, this message translates to:
  /// **'Final brightness percentage (0-100).'**
  String get skapiScriptFadeScreenParamTargetHint;

  /// No description provided for @skapiScriptFadeScreenParamDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'duration'**
  String get skapiScriptFadeScreenParamDurationLabel;

  /// No description provided for @skapiScriptFadeScreenParamDurationHint.
  ///
  /// In en, this message translates to:
  /// **'Seconds the fade should take. The script uses ten brightness steps per second.'**
  String get skapiScriptFadeScreenParamDurationHint;

  /// No description provided for @skapiScriptGrayscaleTitle.
  ///
  /// In en, this message translates to:
  /// **'Grayscale Filter'**
  String get skapiScriptGrayscaleTitle;

  /// No description provided for @skapiScriptGrayscaleSummaryWhat.
  ///
  /// In en, this message translates to:
  /// **'Turns the Windows Color Filters grayscale mode on or off.'**
  String get skapiScriptGrayscaleSummaryWhat;

  /// No description provided for @skapiScriptGrayscaleSummaryHow.
  ///
  /// In en, this message translates to:
  /// **'Writes the ColorFiltering registry keys, then sends Win+Ctrl+C so Windows picks up the change live without a sign-out.'**
  String get skapiScriptGrayscaleSummaryHow;

  /// No description provided for @skapiScriptGrayscaleNote.
  ///
  /// In en, this message translates to:
  /// **'Tier 2: requires Settings > Accessibility > Color filters > \'Allow the shortcut key\' to be on for the live toggle to work.'**
  String get skapiScriptGrayscaleNote;

  /// No description provided for @skapiScriptGrayscaleParamOnLabel.
  ///
  /// In en, this message translates to:
  /// **'on'**
  String get skapiScriptGrayscaleParamOnLabel;

  /// No description provided for @skapiScriptGrayscaleParamOnHint.
  ///
  /// In en, this message translates to:
  /// **'true to enable grayscale, false to turn it off.'**
  String get skapiScriptGrayscaleParamOnHint;

  /// No description provided for @skapiScriptGrayscaleParamDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'duration'**
  String get skapiScriptGrayscaleParamDurationLabel;

  /// No description provided for @skapiScriptGrayscaleParamDurationHint.
  ///
  /// In en, this message translates to:
  /// **'0 means just toggle. >0 auto-reverts back to color after the given seconds. Ideal for visual breaks.'**
  String get skapiScriptGrayscaleParamDurationHint;

  /// No description provided for @skapiScriptFindMouseShakeTitle.
  ///
  /// In en, this message translates to:
  /// **'Find Mouse'**
  String get skapiScriptFindMouseShakeTitle;

  /// No description provided for @skapiScriptFindMouseShakeSummaryWhat.
  ///
  /// In en, this message translates to:
  /// **'Wiggles the cursor in a small circle to draw the eye to its position. The cursor returns to its starting point when the animation ends.'**
  String get skapiScriptFindMouseShakeSummaryWhat;

  /// No description provided for @skapiScriptFindMouseShakeSummaryHow.
  ///
  /// In en, this message translates to:
  /// **'Reads the current cursor position with GetCursorPos, then loops SetCursorPos around a circle of the configured radius. Useful on multi-monitor and 4K setups.'**
  String get skapiScriptFindMouseShakeSummaryHow;

  /// No description provided for @skapiScriptFindMouseShakeNote.
  ///
  /// In en, this message translates to:
  /// **'Tier 2: SetCursorPos can be blocked by accessibility software, and behaviour varies under remote-desktop sessions.'**
  String get skapiScriptFindMouseShakeNote;

  /// No description provided for @skapiScriptFindMouseShakeParamRadiusLabel.
  ///
  /// In en, this message translates to:
  /// **'radius'**
  String get skapiScriptFindMouseShakeParamRadiusLabel;

  /// No description provided for @skapiScriptFindMouseShakeParamRadiusHint.
  ///
  /// In en, this message translates to:
  /// **'Pixels the cursor travels from its origin during the loop. Bigger is more eye-catching.'**
  String get skapiScriptFindMouseShakeParamRadiusHint;

  /// No description provided for @skapiScriptFindMouseShakeParamLoopsLabel.
  ///
  /// In en, this message translates to:
  /// **'loops'**
  String get skapiScriptFindMouseShakeParamLoopsLabel;

  /// No description provided for @skapiScriptFindMouseShakeParamLoopsHint.
  ///
  /// In en, this message translates to:
  /// **'How many full circles to draw before settling.'**
  String get skapiScriptFindMouseShakeParamLoopsHint;

  /// No description provided for @skapiGroupProgramsTitle.
  ///
  /// In en, this message translates to:
  /// **'Specific Program Control'**
  String get skapiGroupProgramsTitle;

  /// No description provided for @skapiGroupProgramsDesc.
  ///
  /// In en, this message translates to:
  /// **'Targeted scripts for specific apps and browsers: graceful save+close, multi-instance shutdown, browser-wide cleanup. Handy when a SmartKraft device wants to wind a particular workflow down without nuking the whole desktop.'**
  String get skapiGroupProgramsDesc;

  /// No description provided for @skapiGroupProgramsFoot.
  ///
  /// In en, this message translates to:
  /// **'Typical use: save and close all editors before sleep, shut every browser at end-of-day, narrowed cleanup of one process family.'**
  String get skapiGroupProgramsFoot;

  /// No description provided for @skapiScriptCloseWithSaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Save & Close App'**
  String get skapiScriptCloseWithSaveTitle;

  /// No description provided for @skapiScriptCloseWithSaveSummaryWhat.
  ///
  /// In en, this message translates to:
  /// **'Sends Ctrl+S to a target app to trigger its own save, waits, then closes the window gracefully.'**
  String get skapiScriptCloseWithSaveSummaryWhat;

  /// No description provided for @skapiScriptCloseWithSaveSummaryHow.
  ///
  /// In en, this message translates to:
  /// **'Focuses each running instance, sends Ctrl+S via SendKeys, waits the configured beat, then posts WM_CLOSE so the app can confirm or finish saving.'**
  String get skapiScriptCloseWithSaveSummaryHow;

  /// No description provided for @skapiScriptCloseWithSaveNote.
  ///
  /// In en, this message translates to:
  /// **'Tier 2: relies on the app interpreting Ctrl+S as \'save\'. Some chat / web apps treat it differently. Test with the apps you actually target.'**
  String get skapiScriptCloseWithSaveNote;

  /// No description provided for @skapiScriptCloseWithSaveParamProcessLabel.
  ///
  /// In en, this message translates to:
  /// **'processName'**
  String get skapiScriptCloseWithSaveParamProcessLabel;

  /// No description provided for @skapiScriptCloseWithSaveParamProcessHint.
  ///
  /// In en, this message translates to:
  /// **'Process name without .exe (winword, excel, code, photoshop). All running instances are saved and closed.'**
  String get skapiScriptCloseWithSaveParamProcessHint;

  /// No description provided for @skapiScriptCloseWithSaveParamWaitLabel.
  ///
  /// In en, this message translates to:
  /// **'wait'**
  String get skapiScriptCloseWithSaveParamWaitLabel;

  /// No description provided for @skapiScriptCloseWithSaveParamWaitHint.
  ///
  /// In en, this message translates to:
  /// **'Seconds to wait between Ctrl+S and the close signal so the app finishes saving.'**
  String get skapiScriptCloseWithSaveParamWaitHint;

  /// No description provided for @skapiScriptCloseAllInstancesTitle.
  ///
  /// In en, this message translates to:
  /// **'Close All Instances'**
  String get skapiScriptCloseAllInstancesTitle;

  /// No description provided for @skapiScriptCloseAllInstancesSummaryWhat.
  ///
  /// In en, this message translates to:
  /// **'Sends a graceful close to every visible window of a process. Each instance can show its own save dialog.'**
  String get skapiScriptCloseAllInstancesSummaryWhat;

  /// No description provided for @skapiScriptCloseAllInstancesSummaryHow.
  ///
  /// In en, this message translates to:
  /// **'Iterates the matching processes via Get-Process and posts WM_CLOSE to each one\'s main window. No force fallback.'**
  String get skapiScriptCloseAllInstancesSummaryHow;

  /// No description provided for @skapiScriptCloseAllInstancesParamProcessLabel.
  ///
  /// In en, this message translates to:
  /// **'processName'**
  String get skapiScriptCloseAllInstancesParamProcessLabel;

  /// No description provided for @skapiScriptCloseAllInstancesParamProcessHint.
  ///
  /// In en, this message translates to:
  /// **'Process name without .exe. Matches all instances.'**
  String get skapiScriptCloseAllInstancesParamProcessHint;

  /// No description provided for @skapiScriptBrowserCloseAllTitle.
  ///
  /// In en, this message translates to:
  /// **'Close All Browsers'**
  String get skapiScriptBrowserCloseAllTitle;

  /// No description provided for @skapiScriptBrowserCloseAllSummaryWhat.
  ///
  /// In en, this message translates to:
  /// **'Closes every running mainstream browser (Chrome, Edge, Firefox, Brave, Vivaldi, Opera) gracefully.'**
  String get skapiScriptBrowserCloseAllSummaryWhat;

  /// No description provided for @skapiScriptBrowserCloseAllSummaryHow.
  ///
  /// In en, this message translates to:
  /// **'Iterates the well-known browser process names and posts WM_CLOSE to each main window. Modern browsers preserve the session if \'restore tabs on next launch\' is enabled.'**
  String get skapiScriptBrowserCloseAllSummaryHow;

  /// No description provided for @skapiScriptBrowserCloseAllNote.
  ///
  /// In en, this message translates to:
  /// **'Force-terminate is not used. To wipe the session as well, use kill-app per browser instead.'**
  String get skapiScriptBrowserCloseAllNote;

  /// No description provided for @skapiTierBadgeExperimental.
  ///
  /// In en, this message translates to:
  /// **'Experimental'**
  String get skapiTierBadgeExperimental;

  /// No description provided for @skapiTierBadgeExperimentalTooltip.
  ///
  /// In en, this message translates to:
  /// **'This script depends on a Windows API that may not be reliable across machines. Test it before relying on it.'**
  String get skapiTierBadgeExperimentalTooltip;

  /// No description provided for @skapiTierBadgeBlocked.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get skapiTierBadgeBlocked;

  /// No description provided for @skapiTierBadgeBlockedTooltip.
  ///
  /// In en, this message translates to:
  /// **'This script is part of the planned library but not implemented yet.'**
  String get skapiTierBadgeBlockedTooltip;

  /// No description provided for @skapiGroupSaveWorkTitle.
  ///
  /// In en, this message translates to:
  /// **'Save Work'**
  String get skapiGroupSaveWorkTitle;

  /// No description provided for @skapiGroupSaveWorkDesc.
  ///
  /// In en, this message translates to:
  /// **'Scripts in this group save your open work to disk before a break or unexpected shutdown. When your SmartKraft device triggers a break, the chosen script automatically saves your file in Word, Excel, VS Code or any other editor, so even if your computer sleeps, shuts down, or runs another command, your work stays safe.'**
  String get skapiGroupSaveWorkDesc;

  /// No description provided for @skapiGroupSaveWorkFoot.
  ///
  /// In en, this message translates to:
  /// **'Typical use: auto-save at the start of a focus break, document backup on low-battery warning, or a one-button \"save everything\" trigger.'**
  String get skapiGroupSaveWorkFoot;

  /// No description provided for @skapiScriptSaveActiveWindowTitle.
  ///
  /// In en, this message translates to:
  /// **'Save Active Window'**
  String get skapiScriptSaveActiveWindowTitle;

  /// No description provided for @skapiScriptSaveActiveWindowSummaryWhat.
  ///
  /// In en, this message translates to:
  /// **'Sends a virtual Ctrl+S to whichever Windows window currently has focus, triggering that application\'s own \"save\" behavior.'**
  String get skapiScriptSaveActiveWindowSummaryWhat;

  /// No description provided for @skapiScriptSaveActiveWindowSummaryHow.
  ///
  /// In en, this message translates to:
  /// **'First it grabs the active window\'s handle and logs its title. Then it dispatches Ctrl+S via SendKeys. Word saves to its current path, VS Code writes the file. If a \"Save As\" dialog appears, it waits until the user manually confirms.'**
  String get skapiScriptSaveActiveWindowSummaryHow;

  /// No description provided for @skapiScriptSaveActiveWindowParamTimeoutLabel.
  ///
  /// In en, this message translates to:
  /// **'timeout'**
  String get skapiScriptSaveActiveWindowParamTimeoutLabel;

  /// No description provided for @skapiScriptSaveActiveWindowParamTimeoutHint.
  ///
  /// In en, this message translates to:
  /// **'Seconds to wait after sending the keystroke so the app has time to write the file.'**
  String get skapiScriptSaveActiveWindowParamTimeoutHint;

  /// No description provided for @skapiScriptSaveActiveWindowParamVerboseLabel.
  ///
  /// In en, this message translates to:
  /// **'verbose'**
  String get skapiScriptSaveActiveWindowParamVerboseLabel;

  /// No description provided for @skapiScriptSaveAllOpenTitle.
  ///
  /// In en, this message translates to:
  /// **'Save All Open Documents'**
  String get skapiScriptSaveAllOpenTitle;

  /// No description provided for @skapiScriptSaveAllOpenSummaryWhat.
  ///
  /// In en, this message translates to:
  /// **'Iterates through a whitelist of running editors and tells each one to save its open documents.'**
  String get skapiScriptSaveAllOpenSummaryWhat;

  /// No description provided for @skapiScriptSaveAllOpenSummaryHow.
  ///
  /// In en, this message translates to:
  /// **'For every whitelisted process found, it focuses the main window, sends Ctrl+S, then waits the configured per-app timeout before moving on. Apps that aren\'t running are skipped silently unless verbose mode is on.'**
  String get skapiScriptSaveAllOpenSummaryHow;

  /// No description provided for @skapiScriptSaveAllOpenNote.
  ///
  /// In en, this message translates to:
  /// **'The whitelist defaults to Word, Excel, PowerPoint and VS Code. Edit the apps parameter to add your own.'**
  String get skapiScriptSaveAllOpenNote;

  /// No description provided for @skapiScriptSaveAllOpenParamAppsLabel.
  ///
  /// In en, this message translates to:
  /// **'apps'**
  String get skapiScriptSaveAllOpenParamAppsLabel;

  /// No description provided for @skapiScriptSaveAllOpenParamAppsHint.
  ///
  /// In en, this message translates to:
  /// **'Process names (without .exe) to send save to. Order matters: earlier entries are processed first.'**
  String get skapiScriptSaveAllOpenParamAppsHint;

  /// No description provided for @skapiScriptSaveAllOpenParamTimeoutLabel.
  ///
  /// In en, this message translates to:
  /// **'timeoutPerApp'**
  String get skapiScriptSaveAllOpenParamTimeoutLabel;

  /// No description provided for @skapiScriptSaveAllOpenParamVerboseLabel.
  ///
  /// In en, this message translates to:
  /// **'verbose'**
  String get skapiScriptSaveAllOpenParamVerboseLabel;

  /// No description provided for @skapiScriptAutosaveTriggerTitle.
  ///
  /// In en, this message translates to:
  /// **'Trigger Auto-Save'**
  String get skapiScriptAutosaveTriggerTitle;

  /// No description provided for @skapiScriptAutosaveTriggerSummaryWhat.
  ///
  /// In en, this message translates to:
  /// **'Broadcasts a Windows save command to every visible top-level window in one pass.'**
  String get skapiScriptAutosaveTriggerSummaryWhat;

  /// No description provided for @skapiScriptAutosaveTriggerSummaryHow.
  ///
  /// In en, this message translates to:
  /// **'Enumerates visible windows, then sends each one a WM_COMMAND with the standard save id. Apps that listen for that message react as if you clicked their File menu\'s Save item. Faster than a per-window Ctrl+S, but a few apps ignore the broadcast.'**
  String get skapiScriptAutosaveTriggerSummaryHow;

  /// No description provided for @skapiScriptAutosaveTriggerNote.
  ///
  /// In en, this message translates to:
  /// **'Use this when you want to flush every editor at once and don\'t mind that a small number of apps may not respond. Combine with save-all-open for stricter coverage.'**
  String get skapiScriptAutosaveTriggerNote;

  /// No description provided for @skapiScriptAutosaveTriggerParamDelayLabel.
  ///
  /// In en, this message translates to:
  /// **'delay'**
  String get skapiScriptAutosaveTriggerParamDelayLabel;

  /// No description provided for @skapiScriptAutosaveTriggerParamDelayHint.
  ///
  /// In en, this message translates to:
  /// **'Seconds to wait before broadcasting, useful when you want the device\'s break notification to appear first.'**
  String get skapiScriptAutosaveTriggerParamDelayHint;

  /// No description provided for @skapiScriptAutosaveTriggerParamVerboseLabel.
  ///
  /// In en, this message translates to:
  /// **'verbose'**
  String get skapiScriptAutosaveTriggerParamVerboseLabel;

  /// No description provided for @skapiScriptDetailSummaryWhatLabel.
  ///
  /// In en, this message translates to:
  /// **'What it does:'**
  String get skapiScriptDetailSummaryWhatLabel;

  /// No description provided for @skapiScriptDetailSummaryHowLabel.
  ///
  /// In en, this message translates to:
  /// **'How it works:'**
  String get skapiScriptDetailSummaryHowLabel;

  /// No description provided for @skapiScriptDetailOriginalSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Original Script'**
  String get skapiScriptDetailOriginalSectionTitle;

  /// No description provided for @skapiScriptDetailOriginalSectionSub.
  ///
  /// In en, this message translates to:
  /// **'read-only · English'**
  String get skapiScriptDetailOriginalSectionSub;

  /// No description provided for @skapiScriptDetailEditingSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Edits'**
  String get skapiScriptDetailEditingSectionTitle;

  /// No description provided for @skapiScriptDetailEditingNotYet.
  ///
  /// In en, this message translates to:
  /// **'No edits yet'**
  String get skapiScriptDetailEditingNotYet;

  /// No description provided for @skapiScriptDetailEditingNotYetSub.
  ///
  /// In en, this message translates to:
  /// **'Create a copy on this device without changing the original.'**
  String get skapiScriptDetailEditingNotYetSub;

  /// No description provided for @skapiScriptDetailEditingModified.
  ///
  /// In en, this message translates to:
  /// **'Edited'**
  String get skapiScriptDetailEditingModified;

  /// No description provided for @skapiScriptDetailEditingModifiedSub.
  ///
  /// In en, this message translates to:
  /// **'Last changed {date}.'**
  String skapiScriptDetailEditingModifiedSub(String date);

  /// No description provided for @skapiScriptDetailEditingOutdated.
  ///
  /// In en, this message translates to:
  /// **'Library updated'**
  String get skapiScriptDetailEditingOutdated;

  /// No description provided for @skapiScriptDetailEditingOutdatedSub.
  ///
  /// In en, this message translates to:
  /// **'The original was changed by an app update. Compare or reset.'**
  String get skapiScriptDetailEditingOutdatedSub;

  /// No description provided for @skapiScriptDetailParamWarnTitle.
  ///
  /// In en, this message translates to:
  /// **'Check parameters before running'**
  String get skapiScriptDetailParamWarnTitle;

  /// No description provided for @skapiScriptDetailParamWarnHint.
  ///
  /// In en, this message translates to:
  /// **'To change these values, use \"Edit\". Parameters are defined in the script\'s param() block.'**
  String get skapiScriptDetailParamWarnHint;

  /// No description provided for @skapiScriptDetailNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get skapiScriptDetailNotesTitle;

  /// No description provided for @skapiScriptDetailButtonRun.
  ///
  /// In en, this message translates to:
  /// **'Run Now'**
  String get skapiScriptDetailButtonRun;

  /// No description provided for @skapiScriptDetailButtonBindAction.
  ///
  /// In en, this message translates to:
  /// **'Bind to Action'**
  String get skapiScriptDetailButtonBindAction;

  /// No description provided for @skapiScriptDetailButtonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get skapiScriptDetailButtonEdit;

  /// No description provided for @skapiScriptDetailButtonView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get skapiScriptDetailButtonView;

  /// No description provided for @skapiScriptDetailButtonReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get skapiScriptDetailButtonReset;

  /// No description provided for @skapiScriptDetailButtonCompare.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get skapiScriptDetailButtonCompare;

  /// No description provided for @skapiScriptCopyButton.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get skapiScriptCopyButton;

  /// No description provided for @skapiScriptCopyButtonDone.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get skapiScriptCopyButtonDone;

  /// No description provided for @skapiScriptSelectButton.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get skapiScriptSelectButton;

  /// No description provided for @skapiEditorTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get skapiEditorTitle;

  /// No description provided for @skapiEditorHint.
  ///
  /// In en, this message translates to:
  /// **'{scriptId} · You are editing a copy on this device. The original library version is unchanged. \"Reset\" always restores the original.'**
  String skapiEditorHint(String scriptId);

  /// No description provided for @skapiEditorStatusBarTitle.
  ///
  /// In en, this message translates to:
  /// **'POWERSHELL · UTF-8'**
  String get skapiEditorStatusBarTitle;

  /// No description provided for @skapiEditorStatusModified.
  ///
  /// In en, this message translates to:
  /// **'● Modified'**
  String get skapiEditorStatusModified;

  /// No description provided for @skapiEditorStatusUnmodified.
  ///
  /// In en, this message translates to:
  /// **'Unchanged'**
  String get skapiEditorStatusUnmodified;

  /// No description provided for @skapiEditorFootCursor.
  ///
  /// In en, this message translates to:
  /// **'Line {line} · Column {column}'**
  String skapiEditorFootCursor(int line, int column);

  /// No description provided for @skapiEditorFootSaveLabel.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get skapiEditorFootSaveLabel;

  /// No description provided for @skapiEditorDiffLineCount.
  ///
  /// In en, this message translates to:
  /// **'{count} line changed'**
  String skapiEditorDiffLineCount(int count);

  /// No description provided for @skapiEditorDiffLinesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} lines changed'**
  String skapiEditorDiffLinesCount(int count);

  /// No description provided for @skapiEditorDiffCompareLink.
  ///
  /// In en, this message translates to:
  /// **'Compare with original'**
  String get skapiEditorDiffCompareLink;

  /// No description provided for @skapiEditorButtonReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get skapiEditorButtonReset;

  /// No description provided for @skapiEditorButtonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get skapiEditorButtonSave;

  /// No description provided for @skapiEditorAfterSaveNote.
  ///
  /// In en, this message translates to:
  /// **'After saving, \"Run Now\" will execute the edited version.'**
  String get skapiEditorAfterSaveNote;

  /// No description provided for @skapiLinuxDistroHeading.
  ///
  /// In en, this message translates to:
  /// **'Pick your distribution family'**
  String get skapiLinuxDistroHeading;

  /// No description provided for @skapiLinuxDistroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Linux scripts diverge between Debian-based (apt, .deb) and Arch-based (pacman) families. Pick the one that matches your machine.'**
  String get skapiLinuxDistroSubtitle;

  /// No description provided for @skapiLinuxDistroDebianLabel.
  ///
  /// In en, this message translates to:
  /// **'Debian-based'**
  String get skapiLinuxDistroDebianLabel;

  /// No description provided for @skapiLinuxDistroDebianSub.
  ///
  /// In en, this message translates to:
  /// **'Debian, Ubuntu, Mint, Pop!_OS, Elementary, Kali, MX, Zorin'**
  String get skapiLinuxDistroDebianSub;

  /// No description provided for @skapiLinuxDistroArchLabel.
  ///
  /// In en, this message translates to:
  /// **'Arch-based'**
  String get skapiLinuxDistroArchLabel;

  /// No description provided for @skapiLinuxDistroArchSub.
  ///
  /// In en, this message translates to:
  /// **'Arch, Manjaro, EndeavourOS, Garuda (coming later)'**
  String get skapiLinuxDistroArchSub;

  /// No description provided for @skapiNewActionNoDevicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Pair a device first'**
  String get skapiNewActionNoDevicesTitle;

  /// No description provided for @skapiNewActionNoDevicesBody.
  ///
  /// In en, this message translates to:
  /// **'Creating an on-device action needs at least one paired SmartKraft device (BF for now).'**
  String get skapiNewActionNoDevicesBody;

  /// No description provided for @skapiNewActionNoDevicesCta.
  ///
  /// In en, this message translates to:
  /// **'Open Devices'**
  String get skapiNewActionNoDevicesCta;

  /// No description provided for @skapiNewActionPickDeviceTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a device'**
  String get skapiNewActionPickDeviceTitle;

  /// No description provided for @skapiNewActionPickDeviceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Which device should this action live on?'**
  String get skapiNewActionPickDeviceSubtitle;

  /// No description provided for @skapiUserNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New script'**
  String get skapiUserNewTitle;

  /// No description provided for @skapiUserEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit script'**
  String get skapiUserEditTitle;

  /// No description provided for @skapiUserTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get skapiUserTitleLabel;

  /// No description provided for @skapiUserTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Morning routine'**
  String get skapiUserTitleHint;

  /// No description provided for @skapiUserDescLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get skapiUserDescLabel;

  /// No description provided for @skapiUserDescHint.
  ///
  /// In en, this message translates to:
  /// **'What does this script do?'**
  String get skapiUserDescHint;

  /// No description provided for @skapiUserPlatformLabel.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get skapiUserPlatformLabel;

  /// No description provided for @skapiUserCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get skapiUserCodeLabel;

  /// No description provided for @skapiUserCodeHint.
  ///
  /// In en, this message translates to:
  /// **'# Your PowerShell code here'**
  String get skapiUserCodeHint;

  /// No description provided for @skapiUserSaveCta.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get skapiUserSaveCta;

  /// No description provided for @skapiUserValidationEmpty.
  ///
  /// In en, this message translates to:
  /// **'Title and code can\'t be empty.'**
  String get skapiUserValidationEmpty;

  /// No description provided for @skapiUserSavedSnack.
  ///
  /// In en, this message translates to:
  /// **'Script saved'**
  String get skapiUserSavedSnack;

  /// No description provided for @skapiUserSectionHeading.
  ///
  /// In en, this message translates to:
  /// **'My scripts'**
  String get skapiUserSectionHeading;

  /// No description provided for @skapiUserSectionSub.
  ///
  /// In en, this message translates to:
  /// **'{count} scripts'**
  String skapiUserSectionSub(int count);

  /// No description provided for @skapiUserEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'No scripts of your own yet. Create one with the New action button, top-right.'**
  String get skapiUserEmptyHint;

  /// No description provided for @skapiUserDetailCodeHeading.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get skapiUserDetailCodeHeading;

  /// No description provided for @skapiUserEditCta.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get skapiUserEditCta;

  /// No description provided for @skapiUserDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete script?'**
  String get skapiUserDeleteConfirmTitle;

  /// No description provided for @skapiUserDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'{name} will be permanently deleted.'**
  String skapiUserDeleteConfirmBody(String name);

  /// No description provided for @skapiUserDeletedSnack.
  ///
  /// In en, this message translates to:
  /// **'Script deleted'**
  String get skapiUserDeletedSnack;

  /// No description provided for @skapiUserRunCta.
  ///
  /// In en, this message translates to:
  /// **'Run'**
  String get skapiUserRunCta;

  /// No description provided for @skapiUserRunUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Running scripts is desktop-only.'**
  String get skapiUserRunUnsupported;

  /// No description provided for @skapiUserRunOutputTitle.
  ///
  /// In en, this message translates to:
  /// **'Run output'**
  String get skapiUserRunOutputTitle;

  /// No description provided for @skapiUserRunDone.
  ///
  /// In en, this message translates to:
  /// **'Finished (exit {code})'**
  String skapiUserRunDone(int code);

  /// No description provided for @skapiLocalScriptsSubheading.
  ///
  /// In en, this message translates to:
  /// **'Local scripts'**
  String get skapiLocalScriptsSubheading;

  /// No description provided for @skapiOnDeviceApiSubheading.
  ///
  /// In en, this message translates to:
  /// **'On-device API'**
  String get skapiOnDeviceApiSubheading;

  /// No description provided for @skapiOnDeviceApiLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not read endpoints'**
  String get skapiOnDeviceApiLoadError;

  /// No description provided for @skapiOnDeviceApiRowHint.
  ///
  /// In en, this message translates to:
  /// **'Tap any row to open the editor'**
  String get skapiOnDeviceApiRowHint;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get commonLoading;

  /// No description provided for @skapiApiTemplateSectionHeader.
  ///
  /// In en, this message translates to:
  /// **'Templates'**
  String get skapiApiTemplateSectionHeader;

  /// No description provided for @skapiApiTemplateSectionCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 template} other{{count} templates}}'**
  String skapiApiTemplateSectionCount(int count);

  /// No description provided for @skapiApiTemplateUploadCta.
  ///
  /// In en, this message translates to:
  /// **'Upload to device'**
  String get skapiApiTemplateUploadCta;

  /// No description provided for @skapiApiTemplateUploadHint.
  ///
  /// In en, this message translates to:
  /// **'Uploading writes this template into one of the device\'s 5 USER API slots. The device fires it on its own trigger (BF: countdown end).'**
  String get skapiApiTemplateUploadHint;

  /// No description provided for @skapiApiTemplatePreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Endpoint preview'**
  String get skapiApiTemplatePreviewTitle;

  /// No description provided for @skapiApiTemplatePreviewType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get skapiApiTemplatePreviewType;

  /// No description provided for @skapiApiTemplatePreviewMethod.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get skapiApiTemplatePreviewMethod;

  /// No description provided for @skapiApiTemplatePreviewUrl.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get skapiApiTemplatePreviewUrl;

  /// No description provided for @skapiApiTemplatePreviewAuth.
  ///
  /// In en, this message translates to:
  /// **'Auth'**
  String get skapiApiTemplatePreviewAuth;

  /// No description provided for @skapiApiTemplatePreviewHeader.
  ///
  /// In en, this message translates to:
  /// **'Header'**
  String get skapiApiTemplatePreviewHeader;

  /// No description provided for @skapiApiTemplatePreviewContentType.
  ///
  /// In en, this message translates to:
  /// **'Content-Type'**
  String get skapiApiTemplatePreviewContentType;

  /// No description provided for @skapiApiTemplatePreviewPayload.
  ///
  /// In en, this message translates to:
  /// **'Payload'**
  String get skapiApiTemplatePreviewPayload;

  /// No description provided for @skapiApiTemplatePreviewDelay.
  ///
  /// In en, this message translates to:
  /// **'Delay'**
  String get skapiApiTemplatePreviewDelay;

  /// No description provided for @skapiOtherCategoryHeading.
  ///
  /// In en, this message translates to:
  /// **'Pick a device category'**
  String get skapiOtherCategoryHeading;

  /// No description provided for @skapiOtherCategorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Templates upload onto the paired device and fire on the device\'s own trigger (no laptop involved).'**
  String get skapiOtherCategorySubtitle;

  /// No description provided for @skapiOtherSyndimmSub.
  ///
  /// In en, this message translates to:
  /// **'SmartKraft smart dimmer'**
  String get skapiOtherSyndimmSub;

  /// No description provided for @skapiOtherLebensspurSub.
  ///
  /// In en, this message translates to:
  /// **'SmartKraft activity tracker'**
  String get skapiOtherLebensspurSub;

  /// No description provided for @skapiOtherBlockingfocusSub.
  ///
  /// In en, this message translates to:
  /// **'SmartKraft focus timer'**
  String get skapiOtherBlockingfocusSub;

  /// No description provided for @skapiOtherIotSub.
  ///
  /// In en, this message translates to:
  /// **'Third-party IoT webhooks (IFTTT, Home Assistant, generic REST)'**
  String get skapiOtherIotSub;

  /// No description provided for @skapiOtherServerSub.
  ///
  /// In en, this message translates to:
  /// **'Self-hosted HTTP receivers (n8n, Node-RED, custom)'**
  String get skapiOtherServerSub;

  /// No description provided for @skapiCategoryComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Templates coming soon'**
  String get skapiCategoryComingSoon;

  /// No description provided for @skapiScriptLockSummaryHowLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Calls loginctl lock-session for the current XDG_SESSION_ID; falls back to xdg-screensaver lock when loginctl is not available.'**
  String get skapiScriptLockSummaryHowLxDebian;

  /// No description provided for @skapiScriptHibernateSummaryHowLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Calls systemctl hibernate. Optional delay sleeps for the requested seconds before suspending.'**
  String get skapiScriptHibernateSummaryHowLxDebian;

  /// No description provided for @skapiScriptHibernateNoteLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Hibernation needs to be configured (swap >= RAM and the resume= kernel parameter). On systems where it is not, systemd-logind falls back to suspend.'**
  String get skapiScriptHibernateNoteLxDebian;

  /// No description provided for @skapiScriptSleepSummaryHowLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Calls systemctl suspend. The kernel may delay if a foreground inhibitor is blocking idle transitions.'**
  String get skapiScriptSleepSummaryHowLxDebian;

  /// No description provided for @skapiScriptShutdownSummaryHowLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Schedules a graceful poweroff via /sbin/shutdown -h +N (minutes). Falls back to systemctl poweroff after the requested delay if shutdown is missing.'**
  String get skapiScriptShutdownSummaryHowLxDebian;

  /// No description provided for @skapiScriptShutdownNoteLxDebian.
  ///
  /// In en, this message translates to:
  /// **'/sbin/shutdown only takes minutes; values under 60 round up to 1 minute. Other logged-in users see a wall message during the countdown.'**
  String get skapiScriptShutdownNoteLxDebian;

  /// No description provided for @skapiScriptShutdownParamForceHintLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Terminates the user session before powering off so the 90s SIGTERM grace period is skipped.'**
  String get skapiScriptShutdownParamForceHintLxDebian;

  /// No description provided for @skapiScriptBrightnessSummaryHowLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Sets internal display backlight via brightnessctl set N% (preferred) or light -S N as a fallback. Both write to /sys/class/backlight.'**
  String get skapiScriptBrightnessSummaryHowLxDebian;

  /// No description provided for @skapiScriptBrightnessNoteLxDebian.
  ///
  /// In en, this message translates to:
  /// **'brightnessctl is sudoless when the user is in the video group, which is the default after install on most Debian setups. External monitors over DDC need ddcutil and are not handled here.'**
  String get skapiScriptBrightnessNoteLxDebian;

  /// No description provided for @skapiScriptMuteToggleSummaryHowLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Toggles or sets the master sink mute via wpctl (PipeWire on Debian 12+) with a pactl fallback for PulseAudio setups.'**
  String get skapiScriptMuteToggleSummaryHowLxDebian;

  /// No description provided for @skapiScriptVolumeSetSummaryHowLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Sets the master sink volume to a 0-100 level via wpctl set-volume (PipeWire) or pactl set-sink-volume (PulseAudio).'**
  String get skapiScriptVolumeSetSummaryHowLxDebian;

  /// No description provided for @skapiScriptVolumeSetNoteLxDebian.
  ///
  /// In en, this message translates to:
  /// **'PipeWire and PulseAudio both expose per-app volume natively, so this script is tier 1 on Linux. Output above 100% is clamped for parity with other platforms.'**
  String get skapiScriptVolumeSetNoteLxDebian;

  /// No description provided for @skapiScriptMediaKeySummaryHowLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Sends a media-key action via playerctl, which uses MPRIS to talk to whatever app currently owns the session (Spotify, Firefox, VLC, mpv, Rhythmbox).'**
  String get skapiScriptMediaKeySummaryHowLxDebian;

  /// No description provided for @skapiScriptMediaKeyNoteLxDebian.
  ///
  /// In en, this message translates to:
  /// **'If no MPRIS-aware media app is running, the command is a no-op. Install the app\'s MPRIS support if a known player does not respond.'**
  String get skapiScriptMediaKeyNoteLxDebian;

  /// No description provided for @skapiScriptMinimizeWindowSummaryHowLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Empty processName minimises the focused window via xdotool. Otherwise picks the first window whose WM_CLASS matches and minimises it.'**
  String get skapiScriptMinimizeWindowSummaryHowLxDebian;

  /// No description provided for @skapiScriptMinimizeWindowNoteLxDebian.
  ///
  /// In en, this message translates to:
  /// **'X11 only. WM_CLASS matching is case-sensitive and depends on how the app declared itself; check xprop WM_CLASS if uncertain.'**
  String get skapiScriptMinimizeWindowNoteLxDebian;

  /// No description provided for @skapiScriptMinimizeWindowParamProcessHintLxDebian.
  ///
  /// In en, this message translates to:
  /// **'WM_CLASS instance name (for example: firefox, code, gnome-terminal-server). Empty targets the active window.'**
  String get skapiScriptMinimizeWindowParamProcessHintLxDebian;

  /// No description provided for @skapiScriptCloseWindowSummaryHowLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Sends WM_DELETE_WINDOW via wmctrl -x -c (matches WM_CLASS) with a title fallback. Equivalent to clicking the X button; the app may show its own save dialog.'**
  String get skapiScriptCloseWindowSummaryHowLxDebian;

  /// No description provided for @skapiScriptCloseWindowNoteLxDebian.
  ///
  /// In en, this message translates to:
  /// **'X11 only. For Wayland, prefer kill-app which uses signals instead of the window protocol.'**
  String get skapiScriptCloseWindowNoteLxDebian;

  /// No description provided for @skapiScriptCloseWindowParamProcessHintLxDebian.
  ///
  /// In en, this message translates to:
  /// **'WM_CLASS instance name; empty closes the focused window. Title-substring match is used as a fallback.'**
  String get skapiScriptCloseWindowParamProcessHintLxDebian;

  /// No description provided for @skapiScriptKillAppSummaryHowLxDebian.
  ///
  /// In en, this message translates to:
  /// **'pkill -TERM -x by exact comm name, waits the requested timeout, then pkill -KILL on anything still alive. Optional preKillSave focuses the window and sends Ctrl+S first (X11 only).'**
  String get skapiScriptKillAppSummaryHowLxDebian;

  /// No description provided for @skapiScriptKillAppNoteLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Linux comm names are limited to 15 characters by the kernel. Use exact short names: firefox (not firefox-esr-bin), code, soffice.bin.'**
  String get skapiScriptKillAppNoteLxDebian;

  /// No description provided for @skapiScriptKillAppParamProcessHintLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Exact comm name (15 char kernel limit). Use pgrep -l to verify the visible name.'**
  String get skapiScriptKillAppParamProcessHintLxDebian;

  /// No description provided for @skapiScriptKillAppParamPreKillSaveHintLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Send Ctrl+S to the app\'s window before SIGTERM. Requires xdotool and X11; ignored on Wayland.'**
  String get skapiScriptKillAppParamPreKillSaveHintLxDebian;

  /// No description provided for @skapiScriptLaunchAppSummaryHowLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Smart dispatch: .desktop -> gtk-launch, real file path -> exec, anything else -> xdg-open, finally PATH lookup. The child is detached via setsid so SKAPP is not blocked.'**
  String get skapiScriptLaunchAppSummaryHowLxDebian;

  /// No description provided for @skapiScriptLaunchAppNoteLxDebian.
  ///
  /// In en, this message translates to:
  /// **'args is split on spaces. Quote-bearing arguments are not supported; use a wrapper script for complex command lines.'**
  String get skapiScriptLaunchAppNoteLxDebian;

  /// No description provided for @skapiScriptLaunchAppParamPathHintLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Binary name on PATH, absolute path, .desktop file, URL, or file path. xdg-open handles MIME types.'**
  String get skapiScriptLaunchAppParamPathHintLxDebian;

  /// No description provided for @skapiScriptDialogSummaryHowLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Opens a modal dialog via zenity (GTK) with a kdialog (KDE) fallback. Writes one of ok / cancel / yes / no / timeout to stdout.'**
  String get skapiScriptDialogSummaryHowLxDebian;

  /// No description provided for @skapiScriptDialogNoteLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Install with: sudo apt install zenity. KDE Plasma users may have kdialog instead. Without either, the script exits with code 2.'**
  String get skapiScriptDialogNoteLxDebian;

  /// No description provided for @skapiScriptToastSummaryHowLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Sends a desktop notification via notify-send (libnotify). Tier 1 because libnotify-bin is preinstalled on every modern Debian desktop.'**
  String get skapiScriptToastSummaryHowLxDebian;

  /// No description provided for @skapiScriptToastNoteLxDebian.
  ///
  /// In en, this message translates to:
  /// **'icon accepts Freedesktop icon-theme names (dialog-information, dialog-warning, dialog-error). duration in seconds; 0 keeps the toast until dismissed.'**
  String get skapiScriptToastNoteLxDebian;

  /// No description provided for @skapiScriptToastParamIconLabelLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get skapiScriptToastParamIconLabelLxDebian;

  /// No description provided for @skapiScriptToastParamIconHintLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Freedesktop icon name, for example: dialog-information, dialog-warning, dialog-error.'**
  String get skapiScriptToastParamIconHintLxDebian;

  /// No description provided for @skapiScriptToastParamDurationLabelLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get skapiScriptToastParamDurationLabelLxDebian;

  /// No description provided for @skapiScriptToastParamDurationHintLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Auto-dismiss after this many seconds. 0 means the toast stays until the user closes it.'**
  String get skapiScriptToastParamDurationHintLxDebian;

  /// No description provided for @skapiScriptShowDesktopSummaryHowLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Reads the EWMH show-desktop state via wmctrl -m, then toggles it with wmctrl -k. Mirrors Win+D semantics on X11.'**
  String get skapiScriptShowDesktopSummaryHowLxDebian;

  /// No description provided for @skapiScriptShowDesktopNoteLxDebian.
  ///
  /// In en, this message translates to:
  /// **'X11 only. Wayland equivalents are compositor-specific (Sway, Hyprland, GNOME Shell extensions).'**
  String get skapiScriptShowDesktopNoteLxDebian;

  /// No description provided for @skapiScriptFadeScreenSummaryHowLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Linearly fades the internal display backlight from current to target over the requested duration via brightnessctl in 10-step-per-second increments.'**
  String get skapiScriptFadeScreenSummaryHowLxDebian;

  /// No description provided for @skapiScriptFadeScreenNoteLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Internal panels only. External monitors over DDC need ddcutil and are not handled here. Tier 2 because reading the current backlight depends on /sys/class/backlight visibility.'**
  String get skapiScriptFadeScreenNoteLxDebian;

  /// No description provided for @skapiScriptGrayscaleSummaryHowLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Toggles GNOME\'s accessibility magnifier color-saturation key (0.0 grayscale, 1.0 color) via gsettings, no extension needed.'**
  String get skapiScriptGrayscaleSummaryHowLxDebian;

  /// No description provided for @skapiScriptGrayscaleNoteLxDebian.
  ///
  /// In en, this message translates to:
  /// **'GNOME / Unity only. KDE Plasma and XFCE have no equivalent system path; on those desktops the script exits with code 3 instead of a silent no-op.'**
  String get skapiScriptGrayscaleNoteLxDebian;

  /// No description provided for @skapiScriptFindMouseShakeSummaryHowLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Reads the cursor position via xdotool getmouselocation, then traces a circle around it for the requested loop count using awk-computed cos/sin coordinates.'**
  String get skapiScriptFindMouseShakeSummaryHowLxDebian;

  /// No description provided for @skapiScriptFindMouseShakeNoteLxDebian.
  ///
  /// In en, this message translates to:
  /// **'X11 only. Wayland blocks synthetic pointer motion at the protocol level (security boundary), so the script exits with code 3.'**
  String get skapiScriptFindMouseShakeNoteLxDebian;

  /// No description provided for @skapiScriptCloseWithSaveSummaryHowLxDebian.
  ///
  /// In en, this message translates to:
  /// **'For each visible window matching WM_CLASS: activate, Ctrl+S, wait, then send WM_DELETE_WINDOW via wmctrl. X11 only.'**
  String get skapiScriptCloseWithSaveSummaryHowLxDebian;

  /// No description provided for @skapiScriptCloseWithSaveNoteLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Tier 2: Ctrl+S key injection is locale and focus dependent; only true save semantics behave predictably. Chat or web apps may map Ctrl+S to something else.'**
  String get skapiScriptCloseWithSaveNoteLxDebian;

  /// No description provided for @skapiScriptCloseWithSaveParamProcessHintLxDebian.
  ///
  /// In en, this message translates to:
  /// **'WM_CLASS instance name (see xprop WM_CLASS). Required.'**
  String get skapiScriptCloseWithSaveParamProcessHintLxDebian;

  /// No description provided for @skapiScriptCloseAllInstancesSummaryHowLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Sends SIGTERM to every running process matching the exact comm name. Each app handles its own shutdown sequence (and may show its own save dialog).'**
  String get skapiScriptCloseAllInstancesSummaryHowLxDebian;

  /// No description provided for @skapiScriptCloseAllInstancesParamProcessHintLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Exact comm name as shown by pgrep -l. Required.'**
  String get skapiScriptCloseAllInstancesParamProcessHintLxDebian;

  /// No description provided for @skapiScriptBrowserCloseAllSummaryHowLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Walks a list of Debian browser binaries (firefox, firefox-esr, chromium, google-chrome, brave, vivaldi-bin, opera) and sends SIGTERM to each running instance.'**
  String get skapiScriptBrowserCloseAllSummaryHowLxDebian;

  /// No description provided for @skapiScriptBrowserCloseAllNoteLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Browsers preserve the session if \"restore tabs on next launch\" is on, so this is a soft \"switch off the screen\" rather than a data-loss action.'**
  String get skapiScriptBrowserCloseAllNoteLxDebian;

  /// No description provided for @skapiScriptSaveActiveWindowSummaryHowLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Sends Ctrl+S to the focused window via xdotool key --clearmodifiers. X11 only.'**
  String get skapiScriptSaveActiveWindowSummaryHowLxDebian;

  /// No description provided for @skapiScriptSaveActiveWindowNoteLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Wayland blocks synthetic key injection at the protocol level. Use autosave-trigger fallback or rely on the app\'s own autosave.'**
  String get skapiScriptSaveActiveWindowNoteLxDebian;

  /// No description provided for @skapiScriptSaveAllOpenSummaryHowLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Iterates the apps list, finds each app\'s visible windows, activates them in turn and sends Ctrl+S between waits.'**
  String get skapiScriptSaveAllOpenSummaryHowLxDebian;

  /// No description provided for @skapiScriptSaveAllOpenNoteLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Default app list covers LibreOffice (soffice.bin), VS Code (code), gedit and kate. Pass --apps \"name1,name2\" to override. X11 only.'**
  String get skapiScriptSaveAllOpenNoteLxDebian;

  /// No description provided for @skapiScriptSaveAllOpenParamAppsHintLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Comma-separated comm names, for example: soffice.bin,code,gedit.'**
  String get skapiScriptSaveAllOpenParamAppsHintLxDebian;

  /// No description provided for @skapiScriptAutosaveTriggerSummaryHowLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Walks every visible top-level window via wmctrl -l, activates each in turn and injects Ctrl+S. X11 lacks the WIN WM_COMMAND broadcast path so per-window focus is the fallback.'**
  String get skapiScriptAutosaveTriggerSummaryHowLxDebian;

  /// No description provided for @skapiScriptAutosaveTriggerNoteLxDebian.
  ///
  /// In en, this message translates to:
  /// **'Tier 2: depends on the focused app honouring Ctrl+S as \"save\". Most editors do; chat apps may misinterpret. X11 only.'**
  String get skapiScriptAutosaveTriggerNoteLxDebian;

  /// No description provided for @commonReadFailed.
  ///
  /// In en, this message translates to:
  /// **'couldn\'t read'**
  String get commonReadFailed;

  /// No description provided for @commonUnknown.
  ///
  /// In en, this message translates to:
  /// **'unknown'**
  String get commonUnknown;

  /// No description provided for @commonComingSoon.
  ///
  /// In en, this message translates to:
  /// **'coming soon'**
  String get commonComingSoon;

  /// No description provided for @commonDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get commonDismiss;

  /// No description provided for @bootstrapBannerError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t read from device: {error}'**
  String bootstrapBannerError(String error);

  /// No description provided for @bootstrapBannerRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get bootstrapBannerRetry;

  /// No description provided for @bfApiChainAuthNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get bfApiChainAuthNone;

  /// No description provided for @bfApiChainAuthBearer.
  ///
  /// In en, this message translates to:
  /// **'Bearer token'**
  String get bfApiChainAuthBearer;

  /// No description provided for @bfApiChainAuthBasic.
  ///
  /// In en, this message translates to:
  /// **'Basic auth'**
  String get bfApiChainAuthBasic;

  /// No description provided for @bfApiChainAuthHeader.
  ///
  /// In en, this message translates to:
  /// **'Custom header'**
  String get bfApiChainAuthHeader;

  /// No description provided for @bfApiChainMasterError.
  ///
  /// In en, this message translates to:
  /// **'Master: {error}'**
  String bfApiChainMasterError(String error);

  /// No description provided for @bfApiChainChainStarted.
  ///
  /// In en, this message translates to:
  /// **'Chain started'**
  String get bfApiChainChainStarted;

  /// No description provided for @bfApiChainChainError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String bfApiChainChainError(String error);

  /// No description provided for @bfApiChainSaveDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Save endpoint?'**
  String get bfApiChainSaveDialogTitle;

  /// No description provided for @bfApiChainSaveDialogBody.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" will be persisted on the device. This updates the user data area.'**
  String bfApiChainSaveDialogBody(String name);

  /// No description provided for @bfApiChainSaveDialogConfirm.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get bfApiChainSaveDialogConfirm;

  /// No description provided for @bfApiChainSavedToast.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" saved'**
  String bfApiChainSavedToast(String name);

  /// No description provided for @bfApiChainSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save: {error}'**
  String bfApiChainSaveFailed(String error);

  /// No description provided for @bfApiChainDeleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete?'**
  String get bfApiChainDeleteDialogTitle;

  /// No description provided for @bfApiChainDeleteDialogBody.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" endpoint will be removed from the device. This action cannot be undone.'**
  String bfApiChainDeleteDialogBody(String name);

  /// No description provided for @bfApiChainDeleteDialogConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get bfApiChainDeleteDialogConfirm;

  /// No description provided for @bfApiChainDeletedToast.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" deleted'**
  String bfApiChainDeletedToast(String name);

  /// No description provided for @bfApiChainDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete: {error}'**
  String bfApiChainDeleteFailed(String error);

  /// No description provided for @bfApiChainTestNoReply.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" no reply (15 s timeout)'**
  String bfApiChainTestNoReply(String name);

  /// No description provided for @bfApiChainTestSuccess.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" success{httpSuffix}'**
  String bfApiChainTestSuccess(String name, String httpSuffix);

  /// No description provided for @bfApiChainTestFailure.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" error: {error}{httpSuffix}'**
  String bfApiChainTestFailure(String name, String error, String httpSuffix);

  /// No description provided for @bfApiChainTestTriggerFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t trigger: {error}'**
  String bfApiChainTestTriggerFailed(String error);

  /// No description provided for @bfApiChainNewEndpointName.
  ///
  /// In en, this message translates to:
  /// **'New endpoint'**
  String get bfApiChainNewEndpointName;

  /// No description provided for @bfApiChainEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No endpoints registered yet'**
  String get bfApiChainEmptyTitle;

  /// No description provided for @bfApiChainEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Use the \"Add endpoint\" card below to define a new HTTP call (e.g. IFTTT webhook, your own server, Spotify pause).'**
  String get bfApiChainEmptyBody;

  /// No description provided for @bfApiChainSystemSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Automatic (paired SKAPPs)'**
  String get bfApiChainSystemSectionTitle;

  /// No description provided for @bfApiChainSystemSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'When you bind a script via SKAPI, a slot opens automatically for each computer. When the countdown ends, a signed webhook goes to the SKAPP on that computer.'**
  String get bfApiChainSystemSectionSubtitle;

  /// No description provided for @bfApiChainUserSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Manual (IoT devices)'**
  String get bfApiChainUserSectionTitle;

  /// No description provided for @bfApiChainUserSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add third-party URLs (Shelly, Home Assistant, IFTTT) by hand. When the countdown ends this list fires first, in order.'**
  String get bfApiChainUserSectionSubtitle;

  /// No description provided for @bfApiChainMasterToggleLabel.
  ///
  /// In en, this message translates to:
  /// **'Trigger active'**
  String get bfApiChainMasterToggleLabel;

  /// No description provided for @bfApiChainMasterOnSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Master on: chain fires on device triggers'**
  String get bfApiChainMasterOnSubtitle;

  /// No description provided for @bfApiChainMasterOffSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Master off: no endpoint will be called'**
  String get bfApiChainMasterOffSubtitle;

  /// No description provided for @bfApiChainFieldNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get bfApiChainFieldNameLabel;

  /// No description provided for @bfApiChainTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get bfApiChainTypeLabel;

  /// No description provided for @bfApiChainEventOrApplet.
  ///
  /// In en, this message translates to:
  /// **'Event / Applet'**
  String get bfApiChainEventOrApplet;

  /// No description provided for @bfApiChainMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get bfApiChainMethodLabel;

  /// No description provided for @bfApiChainDelayLabel.
  ///
  /// In en, this message translates to:
  /// **'Wait after (0-300 s)'**
  String get bfApiChainDelayLabel;

  /// No description provided for @bfApiChainDelayUnit.
  ///
  /// In en, this message translates to:
  /// **'s'**
  String get bfApiChainDelayUnit;

  /// No description provided for @bfApiChainAdvancedHide.
  ///
  /// In en, this message translates to:
  /// **'Hide advanced options'**
  String get bfApiChainAdvancedHide;

  /// No description provided for @bfApiChainAdvancedShow.
  ///
  /// In en, this message translates to:
  /// **'Advanced options'**
  String get bfApiChainAdvancedShow;

  /// No description provided for @bfApiChainAuthLabel.
  ///
  /// In en, this message translates to:
  /// **'Authentication'**
  String get bfApiChainAuthLabel;

  /// No description provided for @bfApiChainCurrentTokenHint.
  ///
  /// In en, this message translates to:
  /// **'Current token: {masked} (write a new value below to refresh)'**
  String bfApiChainCurrentTokenHint(String masked);

  /// No description provided for @bfApiChainNewTokenLabel.
  ///
  /// In en, this message translates to:
  /// **'New token (leave blank to keep)'**
  String get bfApiChainNewTokenLabel;

  /// No description provided for @bfApiChainContentTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Content-Type'**
  String get bfApiChainContentTypeLabel;

  /// No description provided for @bfApiChainSaveCta.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get bfApiChainSaveCta;

  /// No description provided for @bfApiChainDeleteCta.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get bfApiChainDeleteCta;

  /// No description provided for @bfApiChainTestCta.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get bfApiChainTestCta;

  /// No description provided for @bfApiChainAddCardLabel.
  ///
  /// In en, this message translates to:
  /// **'Add new endpoint'**
  String get bfApiChainAddCardLabel;

  /// No description provided for @bfApiChainSavedDelaySeconds.
  ///
  /// In en, this message translates to:
  /// **'{count} s wait'**
  String bfApiChainSavedDelaySeconds(int count);

  /// No description provided for @bfApiChainNotSaved.
  ///
  /// In en, this message translates to:
  /// **'not saved'**
  String get bfApiChainNotSaved;

  /// No description provided for @bfApiChainSystemRowSignedTooltip.
  ///
  /// In en, this message translates to:
  /// **'peer {peer}…  ·  delay {delay}s  ·  signed (HMAC)'**
  String bfApiChainSystemRowSignedTooltip(String peer, int delay);

  /// No description provided for @bfApiChainTestEndpointTooltip.
  ///
  /// In en, this message translates to:
  /// **'Test this endpoint'**
  String get bfApiChainTestEndpointTooltip;

  /// No description provided for @bfLogsBufferEmpty.
  ///
  /// In en, this message translates to:
  /// **'Device log buffer is empty.'**
  String get bfLogsBufferEmpty;

  /// No description provided for @bfLogsUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Device does not support logs in this firmware.'**
  String get bfLogsUnsupported;

  /// No description provided for @deviceLogsNoClockBanner.
  ///
  /// In en, this message translates to:
  /// **'Device clock not set; timestamps are shown as seconds since boot.'**
  String get deviceLogsNoClockBanner;

  /// No description provided for @deviceLogsTruncatedHint.
  ///
  /// In en, this message translates to:
  /// **'(output truncated, try a lower limit or a higher severity)'**
  String get deviceLogsTruncatedHint;

  /// No description provided for @bfEventsTimerRunning.
  ///
  /// In en, this message translates to:
  /// **'Countdown started'**
  String get bfEventsTimerRunning;

  /// No description provided for @bfEventsTimerPaused.
  ///
  /// In en, this message translates to:
  /// **'Countdown paused'**
  String get bfEventsTimerPaused;

  /// No description provided for @bfEventsTimerIdle.
  ///
  /// In en, this message translates to:
  /// **'Countdown reset'**
  String get bfEventsTimerIdle;

  /// No description provided for @bfEventsTimerCooldown.
  ///
  /// In en, this message translates to:
  /// **'Cooldown'**
  String get bfEventsTimerCooldown;

  /// No description provided for @bfEventsTimerExpired.
  ///
  /// In en, this message translates to:
  /// **'Countdown finished'**
  String get bfEventsTimerExpired;

  /// No description provided for @bfEventsFaceChanged.
  ///
  /// In en, this message translates to:
  /// **'Face changed: {from} → {to}'**
  String bfEventsFaceChanged(String from, String to);

  /// No description provided for @bfEventsApiTriggered.
  ///
  /// In en, this message translates to:
  /// **'{type} triggered'**
  String bfEventsApiTriggered(String type);

  /// No description provided for @bfEventsApiTriggeredFallback.
  ///
  /// In en, this message translates to:
  /// **'API triggered'**
  String get bfEventsApiTriggeredFallback;

  /// No description provided for @bfEventsBatteryLevel.
  ///
  /// In en, this message translates to:
  /// **'Battery level: %{percent}'**
  String bfEventsBatteryLevel(int percent);

  /// No description provided for @bfEventsDeviceRestarted.
  ///
  /// In en, this message translates to:
  /// **'Device restarted'**
  String get bfEventsDeviceRestarted;

  /// No description provided for @skapiManifestLoadingRetry.
  ///
  /// In en, this message translates to:
  /// **'{platform}/{scriptId} manifest loading, try again in a moment'**
  String skapiManifestLoadingRetry(String platform, String scriptId);

  /// No description provided for @skapiListenerOffMobileTitle.
  ///
  /// In en, this message translates to:
  /// **'This device cannot run Desktop scripts'**
  String get skapiListenerOffMobileTitle;

  /// No description provided for @skapiListenerOffDesktopTitle.
  ///
  /// In en, this message translates to:
  /// **'SKAPP HTTP listener is off'**
  String get skapiListenerOffDesktopTitle;

  /// No description provided for @skapiListenerOffMobileBody.
  ///
  /// In en, this message translates to:
  /// **'When the countdown ends, scripts will run on Windows / macOS / Linux. SKAPP must be open and the listener active. This phone is only the configuration side; execution happens on the desktop.'**
  String get skapiListenerOffMobileBody;

  /// No description provided for @skapiListenerOffDesktopBody.
  ///
  /// In en, this message translates to:
  /// **'BF will fire the webhook, but no one will catch it because the listener is off. Open Settings → SKAPP HTTP Listener.{lastErrorSuffix}'**
  String skapiListenerOffDesktopBody(String lastErrorSuffix);

  /// No description provided for @skapiSyncBadgeWriting.
  ///
  /// In en, this message translates to:
  /// **'Writing to BF…'**
  String get skapiSyncBadgeWriting;

  /// No description provided for @skapiSyncBadgeWritten.
  ///
  /// In en, this message translates to:
  /// **'Saved on BF'**
  String get skapiSyncBadgeWritten;

  /// No description provided for @skapiSyncBadgeFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t write to BF'**
  String get skapiSyncBadgeFailed;

  /// No description provided for @skapiSyncBadgeFirmwareCodeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Firmware code: {code}'**
  String skapiSyncBadgeFirmwareCodeTooltip(String code);

  /// No description provided for @syncErrUnknownCommand.
  ///
  /// In en, this message translates to:
  /// **'Old firmware on the device. Flash the new firmware'**
  String get syncErrUnknownCommand;

  /// No description provided for @syncErrNotAuthenticated.
  ///
  /// In en, this message translates to:
  /// **'Device session not authorised (re-pair may be needed)'**
  String get syncErrNotAuthenticated;

  /// No description provided for @syncErrNotFound.
  ///
  /// In en, this message translates to:
  /// **'No pairing record on the device'**
  String get syncErrNotFound;

  /// No description provided for @syncErrInternal.
  ///
  /// In en, this message translates to:
  /// **'8 SYSTEM slots may be full'**
  String get syncErrInternal;

  /// No description provided for @syncErrUnknown.
  ///
  /// In en, this message translates to:
  /// **'unknown error'**
  String get syncErrUnknown;

  /// No description provided for @syncErrTimeout.
  ///
  /// In en, this message translates to:
  /// **'Device didn\'t reply (offline?)'**
  String get syncErrTimeout;

  /// No description provided for @syncErrNoBond.
  ///
  /// In en, this message translates to:
  /// **'No pairing with this device'**
  String get syncErrNoBond;

  /// No description provided for @syncErrConnect.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t connect to device'**
  String get syncErrConnect;

  /// No description provided for @discoveryFilterShowAll.
  ///
  /// In en, this message translates to:
  /// **'Show all devices'**
  String get discoveryFilterShowAll;

  /// No description provided for @discoveryFilterOnlySmartKraft.
  ///
  /// In en, this message translates to:
  /// **'SmartKraft only'**
  String get discoveryFilterOnlySmartKraft;

  /// No description provided for @discoveryScanningWithCount.
  ///
  /// In en, this message translates to:
  /// **'Scanning… {count} device(s) found{tail}'**
  String discoveryScanningWithCount(int count, String tail);

  /// No description provided for @discoveryFoundCountWithTail.
  ///
  /// In en, this message translates to:
  /// **'{count} device(s) found{tail}'**
  String discoveryFoundCountWithTail(int count, String tail);

  /// No description provided for @discoveryFilterOff.
  ///
  /// In en, this message translates to:
  /// **'Filter off · {visible} device(s) shown ({sk} SmartKraft{tail})'**
  String discoveryFilterOff(int visible, int sk, String tail);

  /// No description provided for @discoveryMdnsTail.
  ///
  /// In en, this message translates to:
  /// **' + {count} on network'**
  String discoveryMdnsTail(int count);

  /// No description provided for @discoveryWifiOnlySnack.
  ///
  /// In en, this message translates to:
  /// **'This device is currently only visible over WiFi. WiFi pairing isn\'t active yet, briefly press the device\'s button to open the pairing window. Once it\'s also seen over BLE, this row becomes pairable.'**
  String get discoveryWifiOnlySnack;

  /// No description provided for @discoveryBadgePairable.
  ///
  /// In en, this message translates to:
  /// **'Pairable'**
  String get discoveryBadgePairable;

  /// No description provided for @discoveryBadgeBonded.
  ///
  /// In en, this message translates to:
  /// **'Paired with another SKAPP'**
  String get discoveryBadgeBonded;

  /// No description provided for @pairingTitleConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting'**
  String get pairingTitleConnecting;

  /// No description provided for @pairingTitleReconnecting.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting'**
  String get pairingTitleReconnecting;

  /// No description provided for @pairingMutualAuthHmacSubtitle.
  ///
  /// In en, this message translates to:
  /// **'HMAC challenge-response'**
  String get pairingMutualAuthHmacSubtitle;

  /// No description provided for @pairingBleConnectFailed.
  ///
  /// In en, this message translates to:
  /// **'BLE connection failed.\n\nFix: briefly press the device\'s button to open the 60-second pairing window, then tap \"Retry\".\n\nDetails: {error}'**
  String pairingBleConnectFailed(String error);

  /// No description provided for @pairingGattServiceMissing.
  ///
  /// In en, this message translates to:
  /// **'SKAPP service not found'**
  String get pairingGattServiceMissing;

  /// No description provided for @pairingGattCmdRxMissing.
  ///
  /// In en, this message translates to:
  /// **'cmd_rx characteristic missing'**
  String get pairingGattCmdRxMissing;

  /// No description provided for @pairingGattEventTxMissing.
  ///
  /// In en, this message translates to:
  /// **'event_tx characteristic missing'**
  String get pairingGattEventTxMissing;

  /// No description provided for @pairingGattDiscoveryFailed.
  ///
  /// In en, this message translates to:
  /// **'GATT discovery failed: {error}'**
  String pairingGattDiscoveryFailed(String error);

  /// No description provided for @pairingKeySendFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send key: {error}'**
  String pairingKeySendFailed(String error);

  /// No description provided for @pairingDeviceNoReply.
  ///
  /// In en, this message translates to:
  /// **'Device didn\'t reply ({seconds} s).'**
  String pairingDeviceNoReply(int seconds);

  /// No description provided for @pairingDeviceRejected.
  ///
  /// In en, this message translates to:
  /// **'Device rejected: {error}'**
  String pairingDeviceRejected(String error);

  /// No description provided for @pairingInvalidReplyMissingPub.
  ///
  /// In en, this message translates to:
  /// **'Invalid device reply (our_pub missing).'**
  String get pairingInvalidReplyMissingPub;

  /// No description provided for @pairingHexDecodeFailed.
  ///
  /// In en, this message translates to:
  /// **'our_pub hex decode failed: {error}'**
  String pairingHexDecodeFailed(String error);

  /// No description provided for @pairingRetryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get pairingRetryButton;

  /// No description provided for @pairingReconnectTransient.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach the device; the existing pairing is kept.\n\nMake sure the device is powered on and within range, then tap \"Retry\".\n\nDetails: {error}'**
  String pairingReconnectTransient(String error);

  /// No description provided for @pairingRecoveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Renew pairing'**
  String get pairingRecoveryTitle;

  /// No description provided for @pairingRecoveryBody.
  ///
  /// In en, this message translates to:
  /// **'The device doesn\'t recognize the current pairing. To start a fresh one, press the device\'s pairing button to open the 60-second window, then tap Continue.'**
  String get pairingRecoveryBody;

  /// No description provided for @pairingRecoveryContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get pairingRecoveryContinue;

  /// No description provided for @pairingRecoveryCancelled.
  ///
  /// In en, this message translates to:
  /// **'Pairing renewal cancelled. The old pairing is still on file; tap \"Retry\" to attempt another connection later.'**
  String get pairingRecoveryCancelled;

  /// No description provided for @pairingRenewBondButton.
  ///
  /// In en, this message translates to:
  /// **'Renew pairing'**
  String get pairingRenewBondButton;

  /// No description provided for @wifiPasswordConnectionRejected.
  ///
  /// In en, this message translates to:
  /// **'Connection rejected: {error}'**
  String wifiPasswordConnectionRejected(String error);

  /// No description provided for @wifiPasswordTimeout.
  ///
  /// In en, this message translates to:
  /// **'Device didn\'t reply (timeout).'**
  String get wifiPasswordTimeout;

  /// No description provided for @wifiScanRejected.
  ///
  /// In en, this message translates to:
  /// **'Device rejected wifi.scan: {error}\n\nThe device\'s WiFi module may not have started; try a reboot.'**
  String wifiScanRejected(String error);

  /// No description provided for @wifiScanUnexpectedReply.
  ///
  /// In en, this message translates to:
  /// **'Unexpected wifi.scan reply: {data}'**
  String wifiScanUnexpectedReply(String data);

  /// No description provided for @wifiScanTimeout.
  ///
  /// In en, this message translates to:
  /// **'Device didn\'t reply (timeout: {error}).\n\nGet closer to the device, briefly press its button (to trigger advertising) and try again.'**
  String wifiScanTimeout(String error);

  /// No description provided for @wifiScanConnectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection error: {error}'**
  String wifiScanConnectionError(String error);

  /// No description provided for @wifiScanHeaderHelp.
  ///
  /// In en, this message translates to:
  /// **'Below are the WiFi networks **the device** can see (not the phone\'s networks). Pick the network the device should join; the password is requested in the next step.'**
  String get wifiScanHeaderHelp;

  /// No description provided for @wifiScanAuthOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get wifiScanAuthOpen;

  /// No description provided for @wifiScanAuthEncrypted.
  ///
  /// In en, this message translates to:
  /// **'Encrypted'**
  String get wifiScanAuthEncrypted;

  /// No description provided for @wifiSuccessSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing time…'**
  String get wifiSuccessSyncing;

  /// No description provided for @wifiSuccessFetchingInfo.
  ///
  /// In en, this message translates to:
  /// **'Fetching device info…'**
  String get wifiSuccessFetchingInfo;

  /// No description provided for @wifiSuccessPreparingUi.
  ///
  /// In en, this message translates to:
  /// **'Preparing device UI…'**
  String get wifiSuccessPreparingUi;

  /// No description provided for @wifiSuccessManifestRejected.
  ///
  /// In en, this message translates to:
  /// **'device.manifest rejected ({error}). It may be old firmware; sk_baseline.c must be loaded for BF.'**
  String wifiSuccessManifestRejected(String error);

  /// No description provided for @wifiSuccessTapToContinue.
  ///
  /// In en, this message translates to:
  /// **'Tap to continue…'**
  String get wifiSuccessTapToContinue;

  /// No description provided for @deviceHomeUnsupportedTitle.
  ///
  /// In en, this message translates to:
  /// **'Unsupported device'**
  String get deviceHomeUnsupportedTitle;

  /// No description provided for @deviceHomeUnsupportedBody.
  ///
  /// In en, this message translates to:
  /// **'{name} has no device screen in this SKAPP version. When a new device family is added this screen will appear automatically.'**
  String deviceHomeUnsupportedBody(String name);

  /// No description provided for @lsPairingUnpairTitle.
  ///
  /// In en, this message translates to:
  /// **'Unpair this APP'**
  String get lsPairingUnpairTitle;

  /// No description provided for @lsPairingUnpairBody.
  ///
  /// In en, this message translates to:
  /// **'The device will forget this APP\'s bond. You\'ll need to pair again (3 s button + select in Devices).'**
  String get lsPairingUnpairBody;

  /// No description provided for @skYakindaBadgeDefault.
  ///
  /// In en, this message translates to:
  /// **'coming soon'**
  String get skYakindaBadgeDefault;

  /// No description provided for @skapiScriptPulseBrightnessTitle.
  ///
  /// In en, this message translates to:
  /// **'Pulse Brightness'**
  String get skapiScriptPulseBrightnessTitle;

  /// No description provided for @skapiScriptPulseBrightnessSummaryWhat.
  ///
  /// In en, this message translates to:
  /// **'Modulates internal display brightness on a smooth cosine wave between 100% and a lower bound, repeated a set number of times. The user\'s original brightness is restored at the end.'**
  String get skapiScriptPulseBrightnessSummaryWhat;

  /// No description provided for @skapiScriptPulseBrightnessSummaryHow.
  ///
  /// In en, this message translates to:
  /// **'Reads the current brightness through WMI, then writes a brightness sample 20 times per second following a cosine curve. Always restores the captured original on exit.'**
  String get skapiScriptPulseBrightnessSummaryHow;

  /// No description provided for @skapiScriptPulseBrightnessNote.
  ///
  /// In en, this message translates to:
  /// **'Internal panels only (laptops, tablets). External DDC/CI monitors do not respond to this WMI path.'**
  String get skapiScriptPulseBrightnessNote;

  /// No description provided for @skapiScriptPulseBrightnessParamPeriodLabel.
  ///
  /// In en, this message translates to:
  /// **'period'**
  String get skapiScriptPulseBrightnessParamPeriodLabel;

  /// No description provided for @skapiScriptPulseBrightnessParamPeriodHint.
  ///
  /// In en, this message translates to:
  /// **'Seconds for one full bright -> dim -> bright cycle. Around 2 feels like a clear pulse without being jarring.'**
  String get skapiScriptPulseBrightnessParamPeriodHint;

  /// No description provided for @skapiScriptPulseBrightnessParamLowPercentLabel.
  ///
  /// In en, this message translates to:
  /// **'low %'**
  String get skapiScriptPulseBrightnessParamLowPercentLabel;

  /// No description provided for @skapiScriptPulseBrightnessParamLowPercentHint.
  ///
  /// In en, this message translates to:
  /// **'Dim end of the pulse, as a percentage of full brightness. Lower numbers make the pulse more dramatic.'**
  String get skapiScriptPulseBrightnessParamLowPercentHint;

  /// No description provided for @skapiScriptPulseBrightnessParamCyclesLabel.
  ///
  /// In en, this message translates to:
  /// **'cycles'**
  String get skapiScriptPulseBrightnessParamCyclesLabel;

  /// No description provided for @skapiScriptPulseBrightnessParamCyclesHint.
  ///
  /// In en, this message translates to:
  /// **'How many full pulse cycles to run before exiting.'**
  String get skapiScriptPulseBrightnessParamCyclesHint;

  /// No description provided for @skapiScriptBlurTimedTitle.
  ///
  /// In en, this message translates to:
  /// **'Blurred Break'**
  String get skapiScriptBlurTimedTitle;

  /// No description provided for @skapiScriptBlurTimedSummaryWhat.
  ///
  /// In en, this message translates to:
  /// **'Covers the screen with a fullscreen, always-on-top semi-transparent veil for the configured number of seconds. A countdown is shown in the middle.'**
  String get skapiScriptBlurTimedSummaryWhat;

  /// No description provided for @skapiScriptBlurTimedSummaryHow.
  ///
  /// In en, this message translates to:
  /// **'Opens a borderless WPF window with AllowsTransparency and a solid colour brush at the chosen opacity. A dispatcher timer drives the countdown; the window closes itself when the timer hits zero.'**
  String get skapiScriptBlurTimedSummaryHow;

  /// No description provided for @skapiScriptBlurTimedNote.
  ///
  /// In en, this message translates to:
  /// **'Pragmatic interim: real-time Gaussian blur over the desktop needs a C++/Win2D helper that ships later. The solid veil creates similar \'I can\'t focus on the screen, take a break\' friction in the meantime.'**
  String get skapiScriptBlurTimedNote;

  /// No description provided for @skapiScriptBlurTimedParamDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'duration'**
  String get skapiScriptBlurTimedParamDurationLabel;

  /// No description provided for @skapiScriptBlurTimedParamDurationHint.
  ///
  /// In en, this message translates to:
  /// **'Seconds the veil stays up before closing automatically.'**
  String get skapiScriptBlurTimedParamDurationHint;

  /// No description provided for @skapiScriptBlurTimedParamOpacityLabel.
  ///
  /// In en, this message translates to:
  /// **'opacity'**
  String get skapiScriptBlurTimedParamOpacityLabel;

  /// No description provided for @skapiScriptBlurTimedParamOpacityHint.
  ///
  /// In en, this message translates to:
  /// **'Veil opacity 0.0 (invisible) to 1.0 (solid). Around 0.55 still lets the desktop bleed through enough to feel veiled, not blacked out.'**
  String get skapiScriptBlurTimedParamOpacityHint;

  /// No description provided for @skapiScriptBlurTimedParamColorLabel.
  ///
  /// In en, this message translates to:
  /// **'color'**
  String get skapiScriptBlurTimedParamColorLabel;

  /// No description provided for @skapiScriptBlurTimedParamColorHint.
  ///
  /// In en, this message translates to:
  /// **'Veil colour in #RRGGBB hex. Palette black #0A0A0A is the default; lighter cream tones feel calmer.'**
  String get skapiScriptBlurTimedParamColorHint;

  /// No description provided for @skapiScriptBlockingFocusTitle.
  ///
  /// In en, this message translates to:
  /// **'Blocking Focus'**
  String get skapiScriptBlockingFocusTitle;

  /// No description provided for @skapiScriptBlockingFocusSummaryWhat.
  ///
  /// In en, this message translates to:
  /// **'Composite focus enforcer: saves all open Office and VS Code documents, then opens a fullscreen always-on-top countdown window with no close button while the mouse cursor circles continuously. When the timer hits zero everything is undone automatically.'**
  String get skapiScriptBlockingFocusSummaryWhat;

  /// No description provided for @skapiScriptBlockingFocusSummaryHow.
  ///
  /// In en, this message translates to:
  /// **'Three phases run back to back: (1) save phase calls Office COM and VS Code CLI; (2) a parallel runspace drives the cursor in a circle until a synchronized stop flag flips; (3) an STA WPF window shows the title and countdown. A finally block restores cursor origin and tears down both runspaces.'**
  String get skapiScriptBlockingFocusSummaryHow;

  /// No description provided for @skapiScriptBlockingFocusNote.
  ///
  /// In en, this message translates to:
  /// **'Soft mode: Esc and Alt+F4 are NOT blocked. The user can always escape via Task Manager. Strict mode with global keyboard hooks will be a separate script.'**
  String get skapiScriptBlockingFocusNote;

  /// No description provided for @skapiScriptBlockingFocusParamDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'duration'**
  String get skapiScriptBlockingFocusParamDurationLabel;

  /// No description provided for @skapiScriptBlockingFocusParamDurationHint.
  ///
  /// In en, this message translates to:
  /// **'Seconds the lockdown lasts. The countdown ticks down to 00:00 then everything cleans up.'**
  String get skapiScriptBlockingFocusParamDurationHint;

  /// No description provided for @skapiScriptBlockingFocusParamTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'title'**
  String get skapiScriptBlockingFocusParamTitleLabel;

  /// No description provided for @skapiScriptBlockingFocusParamTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Text shown in the middle of the fullscreen window. Keep it short - \'Blocking Focus\' is the default.'**
  String get skapiScriptBlockingFocusParamTitleHint;

  /// No description provided for @skapiScriptBlockingFocusParamShakeRadiusLabel.
  ///
  /// In en, this message translates to:
  /// **'shake radius'**
  String get skapiScriptBlockingFocusParamShakeRadiusLabel;

  /// No description provided for @skapiScriptBlockingFocusParamShakeRadiusHint.
  ///
  /// In en, this message translates to:
  /// **'Pixels the cursor travels from its origin while looping. Bigger circles feel more demanding of attention.'**
  String get skapiScriptBlockingFocusParamShakeRadiusHint;

  /// No description provided for @skapiScriptBlockingFocusParamEnableSaveLabel.
  ///
  /// In en, this message translates to:
  /// **'save on start'**
  String get skapiScriptBlockingFocusParamEnableSaveLabel;

  /// No description provided for @skapiScriptBlockingFocusParamEnableSaveHint.
  ///
  /// In en, this message translates to:
  /// **'Run the Office + VS Code save phase before the lockdown. Turn off when there is no document state to protect.'**
  String get skapiScriptBlockingFocusParamEnableSaveHint;

  /// No description provided for @trayFirstHideToast.
  ///
  /// In en, this message translates to:
  /// **'SKAPP keeps running in the background. Find it in the system tray; right-click for Quit.'**
  String get trayFirstHideToast;

  /// No description provided for @devicesOfflineTapHint.
  ///
  /// In en, this message translates to:
  /// **'{name} is offline.'**
  String devicesOfflineTapHint(String name);

  /// No description provided for @skapiNewActionDeviceOffline.
  ///
  /// In en, this message translates to:
  /// **'{name} is offline. Bring it online to create a new action.'**
  String skapiNewActionDeviceOffline(String name);

  /// No description provided for @bfApiChainRefreshDirtyTitle.
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes'**
  String get bfApiChainRefreshDirtyTitle;

  /// No description provided for @bfApiChainRefreshDirtyBody.
  ///
  /// In en, this message translates to:
  /// **'Refresh will pull the latest endpoint list from the device and discard the draft you haven\'t saved yet.'**
  String get bfApiChainRefreshDirtyBody;

  /// No description provided for @bfApiChainRefreshDirtyConfirm.
  ///
  /// In en, this message translates to:
  /// **'Refresh anyway'**
  String get bfApiChainRefreshDirtyConfirm;

  /// No description provided for @skapiApiEditorTitle.
  ///
  /// In en, this message translates to:
  /// **'On-device API'**
  String get skapiApiEditorTitle;

  /// No description provided for @lsCommonReadFailed.
  ///
  /// In en, this message translates to:
  /// **'Read failed'**
  String get lsCommonReadFailed;

  /// No description provided for @lsCommonFailedWith.
  ///
  /// In en, this message translates to:
  /// **'Failed: {err}'**
  String lsCommonFailedWith(String err);

  /// No description provided for @lsVacationStatusOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get lsVacationStatusOff;

  /// No description provided for @lsVacationStatusUntil.
  ///
  /// In en, this message translates to:
  /// **'Until {date}'**
  String lsVacationStatusUntil(String date);

  /// No description provided for @lsVacationDaysValidationError.
  ///
  /// In en, this message translates to:
  /// **'Days must be between 1 and 60'**
  String get lsVacationDaysValidationError;

  /// No description provided for @lsVacationStartedSnack.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{Vacation started · 1 day} other{Vacation started · {days} days}}'**
  String lsVacationStartedSnack(int days);

  /// No description provided for @lsVacationCancelledSnack.
  ///
  /// In en, this message translates to:
  /// **'Vacation cancelled'**
  String get lsVacationCancelledSnack;

  /// No description provided for @lsVacationActiveUntilFmt.
  ///
  /// In en, this message translates to:
  /// **'Active until {date}'**
  String lsVacationActiveUntilFmt(String date);

  /// No description provided for @lsVacationResumeHint.
  ///
  /// In en, this message translates to:
  /// **'Countdown will resume when vacation ends.'**
  String get lsVacationResumeHint;

  /// No description provided for @lsVacationCancellingButton.
  ///
  /// In en, this message translates to:
  /// **'Cancelling…'**
  String get lsVacationCancellingButton;

  /// No description provided for @lsVacationCancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel vacation'**
  String get lsVacationCancelButton;

  /// No description provided for @lsVacationDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get lsVacationDaysLabel;

  /// No description provided for @lsVacationDaysHint.
  ///
  /// In en, this message translates to:
  /// **'Pauses the countdown for this many days (1 to 60).'**
  String get lsVacationDaysHint;

  /// No description provided for @lsVacationStartingButton.
  ///
  /// In en, this message translates to:
  /// **'Starting…'**
  String get lsVacationStartingButton;

  /// No description provided for @lsVacationStartButton.
  ///
  /// In en, this message translates to:
  /// **'Start vacation'**
  String get lsVacationStartButton;

  /// No description provided for @lsCommonSavingButton.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get lsCommonSavingButton;

  /// No description provided for @lsCommonSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get lsCommonSaveButton;

  /// No description provided for @lsCommonSaveFailedWith.
  ///
  /// In en, this message translates to:
  /// **'Save failed: {err}'**
  String lsCommonSaveFailedWith(String err);

  /// No description provided for @lsDurationValueValidationError.
  ///
  /// In en, this message translates to:
  /// **'Value must be between 1 and 60'**
  String get lsDurationValueValidationError;

  /// No description provided for @lsDurationAlarmsValidationError.
  ///
  /// In en, this message translates to:
  /// **'Alarm count must be between 0 and 10'**
  String get lsDurationAlarmsValidationError;

  /// No description provided for @lsDurationConfiguredSnack.
  ///
  /// In en, this message translates to:
  /// **'Timer configured'**
  String get lsDurationConfiguredSnack;

  /// No description provided for @lsDurationUnitMinute.
  ///
  /// In en, this message translates to:
  /// **'{value, plural, =1{1 minute} other{{value} minutes}}'**
  String lsDurationUnitMinute(int value);

  /// No description provided for @lsDurationUnitHour.
  ///
  /// In en, this message translates to:
  /// **'{value, plural, =1{1 hour} other{{value} hours}}'**
  String lsDurationUnitHour(int value);

  /// No description provided for @lsDurationUnitDay.
  ///
  /// In en, this message translates to:
  /// **'{value, plural, =1{1 day} other{{value} days}}'**
  String lsDurationUnitDay(int value);

  /// No description provided for @lsDurationAlarmCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 alarm} other{{count} alarms}}'**
  String lsDurationAlarmCount(int count);

  /// No description provided for @lsDurationUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get lsDurationUnitLabel;

  /// No description provided for @lsDurationUnitMinutesPlural.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get lsDurationUnitMinutesPlural;

  /// No description provided for @lsDurationUnitHoursPlural.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get lsDurationUnitHoursPlural;

  /// No description provided for @lsDurationUnitDaysPlural.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get lsDurationUnitDaysPlural;

  /// No description provided for @lsDurationValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get lsDurationValueLabel;

  /// No description provided for @lsDurationValueHint.
  ///
  /// In en, this message translates to:
  /// **'1 to 60'**
  String get lsDurationValueHint;

  /// No description provided for @lsDurationAlarmCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Alarm count'**
  String get lsDurationAlarmCountLabel;

  /// No description provided for @lsDurationAlarmCountHint.
  ///
  /// In en, this message translates to:
  /// **'Alarms fire backwards from the end, one unit apart.'**
  String get lsDurationAlarmCountHint;

  /// No description provided for @lsSmtpStatusNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Not configured'**
  String get lsSmtpStatusNotConfigured;

  /// No description provided for @lsSmtpHostRequired.
  ///
  /// In en, this message translates to:
  /// **'Host is required'**
  String get lsSmtpHostRequired;

  /// No description provided for @lsSmtpPortValidationError.
  ///
  /// In en, this message translates to:
  /// **'Port must be between 1 and 65535'**
  String get lsSmtpPortValidationError;

  /// No description provided for @lsSmtpSenderRequired.
  ///
  /// In en, this message translates to:
  /// **'Sender address is required'**
  String get lsSmtpSenderRequired;

  /// No description provided for @lsSmtpFieldHost.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get lsSmtpFieldHost;

  /// No description provided for @lsSmtpFieldPort.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get lsSmtpFieldPort;

  /// No description provided for @lsSmtpFieldSender.
  ///
  /// In en, this message translates to:
  /// **'Sender'**
  String get lsSmtpFieldSender;

  /// No description provided for @lsSmtpFieldKey.
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get lsSmtpFieldKey;

  /// No description provided for @lsSmtpSaveHaltedOn.
  ///
  /// In en, this message translates to:
  /// **'Save halted on {err}'**
  String lsSmtpSaveHaltedOn(String err);

  /// No description provided for @lsSmtpSavedSnack.
  ///
  /// In en, this message translates to:
  /// **'SMTP saved'**
  String get lsSmtpSavedSnack;

  /// No description provided for @lsSmtpTestSentSnack.
  ///
  /// In en, this message translates to:
  /// **'Test mail sent'**
  String get lsSmtpTestSentSnack;

  /// No description provided for @lsSmtpTestFailedWith.
  ///
  /// In en, this message translates to:
  /// **'Test failed: {err}'**
  String lsSmtpTestFailedWith(String err);

  /// No description provided for @lsSmtpUrlCopiedSnack.
  ///
  /// In en, this message translates to:
  /// **'URL copied to clipboard'**
  String get lsSmtpUrlCopiedSnack;

  /// No description provided for @lsSmtpApiKeyPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Gmail App Password / API key'**
  String get lsSmtpApiKeyPlaceholder;

  /// No description provided for @lsSmtpServerLabel.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get lsSmtpServerLabel;

  /// No description provided for @lsSmtpApiKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'API key'**
  String get lsSmtpApiKeyLabel;

  /// No description provided for @lsSmtpApiKeyHint.
  ///
  /// In en, this message translates to:
  /// **'Leave blank to keep the current key.'**
  String get lsSmtpApiKeyHint;

  /// No description provided for @lsSmtpAppPasswordHelpLink.
  ///
  /// In en, this message translates to:
  /// **'How to get a Gmail App Password'**
  String get lsSmtpAppPasswordHelpLink;

  /// No description provided for @lsSmtpSendingButton.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get lsSmtpSendingButton;

  /// No description provided for @lsSmtpSendTestButton.
  ///
  /// In en, this message translates to:
  /// **'Send test'**
  String get lsSmtpSendTestButton;

  /// No description provided for @lsReminderMailRecipientValidation.
  ///
  /// In en, this message translates to:
  /// **'Recipient must look like an email address'**
  String get lsReminderMailRecipientValidation;

  /// No description provided for @lsReminderMailSavedSnack.
  ///
  /// In en, this message translates to:
  /// **'Reminder saved locally'**
  String get lsReminderMailSavedSnack;

  /// No description provided for @lsReminderMailRecipientFirstSnack.
  ///
  /// In en, this message translates to:
  /// **'Set a recipient first'**
  String get lsReminderMailRecipientFirstSnack;

  /// No description provided for @lsReminderMailTestOkSnack.
  ///
  /// In en, this message translates to:
  /// **'SMTP test OK, credentials reach the server'**
  String get lsReminderMailTestOkSnack;

  /// No description provided for @lsReminderMailTestFailedWith.
  ///
  /// In en, this message translates to:
  /// **'SMTP test failed: {err}'**
  String lsReminderMailTestFailedWith(String err);

  /// No description provided for @lsReminderMailRecipientLabel.
  ///
  /// In en, this message translates to:
  /// **'Recipient email'**
  String get lsReminderMailRecipientLabel;

  /// No description provided for @lsReminderMailSubjectLabel.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get lsReminderMailSubjectLabel;

  /// No description provided for @lsReminderMailBodyLabel.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get lsReminderMailBodyLabel;

  /// No description provided for @lsReminderMailBodyHint.
  ///
  /// In en, this message translates to:
  /// **'Your countdown will trigger soon...'**
  String get lsReminderMailBodyHint;

  /// No description provided for @lsReminderMailActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get lsReminderMailActiveLabel;

  /// No description provided for @lsReminderMailFootnote.
  ///
  /// In en, this message translates to:
  /// **'Saved locally on this device. Send-test only verifies the SMTP server is reachable; auto-fire on timer.alarm is pending firmware support.'**
  String get lsReminderMailFootnote;

  /// No description provided for @lsResetApiStatusDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get lsResetApiStatusDisabled;

  /// No description provided for @lsResetApiStatusEnabledPort.
  ///
  /// In en, this message translates to:
  /// **'Enabled · port {port}'**
  String lsResetApiStatusEnabledPort(int port);

  /// No description provided for @lsResetApiRegenDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Regenerate API key?'**
  String get lsResetApiRegenDialogTitle;

  /// No description provided for @lsResetApiRegenDialogBody.
  ///
  /// In en, this message translates to:
  /// **'This will invalidate the current key. Any caller using the previous key will be rejected until you update it. Continue?'**
  String get lsResetApiRegenDialogBody;

  /// No description provided for @lsResetApiRegenConfirm.
  ///
  /// In en, this message translates to:
  /// **'Regenerate'**
  String get lsResetApiRegenConfirm;

  /// No description provided for @lsResetApiKeyRegeneratedSnack.
  ///
  /// In en, this message translates to:
  /// **'Key regenerated'**
  String get lsResetApiKeyRegeneratedSnack;

  /// No description provided for @lsResetApiEnabledLabel.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get lsResetApiEnabledLabel;

  /// No description provided for @lsResetApiEnabledHint.
  ///
  /// In en, this message translates to:
  /// **'When on, an HTTP GET to the endpoint URL with the matching key resets the countdown.'**
  String get lsResetApiEnabledHint;

  /// No description provided for @lsResetApiEndpointUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Endpoint URL'**
  String get lsResetApiEndpointUrlLabel;

  /// No description provided for @lsResetApiUrlNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'(not available)'**
  String get lsResetApiUrlNotAvailable;

  /// No description provided for @lsResetApiCopyUrlTooltip.
  ///
  /// In en, this message translates to:
  /// **'Copy URL'**
  String get lsResetApiCopyUrlTooltip;

  /// No description provided for @lsResetApiKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'API key'**
  String get lsResetApiKeyLabel;

  /// No description provided for @lsResetApiKeyNotSet.
  ///
  /// In en, this message translates to:
  /// **'(not set)'**
  String get lsResetApiKeyNotSet;

  /// No description provided for @lsResetApiExampleLabel.
  ///
  /// In en, this message translates to:
  /// **'Example'**
  String get lsResetApiExampleLabel;

  /// No description provided for @lsResetApiRegenerateButton.
  ///
  /// In en, this message translates to:
  /// **'Regenerate key'**
  String get lsResetApiRegenerateButton;

  /// No description provided for @lsAlarmApiUrlValidation.
  ///
  /// In en, this message translates to:
  /// **'URL must start with http:// or https://'**
  String get lsAlarmApiUrlValidation;

  /// No description provided for @lsAlarmApiHeadersValidation.
  ///
  /// In en, this message translates to:
  /// **'Headers field must be valid JSON'**
  String get lsAlarmApiHeadersValidation;

  /// No description provided for @lsAlarmApiSaveDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Save webhook endpoint?'**
  String get lsAlarmApiSaveDialogTitle;

  /// No description provided for @lsAlarmApiSaveDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Stores `{name}` on the device pointing at:\n{url}'**
  String lsAlarmApiSaveDialogBody(String name, String url);

  /// No description provided for @lsAlarmApiSavedSnack.
  ///
  /// In en, this message translates to:
  /// **'Webhook saved'**
  String get lsAlarmApiSavedSnack;

  /// No description provided for @lsAlarmApiDisabledSnack.
  ///
  /// In en, this message translates to:
  /// **'Webhook disabled'**
  String get lsAlarmApiDisabledSnack;

  /// No description provided for @lsAlarmApiTestQueuedSnack.
  ///
  /// In en, this message translates to:
  /// **'Test queued, watch the upstream service'**
  String get lsAlarmApiTestQueuedSnack;

  /// No description provided for @lsAlarmApiTestFailedWith.
  ///
  /// In en, this message translates to:
  /// **'Test failed: {err}'**
  String lsAlarmApiTestFailedWith(String err);

  /// No description provided for @lsAlarmApiRemoveDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove webhook?'**
  String get lsAlarmApiRemoveDialogTitle;

  /// No description provided for @lsAlarmApiRemoveDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Deletes `{name}` from the device. Local config is kept.'**
  String lsAlarmApiRemoveDialogBody(String name);

  /// No description provided for @lsAlarmApiRemoveButton.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get lsAlarmApiRemoveButton;

  /// No description provided for @lsAlarmApiRemoveFailedWith.
  ///
  /// In en, this message translates to:
  /// **'Remove failed: {err}'**
  String lsAlarmApiRemoveFailedWith(String err);

  /// No description provided for @lsAlarmApiConfiguredStatus.
  ///
  /// In en, this message translates to:
  /// **'Configured'**
  String get lsAlarmApiConfiguredStatus;

  /// No description provided for @lsAlarmApiConfiguredHost.
  ///
  /// In en, this message translates to:
  /// **'Configured · {host}'**
  String lsAlarmApiConfiguredHost(String host);

  /// No description provided for @lsAlarmApiUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get lsAlarmApiUrlLabel;

  /// No description provided for @lsAlarmApiMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'HTTP method'**
  String get lsAlarmApiMethodLabel;

  /// No description provided for @lsAlarmApiHeadersLabel.
  ///
  /// In en, this message translates to:
  /// **'Headers (JSON, optional)'**
  String get lsAlarmApiHeadersLabel;

  /// No description provided for @lsAlarmApiHeadersHint.
  ///
  /// In en, this message translates to:
  /// **'JSON object with optional headers. Saved locally; firmware applies on fire.'**
  String get lsAlarmApiHeadersHint;

  /// No description provided for @lsAlarmApiBodyTemplateLabel.
  ///
  /// In en, this message translates to:
  /// **'Body template (JSON)'**
  String get lsAlarmApiBodyTemplateLabel;

  /// No description provided for @lsAlarmApiBodyTemplateHint.
  ///
  /// In en, this message translates to:
  /// **'Placeholders device and remaining_sec substitute at fire time.'**
  String get lsAlarmApiBodyTemplateHint;

  /// No description provided for @lsAlarmApiBearerLabel.
  ///
  /// In en, this message translates to:
  /// **'Bearer token (optional)'**
  String get lsAlarmApiBearerLabel;

  /// No description provided for @lsAlarmApiFootnote.
  ///
  /// In en, this message translates to:
  /// **'Firmware subscriber for the timer.alarm event is pending. This config stores the endpoint; it will not auto-fire until the next firmware update.'**
  String get lsAlarmApiFootnote;

  /// No description provided for @lsRelaySummarySeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String lsRelaySummarySeconds(int seconds);

  /// No description provided for @lsRelaySummaryMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String lsRelaySummaryMinutes(int minutes);

  /// No description provided for @lsRelayModePulse.
  ///
  /// In en, this message translates to:
  /// **'pulse'**
  String get lsRelayModePulse;

  /// No description provided for @lsRelayModeSteady.
  ///
  /// In en, this message translates to:
  /// **'steady'**
  String get lsRelayModeSteady;

  /// No description provided for @lsRelaySummaryFmt.
  ///
  /// In en, this message translates to:
  /// **'GPIO {gpio} · {duration} {mode}'**
  String lsRelaySummaryFmt(int gpio, String duration, String mode);

  /// No description provided for @lsRelayGpioValidation.
  ///
  /// In en, this message translates to:
  /// **'GPIO must be between 0 and 30'**
  String get lsRelayGpioValidation;

  /// No description provided for @lsRelayDurationValidation.
  ///
  /// In en, this message translates to:
  /// **'Duration must be between 1 and 3600 seconds'**
  String get lsRelayDurationValidation;

  /// No description provided for @lsRelayPulseValidation.
  ///
  /// In en, this message translates to:
  /// **'Pulse half-cycle must be between 1 and 60'**
  String get lsRelayPulseValidation;

  /// No description provided for @lsRelayCmdFailedWith.
  ///
  /// In en, this message translates to:
  /// **'{cmd} failed: {err}'**
  String lsRelayCmdFailedWith(String cmd, String err);

  /// No description provided for @lsRelayConfiguredSnack.
  ///
  /// In en, this message translates to:
  /// **'Relay configured'**
  String get lsRelayConfiguredSnack;

  /// No description provided for @lsRelayFireAbortedSnack.
  ///
  /// In en, this message translates to:
  /// **'Fire aborted'**
  String get lsRelayFireAbortedSnack;

  /// No description provided for @lsRelayForcedIdleSnack.
  ///
  /// In en, this message translates to:
  /// **'Relay forced idle'**
  String get lsRelayForcedIdleSnack;

  /// No description provided for @lsRelayGpioLabel.
  ///
  /// In en, this message translates to:
  /// **'GPIO pin'**
  String get lsRelayGpioLabel;

  /// No description provided for @lsRelayGpioHint.
  ///
  /// In en, this message translates to:
  /// **'ESP32-C6 valid pin; default 19 = D8'**
  String get lsRelayGpioHint;

  /// No description provided for @lsRelayInvertLabel.
  ///
  /// In en, this message translates to:
  /// **'Invert polarity'**
  String get lsRelayInvertLabel;

  /// No description provided for @lsRelayStartDelayLabel.
  ///
  /// In en, this message translates to:
  /// **'Start delay'**
  String get lsRelayStartDelayLabel;

  /// No description provided for @lsRelayStartDelayHint.
  ///
  /// In en, this message translates to:
  /// **'{sec}s before relay activates'**
  String lsRelayStartDelayHint(int sec);

  /// No description provided for @lsRelayActiveDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Active duration'**
  String get lsRelayActiveDurationLabel;

  /// No description provided for @lsRelayUnitSeconds.
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get lsRelayUnitSeconds;

  /// No description provided for @lsRelayUnitMinutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get lsRelayUnitMinutes;

  /// No description provided for @lsRelayPulseModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Pulse mode'**
  String get lsRelayPulseModeLabel;

  /// No description provided for @lsRelayPulseModeHint.
  ///
  /// In en, this message translates to:
  /// **'On = 1 s half-cycle. Custom lets you set the half-cycle.'**
  String get lsRelayPulseModeHint;

  /// No description provided for @lsRelayHalfCycleLabel.
  ///
  /// In en, this message translates to:
  /// **'Half-cycle seconds'**
  String get lsRelayHalfCycleLabel;

  /// No description provided for @lsRelayFiringButton.
  ///
  /// In en, this message translates to:
  /// **'Firing…'**
  String get lsRelayFiringButton;

  /// No description provided for @lsRelayTestRelayButton.
  ///
  /// In en, this message translates to:
  /// **'Test relay'**
  String get lsRelayTestRelayButton;

  /// No description provided for @lsRelayAbortButton.
  ///
  /// In en, this message translates to:
  /// **'Abort'**
  String get lsRelayAbortButton;

  /// No description provided for @lsRelayForceOffButton.
  ///
  /// In en, this message translates to:
  /// **'Force off'**
  String get lsRelayForceOffButton;

  /// No description provided for @lsRelayPulseOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get lsRelayPulseOff;

  /// No description provided for @lsRelayPulseOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get lsRelayPulseOn;

  /// No description provided for @lsRelayPulseCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get lsRelayPulseCustom;

  /// No description provided for @lsRelayPhaseActiveBadge.
  ///
  /// In en, this message translates to:
  /// **'active'**
  String get lsRelayPhaseActiveBadge;

  /// No description provided for @lsRelayPhaseLine.
  ///
  /// In en, this message translates to:
  /// **'Phase: {phase}{elapsed}'**
  String lsRelayPhaseLine(String phase, String elapsed);

  /// No description provided for @lsTelegramTokenRequired.
  ///
  /// In en, this message translates to:
  /// **'Bot token is required'**
  String get lsTelegramTokenRequired;

  /// No description provided for @lsTelegramChatRequired.
  ///
  /// In en, this message translates to:
  /// **'Chat id is required'**
  String get lsTelegramChatRequired;

  /// No description provided for @lsTelegramSaveDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Save Telegram endpoint?'**
  String get lsTelegramSaveDialogTitle;

  /// No description provided for @lsTelegramSaveDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Stores `{name}` on the device. Token is sent in the URL.'**
  String lsTelegramSaveDialogBody(String name);

  /// No description provided for @lsTelegramSavedSnack.
  ///
  /// In en, this message translates to:
  /// **'Telegram endpoint saved'**
  String get lsTelegramSavedSnack;

  /// No description provided for @lsTelegramDisabledSnack.
  ///
  /// In en, this message translates to:
  /// **'Telegram endpoint disabled'**
  String get lsTelegramDisabledSnack;

  /// No description provided for @lsTelegramTestQueuedSnack.
  ///
  /// In en, this message translates to:
  /// **'Test queued, watch the Telegram chat'**
  String get lsTelegramTestQueuedSnack;

  /// No description provided for @lsTelegramRemoveDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Telegram endpoint?'**
  String get lsTelegramRemoveDialogTitle;

  /// No description provided for @lsTelegramBotConfiguredStatus.
  ///
  /// In en, this message translates to:
  /// **'Bot configured'**
  String get lsTelegramBotConfiguredStatus;

  /// No description provided for @lsTelegramBotTokenLabel.
  ///
  /// In en, this message translates to:
  /// **'Bot token'**
  String get lsTelegramBotTokenLabel;

  /// No description provided for @lsTelegramBotTokenHint.
  ///
  /// In en, this message translates to:
  /// **'Get one from @BotFather (looks like 1234567:AAH...).'**
  String get lsTelegramBotTokenHint;

  /// No description provided for @lsTelegramChatIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Chat ID'**
  String get lsTelegramChatIdLabel;

  /// No description provided for @lsTelegramChatIdHint.
  ///
  /// In en, this message translates to:
  /// **'A numeric id (-100...) or @channel username.'**
  String get lsTelegramChatIdHint;

  /// No description provided for @lsTelegramMessageTemplateLabel.
  ///
  /// In en, this message translates to:
  /// **'Message template'**
  String get lsTelegramMessageTemplateLabel;

  /// No description provided for @lsTelegramMessageHint.
  ///
  /// In en, this message translates to:
  /// **'LebensSpur: Alarm triggered.'**
  String get lsTelegramMessageHint;

  /// No description provided for @lsLsApiUrlRequired.
  ///
  /// In en, this message translates to:
  /// **'URL required'**
  String get lsLsApiUrlRequired;

  /// No description provided for @lsLsApiUpdatedSnack.
  ///
  /// In en, this message translates to:
  /// **'Webhook updated'**
  String get lsLsApiUpdatedSnack;

  /// No description provided for @lsLsApiSavedSnack.
  ///
  /// In en, this message translates to:
  /// **'Webhook saved'**
  String get lsLsApiSavedSnack;

  /// No description provided for @lsLsApiSaveFirstSnack.
  ///
  /// In en, this message translates to:
  /// **'Save the webhook first'**
  String get lsLsApiSaveFirstSnack;

  /// No description provided for @lsLsApiTestQueuedSnack.
  ///
  /// In en, this message translates to:
  /// **'Test queued, check the receiver'**
  String get lsLsApiTestQueuedSnack;

  /// No description provided for @lsLsApiRemoveDialogBody.
  ///
  /// In en, this message translates to:
  /// **'The LS webhook will be deleted from the device. The countdown will no longer fire it.'**
  String get lsLsApiRemoveDialogBody;

  /// No description provided for @lsLsApiRemovedSnack.
  ///
  /// In en, this message translates to:
  /// **'Webhook removed'**
  String get lsLsApiRemovedSnack;

  /// No description provided for @lsLsApiConfirmCriticalTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm critical change'**
  String get lsLsApiConfirmCriticalTitle;

  /// No description provided for @lsLsApiConfirmCriticalBody.
  ///
  /// In en, this message translates to:
  /// **'The device asks to confirm:\n  {cmd}\n\nThis token expires in {ttlSec}s.'**
  String lsLsApiConfirmCriticalBody(String cmd, int ttlSec);

  /// No description provided for @lsLsApiConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get lsLsApiConfirmButton;

  /// No description provided for @lsLsApiActiveSlot.
  ///
  /// In en, this message translates to:
  /// **'Active · slot \"{name}\"'**
  String lsLsApiActiveSlot(String name);

  /// No description provided for @lsLsApiActiveWithToken.
  ///
  /// In en, this message translates to:
  /// **'Active · slot \"{name}\" · token {token}'**
  String lsLsApiActiveWithToken(String name, String token);

  /// No description provided for @lsLsApiUrlHint.
  ///
  /// In en, this message translates to:
  /// **'Fired when timer.triggered fires. https:// recommended.'**
  String get lsLsApiUrlHint;

  /// No description provided for @lsLsApiHeadersLabel.
  ///
  /// In en, this message translates to:
  /// **'Headers (JSON)'**
  String get lsLsApiHeadersLabel;

  /// No description provided for @lsLsApiHeadersHint.
  ///
  /// In en, this message translates to:
  /// **'Advanced: not yet wired through CLI. Reserved for a future release.'**
  String get lsLsApiHeadersHint;

  /// No description provided for @lsLsApiBodyTemplateHint.
  ///
  /// In en, this message translates to:
  /// **'Sent as the test payload. The device placeholder is replaced server-side.'**
  String get lsLsApiBodyTemplateHint;

  /// No description provided for @lsLsApiBearerHintExisting.
  ///
  /// In en, this message translates to:
  /// **'Currently set: {token}. Leave blank to keep, or paste a new value to overwrite.'**
  String lsLsApiBearerHintExisting(String token);

  /// No description provided for @lsLsApiBearerHintEmpty.
  ///
  /// In en, this message translates to:
  /// **'Sent as `Authorization: Bearer <token>`.'**
  String get lsLsApiBearerHintEmpty;

  /// No description provided for @lsLsApiUpdateButton.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get lsLsApiUpdateButton;

  /// No description provided for @lsMailGroupsStatusFmt.
  ///
  /// In en, this message translates to:
  /// **'{count} of {max} · {recipients} recipients total'**
  String lsMailGroupsStatusFmt(int count, int max, int recipients);

  /// No description provided for @lsMailGroupsReadFailedWith.
  ///
  /// In en, this message translates to:
  /// **'Read failed: {err}'**
  String lsMailGroupsReadFailedWith(String err);

  /// No description provided for @lsMailGroupsNameValidation.
  ///
  /// In en, this message translates to:
  /// **'Name must be between 1 and 47 characters'**
  String get lsMailGroupsNameValidation;

  /// No description provided for @lsMailGroupsNameSaved.
  ///
  /// In en, this message translates to:
  /// **'Name saved'**
  String get lsMailGroupsNameSaved;

  /// No description provided for @lsMailGroupsSubjectValidation.
  ///
  /// In en, this message translates to:
  /// **'Subject must be at most 127 characters'**
  String get lsMailGroupsSubjectValidation;

  /// No description provided for @lsMailGroupsSubjectSaved.
  ///
  /// In en, this message translates to:
  /// **'Subject saved'**
  String get lsMailGroupsSubjectSaved;

  /// No description provided for @lsMailGroupsBodyValidation.
  ///
  /// In en, this message translates to:
  /// **'Body must be at most 511 characters'**
  String get lsMailGroupsBodyValidation;

  /// No description provided for @lsMailGroupsBodySaved.
  ///
  /// In en, this message translates to:
  /// **'Body saved'**
  String get lsMailGroupsBodySaved;

  /// No description provided for @lsMailGroupsEmailValidation.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get lsMailGroupsEmailValidation;

  /// No description provided for @lsMailGroupsMaxReached.
  ///
  /// In en, this message translates to:
  /// **'Maximum is {max} groups'**
  String lsMailGroupsMaxReached(int max);

  /// No description provided for @lsMailGroupsNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get lsMailGroupsNameEmpty;

  /// No description provided for @lsMailGroupsCreatedSnack.
  ///
  /// In en, this message translates to:
  /// **'Group created'**
  String get lsMailGroupsCreatedSnack;

  /// No description provided for @lsMailGroupsCreateFailedWith.
  ///
  /// In en, this message translates to:
  /// **'Create failed: {err}'**
  String lsMailGroupsCreateFailedWith(String err);

  /// No description provided for @lsMailGroupsDeleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete group?'**
  String get lsMailGroupsDeleteDialogTitle;

  /// No description provided for @lsMailGroupsDeleteDialogBody.
  ///
  /// In en, this message translates to:
  /// **'This removes the group and all its recipients on the device.'**
  String get lsMailGroupsDeleteDialogBody;

  /// No description provided for @lsMailGroupsDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get lsMailGroupsDeleteConfirm;

  /// No description provided for @lsMailGroupsDeletedSnack.
  ///
  /// In en, this message translates to:
  /// **'Group deleted'**
  String get lsMailGroupsDeletedSnack;

  /// No description provided for @lsMailGroupsDefaultName.
  ///
  /// In en, this message translates to:
  /// **'Group {n}'**
  String lsMailGroupsDefaultName(int n);

  /// No description provided for @lsMailGroupsNewGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'New mail group'**
  String get lsMailGroupsNewGroupTitle;

  /// No description provided for @lsMailGroupsGroupNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Group name'**
  String get lsMailGroupsGroupNameLabel;

  /// No description provided for @lsMailGroupsCreateConfirm.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get lsMailGroupsCreateConfirm;

  /// No description provided for @lsMailGroupsEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'No groups yet. Create one to send mail when the timer triggers.'**
  String get lsMailGroupsEmptyHint;

  /// No description provided for @lsMailGroupsWorkingButton.
  ///
  /// In en, this message translates to:
  /// **'Working…'**
  String get lsMailGroupsWorkingButton;

  /// No description provided for @lsMailGroupsCreateNewButton.
  ///
  /// In en, this message translates to:
  /// **'+ Create new group'**
  String get lsMailGroupsCreateNewButton;

  /// No description provided for @lsMailGroupsHeaderCount.
  ///
  /// In en, this message translates to:
  /// **'{count} of {max} groups configured'**
  String lsMailGroupsHeaderCount(int count, int max);

  /// No description provided for @lsMailGroupsHeaderTotalRecipients.
  ///
  /// In en, this message translates to:
  /// **'· {count, plural, =1{1 recipient total} other{{count} recipients total}}'**
  String lsMailGroupsHeaderTotalRecipients(int count);

  /// No description provided for @lsMailGroupsUnnamed.
  ///
  /// In en, this message translates to:
  /// **'(unnamed)'**
  String get lsMailGroupsUnnamed;

  /// No description provided for @lsMailGroupsRowSummary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 recipient} other{{count} recipients}} · {state}'**
  String lsMailGroupsRowSummary(int count, String state);

  /// No description provided for @lsMailGroupsEnabled.
  ///
  /// In en, this message translates to:
  /// **'enabled'**
  String get lsMailGroupsEnabled;

  /// No description provided for @lsMailGroupsDisabled.
  ///
  /// In en, this message translates to:
  /// **'disabled'**
  String get lsMailGroupsDisabled;

  /// No description provided for @lsMailGroupsNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get lsMailGroupsNameLabel;

  /// No description provided for @lsMailGroupsSubjectLabel.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get lsMailGroupsSubjectLabel;

  /// No description provided for @lsMailGroupsSaveBodyButton.
  ///
  /// In en, this message translates to:
  /// **'Save body'**
  String get lsMailGroupsSaveBodyButton;

  /// No description provided for @lsMailGroupsDeleteGroupButton.
  ///
  /// In en, this message translates to:
  /// **'Delete group'**
  String get lsMailGroupsDeleteGroupButton;

  /// No description provided for @lsMailGroupsRecipientsHeader.
  ///
  /// In en, this message translates to:
  /// **'Recipients ({count})'**
  String lsMailGroupsRecipientsHeader(int count);

  /// No description provided for @lsMailGroupsNoRecipients.
  ///
  /// In en, this message translates to:
  /// **'No recipients yet.'**
  String get lsMailGroupsNoRecipients;

  /// No description provided for @lsMailGroupsAddRecipientButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get lsMailGroupsAddRecipientButton;

  /// No description provided for @lsHomeStatusLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get lsHomeStatusLoading;

  /// No description provided for @lsHomeLogsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get lsHomeLogsTooltip;

  /// No description provided for @lsHomeClusterConfiguration.
  ///
  /// In en, this message translates to:
  /// **'CONFIGURATION'**
  String get lsHomeClusterConfiguration;

  /// No description provided for @lsHomeClusterTriggerActions.
  ///
  /// In en, this message translates to:
  /// **'TRIGGER ACTIONS'**
  String get lsHomeClusterTriggerActions;

  /// No description provided for @lsHomeClusterEarlyWarning.
  ///
  /// In en, this message translates to:
  /// **'EARLY WARNING'**
  String get lsHomeClusterEarlyWarning;

  /// No description provided for @lsHomeSectionDurationTitle.
  ///
  /// In en, this message translates to:
  /// **'Duration & Alarms'**
  String get lsHomeSectionDurationTitle;

  /// No description provided for @lsHomeSectionVacationTitle.
  ///
  /// In en, this message translates to:
  /// **'Vacation Mode'**
  String get lsHomeSectionVacationTitle;

  /// No description provided for @lsHomeSectionSmtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Mail Setup (SMTP)'**
  String get lsHomeSectionSmtpTitle;

  /// No description provided for @lsHomeSectionResetApiTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset API endpoint'**
  String get lsHomeSectionResetApiTitle;

  /// No description provided for @lsHomeSectionMailGroupsTitle.
  ///
  /// In en, this message translates to:
  /// **'Mail Groups'**
  String get lsHomeSectionMailGroupsTitle;

  /// No description provided for @lsHomeSectionRelayTitle.
  ///
  /// In en, this message translates to:
  /// **'Relay'**
  String get lsHomeSectionRelayTitle;

  /// No description provided for @lsHomeSectionLsApiTitle.
  ///
  /// In en, this message translates to:
  /// **'LS API webhook'**
  String get lsHomeSectionLsApiTitle;

  /// No description provided for @lsHomeSectionTelegramTitle.
  ///
  /// In en, this message translates to:
  /// **'Telegram'**
  String get lsHomeSectionTelegramTitle;

  /// No description provided for @lsHomeSectionReminderMailTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder Mail'**
  String get lsHomeSectionReminderMailTitle;

  /// No description provided for @lsHomeSectionAlarmApiTitle.
  ///
  /// In en, this message translates to:
  /// **'Alarm API webhook'**
  String get lsHomeSectionAlarmApiTitle;

  /// No description provided for @lsHomeStateInactive.
  ///
  /// In en, this message translates to:
  /// **'INACTIVE'**
  String get lsHomeStateInactive;

  /// No description provided for @lsHomeStateRemaining.
  ///
  /// In en, this message translates to:
  /// **'REMAINING'**
  String get lsHomeStateRemaining;

  /// No description provided for @lsHomeStateVacation.
  ///
  /// In en, this message translates to:
  /// **'VACATION'**
  String get lsHomeStateVacation;

  /// No description provided for @lsHomeStateTriggered.
  ///
  /// In en, this message translates to:
  /// **'TRIGGERED'**
  String get lsHomeStateTriggered;

  /// No description provided for @lsHomeChipBle.
  ///
  /// In en, this message translates to:
  /// **'BLE'**
  String get lsHomeChipBle;

  /// No description provided for @lsHomeChipMail.
  ///
  /// In en, this message translates to:
  /// **'Mail'**
  String get lsHomeChipMail;

  /// No description provided for @lsHomeEarlyWarningPendingNote.
  ///
  /// In en, this message translates to:
  /// **'Early warning actions fire on timer.alarm. Firmware subscriber is pending; these configs persist but will not auto-fire yet.'**
  String get lsHomeEarlyWarningPendingNote;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
