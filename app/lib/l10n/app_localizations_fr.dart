// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'SKAPP';

  @override
  String get brandTagline => 'SmartKraft';

  @override
  String get tabHome => 'Accueil';

  @override
  String get tabDevices => 'Appareils';

  @override
  String get tabSkapi => 'SKAPI';

  @override
  String get tabSettings => 'Paramètres';

  @override
  String get tabSmartKraft => 'SmartKraft';

  @override
  String get comingSoonBadge => 'bientôt disponible';

  @override
  String get featureComingSoonSnack => 'Cette fonctionnalité arrive bientôt';

  @override
  String get homeWelcome => 'Bienvenue chez SmartKraft';

  @override
  String get homeSubtitle => 'Gérez vos appareils SmartKraft';

  @override
  String get homeAddDevice => 'Ajouter un appareil';

  @override
  String get homeNoDevicesTitle => 'Aucun appareil pour l\'instant';

  @override
  String get homeNoDevicesHint =>
      'Ajoutez votre premier appareil SmartKraft pour commencer.';

  @override
  String get homeSummaryTitle => 'Vue d\'ensemble';

  @override
  String homeDevicesOnline(int count) {
    return '$count connecté(s)';
  }

  @override
  String homeDevicesOffline(int count) {
    return '$count hors ligne';
  }

  @override
  String get homeUpdatesTitle => 'Mises à jour disponibles';

  @override
  String homeUpdatesBody(int count) {
    return '$count appareil dispose d\'\'un firmware plus récent.';
  }

  @override
  String get homeWarningsTitle => 'Avertissements';

  @override
  String homeWarningsBody(int count) {
    return '$count appareil a signalé un problème.';
  }

  @override
  String get homeAllGood => 'Tout fonctionne normalement.';

  @override
  String get devicesTitle => 'Appareils';

  @override
  String get devicesEmpty =>
      'Aucun appareil ajouté pour l\'instant.\nAppuyez sur le bouton + pour en ajouter un.';

  @override
  String get devicesAdd => 'Ajouter un appareil';

  @override
  String get devicesAllSection => 'Tous les appareils';

  @override
  String get devicesGroupsTitle => 'Vos groupes';

  @override
  String get devicesGroupsHint =>
      'Créez des groupes pour organiser vos appareils comme vous le souhaitez.';

  @override
  String get devicesGroupsCreate => 'Nouveau groupe';

  @override
  String get devicesGroupsEmpty => 'Aucun groupe pour l\'instant.';

  @override
  String get skapiTitle => 'SKAPI';

  @override
  String get skapiLibraryHeading => 'Bibliothèque SKAPI';

  @override
  String get skapiLibrarySubtitle =>
      'Choisissez la plateforme que vos appareils déclencheront.';

  @override
  String get skapiThisComputer => 'Cet ordinateur';

  @override
  String skapiCategoryCount(int count) {
    return '$count catégories';
  }

  @override
  String get skapiPlatformMac => 'macOS';

  @override
  String get skapiPlatformWin => 'Windows';

  @override
  String get skapiPlatformLinux => 'Linux';

  @override
  String get skapiPlatformOther => 'Autre';

  @override
  String get skapiStarredHeading => 'API favorites';

  @override
  String get skapiStarredEmpty =>
      'Mettez des modèles en favori depuis la bibliothèque, ils apparaîtront ici.';

  @override
  String get skapiContributeTitle =>
      'Envoyez votre bibliothèque à la communauté SmartKraft';

  @override
  String get skapiContributeBody => 'Cette carte sera conçue plus tard.';

  @override
  String get skapiSearchPlaceholder => 'Rechercher des actions…';

  @override
  String get skapiSearchDisabledHint =>
      'S\'activera une fois l\'analyseur SKAPI branché.';

  @override
  String get skapiHelpButtonTooltip => 'À propos de SKAPI';

  @override
  String get skapiHelpSheetTitle => 'À propos de SKAPI';

  @override
  String get skapiHelpIntro =>
      'SKAPI est une bibliothèque d\'actions que vos appareils SmartKraft peuvent déclencher sur votre ordinateur.';

  @override
  String get skapiHelpStep1Title => 'Parcourir un modèle';

  @override
  String get skapiHelpStep1Body =>
      'Choisissez un point de départ dans la bibliothèque SKAPI.';

  @override
  String get skapiHelpStep2Title => 'Configurer';

  @override
  String get skapiHelpStep2Body =>
      'Définissez les paramètres et choisissez l\'appareil qui le déclenche.';

  @override
  String get skapiHelpStep3Title => 'Envoyer vers l\'appareil';

  @override
  String get skapiHelpStep3Body =>
      'L\'appareil enregistre le déclencheur API ; SKAPP exécute le script.';

  @override
  String get skapiHelpGlossaryTitle => 'Glossaire';

  @override
  String get skapiHelpGlossaryTemplate =>
      'Modèle : une entrée de bibliothèque en lecture seule';

  @override
  String get skapiHelpGlossaryAction =>
      'Action : une paire configurée déclencheur API + script';

  @override
  String get skapiHelpGlossaryApiTrigger =>
      'Déclencheur API : ce que l\'appareil appelle';

  @override
  String get skapiHelpGlossaryScript =>
      'Script : ce que votre ordinateur exécute';

  @override
  String get skapiHelpPhase1Notice =>
      'SKAPI est encore en construction. La majeure partie de cet onglet est une ébauche ; les sections marquées « pas encore active » s\'activeront à mesure que l\'analyseur, l\'écouteur et le générateur de formulaires seront prêts.';

  @override
  String get skapiMobileBannerBody =>
      'Ce téléphone ne peut pas être une cible. Pour exécuter des actions, SKAPP doit être ouvert sur votre ordinateur.';

  @override
  String get skapiActionsHeading => 'Mes actions';

  @override
  String get skapiActionsNoDevicesTitle => 'Aucun appareil pour l\'instant';

  @override
  String get skapiActionsNoDevicesBody =>
      'Jumelez d\'abord un appareil SmartKraft ; rendez-vous dans l\'onglet Appareils.';

  @override
  String get skapiActionsCreationDisabled =>
      'La création d\'actions n\'est pas encore active.';

  @override
  String get skapiActionsOfflineDetectionDisabled =>
      'Détection de l\'état en ligne pas encore active';

  @override
  String get skapiActionsMaxLimitNote => 'Jusqu\'à 5 actions par appareil.';

  @override
  String get skapiActionsAddCta => 'Ajouter une action';

  @override
  String skapiHeaderSub(int platforms, int actions) {
    return '$platforms plateformes · $actions actions';
  }

  @override
  String get skapiNewActionPill => 'Nouvelle action';

  @override
  String skapiActionsSubLine(int count) {
    return 'liaisons appareil × script · $count active(s)';
  }

  @override
  String get skapiActionsEmptyHint =>
      'Aucune action pour l\'instant. Définissez ce qui se passe quand on appuie sur un bouton de l\'appareil.';

  @override
  String get skapiActionsCreateCta => 'Créer';

  @override
  String skapiActionsGroupTitle(String name) {
    return 'Actions de $name';
  }

  @override
  String skapiActionsGroupCount(int count) {
    return '$count';
  }

  @override
  String get skapiListenerEndpointTitle =>
      'URL du webhook envoyée aux appareils BF';

  @override
  String get skapiListenerEndpointBody =>
      'Si un BF sur le même Wi-Fi ne peut pas joindre cette URL après le compte à rebours, le choix de carte réseau de votre ordinateur est peut-être erroné (par ex. réseau WSL/VirtualBox/Docker). Appuyez sur Actualiser pour renvoyer.';

  @override
  String get skapiListenerEndpointResolving => 'Résolution de l\'IP locale…';

  @override
  String get skapiListenerEndpointUnavailable =>
      'Aucune interface LAN utilisable trouvée.';

  @override
  String get skapiListenerEndpointRefresh => 'Actualiser';

  @override
  String get skapiListenerEndpointRefreshing => 'Envoi…';

  @override
  String skapiListenerEndpointPushedAt(String when) {
    return 'Dernière actualisation $when';
  }

  @override
  String get skapiListenerSelfTest => 'Autotest';

  @override
  String get skapiListenerSelfTestRunning => 'Test en cours…';

  @override
  String get skapiListenerSelfTestPassed =>
      'Autotest OK : écouteur joignable depuis cet hôte.';

  @override
  String get skapiListenerSelfTestFailed =>
      'Autotest ÉCHOUÉ : écouteur injoignable. Vérifiez le pare-feu Windows.';

  @override
  String get skapiWebhookActivityTitle => 'Webhooks récents';

  @override
  String get skapiWebhookActivityNone =>
      'Aucun webhook reçu pour l\'instant. Une fois le minuteur de l\'appareil expiré, une entrée devrait apparaître ici en quelques secondes.';

  @override
  String get skapiWebhookActivityAccepted => 'Accepté';

  @override
  String skapiWebhookActivityRejected(int code) {
    return 'Rejeté ($code)';
  }

  @override
  String get skapiWebhookActivityMalformed => 'Mal formé';

  @override
  String get skapiWebhookActivitySelfTest => 'Autotest';

  @override
  String get skapiWebhookActivityNoMatch => 'Aucune liaison correspondante';

  @override
  String get skapiWebhookActivityScriptError => 'Erreur de script';

  @override
  String skapiWebhookActivityMatched(int count) {
    return '$count script(s) exécuté(s)';
  }

  @override
  String get skapiBfEndpointsButton => 'Inspecter les endpoints BF';

  @override
  String get skapiBfEndpointsTitle => 'Endpoints stockés sur les appareils BF';

  @override
  String get skapiBfEndpointsHint =>
      'Instantané en lecture seule de api.endpoint.list de chaque appareil jumelé. Comparez l\'URL de chaque emplacement SYSTEM avec l\'URL de l\'écouteur ci-dessus. Elles doivent correspondre exactement. Les emplacements USER peuvent appartenir à des webhooks manuels et capturer votre compte à rebours s\'ils sont mal configurés.';

  @override
  String get skapiBfEndpointsLoading => 'Interrogation des appareils BF…';

  @override
  String get skapiBfEndpointsErrorPrefix => 'Échec de la requête :';

  @override
  String get skapiBfEndpointsKindSystem => 'SYSTEM';

  @override
  String get skapiBfEndpointsKindUser => 'USER';

  @override
  String get skapiBfEndpointsEmpty => 'Aucun endpoint stocké sur cet appareil.';

  @override
  String get skapiBfEndpointsClose => 'Fermer';

  @override
  String get skapiBfEndpointsRefresh => 'Réinterroger';

  @override
  String skapiStarredCount(int count) {
    return '$count en favori';
  }

  @override
  String get skapiStarredSlimEmpty =>
      'Mettez des entrées de la bibliothèque en favori pour rassembler ici vos plus utilisées.';

  @override
  String get skapiCommunityShareTitle =>
      'Partagez votre bibliothèque avec la communauté SmartKraft';

  @override
  String get skapiCommunityShareBody =>
      'Les scripts que vous écrivez deviennent accessibles à tous dans la bibliothèque SKAPI.';

  @override
  String get settingsNetworkIdentityTitle => 'Identité réseau';

  @override
  String get settingsNetworkIdentityName => 'Nom de l\'ordinateur';

  @override
  String get settingsNetworkIdentityNameHint =>
      'Utilisé comme nom d\'instance mDNS';

  @override
  String get settingsNetworkIdentityNameEdit => 'Renommer';

  @override
  String get settingsNetworkIdentityNameDialogTitle =>
      'Renommer cet ordinateur';

  @override
  String get settingsNetworkIdentityNameDialogHelp =>
      'Lettres minuscules, chiffres et tirets. Jusqu\'à 32 caractères.';

  @override
  String get settingsNetworkIdentityUuid => 'ID de l\'appareil';

  @override
  String get settingsNetworkIdentityPort => 'Port de l\'écouteur';

  @override
  String get settingsNetworkIdentityPortDialogTitle => 'Port de l\'écouteur';

  @override
  String get settingsNetworkIdentityToken => 'Jeton Bearer';

  @override
  String get settingsNetworkIdentityRegenerateToken => 'Régénérer le jeton';

  @override
  String get settingsNetworkIdentityRegenerateConfirmTitle =>
      'Régénérer le jeton Bearer ?';

  @override
  String get settingsNetworkIdentityRegenerateConfirmBody =>
      'Les appareils existants devront être jumelés à nouveau avec le nouveau jeton.';

  @override
  String get settingsNetworkIdentityServerNotRunning =>
      'Le serveur n\'est pas encore lancé, il s\'activera en phase 2.';

  @override
  String get settingsNetworkIdentityCopy => 'Copier';

  @override
  String get settingsNetworkIdentityCopied => 'Copié';

  @override
  String get settingsNetworkIdentityStaticIpHint =>
      'Astuce : une réservation DHCP (IP fixe) sur votre routeur rend les connexions plus fiables.';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsSectionAppearance => 'Apparence';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageSystemHint => 'Suivre la langue du système';

  @override
  String get settingsLanguagePickerAllSection => 'Toutes les langues';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsThemeSystem => 'Système';

  @override
  String get settingsSectionAbout => 'À propos';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsDeveloper => 'Développeur';

  @override
  String get settingsDeveloperName => 'SmartKraft';

  @override
  String get settingsOpenAbout => 'À propos de SKAPP';

  @override
  String get settingsSectionAdvanced => 'Avancé';

  @override
  String get settingsDeveloperMode => 'Mode développeur';

  @override
  String get settingsDeveloperToolsTitle => 'Outils de développement';

  @override
  String get settingsDeveloperToolsSubtitle =>
      'Console USB, identité réseau, écouteur, jetons, journaux';

  @override
  String get settingsDeveloperModeInfoTitle =>
      'Que débloque le mode développeur ?';

  @override
  String get settingsDeveloperModeInfoIntro =>
      'Ce mode révèle des fonctions avancées masquées dans l\'interface par défaut. Trois cas d\'usage principaux :';

  @override
  String get settingsDeveloperModeUseCaseCliTitle => 'Console CLI';

  @override
  String get settingsDeveloperModeUseCaseCliBody =>
      'Configurez vos appareils via un câble USB sans établir d\'abord une connexion BLE ou WiFi.';

  @override
  String get settingsDeveloperModeUseCaseSkapiTitle => 'Éditeur de code SKAPI';

  @override
  String get settingsDeveloperModeUseCaseSkapiBody =>
      'Ouvrez et modifiez les scripts intégrés, ou écrivez les vôtres de zéro.';

  @override
  String get settingsDeveloperModeUseCaseMobileTitle =>
      'Déclenchement à distance depuis le mobile';

  @override
  String get settingsDeveloperModeUseCaseMobileBody =>
      'Exécutez les liaisons SKAPI de ce poste depuis un SKAPP mobile jumelé.';

  @override
  String get settingsDeveloperModeInfoSurfacesHeader =>
      'Cartes Paramètres supplémentaires qui apparaissent quand il est activé :';

  @override
  String get settingsDeveloperModeInfoItem1 =>
      'Carte Identité réseau : modifier l\'UUID, le port, le jeton Bearer ; copier / régénérer le secret d\'installation SKAPP.';

  @override
  String get settingsDeveloperModeInfoItem2 =>
      'Contrôles de l\'écouteur HTTP local : démarrer/arrêter, jumelage par QR, rotation du certificat TLS, visibilité sur le LAN.';

  @override
  String get settingsDeveloperModeInfoItem3 =>
      'Liste des jetons par pair : voir chaque SKAPP mobile jumelé et le révoquer individuellement.';

  @override
  String get settingsDeveloperModeInfoItem4 =>
      'Console CLI USB (bureau uniquement) : ligne de commande NDJSON brute vers un appareil SmartKraft connecté en USB.';

  @override
  String get settingsDeveloperModeInfoNotPaid =>
      'Ce n\'est pas une option payante. SKAPP est gratuit et à un seul niveau ; cet interrupteur masque seulement les fonctions avancées par défaut pour rester simple. Les appareils SmartKraft fonctionnent indépendamment de ce réglage.';

  @override
  String get settingsSectionConnectivity => 'Connectivité';

  @override
  String get settingsBluetoothStatus => 'Bluetooth';

  @override
  String get settingsBluetoothStatusOn => 'Prêt';

  @override
  String get settingsBluetoothStatusOff => 'Désactivé';

  @override
  String get settingsBluetoothStatusTurningOn => 'Activation…';

  @override
  String get settingsBluetoothStatusTurningOff => 'Désactivation…';

  @override
  String get settingsBluetoothStatusUnauthorized => 'Aucune autorisation';

  @override
  String get settingsBluetoothStatusUnsupported => 'Non pris en charge';

  @override
  String get settingsBluetoothStatusUnknown => 'Vérification…';

  @override
  String get settingsNetworkStatus => 'Réseau';

  @override
  String get settingsWifiStatusConnected => 'Wi-Fi';

  @override
  String get settingsWifiStatusEthernet => 'Ethernet';

  @override
  String get settingsWifiStatusMobile => 'Données mobiles';

  @override
  String get settingsWifiStatusDisconnected => 'Déconnecté';

  @override
  String get settingsWifiStatusUnknown => 'Vérification…';

  @override
  String get settingsWifiHint => 'Utilisé après le jumelage initial.';

  @override
  String get settingsBluetoothPermissions => 'Autorisations';

  @override
  String get settingsBluetoothPermissionsHint =>
      'Accès Bluetooth et localisation';

  @override
  String get settingsBluetoothGrantPermission => 'Autoriser l\'accès';

  @override
  String get settingsOpenSystemSettings => 'Ouvrir les paramètres système';

  @override
  String get settingsSectionUpdates => 'Mises à jour';

  @override
  String get settingsCheckUpdates => 'Rechercher des mises à jour';

  @override
  String get settingsAutoCheckUpdates => 'Vérifier au lancement';

  @override
  String get settingsAutoCheckUpdatesHint =>
      'Vérifie que vous êtes sur la dernière version à chaque ouverture de SKAPP.';

  @override
  String get settingsUpdateChannel => 'Canal de mise à jour';

  @override
  String get settingsUpdateChannelStable => 'Stable';

  @override
  String get settingsUpdateChannelBeta => 'Bêta';

  @override
  String get settingsUpdateChannelBetaHint =>
      'Recevez les nouvelles fonctionnalités plus tôt. Peut être moins stable.';

  @override
  String get settingsUpToDate => 'Vous êtes sur la dernière version.';

  @override
  String get settingsUpdateCheckPlaceholder =>
      'La recherche de mise à jour sera branchée en phase 3.';

  @override
  String get settingsSectionLegal => 'Mentions légales';

  @override
  String get settingsLicense => 'Licence et remerciements';

  @override
  String get settingsSectionInfo => 'Informations';

  @override
  String get settingsThemeCycleHint => 'Appuyez pour changer';

  @override
  String get settingsChannelCycleHint => 'Appuyez pour changer';

  @override
  String get settingsSectionThisNode => 'Ce nœud';

  @override
  String get settingsNodeNameTitle => 'Nom du nœud SKAPP';

  @override
  String settingsNodeNameSub(String name) {
    return '$name · les autres SKAPP voient ce nom · diffusion mDNS';
  }

  @override
  String get settingsSectionDanger => 'Zone de danger';

  @override
  String get settingsResetPairings => 'Réinitialiser les jumelages';

  @override
  String get settingsResetPairingsSub =>
      'Supprime tous les appareils jumelés ; paramètres/langue/nom du nœud conservés';

  @override
  String get settingsFactoryReset => 'Réinitialisation d\'usine';

  @override
  String get settingsFactoryResetSub => 'Tout est effacé, irréversible';

  @override
  String get settingsSectionAdvancedNetwork => 'Réseau avancé';

  @override
  String get settingsResetPairingsConfirmTitle =>
      'Réinitialiser tous les jumelages ?';

  @override
  String settingsResetPairingsConfirmBody(int paired, int bindings, int peers) {
    return '$paired appareil(s) jumelé(s), $bindings action(s) SKAPI et $peers pair(s) SKAPP seront supprimés. Vos paramètres, thème, langue et notes sont conservés. Les appareils conservent leur liaison de leur côté ; pour les désappairer complètement, réinitialisez l\'\'appareil manuellement. Cette action est irréversible.';
  }

  @override
  String get settingsResetPairingsConfirmAction => 'Réinitialiser';

  @override
  String get settingsFactoryResetConfirmTitle => 'Réinitialisation d\'usine ?';

  @override
  String get settingsFactoryResetConfirmBody =>
      'Tout sera effacé : tous les jumelages, paramètres, thème, langue, notes, identité réseau, certificat TLS et l\'entrée de démarrage automatique. SKAPP revient à l\'état de premier lancement. Cette action est irréversible.';

  @override
  String get settingsFactoryResetConfirmAction => 'Tout effacer';

  @override
  String get settingsFactoryResetSecondConfirmTitle =>
      'En êtes-vous absolument certain ?';

  @override
  String get settingsFactoryResetSecondConfirmBody =>
      'Tapez ERASE pour confirmer.';

  @override
  String get settingsFactoryResetSecondConfirmHint => 'ERASE';

  @override
  String get settingsFactoryResetSecondConfirmAction =>
      'Je comprends. Effacer.';

  @override
  String get settingsResetInProgress => 'Réinitialisation…';

  @override
  String get settingsResetDoneTitle => 'Réinitialisation terminée';

  @override
  String get settingsResetDoneWithWarnings =>
      'Réinitialisation terminée (avec avertissements)';

  @override
  String settingsResetSummaryPaired(int count) {
    return '$count appareil(s) jumelé(s) supprimé(s)';
  }

  @override
  String settingsResetSummaryBindings(int count) {
    return '$count action(s) SKAPI supprimée(s)';
  }

  @override
  String settingsResetSummaryPeers(int count) {
    return '$count pair(s) SKAPP supprimé(s)';
  }

  @override
  String settingsResetSummaryBonds(int count) {
    return '$count liaison(s) d\'\'appareil effacée(s)';
  }

  @override
  String get settingsResetSummaryNetworkIdentity =>
      'Identité réseau réinitialisée aux valeurs par défaut';

  @override
  String get settingsResetSummaryTlsCert => 'Certificat TLS effacé';

  @override
  String get settingsResetSummaryAutostart =>
      'Entrée de démarrage automatique supprimée';

  @override
  String get settingsResetSummaryWarningHeader => 'Avertissements :';

  @override
  String get settingsResetRestartHint =>
      'Redémarrez SKAPP pour appliquer pleinement les changements.';

  @override
  String get settingsResetRestartNow => 'Redémarrer maintenant';

  @override
  String get settingsResetClose => 'Fermer';

  @override
  String settingsFooterCombined(String version, String node) {
    return 'SKAPP $version · $node';
  }

  @override
  String get langEnglish => 'English';

  @override
  String get langTurkish => 'Türkçe';

  @override
  String get aboutTitle => 'À propos de SmartKraft et SKAPP';

  @override
  String get aboutDevicesHeading => 'Nos appareils';

  @override
  String get aboutDevicesBody =>
      'Les appareils SmartKraft sont conçus pour être innovants, distinctifs et porter des détails auxquels d\'autres n\'ont pas pensé. Notre but n\'est pas de reproduire ce qui existe déjà ; il est de réaliser ce qui n\'a pas été fait, ce qui est resté inachevé. Pointer un problème du quotidien non résolu et lui offrir une réponse simple et compréhensible ; ou prendre quelque chose qui a été résolu mais est resté cher, et mettre à sa place une version DIY que chacun peut construire.\n\nChaque appareil SmartKraft est conçu et fabriqué pour apporter une petite réponse simple à un problème encore non résolu. En concevant un appareil, nous nous posons une seule question : « Pourquoi ce problème n\'a-t-il pas été résolu jusqu\'à présent, ou pourquoi est-il resté si cher ? »';

  @override
  String get aboutSkappRoleHeading => 'La place de SKAPP';

  @override
  String get aboutSkappRoleBody =>
      'SKAPP est l\'application commune aux appareils SmartKraft. C\'est une interface utilisateur simple pour jumeler un appareil, le configurer, modifier son comportement et réunir plusieurs appareils dans un même scénario.\n\nSKAPP n\'est pas indispensable pour vos appareils ; c\'est un confort. Chaque appareil SmartKraft peut être configuré de la même manière via USB CLI sans SKAPP, et cette voie reste ouverte à ceux qui préfèrent la ligne de commande. Pour tous les autres qui veulent la rapidité d\'une interface visuelle et le confort de gérer plusieurs appareils à la fois, SKAPP est là.\n\nPas de compte cloud. Pas de publicité. Pas de collecte de données. C\'est un pont discret entre votre téléphone et votre appareil, rien de plus.';

  @override
  String get aboutShowcaseHeading => 'Vitrine des makers';

  @override
  String get aboutShowcaseEmpty =>
      'La vitrine est vide pour l\'instant. Le premier appareil SmartKraft est en chemin ; les fichiers de conception, les sources du firmware, les listes de pièces et les guides d\'assemblage seront listés ici dès qu\'ils seront prêts. D\'ici là, cette section ne promet pas grand-chose, elle réserve juste de la place pour ce qui vient.';

  @override
  String get aboutConnectHeading => 'Nous suivre';

  @override
  String get aboutConnectIntro =>
      'Envoyez un message, consultez le code source, suivez le travail à mesure qu\'il grandit.';

  @override
  String get aboutConnectGitHub => 'GitHub';

  @override
  String get aboutConnectWebsite => 'Site web';

  @override
  String get aboutConnectYouTube => 'YouTube';

  @override
  String get aboutConnectX => 'X';

  @override
  String get aboutConnectEmail => 'E-mail';

  @override
  String get aboutVersionHeading => 'Version';

  @override
  String get licenseTitle => 'Licence et remerciements';

  @override
  String get licenseSmartKraftHeading => 'À propos de SmartKraft';

  @override
  String get licenseSmartKraftBody =>
      'SmartKraft est un petit atelier qui conçoit des outils électroniques inhabituels mais pratiques pour la vie de tous les jours. Derrière chaque appareil qui vous parvient se cachent d\'innombrables étapes : une première esquisse sur un carnet, un premier prototype soudé, des lignes de code écrites tard dans la nuit, de petits détails repris encore et encore. Construire un appareil, c\'est écrire des lignes, dessiner des circuits, souder des joints, trouver des bugs, recommencer. À tous ceux qui ont mis leur effort dans ce processus sans y laisser leur nom, merci, de la part de SmartKraft.\n\nNous croyons à la culture maker, à l\'open source et à une électronique réparable et recyclable. C\'est pourquoi nous publions les conceptions matérielles de nos appareils en open hardware, et leur firmware sous AGPL 3.0. Notre objectif est de rendre accessible une version DIY du plus grand nombre possible de pièces.\n\nUne note que nous voulons aborder en toute honnêteté : les clés de jumelage et les secrets de communication qui protègent la sécurité d\'un appareil restent privés dans le code source. S\'ils étaient publiés, la confiance entre votre appareil et l\'application serait rompue. Cette fermeture n\'est pas une concession contre l\'ouverture ; c\'est une décision prise pour votre sécurité.\n\nPour SKAPP et chaque appareil qui communique avec lui, notre principe est la transparence : nous voulons que vous puissiez lire comment les choses fonctionnent, les auditer et construire votre propre version. Cela dit, chaque appareil a sa propre section de licence et les conditions peuvent varier. Pour voir le code source, les schémas ou les conditions d\'utilisation d\'un appareil, consultez la zone de licence propre à cet appareil.\n\nMerci de nous soutenir en utilisant cette application. Nous sommes heureux que vous soyez là.';

  @override
  String get licenseOpenSourceHeading => 'Sur les épaules des géants';

  @override
  String get licenseOpenSourceBody =>
      'SKAPP est bâti sur des milliers de projets open source écrits avant lui. Un grand merci à l\'équipe Flutter et à ses contributeurs pour avoir rendu possible l\'interface visible, et à tous les développeurs open source qui ont consacré des années au réseau, au stockage, à la cryptographie, au Bluetooth et à d\'innombrables sous-systèmes.\n\nParce que nous bénéficions de l\'open source, nous essayons de garder le matériel et le firmware de nos propres appareils ouverts eux aussi, afin que ceux qui viennent après nous puissent profiter de ce travail de la même façon.\n\nMerci encore à tous ceux qui ont pris part à cet effort.';

  @override
  String get licenseThirdPartyLink =>
      'Licences tierces utilisées dans cette application';

  @override
  String get discoveryTitle => 'Trouver des appareils';

  @override
  String get discoverySearching =>
      'Recherche d\'appareils SmartKraft à proximité…';

  @override
  String get discoveryNoResults =>
      'Aucun appareil SmartKraft trouvé à proximité.';

  @override
  String get discoveryTapToConnect => 'Touchez un appareil pour vous connecter';

  @override
  String get discoveryRescan => 'Rechercher à nouveau';

  @override
  String get pairingTitle => 'Jumeler l\'appareil';

  @override
  String get pairingEnterPasskey =>
      'Saisissez le code d\'accès imprimé sur l\'étiquette de l\'appareil.';

  @override
  String get pairingPasskeyHint => 'ex. K7M9P2AB';

  @override
  String get pairingConnect => 'Connecter';

  @override
  String get pairingMockNotice =>
      'Le firmware de l\'appareil n\'est pas encore prêt. Le jumelage est un espace réservé dans cette version.';

  @override
  String get errorBluetoothPermission =>
      'L\'autorisation Bluetooth est requise pour rechercher des appareils.';

  @override
  String get errorBluetoothOff => 'Le Bluetooth est désactivé.';

  @override
  String get errorLocationPermission =>
      'L\'autorisation de localisation est requise pour rechercher des appareils BLE sur Android.';

  @override
  String get actionOpenSettings => 'Ouvrir les paramètres';

  @override
  String get actionGrantPermission => 'Accorder l\'autorisation';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonConfirm => 'Confirmer';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get commonBack => 'Retour';

  @override
  String get commonRemove => 'Supprimer';

  @override
  String get commonRefresh => 'Actualiser';

  @override
  String get commonOk => 'OK';

  @override
  String get commonClose => 'Fermer';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get commonDelete => 'Supprimer';

  @override
  String get commonConnect => 'Connecter';

  @override
  String get commonAdd => 'Ajouter';

  @override
  String get commonForget => 'Oublier';

  @override
  String get commonMore => 'Plus';

  @override
  String get commonError => 'Erreur';

  @override
  String get commonOnline => 'en ligne';

  @override
  String get commonOffline => 'hors ligne';

  @override
  String get productBlockingFocus => 'Blocking Focus';

  @override
  String get productLebensSpur => 'LebensSpur';

  @override
  String get productGeneric => 'Appareil SmartKraft';

  @override
  String get timeJustNow => 'à l\'instant';

  @override
  String timeMinAgo(int count) {
    return 'il y a $count min';
  }

  @override
  String timeHourAgo(int count) {
    return 'il y a $count h';
  }

  @override
  String timeDayAgo(int count) {
    return 'il y a $count j';
  }

  @override
  String get devicesRemoveTitle => 'Supprimer l\'appareil';

  @override
  String devicesRemoveBody(String name) {
    return '$name sera supprimé. L\'\'appareil reste branché ; pour l\'\'ajouter à nouveau, vous devrez le jumeler de nouveau.';
  }

  @override
  String get devicesUnpair => 'Désappairer';

  @override
  String get devicesEmptyHint =>
      'Approchez votre appareil SmartKraft et appuyez sur le bouton ci-dessous.';

  @override
  String get devicesEmptyTitleNoPaired =>
      'Aucun appareil jumelé pour l\'instant';

  @override
  String devicesLastSeen(String time) {
    return 'Vu pour la dernière fois : $time';
  }

  @override
  String devicesPairedAt(String time) {
    return 'Jumelé : $time';
  }

  @override
  String devicesHubSubtitle(int count) {
    return 'Hôte SKAPP · $count jumelé(s)';
  }

  @override
  String get devicesHubEmptySubtitle => 'en attente d\'appareil';

  @override
  String devicesHeaderSub(int paired, int online) {
    return '$paired jumelé(s) · $online en ligne · vue constellation';
  }

  @override
  String get devicesAddPillLabel => 'Ajouter un appareil';

  @override
  String devicesLegendOnline(int count) {
    return 'en ligne ($count)';
  }

  @override
  String devicesLegendOffline(int count) {
    return 'hors ligne ($count)';
  }

  @override
  String devicesLegendLowBattery(int count) {
    return 'batterie faible ($count)';
  }

  @override
  String get devicesStatPaired => 'jumelé(s)';

  @override
  String get devicesStatBf => 'BF';

  @override
  String get devicesStatLs => 'LS';

  @override
  String get devicesStatMs => 'téléphone';

  @override
  String get devicesEmptyHubLabel => 'Inconnu';

  @override
  String get devicesEmptyAddCta => 'Ajouter le premier appareil';

  @override
  String get devicesEmptyHintChip =>
      'approchez l\'appareil, appuyez sur son bouton';

  @override
  String devicesNotifOfflineHours(int hours) {
    return 'hors ligne il y a $hours h';
  }

  @override
  String devicesNotifOfflineMinutes(int minutes) {
    return 'hors ligne il y a $minutes min';
  }

  @override
  String get devicesNotifLowBattery => 'batterie faible';

  @override
  String get skappPeersCardTitle => 'SKAPP de bureau jumelés';

  @override
  String get skappPeersCardSubtitle =>
      'Les téléphones et tablettes se jumellent ici pour qu\'une action BF puisse exécuter un script sur un SKAPP de bureau. Ouvrez SKAPP de bureau > Paramètres > Écouteur HTTP SKAPP pour obtenir un QR.';

  @override
  String get skappPeersCardEmpty => 'Aucun pair jumelé pour l\'instant.';

  @override
  String get skappPeersCardPairButton => 'Jumeler un nouveau';

  @override
  String get skappPeersCardOnline => 'en ligne';

  @override
  String get skappPeersCardOffline => 'hors ligne';

  @override
  String get skappPeersCardNeverSeen => 'jamais vu';

  @override
  String skappPeersCardRemoveTitle(String name) {
    return 'Supprimer $name ?';
  }

  @override
  String get skappPeersCardRemoveBody =>
      'SKAPP cessera d\'envoyer des scripts à ce pair. Vous pourrez le jumeler à nouveau avec le même QR / jeton plus tard.';

  @override
  String get skappPeersCardRemoveConfirm => 'Supprimer';

  @override
  String get skappPeersCardRemoveCancel => 'Annuler';

  @override
  String skappPeersCardRemovedToast(String name) {
    return '$name désappairé';
  }

  @override
  String get devicesCardLongPressHint => 'Appui long pour gérer';

  @override
  String devicesActionsSheetTitle(String name) {
    return '$name';
  }

  @override
  String get devicesActionForget => 'Oublier l\'appareil';

  @override
  String get devicesActionForgetSubtitle =>
      'Supprime cet appareil de SKAPP. L\'appareil lui-même n\'est pas affecté ; vous pourrez le jumeler à nouveau plus tard.';

  @override
  String get devicesActionCancel => 'Annuler';

  @override
  String devicesForgetDialogTitle(String name) {
    return 'Oublier $name ?';
  }

  @override
  String get devicesForgetDialogBody =>
      'SKAPP cessera de suivre cet appareil. Le jumelage côté appareil reste en place jusqu\'à ce que vous le réinitialisiez depuis l\'appareil.';

  @override
  String devicesForgetDialogBodyWithActions(int count) {
    return 'SKAPP cessera de suivre cet appareil et supprimera $count action(s) SKAPI qui y sont liées. Le jumelage côté appareil reste en place jusqu\'\'à ce que vous le réinitialisiez depuis l\'\'appareil.';
  }

  @override
  String get devicesForgetDialogConfirm => 'Oublier';

  @override
  String get devicesForgetDialogCancel => 'Annuler';

  @override
  String devicesForgotToast(String name) {
    return '$name supprimé de SKAPP';
  }

  @override
  String get devicesMobileNoDetailHint =>
      'Pas de page de détail pour les téléphones · appui long pour désappairer';

  @override
  String get devicesDesktopStatLabel => 'bureau';

  @override
  String get devicesDesktopGroupLabel => 'Bureaux jumelés';

  @override
  String get devicesDesktopTriggerDialogTitle => 'Envoyer une commande SKAPI ?';

  @override
  String devicesDesktopTriggerDialogBody(String name) {
    return 'Toutes les liaisons « touche mobile » de $name s\'\'exécuteront.';
  }

  @override
  String get devicesDesktopTriggerDialogConfirm => 'Envoyer la commande';

  @override
  String get devicesDesktopTriggerDialogCancel => 'Annuler';

  @override
  String get devicesDesktopForgetDialogTitle => 'Désappairer';

  @override
  String devicesDesktopForgetDialogBody(String name) {
    return 'Désappairage de $name. Vous devrez le jumeler à nouveau pour renvoyer des commandes à ce bureau.';
  }

  @override
  String devicesDesktopForgotToast(String name) {
    return '$name désappairé';
  }

  @override
  String get homeStatDevices => 'Appareils';

  @override
  String get homeStatOnline => 'En ligne';

  @override
  String get homeStatWarning => 'Alerte';

  @override
  String homeWarningMeta(String time) {
    return 'Jumelé mais jamais vu · $time';
  }

  @override
  String get homeBrandTotal => 'Total';

  @override
  String get homeBrandActive => 'Actif';

  @override
  String get homeBrandActions => 'Actions';

  @override
  String get homeBrandVersion => 'Version';

  @override
  String get smartkraftSectionProducts => 'Produits';

  @override
  String get smartkraftSectionCommunity => 'Communauté';

  @override
  String get smartkraftStatusLive => 'DISPONIBLE';

  @override
  String get smartkraftStatusDev => 'EN DÉV.';

  @override
  String get smartkraftStatusConcept => 'CONCEPT';

  @override
  String get smartkraftBlockingFocusTagline =>
      'La pause à laquelle vous ne pouvez pas échapper.';

  @override
  String get smartkraftLebensSpurTagline =>
      'Un témoin discret de vos habitudes.';

  @override
  String get smartkraftSynDimmTagline => 'La bonne lumière à la bonne heure.';

  @override
  String homeStickyDevicesMeta(int count, int warning) {
    return '$count appareils · $warning alertes';
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
  String get homeStickyComingSoonMeta => 'contenu en cours';

  @override
  String get homeStickyNotesLabel => 'Notes';

  @override
  String get setupChoiceTitle => 'Ajouter un appareil';

  @override
  String get setupChoiceQuestion => 'Où en sommes-nous ?';

  @override
  String get setupChoiceSubtitle =>
      'L\'appareil sort-il tout juste de sa boîte, ou a-t-il déjà été configuré via CLI ?';

  @override
  String get setupChoiceFreshTitle => 'Première configuration';

  @override
  String get setupChoiceFreshBody =>
      'J\'ajoute un appareil SmartKraft tout neuf pour la première fois. Le jumelage se fera en BLE et l\'assistant de configuration WiFi s\'ouvrira.';

  @override
  String get setupChoiceExistingTitle => 'Ajouter un appareil déjà configuré';

  @override
  String get setupChoiceExistingBody =>
      'J\'ai configuré le WiFi de mon appareil via USB/CLI et je suis sur le même réseau. Jumelez directement en WiFi et passez l\'assistant.';

  @override
  String get setupChoiceFooter =>
      'En cas de doute, choisissez « Première configuration », c\'est la bonne voie aussi bien pour un premier jumelage que pour les appareils réinitialisés en usine.';

  @override
  String get wifiDiscoveryTitle => 'Appareils sur ce réseau';

  @override
  String wifiDiscoveryScanError(String error) {
    return 'Erreur de scan : $error';
  }

  @override
  String get wifiDiscoveryHint =>
      'L\'appareil doit être en WiFi et le téléphone sur le même réseau. Il vous sera demandé d\'appuyer sur le bouton de l\'appareil pendant le jumelage.';

  @override
  String get wifiDiscoveryScanning => 'Analyse en cours…';

  @override
  String get wifiDiscoveryNotFound => 'Aucun appareil trouvé';

  @override
  String wifiDiscoveryFoundCount(int count) {
    return '$count appareil(s) trouvé(s)';
  }

  @override
  String get wifiDiscoveryEmptyTitle =>
      'Recherche d\'appareils SmartKraft sur ce réseau…';

  @override
  String get wifiDiscoveryEmptyTitleIdle => 'Aucun appareil trouvé.';

  @override
  String get wifiDiscoveryEmptyHint =>
      'Assurez-vous que l\'appareil est allumé, connecté au WiFi et sur le même réseau que votre téléphone. Utilisez le bouton d\'actualisation pour réessayer.';

  @override
  String get wifiDiscoveryPairedBadge => 'jumelé';

  @override
  String get wifiPairingTitle => 'Jumelage';

  @override
  String wifiPairingConnectFailed(String error) {
    return 'Connexion impossible : $error';
  }

  @override
  String wifiPairingInvalidJson(String error) {
    return 'JSON invalide : $error';
  }

  @override
  String get wifiPairingClosedEarly => 'Connexion fermée (pas de réponse)';

  @override
  String wifiPairingSendFailed(String error) {
    return 'Échec de l\'\'envoi de la commande : $error';
  }

  @override
  String get wifiPairingTimeout =>
      'L\'appareil n\'a pas répondu (délai dépassé).';

  @override
  String get wifiPairingNotOpen =>
      'La fenêtre de jumelage n\'est pas ouverte sur l\'appareil. Appuyez brièvement sur le bouton et réessayez.';

  @override
  String get skapiBindFixedTriggerLabel =>
      'Déclencheur : à l\'expiration du minuteur';

  @override
  String get wifiPairingDeviceAlreadyBonded =>
      'Cet appareil est déjà jumelé avec un autre SKAPP. L\'ajout d\'un nouveau pair en WiFi n\'est pas pris en charge par le firmware actuel (le TCP n\'accepte que le premier jumelage). Utilisez le jumelage BLE, ou désappairez le pair existant depuis l\'appareil.';

  @override
  String wifiPairingRejected(String error) {
    return 'Appareil rejeté : $error';
  }

  @override
  String get wifiPairingMissingPub =>
      'our_pub manquant/corrompu en provenance de l\'appareil.';

  @override
  String wifiPairingHexError(String error) {
    return 'Échec du décodage hexadécimal de our_pub : $error';
  }

  @override
  String get wifiPairingStageAwaiting => 'Appuyez sur le bouton de l\'appareil';

  @override
  String get wifiPairingStageConnecting => 'Connexion à l\'appareil…';

  @override
  String get wifiPairingStageExchanging => 'Échange des clés…';

  @override
  String get wifiPairingStageDone => 'Jumelage terminé';

  @override
  String get wifiPairingStageFailed => 'Échec du jumelage';

  @override
  String get wifiPairingStageAwaitingHelp =>
      'Appuyez brièvement sur le bouton de commande de l\'appareil (moins de 3 secondes). La fenêtre de jumelage reste ouverte 60 secondes.';

  @override
  String get wifiPairingStageConnectingHelp => 'Ouverture du socket TCP.';

  @override
  String get wifiPairingStageExchangingHelp =>
      'pairing.ecdh.exchange envoyé, en attente de la réponse de l\'appareil.';

  @override
  String get wifiPairingStageDoneHelp =>
      'Direction le tableau de bord de l\'appareil.';

  @override
  String get wifiPairingStartCta => 'Jumeler';

  @override
  String get bfDashboardTitleFallback => 'Appareil';

  @override
  String get bfDashboardWifiNone => 'Pas de WiFi';

  @override
  String get bfDashboardLinkBle => 'BLE';

  @override
  String get bfDashboardLinkWifi => 'WiFi';

  @override
  String get bfDashboardLinkUsb => 'USB';

  @override
  String get bfDashboardToggleVibration => 'Vibration';

  @override
  String get bfDashboardToggleTilt => 'Alerte d\'inclinaison';

  @override
  String get bfDashboardToggleLowBatt => 'Alerte de batterie faible';

  @override
  String get bfDashboardApiChainTitle => 'Chaîne API';

  @override
  String bfDashboardApiChainNone(String state) {
    return 'aucun endpoint pour l\'\'instant · maître $state';
  }

  @override
  String bfDashboardApiChainSummary(int count, String state) {
    return '$count endpoint(s) · maître $state';
  }

  @override
  String get bfDashboardMasterOn => 'actif';

  @override
  String get bfDashboardMasterOff => 'inactif';

  @override
  String get bfDashboardNotebookTitle => 'Carnet utilisateur';

  @override
  String get bfDashboardNotebookSubtitle =>
      'Zone chiffrée · 100 Ko · contenu libre';

  @override
  String get bfDashboardMoreDeviceInfo => 'Infos appareil';

  @override
  String get bfDashboardMoreSettings => 'Paramètres';

  @override
  String bfDashboardWriteFailed(String error) {
    return 'Écriture impossible : $error';
  }

  @override
  String get bfDeviceInfoTitle => 'Infos appareil';

  @override
  String get bfDeviceInfoSectionGeneral => 'GÉNÉRAL';

  @override
  String get bfDeviceInfoSectionConnection => 'CONNEXION';

  @override
  String get bfDeviceInfoSectionBattery => 'BATTERIE';

  @override
  String get bfDeviceInfoSectionTime => 'HEURE';

  @override
  String get bfDeviceInfoSectionLastError => 'DERNIÈRE ERREUR';

  @override
  String get bfDeviceInfoSectionDiagnostics => 'DIAGNOSTICS';

  @override
  String get bfDeviceInfoSectionDocs => 'DOCS';

  @override
  String get bfDeviceInfoProduct => 'Produit';

  @override
  String get bfDeviceInfoTypeCode => 'Code de type';

  @override
  String get bfDeviceInfoIdentity => 'Identité';

  @override
  String get bfDeviceInfoHardware => 'Matériel';

  @override
  String get bfDeviceInfoFirmware => 'Firmware';

  @override
  String get bfDeviceInfoProtocol => 'Protocole';

  @override
  String get bfDeviceInfoBuild => 'Build';

  @override
  String get bfDeviceInfoUptime => 'Temps de fonctionnement';

  @override
  String get bfDeviceInfoWifiState => 'État WiFi';

  @override
  String get bfDeviceInfoIp => 'IP';

  @override
  String get bfDeviceInfoSignal => 'Signal';

  @override
  String get bfDeviceInfoBleAdvertising => 'Annonce BLE';

  @override
  String get bfDeviceInfoBlePaired => 'Jumelages BLE';

  @override
  String bfDeviceInfoPairedClients(int count) {
    return '$count client(s)';
  }

  @override
  String get bfDeviceInfoBattery => 'Batterie';

  @override
  String get bfDeviceInfoBatteryPresent => 'présente';

  @override
  String get bfDeviceInfoBatteryAbsent => 'absente';

  @override
  String get bfDeviceInfoDeviceClock => 'Horloge de l\'appareil';

  @override
  String get bfDeviceInfoLogs => 'Journaux de l\'appareil';

  @override
  String get bfDeviceInfoLogsSubtitle =>
      'logs.get, démarrage, erreur, minuteur, événements API';

  @override
  String get bfDeviceInfoEvents => 'Historique des événements';

  @override
  String get bfDeviceInfoEventsSubtitle =>
      'Local · minuteur, changement de face, déclencheurs API';

  @override
  String get bfDeviceInfoUserGuide => 'Guide d\'utilisation';

  @override
  String get bfDeviceInfoUserGuideSubtitle =>
      'Attribution des faces, minuteur, déclencheurs API';

  @override
  String get bfDeviceInfoDevNotes => 'Notes développeur SK';

  @override
  String get bfDeviceInfoDevNotesSubtitle =>
      'Commandes CLI, architecture, taxonomie des événements';

  @override
  String get bfDeviceInfoLicense => 'Licence et sources ouvertes';

  @override
  String get bfDeviceInfoLicenseSubtitle =>
      'Bibliothèques utilisées et informations de droits d\'auteur';

  @override
  String get bfDeviceInfoComingSoon => 'Bientôt disponible';

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
    return '$d j $h h';
  }

  @override
  String get bfDeviceInfoYes => 'oui';

  @override
  String get bfDeviceInfoNo => 'non';

  @override
  String get bfSettingsTitle => 'Paramètres';

  @override
  String get bfSettingsSectionNetwork => 'RÉSEAU';

  @override
  String get bfSettingsSectionUpdates => 'MISES À JOUR';

  @override
  String get bfSettingsSectionDanger => 'ZONE DE DANGER';

  @override
  String get bfSettingsWifiPrimary => 'WiFi principal';

  @override
  String get bfSettingsWifiSecondary => 'WiFi de secours';

  @override
  String get bfSettingsWifiUnconfigured => 'Non configuré';

  @override
  String get bfSettingsFirmware => 'Firmware';

  @override
  String get bfSettingsCheckUpdates => 'Rechercher des mises à jour';

  @override
  String get bfSettingsCheckUpdatesSubtitle =>
      'S\'active une fois une URL de manifeste définie';

  @override
  String get bfOtaTitle => 'Mise à jour du firmware';

  @override
  String get bfOtaCurrentLabel => 'Version installée';

  @override
  String get bfOtaRunningPartitionLabel => 'Partition active';

  @override
  String get bfOtaCheckCta => 'Rechercher des mises à jour';

  @override
  String get bfOtaIdleHint =>
      'Aucune recherche de mise à jour n\'a encore été effectuée.';

  @override
  String get bfOtaChecking => 'Vérification du serveur de mise à jour…';

  @override
  String get bfOtaUpToDate => 'L\'appareil est à jour.';

  @override
  String bfOtaAvailable(String version) {
    return 'Nouvelle version disponible : $version';
  }

  @override
  String get bfOtaUpdateCta => 'Mettre à jour maintenant';

  @override
  String bfOtaDownloading(int pct) {
    return 'Téléchargement… %$pct';
  }

  @override
  String get bfOtaDone => 'Mise à jour effectuée. L\'appareil redémarre…';

  @override
  String bfOtaErrorMsg(String message) {
    return 'Erreur : $message';
  }

  @override
  String get bfOtaRollbackCta => 'Revenir à la version précédente';

  @override
  String get bfOtaUpdateConfirmTitle =>
      'Installer la mise à jour du firmware ?';

  @override
  String bfOtaUpdateConfirmBody(String version) {
    return 'La version $version sera téléchargée et installée, puis l\'\'appareil redémarrera. Ne l\'\'éteignez pas pendant la mise à jour.';
  }

  @override
  String get bfOtaRollbackConfirmTitle => 'Revenir au firmware précédent ?';

  @override
  String get bfOtaRollbackConfirmBody =>
      'L\'appareil démarrera sur le firmware précédent et redémarrera.';

  @override
  String get bfSettingsReboot => 'Redémarrer l\'appareil';

  @override
  String get bfSettingsRebootSubtitle =>
      'Éteint et rallume l\'appareil · annule tout minuteur actif';

  @override
  String get bfSettingsRebootConfirmTitle => 'Redémarrer l\'appareil ?';

  @override
  String get bfSettingsRebootConfirmBody =>
      'L\'appareil s\'éteindra puis se rallumera dans quelques secondes.';

  @override
  String get bfSettingsUnpairThisPhone => 'Désappairer ce téléphone';

  @override
  String get bfSettingsUnpairSubtitle =>
      'Supprime la liaison · l\'appareil devra être jumelé à nouveau';

  @override
  String get bfSettingsUnpairConfirmTitle => 'Désappairer ce téléphone ?';

  @override
  String get bfSettingsFactoryReset => 'Réinitialisation d\'usine';

  @override
  String get bfSettingsFactoryResetSubtitle =>
      'Efface le WiFi, les endpoints API et les jumelages';

  @override
  String get bfSettingsFactoryResetConfirmTitle =>
      'Réinitialisation d\'usine ?';

  @override
  String get bfSettingsFactoryResetConfirmBody =>
      'Tous les paramètres seront effacés. L\'appareil redémarrera.';

  @override
  String get bfWifiManagementTitle => 'Gestion du WiFi';

  @override
  String get bfWifiConnecting => 'Connexion…';

  @override
  String bfWifiConnectionRejected(String error) {
    return 'Connexion rejetée : $error';
  }

  @override
  String bfWifiConfigure(String label) {
    return 'Configurer $label';
  }

  @override
  String get bfWifiPasswordLabel => 'Mot de passe';

  @override
  String get bfNotebookTitle => 'Carnet utilisateur';

  @override
  String get bfNotebookSaveCancel => 'Annuler';

  @override
  String get bfApiChainCancel => 'Annuler';

  @override
  String get bfApiChainRunChain => 'Exécuter la chaîne';

  @override
  String get bfApiChainToggleAll => 'Tout activer/désactiver';

  @override
  String get bfApiChainFieldName => 'Nom';

  @override
  String get bfApiChainFieldType => 'Type';

  @override
  String get bfApiChainFieldHeaderName => 'Nom de l\'en-tête';

  @override
  String get bfApiChainFieldNewToken =>
      'Nouveau jeton (laisser vide pour conserver)';

  @override
  String get bfHomeLoadingConnecting => 'Connexion à l\'appareil…';

  @override
  String get bfHomeLoadingSecure => 'Ouverture du canal sécurisé…';

  @override
  String get deviceConnUnreachableTitle => 'Impossible de joindre l\'appareil';

  @override
  String get deviceConnUnreachableBody =>
      'L\'appareil est peut-être éteint, hors de portée ou en veille. Assurez-vous qu\'il est allumé et à proximité, puis réessayez.';

  @override
  String get deviceConnRepairTitle => 'Le jumelage doit être renouvelé';

  @override
  String get deviceConnRepairBody =>
      'L\'appareil semble avoir été réinitialisé et ne reconnaît plus ce téléphone. Jumelez-le à nouveau pour vous reconnecter.';

  @override
  String get deviceConnRepairButton => 'Jumeler à nouveau';

  @override
  String get deviceConnTechnicalDetails => 'Détails techniques';

  @override
  String get bfLogsTitle => 'Journaux de l\'appareil';

  @override
  String get bfEventsTitle => 'Historique des événements';

  @override
  String get pairingStepConnecting => 'Connexion';

  @override
  String get pairingStepConnectingSubtitle => 'Lien BLE + découverte GATT';

  @override
  String get pairingStepMutualAuth => 'Authentification mutuelle';

  @override
  String get pairingStepDeviceInfo => 'Vérification device.info';

  @override
  String get pairingStepDeviceInfoSubtitle =>
      'Canal chiffré établi, ping de contrôle';

  @override
  String get pairingStepConnected => 'Connexion établie';

  @override
  String get pairingStepConnectedSubtitle =>
      'CLI prête, passage à la configuration';

  @override
  String get pairingStepKeyExchange => 'Échange de clés';

  @override
  String get pairingStepKeyExchangeSubtitle => 'X25519, clé publique envoyée';

  @override
  String get pairingStepVerifying => 'Vérification';

  @override
  String get pairingStepVerifyingSubtitle =>
      'En attente de l\'appareil, dérivation du jeton';

  @override
  String get pairingStepDone => 'Jumelage terminé';

  @override
  String get pairingStepDoneSubtitle =>
      'Liaison stockée sur l\'appareil et le téléphone';

  @override
  String get pairingLogTitle => 'Journal de jumelage';

  @override
  String get pairingLogCopied => 'Journal copié dans le presse-papiers';

  @override
  String get discoveryPreparing => 'Préparation…';

  @override
  String get discoveryBluetoothOff => 'Le Bluetooth est désactivé';

  @override
  String get wifiPasswordTitle => 'Connecter l\'appareil au WiFi';

  @override
  String get wifiPasswordSsidLabel => 'Nom du réseau (SSID)';

  @override
  String get wifiPasswordNetworkLabel => 'Réseau';

  @override
  String get wifiPasswordPasswordLabel => 'Mot de passe';

  @override
  String get wifiPasswordConnect => 'Connecter';

  @override
  String get wifiPasswordLogTitle => 'Journal de connexion';

  @override
  String get wifiPasswordLogCopied => 'Journal copié dans le presse-papiers';

  @override
  String get wifiScanTitle => 'Choisir un réseau WiFi pour l\'appareil';

  @override
  String get wifiScanRescanTooltip =>
      'Demander à l\'appareil de relancer l\'analyse';

  @override
  String get wifiScanRunning => 'Le scanner WiFi de l\'appareil est en cours…';

  @override
  String get wifiScanNoNetworks =>
      'L\'appareil n\'a trouvé aucun WiFi à proximité.';

  @override
  String get wifiScanRescan => 'Demander à l\'appareil de relancer l\'analyse';

  @override
  String get wifiScanHiddenAdd => 'Ajouter un réseau masqué';

  @override
  String get wifiScanHiddenSubtitle => 'Saisir le SSID manuellement';

  @override
  String get wifiScanLogTitle => 'Journal d\'analyse WiFi';

  @override
  String get wifiSuccessReady => 'Terminé';

  @override
  String get bfEventsClearTooltip => 'Effacer';

  @override
  String get bfEventsEmpty =>
      'Aucun événement pour l\'instant. Ils apparaîtront ici dès que l\'appareil commencera à les publier.';

  @override
  String get logsEmptyTooltip => 'Le journal est vide.';

  @override
  String logsErrorPrefix(String error) {
    return 'Erreur : $error';
  }

  @override
  String get notebookSaved => 'Enregistré';

  @override
  String notebookSaveError(String error) {
    return 'Erreur : $error';
  }

  @override
  String notebookCapacityExceeded(int used, int capacity) {
    return 'Capacité dépassée : $used / $capacity octets';
  }

  @override
  String get notebookClearTooltip => 'Effacer le carnet';

  @override
  String get notebookClearConfirmTitle => 'Effacer tout le carnet ?';

  @override
  String get notebookClearConfirmBody =>
      'Toutes les données utilisateur de l\'appareil seront effacées. Action irréversible.';

  @override
  String get notebookClearAction => 'Effacer';

  @override
  String get notebookClearedSnack => 'Carnet effacé';

  @override
  String notebookClearError(String error) {
    return 'Effacement impossible : $error';
  }

  @override
  String get notebookEncryptedHint =>
      'Zone chiffrée · seul le SKAPP jumelé peut la lire';

  @override
  String get notebookEmptyTitle => 'Le carnet est vide';

  @override
  String get notebookEmptyBody =>
      'Saisissez des notes, du JSON, des définitions de scène ou tout autre texte ci-dessous. Appuyer sur Enregistrer le stocke chiffré sur l\'appareil.';

  @override
  String get notebookHint =>
      'Tapez ce que vous voulez ici (notes, JSON, votre propre schéma). Jusqu\'à 100 Ko stockés sur l\'appareil.';

  @override
  String get notebookDirty => 'Modifications non enregistrées';

  @override
  String get notebookSaved2 => 'Enregistré';

  @override
  String get notebookSyncedDifferent => 'Synchronisé';

  @override
  String get notebookSaveCta => 'Enregistrer';

  @override
  String wifiPairingHexErrorRaw(String error) {
    return 'Échec du décodage hexadécimal de our_pub : $error';
  }

  @override
  String get bfWifiForgetTitle => 'Oublier l\'emplacement ?';

  @override
  String get bfWifiForgetBody =>
      'L\'emplacement sera effacé. Si l\'appareil y est actuellement connecté, il basculera sur l\'autre emplacement (le cas échéant). Une reconfiguration est nécessaire pour le restaurer.';

  @override
  String get bfWifiForget => 'Oublier';

  @override
  String get bfWifiHint =>
      'L\'appareil essaie les deux réseaux dans l\'ordre : Principal d\'abord, Secours en cas d\'échec. L\'emplacement actif est marqué d\'un point vert.';

  @override
  String get bfWifiActive => 'ACTIF';

  @override
  String get bfWifiNotConfigured => 'Non configuré';

  @override
  String get bfWifiChange => 'Modifier';

  @override
  String get bfWifiSetUp => 'Configurer';

  @override
  String get discoveryStatusChecking => 'Vérification de l\'état du Bluetooth.';

  @override
  String get discoveryPermissionsTitle => 'Autorisation Bluetooth requise';

  @override
  String get discoveryPermissionsBody =>
      'Pour trouver les appareils SmartKraft à proximité, veuillez activer l\'autorisation Bluetooth.';

  @override
  String get discoveryPermissionsRetry => 'Redemander les autorisations';

  @override
  String get discoveryPermissionsOpenSettings => 'Ouvrir les paramètres';

  @override
  String get discoveryAdapterOffBody =>
      'Activez le Bluetooth pour rechercher des appareils.';

  @override
  String get discoveryAdapterOffEnable => 'Activer le Bluetooth';

  @override
  String get discoveryUnsupportedTitle => 'BLE non pris en charge';

  @override
  String get discoveryUnsupportedBody =>
      'Cet appareil ne prend pas en charge le Bluetooth Low Energy, et SKAPP a besoin du BLE pour fonctionner.';

  @override
  String get wifiPasswordHelp =>
      'L\'appareil rejoindra ce réseau. Saisissez le mot de passe, tapez-le avec soin.';

  @override
  String get wifiPasswordRequired => 'Le mot de passe est requis';

  @override
  String get wifiPasswordMinLength => 'Au moins 8 caractères';

  @override
  String wifiPasswordSendError(String error) {
    return 'Envoi impossible : $error';
  }

  @override
  String get wifiScanTimeoutHint =>
      'Si l\'analyse prend trop de temps, l\'appareil a peut-être perdu la portée WiFi. Appuyez sur réessayer.';

  @override
  String get wifiScanFailedTitle => 'Échec de l\'analyse';

  @override
  String get wifiScanRetry => 'Réessayer';

  @override
  String get wifiSuccessTitle => 'Connecté';

  @override
  String get wifiSuccessBody =>
      'L\'appareil est maintenant en WiFi. Retour au tableau de bord…';

  @override
  String get deviceNameSectionHeading =>
      'NOM DE L\'APPAREIL (CETTE APP UNIQUEMENT)';

  @override
  String get deviceNameLabel => 'Nom personnalisé';

  @override
  String get deviceNameHint => 'ex. BF du bureau';

  @override
  String get deviceNameSubtitle =>
      'Affiché sur les cartes de cette installation SKAPP. Non envoyé à l\'appareil.';

  @override
  String get deviceNameClear => 'Effacer';

  @override
  String get deviceNameSave => 'Enregistrer';

  @override
  String get deviceNameSaved => 'Enregistré';

  @override
  String get deviceNameEmptyPlaceholder => '(aucun nom personnalisé)';

  @override
  String get settingsUsbConsoleTitle => 'Console CLI USB';

  @override
  String get settingsUsbConsoleSubtitle =>
      'Envoyez des commandes brutes à un appareil connecté en USB';

  @override
  String get usbConsoleAppBarTitle => 'Console USB';

  @override
  String get usbConsolePickPortTitle => 'Sélectionner un port';

  @override
  String get usbConsolePickPortHint =>
      'Branchez un appareil SmartKraft en USB et appuyez sur actualiser';

  @override
  String get usbConsolePortRefreshTooltip => 'Actualiser les ports';

  @override
  String get usbConsoleBfBadge => 'SmartKraft';

  @override
  String get usbConsoleConnecting => 'Connexion…';

  @override
  String get usbConsoleConnected => 'Connecté';

  @override
  String get usbConsoleDisconnected => 'Déconnecté';

  @override
  String usbConsoleErrorBanner(String error) {
    return 'Erreur : $error';
  }

  @override
  String get usbConsoleReconnect => 'Reconnecter';

  @override
  String get usbConsoleDisconnect => 'Déconnecter';

  @override
  String get usbConsoleClear => 'Effacer la console';

  @override
  String get usbConsoleInputHint => 'Tapez une commande, ex. device.info';

  @override
  String get usbConsoleSend => 'Envoyer';

  @override
  String get usbConsoleEmptyHint =>
      'Tapez une commande et appuyez sur Entrée, essayez device.info';

  @override
  String get usbConsoleEntryEvent => 'evt';

  @override
  String get usbConsoleEntryError => 'erreur';

  @override
  String get usbConsoleNotSupportedIos =>
      'La console USB n\'est pas prise en charge sur iOS';

  @override
  String get passphraseFieldLabel => 'Phrase secrète';

  @override
  String get passphraseVerifyButton => 'Vérifier';

  @override
  String passphraseAttemptsLeft(int count) {
    return 'Tentatives restantes : $count';
  }

  @override
  String get passphraseLockoutTriggered =>
      'Trop de tentatives erronées de phrase secrète ; l\'appareil s\'est réinitialisé en usine.';

  @override
  String get bondPeerUnnamed => '(sans nom)';

  @override
  String get pairingPassphraseDialogTitle => 'Phrase secrète de l\'appareil';

  @override
  String get pairingPassphraseDialogBody =>
      'Cet appareil exige une phrase secrète pour accéder au contenu. Saisissez-la pour terminer le jumelage.';

  @override
  String get pairingPassphraseCancelled =>
      'Phrase secrète non saisie, jumelage annulé.';

  @override
  String pairingPassphraseSendError(String error) {
    return 'Envoi de la phrase secrète impossible : $error';
  }

  @override
  String get pairingPassphraseTimeout =>
      'L\'appareil n\'a pas répondu (vérification de la phrase secrète, 8 s).';

  @override
  String get pairingWindowClosedRetry =>
      'Fenêtre de jumelage fermée, appuyez brièvement sur le bouton et réessayez.';

  @override
  String pairingPassphraseFailed(String error) {
    return 'Vérification de la phrase secrète impossible : $error';
  }

  @override
  String get bondStoreFullHeader =>
      'Les 8 emplacements de liaison sont occupés. Supprimez un pair existant pour jumeler un nouveau SKAPP :';

  @override
  String bondStoreFullPeerLine(Object slot, String name, String shortPid) {
    return '  • emplacement $slot, $name [#$shortPid]';
  }

  @override
  String get bondStoreFullFooter =>
      'Depuis un autre SKAPP jumelé ou via USB, exécutez\n`bond.remove --slot N`, puis appuyez sur Réessayer ici.';

  @override
  String get passphraseGateDialogBody =>
      'Cet appareil demande la phrase secrète à chaque connexion. Saisissez-la pour accéder au contenu.';

  @override
  String get passphraseGateCancelled =>
      'Phrase secrète non saisie, la vérification est requise pour accéder à cet écran.';

  @override
  String passphraseGateVerifyError(String error) {
    return 'Erreur de vérification : $error';
  }

  @override
  String passphraseGateCommError(String error) {
    return 'Erreur de communication : $error';
  }

  @override
  String get passphraseGateUnknownError => 'Erreur de verrouillage inconnue.';

  @override
  String get bfPassphraseTitle => 'Phrase secrète de l\'appareil';

  @override
  String get bfPassphraseSetTitle => 'Définir la phrase secrète';

  @override
  String get bfPassphraseChangeTitle => 'Modifier la phrase secrète';

  @override
  String get bfPassphraseClearTitle => 'Supprimer la phrase secrète';

  @override
  String get bfPassphraseChangeSubtitle =>
      'Saisissez l\'ancienne phrase secrète, définissez la nouvelle';

  @override
  String get bfPassphraseClearSubtitle =>
      'Réinitialiser le verrou de contenu sur l\'appareil';

  @override
  String get bfPassphraseModePairing => 'Demander lors du jumelage';

  @override
  String get bfPassphraseModePairingSubtitle =>
      'Demande lorsqu\'un nouveau SKAPP se jumelle. Les pairs existants ne sont pas sollicités.';

  @override
  String get bfPassphraseModeAlways => 'Demander à chaque connexion';

  @override
  String get bfPassphraseModeAlwaysSubtitle =>
      'Demande à chaque ouverture de session. Le contenu reste verrouillé même si un SKAPP est volé.';

  @override
  String get bfPassphraseStatusNone =>
      'Aucune phrase secrète, l\'appareil n\'a pas de verrou de contenu';

  @override
  String get bfPassphraseStatusActiveOff =>
      'Phrase secrète définie · application désactivée (les deux options désactivées)';

  @override
  String get bfPassphraseStatusActivePairing => 'Demandée lors du jumelage';

  @override
  String get bfPassphraseStatusActiveAlways => 'Demandée à chaque connexion';

  @override
  String get bfPassphraseBadgeActive => 'Phrase secrète active';

  @override
  String get bfPassphraseBadgeNone => 'Aucune phrase secrète';

  @override
  String bfPassphraseAttemptsRatio(int left, int total) {
    return 'Tentatives restantes : $left / $total';
  }

  @override
  String bfPassphraseLengthSubtitle(int min, int max) {
    return 'Longueur $min-$max caractères';
  }

  @override
  String bfPassphraseLengthHint(int min, int max) {
    return 'Longueur : $min-$max';
  }

  @override
  String bfPassphraseTooShort(int min) {
    return 'Au moins $min caractères';
  }

  @override
  String bfPassphraseTooLong(int max) {
    return 'Au plus $max caractères';
  }

  @override
  String get bfPassphraseEmpty => 'Ne peut pas être vide';

  @override
  String get bfPassphraseNewLabel => 'Nouvelle phrase secrète';

  @override
  String get bfPassphraseCurrentLabel => 'Phrase secrète actuelle';

  @override
  String get bfPassphraseSetDone => 'Phrase secrète définie';

  @override
  String get bfPassphraseChangeDone => 'Phrase secrète modifiée';

  @override
  String get bfPassphraseClearDone => 'Phrase secrète supprimée';

  @override
  String bfPassphraseStatusReadError(String error) {
    return 'Lecture du statut impossible : $error';
  }

  @override
  String get bfPassphraseNotesTitle => 'Notes';

  @override
  String get bfPassphraseNotesBody =>
      '• La phrase secrète est hachée sur l\'appareil avec PBKDF2-SHA256 ; elle n\'est jamais stockée en clair.\n• 10 tentatives erronées réinitialisent l\'appareil en usine ; toutes les liaisons et données sont effacées.\n• Un appareil connecté en USB ignore l\'invite de phrase secrète, l\'accès physique permet déjà la réinitialisation d\'usine via le bouton.';

  @override
  String bfBondListTitle(int used, int capacity) {
    return 'SKAPP jumelés  ($used/$capacity)';
  }

  @override
  String get bfBondListEmpty => 'Aucun pair jumelé pour l\'instant.';

  @override
  String get bfBondListBadgeThisPhone => 'Ce téléphone';

  @override
  String get bfBondListBadgeActiveSession => 'Session active';

  @override
  String bfBondListRowSubtitle(String shortPid, String date) {
    return '#$shortPid · jumelé : $date';
  }

  @override
  String get bfBondListRemoveTooltip => 'Supprimer ce pair';

  @override
  String get bfBondListRemoveTitle => 'Supprimer le pair ?';

  @override
  String get bfBondListRemoveSelfBody =>
      'Vous supprimez la liaison de ce téléphone. Si vous confirmez, la session se ferme ; pour rejoindre l\'appareil à nouveau, vous devrez appuyer brièvement sur le bouton et le jumeler de nouveau.';

  @override
  String bfBondListRemoveOtherBody(String label, int slot) {
    return '« $label » (emplacement $slot) est effacé de l\'\'appareil. Ce SKAPP devra appuyer brièvement sur le bouton et se jumeler à nouveau pour se reconnecter.';
  }

  @override
  String bfBondListSlotRemoved(int slot) {
    return 'Emplacement $slot supprimé';
  }

  @override
  String bfBondListFetchError(String error) {
    return 'Échec de bond.list : $error';
  }

  @override
  String get bfSettingsSectionSecurity => 'SÉCURITÉ';

  @override
  String get bfSettingsPassphraseTitle => 'Phrase secrète de l\'appareil';

  @override
  String get bfSettingsBondListTitle => 'SKAPP jumelés';

  @override
  String get bfSettingsPassphraseSubtitleAlways => 'Active, à chaque connexion';

  @override
  String get bfSettingsPassphraseSubtitlePairing => 'Active, au jumelage';

  @override
  String get bfSettingsPassphraseSubtitleOff =>
      'Active, application désactivée';

  @override
  String bfSettingsBondsSubtitle(int count, int capacity) {
    return 'Pairs jumelés : $count / $capacity';
  }

  @override
  String get skapiHowItWorksTitle => 'Comment ça marche';

  @override
  String skapiHowItWorksBody(String deviceName) {
    return 'Lorsque votre appareil SmartKraft (par exemple $deviceName) connaît un événement tel que la fin d\'\'un minuteur, une pression de bouton ou un déclenchement de capteur, il envoie une petite commande à votre ordinateur. Votre ordinateur reçoit cette commande et exécute le script que vous avez choisi.';
  }

  @override
  String get skapiHowItWorksFlowDeviceLabel => 'Appareil SmartKraft';

  @override
  String get skapiHowItWorksFlowDeviceSub =>
      'ex. Blocking Focus, déclenche un événement';

  @override
  String get skapiHowItWorksFlowComputerLabel => 'Ordinateur';

  @override
  String get skapiHowItWorksFlowComputerSub =>
      'SKAPP reçoit la commande, le script s\'exécute';

  @override
  String get skapiHowItWorksFoot =>
      'SKAPP doit être en cours d\'exécution sur votre ordinateur. Tout le trafic reste sur le réseau WiFi, aucune connexion Internet n\'est nécessaire, et aucune donnée ne quitte votre domicile.';

  @override
  String get skapiPlatformGroupsHeader => 'Catégories d\'actions';

  @override
  String skapiPlatformGroupsLoadError(String error) {
    return 'Échec du chargement des groupes : $error';
  }

  @override
  String get skapiPlatformEmptyTitle => 'Aucun script ici pour l\'instant';

  @override
  String get skapiPlatformEmptyBody =>
      'Les scripts pour cette plateforme sont encore en chemin. Revenez après la prochaine mise à jour de SKAPP.';

  @override
  String skapiGroupScriptsLoadError(String error) {
    return 'Échec du chargement des scripts : $error';
  }

  @override
  String skapiScriptDetailLoadError(String error) {
    return 'Impossible de charger ce script : $error';
  }

  @override
  String get skapiBindScreenTitle => 'Lier à une action';

  @override
  String get skapiBindScreenSubtitle =>
      'Exécutez ce script automatiquement quand un événement de l\'appareil se déclenche.';

  @override
  String get skapiBindFieldDeviceLabel => 'Appareil';

  @override
  String get skapiBindFieldDeviceHint =>
      'Choisissez quel appareil jumelé doit déclencher ce script.';

  @override
  String get skapiBindFieldDeviceEmpty =>
      'Aucun appareil jumelé pour l\'instant. Jumelez-en un depuis l\'onglet Appareils d\'abord.';

  @override
  String get skapiBindFieldEventLabel => 'Événement';

  @override
  String get skapiBindFieldEventHint =>
      'L\'appareil émet cet événement ; le script s\'exécute lorsqu\'il survient.';

  @override
  String get skapiBindEventTimerStarted => 'Minuteur démarré';

  @override
  String get skapiBindEventTimerExpired => 'Minuteur expiré';

  @override
  String get skapiBindEventFaceChanged => 'Face du cube changée';

  @override
  String get skapiBindEventButtonPressed => 'Bouton pressé';

  @override
  String get skapiBindEventButtonHeld => 'Bouton maintenu';

  @override
  String get skapiBindEventBatteryLow => 'Batterie faible';

  @override
  String get skapiBindEventBatteryLockout => 'Verrouillage batterie';

  @override
  String get skapiBindEventPowerStateChanged => 'État d\'alimentation changé';

  @override
  String get skapiBindEventPairingSuccess => 'Jumelage réussi';

  @override
  String get skapiBindEventApiSent => 'Appel API envoyé';

  @override
  String get skapiBindParamsHeader => 'Remplacements de paramètres';

  @override
  String get skapiBindParamsHint =>
      'Laissez vide pour conserver les valeurs par défaut du script. Ces valeurs sont envoyées à chaque déclenchement de la liaison.';

  @override
  String get skapiBindButtonSave => 'Enregistrer la liaison';

  @override
  String get skapiBindButtonDelete => 'Supprimer la liaison';

  @override
  String get skapiBindButtonCancel => 'Annuler';

  @override
  String get skapiBindButtonEnable => 'Activer';

  @override
  String get skapiBindButtonDisable => 'Désactiver';

  @override
  String get skapiBindStatusEnabled => 'Active';

  @override
  String get skapiBindStatusDisabled => 'En pause';

  @override
  String get skapiBindSavedToast => 'Liaison enregistrée';

  @override
  String get skapiBindDeletedToast => 'Liaison supprimée';

  @override
  String skapiBindBadgeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count liaisons',
      one: '1 liaison',
    );
    return '$_temp0';
  }

  @override
  String get skapiBindNoPairedDeviceWarning =>
      'Jumelez d\'abord un appareil pour créer des liaisons.';

  @override
  String skapiBindTriggeredDesktopToast(String script) {
    return 'Déclenché : $script';
  }

  @override
  String skapiBindTriggeredMobileToast(String event) {
    return 'Liaison déclenchée ($event) ; l\'\'exécution arrive en phase K.';
  }

  @override
  String skapiBindLoadError(String error) {
    return 'Impossible de charger les liaisons : $error';
  }

  @override
  String get skapiBindListSectionTitle => 'Liaisons sur ce script';

  @override
  String get skapiBindListEmpty =>
      'Aucune liaison pour l\'instant. Appuyez sur Lier à une action pour en créer une.';

  @override
  String get skapiBindNewButton => 'Nouvelle liaison';

  @override
  String get skapiBasicSettingsTitle => 'Paramètres';

  @override
  String get skapiBasicEmptyParams =>
      'Ce script ne nécessite aucun paramètre. Appuyez sur Exécuter maintenant.';

  @override
  String get skapiBasicUnitSeconds => 'secondes';

  @override
  String get skapiBasicConvHalfMinute => 'une demi-minute';

  @override
  String get skapiBasicConvLessThanMinute => 'moins d\'une minute';

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
      other: '$count heures',
      one: '1 heure',
    );
    return '$_temp0';
  }

  @override
  String get skapiBasicConvImmediate => 'démarre immédiatement';

  @override
  String skapiBasicConvAfter(String time) {
    return 'après $time';
  }

  @override
  String get skapiBasicPrerunSectionTitle => 'Délai avant exécution';

  @override
  String get skapiBasicPrerunAddCta => 'Ajouter un délai avant l\'exécution';

  @override
  String get skapiBasicPrerunLabel =>
      'Attendre ce nombre de secondes avant que le script démarre';

  @override
  String get skapiBasicPrerunHelp =>
      'Utile pour laisser une notification s\'afficher d\'abord, ou enchaîner des actions. La valeur par défaut 0 signifie démarrer immédiatement.';

  @override
  String get skapiBasicPrerunRemove => 'Supprimer le délai';

  @override
  String get skapiBasicListAddPlaceholder => '+ ajouter';

  @override
  String get skapiRunSheetTitle => 'Exécuter le script';

  @override
  String get skapiRunSheetStatusRunning => 'En cours';

  @override
  String get skapiRunSheetStatusOk => 'Terminé';

  @override
  String get skapiRunSheetStatusError => 'Échec';

  @override
  String skapiRunSheetExitCode(int code) {
    return 'Code de sortie : $code';
  }

  @override
  String get skapiRunSheetCancel => 'Annuler';

  @override
  String get skapiRunSheetClose => 'Fermer';

  @override
  String get skapiRunSheetCopyOutput => 'Copier la sortie';

  @override
  String get skapiRunSheetCopiedDone => 'Copié';

  @override
  String get skapiRunSheetEmptyOutput => 'En attente de la sortie...';

  @override
  String get skapiRunSheetDismissConfirmTitle =>
      'Arrêter l\'exécution du script ?';

  @override
  String get skapiRunSheetDismissConfirmBody =>
      'Le script est toujours en cours. Fermer cette feuille l\'annulera.';

  @override
  String get skapiRunSheetDismissConfirmStay => 'Continuer l\'exécution';

  @override
  String get skapiRunSheetDismissConfirmStop => 'Annuler';

  @override
  String get skapiRunErrorPowerShellMissing =>
      'PowerShell est introuvable sur ce système.';

  @override
  String skapiRunErrorTempWrite(String error) {
    return 'Impossible d\'\'écrire le script dans le dossier temporaire : $error';
  }

  @override
  String skapiRunErrorSpawn(String error) {
    return 'Impossible de démarrer PowerShell : $error';
  }

  @override
  String skapiRunDurationMs(int ms) {
    return 'A pris $ms ms';
  }

  @override
  String get skapiCopiedToClipboard => 'Copié';

  @override
  String get skapiFavouriteAddTooltip => 'Ajouter aux favoris';

  @override
  String get skapiFavouriteRemoveTooltip => 'Retirer des favoris';

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
  String get skapiPlatformScreenCategoriesTitle => 'Catégories d\'actions';

  @override
  String skapiPlatformScreenCategoriesSub(int groups, int scripts) {
    return '$groups groupes · $scripts scripts au total';
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
  String get skapiGroupPowerTitle => 'Gestion de l\'alimentation';

  @override
  String get skapiGroupPowerDesc =>
      'Les scripts de ce groupe verrouillent, mettent en veille, en veille prolongée ou éteignent l\'ordinateur. Ils sont utiles lorsqu\'un appareil SmartKraft signale la fin d\'une session de concentration ou détecte une longue inactivité et que vous voulez que la machine suive.';

  @override
  String get skapiGroupPowerFoot =>
      'Usage typique : verrouiller quand vous vous levez, mettre en veille prolongée en fin de journée, extinction programmée après une longue période d\'inactivité.';

  @override
  String get skapiScriptLockTitle => 'Verrouiller le poste';

  @override
  String get skapiScriptLockSummaryWhat =>
      'Verrouille Windows immédiatement et revient à l\'écran de connexion. Les applications ouvertes continuent de tourner.';

  @override
  String get skapiScriptLockSummaryHow =>
      'Appelle la fonction Win32 LockWorkStation de user32. Équivaut à appuyer sur Win+L.';

  @override
  String get skapiScriptHibernateTitle => 'Veille prolongée';

  @override
  String get skapiScriptHibernateSummaryWhat =>
      'Enregistre la session en cours sur le disque et éteint la machine. À la reprise, vous retrouvez où vous en étiez, même sans batterie.';

  @override
  String get skapiScriptHibernateSummaryHow =>
      'Exécute le shutdown.exe intégré avec l\'option /h. La veille prolongée doit être activée dans les paramètres d\'alimentation de Windows ; sinon, Windows bascule en veille.';

  @override
  String get skapiScriptHibernateNote =>
      'Exécutez powercfg /hibernate on une fois depuis une invite admin si la veille prolongée manque sur votre système.';

  @override
  String get skapiScriptHibernateParamDelayLabel => 'délai';

  @override
  String get skapiScriptHibernateParamDelayHint =>
      'Secondes à attendre avant la mise en veille prolongée, au cas où la notification de l\'appareil doit s\'afficher d\'abord.';

  @override
  String get skapiScriptSleepTitle => 'Veille';

  @override
  String get skapiScriptSleepSummaryWhat =>
      'Suspend la machine en mémoire (S3). La reprise est rapide mais consomme un peu de batterie pendant la suspension.';

  @override
  String get skapiScriptSleepSummaryHow =>
      'Appelle System.Windows.Forms.Application.SetSuspendState avec PowerState.Suspend. Le système peut retarder si un processus de premier plan bloque les transitions vers l\'inactivité.';

  @override
  String get skapiScriptSleepParamDelayLabel => 'délai';

  @override
  String get skapiScriptSleepParamDelayHint =>
      'Secondes à attendre avant la mise en veille.';

  @override
  String get skapiScriptShutdownTitle => 'Arrêt';

  @override
  String get skapiScriptShutdownSummaryWhat =>
      'Lance un arrêt propre de Windows. Les applications ouvertes sont invitées à enregistrer et fermer.';

  @override
  String get skapiScriptShutdownSummaryHow =>
      'Exécute le shutdown.exe /s intégré. Avec l\'option forcer activée, /f est ajouté pour que les applications qui ne répondent pas soient terminées.';

  @override
  String get skapiScriptShutdownNote =>
      'Un délai non nul laisse à l\'utilisateur le temps d\'annuler via shutdown /a depuis un terminal.';

  @override
  String get skapiScriptShutdownParamDelayLabel => 'délai';

  @override
  String get skapiScriptShutdownParamDelayHint =>
      'Secondes que Windows attend avant l\'extinction. 30 est la valeur par défaut ; choisissez 0 pour un arrêt immédiat.';

  @override
  String get skapiScriptShutdownParamForceLabel => 'forcer';

  @override
  String get skapiScriptShutdownParamForceHint =>
      'Ferme les applications qui ne répondent pas au signal d\'arrêt. Le travail non enregistré de ces applications peut être perdu.';

  @override
  String get skapiGroupDisplayAudioTitle => 'Affichage, image et son';

  @override
  String get skapiGroupDisplayAudioDesc =>
      'Les scripts de ce groupe règlent l\'écran et la sortie audio : luminosité, volume, sourdine et lecture multimédia. Ils sont utiles lorsqu\'un appareil SmartKraft veut que l\'ordinateur baisse la luminosité pendant une pause de concentration ou mette la musique en pause quand vous vous levez.';

  @override
  String get skapiGroupDisplayAudioFoot =>
      'Usage typique : baisser la luminosité pendant une pause, couper le son au verrouillage, mettre Spotify en pause quand un appareil ne détecte aucune activité.';

  @override
  String get skapiScriptBrightnessTitle => 'Régler la luminosité';

  @override
  String get skapiScriptBrightnessSummaryWhat =>
      'Règle la luminosité de l\'écran interne à un pourcentage entre 0 et 100.';

  @override
  String get skapiScriptBrightnessSummaryHow =>
      'Appelle WmiMonitorBrightnessMethods.WmiSetBrightness via WMI au niveau demandé. Seuls les ordinateurs portables, tablettes et écrans intégrés répondent ; les moniteurs externes DDC/CI ne sont pas pris en charge par cette voie.';

  @override
  String get skapiScriptBrightnessNote =>
      'Les moniteurs externes ne changeront pas. Pour les configurations multi-écrans, seul le panneau qui rapporte sa luminosité via WMI réagit.';

  @override
  String get skapiScriptBrightnessParamLevelLabel => 'niveau';

  @override
  String get skapiScriptBrightnessParamLevelHint =>
      'Pourcentage de luminosité (0-100). Les valeurs basses sont plus sombres. 70 est une valeur par défaut confortable en éclairage normal.';

  @override
  String get skapiScriptBrightnessParamTimeoutLabel => 'délai';

  @override
  String get skapiScriptBrightnessParamTimeoutHint =>
      'Secondes accordées au changement de luminosité. Le système monte en douceur dans cette fenêtre.';

  @override
  String get skapiScriptMuteToggleTitle => 'Basculer la sourdine';

  @override
  String get skapiScriptMuteToggleSummaryWhat =>
      'Bascule la sourdine principale du système. Les médias en cours continuent de jouer mais vous ne les entendez pas.';

  @override
  String get skapiScriptMuteToggleSummaryHow =>
      'Envoie la touche virtuelle VK_VOLUME_MUTE, la même voie que Windows utilise lorsque l\'utilisateur appuie sur la touche sourdine d\'un clavier. Aucune dépendance admin ou COM.';

  @override
  String get skapiScriptMuteToggleParamModeLabel => 'mode';

  @override
  String get skapiScriptMuteToggleParamModeHint =>
      'toggle / on / off. Seul toggle est appliqué via la frappe simple ; on et off sont acceptés pour la compatibilité future.';

  @override
  String get skapiScriptVolumeSetTitle => 'Régler le volume';

  @override
  String get skapiScriptVolumeSetSummaryWhat =>
      'Règle le volume principal du système à un niveau précis entre 0 et 100.';

  @override
  String get skapiScriptVolumeSetSummaryHow =>
      'Appelle IAudioEndpointVolume.SetMasterVolumeLevelScalar de Core Audio via interop COM C# en ligne. Cible l\'endpoint de rendu par défaut.';

  @override
  String get skapiScriptVolumeSetNote =>
      'Niveau 2 : fonctionne sur les postes Windows 10/11 standard. Les installations allégées peuvent ne pas exposer l\'interface COM ; les endpoints par application ne sont pas pris en charge par cette voie.';

  @override
  String get skapiScriptVolumeSetParamLevelLabel => 'niveau';

  @override
  String get skapiScriptVolumeSetParamLevelHint =>
      'Pourcentage de volume (0-100). 0 met en silence sans activer la sourdine ; 50 est une valeur par défaut confortable.';

  @override
  String get skapiScriptMediaKeyTitle => 'Touche multimédia';

  @override
  String get skapiScriptMediaKeySummaryWhat =>
      'Simule une pression de touche multimédia : lecture-pause, suivant, précédent ou stop. Va à l\'application qui possède actuellement la session multimédia.';

  @override
  String get skapiScriptMediaKeySummaryHow =>
      'Envoie VK_MEDIA_PLAY_PAUSE / VK_MEDIA_NEXT_TRACK / VK_MEDIA_PREV_TRACK / VK_MEDIA_STOP via keybd_event. Windows route la pression via les System Media Transport Controls.';

  @override
  String get skapiScriptMediaKeyNote =>
      'Niveau 2 : nécessite une session multimédia active. Si aucune application ne joue ou si l\'application de premier plan ne s\'enregistre pas auprès des SMTC, la pression est silencieusement ignorée.';

  @override
  String get skapiScriptMediaKeyParamKeyLabel => 'touche';

  @override
  String get skapiScriptMediaKeyParamKeyHint =>
      'play-pause / next / previous / stop. La valeur par défaut est play-pause.';

  @override
  String get skapiGroupWindowAppTitle => 'Fenêtre et application';

  @override
  String get skapiGroupWindowAppDesc =>
      'Les scripts de ce groupe contrôlent les fenêtres et les applications : réduire, mettre au premier plan, fermer proprement ou tuer des processus directement. Ils gardent votre espace de travail rangé lorsqu\'un appareil SmartKraft veut que l\'ordinateur change de contexte.';

  @override
  String get skapiGroupWindowAppFoot =>
      'Usage typique : tout réduire quand une session de concentration commence, fermer le navigateur quand le travail est fini, tuer une application bloquée à la demande.';

  @override
  String get skapiScriptMinimizeWindowTitle => 'Réduire la fenêtre';

  @override
  String get skapiScriptMinimizeWindowSummaryWhat =>
      'Réduit une fenêtre spécifique par nom de processus. Un nom de processus vide cible la fenêtre actuellement au premier plan.';

  @override
  String get skapiScriptMinimizeWindowSummaryHow =>
      'Résout la première fenêtre principale correspondante via Get-Process et appelle ShowWindow de user32 avec SW_MINIMIZE.';

  @override
  String get skapiScriptMinimizeWindowNote =>
      'Si plusieurs instances tournent, seule la première fenêtre correspondante est réduite. Utilisez le nom de processus sans le suffixe .exe.';

  @override
  String get skapiScriptMinimizeWindowParamProcessLabel => 'processName';

  @override
  String get skapiScriptMinimizeWindowParamProcessHint =>
      'Nom de processus sans .exe (chrome, code, winword). Vide cible la fenêtre de premier plan.';

  @override
  String get skapiScriptCloseWindowTitle => 'Fermer la fenêtre';

  @override
  String get skapiScriptCloseWindowSummaryWhat =>
      'Envoie une fermeture propre à une fenêtre pour que l\'application puisse afficher son propre dialogue « enregistrer les modifications ? ».';

  @override
  String get skapiScriptCloseWindowSummaryHow =>
      'Publie WM_CLOSE via SendMessage de user32. Même effet que l\'utilisateur cliquant sur le bouton X. Un nom de processus vide cible la fenêtre de premier plan.';

  @override
  String get skapiScriptCloseWindowNote =>
      'Les applications avec du travail non enregistré ouvriront leur propre dialogue. Le script n\'attend pas et ne termine pas les applications bloquées.';

  @override
  String get skapiScriptCloseWindowParamProcessLabel => 'processName';

  @override
  String get skapiScriptCloseWindowParamProcessHint =>
      'Nom de processus sans .exe. Vide cible la fenêtre de premier plan.';

  @override
  String get skapiScriptKillAppTitle => 'Forcer la fermeture de l\'application';

  @override
  String get skapiScriptKillAppSummaryWhat =>
      'Termine chaque instance d\'un processus. Essaie d\'abord WM_CLOSE, puis TerminateProcess si l\'application est toujours active après le délai.';

  @override
  String get skapiScriptKillAppSummaryHow =>
      'Envoie WM_CLOSE à chaque fenêtre principale, attend le délai configuré, puis lance Stop-Process avec -Force sur tout ce qui tourne encore.';

  @override
  String get skapiScriptKillAppNote =>
      'Le travail non enregistré des applications qui ne répondent pas sera perdu à la fermeture forcée. Utilisez preKillSave pour les applications de type éditeur qui répondent à Ctrl+S.';

  @override
  String get skapiScriptKillAppParamProcessLabel => 'processName';

  @override
  String get skapiScriptKillAppParamProcessHint =>
      'Nom de processus sans .exe. Toutes les instances en cours sont terminées.';

  @override
  String get skapiScriptKillAppParamTimeoutLabel => 'délai';

  @override
  String get skapiScriptKillAppParamTimeoutHint =>
      'Secondes à attendre entre WM_CLOSE et la fermeture forcée. Des valeurs plus élevées laissent plus de temps à l\'application pour enregistrer.';

  @override
  String get skapiScriptKillAppParamPreKillSaveLabel => 'preKillSave';

  @override
  String get skapiScriptKillAppParamPreKillSaveHint =>
      'Envoie Ctrl+S à la fenêtre de premier plan avant de fermer. Utile pour les éditeurs mais sans effet sur les applications qui ignorent Ctrl+S.';

  @override
  String get skapiScriptLaunchAppTitle => 'Lancer une application';

  @override
  String get skapiScriptLaunchAppSummaryWhat =>
      'Démarre un exécutable, ouvre une URL ou lance un document avec le gestionnaire par défaut.';

  @override
  String get skapiScriptLaunchAppSummaryHow =>
      'Appelle Start-Process de PowerShell avec le chemin et une liste d\'arguments optionnelle. Le chemin peut être un .exe, un chemin de fichier complet ou une URL.';

  @override
  String get skapiScriptLaunchAppNote =>
      'Les chemins avec espaces sont acceptés. Utilisez une URL comme https://example.com pour ouvrir le navigateur par défaut.';

  @override
  String get skapiScriptLaunchAppParamPathLabel => 'path';

  @override
  String get skapiScriptLaunchAppParamPathHint =>
      'Exécutable, chemin de fichier complet ou URL. notepad / C:\\\\tools\\\\my.exe / https://example.com.';

  @override
  String get skapiScriptLaunchAppParamArgsLabel => 'args';

  @override
  String get skapiScriptLaunchAppParamArgsHint =>
      'Arguments passés à l\'exécutable. Vide pour aucun.';

  @override
  String get skappListenerCardTitle => 'Écouteur HTTP SKAPP';

  @override
  String skappListenerCardSubtitleRunning(int port) {
    return 'En cours sur le port $port';
  }

  @override
  String get skappListenerCardSubtitleStopped => 'Arrêté';

  @override
  String get skappListenerCardSubtitleUnsupported =>
      'Cette plateforme ne peut pas héberger l\'écouteur.';

  @override
  String get skappListenerCardEnableSwitch => 'Activer l\'écouteur';

  @override
  String get skappListenerCardSecurityNote =>
      'L\'écouteur n\'accepte les connexions que sur votre réseau local et exige le jeton Bearer. HTTP en clair, ne l\'exposez pas à l\'Internet public.';

  @override
  String get settingsLanVisibleTitle => 'Visible sur le LAN';

  @override
  String get settingsLanVisibleSubtitle =>
      'Quand désactivé, l\'écouteur ne se lie qu\'à localhost. Les appareils BF jumelés ne peuvent pas atteindre ce poste.';

  @override
  String get settingsLanVisibleWarnBfBreaks =>
      'Désactiver ceci rompt la chaîne de webhook BF. À utiliser uniquement dans un environnement de confiance ou de test.';

  @override
  String get settingsLanVisibleAutoReopenedSnack =>
      'La visibilité sur le LAN a été réactivée pour que les appareils BF puissent atteindre ce poste.';

  @override
  String get skapiRunRemoteDeveloperModeDisabled =>
      'Le bureau cible a le mode développeur désactivé, l\'exécution de scripts à distance y est donc coupée.';

  @override
  String get skappPeerPairingManualUuidConfirmLabel =>
      'Code de confirmation (4 derniers de l\'UUID)';

  @override
  String get skappPeerPairingManualUuidConfirmHint =>
      'Lisez le code de 4 caractères affiché sur l\'écran de jumelage du bureau.';

  @override
  String get skappPeerPairingManualUuidConfirmError =>
      'Le code ne correspond pas aux 4 derniers de l\'UUID. Vérifiez l\'écran du bureau.';

  @override
  String get skappListenerCardUuidLast4Label =>
      'Code de confirmation du jumelage';

  @override
  String get skappListenerCardUuidLast4Hint =>
      'Saisissez ces 4 caractères sur l\'écran de jumelage manuel du téléphone.';

  @override
  String get settingsPeerTokensTitle => 'Jetons de pairs émis';

  @override
  String get settingsPeerTokensSubtitle =>
      'Pairs mobiles jumelés avec ce bureau. Révoquez une entrée pour la déconnecter sans affecter les autres.';

  @override
  String get settingsPeerTokensEmpty => 'Aucun pair jumelé pour l\'instant.';

  @override
  String settingsPeerTokensIssuedAt(String when) {
    return 'Jumelé $when';
  }

  @override
  String settingsPeerTokensLastUsed(String when) {
    return 'Dernière utilisation $when';
  }

  @override
  String get settingsPeerTokensRevokeButton => 'Révoquer';

  @override
  String get settingsPeerTokensRevokeConfirmTitle => 'Révoquer ce pair ?';

  @override
  String get settingsPeerTokensRevokeConfirmBody =>
      'Le pair sera déconnecté immédiatement et devra se jumeler à nouveau pour atteindre ce bureau.';

  @override
  String get settingsPeerTokensRevokeConfirmCancel => 'Annuler';

  @override
  String get settingsPeerTokensRevokeConfirmAction => 'Révoquer';

  @override
  String settingsPeerTokensRevokedToast(String name) {
    return 'Pair $name révoqué';
  }

  @override
  String get skappListenerCardRotateCertButton =>
      'Renouveler le certificat TLS';

  @override
  String get skappListenerCardRotateCertConfirmTitle =>
      'Renouveler le certificat ?';

  @override
  String get skappListenerCardRotateCertConfirmBody =>
      'Un nouveau certificat TLS auto-signé sera généré. Chaque pair précédemment jumelé échouera à la poignée de main jusqu\'à un nouveau jumelage.';

  @override
  String get skappListenerCardRotateCertConfirmCancel => 'Annuler';

  @override
  String get skappListenerCardRotateCertConfirmAction => 'Renouveler';

  @override
  String get skappListenerCardRotateCertDoneSnack =>
      'Certificat TLS renouvelé. Jumelez à nouveau chaque appareil.';

  @override
  String get skappListenerCardCertFingerprintLabel => 'Empreinte TLS';

  @override
  String skappListenerCardErrorPortInUse(int port) {
    return 'Le port $port est déjà utilisé. Choisissez un autre port dans Identité réseau.';
  }

  @override
  String skappListenerCardErrorGeneric(String error) {
    return 'Impossible de démarrer l\'\'écouteur : $error';
  }

  @override
  String get skappPeerPairingTitle => 'Jumeler un SKAPP de bureau';

  @override
  String get skappPeerPairingSubtitle =>
      'Scannez le QR affiché dans les Paramètres du SKAPP de bureau, ou collez le code de jumelage manuellement.';

  @override
  String get skappPeerPairingTabScan => 'Scanner le QR';

  @override
  String get skappPeerPairingTabManual => 'Manuel';

  @override
  String get skappPeerPairingScanHint =>
      'Pointez votre caméra sur le QR affiché dans SKAPP de bureau > Paramètres > Écouteur HTTP SKAPP.';

  @override
  String get skappPeerPairingScanCameraDeniedTitle =>
      'Autorisation caméra requise';

  @override
  String get skappPeerPairingScanCameraDeniedBody =>
      'Autorisez l\'accès à la caméra depuis les paramètres de votre téléphone pour scanner le QR de jumelage. Vous pouvez aussi saisir le code manuellement.';

  @override
  String get skappPeerPairingManualHostLabel => 'IP ou nom d\'hôte du bureau';

  @override
  String get skappPeerPairingManualPortLabel => 'Port';

  @override
  String get skappPeerPairingManualTokenLabel => 'Jeton Bearer';

  @override
  String get skappPeerPairingManualUuidLabel => 'UUID du bureau';

  @override
  String get skappPeerPairingManualNameLabel => 'Nom d\'affichage';

  @override
  String get skappPeerPairingManualSubmit => 'Jumeler';

  @override
  String skappPeerPairingSavedToast(String name) {
    return 'Jumelé avec $name';
  }

  @override
  String skappPeerPairingFailedToast(String reason) {
    return 'Échec du jumelage : $reason';
  }

  @override
  String get skappPeerPairingShowQrTitle =>
      'Jumeler un téléphone avec ce bureau';

  @override
  String get skappPeerPairingShowQrBody =>
      'Ouvrez SKAPP sur votre téléphone, allez dans SKAPI > Paramètres > Jumeler un bureau, et scannez ce QR. Le QR contient le jeton Bearer, traitez-le comme un mot de passe.';

  @override
  String get skappPeerPairingShowQrCloseButton => 'Terminé';

  @override
  String get skappPeerListEmpty =>
      'Aucun bureau jumelé pour l\'instant. Jumelez-en un pour exécuter des scripts depuis ce téléphone.';

  @override
  String get skappPeerListSectionTitle => 'SKAPP de bureau jumelés';

  @override
  String get skappPeerStatusOnline => 'En ligne';

  @override
  String get skappPeerStatusOffline => 'Hors ligne';

  @override
  String skappPeerStatusLastSeen(String when) {
    return 'Vu pour la dernière fois $when';
  }

  @override
  String get skappPeerRemoveTooltip => 'Supprimer le bureau jumelé';

  @override
  String get skappPeerRemoveConfirmTitle => 'Supprimer le jumelage ?';

  @override
  String skappPeerRemoveConfirmBody(String name) {
    return 'Les scripts déclenchés depuis ce téléphone ne s\'\'exécuteront plus sur $name jusqu\'\'à un nouveau jumelage.';
  }

  @override
  String get skappPeerScanRefreshTooltip => 'Actualiser la liste des pairs';

  @override
  String skapiRunRemoteSheetTitle(String peerName) {
    return 'Exécuter à distance sur $peerName';
  }

  @override
  String get skapiRunRemoteConnecting => 'Connexion au bureau...';

  @override
  String get skapiRunRemoteOfflineError =>
      'Le bureau jumelé est hors ligne. Essayez d\'actualiser les pairs ou vérifiez l\'écouteur du bureau.';

  @override
  String get skapiRunRemoteUnauthorizedError =>
      'Jeton Bearer rejeté. Le jeton du bureau a peut-être été renouvelé. Jumelez à nouveau depuis les Paramètres.';

  @override
  String skapiRunRemoteHttpError(String reason) {
    return 'Échec de l\'\'exécution à distance : $reason';
  }

  @override
  String get skapiRunMobileNoPeerTitle => 'Aucun bureau jumelé';

  @override
  String get skapiRunMobileNoPeerBody =>
      'Jumelez un SKAPP de bureau depuis les Paramètres pour exécuter des scripts depuis ce téléphone.';

  @override
  String get skapiRunMobileNoPeerCta => 'Ouvrir les paramètres';

  @override
  String get skapiRunRemoteNotWhitelisted =>
      'Ce script n\'est pas marqué comme exécutable à distance. Exécutez-le directement sur le bureau.';

  @override
  String get skapiRunRemoteNoPeerHint =>
      'Jumelez un SKAPP de bureau depuis les Paramètres pour exécuter des scripts depuis ce téléphone.';

  @override
  String get skapiRunRemoteNoPeerAction => 'Ouvrir les paramètres';

  @override
  String get skappPeerPickerTitle => 'Envoyer vers quel ordinateur ?';

  @override
  String get skappPeerPickerSubtitle =>
      'Choisissez le SKAPP de bureau jumelé qui doit exécuter ce script.';

  @override
  String get skappPeerPickerOfflineReason => 'Hors ligne';

  @override
  String get skappPeerPickerDevModeOffReason =>
      'Le mode développeur est désactivé';

  @override
  String get skappPeerPickerEmpty => 'Aucun bureau jumelé à choisir.';

  @override
  String get skapiRunRemoteCancelButton => 'Annuler';

  @override
  String get skapiRunRemoteCancelledNote => 'Exécution annulée';

  @override
  String skapiRunRemoteTooManyRuns(int running, int limit) {
    return 'Ce bureau exécute déjà $running scripts ($limit max). Attendez qu\'\'un se termine.';
  }

  @override
  String get skappPeerHealthDevModeBadge => 'Mode dev';

  @override
  String get remoteRunActivityCardTitle => 'Exécutions à distance';

  @override
  String get remoteRunActivityCardSubtitle =>
      'Exécutions de scripts récentes que des pairs mobiles jumelés ont demandé à ce bureau d\'effectuer.';

  @override
  String get remoteRunActivityCardEmpty =>
      'Aucune exécution à distance pour l\'instant.';

  @override
  String get remoteRunActivityCardClear => 'Effacer l\'historique';

  @override
  String remoteRunActivityRowOk(int exitCode, int durationMs) {
    return 'sortie $exitCode · $durationMs ms';
  }

  @override
  String get remoteRunActivityRowCancelled => 'annulé';

  @override
  String remoteRunActivityRowRejected(String reason) {
    return 'rejeté · $reason';
  }

  @override
  String get mobileTriggerCardTitle => 'Déclencheur';

  @override
  String get mobileTriggerCardSubtitle =>
      'Envoyez un événement de tape à un SKAPP de bureau jumelé. Toute liaison à l\'écoute de cet événement exécutera son script sur ce bureau.';

  @override
  String get mobileTriggerCardSendButton => 'Envoyer une tape';

  @override
  String get mobileTriggerCardSending => 'Envoi...';

  @override
  String mobileTriggerSentToast(String name) {
    return 'Tape envoyée à $name';
  }

  @override
  String get skapiBindEventMobileTap => 'Tape mobile';

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
  String get msHomeScreenTitle => 'Pair mobile';

  @override
  String get msHomeScreenNotFound => 'Ce pair mobile n\'est plus jumelé.';

  @override
  String get msHomeScreenEventsHeader => 'Événements disponibles';

  @override
  String msHomeScreenBindingsHeader(int count) {
    return 'Liaisons ($count)';
  }

  @override
  String get msHomeScreenBindingsEmpty =>
      'Aucune liaison pour l\'instant. Utilisez SKAPI → script → Lier à une action pour relier un événement de tape à un script.';

  @override
  String get msHomeScreenHint =>
      'Les téléphones n\'exécutent pas de scripts. Ils émettent des événements de déclenchement que ce bureau lie à des scripts.';

  @override
  String msHomeScreenPairedAt(String date) {
    return 'Jumelé $date';
  }

  @override
  String get skapiGroupNotifyTitle => 'Notification et dialogue';

  @override
  String get skapiGroupNotifyDesc =>
      'Les scripts de ce groupe s\'adressent directement à l\'utilisateur : afficher un toast, montrer une boîte de dialogue modale, ou attendre une réponse oui/non. Utilisez-les quand l\'événement d\'un appareil SmartKraft nécessite que la personne devant l\'écran confirme ou décide.';

  @override
  String get skapiGroupNotifyFoot =>
      'Usage typique : dialogue avant une action destructrice, toast pour un rappel léger, dialogue avec délai pour basculer automatiquement.';

  @override
  String get skapiScriptDialogTitle => 'Afficher un dialogue';

  @override
  String get skapiScriptDialogSummaryWhat =>
      'Affiche une MessageBox Windows modale et renvoie le choix de l\'utilisateur (ok / cancel / yes / no / timeout).';

  @override
  String get skapiScriptDialogSummaryHow =>
      'Appelle System.Windows.Forms.MessageBox sur un runspace enfant pour que le script puisse mettre le dialogue en concurrence avec un délai optionnel. La valeur choisie est écrite sur la sortie standard pour que l\'appelant puisse brancher dessus.';

  @override
  String get skapiScriptDialogNote =>
      'La sortie standard est la réponse de l\'utilisateur en minuscules. timeout=0 attend indéfiniment.';

  @override
  String get skapiScriptDialogParamTitleLabel => 'title';

  @override
  String get skapiScriptDialogParamTitleHint =>
      'Titre de la fenêtre affiché dans la boîte de message.';

  @override
  String get skapiScriptDialogParamBodyLabel => 'body';

  @override
  String get skapiScriptDialogParamBodyHint =>
      'La question ou le message affiché à l\'utilisateur.';

  @override
  String get skapiScriptDialogParamButtonsLabel => 'buttons';

  @override
  String get skapiScriptDialogParamButtonsHint =>
      'ok / ok_cancel / yes_no / yes_no_cancel. Par défaut ok_cancel.';

  @override
  String get skapiScriptDialogParamTimeoutLabel => 'timeout';

  @override
  String get skapiScriptDialogParamTimeoutHint =>
      'Secondes à attendre avant de basculer sur « timeout ». 0 signifie attendre indéfiniment.';

  @override
  String get skapiScriptToastTitle => 'Afficher un toast';

  @override
  String get skapiScriptToastSummaryWhat =>
      'Affiche une notification toast Windows avec un titre et un corps. Glisse depuis le coin inférieur droit et atterrit dans le centre de notifications.';

  @override
  String get skapiScriptToastSummaryHow =>
      'Construit une charge utile XML ToastNotification et la transmet au WinRT ToastNotificationManager sous l\'AppUserModelID configuré.';

  @override
  String get skapiScriptToastNote =>
      'Niveau 2 : nécessite Windows 10+ et un AppUserModelID enregistré pour la meilleure expérience. L\'AUMID par défaut place le toast sous PowerShell dans le centre de notifications.';

  @override
  String get skapiScriptToastParamTitleLabel => 'title';

  @override
  String get skapiScriptToastParamTitleHint =>
      'Première ligne en gras du toast.';

  @override
  String get skapiScriptToastParamBodyLabel => 'body';

  @override
  String get skapiScriptToastParamBodyHint =>
      'Deuxième ligne plus petite. Optionnel.';

  @override
  String get skapiScriptToastParamAumidLabel => 'aumid';

  @override
  String get skapiScriptToastParamAumidHint =>
      'App User Model ID sous lequel le toast apparaît. Par défaut, revient à PowerShell.';

  @override
  String get skapiGroupVisualBreakTitle => 'Pause visuelle';

  @override
  String get skapiGroupVisualBreakDesc =>
      'Des repères visuels doux qui éloignent l\'utilisateur d\'un travail intense : baisser la luminosité, passer en niveaux de gris, retrouver le curseur ou afficher le bureau. Les effets de ce groupe sont réversibles et ne bloquent jamais durement les entrées.';

  @override
  String get skapiGroupVisualBreakFoot =>
      'Usage typique : baisser la luminosité au début d\'une pause de concentration, mode niveaux de gris pour les lectures nocturnes, retrouver la souris sur les configurations multi-écrans.';

  @override
  String get skapiScriptShowDesktopTitle => 'Afficher le bureau';

  @override
  String get skapiScriptShowDesktopSummaryWhat =>
      'Bascule « afficher le bureau ». Comme appuyer deux fois de suite sur Win+D.';

  @override
  String get skapiScriptShowDesktopSummaryHow =>
      'Appelle Shell.Application.ToggleDesktop via COM. Le relancer restaure la disposition précédente des fenêtres.';

  @override
  String get skapiScriptFadeScreenTitle => 'Fondu de l\'écran';

  @override
  String get skapiScriptFadeScreenSummaryWhat =>
      'Fait passer en fondu la luminosité de l\'écran interne de son niveau actuel à un niveau cible en quelques secondes.';

  @override
  String get skapiScriptFadeScreenSummaryHow =>
      'Lit la luminosité actuelle via WMI WmiMonitorBrightness, puis fait varier WmiSetBrightness par incréments linéaires vers la cible pour que le changement paraisse fluide.';

  @override
  String get skapiScriptFadeScreenNote =>
      'Niveau 2 : la luminosité WMI ne fonctionne que sur les panneaux internes. Les moniteurs externes ne répondent pas sur cette voie.';

  @override
  String get skapiScriptFadeScreenParamTargetLabel => 'target';

  @override
  String get skapiScriptFadeScreenParamTargetHint =>
      'Pourcentage de luminosité final (0-100).';

  @override
  String get skapiScriptFadeScreenParamDurationLabel => 'duration';

  @override
  String get skapiScriptFadeScreenParamDurationHint =>
      'Secondes que le fondu doit prendre. Le script utilise dix paliers de luminosité par seconde.';

  @override
  String get skapiScriptGrayscaleTitle => 'Filtre niveaux de gris';

  @override
  String get skapiScriptGrayscaleSummaryWhat =>
      'Active ou désactive le mode niveaux de gris des filtres de couleur de Windows.';

  @override
  String get skapiScriptGrayscaleSummaryHow =>
      'Écrit les clés de registre ColorFiltering, puis envoie Win+Ctrl+C pour que Windows applique le changement en direct sans déconnexion.';

  @override
  String get skapiScriptGrayscaleNote =>
      'Niveau 2 : nécessite que Paramètres > Accessibilité > Filtres de couleur > « Autoriser la touche de raccourci » soit activé pour que la bascule en direct fonctionne.';

  @override
  String get skapiScriptGrayscaleParamOnLabel => 'on';

  @override
  String get skapiScriptGrayscaleParamOnHint =>
      'true pour activer les niveaux de gris, false pour les désactiver.';

  @override
  String get skapiScriptGrayscaleParamDurationLabel => 'duration';

  @override
  String get skapiScriptGrayscaleParamDurationHint =>
      '0 signifie simplement basculer. >0 rétablit automatiquement la couleur après le nombre de secondes donné. Idéal pour les pauses visuelles.';

  @override
  String get skapiScriptFindMouseShakeTitle => 'Retrouver la souris';

  @override
  String get skapiScriptFindMouseShakeSummaryWhat =>
      'Fait tourner le curseur en petit cercle pour attirer l\'œil sur sa position. Le curseur revient à son point de départ à la fin de l\'animation.';

  @override
  String get skapiScriptFindMouseShakeSummaryHow =>
      'Lit la position actuelle du curseur avec GetCursorPos, puis boucle SetCursorPos autour d\'un cercle du rayon configuré. Utile sur les configurations multi-écrans et 4K.';

  @override
  String get skapiScriptFindMouseShakeNote =>
      'Niveau 2 : SetCursorPos peut être bloqué par un logiciel d\'accessibilité, et le comportement varie sous les sessions de bureau à distance.';

  @override
  String get skapiScriptFindMouseShakeParamRadiusLabel => 'radius';

  @override
  String get skapiScriptFindMouseShakeParamRadiusHint =>
      'Pixels que le curseur parcourt depuis son origine pendant la boucle. Plus grand est plus visible.';

  @override
  String get skapiScriptFindMouseShakeParamLoopsLabel => 'loops';

  @override
  String get skapiScriptFindMouseShakeParamLoopsHint =>
      'Combien de cercles complets dessiner avant de se stabiliser.';

  @override
  String get skapiGroupProgramsTitle => 'Contrôle d\'un programme spécifique';

  @override
  String get skapiGroupProgramsDesc =>
      'Scripts ciblés pour des applications et navigateurs spécifiques : enregistrer+fermer proprement, fermeture multi-instances, nettoyage de tout un navigateur. Pratiques quand un appareil SmartKraft veut clôturer un flux de travail particulier sans détruire tout le bureau.';

  @override
  String get skapiGroupProgramsFoot =>
      'Usage typique : enregistrer et fermer tous les éditeurs avant la veille, fermer chaque navigateur en fin de journée, nettoyage ciblé d\'une seule famille de processus.';

  @override
  String get skapiScriptCloseWithSaveTitle =>
      'Enregistrer et fermer l\'application';

  @override
  String get skapiScriptCloseWithSaveSummaryWhat =>
      'Envoie Ctrl+S à une application cible pour déclencher son propre enregistrement, attend, puis ferme la fenêtre proprement.';

  @override
  String get skapiScriptCloseWithSaveSummaryHow =>
      'Met chaque instance en cours au premier plan, envoie Ctrl+S via SendKeys, attend le délai configuré, puis publie WM_CLOSE pour que l\'application puisse confirmer ou finir l\'enregistrement.';

  @override
  String get skapiScriptCloseWithSaveNote =>
      'Niveau 2 : repose sur l\'interprétation de Ctrl+S comme « enregistrer » par l\'application. Certaines applications de chat / web le traitent différemment. Testez avec les applications que vous ciblez réellement.';

  @override
  String get skapiScriptCloseWithSaveParamProcessLabel => 'processName';

  @override
  String get skapiScriptCloseWithSaveParamProcessHint =>
      'Nom de processus sans .exe (winword, excel, code, photoshop). Toutes les instances en cours sont enregistrées et fermées.';

  @override
  String get skapiScriptCloseWithSaveParamWaitLabel => 'wait';

  @override
  String get skapiScriptCloseWithSaveParamWaitHint =>
      'Secondes à attendre entre Ctrl+S et le signal de fermeture pour que l\'application finisse d\'enregistrer.';

  @override
  String get skapiScriptCloseAllInstancesTitle => 'Fermer toutes les instances';

  @override
  String get skapiScriptCloseAllInstancesSummaryWhat =>
      'Envoie une fermeture propre à chaque fenêtre visible d\'un processus. Chaque instance peut afficher son propre dialogue d\'enregistrement.';

  @override
  String get skapiScriptCloseAllInstancesSummaryHow =>
      'Parcourt les processus correspondants via Get-Process et publie WM_CLOSE à la fenêtre principale de chacun. Pas de repli forcé.';

  @override
  String get skapiScriptCloseAllInstancesParamProcessLabel => 'processName';

  @override
  String get skapiScriptCloseAllInstancesParamProcessHint =>
      'Nom de processus sans .exe. Correspond à toutes les instances.';

  @override
  String get skapiScriptBrowserCloseAllTitle => 'Fermer tous les navigateurs';

  @override
  String get skapiScriptBrowserCloseAllSummaryWhat =>
      'Ferme proprement tous les navigateurs courants en cours (Chrome, Edge, Firefox, Brave, Vivaldi, Opera).';

  @override
  String get skapiScriptBrowserCloseAllSummaryHow =>
      'Parcourt les noms de processus de navigateurs connus et publie WM_CLOSE à chaque fenêtre principale. Les navigateurs modernes préservent la session si « restaurer les onglets au prochain lancement » est activé.';

  @override
  String get skapiScriptBrowserCloseAllNote =>
      'La fermeture forcée n\'est pas utilisée. Pour effacer aussi la session, utilisez plutôt kill-app par navigateur.';

  @override
  String get skapiTierBadgeExperimental => 'Expérimental';

  @override
  String get skapiTierBadgeExperimentalTooltip =>
      'Ce script dépend d\'une API Windows qui peut ne pas être fiable d\'une machine à l\'autre. Testez-le avant de compter dessus.';

  @override
  String get skapiTierBadgeBlocked => 'Bientôt disponible';

  @override
  String get skapiTierBadgeBlockedTooltip =>
      'Ce script fait partie de la bibliothèque prévue mais n\'est pas encore implémenté.';

  @override
  String get skapiGroupSaveWorkTitle => 'Enregistrer le travail';

  @override
  String get skapiGroupSaveWorkDesc =>
      'Les scripts de ce groupe enregistrent votre travail ouvert sur le disque avant une pause ou un arrêt inattendu. Quand votre appareil SmartKraft déclenche une pause, le script choisi enregistre automatiquement votre fichier dans Word, Excel, VS Code ou tout autre éditeur, de sorte que même si votre ordinateur se met en veille, s\'éteint ou exécute une autre commande, votre travail reste protégé.';

  @override
  String get skapiGroupSaveWorkFoot =>
      'Usage typique : enregistrement automatique au début d\'une pause de concentration, sauvegarde de document sur avertissement de batterie faible, ou un déclencheur « tout enregistrer » d\'un seul bouton.';

  @override
  String get skapiScriptSaveActiveWindowTitle =>
      'Enregistrer la fenêtre active';

  @override
  String get skapiScriptSaveActiveWindowSummaryWhat =>
      'Envoie un Ctrl+S virtuel à la fenêtre Windows qui a actuellement le focus, déclenchant le comportement d\'enregistrement propre à cette application.';

  @override
  String get skapiScriptSaveActiveWindowSummaryHow =>
      'Il récupère d\'abord le handle de la fenêtre active et journalise son titre. Puis il envoie Ctrl+S via SendKeys. Word enregistre dans son chemin actuel, VS Code écrit le fichier. Si une boîte « Enregistrer sous » apparaît, il attend que l\'utilisateur confirme manuellement.';

  @override
  String get skapiScriptSaveActiveWindowParamTimeoutLabel => 'timeout';

  @override
  String get skapiScriptSaveActiveWindowParamTimeoutHint =>
      'Secondes à attendre après l\'envoi de la frappe pour que l\'application ait le temps d\'écrire le fichier.';

  @override
  String get skapiScriptSaveActiveWindowParamVerboseLabel => 'verbose';

  @override
  String get skapiScriptSaveAllOpenTitle =>
      'Enregistrer tous les documents ouverts';

  @override
  String get skapiScriptSaveAllOpenSummaryWhat =>
      'Parcourt une liste blanche d\'éditeurs en cours et demande à chacun d\'enregistrer ses documents ouverts.';

  @override
  String get skapiScriptSaveAllOpenSummaryHow =>
      'Pour chaque processus de la liste blanche trouvé, il met la fenêtre principale au premier plan, envoie Ctrl+S, puis attend le délai configuré par application avant de continuer. Les applications qui ne tournent pas sont ignorées silencieusement sauf si le mode verbeux est activé.';

  @override
  String get skapiScriptSaveAllOpenNote =>
      'La liste blanche couvre par défaut Word, Excel, PowerPoint et VS Code. Modifiez le paramètre apps pour ajouter les vôtres.';

  @override
  String get skapiScriptSaveAllOpenParamAppsLabel => 'apps';

  @override
  String get skapiScriptSaveAllOpenParamAppsHint =>
      'Noms de processus (sans .exe) auxquels envoyer l\'enregistrement. L\'ordre compte : les premières entrées sont traitées en premier.';

  @override
  String get skapiScriptSaveAllOpenParamTimeoutLabel => 'timeoutPerApp';

  @override
  String get skapiScriptSaveAllOpenParamVerboseLabel => 'verbose';

  @override
  String get skapiScriptAutosaveTriggerTitle =>
      'Déclencher l\'enregistrement automatique';

  @override
  String get skapiScriptAutosaveTriggerSummaryWhat =>
      'Diffuse une commande d\'enregistrement Windows à chaque fenêtre de premier niveau visible en une seule passe.';

  @override
  String get skapiScriptAutosaveTriggerSummaryHow =>
      'Énumère les fenêtres visibles, puis envoie à chacune un WM_COMMAND avec l\'identifiant d\'enregistrement standard. Les applications qui écoutent ce message réagissent comme si vous aviez cliqué sur l\'élément Enregistrer de leur menu Fichier. Plus rapide qu\'un Ctrl+S par fenêtre, mais quelques applications ignorent la diffusion.';

  @override
  String get skapiScriptAutosaveTriggerNote =>
      'Utilisez ceci quand vous voulez vider tous les éditeurs d\'un coup et que peu importe qu\'un petit nombre d\'applications ne réponde pas. Combinez avec save-all-open pour une couverture plus stricte.';

  @override
  String get skapiScriptAutosaveTriggerParamDelayLabel => 'delay';

  @override
  String get skapiScriptAutosaveTriggerParamDelayHint =>
      'Secondes à attendre avant la diffusion, utile quand vous voulez que la notification de pause de l\'appareil s\'affiche d\'abord.';

  @override
  String get skapiScriptAutosaveTriggerParamVerboseLabel => 'verbose';

  @override
  String get skapiScriptDetailSummaryWhatLabel => 'Ce qu\'il fait :';

  @override
  String get skapiScriptDetailSummaryHowLabel => 'Comment ça marche :';

  @override
  String get skapiScriptDetailOriginalSectionTitle => 'Script original';

  @override
  String get skapiScriptDetailOriginalSectionSub => 'lecture seule · anglais';

  @override
  String get skapiScriptDetailEditingSectionTitle => 'Modifications';

  @override
  String get skapiScriptDetailEditingNotYet =>
      'Aucune modification pour l\'instant';

  @override
  String get skapiScriptDetailEditingNotYetSub =>
      'Créez une copie sur cet appareil sans modifier l\'original.';

  @override
  String get skapiScriptDetailEditingModified => 'Modifié';

  @override
  String skapiScriptDetailEditingModifiedSub(String date) {
    return 'Dernière modification $date.';
  }

  @override
  String get skapiScriptDetailEditingOutdated => 'Bibliothèque mise à jour';

  @override
  String get skapiScriptDetailEditingOutdatedSub =>
      'L\'original a été modifié par une mise à jour de l\'application. Comparez ou réinitialisez.';

  @override
  String get skapiScriptDetailParamWarnTitle =>
      'Vérifiez les paramètres avant d\'exécuter';

  @override
  String get skapiScriptDetailParamWarnHint =>
      'Pour modifier ces valeurs, utilisez « Modifier ». Les paramètres sont définis dans le bloc param() du script.';

  @override
  String get skapiScriptDetailNotesTitle => 'Notes';

  @override
  String get skapiScriptDetailButtonRun => 'Exécuter maintenant';

  @override
  String get skapiScriptDetailButtonBindAction => 'Lier à une action';

  @override
  String get skapiScriptDetailButtonEdit => 'Modifier';

  @override
  String get skapiScriptDetailButtonView => 'Voir';

  @override
  String get skapiScriptDetailButtonReset => 'Réinitialiser';

  @override
  String get skapiScriptDetailButtonCompare => 'Comparer';

  @override
  String get skapiScriptCopyButton => 'Copier';

  @override
  String get skapiScriptCopyButtonDone => 'Copié';

  @override
  String get skapiScriptSelectButton => 'Sélectionner';

  @override
  String get skapiEditorTitle => 'Modifier';

  @override
  String skapiEditorHint(String scriptId) {
    return '$scriptId · Vous modifiez une copie sur cet appareil. La version originale de la bibliothèque est inchangée. « Réinitialiser » restaure toujours l\'\'original.';
  }

  @override
  String get skapiEditorStatusBarTitle => 'POWERSHELL · UTF-8';

  @override
  String get skapiEditorStatusModified => '● Modifié';

  @override
  String get skapiEditorStatusUnmodified => 'Inchangé';

  @override
  String skapiEditorFootCursor(int line, int column) {
    return 'Ligne $line · Colonne $column';
  }

  @override
  String get skapiEditorFootSaveLabel => 'Enregistrer';

  @override
  String skapiEditorDiffLineCount(int count) {
    return '$count ligne modifiée';
  }

  @override
  String skapiEditorDiffLinesCount(int count) {
    return '$count lignes modifiées';
  }

  @override
  String get skapiEditorDiffCompareLink => 'Comparer avec l\'original';

  @override
  String get skapiEditorButtonReset => 'Réinitialiser';

  @override
  String get skapiEditorButtonSave => 'Enregistrer';

  @override
  String get skapiEditorAfterSaveNote =>
      'Après enregistrement, « Exécuter maintenant » lancera la version modifiée.';

  @override
  String get skapiLinuxDistroHeading =>
      'Choisissez votre famille de distribution';

  @override
  String get skapiLinuxDistroSubtitle =>
      'Les scripts Linux divergent entre les familles basées sur Debian (apt, .deb) et basées sur Arch (pacman). Choisissez celle qui correspond à votre machine.';

  @override
  String get skapiLinuxDistroDebianLabel => 'Basé sur Debian';

  @override
  String get skapiLinuxDistroDebianSub =>
      'Debian, Ubuntu, Mint, Pop!_OS, Elementary, Kali, MX, Zorin';

  @override
  String get skapiLinuxDistroArchLabel => 'Basé sur Arch';

  @override
  String get skapiLinuxDistroArchSub =>
      'Arch, Manjaro, EndeavourOS, Garuda (bientôt)';

  @override
  String get skapiNewActionNoDevicesTitle => 'Jumelez d\'abord un appareil';

  @override
  String get skapiNewActionNoDevicesBody =>
      'Créer une action sur l\'appareil nécessite au moins un appareil SmartKraft jumelé (BF pour l\'instant).';

  @override
  String get skapiNewActionNoDevicesCta => 'Ouvrir Appareils';

  @override
  String get skapiNewActionPickDeviceTitle => 'Choisir un appareil';

  @override
  String get skapiNewActionPickDeviceSubtitle =>
      'Sur quel appareil cette action doit-elle résider ?';

  @override
  String get skapiUserNewTitle => 'Nouveau script';

  @override
  String get skapiUserEditTitle => 'Modifier le script';

  @override
  String get skapiUserTitleLabel => 'Titre';

  @override
  String get skapiUserTitleHint => 'ex. Routine du matin';

  @override
  String get skapiUserDescLabel => 'Description';

  @override
  String get skapiUserDescHint => 'Que fait ce script ?';

  @override
  String get skapiUserPlatformLabel => 'Plateforme';

  @override
  String get skapiUserCodeLabel => 'Code';

  @override
  String get skapiUserCodeHint => '# Votre code PowerShell ici';

  @override
  String get skapiUserSaveCta => 'Enregistrer';

  @override
  String get skapiUserValidationEmpty =>
      'Le titre et le code ne peuvent pas être vides.';

  @override
  String get skapiUserSavedSnack => 'Script enregistré';

  @override
  String get skapiUserSectionHeading => 'Mes scripts';

  @override
  String skapiUserSectionSub(int count) {
    return '$count scripts';
  }

  @override
  String get skapiUserEmptyHint =>
      'Aucun script à vous pour l\'instant. Créez-en un avec le bouton Nouvelle action, en haut à droite.';

  @override
  String get skapiUserDetailCodeHeading => 'Code';

  @override
  String get skapiUserEditCta => 'Modifier';

  @override
  String get skapiUserDeleteConfirmTitle => 'Supprimer le script ?';

  @override
  String skapiUserDeleteConfirmBody(String name) {
    return '$name sera définitivement supprimé.';
  }

  @override
  String get skapiUserDeletedSnack => 'Script supprimé';

  @override
  String get skapiUserRunCta => 'Exécuter';

  @override
  String get skapiUserRunUnsupported =>
      'L\'exécution de scripts est réservée au bureau.';

  @override
  String get skapiUserRunOutputTitle => 'Sortie d\'exécution';

  @override
  String skapiUserRunDone(int code) {
    return 'Terminé (sortie $code)';
  }

  @override
  String get skapiLocalScriptsSubheading => 'Scripts locaux';

  @override
  String get skapiOnDeviceApiSubheading => 'API sur l\'appareil';

  @override
  String get skapiOnDeviceApiLoadError => 'Impossible de lire les endpoints';

  @override
  String get skapiOnDeviceApiRowHint =>
      'Touchez une ligne pour ouvrir l\'éditeur';

  @override
  String get commonLoading => 'Chargement...';

  @override
  String get skapiApiTemplateSectionHeader => 'Modèles';

  @override
  String skapiApiTemplateSectionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count modèles',
      one: '1 modèle',
    );
    return '$_temp0';
  }

  @override
  String get skapiApiTemplateUploadCta => 'Envoyer vers l\'appareil';

  @override
  String get skapiApiTemplateUploadHint =>
      'L\'envoi écrit ce modèle dans l\'un des 5 emplacements API USER de l\'appareil. L\'appareil le déclenche sur son propre événement (BF : fin du compte à rebours).';

  @override
  String get skapiApiTemplatePreviewTitle => 'Aperçu de l\'endpoint';

  @override
  String get skapiApiTemplatePreviewType => 'Type';

  @override
  String get skapiApiTemplatePreviewMethod => 'Méthode';

  @override
  String get skapiApiTemplatePreviewUrl => 'URL';

  @override
  String get skapiApiTemplatePreviewAuth => 'Auth';

  @override
  String get skapiApiTemplatePreviewHeader => 'En-tête';

  @override
  String get skapiApiTemplatePreviewContentType => 'Content-Type';

  @override
  String get skapiApiTemplatePreviewPayload => 'Charge utile';

  @override
  String get skapiApiTemplatePreviewDelay => 'Délai';

  @override
  String get skapiOtherCategoryHeading => 'Choisir une catégorie d\'appareil';

  @override
  String get skapiOtherCategorySubtitle =>
      'Les modèles s\'envoient sur l\'appareil jumelé et se déclenchent sur l\'événement propre à l\'appareil (sans ordinateur).';

  @override
  String get skapiOtherSyndimmSub => 'Variateur intelligent SmartKraft';

  @override
  String get skapiOtherLebensspurSub => 'Traqueur d\'activité SmartKraft';

  @override
  String get skapiOtherBlockingfocusSub =>
      'Minuteur de concentration SmartKraft';

  @override
  String get skapiOtherIotSub =>
      'Webhooks IoT tiers (IFTTT, Home Assistant, REST générique)';

  @override
  String get skapiOtherServerSub =>
      'Récepteurs HTTP auto-hébergés (n8n, Node-RED, personnalisés)';

  @override
  String get skapiCategoryComingSoon => 'Modèles bientôt disponibles';

  @override
  String get skapiScriptLockSummaryHowLxDebian =>
      'Appelle loginctl lock-session pour le XDG_SESSION_ID courant ; revient à xdg-screensaver lock quand loginctl n\'est pas disponible.';

  @override
  String get skapiScriptHibernateSummaryHowLxDebian =>
      'Appelle systemctl hibernate. Le délai optionnel attend le nombre de secondes demandé avant la suspension.';

  @override
  String get skapiScriptHibernateNoteLxDebian =>
      'La veille prolongée doit être configurée (swap >= RAM et le paramètre noyau resume=). Sur les systèmes où elle ne l\'est pas, systemd-logind bascule en suspension.';

  @override
  String get skapiScriptSleepSummaryHowLxDebian =>
      'Appelle systemctl suspend. Le noyau peut retarder si un inhibiteur de premier plan bloque les transitions vers l\'inactivité.';

  @override
  String get skapiScriptShutdownSummaryHowLxDebian =>
      'Programme un arrêt propre via /sbin/shutdown -h +N (minutes). Revient à systemctl poweroff après le délai demandé si shutdown est absent.';

  @override
  String get skapiScriptShutdownNoteLxDebian =>
      '/sbin/shutdown ne prend que des minutes ; les valeurs inférieures à 60 sont arrondies à 1 minute. Les autres utilisateurs connectés voient un message wall pendant le compte à rebours.';

  @override
  String get skapiScriptShutdownParamForceHintLxDebian =>
      'Termine la session utilisateur avant l\'extinction pour que le délai de grâce SIGTERM de 90 s soit ignoré.';

  @override
  String get skapiScriptBrightnessSummaryHowLxDebian =>
      'Règle le rétroéclairage de l\'écran interne via brightnessctl set N% (préféré) ou light -S N en repli. Tous deux écrivent dans /sys/class/backlight.';

  @override
  String get skapiScriptBrightnessNoteLxDebian =>
      'brightnessctl fonctionne sans sudo quand l\'utilisateur est dans le groupe video, ce qui est le cas par défaut après installation sur la plupart des configurations Debian. Les moniteurs externes via DDC nécessitent ddcutil et ne sont pas pris en charge ici.';

  @override
  String get skapiScriptMuteToggleSummaryHowLxDebian =>
      'Bascule ou définit la sourdine du sink principal via wpctl (PipeWire sur Debian 12+) avec un repli pactl pour les configurations PulseAudio.';

  @override
  String get skapiScriptVolumeSetSummaryHowLxDebian =>
      'Règle le volume du sink principal à un niveau 0-100 via wpctl set-volume (PipeWire) ou pactl set-sink-volume (PulseAudio).';

  @override
  String get skapiScriptVolumeSetNoteLxDebian =>
      'PipeWire et PulseAudio exposent tous deux nativement le volume par application, ce script est donc de niveau 1 sur Linux. La sortie au-dessus de 100 % est limitée par parité avec les autres plateformes.';

  @override
  String get skapiScriptMediaKeySummaryHowLxDebian =>
      'Envoie une action de touche multimédia via playerctl, qui utilise MPRIS pour communiquer avec l\'application qui possède actuellement la session (Spotify, Firefox, VLC, mpv, Rhythmbox).';

  @override
  String get skapiScriptMediaKeyNoteLxDebian =>
      'Si aucune application multimédia compatible MPRIS ne tourne, la commande est sans effet. Installez la prise en charge MPRIS de l\'application si un lecteur connu ne répond pas.';

  @override
  String get skapiScriptMinimizeWindowSummaryHowLxDebian =>
      'Un processName vide réduit la fenêtre active via xdotool. Sinon, choisit la première fenêtre dont le WM_CLASS correspond et la réduit.';

  @override
  String get skapiScriptMinimizeWindowNoteLxDebian =>
      'X11 uniquement. La correspondance WM_CLASS est sensible à la casse et dépend de la façon dont l\'application s\'est déclarée ; vérifiez xprop WM_CLASS en cas de doute.';

  @override
  String get skapiScriptMinimizeWindowParamProcessHintLxDebian =>
      'Nom d\'instance WM_CLASS (par exemple : firefox, code, gnome-terminal-server). Vide cible la fenêtre active.';

  @override
  String get skapiScriptCloseWindowSummaryHowLxDebian =>
      'Envoie WM_DELETE_WINDOW via wmctrl -x -c (correspond au WM_CLASS) avec un repli sur le titre. Équivaut à cliquer sur le bouton X ; l\'application peut afficher son propre dialogue d\'enregistrement.';

  @override
  String get skapiScriptCloseWindowNoteLxDebian =>
      'X11 uniquement. Pour Wayland, préférez kill-app qui utilise des signaux au lieu du protocole de fenêtre.';

  @override
  String get skapiScriptCloseWindowParamProcessHintLxDebian =>
      'Nom d\'instance WM_CLASS ; vide ferme la fenêtre active. La correspondance par sous-chaîne de titre est utilisée en repli.';

  @override
  String get skapiScriptKillAppSummaryHowLxDebian =>
      'pkill -TERM -x par nom comm exact, attend le délai demandé, puis pkill -KILL sur tout ce qui est encore actif. preKillSave optionnel met d\'abord la fenêtre au premier plan et envoie Ctrl+S (X11 uniquement).';

  @override
  String get skapiScriptKillAppNoteLxDebian =>
      'Les noms comm Linux sont limités à 15 caractères par le noyau. Utilisez des noms courts exacts : firefox (pas firefox-esr-bin), code, soffice.bin.';

  @override
  String get skapiScriptKillAppParamProcessHintLxDebian =>
      'Nom comm exact (limite noyau de 15 caractères). Utilisez pgrep -l pour vérifier le nom visible.';

  @override
  String get skapiScriptKillAppParamPreKillSaveHintLxDebian =>
      'Envoie Ctrl+S à la fenêtre de l\'application avant SIGTERM. Nécessite xdotool et X11 ; ignoré sur Wayland.';

  @override
  String get skapiScriptLaunchAppSummaryHowLxDebian =>
      'Répartition intelligente : .desktop -> gtk-launch, chemin de fichier réel -> exec, sinon -> xdg-open, enfin recherche dans le PATH. Le processus enfant est détaché via setsid pour que SKAPP ne soit pas bloqué.';

  @override
  String get skapiScriptLaunchAppNoteLxDebian =>
      'args est découpé sur les espaces. Les arguments contenant des guillemets ne sont pas pris en charge ; utilisez un script wrapper pour les lignes de commande complexes.';

  @override
  String get skapiScriptLaunchAppParamPathHintLxDebian =>
      'Nom de binaire dans le PATH, chemin absolu, fichier .desktop, URL ou chemin de fichier. xdg-open gère les types MIME.';

  @override
  String get skapiScriptDialogSummaryHowLxDebian =>
      'Ouvre une boîte de dialogue modale via zenity (GTK) avec un repli kdialog (KDE). Écrit ok / cancel / yes / no / timeout sur la sortie standard.';

  @override
  String get skapiScriptDialogNoteLxDebian =>
      'Installez avec : sudo apt install zenity. Les utilisateurs de KDE Plasma peuvent avoir kdialog à la place. Sans l\'un ou l\'autre, le script se termine avec le code 2.';

  @override
  String get skapiScriptToastSummaryHowLxDebian =>
      'Envoie une notification de bureau via notify-send (libnotify). Niveau 1 car libnotify-bin est préinstallé sur tout bureau Debian moderne.';

  @override
  String get skapiScriptToastNoteLxDebian =>
      'icon accepte les noms de thème d\'icônes Freedesktop (dialog-information, dialog-warning, dialog-error). duration en secondes ; 0 garde le toast jusqu\'à fermeture.';

  @override
  String get skapiScriptToastParamIconLabelLxDebian => 'Icône';

  @override
  String get skapiScriptToastParamIconHintLxDebian =>
      'Nom d\'icône Freedesktop, par exemple : dialog-information, dialog-warning, dialog-error.';

  @override
  String get skapiScriptToastParamDurationLabelLxDebian => 'Durée';

  @override
  String get skapiScriptToastParamDurationHintLxDebian =>
      'Fermeture automatique après ce nombre de secondes. 0 signifie que le toast reste jusqu\'à ce que l\'utilisateur le ferme.';

  @override
  String get skapiScriptShowDesktopSummaryHowLxDebian =>
      'Lit l\'état EWMH show-desktop via wmctrl -m, puis le bascule avec wmctrl -k. Reproduit la sémantique de Win+D sur X11.';

  @override
  String get skapiScriptShowDesktopNoteLxDebian =>
      'X11 uniquement. Les équivalents Wayland sont propres au compositeur (Sway, Hyprland, extensions GNOME Shell).';

  @override
  String get skapiScriptFadeScreenSummaryHowLxDebian =>
      'Fait passer linéairement en fondu le rétroéclairage de l\'écran interne de l\'actuel vers la cible sur la durée demandée via brightnessctl, par incréments de 10 paliers par seconde.';

  @override
  String get skapiScriptFadeScreenNoteLxDebian =>
      'Panneaux internes uniquement. Les moniteurs externes via DDC nécessitent ddcutil et ne sont pas pris en charge ici. Niveau 2 car la lecture du rétroéclairage actuel dépend de la visibilité de /sys/class/backlight.';

  @override
  String get skapiScriptGrayscaleSummaryHowLxDebian =>
      'Bascule la clé de saturation des couleurs de la loupe d\'accessibilité de GNOME (0.0 niveaux de gris, 1.0 couleur) via gsettings, sans extension nécessaire.';

  @override
  String get skapiScriptGrayscaleNoteLxDebian =>
      'GNOME / Unity uniquement. KDE Plasma et XFCE n\'ont pas de voie système équivalente ; sur ces bureaux, le script se termine avec le code 3 au lieu d\'un échec silencieux.';

  @override
  String get skapiScriptFindMouseShakeSummaryHowLxDebian =>
      'Lit la position du curseur via xdotool getmouselocation, puis trace un cercle autour pour le nombre de boucles demandé en utilisant des coordonnées cos/sin calculées par awk.';

  @override
  String get skapiScriptFindMouseShakeNoteLxDebian =>
      'X11 uniquement. Wayland bloque le mouvement de pointeur synthétique au niveau du protocole (frontière de sécurité), le script se termine donc avec le code 3.';

  @override
  String get skapiScriptCloseWithSaveSummaryHowLxDebian =>
      'Pour chaque fenêtre visible correspondant au WM_CLASS : activer, Ctrl+S, attendre, puis envoyer WM_DELETE_WINDOW via wmctrl. X11 uniquement.';

  @override
  String get skapiScriptCloseWithSaveNoteLxDebian =>
      'Niveau 2 : l\'injection de la touche Ctrl+S dépend de la locale et du focus ; seule une vraie sémantique d\'enregistrement se comporte de façon prévisible. Les applications de chat ou web peuvent associer Ctrl+S à autre chose.';

  @override
  String get skapiScriptCloseWithSaveParamProcessHintLxDebian =>
      'Nom d\'instance WM_CLASS (voir xprop WM_CLASS). Requis.';

  @override
  String get skapiScriptCloseAllInstancesSummaryHowLxDebian =>
      'Envoie SIGTERM à chaque processus en cours correspondant au nom comm exact. Chaque application gère sa propre séquence d\'arrêt (et peut afficher son propre dialogue d\'enregistrement).';

  @override
  String get skapiScriptCloseAllInstancesParamProcessHintLxDebian =>
      'Nom comm exact tel qu\'affiché par pgrep -l. Requis.';

  @override
  String get skapiScriptBrowserCloseAllSummaryHowLxDebian =>
      'Parcourt une liste de binaires de navigateurs Debian (firefox, firefox-esr, chromium, google-chrome, brave, vivaldi-bin, opera) et envoie SIGTERM à chaque instance en cours.';

  @override
  String get skapiScriptBrowserCloseAllNoteLxDebian =>
      'Les navigateurs préservent la session si « restaurer les onglets au prochain lancement » est activé, c\'est donc un « éteindre l\'écran » doux plutôt qu\'une action de perte de données.';

  @override
  String get skapiScriptSaveActiveWindowSummaryHowLxDebian =>
      'Envoie Ctrl+S à la fenêtre active via xdotool key --clearmodifiers. X11 uniquement.';

  @override
  String get skapiScriptSaveActiveWindowNoteLxDebian =>
      'Wayland bloque l\'injection de touches synthétiques au niveau du protocole. Utilisez le repli autosave-trigger ou comptez sur l\'enregistrement automatique propre à l\'application.';

  @override
  String get skapiScriptSaveAllOpenSummaryHowLxDebian =>
      'Parcourt la liste des applications, trouve les fenêtres visibles de chacune, les active tour à tour et envoie Ctrl+S entre les pauses.';

  @override
  String get skapiScriptSaveAllOpenNoteLxDebian =>
      'La liste d\'applications par défaut couvre LibreOffice (soffice.bin), VS Code (code), gedit et kate. Passez --apps « nom1,nom2 » pour la remplacer. X11 uniquement.';

  @override
  String get skapiScriptSaveAllOpenParamAppsHintLxDebian =>
      'Noms comm séparés par des virgules, par exemple : soffice.bin,code,gedit.';

  @override
  String get skapiScriptAutosaveTriggerSummaryHowLxDebian =>
      'Parcourt chaque fenêtre de premier niveau visible via wmctrl -l, active chacune tour à tour et injecte Ctrl+S. X11 n\'a pas la voie de diffusion WIN WM_COMMAND, le focus par fenêtre est donc le repli.';

  @override
  String get skapiScriptAutosaveTriggerNoteLxDebian =>
      'Niveau 2 : dépend de l\'application active honorant Ctrl+S comme « enregistrer ». La plupart des éditeurs le font ; les applications de chat peuvent mal l\'interpréter. X11 uniquement.';

  @override
  String get commonReadFailed => 'lecture impossible';

  @override
  String get commonUnknown => 'inconnu';

  @override
  String get commonComingSoon => 'bientôt disponible';

  @override
  String get commonDismiss => 'Ignorer';

  @override
  String bootstrapBannerError(String error) {
    return 'Lecture impossible depuis l\'\'appareil : $error';
  }

  @override
  String get bootstrapBannerRetry => 'Réessayer';

  @override
  String get bfApiChainAuthNone => 'Aucune';

  @override
  String get bfApiChainAuthBearer => 'Jeton Bearer';

  @override
  String get bfApiChainAuthBasic => 'Auth Basic';

  @override
  String get bfApiChainAuthHeader => 'En-tête personnalisé';

  @override
  String bfApiChainMasterError(String error) {
    return 'Maître : $error';
  }

  @override
  String get bfApiChainChainStarted => 'Chaîne démarrée';

  @override
  String bfApiChainChainError(String error) {
    return 'Erreur : $error';
  }

  @override
  String get bfApiChainSaveDialogTitle => 'Enregistrer l\'endpoint ?';

  @override
  String bfApiChainSaveDialogBody(String name) {
    return '« $name » sera conservé sur l\'\'appareil. Cela met à jour la zone de données utilisateur.';
  }

  @override
  String get bfApiChainSaveDialogConfirm => 'Enregistrer';

  @override
  String bfApiChainSavedToast(String name) {
    return '« $name » enregistré';
  }

  @override
  String bfApiChainSaveFailed(String error) {
    return 'Enregistrement impossible : $error';
  }

  @override
  String get bfApiChainDeleteDialogTitle => 'Supprimer ?';

  @override
  String bfApiChainDeleteDialogBody(String name) {
    return 'L\'\'endpoint « $name » sera supprimé de l\'\'appareil. Cette action est irréversible.';
  }

  @override
  String get bfApiChainDeleteDialogConfirm => 'Supprimer';

  @override
  String bfApiChainDeletedToast(String name) {
    return '« $name » supprimé';
  }

  @override
  String bfApiChainDeleteFailed(String error) {
    return 'Suppression impossible : $error';
  }

  @override
  String bfApiChainTestNoReply(String name) {
    return '« $name » sans réponse (délai de 15 s)';
  }

  @override
  String bfApiChainTestSuccess(String name, String httpSuffix) {
    return '« $name » réussi$httpSuffix';
  }

  @override
  String bfApiChainTestFailure(String name, String error, String httpSuffix) {
    return '« $name » erreur : $error$httpSuffix';
  }

  @override
  String bfApiChainTestTriggerFailed(String error) {
    return 'Déclenchement impossible : $error';
  }

  @override
  String get bfApiChainNewEndpointName => 'Nouvel endpoint';

  @override
  String get bfApiChainEmptyTitle =>
      'Aucun endpoint enregistré pour l\'instant';

  @override
  String get bfApiChainEmptyBody =>
      'Utilisez la carte « Ajouter un endpoint » ci-dessous pour définir un nouvel appel HTTP (par ex. webhook IFTTT, votre propre serveur, pause Spotify).';

  @override
  String get bfApiChainSystemSectionTitle => 'Automatique (SKAPP jumelés)';

  @override
  String get bfApiChainSystemSectionSubtitle =>
      'Lorsque vous liez un script via SKAPI, un emplacement s\'ouvre automatiquement pour chaque ordinateur. À la fin du compte à rebours, un webhook signé est envoyé au SKAPP de cet ordinateur.';

  @override
  String get bfApiChainUserSectionTitle => 'Manuel (appareils IoT)';

  @override
  String get bfApiChainUserSectionSubtitle =>
      'Ajoutez des URL tierces (Shelly, Home Assistant, IFTTT) manuellement. À la fin du compte à rebours, cette liste se déclenche en premier, dans l\'ordre.';

  @override
  String get bfApiChainMasterToggleLabel => 'Déclencheur actif';

  @override
  String get bfApiChainMasterOnSubtitle =>
      'Maître actif : la chaîne se déclenche sur les événements de l\'appareil';

  @override
  String get bfApiChainMasterOffSubtitle =>
      'Maître inactif : aucun endpoint ne sera appelé';

  @override
  String get bfApiChainFieldNameLabel => 'Nom';

  @override
  String get bfApiChainTypeLabel => 'Type';

  @override
  String get bfApiChainEventOrApplet => 'Événement / Applet';

  @override
  String get bfApiChainMethodLabel => 'Méthode';

  @override
  String get bfApiChainDelayLabel => 'Attendre après (0-300 s)';

  @override
  String get bfApiChainDelayUnit => 's';

  @override
  String get bfApiChainAdvancedHide => 'Masquer les options avancées';

  @override
  String get bfApiChainAdvancedShow => 'Options avancées';

  @override
  String get bfApiChainAuthLabel => 'Authentification';

  @override
  String bfApiChainCurrentTokenHint(String masked) {
    return 'Jeton actuel : $masked (écrivez une nouvelle valeur ci-dessous pour le renouveler)';
  }

  @override
  String get bfApiChainNewTokenLabel =>
      'Nouveau jeton (laisser vide pour conserver)';

  @override
  String get bfApiChainContentTypeLabel => 'Content-Type';

  @override
  String get bfApiChainSaveCta => 'Enregistrer';

  @override
  String get bfApiChainDeleteCta => 'Supprimer';

  @override
  String get bfApiChainTestCta => 'Tester';

  @override
  String get bfApiChainAddCardLabel => 'Ajouter un nouvel endpoint';

  @override
  String bfApiChainSavedDelaySeconds(int count) {
    return '$count s d\'\'attente';
  }

  @override
  String get bfApiChainNotSaved => 'non enregistré';

  @override
  String bfApiChainSystemRowSignedTooltip(String peer, int delay) {
    return 'pair $peer…  ·  délai $delay s  ·  signé (HMAC)';
  }

  @override
  String get bfApiChainTestEndpointTooltip => 'Tester cet endpoint';

  @override
  String get bfLogsBufferEmpty =>
      'Le tampon de journal de l\'appareil est vide.';

  @override
  String get bfLogsUnsupported =>
      'L\'appareil ne prend pas en charge les journaux dans ce firmware.';

  @override
  String get deviceLogsNoClockBanner =>
      'Horloge de l\'appareil non réglée ; les horodatages sont affichés en secondes depuis le démarrage.';

  @override
  String get deviceLogsTruncatedHint =>
      '(sortie tronquée, essayez une limite plus basse ou une gravité plus élevée)';

  @override
  String get bfEventsTimerRunning => 'Compte à rebours démarré';

  @override
  String get bfEventsTimerPaused => 'Compte à rebours en pause';

  @override
  String get bfEventsTimerIdle => 'Compte à rebours réinitialisé';

  @override
  String get bfEventsTimerCooldown => 'Récupération';

  @override
  String get bfEventsTimerExpired => 'Compte à rebours terminé';

  @override
  String bfEventsFaceChanged(String from, String to) {
    return 'Face changée : $from → $to';
  }

  @override
  String bfEventsApiTriggered(String type) {
    return '$type déclenché';
  }

  @override
  String get bfEventsApiTriggeredFallback => 'API déclenchée';

  @override
  String bfEventsBatteryLevel(int percent) {
    return 'Niveau de batterie : %$percent';
  }

  @override
  String get bfEventsDeviceRestarted => 'Appareil redémarré';

  @override
  String skapiManifestLoadingRetry(String platform, String scriptId) {
    return 'Manifeste $platform/$scriptId en cours de chargement, réessayez dans un instant';
  }

  @override
  String get skapiListenerOffMobileTitle =>
      'Cet appareil ne peut pas exécuter de scripts de bureau';

  @override
  String get skapiListenerOffDesktopTitle =>
      'L\'écouteur HTTP SKAPP est désactivé';

  @override
  String get skapiListenerOffMobileBody =>
      'À la fin du compte à rebours, les scripts s\'exécuteront sur Windows / macOS / Linux. SKAPP doit être ouvert et l\'écouteur actif. Ce téléphone n\'est que le côté configuration ; l\'exécution se fait sur le bureau.';

  @override
  String skapiListenerOffDesktopBody(String lastErrorSuffix) {
    return 'BF déclenchera le webhook, mais personne ne le captera car l\'\'écouteur est désactivé. Ouvrez Paramètres → Écouteur HTTP SKAPP.$lastErrorSuffix';
  }

  @override
  String get skapiSyncBadgeWriting => 'Écriture vers BF…';

  @override
  String get skapiSyncBadgeWritten => 'Enregistré sur BF';

  @override
  String get skapiSyncBadgeFailed => 'Écriture vers BF impossible';

  @override
  String skapiSyncBadgeFirmwareCodeTooltip(String code) {
    return 'Code firmware : $code';
  }

  @override
  String get syncErrUnknownCommand =>
      'Ancien firmware sur l\'appareil. Flashez le nouveau firmware';

  @override
  String get syncErrNotAuthenticated =>
      'Session de l\'appareil non autorisée (un nouveau jumelage peut être nécessaire)';

  @override
  String get syncErrNotFound =>
      'Aucun enregistrement de jumelage sur l\'appareil';

  @override
  String get syncErrInternal =>
      'Les 8 emplacements SYSTEM sont peut-être pleins';

  @override
  String get syncErrUnknown => 'erreur inconnue';

  @override
  String get syncErrTimeout => 'L\'appareil n\'a pas répondu (hors ligne ?)';

  @override
  String get syncErrNoBond => 'Aucun jumelage avec cet appareil';

  @override
  String get syncErrConnect => 'Connexion à l\'appareil impossible';

  @override
  String get discoveryFilterShowAll => 'Afficher tous les appareils';

  @override
  String get discoveryFilterOnlySmartKraft => 'SmartKraft uniquement';

  @override
  String discoveryScanningWithCount(int count, String tail) {
    return 'Analyse… $count appareil(s) trouvé(s)$tail';
  }

  @override
  String discoveryFoundCountWithTail(int count, String tail) {
    return '$count appareil(s) trouvé(s)$tail';
  }

  @override
  String discoveryFilterOff(int visible, int sk, String tail) {
    return 'Filtre désactivé · $visible appareil(s) affiché(s) ($sk SmartKraft$tail)';
  }

  @override
  String discoveryMdnsTail(int count) {
    return ' + $count sur le réseau';
  }

  @override
  String get discoveryWifiOnlySnack =>
      'Cet appareil n\'est actuellement visible qu\'en WiFi. Le jumelage WiFi n\'est pas encore actif, appuyez brièvement sur le bouton de l\'appareil pour ouvrir la fenêtre de jumelage. Une fois qu\'il est aussi vu en BLE, cette ligne devient jumelable.';

  @override
  String get discoveryBadgePairable => 'Jumelable';

  @override
  String get discoveryBadgeBonded => 'Jumelé avec un autre SKAPP';

  @override
  String get pairingTitleConnecting => 'Connexion';

  @override
  String get pairingTitleReconnecting => 'Reconnexion';

  @override
  String get pairingMutualAuthHmacSubtitle => 'Défi-réponse HMAC';

  @override
  String pairingBleConnectFailed(String error) {
    return 'Échec de la connexion BLE.\n\nSolution : appuyez brièvement sur le bouton de l\'\'appareil pour ouvrir la fenêtre de jumelage de 60 secondes, puis appuyez sur « Réessayer ».\n\nDétails : $error';
  }

  @override
  String get pairingGattServiceMissing => 'Service SKAPP introuvable';

  @override
  String get pairingGattCmdRxMissing => 'Caractéristique cmd_rx manquante';

  @override
  String get pairingGattEventTxMissing => 'Caractéristique event_tx manquante';

  @override
  String pairingGattDiscoveryFailed(String error) {
    return 'Échec de la découverte GATT : $error';
  }

  @override
  String pairingKeySendFailed(String error) {
    return 'Envoi de la clé impossible : $error';
  }

  @override
  String pairingDeviceNoReply(int seconds) {
    return 'L\'\'appareil n\'\'a pas répondu ($seconds s).';
  }

  @override
  String pairingDeviceRejected(String error) {
    return 'Appareil rejeté : $error';
  }

  @override
  String get pairingInvalidReplyMissingPub =>
      'Réponse de l\'appareil invalide (our_pub manquant).';

  @override
  String pairingHexDecodeFailed(String error) {
    return 'Échec du décodage hexadécimal de our_pub : $error';
  }

  @override
  String get pairingRetryButton => 'Réessayer';

  @override
  String pairingReconnectTransient(String error) {
    return 'Impossible de joindre l\'\'appareil ; le jumelage existant est conservé.\n\nAssurez-vous que l\'\'appareil est allumé et à portée, puis appuyez sur « Réessayer ».\n\nDétails : $error';
  }

  @override
  String get pairingRecoveryTitle => 'Renouveler le jumelage';

  @override
  String get pairingRecoveryBody =>
      'L\'appareil ne reconnaît pas le jumelage actuel. Pour en démarrer un nouveau, appuyez sur le bouton de jumelage de l\'appareil pour ouvrir la fenêtre de 60 secondes, puis appuyez sur Continuer.';

  @override
  String get pairingRecoveryContinue => 'Continuer';

  @override
  String get pairingRecoveryCancelled =>
      'Renouvellement du jumelage annulé. L\'ancien jumelage est toujours enregistré ; appuyez sur « Réessayer » pour tenter une autre connexion plus tard.';

  @override
  String get pairingRenewBondButton => 'Renouveler le jumelage';

  @override
  String wifiPasswordConnectionRejected(String error) {
    return 'Connexion rejetée : $error';
  }

  @override
  String get wifiPasswordTimeout =>
      'L\'appareil n\'a pas répondu (délai dépassé).';

  @override
  String wifiScanRejected(String error) {
    return 'L\'\'appareil a rejeté wifi.scan : $error\n\nLe module WiFi de l\'\'appareil n\'\'a peut-être pas démarré ; essayez un redémarrage.';
  }

  @override
  String wifiScanUnexpectedReply(String data) {
    return 'Réponse wifi.scan inattendue : $data';
  }

  @override
  String wifiScanTimeout(String error) {
    return 'L\'\'appareil n\'\'a pas répondu (délai : $error).\n\nRapprochez-vous de l\'\'appareil, appuyez brièvement sur son bouton (pour déclencher l\'\'annonce) et réessayez.';
  }

  @override
  String wifiScanConnectionError(String error) {
    return 'Erreur de connexion : $error';
  }

  @override
  String get wifiScanHeaderHelp =>
      'Voici les réseaux WiFi que **l\'appareil** peut voir (pas les réseaux du téléphone). Choisissez le réseau que l\'appareil doit rejoindre ; le mot de passe est demandé à l\'étape suivante.';

  @override
  String get wifiScanAuthOpen => 'Ouvert';

  @override
  String get wifiScanAuthEncrypted => 'Chiffré';

  @override
  String get wifiSuccessSyncing => 'Synchronisation de l\'heure…';

  @override
  String get wifiSuccessFetchingInfo =>
      'Récupération des infos de l\'appareil…';

  @override
  String get wifiSuccessPreparingUi =>
      'Préparation de l\'interface de l\'appareil…';

  @override
  String wifiSuccessManifestRejected(String error) {
    return 'device.manifest rejeté ($error). C\'\'est peut-être un ancien firmware ; sk_baseline.c doit être chargé pour le BF.';
  }

  @override
  String get wifiSuccessTapToContinue => 'Touchez pour continuer…';

  @override
  String get deviceHomeUnsupportedTitle => 'Appareil non pris en charge';

  @override
  String deviceHomeUnsupportedBody(String name) {
    return '$name n\'\'a pas d\'\'écran d\'\'appareil dans cette version de SKAPP. Lorsqu\'\'une nouvelle famille d\'\'appareils sera ajoutée, cet écran apparaîtra automatiquement.';
  }

  @override
  String get lsPairingUnpairTitle => 'Désappairer cette APP';

  @override
  String get lsPairingUnpairBody =>
      'L\'appareil oubliera la liaison de cette APP. Vous devrez la jumeler à nouveau (bouton 3 s + sélection dans Appareils).';

  @override
  String get skYakindaBadgeDefault => 'bientôt disponible';

  @override
  String get skapiScriptPulseBrightnessTitle => 'Pulser la luminosité';

  @override
  String get skapiScriptPulseBrightnessSummaryWhat =>
      'Module la luminosité de l\'écran interne sur une onde cosinus douce entre 100 % et une borne inférieure, répétée un nombre de fois défini. La luminosité d\'origine de l\'utilisateur est restaurée à la fin.';

  @override
  String get skapiScriptPulseBrightnessSummaryHow =>
      'Lit la luminosité actuelle via WMI, puis écrit un échantillon de luminosité 20 fois par seconde en suivant une courbe cosinus. Restaure toujours l\'original capturé à la sortie.';

  @override
  String get skapiScriptPulseBrightnessNote =>
      'Panneaux internes uniquement (ordinateurs portables, tablettes). Les moniteurs externes DDC/CI ne répondent pas à cette voie WMI.';

  @override
  String get skapiScriptPulseBrightnessParamPeriodLabel => 'période';

  @override
  String get skapiScriptPulseBrightnessParamPeriodHint =>
      'Secondes pour un cycle complet clair -> sombre -> clair. Autour de 2 donne une pulsation nette sans être brutale.';

  @override
  String get skapiScriptPulseBrightnessParamLowPercentLabel => '% bas';

  @override
  String get skapiScriptPulseBrightnessParamLowPercentHint =>
      'Extrémité sombre de la pulsation, en pourcentage de la pleine luminosité. Des nombres plus bas rendent la pulsation plus marquée.';

  @override
  String get skapiScriptPulseBrightnessParamCyclesLabel => 'cycles';

  @override
  String get skapiScriptPulseBrightnessParamCyclesHint =>
      'Combien de cycles de pulsation complets exécuter avant de quitter.';

  @override
  String get skapiScriptBlurTimedTitle => 'Pause floutée';

  @override
  String get skapiScriptBlurTimedSummaryWhat =>
      'Couvre l\'écran d\'un voile semi-transparent en plein écran, toujours au premier plan, pour le nombre de secondes configuré. Un compte à rebours est affiché au centre.';

  @override
  String get skapiScriptBlurTimedSummaryHow =>
      'Ouvre une fenêtre WPF sans bordure avec AllowsTransparency et une brosse de couleur unie à l\'opacité choisie. Un dispatcher timer pilote le compte à rebours ; la fenêtre se ferme d\'elle-même quand le minuteur atteint zéro.';

  @override
  String get skapiScriptBlurTimedNote =>
      'Solution intermédiaire pragmatique : un vrai flou gaussien en temps réel sur le bureau nécessite un assistant C++/Win2D qui arrivera plus tard. Le voile uni crée une friction similaire « je ne peux pas me concentrer sur l\'écran, faisons une pause » en attendant.';

  @override
  String get skapiScriptBlurTimedParamDurationLabel => 'duration';

  @override
  String get skapiScriptBlurTimedParamDurationHint =>
      'Secondes pendant lesquelles le voile reste avant de se fermer automatiquement.';

  @override
  String get skapiScriptBlurTimedParamOpacityLabel => 'opacity';

  @override
  String get skapiScriptBlurTimedParamOpacityHint =>
      'Opacité du voile de 0.0 (invisible) à 1.0 (opaque). Autour de 0.55 laisse encore transparaître assez le bureau pour donner une impression de voile, sans tout noircir.';

  @override
  String get skapiScriptBlurTimedParamColorLabel => 'color';

  @override
  String get skapiScriptBlurTimedParamColorHint =>
      'Couleur du voile en hexa #RRGGBB. Le noir de la palette #0A0A0A est la valeur par défaut ; des tons crème plus clairs paraissent plus apaisants.';

  @override
  String get skapiScriptBlockingFocusTitle => 'Blocking Focus';

  @override
  String get skapiScriptBlockingFocusSummaryWhat =>
      'Outil composite d\'aide à la concentration : enregistre tous les documents Office et VS Code ouverts, puis ouvre une fenêtre de compte à rebours en plein écran toujours au premier plan, sans bouton de fermeture, tandis que le curseur de la souris tourne en continu. Quand le minuteur atteint zéro, tout est annulé automatiquement.';

  @override
  String get skapiScriptBlockingFocusSummaryHow =>
      'Trois phases s\'enchaînent : (1) la phase d\'enregistrement appelle Office COM et la CLI de VS Code ; (2) un runspace parallèle fait tourner le curseur en cercle jusqu\'à ce qu\'un drapeau d\'arrêt synchronisé bascule ; (3) une fenêtre WPF STA affiche le titre et le compte à rebours. Un bloc finally restaure l\'origine du curseur et démantèle les deux runspaces.';

  @override
  String get skapiScriptBlockingFocusNote =>
      'Mode doux : Échap et Alt+F4 ne sont PAS bloqués. L\'utilisateur peut toujours s\'échapper via le Gestionnaire des tâches. Un mode strict avec des hooks clavier globaux sera un script distinct.';

  @override
  String get skapiScriptBlockingFocusParamDurationLabel => 'duration';

  @override
  String get skapiScriptBlockingFocusParamDurationHint =>
      'Secondes que dure le verrouillage. Le compte à rebours descend jusqu\'à 00:00 puis tout se nettoie.';

  @override
  String get skapiScriptBlockingFocusParamTitleLabel => 'title';

  @override
  String get skapiScriptBlockingFocusParamTitleHint =>
      'Texte affiché au milieu de la fenêtre plein écran. Restez court - « Blocking Focus » est la valeur par défaut.';

  @override
  String get skapiScriptBlockingFocusParamShakeRadiusLabel =>
      'rayon de secousse';

  @override
  String get skapiScriptBlockingFocusParamShakeRadiusHint =>
      'Pixels que le curseur parcourt depuis son origine pendant la boucle. Des cercles plus grands attirent plus l\'attention.';

  @override
  String get skapiScriptBlockingFocusParamEnableSaveLabel =>
      'enregistrer au démarrage';

  @override
  String get skapiScriptBlockingFocusParamEnableSaveHint =>
      'Exécute la phase d\'enregistrement Office + VS Code avant le verrouillage. Désactivez quand il n\'y a aucun état de document à protéger.';

  @override
  String get trayFirstHideToast =>
      'SKAPP continue de tourner en arrière-plan. Retrouvez-le dans la barre d\'état système ; clic droit pour Quitter.';

  @override
  String devicesOfflineTapHint(String name) {
    return '$name est hors ligne.';
  }

  @override
  String skapiNewActionDeviceOffline(String name) {
    return '$name est hors ligne. Remettez-le en ligne pour créer une nouvelle action.';
  }

  @override
  String get bfApiChainRefreshDirtyTitle => 'Modifications non enregistrées';

  @override
  String get bfApiChainRefreshDirtyBody =>
      'L\'actualisation récupérera la dernière liste d\'endpoints de l\'appareil et écartera le brouillon que vous n\'avez pas encore enregistré.';

  @override
  String get bfApiChainRefreshDirtyConfirm => 'Actualiser quand même';

  @override
  String get skapiApiEditorTitle => 'API sur l\'appareil';

  @override
  String get lsCommonReadFailed => 'Échec de la lecture';

  @override
  String lsCommonFailedWith(String err) {
    return 'Échec : $err';
  }

  @override
  String get lsVacationStatusOff => 'Désactivé';

  @override
  String lsVacationStatusUntil(String date) {
    return 'Jusqu\'\'au $date';
  }

  @override
  String get lsVacationDaysValidationError =>
      'Le nombre de jours doit être compris entre 1 et 60';

  @override
  String lsVacationStartedSnack(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Vacances commencées · $days jours',
      one: 'Vacances commencées · 1 jour',
    );
    return '$_temp0';
  }

  @override
  String get lsVacationCancelledSnack => 'Vacances annulées';

  @override
  String lsVacationActiveUntilFmt(String date) {
    return 'Actif jusqu\'\'au $date';
  }

  @override
  String get lsVacationResumeHint =>
      'Le compte à rebours reprendra à la fin des vacances.';

  @override
  String get lsVacationCancellingButton => 'Annulation…';

  @override
  String get lsVacationCancelButton => 'Annuler les vacances';

  @override
  String get lsVacationDaysLabel => 'Jours';

  @override
  String get lsVacationDaysHint =>
      'Met le compte à rebours en pause pendant ce nombre de jours (1 à 60).';

  @override
  String get lsVacationStartingButton => 'Démarrage…';

  @override
  String get lsVacationStartButton => 'Démarrer les vacances';

  @override
  String get lsCommonSavingButton => 'Enregistrement…';

  @override
  String get lsCommonSaveButton => 'Enregistrer';

  @override
  String lsCommonSaveFailedWith(String err) {
    return 'Échec de l\'\'enregistrement : $err';
  }

  @override
  String get lsDurationValueValidationError =>
      'La valeur doit être comprise entre 1 et 60';

  @override
  String get lsDurationAlarmsValidationError =>
      'Le nombre d\'alarmes doit être compris entre 0 et 10';

  @override
  String get lsDurationConfiguredSnack => 'Minuteur configuré';

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
      other: '$value heures',
      one: '1 heure',
    );
    return '$_temp0';
  }

  @override
  String lsDurationUnitDay(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value jours',
      one: '1 jour',
    );
    return '$_temp0';
  }

  @override
  String lsDurationAlarmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alarmes',
      one: '1 alarme',
    );
    return '$_temp0';
  }

  @override
  String get lsDurationUnitLabel => 'Unité';

  @override
  String get lsDurationUnitMinutesPlural => 'minutes';

  @override
  String get lsDurationUnitHoursPlural => 'heures';

  @override
  String get lsDurationUnitDaysPlural => 'jours';

  @override
  String get lsDurationValueLabel => 'Valeur';

  @override
  String get lsDurationValueHint => '1 à 60';

  @override
  String get lsDurationAlarmCountLabel => 'Nombre d\'alarmes';

  @override
  String get lsDurationAlarmCountHint =>
      'Les alarmes se déclenchent à rebours depuis la fin, espacées d\'une unité.';

  @override
  String get lsSmtpStatusNotConfigured => 'Non configuré';

  @override
  String get lsSmtpHostRequired => 'L\'hôte est requis';

  @override
  String get lsSmtpPortValidationError =>
      'Le port doit être compris entre 1 et 65535';

  @override
  String get lsSmtpSenderRequired => 'L\'adresse de l\'expéditeur est requise';

  @override
  String get lsSmtpFieldHost => 'Hôte';

  @override
  String get lsSmtpFieldPort => 'Port';

  @override
  String get lsSmtpFieldSender => 'Expéditeur';

  @override
  String get lsSmtpFieldKey => 'Clé';

  @override
  String lsSmtpSaveHaltedOn(String err) {
    return 'Enregistrement interrompu sur $err';
  }

  @override
  String get lsSmtpSavedSnack => 'SMTP enregistré';

  @override
  String get lsSmtpTestSentSnack => 'E-mail de test envoyé';

  @override
  String lsSmtpTestFailedWith(String err) {
    return 'Échec du test : $err';
  }

  @override
  String get lsSmtpUrlCopiedSnack => 'URL copiée dans le presse-papiers';

  @override
  String get lsSmtpApiKeyPlaceholder =>
      'Mot de passe d\'application Gmail / clé API';

  @override
  String get lsSmtpServerLabel => 'Serveur';

  @override
  String get lsSmtpApiKeyLabel => 'Clé API';

  @override
  String get lsSmtpApiKeyHint => 'Laissez vide pour conserver la clé actuelle.';

  @override
  String get lsSmtpAppPasswordHelpLink =>
      'Comment obtenir un mot de passe d\'application Gmail';

  @override
  String get lsSmtpSendingButton => 'Envoi…';

  @override
  String get lsSmtpSendTestButton => 'Envoyer un test';

  @override
  String get lsReminderMailRecipientValidation =>
      'Le destinataire doit ressembler à une adresse e-mail';

  @override
  String get lsReminderMailSavedSnack => 'Rappel enregistré localement';

  @override
  String get lsReminderMailRecipientFirstSnack =>
      'Définissez d\'abord un destinataire';

  @override
  String get lsReminderMailTestOkSnack =>
      'Test SMTP OK, les identifiants atteignent le serveur';

  @override
  String lsReminderMailTestFailedWith(String err) {
    return 'Échec du test SMTP : $err';
  }

  @override
  String get lsReminderMailRecipientLabel => 'E-mail du destinataire';

  @override
  String get lsReminderMailSubjectLabel => 'Objet';

  @override
  String get lsReminderMailBodyLabel => 'Corps';

  @override
  String get lsReminderMailBodyHint =>
      'Votre compte à rebours va bientôt se déclencher...';

  @override
  String get lsReminderMailActiveLabel => 'Actif';

  @override
  String get lsReminderMailFootnote =>
      'Enregistré localement sur cet appareil. Le test d\'envoi vérifie seulement que le serveur SMTP est joignable ; le déclenchement automatique sur timer.alarm est en attente de prise en charge par le firmware.';

  @override
  String get lsResetApiStatusDisabled => 'Désactivé';

  @override
  String lsResetApiStatusEnabledPort(int port) {
    return 'Activé · port $port';
  }

  @override
  String get lsResetApiRegenDialogTitle => 'Régénérer la clé API ?';

  @override
  String get lsResetApiRegenDialogBody =>
      'Cela invalidera la clé actuelle. Tout appelant utilisant la clé précédente sera rejeté jusqu\'à ce que vous la mettiez à jour. Continuer ?';

  @override
  String get lsResetApiRegenConfirm => 'Régénérer';

  @override
  String get lsResetApiKeyRegeneratedSnack => 'Clé régénérée';

  @override
  String get lsResetApiEnabledLabel => 'Activé';

  @override
  String get lsResetApiEnabledHint =>
      'Quand activé, une requête HTTP GET vers l\'URL de l\'endpoint avec la clé correspondante réinitialise le compte à rebours.';

  @override
  String get lsResetApiEndpointUrlLabel => 'URL de l\'endpoint';

  @override
  String get lsResetApiUrlNotAvailable => '(non disponible)';

  @override
  String get lsResetApiCopyUrlTooltip => 'Copier l\'URL';

  @override
  String get lsResetApiKeyLabel => 'Clé API';

  @override
  String get lsResetApiKeyNotSet => '(non définie)';

  @override
  String get lsResetApiExampleLabel => 'Exemple';

  @override
  String get lsResetApiRegenerateButton => 'Régénérer la clé';

  @override
  String get lsAlarmApiUrlValidation =>
      'L\'URL doit commencer par http:// ou https://';

  @override
  String get lsAlarmApiHeadersValidation =>
      'Le champ En-têtes doit être un JSON valide';

  @override
  String get lsAlarmApiSaveDialogTitle => 'Enregistrer l\'endpoint webhook ?';

  @override
  String lsAlarmApiSaveDialogBody(String name, String url) {
    return 'Stocke « $name » sur l\'\'appareil pointant vers :\n$url';
  }

  @override
  String get lsAlarmApiSavedSnack => 'Webhook enregistré';

  @override
  String get lsAlarmApiDisabledSnack => 'Webhook désactivé';

  @override
  String get lsAlarmApiTestQueuedSnack =>
      'Test mis en file, surveillez le service en amont';

  @override
  String lsAlarmApiTestFailedWith(String err) {
    return 'Échec du test : $err';
  }

  @override
  String get lsAlarmApiRemoveDialogTitle => 'Supprimer le webhook ?';

  @override
  String lsAlarmApiRemoveDialogBody(String name) {
    return 'Supprime « $name » de l\'\'appareil. La configuration locale est conservée.';
  }

  @override
  String get lsAlarmApiRemoveButton => 'Supprimer';

  @override
  String lsAlarmApiRemoveFailedWith(String err) {
    return 'Échec de la suppression : $err';
  }

  @override
  String get lsAlarmApiConfiguredStatus => 'Configuré';

  @override
  String lsAlarmApiConfiguredHost(String host) {
    return 'Configuré · $host';
  }

  @override
  String get lsAlarmApiUrlLabel => 'URL';

  @override
  String get lsAlarmApiMethodLabel => 'Méthode HTTP';

  @override
  String get lsAlarmApiHeadersLabel => 'En-têtes (JSON, optionnel)';

  @override
  String get lsAlarmApiHeadersHint =>
      'Objet JSON avec des en-têtes optionnels. Enregistré localement ; le firmware les applique au déclenchement.';

  @override
  String get lsAlarmApiBodyTemplateLabel => 'Modèle de corps (JSON)';

  @override
  String get lsAlarmApiBodyTemplateHint =>
      'Les espaces réservés device et remaining_sec sont substitués au moment du déclenchement.';

  @override
  String get lsAlarmApiBearerLabel => 'Jeton Bearer (optionnel)';

  @override
  String get lsAlarmApiFootnote =>
      'L\'abonné firmware pour l\'événement timer.alarm est en attente. Cette configuration stocke l\'endpoint ; il ne se déclenchera pas automatiquement avant la prochaine mise à jour du firmware.';

  @override
  String lsRelaySummarySeconds(int seconds) {
    return '$seconds s';
  }

  @override
  String lsRelaySummaryMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get lsRelayModePulse => 'impulsion';

  @override
  String get lsRelayModeSteady => 'continu';

  @override
  String lsRelaySummaryFmt(int gpio, String duration, String mode) {
    return 'GPIO $gpio · $duration $mode';
  }

  @override
  String get lsRelayGpioValidation => 'Le GPIO doit être compris entre 0 et 30';

  @override
  String get lsRelayDurationValidation =>
      'La durée doit être comprise entre 1 et 3600 secondes';

  @override
  String get lsRelayPulseValidation =>
      'La demi-période d\'impulsion doit être comprise entre 1 et 60';

  @override
  String lsRelayCmdFailedWith(String cmd, String err) {
    return 'Échec de $cmd : $err';
  }

  @override
  String get lsRelayConfiguredSnack => 'Relais configuré';

  @override
  String get lsRelayFireAbortedSnack => 'Déclenchement annulé';

  @override
  String get lsRelayForcedIdleSnack => 'Relais forcé au repos';

  @override
  String get lsRelayGpioLabel => 'Broche GPIO';

  @override
  String get lsRelayGpioHint => 'Broche valide ESP32-C6 ; par défaut 19 = D8';

  @override
  String get lsRelayInvertLabel => 'Inverser la polarité';

  @override
  String get lsRelayStartDelayLabel => 'Délai de démarrage';

  @override
  String lsRelayStartDelayHint(int sec) {
    return '$sec s avant l\'\'activation du relais';
  }

  @override
  String get lsRelayActiveDurationLabel => 'Durée d\'activité';

  @override
  String get lsRelayUnitSeconds => 'Secondes';

  @override
  String get lsRelayUnitMinutes => 'Minutes';

  @override
  String get lsRelayPulseModeLabel => 'Mode impulsion';

  @override
  String get lsRelayPulseModeHint =>
      'Activé = demi-période de 1 s. Personnalisé vous laisse définir la demi-période.';

  @override
  String get lsRelayHalfCycleLabel => 'Secondes de demi-période';

  @override
  String get lsRelayFiringButton => 'Déclenchement…';

  @override
  String get lsRelayTestRelayButton => 'Tester le relais';

  @override
  String get lsRelayAbortButton => 'Annuler';

  @override
  String get lsRelayForceOffButton => 'Forcer l\'arrêt';

  @override
  String get lsRelayPulseOff => 'Désactivé';

  @override
  String get lsRelayPulseOn => 'Activé';

  @override
  String get lsRelayPulseCustom => 'Personnalisé';

  @override
  String get lsRelayPhaseActiveBadge => 'actif';

  @override
  String lsRelayPhaseLine(String phase, String elapsed) {
    return 'Phase : $phase$elapsed';
  }

  @override
  String get lsTelegramTokenRequired => 'Le jeton du bot est requis';

  @override
  String get lsTelegramChatRequired =>
      'L\'identifiant de discussion est requis';

  @override
  String get lsTelegramSaveDialogTitle => 'Enregistrer l\'endpoint Telegram ?';

  @override
  String lsTelegramSaveDialogBody(String name) {
    return 'Stocke « $name » sur l\'\'appareil. Le jeton est envoyé dans l\'\'URL.';
  }

  @override
  String get lsTelegramSavedSnack => 'Endpoint Telegram enregistré';

  @override
  String get lsTelegramDisabledSnack => 'Endpoint Telegram désactivé';

  @override
  String get lsTelegramTestQueuedSnack =>
      'Test mis en file, surveillez la discussion Telegram';

  @override
  String get lsTelegramRemoveDialogTitle => 'Supprimer l\'endpoint Telegram ?';

  @override
  String get lsTelegramBotConfiguredStatus => 'Bot configuré';

  @override
  String get lsTelegramBotTokenLabel => 'Jeton du bot';

  @override
  String get lsTelegramBotTokenHint =>
      'Obtenez-en un auprès de @BotFather (ressemble à 1234567:AAH...).';

  @override
  String get lsTelegramChatIdLabel => 'ID de discussion';

  @override
  String get lsTelegramChatIdHint =>
      'Un identifiant numérique (-100...) ou un nom d\'utilisateur @canal.';

  @override
  String get lsTelegramMessageTemplateLabel => 'Modèle de message';

  @override
  String get lsTelegramMessageHint => 'LebensSpur : alarme déclenchée.';

  @override
  String get lsLsApiUrlRequired => 'URL requise';

  @override
  String get lsLsApiUpdatedSnack => 'Webhook mis à jour';

  @override
  String get lsLsApiSavedSnack => 'Webhook enregistré';

  @override
  String get lsLsApiSaveFirstSnack => 'Enregistrez d\'abord le webhook';

  @override
  String get lsLsApiTestQueuedSnack =>
      'Test mis en file, vérifiez le récepteur';

  @override
  String get lsLsApiRemoveDialogBody =>
      'Le webhook LS sera supprimé de l\'appareil. Le compte à rebours ne le déclenchera plus.';

  @override
  String get lsLsApiRemovedSnack => 'Webhook supprimé';

  @override
  String get lsLsApiConfirmCriticalTitle => 'Confirmer le changement critique';

  @override
  String lsLsApiConfirmCriticalBody(String cmd, int ttlSec) {
    return 'L\'\'appareil demande de confirmer :\n  $cmd\n\nCe jeton expire dans $ttlSec s.';
  }

  @override
  String get lsLsApiConfirmButton => 'Confirmer';

  @override
  String lsLsApiActiveSlot(String name) {
    return 'Actif · emplacement « $name »';
  }

  @override
  String lsLsApiActiveWithToken(String name, String token) {
    return 'Actif · emplacement « $name » · jeton $token';
  }

  @override
  String get lsLsApiUrlHint =>
      'Déclenché quand timer.triggered se déclenche. https:// recommandé.';

  @override
  String get lsLsApiHeadersLabel => 'En-têtes (JSON)';

  @override
  String get lsLsApiHeadersHint =>
      'Avancé : pas encore relié via CLI. Réservé pour une version future.';

  @override
  String get lsLsApiBodyTemplateHint =>
      'Envoyé comme charge utile de test. L\'espace réservé device est remplacé côté serveur.';

  @override
  String lsLsApiBearerHintExisting(String token) {
    return 'Actuellement défini : $token. Laissez vide pour conserver, ou collez une nouvelle valeur pour écraser.';
  }

  @override
  String get lsLsApiBearerHintEmpty =>
      'Envoyé en tant que `Authorization: Bearer <token>`.';

  @override
  String get lsLsApiUpdateButton => 'Mettre à jour';

  @override
  String lsMailGroupsStatusFmt(int count, int max, int recipients) {
    return '$count sur $max · $recipients destinataires au total';
  }

  @override
  String lsMailGroupsReadFailedWith(String err) {
    return 'Échec de la lecture : $err';
  }

  @override
  String get lsMailGroupsNameValidation =>
      'Le nom doit comporter entre 1 et 47 caractères';

  @override
  String get lsMailGroupsNameSaved => 'Nom enregistré';

  @override
  String get lsMailGroupsSubjectValidation =>
      'L\'objet doit comporter au plus 127 caractères';

  @override
  String get lsMailGroupsSubjectSaved => 'Objet enregistré';

  @override
  String get lsMailGroupsBodyValidation =>
      'Le corps doit comporter au plus 511 caractères';

  @override
  String get lsMailGroupsBodySaved => 'Corps enregistré';

  @override
  String get lsMailGroupsEmailValidation => 'Saisissez un e-mail valide';

  @override
  String lsMailGroupsMaxReached(int max) {
    return 'Le maximum est de $max groupes';
  }

  @override
  String get lsMailGroupsNameEmpty => 'Le nom ne peut pas être vide';

  @override
  String get lsMailGroupsCreatedSnack => 'Groupe créé';

  @override
  String lsMailGroupsCreateFailedWith(String err) {
    return 'Échec de la création : $err';
  }

  @override
  String get lsMailGroupsDeleteDialogTitle => 'Supprimer le groupe ?';

  @override
  String get lsMailGroupsDeleteDialogBody =>
      'Cela supprime le groupe et tous ses destinataires sur l\'appareil.';

  @override
  String get lsMailGroupsDeleteConfirm => 'Supprimer';

  @override
  String get lsMailGroupsDeletedSnack => 'Groupe supprimé';

  @override
  String lsMailGroupsDefaultName(int n) {
    return 'Groupe $n';
  }

  @override
  String get lsMailGroupsNewGroupTitle => 'Nouveau groupe de messagerie';

  @override
  String get lsMailGroupsGroupNameLabel => 'Nom du groupe';

  @override
  String get lsMailGroupsCreateConfirm => 'Créer';

  @override
  String get lsMailGroupsEmptyHint =>
      'Aucun groupe pour l\'instant. Créez-en un pour envoyer un e-mail au déclenchement du minuteur.';

  @override
  String get lsMailGroupsWorkingButton => 'Traitement…';

  @override
  String get lsMailGroupsCreateNewButton => '+ Créer un nouveau groupe';

  @override
  String lsMailGroupsHeaderCount(int count, int max) {
    return '$count sur $max groupes configurés';
  }

  @override
  String lsMailGroupsHeaderTotalRecipients(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count destinataires au total',
      one: '1 destinataire au total',
    );
    return '· $_temp0';
  }

  @override
  String get lsMailGroupsUnnamed => '(sans nom)';

  @override
  String lsMailGroupsRowSummary(int count, String state) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count destinataires',
      one: '1 destinataire',
    );
    return '$_temp0 · $state';
  }

  @override
  String get lsMailGroupsEnabled => 'activé';

  @override
  String get lsMailGroupsDisabled => 'désactivé';

  @override
  String get lsMailGroupsNameLabel => 'Nom';

  @override
  String get lsMailGroupsSubjectLabel => 'Objet';

  @override
  String get lsMailGroupsSaveBodyButton => 'Enregistrer le corps';

  @override
  String get lsMailGroupsDeleteGroupButton => 'Supprimer le groupe';

  @override
  String lsMailGroupsRecipientsHeader(int count) {
    return 'Destinataires ($count)';
  }

  @override
  String get lsMailGroupsNoRecipients => 'Aucun destinataire pour l\'instant.';

  @override
  String get lsMailGroupsAddRecipientButton => 'Ajouter';

  @override
  String get lsHomeStatusLoading => 'Chargement…';

  @override
  String get lsHomeLogsTooltip => 'Journaux';

  @override
  String get lsHomeClusterConfiguration => 'CONFIGURATION';

  @override
  String get lsHomeClusterTriggerActions => 'ACTIONS DE DÉCLENCHEMENT';

  @override
  String get lsHomeClusterEarlyWarning => 'ALERTE PRÉCOCE';

  @override
  String get lsHomeSectionDurationTitle => 'Durée et alarmes';

  @override
  String get lsHomeSectionVacationTitle => 'Mode vacances';

  @override
  String get lsHomeSectionSmtpTitle => 'Configuration de la messagerie (SMTP)';

  @override
  String get lsHomeSectionResetApiTitle => 'Endpoint API de réinitialisation';

  @override
  String get lsHomeSectionMailGroupsTitle => 'Groupes de messagerie';

  @override
  String get lsHomeSectionRelayTitle => 'Relais';

  @override
  String get lsHomeSectionLsApiTitle => 'Webhook API LS';

  @override
  String get lsHomeSectionTelegramTitle => 'Telegram';

  @override
  String get lsHomeSectionReminderMailTitle => 'E-mail de rappel';

  @override
  String get lsHomeSectionAlarmApiTitle => 'Webhook API d\'alarme';

  @override
  String get lsHomeStateInactive => 'INACTIF';

  @override
  String get lsHomeStateRemaining => 'RESTANT';

  @override
  String get lsHomeStateVacation => 'VACANCES';

  @override
  String get lsHomeStateTriggered => 'DÉCLENCHÉ';

  @override
  String get lsHomeChipBle => 'BLE';

  @override
  String get lsHomeChipMail => 'E-mail';

  @override
  String get lsHomeEarlyWarningPendingNote =>
      'Les actions d\'alerte précoce se déclenchent sur timer.alarm. L\'abonné firmware est en attente ; ces configurations persistent mais ne se déclencheront pas encore automatiquement.';

  @override
  String get settingsDiagnosticsTitle => 'Diagnostics';

  @override
  String get settingsDiagnosticsSubtitle =>
      'Journaux pour aider à déboguer les problèmes';

  @override
  String get diagnosticsCopyLogs => 'Copier les journaux';

  @override
  String get diagnosticsOpenFolder => 'Ouvrir le dossier';

  @override
  String get diagnosticsOpenFolderFailed =>
      'Impossible d\'ouvrir le dossier des journaux.';

  @override
  String get diagnosticsShareLogs => 'Partager les journaux';

  @override
  String get diagnosticsClearLogs => 'Effacer les journaux';

  @override
  String get diagnosticsCopied => 'Journaux copiés dans le presse-papiers';

  @override
  String get diagnosticsCleared => 'Journaux effacés';

  @override
  String get aboutPrivacyLabel => 'Politique de confidentialité';

  @override
  String get updateChecking => 'Recherche de mises à jour…';

  @override
  String get updateUpToDate => 'Vous êtes sur la dernière version';

  @override
  String get updateCheckFailed => 'Impossible de vérifier les mises à jour';

  @override
  String get updateAvailableTitle => 'Mise à jour disponible';

  @override
  String updateAvailableBody(String version, String current) {
    return 'Une nouvelle version ($version) est disponible. Vous êtes sur $current.';
  }

  @override
  String get updateDownloadAction => 'Télécharger';

  @override
  String get updateLater => 'Plus tard';
}
