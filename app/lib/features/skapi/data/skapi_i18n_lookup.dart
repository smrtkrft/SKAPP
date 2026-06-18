import '../../../l10n/app_localizations.dart';

/// Resolves an i18n key string to its localized value.
///
/// Why a switch instead of reflection / mirrors / generated lookup:
/// `AppLocalizations` exposes named getters (the Flutter intl pipeline
/// generates them) and the asset manifests reference keys by string.
/// A central switch is the bridge; new scripts add their `.arb` keys
/// and a case here. Mirrors and reflection are not available in Flutter
/// release builds.
///
/// Adding a new script:
///   1. Add the `.arb` key (en + tr) and `flutter pub get` to
///      regenerate the AppLocalizations getters.
///   2. Add a case here for each new key referenced from a manifest.
///   3. Unhandled keys fall back to the raw key string so missing
///      translations are loud during dev rather than silent.
String resolveSkapiI18nKey(AppLocalizations l, String key) {
  switch (key) {
    // Group: power
    case 'skapiGroupPowerTitle':
      return l.skapiGroupPowerTitle;
    case 'skapiGroupPowerDesc':
      return l.skapiGroupPowerDesc;
    case 'skapiGroupPowerFoot':
      return l.skapiGroupPowerFoot;

    // Script: lock
    case 'skapiScriptLockTitle':
      return l.skapiScriptLockTitle;
    case 'skapiScriptLockSummaryWhat':
      return l.skapiScriptLockSummaryWhat;
    case 'skapiScriptLockSummaryHow':
      return l.skapiScriptLockSummaryHow;

    // Script: hibernate
    case 'skapiScriptHibernateTitle':
      return l.skapiScriptHibernateTitle;
    case 'skapiScriptHibernateSummaryWhat':
      return l.skapiScriptHibernateSummaryWhat;
    case 'skapiScriptHibernateSummaryHow':
      return l.skapiScriptHibernateSummaryHow;
    case 'skapiScriptHibernateNote':
      return l.skapiScriptHibernateNote;
    case 'skapiScriptHibernateParamDelayLabel':
      return l.skapiScriptHibernateParamDelayLabel;
    case 'skapiScriptHibernateParamDelayHint':
      return l.skapiScriptHibernateParamDelayHint;

    // Script: sleep
    case 'skapiScriptSleepTitle':
      return l.skapiScriptSleepTitle;
    case 'skapiScriptSleepSummaryWhat':
      return l.skapiScriptSleepSummaryWhat;
    case 'skapiScriptSleepSummaryHow':
      return l.skapiScriptSleepSummaryHow;
    case 'skapiScriptSleepParamDelayLabel':
      return l.skapiScriptSleepParamDelayLabel;
    case 'skapiScriptSleepParamDelayHint':
      return l.skapiScriptSleepParamDelayHint;

    // Script: shutdown
    case 'skapiScriptShutdownTitle':
      return l.skapiScriptShutdownTitle;
    case 'skapiScriptShutdownSummaryWhat':
      return l.skapiScriptShutdownSummaryWhat;
    case 'skapiScriptShutdownSummaryHow':
      return l.skapiScriptShutdownSummaryHow;
    case 'skapiScriptShutdownNote':
      return l.skapiScriptShutdownNote;
    case 'skapiScriptShutdownParamDelayLabel':
      return l.skapiScriptShutdownParamDelayLabel;
    case 'skapiScriptShutdownParamDelayHint':
      return l.skapiScriptShutdownParamDelayHint;
    case 'skapiScriptShutdownParamForceLabel':
      return l.skapiScriptShutdownParamForceLabel;
    case 'skapiScriptShutdownParamForceHint':
      return l.skapiScriptShutdownParamForceHint;

    // Group: display-audio
    case 'skapiGroupDisplayAudioTitle':
      return l.skapiGroupDisplayAudioTitle;
    case 'skapiGroupDisplayAudioDesc':
      return l.skapiGroupDisplayAudioDesc;
    case 'skapiGroupDisplayAudioFoot':
      return l.skapiGroupDisplayAudioFoot;

    // Script: brightness
    case 'skapiScriptBrightnessTitle':
      return l.skapiScriptBrightnessTitle;
    case 'skapiScriptBrightnessSummaryWhat':
      return l.skapiScriptBrightnessSummaryWhat;
    case 'skapiScriptBrightnessSummaryHow':
      return l.skapiScriptBrightnessSummaryHow;
    case 'skapiScriptBrightnessNote':
      return l.skapiScriptBrightnessNote;
    case 'skapiScriptBrightnessParamLevelLabel':
      return l.skapiScriptBrightnessParamLevelLabel;
    case 'skapiScriptBrightnessParamLevelHint':
      return l.skapiScriptBrightnessParamLevelHint;
    case 'skapiScriptBrightnessParamTimeoutLabel':
      return l.skapiScriptBrightnessParamTimeoutLabel;
    case 'skapiScriptBrightnessParamTimeoutHint':
      return l.skapiScriptBrightnessParamTimeoutHint;

    // Script: mute-toggle
    case 'skapiScriptMuteToggleTitle':
      return l.skapiScriptMuteToggleTitle;
    case 'skapiScriptMuteToggleSummaryWhat':
      return l.skapiScriptMuteToggleSummaryWhat;
    case 'skapiScriptMuteToggleSummaryHow':
      return l.skapiScriptMuteToggleSummaryHow;
    case 'skapiScriptMuteToggleParamModeLabel':
      return l.skapiScriptMuteToggleParamModeLabel;
    case 'skapiScriptMuteToggleParamModeHint':
      return l.skapiScriptMuteToggleParamModeHint;

    // Script: volume-set
    case 'skapiScriptVolumeSetTitle':
      return l.skapiScriptVolumeSetTitle;
    case 'skapiScriptVolumeSetSummaryWhat':
      return l.skapiScriptVolumeSetSummaryWhat;
    case 'skapiScriptVolumeSetSummaryHow':
      return l.skapiScriptVolumeSetSummaryHow;
    case 'skapiScriptVolumeSetNote':
      return l.skapiScriptVolumeSetNote;
    case 'skapiScriptVolumeSetParamLevelLabel':
      return l.skapiScriptVolumeSetParamLevelLabel;
    case 'skapiScriptVolumeSetParamLevelHint':
      return l.skapiScriptVolumeSetParamLevelHint;

    // Script: media-key
    case 'skapiScriptMediaKeyTitle':
      return l.skapiScriptMediaKeyTitle;
    case 'skapiScriptMediaKeySummaryWhat':
      return l.skapiScriptMediaKeySummaryWhat;
    case 'skapiScriptMediaKeySummaryHow':
      return l.skapiScriptMediaKeySummaryHow;
    case 'skapiScriptMediaKeyNote':
      return l.skapiScriptMediaKeyNote;
    case 'skapiScriptMediaKeyParamKeyLabel':
      return l.skapiScriptMediaKeyParamKeyLabel;
    case 'skapiScriptMediaKeyParamKeyHint':
      return l.skapiScriptMediaKeyParamKeyHint;

    // Group: window-app
    case 'skapiGroupWindowAppTitle':
      return l.skapiGroupWindowAppTitle;
    case 'skapiGroupWindowAppDesc':
      return l.skapiGroupWindowAppDesc;
    case 'skapiGroupWindowAppFoot':
      return l.skapiGroupWindowAppFoot;

    // Script: minimize-window
    case 'skapiScriptMinimizeWindowTitle':
      return l.skapiScriptMinimizeWindowTitle;
    case 'skapiScriptMinimizeWindowSummaryWhat':
      return l.skapiScriptMinimizeWindowSummaryWhat;
    case 'skapiScriptMinimizeWindowSummaryHow':
      return l.skapiScriptMinimizeWindowSummaryHow;
    case 'skapiScriptMinimizeWindowNote':
      return l.skapiScriptMinimizeWindowNote;
    case 'skapiScriptMinimizeWindowParamProcessLabel':
      return l.skapiScriptMinimizeWindowParamProcessLabel;
    case 'skapiScriptMinimizeWindowParamProcessHint':
      return l.skapiScriptMinimizeWindowParamProcessHint;

    // Script: close-window
    case 'skapiScriptCloseWindowTitle':
      return l.skapiScriptCloseWindowTitle;
    case 'skapiScriptCloseWindowSummaryWhat':
      return l.skapiScriptCloseWindowSummaryWhat;
    case 'skapiScriptCloseWindowSummaryHow':
      return l.skapiScriptCloseWindowSummaryHow;
    case 'skapiScriptCloseWindowNote':
      return l.skapiScriptCloseWindowNote;
    case 'skapiScriptCloseWindowParamProcessLabel':
      return l.skapiScriptCloseWindowParamProcessLabel;
    case 'skapiScriptCloseWindowParamProcessHint':
      return l.skapiScriptCloseWindowParamProcessHint;

    // Script: kill-app
    case 'skapiScriptKillAppTitle':
      return l.skapiScriptKillAppTitle;
    case 'skapiScriptKillAppSummaryWhat':
      return l.skapiScriptKillAppSummaryWhat;
    case 'skapiScriptKillAppSummaryHow':
      return l.skapiScriptKillAppSummaryHow;
    case 'skapiScriptKillAppNote':
      return l.skapiScriptKillAppNote;
    case 'skapiScriptKillAppParamProcessLabel':
      return l.skapiScriptKillAppParamProcessLabel;
    case 'skapiScriptKillAppParamProcessHint':
      return l.skapiScriptKillAppParamProcessHint;
    case 'skapiScriptKillAppParamTimeoutLabel':
      return l.skapiScriptKillAppParamTimeoutLabel;
    case 'skapiScriptKillAppParamTimeoutHint':
      return l.skapiScriptKillAppParamTimeoutHint;
    case 'skapiScriptKillAppParamPreKillSaveLabel':
      return l.skapiScriptKillAppParamPreKillSaveLabel;
    case 'skapiScriptKillAppParamPreKillSaveHint':
      return l.skapiScriptKillAppParamPreKillSaveHint;

    // Script: launch-app
    case 'skapiScriptLaunchAppTitle':
      return l.skapiScriptLaunchAppTitle;
    case 'skapiScriptLaunchAppSummaryWhat':
      return l.skapiScriptLaunchAppSummaryWhat;
    case 'skapiScriptLaunchAppSummaryHow':
      return l.skapiScriptLaunchAppSummaryHow;
    case 'skapiScriptLaunchAppNote':
      return l.skapiScriptLaunchAppNote;
    case 'skapiScriptLaunchAppParamPathLabel':
      return l.skapiScriptLaunchAppParamPathLabel;
    case 'skapiScriptLaunchAppParamPathHint':
      return l.skapiScriptLaunchAppParamPathHint;
    case 'skapiScriptLaunchAppParamArgsLabel':
      return l.skapiScriptLaunchAppParamArgsLabel;
    case 'skapiScriptLaunchAppParamArgsHint':
      return l.skapiScriptLaunchAppParamArgsHint;

    // Group: notify
    case 'skapiGroupNotifyTitle':
      return l.skapiGroupNotifyTitle;
    case 'skapiGroupNotifyDesc':
      return l.skapiGroupNotifyDesc;
    case 'skapiGroupNotifyFoot':
      return l.skapiGroupNotifyFoot;

    // Script: dialog
    case 'skapiScriptDialogTitle':
      return l.skapiScriptDialogTitle;
    case 'skapiScriptDialogSummaryWhat':
      return l.skapiScriptDialogSummaryWhat;
    case 'skapiScriptDialogSummaryHow':
      return l.skapiScriptDialogSummaryHow;
    case 'skapiScriptDialogNote':
      return l.skapiScriptDialogNote;
    case 'skapiScriptDialogParamTitleLabel':
      return l.skapiScriptDialogParamTitleLabel;
    case 'skapiScriptDialogParamTitleHint':
      return l.skapiScriptDialogParamTitleHint;
    case 'skapiScriptDialogParamBodyLabel':
      return l.skapiScriptDialogParamBodyLabel;
    case 'skapiScriptDialogParamBodyHint':
      return l.skapiScriptDialogParamBodyHint;
    case 'skapiScriptDialogParamButtonsLabel':
      return l.skapiScriptDialogParamButtonsLabel;
    case 'skapiScriptDialogParamButtonsHint':
      return l.skapiScriptDialogParamButtonsHint;
    case 'skapiScriptDialogParamTimeoutLabel':
      return l.skapiScriptDialogParamTimeoutLabel;
    case 'skapiScriptDialogParamTimeoutHint':
      return l.skapiScriptDialogParamTimeoutHint;

    // Script: toast
    case 'skapiScriptToastTitle':
      return l.skapiScriptToastTitle;
    case 'skapiScriptToastSummaryWhat':
      return l.skapiScriptToastSummaryWhat;
    case 'skapiScriptToastSummaryHow':
      return l.skapiScriptToastSummaryHow;
    case 'skapiScriptToastNote':
      return l.skapiScriptToastNote;
    case 'skapiScriptToastParamTitleLabel':
      return l.skapiScriptToastParamTitleLabel;
    case 'skapiScriptToastParamTitleHint':
      return l.skapiScriptToastParamTitleHint;
    case 'skapiScriptToastParamBodyLabel':
      return l.skapiScriptToastParamBodyLabel;
    case 'skapiScriptToastParamBodyHint':
      return l.skapiScriptToastParamBodyHint;
    case 'skapiScriptToastParamAumidLabel':
      return l.skapiScriptToastParamAumidLabel;
    case 'skapiScriptToastParamAumidHint':
      return l.skapiScriptToastParamAumidHint;

    // Group: visual-break
    case 'skapiGroupVisualBreakTitle':
      return l.skapiGroupVisualBreakTitle;
    case 'skapiGroupVisualBreakDesc':
      return l.skapiGroupVisualBreakDesc;
    case 'skapiGroupVisualBreakFoot':
      return l.skapiGroupVisualBreakFoot;

    // Script: show-desktop
    case 'skapiScriptShowDesktopTitle':
      return l.skapiScriptShowDesktopTitle;
    case 'skapiScriptShowDesktopSummaryWhat':
      return l.skapiScriptShowDesktopSummaryWhat;
    case 'skapiScriptShowDesktopSummaryHow':
      return l.skapiScriptShowDesktopSummaryHow;

    // Script: fade-screen
    case 'skapiScriptFadeScreenTitle':
      return l.skapiScriptFadeScreenTitle;
    case 'skapiScriptFadeScreenSummaryWhat':
      return l.skapiScriptFadeScreenSummaryWhat;
    case 'skapiScriptFadeScreenSummaryHow':
      return l.skapiScriptFadeScreenSummaryHow;
    case 'skapiScriptFadeScreenNote':
      return l.skapiScriptFadeScreenNote;
    case 'skapiScriptFadeScreenParamTargetLabel':
      return l.skapiScriptFadeScreenParamTargetLabel;
    case 'skapiScriptFadeScreenParamTargetHint':
      return l.skapiScriptFadeScreenParamTargetHint;
    case 'skapiScriptFadeScreenParamDurationLabel':
      return l.skapiScriptFadeScreenParamDurationLabel;
    case 'skapiScriptFadeScreenParamDurationHint':
      return l.skapiScriptFadeScreenParamDurationHint;

    // Script: grayscale
    case 'skapiScriptGrayscaleTitle':
      return l.skapiScriptGrayscaleTitle;
    case 'skapiScriptGrayscaleSummaryWhat':
      return l.skapiScriptGrayscaleSummaryWhat;
    case 'skapiScriptGrayscaleSummaryHow':
      return l.skapiScriptGrayscaleSummaryHow;
    case 'skapiScriptGrayscaleNote':
      return l.skapiScriptGrayscaleNote;
    case 'skapiScriptGrayscaleParamOnLabel':
      return l.skapiScriptGrayscaleParamOnLabel;
    case 'skapiScriptGrayscaleParamOnHint':
      return l.skapiScriptGrayscaleParamOnHint;

    // Script: find-mouse-shake
    case 'skapiScriptFindMouseShakeTitle':
      return l.skapiScriptFindMouseShakeTitle;
    case 'skapiScriptFindMouseShakeSummaryWhat':
      return l.skapiScriptFindMouseShakeSummaryWhat;
    case 'skapiScriptFindMouseShakeSummaryHow':
      return l.skapiScriptFindMouseShakeSummaryHow;
    case 'skapiScriptFindMouseShakeNote':
      return l.skapiScriptFindMouseShakeNote;
    case 'skapiScriptFindMouseShakeParamRadiusLabel':
      return l.skapiScriptFindMouseShakeParamRadiusLabel;
    case 'skapiScriptFindMouseShakeParamRadiusHint':
      return l.skapiScriptFindMouseShakeParamRadiusHint;
    case 'skapiScriptFindMouseShakeParamLoopsLabel':
      return l.skapiScriptFindMouseShakeParamLoopsLabel;
    case 'skapiScriptFindMouseShakeParamLoopsHint':
      return l.skapiScriptFindMouseShakeParamLoopsHint;

    // Script: pulse-brightness
    case 'skapiScriptPulseBrightnessTitle':
      return l.skapiScriptPulseBrightnessTitle;
    case 'skapiScriptPulseBrightnessSummaryWhat':
      return l.skapiScriptPulseBrightnessSummaryWhat;
    case 'skapiScriptPulseBrightnessSummaryHow':
      return l.skapiScriptPulseBrightnessSummaryHow;
    case 'skapiScriptPulseBrightnessNote':
      return l.skapiScriptPulseBrightnessNote;
    case 'skapiScriptPulseBrightnessParamPeriodLabel':
      return l.skapiScriptPulseBrightnessParamPeriodLabel;
    case 'skapiScriptPulseBrightnessParamPeriodHint':
      return l.skapiScriptPulseBrightnessParamPeriodHint;
    case 'skapiScriptPulseBrightnessParamLowPercentLabel':
      return l.skapiScriptPulseBrightnessParamLowPercentLabel;
    case 'skapiScriptPulseBrightnessParamLowPercentHint':
      return l.skapiScriptPulseBrightnessParamLowPercentHint;
    case 'skapiScriptPulseBrightnessParamCyclesLabel':
      return l.skapiScriptPulseBrightnessParamCyclesLabel;
    case 'skapiScriptPulseBrightnessParamCyclesHint':
      return l.skapiScriptPulseBrightnessParamCyclesHint;

    // Script: blur-timed
    case 'skapiScriptBlurTimedTitle':
      return l.skapiScriptBlurTimedTitle;
    case 'skapiScriptBlurTimedSummaryWhat':
      return l.skapiScriptBlurTimedSummaryWhat;
    case 'skapiScriptBlurTimedSummaryHow':
      return l.skapiScriptBlurTimedSummaryHow;
    case 'skapiScriptBlurTimedNote':
      return l.skapiScriptBlurTimedNote;
    case 'skapiScriptBlurTimedParamDurationLabel':
      return l.skapiScriptBlurTimedParamDurationLabel;
    case 'skapiScriptBlurTimedParamDurationHint':
      return l.skapiScriptBlurTimedParamDurationHint;
    case 'skapiScriptBlurTimedParamOpacityLabel':
      return l.skapiScriptBlurTimedParamOpacityLabel;
    case 'skapiScriptBlurTimedParamOpacityHint':
      return l.skapiScriptBlurTimedParamOpacityHint;
    case 'skapiScriptBlurTimedParamColorLabel':
      return l.skapiScriptBlurTimedParamColorLabel;
    case 'skapiScriptBlurTimedParamColorHint':
      return l.skapiScriptBlurTimedParamColorHint;

    // Script: blocking-focus (focus-lockdown rename + composite)
    case 'skapiScriptBlockingFocusTitle':
      return l.skapiScriptBlockingFocusTitle;
    case 'skapiScriptBlockingFocusSummaryWhat':
      return l.skapiScriptBlockingFocusSummaryWhat;
    case 'skapiScriptBlockingFocusSummaryHow':
      return l.skapiScriptBlockingFocusSummaryHow;
    case 'skapiScriptBlockingFocusNote':
      return l.skapiScriptBlockingFocusNote;
    case 'skapiScriptBlockingFocusParamDurationLabel':
      return l.skapiScriptBlockingFocusParamDurationLabel;
    case 'skapiScriptBlockingFocusParamDurationHint':
      return l.skapiScriptBlockingFocusParamDurationHint;
    case 'skapiScriptBlockingFocusParamTitleLabel':
      return l.skapiScriptBlockingFocusParamTitleLabel;
    case 'skapiScriptBlockingFocusParamTitleHint':
      return l.skapiScriptBlockingFocusParamTitleHint;
    case 'skapiScriptBlockingFocusParamShakeRadiusLabel':
      return l.skapiScriptBlockingFocusParamShakeRadiusLabel;
    case 'skapiScriptBlockingFocusParamShakeRadiusHint':
      return l.skapiScriptBlockingFocusParamShakeRadiusHint;
    case 'skapiScriptBlockingFocusParamEnableSaveLabel':
      return l.skapiScriptBlockingFocusParamEnableSaveLabel;
    case 'skapiScriptBlockingFocusParamEnableSaveHint':
      return l.skapiScriptBlockingFocusParamEnableSaveHint;

    // Group: programs
    case 'skapiGroupProgramsTitle':
      return l.skapiGroupProgramsTitle;
    case 'skapiGroupProgramsDesc':
      return l.skapiGroupProgramsDesc;
    case 'skapiGroupProgramsFoot':
      return l.skapiGroupProgramsFoot;

    // Script: close-with-save
    case 'skapiScriptCloseWithSaveTitle':
      return l.skapiScriptCloseWithSaveTitle;
    case 'skapiScriptCloseWithSaveSummaryWhat':
      return l.skapiScriptCloseWithSaveSummaryWhat;
    case 'skapiScriptCloseWithSaveSummaryHow':
      return l.skapiScriptCloseWithSaveSummaryHow;
    case 'skapiScriptCloseWithSaveNote':
      return l.skapiScriptCloseWithSaveNote;
    case 'skapiScriptCloseWithSaveParamProcessLabel':
      return l.skapiScriptCloseWithSaveParamProcessLabel;
    case 'skapiScriptCloseWithSaveParamProcessHint':
      return l.skapiScriptCloseWithSaveParamProcessHint;
    case 'skapiScriptCloseWithSaveParamWaitLabel':
      return l.skapiScriptCloseWithSaveParamWaitLabel;
    case 'skapiScriptCloseWithSaveParamWaitHint':
      return l.skapiScriptCloseWithSaveParamWaitHint;

    // Script: close-all-instances
    case 'skapiScriptCloseAllInstancesTitle':
      return l.skapiScriptCloseAllInstancesTitle;
    case 'skapiScriptCloseAllInstancesSummaryWhat':
      return l.skapiScriptCloseAllInstancesSummaryWhat;
    case 'skapiScriptCloseAllInstancesSummaryHow':
      return l.skapiScriptCloseAllInstancesSummaryHow;
    case 'skapiScriptCloseAllInstancesParamProcessLabel':
      return l.skapiScriptCloseAllInstancesParamProcessLabel;
    case 'skapiScriptCloseAllInstancesParamProcessHint':
      return l.skapiScriptCloseAllInstancesParamProcessHint;

    // Script: browser-close-all
    case 'skapiScriptBrowserCloseAllTitle':
      return l.skapiScriptBrowserCloseAllTitle;
    case 'skapiScriptBrowserCloseAllSummaryWhat':
      return l.skapiScriptBrowserCloseAllSummaryWhat;
    case 'skapiScriptBrowserCloseAllSummaryHow':
      return l.skapiScriptBrowserCloseAllSummaryHow;
    case 'skapiScriptBrowserCloseAllNote':
      return l.skapiScriptBrowserCloseAllNote;

    // Group: save-work
    case 'skapiGroupSaveWorkTitle':
      return l.skapiGroupSaveWorkTitle;
    case 'skapiGroupSaveWorkDesc':
      return l.skapiGroupSaveWorkDesc;
    case 'skapiGroupSaveWorkFoot':
      return l.skapiGroupSaveWorkFoot;

    // Script: save-active-window
    case 'skapiScriptSaveActiveWindowTitle':
      return l.skapiScriptSaveActiveWindowTitle;
    case 'skapiScriptSaveActiveWindowSummaryWhat':
      return l.skapiScriptSaveActiveWindowSummaryWhat;
    case 'skapiScriptSaveActiveWindowSummaryHow':
      return l.skapiScriptSaveActiveWindowSummaryHow;
    case 'skapiScriptSaveActiveWindowParamTimeoutLabel':
      return l.skapiScriptSaveActiveWindowParamTimeoutLabel;
    case 'skapiScriptSaveActiveWindowParamTimeoutHint':
      return l.skapiScriptSaveActiveWindowParamTimeoutHint;
    case 'skapiScriptSaveActiveWindowParamVerboseLabel':
      return l.skapiScriptSaveActiveWindowParamVerboseLabel;

    // Script: save-all-open
    case 'skapiScriptSaveAllOpenTitle':
      return l.skapiScriptSaveAllOpenTitle;
    case 'skapiScriptSaveAllOpenSummaryWhat':
      return l.skapiScriptSaveAllOpenSummaryWhat;
    case 'skapiScriptSaveAllOpenSummaryHow':
      return l.skapiScriptSaveAllOpenSummaryHow;
    case 'skapiScriptSaveAllOpenNote':
      return l.skapiScriptSaveAllOpenNote;
    case 'skapiScriptSaveAllOpenParamAppsLabel':
      return l.skapiScriptSaveAllOpenParamAppsLabel;
    case 'skapiScriptSaveAllOpenParamAppsHint':
      return l.skapiScriptSaveAllOpenParamAppsHint;
    case 'skapiScriptSaveAllOpenParamTimeoutLabel':
      return l.skapiScriptSaveAllOpenParamTimeoutLabel;
    case 'skapiScriptSaveAllOpenParamVerboseLabel':
      return l.skapiScriptSaveAllOpenParamVerboseLabel;

    // Script: autosave-trigger
    case 'skapiScriptAutosaveTriggerTitle':
      return l.skapiScriptAutosaveTriggerTitle;
    case 'skapiScriptAutosaveTriggerSummaryWhat':
      return l.skapiScriptAutosaveTriggerSummaryWhat;
    case 'skapiScriptAutosaveTriggerSummaryHow':
      return l.skapiScriptAutosaveTriggerSummaryHow;
    case 'skapiScriptAutosaveTriggerNote':
      return l.skapiScriptAutosaveTriggerNote;
    case 'skapiScriptAutosaveTriggerParamDelayLabel':
      return l.skapiScriptAutosaveTriggerParamDelayLabel;
    case 'skapiScriptAutosaveTriggerParamDelayHint':
      return l.skapiScriptAutosaveTriggerParamDelayHint;
    case 'skapiScriptAutosaveTriggerParamVerboseLabel':
      return l.skapiScriptAutosaveTriggerParamVerboseLabel;

    // ---- lx-debian overrides (only keys that diverge from win/mac) ----

    // Power
    case 'skapiScriptLockSummaryHowLxDebian':
      return l.skapiScriptLockSummaryHowLxDebian;
    case 'skapiScriptHibernateSummaryHowLxDebian':
      return l.skapiScriptHibernateSummaryHowLxDebian;
    case 'skapiScriptHibernateNoteLxDebian':
      return l.skapiScriptHibernateNoteLxDebian;
    case 'skapiScriptSleepSummaryHowLxDebian':
      return l.skapiScriptSleepSummaryHowLxDebian;
    case 'skapiScriptShutdownSummaryHowLxDebian':
      return l.skapiScriptShutdownSummaryHowLxDebian;
    case 'skapiScriptShutdownNoteLxDebian':
      return l.skapiScriptShutdownNoteLxDebian;
    case 'skapiScriptShutdownParamForceHintLxDebian':
      return l.skapiScriptShutdownParamForceHintLxDebian;

    // Display & Audio
    case 'skapiScriptBrightnessSummaryHowLxDebian':
      return l.skapiScriptBrightnessSummaryHowLxDebian;
    case 'skapiScriptBrightnessNoteLxDebian':
      return l.skapiScriptBrightnessNoteLxDebian;
    case 'skapiScriptMuteToggleSummaryHowLxDebian':
      return l.skapiScriptMuteToggleSummaryHowLxDebian;
    case 'skapiScriptVolumeSetSummaryHowLxDebian':
      return l.skapiScriptVolumeSetSummaryHowLxDebian;
    case 'skapiScriptVolumeSetNoteLxDebian':
      return l.skapiScriptVolumeSetNoteLxDebian;
    case 'skapiScriptMediaKeySummaryHowLxDebian':
      return l.skapiScriptMediaKeySummaryHowLxDebian;
    case 'skapiScriptMediaKeyNoteLxDebian':
      return l.skapiScriptMediaKeyNoteLxDebian;

    // Window & App
    case 'skapiScriptMinimizeWindowSummaryHowLxDebian':
      return l.skapiScriptMinimizeWindowSummaryHowLxDebian;
    case 'skapiScriptMinimizeWindowNoteLxDebian':
      return l.skapiScriptMinimizeWindowNoteLxDebian;
    case 'skapiScriptMinimizeWindowParamProcessHintLxDebian':
      return l.skapiScriptMinimizeWindowParamProcessHintLxDebian;
    case 'skapiScriptCloseWindowSummaryHowLxDebian':
      return l.skapiScriptCloseWindowSummaryHowLxDebian;
    case 'skapiScriptCloseWindowNoteLxDebian':
      return l.skapiScriptCloseWindowNoteLxDebian;
    case 'skapiScriptCloseWindowParamProcessHintLxDebian':
      return l.skapiScriptCloseWindowParamProcessHintLxDebian;
    case 'skapiScriptKillAppSummaryHowLxDebian':
      return l.skapiScriptKillAppSummaryHowLxDebian;
    case 'skapiScriptKillAppNoteLxDebian':
      return l.skapiScriptKillAppNoteLxDebian;
    case 'skapiScriptKillAppParamProcessHintLxDebian':
      return l.skapiScriptKillAppParamProcessHintLxDebian;
    case 'skapiScriptKillAppParamPreKillSaveHintLxDebian':
      return l.skapiScriptKillAppParamPreKillSaveHintLxDebian;
    case 'skapiScriptLaunchAppSummaryHowLxDebian':
      return l.skapiScriptLaunchAppSummaryHowLxDebian;
    case 'skapiScriptLaunchAppNoteLxDebian':
      return l.skapiScriptLaunchAppNoteLxDebian;
    case 'skapiScriptLaunchAppParamPathHintLxDebian':
      return l.skapiScriptLaunchAppParamPathHintLxDebian;

    // Notify
    case 'skapiScriptDialogSummaryHowLxDebian':
      return l.skapiScriptDialogSummaryHowLxDebian;
    case 'skapiScriptDialogNoteLxDebian':
      return l.skapiScriptDialogNoteLxDebian;
    case 'skapiScriptToastSummaryHowLxDebian':
      return l.skapiScriptToastSummaryHowLxDebian;
    case 'skapiScriptToastNoteLxDebian':
      return l.skapiScriptToastNoteLxDebian;
    case 'skapiScriptToastParamIconLabelLxDebian':
      return l.skapiScriptToastParamIconLabelLxDebian;
    case 'skapiScriptToastParamIconHintLxDebian':
      return l.skapiScriptToastParamIconHintLxDebian;
    case 'skapiScriptToastParamDurationLabelLxDebian':
      return l.skapiScriptToastParamDurationLabelLxDebian;
    case 'skapiScriptToastParamDurationHintLxDebian':
      return l.skapiScriptToastParamDurationHintLxDebian;

    // Visual Break
    case 'skapiScriptShowDesktopSummaryHowLxDebian':
      return l.skapiScriptShowDesktopSummaryHowLxDebian;
    case 'skapiScriptShowDesktopNoteLxDebian':
      return l.skapiScriptShowDesktopNoteLxDebian;
    case 'skapiScriptFadeScreenSummaryHowLxDebian':
      return l.skapiScriptFadeScreenSummaryHowLxDebian;
    case 'skapiScriptFadeScreenNoteLxDebian':
      return l.skapiScriptFadeScreenNoteLxDebian;
    case 'skapiScriptGrayscaleSummaryHowLxDebian':
      return l.skapiScriptGrayscaleSummaryHowLxDebian;
    case 'skapiScriptGrayscaleNoteLxDebian':
      return l.skapiScriptGrayscaleNoteLxDebian;
    case 'skapiScriptFindMouseShakeSummaryHowLxDebian':
      return l.skapiScriptFindMouseShakeSummaryHowLxDebian;
    case 'skapiScriptFindMouseShakeNoteLxDebian':
      return l.skapiScriptFindMouseShakeNoteLxDebian;

    // Programs
    case 'skapiScriptCloseWithSaveSummaryHowLxDebian':
      return l.skapiScriptCloseWithSaveSummaryHowLxDebian;
    case 'skapiScriptCloseWithSaveNoteLxDebian':
      return l.skapiScriptCloseWithSaveNoteLxDebian;
    case 'skapiScriptCloseWithSaveParamProcessHintLxDebian':
      return l.skapiScriptCloseWithSaveParamProcessHintLxDebian;
    case 'skapiScriptCloseAllInstancesSummaryHowLxDebian':
      return l.skapiScriptCloseAllInstancesSummaryHowLxDebian;
    case 'skapiScriptCloseAllInstancesParamProcessHintLxDebian':
      return l.skapiScriptCloseAllInstancesParamProcessHintLxDebian;
    case 'skapiScriptBrowserCloseAllSummaryHowLxDebian':
      return l.skapiScriptBrowserCloseAllSummaryHowLxDebian;
    case 'skapiScriptBrowserCloseAllNoteLxDebian':
      return l.skapiScriptBrowserCloseAllNoteLxDebian;

    // Save Work
    case 'skapiScriptSaveActiveWindowSummaryHowLxDebian':
      return l.skapiScriptSaveActiveWindowSummaryHowLxDebian;
    case 'skapiScriptSaveActiveWindowNoteLxDebian':
      return l.skapiScriptSaveActiveWindowNoteLxDebian;
    case 'skapiScriptSaveAllOpenSummaryHowLxDebian':
      return l.skapiScriptSaveAllOpenSummaryHowLxDebian;
    case 'skapiScriptSaveAllOpenNoteLxDebian':
      return l.skapiScriptSaveAllOpenNoteLxDebian;
    case 'skapiScriptSaveAllOpenParamAppsHintLxDebian':
      return l.skapiScriptSaveAllOpenParamAppsHintLxDebian;
    case 'skapiScriptAutosaveTriggerSummaryHowLxDebian':
      return l.skapiScriptAutosaveTriggerSummaryHowLxDebian;
    case 'skapiScriptAutosaveTriggerNoteLxDebian':
      return l.skapiScriptAutosaveTriggerNoteLxDebian;
  }
  return key;
}
