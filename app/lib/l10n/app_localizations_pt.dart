// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'SKAPP';

  @override
  String get brandTagline => 'SmartKraft';

  @override
  String get tabHome => 'Início';

  @override
  String get tabDevices => 'Dispositivos';

  @override
  String get tabSkapi => 'SKAPI';

  @override
  String get tabSettings => 'Configurações';

  @override
  String get tabSmartKraft => 'SmartKraft';

  @override
  String get comingSoonBadge => 'em breve';

  @override
  String get featureComingSoonSnack => 'Este recurso chega em breve';

  @override
  String get homeWelcome => 'Bem-vindo à SmartKraft';

  @override
  String get homeSubtitle => 'Gerencie seus dispositivos SmartKraft';

  @override
  String get homeAddDevice => 'Adicionar dispositivo';

  @override
  String get homeNoDevicesTitle => 'Nenhum dispositivo ainda';

  @override
  String get homeNoDevicesHint =>
      'Adicione seu primeiro dispositivo SmartKraft para começar.';

  @override
  String get homeSummaryTitle => 'Visão geral';

  @override
  String homeDevicesOnline(int count) {
    return '$count conectados';
  }

  @override
  String homeDevicesOffline(int count) {
    return '$count offline';
  }

  @override
  String get homeUpdatesTitle => 'Atualizações disponíveis';

  @override
  String homeUpdatesBody(int count) {
    return '$count dispositivo tem um firmware mais recente.';
  }

  @override
  String get homeWarningsTitle => 'Avisos';

  @override
  String homeWarningsBody(int count) {
    return '$count dispositivo relatou um problema.';
  }

  @override
  String get homeAllGood => 'Está tudo funcionando bem.';

  @override
  String get devicesTitle => 'Dispositivos';

  @override
  String get devicesEmpty =>
      'Nenhum dispositivo adicionado ainda.\nToque no botão + para adicionar um.';

  @override
  String get devicesAdd => 'Adicionar dispositivo';

  @override
  String get devicesAllSection => 'Todos os dispositivos';

  @override
  String get devicesGroupsTitle => 'Seus grupos';

  @override
  String get devicesGroupsHint =>
      'Crie grupos para organizar seus dispositivos como quiser.';

  @override
  String get devicesGroupsCreate => 'Novo grupo';

  @override
  String get devicesGroupsEmpty => 'Nenhum grupo ainda.';

  @override
  String get skapiTitle => 'SKAPI';

  @override
  String get skapiLibraryHeading => 'Biblioteca SKAPI';

  @override
  String get skapiLibrarySubtitle =>
      'Escolha a plataforma que seus dispositivos vão acionar.';

  @override
  String get skapiThisComputer => 'Este computador';

  @override
  String skapiCategoryCount(int count) {
    return '$count categorias';
  }

  @override
  String get skapiPlatformMac => 'macOS';

  @override
  String get skapiPlatformWin => 'Windows';

  @override
  String get skapiPlatformLinux => 'Linux';

  @override
  String get skapiPlatformOther => 'Outra';

  @override
  String get skapiStarredHeading => 'APIs favoritas';

  @override
  String get skapiStarredEmpty =>
      'Marque modelos da biblioteca como favoritos; eles aparecerão aqui.';

  @override
  String get skapiContributeTitle =>
      'Envie sua biblioteca para a comunidade SmartKraft';

  @override
  String get skapiContributeBody => 'Este cartão será projetado depois.';

  @override
  String get skapiSearchPlaceholder => 'Buscar ações…';

  @override
  String get skapiSearchDisabledHint =>
      'Será ativado quando o parser do SKAPI estiver conectado.';

  @override
  String get skapiHelpButtonTooltip => 'Sobre o SKAPI';

  @override
  String get skapiHelpSheetTitle => 'Sobre o SKAPI';

  @override
  String get skapiHelpIntro =>
      'O SKAPI é uma biblioteca de ações que seus dispositivos SmartKraft podem acionar no seu computador.';

  @override
  String get skapiHelpStep1Title => 'Navegue por um modelo';

  @override
  String get skapiHelpStep1Body =>
      'Escolha um ponto de partida na biblioteca do SKAPI.';

  @override
  String get skapiHelpStep2Title => 'Configurar';

  @override
  String get skapiHelpStep2Body =>
      'Defina os parâmetros e escolha qual dispositivo o dispara.';

  @override
  String get skapiHelpStep3Title => 'Enviar ao dispositivo';

  @override
  String get skapiHelpStep3Body =>
      'O dispositivo armazena o gatilho da API; o SKAPP executa o script.';

  @override
  String get skapiHelpGlossaryTitle => 'Glossário';

  @override
  String get skapiHelpGlossaryTemplate =>
      'Modelo: uma entrada de biblioteca somente leitura';

  @override
  String get skapiHelpGlossaryAction =>
      'Ação: um par configurado de gatilho de API + script';

  @override
  String get skapiHelpGlossaryApiTrigger =>
      'Gatilho de API: o que o dispositivo chama';

  @override
  String get skapiHelpGlossaryScript =>
      'Script: o que o seu computador executa';

  @override
  String get skapiHelpPhase1Notice =>
      'O SKAPI ainda está em construção. A maior parte desta aba é um esqueleto; as seções marcadas como \'ainda não ativa\' serão ligadas conforme o parser, o ouvinte e o construtor de formulários ficarem prontos.';

  @override
  String get skapiMobileBannerBody =>
      'Este celular não pode ser um destino. Para executar ações, o SKAPP precisa estar aberto no seu computador.';

  @override
  String get skapiActionsHeading => 'Minhas ações';

  @override
  String get skapiActionsNoDevicesTitle => 'Nenhum dispositivo ainda';

  @override
  String get skapiActionsNoDevicesBody =>
      'Pareie primeiro um dispositivo SmartKraft; vá até a aba Dispositivos.';

  @override
  String get skapiActionsCreationDisabled =>
      'A criação de ações ainda não está ativa.';

  @override
  String get skapiActionsOfflineDetectionDisabled =>
      'Detecção de online ainda não ativa';

  @override
  String get skapiActionsMaxLimitNote => 'Até 5 ações por dispositivo.';

  @override
  String get skapiActionsAddCta => 'Adicionar ação';

  @override
  String skapiHeaderSub(int platforms, int actions) {
    return '$platforms plataformas · $actions ações';
  }

  @override
  String get skapiNewActionPill => 'Nova ação';

  @override
  String skapiActionsSubLine(int count) {
    return 'vínculos dispositivo × script · $count ativos';
  }

  @override
  String get skapiActionsEmptyHint =>
      'Nenhuma ação ainda. Defina o que acontece quando um botão do dispositivo é pressionado.';

  @override
  String get skapiActionsCreateCta => 'Criar';

  @override
  String skapiActionsGroupTitle(String name) {
    return 'Ações de $name';
  }

  @override
  String skapiActionsGroupCount(int count) {
    return '$count';
  }

  @override
  String get skapiListenerEndpointTitle =>
      'URL do webhook enviada aos dispositivos BF';

  @override
  String get skapiListenerEndpointBody =>
      'Se um BF na mesma Wi-Fi não conseguir acessar esta URL após a contagem regressiva, a placa de rede escolhida no seu notebook pode estar errada (ex.: rede do WSL/VirtualBox/Docker). Toque em Atualizar para reenviar.';

  @override
  String get skapiListenerEndpointResolving => 'Resolvendo IP local…';

  @override
  String get skapiListenerEndpointUnavailable =>
      'Nenhuma interface LAN utilizável encontrada.';

  @override
  String get skapiListenerEndpointRefresh => 'Atualizar';

  @override
  String get skapiListenerEndpointRefreshing => 'Enviando…';

  @override
  String skapiListenerEndpointPushedAt(String when) {
    return 'Última atualização $when';
  }

  @override
  String get skapiListenerSelfTest => 'Autoteste';

  @override
  String get skapiListenerSelfTestRunning => 'Testando…';

  @override
  String get skapiListenerSelfTestPassed =>
      'Autoteste OK: ouvinte acessível a partir deste host.';

  @override
  String get skapiListenerSelfTestFailed =>
      'Autoteste FALHOU: ouvinte inacessível. Verifique o Firewall do Windows.';

  @override
  String get skapiWebhookActivityTitle => 'Webhooks recentes';

  @override
  String get skapiWebhookActivityNone =>
      'Nenhum webhook recebido ainda. Após o timer do dispositivo expirar, uma entrada deve aparecer aqui em segundos.';

  @override
  String get skapiWebhookActivityAccepted => 'Aceito';

  @override
  String skapiWebhookActivityRejected(int code) {
    return 'Rejeitado ($code)';
  }

  @override
  String get skapiWebhookActivityMalformed => 'Malformado';

  @override
  String get skapiWebhookActivitySelfTest => 'Autoteste';

  @override
  String get skapiWebhookActivityNoMatch => 'Nenhum vínculo correspondente';

  @override
  String get skapiWebhookActivityScriptError => 'Erro de script';

  @override
  String skapiWebhookActivityMatched(int count) {
    return '$count script(s) executado(s)';
  }

  @override
  String get skapiBfEndpointsButton => 'Inspecionar endpoints BF';

  @override
  String get skapiBfEndpointsTitle =>
      'Endpoints armazenados nos dispositivos BF';

  @override
  String get skapiBfEndpointsHint =>
      'Snapshot somente leitura de api.endpoint.list de cada dispositivo pareado. Compare a URL de cada slot SYSTEM com a URL do ouvinte acima. Elas devem ser idênticas. Os slots USER podem pertencer a webhooks manuais e podem capturar sua contagem regressiva se estiverem mal configurados.';

  @override
  String get skapiBfEndpointsLoading => 'Consultando dispositivos BF…';

  @override
  String get skapiBfEndpointsErrorPrefix => 'Consulta falhou:';

  @override
  String get skapiBfEndpointsKindSystem => 'SYSTEM';

  @override
  String get skapiBfEndpointsKindUser => 'USER';

  @override
  String get skapiBfEndpointsEmpty =>
      'Nenhum endpoint armazenado neste dispositivo.';

  @override
  String get skapiBfEndpointsClose => 'Fechar';

  @override
  String get skapiBfEndpointsRefresh => 'Consultar de novo';

  @override
  String skapiStarredCount(int count) {
    return '$count favoritos';
  }

  @override
  String get skapiStarredSlimEmpty =>
      'Marque entradas da biblioteca como favoritas para reunir aqui as mais usadas.';

  @override
  String get skapiCommunityShareTitle =>
      'Compartilhe sua biblioteca com a comunidade SmartKraft';

  @override
  String get skapiCommunityShareBody =>
      'Os scripts que você escreve ficam disponíveis para todos na biblioteca do SKAPI.';

  @override
  String get settingsNetworkIdentityTitle => 'Identidade de rede';

  @override
  String get settingsNetworkIdentityName => 'Nome do computador';

  @override
  String get settingsNetworkIdentityNameHint =>
      'Usado como nome da instância mDNS';

  @override
  String get settingsNetworkIdentityNameEdit => 'Renomear';

  @override
  String get settingsNetworkIdentityNameDialogTitle =>
      'Renomear este computador';

  @override
  String get settingsNetworkIdentityNameDialogHelp =>
      'Letras minúsculas, números e hifens. Até 32 caracteres.';

  @override
  String get settingsNetworkIdentityUuid => 'ID do dispositivo';

  @override
  String get settingsNetworkIdentityPort => 'Porta do ouvinte';

  @override
  String get settingsNetworkIdentityPortDialogTitle => 'Porta do ouvinte';

  @override
  String get settingsNetworkIdentityToken => 'Token Bearer';

  @override
  String get settingsNetworkIdentityRegenerateToken => 'Regenerar token';

  @override
  String get settingsNetworkIdentityRegenerateConfirmTitle =>
      'Regenerar o token Bearer?';

  @override
  String get settingsNetworkIdentityRegenerateConfirmBody =>
      'Os dispositivos existentes precisarão ser pareados novamente com o novo token.';

  @override
  String get settingsNetworkIdentityServerNotRunning =>
      'O servidor ainda não está em execução; será ativado na Fase 2.';

  @override
  String get settingsNetworkIdentityCopy => 'Copiar';

  @override
  String get settingsNetworkIdentityCopied => 'Copiado';

  @override
  String get settingsNetworkIdentityStaticIpHint =>
      'Dica: uma reserva de DHCP (IP estático) no seu roteador deixa as conexões mais confiáveis.';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsSectionAppearance => 'Aparência';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageSystemHint => 'Seguir o idioma do sistema';

  @override
  String get settingsLanguagePickerAllSection => 'Todos os idiomas';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDark => 'Escuro';

  @override
  String get settingsThemeSystem => 'Sistema';

  @override
  String get settingsSectionAbout => 'Sobre';

  @override
  String get settingsVersion => 'Versão';

  @override
  String get settingsDeveloper => 'Desenvolvedor';

  @override
  String get settingsDeveloperName => 'SmartKraft';

  @override
  String get settingsOpenAbout => 'Sobre o SKAPP';

  @override
  String get settingsSectionAdvanced => 'Avançado';

  @override
  String get settingsDeveloperMode => 'Modo desenvolvedor';

  @override
  String get settingsDeveloperToolsTitle => 'Ferramentas de desenvolvedor';

  @override
  String get settingsDeveloperToolsSubtitle =>
      'Console USB, identidade de rede, ouvinte, tokens, registros';

  @override
  String get settingsDeveloperModeInfoTitle =>
      'O que o modo desenvolvedor libera?';

  @override
  String get settingsDeveloperModeInfoIntro =>
      'Este modo revela recursos avançados ocultos na interface padrão. Três casos de uso principais:';

  @override
  String get settingsDeveloperModeUseCaseCliTitle => 'Console CLI';

  @override
  String get settingsDeveloperModeUseCaseCliBody =>
      'Configure seus dispositivos por cabo USB sem precisar antes de uma conexão BLE ou Wi-Fi.';

  @override
  String get settingsDeveloperModeUseCaseSkapiTitle => 'Editor de código SKAPI';

  @override
  String get settingsDeveloperModeUseCaseSkapiBody =>
      'Abra e modifique scripts embutidos, ou escreva os seus do zero.';

  @override
  String get settingsDeveloperModeUseCaseMobileTitle =>
      'Acionamento remoto pelo celular';

  @override
  String get settingsDeveloperModeUseCaseMobileBody =>
      'Execute os vínculos SKAPI deste desktop a partir de um SKAPP móvel pareado.';

  @override
  String get settingsDeveloperModeInfoSurfacesHeader =>
      'Cartões extras de Configurações que aparecem quando está ativado:';

  @override
  String get settingsDeveloperModeInfoItem1 =>
      'Cartão de identidade de rede: edite UUID, porta, token Bearer; copie / regenere o segredo de instalação do SKAPP.';

  @override
  String get settingsDeveloperModeInfoItem2 =>
      'Controles do ouvinte HTTP local: iniciar/parar, pareamento por QR, rotação de certificado TLS, visibilidade na LAN.';

  @override
  String get settingsDeveloperModeInfoItem3 =>
      'Lista de tokens por par: veja cada SKAPP móvel pareado e revogue individualmente.';

  @override
  String get settingsDeveloperModeInfoItem4 =>
      'Console CLI por USB (somente desktop): linha de comando NDJSON bruta para um dispositivo SmartKraft conectado por USB.';

  @override
  String get settingsDeveloperModeInfoNotPaid =>
      'Não é uma atualização paga. O SKAPP tem um único nível e é gratuito; este botão só esconde recursos avançados por padrão para manter as coisas simples. Os dispositivos SmartKraft funcionam de forma independente dessa configuração.';

  @override
  String get settingsSectionConnectivity => 'Conectividade';

  @override
  String get settingsBluetoothStatus => 'Bluetooth';

  @override
  String get settingsBluetoothStatusOn => 'Pronto';

  @override
  String get settingsBluetoothStatusOff => 'Desligado';

  @override
  String get settingsBluetoothStatusTurningOn => 'Ligando…';

  @override
  String get settingsBluetoothStatusTurningOff => 'Desligando…';

  @override
  String get settingsBluetoothStatusUnauthorized => 'Sem permissão';

  @override
  String get settingsBluetoothStatusUnsupported => 'Não suportado';

  @override
  String get settingsBluetoothStatusUnknown => 'Verificando…';

  @override
  String get settingsNetworkStatus => 'Rede';

  @override
  String get settingsWifiStatusConnected => 'Wi-Fi';

  @override
  String get settingsWifiStatusEthernet => 'Ethernet';

  @override
  String get settingsWifiStatusMobile => 'Dados móveis';

  @override
  String get settingsWifiStatusDisconnected => 'Desconectado';

  @override
  String get settingsWifiStatusUnknown => 'Verificando…';

  @override
  String get settingsWifiHint => 'Usado após o pareamento inicial.';

  @override
  String get settingsBluetoothPermissions => 'Permissões';

  @override
  String get settingsBluetoothPermissionsHint =>
      'Acesso a Bluetooth e localização';

  @override
  String get settingsBluetoothGrantPermission => 'Conceder acesso';

  @override
  String get settingsOpenSystemSettings => 'Abrir configurações do sistema';

  @override
  String get settingsSectionUpdates => 'Atualizações';

  @override
  String get settingsCheckUpdates => 'Verificar atualizações';

  @override
  String get settingsAutoCheckUpdates => 'Verificar ao iniciar';

  @override
  String get settingsAutoCheckUpdatesHint =>
      'Confira se você está na versão mais recente toda vez que o SKAPP abrir.';

  @override
  String get settingsUpdateChannel => 'Canal de atualização';

  @override
  String get settingsUpdateChannelStable => 'Estável';

  @override
  String get settingsUpdateChannelBeta => 'Beta';

  @override
  String get settingsUpdateChannelBetaHint =>
      'Receba novos recursos antes. Pode ser menos estável.';

  @override
  String get settingsUpToDate => 'Você está na versão mais recente.';

  @override
  String get settingsUpdateCheckPlaceholder =>
      'A verificação de atualizações será conectada na Fase 3.';

  @override
  String get settingsSectionLegal => 'Jurídico';

  @override
  String get settingsLicense => 'Licença e agradecimentos';

  @override
  String get settingsSectionInfo => 'Informações';

  @override
  String get settingsThemeCycleHint => 'Toque para alternar';

  @override
  String get settingsChannelCycleHint => 'Toque para alternar';

  @override
  String get settingsSectionThisNode => 'Este nó';

  @override
  String get settingsNodeNameTitle => 'Nome do nó SKAPP';

  @override
  String settingsNodeNameSub(String name) {
    return '$name · outros SKAPPs veem este nome · transmissão mDNS';
  }

  @override
  String get settingsSectionDanger => 'Zona de perigo';

  @override
  String get settingsResetPairings => 'Redefinir pareamentos';

  @override
  String get settingsResetPairingsSub =>
      'Remove todos os dispositivos pareados; configurações/idioma/nome do nó são preservados';

  @override
  String get settingsFactoryReset => 'Redefinição de fábrica';

  @override
  String get settingsFactoryResetSub => 'Tudo é apagado, irreversível';

  @override
  String get settingsSectionAdvancedNetwork => 'Rede avançada';

  @override
  String get settingsResetPairingsConfirmTitle =>
      'Redefinir todos os pareamentos?';

  @override
  String settingsResetPairingsConfirmBody(int paired, int bindings, int peers) {
    return '$paired dispositivo(s) pareado(s), $bindings ação(ões) SKAPI e $peers par(es) SKAPP serão removidos. Suas configurações, tema, idioma e notas são mantidos. Os dispositivos ainda guardam o vínculo do lado deles; para desparear totalmente, redefina o dispositivo manualmente. Isso não pode ser desfeito.';
  }

  @override
  String get settingsResetPairingsConfirmAction => 'Redefinir';

  @override
  String get settingsFactoryResetConfirmTitle => 'Redefinição de fábrica?';

  @override
  String get settingsFactoryResetConfirmBody =>
      'Tudo será apagado: todos os pareamentos, configurações, tema, idioma, notas, identidade de rede, certificado TLS e a entrada de início automático. O SKAPP volta ao estado de primeira execução. Isso não pode ser desfeito.';

  @override
  String get settingsFactoryResetConfirmAction => 'Apagar tudo';

  @override
  String get settingsFactoryResetSecondConfirmTitle =>
      'Você tem certeza absoluta?';

  @override
  String get settingsFactoryResetSecondConfirmBody =>
      'Digite APAGAR para confirmar.';

  @override
  String get settingsFactoryResetSecondConfirmHint => 'APAGAR';

  @override
  String get settingsFactoryResetSecondConfirmAction => 'Eu entendo. Apagar.';

  @override
  String get settingsResetInProgress => 'Redefinindo…';

  @override
  String get settingsResetDoneTitle => 'Redefinição concluída';

  @override
  String get settingsResetDoneWithWarnings =>
      'Redefinição concluída (com avisos)';

  @override
  String settingsResetSummaryPaired(int count) {
    return '$count dispositivo(s) pareado(s) removido(s)';
  }

  @override
  String settingsResetSummaryBindings(int count) {
    return '$count ação(ões) SKAPI removida(s)';
  }

  @override
  String settingsResetSummaryPeers(int count) {
    return '$count par(es) SKAPP removido(s)';
  }

  @override
  String settingsResetSummaryBonds(int count) {
    return '$count vínculo(s) de dispositivo limpo(s)';
  }

  @override
  String get settingsResetSummaryNetworkIdentity =>
      'Identidade de rede redefinida para o padrão';

  @override
  String get settingsResetSummaryTlsCert => 'Certificado TLS removido';

  @override
  String get settingsResetSummaryAutostart =>
      'Entrada de início automático removida';

  @override
  String get settingsResetSummaryWarningHeader => 'Avisos:';

  @override
  String get settingsResetRestartHint =>
      'Reinicie o SKAPP para aplicar totalmente as alterações.';

  @override
  String get settingsResetRestartNow => 'Reiniciar agora';

  @override
  String get settingsResetClose => 'Fechar';

  @override
  String settingsFooterCombined(String version, String node) {
    return 'SKAPP $version · $node';
  }

  @override
  String get langEnglish => 'English';

  @override
  String get langTurkish => 'Türkçe';

  @override
  String get aboutTitle => 'Sobre a SmartKraft e o SKAPP';

  @override
  String get aboutDevicesHeading => 'Nossos dispositivos';

  @override
  String get aboutDevicesBody =>
      'Os dispositivos SmartKraft são feitos para serem inovadores, distintos e para trazer detalhes que outros não pensaram. Nosso objetivo não é reproduzir o que já existe; é fazer o que ainda não foi feito, o que ficou por fazer. Apontar para um problema cotidiano sem solução e oferecer a ele uma resposta simples e compreensível; ou pegar algo já resolvido, mas que continuou caro, e colocar no lugar uma versão DIY que qualquer um possa construir.\n\nCada dispositivo SmartKraft é projetado e construído para dar uma resposta pequena e direta a um problema ainda não resolvido. Ao projetar um dispositivo, fazemos a nós mesmos uma única pergunta: \"Por que esse problema ainda não foi resolvido, ou por que ele continuou tão caro?\"';

  @override
  String get aboutSkappRoleHeading => 'Onde o SKAPP se encaixa';

  @override
  String get aboutSkappRoleBody =>
      'O SKAPP é o aplicativo compartilhado dos dispositivos SmartKraft. É uma interface simples para parear um dispositivo, configurá-lo, mudar seu comportamento e reunir vários dispositivos em um único cenário.\n\nO SKAPP não é obrigatório para seus dispositivos; é uma comodidade. Todo dispositivo SmartKraft pode ser configurado da mesma forma por USB CLI sem o SKAPP, e esse caminho continua aberto para quem prefere a linha de comando. Para todos os outros que querem a agilidade de uma interface visual e o conforto de gerenciar vários dispositivos de uma vez, o SKAPP está aqui.\n\nSem conta na nuvem. Sem publicidade. Sem coleta de dados. É uma ponte silenciosa entre o seu celular e o seu dispositivo, nada mais.';

  @override
  String get aboutShowcaseHeading => 'Vitrine de makers';

  @override
  String get aboutShowcaseEmpty =>
      'A vitrine está vazia por enquanto. O primeiro dispositivo SmartKraft está a caminho; arquivos de design, fontes de firmware, listas de peças e guias de montagem serão listados aqui quando estiverem prontos. Até lá, esta seção não promete muito; é apenas um espaço reservado para o que está por vir.';

  @override
  String get aboutConnectHeading => 'Conecte-se';

  @override
  String get aboutConnectIntro =>
      'Envie uma mensagem, veja o código-fonte, acompanhe o trabalho à medida que ele cresce.';

  @override
  String get aboutConnectGitHub => 'GitHub';

  @override
  String get aboutConnectWebsite => 'Site';

  @override
  String get aboutConnectYouTube => 'YouTube';

  @override
  String get aboutConnectX => 'X';

  @override
  String get aboutConnectEmail => 'E-mail';

  @override
  String get aboutVersionHeading => 'Versão';

  @override
  String get licenseTitle => 'Licença e agradecimentos';

  @override
  String get licenseSmartKraftHeading => 'Sobre a SmartKraft';

  @override
  String get licenseSmartKraftBody =>
      'A SmartKraft é uma pequena oficina que projeta ferramentas eletrônicas incomuns, mas práticas, para o dia a dia. Por trás de cada dispositivo que chega às suas mãos há inúmeros passos: um primeiro rascunho em um caderno, um primeiro protótipo soldado, linhas de código escritas tarde da noite, pequenos detalhes refeitos uma e outra vez. Construir um dispositivo significa escrever linhas, desenhar circuitos, soldar junções, encontrar bugs, recomeçar. A todos que dedicaram seu esforço a esse processo sem deixar um nome nele, obrigado, em nome da SmartKraft.\n\nAcreditamos na cultura maker, no código aberto e em eletrônicos reparáveis e recicláveis. Por isso publicamos os projetos de hardware dos nossos dispositivos como hardware aberto, e seu firmware sob a AGPL 3.0. Nosso objetivo é tornar acessível uma versão DIY de quantas partes for possível.\n\nUma observação sobre a qual queremos ser honestos: as chaves de pareamento e os segredos de comunicação que protegem a segurança de um dispositivo são mantidos privados no código-fonte. Se fossem publicados, a confiança entre o seu dispositivo e o aplicativo se romperia. Esse fechamento não é uma concessão contra a abertura; é uma decisão tomada pela sua segurança.\n\nPara o SKAPP e cada dispositivo que conversa com ele, nosso princípio é a transparência: queremos que você consiga ler como as coisas funcionam, auditá-las e construir a sua própria versão. Ainda assim, cada dispositivo tem sua própria seção de licença e os termos podem variar. Para ver o código-fonte, os esquemáticos ou os termos de uso de um dispositivo, consulte a área de licença do próprio dispositivo.\n\nObrigado por nos apoiar usando este aplicativo. Ficamos felizes por você estar aqui.';

  @override
  String get licenseOpenSourceHeading => 'Apoiados em seus ombros';

  @override
  String get licenseOpenSourceBody =>
      'O SKAPP é construído sobre milhares de projetos de código aberto escritos antes dele. Um agradecimento sincero à equipe do Flutter e seus contribuidores por tornarem possível a interface visível, e a todos os desenvolvedores de código aberto que dedicaram anos a redes, armazenamento, criptografia, Bluetooth e incontáveis subsistemas.\n\nPorque nos beneficiamos do código aberto, procuramos manter o hardware e o firmware dos nossos dispositivos abertos também, para que quem vier depois de nós possa se beneficiar deste corpo de trabalho da mesma forma.\n\nObrigado novamente a todos que fizeram parte deste esforço.';

  @override
  String get licenseThirdPartyLink =>
      'Licenças de terceiros usadas neste aplicativo';

  @override
  String get discoveryTitle => 'Encontrar dispositivos';

  @override
  String get discoverySearching =>
      'Procurando dispositivos SmartKraft por perto…';

  @override
  String get discoveryNoResults =>
      'Nenhum dispositivo SmartKraft encontrado por perto.';

  @override
  String get discoveryTapToConnect => 'Toque em um dispositivo para conectar';

  @override
  String get discoveryRescan => 'Buscar novamente';

  @override
  String get pairingTitle => 'Parear dispositivo';

  @override
  String get pairingEnterPasskey =>
      'Digite a chave de acesso impressa na etiqueta do dispositivo.';

  @override
  String get pairingPasskeyHint => 'ex.: K7M9P2AB';

  @override
  String get pairingConnect => 'Conectar';

  @override
  String get pairingMockNotice =>
      'O firmware do dispositivo ainda não está pronto. O pareamento é um espaço reservado nesta versão.';

  @override
  String get errorBluetoothPermission =>
      'A permissão de Bluetooth é necessária para buscar dispositivos.';

  @override
  String get errorBluetoothOff => 'O Bluetooth está desligado.';

  @override
  String get errorLocationPermission =>
      'A permissão de localização é necessária para buscar dispositivos BLE no Android.';

  @override
  String get actionOpenSettings => 'Abrir configurações';

  @override
  String get actionGrantPermission => 'Conceder permissão';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonConfirm => 'Confirmar';

  @override
  String get commonRetry => 'Tentar de novo';

  @override
  String get commonBack => 'Voltar';

  @override
  String get commonRemove => 'Remover';

  @override
  String get commonRefresh => 'Atualizar';

  @override
  String get commonOk => 'OK';

  @override
  String get commonClose => 'Fechar';

  @override
  String get commonSave => 'Salvar';

  @override
  String get commonDelete => 'Excluir';

  @override
  String get commonConnect => 'Conectar';

  @override
  String get commonAdd => 'Adicionar';

  @override
  String get commonForget => 'Esquecer';

  @override
  String get commonMore => 'Mais';

  @override
  String get commonError => 'Erro';

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
  String get timeJustNow => 'agora mesmo';

  @override
  String timeMinAgo(int count) {
    return 'há $count min';
  }

  @override
  String timeHourAgo(int count) {
    return 'há $count h';
  }

  @override
  String timeDayAgo(int count) {
    return 'há $count d';
  }

  @override
  String get devicesRemoveTitle => 'Remover dispositivo';

  @override
  String devicesRemoveBody(String name) {
    return '$name será removido. O dispositivo continua conectado; para adicioná-lo de novo será preciso parear novamente.';
  }

  @override
  String get devicesUnpair => 'Desparear';

  @override
  String get devicesEmptyHint =>
      'Aproxime seu dispositivo SmartKraft e toque no botão abaixo.';

  @override
  String get devicesEmptyTitleNoPaired => 'Nenhum dispositivo pareado ainda';

  @override
  String devicesLastSeen(String time) {
    return 'Visto pela última vez: $time';
  }

  @override
  String devicesPairedAt(String time) {
    return 'Pareado: $time';
  }

  @override
  String devicesHubSubtitle(int count) {
    return 'Host SKAPP · $count pareados';
  }

  @override
  String get devicesHubEmptySubtitle => 'aguardando dispositivo';

  @override
  String devicesHeaderSub(int paired, int online) {
    return '$paired pareados · $online online · vista de constelação';
  }

  @override
  String get devicesAddPillLabel => 'Adicionar dispositivo';

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
    return 'bateria fraca ($count)';
  }

  @override
  String get devicesStatPaired => 'pareados';

  @override
  String get devicesStatBf => 'BF';

  @override
  String get devicesStatLs => 'LS';

  @override
  String get devicesStatMs => 'celular';

  @override
  String get devicesEmptyHubLabel => 'Desconhecido';

  @override
  String get devicesEmptyAddCta => 'Adicionar primeiro dispositivo';

  @override
  String get devicesEmptyHintChip =>
      'aproxime o dispositivo, pressione o botão dele';

  @override
  String devicesNotifOfflineHours(int hours) {
    return 'offline há ${hours}h';
  }

  @override
  String devicesNotifOfflineMinutes(int minutes) {
    return 'offline há ${minutes}m';
  }

  @override
  String get devicesNotifLowBattery => 'bateria fraca';

  @override
  String get skappPeersCardTitle => 'SKAPPs Desktop pareados';

  @override
  String get skappPeersCardSubtitle =>
      'Celulares e tablets se pareiam aqui para que uma ação BF possa executar um script em um SKAPP Desktop. Abra SKAPP Desktop > Configurações > Ouvinte HTTP do SKAPP para obter um QR.';

  @override
  String get skappPeersCardEmpty => 'Nenhum par pareado ainda.';

  @override
  String get skappPeersCardPairButton => 'Parear novo';

  @override
  String get skappPeersCardOnline => 'online';

  @override
  String get skappPeersCardOffline => 'offline';

  @override
  String get skappPeersCardNeverSeen => 'nunca visto';

  @override
  String skappPeersCardRemoveTitle(String name) {
    return 'Remover $name?';
  }

  @override
  String get skappPeersCardRemoveBody =>
      'O SKAPP deixará de enviar scripts para este par. Você pode parear novamente com o mesmo QR / token depois.';

  @override
  String get skappPeersCardRemoveConfirm => 'Remover';

  @override
  String get skappPeersCardRemoveCancel => 'Cancelar';

  @override
  String skappPeersCardRemovedToast(String name) {
    return '$name despareado';
  }

  @override
  String get devicesCardLongPressHint => 'Mantenha pressionado para gerenciar';

  @override
  String devicesActionsSheetTitle(String name) {
    return '$name';
  }

  @override
  String get devicesActionForget => 'Esquecer dispositivo';

  @override
  String get devicesActionForgetSubtitle =>
      'Remove este dispositivo do SKAPP. O dispositivo em si não é afetado; você pode pareá-lo novamente depois.';

  @override
  String get devicesActionCancel => 'Cancelar';

  @override
  String devicesForgetDialogTitle(String name) {
    return 'Esquecer $name?';
  }

  @override
  String get devicesForgetDialogBody =>
      'O SKAPP deixará de rastrear este dispositivo. O pareamento do lado do dispositivo permanece até você redefini-lo pelo próprio dispositivo.';

  @override
  String devicesForgetDialogBodyWithActions(int count) {
    return 'O SKAPP deixará de rastrear este dispositivo e excluirá $count ação(ões) SKAPI vinculada(s) a ele. O pareamento do lado do dispositivo permanece até você redefini-lo pelo próprio dispositivo.';
  }

  @override
  String get devicesForgetDialogConfirm => 'Esquecer';

  @override
  String get devicesForgetDialogCancel => 'Cancelar';

  @override
  String devicesForgotToast(String name) {
    return '$name removido do SKAPP';
  }

  @override
  String get devicesMobileNoDetailHint =>
      'Sem página de detalhes para celulares · mantenha pressionado para desparear';

  @override
  String get devicesDesktopStatLabel => 'desktop';

  @override
  String get devicesDesktopGroupLabel => 'Desktops pareados';

  @override
  String get devicesDesktopTriggerDialogTitle => 'Enviar um comando SKAPI?';

  @override
  String devicesDesktopTriggerDialogBody(String name) {
    return 'Todos os vínculos de toque móvel em $name serão executados.';
  }

  @override
  String get devicesDesktopTriggerDialogConfirm => 'Enviar comando';

  @override
  String get devicesDesktopTriggerDialogCancel => 'Cancelar';

  @override
  String get devicesDesktopForgetDialogTitle => 'Desparear';

  @override
  String devicesDesktopForgetDialogBody(String name) {
    return 'Despareando $name. Será preciso parear novamente para enviar comandos a este desktop.';
  }

  @override
  String devicesDesktopForgotToast(String name) {
    return '$name despareado';
  }

  @override
  String get homeStatDevices => 'Dispositivos';

  @override
  String get homeStatOnline => 'Online';

  @override
  String get homeStatWarning => 'Aviso';

  @override
  String homeWarningMeta(String time) {
    return 'Pareado, mas nunca visto · $time';
  }

  @override
  String get homeBrandTotal => 'Total';

  @override
  String get homeBrandActive => 'Ativos';

  @override
  String get homeBrandActions => 'Ações';

  @override
  String get homeBrandVersion => 'Versão';

  @override
  String get smartkraftSectionProducts => 'Produtos';

  @override
  String get smartkraftSectionCommunity => 'Comunidade';

  @override
  String get smartkraftStatusLive => 'NO AR';

  @override
  String get smartkraftStatusDev => 'EM DESENV.';

  @override
  String get smartkraftStatusConcept => 'CONCEITO';

  @override
  String get smartkraftBlockingFocusTagline =>
      'A pausa da qual você não consegue escapar.';

  @override
  String get smartkraftLebensSpurTagline =>
      'Uma testemunha silenciosa dos seus hábitos.';

  @override
  String get smartkraftSynDimmTagline => 'A luz certa na hora certa.';

  @override
  String homeStickyDevicesMeta(int count, int warning) {
    return '$count dispositivos · $warning alertas';
  }

  @override
  String homeStickySkapiMeta(int actions) {
    return '$actions ações';
  }

  @override
  String homeStickySettingsMeta(String node, String version) {
    return '$node · v$version';
  }

  @override
  String get homeStickyComingSoonMeta => 'conteúdo em andamento';

  @override
  String get homeStickyNotesLabel => 'Notas';

  @override
  String get setupChoiceTitle => 'Adicionar dispositivo';

  @override
  String get setupChoiceQuestion => 'Onde estamos?';

  @override
  String get setupChoiceSubtitle =>
      'O dispositivo está recém-saído da caixa ou já foi configurado via CLI antes?';

  @override
  String get setupChoiceFreshTitle => 'Configuração nova';

  @override
  String get setupChoiceFreshBody =>
      'Estou adicionando um dispositivo SmartKraft novinho pela primeira vez. O pareamento será feito por BLE e o assistente de configuração de Wi-Fi vai abrir.';

  @override
  String get setupChoiceExistingTitle =>
      'Adicionar um dispositivo já configurado';

  @override
  String get setupChoiceExistingBody =>
      'Configurei o Wi-Fi do meu dispositivo via USB/CLI e estou na mesma rede. Pareie diretamente por Wi-Fi e pule o assistente.';

  @override
  String get setupChoiceFooter =>
      'Na dúvida, escolha \"Configuração nova\"; é o caminho certo tanto para o primeiro pareamento quanto para dispositivos restaurados de fábrica.';

  @override
  String get wifiDiscoveryTitle => 'Dispositivos nesta rede';

  @override
  String wifiDiscoveryScanError(String error) {
    return 'Erro de busca: $error';
  }

  @override
  String get wifiDiscoveryHint =>
      'O dispositivo precisa estar no Wi-Fi e o celular na mesma rede. Será pedido que você pressione o botão do dispositivo durante o pareamento.';

  @override
  String get wifiDiscoveryScanning => 'Buscando…';

  @override
  String get wifiDiscoveryNotFound => 'Nenhum dispositivo encontrado';

  @override
  String wifiDiscoveryFoundCount(int count) {
    return '$count dispositivo(s) encontrado(s)';
  }

  @override
  String get wifiDiscoveryEmptyTitle =>
      'Procurando dispositivos SmartKraft nesta rede…';

  @override
  String get wifiDiscoveryEmptyTitleIdle => 'Nenhum dispositivo encontrado.';

  @override
  String get wifiDiscoveryEmptyHint =>
      'Verifique se o dispositivo está ligado, conectado ao Wi-Fi e na mesma rede do seu celular. Use o botão de atualizar para tentar de novo.';

  @override
  String get wifiDiscoveryPairedBadge => 'pareado';

  @override
  String get wifiPairingTitle => 'Pareamento';

  @override
  String wifiPairingConnectFailed(String error) {
    return 'Não foi possível conectar: $error';
  }

  @override
  String wifiPairingInvalidJson(String error) {
    return 'JSON inválido: $error';
  }

  @override
  String get wifiPairingClosedEarly => 'Conexão encerrada (sem resposta)';

  @override
  String wifiPairingSendFailed(String error) {
    return 'Não foi possível enviar o comando: $error';
  }

  @override
  String get wifiPairingTimeout =>
      'O dispositivo não respondeu (tempo esgotado).';

  @override
  String get wifiPairingNotOpen =>
      'A janela de pareamento não está aberta no dispositivo. Pressione o botão rapidamente e tente de novo.';

  @override
  String get skapiBindFixedTriggerLabel => 'Gatilho: quando o timer expira';

  @override
  String get wifiPairingDeviceAlreadyBonded =>
      'Este dispositivo já está pareado com outro SKAPP. Adicionar um novo par por Wi-Fi não é suportado pelo firmware atual (o TCP só aceita o primeiro par). Use o pareamento por BLE, ou desfaça o pareamento do par existente no dispositivo.';

  @override
  String wifiPairingRejected(String error) {
    return 'Dispositivo rejeitou: $error';
  }

  @override
  String get wifiPairingMissingPub =>
      'our_pub ausente/corrompido do dispositivo.';

  @override
  String wifiPairingHexError(String error) {
    return 'falha na decodificação hex de our_pub: $error';
  }

  @override
  String get wifiPairingStageAwaiting => 'Pressione o botão no dispositivo';

  @override
  String get wifiPairingStageConnecting => 'Conectando ao dispositivo…';

  @override
  String get wifiPairingStageExchanging => 'Trocando chaves…';

  @override
  String get wifiPairingStageDone => 'Pareamento concluído';

  @override
  String get wifiPairingStageFailed => 'Falha no pareamento';

  @override
  String get wifiPairingStageAwaitingHelp =>
      'Pressione brevemente o botão de controle do dispositivo (menos de 3 segundos). A janela de pareamento fica aberta por 60 segundos.';

  @override
  String get wifiPairingStageConnectingHelp => 'Abrindo o socket TCP.';

  @override
  String get wifiPairingStageExchangingHelp =>
      'pairing.ecdh.exchange enviado, aguardando a resposta do dispositivo.';

  @override
  String get wifiPairingStageDoneHelp => 'Indo para o painel do dispositivo.';

  @override
  String get wifiPairingStartCta => 'Parear';

  @override
  String get bfDashboardTitleFallback => 'Dispositivo';

  @override
  String get bfDashboardWifiNone => 'Sem Wi-Fi';

  @override
  String get bfDashboardLinkBle => 'BLE';

  @override
  String get bfDashboardLinkWifi => 'Wi-Fi';

  @override
  String get bfDashboardLinkUsb => 'USB';

  @override
  String get bfDashboardToggleVibration => 'Vibração';

  @override
  String get bfDashboardToggleTilt => 'Alerta de inclinação';

  @override
  String get bfDashboardToggleLowBatt => 'Alerta de bateria fraca';

  @override
  String get bfDashboardApiChainTitle => 'Cadeia de API';

  @override
  String bfDashboardApiChainNone(String state) {
    return 'nenhum endpoint ainda · mestre $state';
  }

  @override
  String bfDashboardApiChainSummary(int count, String state) {
    return '$count endpoint(s) · mestre $state';
  }

  @override
  String get bfDashboardMasterOn => 'ligado';

  @override
  String get bfDashboardMasterOff => 'desligado';

  @override
  String get bfDashboardNotebookTitle => 'Caderno do usuário';

  @override
  String get bfDashboardNotebookSubtitle =>
      'Área criptografada · 100 KB · conteúdo livre';

  @override
  String get bfDashboardMoreDeviceInfo => 'Informações do dispositivo';

  @override
  String get bfDashboardMoreSettings => 'Configurações';

  @override
  String bfDashboardWriteFailed(String error) {
    return 'Não foi possível gravar: $error';
  }

  @override
  String get bfDeviceInfoTitle => 'Informações do dispositivo';

  @override
  String get bfDeviceInfoSectionGeneral => 'GERAL';

  @override
  String get bfDeviceInfoSectionConnection => 'CONEXÃO';

  @override
  String get bfDeviceInfoSectionBattery => 'BATERIA';

  @override
  String get bfDeviceInfoSectionTime => 'HORA';

  @override
  String get bfDeviceInfoSectionLastError => 'ÚLTIMO ERRO';

  @override
  String get bfDeviceInfoSectionDiagnostics => 'DIAGNÓSTICO';

  @override
  String get bfDeviceInfoSectionDocs => 'DOCS';

  @override
  String get bfDeviceInfoProduct => 'Produto';

  @override
  String get bfDeviceInfoTypeCode => 'Código de tipo';

  @override
  String get bfDeviceInfoIdentity => 'Identidade';

  @override
  String get bfDeviceInfoHardware => 'Hardware';

  @override
  String get bfDeviceInfoFirmware => 'Firmware';

  @override
  String get bfDeviceInfoProtocol => 'Protocolo';

  @override
  String get bfDeviceInfoBuild => 'Build';

  @override
  String get bfDeviceInfoUptime => 'Tempo ativo';

  @override
  String get bfDeviceInfoWifiState => 'Estado do Wi-Fi';

  @override
  String get bfDeviceInfoIp => 'IP';

  @override
  String get bfDeviceInfoSignal => 'Sinal';

  @override
  String get bfDeviceInfoBleAdvertising => 'Anúncio BLE';

  @override
  String get bfDeviceInfoBlePaired => 'Pareamentos BLE';

  @override
  String bfDeviceInfoPairedClients(int count) {
    return '$count cliente(s)';
  }

  @override
  String get bfDeviceInfoBattery => 'Bateria';

  @override
  String get bfDeviceInfoBatteryPresent => 'presente';

  @override
  String get bfDeviceInfoBatteryAbsent => 'ausente';

  @override
  String get bfDeviceInfoDeviceClock => 'Relógio do dispositivo';

  @override
  String get bfDeviceInfoLogs => 'Registros do dispositivo';

  @override
  String get bfDeviceInfoLogsSubtitle =>
      'logs.get, boot, erro, timer, eventos de API';

  @override
  String get bfDeviceInfoEvents => 'Histórico de eventos';

  @override
  String get bfDeviceInfoEventsSubtitle =>
      'Local · timer, mudança de face, gatilhos de API';

  @override
  String get bfDeviceInfoUserGuide => 'Guia do usuário';

  @override
  String get bfDeviceInfoUserGuideSubtitle =>
      'Atribuição de face, timer, gatilhos de API';

  @override
  String get bfDeviceInfoDevNotes => 'Notas do desenvolvedor SK';

  @override
  String get bfDeviceInfoDevNotesSubtitle =>
      'Comandos CLI, arquitetura, taxonomia de eventos';

  @override
  String get bfDeviceInfoLicense => 'Licença e fontes abertas';

  @override
  String get bfDeviceInfoLicenseSubtitle =>
      'Bibliotecas usadas e informações de copyright';

  @override
  String get bfDeviceInfoComingSoon => 'Em breve';

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
  String get bfDeviceInfoYes => 'sim';

  @override
  String get bfDeviceInfoNo => 'não';

  @override
  String get bfSettingsTitle => 'Configurações';

  @override
  String get bfSettingsSectionNetwork => 'REDE';

  @override
  String get bfSettingsSectionUpdates => 'ATUALIZAÇÕES';

  @override
  String get bfSettingsSectionDanger => 'ZONA DE PERIGO';

  @override
  String get bfSettingsWifiPrimary => 'Wi-Fi principal';

  @override
  String get bfSettingsWifiSecondary => 'Wi-Fi reserva';

  @override
  String get bfSettingsWifiUnconfigured => 'Não configurado';

  @override
  String get bfSettingsFirmware => 'Firmware';

  @override
  String get bfSettingsCheckUpdates => 'Verificar atualizações';

  @override
  String get bfSettingsCheckUpdatesSubtitle =>
      'Ativa quando uma URL de manifesto é definida';

  @override
  String get bfOtaTitle => 'Atualização de firmware';

  @override
  String get bfOtaCurrentLabel => 'Versão instalada';

  @override
  String get bfOtaRunningPartitionLabel => 'Partição ativa';

  @override
  String get bfOtaCheckCta => 'Verificar atualizações';

  @override
  String get bfOtaIdleHint =>
      'Nenhuma verificação de atualização foi feita ainda.';

  @override
  String get bfOtaChecking => 'Consultando o servidor de atualização…';

  @override
  String get bfOtaUpToDate => 'O dispositivo está atualizado.';

  @override
  String bfOtaAvailable(String version) {
    return 'Nova versão disponível: $version';
  }

  @override
  String get bfOtaUpdateCta => 'Atualizar agora';

  @override
  String bfOtaDownloading(int pct) {
    return 'Baixando… %$pct';
  }

  @override
  String get bfOtaDone => 'Atualizado. O dispositivo está reiniciando…';

  @override
  String bfOtaErrorMsg(String message) {
    return 'Erro: $message';
  }

  @override
  String get bfOtaRollbackCta => 'Reverter para a versão anterior';

  @override
  String get bfOtaUpdateConfirmTitle => 'Instalar a atualização de firmware?';

  @override
  String bfOtaUpdateConfirmBody(String version) {
    return 'A versão $version será baixada e instalada, depois o dispositivo reinicia. Não o desligue durante a atualização.';
  }

  @override
  String get bfOtaRollbackConfirmTitle => 'Reverter o firmware?';

  @override
  String get bfOtaRollbackConfirmBody =>
      'O dispositivo iniciará com o firmware anterior e reiniciará.';

  @override
  String get bfSettingsReboot => 'Reiniciar dispositivo';

  @override
  String get bfSettingsRebootSubtitle =>
      'Reinicia o dispositivo · cancela qualquer timer ativo';

  @override
  String get bfSettingsRebootConfirmTitle => 'Reiniciar dispositivo?';

  @override
  String get bfSettingsRebootConfirmBody =>
      'O dispositivo será desligado e ligado novamente em alguns segundos.';

  @override
  String get bfSettingsUnpairThisPhone => 'Desparear este celular';

  @override
  String get bfSettingsUnpairSubtitle =>
      'Remove o vínculo · o dispositivo precisará ser pareado de novo';

  @override
  String get bfSettingsUnpairConfirmTitle => 'Desparear este celular?';

  @override
  String get bfSettingsFactoryReset => 'Redefinição de fábrica';

  @override
  String get bfSettingsFactoryResetSubtitle =>
      'Apaga Wi-Fi, endpoints de API e pareamentos';

  @override
  String get bfSettingsFactoryResetConfirmTitle => 'Redefinição de fábrica?';

  @override
  String get bfSettingsFactoryResetConfirmBody =>
      'Todas as configurações serão apagadas. O dispositivo reiniciará.';

  @override
  String get bfWifiManagementTitle => 'Gerenciamento de Wi-Fi';

  @override
  String get bfWifiConnecting => 'Conectando…';

  @override
  String bfWifiConnectionRejected(String error) {
    return 'Conexão rejeitada: $error';
  }

  @override
  String bfWifiConfigure(String label) {
    return 'Configurar $label';
  }

  @override
  String get bfWifiPasswordLabel => 'Senha';

  @override
  String get bfNotebookTitle => 'Caderno do usuário';

  @override
  String get bfNotebookSaveCancel => 'Cancelar';

  @override
  String get bfApiChainCancel => 'Cancelar';

  @override
  String get bfApiChainRunChain => 'Executar cadeia';

  @override
  String get bfApiChainToggleAll => 'Ativar/desativar tudo';

  @override
  String get bfApiChainFieldName => 'Nome';

  @override
  String get bfApiChainFieldType => 'Tipo';

  @override
  String get bfApiChainFieldHeaderName => 'Nome do header';

  @override
  String get bfApiChainFieldNewToken =>
      'Novo token (deixe em branco para manter)';

  @override
  String get bfHomeLoadingConnecting => 'Conectando ao dispositivo…';

  @override
  String get bfHomeLoadingSecure => 'Abrindo canal seguro…';

  @override
  String get deviceConnUnreachableTitle =>
      'Não foi possível acessar o dispositivo';

  @override
  String get deviceConnUnreachableBody =>
      'O dispositivo pode estar desligado, fora de alcance ou em repouso. Verifique se está ligado e por perto e tente de novo.';

  @override
  String get deviceConnRepairTitle => 'O pareamento precisa ser renovado';

  @override
  String get deviceConnRepairBody =>
      'O dispositivo parece ter sido redefinido e não reconhece mais este celular. Pareie com ele novamente para reconectar.';

  @override
  String get deviceConnRepairButton => 'Parear de novo';

  @override
  String get deviceConnTechnicalDetails => 'Detalhes técnicos';

  @override
  String get bfLogsTitle => 'Registros do dispositivo';

  @override
  String get bfEventsTitle => 'Histórico de eventos';

  @override
  String get pairingStepConnecting => 'Conectando';

  @override
  String get pairingStepConnectingSubtitle => 'Link BLE + descoberta GATT';

  @override
  String get pairingStepMutualAuth => 'Autenticação mútua';

  @override
  String get pairingStepDeviceInfo => 'Verificação de device.info';

  @override
  String get pairingStepDeviceInfoSubtitle =>
      'Canal criptografado ativo, ping de sanidade';

  @override
  String get pairingStepConnected => 'Conexão estabelecida';

  @override
  String get pairingStepConnectedSubtitle =>
      'CLI pronta, indo para a configuração';

  @override
  String get pairingStepKeyExchange => 'Troca de chaves';

  @override
  String get pairingStepKeyExchangeSubtitle => 'X25519, chave pública enviada';

  @override
  String get pairingStepVerifying => 'Verificando';

  @override
  String get pairingStepVerifyingSubtitle =>
      'Aguardando o dispositivo, derivando o token';

  @override
  String get pairingStepDone => 'Pareamento concluído';

  @override
  String get pairingStepDoneSubtitle =>
      'Vínculo armazenado no dispositivo e no celular';

  @override
  String get pairingLogTitle => 'Registro de pareamento';

  @override
  String get pairingLogCopied =>
      'Registro copiado para a área de transferência';

  @override
  String get discoveryPreparing => 'Preparando…';

  @override
  String get discoveryBluetoothOff => 'O Bluetooth está desligado';

  @override
  String get wifiPasswordTitle => 'Conectar dispositivo ao Wi-Fi';

  @override
  String get wifiPasswordSsidLabel => 'Nome da rede (SSID)';

  @override
  String get wifiPasswordNetworkLabel => 'Rede';

  @override
  String get wifiPasswordPasswordLabel => 'Senha';

  @override
  String get wifiPasswordConnect => 'Conectar';

  @override
  String get wifiPasswordLogTitle => 'Registro de conexão';

  @override
  String get wifiPasswordLogCopied =>
      'Registro copiado para a área de transferência';

  @override
  String get wifiScanTitle => 'Escolha uma rede Wi-Fi para o dispositivo';

  @override
  String get wifiScanRescanTooltip =>
      'Pedir ao dispositivo para buscar de novo';

  @override
  String get wifiScanRunning =>
      'O scanner de Wi-Fi do dispositivo está em execução…';

  @override
  String get wifiScanNoNetworks =>
      'O dispositivo não encontrou nenhuma Wi-Fi por perto.';

  @override
  String get wifiScanRescan => 'Pedir ao dispositivo para buscar de novo';

  @override
  String get wifiScanHiddenAdd => 'Adicionar rede oculta';

  @override
  String get wifiScanHiddenSubtitle => 'Digite o SSID manualmente';

  @override
  String get wifiScanLogTitle => 'Registro da busca de Wi-Fi';

  @override
  String get wifiSuccessReady => 'Pronto';

  @override
  String get bfEventsClearTooltip => 'Limpar';

  @override
  String get bfEventsEmpty =>
      'Nenhum evento ainda. Eles aparecerão aqui quando o dispositivo começar a publicar.';

  @override
  String get logsEmptyTooltip => 'O registro está vazio.';

  @override
  String logsErrorPrefix(String error) {
    return 'Erro: $error';
  }

  @override
  String get notebookSaved => 'Salvo';

  @override
  String notebookSaveError(String error) {
    return 'Erro: $error';
  }

  @override
  String notebookCapacityExceeded(int used, int capacity) {
    return 'Capacidade excedida: $used / $capacity bytes';
  }

  @override
  String get notebookClearTooltip => 'Limpar caderno';

  @override
  String get notebookClearConfirmTitle => 'Limpar o caderno inteiro?';

  @override
  String get notebookClearConfirmBody =>
      'Todos os dados do usuário no dispositivo serão apagados. Não pode ser desfeito.';

  @override
  String get notebookClearAction => 'Limpar';

  @override
  String get notebookClearedSnack => 'Caderno limpo';

  @override
  String notebookClearError(String error) {
    return 'Não foi possível limpar: $error';
  }

  @override
  String get notebookEncryptedHint =>
      'Área criptografada · só o SKAPP pareado pode lê-la';

  @override
  String get notebookEmptyTitle => 'O caderno está vazio';

  @override
  String get notebookEmptyBody =>
      'Digite notas, JSON, definições de cena ou qualquer outro texto abaixo. Tocar em Salvar armazena tudo criptografado no dispositivo.';

  @override
  String get notebookHint =>
      'Digite o que quiser aqui (notas, JSON, seu próprio schema). Até 100 KB armazenados no dispositivo.';

  @override
  String get notebookDirty => 'Alterações não salvas';

  @override
  String get notebookSaved2 => 'Salvo';

  @override
  String get notebookSyncedDifferent => 'Em sincronia';

  @override
  String get notebookSaveCta => 'Salvar';

  @override
  String wifiPairingHexErrorRaw(String error) {
    return 'falha na decodificação hex de our_pub: $error';
  }

  @override
  String get bfWifiForgetTitle => 'Esquecer slot?';

  @override
  String get bfWifiForgetBody =>
      'O slot será apagado. Se o dispositivo estiver conectado aqui no momento, ele recorrerá ao outro slot (se houver). É necessário reconfigurar para restaurar.';

  @override
  String get bfWifiForget => 'Esquecer';

  @override
  String get bfWifiHint =>
      'O dispositivo tenta as duas redes em ordem: primeiro a principal, a reserva se ela falhar. O slot ativo é marcado com um ponto verde.';

  @override
  String get bfWifiActive => 'ATIVO';

  @override
  String get bfWifiNotConfigured => 'Não configurado';

  @override
  String get bfWifiChange => 'Alterar';

  @override
  String get bfWifiSetUp => 'Configurar';

  @override
  String get discoveryStatusChecking => 'Verificação de status do Bluetooth.';

  @override
  String get discoveryPermissionsTitle => 'Permissão de Bluetooth necessária';

  @override
  String get discoveryPermissionsBody =>
      'Para encontrar dispositivos SmartKraft por perto, ative a permissão de Bluetooth.';

  @override
  String get discoveryPermissionsRetry => 'Solicitar permissões de novo';

  @override
  String get discoveryPermissionsOpenSettings => 'Abrir configurações';

  @override
  String get discoveryAdapterOffBody =>
      'Ligue o Bluetooth para buscar dispositivos.';

  @override
  String get discoveryAdapterOffEnable => 'Ligar o Bluetooth';

  @override
  String get discoveryUnsupportedTitle => 'BLE não suportado';

  @override
  String get discoveryUnsupportedBody =>
      'Este dispositivo não suporta Bluetooth Low Energy; o SKAPP precisa de BLE para funcionar.';

  @override
  String get wifiPasswordHelp =>
      'O dispositivo vai entrar nesta rede. Digite a senha com cuidado.';

  @override
  String get wifiPasswordRequired => 'A senha é obrigatória';

  @override
  String get wifiPasswordMinLength => 'Pelo menos 8 caracteres';

  @override
  String wifiPasswordSendError(String error) {
    return 'Não foi possível enviar: $error';
  }

  @override
  String get wifiScanTimeoutHint =>
      'Se a busca demorar muito, o dispositivo pode ter perdido o alcance do Wi-Fi. Toque em tentar de novo.';

  @override
  String get wifiScanFailedTitle => 'Falha na busca';

  @override
  String get wifiScanRetry => 'Tentar de novo';

  @override
  String get wifiSuccessTitle => 'Conectado';

  @override
  String get wifiSuccessBody =>
      'O dispositivo está no Wi-Fi agora. Voltando ao painel…';

  @override
  String get deviceNameSectionHeading =>
      'NOME DO DISPOSITIVO (SOMENTE NESTE APP)';

  @override
  String get deviceNameLabel => 'Nome personalizado';

  @override
  String get deviceNameHint => 'ex.: BF do escritório';

  @override
  String get deviceNameSubtitle =>
      'Mostrado nos cartões desta instalação do SKAPP. Não é enviado ao dispositivo.';

  @override
  String get deviceNameClear => 'Limpar';

  @override
  String get deviceNameSave => 'Salvar';

  @override
  String get deviceNameSaved => 'Salvo';

  @override
  String get deviceNameEmptyPlaceholder => '(sem nome personalizado)';

  @override
  String get settingsUsbConsoleTitle => 'Console CLI por USB';

  @override
  String get settingsUsbConsoleSubtitle =>
      'Envie comandos brutos a um dispositivo conectado por USB';

  @override
  String get usbConsoleAppBarTitle => 'Console USB';

  @override
  String get usbConsolePickPortTitle => 'Selecione uma porta';

  @override
  String get usbConsolePickPortHint =>
      'Conecte um dispositivo SmartKraft via USB e toque em atualizar';

  @override
  String get usbConsolePortRefreshTooltip => 'Atualizar portas';

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
    return 'Erro: $error';
  }

  @override
  String get usbConsoleReconnect => 'Reconectar';

  @override
  String get usbConsoleDisconnect => 'Desconectar';

  @override
  String get usbConsoleClear => 'Limpar console';

  @override
  String get usbConsoleInputHint => 'Digite um comando, ex.: device.info';

  @override
  String get usbConsoleSend => 'Enviar';

  @override
  String get usbConsoleEmptyHint =>
      'Digite um comando e pressione Enter, tente device.info';

  @override
  String get usbConsoleEntryEvent => 'evt';

  @override
  String get usbConsoleEntryError => 'erro';

  @override
  String get usbConsoleNotSupportedIos =>
      'O console USB não é suportado no iOS';

  @override
  String get passphraseFieldLabel => 'Frase secreta';

  @override
  String get passphraseVerifyButton => 'Verificar';

  @override
  String passphraseAttemptsLeft(int count) {
    return 'Tentativas restantes: $count';
  }

  @override
  String get passphraseLockoutTriggered =>
      'Tentativas erradas demais; o dispositivo se redefiniu de fábrica.';

  @override
  String get bondPeerUnnamed => '(sem nome)';

  @override
  String get pairingPassphraseDialogTitle => 'Frase secreta do dispositivo';

  @override
  String get pairingPassphraseDialogBody =>
      'Este dispositivo exige uma frase secreta para acesso ao conteúdo. Digite-a para concluir o pareamento.';

  @override
  String get pairingPassphraseCancelled =>
      'Frase secreta não inserida, pareamento cancelado.';

  @override
  String pairingPassphraseSendError(String error) {
    return 'Não foi possível enviar a frase secreta: $error';
  }

  @override
  String get pairingPassphraseTimeout =>
      'O dispositivo não respondeu (verificação da frase secreta, 8 s).';

  @override
  String get pairingWindowClosedRetry =>
      'Janela de pareamento fechada, pressione o botão rapidamente e tente de novo.';

  @override
  String pairingPassphraseFailed(String error) {
    return 'Não foi possível verificar a frase secreta: $error';
  }

  @override
  String get bondStoreFullHeader =>
      'Todos os 8 slots de vínculo estão cheios. Remova um par existente para parear um novo SKAPP:';

  @override
  String bondStoreFullPeerLine(Object slot, String name, String shortPid) {
    return '  • slot $slot, $name [#$shortPid]';
  }

  @override
  String get bondStoreFullFooter =>
      'De outro SKAPP pareado ou via USB, execute\n`bond.remove --slot N` e toque em Tentar de novo aqui.';

  @override
  String get passphraseGateDialogBody =>
      'Este dispositivo pede a frase secreta a cada conexão. Digite-a para acessar o conteúdo.';

  @override
  String get passphraseGateCancelled =>
      'Frase secreta não inserida; a verificação é necessária para acessar esta tela.';

  @override
  String passphraseGateVerifyError(String error) {
    return 'Erro de verificação: $error';
  }

  @override
  String passphraseGateCommError(String error) {
    return 'Erro de comunicação: $error';
  }

  @override
  String get passphraseGateUnknownError => 'Erro de bloqueio desconhecido.';

  @override
  String get bfPassphraseTitle => 'Frase secreta do dispositivo';

  @override
  String get bfPassphraseSetTitle => 'Definir frase secreta';

  @override
  String get bfPassphraseChangeTitle => 'Alterar frase secreta';

  @override
  String get bfPassphraseClearTitle => 'Remover frase secreta';

  @override
  String get bfPassphraseChangeSubtitle =>
      'Digite a frase secreta antiga e defina a nova';

  @override
  String get bfPassphraseClearSubtitle =>
      'Redefine o bloqueio de conteúdo no dispositivo';

  @override
  String get bfPassphraseModePairing => 'Perguntar durante o pareamento';

  @override
  String get bfPassphraseModePairingSubtitle =>
      'Pergunta quando um novo SKAPP pareia. Pares existentes não são solicitados.';

  @override
  String get bfPassphraseModeAlways => 'Perguntar a cada conexão';

  @override
  String get bfPassphraseModeAlwaysSubtitle =>
      'Pergunta toda vez que uma sessão abre. O conteúdo fica bloqueado mesmo que um SKAPP seja roubado.';

  @override
  String get bfPassphraseStatusNone =>
      'Sem frase secreta; o dispositivo não tem bloqueio de conteúdo';

  @override
  String get bfPassphraseStatusActiveOff =>
      'Frase secreta definida · imposição desligada (ambos os botões desligados)';

  @override
  String get bfPassphraseStatusActivePairing =>
      'Perguntada durante o pareamento';

  @override
  String get bfPassphraseStatusActiveAlways => 'Perguntada a cada conexão';

  @override
  String get bfPassphraseBadgeActive => 'Frase secreta ativa';

  @override
  String get bfPassphraseBadgeNone => 'Sem frase secreta';

  @override
  String bfPassphraseAttemptsRatio(int left, int total) {
    return 'Tentativas restantes: $left / $total';
  }

  @override
  String bfPassphraseLengthSubtitle(int min, int max) {
    return 'Comprimento de $min a $max caracteres';
  }

  @override
  String bfPassphraseLengthHint(int min, int max) {
    return 'Comprimento: $min-$max';
  }

  @override
  String bfPassphraseTooShort(int min) {
    return 'Pelo menos $min caracteres';
  }

  @override
  String bfPassphraseTooLong(int max) {
    return 'No máximo $max caracteres';
  }

  @override
  String get bfPassphraseEmpty => 'Não pode ficar vazia';

  @override
  String get bfPassphraseNewLabel => 'Nova frase secreta';

  @override
  String get bfPassphraseCurrentLabel => 'Frase secreta atual';

  @override
  String get bfPassphraseSetDone => 'Frase secreta definida';

  @override
  String get bfPassphraseChangeDone => 'Frase secreta alterada';

  @override
  String get bfPassphraseClearDone => 'Frase secreta removida';

  @override
  String bfPassphraseStatusReadError(String error) {
    return 'Não foi possível ler o status: $error';
  }

  @override
  String get bfPassphraseNotesTitle => 'Notas';

  @override
  String get bfPassphraseNotesBody =>
      '• A frase secreta é hasheada no dispositivo com PBKDF2-SHA256; nunca é armazenada em texto puro.\n• 10 tentativas erradas redefinem o dispositivo de fábrica; todos os vínculos e dados são apagados.\n• Um dispositivo conectado por USB pula a solicitação da frase secreta, pois o acesso físico já permite a redefinição de fábrica pelo botão.';

  @override
  String bfBondListTitle(int used, int capacity) {
    return 'SKAPPs pareados  ($used/$capacity)';
  }

  @override
  String get bfBondListEmpty => 'Nenhum par pareado ainda.';

  @override
  String get bfBondListBadgeThisPhone => 'Este celular';

  @override
  String get bfBondListBadgeActiveSession => 'Sessão ativa';

  @override
  String bfBondListRowSubtitle(String shortPid, String date) {
    return '#$shortPid · pareado: $date';
  }

  @override
  String get bfBondListRemoveTooltip => 'Remover este par';

  @override
  String get bfBondListRemoveTitle => 'Remover par?';

  @override
  String get bfBondListRemoveSelfBody =>
      'Você está removendo o vínculo deste celular. Se confirmar, a sessão cai; para acessar o dispositivo de novo, será preciso pressionar o botão rapidamente e parear novamente.';

  @override
  String bfBondListRemoveOtherBody(String label, int slot) {
    return '\"$label\" (slot $slot) é apagado do dispositivo. Aquele SKAPP precisa pressionar o botão rapidamente e parear de novo para reconectar.';
  }

  @override
  String bfBondListSlotRemoved(int slot) {
    return 'Slot $slot removido';
  }

  @override
  String bfBondListFetchError(String error) {
    return 'bond.list falhou: $error';
  }

  @override
  String get bfSettingsSectionSecurity => 'SEGURANÇA';

  @override
  String get bfSettingsPassphraseTitle => 'Frase secreta do dispositivo';

  @override
  String get bfSettingsBondListTitle => 'SKAPPs pareados';

  @override
  String get bfSettingsPassphraseSubtitleAlways => 'Ativa, a cada conexão';

  @override
  String get bfSettingsPassphraseSubtitlePairing => 'Ativa, no pareamento';

  @override
  String get bfSettingsPassphraseSubtitleOff => 'Ativa, imposição desligada';

  @override
  String bfSettingsBondsSubtitle(int count, int capacity) {
    return 'Pares pareados: $count / $capacity';
  }

  @override
  String get skapiHowItWorksTitle => 'Como funciona';

  @override
  String skapiHowItWorksBody(String deviceName) {
    return 'Quando o seu dispositivo SmartKraft (por exemplo, $deviceName) tem um evento, como um timer terminando, um botão pressionado ou um sensor acionado, ele envia um pequeno comando ao seu computador. Seu computador recebe esse comando e executa o script que você escolheu.';
  }

  @override
  String get skapiHowItWorksFlowDeviceLabel => 'Dispositivo SmartKraft';

  @override
  String get skapiHowItWorksFlowDeviceSub =>
      'ex.: Blocking Focus, dispara um evento';

  @override
  String get skapiHowItWorksFlowComputerLabel => 'Computador';

  @override
  String get skapiHowItWorksFlowComputerSub =>
      'O SKAPP recebe o comando, o script é executado';

  @override
  String get skapiHowItWorksFoot =>
      'O SKAPP precisa estar em execução no seu computador. Todo o tráfego permanece na rede Wi-Fi, nenhuma conexão com a internet é necessária e nenhum dado sai da sua casa.';

  @override
  String get skapiPlatformGroupsHeader => 'Categorias de ações';

  @override
  String skapiPlatformGroupsLoadError(String error) {
    return 'Falha ao carregar os grupos: $error';
  }

  @override
  String get skapiPlatformEmptyTitle => 'Nenhum script aqui ainda';

  @override
  String get skapiPlatformEmptyBody =>
      'Os scripts para esta plataforma ainda estão a caminho. Volte após a próxima atualização do SKAPP.';

  @override
  String skapiGroupScriptsLoadError(String error) {
    return 'Falha ao carregar os scripts: $error';
  }

  @override
  String skapiScriptDetailLoadError(String error) {
    return 'Não foi possível carregar este script: $error';
  }

  @override
  String get skapiBindScreenTitle => 'Vincular a uma ação';

  @override
  String get skapiBindScreenSubtitle =>
      'Execute este script automaticamente quando um evento do dispositivo disparar.';

  @override
  String get skapiBindFieldDeviceLabel => 'Dispositivo';

  @override
  String get skapiBindFieldDeviceHint =>
      'Escolha qual dispositivo pareado deve disparar este script.';

  @override
  String get skapiBindFieldDeviceEmpty =>
      'Nenhum dispositivo pareado ainda. Pareie um na aba Dispositivos primeiro.';

  @override
  String get skapiBindFieldEventLabel => 'Evento';

  @override
  String get skapiBindFieldEventHint =>
      'O dispositivo emite este evento; o script é executado quando isso acontece.';

  @override
  String get skapiBindEventTimerStarted => 'Timer iniciado';

  @override
  String get skapiBindEventTimerExpired => 'Timer expirado';

  @override
  String get skapiBindEventFaceChanged => 'Face do cubo alterada';

  @override
  String get skapiBindEventButtonPressed => 'Botão pressionado';

  @override
  String get skapiBindEventButtonHeld => 'Botão mantido pressionado';

  @override
  String get skapiBindEventBatteryLow => 'Bateria fraca';

  @override
  String get skapiBindEventBatteryLockout => 'Bloqueio por bateria';

  @override
  String get skapiBindEventPowerStateChanged => 'Estado de energia alterado';

  @override
  String get skapiBindEventPairingSuccess => 'Pareamento bem-sucedido';

  @override
  String get skapiBindEventApiSent => 'Chamada de API enviada';

  @override
  String get skapiBindParamsHeader => 'Substituições de parâmetros';

  @override
  String get skapiBindParamsHint =>
      'Deixe vazio para manter os padrões do script. Estes valores são enviados toda vez que o vínculo dispara.';

  @override
  String get skapiBindButtonSave => 'Salvar vínculo';

  @override
  String get skapiBindButtonDelete => 'Excluir vínculo';

  @override
  String get skapiBindButtonCancel => 'Cancelar';

  @override
  String get skapiBindButtonEnable => 'Ativar';

  @override
  String get skapiBindButtonDisable => 'Desativar';

  @override
  String get skapiBindStatusEnabled => 'Ativo';

  @override
  String get skapiBindStatusDisabled => 'Pausado';

  @override
  String get skapiBindSavedToast => 'Vínculo salvo';

  @override
  String get skapiBindDeletedToast => 'Vínculo removido';

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
      'Pareie um dispositivo primeiro para criar vínculos.';

  @override
  String skapiBindTriggeredDesktopToast(String script) {
    return 'Disparado: $script';
  }

  @override
  String skapiBindTriggeredMobileToast(String event) {
    return 'Vínculo disparado ($event); a execução chega na Fase K.';
  }

  @override
  String skapiBindLoadError(String error) {
    return 'Não foi possível carregar os vínculos: $error';
  }

  @override
  String get skapiBindListSectionTitle => 'Vínculos neste script';

  @override
  String get skapiBindListEmpty =>
      'Nenhum vínculo ainda. Toque em Vincular a uma ação para criar um.';

  @override
  String get skapiBindNewButton => 'Novo vínculo';

  @override
  String get skapiBasicSettingsTitle => 'Configurações';

  @override
  String get skapiBasicEmptyParams =>
      'Este script não precisa de configurações. Toque em Executar agora.';

  @override
  String get skapiBasicUnitSeconds => 'segundos';

  @override
  String get skapiBasicConvHalfMinute => 'meio minuto';

  @override
  String get skapiBasicConvLessThanMinute => 'menos de um minuto';

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
  String get skapiBasicConvImmediate => 'começa imediatamente';

  @override
  String skapiBasicConvAfter(String time) {
    return 'após $time';
  }

  @override
  String get skapiBasicPrerunSectionTitle => 'Atraso antes da execução';

  @override
  String get skapiBasicPrerunAddCta => 'Adicionar atraso antes de executar';

  @override
  String get skapiBasicPrerunLabel =>
      'Aguardar estes segundos antes de o script iniciar';

  @override
  String get skapiBasicPrerunHelp =>
      'Útil para deixar uma notificação aparecer primeiro, ou para encadear ações. O padrão 0 significa começar imediatamente.';

  @override
  String get skapiBasicPrerunRemove => 'Remover atraso';

  @override
  String get skapiBasicListAddPlaceholder => '+ adicionar';

  @override
  String get skapiRunSheetTitle => 'Executar script';

  @override
  String get skapiRunSheetStatusRunning => 'Em execução';

  @override
  String get skapiRunSheetStatusOk => 'Concluído';

  @override
  String get skapiRunSheetStatusError => 'Falhou';

  @override
  String skapiRunSheetExitCode(int code) {
    return 'Código de saída: $code';
  }

  @override
  String get skapiRunSheetCancel => 'Cancelar';

  @override
  String get skapiRunSheetClose => 'Fechar';

  @override
  String get skapiRunSheetCopyOutput => 'Copiar saída';

  @override
  String get skapiRunSheetCopiedDone => 'Copiado';

  @override
  String get skapiRunSheetEmptyOutput => 'Aguardando a saída...';

  @override
  String get skapiRunSheetDismissConfirmTitle => 'Parar a execução do script?';

  @override
  String get skapiRunSheetDismissConfirmBody =>
      'O script ainda está em execução. Fechar esta folha vai cancelá-lo.';

  @override
  String get skapiRunSheetDismissConfirmStay => 'Manter em execução';

  @override
  String get skapiRunSheetDismissConfirmStop => 'Cancelar';

  @override
  String get skapiRunErrorPowerShellMissing =>
      'O PowerShell não foi encontrado neste sistema.';

  @override
  String skapiRunErrorTempWrite(String error) {
    return 'Não foi possível gravar o script na pasta temporária: $error';
  }

  @override
  String skapiRunErrorSpawn(String error) {
    return 'Não foi possível iniciar o PowerShell: $error';
  }

  @override
  String skapiRunDurationMs(int ms) {
    return 'Levou $ms ms';
  }

  @override
  String get skapiCopiedToClipboard => 'Copiado';

  @override
  String get skapiFavouriteAddTooltip => 'Adicionar aos favoritos';

  @override
  String get skapiFavouriteRemoveTooltip => 'Remover dos favoritos';

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
  String get skapiPlatformScreenCategoriesTitle => 'Categorias de ações';

  @override
  String skapiPlatformScreenCategoriesSub(int groups, int scripts) {
    return '$groups grupos · $scripts scripts no total';
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
  String get skapiGroupPowerTitle => 'Gerenciamento de energia';

  @override
  String get skapiGroupPowerDesc =>
      'Os scripts deste grupo bloqueiam, suspendem, hibernam ou desligam o computador. São úteis quando um dispositivo SmartKraft sinaliza o fim de uma sessão de foco ou detecta inatividade prolongada e você quer que a máquina acompanhe.';

  @override
  String get skapiGroupPowerFoot =>
      'Uso típico: bloquear ao se levantar, hibernar no fim do dia, desligamento agendado após um longo período ocioso.';

  @override
  String get skapiScriptLockTitle => 'Bloquear estação de trabalho';

  @override
  String get skapiScriptLockSummaryWhat =>
      'Bloqueia o Windows imediatamente e volta à tela de login. Os apps abertos continuam em execução.';

  @override
  String get skapiScriptLockSummaryHow =>
      'Chama a função Win32 LockWorkStation da user32. Equivale a pressionar Win+L.';

  @override
  String get skapiScriptHibernateTitle => 'Hibernar';

  @override
  String get skapiScriptHibernateSummaryWhat =>
      'Salva a sessão atual em disco e desliga a máquina. Ao retomar, você volta de onde parou, mesmo sem bateria.';

  @override
  String get skapiScriptHibernateSummaryHow =>
      'Executa o shutdown.exe embutido com a flag /h. A hibernação precisa estar ativada nas configurações de energia do Windows; se não estiver, o Windows recorre à suspensão.';

  @override
  String get skapiScriptHibernateNote =>
      'Execute powercfg /hibernate on uma vez em um shell de administrador se a hibernação estiver ausente no seu sistema.';

  @override
  String get skapiScriptHibernateParamDelayLabel => 'atraso';

  @override
  String get skapiScriptHibernateParamDelayHint =>
      'Segundos a esperar antes de hibernar, caso a notificação do dispositivo deva aparecer primeiro.';

  @override
  String get skapiScriptSleepTitle => 'Suspender';

  @override
  String get skapiScriptSleepSummaryWhat =>
      'Suspende a máquina para a RAM (S3). Retomar é rápido, mas consome um pouco de bateria enquanto suspensa.';

  @override
  String get skapiScriptSleepSummaryHow =>
      'Chama System.Windows.Forms.Application.SetSuspendState com PowerState.Suspend. O sistema pode atrasar se um processo em primeiro plano estiver bloqueando as transições de ociosidade.';

  @override
  String get skapiScriptSleepParamDelayLabel => 'atraso';

  @override
  String get skapiScriptSleepParamDelayHint =>
      'Segundos a esperar antes de suspender.';

  @override
  String get skapiScriptShutdownTitle => 'Desligar';

  @override
  String get skapiScriptShutdownSummaryWhat =>
      'Inicia um desligamento gracioso do Windows. Os apps abertos são solicitados a salvar e fechar.';

  @override
  String get skapiScriptShutdownSummaryHow =>
      'Executa o shutdown.exe /s embutido. Com a força ativada, /f é adicionado para que apps que não respondem sejam encerrados.';

  @override
  String get skapiScriptShutdownNote =>
      'Um atraso diferente de zero dá tempo ao usuário de cancelar com shutdown /a em um terminal.';

  @override
  String get skapiScriptShutdownParamDelayLabel => 'atraso';

  @override
  String get skapiScriptShutdownParamDelayHint =>
      'Segundos que o Windows espera antes de desligar. 30 é o padrão; escolha 0 para desligamento imediato.';

  @override
  String get skapiScriptShutdownParamForceLabel => 'força';

  @override
  String get skapiScriptShutdownParamForceHint =>
      'Fecha apps que não respondem ao sinal de desligamento. Trabalho não salvo nesses apps pode ser perdido.';

  @override
  String get skapiGroupDisplayAudioTitle => 'Tela, imagem e som';

  @override
  String get skapiGroupDisplayAudioDesc =>
      'Os scripts deste grupo ajustam a tela e a saída de áudio: brilho, volume, mudo e reprodução de mídia. São úteis quando um dispositivo SmartKraft quer que o computador escureça durante uma pausa de foco ou pause a música quando você se levanta.';

  @override
  String get skapiGroupDisplayAudioFoot =>
      'Uso típico: escurecer a tela durante uma pausa, mutar ao bloquear, pausar o Spotify quando um dispositivo detecta inatividade.';

  @override
  String get skapiScriptBrightnessTitle => 'Definir brilho';

  @override
  String get skapiScriptBrightnessSummaryWhat =>
      'Define o brilho da tela interna para um percentual entre 0 e 100.';

  @override
  String get skapiScriptBrightnessSummaryHow =>
      'Chama o WMI WmiMonitorBrightnessMethods.WmiSetBrightness com o nível solicitado. Apenas notebooks, tablets e painéis embutidos respondem; monitores externos DDC/CI não são suportados por este caminho.';

  @override
  String get skapiScriptBrightnessNote =>
      'Monitores externos não mudam. Em configurações com vários monitores, só o painel que reporta o brilho via WMI reage.';

  @override
  String get skapiScriptBrightnessParamLevelLabel => 'nível';

  @override
  String get skapiScriptBrightnessParamLevelHint =>
      'Percentual de brilho (0-100). Valores menores são mais escuros. 70 é um padrão confortável em iluminação normal.';

  @override
  String get skapiScriptBrightnessParamTimeoutLabel => 'tempo limite';

  @override
  String get skapiScriptBrightnessParamTimeoutHint =>
      'Segundos que a mudança de brilho pode levar. O sistema faz a transição suave dentro desta janela.';

  @override
  String get skapiScriptMuteToggleTitle => 'Alternar mudo';

  @override
  String get skapiScriptMuteToggleSummaryWhat =>
      'Alterna o mudo geral do sistema. A mídia ativa continua tocando, mas você não a ouve.';

  @override
  String get skapiScriptMuteToggleSummaryHow =>
      'Envia a tecla virtual VK_VOLUME_MUTE, o mesmo caminho que o Windows usa quando o usuário pressiona a tecla de mudo no teclado. Sem dependência de administrador ou COM.';

  @override
  String get skapiScriptMuteToggleParamModeLabel => 'modo';

  @override
  String get skapiScriptMuteToggleParamModeHint =>
      'toggle / on / off. Apenas toggle é imposto pelo simples atalho de teclado; on e off são aceitos para compatibilidade futura.';

  @override
  String get skapiScriptVolumeSetTitle => 'Definir volume';

  @override
  String get skapiScriptVolumeSetSummaryWhat =>
      'Define o volume geral do sistema em um nível preciso entre 0 e 100.';

  @override
  String get skapiScriptVolumeSetSummaryHow =>
      'Chama o Core Audio IAudioEndpointVolume.SetMasterVolumeLevelScalar via interop COM em C# embutido. Mira o endpoint de saída padrão.';

  @override
  String get skapiScriptVolumeSetNote =>
      'Nível 2: funciona em desktops Windows 10/11 padrão. Instalações enxutas podem não expor a interface COM; endpoints por app não são tratados por este caminho.';

  @override
  String get skapiScriptVolumeSetParamLevelLabel => 'nível';

  @override
  String get skapiScriptVolumeSetParamLevelHint =>
      'Percentual de volume (0-100). 0 silencia sem ativar o mudo; 50 é um padrão confortável.';

  @override
  String get skapiScriptMediaKeyTitle => 'Tecla de mídia';

  @override
  String get skapiScriptMediaKeySummaryWhat =>
      'Simula o toque de uma tecla de mídia: tocar/pausar, próxima, anterior ou parar. Vai para o app que controla a sessão de mídia no momento.';

  @override
  String get skapiScriptMediaKeySummaryHow =>
      'Envia VK_MEDIA_PLAY_PAUSE / VK_MEDIA_NEXT_TRACK / VK_MEDIA_PREV_TRACK / VK_MEDIA_STOP via keybd_event. O Windows roteia o toque pelos System Media Transport Controls.';

  @override
  String get skapiScriptMediaKeyNote =>
      'Nível 2: precisa de uma sessão de mídia ativa. Se nenhum app estiver tocando ou o app em primeiro plano não se registrar no SMTC, o toque é descartado silenciosamente.';

  @override
  String get skapiScriptMediaKeyParamKeyLabel => 'tecla';

  @override
  String get skapiScriptMediaKeyParamKeyHint =>
      'play-pause / next / previous / stop. O padrão é play-pause.';

  @override
  String get skapiGroupWindowAppTitle => 'Janela e aplicativo';

  @override
  String get skapiGroupWindowAppDesc =>
      'Os scripts deste grupo controlam janelas e aplicativos: minimizar, focar, fechar graciosamente ou encerrar processos de imediato. Mantêm seu espaço de trabalho organizado quando um dispositivo SmartKraft quer que o computador mude de contexto.';

  @override
  String get skapiGroupWindowAppFoot =>
      'Uso típico: minimizar tudo quando uma sessão de foco começa, fechar o navegador quando o trabalho acaba, encerrar um app travado sob demanda.';

  @override
  String get skapiScriptMinimizeWindowTitle => 'Minimizar janela';

  @override
  String get skapiScriptMinimizeWindowSummaryWhat =>
      'Minimiza uma janela específica pelo nome do processo. Um nome de processo vazio mira a janela em foco no momento.';

  @override
  String get skapiScriptMinimizeWindowSummaryHow =>
      'Resolve a primeira janela principal correspondente via Get-Process e chama a user32 ShowWindow com SW_MINIMIZE.';

  @override
  String get skapiScriptMinimizeWindowNote =>
      'Se houver várias instâncias em execução, só a primeira janela correspondente é minimizada. Use o nome do processo sem o sufixo .exe.';

  @override
  String get skapiScriptMinimizeWindowParamProcessLabel => 'processName';

  @override
  String get skapiScriptMinimizeWindowParamProcessHint =>
      'Nome do processo sem .exe (chrome, code, winword). Vazio mira a janela em primeiro plano.';

  @override
  String get skapiScriptCloseWindowTitle => 'Fechar janela';

  @override
  String get skapiScriptCloseWindowSummaryWhat =>
      'Envia um fechamento gracioso a uma janela para que o app possa mostrar seu próprio diálogo de \"salvar alterações?\".';

  @override
  String get skapiScriptCloseWindowSummaryHow =>
      'Envia WM_CLOSE via user32 SendMessage. Mesmo efeito de o usuário clicar no botão X. Um nome de processo vazio mira a janela em primeiro plano.';

  @override
  String get skapiScriptCloseWindowNote =>
      'Apps com trabalho não salvo abrem seu próprio diálogo. O script não espera nem encerra apps travados.';

  @override
  String get skapiScriptCloseWindowParamProcessLabel => 'processName';

  @override
  String get skapiScriptCloseWindowParamProcessHint =>
      'Nome do processo sem .exe. Vazio mira a janela em primeiro plano.';

  @override
  String get skapiScriptKillAppTitle => 'Forçar saída do app';

  @override
  String get skapiScriptKillAppSummaryWhat =>
      'Encerra todas as instâncias de um processo. Tenta WM_CLOSE primeiro, depois TerminateProcess se o app ainda estiver ativo após o tempo limite.';

  @override
  String get skapiScriptKillAppSummaryHow =>
      'Envia WM_CLOSE a cada janela principal, espera o tempo limite configurado e então executa Stop-Process com -Force em tudo que ainda estiver rodando.';

  @override
  String get skapiScriptKillAppNote =>
      'Trabalho não salvo em apps que não respondem será perdido ao forçar o encerramento. Use preKillSave para apps tipo editor que respondem a Ctrl+S.';

  @override
  String get skapiScriptKillAppParamProcessLabel => 'processName';

  @override
  String get skapiScriptKillAppParamProcessHint =>
      'Nome do processo sem .exe. Todas as instâncias em execução são encerradas.';

  @override
  String get skapiScriptKillAppParamTimeoutLabel => 'tempo limite';

  @override
  String get skapiScriptKillAppParamTimeoutHint =>
      'Segundos a esperar entre o WM_CLOSE e o encerramento forçado. Valores maiores dão mais tempo ao app para salvar.';

  @override
  String get skapiScriptKillAppParamPreKillSaveLabel => 'preKillSave';

  @override
  String get skapiScriptKillAppParamPreKillSaveHint =>
      'Envia Ctrl+S à janela em primeiro plano antes de fechar. Útil para editores, mas não tem efeito em apps que ignoram Ctrl+S.';

  @override
  String get skapiScriptLaunchAppTitle => 'Iniciar app';

  @override
  String get skapiScriptLaunchAppSummaryWhat =>
      'Inicia um executável, abre uma URL ou abre um documento com o manipulador padrão.';

  @override
  String get skapiScriptLaunchAppSummaryHow =>
      'Chama o PowerShell Start-Process com o caminho e uma lista de argumentos opcional. O caminho pode ser um .exe, um caminho de arquivo completo ou uma URL.';

  @override
  String get skapiScriptLaunchAppNote =>
      'Caminhos com espaços são aceitos. Use uma URL como https://example.com para abrir o navegador padrão.';

  @override
  String get skapiScriptLaunchAppParamPathLabel => 'caminho';

  @override
  String get skapiScriptLaunchAppParamPathHint =>
      'Executável, caminho de arquivo completo ou URL. notepad / C:\\\\tools\\\\my.exe / https://example.com.';

  @override
  String get skapiScriptLaunchAppParamArgsLabel => 'args';

  @override
  String get skapiScriptLaunchAppParamArgsHint =>
      'Argumentos passados ao executável. Vazio para nenhum.';

  @override
  String get skappListenerCardTitle => 'Ouvinte HTTP do SKAPP';

  @override
  String skappListenerCardSubtitleRunning(int port) {
    return 'Em execução na porta $port';
  }

  @override
  String get skappListenerCardSubtitleStopped => 'Parado';

  @override
  String get skappListenerCardSubtitleUnsupported =>
      'Esta plataforma não pode hospedar o ouvinte.';

  @override
  String get skappListenerCardEnableSwitch => 'Ativar ouvinte';

  @override
  String get skappListenerCardSecurityNote =>
      'O ouvinte aceita conexões apenas na sua rede local e exige o token Bearer. HTTP simples, não o exponha à internet pública.';

  @override
  String get settingsLanVisibleTitle => 'Visível na LAN';

  @override
  String get settingsLanVisibleSubtitle =>
      'Quando desligado, o ouvinte só se vincula ao localhost. Os dispositivos BF pareados não conseguem acessar este desktop.';

  @override
  String get settingsLanVisibleWarnBfBreaks =>
      'Desligar isto quebra a cadeia de webhook do BF. Use apenas em ambiente confiável ou de teste.';

  @override
  String get settingsLanVisibleAutoReopenedSnack =>
      'A visibilidade na LAN foi reativada para que os dispositivos BF possam acessar este desktop.';

  @override
  String get skapiRunRemoteDeveloperModeDisabled =>
      'O desktop de destino está com o modo desenvolvedor desativado, então a execução remota de scripts está desligada lá.';

  @override
  String get skappPeerPairingManualUuidConfirmLabel =>
      'Código de confirmação (4 últimos do UUID)';

  @override
  String get skappPeerPairingManualUuidConfirmHint =>
      'Leia o código de 4 caracteres mostrado na tela de pareamento do desktop.';

  @override
  String get skappPeerPairingManualUuidConfirmError =>
      'O código não corresponde aos 4 últimos do UUID. Verifique a tela do desktop.';

  @override
  String get skappListenerCardUuidLast4Label =>
      'Código de confirmação de pareamento';

  @override
  String get skappListenerCardUuidLast4Hint =>
      'Digite estes 4 caracteres na tela de pareamento manual do celular.';

  @override
  String get settingsPeerTokensTitle => 'Tokens de par emitidos';

  @override
  String get settingsPeerTokensSubtitle =>
      'Pares móveis pareados com este desktop. Revogue qualquer entrada para desconectá-la sem afetar as demais.';

  @override
  String get settingsPeerTokensEmpty => 'Nenhum par pareado ainda.';

  @override
  String settingsPeerTokensIssuedAt(String when) {
    return 'Pareado $when';
  }

  @override
  String settingsPeerTokensLastUsed(String when) {
    return 'Usado pela última vez $when';
  }

  @override
  String get settingsPeerTokensRevokeButton => 'Revogar';

  @override
  String get settingsPeerTokensRevokeConfirmTitle => 'Revogar este par?';

  @override
  String get settingsPeerTokensRevokeConfirmBody =>
      'O par será desconectado imediatamente e terá que parear de novo para acessar este desktop.';

  @override
  String get settingsPeerTokensRevokeConfirmCancel => 'Cancelar';

  @override
  String get settingsPeerTokensRevokeConfirmAction => 'Revogar';

  @override
  String settingsPeerTokensRevokedToast(String name) {
    return 'Par $name revogado';
  }

  @override
  String get skappListenerCardRotateCertButton => 'Rotacionar certificado TLS';

  @override
  String get skappListenerCardRotateCertConfirmTitle =>
      'Rotacionar certificado?';

  @override
  String get skappListenerCardRotateCertConfirmBody =>
      'Um novo certificado TLS autoassinado será gerado. Todo par previamente pareado falhará no handshake até parear novamente.';

  @override
  String get skappListenerCardRotateCertConfirmCancel => 'Cancelar';

  @override
  String get skappListenerCardRotateCertConfirmAction => 'Rotacionar';

  @override
  String get skappListenerCardRotateCertDoneSnack =>
      'Certificado TLS rotacionado. Pareie todos os dispositivos novamente.';

  @override
  String get skappListenerCardCertFingerprintLabel => 'Impressão digital TLS';

  @override
  String skappListenerCardErrorPortInUse(int port) {
    return 'A porta $port já está em uso. Escolha uma porta diferente na Identidade de rede.';
  }

  @override
  String skappListenerCardErrorGeneric(String error) {
    return 'Não foi possível iniciar o ouvinte: $error';
  }

  @override
  String get skappPeerPairingTitle => 'Parear SKAPP Desktop';

  @override
  String get skappPeerPairingSubtitle =>
      'Escaneie o QR mostrado nas Configurações do SKAPP Desktop, ou cole o código de pareamento manualmente.';

  @override
  String get skappPeerPairingTabScan => 'Escanear QR';

  @override
  String get skappPeerPairingTabManual => 'Manual';

  @override
  String get skappPeerPairingScanHint =>
      'Aponte a câmera para o QR mostrado em SKAPP Desktop > Configurações > Ouvinte HTTP do SKAPP.';

  @override
  String get skappPeerPairingScanCameraDeniedTitle =>
      'Permissão de câmera necessária';

  @override
  String get skappPeerPairingScanCameraDeniedBody =>
      'Permita o acesso à câmera nas configurações do celular para escanear o QR de pareamento. Você também pode digitar o código manualmente.';

  @override
  String get skappPeerPairingManualHostLabel => 'IP ou hostname do desktop';

  @override
  String get skappPeerPairingManualPortLabel => 'Porta';

  @override
  String get skappPeerPairingManualTokenLabel => 'Token Bearer';

  @override
  String get skappPeerPairingManualUuidLabel => 'UUID do desktop';

  @override
  String get skappPeerPairingManualNameLabel => 'Nome de exibição';

  @override
  String get skappPeerPairingManualSubmit => 'Parear';

  @override
  String skappPeerPairingSavedToast(String name) {
    return 'Pareado com $name';
  }

  @override
  String skappPeerPairingFailedToast(String reason) {
    return 'Falha no pareamento: $reason';
  }

  @override
  String get skappPeerPairingShowQrTitle =>
      'Pareie um celular com este desktop';

  @override
  String get skappPeerPairingShowQrBody =>
      'Abra o SKAPP no seu celular, vá em SKAPI > Configurações > Parear Desktop e escaneie este QR. O QR contém o token Bearer; trate-o como uma senha.';

  @override
  String get skappPeerPairingShowQrCloseButton => 'Concluído';

  @override
  String get skappPeerListEmpty =>
      'Nenhum desktop pareado ainda. Pareie um para executar scripts deste celular.';

  @override
  String get skappPeerListSectionTitle => 'SKAPPs Desktop pareados';

  @override
  String get skappPeerStatusOnline => 'Online';

  @override
  String get skappPeerStatusOffline => 'Offline';

  @override
  String skappPeerStatusLastSeen(String when) {
    return 'Visto pela última vez $when';
  }

  @override
  String get skappPeerRemoveTooltip => 'Remover desktop pareado';

  @override
  String get skappPeerRemoveConfirmTitle => 'Remover pareamento?';

  @override
  String skappPeerRemoveConfirmBody(String name) {
    return 'Os scripts disparados deste celular não serão mais executados em $name até você parear de novo.';
  }

  @override
  String get skappPeerScanRefreshTooltip => 'Atualizar lista de pares';

  @override
  String skapiRunRemoteSheetTitle(String peerName) {
    return 'Executar remotamente em $peerName';
  }

  @override
  String get skapiRunRemoteConnecting => 'Conectando ao desktop...';

  @override
  String get skapiRunRemoteOfflineError =>
      'O desktop pareado está offline. Tente atualizar os pares ou verifique o ouvinte do desktop.';

  @override
  String get skapiRunRemoteUnauthorizedError =>
      'Token Bearer rejeitado. O token do desktop pode ter sido rotacionado. Pareie de novo nas Configurações.';

  @override
  String skapiRunRemoteHttpError(String reason) {
    return 'Falha na execução remota: $reason';
  }

  @override
  String get skapiRunMobileNoPeerTitle => 'Nenhum desktop pareado';

  @override
  String get skapiRunMobileNoPeerBody =>
      'Pareie um SKAPP Desktop nas Configurações para executar scripts deste celular.';

  @override
  String get skapiRunMobileNoPeerCta => 'Abrir Configurações';

  @override
  String get skapiRunRemoteNotWhitelisted =>
      'Este script não está marcado como executável remotamente. Execute-o diretamente no desktop.';

  @override
  String get skapiRunRemoteNoPeerHint =>
      'Pareie um SKAPP Desktop nas Configurações para executar scripts deste celular.';

  @override
  String get skapiRunRemoteNoPeerAction => 'Abrir configurações';

  @override
  String get skappPeerPickerTitle => 'Enviar para qual computador?';

  @override
  String get skappPeerPickerSubtitle =>
      'Escolha o SKAPP Desktop pareado que deve executar este script.';

  @override
  String get skappPeerPickerOfflineReason => 'Offline';

  @override
  String get skappPeerPickerDevModeOffReason =>
      'O modo desenvolvedor está desligado';

  @override
  String get skappPeerPickerEmpty => 'Nenhum desktop pareado para escolher.';

  @override
  String get skapiRunRemoteCancelButton => 'Cancelar';

  @override
  String get skapiRunRemoteCancelledNote => 'Execução cancelada';

  @override
  String skapiRunRemoteTooManyRuns(int running, int limit) {
    return 'Aquele desktop já tem $running scripts em execução ($limit no máximo). Espere um terminar.';
  }

  @override
  String get skappPeerHealthDevModeBadge => 'Modo dev';

  @override
  String get remoteRunActivityCardTitle => 'Execuções remotas';

  @override
  String get remoteRunActivityCardSubtitle =>
      'Execuções recentes de scripts que pares móveis pareados pediram a este desktop para realizar.';

  @override
  String get remoteRunActivityCardEmpty => 'Nenhuma execução remota ainda.';

  @override
  String get remoteRunActivityCardClear => 'Limpar histórico';

  @override
  String remoteRunActivityRowOk(int exitCode, int durationMs) {
    return 'saída $exitCode · $durationMs ms';
  }

  @override
  String get remoteRunActivityRowCancelled => 'cancelada';

  @override
  String remoteRunActivityRowRejected(String reason) {
    return 'rejeitada · $reason';
  }

  @override
  String get mobileTriggerCardTitle => 'Disparar';

  @override
  String get mobileTriggerCardSubtitle =>
      'Envia um evento de toque a um SKAPP Desktop pareado. Qualquer vínculo escutando este evento disparará seu script naquele desktop.';

  @override
  String get mobileTriggerCardSendButton => 'Enviar toque';

  @override
  String get mobileTriggerCardSending => 'Enviando...';

  @override
  String mobileTriggerSentToast(String name) {
    return 'Toque enviado para $name';
  }

  @override
  String get skapiBindEventMobileTap => 'Toque móvel';

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
  String get msHomeScreenTitle => 'Par móvel';

  @override
  String get msHomeScreenNotFound => 'Este par móvel não está mais pareado.';

  @override
  String get msHomeScreenEventsHeader => 'Eventos disponíveis';

  @override
  String msHomeScreenBindingsHeader(int count) {
    return 'Vínculos ($count)';
  }

  @override
  String get msHomeScreenBindingsEmpty =>
      'Nenhum vínculo ainda. Use SKAPI → script → Vincular a uma ação para ligar um evento de toque a um script.';

  @override
  String get msHomeScreenHint =>
      'Celulares não executam scripts. Eles emitem eventos de gatilho que este desktop vincula a scripts.';

  @override
  String msHomeScreenPairedAt(String date) {
    return 'Pareado $date';
  }

  @override
  String get skapiGroupNotifyTitle => 'Notificar e diálogo';

  @override
  String get skapiGroupNotifyDesc =>
      'Os scripts deste grupo falam diretamente com o usuário: exibir um toast, mostrar um diálogo modal ou esperar uma resposta de sim/não. Use-os quando o evento de um dispositivo SmartKraft precisa que a pessoa diante da tela confirme ou decida.';

  @override
  String get skapiGroupNotifyFoot =>
      'Uso típico: diálogo antes de uma ação destrutiva, toast em um lembrete leve, diálogo com tempo limite para seguir automaticamente.';

  @override
  String get skapiScriptDialogTitle => 'Mostrar diálogo';

  @override
  String get skapiScriptDialogSummaryWhat =>
      'Mostra um MessageBox modal do Windows e retorna a escolha do usuário (ok / cancel / yes / no / timeout).';

  @override
  String get skapiScriptDialogSummaryHow =>
      'Chama System.Windows.Forms.MessageBox em um runspace filho para que o script possa fazer o diálogo competir com um tempo limite opcional. O valor escolhido é escrito no stdout para o chamador decidir o fluxo.';

  @override
  String get skapiScriptDialogNote =>
      'O stdout é a resposta do usuário em minúsculas. timeout=0 espera indefinidamente.';

  @override
  String get skapiScriptDialogParamTitleLabel => 'title';

  @override
  String get skapiScriptDialogParamTitleHint =>
      'Título da janela mostrado na caixa de mensagem.';

  @override
  String get skapiScriptDialogParamBodyLabel => 'body';

  @override
  String get skapiScriptDialogParamBodyHint =>
      'A pergunta ou mensagem mostrada ao usuário.';

  @override
  String get skapiScriptDialogParamButtonsLabel => 'buttons';

  @override
  String get skapiScriptDialogParamButtonsHint =>
      'ok / ok_cancel / yes_no / yes_no_cancel. Padrão ok_cancel.';

  @override
  String get skapiScriptDialogParamTimeoutLabel => 'timeout';

  @override
  String get skapiScriptDialogParamTimeoutHint =>
      'Segundos a esperar antes de seguir com \'timeout\'. 0 significa esperar para sempre.';

  @override
  String get skapiScriptToastTitle => 'Mostrar toast';

  @override
  String get skapiScriptToastSummaryWhat =>
      'Mostra uma notificação toast do Windows com um título e um corpo. Surge no canto inferior direito e aparece na Central de Ações.';

  @override
  String get skapiScriptToastSummaryHow =>
      'Monta um payload XML de ToastNotification e o entrega ao WinRT ToastNotificationManager sob o AppUserModelID configurado.';

  @override
  String get skapiScriptToastNote =>
      'Nível 2: requer Windows 10+ e um AppUserModelID registrado para a melhor experiência. O AUMID padrão coloca o toast sob o PowerShell na Central de Ações.';

  @override
  String get skapiScriptToastParamTitleLabel => 'title';

  @override
  String get skapiScriptToastParamTitleHint =>
      'Primeira linha em negrito do toast.';

  @override
  String get skapiScriptToastParamBodyLabel => 'body';

  @override
  String get skapiScriptToastParamBodyHint => 'Segunda linha, menor. Opcional.';

  @override
  String get skapiScriptToastParamAumidLabel => 'aumid';

  @override
  String get skapiScriptToastParamAumidHint =>
      'App User Model ID sob o qual o toast aparece. O padrão recorre ao PowerShell.';

  @override
  String get skapiGroupVisualBreakTitle => 'Pausa visual';

  @override
  String get skapiGroupVisualBreakDesc =>
      'Pistas visuais suaves que afastam o usuário do trabalho intenso: escurecer a tela, mudar para tons de cinza, encontrar o cursor ou mostrar a área de trabalho. Os efeitos deste grupo são reversíveis e nunca bloqueiam a entrada de forma rígida.';

  @override
  String get skapiGroupVisualBreakFoot =>
      'Uso típico: escurecer a tela no início de uma pausa de foco, modo tons de cinza para leituras noturnas, encontrar o mouse em configurações com vários monitores.';

  @override
  String get skapiScriptShowDesktopTitle => 'Mostrar área de trabalho';

  @override
  String get skapiScriptShowDesktopSummaryWhat =>
      'Alterna \'mostrar área de trabalho\'. Igual a pressionar Win+D duas vezes seguidas.';

  @override
  String get skapiScriptShowDesktopSummaryHow =>
      'Chama Shell.Application.ToggleDesktop via COM. Executá-lo de novo restaura a disposição anterior das janelas.';

  @override
  String get skapiScriptFadeScreenTitle => 'Esmaecer tela';

  @override
  String get skapiScriptFadeScreenSummaryWhat =>
      'Esmaece o brilho da tela interna do nível atual até um nível de destino ao longo de alguns segundos.';

  @override
  String get skapiScriptFadeScreenSummaryHow =>
      'Lê o brilho atual via WMI WmiMonitorBrightness, depois aplica WmiSetBrightness em incrementos lineares em direção ao destino para que a mudança pareça suave.';

  @override
  String get skapiScriptFadeScreenNote =>
      'Nível 2: o brilho via WMI só funciona em painéis internos. Monitores externos não respondem por este caminho.';

  @override
  String get skapiScriptFadeScreenParamTargetLabel => 'target';

  @override
  String get skapiScriptFadeScreenParamTargetHint =>
      'Percentual de brilho final (0-100).';

  @override
  String get skapiScriptFadeScreenParamDurationLabel => 'duration';

  @override
  String get skapiScriptFadeScreenParamDurationHint =>
      'Segundos que o esmaecimento deve levar. O script usa dez passos de brilho por segundo.';

  @override
  String get skapiScriptGrayscaleTitle => 'Filtro de tons de cinza';

  @override
  String get skapiScriptGrayscaleSummaryWhat =>
      'Liga ou desliga o modo tons de cinza dos Filtros de Cor do Windows.';

  @override
  String get skapiScriptGrayscaleSummaryHow =>
      'Escreve as chaves de registro ColorFiltering, depois envia Win+Ctrl+C para que o Windows aplique a mudança ao vivo sem precisar sair da sessão.';

  @override
  String get skapiScriptGrayscaleNote =>
      'Nível 2: requer que Configurações > Acessibilidade > Filtros de cor > \'Permitir a tecla de atalho\' esteja ativo para que o alternar ao vivo funcione.';

  @override
  String get skapiScriptGrayscaleParamOnLabel => 'on';

  @override
  String get skapiScriptGrayscaleParamOnHint =>
      'true para ativar os tons de cinza, false para desligar.';

  @override
  String get skapiScriptGrayscaleParamDurationLabel => 'duration';

  @override
  String get skapiScriptGrayscaleParamDurationHint =>
      '0 significa apenas alternar. >0 volta automaticamente à cor após os segundos indicados. Ideal para pausas visuais.';

  @override
  String get skapiScriptFindMouseShakeTitle => 'Encontrar mouse';

  @override
  String get skapiScriptFindMouseShakeSummaryWhat =>
      'Mexe o cursor em um pequeno círculo para chamar o olhar à posição dele. O cursor volta ao ponto de partida quando a animação termina.';

  @override
  String get skapiScriptFindMouseShakeSummaryHow =>
      'Lê a posição atual do cursor com GetCursorPos, depois faz um loop com SetCursorPos em torno de um círculo do raio configurado. Útil em configurações com vários monitores e 4K.';

  @override
  String get skapiScriptFindMouseShakeNote =>
      'Nível 2: o SetCursorPos pode ser bloqueado por software de acessibilidade, e o comportamento varia em sessões de área de trabalho remota.';

  @override
  String get skapiScriptFindMouseShakeParamRadiusLabel => 'radius';

  @override
  String get skapiScriptFindMouseShakeParamRadiusHint =>
      'Pixels que o cursor percorre a partir da origem durante o loop. Maior chama mais a atenção.';

  @override
  String get skapiScriptFindMouseShakeParamLoopsLabel => 'loops';

  @override
  String get skapiScriptFindMouseShakeParamLoopsHint =>
      'Quantos círculos completos desenhar antes de parar.';

  @override
  String get skapiGroupProgramsTitle => 'Controle de programas específicos';

  @override
  String get skapiGroupProgramsDesc =>
      'Scripts direcionados a apps e navegadores específicos: salvar+fechar gracioso, encerramento de múltiplas instâncias, limpeza de todo um navegador. Úteis quando um dispositivo SmartKraft quer encerrar um fluxo de trabalho específico sem destruir o desktop inteiro.';

  @override
  String get skapiGroupProgramsFoot =>
      'Uso típico: salvar e fechar todos os editores antes de suspender, fechar todos os navegadores no fim do dia, limpeza restrita de uma família de processos.';

  @override
  String get skapiScriptCloseWithSaveTitle => 'Salvar e fechar app';

  @override
  String get skapiScriptCloseWithSaveSummaryWhat =>
      'Envia Ctrl+S a um app de destino para acionar o salvamento dele, espera e então fecha a janela graciosamente.';

  @override
  String get skapiScriptCloseWithSaveSummaryHow =>
      'Foca cada instância em execução, envia Ctrl+S via SendKeys, espera o intervalo configurado e então envia WM_CLOSE para que o app possa confirmar ou terminar de salvar.';

  @override
  String get skapiScriptCloseWithSaveNote =>
      'Nível 2: depende de o app interpretar Ctrl+S como \'salvar\'. Alguns apps de chat / web o tratam de outra forma. Teste com os apps que você realmente usa.';

  @override
  String get skapiScriptCloseWithSaveParamProcessLabel => 'processName';

  @override
  String get skapiScriptCloseWithSaveParamProcessHint =>
      'Nome do processo sem .exe (winword, excel, code, photoshop). Todas as instâncias em execução são salvas e fechadas.';

  @override
  String get skapiScriptCloseWithSaveParamWaitLabel => 'wait';

  @override
  String get skapiScriptCloseWithSaveParamWaitHint =>
      'Segundos a esperar entre o Ctrl+S e o sinal de fechar para que o app termine de salvar.';

  @override
  String get skapiScriptCloseAllInstancesTitle => 'Fechar todas as instâncias';

  @override
  String get skapiScriptCloseAllInstancesSummaryWhat =>
      'Envia um fechamento gracioso a cada janela visível de um processo. Cada instância pode mostrar seu próprio diálogo de salvar.';

  @override
  String get skapiScriptCloseAllInstancesSummaryHow =>
      'Itera os processos correspondentes via Get-Process e envia WM_CLOSE à janela principal de cada um. Sem encerramento forçado de reserva.';

  @override
  String get skapiScriptCloseAllInstancesParamProcessLabel => 'processName';

  @override
  String get skapiScriptCloseAllInstancesParamProcessHint =>
      'Nome do processo sem .exe. Corresponde a todas as instâncias.';

  @override
  String get skapiScriptBrowserCloseAllTitle => 'Fechar todos os navegadores';

  @override
  String get skapiScriptBrowserCloseAllSummaryWhat =>
      'Fecha graciosamente todos os navegadores populares em execução (Chrome, Edge, Firefox, Brave, Vivaldi, Opera).';

  @override
  String get skapiScriptBrowserCloseAllSummaryHow =>
      'Itera os nomes de processo conhecidos dos navegadores e envia WM_CLOSE à janela principal de cada um. Navegadores modernos preservam a sessão se \'restaurar abas na próxima inicialização\' estiver ativado.';

  @override
  String get skapiScriptBrowserCloseAllNote =>
      'O encerramento forçado não é usado. Para apagar a sessão também, use kill-app por navegador.';

  @override
  String get skapiTierBadgeExperimental => 'Experimental';

  @override
  String get skapiTierBadgeExperimentalTooltip =>
      'Este script depende de uma API do Windows que pode não ser confiável em diferentes máquinas. Teste-o antes de depender dele.';

  @override
  String get skapiTierBadgeBlocked => 'Em breve';

  @override
  String get skapiTierBadgeBlockedTooltip =>
      'Este script faz parte da biblioteca planejada, mas ainda não foi implementado.';

  @override
  String get skapiGroupSaveWorkTitle => 'Salvar trabalho';

  @override
  String get skapiGroupSaveWorkDesc =>
      'Os scripts deste grupo salvam em disco o trabalho aberto antes de uma pausa ou de um desligamento inesperado. Quando seu dispositivo SmartKraft dispara uma pausa, o script escolhido salva automaticamente seu arquivo no Word, Excel, VS Code ou qualquer outro editor, de modo que, mesmo se o computador suspender, desligar ou executar outro comando, seu trabalho fica seguro.';

  @override
  String get skapiGroupSaveWorkFoot =>
      'Uso típico: salvamento automático no início de uma pausa de foco, backup de documento ao avisar bateria fraca, ou um gatilho de um botão para \"salvar tudo\".';

  @override
  String get skapiScriptSaveActiveWindowTitle => 'Salvar janela ativa';

  @override
  String get skapiScriptSaveActiveWindowSummaryWhat =>
      'Envia um Ctrl+S virtual à janela do Windows que estiver em foco no momento, acionando o comportamento de \"salvar\" daquele aplicativo.';

  @override
  String get skapiScriptSaveActiveWindowSummaryHow =>
      'Primeiro captura o handle da janela ativa e registra o título dela. Depois dispara Ctrl+S via SendKeys. O Word salva no caminho atual, o VS Code grava o arquivo. Se um diálogo de \"Salvar como\" aparecer, ele espera até o usuário confirmar manualmente.';

  @override
  String get skapiScriptSaveActiveWindowParamTimeoutLabel => 'timeout';

  @override
  String get skapiScriptSaveActiveWindowParamTimeoutHint =>
      'Segundos a esperar após enviar o atalho para que o app tenha tempo de gravar o arquivo.';

  @override
  String get skapiScriptSaveActiveWindowParamVerboseLabel => 'verbose';

  @override
  String get skapiScriptSaveAllOpenTitle =>
      'Salvar todos os documentos abertos';

  @override
  String get skapiScriptSaveAllOpenSummaryWhat =>
      'Percorre uma lista de editores em execução e manda cada um salvar seus documentos abertos.';

  @override
  String get skapiScriptSaveAllOpenSummaryHow =>
      'Para cada processo da lista que for encontrado, foca a janela principal, envia Ctrl+S e então espera o tempo limite configurado por app antes de seguir. Apps que não estão em execução são pulados em silêncio, a menos que o modo verbose esteja ativo.';

  @override
  String get skapiScriptSaveAllOpenNote =>
      'A lista padrão inclui Word, Excel, PowerPoint e VS Code. Edite o parâmetro apps para adicionar os seus.';

  @override
  String get skapiScriptSaveAllOpenParamAppsLabel => 'apps';

  @override
  String get skapiScriptSaveAllOpenParamAppsHint =>
      'Nomes de processo (sem .exe) para os quais enviar o salvar. A ordem importa: as entradas anteriores são processadas primeiro.';

  @override
  String get skapiScriptSaveAllOpenParamTimeoutLabel => 'timeoutPerApp';

  @override
  String get skapiScriptSaveAllOpenParamVerboseLabel => 'verbose';

  @override
  String get skapiScriptAutosaveTriggerTitle => 'Acionar salvamento automático';

  @override
  String get skapiScriptAutosaveTriggerSummaryWhat =>
      'Transmite um comando de salvar do Windows a cada janela de nível superior visível em uma só passada.';

  @override
  String get skapiScriptAutosaveTriggerSummaryHow =>
      'Enumera as janelas visíveis e então envia a cada uma um WM_COMMAND com o id padrão de salvar. Apps que escutam essa mensagem reagem como se você tivesse clicado no item Salvar do menu Arquivo. Mais rápido que um Ctrl+S por janela, mas alguns apps ignoram a transmissão.';

  @override
  String get skapiScriptAutosaveTriggerNote =>
      'Use quando quiser descarregar todos os editores de uma vez e não se importar que um pequeno número de apps possa não responder. Combine com salvar-tudo-aberto para uma cobertura mais rígida.';

  @override
  String get skapiScriptAutosaveTriggerParamDelayLabel => 'delay';

  @override
  String get skapiScriptAutosaveTriggerParamDelayHint =>
      'Segundos a esperar antes de transmitir, útil quando você quer que a notificação de pausa do dispositivo apareça primeiro.';

  @override
  String get skapiScriptAutosaveTriggerParamVerboseLabel => 'verbose';

  @override
  String get skapiScriptDetailSummaryWhatLabel => 'O que faz:';

  @override
  String get skapiScriptDetailSummaryHowLabel => 'Como funciona:';

  @override
  String get skapiScriptDetailOriginalSectionTitle => 'Script original';

  @override
  String get skapiScriptDetailOriginalSectionSub => 'somente leitura · inglês';

  @override
  String get skapiScriptDetailEditingSectionTitle => 'Edições';

  @override
  String get skapiScriptDetailEditingNotYet => 'Nenhuma edição ainda';

  @override
  String get skapiScriptDetailEditingNotYetSub =>
      'Crie uma cópia neste dispositivo sem alterar o original.';

  @override
  String get skapiScriptDetailEditingModified => 'Editado';

  @override
  String skapiScriptDetailEditingModifiedSub(String date) {
    return 'Última alteração $date.';
  }

  @override
  String get skapiScriptDetailEditingOutdated => 'Biblioteca atualizada';

  @override
  String get skapiScriptDetailEditingOutdatedSub =>
      'O original foi alterado por uma atualização do app. Compare ou redefina.';

  @override
  String get skapiScriptDetailParamWarnTitle =>
      'Confira os parâmetros antes de executar';

  @override
  String get skapiScriptDetailParamWarnHint =>
      'Para alterar estes valores, use \"Editar\". Os parâmetros são definidos no bloco param() do script.';

  @override
  String get skapiScriptDetailNotesTitle => 'Notas';

  @override
  String get skapiScriptDetailButtonRun => 'Executar agora';

  @override
  String get skapiScriptDetailButtonBindAction => 'Vincular a uma ação';

  @override
  String get skapiScriptDetailButtonEdit => 'Editar';

  @override
  String get skapiScriptDetailButtonView => 'Visualizar';

  @override
  String get skapiScriptDetailButtonReset => 'Redefinir';

  @override
  String get skapiScriptDetailButtonCompare => 'Comparar';

  @override
  String get skapiScriptCopyButton => 'Copiar';

  @override
  String get skapiScriptCopyButtonDone => 'Copiado';

  @override
  String get skapiScriptSelectButton => 'Selecionar';

  @override
  String get skapiEditorTitle => 'Editar';

  @override
  String skapiEditorHint(String scriptId) {
    return '$scriptId · Você está editando uma cópia neste dispositivo. A versão original da biblioteca permanece inalterada. \"Redefinir\" sempre restaura o original.';
  }

  @override
  String get skapiEditorStatusBarTitle => 'POWERSHELL · UTF-8';

  @override
  String get skapiEditorStatusModified => '● Modificado';

  @override
  String get skapiEditorStatusUnmodified => 'Inalterado';

  @override
  String skapiEditorFootCursor(int line, int column) {
    return 'Linha $line · Coluna $column';
  }

  @override
  String get skapiEditorFootSaveLabel => 'Salvar';

  @override
  String skapiEditorDiffLineCount(int count) {
    return '$count linha alterada';
  }

  @override
  String skapiEditorDiffLinesCount(int count) {
    return '$count linhas alteradas';
  }

  @override
  String get skapiEditorDiffCompareLink => 'Comparar com o original';

  @override
  String get skapiEditorButtonReset => 'Redefinir';

  @override
  String get skapiEditorButtonSave => 'Salvar';

  @override
  String get skapiEditorAfterSaveNote =>
      'Após salvar, \"Executar agora\" executará a versão editada.';

  @override
  String get skapiLinuxDistroHeading => 'Escolha a família da sua distribuição';

  @override
  String get skapiLinuxDistroSubtitle =>
      'Os scripts de Linux divergem entre as famílias baseadas em Debian (apt, .deb) e baseadas em Arch (pacman). Escolha a que corresponde à sua máquina.';

  @override
  String get skapiLinuxDistroDebianLabel => 'Baseada em Debian';

  @override
  String get skapiLinuxDistroDebianSub =>
      'Debian, Ubuntu, Mint, Pop!_OS, Elementary, Kali, MX, Zorin';

  @override
  String get skapiLinuxDistroArchLabel => 'Baseada em Arch';

  @override
  String get skapiLinuxDistroArchSub =>
      'Arch, Manjaro, EndeavourOS, Garuda (em breve)';

  @override
  String get skapiNewActionNoDevicesTitle => 'Pareie um dispositivo primeiro';

  @override
  String get skapiNewActionNoDevicesBody =>
      'Criar uma ação no dispositivo precisa de pelo menos um dispositivo SmartKraft pareado (BF por enquanto).';

  @override
  String get skapiNewActionNoDevicesCta => 'Abrir Dispositivos';

  @override
  String get skapiNewActionPickDeviceTitle => 'Escolha um dispositivo';

  @override
  String get skapiNewActionPickDeviceSubtitle =>
      'Em qual dispositivo esta ação deve ficar?';

  @override
  String get skapiUserNewTitle => 'Novo script';

  @override
  String get skapiUserEditTitle => 'Editar script';

  @override
  String get skapiUserTitleLabel => 'Título';

  @override
  String get skapiUserTitleHint => 'ex.: Rotina matinal';

  @override
  String get skapiUserDescLabel => 'Descrição';

  @override
  String get skapiUserDescHint => 'O que este script faz?';

  @override
  String get skapiUserPlatformLabel => 'Plataforma';

  @override
  String get skapiUserCodeLabel => 'Código';

  @override
  String get skapiUserCodeHint => '# Seu código PowerShell aqui';

  @override
  String get skapiUserSaveCta => 'Salvar';

  @override
  String get skapiUserValidationEmpty =>
      'Título e código não podem ficar vazios.';

  @override
  String get skapiUserSavedSnack => 'Script salvo';

  @override
  String get skapiUserSectionHeading => 'Meus scripts';

  @override
  String skapiUserSectionSub(int count) {
    return '$count scripts';
  }

  @override
  String get skapiUserEmptyHint =>
      'Nenhum script seu ainda. Crie um com o botão Nova ação, no canto superior direito.';

  @override
  String get skapiUserDetailCodeHeading => 'Código';

  @override
  String get skapiUserEditCta => 'Editar';

  @override
  String get skapiUserDeleteConfirmTitle => 'Excluir script?';

  @override
  String skapiUserDeleteConfirmBody(String name) {
    return '$name será excluído permanentemente.';
  }

  @override
  String get skapiUserDeletedSnack => 'Script excluído';

  @override
  String get skapiUserRunCta => 'Executar';

  @override
  String get skapiUserRunUnsupported => 'Executar scripts é só para desktop.';

  @override
  String get skapiUserRunOutputTitle => 'Saída da execução';

  @override
  String skapiUserRunDone(int code) {
    return 'Concluído (saída $code)';
  }

  @override
  String get skapiLocalScriptsSubheading => 'Scripts locais';

  @override
  String get skapiOnDeviceApiSubheading => 'API no dispositivo';

  @override
  String get skapiOnDeviceApiLoadError => 'Não foi possível ler os endpoints';

  @override
  String get skapiOnDeviceApiRowHint =>
      'Toque em qualquer linha para abrir o editor';

  @override
  String get commonLoading => 'Carregando...';

  @override
  String get skapiApiTemplateSectionHeader => 'Modelos';

  @override
  String skapiApiTemplateSectionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count modelos',
      one: '1 modelo',
    );
    return '$_temp0';
  }

  @override
  String get skapiApiTemplateUploadCta => 'Enviar ao dispositivo';

  @override
  String get skapiApiTemplateUploadHint =>
      'O envio grava este modelo em um dos 5 slots de API USER do dispositivo. O dispositivo o dispara no próprio gatilho (BF: fim da contagem regressiva).';

  @override
  String get skapiApiTemplatePreviewTitle => 'Prévia do endpoint';

  @override
  String get skapiApiTemplatePreviewType => 'Tipo';

  @override
  String get skapiApiTemplatePreviewMethod => 'Método';

  @override
  String get skapiApiTemplatePreviewUrl => 'URL';

  @override
  String get skapiApiTemplatePreviewAuth => 'Autenticação';

  @override
  String get skapiApiTemplatePreviewHeader => 'Header';

  @override
  String get skapiApiTemplatePreviewContentType => 'Content-Type';

  @override
  String get skapiApiTemplatePreviewPayload => 'Payload';

  @override
  String get skapiApiTemplatePreviewDelay => 'Atraso';

  @override
  String get skapiOtherCategoryHeading =>
      'Escolha uma categoria de dispositivo';

  @override
  String get skapiOtherCategorySubtitle =>
      'Os modelos são enviados ao dispositivo pareado e disparam no próprio gatilho do dispositivo (sem notebook envolvido).';

  @override
  String get skapiOtherSyndimmSub => 'Dimmer inteligente da SmartKraft';

  @override
  String get skapiOtherLebensspurSub => 'Rastreador de atividade da SmartKraft';

  @override
  String get skapiOtherBlockingfocusSub => 'Timer de foco da SmartKraft';

  @override
  String get skapiOtherIotSub =>
      'Webhooks de IoT de terceiros (IFTTT, Home Assistant, REST genérico)';

  @override
  String get skapiOtherServerSub =>
      'Receptores HTTP auto-hospedados (n8n, Node-RED, personalizados)';

  @override
  String get skapiCategoryComingSoon => 'Modelos em breve';

  @override
  String get skapiScriptLockSummaryHowLxDebian =>
      'Chama loginctl lock-session para o XDG_SESSION_ID atual; recorre a xdg-screensaver lock quando o loginctl não está disponível.';

  @override
  String get skapiScriptHibernateSummaryHowLxDebian =>
      'Chama systemctl hibernate. Um atraso opcional dorme pelos segundos solicitados antes de suspender.';

  @override
  String get skapiScriptHibernateNoteLxDebian =>
      'A hibernação precisa estar configurada (swap >= RAM e o parâmetro de kernel resume=). Em sistemas onde não está, o systemd-logind recorre à suspensão.';

  @override
  String get skapiScriptSleepSummaryHowLxDebian =>
      'Chama systemctl suspend. O kernel pode atrasar se um inibidor em primeiro plano estiver bloqueando as transições de ociosidade.';

  @override
  String get skapiScriptShutdownSummaryHowLxDebian =>
      'Agenda um desligamento gracioso via /sbin/shutdown -h +N (minutos). Recorre a systemctl poweroff após o atraso solicitado se o shutdown estiver ausente.';

  @override
  String get skapiScriptShutdownNoteLxDebian =>
      'O /sbin/shutdown só aceita minutos; valores abaixo de 60 são arredondados para 1 minuto. Outros usuários logados veem uma mensagem wall durante a contagem regressiva.';

  @override
  String get skapiScriptShutdownParamForceHintLxDebian =>
      'Encerra a sessão do usuário antes de desligar, então o período de tolerância SIGTERM de 90s é pulado.';

  @override
  String get skapiScriptBrightnessSummaryHowLxDebian =>
      'Define o brilho da tela interna via brightnessctl set N% (preferencial) ou light -S N como alternativa. Ambos escrevem em /sys/class/backlight.';

  @override
  String get skapiScriptBrightnessNoteLxDebian =>
      'O brightnessctl dispensa sudo quando o usuário está no grupo video, que é o padrão após a instalação na maioria das configurações Debian. Monitores externos por DDC precisam de ddcutil e não são tratados aqui.';

  @override
  String get skapiScriptMuteToggleSummaryHowLxDebian =>
      'Alterna ou define o mudo do sink principal via wpctl (PipeWire no Debian 12+) com alternativa pactl para configurações PulseAudio.';

  @override
  String get skapiScriptVolumeSetSummaryHowLxDebian =>
      'Define o volume do sink principal em um nível de 0-100 via wpctl set-volume (PipeWire) ou pactl set-sink-volume (PulseAudio).';

  @override
  String get skapiScriptVolumeSetNoteLxDebian =>
      'PipeWire e PulseAudio expõem volume por app nativamente, então este script é nível 1 no Linux. Saída acima de 100% é limitada para manter a paridade com outras plataformas.';

  @override
  String get skapiScriptMediaKeySummaryHowLxDebian =>
      'Envia uma ação de tecla de mídia via playerctl, que usa MPRIS para falar com o app que controla a sessão no momento (Spotify, Firefox, VLC, mpv, Rhythmbox).';

  @override
  String get skapiScriptMediaKeyNoteLxDebian =>
      'Se nenhum app de mídia compatível com MPRIS estiver em execução, o comando não tem efeito. Instale o suporte MPRIS do app se um player conhecido não responder.';

  @override
  String get skapiScriptMinimizeWindowSummaryHowLxDebian =>
      'Um processName vazio minimiza a janela em foco via xdotool. Caso contrário, escolhe a primeira janela cujo WM_CLASS corresponde e a minimiza.';

  @override
  String get skapiScriptMinimizeWindowNoteLxDebian =>
      'Apenas X11. A correspondência de WM_CLASS diferencia maiúsculas de minúsculas e depende de como o app se declarou; verifique com xprop WM_CLASS se tiver dúvida.';

  @override
  String get skapiScriptMinimizeWindowParamProcessHintLxDebian =>
      'Nome da instância WM_CLASS (por exemplo: firefox, code, gnome-terminal-server). Vazio mira a janela ativa.';

  @override
  String get skapiScriptCloseWindowSummaryHowLxDebian =>
      'Envia WM_DELETE_WINDOW via wmctrl -x -c (corresponde por WM_CLASS) com alternativa por título. Equivale a clicar no botão X; o app pode mostrar seu próprio diálogo de salvar.';

  @override
  String get skapiScriptCloseWindowNoteLxDebian =>
      'Apenas X11. No Wayland, prefira kill-app, que usa sinais em vez do protocolo de janela.';

  @override
  String get skapiScriptCloseWindowParamProcessHintLxDebian =>
      'Nome da instância WM_CLASS; vazio fecha a janela em foco. A correspondência por trecho do título é usada como alternativa.';

  @override
  String get skapiScriptKillAppSummaryHowLxDebian =>
      'pkill -TERM -x pelo nome comm exato, espera o tempo limite solicitado e então pkill -KILL em tudo que ainda estiver vivo. O preKillSave opcional foca a janela e envia Ctrl+S primeiro (apenas X11).';

  @override
  String get skapiScriptKillAppNoteLxDebian =>
      'Os nomes comm do Linux são limitados a 15 caracteres pelo kernel. Use nomes curtos exatos: firefox (não firefox-esr-bin), code, soffice.bin.';

  @override
  String get skapiScriptKillAppParamProcessHintLxDebian =>
      'Nome comm exato (limite de 15 caracteres do kernel). Use pgrep -l para verificar o nome visível.';

  @override
  String get skapiScriptKillAppParamPreKillSaveHintLxDebian =>
      'Envia Ctrl+S à janela do app antes do SIGTERM. Requer xdotool e X11; ignorado no Wayland.';

  @override
  String get skapiScriptLaunchAppSummaryHowLxDebian =>
      'Despacho inteligente: .desktop -> gtk-launch, caminho de arquivo real -> exec, qualquer outra coisa -> xdg-open, por fim busca no PATH. O filho é desacoplado via setsid para que o SKAPP não fique bloqueado.';

  @override
  String get skapiScriptLaunchAppNoteLxDebian =>
      'args é dividido por espaços. Argumentos com aspas não são suportados; use um script wrapper para linhas de comando complexas.';

  @override
  String get skapiScriptLaunchAppParamPathHintLxDebian =>
      'Nome do binário no PATH, caminho absoluto, arquivo .desktop, URL ou caminho de arquivo. O xdg-open trata os tipos MIME.';

  @override
  String get skapiScriptDialogSummaryHowLxDebian =>
      'Abre um diálogo modal via zenity (GTK) com alternativa kdialog (KDE). Escreve um entre ok / cancel / yes / no / timeout no stdout.';

  @override
  String get skapiScriptDialogNoteLxDebian =>
      'Instale com: sudo apt install zenity. Usuários do KDE Plasma podem ter o kdialog. Sem nenhum dos dois, o script sai com o código 2.';

  @override
  String get skapiScriptToastSummaryHowLxDebian =>
      'Envia uma notificação de área de trabalho via notify-send (libnotify). Nível 1 porque o libnotify-bin vem pré-instalado em todo desktop Debian moderno.';

  @override
  String get skapiScriptToastNoteLxDebian =>
      'icon aceita nomes do tema de ícones Freedesktop (dialog-information, dialog-warning, dialog-error). duration em segundos; 0 mantém o toast até ser dispensado.';

  @override
  String get skapiScriptToastParamIconLabelLxDebian => 'Ícone';

  @override
  String get skapiScriptToastParamIconHintLxDebian =>
      'Nome de ícone Freedesktop, por exemplo: dialog-information, dialog-warning, dialog-error.';

  @override
  String get skapiScriptToastParamDurationLabelLxDebian => 'Duração';

  @override
  String get skapiScriptToastParamDurationHintLxDebian =>
      'Dispensar automaticamente após esta quantidade de segundos. 0 significa que o toast permanece até o usuário fechá-lo.';

  @override
  String get skapiScriptShowDesktopSummaryHowLxDebian =>
      'Lê o estado EWMH show-desktop via wmctrl -m, depois o alterna com wmctrl -k. Espelha a semântica de Win+D no X11.';

  @override
  String get skapiScriptShowDesktopNoteLxDebian =>
      'Apenas X11. Os equivalentes no Wayland são específicos do compositor (Sway, Hyprland, extensões do GNOME Shell).';

  @override
  String get skapiScriptFadeScreenSummaryHowLxDebian =>
      'Esmaece linearmente o brilho da tela interna do atual até o destino ao longo da duração solicitada via brightnessctl em incrementos de 10 passos por segundo.';

  @override
  String get skapiScriptFadeScreenNoteLxDebian =>
      'Apenas painéis internos. Monitores externos por DDC precisam de ddcutil e não são tratados aqui. Nível 2 porque ler o brilho atual depende da visibilidade de /sys/class/backlight.';

  @override
  String get skapiScriptGrayscaleSummaryHowLxDebian =>
      'Alterna a chave de saturação de cor da lupa de acessibilidade do GNOME (0.0 tons de cinza, 1.0 cor) via gsettings, sem precisar de extensão.';

  @override
  String get skapiScriptGrayscaleNoteLxDebian =>
      'Apenas GNOME / Unity. KDE Plasma e XFCE não têm caminho de sistema equivalente; nesses ambientes o script sai com o código 3 em vez de não ter efeito silenciosamente.';

  @override
  String get skapiScriptFindMouseShakeSummaryHowLxDebian =>
      'Lê a posição do cursor via xdotool getmouselocation, depois traça um círculo em torno dela pela quantidade de loops solicitada usando coordenadas cos/sin computadas com awk.';

  @override
  String get skapiScriptFindMouseShakeNoteLxDebian =>
      'Apenas X11. O Wayland bloqueia o movimento sintético do ponteiro no nível do protocolo (limite de segurança), então o script sai com o código 3.';

  @override
  String get skapiScriptCloseWithSaveSummaryHowLxDebian =>
      'Para cada janela visível correspondente ao WM_CLASS: ativa, Ctrl+S, espera e então envia WM_DELETE_WINDOW via wmctrl. Apenas X11.';

  @override
  String get skapiScriptCloseWithSaveNoteLxDebian =>
      'Nível 2: a injeção da tecla Ctrl+S depende do locale e do foco; só uma semântica real de salvar se comporta de forma previsível. Apps de chat ou web podem mapear Ctrl+S para outra coisa.';

  @override
  String get skapiScriptCloseWithSaveParamProcessHintLxDebian =>
      'Nome da instância WM_CLASS (veja xprop WM_CLASS). Obrigatório.';

  @override
  String get skapiScriptCloseAllInstancesSummaryHowLxDebian =>
      'Envia SIGTERM a cada processo em execução correspondente ao nome comm exato. Cada app trata sua própria sequência de encerramento (e pode mostrar seu próprio diálogo de salvar).';

  @override
  String get skapiScriptCloseAllInstancesParamProcessHintLxDebian =>
      'Nome comm exato conforme mostrado por pgrep -l. Obrigatório.';

  @override
  String get skapiScriptBrowserCloseAllSummaryHowLxDebian =>
      'Percorre uma lista de binários de navegadores do Debian (firefox, firefox-esr, chromium, google-chrome, brave, vivaldi-bin, opera) e envia SIGTERM a cada instância em execução.';

  @override
  String get skapiScriptBrowserCloseAllNoteLxDebian =>
      'Os navegadores preservam a sessão se \"restaurar abas na próxima inicialização\" estiver ativo, então isto é um suave \"apagar a tela\" em vez de uma ação de perda de dados.';

  @override
  String get skapiScriptSaveActiveWindowSummaryHowLxDebian =>
      'Envia Ctrl+S à janela em foco via xdotool key --clearmodifiers. Apenas X11.';

  @override
  String get skapiScriptSaveActiveWindowNoteLxDebian =>
      'O Wayland bloqueia a injeção sintética de teclas no nível do protocolo. Use a alternativa autosave-trigger ou conte com o salvamento automático do próprio app.';

  @override
  String get skapiScriptSaveAllOpenSummaryHowLxDebian =>
      'Itera a lista de apps, encontra as janelas visíveis de cada app, ativa-as uma a uma e envia Ctrl+S entre as esperas.';

  @override
  String get skapiScriptSaveAllOpenNoteLxDebian =>
      'A lista de apps padrão cobre LibreOffice (soffice.bin), VS Code (code), gedit e kate. Passe --apps \"nome1,nome2\" para sobrescrever. Apenas X11.';

  @override
  String get skapiScriptSaveAllOpenParamAppsHintLxDebian =>
      'Nomes comm separados por vírgula, por exemplo: soffice.bin,code,gedit.';

  @override
  String get skapiScriptAutosaveTriggerSummaryHowLxDebian =>
      'Percorre cada janela de nível superior visível via wmctrl -l, ativa cada uma por vez e injeta Ctrl+S. O X11 não tem o caminho de transmissão WM_COMMAND do Windows, então o foco por janela é a alternativa.';

  @override
  String get skapiScriptAutosaveTriggerNoteLxDebian =>
      'Nível 2: depende de o app em foco honrar Ctrl+S como \"salvar\". A maioria dos editores honra; apps de chat podem interpretar errado. Apenas X11.';

  @override
  String get commonReadFailed => 'não foi possível ler';

  @override
  String get commonUnknown => 'desconhecido';

  @override
  String get commonComingSoon => 'em breve';

  @override
  String get commonDismiss => 'Dispensar';

  @override
  String bootstrapBannerError(String error) {
    return 'Não foi possível ler do dispositivo: $error';
  }

  @override
  String get bootstrapBannerRetry => 'Tentar de novo';

  @override
  String get bfApiChainAuthNone => 'Nenhuma';

  @override
  String get bfApiChainAuthBearer => 'Token Bearer';

  @override
  String get bfApiChainAuthBasic => 'Autenticação básica';

  @override
  String get bfApiChainAuthHeader => 'Header personalizado';

  @override
  String bfApiChainMasterError(String error) {
    return 'Mestre: $error';
  }

  @override
  String get bfApiChainChainStarted => 'Cadeia iniciada';

  @override
  String bfApiChainChainError(String error) {
    return 'Erro: $error';
  }

  @override
  String get bfApiChainSaveDialogTitle => 'Salvar endpoint?';

  @override
  String bfApiChainSaveDialogBody(String name) {
    return '\"$name\" será persistido no dispositivo. Isso atualiza a área de dados do usuário.';
  }

  @override
  String get bfApiChainSaveDialogConfirm => 'Salvar';

  @override
  String bfApiChainSavedToast(String name) {
    return '\"$name\" salvo';
  }

  @override
  String bfApiChainSaveFailed(String error) {
    return 'Não foi possível salvar: $error';
  }

  @override
  String get bfApiChainDeleteDialogTitle => 'Excluir?';

  @override
  String bfApiChainDeleteDialogBody(String name) {
    return 'O endpoint \"$name\" será removido do dispositivo. Esta ação não pode ser desfeita.';
  }

  @override
  String get bfApiChainDeleteDialogConfirm => 'Excluir';

  @override
  String bfApiChainDeletedToast(String name) {
    return '\"$name\" excluído';
  }

  @override
  String bfApiChainDeleteFailed(String error) {
    return 'Não foi possível excluir: $error';
  }

  @override
  String bfApiChainTestNoReply(String name) {
    return '\"$name\" sem resposta (tempo limite de 15 s)';
  }

  @override
  String bfApiChainTestSuccess(String name, String httpSuffix) {
    return '\"$name\" sucesso$httpSuffix';
  }

  @override
  String bfApiChainTestFailure(String name, String error, String httpSuffix) {
    return '\"$name\" erro: $error$httpSuffix';
  }

  @override
  String bfApiChainTestTriggerFailed(String error) {
    return 'Não foi possível disparar: $error';
  }

  @override
  String get bfApiChainNewEndpointName => 'Novo endpoint';

  @override
  String get bfApiChainEmptyTitle => 'Nenhum endpoint registrado ainda';

  @override
  String get bfApiChainEmptyBody =>
      'Use o cartão \"Adicionar endpoint\" abaixo para definir uma nova chamada HTTP (ex.: webhook do IFTTT, seu próprio servidor, pausar o Spotify).';

  @override
  String get bfApiChainSystemSectionTitle => 'Automático (SKAPPs pareados)';

  @override
  String get bfApiChainSystemSectionSubtitle =>
      'Quando você vincula um script via SKAPI, um slot abre automaticamente para cada computador. Quando a contagem regressiva termina, um webhook assinado vai para o SKAPP naquele computador.';

  @override
  String get bfApiChainUserSectionTitle => 'Manual (dispositivos IoT)';

  @override
  String get bfApiChainUserSectionSubtitle =>
      'Adicione URLs de terceiros (Shelly, Home Assistant, IFTTT) manualmente. Quando a contagem regressiva termina, esta lista dispara primeiro, em ordem.';

  @override
  String get bfApiChainMasterToggleLabel => 'Gatilho ativo';

  @override
  String get bfApiChainMasterOnSubtitle =>
      'Mestre ligado: a cadeia dispara nos gatilhos do dispositivo';

  @override
  String get bfApiChainMasterOffSubtitle =>
      'Mestre desligado: nenhum endpoint será chamado';

  @override
  String get bfApiChainFieldNameLabel => 'Nome';

  @override
  String get bfApiChainTypeLabel => 'Tipo';

  @override
  String get bfApiChainEventOrApplet => 'Evento / Applet';

  @override
  String get bfApiChainMethodLabel => 'Método';

  @override
  String get bfApiChainDelayLabel => 'Aguardar depois (0-300 s)';

  @override
  String get bfApiChainDelayUnit => 's';

  @override
  String get bfApiChainAdvancedHide => 'Ocultar opções avançadas';

  @override
  String get bfApiChainAdvancedShow => 'Opções avançadas';

  @override
  String get bfApiChainAuthLabel => 'Autenticação';

  @override
  String bfApiChainCurrentTokenHint(String masked) {
    return 'Token atual: $masked (escreva um novo valor abaixo para atualizar)';
  }

  @override
  String get bfApiChainNewTokenLabel =>
      'Novo token (deixe em branco para manter)';

  @override
  String get bfApiChainContentTypeLabel => 'Content-Type';

  @override
  String get bfApiChainSaveCta => 'Salvar';

  @override
  String get bfApiChainDeleteCta => 'Excluir';

  @override
  String get bfApiChainTestCta => 'Testar';

  @override
  String get bfApiChainAddCardLabel => 'Adicionar novo endpoint';

  @override
  String bfApiChainSavedDelaySeconds(int count) {
    return '$count s de espera';
  }

  @override
  String get bfApiChainNotSaved => 'não salvo';

  @override
  String bfApiChainSystemRowSignedTooltip(String peer, int delay) {
    return 'par $peer…  ·  atraso ${delay}s  ·  assinado (HMAC)';
  }

  @override
  String get bfApiChainTestEndpointTooltip => 'Testar este endpoint';

  @override
  String get bfLogsBufferEmpty =>
      'O buffer de registros do dispositivo está vazio.';

  @override
  String get bfLogsUnsupported =>
      'O dispositivo não suporta registros neste firmware.';

  @override
  String get deviceLogsNoClockBanner =>
      'Relógio do dispositivo não definido; os horários são mostrados como segundos desde a inicialização.';

  @override
  String get deviceLogsTruncatedHint =>
      '(saída truncada, tente um limite menor ou uma severidade maior)';

  @override
  String get bfEventsTimerRunning => 'Contagem regressiva iniciada';

  @override
  String get bfEventsTimerPaused => 'Contagem regressiva pausada';

  @override
  String get bfEventsTimerIdle => 'Contagem regressiva redefinida';

  @override
  String get bfEventsTimerCooldown => 'Resfriamento';

  @override
  String get bfEventsTimerExpired => 'Contagem regressiva finalizada';

  @override
  String bfEventsFaceChanged(String from, String to) {
    return 'Face alterada: $from → $to';
  }

  @override
  String bfEventsApiTriggered(String type) {
    return '$type disparado';
  }

  @override
  String get bfEventsApiTriggeredFallback => 'API disparada';

  @override
  String bfEventsBatteryLevel(int percent) {
    return 'Nível de bateria: %$percent';
  }

  @override
  String get bfEventsDeviceRestarted => 'Dispositivo reiniciado';

  @override
  String skapiManifestLoadingRetry(String platform, String scriptId) {
    return 'manifesto de $platform/$scriptId carregando, tente de novo em um instante';
  }

  @override
  String get skapiListenerOffMobileTitle =>
      'Este dispositivo não pode executar scripts de desktop';

  @override
  String get skapiListenerOffDesktopTitle =>
      'O ouvinte HTTP do SKAPP está desligado';

  @override
  String get skapiListenerOffMobileBody =>
      'Quando a contagem regressiva termina, os scripts serão executados no Windows / macOS / Linux. O SKAPP precisa estar aberto e o ouvinte ativo. Este celular é apenas o lado de configuração; a execução acontece no desktop.';

  @override
  String skapiListenerOffDesktopBody(String lastErrorSuffix) {
    return 'O BF disparará o webhook, mas ninguém o receberá porque o ouvinte está desligado. Abra Configurações → Ouvinte HTTP do SKAPP.$lastErrorSuffix';
  }

  @override
  String get skapiSyncBadgeWriting => 'Gravando no BF…';

  @override
  String get skapiSyncBadgeWritten => 'Salvo no BF';

  @override
  String get skapiSyncBadgeFailed => 'Não foi possível gravar no BF';

  @override
  String skapiSyncBadgeFirmwareCodeTooltip(String code) {
    return 'Código de firmware: $code';
  }

  @override
  String get syncErrUnknownCommand =>
      'Firmware antigo no dispositivo. Grave o novo firmware';

  @override
  String get syncErrNotAuthenticated =>
      'Sessão do dispositivo não autorizada (pode ser preciso parear de novo)';

  @override
  String get syncErrNotFound => 'Nenhum registro de pareamento no dispositivo';

  @override
  String get syncErrInternal => 'Os 8 slots SYSTEM podem estar cheios';

  @override
  String get syncErrUnknown => 'erro desconhecido';

  @override
  String get syncErrTimeout => 'O dispositivo não respondeu (offline?)';

  @override
  String get syncErrNoBond => 'Nenhum pareamento com este dispositivo';

  @override
  String get syncErrConnect => 'Não foi possível conectar ao dispositivo';

  @override
  String get discoveryFilterShowAll => 'Mostrar todos os dispositivos';

  @override
  String get discoveryFilterOnlySmartKraft => 'Apenas SmartKraft';

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
    return 'Filtro desligado · $visible dispositivo(s) mostrado(s) ($sk SmartKraft$tail)';
  }

  @override
  String discoveryMdnsTail(int count) {
    return ' + $count na rede';
  }

  @override
  String get discoveryWifiOnlySnack =>
      'Este dispositivo está visível apenas por Wi-Fi no momento. O pareamento por Wi-Fi ainda não está ativo; pressione rapidamente o botão do dispositivo para abrir a janela de pareamento. Quando ele também for visto por BLE, esta linha ficará pareável.';

  @override
  String get discoveryBadgePairable => 'Pareável';

  @override
  String get discoveryBadgeBonded => 'Pareado com outro SKAPP';

  @override
  String get pairingTitleConnecting => 'Conectando';

  @override
  String get pairingTitleReconnecting => 'Reconectando';

  @override
  String get pairingMutualAuthHmacSubtitle => 'Desafio-resposta HMAC';

  @override
  String pairingBleConnectFailed(String error) {
    return 'Falha na conexão BLE.\n\nSolução: pressione rapidamente o botão do dispositivo para abrir a janela de pareamento de 60 segundos, depois toque em \"Tentar de novo\".\n\nDetalhes: $error';
  }

  @override
  String get pairingGattServiceMissing => 'Serviço SKAPP não encontrado';

  @override
  String get pairingGattCmdRxMissing => 'Característica cmd_rx ausente';

  @override
  String get pairingGattEventTxMissing => 'Característica event_tx ausente';

  @override
  String pairingGattDiscoveryFailed(String error) {
    return 'Falha na descoberta GATT: $error';
  }

  @override
  String pairingKeySendFailed(String error) {
    return 'Não foi possível enviar a chave: $error';
  }

  @override
  String pairingDeviceNoReply(int seconds) {
    return 'O dispositivo não respondeu ($seconds s).';
  }

  @override
  String pairingDeviceRejected(String error) {
    return 'Dispositivo rejeitou: $error';
  }

  @override
  String get pairingInvalidReplyMissingPub =>
      'Resposta inválida do dispositivo (our_pub ausente).';

  @override
  String pairingHexDecodeFailed(String error) {
    return 'falha na decodificação hex de our_pub: $error';
  }

  @override
  String get pairingRetryButton => 'Tentar de novo';

  @override
  String pairingReconnectTransient(String error) {
    return 'Não foi possível acessar o dispositivo; o pareamento existente é mantido.\n\nVerifique se o dispositivo está ligado e dentro do alcance, depois toque em \"Tentar de novo\".\n\nDetalhes: $error';
  }

  @override
  String get pairingRecoveryTitle => 'Renovar pareamento';

  @override
  String get pairingRecoveryBody =>
      'O dispositivo não reconhece o pareamento atual. Para iniciar um novo, pressione o botão de pareamento do dispositivo para abrir a janela de 60 segundos, depois toque em Continuar.';

  @override
  String get pairingRecoveryContinue => 'Continuar';

  @override
  String get pairingRecoveryCancelled =>
      'Renovação de pareamento cancelada. O pareamento antigo ainda está registrado; toque em \"Tentar de novo\" para tentar outra conexão mais tarde.';

  @override
  String get pairingRenewBondButton => 'Renovar pareamento';

  @override
  String wifiPasswordConnectionRejected(String error) {
    return 'Conexão rejeitada: $error';
  }

  @override
  String get wifiPasswordTimeout =>
      'O dispositivo não respondeu (tempo esgotado).';

  @override
  String wifiScanRejected(String error) {
    return 'O dispositivo rejeitou wifi.scan: $error\n\nO módulo Wi-Fi do dispositivo pode não ter iniciado; tente reiniciar.';
  }

  @override
  String wifiScanUnexpectedReply(String data) {
    return 'Resposta inesperada de wifi.scan: $data';
  }

  @override
  String wifiScanTimeout(String error) {
    return 'O dispositivo não respondeu (tempo esgotado: $error).\n\nAproxime-se do dispositivo, pressione rapidamente o botão dele (para acionar o anúncio) e tente de novo.';
  }

  @override
  String wifiScanConnectionError(String error) {
    return 'Erro de conexão: $error';
  }

  @override
  String get wifiScanHeaderHelp =>
      'Abaixo estão as redes Wi-Fi que **o dispositivo** consegue ver (não as redes do celular). Escolha a rede em que o dispositivo deve entrar; a senha é solicitada na próxima etapa.';

  @override
  String get wifiScanAuthOpen => 'Aberta';

  @override
  String get wifiScanAuthEncrypted => 'Criptografada';

  @override
  String get wifiSuccessSyncing => 'Sincronizando hora…';

  @override
  String get wifiSuccessFetchingInfo => 'Obtendo informações do dispositivo…';

  @override
  String get wifiSuccessPreparingUi => 'Preparando a interface do dispositivo…';

  @override
  String wifiSuccessManifestRejected(String error) {
    return 'device.manifest rejeitado ($error). Pode ser firmware antigo; o sk_baseline.c precisa estar carregado para o BF.';
  }

  @override
  String get wifiSuccessTapToContinue => 'Toque para continuar…';

  @override
  String get deviceHomeUnsupportedTitle => 'Dispositivo não suportado';

  @override
  String deviceHomeUnsupportedBody(String name) {
    return '$name não tem tela de dispositivo nesta versão do SKAPP. Quando uma nova família de dispositivos for adicionada, esta tela aparecerá automaticamente.';
  }

  @override
  String get lsPairingUnpairTitle => 'Desparear este APP';

  @override
  String get lsPairingUnpairBody =>
      'O dispositivo esquecerá o vínculo deste APP. Será preciso parear de novo (botão por 3 s + selecionar em Dispositivos).';

  @override
  String get skYakindaBadgeDefault => 'em breve';

  @override
  String get skapiScriptPulseBrightnessTitle => 'Pulsar brilho';

  @override
  String get skapiScriptPulseBrightnessSummaryWhat =>
      'Modula o brilho da tela interna em uma onda cosseno suave entre 100% e um limite inferior, repetida um número definido de vezes. O brilho original do usuário é restaurado ao final.';

  @override
  String get skapiScriptPulseBrightnessSummaryHow =>
      'Lê o brilho atual via WMI, depois escreve uma amostra de brilho 20 vezes por segundo seguindo uma curva cosseno. Sempre restaura o original capturado ao sair.';

  @override
  String get skapiScriptPulseBrightnessNote =>
      'Apenas painéis internos (notebooks, tablets). Monitores externos DDC/CI não respondem a este caminho WMI.';

  @override
  String get skapiScriptPulseBrightnessParamPeriodLabel => 'período';

  @override
  String get skapiScriptPulseBrightnessParamPeriodHint =>
      'Segundos para um ciclo completo claro -> escuro -> claro. Cerca de 2 parece um pulso nítido sem incomodar.';

  @override
  String get skapiScriptPulseBrightnessParamLowPercentLabel => '% mínimo';

  @override
  String get skapiScriptPulseBrightnessParamLowPercentHint =>
      'Extremo escuro do pulso, como percentual do brilho total. Números menores tornam o pulso mais dramático.';

  @override
  String get skapiScriptPulseBrightnessParamCyclesLabel => 'ciclos';

  @override
  String get skapiScriptPulseBrightnessParamCyclesHint =>
      'Quantos ciclos completos de pulso executar antes de sair.';

  @override
  String get skapiScriptBlurTimedTitle => 'Pausa desfocada';

  @override
  String get skapiScriptBlurTimedSummaryWhat =>
      'Cobre a tela com um véu semitransparente em tela cheia e sempre no topo pela quantidade de segundos configurada. Uma contagem regressiva é mostrada no centro.';

  @override
  String get skapiScriptBlurTimedSummaryHow =>
      'Abre uma janela WPF sem bordas com AllowsTransparency e um pincel de cor sólida na opacidade escolhida. Um timer de dispatcher conduz a contagem regressiva; a janela se fecha quando o timer chega a zero.';

  @override
  String get skapiScriptBlurTimedNote =>
      'Solução provisória pragmática: o desfoque gaussiano em tempo real sobre a área de trabalho precisa de um auxiliar C++/Win2D que chega depois. O véu sólido cria uma fricção parecida de \'não consigo focar na tela, faça uma pausa\' enquanto isso.';

  @override
  String get skapiScriptBlurTimedParamDurationLabel => 'duration';

  @override
  String get skapiScriptBlurTimedParamDurationHint =>
      'Segundos que o véu permanece antes de fechar automaticamente.';

  @override
  String get skapiScriptBlurTimedParamOpacityLabel => 'opacity';

  @override
  String get skapiScriptBlurTimedParamOpacityHint =>
      'Opacidade do véu de 0.0 (invisível) a 1.0 (sólido). Cerca de 0.55 ainda deixa a área de trabalho transparecer o suficiente para parecer velada, não apagada.';

  @override
  String get skapiScriptBlurTimedParamColorLabel => 'color';

  @override
  String get skapiScriptBlurTimedParamColorHint =>
      'Cor do véu em hex #RRGGBB. O preto da paleta #0A0A0A é o padrão; tons creme mais claros parecem mais calmos.';

  @override
  String get skapiScriptBlockingFocusTitle => 'Blocking Focus';

  @override
  String get skapiScriptBlockingFocusSummaryWhat =>
      'Impositor de foco composto: salva todos os documentos abertos do Office e do VS Code, depois abre uma janela de contagem regressiva em tela cheia e sempre no topo, sem botão de fechar, enquanto o cursor do mouse gira continuamente. Quando o timer chega a zero, tudo é desfeito automaticamente.';

  @override
  String get skapiScriptBlockingFocusSummaryHow =>
      'Três fases rodam em sequência: (1) a fase de salvar chama o COM do Office e a CLI do VS Code; (2) um runspace paralelo conduz o cursor em círculo até uma flag de parada sincronizada virar; (3) uma janela WPF em STA mostra o título e a contagem regressiva. Um bloco finally restaura a origem do cursor e desmonta ambos os runspaces.';

  @override
  String get skapiScriptBlockingFocusNote =>
      'Modo suave: Esc e Alt+F4 NÃO são bloqueados. O usuário sempre pode escapar pelo Gerenciador de Tarefas. O modo estrito com hooks globais de teclado será um script separado.';

  @override
  String get skapiScriptBlockingFocusParamDurationLabel => 'duration';

  @override
  String get skapiScriptBlockingFocusParamDurationHint =>
      'Segundos que o bloqueio dura. A contagem regressiva desce até 00:00 e então tudo é limpo.';

  @override
  String get skapiScriptBlockingFocusParamTitleLabel => 'title';

  @override
  String get skapiScriptBlockingFocusParamTitleHint =>
      'Texto mostrado no centro da janela em tela cheia. Mantenha curto - \'Blocking Focus\' é o padrão.';

  @override
  String get skapiScriptBlockingFocusParamShakeRadiusLabel => 'raio do balanço';

  @override
  String get skapiScriptBlockingFocusParamShakeRadiusHint =>
      'Pixels que o cursor percorre a partir da origem durante o loop. Círculos maiores exigem mais atenção.';

  @override
  String get skapiScriptBlockingFocusParamEnableSaveLabel =>
      'salvar ao iniciar';

  @override
  String get skapiScriptBlockingFocusParamEnableSaveHint =>
      'Executa a fase de salvar do Office + VS Code antes do bloqueio. Desligue quando não houver estado de documento para proteger.';

  @override
  String get trayFirstHideToast =>
      'O SKAPP continua em execução em segundo plano. Encontre-o na bandeja do sistema; clique com o botão direito para Sair.';

  @override
  String devicesOfflineTapHint(String name) {
    return '$name está offline.';
  }

  @override
  String skapiNewActionDeviceOffline(String name) {
    return '$name está offline. Coloque-o online para criar uma nova ação.';
  }

  @override
  String get bfApiChainRefreshDirtyTitle => 'Alterações não salvas';

  @override
  String get bfApiChainRefreshDirtyBody =>
      'Atualizar vai buscar a lista de endpoints mais recente do dispositivo e descartar o rascunho que você ainda não salvou.';

  @override
  String get bfApiChainRefreshDirtyConfirm => 'Atualizar mesmo assim';

  @override
  String get skapiApiEditorTitle => 'API no dispositivo';

  @override
  String get lsCommonReadFailed => 'Falha na leitura';

  @override
  String lsCommonFailedWith(String err) {
    return 'Falhou: $err';
  }

  @override
  String get lsVacationStatusOff => 'Desligado';

  @override
  String lsVacationStatusUntil(String date) {
    return 'Até $date';
  }

  @override
  String get lsVacationDaysValidationError =>
      'Os dias devem estar entre 1 e 60';

  @override
  String lsVacationStartedSnack(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Férias iniciadas · $days dias',
      one: 'Férias iniciadas · 1 dia',
    );
    return '$_temp0';
  }

  @override
  String get lsVacationCancelledSnack => 'Férias canceladas';

  @override
  String lsVacationActiveUntilFmt(String date) {
    return 'Ativas até $date';
  }

  @override
  String get lsVacationResumeHint =>
      'A contagem regressiva será retomada quando as férias terminarem.';

  @override
  String get lsVacationCancellingButton => 'Cancelando…';

  @override
  String get lsVacationCancelButton => 'Cancelar férias';

  @override
  String get lsVacationDaysLabel => 'Dias';

  @override
  String get lsVacationDaysHint =>
      'Pausa a contagem regressiva por esta quantidade de dias (1 a 60).';

  @override
  String get lsVacationStartingButton => 'Iniciando…';

  @override
  String get lsVacationStartButton => 'Iniciar férias';

  @override
  String get lsCommonSavingButton => 'Salvando…';

  @override
  String get lsCommonSaveButton => 'Salvar';

  @override
  String lsCommonSaveFailedWith(String err) {
    return 'Falha ao salvar: $err';
  }

  @override
  String get lsDurationValueValidationError =>
      'O valor deve estar entre 1 e 60';

  @override
  String get lsDurationAlarmsValidationError =>
      'A contagem de alarmes deve estar entre 0 e 10';

  @override
  String get lsDurationConfiguredSnack => 'Timer configurado';

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
      other: '$value dias',
      one: '1 dia',
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
  String get lsDurationUnitLabel => 'Unidade';

  @override
  String get lsDurationUnitMinutesPlural => 'minutos';

  @override
  String get lsDurationUnitHoursPlural => 'horas';

  @override
  String get lsDurationUnitDaysPlural => 'dias';

  @override
  String get lsDurationValueLabel => 'Valor';

  @override
  String get lsDurationValueHint => '1 a 60';

  @override
  String get lsDurationAlarmCountLabel => 'Contagem de alarmes';

  @override
  String get lsDurationAlarmCountHint =>
      'Os alarmes disparam de trás para frente a partir do fim, com uma unidade de intervalo.';

  @override
  String get lsSmtpStatusNotConfigured => 'Não configurado';

  @override
  String get lsSmtpHostRequired => 'O host é obrigatório';

  @override
  String get lsSmtpPortValidationError => 'A porta deve estar entre 1 e 65535';

  @override
  String get lsSmtpSenderRequired => 'O endereço do remetente é obrigatório';

  @override
  String get lsSmtpFieldHost => 'Host';

  @override
  String get lsSmtpFieldPort => 'Porta';

  @override
  String get lsSmtpFieldSender => 'Remetente';

  @override
  String get lsSmtpFieldKey => 'Chave';

  @override
  String lsSmtpSaveHaltedOn(String err) {
    return 'Salvamento interrompido em $err';
  }

  @override
  String get lsSmtpSavedSnack => 'SMTP salvo';

  @override
  String get lsSmtpTestSentSnack => 'E-mail de teste enviado';

  @override
  String lsSmtpTestFailedWith(String err) {
    return 'Falha no teste: $err';
  }

  @override
  String get lsSmtpUrlCopiedSnack => 'URL copiada para a área de transferência';

  @override
  String get lsSmtpApiKeyPlaceholder => 'Senha de app do Gmail / chave de API';

  @override
  String get lsSmtpServerLabel => 'Servidor';

  @override
  String get lsSmtpApiKeyLabel => 'Chave de API';

  @override
  String get lsSmtpApiKeyHint => 'Deixe em branco para manter a chave atual.';

  @override
  String get lsSmtpAppPasswordHelpLink =>
      'Como obter uma senha de app do Gmail';

  @override
  String get lsSmtpSendingButton => 'Enviando…';

  @override
  String get lsSmtpSendTestButton => 'Enviar teste';

  @override
  String get lsReminderMailRecipientValidation =>
      'O destinatário precisa parecer um endereço de e-mail';

  @override
  String get lsReminderMailSavedSnack => 'Lembrete salvo localmente';

  @override
  String get lsReminderMailRecipientFirstSnack =>
      'Defina um destinatário primeiro';

  @override
  String get lsReminderMailTestOkSnack =>
      'Teste SMTP OK, as credenciais alcançam o servidor';

  @override
  String lsReminderMailTestFailedWith(String err) {
    return 'Falha no teste SMTP: $err';
  }

  @override
  String get lsReminderMailRecipientLabel => 'E-mail do destinatário';

  @override
  String get lsReminderMailSubjectLabel => 'Assunto';

  @override
  String get lsReminderMailBodyLabel => 'Corpo';

  @override
  String get lsReminderMailBodyHint =>
      'Sua contagem regressiva vai disparar em breve...';

  @override
  String get lsReminderMailActiveLabel => 'Ativo';

  @override
  String get lsReminderMailFootnote =>
      'Salvo localmente neste dispositivo. O teste de envio só verifica se o servidor SMTP está acessível; o disparo automático em timer.alarm depende de suporte do firmware.';

  @override
  String get lsResetApiStatusDisabled => 'Desativado';

  @override
  String lsResetApiStatusEnabledPort(int port) {
    return 'Ativado · porta $port';
  }

  @override
  String get lsResetApiRegenDialogTitle => 'Regenerar a chave de API?';

  @override
  String get lsResetApiRegenDialogBody =>
      'Isto invalidará a chave atual. Qualquer chamador usando a chave anterior será rejeitado até você atualizá-la. Continuar?';

  @override
  String get lsResetApiRegenConfirm => 'Regenerar';

  @override
  String get lsResetApiKeyRegeneratedSnack => 'Chave regenerada';

  @override
  String get lsResetApiEnabledLabel => 'Ativado';

  @override
  String get lsResetApiEnabledHint =>
      'Quando ligado, um GET HTTP à URL do endpoint com a chave correspondente reinicia a contagem regressiva.';

  @override
  String get lsResetApiEndpointUrlLabel => 'URL do endpoint';

  @override
  String get lsResetApiUrlNotAvailable => '(não disponível)';

  @override
  String get lsResetApiCopyUrlTooltip => 'Copiar URL';

  @override
  String get lsResetApiKeyLabel => 'Chave de API';

  @override
  String get lsResetApiKeyNotSet => '(não definida)';

  @override
  String get lsResetApiExampleLabel => 'Exemplo';

  @override
  String get lsResetApiRegenerateButton => 'Regenerar chave';

  @override
  String get lsAlarmApiUrlValidation =>
      'A URL deve começar com http:// ou https://';

  @override
  String get lsAlarmApiHeadersValidation =>
      'O campo de headers deve ser um JSON válido';

  @override
  String get lsAlarmApiSaveDialogTitle => 'Salvar endpoint de webhook?';

  @override
  String lsAlarmApiSaveDialogBody(String name, String url) {
    return 'Armazena `$name` no dispositivo apontando para:\n$url';
  }

  @override
  String get lsAlarmApiSavedSnack => 'Webhook salvo';

  @override
  String get lsAlarmApiDisabledSnack => 'Webhook desativado';

  @override
  String get lsAlarmApiTestQueuedSnack =>
      'Teste enfileirado, observe o serviço de destino';

  @override
  String lsAlarmApiTestFailedWith(String err) {
    return 'Falha no teste: $err';
  }

  @override
  String get lsAlarmApiRemoveDialogTitle => 'Remover webhook?';

  @override
  String lsAlarmApiRemoveDialogBody(String name) {
    return 'Exclui `$name` do dispositivo. A configuração local é mantida.';
  }

  @override
  String get lsAlarmApiRemoveButton => 'Remover';

  @override
  String lsAlarmApiRemoveFailedWith(String err) {
    return 'Falha ao remover: $err';
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
  String get lsAlarmApiHeadersLabel => 'Headers (JSON, opcional)';

  @override
  String get lsAlarmApiHeadersHint =>
      'Objeto JSON com headers opcionais. Salvo localmente; o firmware aplica ao disparar.';

  @override
  String get lsAlarmApiBodyTemplateLabel => 'Modelo de corpo (JSON)';

  @override
  String get lsAlarmApiBodyTemplateHint =>
      'Os placeholders device e remaining_sec são substituídos na hora do disparo.';

  @override
  String get lsAlarmApiBearerLabel => 'Token Bearer (opcional)';

  @override
  String get lsAlarmApiFootnote =>
      'O assinante de firmware para o evento timer.alarm está pendente. Esta configuração armazena o endpoint; ele não vai disparar automaticamente até a próxima atualização de firmware.';

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
  String get lsRelayModeSteady => 'contínuo';

  @override
  String lsRelaySummaryFmt(int gpio, String duration, String mode) {
    return 'GPIO $gpio · $duration $mode';
  }

  @override
  String get lsRelayGpioValidation => 'O GPIO deve estar entre 0 e 30';

  @override
  String get lsRelayDurationValidation =>
      'A duração deve estar entre 1 e 3600 segundos';

  @override
  String get lsRelayPulseValidation =>
      'O meio-ciclo do pulso deve estar entre 1 e 60';

  @override
  String lsRelayCmdFailedWith(String cmd, String err) {
    return '$cmd falhou: $err';
  }

  @override
  String get lsRelayConfiguredSnack => 'Relé configurado';

  @override
  String get lsRelayFireAbortedSnack => 'Disparo abortado';

  @override
  String get lsRelayForcedIdleSnack => 'Relé forçado a ocioso';

  @override
  String get lsRelayGpioLabel => 'Pino GPIO';

  @override
  String get lsRelayGpioHint => 'Pino válido do ESP32-C6; padrão 19 = D8';

  @override
  String get lsRelayInvertLabel => 'Inverter polaridade';

  @override
  String get lsRelayStartDelayLabel => 'Atraso de início';

  @override
  String lsRelayStartDelayHint(int sec) {
    return '${sec}s antes de o relé ativar';
  }

  @override
  String get lsRelayActiveDurationLabel => 'Duração ativa';

  @override
  String get lsRelayUnitSeconds => 'Segundos';

  @override
  String get lsRelayUnitMinutes => 'Minutos';

  @override
  String get lsRelayPulseModeLabel => 'Modo de pulso';

  @override
  String get lsRelayPulseModeHint =>
      'Ligado = meio-ciclo de 1 s. Personalizado deixa você definir o meio-ciclo.';

  @override
  String get lsRelayHalfCycleLabel => 'Segundos de meio-ciclo';

  @override
  String get lsRelayFiringButton => 'Disparando…';

  @override
  String get lsRelayTestRelayButton => 'Testar relé';

  @override
  String get lsRelayAbortButton => 'Abortar';

  @override
  String get lsRelayForceOffButton => 'Forçar desligado';

  @override
  String get lsRelayPulseOff => 'Desligado';

  @override
  String get lsRelayPulseOn => 'Ligado';

  @override
  String get lsRelayPulseCustom => 'Personalizado';

  @override
  String get lsRelayPhaseActiveBadge => 'ativa';

  @override
  String lsRelayPhaseLine(String phase, String elapsed) {
    return 'Fase: $phase$elapsed';
  }

  @override
  String get lsTelegramTokenRequired => 'O token do bot é obrigatório';

  @override
  String get lsTelegramChatRequired => 'O id do chat é obrigatório';

  @override
  String get lsTelegramSaveDialogTitle => 'Salvar endpoint do Telegram?';

  @override
  String lsTelegramSaveDialogBody(String name) {
    return 'Armazena `$name` no dispositivo. O token é enviado na URL.';
  }

  @override
  String get lsTelegramSavedSnack => 'Endpoint do Telegram salvo';

  @override
  String get lsTelegramDisabledSnack => 'Endpoint do Telegram desativado';

  @override
  String get lsTelegramTestQueuedSnack =>
      'Teste enfileirado, observe o chat do Telegram';

  @override
  String get lsTelegramRemoveDialogTitle => 'Remover endpoint do Telegram?';

  @override
  String get lsTelegramBotConfiguredStatus => 'Bot configurado';

  @override
  String get lsTelegramBotTokenLabel => 'Token do bot';

  @override
  String get lsTelegramBotTokenHint =>
      'Obtenha um com o @BotFather (parece com 1234567:AAH...).';

  @override
  String get lsTelegramChatIdLabel => 'Chat ID';

  @override
  String get lsTelegramChatIdHint =>
      'Um id numérico (-100...) ou um nome de usuário @canal.';

  @override
  String get lsTelegramMessageTemplateLabel => 'Modelo de mensagem';

  @override
  String get lsTelegramMessageHint => 'LebensSpur: Alarme disparado.';

  @override
  String get lsLsApiUrlRequired => 'URL obrigatória';

  @override
  String get lsLsApiUpdatedSnack => 'Webhook atualizado';

  @override
  String get lsLsApiSavedSnack => 'Webhook salvo';

  @override
  String get lsLsApiSaveFirstSnack => 'Salve o webhook primeiro';

  @override
  String get lsLsApiTestQueuedSnack =>
      'Teste enfileirado, verifique o receptor';

  @override
  String get lsLsApiRemoveDialogBody =>
      'O webhook do LS será excluído do dispositivo. A contagem regressiva não vai mais dispará-lo.';

  @override
  String get lsLsApiRemovedSnack => 'Webhook removido';

  @override
  String get lsLsApiConfirmCriticalTitle => 'Confirmar alteração crítica';

  @override
  String lsLsApiConfirmCriticalBody(String cmd, int ttlSec) {
    return 'O dispositivo pede para confirmar:\n  $cmd\n\nEste token expira em ${ttlSec}s.';
  }

  @override
  String get lsLsApiConfirmButton => 'Confirmar';

  @override
  String lsLsApiActiveSlot(String name) {
    return 'Ativo · slot \"$name\"';
  }

  @override
  String lsLsApiActiveWithToken(String name, String token) {
    return 'Ativo · slot \"$name\" · token $token';
  }

  @override
  String get lsLsApiUrlHint =>
      'Disparado quando timer.triggered dispara. https:// recomendado.';

  @override
  String get lsLsApiHeadersLabel => 'Headers (JSON)';

  @override
  String get lsLsApiHeadersHint =>
      'Avançado: ainda não conectado via CLI. Reservado para uma versão futura.';

  @override
  String get lsLsApiBodyTemplateHint =>
      'Enviado como o payload de teste. O placeholder device é substituído no servidor.';

  @override
  String lsLsApiBearerHintExisting(String token) {
    return 'Definido no momento: $token. Deixe em branco para manter, ou cole um novo valor para sobrescrever.';
  }

  @override
  String get lsLsApiBearerHintEmpty =>
      'Enviado como `Authorization: Bearer <token>`.';

  @override
  String get lsLsApiUpdateButton => 'Atualizar';

  @override
  String lsMailGroupsStatusFmt(int count, int max, int recipients) {
    return '$count de $max · $recipients destinatários no total';
  }

  @override
  String lsMailGroupsReadFailedWith(String err) {
    return 'Falha na leitura: $err';
  }

  @override
  String get lsMailGroupsNameValidation =>
      'O nome deve ter entre 1 e 47 caracteres';

  @override
  String get lsMailGroupsNameSaved => 'Nome salvo';

  @override
  String get lsMailGroupsSubjectValidation =>
      'O assunto deve ter no máximo 127 caracteres';

  @override
  String get lsMailGroupsSubjectSaved => 'Assunto salvo';

  @override
  String get lsMailGroupsBodyValidation =>
      'O corpo deve ter no máximo 511 caracteres';

  @override
  String get lsMailGroupsBodySaved => 'Corpo salvo';

  @override
  String get lsMailGroupsEmailValidation => 'Insira um e-mail válido';

  @override
  String lsMailGroupsMaxReached(int max) {
    return 'O máximo é $max grupos';
  }

  @override
  String get lsMailGroupsNameEmpty => 'O nome não pode ficar vazio';

  @override
  String get lsMailGroupsCreatedSnack => 'Grupo criado';

  @override
  String lsMailGroupsCreateFailedWith(String err) {
    return 'Falha ao criar: $err';
  }

  @override
  String get lsMailGroupsDeleteDialogTitle => 'Excluir grupo?';

  @override
  String get lsMailGroupsDeleteDialogBody =>
      'Isto remove o grupo e todos os seus destinatários no dispositivo.';

  @override
  String get lsMailGroupsDeleteConfirm => 'Excluir';

  @override
  String get lsMailGroupsDeletedSnack => 'Grupo excluído';

  @override
  String lsMailGroupsDefaultName(int n) {
    return 'Grupo $n';
  }

  @override
  String get lsMailGroupsNewGroupTitle => 'Novo grupo de e-mail';

  @override
  String get lsMailGroupsGroupNameLabel => 'Nome do grupo';

  @override
  String get lsMailGroupsCreateConfirm => 'Criar';

  @override
  String get lsMailGroupsEmptyHint =>
      'Nenhum grupo ainda. Crie um para enviar e-mail quando o timer disparar.';

  @override
  String get lsMailGroupsWorkingButton => 'Trabalhando…';

  @override
  String get lsMailGroupsCreateNewButton => '+ Criar novo grupo';

  @override
  String lsMailGroupsHeaderCount(int count, int max) {
    return '$count de $max grupos configurados';
  }

  @override
  String lsMailGroupsHeaderTotalRecipients(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count destinatários no total',
      one: '1 destinatário no total',
    );
    return '· $_temp0';
  }

  @override
  String get lsMailGroupsUnnamed => '(sem nome)';

  @override
  String lsMailGroupsRowSummary(int count, String state) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count destinatários',
      one: '1 destinatário',
    );
    return '$_temp0 · $state';
  }

  @override
  String get lsMailGroupsEnabled => 'ativado';

  @override
  String get lsMailGroupsDisabled => 'desativado';

  @override
  String get lsMailGroupsNameLabel => 'Nome';

  @override
  String get lsMailGroupsSubjectLabel => 'Assunto';

  @override
  String get lsMailGroupsSaveBodyButton => 'Salvar corpo';

  @override
  String get lsMailGroupsDeleteGroupButton => 'Excluir grupo';

  @override
  String lsMailGroupsRecipientsHeader(int count) {
    return 'Destinatários ($count)';
  }

  @override
  String get lsMailGroupsNoRecipients => 'Nenhum destinatário ainda.';

  @override
  String get lsMailGroupsAddRecipientButton => 'Adicionar';

  @override
  String get lsHomeStatusLoading => 'Carregando…';

  @override
  String get lsHomeLogsTooltip => 'Registros';

  @override
  String get lsHomeClusterConfiguration => 'CONFIGURAÇÃO';

  @override
  String get lsHomeClusterTriggerActions => 'AÇÕES DE GATILHO';

  @override
  String get lsHomeClusterEarlyWarning => 'AVISO ANTECIPADO';

  @override
  String get lsHomeSectionDurationTitle => 'Duração e alarmes';

  @override
  String get lsHomeSectionVacationTitle => 'Modo férias';

  @override
  String get lsHomeSectionSmtpTitle => 'Configuração de e-mail (SMTP)';

  @override
  String get lsHomeSectionResetApiTitle => 'Endpoint da API de reinício';

  @override
  String get lsHomeSectionMailGroupsTitle => 'Grupos de e-mail';

  @override
  String get lsHomeSectionRelayTitle => 'Relé';

  @override
  String get lsHomeSectionLsApiTitle => 'Webhook da API LS';

  @override
  String get lsHomeSectionTelegramTitle => 'Telegram';

  @override
  String get lsHomeSectionReminderMailTitle => 'E-mail de lembrete';

  @override
  String get lsHomeSectionAlarmApiTitle => 'Webhook da API de alarme';

  @override
  String get lsHomeStateInactive => 'INATIVO';

  @override
  String get lsHomeStateRemaining => 'RESTANTE';

  @override
  String get lsHomeStateVacation => 'FÉRIAS';

  @override
  String get lsHomeStateTriggered => 'DISPARADO';

  @override
  String get lsHomeChipBle => 'BLE';

  @override
  String get lsHomeChipMail => 'E-mail';

  @override
  String get lsHomeEarlyWarningPendingNote =>
      'As ações de aviso antecipado disparam em timer.alarm. O assinante de firmware está pendente; estas configurações persistem, mas ainda não vão disparar automaticamente.';

  @override
  String get settingsDiagnosticsTitle => 'Diagnóstico';

  @override
  String get settingsDiagnosticsSubtitle =>
      'Registros para ajudar a depurar problemas';

  @override
  String get diagnosticsCopyLogs => 'Copiar registros';

  @override
  String get diagnosticsOpenFolder => 'Abrir pasta';

  @override
  String get diagnosticsOpenFolderFailed =>
      'Não foi possível abrir a pasta de registros.';

  @override
  String get diagnosticsShareLogs => 'Compartilhar registros';

  @override
  String get diagnosticsClearLogs => 'Limpar registros';

  @override
  String get diagnosticsCopied =>
      'Registros copiados para a área de transferência';

  @override
  String get diagnosticsCleared => 'Registros limpos';

  @override
  String get aboutPrivacyLabel => 'Política de privacidade';

  @override
  String get updateChecking => 'Verificando atualizações…';

  @override
  String get updateUpToDate => 'Você está na versão mais recente';

  @override
  String get updateCheckFailed => 'Não foi possível verificar atualizações';

  @override
  String get updateAvailableTitle => 'Atualização disponível';

  @override
  String updateAvailableBody(String version, String current) {
    return 'Uma nova versão ($version) está disponível. Você está na $current.';
  }

  @override
  String get updateDownloadAction => 'Baixar';

  @override
  String get updateLater => 'Depois';
}
