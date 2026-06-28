// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'SKAPP';

  @override
  String get brandTagline => 'SmartKraft';

  @override
  String get tabHome => 'Inicio';

  @override
  String get tabDevices => 'Dispositivos';

  @override
  String get tabSkapi => 'SKAPI';

  @override
  String get tabSettings => 'Ajustes';

  @override
  String get tabSmartKraft => 'SmartKraft';

  @override
  String get comingSoonBadge => 'próximamente';

  @override
  String get featureComingSoonSnack => 'Esta función llegará pronto';

  @override
  String get homeWelcome => 'Bienvenido a SmartKraft';

  @override
  String get homeSubtitle => 'Gestiona tus dispositivos SmartKraft';

  @override
  String get homeAddDevice => 'Añadir nuevo dispositivo';

  @override
  String get homeNoDevicesTitle => 'Aún no hay dispositivos';

  @override
  String get homeNoDevicesHint =>
      'Añade tu primer dispositivo SmartKraft para empezar.';

  @override
  String get homeSummaryTitle => 'Resumen';

  @override
  String homeDevicesOnline(int count) {
    return '$count conectados';
  }

  @override
  String homeDevicesOffline(int count) {
    return '$count desconectados';
  }

  @override
  String get homeUpdatesTitle => 'Actualizaciones disponibles';

  @override
  String homeUpdatesBody(int count) {
    return '$count dispositivo tiene un firmware más reciente.';
  }

  @override
  String get homeWarningsTitle => 'Avisos';

  @override
  String homeWarningsBody(int count) {
    return '$count dispositivo informó de un problema.';
  }

  @override
  String get homeAllGood => 'Todo funciona correctamente.';

  @override
  String get devicesTitle => 'Dispositivos';

  @override
  String get devicesEmpty =>
      'Aún no hay dispositivos.\nToca el botón + para añadir uno.';

  @override
  String get devicesAdd => 'Añadir dispositivo';

  @override
  String get devicesAllSection => 'Todos los dispositivos';

  @override
  String get devicesGroupsTitle => 'Tus grupos';

  @override
  String get devicesGroupsHint =>
      'Crea grupos para organizar tus dispositivos como quieras.';

  @override
  String get devicesGroupsCreate => 'Nuevo grupo';

  @override
  String get devicesGroupsEmpty => 'Aún no hay grupos.';

  @override
  String get skapiTitle => 'SKAPI';

  @override
  String get skapiLibraryHeading => 'Biblioteca SKAPI';

  @override
  String get skapiLibrarySubtitle =>
      'Elige la plataforma que activarán tus dispositivos.';

  @override
  String get skapiThisComputer => 'Este equipo';

  @override
  String skapiCategoryCount(int count) {
    return '$count categorías';
  }

  @override
  String get skapiPlatformMac => 'macOS';

  @override
  String get skapiPlatformWin => 'Windows';

  @override
  String get skapiPlatformLinux => 'Linux';

  @override
  String get skapiPlatformOther => 'Otra';

  @override
  String get skapiStarredHeading => 'API destacadas';

  @override
  String get skapiStarredEmpty =>
      'Marca plantillas de la biblioteca como favoritas y aparecerán aquí.';

  @override
  String get skapiContributeTitle =>
      'Envía tu biblioteca a la comunidad de SmartKraft';

  @override
  String get skapiContributeBody => 'Esta tarjeta se diseñará más adelante.';

  @override
  String get skapiSearchPlaceholder => 'Buscar acciones…';

  @override
  String get skapiSearchDisabledHint =>
      'Se activará cuando el analizador de SKAPI esté conectado.';

  @override
  String get skapiHelpButtonTooltip => 'Acerca de SKAPI';

  @override
  String get skapiHelpSheetTitle => 'Acerca de SKAPI';

  @override
  String get skapiHelpIntro =>
      'SKAPI es una biblioteca de acciones que tus dispositivos SmartKraft pueden activar en tu equipo.';

  @override
  String get skapiHelpStep1Title => 'Explora una plantilla';

  @override
  String get skapiHelpStep1Body =>
      'Elige un punto de partida en la biblioteca SKAPI.';

  @override
  String get skapiHelpStep2Title => 'Configura';

  @override
  String get skapiHelpStep2Body =>
      'Define los parámetros y elige qué dispositivo la activa.';

  @override
  String get skapiHelpStep3Title => 'Envía al dispositivo';

  @override
  String get skapiHelpStep3Body =>
      'El dispositivo guarda el disparador de la API; SKAPP ejecuta el script.';

  @override
  String get skapiHelpGlossaryTitle => 'Glosario';

  @override
  String get skapiHelpGlossaryTemplate =>
      'Plantilla: una entrada de solo lectura de la biblioteca';

  @override
  String get skapiHelpGlossaryAction =>
      'Acción: un par configurado de disparador de API + script';

  @override
  String get skapiHelpGlossaryApiTrigger =>
      'Disparador de API: lo que llama el dispositivo';

  @override
  String get skapiHelpGlossaryScript => 'Script: lo que ejecuta tu equipo';

  @override
  String get skapiHelpPhase1Notice =>
      'SKAPI todavía se está desarrollando. La mayor parte de esta pestaña es un esqueleto; las secciones marcadas como \'aún no activo\' se habilitarán cuando lleguen el analizador, el receptor y el generador de formularios.';

  @override
  String get skapiMobileBannerBody =>
      'Este teléfono no puede ser un destino. Para ejecutar acciones, SKAPP debe estar abierto en tu equipo.';

  @override
  String get skapiActionsHeading => 'Mis acciones';

  @override
  String get skapiActionsNoDevicesTitle => 'Aún no hay dispositivos';

  @override
  String get skapiActionsNoDevicesBody =>
      'Empareja primero un dispositivo SmartKraft; ve a la pestaña Dispositivos.';

  @override
  String get skapiActionsCreationDisabled =>
      'La creación de acciones aún no está activa.';

  @override
  String get skapiActionsOfflineDetectionDisabled =>
      'Detección de conexión aún no activa';

  @override
  String get skapiActionsMaxLimitNote => 'Hasta 5 acciones por dispositivo.';

  @override
  String get skapiActionsAddCta => 'Añadir acción';

  @override
  String skapiHeaderSub(int platforms, int actions) {
    return '$platforms plataformas · $actions acciones';
  }

  @override
  String get skapiNewActionPill => 'Nueva acción';

  @override
  String skapiActionsSubLine(int count) {
    return 'vínculos dispositivo × script · $count activos';
  }

  @override
  String get skapiActionsEmptyHint =>
      'Aún no hay acciones. Vincula qué ocurre al pulsar un botón del dispositivo.';

  @override
  String get skapiActionsCreateCta => 'Crear';

  @override
  String skapiActionsGroupTitle(String name) {
    return 'Acciones de $name';
  }

  @override
  String skapiActionsGroupCount(int count) {
    return '$count';
  }

  @override
  String get skapiListenerEndpointTitle =>
      'URL de webhook enviada a los dispositivos BF';

  @override
  String get skapiListenerEndpointBody =>
      'Si un BF en la misma Wi-Fi no puede alcanzar esta URL tras la cuenta atrás, la NIC elegida en tu portátil puede ser incorrecta (p. ej., red WSL/VirtualBox/Docker). Toca Actualizar para reenviarla.';

  @override
  String get skapiListenerEndpointResolving => 'Resolviendo IP local…';

  @override
  String get skapiListenerEndpointUnavailable =>
      'No se encontró ninguna interfaz LAN utilizable.';

  @override
  String get skapiListenerEndpointRefresh => 'Actualizar';

  @override
  String get skapiListenerEndpointRefreshing => 'Enviando…';

  @override
  String skapiListenerEndpointPushedAt(String when) {
    return 'Última actualización: $when';
  }

  @override
  String get skapiListenerSelfTest => 'Autoprueba';

  @override
  String get skapiListenerSelfTestRunning => 'Probando…';

  @override
  String get skapiListenerSelfTestPassed =>
      'Autoprueba correcta: el receptor es accesible desde este host.';

  @override
  String get skapiListenerSelfTestFailed =>
      'Autoprueba FALLIDA: el receptor no es accesible. Comprueba el Firewall de Windows.';

  @override
  String get skapiWebhookActivityTitle => 'Webhooks recientes';

  @override
  String get skapiWebhookActivityNone =>
      'Aún no se han recibido webhooks. Cuando expire el temporizador del dispositivo, debería aparecer una entrada aquí en segundos.';

  @override
  String get skapiWebhookActivityAccepted => 'Aceptado';

  @override
  String skapiWebhookActivityRejected(int code) {
    return 'Rechazado ($code)';
  }

  @override
  String get skapiWebhookActivityMalformed => 'Con formato incorrecto';

  @override
  String get skapiWebhookActivitySelfTest => 'Autoprueba';

  @override
  String get skapiWebhookActivityNoMatch => 'Ningún vínculo coincidió';

  @override
  String get skapiWebhookActivityScriptError => 'Error del script';

  @override
  String skapiWebhookActivityMatched(int count) {
    return '$count script(s) ejecutado(s)';
  }

  @override
  String get skapiBfEndpointsButton => 'Inspeccionar endpoints BF';

  @override
  String get skapiBfEndpointsTitle =>
      'Endpoints almacenados en dispositivos BF';

  @override
  String get skapiBfEndpointsHint =>
      'Instantánea de solo lectura de api.endpoint.list de cada dispositivo emparejado. Compara la URL de cada ranura SYSTEM con la URL del receptor de arriba. Deben coincidir exactamente. Las ranuras USER pueden pertenecer a webhooks manuales y podrían capturar tu cuenta atrás si están mal configuradas.';

  @override
  String get skapiBfEndpointsLoading => 'Consultando dispositivos BF…';

  @override
  String get skapiBfEndpointsErrorPrefix => 'Consulta fallida:';

  @override
  String get skapiBfEndpointsKindSystem => 'SYSTEM';

  @override
  String get skapiBfEndpointsKindUser => 'USER';

  @override
  String get skapiBfEndpointsEmpty =>
      'No hay endpoints almacenados en este dispositivo.';

  @override
  String get skapiBfEndpointsClose => 'Cerrar';

  @override
  String get skapiBfEndpointsRefresh => 'Reconsultar';

  @override
  String skapiStarredCount(int count) {
    return '$count destacadas';
  }

  @override
  String get skapiStarredSlimEmpty =>
      'Marca entradas de la biblioteca como favoritas para reunir aquí las más usadas.';

  @override
  String get skapiCommunityShareTitle =>
      'Comparte tu biblioteca con la comunidad de SmartKraft';

  @override
  String get skapiCommunityShareBody =>
      'Los scripts que escribes quedan disponibles para todos en la biblioteca SKAPI.';

  @override
  String get settingsNetworkIdentityTitle => 'Identidad de red';

  @override
  String get settingsNetworkIdentityName => 'Nombre del equipo';

  @override
  String get settingsNetworkIdentityNameHint =>
      'Se usa como nombre de instancia mDNS';

  @override
  String get settingsNetworkIdentityNameEdit => 'Cambiar nombre';

  @override
  String get settingsNetworkIdentityNameDialogTitle =>
      'Cambiar el nombre de este equipo';

  @override
  String get settingsNetworkIdentityNameDialogHelp =>
      'Letras minúsculas, números y guiones. Hasta 32 caracteres.';

  @override
  String get settingsNetworkIdentityUuid => 'ID del dispositivo';

  @override
  String get settingsNetworkIdentityPort => 'Puerto del receptor';

  @override
  String get settingsNetworkIdentityPortDialogTitle => 'Puerto del receptor';

  @override
  String get settingsNetworkIdentityToken => 'Token Bearer';

  @override
  String get settingsNetworkIdentityRegenerateToken => 'Regenerar token';

  @override
  String get settingsNetworkIdentityRegenerateConfirmTitle =>
      '¿Regenerar el token Bearer?';

  @override
  String get settingsNetworkIdentityRegenerateConfirmBody =>
      'Los dispositivos existentes deberán emparejarse de nuevo con el nuevo token.';

  @override
  String get settingsNetworkIdentityServerNotRunning =>
      'El servidor aún no está en ejecución; se activará en la Fase 2.';

  @override
  String get settingsNetworkIdentityCopy => 'Copiar';

  @override
  String get settingsNetworkIdentityCopied => 'Copiado';

  @override
  String get settingsNetworkIdentityStaticIpHint =>
      'Consejo: una reserva DHCP (IP estática) en tu router hace que las conexiones sean más fiables.';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsSectionAppearance => 'Apariencia';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageSystemHint => 'Seguir el idioma del sistema';

  @override
  String get settingsLanguagePickerAllSection => 'Todos los idiomas';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDark => 'Oscuro';

  @override
  String get settingsThemeSystem => 'Sistema';

  @override
  String get settingsSectionAbout => 'Acerca de';

  @override
  String get settingsVersion => 'Versión';

  @override
  String get settingsDeveloper => 'Desarrollador';

  @override
  String get settingsDeveloperName => 'SmartKraft';

  @override
  String get settingsOpenAbout => 'Acerca de SKAPP';

  @override
  String get settingsSectionAdvanced => 'Avanzado';

  @override
  String get settingsDeveloperMode => 'Modo de desarrollador';

  @override
  String get settingsDeveloperToolsTitle => 'Herramientas de desarrollador';

  @override
  String get settingsDeveloperToolsSubtitle =>
      'Consola USB, identidad de red, receptor, tokens, registros';

  @override
  String get settingsDeveloperModeInfoTitle =>
      '¿Qué desbloquea el modo de desarrollador?';

  @override
  String get settingsDeveloperModeInfoIntro =>
      'Este modo muestra funciones avanzadas ocultas en la interfaz predeterminada. Tres casos de uso principales:';

  @override
  String get settingsDeveloperModeUseCaseCliTitle => 'Consola CLI';

  @override
  String get settingsDeveloperModeUseCaseCliBody =>
      'Configura tus dispositivos por cable USB sin establecer primero una conexión BLE o WiFi.';

  @override
  String get settingsDeveloperModeUseCaseSkapiTitle => 'Editor de código SKAPI';

  @override
  String get settingsDeveloperModeUseCaseSkapiBody =>
      'Abre y modifica scripts integrados, o escribe los tuyos desde cero.';

  @override
  String get settingsDeveloperModeUseCaseMobileTitle =>
      'Activación remota desde el móvil';

  @override
  String get settingsDeveloperModeUseCaseMobileBody =>
      'Ejecuta los vínculos SKAPI de este equipo desde un SKAPP móvil emparejado.';

  @override
  String get settingsDeveloperModeInfoSurfacesHeader =>
      'Tarjetas adicionales de Ajustes que aparecen cuando está activado:';

  @override
  String get settingsDeveloperModeInfoItem1 =>
      'Tarjeta de identidad de red: edita UUID, puerto y token Bearer; copia o regenera el secreto de instalación de SKAPP.';

  @override
  String get settingsDeveloperModeInfoItem2 =>
      'Controles del receptor HTTP local: iniciar/detener, emparejamiento por QR, rotación de certificado TLS, visibilidad en LAN.';

  @override
  String get settingsDeveloperModeInfoItem3 =>
      'Lista de tokens por par: ve cada SKAPP móvil emparejado y revócalos individualmente.';

  @override
  String get settingsDeveloperModeInfoItem4 =>
      'Consola CLI USB (solo escritorio): línea de comandos NDJSON sin procesar hacia un dispositivo SmartKraft conectado por USB.';

  @override
  String get settingsDeveloperModeInfoNotPaid =>
      'No es una mejora de pago. SKAPP es de un solo nivel y gratuita; este interruptor solo oculta funciones avanzadas de forma predeterminada para mantener las cosas simples. Los dispositivos SmartKraft funcionan con independencia de este ajuste.';

  @override
  String get settingsSectionConnectivity => 'Conectividad';

  @override
  String get settingsBluetoothStatus => 'Bluetooth';

  @override
  String get settingsBluetoothStatusOn => 'Listo';

  @override
  String get settingsBluetoothStatusOff => 'Desactivado';

  @override
  String get settingsBluetoothStatusTurningOn => 'Activando…';

  @override
  String get settingsBluetoothStatusTurningOff => 'Desactivando…';

  @override
  String get settingsBluetoothStatusUnauthorized => 'Sin permiso';

  @override
  String get settingsBluetoothStatusUnsupported => 'No compatible';

  @override
  String get settingsBluetoothStatusUnknown => 'Comprobando…';

  @override
  String get settingsNetworkStatus => 'Red';

  @override
  String get settingsWifiStatusConnected => 'Wi-Fi';

  @override
  String get settingsWifiStatusEthernet => 'Ethernet';

  @override
  String get settingsWifiStatusMobile => 'Datos móviles';

  @override
  String get settingsWifiStatusDisconnected => 'Desconectado';

  @override
  String get settingsWifiStatusUnknown => 'Comprobando…';

  @override
  String get settingsWifiHint => 'Se usa tras el emparejamiento inicial.';

  @override
  String get settingsBluetoothPermissions => 'Permisos';

  @override
  String get settingsBluetoothPermissionsHint =>
      'Acceso a Bluetooth y ubicación';

  @override
  String get settingsBluetoothGrantPermission => 'Conceder acceso';

  @override
  String get settingsOpenSystemSettings => 'Abrir ajustes del sistema';

  @override
  String get settingsSectionUpdates => 'Actualizaciones';

  @override
  String get settingsCheckUpdates => 'Buscar actualizaciones';

  @override
  String get settingsAutoCheckUpdates => 'Comprobar al iniciar';

  @override
  String get settingsAutoCheckUpdatesHint =>
      'Verifica que tienes la última versión cada vez que se abre SKAPP.';

  @override
  String get settingsUpdateChannel => 'Canal de actualización';

  @override
  String get settingsUpdateChannelStable => 'Estable';

  @override
  String get settingsUpdateChannelBeta => 'Beta';

  @override
  String get settingsUpdateChannelBetaHint =>
      'Recibe nuevas funciones antes. Puede ser menos estable.';

  @override
  String get settingsUpToDate => 'Tienes la última versión.';

  @override
  String get settingsUpdateCheckPlaceholder =>
      'La comprobación de actualizaciones se conectará en la Fase 3.';

  @override
  String get settingsSectionLegal => 'Aspectos legales';

  @override
  String get settingsLicense => 'Licencia y agradecimientos';

  @override
  String get settingsSectionInfo => 'Información';

  @override
  String get settingsThemeCycleHint => 'Toca para cambiar';

  @override
  String get settingsChannelCycleHint => 'Toca para cambiar';

  @override
  String get settingsSectionThisNode => 'Este nodo';

  @override
  String get settingsNodeNameTitle => 'Nombre del nodo SKAPP';

  @override
  String settingsNodeNameSub(String name) {
    return '$name · otros SKAPP ven este nombre · difusión mDNS';
  }

  @override
  String get settingsSectionDanger => 'Zona de peligro';

  @override
  String get settingsResetPairings => 'Restablecer emparejamientos';

  @override
  String get settingsResetPairingsSub =>
      'Elimina todos los dispositivos emparejados; se conservan ajustes/idioma/nombre del nodo';

  @override
  String get settingsFactoryReset => 'Restablecimiento de fábrica';

  @override
  String get settingsFactoryResetSub => 'Todo se borra, irreversible';

  @override
  String get settingsSectionAdvancedNetwork => 'Red avanzada';

  @override
  String get settingsResetPairingsConfirmTitle =>
      '¿Restablecer todos los emparejamientos?';

  @override
  String settingsResetPairingsConfirmBody(int paired, int bindings, int peers) {
    return 'Se eliminarán $paired dispositivo(s) emparejado(s), $bindings acción(es) SKAPI y $peers par(es) SKAPP. Se conservan tus ajustes, tema, idioma y notas. Los dispositivos mantienen su vínculo por su parte; para desemparejar por completo, restablece el dispositivo manualmente. Esto no se puede deshacer.';
  }

  @override
  String get settingsResetPairingsConfirmAction => 'Restablecer';

  @override
  String get settingsFactoryResetConfirmTitle =>
      '¿Restablecimiento de fábrica?';

  @override
  String get settingsFactoryResetConfirmBody =>
      'Se borrará todo: todos los emparejamientos, ajustes, tema, idioma, notas, identidad de red, certificado TLS y la entrada de inicio automático. SKAPP vuelve al estado de primer arranque. Esto no se puede deshacer.';

  @override
  String get settingsFactoryResetConfirmAction => 'Borrar todo';

  @override
  String get settingsFactoryResetSecondConfirmTitle =>
      '¿Estás totalmente seguro?';

  @override
  String get settingsFactoryResetSecondConfirmBody =>
      'Escribe ERASE para confirmar.';

  @override
  String get settingsFactoryResetSecondConfirmHint => 'ERASE';

  @override
  String get settingsFactoryResetSecondConfirmAction => 'Lo entiendo. Borrar.';

  @override
  String get settingsResetInProgress => 'Restableciendo…';

  @override
  String get settingsResetDoneTitle => 'Restablecimiento completado';

  @override
  String get settingsResetDoneWithWarnings =>
      'Restablecimiento completado (con avisos)';

  @override
  String settingsResetSummaryPaired(int count) {
    return '$count dispositivo(s) emparejado(s) eliminado(s)';
  }

  @override
  String settingsResetSummaryBindings(int count) {
    return '$count acción(es) SKAPI eliminada(s)';
  }

  @override
  String settingsResetSummaryPeers(int count) {
    return '$count par(es) SKAPP eliminado(s)';
  }

  @override
  String settingsResetSummaryBonds(int count) {
    return '$count vínculo(s) de dispositivo borrado(s)';
  }

  @override
  String get settingsResetSummaryNetworkIdentity =>
      'Identidad de red restablecida a los valores predeterminados';

  @override
  String get settingsResetSummaryTlsCert => 'Certificado TLS borrado';

  @override
  String get settingsResetSummaryAutostart =>
      'Entrada de inicio automático eliminada';

  @override
  String get settingsResetSummaryWarningHeader => 'Avisos:';

  @override
  String get settingsResetRestartHint =>
      'Reinicia SKAPP para aplicar los cambios por completo.';

  @override
  String get settingsResetRestartNow => 'Reiniciar ahora';

  @override
  String get settingsResetClose => 'Cerrar';

  @override
  String settingsFooterCombined(String version, String node) {
    return 'SKAPP $version · $node';
  }

  @override
  String get langEnglish => 'English';

  @override
  String get langTurkish => 'Türkçe';

  @override
  String get aboutTitle => 'Acerca de SmartKraft y SKAPP';

  @override
  String get aboutDevicesHeading => 'Nuestros dispositivos';

  @override
  String get aboutDevicesBody =>
      'Los dispositivos SmartKraft están diseñados para ser innovadores, distintivos y para incluir detalles que otros no han pensado. Nuestro objetivo no es reproducir lo que ya existe; es hacer lo que no se ha hecho, lo que se ha quedado sin hacer. Señalar un problema cotidiano sin resolver y darle una respuesta simple y comprensible; o tomar algo que ya está resuelto pero que sigue siendo caro, y poner en su lugar una versión DIY que todos puedan construir.\n\nCada dispositivo SmartKraft se diseña y se construye para dar una respuesta pequeña y sencilla a un problema que aún no se ha resuelto. Al diseñar un dispositivo, nos hacemos una sola pregunta: \"¿Por qué no se ha resuelto este problema hasta ahora, o por qué ha seguido siendo tan caro?\"';

  @override
  String get aboutSkappRoleHeading => 'Dónde encaja SKAPP';

  @override
  String get aboutSkappRoleBody =>
      'SKAPP es la aplicación común para los dispositivos SmartKraft. Es una interfaz de usuario sencilla para emparejar un dispositivo, configurarlo, cambiar su comportamiento y reunir varios dispositivos en un único escenario.\n\nSKAPP no es necesaria para tus dispositivos; es una comodidad. Cada dispositivo SmartKraft puede configurarse de la misma manera por USB CLI sin SKAPP, y esa vía permanece abierta para quienes prefieren la línea de comandos. Para todos los demás que quieran la rapidez de una interfaz visual y la comodidad de gestionar varios dispositivos a la vez, SKAPP está aquí.\n\nSin cuenta en la nube. Sin publicidad. Sin recopilación de datos. Es un puente silencioso entre tu teléfono y tu dispositivo, nada más.';

  @override
  String get aboutShowcaseHeading => 'Vitrina de creadores';

  @override
  String get aboutShowcaseEmpty =>
      'La vitrina está vacía por ahora. El primer dispositivo SmartKraft está en camino; los archivos de diseño, las fuentes del firmware, las listas de piezas y las guías de montaje se listarán aquí cuando estén listos. Hasta entonces, esta sección no promete mucho, solo reserva un espacio para lo que está por venir.';

  @override
  String get aboutConnectHeading => 'Contacto';

  @override
  String get aboutConnectIntro =>
      'Envía un mensaje, mira el código fuente, sigue el trabajo a medida que crece.';

  @override
  String get aboutConnectGitHub => 'GitHub';

  @override
  String get aboutConnectWebsite => 'Sitio web';

  @override
  String get aboutConnectYouTube => 'YouTube';

  @override
  String get aboutConnectX => 'X';

  @override
  String get aboutConnectEmail => 'Correo electrónico';

  @override
  String get aboutVersionHeading => 'Versión';

  @override
  String get licenseTitle => 'Licencia y agradecimientos';

  @override
  String get licenseSmartKraftHeading => 'Acerca de SmartKraft';

  @override
  String get licenseSmartKraftBody =>
      'SmartKraft es un pequeño taller que diseña herramientas electrónicas inusuales pero prácticas para la vida cotidiana. Detrás de cada dispositivo que llega a tus manos hay innumerables pasos: un primer boceto en un cuaderno, un primer prototipo soldado, líneas de código escritas de madrugada, pequeños detalles reintentados una y otra vez. Construir un dispositivo significa escribir líneas, dibujar circuitos, soldar uniones, encontrar errores, empezar de nuevo. A todos los que han puesto su esfuerzo en este proceso sin dejar su nombre en él, gracias, en nombre de SmartKraft.\n\nCreemos en la cultura maker, en el código abierto y en una electrónica reparable y reciclable. Por eso publicamos los diseños de hardware de nuestros dispositivos como hardware abierto, y su firmware bajo AGPL 3.0. Nuestro objetivo es hacer accesible una versión DIY de tantas partes como sea posible.\n\nUna nota que queremos compartir con honestidad: las claves de emparejamiento y los secretos de comunicación que protegen la seguridad de un dispositivo se mantienen privados en el código fuente. Si se publicaran, se rompería la confianza entre tu dispositivo y la aplicación. Este cierre no es una concesión contra la apertura; es una decisión tomada por tu seguridad.\n\nPara SKAPP y cada dispositivo que se comunica con ella, nuestro principio es la transparencia: queremos que puedas leer cómo funcionan las cosas, auditarlas y construir tu propia versión. Aun así, cada dispositivo tiene su propia sección de licencia y los términos pueden variar. Para ver el código fuente, los esquemas o las condiciones de uso de un dispositivo, consulta el área de licencia propia de ese dispositivo.\n\nGracias por apoyarnos usando esta aplicación. Nos alegra que estés aquí.';

  @override
  String get licenseOpenSourceHeading => 'A hombros de gigantes';

  @override
  String get licenseOpenSourceBody =>
      'SKAPP está construida sobre miles de proyectos de código abierto escritos antes que ella. Un agradecimiento sincero al equipo de Flutter y a sus colaboradores por hacer posible la interfaz visible, y a todos los desarrolladores de código abierto que han dedicado años a las redes, el almacenamiento, la criptografía, el Bluetooth y a incontables subsistemas.\n\nPorque nos beneficiamos del código abierto, intentamos mantener también abiertos el hardware y el firmware de nuestros propios dispositivos, para que quienes vengan después puedan beneficiarse de este trabajo de la misma manera.\n\nGracias de nuevo a todos los que han formado parte de este esfuerzo.';

  @override
  String get licenseThirdPartyLink =>
      'Licencias de terceros usadas en esta aplicación';

  @override
  String get discoveryTitle => 'Buscar dispositivos';

  @override
  String get discoverySearching => 'Buscando dispositivos SmartKraft cercanos…';

  @override
  String get discoveryNoResults =>
      'No se encontraron dispositivos SmartKraft cerca.';

  @override
  String get discoveryTapToConnect => 'Toca un dispositivo para conectarte';

  @override
  String get discoveryRescan => 'Buscar de nuevo';

  @override
  String get pairingTitle => 'Emparejar dispositivo';

  @override
  String get pairingEnterPasskey =>
      'Introduce la clave de acceso impresa en la etiqueta del dispositivo.';

  @override
  String get pairingPasskeyHint => 'p. ej. K7M9P2AB';

  @override
  String get pairingConnect => 'Conectar';

  @override
  String get pairingMockNotice =>
      'El firmware del dispositivo aún no está listo. El emparejamiento es un marcador de posición en esta compilación.';

  @override
  String get errorBluetoothPermission =>
      'Se requiere permiso de Bluetooth para buscar dispositivos.';

  @override
  String get errorBluetoothOff => 'El Bluetooth está desactivado.';

  @override
  String get errorLocationPermission =>
      'Se requiere permiso de ubicación para buscar dispositivos BLE en Android.';

  @override
  String get actionOpenSettings => 'Abrir ajustes';

  @override
  String get actionGrantPermission => 'Conceder permiso';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonConfirm => 'Confirmar';

  @override
  String get commonRetry => 'Reintentar';

  @override
  String get commonBack => 'Atrás';

  @override
  String get commonRemove => 'Eliminar';

  @override
  String get commonRefresh => 'Actualizar';

  @override
  String get commonOk => 'Aceptar';

  @override
  String get commonClose => 'Cerrar';

  @override
  String get commonSave => 'Guardar';

  @override
  String get commonDelete => 'Eliminar';

  @override
  String get commonConnect => 'Conectar';

  @override
  String get commonAdd => 'Añadir';

  @override
  String get commonForget => 'Olvidar';

  @override
  String get commonMore => 'Más';

  @override
  String get commonError => 'Error';

  @override
  String get commonOnline => 'conectado';

  @override
  String get commonOffline => 'desconectado';

  @override
  String get productBlockingFocus => 'Blocking Focus';

  @override
  String get productLebensSpur => 'LebensSpur';

  @override
  String get productGeneric => 'Dispositivo SmartKraft';

  @override
  String get timeJustNow => 'justo ahora';

  @override
  String timeMinAgo(int count) {
    return 'hace $count min';
  }

  @override
  String timeHourAgo(int count) {
    return 'hace $count h';
  }

  @override
  String timeDayAgo(int count) {
    return 'hace $count d';
  }

  @override
  String get devicesRemoveTitle => 'Eliminar dispositivo';

  @override
  String devicesRemoveBody(String name) {
    return 'Se eliminará $name. El dispositivo sigue conectado; para volver a añadirlo tendrás que emparejarlo de nuevo.';
  }

  @override
  String get devicesUnpair => 'Desemparejar';

  @override
  String get devicesEmptyHint =>
      'Acerca tu dispositivo SmartKraft y toca el botón de abajo.';

  @override
  String get devicesEmptyTitleNoPaired => 'Aún no hay dispositivos emparejados';

  @override
  String devicesLastSeen(String time) {
    return 'Visto por última vez: $time';
  }

  @override
  String devicesPairedAt(String time) {
    return 'Emparejado: $time';
  }

  @override
  String devicesHubSubtitle(int count) {
    return 'Host SKAPP · $count emparejados';
  }

  @override
  String get devicesHubEmptySubtitle => 'esperando dispositivo';

  @override
  String devicesHeaderSub(int paired, int online) {
    return '$paired emparejados · $online en línea · vista de constelación';
  }

  @override
  String get devicesAddPillLabel => 'Añadir dispositivo';

  @override
  String devicesLegendOnline(int count) {
    return 'en línea ($count)';
  }

  @override
  String devicesLegendOffline(int count) {
    return 'desconectados ($count)';
  }

  @override
  String devicesLegendLowBattery(int count) {
    return 'batería baja ($count)';
  }

  @override
  String get devicesStatPaired => 'emparejados';

  @override
  String get devicesStatBf => 'BF';

  @override
  String get devicesStatLs => 'LS';

  @override
  String get devicesStatMs => 'teléfono';

  @override
  String get devicesEmptyHubLabel => 'Desconocido';

  @override
  String get devicesEmptyAddCta => 'Añadir primer dispositivo';

  @override
  String get devicesEmptyHintChip => 'acerca el dispositivo, pulsa su botón';

  @override
  String devicesNotifOfflineHours(int hours) {
    return 'desconectado hace $hours h';
  }

  @override
  String devicesNotifOfflineMinutes(int minutes) {
    return 'desconectado hace $minutes min';
  }

  @override
  String get devicesNotifLowBattery => 'batería baja';

  @override
  String get skappPeersCardTitle => 'SKAPP de escritorio emparejados';

  @override
  String get skappPeersCardSubtitle =>
      'Los teléfonos y tabletas se emparejan aquí para que una acción de BF pueda ejecutar un script en un SKAPP de escritorio. Abre SKAPP de escritorio > Ajustes > Receptor HTTP de SKAPP para obtener un QR.';

  @override
  String get skappPeersCardEmpty => 'Aún no hay ningún par emparejado.';

  @override
  String get skappPeersCardPairButton => 'Emparejar nuevo';

  @override
  String get skappPeersCardOnline => 'en línea';

  @override
  String get skappPeersCardOffline => 'desconectado';

  @override
  String get skappPeersCardNeverSeen => 'nunca visto';

  @override
  String skappPeersCardRemoveTitle(String name) {
    return '¿Eliminar $name?';
  }

  @override
  String get skappPeersCardRemoveBody =>
      'SKAPP dejará de enviar scripts a este par. Puedes volver a emparejarlo con el mismo QR / token más adelante.';

  @override
  String get skappPeersCardRemoveConfirm => 'Eliminar';

  @override
  String get skappPeersCardRemoveCancel => 'Cancelar';

  @override
  String skappPeersCardRemovedToast(String name) {
    return '$name desemparejado';
  }

  @override
  String get devicesCardLongPressHint => 'Mantén pulsado para gestionar';

  @override
  String devicesActionsSheetTitle(String name) {
    return '$name';
  }

  @override
  String get devicesActionForget => 'Olvidar dispositivo';

  @override
  String get devicesActionForgetSubtitle =>
      'Elimina este dispositivo de SKAPP. El dispositivo en sí no se ve afectado; puedes emparejarlo de nuevo más adelante.';

  @override
  String get devicesActionCancel => 'Cancelar';

  @override
  String devicesForgetDialogTitle(String name) {
    return '¿Olvidar $name?';
  }

  @override
  String get devicesForgetDialogBody =>
      'SKAPP dejará de hacer seguimiento de este dispositivo. El emparejamiento del lado del dispositivo se mantiene hasta que lo restablezcas desde el dispositivo.';

  @override
  String devicesForgetDialogBodyWithActions(int count) {
    return 'SKAPP dejará de hacer seguimiento de este dispositivo y eliminará $count acción(es) SKAPI vinculada(s) a él. El emparejamiento del lado del dispositivo se mantiene hasta que lo restablezcas desde el dispositivo.';
  }

  @override
  String get devicesForgetDialogConfirm => 'Olvidar';

  @override
  String get devicesForgetDialogCancel => 'Cancelar';

  @override
  String devicesForgotToast(String name) {
    return '$name eliminado de SKAPP';
  }

  @override
  String get devicesMobileNoDetailHint =>
      'No hay página de detalles para teléfonos · mantén pulsado para desemparejar';

  @override
  String get devicesDesktopStatLabel => 'escritorio';

  @override
  String get devicesDesktopGroupLabel => 'Equipos de escritorio emparejados';

  @override
  String get devicesDesktopTriggerDialogTitle => '¿Enviar un comando SKAPI?';

  @override
  String devicesDesktopTriggerDialogBody(String name) {
    return 'Se ejecutarán todos los vínculos de toque móvil de $name.';
  }

  @override
  String get devicesDesktopTriggerDialogConfirm => 'Enviar comando';

  @override
  String get devicesDesktopTriggerDialogCancel => 'Cancelar';

  @override
  String get devicesDesktopForgetDialogTitle => 'Desemparejar';

  @override
  String devicesDesktopForgetDialogBody(String name) {
    return 'Desemparejando $name. Tendrás que emparejarlo de nuevo para volver a enviar comandos a este equipo de escritorio.';
  }

  @override
  String devicesDesktopForgotToast(String name) {
    return '$name desemparejado';
  }

  @override
  String get homeStatDevices => 'Dispositivos';

  @override
  String get homeStatOnline => 'En línea';

  @override
  String get homeStatWarning => 'Aviso';

  @override
  String homeWarningMeta(String time) {
    return 'Emparejado pero nunca visto · $time';
  }

  @override
  String get homeBrandTotal => 'Total';

  @override
  String get homeBrandActive => 'Activos';

  @override
  String get homeBrandActions => 'Acciones';

  @override
  String get homeBrandVersion => 'Versión';

  @override
  String get smartkraftSectionProducts => 'Productos';

  @override
  String get smartkraftSectionCommunity => 'Comunidad';

  @override
  String get smartkraftStatusLive => 'EN VIVO';

  @override
  String get smartkraftStatusDev => 'EN DESARROLLO';

  @override
  String get smartkraftStatusConcept => 'CONCEPTO';

  @override
  String get smartkraftBlockingFocusTagline =>
      'La pausa de la que no puedes escapar.';

  @override
  String get smartkraftLebensSpurTagline =>
      'Un testigo silencioso de tus hábitos.';

  @override
  String get smartkraftSynDimmTagline => 'La luz adecuada a la hora adecuada.';

  @override
  String homeStickyDevicesMeta(int count, int warning) {
    return '$count dispositivos · $warning alertas';
  }

  @override
  String homeStickySkapiMeta(int actions) {
    return '$actions acciones';
  }

  @override
  String homeStickySettingsMeta(String node, String version) {
    return '$node · v$version';
  }

  @override
  String get homeStickyComingSoonMeta => 'contenido en preparación';

  @override
  String get homeStickyNotesLabel => 'Notas';

  @override
  String get setupChoiceTitle => 'Añadir dispositivo';

  @override
  String get setupChoiceQuestion => '¿En qué punto estamos?';

  @override
  String get setupChoiceSubtitle =>
      '¿El dispositivo es nuevo de fábrica o se ha configurado antes mediante CLI?';

  @override
  String get setupChoiceFreshTitle => 'Configuración nueva';

  @override
  String get setupChoiceFreshBody =>
      'Estoy añadiendo un dispositivo SmartKraft nuevo por primera vez. El emparejamiento se hará por BLE y se abrirá el asistente de configuración WiFi.';

  @override
  String get setupChoiceExistingTitle => 'Añadir un dispositivo ya configurado';

  @override
  String get setupChoiceExistingBody =>
      'Configuré la WiFi de mi dispositivo por USB/CLI y estoy en la misma red. Empareja directamente por WiFi y omite el asistente.';

  @override
  String get setupChoiceFooter =>
      'En caso de duda, elige \"Configuración nueva\"; es la opción correcta tanto para el primer emparejamiento como para dispositivos restablecidos de fábrica.';

  @override
  String get wifiDiscoveryTitle => 'Dispositivos en esta red';

  @override
  String wifiDiscoveryScanError(String error) {
    return 'Error de búsqueda: $error';
  }

  @override
  String get wifiDiscoveryHint =>
      'El dispositivo debe estar en WiFi y el teléfono en la misma red. Se te pedirá que pulses el botón del dispositivo durante el emparejamiento.';

  @override
  String get wifiDiscoveryScanning => 'Buscando…';

  @override
  String get wifiDiscoveryNotFound => 'No se encontraron dispositivos';

  @override
  String wifiDiscoveryFoundCount(int count) {
    return '$count dispositivo(s) encontrado(s)';
  }

  @override
  String get wifiDiscoveryEmptyTitle =>
      'Buscando dispositivos SmartKraft en esta red…';

  @override
  String get wifiDiscoveryEmptyTitleIdle => 'No se encontraron dispositivos.';

  @override
  String get wifiDiscoveryEmptyHint =>
      'Asegúrate de que el dispositivo está encendido, conectado a WiFi y en la misma red que tu teléfono. Usa el botón de actualizar para reintentar.';

  @override
  String get wifiDiscoveryPairedBadge => 'emparejado';

  @override
  String get wifiPairingTitle => 'Emparejamiento';

  @override
  String wifiPairingConnectFailed(String error) {
    return 'No se pudo conectar: $error';
  }

  @override
  String wifiPairingInvalidJson(String error) {
    return 'JSON no válido: $error';
  }

  @override
  String get wifiPairingClosedEarly => 'Conexión cerrada (sin respuesta)';

  @override
  String wifiPairingSendFailed(String error) {
    return 'No se pudo enviar el comando: $error';
  }

  @override
  String get wifiPairingTimeout =>
      'El dispositivo no respondió (tiempo agotado).';

  @override
  String get wifiPairingNotOpen =>
      'La ventana de emparejamiento no está abierta en el dispositivo. Pulsa brevemente el botón e inténtalo de nuevo.';

  @override
  String get skapiBindFixedTriggerLabel =>
      'Disparador: cuando expira el temporizador';

  @override
  String get wifiPairingDeviceAlreadyBonded =>
      'Este dispositivo ya está emparejado con otro SKAPP. El firmware actual no admite añadir un nuevo par por WiFi (TCP solo acepta el primer emparejamiento). Usa el emparejamiento BLE o desempareja el par existente desde el dispositivo.';

  @override
  String wifiPairingRejected(String error) {
    return 'El dispositivo lo rechazó: $error';
  }

  @override
  String get wifiPairingMissingPub =>
      'our_pub del dispositivo falta o está dañado.';

  @override
  String wifiPairingHexError(String error) {
    return 'Falló la decodificación hex de our_pub: $error';
  }

  @override
  String get wifiPairingStageAwaiting => 'Pulsa el botón del dispositivo';

  @override
  String get wifiPairingStageConnecting => 'Conectando con el dispositivo…';

  @override
  String get wifiPairingStageExchanging => 'Intercambiando claves…';

  @override
  String get wifiPairingStageDone => 'Emparejamiento completado';

  @override
  String get wifiPairingStageFailed => 'El emparejamiento falló';

  @override
  String get wifiPairingStageAwaitingHelp =>
      'Pulsa brevemente el botón de control del dispositivo (menos de 3 segundos). La ventana de emparejamiento permanece abierta 60 segundos.';

  @override
  String get wifiPairingStageConnectingHelp => 'Abriendo socket TCP.';

  @override
  String get wifiPairingStageExchangingHelp =>
      'pairing.ecdh.exchange enviado, esperando la respuesta del dispositivo.';

  @override
  String get wifiPairingStageDoneHelp => 'Yendo al panel del dispositivo.';

  @override
  String get wifiPairingStartCta => 'Emparejar';

  @override
  String get bfDashboardTitleFallback => 'Dispositivo';

  @override
  String get bfDashboardWifiNone => 'Sin WiFi';

  @override
  String get bfDashboardLinkBle => 'BLE';

  @override
  String get bfDashboardLinkWifi => 'WiFi';

  @override
  String get bfDashboardLinkUsb => 'USB';

  @override
  String get bfDashboardToggleVibration => 'Vibración';

  @override
  String get bfDashboardToggleTilt => 'Alerta de inclinación';

  @override
  String get bfDashboardToggleLowBatt => 'Alerta de batería baja';

  @override
  String get bfDashboardApiChainTitle => 'Cadena de API';

  @override
  String bfDashboardApiChainNone(String state) {
    return 'aún sin endpoints · maestro $state';
  }

  @override
  String bfDashboardApiChainSummary(int count, String state) {
    return '$count endpoint(s) · maestro $state';
  }

  @override
  String get bfDashboardMasterOn => 'activado';

  @override
  String get bfDashboardMasterOff => 'desactivado';

  @override
  String get bfDashboardNotebookTitle => 'Cuaderno del usuario';

  @override
  String get bfDashboardNotebookSubtitle =>
      'Área cifrada · 100 KB · contenido libre';

  @override
  String get bfDashboardMoreDeviceInfo => 'Información del dispositivo';

  @override
  String get bfDashboardMoreSettings => 'Ajustes';

  @override
  String bfDashboardWriteFailed(String error) {
    return 'No se pudo escribir: $error';
  }

  @override
  String get bfDeviceInfoTitle => 'Información del dispositivo';

  @override
  String get bfDeviceInfoSectionGeneral => 'GENERAL';

  @override
  String get bfDeviceInfoSectionConnection => 'CONEXIÓN';

  @override
  String get bfDeviceInfoSectionBattery => 'BATERÍA';

  @override
  String get bfDeviceInfoSectionTime => 'HORA';

  @override
  String get bfDeviceInfoSectionLastError => 'ÚLTIMO ERROR';

  @override
  String get bfDeviceInfoSectionDiagnostics => 'DIAGNÓSTICOS';

  @override
  String get bfDeviceInfoSectionDocs => 'DOCUMENTACIÓN';

  @override
  String get bfDeviceInfoProduct => 'Producto';

  @override
  String get bfDeviceInfoTypeCode => 'Código de tipo';

  @override
  String get bfDeviceInfoIdentity => 'Identidad';

  @override
  String get bfDeviceInfoHardware => 'Hardware';

  @override
  String get bfDeviceInfoFirmware => 'Firmware';

  @override
  String get bfDeviceInfoProtocol => 'Protocolo';

  @override
  String get bfDeviceInfoBuild => 'Compilación';

  @override
  String get bfDeviceInfoUptime => 'Tiempo activo';

  @override
  String get bfDeviceInfoWifiState => 'Estado de WiFi';

  @override
  String get bfDeviceInfoIp => 'IP';

  @override
  String get bfDeviceInfoSignal => 'Señal';

  @override
  String get bfDeviceInfoBleAdvertising => 'Difusión BLE';

  @override
  String get bfDeviceInfoBlePaired => 'Emparejamientos BLE';

  @override
  String bfDeviceInfoPairedClients(int count) {
    return '$count cliente(s)';
  }

  @override
  String get bfDeviceInfoBattery => 'Batería';

  @override
  String get bfDeviceInfoBatteryPresent => 'presente';

  @override
  String get bfDeviceInfoBatteryAbsent => 'ausente';

  @override
  String get bfDeviceInfoDeviceClock => 'Reloj del dispositivo';

  @override
  String get bfDeviceInfoLogs => 'Registros del dispositivo';

  @override
  String get bfDeviceInfoLogsSubtitle =>
      'logs.get, arranque, error, temporizador, eventos de API';

  @override
  String get bfDeviceInfoEvents => 'Historial de eventos';

  @override
  String get bfDeviceInfoEventsSubtitle =>
      'Local · temporizador, cambio de cara, disparadores de API';

  @override
  String get bfDeviceInfoUserGuide => 'Guía del usuario';

  @override
  String get bfDeviceInfoUserGuideSubtitle =>
      'Asignación de caras, temporizador, disparadores de API';

  @override
  String get bfDeviceInfoDevNotes => 'Notas para desarrolladores de SK';

  @override
  String get bfDeviceInfoDevNotesSubtitle =>
      'Comandos CLI, arquitectura, taxonomía de eventos';

  @override
  String get bfDeviceInfoLicense => 'Licencia y fuentes abiertas';

  @override
  String get bfDeviceInfoLicenseSubtitle =>
      'Bibliotecas usadas e información de copyright';

  @override
  String get bfDeviceInfoComingSoon => 'Próximamente';

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
  String get bfDeviceInfoYes => 'sí';

  @override
  String get bfDeviceInfoNo => 'no';

  @override
  String get bfSettingsTitle => 'Ajustes';

  @override
  String get bfSettingsSectionNetwork => 'RED';

  @override
  String get bfSettingsSectionUpdates => 'ACTUALIZACIONES';

  @override
  String get bfSettingsSectionDanger => 'ZONA DE PELIGRO';

  @override
  String get bfSettingsWifiPrimary => 'WiFi principal';

  @override
  String get bfSettingsWifiSecondary => 'WiFi de reserva';

  @override
  String get bfSettingsWifiUnconfigured => 'Sin configurar';

  @override
  String get bfSettingsFirmware => 'Firmware';

  @override
  String get bfSettingsCheckUpdates => 'Buscar actualizaciones';

  @override
  String get bfSettingsCheckUpdatesSubtitle =>
      'Se activa cuando se define una URL de manifiesto';

  @override
  String get bfOtaTitle => 'Actualización de firmware';

  @override
  String get bfOtaCurrentLabel => 'Versión instalada';

  @override
  String get bfOtaRunningPartitionLabel => 'Partición activa';

  @override
  String get bfOtaCheckCta => 'Buscar actualizaciones';

  @override
  String get bfOtaIdleHint =>
      'Aún no se ha realizado ninguna comprobación de actualizaciones.';

  @override
  String get bfOtaChecking => 'Comprobando el servidor de actualizaciones…';

  @override
  String get bfOtaUpToDate => 'El dispositivo está actualizado.';

  @override
  String bfOtaAvailable(String version) {
    return 'Nueva versión disponible: $version';
  }

  @override
  String get bfOtaUpdateCta => 'Actualizar ahora';

  @override
  String bfOtaDownloading(int pct) {
    return 'Descargando… %$pct';
  }

  @override
  String get bfOtaDone => 'Actualizado. El dispositivo se está reiniciando…';

  @override
  String bfOtaErrorMsg(String message) {
    return 'Error: $message';
  }

  @override
  String get bfOtaRollbackCta => 'Volver a la versión anterior';

  @override
  String get bfOtaUpdateConfirmTitle =>
      '¿Instalar la actualización de firmware?';

  @override
  String bfOtaUpdateConfirmBody(String version) {
    return 'Se descargará e instalará la versión $version y luego el dispositivo se reiniciará. No lo apagues durante la actualización.';
  }

  @override
  String get bfOtaRollbackConfirmTitle => '¿Revertir el firmware?';

  @override
  String get bfOtaRollbackConfirmBody =>
      'El dispositivo arrancará el firmware anterior y se reiniciará.';

  @override
  String get bfSettingsReboot => 'Reiniciar dispositivo';

  @override
  String get bfSettingsRebootSubtitle =>
      'Apaga y enciende el dispositivo · cancela cualquier temporizador activo';

  @override
  String get bfSettingsRebootConfirmTitle => '¿Reiniciar el dispositivo?';

  @override
  String get bfSettingsRebootConfirmBody =>
      'El dispositivo se apagará y se volverá a encender en unos segundos.';

  @override
  String get bfSettingsUnpairThisPhone => 'Desemparejar este teléfono';

  @override
  String get bfSettingsUnpairSubtitle =>
      'Elimina el vínculo · el dispositivo deberá emparejarse de nuevo';

  @override
  String get bfSettingsUnpairConfirmTitle => '¿Desemparejar este teléfono?';

  @override
  String get bfSettingsFactoryReset => 'Restablecimiento de fábrica';

  @override
  String get bfSettingsFactoryResetSubtitle =>
      'Borra la WiFi, los endpoints de API y los emparejamientos';

  @override
  String get bfSettingsFactoryResetConfirmTitle =>
      '¿Restablecimiento de fábrica?';

  @override
  String get bfSettingsFactoryResetConfirmBody =>
      'Se borrarán todos los ajustes. El dispositivo se reiniciará.';

  @override
  String get bfWifiManagementTitle => 'Gestión de WiFi';

  @override
  String get bfWifiConnecting => 'Conectando…';

  @override
  String bfWifiConnectionRejected(String error) {
    return 'Conexión rechazada: $error';
  }

  @override
  String bfWifiConfigure(String label) {
    return 'Configurar $label';
  }

  @override
  String get bfWifiPasswordLabel => 'Contraseña';

  @override
  String get bfNotebookTitle => 'Cuaderno del usuario';

  @override
  String get bfNotebookSaveCancel => 'Cancelar';

  @override
  String get bfApiChainCancel => 'Cancelar';

  @override
  String get bfApiChainRunChain => 'Ejecutar cadena';

  @override
  String get bfApiChainToggleAll => 'Activar/desactivar todo';

  @override
  String get bfApiChainFieldName => 'Nombre';

  @override
  String get bfApiChainFieldType => 'Tipo';

  @override
  String get bfApiChainFieldHeaderName => 'Nombre de la cabecera';

  @override
  String get bfApiChainFieldNewToken =>
      'Nuevo token (déjalo en blanco para conservarlo)';

  @override
  String get bfHomeLoadingConnecting => 'Conectando con el dispositivo…';

  @override
  String get bfHomeLoadingSecure => 'Abriendo canal seguro…';

  @override
  String get deviceConnUnreachableTitle =>
      'No se puede alcanzar el dispositivo';

  @override
  String get deviceConnUnreachableBody =>
      'El dispositivo puede estar apagado, fuera de alcance o en reposo. Asegúrate de que está encendido y cerca, y luego inténtalo de nuevo.';

  @override
  String get deviceConnRepairTitle => 'Hay que renovar el emparejamiento';

  @override
  String get deviceConnRepairBody =>
      'Parece que el dispositivo se restableció y ya no reconoce este teléfono. Empareja con él de nuevo para volver a conectar.';

  @override
  String get deviceConnRepairButton => 'Emparejar de nuevo';

  @override
  String get deviceConnTechnicalDetails => 'Detalles técnicos';

  @override
  String get bfLogsTitle => 'Registros del dispositivo';

  @override
  String get bfEventsTitle => 'Historial de eventos';

  @override
  String get pairingStepConnecting => 'Conectando';

  @override
  String get pairingStepConnectingSubtitle =>
      'Enlace BLE + descubrimiento GATT';

  @override
  String get pairingStepMutualAuth => 'Autenticación mutua';

  @override
  String get pairingStepDeviceInfo => 'Verificación de device.info';

  @override
  String get pairingStepDeviceInfoSubtitle =>
      'Canal cifrado activo, ping de comprobación';

  @override
  String get pairingStepConnected => 'Conexión establecida';

  @override
  String get pairingStepConnectedSubtitle =>
      'CLI listo, pasando a la configuración';

  @override
  String get pairingStepKeyExchange => 'Intercambio de claves';

  @override
  String get pairingStepKeyExchangeSubtitle => 'X25519, clave pública enviada';

  @override
  String get pairingStepVerifying => 'Verificando';

  @override
  String get pairingStepVerifyingSubtitle =>
      'Esperando al dispositivo, derivando token';

  @override
  String get pairingStepDone => 'Emparejamiento completado';

  @override
  String get pairingStepDoneSubtitle =>
      'Vínculo guardado en el dispositivo y el teléfono';

  @override
  String get pairingLogTitle => 'Registro de emparejamiento';

  @override
  String get pairingLogCopied => 'Registro copiado al portapapeles';

  @override
  String get discoveryPreparing => 'Preparando…';

  @override
  String get discoveryBluetoothOff => 'El Bluetooth está desactivado';

  @override
  String get wifiPasswordTitle => 'Conectar el dispositivo a la WiFi';

  @override
  String get wifiPasswordSsidLabel => 'Nombre de la red (SSID)';

  @override
  String get wifiPasswordNetworkLabel => 'Red';

  @override
  String get wifiPasswordPasswordLabel => 'Contraseña';

  @override
  String get wifiPasswordConnect => 'Conectar';

  @override
  String get wifiPasswordLogTitle => 'Registro de conexión';

  @override
  String get wifiPasswordLogCopied => 'Registro copiado al portapapeles';

  @override
  String get wifiScanTitle => 'Elige una red WiFi para el dispositivo';

  @override
  String get wifiScanRescanTooltip =>
      'Pedir al dispositivo que busque de nuevo';

  @override
  String get wifiScanRunning =>
      'El escáner WiFi del dispositivo está en marcha…';

  @override
  String get wifiScanNoNetworks =>
      'El dispositivo no encontró ninguna WiFi cercana.';

  @override
  String get wifiScanRescan => 'Pedir al dispositivo que busque de nuevo';

  @override
  String get wifiScanHiddenAdd => 'Añadir red oculta';

  @override
  String get wifiScanHiddenSubtitle => 'Escribe el SSID a mano';

  @override
  String get wifiScanLogTitle => 'Registro de búsqueda WiFi';

  @override
  String get wifiSuccessReady => 'Listo';

  @override
  String get bfEventsClearTooltip => 'Borrar';

  @override
  String get bfEventsEmpty =>
      'Aún no hay eventos. Aparecerán aquí cuando el dispositivo empiece a publicarlos.';

  @override
  String get logsEmptyTooltip => 'El registro está vacío.';

  @override
  String logsErrorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get notebookSaved => 'Guardado';

  @override
  String notebookSaveError(String error) {
    return 'Error: $error';
  }

  @override
  String notebookCapacityExceeded(int used, int capacity) {
    return 'Capacidad superada: $used / $capacity bytes';
  }

  @override
  String get notebookClearTooltip => 'Borrar cuaderno';

  @override
  String get notebookClearConfirmTitle => '¿Borrar todo el cuaderno?';

  @override
  String get notebookClearConfirmBody =>
      'Se borrarán todos los datos de usuario del dispositivo. No se puede deshacer.';

  @override
  String get notebookClearAction => 'Borrar';

  @override
  String get notebookClearedSnack => 'Cuaderno borrado';

  @override
  String notebookClearError(String error) {
    return 'No se pudo borrar: $error';
  }

  @override
  String get notebookEncryptedHint =>
      'Área cifrada · solo el SKAPP emparejado puede leerla';

  @override
  String get notebookEmptyTitle => 'El cuaderno está vacío';

  @override
  String get notebookEmptyBody =>
      'Escribe abajo notas, JSON, definiciones de escenas o cualquier otro texto. Al tocar Guardar se almacena cifrado en el dispositivo.';

  @override
  String get notebookHint =>
      'Escribe aquí lo que quieras (notas, JSON, tu propio esquema). Hasta 100 KB almacenados en el dispositivo.';

  @override
  String get notebookDirty => 'Cambios sin guardar';

  @override
  String get notebookSaved2 => 'Guardado';

  @override
  String get notebookSyncedDifferent => 'Sincronizado';

  @override
  String get notebookSaveCta => 'Guardar';

  @override
  String wifiPairingHexErrorRaw(String error) {
    return 'Falló la decodificación hex de our_pub: $error';
  }

  @override
  String get bfWifiForgetTitle => '¿Olvidar la ranura?';

  @override
  String get bfWifiForgetBody =>
      'La ranura se borrará. Si el dispositivo está conectado aquí actualmente, recurrirá a la otra ranura (si la hay). Es necesario volver a configurarla para restaurarla.';

  @override
  String get bfWifiForget => 'Olvidar';

  @override
  String get bfWifiHint =>
      'El dispositivo prueba las dos redes por orden: primero la principal y, si falla, la de reserva. La ranura activa se marca con un punto verde.';

  @override
  String get bfWifiActive => 'ACTIVA';

  @override
  String get bfWifiNotConfigured => 'Sin configurar';

  @override
  String get bfWifiChange => 'Cambiar';

  @override
  String get bfWifiSetUp => 'Configurar';

  @override
  String get discoveryStatusChecking => 'Comprobación del estado de Bluetooth.';

  @override
  String get discoveryPermissionsTitle => 'Se requiere permiso de Bluetooth';

  @override
  String get discoveryPermissionsBody =>
      'Para encontrar dispositivos SmartKraft cercanos, activa el permiso de Bluetooth.';

  @override
  String get discoveryPermissionsRetry => 'Solicitar permisos de nuevo';

  @override
  String get discoveryPermissionsOpenSettings => 'Abrir ajustes';

  @override
  String get discoveryAdapterOffBody =>
      'Activa el Bluetooth para buscar dispositivos.';

  @override
  String get discoveryAdapterOffEnable => 'Activar Bluetooth';

  @override
  String get discoveryUnsupportedTitle => 'BLE no compatible';

  @override
  String get discoveryUnsupportedBody =>
      'Este dispositivo no admite Bluetooth Low Energy; SKAPP necesita BLE para funcionar.';

  @override
  String get wifiPasswordHelp =>
      'El dispositivo se unirá a esta red. Introduce la contraseña, escríbela con cuidado.';

  @override
  String get wifiPasswordRequired => 'La contraseña es obligatoria';

  @override
  String get wifiPasswordMinLength => 'Al menos 8 caracteres';

  @override
  String wifiPasswordSendError(String error) {
    return 'No se pudo enviar: $error';
  }

  @override
  String get wifiScanTimeoutHint =>
      'Si la búsqueda tarda demasiado, el dispositivo puede haber perdido el alcance de la WiFi. Toca reintentar.';

  @override
  String get wifiScanFailedTitle => 'La búsqueda falló';

  @override
  String get wifiScanRetry => 'Reintentar';

  @override
  String get wifiSuccessTitle => 'Conectado';

  @override
  String get wifiSuccessBody =>
      'El dispositivo ya está en WiFi. Volviendo al panel…';

  @override
  String get deviceNameSectionHeading =>
      'NOMBRE DEL DISPOSITIVO (SOLO EN ESTA APP)';

  @override
  String get deviceNameLabel => 'Nombre personalizado';

  @override
  String get deviceNameHint => 'p. ej. BF de la oficina';

  @override
  String get deviceNameSubtitle =>
      'Se muestra en las tarjetas de esta instalación de SKAPP. No se envía al dispositivo.';

  @override
  String get deviceNameClear => 'Borrar';

  @override
  String get deviceNameSave => 'Guardar';

  @override
  String get deviceNameSaved => 'Guardado';

  @override
  String get deviceNameEmptyPlaceholder => '(sin nombre personalizado)';

  @override
  String get settingsUsbConsoleTitle => 'Consola CLI USB';

  @override
  String get settingsUsbConsoleSubtitle =>
      'Envía comandos sin procesar a un dispositivo conectado por USB';

  @override
  String get usbConsoleAppBarTitle => 'Consola USB';

  @override
  String get usbConsolePickPortTitle => 'Selecciona un puerto';

  @override
  String get usbConsolePickPortHint =>
      'Conecta un dispositivo SmartKraft por USB y toca actualizar';

  @override
  String get usbConsolePortRefreshTooltip => 'Actualizar puertos';

  @override
  String get usbConsoleBfBadge => 'SmartKraft';

  @override
  String get usbConsoleConnecting => 'Conectando…';

  @override
  String get usbConsoleConnected => 'Conectado';

  @override
  String get usbConsoleDisconnected => 'Desconectado';

  @override
  String usbConsoleErrorBanner(String error) {
    return 'Error: $error';
  }

  @override
  String get usbConsoleReconnect => 'Reconectar';

  @override
  String get usbConsoleDisconnect => 'Desconectar';

  @override
  String get usbConsoleClear => 'Borrar consola';

  @override
  String get usbConsoleInputHint => 'Escribe un comando, p. ej. device.info';

  @override
  String get usbConsoleSend => 'Enviar';

  @override
  String get usbConsoleEmptyHint =>
      'Escribe un comando y pulsa Intro, prueba device.info';

  @override
  String get usbConsoleEntryEvent => 'evt';

  @override
  String get usbConsoleEntryError => 'error';

  @override
  String get usbConsoleNotSupportedIos =>
      'La consola USB no es compatible con iOS';

  @override
  String get passphraseFieldLabel => 'Frase de contraseña';

  @override
  String get passphraseVerifyButton => 'Verificar';

  @override
  String passphraseAttemptsLeft(int count) {
    return 'Intentos restantes: $count';
  }

  @override
  String get passphraseLockoutTriggered =>
      'Demasiados intentos incorrectos de la frase de contraseña; el dispositivo se restableció de fábrica.';

  @override
  String get bondPeerUnnamed => '(sin nombre)';

  @override
  String get pairingPassphraseDialogTitle =>
      'Frase de contraseña del dispositivo';

  @override
  String get pairingPassphraseDialogBody =>
      'Este dispositivo requiere una frase de contraseña para acceder al contenido. Introdúcela para completar el emparejamiento.';

  @override
  String get pairingPassphraseCancelled =>
      'Frase de contraseña no introducida, emparejamiento cancelado.';

  @override
  String pairingPassphraseSendError(String error) {
    return 'No se pudo enviar la frase de contraseña: $error';
  }

  @override
  String get pairingPassphraseTimeout =>
      'El dispositivo no respondió (verificación de frase de contraseña, 8 s).';

  @override
  String get pairingWindowClosedRetry =>
      'La ventana de emparejamiento se cerró, pulsa brevemente el botón e inténtalo de nuevo.';

  @override
  String pairingPassphraseFailed(String error) {
    return 'No se pudo verificar la frase de contraseña: $error';
  }

  @override
  String get bondStoreFullHeader =>
      'Las 8 ranuras de vínculo están llenas. Elimina un par existente para emparejar un nuevo SKAPP:';

  @override
  String bondStoreFullPeerLine(Object slot, String name, String shortPid) {
    return '  • ranura $slot, $name [#$shortPid]';
  }

  @override
  String get bondStoreFullFooter =>
      'Desde otro SKAPP emparejado o por USB, ejecuta\n`bond.remove --slot N` y luego toca Reintentar aquí.';

  @override
  String get passphraseGateDialogBody =>
      'Este dispositivo pide la frase de contraseña en cada conexión. Introdúcela para acceder al contenido.';

  @override
  String get passphraseGateCancelled =>
      'Frase de contraseña no introducida; se requiere verificación para acceder a esta pantalla.';

  @override
  String passphraseGateVerifyError(String error) {
    return 'Error de verificación: $error';
  }

  @override
  String passphraseGateCommError(String error) {
    return 'Error de comunicación: $error';
  }

  @override
  String get passphraseGateUnknownError => 'Error de bloqueo desconocido.';

  @override
  String get bfPassphraseTitle => 'Frase de contraseña del dispositivo';

  @override
  String get bfPassphraseSetTitle => 'Definir frase de contraseña';

  @override
  String get bfPassphraseChangeTitle => 'Cambiar frase de contraseña';

  @override
  String get bfPassphraseClearTitle => 'Eliminar frase de contraseña';

  @override
  String get bfPassphraseChangeSubtitle =>
      'Introduce la frase de contraseña anterior y define la nueva';

  @override
  String get bfPassphraseClearSubtitle =>
      'Restablece el bloqueo de contenido del dispositivo';

  @override
  String get bfPassphraseModePairing => 'Preguntar durante el emparejamiento';

  @override
  String get bfPassphraseModePairingSubtitle =>
      'Pregunta cuando se empareja un nuevo SKAPP. A los pares existentes no se les pregunta.';

  @override
  String get bfPassphraseModeAlways => 'Preguntar en cada conexión';

  @override
  String get bfPassphraseModeAlwaysSubtitle =>
      'Pregunta cada vez que se abre una sesión. El contenido permanece bloqueado aunque roben un SKAPP.';

  @override
  String get bfPassphraseStatusNone =>
      'Sin frase de contraseña, el dispositivo no tiene bloqueo de contenido';

  @override
  String get bfPassphraseStatusActiveOff =>
      'Frase de contraseña definida · aplicación desactivada (ambos interruptores apagados)';

  @override
  String get bfPassphraseStatusActivePairing =>
      'Se pregunta durante el emparejamiento';

  @override
  String get bfPassphraseStatusActiveAlways => 'Se pregunta en cada conexión';

  @override
  String get bfPassphraseBadgeActive => 'Frase de contraseña activa';

  @override
  String get bfPassphraseBadgeNone => 'Sin frase de contraseña';

  @override
  String bfPassphraseAttemptsRatio(int left, int total) {
    return 'Intentos restantes: $left / $total';
  }

  @override
  String bfPassphraseLengthSubtitle(int min, int max) {
    return 'Longitud $min-$max caracteres';
  }

  @override
  String bfPassphraseLengthHint(int min, int max) {
    return 'Longitud: $min-$max';
  }

  @override
  String bfPassphraseTooShort(int min) {
    return 'Al menos $min caracteres';
  }

  @override
  String bfPassphraseTooLong(int max) {
    return 'Como máximo $max caracteres';
  }

  @override
  String get bfPassphraseEmpty => 'No puede estar vacía';

  @override
  String get bfPassphraseNewLabel => 'Nueva frase de contraseña';

  @override
  String get bfPassphraseCurrentLabel => 'Frase de contraseña actual';

  @override
  String get bfPassphraseSetDone => 'Frase de contraseña definida';

  @override
  String get bfPassphraseChangeDone => 'Frase de contraseña cambiada';

  @override
  String get bfPassphraseClearDone => 'Frase de contraseña eliminada';

  @override
  String bfPassphraseStatusReadError(String error) {
    return 'No se pudo leer el estado: $error';
  }

  @override
  String get bfPassphraseNotesTitle => 'Notas';

  @override
  String get bfPassphraseNotesBody =>
      '• La frase de contraseña se cifra en el dispositivo con PBKDF2-SHA256; nunca se almacena en texto plano.\n• 10 intentos incorrectos restablecen de fábrica el dispositivo; se borran todos los vínculos y datos.\n• Un dispositivo conectado por USB omite la solicitud de la frase de contraseña; el acceso físico ya permite el restablecimiento de fábrica mediante el botón.';

  @override
  String bfBondListTitle(int used, int capacity) {
    return 'SKAPP emparejados  ($used/$capacity)';
  }

  @override
  String get bfBondListEmpty => 'Aún no hay pares emparejados.';

  @override
  String get bfBondListBadgeThisPhone => 'Este teléfono';

  @override
  String get bfBondListBadgeActiveSession => 'Sesión activa';

  @override
  String bfBondListRowSubtitle(String shortPid, String date) {
    return '#$shortPid · emparejado: $date';
  }

  @override
  String get bfBondListRemoveTooltip => 'Eliminar este par';

  @override
  String get bfBondListRemoveTitle => '¿Eliminar par?';

  @override
  String get bfBondListRemoveSelfBody =>
      'Estás eliminando el vínculo de este teléfono. Si confirmas, la sesión se interrumpe; para volver a alcanzar el dispositivo tendrás que pulsar brevemente el botón y emparejar de nuevo.';

  @override
  String bfBondListRemoveOtherBody(String label, int slot) {
    return '\"$label\" (ranura $slot) se borra del dispositivo. Ese SKAPP debe pulsar brevemente el botón y emparejar de nuevo para reconectarse.';
  }

  @override
  String bfBondListSlotRemoved(int slot) {
    return 'Ranura $slot eliminada';
  }

  @override
  String bfBondListFetchError(String error) {
    return 'bond.list falló: $error';
  }

  @override
  String get bfSettingsSectionSecurity => 'SEGURIDAD';

  @override
  String get bfSettingsPassphraseTitle => 'Frase de contraseña del dispositivo';

  @override
  String get bfSettingsBondListTitle => 'SKAPP emparejados';

  @override
  String get bfSettingsPassphraseSubtitleAlways => 'Activa, en cada conexión';

  @override
  String get bfSettingsPassphraseSubtitlePairing => 'Activa, al emparejar';

  @override
  String get bfSettingsPassphraseSubtitleOff =>
      'Activa, aplicación desactivada';

  @override
  String bfSettingsBondsSubtitle(int count, int capacity) {
    return 'Pares emparejados: $count / $capacity';
  }

  @override
  String get skapiHowItWorksTitle => 'Cómo funciona';

  @override
  String skapiHowItWorksBody(String deviceName) {
    return 'Cuando tu dispositivo SmartKraft (por ejemplo $deviceName) experimenta un evento como el fin de un temporizador, una pulsación de botón o el disparo de un sensor, envía un pequeño comando a tu equipo. Tu equipo recibe ese comando y ejecuta el script que hayas elegido.';
  }

  @override
  String get skapiHowItWorksFlowDeviceLabel => 'Dispositivo SmartKraft';

  @override
  String get skapiHowItWorksFlowDeviceSub =>
      'p. ej. Blocking Focus, dispara un evento';

  @override
  String get skapiHowItWorksFlowComputerLabel => 'Equipo';

  @override
  String get skapiHowItWorksFlowComputerSub =>
      'SKAPP recibe el comando, el script se ejecuta';

  @override
  String get skapiHowItWorksFoot =>
      'SKAPP debe estar en ejecución en tu equipo. Todo el tráfico permanece en la red WiFi, no se requiere conexión a internet y ningún dato sale de tu casa.';

  @override
  String get skapiPlatformGroupsHeader => 'Categorías de acciones';

  @override
  String skapiPlatformGroupsLoadError(String error) {
    return 'No se pudieron cargar los grupos: $error';
  }

  @override
  String get skapiPlatformEmptyTitle => 'Aún no hay scripts aquí';

  @override
  String get skapiPlatformEmptyBody =>
      'Los scripts para esta plataforma todavía están en camino. Vuelve a comprobarlo tras la próxima actualización de SKAPP.';

  @override
  String skapiGroupScriptsLoadError(String error) {
    return 'No se pudieron cargar los scripts: $error';
  }

  @override
  String skapiScriptDetailLoadError(String error) {
    return 'No se pudo cargar este script: $error';
  }

  @override
  String get skapiBindScreenTitle => 'Vincular a una acción';

  @override
  String get skapiBindScreenSubtitle =>
      'Ejecuta este script automáticamente cuando se dispara un evento del dispositivo.';

  @override
  String get skapiBindFieldDeviceLabel => 'Dispositivo';

  @override
  String get skapiBindFieldDeviceHint =>
      'Elige qué dispositivo emparejado debe disparar este script.';

  @override
  String get skapiBindFieldDeviceEmpty =>
      'Aún no hay dispositivos emparejados. Empareja uno primero desde la pestaña Dispositivos.';

  @override
  String get skapiBindFieldEventLabel => 'Evento';

  @override
  String get skapiBindFieldEventHint =>
      'El dispositivo emite este evento; el script se ejecuta cuando ocurre.';

  @override
  String get skapiBindEventTimerStarted => 'Temporizador iniciado';

  @override
  String get skapiBindEventTimerExpired => 'Temporizador expirado';

  @override
  String get skapiBindEventFaceChanged => 'Cara del cubo cambiada';

  @override
  String get skapiBindEventButtonPressed => 'Botón pulsado';

  @override
  String get skapiBindEventButtonHeld => 'Botón mantenido';

  @override
  String get skapiBindEventBatteryLow => 'Batería baja';

  @override
  String get skapiBindEventBatteryLockout => 'Bloqueo por batería';

  @override
  String get skapiBindEventPowerStateChanged => 'Estado de energía cambiado';

  @override
  String get skapiBindEventPairingSuccess => 'Emparejamiento correcto';

  @override
  String get skapiBindEventApiSent => 'Llamada de API enviada';

  @override
  String get skapiBindParamsHeader => 'Anulaciones de parámetros';

  @override
  String get skapiBindParamsHint =>
      'Déjalo vacío para conservar los valores predeterminados del script. Estos valores se envían cada vez que se dispara el vínculo.';

  @override
  String get skapiBindButtonSave => 'Guardar vínculo';

  @override
  String get skapiBindButtonDelete => 'Eliminar vínculo';

  @override
  String get skapiBindButtonCancel => 'Cancelar';

  @override
  String get skapiBindButtonEnable => 'Activar';

  @override
  String get skapiBindButtonDisable => 'Desactivar';

  @override
  String get skapiBindStatusEnabled => 'Activo';

  @override
  String get skapiBindStatusDisabled => 'En pausa';

  @override
  String get skapiBindSavedToast => 'Vínculo guardado';

  @override
  String get skapiBindDeletedToast => 'Vínculo eliminado';

  @override
  String skapiBindBadgeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vínculos',
      one: '1 vínculo',
    );
    return '$_temp0';
  }

  @override
  String get skapiBindNoPairedDeviceWarning =>
      'Empareja primero un dispositivo para crear vínculos.';

  @override
  String skapiBindTriggeredDesktopToast(String script) {
    return 'Activado: $script';
  }

  @override
  String skapiBindTriggeredMobileToast(String event) {
    return 'Vínculo disparado ($event); la ejecución llega en la Fase K.';
  }

  @override
  String skapiBindLoadError(String error) {
    return 'No se pudieron cargar los vínculos: $error';
  }

  @override
  String get skapiBindListSectionTitle => 'Vínculos de este script';

  @override
  String get skapiBindListEmpty =>
      'Aún no hay vínculos. Toca Vincular a una acción para crear uno.';

  @override
  String get skapiBindNewButton => 'Nuevo vínculo';

  @override
  String get skapiBasicSettingsTitle => 'Ajustes';

  @override
  String get skapiBasicEmptyParams =>
      'Este script no necesita ajustes. Toca Ejecutar ahora.';

  @override
  String get skapiBasicUnitSeconds => 'segundos';

  @override
  String get skapiBasicConvHalfMinute => 'medio minuto';

  @override
  String get skapiBasicConvLessThanMinute => 'menos de un minuto';

  @override
  String skapiBasicConvMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutos',
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
      other: '$count horas',
      one: '1 hora',
    );
    return '$_temp0';
  }

  @override
  String get skapiBasicConvImmediate => 'comienza de inmediato';

  @override
  String skapiBasicConvAfter(String time) {
    return 'después de $time';
  }

  @override
  String get skapiBasicPrerunSectionTitle => 'Retardo previo a la ejecución';

  @override
  String get skapiBasicPrerunAddCta => 'Añadir retardo antes de ejecutar';

  @override
  String get skapiBasicPrerunLabel =>
      'Espera estos segundos antes de que comience el script';

  @override
  String get skapiBasicPrerunHelp =>
      'Útil para dejar que aparezca primero una notificación o para encadenar acciones. El valor predeterminado 0 significa que comienza de inmediato.';

  @override
  String get skapiBasicPrerunRemove => 'Quitar retardo';

  @override
  String get skapiBasicListAddPlaceholder => '+ añadir';

  @override
  String get skapiRunSheetTitle => 'Ejecutar script';

  @override
  String get skapiRunSheetStatusRunning => 'En ejecución';

  @override
  String get skapiRunSheetStatusOk => 'Listo';

  @override
  String get skapiRunSheetStatusError => 'Fallido';

  @override
  String skapiRunSheetExitCode(int code) {
    return 'Código de salida: $code';
  }

  @override
  String get skapiRunSheetCancel => 'Cancelar';

  @override
  String get skapiRunSheetClose => 'Cerrar';

  @override
  String get skapiRunSheetCopyOutput => 'Copiar salida';

  @override
  String get skapiRunSheetCopiedDone => 'Copiado';

  @override
  String get skapiRunSheetEmptyOutput => 'Esperando salida...';

  @override
  String get skapiRunSheetDismissConfirmTitle =>
      '¿Detener la ejecución del script?';

  @override
  String get skapiRunSheetDismissConfirmBody =>
      'El script aún se está ejecutando. Cerrar esta hoja lo cancelará.';

  @override
  String get skapiRunSheetDismissConfirmStay => 'Seguir ejecutando';

  @override
  String get skapiRunSheetDismissConfirmStop => 'Cancelar';

  @override
  String get skapiRunErrorPowerShellMissing =>
      'No se encontró PowerShell en este sistema.';

  @override
  String skapiRunErrorTempWrite(String error) {
    return 'No se pudo escribir el script en la carpeta temporal: $error';
  }

  @override
  String skapiRunErrorSpawn(String error) {
    return 'No se pudo iniciar PowerShell: $error';
  }

  @override
  String skapiRunDurationMs(int ms) {
    return 'Tardó $ms ms';
  }

  @override
  String get skapiCopiedToClipboard => 'Copiado';

  @override
  String get skapiFavouriteAddTooltip => 'Añadir a favoritos';

  @override
  String get skapiFavouriteRemoveTooltip => 'Quitar de favoritos';

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
  String get skapiPlatformScreenCategoriesTitle => 'Categorías de acciones';

  @override
  String skapiPlatformScreenCategoriesSub(int groups, int scripts) {
    return '$groups grupos · $scripts scripts en total';
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
  String get skapiGroupPowerTitle => 'Gestión de energía';

  @override
  String get skapiGroupPowerDesc =>
      'Los scripts de este grupo bloquean, suspenden, hibernan o apagan el equipo. Son útiles cuando un dispositivo SmartKraft señala el fin de una sesión de concentración o detecta inactividad prolongada y quieres que la máquina actúe en consecuencia.';

  @override
  String get skapiGroupPowerFoot =>
      'Uso típico: bloquear al levantarte, hibernar al final del día, apagado programado tras un largo periodo de inactividad.';

  @override
  String get skapiScriptLockTitle => 'Bloquear estación de trabajo';

  @override
  String get skapiScriptLockSummaryWhat =>
      'Bloquea Windows de inmediato y vuelve a la pantalla de inicio de sesión. Las apps abiertas siguen en ejecución.';

  @override
  String get skapiScriptLockSummaryHow =>
      'Llama a la función Win32 LockWorkStation de user32. Equivale a pulsar Win+L.';

  @override
  String get skapiScriptHibernateTitle => 'Hibernar';

  @override
  String get skapiScriptHibernateSummaryWhat =>
      'Guarda la sesión actual en el disco y apaga la máquina. Al reanudar vuelves a donde lo dejaste, incluso sin batería.';

  @override
  String get skapiScriptHibernateSummaryHow =>
      'Ejecuta el shutdown.exe integrado con la opción /h. La hibernación debe estar activada en los ajustes de energía de Windows; si no lo está, Windows recurre a la suspensión.';

  @override
  String get skapiScriptHibernateNote =>
      'Ejecuta powercfg /hibernate on una vez desde un shell de administrador si falta la hibernación en tu sistema.';

  @override
  String get skapiScriptHibernateParamDelayLabel => 'delay';

  @override
  String get skapiScriptHibernateParamDelayHint =>
      'Segundos de espera antes de hibernar, por si la notificación del dispositivo debe aparecer primero.';

  @override
  String get skapiScriptSleepTitle => 'Suspender';

  @override
  String get skapiScriptSleepSummaryWhat =>
      'Suspende la máquina en RAM (S3). La reanudación es rápida pero consume algo de batería mientras está suspendida.';

  @override
  String get skapiScriptSleepSummaryHow =>
      'Llama a System.Windows.Forms.Application.SetSuspendState con PowerState.Suspend. El sistema operativo puede retrasarlo si un proceso en primer plano bloquea las transiciones a inactividad.';

  @override
  String get skapiScriptSleepParamDelayLabel => 'delay';

  @override
  String get skapiScriptSleepParamDelayHint =>
      'Segundos de espera antes de suspender.';

  @override
  String get skapiScriptShutdownTitle => 'Apagar';

  @override
  String get skapiScriptShutdownSummaryWhat =>
      'Inicia un apagado ordenado de Windows. Se pide a las apps abiertas que guarden y se cierren.';

  @override
  String get skapiScriptShutdownSummaryHow =>
      'Ejecuta el shutdown.exe /s integrado. Con la opción de forzar activada, se añade /f para que se cierren las apps que no respondan.';

  @override
  String get skapiScriptShutdownNote =>
      'Un retardo distinto de cero da tiempo al usuario para cancelar mediante shutdown /a desde una terminal.';

  @override
  String get skapiScriptShutdownParamDelayLabel => 'delay';

  @override
  String get skapiScriptShutdownParamDelayHint =>
      'Segundos que Windows espera antes de apagarse. 30 es el valor predeterminado; elige 0 para un apagado inmediato.';

  @override
  String get skapiScriptShutdownParamForceLabel => 'force';

  @override
  String get skapiScriptShutdownParamForceHint =>
      'Cierra las apps que no responden a la señal de apagado. El trabajo sin guardar en esas apps puede perderse.';

  @override
  String get skapiGroupDisplayAudioTitle => 'Pantalla, imagen y sonido';

  @override
  String get skapiGroupDisplayAudioDesc =>
      'Los scripts de este grupo ajustan la pantalla y la salida de audio: brillo, volumen, silencio y reproducción multimedia. Son útiles cuando un dispositivo SmartKraft quiere que el equipo atenúe la pantalla durante una pausa de concentración o pause la música cuando te levantas.';

  @override
  String get skapiGroupDisplayAudioFoot =>
      'Uso típico: atenuar la pantalla durante una pausa, silenciar al bloquear, pausar Spotify cuando un dispositivo no detecta actividad.';

  @override
  String get skapiScriptBrightnessTitle => 'Ajustar brillo';

  @override
  String get skapiScriptBrightnessSummaryWhat =>
      'Establece el brillo de la pantalla interna en un porcentaje entre 0 y 100.';

  @override
  String get skapiScriptBrightnessSummaryHow =>
      'Llama a WMI WmiMonitorBrightnessMethods.WmiSetBrightness con el nivel solicitado. Solo responden portátiles, tabletas y paneles integrados; los monitores externos DDC/CI no son compatibles por esta vía.';

  @override
  String get skapiScriptBrightnessNote =>
      'Los monitores externos no cambiarán. En configuraciones de varios monitores, solo reacciona el panel que informa del brillo mediante WMI.';

  @override
  String get skapiScriptBrightnessParamLevelLabel => 'level';

  @override
  String get skapiScriptBrightnessParamLevelHint =>
      'Porcentaje de brillo (0-100). Los valores más bajos son más tenues. 70 es un valor predeterminado cómodo con iluminación normal.';

  @override
  String get skapiScriptBrightnessParamTimeoutLabel => 'timeout';

  @override
  String get skapiScriptBrightnessParamTimeoutHint =>
      'Segundos que se permite que tarde el cambio de brillo. El sistema operativo lo ajusta suavemente dentro de esta ventana.';

  @override
  String get skapiScriptMuteToggleTitle => 'Alternar silencio';

  @override
  String get skapiScriptMuteToggleSummaryWhat =>
      'Alterna el silencio maestro del sistema. El contenido multimedia activo sigue reproduciéndose pero no lo oyes.';

  @override
  String get skapiScriptMuteToggleSummaryHow =>
      'Envía la tecla virtual VK_VOLUME_MUTE, la misma vía que usa Windows cuando el usuario pulsa la tecla de silencio del teclado. Sin dependencia de administrador ni de COM.';

  @override
  String get skapiScriptMuteToggleParamModeLabel => 'mode';

  @override
  String get skapiScriptMuteToggleParamModeHint =>
      'toggle / on / off. Solo toggle se aplica mediante la pulsación de tecla simple; on y off se aceptan para compatibilidad futura.';

  @override
  String get skapiScriptVolumeSetTitle => 'Ajustar volumen';

  @override
  String get skapiScriptVolumeSetSummaryWhat =>
      'Establece el volumen maestro del sistema en un nivel preciso entre 0 y 100.';

  @override
  String get skapiScriptVolumeSetSummaryHow =>
      'Llama a Core Audio IAudioEndpointVolume.SetMasterVolumeLevelScalar mediante interoperabilidad COM en C# en línea. Apunta al endpoint de renderizado predeterminado.';

  @override
  String get skapiScriptVolumeSetNote =>
      'Nivel 2: funciona en equipos de escritorio estándar con Windows 10/11. Las instalaciones reducidas pueden no exponer la interfaz COM; los endpoints por app no se gestionan por esta vía.';

  @override
  String get skapiScriptVolumeSetParamLevelLabel => 'level';

  @override
  String get skapiScriptVolumeSetParamLevelHint =>
      'Porcentaje de volumen (0-100). 0 silencia sin activar el mute; 50 es un valor predeterminado cómodo.';

  @override
  String get skapiScriptMediaKeyTitle => 'Tecla multimedia';

  @override
  String get skapiScriptMediaKeySummaryWhat =>
      'Simula la pulsación de una tecla multimedia: reproducir/pausar, siguiente, anterior o detener. Va a la app que posee actualmente la sesión multimedia.';

  @override
  String get skapiScriptMediaKeySummaryHow =>
      'Envía VK_MEDIA_PLAY_PAUSE / VK_MEDIA_NEXT_TRACK / VK_MEDIA_PREV_TRACK / VK_MEDIA_STOP mediante keybd_event. Windows enruta la pulsación a través de los controles de transporte multimedia del sistema.';

  @override
  String get skapiScriptMediaKeyNote =>
      'Nivel 2: necesita una sesión multimedia activa. Si ninguna app está reproduciendo o la app en primer plano no se registra con SMTC, la pulsación se descarta silenciosamente.';

  @override
  String get skapiScriptMediaKeyParamKeyLabel => 'key';

  @override
  String get skapiScriptMediaKeyParamKeyHint =>
      'play-pause / next / previous / stop. El valor predeterminado es play-pause.';

  @override
  String get skapiGroupWindowAppTitle => 'Ventana y aplicación';

  @override
  String get skapiGroupWindowAppDesc =>
      'Los scripts de este grupo controlan ventanas y aplicaciones: minimizar, enfocar, cerrar de forma ordenada o terminar procesos sin más. Mantienen tu espacio de trabajo ordenado cuando un dispositivo SmartKraft quiere que el equipo cambie de contexto.';

  @override
  String get skapiGroupWindowAppFoot =>
      'Uso típico: minimizar todo cuando empieza una sesión de concentración, cerrar el navegador al terminar de trabajar, terminar una app bloqueada bajo demanda.';

  @override
  String get skapiScriptMinimizeWindowTitle => 'Minimizar ventana';

  @override
  String get skapiScriptMinimizeWindowSummaryWhat =>
      'Minimiza una ventana concreta por nombre de proceso. Un nombre de proceso vacío apunta a la ventana enfocada actualmente.';

  @override
  String get skapiScriptMinimizeWindowSummaryHow =>
      'Resuelve la primera ventana principal coincidente mediante Get-Process y llama a user32 ShowWindow con SW_MINIMIZE.';

  @override
  String get skapiScriptMinimizeWindowNote =>
      'Si hay varias instancias en ejecución, solo se minimiza la primera ventana coincidente. Usa el nombre del proceso sin el sufijo .exe.';

  @override
  String get skapiScriptMinimizeWindowParamProcessLabel => 'processName';

  @override
  String get skapiScriptMinimizeWindowParamProcessHint =>
      'Nombre de proceso sin .exe (chrome, code, winword). Vacío apunta a la ventana en primer plano.';

  @override
  String get skapiScriptCloseWindowTitle => 'Cerrar ventana';

  @override
  String get skapiScriptCloseWindowSummaryWhat =>
      'Envía un cierre ordenado a una ventana para que la app pueda mostrar su propio diálogo de \"¿guardar cambios?\".';

  @override
  String get skapiScriptCloseWindowSummaryHow =>
      'Publica WM_CLOSE mediante user32 SendMessage. El mismo efecto que cuando el usuario hace clic en el botón X. Un nombre de proceso vacío apunta a la ventana en primer plano.';

  @override
  String get skapiScriptCloseWindowNote =>
      'Las apps con trabajo sin guardar mostrarán su propio diálogo. El script no espera ni termina las apps colgadas.';

  @override
  String get skapiScriptCloseWindowParamProcessLabel => 'processName';

  @override
  String get skapiScriptCloseWindowParamProcessHint =>
      'Nombre de proceso sin .exe. Vacío apunta a la ventana en primer plano.';

  @override
  String get skapiScriptKillAppTitle => 'Forzar cierre de la app';

  @override
  String get skapiScriptKillAppSummaryWhat =>
      'Termina todas las instancias de un proceso. Prueba primero con WM_CLOSE y luego con TerminateProcess si la app sigue viva tras el tiempo de espera.';

  @override
  String get skapiScriptKillAppSummaryHow =>
      'Envía WM_CLOSE a cada ventana principal, espera el tiempo de espera configurado y luego ejecuta Stop-Process con -Force en todo lo que siga en ejecución.';

  @override
  String get skapiScriptKillAppNote =>
      'El trabajo sin guardar en apps que no responden se perderá al forzar el cierre. Usa preKillSave para apps de tipo editor que responden a Ctrl+S.';

  @override
  String get skapiScriptKillAppParamProcessLabel => 'processName';

  @override
  String get skapiScriptKillAppParamProcessHint =>
      'Nombre de proceso sin .exe. Se terminan todas las instancias en ejecución.';

  @override
  String get skapiScriptKillAppParamTimeoutLabel => 'timeout';

  @override
  String get skapiScriptKillAppParamTimeoutHint =>
      'Segundos de espera entre WM_CLOSE y el cierre forzado. Valores más altos dan a la app más tiempo para guardar.';

  @override
  String get skapiScriptKillAppParamPreKillSaveLabel => 'preKillSave';

  @override
  String get skapiScriptKillAppParamPreKillSaveHint =>
      'Envía Ctrl+S a la ventana en primer plano antes de cerrarla. Útil para editores, pero no tiene efecto en apps que ignoran Ctrl+S.';

  @override
  String get skapiScriptLaunchAppTitle => 'Iniciar app';

  @override
  String get skapiScriptLaunchAppSummaryWhat =>
      'Inicia un ejecutable, abre una URL o lanza un documento con el controlador predeterminado.';

  @override
  String get skapiScriptLaunchAppSummaryHow =>
      'Llama a PowerShell Start-Process con la ruta y una lista de argumentos opcional. La ruta puede ser un .exe, una ruta de archivo completa o una URL.';

  @override
  String get skapiScriptLaunchAppNote =>
      'Se aceptan rutas con espacios. Usa una URL como https://example.com para abrir el navegador predeterminado.';

  @override
  String get skapiScriptLaunchAppParamPathLabel => 'path';

  @override
  String get skapiScriptLaunchAppParamPathHint =>
      'Ejecutable, ruta de archivo completa o URL. notepad / C:\\\\tools\\\\my.exe / https://example.com.';

  @override
  String get skapiScriptLaunchAppParamArgsLabel => 'args';

  @override
  String get skapiScriptLaunchAppParamArgsHint =>
      'Argumentos pasados al ejecutable. Vacío para ninguno.';

  @override
  String get skappListenerCardTitle => 'Receptor HTTP de SKAPP';

  @override
  String skappListenerCardSubtitleRunning(int port) {
    return 'En ejecución en el puerto $port';
  }

  @override
  String get skappListenerCardSubtitleStopped => 'Detenido';

  @override
  String get skappListenerCardSubtitleUnsupported =>
      'Esta plataforma no puede alojar el receptor.';

  @override
  String get skappListenerCardEnableSwitch => 'Activar receptor';

  @override
  String get skappListenerCardSecurityNote =>
      'El receptor solo acepta conexiones en tu red local y requiere el token Bearer. HTTP sin cifrar, no lo expongas a internet pública.';

  @override
  String get settingsLanVisibleTitle => 'Visible en la LAN';

  @override
  String get settingsLanVisibleSubtitle =>
      'Cuando está desactivado, el receptor solo se enlaza a localhost. Los dispositivos BF emparejados no pueden alcanzar este equipo.';

  @override
  String get settingsLanVisibleWarnBfBreaks =>
      'Desactivar esto rompe la cadena de webhooks de BF. Úsalo solo en un entorno de confianza o de prueba.';

  @override
  String get settingsLanVisibleAutoReopenedSnack =>
      'La visibilidad en LAN se reactivó para que los dispositivos BF puedan alcanzar este equipo.';

  @override
  String get skapiRunRemoteDeveloperModeDisabled =>
      'El equipo de destino tiene el modo de desarrollador desactivado, por lo que la ejecución remota de scripts está desactivada allí.';

  @override
  String get skappPeerPairingManualUuidConfirmLabel =>
      'Código de confirmación (últimos 4 del UUID)';

  @override
  String get skappPeerPairingManualUuidConfirmHint =>
      'Lee el código de 4 caracteres que se muestra en la pantalla de emparejamiento del equipo de escritorio.';

  @override
  String get skappPeerPairingManualUuidConfirmError =>
      'El código no coincide con los últimos 4 del UUID. Comprueba la pantalla del equipo de escritorio.';

  @override
  String get skappListenerCardUuidLast4Label =>
      'Código de confirmación de emparejamiento';

  @override
  String get skappListenerCardUuidLast4Hint =>
      'Escribe estos 4 caracteres en la pantalla de emparejamiento manual del teléfono.';

  @override
  String get settingsPeerTokensTitle => 'Tokens de par emitidos';

  @override
  String get settingsPeerTokensSubtitle =>
      'Pares móviles emparejados con este equipo de escritorio. Revoca cualquier entrada para cerrarle la sesión sin afectar a los demás.';

  @override
  String get settingsPeerTokensEmpty => 'Aún no hay pares emparejados.';

  @override
  String settingsPeerTokensIssuedAt(String when) {
    return 'Emparejado $when';
  }

  @override
  String settingsPeerTokensLastUsed(String when) {
    return 'Último uso $when';
  }

  @override
  String get settingsPeerTokensRevokeButton => 'Revocar';

  @override
  String get settingsPeerTokensRevokeConfirmTitle => '¿Revocar este par?';

  @override
  String get settingsPeerTokensRevokeConfirmBody =>
      'Al par se le cerrará la sesión de inmediato y tendrá que emparejarse de nuevo para alcanzar este equipo de escritorio.';

  @override
  String get settingsPeerTokensRevokeConfirmCancel => 'Cancelar';

  @override
  String get settingsPeerTokensRevokeConfirmAction => 'Revocar';

  @override
  String settingsPeerTokensRevokedToast(String name) {
    return 'Par $name revocado';
  }

  @override
  String get skappListenerCardRotateCertButton => 'Rotar certificado TLS';

  @override
  String get skappListenerCardRotateCertConfirmTitle =>
      '¿Rotar el certificado?';

  @override
  String get skappListenerCardRotateCertConfirmBody =>
      'Se generará un nuevo certificado TLS autofirmado. Todos los pares emparejados previamente fallarán en el protocolo de enlace hasta que se emparejen de nuevo.';

  @override
  String get skappListenerCardRotateCertConfirmCancel => 'Cancelar';

  @override
  String get skappListenerCardRotateCertConfirmAction => 'Rotar';

  @override
  String get skappListenerCardRotateCertDoneSnack =>
      'Certificado TLS rotado. Empareja de nuevo todos los dispositivos.';

  @override
  String get skappListenerCardCertFingerprintLabel => 'Huella TLS';

  @override
  String skappListenerCardErrorPortInUse(int port) {
    return 'El puerto $port ya está en uso. Elige un puerto diferente en Identidad de red.';
  }

  @override
  String skappListenerCardErrorGeneric(String error) {
    return 'No se pudo iniciar el receptor: $error';
  }

  @override
  String get skappPeerPairingTitle => 'Emparejar SKAPP de escritorio';

  @override
  String get skappPeerPairingSubtitle =>
      'Escanea el QR que se muestra en los Ajustes del SKAPP de escritorio, o pega el código de emparejamiento manualmente.';

  @override
  String get skappPeerPairingTabScan => 'Escanear QR';

  @override
  String get skappPeerPairingTabManual => 'Manual';

  @override
  String get skappPeerPairingScanHint =>
      'Apunta la cámara al QR que se muestra en SKAPP de escritorio > Ajustes > Receptor HTTP de SKAPP.';

  @override
  String get skappPeerPairingScanCameraDeniedTitle =>
      'Se requiere permiso de cámara';

  @override
  String get skappPeerPairingScanCameraDeniedBody =>
      'Permite el acceso a la cámara desde los ajustes de tu teléfono para escanear el QR de emparejamiento. También puedes introducir el código manualmente.';

  @override
  String get skappPeerPairingManualHostLabel =>
      'IP o nombre de host del equipo de escritorio';

  @override
  String get skappPeerPairingManualPortLabel => 'Puerto';

  @override
  String get skappPeerPairingManualTokenLabel => 'Token Bearer';

  @override
  String get skappPeerPairingManualUuidLabel => 'UUID del equipo de escritorio';

  @override
  String get skappPeerPairingManualNameLabel => 'Nombre visible';

  @override
  String get skappPeerPairingManualSubmit => 'Emparejar';

  @override
  String skappPeerPairingSavedToast(String name) {
    return 'Emparejado con $name';
  }

  @override
  String skappPeerPairingFailedToast(String reason) {
    return 'El emparejamiento falló: $reason';
  }

  @override
  String get skappPeerPairingShowQrTitle =>
      'Empareja un teléfono con este equipo de escritorio';

  @override
  String get skappPeerPairingShowQrBody =>
      'Abre SKAPP en tu teléfono, ve a SKAPI > Ajustes > Emparejar equipo de escritorio y escanea este QR. El QR contiene el token Bearer, trátalo como una contraseña.';

  @override
  String get skappPeerPairingShowQrCloseButton => 'Hecho';

  @override
  String get skappPeerListEmpty =>
      'Aún no hay ningún equipo de escritorio emparejado. Empareja uno para ejecutar scripts desde este teléfono.';

  @override
  String get skappPeerListSectionTitle => 'SKAPP de escritorio emparejados';

  @override
  String get skappPeerStatusOnline => 'En línea';

  @override
  String get skappPeerStatusOffline => 'Desconectado';

  @override
  String skappPeerStatusLastSeen(String when) {
    return 'Visto por última vez $when';
  }

  @override
  String get skappPeerRemoveTooltip =>
      'Eliminar equipo de escritorio emparejado';

  @override
  String get skappPeerRemoveConfirmTitle => '¿Eliminar el emparejamiento?';

  @override
  String skappPeerRemoveConfirmBody(String name) {
    return 'Los scripts activados desde este teléfono ya no se ejecutarán en $name hasta que vuelvas a emparejar.';
  }

  @override
  String get skappPeerScanRefreshTooltip => 'Actualizar lista de pares';

  @override
  String skapiRunRemoteSheetTitle(String peerName) {
    return 'Ejecutar de forma remota en $peerName';
  }

  @override
  String get skapiRunRemoteConnecting =>
      'Conectando con el equipo de escritorio...';

  @override
  String get skapiRunRemoteOfflineError =>
      'El equipo de escritorio emparejado está desconectado. Prueba a actualizar los pares o comprueba el receptor del equipo de escritorio.';

  @override
  String get skapiRunRemoteUnauthorizedError =>
      'Token Bearer rechazado. El token del equipo de escritorio puede haber rotado. Empareja de nuevo desde Ajustes.';

  @override
  String skapiRunRemoteHttpError(String reason) {
    return 'La ejecución remota falló: $reason';
  }

  @override
  String get skapiRunMobileNoPeerTitle => 'Sin equipo de escritorio emparejado';

  @override
  String get skapiRunMobileNoPeerBody =>
      'Empareja un SKAPP de escritorio desde Ajustes para ejecutar scripts desde este teléfono.';

  @override
  String get skapiRunMobileNoPeerCta => 'Abrir Ajustes';

  @override
  String get skapiRunRemoteNotWhitelisted =>
      'Este script no está marcado como ejecutable de forma remota. Ejecútalo directamente en el equipo de escritorio.';

  @override
  String get skapiRunRemoteNoPeerHint =>
      'Empareja un SKAPP de escritorio desde Ajustes para ejecutar scripts desde este teléfono.';

  @override
  String get skapiRunRemoteNoPeerAction => 'Abrir ajustes';

  @override
  String get skappPeerPickerTitle => '¿A qué equipo enviar?';

  @override
  String get skappPeerPickerSubtitle =>
      'Elige el SKAPP de escritorio emparejado que debe ejecutar este script.';

  @override
  String get skappPeerPickerOfflineReason => 'Desconectado';

  @override
  String get skappPeerPickerDevModeOffReason =>
      'El modo de desarrollador está desactivado';

  @override
  String get skappPeerPickerEmpty =>
      'No hay equipos de escritorio emparejados para elegir.';

  @override
  String get skapiRunRemoteCancelButton => 'Cancelar';

  @override
  String get skapiRunRemoteCancelledNote => 'Ejecución cancelada';

  @override
  String skapiRunRemoteTooManyRuns(int running, int limit) {
    return 'Ese equipo de escritorio ya tiene $running scripts en ejecución ($limit máx.). Espera a que termine uno.';
  }

  @override
  String get skappPeerHealthDevModeBadge => 'Modo dev';

  @override
  String get remoteRunActivityCardTitle => 'Ejecuciones remotas';

  @override
  String get remoteRunActivityCardSubtitle =>
      'Ejecuciones recientes de scripts que los pares móviles emparejados pidieron realizar a este equipo de escritorio.';

  @override
  String get remoteRunActivityCardEmpty => 'Aún no hay ejecuciones remotas.';

  @override
  String get remoteRunActivityCardClear => 'Borrar historial';

  @override
  String remoteRunActivityRowOk(int exitCode, int durationMs) {
    return 'salida $exitCode · $durationMs ms';
  }

  @override
  String get remoteRunActivityRowCancelled => 'cancelada';

  @override
  String remoteRunActivityRowRejected(String reason) {
    return 'rechazada · $reason';
  }

  @override
  String get mobileTriggerCardTitle => 'Activar';

  @override
  String get mobileTriggerCardSubtitle =>
      'Envía un evento de toque a un SKAPP de escritorio emparejado. Cualquier vínculo a la escucha de este evento disparará su script en ese equipo de escritorio.';

  @override
  String get mobileTriggerCardSendButton => 'Enviar toque';

  @override
  String get mobileTriggerCardSending => 'Enviando...';

  @override
  String mobileTriggerSentToast(String name) {
    return 'Toque enviado a $name';
  }

  @override
  String get skapiBindEventMobileTap => 'Toque móvil';

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
  String get msHomeScreenTitle => 'Par móvil';

  @override
  String get msHomeScreenNotFound => 'Este par móvil ya no está emparejado.';

  @override
  String get msHomeScreenEventsHeader => 'Eventos disponibles';

  @override
  String msHomeScreenBindingsHeader(int count) {
    return 'Vínculos ($count)';
  }

  @override
  String get msHomeScreenBindingsEmpty =>
      'Aún no hay vínculos. Usa SKAPI → script → Vincular a una acción para conectar un evento de toque a un script.';

  @override
  String get msHomeScreenHint =>
      'Los teléfonos no ejecutan scripts. Emiten eventos disparadores que este equipo de escritorio vincula a scripts.';

  @override
  String msHomeScreenPairedAt(String date) {
    return 'Emparejado $date';
  }

  @override
  String get skapiGroupNotifyTitle => 'Notificar y diálogo';

  @override
  String get skapiGroupNotifyDesc =>
      'Los scripts de este grupo se comunican directamente con el usuario: muestran un aviso emergente, un diálogo modal o esperan una respuesta de sí/no. Úsalos cuando el evento de un dispositivo SmartKraft necesita que la persona frente a la pantalla confirme o decida.';

  @override
  String get skapiGroupNotifyFoot =>
      'Uso típico: diálogo antes de una acción destructiva, aviso emergente para un recordatorio suave, diálogo con tiempo de espera para continuar automáticamente.';

  @override
  String get skapiScriptDialogTitle => 'Mostrar diálogo';

  @override
  String get skapiScriptDialogSummaryWhat =>
      'Muestra un MessageBox modal de Windows y devuelve la elección del usuario (ok / cancel / yes / no / timeout).';

  @override
  String get skapiScriptDialogSummaryHow =>
      'Llama a System.Windows.Forms.MessageBox en un runspace secundario para que el script pueda competir el diálogo contra un tiempo de espera opcional. El valor elegido se escribe en stdout para que el llamador bifurque.';

  @override
  String get skapiScriptDialogNote =>
      'stdout es la respuesta del usuario en minúsculas. timeout=0 espera indefinidamente.';

  @override
  String get skapiScriptDialogParamTitleLabel => 'title';

  @override
  String get skapiScriptDialogParamTitleHint =>
      'Título de la ventana que se muestra en el cuadro de mensaje.';

  @override
  String get skapiScriptDialogParamBodyLabel => 'body';

  @override
  String get skapiScriptDialogParamBodyHint =>
      'La pregunta o el mensaje que se muestra al usuario.';

  @override
  String get skapiScriptDialogParamButtonsLabel => 'buttons';

  @override
  String get skapiScriptDialogParamButtonsHint =>
      'ok / ok_cancel / yes_no / yes_no_cancel. Predeterminado ok_cancel.';

  @override
  String get skapiScriptDialogParamTimeoutLabel => 'timeout';

  @override
  String get skapiScriptDialogParamTimeoutHint =>
      'Segundos de espera antes de continuar con \'timeout\'. 0 significa esperar para siempre.';

  @override
  String get skapiScriptToastTitle => 'Mostrar aviso emergente';

  @override
  String get skapiScriptToastSummaryWhat =>
      'Muestra una notificación emergente de Windows con un título y un cuerpo. Se desliza desde la esquina inferior derecha y aterriza en el Centro de actividades.';

  @override
  String get skapiScriptToastSummaryHow =>
      'Construye una carga XML de ToastNotification y la entrega al ToastNotificationManager de WinRT bajo el AppUserModelID configurado.';

  @override
  String get skapiScriptToastNote =>
      'Nivel 2: requiere Windows 10+ y un AppUserModelID registrado para la mejor experiencia. El AUMID predeterminado coloca el aviso bajo PowerShell en el Centro de actividades.';

  @override
  String get skapiScriptToastParamTitleLabel => 'title';

  @override
  String get skapiScriptToastParamTitleHint =>
      'Primera línea en negrita del aviso emergente.';

  @override
  String get skapiScriptToastParamBodyLabel => 'body';

  @override
  String get skapiScriptToastParamBodyHint =>
      'Segunda línea más pequeña. Opcional.';

  @override
  String get skapiScriptToastParamAumidLabel => 'aumid';

  @override
  String get skapiScriptToastParamAumidHint =>
      'App User Model ID bajo el cual aparece el aviso. El valor predeterminado recurre a PowerShell.';

  @override
  String get skapiGroupVisualBreakTitle => 'Pausa visual';

  @override
  String get skapiGroupVisualBreakDesc =>
      'Señales visuales suaves que alejan al usuario del trabajo intenso: atenuar la pantalla, cambiar a escala de grises, localizar el cursor o mostrar el escritorio. Los efectos de este grupo son reversibles y nunca bloquean la entrada por completo.';

  @override
  String get skapiGroupVisualBreakFoot =>
      'Uso típico: atenuar la pantalla al inicio de una pausa de concentración, modo escala de grises para lecturas nocturnas, localizar el ratón en configuraciones de varios monitores.';

  @override
  String get skapiScriptShowDesktopTitle => 'Mostrar escritorio';

  @override
  String get skapiScriptShowDesktopSummaryWhat =>
      'Alterna \'mostrar escritorio\'. Igual que pulsar Win+D dos veces seguidas.';

  @override
  String get skapiScriptShowDesktopSummaryHow =>
      'Llama a Shell.Application.ToggleDesktop mediante COM. Volver a ejecutarlo restaura la disposición de ventanas anterior.';

  @override
  String get skapiScriptFadeScreenTitle => 'Atenuar pantalla';

  @override
  String get skapiScriptFadeScreenSummaryWhat =>
      'Atenúa el brillo de la pantalla interna desde su nivel actual hasta un nivel objetivo a lo largo de unos segundos.';

  @override
  String get skapiScriptFadeScreenSummaryHow =>
      'Lee el brillo actual mediante WMI WmiMonitorBrightness y luego avanza WmiSetBrightness en incrementos lineales hacia el objetivo para que el cambio se sienta suave.';

  @override
  String get skapiScriptFadeScreenNote =>
      'Nivel 2: el brillo por WMI solo funciona en paneles internos. Los monitores externos no responden por esta vía.';

  @override
  String get skapiScriptFadeScreenParamTargetLabel => 'target';

  @override
  String get skapiScriptFadeScreenParamTargetHint =>
      'Porcentaje de brillo final (0-100).';

  @override
  String get skapiScriptFadeScreenParamDurationLabel => 'duration';

  @override
  String get skapiScriptFadeScreenParamDurationHint =>
      'Segundos que debe tardar la atenuación. El script usa diez pasos de brillo por segundo.';

  @override
  String get skapiScriptGrayscaleTitle => 'Filtro de escala de grises';

  @override
  String get skapiScriptGrayscaleSummaryWhat =>
      'Activa o desactiva el modo de escala de grises de los Filtros de color de Windows.';

  @override
  String get skapiScriptGrayscaleSummaryHow =>
      'Escribe las claves de registro ColorFiltering y luego envía Win+Ctrl+C para que Windows aplique el cambio en directo sin cerrar sesión.';

  @override
  String get skapiScriptGrayscaleNote =>
      'Nivel 2: requiere que Ajustes > Accesibilidad > Filtros de color > \'Permitir la tecla de acceso directo\' esté activado para que la alternancia en directo funcione.';

  @override
  String get skapiScriptGrayscaleParamOnLabel => 'on';

  @override
  String get skapiScriptGrayscaleParamOnHint =>
      'true para activar la escala de grises, false para desactivarla.';

  @override
  String get skapiScriptGrayscaleParamDurationLabel => 'duration';

  @override
  String get skapiScriptGrayscaleParamDurationHint =>
      '0 solo alterna. >0 vuelve automáticamente al color tras los segundos indicados. Ideal para pausas visuales.';

  @override
  String get skapiScriptFindMouseShakeTitle => 'Localizar ratón';

  @override
  String get skapiScriptFindMouseShakeSummaryWhat =>
      'Mueve el cursor en un pequeño círculo para atraer la mirada a su posición. El cursor vuelve a su punto de partida cuando termina la animación.';

  @override
  String get skapiScriptFindMouseShakeSummaryHow =>
      'Lee la posición actual del cursor con GetCursorPos y luego repite SetCursorPos alrededor de un círculo del radio configurado. Útil en configuraciones de varios monitores y 4K.';

  @override
  String get skapiScriptFindMouseShakeNote =>
      'Nivel 2: SetCursorPos puede ser bloqueado por software de accesibilidad, y el comportamiento varía en sesiones de escritorio remoto.';

  @override
  String get skapiScriptFindMouseShakeParamRadiusLabel => 'radius';

  @override
  String get skapiScriptFindMouseShakeParamRadiusHint =>
      'Píxeles que recorre el cursor desde su origen durante el bucle. Cuanto mayor, más llamativo.';

  @override
  String get skapiScriptFindMouseShakeParamLoopsLabel => 'loops';

  @override
  String get skapiScriptFindMouseShakeParamLoopsHint =>
      'Cuántos círculos completos dibujar antes de detenerse.';

  @override
  String get skapiGroupProgramsTitle => 'Control de programas específicos';

  @override
  String get skapiGroupProgramsDesc =>
      'Scripts dirigidos a apps y navegadores concretos: guardar+cerrar de forma ordenada, cierre de varias instancias, limpieza de todo el navegador. Útiles cuando un dispositivo SmartKraft quiere finalizar un flujo de trabajo concreto sin arrasar todo el escritorio.';

  @override
  String get skapiGroupProgramsFoot =>
      'Uso típico: guardar y cerrar todos los editores antes de suspender, cerrar todos los navegadores al final del día, limpieza acotada de una familia de procesos.';

  @override
  String get skapiScriptCloseWithSaveTitle => 'Guardar y cerrar app';

  @override
  String get skapiScriptCloseWithSaveSummaryWhat =>
      'Envía Ctrl+S a una app de destino para activar su propio guardado, espera y luego cierra la ventana de forma ordenada.';

  @override
  String get skapiScriptCloseWithSaveSummaryHow =>
      'Enfoca cada instancia en ejecución, envía Ctrl+S mediante SendKeys, espera el intervalo configurado y luego publica WM_CLOSE para que la app pueda confirmar o terminar de guardar.';

  @override
  String get skapiScriptCloseWithSaveNote =>
      'Nivel 2: depende de que la app interprete Ctrl+S como \'guardar\'. Algunas apps de chat / web lo tratan de forma diferente. Pruébalo con las apps que realmente usas.';

  @override
  String get skapiScriptCloseWithSaveParamProcessLabel => 'processName';

  @override
  String get skapiScriptCloseWithSaveParamProcessHint =>
      'Nombre de proceso sin .exe (winword, excel, code, photoshop). Se guardan y cierran todas las instancias en ejecución.';

  @override
  String get skapiScriptCloseWithSaveParamWaitLabel => 'wait';

  @override
  String get skapiScriptCloseWithSaveParamWaitHint =>
      'Segundos de espera entre Ctrl+S y la señal de cierre para que la app termine de guardar.';

  @override
  String get skapiScriptCloseAllInstancesTitle => 'Cerrar todas las instancias';

  @override
  String get skapiScriptCloseAllInstancesSummaryWhat =>
      'Envía un cierre ordenado a cada ventana visible de un proceso. Cada instancia puede mostrar su propio diálogo de guardado.';

  @override
  String get skapiScriptCloseAllInstancesSummaryHow =>
      'Itera los procesos coincidentes mediante Get-Process y publica WM_CLOSE en la ventana principal de cada uno. Sin recurso a cierre forzado.';

  @override
  String get skapiScriptCloseAllInstancesParamProcessLabel => 'processName';

  @override
  String get skapiScriptCloseAllInstancesParamProcessHint =>
      'Nombre de proceso sin .exe. Coincide con todas las instancias.';

  @override
  String get skapiScriptBrowserCloseAllTitle => 'Cerrar todos los navegadores';

  @override
  String get skapiScriptBrowserCloseAllSummaryWhat =>
      'Cierra de forma ordenada cada navegador habitual en ejecución (Chrome, Edge, Firefox, Brave, Vivaldi, Opera).';

  @override
  String get skapiScriptBrowserCloseAllSummaryHow =>
      'Itera los nombres de proceso de navegadores conocidos y publica WM_CLOSE en cada ventana principal. Los navegadores modernos conservan la sesión si \'restaurar pestañas en el próximo inicio\' está activado.';

  @override
  String get skapiScriptBrowserCloseAllNote =>
      'No se usa el cierre forzado. Para borrar también la sesión, usa kill-app por navegador en su lugar.';

  @override
  String get skapiTierBadgeExperimental => 'Experimental';

  @override
  String get skapiTierBadgeExperimentalTooltip =>
      'Este script depende de una API de Windows que puede no ser fiable en todas las máquinas. Pruébalo antes de confiar en él.';

  @override
  String get skapiTierBadgeBlocked => 'Próximamente';

  @override
  String get skapiTierBadgeBlockedTooltip =>
      'Este script forma parte de la biblioteca planificada pero aún no está implementado.';

  @override
  String get skapiGroupSaveWorkTitle => 'Guardar trabajo';

  @override
  String get skapiGroupSaveWorkDesc =>
      'Los scripts de este grupo guardan tu trabajo abierto en el disco antes de una pausa o un apagado inesperado. Cuando tu dispositivo SmartKraft activa una pausa, el script elegido guarda automáticamente tu archivo en Word, Excel, VS Code o cualquier otro editor, de modo que aunque tu equipo se suspenda, se apague o ejecute otro comando, tu trabajo queda a salvo.';

  @override
  String get skapiGroupSaveWorkFoot =>
      'Uso típico: guardado automático al inicio de una pausa de concentración, copia de seguridad del documento ante un aviso de batería baja, o un disparador de \"guardar todo\" con un solo botón.';

  @override
  String get skapiScriptSaveActiveWindowTitle => 'Guardar ventana activa';

  @override
  String get skapiScriptSaveActiveWindowSummaryWhat =>
      'Envía un Ctrl+S virtual a la ventana de Windows que tenga el foco en ese momento, activando el comportamiento de \"guardar\" propio de esa aplicación.';

  @override
  String get skapiScriptSaveActiveWindowSummaryHow =>
      'Primero captura el identificador de la ventana activa y registra su título. Luego envía Ctrl+S mediante SendKeys. Word guarda en su ruta actual, VS Code escribe el archivo. Si aparece un diálogo \"Guardar como\", espera hasta que el usuario confirme manualmente.';

  @override
  String get skapiScriptSaveActiveWindowParamTimeoutLabel => 'timeout';

  @override
  String get skapiScriptSaveActiveWindowParamTimeoutHint =>
      'Segundos de espera tras enviar la pulsación para que la app tenga tiempo de escribir el archivo.';

  @override
  String get skapiScriptSaveActiveWindowParamVerboseLabel => 'verbose';

  @override
  String get skapiScriptSaveAllOpenTitle =>
      'Guardar todos los documentos abiertos';

  @override
  String get skapiScriptSaveAllOpenSummaryWhat =>
      'Recorre una lista blanca de editores en ejecución y le dice a cada uno que guarde sus documentos abiertos.';

  @override
  String get skapiScriptSaveAllOpenSummaryHow =>
      'Por cada proceso de la lista blanca encontrado, enfoca la ventana principal, envía Ctrl+S y luego espera el tiempo de espera configurado por app antes de continuar. Las apps que no están en ejecución se omiten silenciosamente a menos que el modo detallado esté activado.';

  @override
  String get skapiScriptSaveAllOpenNote =>
      'La lista blanca incluye por defecto Word, Excel, PowerPoint y VS Code. Edita el parámetro apps para añadir los tuyos.';

  @override
  String get skapiScriptSaveAllOpenParamAppsLabel => 'apps';

  @override
  String get skapiScriptSaveAllOpenParamAppsHint =>
      'Nombres de proceso (sin .exe) a los que enviar guardar. El orden importa: las primeras entradas se procesan primero.';

  @override
  String get skapiScriptSaveAllOpenParamTimeoutLabel => 'timeoutPerApp';

  @override
  String get skapiScriptSaveAllOpenParamVerboseLabel => 'verbose';

  @override
  String get skapiScriptAutosaveTriggerTitle => 'Activar guardado automático';

  @override
  String get skapiScriptAutosaveTriggerSummaryWhat =>
      'Difunde un comando de guardado de Windows a cada ventana de nivel superior visible en una sola pasada.';

  @override
  String get skapiScriptAutosaveTriggerSummaryHow =>
      'Enumera las ventanas visibles y luego envía a cada una un WM_COMMAND con el id de guardado estándar. Las apps que escuchan ese mensaje reaccionan como si hubieras hecho clic en el elemento Guardar del menú Archivo. Más rápido que un Ctrl+S por ventana, pero algunas apps ignoran la difusión.';

  @override
  String get skapiScriptAutosaveTriggerNote =>
      'Úsalo cuando quieras volcar todos los editores a la vez y no te importe que algunas apps no respondan. Combínalo con guardar-todo-abierto para una cobertura más estricta.';

  @override
  String get skapiScriptAutosaveTriggerParamDelayLabel => 'delay';

  @override
  String get skapiScriptAutosaveTriggerParamDelayHint =>
      'Segundos de espera antes de difundir, útil cuando quieres que la notificación de pausa del dispositivo aparezca primero.';

  @override
  String get skapiScriptAutosaveTriggerParamVerboseLabel => 'verbose';

  @override
  String get skapiScriptDetailSummaryWhatLabel => 'Qué hace:';

  @override
  String get skapiScriptDetailSummaryHowLabel => 'Cómo funciona:';

  @override
  String get skapiScriptDetailOriginalSectionTitle => 'Script original';

  @override
  String get skapiScriptDetailOriginalSectionSub => 'solo lectura · inglés';

  @override
  String get skapiScriptDetailEditingSectionTitle => 'Ediciones';

  @override
  String get skapiScriptDetailEditingNotYet => 'Aún sin ediciones';

  @override
  String get skapiScriptDetailEditingNotYetSub =>
      'Crea una copia en este dispositivo sin cambiar el original.';

  @override
  String get skapiScriptDetailEditingModified => 'Editado';

  @override
  String skapiScriptDetailEditingModifiedSub(String date) {
    return 'Último cambio $date.';
  }

  @override
  String get skapiScriptDetailEditingOutdated => 'Biblioteca actualizada';

  @override
  String get skapiScriptDetailEditingOutdatedSub =>
      'El original cambió con una actualización de la app. Compara o restablece.';

  @override
  String get skapiScriptDetailParamWarnTitle =>
      'Comprueba los parámetros antes de ejecutar';

  @override
  String get skapiScriptDetailParamWarnHint =>
      'Para cambiar estos valores, usa \"Editar\". Los parámetros se definen en el bloque param() del script.';

  @override
  String get skapiScriptDetailNotesTitle => 'Notas';

  @override
  String get skapiScriptDetailButtonRun => 'Ejecutar ahora';

  @override
  String get skapiScriptDetailButtonBindAction => 'Vincular a una acción';

  @override
  String get skapiScriptDetailButtonEdit => 'Editar';

  @override
  String get skapiScriptDetailButtonView => 'Ver';

  @override
  String get skapiScriptDetailButtonReset => 'Restablecer';

  @override
  String get skapiScriptDetailButtonCompare => 'Comparar';

  @override
  String get skapiScriptCopyButton => 'Copiar';

  @override
  String get skapiScriptCopyButtonDone => 'Copiado';

  @override
  String get skapiScriptSelectButton => 'Seleccionar';

  @override
  String get skapiEditorTitle => 'Editar';

  @override
  String skapiEditorHint(String scriptId) {
    return '$scriptId · Estás editando una copia en este dispositivo. La versión original de la biblioteca no cambia. \"Restablecer\" siempre restaura el original.';
  }

  @override
  String get skapiEditorStatusBarTitle => 'POWERSHELL · UTF-8';

  @override
  String get skapiEditorStatusModified => '● Modificado';

  @override
  String get skapiEditorStatusUnmodified => 'Sin cambios';

  @override
  String skapiEditorFootCursor(int line, int column) {
    return 'Línea $line · Columna $column';
  }

  @override
  String get skapiEditorFootSaveLabel => 'Guardar';

  @override
  String skapiEditorDiffLineCount(int count) {
    return '$count línea cambiada';
  }

  @override
  String skapiEditorDiffLinesCount(int count) {
    return '$count líneas cambiadas';
  }

  @override
  String get skapiEditorDiffCompareLink => 'Comparar con el original';

  @override
  String get skapiEditorButtonReset => 'Restablecer';

  @override
  String get skapiEditorButtonSave => 'Guardar';

  @override
  String get skapiEditorAfterSaveNote =>
      'Tras guardar, \"Ejecutar ahora\" ejecutará la versión editada.';

  @override
  String get skapiLinuxDistroHeading => 'Elige la familia de tu distribución';

  @override
  String get skapiLinuxDistroSubtitle =>
      'Los scripts de Linux divergen entre las familias basadas en Debian (apt, .deb) y las basadas en Arch (pacman). Elige la que coincida con tu máquina.';

  @override
  String get skapiLinuxDistroDebianLabel => 'Basada en Debian';

  @override
  String get skapiLinuxDistroDebianSub =>
      'Debian, Ubuntu, Mint, Pop!_OS, Elementary, Kali, MX, Zorin';

  @override
  String get skapiLinuxDistroArchLabel => 'Basada en Arch';

  @override
  String get skapiLinuxDistroArchSub =>
      'Arch, Manjaro, EndeavourOS, Garuda (más adelante)';

  @override
  String get skapiNewActionNoDevicesTitle => 'Empareja primero un dispositivo';

  @override
  String get skapiNewActionNoDevicesBody =>
      'Crear una acción en el dispositivo requiere al menos un dispositivo SmartKraft emparejado (BF por ahora).';

  @override
  String get skapiNewActionNoDevicesCta => 'Abrir Dispositivos';

  @override
  String get skapiNewActionPickDeviceTitle => 'Elige un dispositivo';

  @override
  String get skapiNewActionPickDeviceSubtitle =>
      '¿En qué dispositivo debe residir esta acción?';

  @override
  String get skapiUserNewTitle => 'Nuevo script';

  @override
  String get skapiUserEditTitle => 'Editar script';

  @override
  String get skapiUserTitleLabel => 'Título';

  @override
  String get skapiUserTitleHint => 'p. ej. Rutina matutina';

  @override
  String get skapiUserDescLabel => 'Descripción';

  @override
  String get skapiUserDescHint => '¿Qué hace este script?';

  @override
  String get skapiUserPlatformLabel => 'Plataforma';

  @override
  String get skapiUserCodeLabel => 'Código';

  @override
  String get skapiUserCodeHint => '# Tu código de PowerShell aquí';

  @override
  String get skapiUserSaveCta => 'Guardar';

  @override
  String get skapiUserValidationEmpty =>
      'El título y el código no pueden estar vacíos.';

  @override
  String get skapiUserSavedSnack => 'Script guardado';

  @override
  String get skapiUserSectionHeading => 'Mis scripts';

  @override
  String skapiUserSectionSub(int count) {
    return '$count scripts';
  }

  @override
  String get skapiUserEmptyHint =>
      'Aún no tienes scripts propios. Crea uno con el botón Nueva acción, arriba a la derecha.';

  @override
  String get skapiUserDetailCodeHeading => 'Código';

  @override
  String get skapiUserEditCta => 'Editar';

  @override
  String get skapiUserDeleteConfirmTitle => '¿Eliminar script?';

  @override
  String skapiUserDeleteConfirmBody(String name) {
    return '$name se eliminará permanentemente.';
  }

  @override
  String get skapiUserDeletedSnack => 'Script eliminado';

  @override
  String get skapiUserRunCta => 'Ejecutar';

  @override
  String get skapiUserRunUnsupported =>
      'La ejecución de scripts es solo para escritorio.';

  @override
  String get skapiUserRunOutputTitle => 'Salida de la ejecución';

  @override
  String skapiUserRunDone(int code) {
    return 'Finalizado (salida $code)';
  }

  @override
  String get skapiLocalScriptsSubheading => 'Scripts locales';

  @override
  String get skapiOnDeviceApiSubheading => 'API en el dispositivo';

  @override
  String get skapiOnDeviceApiLoadError => 'No se pudieron leer los endpoints';

  @override
  String get skapiOnDeviceApiRowHint =>
      'Toca cualquier fila para abrir el editor';

  @override
  String get commonLoading => 'Cargando...';

  @override
  String get skapiApiTemplateSectionHeader => 'Plantillas';

  @override
  String skapiApiTemplateSectionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count plantillas',
      one: '1 plantilla',
    );
    return '$_temp0';
  }

  @override
  String get skapiApiTemplateUploadCta => 'Subir al dispositivo';

  @override
  String get skapiApiTemplateUploadHint =>
      'Al subirla, esta plantilla se escribe en una de las 5 ranuras de API USER del dispositivo. El dispositivo la dispara con su propio disparador (BF: fin de la cuenta atrás).';

  @override
  String get skapiApiTemplatePreviewTitle => 'Vista previa del endpoint';

  @override
  String get skapiApiTemplatePreviewType => 'Tipo';

  @override
  String get skapiApiTemplatePreviewMethod => 'Método';

  @override
  String get skapiApiTemplatePreviewUrl => 'URL';

  @override
  String get skapiApiTemplatePreviewAuth => 'Autenticación';

  @override
  String get skapiApiTemplatePreviewHeader => 'Cabecera';

  @override
  String get skapiApiTemplatePreviewContentType => 'Content-Type';

  @override
  String get skapiApiTemplatePreviewPayload => 'Carga útil';

  @override
  String get skapiApiTemplatePreviewDelay => 'Retardo';

  @override
  String get skapiOtherCategoryHeading => 'Elige una categoría de dispositivo';

  @override
  String get skapiOtherCategorySubtitle =>
      'Las plantillas se suben al dispositivo emparejado y se disparan con el propio disparador del dispositivo (sin que intervenga el portátil).';

  @override
  String get skapiOtherSyndimmSub =>
      'Regulador de luz inteligente de SmartKraft';

  @override
  String get skapiOtherLebensspurSub => 'Rastreador de actividad de SmartKraft';

  @override
  String get skapiOtherBlockingfocusSub =>
      'Temporizador de concentración de SmartKraft';

  @override
  String get skapiOtherIotSub =>
      'Webhooks de IoT de terceros (IFTTT, Home Assistant, REST genérico)';

  @override
  String get skapiOtherServerSub =>
      'Receptores HTTP autoalojados (n8n, Node-RED, personalizados)';

  @override
  String get skapiCategoryComingSoon => 'Plantillas próximamente';

  @override
  String get skapiScriptLockSummaryHowLxDebian =>
      'Llama a loginctl lock-session para el XDG_SESSION_ID actual; recurre a xdg-screensaver lock cuando loginctl no está disponible.';

  @override
  String get skapiScriptHibernateSummaryHowLxDebian =>
      'Llama a systemctl hibernate. Un retardo opcional duerme los segundos solicitados antes de suspender.';

  @override
  String get skapiScriptHibernateNoteLxDebian =>
      'La hibernación debe estar configurada (swap >= RAM y el parámetro de kernel resume=). En sistemas donde no lo está, systemd-logind recurre a la suspensión.';

  @override
  String get skapiScriptSleepSummaryHowLxDebian =>
      'Llama a systemctl suspend. El kernel puede retrasarlo si un inhibidor en primer plano bloquea las transiciones a inactividad.';

  @override
  String get skapiScriptShutdownSummaryHowLxDebian =>
      'Programa un apagado ordenado mediante /sbin/shutdown -h +N (minutos). Recurre a systemctl poweroff tras el retardo solicitado si falta shutdown.';

  @override
  String get skapiScriptShutdownNoteLxDebian =>
      '/sbin/shutdown solo admite minutos; los valores inferiores a 60 se redondean a 1 minuto. Otros usuarios con sesión iniciada ven un mensaje wall durante la cuenta atrás.';

  @override
  String get skapiScriptShutdownParamForceHintLxDebian =>
      'Termina la sesión del usuario antes de apagar, de modo que se omite el periodo de gracia de 90 s de SIGTERM.';

  @override
  String get skapiScriptBrightnessSummaryHowLxDebian =>
      'Ajusta la retroiluminación de la pantalla interna mediante brightnessctl set N% (preferido) o light -S N como alternativa. Ambos escriben en /sys/class/backlight.';

  @override
  String get skapiScriptBrightnessNoteLxDebian =>
      'brightnessctl no necesita sudo cuando el usuario está en el grupo video, que es el predeterminado tras la instalación en la mayoría de configuraciones de Debian. Los monitores externos por DDC necesitan ddcutil y no se gestionan aquí.';

  @override
  String get skapiScriptMuteToggleSummaryHowLxDebian =>
      'Alterna o ajusta el silencio del sink maestro mediante wpctl (PipeWire en Debian 12+) con una alternativa pactl para configuraciones de PulseAudio.';

  @override
  String get skapiScriptVolumeSetSummaryHowLxDebian =>
      'Ajusta el volumen del sink maestro a un nivel 0-100 mediante wpctl set-volume (PipeWire) o pactl set-sink-volume (PulseAudio).';

  @override
  String get skapiScriptVolumeSetNoteLxDebian =>
      'Tanto PipeWire como PulseAudio exponen el volumen por app de forma nativa, por lo que este script es de nivel 1 en Linux. La salida por encima del 100% se limita para mantener la paridad con otras plataformas.';

  @override
  String get skapiScriptMediaKeySummaryHowLxDebian =>
      'Envía una acción de tecla multimedia mediante playerctl, que usa MPRIS para comunicarse con la app que posea la sesión en ese momento (Spotify, Firefox, VLC, mpv, Rhythmbox).';

  @override
  String get skapiScriptMediaKeyNoteLxDebian =>
      'Si no hay ninguna app multimedia compatible con MPRIS en ejecución, el comando no tiene efecto. Instala la compatibilidad con MPRIS de la app si un reproductor conocido no responde.';

  @override
  String get skapiScriptMinimizeWindowSummaryHowLxDebian =>
      'Un processName vacío minimiza la ventana enfocada mediante xdotool. De lo contrario, elige la primera ventana cuyo WM_CLASS coincida y la minimiza.';

  @override
  String get skapiScriptMinimizeWindowNoteLxDebian =>
      'Solo X11. La coincidencia de WM_CLASS distingue mayúsculas y minúsculas y depende de cómo se haya declarado la app; consulta xprop WM_CLASS si tienes dudas.';

  @override
  String get skapiScriptMinimizeWindowParamProcessHintLxDebian =>
      'Nombre de instancia WM_CLASS (por ejemplo: firefox, code, gnome-terminal-server). Vacío apunta a la ventana activa.';

  @override
  String get skapiScriptCloseWindowSummaryHowLxDebian =>
      'Envía WM_DELETE_WINDOW mediante wmctrl -x -c (coincide con WM_CLASS) con una alternativa por título. Equivale a hacer clic en el botón X; la app puede mostrar su propio diálogo de guardado.';

  @override
  String get skapiScriptCloseWindowNoteLxDebian =>
      'Solo X11. Para Wayland, usa preferiblemente kill-app, que utiliza señales en lugar del protocolo de ventanas.';

  @override
  String get skapiScriptCloseWindowParamProcessHintLxDebian =>
      'Nombre de instancia WM_CLASS; vacío cierra la ventana enfocada. Como alternativa se usa la coincidencia de subcadena del título.';

  @override
  String get skapiScriptKillAppSummaryHowLxDebian =>
      'pkill -TERM -x por nombre comm exacto, espera el tiempo de espera solicitado y luego pkill -KILL en todo lo que siga vivo. Un preKillSave opcional enfoca la ventana y envía Ctrl+S primero (solo X11).';

  @override
  String get skapiScriptKillAppNoteLxDebian =>
      'Los nombres comm de Linux están limitados a 15 caracteres por el kernel. Usa nombres cortos exactos: firefox (no firefox-esr-bin), code, soffice.bin.';

  @override
  String get skapiScriptKillAppParamProcessHintLxDebian =>
      'Nombre comm exacto (límite de 15 caracteres del kernel). Usa pgrep -l para verificar el nombre visible.';

  @override
  String get skapiScriptKillAppParamPreKillSaveHintLxDebian =>
      'Envía Ctrl+S a la ventana de la app antes de SIGTERM. Requiere xdotool y X11; se ignora en Wayland.';

  @override
  String get skapiScriptLaunchAppSummaryHowLxDebian =>
      'Despacho inteligente: .desktop -> gtk-launch, ruta de archivo real -> exec, cualquier otra cosa -> xdg-open y, por último, búsqueda en PATH. El proceso hijo se separa mediante setsid para que SKAPP no se bloquee.';

  @override
  String get skapiScriptLaunchAppNoteLxDebian =>
      'args se divide por espacios. No se admiten argumentos con comillas; usa un script envoltorio para líneas de comandos complejas.';

  @override
  String get skapiScriptLaunchAppParamPathHintLxDebian =>
      'Nombre de binario en PATH, ruta absoluta, archivo .desktop, URL o ruta de archivo. xdg-open gestiona los tipos MIME.';

  @override
  String get skapiScriptDialogSummaryHowLxDebian =>
      'Abre un diálogo modal mediante zenity (GTK) con una alternativa kdialog (KDE). Escribe uno de ok / cancel / yes / no / timeout en stdout.';

  @override
  String get skapiScriptDialogNoteLxDebian =>
      'Instálalo con: sudo apt install zenity. Los usuarios de KDE Plasma pueden tener kdialog en su lugar. Sin ninguno de los dos, el script sale con el código 2.';

  @override
  String get skapiScriptToastSummaryHowLxDebian =>
      'Envía una notificación de escritorio mediante notify-send (libnotify). Nivel 1 porque libnotify-bin viene preinstalado en todos los escritorios Debian modernos.';

  @override
  String get skapiScriptToastNoteLxDebian =>
      'icon acepta nombres de tema de iconos de Freedesktop (dialog-information, dialog-warning, dialog-error). duration en segundos; 0 mantiene el aviso hasta que se descarta.';

  @override
  String get skapiScriptToastParamIconLabelLxDebian => 'Icono';

  @override
  String get skapiScriptToastParamIconHintLxDebian =>
      'Nombre de icono de Freedesktop, por ejemplo: dialog-information, dialog-warning, dialog-error.';

  @override
  String get skapiScriptToastParamDurationLabelLxDebian => 'Duración';

  @override
  String get skapiScriptToastParamDurationHintLxDebian =>
      'Se descarta automáticamente tras estos segundos. 0 significa que el aviso permanece hasta que el usuario lo cierra.';

  @override
  String get skapiScriptShowDesktopSummaryHowLxDebian =>
      'Lee el estado show-desktop de EWMH mediante wmctrl -m y luego lo alterna con wmctrl -k. Refleja la semántica de Win+D en X11.';

  @override
  String get skapiScriptShowDesktopNoteLxDebian =>
      'Solo X11. Los equivalentes de Wayland son específicos del compositor (Sway, Hyprland, extensiones de GNOME Shell).';

  @override
  String get skapiScriptFadeScreenSummaryHowLxDebian =>
      'Atenúa linealmente la retroiluminación de la pantalla interna desde el nivel actual hasta el objetivo a lo largo de la duración solicitada mediante brightnessctl en incrementos de 10 pasos por segundo.';

  @override
  String get skapiScriptFadeScreenNoteLxDebian =>
      'Solo paneles internos. Los monitores externos por DDC necesitan ddcutil y no se gestionan aquí. Nivel 2 porque leer la retroiluminación actual depende de la visibilidad de /sys/class/backlight.';

  @override
  String get skapiScriptGrayscaleSummaryHowLxDebian =>
      'Alterna la clave de saturación de color de la lupa de accesibilidad de GNOME (0.0 escala de grises, 1.0 color) mediante gsettings, sin necesidad de ninguna extensión.';

  @override
  String get skapiScriptGrayscaleNoteLxDebian =>
      'Solo GNOME / Unity. KDE Plasma y XFCE no tienen una vía de sistema equivalente; en esos escritorios el script sale con el código 3 en lugar de no tener efecto silenciosamente.';

  @override
  String get skapiScriptFindMouseShakeSummaryHowLxDebian =>
      'Lee la posición del cursor mediante xdotool getmouselocation y luego traza un círculo a su alrededor durante el número de bucles solicitado usando coordenadas cos/sin calculadas con awk.';

  @override
  String get skapiScriptFindMouseShakeNoteLxDebian =>
      'Solo X11. Wayland bloquea el movimiento sintético del puntero a nivel de protocolo (límite de seguridad), por lo que el script sale con el código 3.';

  @override
  String get skapiScriptCloseWithSaveSummaryHowLxDebian =>
      'Por cada ventana visible que coincida con WM_CLASS: activar, Ctrl+S, esperar y luego enviar WM_DELETE_WINDOW mediante wmctrl. Solo X11.';

  @override
  String get skapiScriptCloseWithSaveNoteLxDebian =>
      'Nivel 2: la inyección de la tecla Ctrl+S depende de la configuración regional y del foco; solo la semántica de guardado real se comporta de forma predecible. Las apps de chat o web pueden asignar Ctrl+S a otra cosa.';

  @override
  String get skapiScriptCloseWithSaveParamProcessHintLxDebian =>
      'Nombre de instancia WM_CLASS (consulta xprop WM_CLASS). Obligatorio.';

  @override
  String get skapiScriptCloseAllInstancesSummaryHowLxDebian =>
      'Envía SIGTERM a cada proceso en ejecución que coincida con el nombre comm exacto. Cada app gestiona su propia secuencia de cierre (y puede mostrar su propio diálogo de guardado).';

  @override
  String get skapiScriptCloseAllInstancesParamProcessHintLxDebian =>
      'Nombre comm exacto tal como lo muestra pgrep -l. Obligatorio.';

  @override
  String get skapiScriptBrowserCloseAllSummaryHowLxDebian =>
      'Recorre una lista de binarios de navegadores de Debian (firefox, firefox-esr, chromium, google-chrome, brave, vivaldi-bin, opera) y envía SIGTERM a cada instancia en ejecución.';

  @override
  String get skapiScriptBrowserCloseAllNoteLxDebian =>
      'Los navegadores conservan la sesión si \"restaurar pestañas en el próximo inicio\" está activado, por lo que esto es un suave \"apagar la pantalla\" más que una acción que provoque pérdida de datos.';

  @override
  String get skapiScriptSaveActiveWindowSummaryHowLxDebian =>
      'Envía Ctrl+S a la ventana enfocada mediante xdotool key --clearmodifiers. Solo X11.';

  @override
  String get skapiScriptSaveActiveWindowNoteLxDebian =>
      'Wayland bloquea la inyección sintética de teclas a nivel de protocolo. Usa la alternativa autosave-trigger o confía en el guardado automático propio de la app.';

  @override
  String get skapiScriptSaveAllOpenSummaryHowLxDebian =>
      'Itera la lista de apps, encuentra las ventanas visibles de cada una, las activa por turnos y envía Ctrl+S entre esperas.';

  @override
  String get skapiScriptSaveAllOpenNoteLxDebian =>
      'La lista de apps predeterminada cubre LibreOffice (soffice.bin), VS Code (code), gedit y kate. Pasa --apps \"nombre1,nombre2\" para anularla. Solo X11.';

  @override
  String get skapiScriptSaveAllOpenParamAppsHintLxDebian =>
      'Nombres comm separados por comas, por ejemplo: soffice.bin,code,gedit.';

  @override
  String get skapiScriptAutosaveTriggerSummaryHowLxDebian =>
      'Recorre cada ventana de nivel superior visible mediante wmctrl -l, activa cada una por turnos e inyecta Ctrl+S. X11 carece de la vía de difusión WIN WM_COMMAND, así que el foco por ventana es la alternativa.';

  @override
  String get skapiScriptAutosaveTriggerNoteLxDebian =>
      'Nivel 2: depende de que la app enfocada respete Ctrl+S como \"guardar\". La mayoría de los editores lo hacen; las apps de chat pueden malinterpretarlo. Solo X11.';

  @override
  String get commonReadFailed => 'no se pudo leer';

  @override
  String get commonUnknown => 'desconocido';

  @override
  String get commonComingSoon => 'próximamente';

  @override
  String get commonDismiss => 'Descartar';

  @override
  String bootstrapBannerError(String error) {
    return 'No se pudo leer del dispositivo: $error';
  }

  @override
  String get bootstrapBannerRetry => 'Reintentar';

  @override
  String get bfApiChainAuthNone => 'Ninguna';

  @override
  String get bfApiChainAuthBearer => 'Token Bearer';

  @override
  String get bfApiChainAuthBasic => 'Autenticación básica';

  @override
  String get bfApiChainAuthHeader => 'Cabecera personalizada';

  @override
  String bfApiChainMasterError(String error) {
    return 'Maestro: $error';
  }

  @override
  String get bfApiChainChainStarted => 'Cadena iniciada';

  @override
  String bfApiChainChainError(String error) {
    return 'Error: $error';
  }

  @override
  String get bfApiChainSaveDialogTitle => '¿Guardar endpoint?';

  @override
  String bfApiChainSaveDialogBody(String name) {
    return '\"$name\" se guardará de forma persistente en el dispositivo. Esto actualiza el área de datos de usuario.';
  }

  @override
  String get bfApiChainSaveDialogConfirm => 'Guardar';

  @override
  String bfApiChainSavedToast(String name) {
    return '\"$name\" guardado';
  }

  @override
  String bfApiChainSaveFailed(String error) {
    return 'No se pudo guardar: $error';
  }

  @override
  String get bfApiChainDeleteDialogTitle => '¿Eliminar?';

  @override
  String bfApiChainDeleteDialogBody(String name) {
    return 'El endpoint \"$name\" se eliminará del dispositivo. Esta acción no se puede deshacer.';
  }

  @override
  String get bfApiChainDeleteDialogConfirm => 'Eliminar';

  @override
  String bfApiChainDeletedToast(String name) {
    return '\"$name\" eliminado';
  }

  @override
  String bfApiChainDeleteFailed(String error) {
    return 'No se pudo eliminar: $error';
  }

  @override
  String bfApiChainTestNoReply(String name) {
    return '\"$name\" sin respuesta (tiempo de espera de 15 s)';
  }

  @override
  String bfApiChainTestSuccess(String name, String httpSuffix) {
    return '\"$name\" correcto$httpSuffix';
  }

  @override
  String bfApiChainTestFailure(String name, String error, String httpSuffix) {
    return '\"$name\" error: $error$httpSuffix';
  }

  @override
  String bfApiChainTestTriggerFailed(String error) {
    return 'No se pudo activar: $error';
  }

  @override
  String get bfApiChainNewEndpointName => 'Nuevo endpoint';

  @override
  String get bfApiChainEmptyTitle => 'Aún no hay endpoints registrados';

  @override
  String get bfApiChainEmptyBody =>
      'Usa la tarjeta \"Añadir endpoint\" de abajo para definir una nueva llamada HTTP (p. ej. webhook de IFTTT, tu propio servidor, pausar Spotify).';

  @override
  String get bfApiChainSystemSectionTitle => 'Automático (SKAPP emparejados)';

  @override
  String get bfApiChainSystemSectionSubtitle =>
      'Cuando vinculas un script mediante SKAPI, se abre una ranura automáticamente para cada equipo. Cuando termina la cuenta atrás, un webhook firmado se envía al SKAPP de ese equipo.';

  @override
  String get bfApiChainUserSectionTitle => 'Manual (dispositivos IoT)';

  @override
  String get bfApiChainUserSectionSubtitle =>
      'Añade a mano URL de terceros (Shelly, Home Assistant, IFTTT). Cuando termina la cuenta atrás, esta lista se dispara primero, por orden.';

  @override
  String get bfApiChainMasterToggleLabel => 'Disparador activo';

  @override
  String get bfApiChainMasterOnSubtitle =>
      'Maestro activado: la cadena se dispara con los disparadores del dispositivo';

  @override
  String get bfApiChainMasterOffSubtitle =>
      'Maestro desactivado: no se llamará a ningún endpoint';

  @override
  String get bfApiChainFieldNameLabel => 'Nombre';

  @override
  String get bfApiChainTypeLabel => 'Tipo';

  @override
  String get bfApiChainEventOrApplet => 'Evento / Applet';

  @override
  String get bfApiChainMethodLabel => 'Método';

  @override
  String get bfApiChainDelayLabel => 'Esperar después (0-300 s)';

  @override
  String get bfApiChainDelayUnit => 's';

  @override
  String get bfApiChainAdvancedHide => 'Ocultar opciones avanzadas';

  @override
  String get bfApiChainAdvancedShow => 'Opciones avanzadas';

  @override
  String get bfApiChainAuthLabel => 'Autenticación';

  @override
  String bfApiChainCurrentTokenHint(String masked) {
    return 'Token actual: $masked (escribe un nuevo valor abajo para actualizarlo)';
  }

  @override
  String get bfApiChainNewTokenLabel =>
      'Nuevo token (déjalo en blanco para conservarlo)';

  @override
  String get bfApiChainContentTypeLabel => 'Content-Type';

  @override
  String get bfApiChainSaveCta => 'Guardar';

  @override
  String get bfApiChainDeleteCta => 'Eliminar';

  @override
  String get bfApiChainTestCta => 'Probar';

  @override
  String get bfApiChainAddCardLabel => 'Añadir nuevo endpoint';

  @override
  String bfApiChainSavedDelaySeconds(int count) {
    return '$count s de espera';
  }

  @override
  String get bfApiChainNotSaved => 'no guardado';

  @override
  String bfApiChainSystemRowSignedTooltip(String peer, int delay) {
    return 'par $peer…  ·  retardo ${delay}s  ·  firmado (HMAC)';
  }

  @override
  String get bfApiChainTestEndpointTooltip => 'Probar este endpoint';

  @override
  String get bfLogsBufferEmpty =>
      'El búfer de registros del dispositivo está vacío.';

  @override
  String get bfLogsUnsupported =>
      'El dispositivo no admite registros en este firmware.';

  @override
  String get deviceLogsNoClockBanner =>
      'El reloj del dispositivo no está configurado; las marcas de tiempo se muestran como segundos desde el arranque.';

  @override
  String get deviceLogsTruncatedHint =>
      '(salida truncada, prueba un límite menor o una gravedad mayor)';

  @override
  String get bfEventsTimerRunning => 'Cuenta atrás iniciada';

  @override
  String get bfEventsTimerPaused => 'Cuenta atrás en pausa';

  @override
  String get bfEventsTimerIdle => 'Cuenta atrás restablecida';

  @override
  String get bfEventsTimerCooldown => 'Enfriamiento';

  @override
  String get bfEventsTimerExpired => 'Cuenta atrás finalizada';

  @override
  String bfEventsFaceChanged(String from, String to) {
    return 'Cara cambiada: $from → $to';
  }

  @override
  String bfEventsApiTriggered(String type) {
    return '$type activado';
  }

  @override
  String get bfEventsApiTriggeredFallback => 'API activada';

  @override
  String bfEventsBatteryLevel(int percent) {
    return 'Nivel de batería: %$percent';
  }

  @override
  String get bfEventsDeviceRestarted => 'Dispositivo reiniciado';

  @override
  String skapiManifestLoadingRetry(String platform, String scriptId) {
    return 'Cargando el manifiesto de $platform/$scriptId, inténtalo de nuevo en un momento';
  }

  @override
  String get skapiListenerOffMobileTitle =>
      'Este dispositivo no puede ejecutar scripts de escritorio';

  @override
  String get skapiListenerOffDesktopTitle =>
      'El receptor HTTP de SKAPP está desactivado';

  @override
  String get skapiListenerOffMobileBody =>
      'Cuando termine la cuenta atrás, los scripts se ejecutarán en Windows / macOS / Linux. SKAPP debe estar abierto y el receptor activo. Este teléfono es solo el lado de la configuración; la ejecución ocurre en el equipo de escritorio.';

  @override
  String skapiListenerOffDesktopBody(String lastErrorSuffix) {
    return 'BF disparará el webhook, pero nadie lo recibirá porque el receptor está desactivado. Abre Ajustes → Receptor HTTP de SKAPP.$lastErrorSuffix';
  }

  @override
  String get skapiSyncBadgeWriting => 'Escribiendo en BF…';

  @override
  String get skapiSyncBadgeWritten => 'Guardado en BF';

  @override
  String get skapiSyncBadgeFailed => 'No se pudo escribir en BF';

  @override
  String skapiSyncBadgeFirmwareCodeTooltip(String code) {
    return 'Código de firmware: $code';
  }

  @override
  String get syncErrUnknownCommand =>
      'Firmware antiguo en el dispositivo. Flashea el nuevo firmware';

  @override
  String get syncErrNotAuthenticated =>
      'Sesión del dispositivo no autorizada (puede ser necesario emparejar de nuevo)';

  @override
  String get syncErrNotFound =>
      'No hay registro de emparejamiento en el dispositivo';

  @override
  String get syncErrInternal => 'Las 8 ranuras SYSTEM pueden estar llenas';

  @override
  String get syncErrUnknown => 'error desconocido';

  @override
  String get syncErrTimeout => 'El dispositivo no respondió (¿desconectado?)';

  @override
  String get syncErrNoBond => 'No hay emparejamiento con este dispositivo';

  @override
  String get syncErrConnect => 'No se pudo conectar con el dispositivo';

  @override
  String get discoveryFilterShowAll => 'Mostrar todos los dispositivos';

  @override
  String get discoveryFilterOnlySmartKraft => 'Solo SmartKraft';

  @override
  String discoveryScanningWithCount(int count, String tail) {
    return 'Buscando… $count dispositivo(s) encontrado(s)$tail';
  }

  @override
  String discoveryFoundCountWithTail(int count, String tail) {
    return '$count dispositivo(s) encontrado(s)$tail';
  }

  @override
  String discoveryFilterOff(int visible, int sk, String tail) {
    return 'Filtro desactivado · $visible dispositivo(s) mostrado(s) ($sk SmartKraft$tail)';
  }

  @override
  String discoveryMdnsTail(int count) {
    return ' + $count en la red';
  }

  @override
  String get discoveryWifiOnlySnack =>
      'Este dispositivo solo es visible actualmente por WiFi. El emparejamiento por WiFi aún no está activo; pulsa brevemente el botón del dispositivo para abrir la ventana de emparejamiento. Cuando también se vea por BLE, esta fila se podrá emparejar.';

  @override
  String get discoveryBadgePairable => 'Emparejable';

  @override
  String get discoveryBadgeBonded => 'Emparejado con otro SKAPP';

  @override
  String get pairingTitleConnecting => 'Conectando';

  @override
  String get pairingTitleReconnecting => 'Reconectando';

  @override
  String get pairingMutualAuthHmacSubtitle => 'Desafío-respuesta HMAC';

  @override
  String pairingBleConnectFailed(String error) {
    return 'La conexión BLE falló.\n\nSolución: pulsa brevemente el botón del dispositivo para abrir la ventana de emparejamiento de 60 segundos y luego toca \"Reintentar\".\n\nDetalles: $error';
  }

  @override
  String get pairingGattServiceMissing => 'No se encontró el servicio SKAPP';

  @override
  String get pairingGattCmdRxMissing => 'Falta la característica cmd_rx';

  @override
  String get pairingGattEventTxMissing => 'Falta la característica event_tx';

  @override
  String pairingGattDiscoveryFailed(String error) {
    return 'Falló el descubrimiento GATT: $error';
  }

  @override
  String pairingKeySendFailed(String error) {
    return 'No se pudo enviar la clave: $error';
  }

  @override
  String pairingDeviceNoReply(int seconds) {
    return 'El dispositivo no respondió ($seconds s).';
  }

  @override
  String pairingDeviceRejected(String error) {
    return 'El dispositivo lo rechazó: $error';
  }

  @override
  String get pairingInvalidReplyMissingPub =>
      'Respuesta del dispositivo no válida (falta our_pub).';

  @override
  String pairingHexDecodeFailed(String error) {
    return 'Falló la decodificación hex de our_pub: $error';
  }

  @override
  String get pairingRetryButton => 'Reintentar';

  @override
  String pairingReconnectTransient(String error) {
    return 'No se pudo alcanzar el dispositivo; se conserva el emparejamiento existente.\n\nAsegúrate de que el dispositivo está encendido y dentro del alcance, y luego toca \"Reintentar\".\n\nDetalles: $error';
  }

  @override
  String get pairingRecoveryTitle => 'Renovar emparejamiento';

  @override
  String get pairingRecoveryBody =>
      'El dispositivo no reconoce el emparejamiento actual. Para iniciar uno nuevo, pulsa el botón de emparejamiento del dispositivo para abrir la ventana de 60 segundos y luego toca Continuar.';

  @override
  String get pairingRecoveryContinue => 'Continuar';

  @override
  String get pairingRecoveryCancelled =>
      'Renovación del emparejamiento cancelada. El emparejamiento anterior sigue registrado; toca \"Reintentar\" para intentar otra conexión más tarde.';

  @override
  String get pairingRenewBondButton => 'Renovar emparejamiento';

  @override
  String wifiPasswordConnectionRejected(String error) {
    return 'Conexión rechazada: $error';
  }

  @override
  String get wifiPasswordTimeout =>
      'El dispositivo no respondió (tiempo agotado).';

  @override
  String wifiScanRejected(String error) {
    return 'El dispositivo rechazó wifi.scan: $error\n\nEl módulo WiFi del dispositivo puede no haberse iniciado; prueba a reiniciarlo.';
  }

  @override
  String wifiScanUnexpectedReply(String data) {
    return 'Respuesta inesperada de wifi.scan: $data';
  }

  @override
  String wifiScanTimeout(String error) {
    return 'El dispositivo no respondió (tiempo agotado: $error).\n\nAcércate al dispositivo, pulsa brevemente su botón (para activar la difusión) e inténtalo de nuevo.';
  }

  @override
  String wifiScanConnectionError(String error) {
    return 'Error de conexión: $error';
  }

  @override
  String get wifiScanHeaderHelp =>
      'A continuación están las redes WiFi que **el dispositivo** puede ver (no las redes del teléfono). Elige la red a la que debe unirse el dispositivo; la contraseña se solicita en el siguiente paso.';

  @override
  String get wifiScanAuthOpen => 'Abierta';

  @override
  String get wifiScanAuthEncrypted => 'Cifrada';

  @override
  String get wifiSuccessSyncing => 'Sincronizando la hora…';

  @override
  String get wifiSuccessFetchingInfo =>
      'Obteniendo información del dispositivo…';

  @override
  String get wifiSuccessPreparingUi =>
      'Preparando la interfaz del dispositivo…';

  @override
  String wifiSuccessManifestRejected(String error) {
    return 'device.manifest rechazado ($error). Puede ser firmware antiguo; debe cargarse sk_baseline.c para BF.';
  }

  @override
  String get wifiSuccessTapToContinue => 'Toca para continuar…';

  @override
  String get deviceHomeUnsupportedTitle => 'Dispositivo no compatible';

  @override
  String deviceHomeUnsupportedBody(String name) {
    return '$name no tiene pantalla de dispositivo en esta versión de SKAPP. Cuando se añada una nueva familia de dispositivos, esta pantalla aparecerá automáticamente.';
  }

  @override
  String get lsPairingUnpairTitle => 'Desemparejar esta APP';

  @override
  String get lsPairingUnpairBody =>
      'El dispositivo olvidará el vínculo de esta APP. Tendrás que emparejar de nuevo (botón 3 s + seleccionar en Dispositivos).';

  @override
  String get skYakindaBadgeDefault => 'próximamente';

  @override
  String get skapiScriptPulseBrightnessTitle => 'Pulsar brillo';

  @override
  String get skapiScriptPulseBrightnessSummaryWhat =>
      'Modula el brillo de la pantalla interna en una onda coseno suave entre el 100% y un límite inferior, repetida un número determinado de veces. El brillo original del usuario se restaura al final.';

  @override
  String get skapiScriptPulseBrightnessSummaryHow =>
      'Lee el brillo actual mediante WMI y luego escribe una muestra de brillo 20 veces por segundo siguiendo una curva coseno. Siempre restaura el original capturado al salir.';

  @override
  String get skapiScriptPulseBrightnessNote =>
      'Solo paneles internos (portátiles, tabletas). Los monitores externos DDC/CI no responden a esta vía de WMI.';

  @override
  String get skapiScriptPulseBrightnessParamPeriodLabel => 'period';

  @override
  String get skapiScriptPulseBrightnessParamPeriodHint =>
      'Segundos de un ciclo completo brillante -> tenue -> brillante. Alrededor de 2 se siente como un pulso claro sin ser brusco.';

  @override
  String get skapiScriptPulseBrightnessParamLowPercentLabel => 'low %';

  @override
  String get skapiScriptPulseBrightnessParamLowPercentHint =>
      'Extremo tenue del pulso, como porcentaje del brillo total. Los números más bajos hacen el pulso más dramático.';

  @override
  String get skapiScriptPulseBrightnessParamCyclesLabel => 'cycles';

  @override
  String get skapiScriptPulseBrightnessParamCyclesHint =>
      'Cuántos ciclos completos de pulso ejecutar antes de salir.';

  @override
  String get skapiScriptBlurTimedTitle => 'Pausa difuminada';

  @override
  String get skapiScriptBlurTimedSummaryWhat =>
      'Cubre la pantalla con un velo semitransparente a pantalla completa y siempre visible durante el número de segundos configurado. Se muestra una cuenta atrás en el centro.';

  @override
  String get skapiScriptBlurTimedSummaryHow =>
      'Abre una ventana WPF sin bordes con AllowsTransparency y un pincel de color sólido con la opacidad elegida. Un temporizador del dispatcher controla la cuenta atrás; la ventana se cierra sola cuando el temporizador llega a cero.';

  @override
  String get skapiScriptBlurTimedNote =>
      'Solución provisional pragmática: un difuminado gaussiano en tiempo real sobre el escritorio necesita un asistente C++/Win2D que llegará más adelante. El velo sólido crea mientras tanto una fricción similar de \'no puedo concentrarme en la pantalla, tómate una pausa\'.';

  @override
  String get skapiScriptBlurTimedParamDurationLabel => 'duration';

  @override
  String get skapiScriptBlurTimedParamDurationHint =>
      'Segundos que el velo permanece antes de cerrarse automáticamente.';

  @override
  String get skapiScriptBlurTimedParamOpacityLabel => 'opacity';

  @override
  String get skapiScriptBlurTimedParamOpacityHint =>
      'Opacidad del velo de 0.0 (invisible) a 1.0 (sólido). Alrededor de 0.55 aún deja que el escritorio se trasluzca lo suficiente para sentirse velado, no totalmente en negro.';

  @override
  String get skapiScriptBlurTimedParamColorLabel => 'color';

  @override
  String get skapiScriptBlurTimedParamColorHint =>
      'Color del velo en hex #RRGGBB. El negro de la paleta #0A0A0A es el predeterminado; los tonos crema más claros se sienten más tranquilos.';

  @override
  String get skapiScriptBlockingFocusTitle => 'Blocking Focus';

  @override
  String get skapiScriptBlockingFocusSummaryWhat =>
      'Aplicador de concentración compuesto: guarda todos los documentos abiertos de Office y VS Code, y luego abre una ventana de cuenta atrás a pantalla completa y siempre visible sin botón de cierre mientras el cursor del ratón gira continuamente. Cuando el temporizador llega a cero, todo se deshace automáticamente.';

  @override
  String get skapiScriptBlockingFocusSummaryHow =>
      'Se ejecutan tres fases seguidas: (1) la fase de guardado llama a Office COM y a la CLI de VS Code; (2) un runspace paralelo mueve el cursor en círculo hasta que se activa una bandera de parada sincronizada; (3) una ventana WPF STA muestra el título y la cuenta atrás. Un bloque finally restaura el origen del cursor y desmonta ambos runspaces.';

  @override
  String get skapiScriptBlockingFocusNote =>
      'Modo suave: Esc y Alt+F4 NO están bloqueados. El usuario siempre puede escapar mediante el Administrador de tareas. El modo estricto con hooks de teclado globales será un script aparte.';

  @override
  String get skapiScriptBlockingFocusParamDurationLabel => 'duration';

  @override
  String get skapiScriptBlockingFocusParamDurationHint =>
      'Segundos que dura el bloqueo. La cuenta atrás baja hasta 00:00 y luego todo se limpia.';

  @override
  String get skapiScriptBlockingFocusParamTitleLabel => 'title';

  @override
  String get skapiScriptBlockingFocusParamTitleHint =>
      'Texto que se muestra en el centro de la ventana a pantalla completa. Mantenlo corto; \'Blocking Focus\' es el predeterminado.';

  @override
  String get skapiScriptBlockingFocusParamShakeRadiusLabel => 'shake radius';

  @override
  String get skapiScriptBlockingFocusParamShakeRadiusHint =>
      'Píxeles que recorre el cursor desde su origen mientras gira. Los círculos más grandes exigen más atención.';

  @override
  String get skapiScriptBlockingFocusParamEnableSaveLabel => 'save on start';

  @override
  String get skapiScriptBlockingFocusParamEnableSaveHint =>
      'Ejecuta la fase de guardado de Office + VS Code antes del bloqueo. Desactívalo cuando no haya estado de documentos que proteger.';

  @override
  String get trayFirstHideToast =>
      'SKAPP sigue ejecutándose en segundo plano. Encuéntralo en la bandeja del sistema; haz clic derecho para Salir.';

  @override
  String devicesOfflineTapHint(String name) {
    return '$name está desconectado.';
  }

  @override
  String skapiNewActionDeviceOffline(String name) {
    return '$name está desconectado. Conéctalo para crear una nueva acción.';
  }

  @override
  String get bfApiChainRefreshDirtyTitle => 'Cambios sin guardar';

  @override
  String get bfApiChainRefreshDirtyBody =>
      'Al actualizar se obtendrá la lista de endpoints más reciente del dispositivo y se descartará el borrador que aún no has guardado.';

  @override
  String get bfApiChainRefreshDirtyConfirm => 'Actualizar de todos modos';

  @override
  String get skapiApiEditorTitle => 'API en el dispositivo';

  @override
  String get lsCommonReadFailed => 'La lectura falló';

  @override
  String lsCommonFailedWith(String err) {
    return 'Falló: $err';
  }

  @override
  String get lsVacationStatusOff => 'Desactivado';

  @override
  String lsVacationStatusUntil(String date) {
    return 'Hasta $date';
  }

  @override
  String get lsVacationDaysValidationError =>
      'Los días deben estar entre 1 y 60';

  @override
  String lsVacationStartedSnack(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Vacaciones iniciadas · $days días',
      one: 'Vacaciones iniciadas · 1 día',
    );
    return '$_temp0';
  }

  @override
  String get lsVacationCancelledSnack => 'Vacaciones canceladas';

  @override
  String lsVacationActiveUntilFmt(String date) {
    return 'Activas hasta $date';
  }

  @override
  String get lsVacationResumeHint =>
      'La cuenta atrás se reanudará cuando terminen las vacaciones.';

  @override
  String get lsVacationCancellingButton => 'Cancelando…';

  @override
  String get lsVacationCancelButton => 'Cancelar vacaciones';

  @override
  String get lsVacationDaysLabel => 'Días';

  @override
  String get lsVacationDaysHint =>
      'Pausa la cuenta atrás durante estos días (de 1 a 60).';

  @override
  String get lsVacationStartingButton => 'Iniciando…';

  @override
  String get lsVacationStartButton => 'Iniciar vacaciones';

  @override
  String get lsCommonSavingButton => 'Guardando…';

  @override
  String get lsCommonSaveButton => 'Guardar';

  @override
  String lsCommonSaveFailedWith(String err) {
    return 'El guardado falló: $err';
  }

  @override
  String get lsDurationValueValidationError =>
      'El valor debe estar entre 1 y 60';

  @override
  String get lsDurationAlarmsValidationError =>
      'El número de alarmas debe estar entre 0 y 10';

  @override
  String get lsDurationConfiguredSnack => 'Temporizador configurado';

  @override
  String lsDurationUnitMinute(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value minutos',
      one: '1 minuto',
    );
    return '$_temp0';
  }

  @override
  String lsDurationUnitHour(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value horas',
      one: '1 hora',
    );
    return '$_temp0';
  }

  @override
  String lsDurationUnitDay(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value días',
      one: '1 día',
    );
    return '$_temp0';
  }

  @override
  String lsDurationAlarmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alarmas',
      one: '1 alarma',
    );
    return '$_temp0';
  }

  @override
  String get lsDurationUnitLabel => 'Unidad';

  @override
  String get lsDurationUnitMinutesPlural => 'minutos';

  @override
  String get lsDurationUnitHoursPlural => 'horas';

  @override
  String get lsDurationUnitDaysPlural => 'días';

  @override
  String get lsDurationValueLabel => 'Valor';

  @override
  String get lsDurationValueHint => '1 a 60';

  @override
  String get lsDurationAlarmCountLabel => 'Número de alarmas';

  @override
  String get lsDurationAlarmCountHint =>
      'Las alarmas se disparan hacia atrás desde el final, separadas una unidad.';

  @override
  String get lsSmtpStatusNotConfigured => 'Sin configurar';

  @override
  String get lsSmtpHostRequired => 'El host es obligatorio';

  @override
  String get lsSmtpPortValidationError =>
      'El puerto debe estar entre 1 y 65535';

  @override
  String get lsSmtpSenderRequired =>
      'La dirección del remitente es obligatoria';

  @override
  String get lsSmtpFieldHost => 'Host';

  @override
  String get lsSmtpFieldPort => 'Puerto';

  @override
  String get lsSmtpFieldSender => 'Remitente';

  @override
  String get lsSmtpFieldKey => 'Clave';

  @override
  String lsSmtpSaveHaltedOn(String err) {
    return 'Guardado detenido en $err';
  }

  @override
  String get lsSmtpSavedSnack => 'SMTP guardado';

  @override
  String get lsSmtpTestSentSnack => 'Correo de prueba enviado';

  @override
  String lsSmtpTestFailedWith(String err) {
    return 'La prueba falló: $err';
  }

  @override
  String get lsSmtpUrlCopiedSnack => 'URL copiada al portapapeles';

  @override
  String get lsSmtpApiKeyPlaceholder =>
      'Contraseña de aplicación de Gmail / clave de API';

  @override
  String get lsSmtpServerLabel => 'Servidor';

  @override
  String get lsSmtpApiKeyLabel => 'Clave de API';

  @override
  String get lsSmtpApiKeyHint =>
      'Déjalo en blanco para conservar la clave actual.';

  @override
  String get lsSmtpAppPasswordHelpLink =>
      'Cómo obtener una contraseña de aplicación de Gmail';

  @override
  String get lsSmtpSendingButton => 'Enviando…';

  @override
  String get lsSmtpSendTestButton => 'Enviar prueba';

  @override
  String get lsReminderMailRecipientValidation =>
      'El destinatario debe tener forma de dirección de correo electrónico';

  @override
  String get lsReminderMailSavedSnack => 'Recordatorio guardado localmente';

  @override
  String get lsReminderMailRecipientFirstSnack =>
      'Define primero un destinatario';

  @override
  String get lsReminderMailTestOkSnack =>
      'Prueba SMTP correcta, las credenciales llegan al servidor';

  @override
  String lsReminderMailTestFailedWith(String err) {
    return 'La prueba SMTP falló: $err';
  }

  @override
  String get lsReminderMailRecipientLabel => 'Correo del destinatario';

  @override
  String get lsReminderMailSubjectLabel => 'Asunto';

  @override
  String get lsReminderMailBodyLabel => 'Cuerpo';

  @override
  String get lsReminderMailBodyHint => 'Tu cuenta atrás se activará pronto...';

  @override
  String get lsReminderMailActiveLabel => 'Activo';

  @override
  String get lsReminderMailFootnote =>
      'Guardado localmente en este dispositivo. La prueba de envío solo verifica que el servidor SMTP es accesible; el disparo automático en timer.alarm está pendiente de compatibilidad del firmware.';

  @override
  String get lsResetApiStatusDisabled => 'Desactivado';

  @override
  String lsResetApiStatusEnabledPort(int port) {
    return 'Activado · puerto $port';
  }

  @override
  String get lsResetApiRegenDialogTitle => '¿Regenerar la clave de API?';

  @override
  String get lsResetApiRegenDialogBody =>
      'Esto invalidará la clave actual. Cualquier llamador que use la clave anterior será rechazado hasta que la actualices. ¿Continuar?';

  @override
  String get lsResetApiRegenConfirm => 'Regenerar';

  @override
  String get lsResetApiKeyRegeneratedSnack => 'Clave regenerada';

  @override
  String get lsResetApiEnabledLabel => 'Activado';

  @override
  String get lsResetApiEnabledHint =>
      'Cuando está activado, un GET HTTP a la URL del endpoint con la clave correspondiente restablece la cuenta atrás.';

  @override
  String get lsResetApiEndpointUrlLabel => 'URL del endpoint';

  @override
  String get lsResetApiUrlNotAvailable => '(no disponible)';

  @override
  String get lsResetApiCopyUrlTooltip => 'Copiar URL';

  @override
  String get lsResetApiKeyLabel => 'Clave de API';

  @override
  String get lsResetApiKeyNotSet => '(no definida)';

  @override
  String get lsResetApiExampleLabel => 'Ejemplo';

  @override
  String get lsResetApiRegenerateButton => 'Regenerar clave';

  @override
  String get lsAlarmApiUrlValidation =>
      'La URL debe empezar por http:// o https://';

  @override
  String get lsAlarmApiHeadersValidation =>
      'El campo de cabeceras debe ser JSON válido';

  @override
  String get lsAlarmApiSaveDialogTitle => '¿Guardar el endpoint del webhook?';

  @override
  String lsAlarmApiSaveDialogBody(String name, String url) {
    return 'Guarda `$name` en el dispositivo apuntando a:\n$url';
  }

  @override
  String get lsAlarmApiSavedSnack => 'Webhook guardado';

  @override
  String get lsAlarmApiDisabledSnack => 'Webhook desactivado';

  @override
  String get lsAlarmApiTestQueuedSnack =>
      'Prueba en cola, observa el servicio de destino';

  @override
  String lsAlarmApiTestFailedWith(String err) {
    return 'La prueba falló: $err';
  }

  @override
  String get lsAlarmApiRemoveDialogTitle => '¿Eliminar el webhook?';

  @override
  String lsAlarmApiRemoveDialogBody(String name) {
    return 'Elimina `$name` del dispositivo. Se conserva la configuración local.';
  }

  @override
  String get lsAlarmApiRemoveButton => 'Eliminar';

  @override
  String lsAlarmApiRemoveFailedWith(String err) {
    return 'La eliminación falló: $err';
  }

  @override
  String get lsAlarmApiConfiguredStatus => 'Configurado';

  @override
  String lsAlarmApiConfiguredHost(String host) {
    return 'Configurado · $host';
  }

  @override
  String get lsAlarmApiUrlLabel => 'URL';

  @override
  String get lsAlarmApiMethodLabel => 'Método HTTP';

  @override
  String get lsAlarmApiHeadersLabel => 'Cabeceras (JSON, opcional)';

  @override
  String get lsAlarmApiHeadersHint =>
      'Objeto JSON con cabeceras opcionales. Se guarda localmente; el firmware las aplica al disparar.';

  @override
  String get lsAlarmApiBodyTemplateLabel => 'Plantilla del cuerpo (JSON)';

  @override
  String get lsAlarmApiBodyTemplateHint =>
      'Los marcadores de posición device y remaining_sec se sustituyen en el momento del disparo.';

  @override
  String get lsAlarmApiBearerLabel => 'Token Bearer (opcional)';

  @override
  String get lsAlarmApiFootnote =>
      'El suscriptor del firmware para el evento timer.alarm está pendiente. Esta configuración almacena el endpoint; no se disparará automáticamente hasta la próxima actualización de firmware.';

  @override
  String lsRelaySummarySeconds(int seconds) {
    return '${seconds}s';
  }

  @override
  String lsRelaySummaryMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get lsRelayModePulse => 'pulso';

  @override
  String get lsRelayModeSteady => 'constante';

  @override
  String lsRelaySummaryFmt(int gpio, String duration, String mode) {
    return 'GPIO $gpio · $duration $mode';
  }

  @override
  String get lsRelayGpioValidation => 'El GPIO debe estar entre 0 y 30';

  @override
  String get lsRelayDurationValidation =>
      'La duración debe estar entre 1 y 3600 segundos';

  @override
  String get lsRelayPulseValidation =>
      'El semiciclo del pulso debe estar entre 1 y 60';

  @override
  String lsRelayCmdFailedWith(String cmd, String err) {
    return '$cmd falló: $err';
  }

  @override
  String get lsRelayConfiguredSnack => 'Relé configurado';

  @override
  String get lsRelayFireAbortedSnack => 'Disparo abortado';

  @override
  String get lsRelayForcedIdleSnack => 'Relé forzado a inactivo';

  @override
  String get lsRelayGpioLabel => 'Pin GPIO';

  @override
  String get lsRelayGpioHint =>
      'Pin válido de ESP32-C6; predeterminado 19 = D8';

  @override
  String get lsRelayInvertLabel => 'Invertir polaridad';

  @override
  String get lsRelayStartDelayLabel => 'Retardo de inicio';

  @override
  String lsRelayStartDelayHint(int sec) {
    return '${sec}s antes de que el relé se active';
  }

  @override
  String get lsRelayActiveDurationLabel => 'Duración activa';

  @override
  String get lsRelayUnitSeconds => 'Segundos';

  @override
  String get lsRelayUnitMinutes => 'Minutos';

  @override
  String get lsRelayPulseModeLabel => 'Modo de pulso';

  @override
  String get lsRelayPulseModeHint =>
      'Activado = semiciclo de 1 s. Personalizado te permite definir el semiciclo.';

  @override
  String get lsRelayHalfCycleLabel => 'Segundos del semiciclo';

  @override
  String get lsRelayFiringButton => 'Disparando…';

  @override
  String get lsRelayTestRelayButton => 'Probar relé';

  @override
  String get lsRelayAbortButton => 'Abortar';

  @override
  String get lsRelayForceOffButton => 'Forzar apagado';

  @override
  String get lsRelayPulseOff => 'Desactivado';

  @override
  String get lsRelayPulseOn => 'Activado';

  @override
  String get lsRelayPulseCustom => 'Personalizado';

  @override
  String get lsRelayPhaseActiveBadge => 'activa';

  @override
  String lsRelayPhaseLine(String phase, String elapsed) {
    return 'Fase: $phase$elapsed';
  }

  @override
  String get lsTelegramTokenRequired => 'El token del bot es obligatorio';

  @override
  String get lsTelegramChatRequired => 'El id del chat es obligatorio';

  @override
  String get lsTelegramSaveDialogTitle => '¿Guardar el endpoint de Telegram?';

  @override
  String lsTelegramSaveDialogBody(String name) {
    return 'Guarda `$name` en el dispositivo. El token se envía en la URL.';
  }

  @override
  String get lsTelegramSavedSnack => 'Endpoint de Telegram guardado';

  @override
  String get lsTelegramDisabledSnack => 'Endpoint de Telegram desactivado';

  @override
  String get lsTelegramTestQueuedSnack =>
      'Prueba en cola, observa el chat de Telegram';

  @override
  String get lsTelegramRemoveDialogTitle =>
      '¿Eliminar el endpoint de Telegram?';

  @override
  String get lsTelegramBotConfiguredStatus => 'Bot configurado';

  @override
  String get lsTelegramBotTokenLabel => 'Token del bot';

  @override
  String get lsTelegramBotTokenHint =>
      'Consíguelo de @BotFather (tiene el aspecto 1234567:AAH...).';

  @override
  String get lsTelegramChatIdLabel => 'ID del chat';

  @override
  String get lsTelegramChatIdHint =>
      'Un id numérico (-100...) o un nombre de usuario @canal.';

  @override
  String get lsTelegramMessageTemplateLabel => 'Plantilla del mensaje';

  @override
  String get lsTelegramMessageHint => 'LebensSpur: alarma activada.';

  @override
  String get lsLsApiUrlRequired => 'URL obligatoria';

  @override
  String get lsLsApiUpdatedSnack => 'Webhook actualizado';

  @override
  String get lsLsApiSavedSnack => 'Webhook guardado';

  @override
  String get lsLsApiSaveFirstSnack => 'Guarda primero el webhook';

  @override
  String get lsLsApiTestQueuedSnack => 'Prueba en cola, comprueba el receptor';

  @override
  String get lsLsApiRemoveDialogBody =>
      'El webhook de LS se eliminará del dispositivo. La cuenta atrás ya no lo disparará.';

  @override
  String get lsLsApiRemovedSnack => 'Webhook eliminado';

  @override
  String get lsLsApiConfirmCriticalTitle => 'Confirmar cambio crítico';

  @override
  String lsLsApiConfirmCriticalBody(String cmd, int ttlSec) {
    return 'El dispositivo pide que confirmes:\n  $cmd\n\nEste token caduca en ${ttlSec}s.';
  }

  @override
  String get lsLsApiConfirmButton => 'Confirmar';

  @override
  String lsLsApiActiveSlot(String name) {
    return 'Activa · ranura \"$name\"';
  }

  @override
  String lsLsApiActiveWithToken(String name, String token) {
    return 'Activa · ranura \"$name\" · token $token';
  }

  @override
  String get lsLsApiUrlHint =>
      'Se dispara cuando se activa timer.triggered. Se recomienda https://.';

  @override
  String get lsLsApiHeadersLabel => 'Cabeceras (JSON)';

  @override
  String get lsLsApiHeadersHint =>
      'Avanzado: aún no conectado a través de CLI. Reservado para una versión futura.';

  @override
  String get lsLsApiBodyTemplateHint =>
      'Se envía como la carga útil de prueba. El marcador de posición device se sustituye en el servidor.';

  @override
  String lsLsApiBearerHintExisting(String token) {
    return 'Definido actualmente: $token. Déjalo en blanco para conservarlo, o pega un nuevo valor para sobrescribirlo.';
  }

  @override
  String get lsLsApiBearerHintEmpty =>
      'Se envía como `Authorization: Bearer <token>`.';

  @override
  String get lsLsApiUpdateButton => 'Actualizar';

  @override
  String lsMailGroupsStatusFmt(int count, int max, int recipients) {
    return '$count de $max · $recipients destinatarios en total';
  }

  @override
  String lsMailGroupsReadFailedWith(String err) {
    return 'La lectura falló: $err';
  }

  @override
  String get lsMailGroupsNameValidation =>
      'El nombre debe tener entre 1 y 47 caracteres';

  @override
  String get lsMailGroupsNameSaved => 'Nombre guardado';

  @override
  String get lsMailGroupsSubjectValidation =>
      'El asunto debe tener como máximo 127 caracteres';

  @override
  String get lsMailGroupsSubjectSaved => 'Asunto guardado';

  @override
  String get lsMailGroupsBodyValidation =>
      'El cuerpo debe tener como máximo 511 caracteres';

  @override
  String get lsMailGroupsBodySaved => 'Cuerpo guardado';

  @override
  String get lsMailGroupsEmailValidation => 'Introduce un correo válido';

  @override
  String lsMailGroupsMaxReached(int max) {
    return 'El máximo es $max grupos';
  }

  @override
  String get lsMailGroupsNameEmpty => 'El nombre no puede estar vacío';

  @override
  String get lsMailGroupsCreatedSnack => 'Grupo creado';

  @override
  String lsMailGroupsCreateFailedWith(String err) {
    return 'La creación falló: $err';
  }

  @override
  String get lsMailGroupsDeleteDialogTitle => '¿Eliminar el grupo?';

  @override
  String get lsMailGroupsDeleteDialogBody =>
      'Esto elimina el grupo y todos sus destinatarios del dispositivo.';

  @override
  String get lsMailGroupsDeleteConfirm => 'Eliminar';

  @override
  String get lsMailGroupsDeletedSnack => 'Grupo eliminado';

  @override
  String lsMailGroupsDefaultName(int n) {
    return 'Grupo $n';
  }

  @override
  String get lsMailGroupsNewGroupTitle => 'Nuevo grupo de correo';

  @override
  String get lsMailGroupsGroupNameLabel => 'Nombre del grupo';

  @override
  String get lsMailGroupsCreateConfirm => 'Crear';

  @override
  String get lsMailGroupsEmptyHint =>
      'Aún no hay grupos. Crea uno para enviar correo cuando se active el temporizador.';

  @override
  String get lsMailGroupsWorkingButton => 'Trabajando…';

  @override
  String get lsMailGroupsCreateNewButton => '+ Crear nuevo grupo';

  @override
  String lsMailGroupsHeaderCount(int count, int max) {
    return '$count de $max grupos configurados';
  }

  @override
  String lsMailGroupsHeaderTotalRecipients(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count destinatarios en total',
      one: '1 destinatario en total',
    );
    return '· $_temp0';
  }

  @override
  String get lsMailGroupsUnnamed => '(sin nombre)';

  @override
  String lsMailGroupsRowSummary(int count, String state) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count destinatarios',
      one: '1 destinatario',
    );
    return '$_temp0 · $state';
  }

  @override
  String get lsMailGroupsEnabled => 'activado';

  @override
  String get lsMailGroupsDisabled => 'desactivado';

  @override
  String get lsMailGroupsNameLabel => 'Nombre';

  @override
  String get lsMailGroupsSubjectLabel => 'Asunto';

  @override
  String get lsMailGroupsSaveBodyButton => 'Guardar cuerpo';

  @override
  String get lsMailGroupsDeleteGroupButton => 'Eliminar grupo';

  @override
  String lsMailGroupsRecipientsHeader(int count) {
    return 'Destinatarios ($count)';
  }

  @override
  String get lsMailGroupsNoRecipients => 'Aún no hay destinatarios.';

  @override
  String get lsMailGroupsAddRecipientButton => 'Añadir';

  @override
  String get lsHomeStatusLoading => 'Cargando…';

  @override
  String get lsHomeLogsTooltip => 'Registros';

  @override
  String get lsHomeClusterConfiguration => 'CONFIGURACIÓN';

  @override
  String get lsHomeClusterTriggerActions => 'ACCIONES DE DISPARO';

  @override
  String get lsHomeClusterEarlyWarning => 'AVISO ANTICIPADO';

  @override
  String get lsHomeSectionDurationTitle => 'Duración y alarmas';

  @override
  String get lsHomeSectionVacationTitle => 'Modo vacaciones';

  @override
  String get lsHomeSectionSmtpTitle => 'Configuración de correo (SMTP)';

  @override
  String get lsHomeSectionResetApiTitle =>
      'Endpoint de la API de restablecimiento';

  @override
  String get lsHomeSectionMailGroupsTitle => 'Grupos de correo';

  @override
  String get lsHomeSectionRelayTitle => 'Relé';

  @override
  String get lsHomeSectionLsApiTitle => 'Webhook de la LS API';

  @override
  String get lsHomeSectionTelegramTitle => 'Telegram';

  @override
  String get lsHomeSectionReminderMailTitle => 'Correo de recordatorio';

  @override
  String get lsHomeSectionAlarmApiTitle => 'Webhook de la API de alarma';

  @override
  String get lsHomeStateInactive => 'INACTIVO';

  @override
  String get lsHomeStateRemaining => 'RESTANTE';

  @override
  String get lsHomeStateVacation => 'VACACIONES';

  @override
  String get lsHomeStateTriggered => 'ACTIVADO';

  @override
  String get lsHomeChipBle => 'BLE';

  @override
  String get lsHomeChipMail => 'Correo';

  @override
  String get lsHomeEarlyWarningPendingNote =>
      'Las acciones de aviso anticipado se disparan en timer.alarm. El suscriptor del firmware está pendiente; estas configuraciones se conservan pero aún no se dispararán automáticamente.';

  @override
  String get settingsDiagnosticsTitle => 'Diagnósticos';

  @override
  String get settingsDiagnosticsSubtitle =>
      'Registros para ayudar a depurar problemas';

  @override
  String get diagnosticsCopyLogs => 'Copiar registros';

  @override
  String get diagnosticsOpenFolder => 'Abrir carpeta';

  @override
  String get diagnosticsOpenFolderFailed =>
      'No se pudo abrir la carpeta de registros.';

  @override
  String get diagnosticsShareLogs => 'Compartir registros';

  @override
  String get diagnosticsClearLogs => 'Borrar registros';

  @override
  String get diagnosticsCopied => 'Registros copiados al portapapeles';

  @override
  String get diagnosticsCleared => 'Registros borrados';

  @override
  String get aboutPrivacyLabel => 'Política de privacidad';

  @override
  String get updateChecking => 'Buscando actualizaciones…';

  @override
  String get updateUpToDate => 'Tienes la última versión';

  @override
  String get updateCheckFailed => 'No se pudieron buscar actualizaciones';

  @override
  String get updateAvailableTitle => 'Actualización disponible';

  @override
  String updateAvailableBody(String version, String current) {
    return 'Hay una nueva versión ($version) disponible. Estás en la $current.';
  }

  @override
  String get updateDownloadAction => 'Descargar';

  @override
  String get updateLater => 'Más tarde';
}
