// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'SKAPP';

  @override
  String get brandTagline => 'SmartKraft';

  @override
  String get tabHome => 'Главная';

  @override
  String get tabDevices => 'Устройства';

  @override
  String get tabSkapi => 'SKAPI';

  @override
  String get tabSettings => 'Настройки';

  @override
  String get tabSmartKraft => 'SmartKraft';

  @override
  String get comingSoonBadge => 'скоро';

  @override
  String get featureComingSoonSnack => 'Эта функция скоро появится';

  @override
  String get homeWelcome => 'Добро пожаловать в SmartKraft';

  @override
  String get homeSubtitle => 'Управляйте своими устройствами SmartKraft';

  @override
  String get homeAddDevice => 'Добавить устройство';

  @override
  String get homeNoDevicesTitle => 'Пока нет устройств';

  @override
  String get homeNoDevicesHint =>
      'Добавьте первое устройство SmartKraft, чтобы начать.';

  @override
  String get homeSummaryTitle => 'Обзор';

  @override
  String homeDevicesOnline(int count) {
    return '$count подключено';
  }

  @override
  String homeDevicesOffline(int count) {
    return '$count не в сети';
  }

  @override
  String get homeUpdatesTitle => 'Доступны обновления';

  @override
  String homeUpdatesBody(int count) {
    return '$count устройство имеет более новую прошивку.';
  }

  @override
  String get homeWarningsTitle => 'Предупреждения';

  @override
  String homeWarningsBody(int count) {
    return '$count устройство сообщило о проблеме.';
  }

  @override
  String get homeAllGood => 'Всё работает исправно.';

  @override
  String get devicesTitle => 'Устройства';

  @override
  String get devicesEmpty =>
      'Устройства ещё не добавлены.\nНажмите кнопку +, чтобы добавить.';

  @override
  String get devicesAdd => 'Добавить устройство';

  @override
  String get devicesAllSection => 'Все устройства';

  @override
  String get devicesGroupsTitle => 'Ваши группы';

  @override
  String get devicesGroupsHint =>
      'Создавайте группы, чтобы упорядочить устройства по своему усмотрению.';

  @override
  String get devicesGroupsCreate => 'Новая группа';

  @override
  String get devicesGroupsEmpty => 'Пока нет групп.';

  @override
  String get skapiTitle => 'SKAPI';

  @override
  String get skapiLibraryHeading => 'Библиотека SKAPI';

  @override
  String get skapiLibrarySubtitle =>
      'Выберите платформу, на которой ваши устройства будут запускать действия.';

  @override
  String get skapiThisComputer => 'Этот компьютер';

  @override
  String skapiCategoryCount(int count) {
    return '$count категорий';
  }

  @override
  String get skapiPlatformMac => 'macOS';

  @override
  String get skapiPlatformWin => 'Windows';

  @override
  String get skapiPlatformLinux => 'Linux';

  @override
  String get skapiPlatformOther => 'Другое';

  @override
  String get skapiStarredHeading => 'Избранные API';

  @override
  String get skapiStarredEmpty =>
      'Отмечайте шаблоны в библиотеке — они появятся здесь.';

  @override
  String get skapiContributeTitle =>
      'Отправьте свою библиотеку сообществу SmartKraft';

  @override
  String get skapiContributeBody => 'Эта карточка будет оформлена позже.';

  @override
  String get skapiSearchPlaceholder => 'Поиск действий…';

  @override
  String get skapiSearchDisabledHint =>
      'Активируется после подключения парсера SKAPI.';

  @override
  String get skapiHelpButtonTooltip => 'О SKAPI';

  @override
  String get skapiHelpSheetTitle => 'О SKAPI';

  @override
  String get skapiHelpIntro =>
      'SKAPI — это библиотека действий, которые ваши устройства SmartKraft могут запускать на компьютере.';

  @override
  String get skapiHelpStep1Title => 'Выберите шаблон';

  @override
  String get skapiHelpStep1Body =>
      'Выберите отправную точку из библиотеки SKAPI.';

  @override
  String get skapiHelpStep2Title => 'Настройте';

  @override
  String get skapiHelpStep2Body =>
      'Задайте параметры и выберите, какое устройство будет его запускать.';

  @override
  String get skapiHelpStep3Title => 'Отправьте на устройство';

  @override
  String get skapiHelpStep3Body =>
      'Устройство сохраняет API-триггер; SKAPP выполняет скрипт.';

  @override
  String get skapiHelpGlossaryTitle => 'Глоссарий';

  @override
  String get skapiHelpGlossaryTemplate =>
      'Шаблон: запись библиотеки только для чтения';

  @override
  String get skapiHelpGlossaryAction =>
      'Действие: настроенная пара API-триггер + скрипт';

  @override
  String get skapiHelpGlossaryApiTrigger =>
      'API-триггер: то, что вызывает устройство';

  @override
  String get skapiHelpGlossaryScript =>
      'Скрипт: то, что выполняет ваш компьютер';

  @override
  String get skapiHelpPhase1Notice =>
      'SKAPI ещё в разработке. Большая часть этой вкладки — заготовка; разделы с пометкой «пока не активно» включатся по мере готовности парсера, слушателя и конструктора форм.';

  @override
  String get skapiMobileBannerBody =>
      'Этот телефон не может быть целью. Чтобы выполнять действия, SKAPP должен быть открыт на вашем компьютере.';

  @override
  String get skapiActionsHeading => 'Мои действия';

  @override
  String get skapiActionsNoDevicesTitle => 'Пока нет устройств';

  @override
  String get skapiActionsNoDevicesBody =>
      'Сначала выполните сопряжение устройства SmartKraft на вкладке «Устройства».';

  @override
  String get skapiActionsCreationDisabled =>
      'Создание действий пока не активно.';

  @override
  String get skapiActionsOfflineDetectionDisabled =>
      'Определение онлайн-статуса пока не активно';

  @override
  String get skapiActionsMaxLimitNote => 'До 5 действий на устройство.';

  @override
  String get skapiActionsAddCta => 'Добавить действие';

  @override
  String skapiHeaderSub(int platforms, int actions) {
    return '$platforms платформ · $actions действий';
  }

  @override
  String get skapiNewActionPill => 'Новое действие';

  @override
  String skapiActionsSubLine(int count) {
    return 'привязки устройство × скрипт · $count активно';
  }

  @override
  String get skapiActionsEmptyHint =>
      'Пока нет действий. Привяжите, что произойдёт при нажатии кнопки устройства.';

  @override
  String get skapiActionsCreateCta => 'Создать';

  @override
  String skapiActionsGroupTitle(String name) {
    return 'Действия: $name';
  }

  @override
  String skapiActionsGroupCount(int count) {
    return '$count';
  }

  @override
  String get skapiListenerEndpointTitle =>
      'URL вебхука, отправленный на устройства BF';

  @override
  String get skapiListenerEndpointBody =>
      'Если BF в той же сети Wi-Fi не может достучаться до этого URL после отсчёта, возможно, выбран не тот сетевой адаптер вашего ноутбука (например, сеть WSL/VirtualBox/Docker). Нажмите «Обновить», чтобы отправить заново.';

  @override
  String get skapiListenerEndpointResolving => 'Определение локального IP…';

  @override
  String get skapiListenerEndpointUnavailable =>
      'Подходящий интерфейс LAN не найден.';

  @override
  String get skapiListenerEndpointRefresh => 'Обновить';

  @override
  String get skapiListenerEndpointRefreshing => 'Отправка…';

  @override
  String skapiListenerEndpointPushedAt(String when) {
    return 'Последнее обновление: $when';
  }

  @override
  String get skapiListenerSelfTest => 'Самопроверка';

  @override
  String get skapiListenerSelfTestRunning => 'Проверка…';

  @override
  String get skapiListenerSelfTestPassed =>
      'Самопроверка пройдена: слушатель доступен с этого хоста.';

  @override
  String get skapiListenerSelfTestFailed =>
      'Самопроверка НЕ ПРОЙДЕНА: слушатель недоступен. Проверьте брандмауэр Windows.';

  @override
  String get skapiWebhookActivityTitle => 'Недавние вебхуки';

  @override
  String get skapiWebhookActivityNone =>
      'Вебхуки пока не получены. После истечения таймера устройства запись должна появиться здесь в течение нескольких секунд.';

  @override
  String get skapiWebhookActivityAccepted => 'Принято';

  @override
  String skapiWebhookActivityRejected(int code) {
    return 'Отклонено ($code)';
  }

  @override
  String get skapiWebhookActivityMalformed => 'Некорректный формат';

  @override
  String get skapiWebhookActivitySelfTest => 'Самопроверка';

  @override
  String get skapiWebhookActivityNoMatch => 'Нет подходящей привязки';

  @override
  String get skapiWebhookActivityScriptError => 'Ошибка скрипта';

  @override
  String skapiWebhookActivityMatched(int count) {
    return 'Выполнено скриптов: $count';
  }

  @override
  String get skapiBfEndpointsButton => 'Просмотреть конечные точки BF';

  @override
  String get skapiBfEndpointsTitle =>
      'Конечные точки, сохранённые на устройствах BF';

  @override
  String get skapiBfEndpointsHint =>
      'Снимок api.endpoint.list с каждого сопряжённого устройства, только для чтения. Сравните URL каждого слота SYSTEM с URL слушателя выше. Они должны точно совпадать. Слоты USER могут принадлежать ручным вебхукам и при неверной настройке перехватить ваш отсчёт.';

  @override
  String get skapiBfEndpointsLoading => 'Опрос устройств BF…';

  @override
  String get skapiBfEndpointsErrorPrefix => 'Сбой запроса:';

  @override
  String get skapiBfEndpointsKindSystem => 'SYSTEM';

  @override
  String get skapiBfEndpointsKindUser => 'USER';

  @override
  String get skapiBfEndpointsEmpty =>
      'На этом устройстве нет сохранённых конечных точек.';

  @override
  String get skapiBfEndpointsClose => 'Закрыть';

  @override
  String get skapiBfEndpointsRefresh => 'Запросить снова';

  @override
  String skapiStarredCount(int count) {
    return '$count в избранном';
  }

  @override
  String get skapiStarredSlimEmpty =>
      'Отмечайте записи библиотеки, чтобы собрать здесь самые используемые.';

  @override
  String get skapiCommunityShareTitle =>
      'Поделитесь библиотекой с сообществом SmartKraft';

  @override
  String get skapiCommunityShareBody =>
      'Написанные вами скрипты станут доступны всем в библиотеке SKAPI.';

  @override
  String get settingsNetworkIdentityTitle => 'Сетевая идентификация';

  @override
  String get settingsNetworkIdentityName => 'Имя компьютера';

  @override
  String get settingsNetworkIdentityNameHint =>
      'Используется как имя экземпляра mDNS';

  @override
  String get settingsNetworkIdentityNameEdit => 'Переименовать';

  @override
  String get settingsNetworkIdentityNameDialogTitle =>
      'Переименовать этот компьютер';

  @override
  String get settingsNetworkIdentityNameDialogHelp =>
      'Строчные буквы, цифры и дефисы. До 32 символов.';

  @override
  String get settingsNetworkIdentityUuid => 'ID устройства';

  @override
  String get settingsNetworkIdentityPort => 'Порт слушателя';

  @override
  String get settingsNetworkIdentityPortDialogTitle => 'Порт слушателя';

  @override
  String get settingsNetworkIdentityToken => 'Bearer-токен';

  @override
  String get settingsNetworkIdentityRegenerateToken =>
      'Сгенерировать токен заново';

  @override
  String get settingsNetworkIdentityRegenerateConfirmTitle =>
      'Сгенерировать Bearer-токен заново?';

  @override
  String get settingsNetworkIdentityRegenerateConfirmBody =>
      'Существующие устройства потребуется заново сопрягать с новым токеном.';

  @override
  String get settingsNetworkIdentityServerNotRunning =>
      'Сервер ещё не запущен, активируется в Фазе 2.';

  @override
  String get settingsNetworkIdentityCopy => 'Копировать';

  @override
  String get settingsNetworkIdentityCopied => 'Скопировано';

  @override
  String get settingsNetworkIdentityStaticIpHint =>
      'Совет: резервирование DHCP (статический IP) на роутере делает подключения надёжнее.';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsSectionAppearance => 'Внешний вид';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsLanguageSystemHint => 'Следовать языку системы';

  @override
  String get settingsLanguagePickerAllSection => 'Все языки';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get settingsThemeLight => 'Светлая';

  @override
  String get settingsThemeDark => 'Тёмная';

  @override
  String get settingsThemeSystem => 'Системная';

  @override
  String get settingsSectionAbout => 'О приложении';

  @override
  String get settingsVersion => 'Версия';

  @override
  String get settingsDeveloper => 'Разработчик';

  @override
  String get settingsDeveloperName => 'SmartKraft';

  @override
  String get settingsOpenAbout => 'О SKAPP';

  @override
  String get settingsSectionAdvanced => 'Дополнительно';

  @override
  String get settingsDeveloperMode => 'Режим разработчика';

  @override
  String get settingsDeveloperToolsTitle => 'Инструменты разработчика';

  @override
  String get settingsDeveloperToolsSubtitle =>
      'USB-консоль, сетевая идентификация, слушатель, токены, журналы';

  @override
  String get settingsDeveloperModeInfoTitle =>
      'Что открывает режим разработчика?';

  @override
  String get settingsDeveloperModeInfoIntro =>
      'Этот режим открывает возможности для опытных пользователей, скрытые в обычном интерфейсе. Три основных сценария:';

  @override
  String get settingsDeveloperModeUseCaseCliTitle => 'Консоль CLI';

  @override
  String get settingsDeveloperModeUseCaseCliBody =>
      'Настраивайте устройства по USB-кабелю без предварительного подключения по BLE или Wi-Fi.';

  @override
  String get settingsDeveloperModeUseCaseSkapiTitle => 'Редактор кода SKAPI';

  @override
  String get settingsDeveloperModeUseCaseSkapiBody =>
      'Открывайте и изменяйте встроенные скрипты или пишите свои с нуля.';

  @override
  String get settingsDeveloperModeUseCaseMobileTitle =>
      'Удалённый запуск с телефона';

  @override
  String get settingsDeveloperModeUseCaseMobileBody =>
      'Запускайте привязки SKAPI этого компьютера с сопряжённого мобильного SKAPP.';

  @override
  String get settingsDeveloperModeInfoSurfacesHeader =>
      'Дополнительные карточки настроек, появляющиеся при включении:';

  @override
  String get settingsDeveloperModeInfoItem1 =>
      'Карточка сетевой идентификации: изменение UUID, порта, Bearer-токена; копирование / повторная генерация секрета установки SKAPP.';

  @override
  String get settingsDeveloperModeInfoItem2 =>
      'Управление локальным HTTP-слушателем: запуск/остановка, сопряжение по QR, ротация TLS-сертификата, видимость в LAN.';

  @override
  String get settingsDeveloperModeInfoItem3 =>
      'Список токенов по узлам: просмотр каждого сопряжённого мобильного SKAPP и отзыв по отдельности.';

  @override
  String get settingsDeveloperModeInfoItem4 =>
      'USB CLI-консоль (только для ПК): прямая командная строка NDJSON к устройству SmartKraft, подключённому по USB.';

  @override
  String get settingsDeveloperModeInfoNotPaid =>
      'Это не платное обновление. SKAPP бесплатен и не имеет уровней; этот переключатель лишь скрывает по умолчанию возможности для опытных пользователей, чтобы не усложнять интерфейс. Устройства SmartKraft работают независимо от этой настройки.';

  @override
  String get settingsSectionConnectivity => 'Подключение';

  @override
  String get settingsBluetoothStatus => 'Bluetooth';

  @override
  String get settingsBluetoothStatusOn => 'Готов';

  @override
  String get settingsBluetoothStatusOff => 'Выключен';

  @override
  String get settingsBluetoothStatusTurningOn => 'Включение…';

  @override
  String get settingsBluetoothStatusTurningOff => 'Выключение…';

  @override
  String get settingsBluetoothStatusUnauthorized => 'Нет разрешения';

  @override
  String get settingsBluetoothStatusUnsupported => 'Не поддерживается';

  @override
  String get settingsBluetoothStatusUnknown => 'Проверка…';

  @override
  String get settingsNetworkStatus => 'Сеть';

  @override
  String get settingsWifiStatusConnected => 'Wi-Fi';

  @override
  String get settingsWifiStatusEthernet => 'Ethernet';

  @override
  String get settingsWifiStatusMobile => 'Мобильные данные';

  @override
  String get settingsWifiStatusDisconnected => 'Отключено';

  @override
  String get settingsWifiStatusUnknown => 'Проверка…';

  @override
  String get settingsWifiHint => 'Используется после первого сопряжения.';

  @override
  String get settingsBluetoothPermissions => 'Разрешения';

  @override
  String get settingsBluetoothPermissionsHint =>
      'Доступ к Bluetooth и геолокации';

  @override
  String get settingsBluetoothGrantPermission => 'Предоставить доступ';

  @override
  String get settingsOpenSystemSettings => 'Открыть системные настройки';

  @override
  String get settingsSectionUpdates => 'Обновления';

  @override
  String get settingsCheckUpdates => 'Проверить обновления';

  @override
  String get settingsAutoCheckUpdates => 'Проверять при запуске';

  @override
  String get settingsAutoCheckUpdatesHint =>
      'Проверять наличие последней версии при каждом запуске SKAPP.';

  @override
  String get settingsUpdateChannel => 'Канал обновлений';

  @override
  String get settingsUpdateChannelStable => 'Стабильный';

  @override
  String get settingsUpdateChannelBeta => 'Бета';

  @override
  String get settingsUpdateChannelBetaHint =>
      'Получайте новые функции раньше. Возможна меньшая стабильность.';

  @override
  String get settingsUpToDate => 'У вас установлена последняя версия.';

  @override
  String get settingsUpdateCheckPlaceholder =>
      'Проверка обновлений будет подключена в Фазе 3.';

  @override
  String get settingsSectionLegal => 'Правовая информация';

  @override
  String get settingsLicense => 'Лицензия и благодарности';

  @override
  String get settingsSectionInfo => 'Информация';

  @override
  String get settingsThemeCycleHint => 'Нажмите для переключения';

  @override
  String get settingsChannelCycleHint => 'Нажмите для переключения';

  @override
  String get settingsSectionThisNode => 'Этот узел';

  @override
  String get settingsNodeNameTitle => 'Имя узла SKAPP';

  @override
  String settingsNodeNameSub(String name) {
    return '$name · другие SKAPP видят это имя · вещание mDNS';
  }

  @override
  String get settingsSectionDanger => 'Опасная зона';

  @override
  String get settingsResetPairings => 'Сбросить сопряжения';

  @override
  String get settingsResetPairingsSub =>
      'Удалить все сопряжённые устройства; настройки/язык/имя узла сохраняются';

  @override
  String get settingsFactoryReset => 'Сброс к заводским настройкам';

  @override
  String get settingsFactoryResetSub => 'Всё будет стёрто, необратимо';

  @override
  String get settingsSectionAdvancedNetwork => 'Дополнительная сеть';

  @override
  String get settingsResetPairingsConfirmTitle => 'Сбросить все сопряжения?';

  @override
  String settingsResetPairingsConfirmBody(int paired, int bindings, int peers) {
    return 'Будут удалены: сопряжённых устройств — $paired, действий SKAPI — $bindings, узлов SKAPP — $peers. Ваши настройки, тема, язык и заметки сохранятся. Устройства сохраняют привязку на своей стороне; для полного разрыва сопряжения сбросьте устройство вручную. Это нельзя отменить.';
  }

  @override
  String get settingsResetPairingsConfirmAction => 'Сбросить';

  @override
  String get settingsFactoryResetConfirmTitle =>
      'Сброс к заводским настройкам?';

  @override
  String get settingsFactoryResetConfirmBody =>
      'Будет стёрто всё: все сопряжения, настройки, тема, язык, заметки, сетевая идентификация, TLS-сертификат и запись автозапуска. SKAPP вернётся к состоянию первого запуска. Это нельзя отменить.';

  @override
  String get settingsFactoryResetConfirmAction => 'Стереть всё';

  @override
  String get settingsFactoryResetSecondConfirmTitle => 'Вы абсолютно уверены?';

  @override
  String get settingsFactoryResetSecondConfirmBody =>
      'Введите ERASE для подтверждения.';

  @override
  String get settingsFactoryResetSecondConfirmHint => 'ERASE';

  @override
  String get settingsFactoryResetSecondConfirmAction => 'Я понимаю. Стереть.';

  @override
  String get settingsResetInProgress => 'Сброс…';

  @override
  String get settingsResetDoneTitle => 'Сброс завершён';

  @override
  String get settingsResetDoneWithWarnings =>
      'Сброс завершён (с предупреждениями)';

  @override
  String settingsResetSummaryPaired(int count) {
    return 'Удалено сопряжённых устройств: $count';
  }

  @override
  String settingsResetSummaryBindings(int count) {
    return 'Удалено действий SKAPI: $count';
  }

  @override
  String settingsResetSummaryPeers(int count) {
    return 'Удалено узлов SKAPP: $count';
  }

  @override
  String settingsResetSummaryBonds(int count) {
    return 'Очищено привязок устройств: $count';
  }

  @override
  String get settingsResetSummaryNetworkIdentity =>
      'Сетевая идентификация сброшена к значениям по умолчанию';

  @override
  String get settingsResetSummaryTlsCert => 'TLS-сертификат очищен';

  @override
  String get settingsResetSummaryAutostart => 'Запись автозапуска удалена';

  @override
  String get settingsResetSummaryWarningHeader => 'Предупреждения:';

  @override
  String get settingsResetRestartHint =>
      'Перезапустите SKAPP, чтобы полностью применить изменения.';

  @override
  String get settingsResetRestartNow => 'Перезапустить сейчас';

  @override
  String get settingsResetClose => 'Закрыть';

  @override
  String settingsFooterCombined(String version, String node) {
    return 'SKAPP $version · $node';
  }

  @override
  String get langEnglish => 'English';

  @override
  String get langTurkish => 'Türkçe';

  @override
  String get aboutTitle => 'О SmartKraft и SKAPP';

  @override
  String get aboutDevicesHeading => 'Наши устройства';

  @override
  String get aboutDevicesBody =>
      'Устройства SmartKraft создаются инновационными, самобытными и наполненными деталями, о которых другие не подумали. Наша цель — не повторять то, что уже существует, а делать то, что ещё не сделано, что осталось незавершённым. Указать на нерешённую повседневную проблему и предложить ей простой, понятный ответ; или взять то, что решено, но осталось дорогим, и заменить это DIY-версией, которую может собрать каждый.\n\nКаждое устройство SmartKraft спроектировано и собрано, чтобы дать маленький, ясный ответ на ещё не решённую проблему. Создавая устройство, мы задаём себе один вопрос: «Почему эта проблема до сих пор не решена или почему она осталась такой дорогой?»';

  @override
  String get aboutSkappRoleHeading => 'Где здесь SKAPP';

  @override
  String get aboutSkappRoleBody =>
      'SKAPP — это общее приложение для устройств SmartKraft. Это простой интерфейс для сопряжения устройства, его настройки, изменения поведения и объединения нескольких устройств в одном сценарии.\n\nSKAPP не обязателен для ваших устройств; это удобство. Любое устройство SmartKraft можно настроить так же через USB CLI без SKAPP, и этот путь остаётся открытым для тех, кто предпочитает командную строку. Для всех остальных, кому нужна скорость визуального интерфейса и удобство управления несколькими устройствами сразу, есть SKAPP.\n\nНикаких облачных аккаунтов. Никакой рекламы. Никакого сбора данных. Это тихий мост между вашим телефоном и устройством, не более того.';

  @override
  String get aboutShowcaseHeading => 'Витрина мейкеров';

  @override
  String get aboutShowcaseEmpty =>
      'Витрина пока пуста. Первое устройство SmartKraft уже в пути; файлы проектов, исходники прошивки, списки деталей и руководства по сборке появятся здесь, когда будут готовы. А пока этот раздел немногое обещает — он просто хранит место для того, что впереди.';

  @override
  String get aboutConnectHeading => 'Связаться';

  @override
  String get aboutConnectIntro =>
      'Напишите нам, посмотрите исходный код, следите за тем, как растёт проект.';

  @override
  String get aboutConnectGitHub => 'GitHub';

  @override
  String get aboutConnectWebsite => 'Веб-сайт';

  @override
  String get aboutConnectYouTube => 'YouTube';

  @override
  String get aboutConnectX => 'X';

  @override
  String get aboutConnectEmail => 'Эл. почта';

  @override
  String get aboutVersionHeading => 'Версия';

  @override
  String get licenseTitle => 'Лицензия и благодарности';

  @override
  String get licenseSmartKraftHeading => 'О SmartKraft';

  @override
  String get licenseSmartKraftBody =>
      'SmartKraft — небольшая мастерская, которая проектирует необычные, но практичные электронные инструменты для повседневной жизни. За каждым устройством, что попадает к вам в руки, стоят бесчисленные шаги: ранний набросок в блокноте, первый спаянный прототип, строки кода, написанные глубокой ночью, мелкие детали, переделанные снова и снова. Создать устройство — значит писать строки, чертить схемы, паять соединения, находить ошибки, начинать заново. Всем, кто вложил свой труд в этот процесс, не оставив на нём своего имени, спасибо — от имени SmartKraft.\n\nМы верим в культуру мейкеров, в открытый код и в ремонтопригодную, перерабатываемую электронику. Поэтому мы публикуем аппаратные проекты наших устройств как открытое железо, а их прошивки — под лицензией AGPL 3.0. Наша цель — сделать DIY-версию как можно большего числа деталей доступной.\n\nЗамечание, в котором мы хотим быть честны: ключи сопряжения и секреты связи, защищающие безопасность устройства, хранятся в исходниках закрытыми. Если бы их опубликовали, доверие между вашим устройством и приложением было бы нарушено. Это закрытие — не уступка в ущерб открытости; это решение, принятое ради вашей безопасности.\n\nДля SKAPP и каждого устройства, что с ним общается, наш принцип — прозрачность: мы хотим, чтобы вы могли читать, как всё устроено, проверять это и собирать свою версию. И всё же у каждого устройства свой раздел лицензии, и условия могут различаться. Чтобы увидеть исходники устройства, его схемы или условия использования, загляните в раздел лицензии этого устройства.\n\nСпасибо, что поддерживаете нас, пользуясь этим приложением. Мы рады, что вы здесь.';

  @override
  String get licenseOpenSourceHeading => 'Стоя на их плечах';

  @override
  String get licenseOpenSourceBody =>
      'SKAPP построен на тысячах проектов с открытым кодом, написанных до него. Сердечная благодарность команде Flutter и её участникам за то, что сделали видимый интерфейс возможным, а также всем разработчикам открытого кода, отдавшим годы сетям, хранению данных, криптографии, Bluetooth и бесчисленным подсистемам.\n\nПоскольку мы пользуемся открытым кодом, мы стараемся держать открытыми и аппаратную часть, и прошивки наших устройств, чтобы те, кто придёт после нас, могли так же воспользоваться этим трудом.\n\nЕщё раз спасибо всем, кто был частью этой работы.';

  @override
  String get licenseThirdPartyLink =>
      'Сторонние лицензии, используемые в этом приложении';

  @override
  String get discoveryTitle => 'Найти устройства';

  @override
  String get discoverySearching => 'Поиск ближайших устройств SmartKraft…';

  @override
  String get discoveryNoResults =>
      'Поблизости не найдено устройств SmartKraft.';

  @override
  String get discoveryTapToConnect => 'Нажмите на устройство для подключения';

  @override
  String get discoveryRescan => 'Сканировать снова';

  @override
  String get pairingTitle => 'Сопряжение устройства';

  @override
  String get pairingEnterPasskey =>
      'Введите код доступа, напечатанный на этикетке устройства.';

  @override
  String get pairingPasskeyHint => 'например, K7M9P2AB';

  @override
  String get pairingConnect => 'Подключить';

  @override
  String get pairingMockNotice =>
      'Прошивка устройства ещё не готова. В этой сборке сопряжение является заглушкой.';

  @override
  String get errorBluetoothPermission =>
      'Для поиска устройств требуется разрешение Bluetooth.';

  @override
  String get errorBluetoothOff => 'Bluetooth выключен.';

  @override
  String get errorLocationPermission =>
      'Для поиска устройств BLE на Android требуется разрешение геолокации.';

  @override
  String get actionOpenSettings => 'Открыть настройки';

  @override
  String get actionGrantPermission => 'Предоставить разрешение';

  @override
  String get commonCancel => 'Отмена';

  @override
  String get commonConfirm => 'Подтвердить';

  @override
  String get commonRetry => 'Повторить';

  @override
  String get commonBack => 'Назад';

  @override
  String get commonRemove => 'Удалить';

  @override
  String get commonRefresh => 'Обновить';

  @override
  String get commonOk => 'ОК';

  @override
  String get commonClose => 'Закрыть';

  @override
  String get commonSave => 'Сохранить';

  @override
  String get commonDelete => 'Удалить';

  @override
  String get commonConnect => 'Подключить';

  @override
  String get commonAdd => 'Добавить';

  @override
  String get commonForget => 'Забыть';

  @override
  String get commonMore => 'Ещё';

  @override
  String get commonError => 'Ошибка';

  @override
  String get commonOnline => 'в сети';

  @override
  String get commonOffline => 'не в сети';

  @override
  String get productBlockingFocus => 'Blocking Focus';

  @override
  String get productLebensSpur => 'LebensSpur';

  @override
  String get productGeneric => 'Устройство SmartKraft';

  @override
  String get timeJustNow => 'только что';

  @override
  String timeMinAgo(int count) {
    return '$count мин назад';
  }

  @override
  String timeHourAgo(int count) {
    return '$count ч назад';
  }

  @override
  String timeDayAgo(int count) {
    return '$count д назад';
  }

  @override
  String get devicesRemoveTitle => 'Удалить устройство';

  @override
  String devicesRemoveBody(String name) {
    return '$name будет удалено. Устройство останется подключённым; чтобы добавить его снова, потребуется повторное сопряжение.';
  }

  @override
  String get devicesUnpair => 'Разорвать сопряжение';

  @override
  String get devicesEmptyHint =>
      'Поднесите устройство SmartKraft ближе и нажмите кнопку ниже.';

  @override
  String get devicesEmptyTitleNoPaired => 'Пока нет сопряжённых устройств';

  @override
  String devicesLastSeen(String time) {
    return 'Последний раз в сети: $time';
  }

  @override
  String devicesPairedAt(String time) {
    return 'Сопряжено: $time';
  }

  @override
  String devicesHubSubtitle(int count) {
    return 'Хост SKAPP · сопряжено: $count';
  }

  @override
  String get devicesHubEmptySubtitle => 'ожидание устройства';

  @override
  String devicesHeaderSub(int paired, int online) {
    return '$paired сопряжено · $online в сети · вид созвездия';
  }

  @override
  String get devicesAddPillLabel => 'Добавить устройство';

  @override
  String devicesLegendOnline(int count) {
    return 'в сети ($count)';
  }

  @override
  String devicesLegendOffline(int count) {
    return 'не в сети ($count)';
  }

  @override
  String devicesLegendLowBattery(int count) {
    return 'низкий заряд ($count)';
  }

  @override
  String get devicesStatPaired => 'сопряжено';

  @override
  String get devicesStatBf => 'BF';

  @override
  String get devicesStatLs => 'LS';

  @override
  String get devicesStatMs => 'телефон';

  @override
  String get devicesEmptyHubLabel => 'Неизвестно';

  @override
  String get devicesEmptyAddCta => 'Добавить первое устройство';

  @override
  String get devicesEmptyHintChip => 'поднесите устройство, нажмите его кнопку';

  @override
  String devicesNotifOfflineHours(int hours) {
    return 'не в сети $hours ч назад';
  }

  @override
  String devicesNotifOfflineMinutes(int minutes) {
    return 'не в сети $minutes мин назад';
  }

  @override
  String get devicesNotifLowBattery => 'низкий заряд';

  @override
  String get skappPeersCardTitle => 'Сопряжённые настольные SKAPP';

  @override
  String get skappPeersCardSubtitle =>
      'Телефоны и планшеты сопрягаются здесь, чтобы действие BF могло запустить скрипт на настольном SKAPP. Откройте Настольный SKAPP > Настройки > HTTP-слушатель SKAPP, чтобы получить QR.';

  @override
  String get skappPeersCardEmpty => 'Пока нет сопряжённых узлов.';

  @override
  String get skappPeersCardPairButton => 'Сопрячь новый';

  @override
  String get skappPeersCardOnline => 'в сети';

  @override
  String get skappPeersCardOffline => 'не в сети';

  @override
  String get skappPeersCardNeverSeen => 'не появлялся';

  @override
  String skappPeersCardRemoveTitle(String name) {
    return 'Удалить $name?';
  }

  @override
  String get skappPeersCardRemoveBody =>
      'SKAPP перестанет отправлять скрипты этому узлу. Позже вы сможете заново выполнить сопряжение тем же QR / токеном.';

  @override
  String get skappPeersCardRemoveConfirm => 'Удалить';

  @override
  String get skappPeersCardRemoveCancel => 'Отмена';

  @override
  String skappPeersCardRemovedToast(String name) {
    return 'Сопряжение с $name разорвано';
  }

  @override
  String get devicesCardLongPressHint => 'Долгое нажатие для управления';

  @override
  String devicesActionsSheetTitle(String name) {
    return '$name';
  }

  @override
  String get devicesActionForget => 'Забыть устройство';

  @override
  String get devicesActionForgetSubtitle =>
      'Удалить это устройство из SKAPP. Само устройство не затрагивается; вы сможете сопрячь его снова позже.';

  @override
  String get devicesActionCancel => 'Отмена';

  @override
  String devicesForgetDialogTitle(String name) {
    return 'Забыть $name?';
  }

  @override
  String get devicesForgetDialogBody =>
      'SKAPP перестанет отслеживать это устройство. Сопряжение на стороне устройства сохраняется, пока вы не сбросите его с устройства.';

  @override
  String devicesForgetDialogBodyWithActions(int count) {
    return 'SKAPP перестанет отслеживать это устройство и удалит привязанные к нему действия SKAPI: $count. Сопряжение на стороне устройства сохраняется, пока вы не сбросите его с устройства.';
  }

  @override
  String get devicesForgetDialogConfirm => 'Забыть';

  @override
  String get devicesForgetDialogCancel => 'Отмена';

  @override
  String devicesForgotToast(String name) {
    return '$name удалено из SKAPP';
  }

  @override
  String get devicesMobileNoDetailHint =>
      'Для телефонов нет страницы сведений · долгое нажатие, чтобы разорвать сопряжение';

  @override
  String get devicesDesktopStatLabel => 'ПК';

  @override
  String get devicesDesktopGroupLabel => 'Сопряжённые ПК';

  @override
  String get devicesDesktopTriggerDialogTitle => 'Отправить команду SKAPI?';

  @override
  String devicesDesktopTriggerDialogBody(String name) {
    return 'Все привязки к мобильным касаниям на $name будут выполнены.';
  }

  @override
  String get devicesDesktopTriggerDialogConfirm => 'Отправить команду';

  @override
  String get devicesDesktopTriggerDialogCancel => 'Отмена';

  @override
  String get devicesDesktopForgetDialogTitle => 'Разорвать сопряжение';

  @override
  String devicesDesktopForgetDialogBody(String name) {
    return 'Разрыв сопряжения с $name. Чтобы снова отправлять команды этому ПК, потребуется повторное сопряжение.';
  }

  @override
  String devicesDesktopForgotToast(String name) {
    return 'Сопряжение с $name разорвано';
  }

  @override
  String get homeStatDevices => 'Устройства';

  @override
  String get homeStatOnline => 'В сети';

  @override
  String get homeStatWarning => 'Предупреждение';

  @override
  String homeWarningMeta(String time) {
    return 'Сопряжено, но ни разу не появлялось · $time';
  }

  @override
  String get homeBrandTotal => 'Всего';

  @override
  String get homeBrandActive => 'Активно';

  @override
  String get homeBrandActions => 'Действия';

  @override
  String get homeBrandVersion => 'Версия';

  @override
  String get smartkraftSectionProducts => 'Продукты';

  @override
  String get smartkraftSectionCommunity => 'Сообщество';

  @override
  String get smartkraftStatusLive => 'ДОСТУПНО';

  @override
  String get smartkraftStatusDev => 'В РАЗРАБОТКЕ';

  @override
  String get smartkraftStatusConcept => 'КОНЦЕПТ';

  @override
  String get smartkraftBlockingFocusTagline =>
      'Перерыв, который нельзя пропустить.';

  @override
  String get smartkraftLebensSpurTagline => 'Тихий свидетель ваших привычек.';

  @override
  String get smartkraftSynDimmTagline => 'Нужный свет в нужный час.';

  @override
  String homeStickyDevicesMeta(int count, int warning) {
    return '$count устройств · $warning оповещений';
  }

  @override
  String homeStickySkapiMeta(int actions) {
    return '$actions действий';
  }

  @override
  String homeStickySettingsMeta(String node, String version) {
    return '$node · v$version';
  }

  @override
  String get homeStickyComingSoonMeta => 'контент в работе';

  @override
  String get homeStickyNotesLabel => 'Заметки';

  @override
  String get setupChoiceTitle => 'Добавить устройство';

  @override
  String get setupChoiceQuestion => 'С чего начнём?';

  @override
  String get setupChoiceSubtitle =>
      'Устройство только из коробки или его уже настраивали через CLI?';

  @override
  String get setupChoiceFreshTitle => 'Новая настройка';

  @override
  String get setupChoiceFreshBody =>
      'Я добавляю новое устройство SmartKraft впервые. Сопряжение пройдёт по BLE, и откроется мастер настройки Wi-Fi.';

  @override
  String get setupChoiceExistingTitle => 'Добавить уже настроенное устройство';

  @override
  String get setupChoiceExistingBody =>
      'Я настроил Wi-Fi устройства через USB/CLI и нахожусь в той же сети. Сопрячь напрямую по Wi-Fi, минуя мастер.';

  @override
  String get setupChoiceFooter =>
      'Если сомневаетесь, выберите «Новая настройка» — это верный путь и для первого сопряжения, и для устройств после сброса к заводским настройкам.';

  @override
  String get wifiDiscoveryTitle => 'Устройства в этой сети';

  @override
  String wifiDiscoveryScanError(String error) {
    return 'Ошибка сканирования: $error';
  }

  @override
  String get wifiDiscoveryHint =>
      'Устройство должно быть в сети Wi-Fi, а телефон — в той же сети. Во время сопряжения вас попросят нажать кнопку устройства.';

  @override
  String get wifiDiscoveryScanning => 'Сканирование…';

  @override
  String get wifiDiscoveryNotFound => 'Устройства не найдены';

  @override
  String wifiDiscoveryFoundCount(int count) {
    return 'Найдено устройств: $count';
  }

  @override
  String get wifiDiscoveryEmptyTitle =>
      'Поиск устройств SmartKraft в этой сети…';

  @override
  String get wifiDiscoveryEmptyTitleIdle => 'Устройства не найдены.';

  @override
  String get wifiDiscoveryEmptyHint =>
      'Убедитесь, что устройство включено, подключено к Wi-Fi и находится в той же сети, что и телефон. Нажмите кнопку обновления, чтобы повторить.';

  @override
  String get wifiDiscoveryPairedBadge => 'сопряжено';

  @override
  String get wifiPairingTitle => 'Сопряжение';

  @override
  String wifiPairingConnectFailed(String error) {
    return 'Не удалось подключиться: $error';
  }

  @override
  String wifiPairingInvalidJson(String error) {
    return 'Некорректный JSON: $error';
  }

  @override
  String get wifiPairingClosedEarly => 'Соединение закрыто (нет ответа)';

  @override
  String wifiPairingSendFailed(String error) {
    return 'Не удалось отправить команду: $error';
  }

  @override
  String get wifiPairingTimeout => 'Устройство не ответило (тайм-аут).';

  @override
  String get wifiPairingNotOpen =>
      'Окно сопряжения на устройстве не открыто. Коротко нажмите кнопку и повторите.';

  @override
  String get skapiBindFixedTriggerLabel => 'Триггер: по истечении таймера';

  @override
  String get wifiPairingDeviceAlreadyBonded =>
      'Это устройство уже сопряжено с другим SKAPP. Добавление нового узла по Wi-Fi не поддерживается текущей прошивкой (TCP принимает только первое сопряжение). Используйте сопряжение по BLE или разорвите сопряжение существующего узла на устройстве.';

  @override
  String wifiPairingRejected(String error) {
    return 'Устройство отклонило: $error';
  }

  @override
  String get wifiPairingMissingPub =>
      'Отсутствует/повреждён our_pub от устройства.';

  @override
  String wifiPairingHexError(String error) {
    return 'Ошибка hex-декодирования our_pub: $error';
  }

  @override
  String get wifiPairingStageAwaiting => 'Нажмите кнопку на устройстве';

  @override
  String get wifiPairingStageConnecting => 'Подключение к устройству…';

  @override
  String get wifiPairingStageExchanging => 'Обмен ключами…';

  @override
  String get wifiPairingStageDone => 'Сопряжение завершено';

  @override
  String get wifiPairingStageFailed => 'Сопряжение не удалось';

  @override
  String get wifiPairingStageAwaitingHelp =>
      'Коротко нажмите кнопку управления устройства (менее 3 секунд). Окно сопряжения остаётся открытым 60 секунд.';

  @override
  String get wifiPairingStageConnectingHelp => 'Открытие TCP-сокета.';

  @override
  String get wifiPairingStageExchangingHelp =>
      'pairing.ecdh.exchange отправлен, ожидание ответа устройства.';

  @override
  String get wifiPairingStageDoneHelp => 'Переход на панель устройства.';

  @override
  String get wifiPairingStartCta => 'Сопрячь';

  @override
  String get bfDashboardTitleFallback => 'Устройство';

  @override
  String get bfDashboardWifiNone => 'Нет Wi-Fi';

  @override
  String get bfDashboardLinkBle => 'BLE';

  @override
  String get bfDashboardLinkWifi => 'Wi-Fi';

  @override
  String get bfDashboardLinkUsb => 'USB';

  @override
  String get bfDashboardToggleVibration => 'Вибрация';

  @override
  String get bfDashboardToggleTilt => 'Оповещение о наклоне';

  @override
  String get bfDashboardToggleLowBatt => 'Оповещение о низком заряде';

  @override
  String get bfDashboardApiChainTitle => 'Цепочка API';

  @override
  String bfDashboardApiChainNone(String state) {
    return 'пока нет конечных точек · мастер $state';
  }

  @override
  String bfDashboardApiChainSummary(int count, String state) {
    return 'конечных точек: $count · мастер $state';
  }

  @override
  String get bfDashboardMasterOn => 'вкл';

  @override
  String get bfDashboardMasterOff => 'выкл';

  @override
  String get bfDashboardNotebookTitle => 'Блокнот пользователя';

  @override
  String get bfDashboardNotebookSubtitle =>
      'Зашифрованная область · 100 КБ · произвольное содержимое';

  @override
  String get bfDashboardMoreDeviceInfo => 'Сведения об устройстве';

  @override
  String get bfDashboardMoreSettings => 'Настройки';

  @override
  String bfDashboardWriteFailed(String error) {
    return 'Не удалось записать: $error';
  }

  @override
  String get bfDeviceInfoTitle => 'Сведения об устройстве';

  @override
  String get bfDeviceInfoSectionGeneral => 'ОБЩЕЕ';

  @override
  String get bfDeviceInfoSectionConnection => 'ПОДКЛЮЧЕНИЕ';

  @override
  String get bfDeviceInfoSectionBattery => 'БАТАРЕЯ';

  @override
  String get bfDeviceInfoSectionTime => 'ВРЕМЯ';

  @override
  String get bfDeviceInfoSectionLastError => 'ПОСЛЕДНЯЯ ОШИБКА';

  @override
  String get bfDeviceInfoSectionDiagnostics => 'ДИАГНОСТИКА';

  @override
  String get bfDeviceInfoSectionDocs => 'ДОКУМЕНТАЦИЯ';

  @override
  String get bfDeviceInfoProduct => 'Продукт';

  @override
  String get bfDeviceInfoTypeCode => 'Код типа';

  @override
  String get bfDeviceInfoIdentity => 'Идентификация';

  @override
  String get bfDeviceInfoHardware => 'Аппаратное обеспечение';

  @override
  String get bfDeviceInfoFirmware => 'Прошивка';

  @override
  String get bfDeviceInfoProtocol => 'Протокол';

  @override
  String get bfDeviceInfoBuild => 'Сборка';

  @override
  String get bfDeviceInfoUptime => 'Время работы';

  @override
  String get bfDeviceInfoWifiState => 'Состояние Wi-Fi';

  @override
  String get bfDeviceInfoIp => 'IP';

  @override
  String get bfDeviceInfoSignal => 'Сигнал';

  @override
  String get bfDeviceInfoBleAdvertising => 'Вещание BLE';

  @override
  String get bfDeviceInfoBlePaired => 'Сопряжения BLE';

  @override
  String bfDeviceInfoPairedClients(int count) {
    return 'клиентов: $count';
  }

  @override
  String get bfDeviceInfoBattery => 'Батарея';

  @override
  String get bfDeviceInfoBatteryPresent => 'есть';

  @override
  String get bfDeviceInfoBatteryAbsent => 'нет';

  @override
  String get bfDeviceInfoDeviceClock => 'Часы устройства';

  @override
  String get bfDeviceInfoLogs => 'Журналы устройства';

  @override
  String get bfDeviceInfoLogsSubtitle =>
      'logs.get, загрузка, ошибки, таймер, события API';

  @override
  String get bfDeviceInfoEvents => 'История событий';

  @override
  String get bfDeviceInfoEventsSubtitle =>
      'Локально · таймер, смена грани, API-триггеры';

  @override
  String get bfDeviceInfoUserGuide => 'Руководство пользователя';

  @override
  String get bfDeviceInfoUserGuideSubtitle =>
      'Назначение граней, таймер, API-триггеры';

  @override
  String get bfDeviceInfoDevNotes => 'Заметки разработчика SK';

  @override
  String get bfDeviceInfoDevNotesSubtitle =>
      'Команды CLI, архитектура, классификация событий';

  @override
  String get bfDeviceInfoLicense => 'Лицензия и открытые исходники';

  @override
  String get bfDeviceInfoLicenseSubtitle =>
      'Используемые библиотеки и сведения об авторских правах';

  @override
  String get bfDeviceInfoComingSoon => 'Скоро';

  @override
  String bfDeviceInfoUptimeSecs(int n) {
    return '$n с';
  }

  @override
  String bfDeviceInfoUptimeMins(int n) {
    return '$n мин';
  }

  @override
  String bfDeviceInfoUptimeHours(int h, int m) {
    return '$h ч $m мин';
  }

  @override
  String bfDeviceInfoUptimeDays(int d, int h) {
    return '$d д $h ч';
  }

  @override
  String get bfDeviceInfoYes => 'да';

  @override
  String get bfDeviceInfoNo => 'нет';

  @override
  String get bfSettingsTitle => 'Настройки';

  @override
  String get bfSettingsSectionNetwork => 'СЕТЬ';

  @override
  String get bfSettingsSectionUpdates => 'ОБНОВЛЕНИЯ';

  @override
  String get bfSettingsSectionDanger => 'ОПАСНАЯ ЗОНА';

  @override
  String get bfSettingsWifiPrimary => 'Основной Wi-Fi';

  @override
  String get bfSettingsWifiSecondary => 'Резервный Wi-Fi';

  @override
  String get bfSettingsWifiUnconfigured => 'Не настроено';

  @override
  String get bfSettingsFirmware => 'Прошивка';

  @override
  String get bfSettingsCheckUpdates => 'Проверить обновления';

  @override
  String get bfSettingsCheckUpdatesSubtitle =>
      'Активируется после указания URL манифеста';

  @override
  String get bfOtaTitle => 'Обновление прошивки';

  @override
  String get bfOtaCurrentLabel => 'Установленная версия';

  @override
  String get bfOtaRunningPartitionLabel => 'Активный раздел';

  @override
  String get bfOtaCheckCta => 'Проверить обновления';

  @override
  String get bfOtaIdleHint => 'Проверка обновлений ещё не выполнялась.';

  @override
  String get bfOtaChecking => 'Проверка сервера обновлений…';

  @override
  String get bfOtaUpToDate => 'Устройство обновлено до последней версии.';

  @override
  String bfOtaAvailable(String version) {
    return 'Доступна новая версия: $version';
  }

  @override
  String get bfOtaUpdateCta => 'Обновить сейчас';

  @override
  String bfOtaDownloading(int pct) {
    return 'Загрузка… %$pct';
  }

  @override
  String get bfOtaDone => 'Обновлено. Устройство перезагружается…';

  @override
  String bfOtaErrorMsg(String message) {
    return 'Ошибка: $message';
  }

  @override
  String get bfOtaRollbackCta => 'Откатить до предыдущей версии';

  @override
  String get bfOtaUpdateConfirmTitle => 'Установить обновление прошивки?';

  @override
  String bfOtaUpdateConfirmBody(String version) {
    return 'Версия $version будет загружена и установлена, затем устройство перезагрузится. Не отключайте питание во время обновления.';
  }

  @override
  String get bfOtaRollbackConfirmTitle => 'Откатить прошивку?';

  @override
  String get bfOtaRollbackConfirmBody =>
      'Устройство загрузит предыдущую прошивку и перезапустится.';

  @override
  String get bfSettingsReboot => 'Перезапустить устройство';

  @override
  String get bfSettingsRebootSubtitle =>
      'Перезагружает устройство · отменяет любой активный таймер';

  @override
  String get bfSettingsRebootConfirmTitle => 'Перезапустить устройство?';

  @override
  String get bfSettingsRebootConfirmBody =>
      'Устройство выключится и снова включится через несколько секунд.';

  @override
  String get bfSettingsUnpairThisPhone => 'Отвязать этот телефон';

  @override
  String get bfSettingsUnpairSubtitle =>
      'Удаляет привязку · устройство потребуется сопрячь заново';

  @override
  String get bfSettingsUnpairConfirmTitle => 'Отвязать этот телефон?';

  @override
  String get bfSettingsFactoryReset => 'Сброс к заводским настройкам';

  @override
  String get bfSettingsFactoryResetSubtitle =>
      'Стирает Wi-Fi, конечные точки API и сопряжения';

  @override
  String get bfSettingsFactoryResetConfirmTitle =>
      'Сброс к заводским настройкам?';

  @override
  String get bfSettingsFactoryResetConfirmBody =>
      'Все настройки будут очищены. Устройство перезагрузится.';

  @override
  String get bfWifiManagementTitle => 'Управление Wi-Fi';

  @override
  String get bfWifiConnecting => 'Подключение…';

  @override
  String bfWifiConnectionRejected(String error) {
    return 'Подключение отклонено: $error';
  }

  @override
  String bfWifiConfigure(String label) {
    return 'Настроить $label';
  }

  @override
  String get bfWifiPasswordLabel => 'Пароль';

  @override
  String get bfNotebookTitle => 'Блокнот пользователя';

  @override
  String get bfNotebookSaveCancel => 'Отмена';

  @override
  String get bfApiChainCancel => 'Отмена';

  @override
  String get bfApiChainRunChain => 'Запустить цепочку';

  @override
  String get bfApiChainToggleAll => 'Включить/выключить все';

  @override
  String get bfApiChainFieldName => 'Имя';

  @override
  String get bfApiChainFieldType => 'Тип';

  @override
  String get bfApiChainFieldHeaderName => 'Имя заголовка';

  @override
  String get bfApiChainFieldNewToken =>
      'Новый токен (оставьте пустым, чтобы сохранить)';

  @override
  String get bfHomeLoadingConnecting => 'Подключение к устройству…';

  @override
  String get bfHomeLoadingSecure => 'Открытие защищённого канала…';

  @override
  String get deviceConnUnreachableTitle => 'Не удаётся связаться с устройством';

  @override
  String get deviceConnUnreachableBody =>
      'Устройство может быть выключено, вне зоны действия или в спящем режиме. Убедитесь, что оно включено и находится рядом, затем повторите попытку.';

  @override
  String get deviceConnRepairTitle => 'Сопряжение нужно обновить';

  @override
  String get deviceConnRepairBody =>
      'Похоже, устройство было сброшено и больше не распознаёт этот телефон. Сопрягите его заново, чтобы восстановить связь.';

  @override
  String get deviceConnRepairButton => 'Сопрячь снова';

  @override
  String get deviceConnTechnicalDetails => 'Технические подробности';

  @override
  String get bfLogsTitle => 'Журналы устройства';

  @override
  String get bfEventsTitle => 'История событий';

  @override
  String get pairingStepConnecting => 'Подключение';

  @override
  String get pairingStepConnectingSubtitle => 'BLE-связь + обнаружение GATT';

  @override
  String get pairingStepMutualAuth => 'Взаимная аутентификация';

  @override
  String get pairingStepDeviceInfo => 'Проверка device.info';

  @override
  String get pairingStepDeviceInfoSubtitle =>
      'Зашифрованный канал поднят, проверочный пинг';

  @override
  String get pairingStepConnected => 'Соединение установлено';

  @override
  String get pairingStepConnectedSubtitle => 'CLI готов, переход к настройке';

  @override
  String get pairingStepKeyExchange => 'Обмен ключами';

  @override
  String get pairingStepKeyExchangeSubtitle =>
      'X25519, открытый ключ отправлен';

  @override
  String get pairingStepVerifying => 'Проверка';

  @override
  String get pairingStepVerifyingSubtitle =>
      'Ожидание устройства, вывод токена';

  @override
  String get pairingStepDone => 'Сопряжение завершено';

  @override
  String get pairingStepDoneSubtitle =>
      'Привязка сохранена на устройстве и телефоне';

  @override
  String get pairingLogTitle => 'Журнал сопряжения';

  @override
  String get pairingLogCopied => 'Журнал скопирован в буфер обмена';

  @override
  String get discoveryPreparing => 'Подготовка…';

  @override
  String get discoveryBluetoothOff => 'Bluetooth выключен';

  @override
  String get wifiPasswordTitle => 'Подключить устройство к Wi-Fi';

  @override
  String get wifiPasswordSsidLabel => 'Имя сети (SSID)';

  @override
  String get wifiPasswordNetworkLabel => 'Сеть';

  @override
  String get wifiPasswordPasswordLabel => 'Пароль';

  @override
  String get wifiPasswordConnect => 'Подключить';

  @override
  String get wifiPasswordLogTitle => 'Журнал подключения';

  @override
  String get wifiPasswordLogCopied => 'Журнал скопирован в буфер обмена';

  @override
  String get wifiScanTitle => 'Выберите сеть Wi-Fi для устройства';

  @override
  String get wifiScanRescanTooltip => 'Попросить устройство сканировать снова';

  @override
  String get wifiScanRunning => 'Сканер Wi-Fi устройства работает…';

  @override
  String get wifiScanNoNetworks => 'Устройство не нашло ближайших сетей Wi-Fi.';

  @override
  String get wifiScanRescan => 'Попросить устройство сканировать снова';

  @override
  String get wifiScanHiddenAdd => 'Добавить скрытую сеть';

  @override
  String get wifiScanHiddenSubtitle => 'Введите SSID вручную';

  @override
  String get wifiScanLogTitle => 'Журнал сканирования Wi-Fi';

  @override
  String get wifiSuccessReady => 'Готово';

  @override
  String get bfEventsClearTooltip => 'Очистить';

  @override
  String get bfEventsEmpty =>
      'Пока нет событий. Они появятся здесь, как только устройство начнёт их публиковать.';

  @override
  String get logsEmptyTooltip => 'Журнал пуст.';

  @override
  String logsErrorPrefix(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get notebookSaved => 'Сохранено';

  @override
  String notebookSaveError(String error) {
    return 'Ошибка: $error';
  }

  @override
  String notebookCapacityExceeded(int used, int capacity) {
    return 'Превышена ёмкость: $used / $capacity байт';
  }

  @override
  String get notebookClearTooltip => 'Очистить блокнот';

  @override
  String get notebookClearConfirmTitle => 'Очистить весь блокнот?';

  @override
  String get notebookClearConfirmBody =>
      'Все пользовательские данные на устройстве будут стёрты. Это нельзя отменить.';

  @override
  String get notebookClearAction => 'Очистить';

  @override
  String get notebookClearedSnack => 'Блокнот очищен';

  @override
  String notebookClearError(String error) {
    return 'Не удалось очистить: $error';
  }

  @override
  String get notebookEncryptedHint =>
      'Зашифрованная область · читать может только сопряжённый SKAPP';

  @override
  String get notebookEmptyTitle => 'Блокнот пуст';

  @override
  String get notebookEmptyBody =>
      'Введите ниже заметки, JSON, описания сцен или любой другой текст. По нажатию «Сохранить» он сохраняется на устройстве в зашифрованном виде.';

  @override
  String get notebookHint =>
      'Введите здесь что угодно (заметки, JSON, свою схему). На устройстве хранится до 100 КБ.';

  @override
  String get notebookDirty => 'Несохранённые изменения';

  @override
  String get notebookSaved2 => 'Сохранено';

  @override
  String get notebookSyncedDifferent => 'Синхронизировано';

  @override
  String get notebookSaveCta => 'Сохранить';

  @override
  String wifiPairingHexErrorRaw(String error) {
    return 'Ошибка hex-декодирования our_pub: $error';
  }

  @override
  String get bfWifiForgetTitle => 'Забыть слот?';

  @override
  String get bfWifiForgetBody =>
      'Слот будет очищен. Если устройство сейчас подключено через него, оно переключится на другой слот (если есть). Для восстановления потребуется повторная настройка.';

  @override
  String get bfWifiForget => 'Забыть';

  @override
  String get bfWifiHint =>
      'Устройство пробует две сети по очереди: сначала основную, затем резервную, если основная недоступна. Активный слот отмечен зелёной точкой.';

  @override
  String get bfWifiActive => 'АКТИВНО';

  @override
  String get bfWifiNotConfigured => 'Не настроено';

  @override
  String get bfWifiChange => 'Изменить';

  @override
  String get bfWifiSetUp => 'Настроить';

  @override
  String get discoveryStatusChecking => 'Проверка состояния Bluetooth.';

  @override
  String get discoveryPermissionsTitle => 'Требуется разрешение Bluetooth';

  @override
  String get discoveryPermissionsBody =>
      'Чтобы найти ближайшие устройства SmartKraft, включите разрешение Bluetooth.';

  @override
  String get discoveryPermissionsRetry => 'Запросить разрешения снова';

  @override
  String get discoveryPermissionsOpenSettings => 'Открыть настройки';

  @override
  String get discoveryAdapterOffBody =>
      'Включите Bluetooth для поиска устройств.';

  @override
  String get discoveryAdapterOffEnable => 'Включить Bluetooth';

  @override
  String get discoveryUnsupportedTitle => 'BLE не поддерживается';

  @override
  String get discoveryUnsupportedBody =>
      'Это устройство не поддерживает Bluetooth Low Energy, а SKAPP нужен BLE для работы.';

  @override
  String get wifiPasswordHelp =>
      'Устройство подключится к этой сети. Введите пароль, внимательно набирая его.';

  @override
  String get wifiPasswordRequired => 'Требуется пароль';

  @override
  String get wifiPasswordMinLength => 'Не менее 8 символов';

  @override
  String wifiPasswordSendError(String error) {
    return 'Не удалось отправить: $error';
  }

  @override
  String get wifiScanTimeoutHint =>
      'Если сканирование длится слишком долго, устройство могло потерять связь по Wi-Fi. Нажмите «Повторить».';

  @override
  String get wifiScanFailedTitle => 'Сканирование не удалось';

  @override
  String get wifiScanRetry => 'Повторить';

  @override
  String get wifiSuccessTitle => 'Подключено';

  @override
  String get wifiSuccessBody =>
      'Устройство теперь в сети Wi-Fi. Возврат на панель…';

  @override
  String get deviceNameSectionHeading =>
      'ИМЯ УСТРОЙСТВА (ТОЛЬКО В ЭТОМ ПРИЛОЖЕНИИ)';

  @override
  String get deviceNameLabel => 'Своё имя';

  @override
  String get deviceNameHint => 'например, Офисный BF';

  @override
  String get deviceNameSubtitle =>
      'Показывается на карточках в этой установке SKAPP. На устройство не передаётся.';

  @override
  String get deviceNameClear => 'Очистить';

  @override
  String get deviceNameSave => 'Сохранить';

  @override
  String get deviceNameSaved => 'Сохранено';

  @override
  String get deviceNameEmptyPlaceholder => '(нет своего имени)';

  @override
  String get settingsUsbConsoleTitle => 'USB CLI-консоль';

  @override
  String get settingsUsbConsoleSubtitle =>
      'Отправляйте необработанные команды устройству, подключённому по USB';

  @override
  String get usbConsoleAppBarTitle => 'USB-консоль';

  @override
  String get usbConsolePickPortTitle => 'Выберите порт';

  @override
  String get usbConsolePickPortHint =>
      'Подключите устройство SmartKraft по USB и нажмите «Обновить»';

  @override
  String get usbConsolePortRefreshTooltip => 'Обновить порты';

  @override
  String get usbConsoleBfBadge => 'SmartKraft';

  @override
  String get usbConsoleConnecting => 'Подключение…';

  @override
  String get usbConsoleConnected => 'Подключено';

  @override
  String get usbConsoleDisconnected => 'Отключено';

  @override
  String usbConsoleErrorBanner(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get usbConsoleReconnect => 'Переподключить';

  @override
  String get usbConsoleDisconnect => 'Отключить';

  @override
  String get usbConsoleClear => 'Очистить консоль';

  @override
  String get usbConsoleInputHint => 'Введите команду, например device.info';

  @override
  String get usbConsoleSend => 'Отправить';

  @override
  String get usbConsoleEmptyHint =>
      'Введите команду и нажмите Enter, попробуйте device.info';

  @override
  String get usbConsoleEntryEvent => 'evt';

  @override
  String get usbConsoleEntryError => 'ошибка';

  @override
  String get usbConsoleNotSupportedIos =>
      'USB-консоль не поддерживается на iOS';

  @override
  String get passphraseFieldLabel => 'Парольная фраза';

  @override
  String get passphraseVerifyButton => 'Проверить';

  @override
  String passphraseAttemptsLeft(int count) {
    return 'Осталось попыток: $count';
  }

  @override
  String get passphraseLockoutTriggered =>
      'Слишком много неверных попыток ввода парольной фразы; устройство выполнило сброс к заводским настройкам.';

  @override
  String get bondPeerUnnamed => '(без имени)';

  @override
  String get pairingPassphraseDialogTitle => 'Парольная фраза устройства';

  @override
  String get pairingPassphraseDialogBody =>
      'Это устройство требует парольную фразу для доступа к содержимому. Введите её, чтобы завершить сопряжение.';

  @override
  String get pairingPassphraseCancelled =>
      'Парольная фраза не введена, сопряжение отменено.';

  @override
  String pairingPassphraseSendError(String error) {
    return 'Не удалось отправить парольную фразу: $error';
  }

  @override
  String get pairingPassphraseTimeout =>
      'Устройство не ответило (проверка парольной фразы, 8 с).';

  @override
  String get pairingWindowClosedRetry =>
      'Окно сопряжения закрыто, коротко нажмите кнопку и повторите.';

  @override
  String pairingPassphraseFailed(String error) {
    return 'Не удалось проверить парольную фразу: $error';
  }

  @override
  String get bondStoreFullHeader =>
      'Все 8 слотов привязки заняты. Удалите существующий узел, чтобы сопрячь новый SKAPP:';

  @override
  String bondStoreFullPeerLine(Object slot, String name, String shortPid) {
    return '  • слот $slot, $name [#$shortPid]';
  }

  @override
  String get bondStoreFullFooter =>
      'С другого сопряжённого SKAPP или по USB выполните\n`bond.remove --slot N`, затем нажмите «Повторить» здесь.';

  @override
  String get passphraseGateDialogBody =>
      'Это устройство запрашивает парольную фразу при каждом подключении. Введите её для доступа к содержимому.';

  @override
  String get passphraseGateCancelled =>
      'Парольная фраза не введена, для доступа к этому экрану требуется проверка.';

  @override
  String passphraseGateVerifyError(String error) {
    return 'Ошибка проверки: $error';
  }

  @override
  String passphraseGateCommError(String error) {
    return 'Ошибка связи: $error';
  }

  @override
  String get passphraseGateUnknownError => 'Неизвестная ошибка блокировки.';

  @override
  String get bfPassphraseTitle => 'Парольная фраза устройства';

  @override
  String get bfPassphraseSetTitle => 'Задать парольную фразу';

  @override
  String get bfPassphraseChangeTitle => 'Изменить парольную фразу';

  @override
  String get bfPassphraseClearTitle => 'Удалить парольную фразу';

  @override
  String get bfPassphraseChangeSubtitle =>
      'Введите старую парольную фразу, задайте новую';

  @override
  String get bfPassphraseClearSubtitle =>
      'Сбросить блокировку содержимого на устройстве';

  @override
  String get bfPassphraseModePairing => 'Запрашивать при сопряжении';

  @override
  String get bfPassphraseModePairingSubtitle =>
      'Запрашивается при сопряжении нового SKAPP. У существующих узлов не запрашивается.';

  @override
  String get bfPassphraseModeAlways => 'Запрашивать при каждом подключении';

  @override
  String get bfPassphraseModeAlwaysSubtitle =>
      'Запрашивается при каждом открытии сеанса. Содержимое остаётся заблокированным, даже если SKAPP украдут.';

  @override
  String get bfPassphraseStatusNone =>
      'Нет парольной фразы, у устройства нет блокировки содержимого';

  @override
  String get bfPassphraseStatusActiveOff =>
      'Парольная фраза задана · применение отключено (оба переключателя выключены)';

  @override
  String get bfPassphraseStatusActivePairing => 'Запрашивается при сопряжении';

  @override
  String get bfPassphraseStatusActiveAlways =>
      'Запрашивается при каждом подключении';

  @override
  String get bfPassphraseBadgeActive => 'Парольная фраза активна';

  @override
  String get bfPassphraseBadgeNone => 'Нет парольной фразы';

  @override
  String bfPassphraseAttemptsRatio(int left, int total) {
    return 'Осталось попыток: $left / $total';
  }

  @override
  String bfPassphraseLengthSubtitle(int min, int max) {
    return 'Длина $min-$max символов';
  }

  @override
  String bfPassphraseLengthHint(int min, int max) {
    return 'Длина: $min-$max';
  }

  @override
  String bfPassphraseTooShort(int min) {
    return 'Не менее $min символов';
  }

  @override
  String bfPassphraseTooLong(int max) {
    return 'Не более $max символов';
  }

  @override
  String get bfPassphraseEmpty => 'Не может быть пустым';

  @override
  String get bfPassphraseNewLabel => 'Новая парольная фраза';

  @override
  String get bfPassphraseCurrentLabel => 'Текущая парольная фраза';

  @override
  String get bfPassphraseSetDone => 'Парольная фраза задана';

  @override
  String get bfPassphraseChangeDone => 'Парольная фраза изменена';

  @override
  String get bfPassphraseClearDone => 'Парольная фраза удалена';

  @override
  String bfPassphraseStatusReadError(String error) {
    return 'Не удалось прочитать состояние: $error';
  }

  @override
  String get bfPassphraseNotesTitle => 'Примечания';

  @override
  String get bfPassphraseNotesBody =>
      '• Парольная фраза хешируется на устройстве с помощью PBKDF2-SHA256; она никогда не хранится в открытом виде.\n• 10 неверных попыток приводят к сбросу устройства к заводским настройкам; все привязки и данные стираются.\n• Для устройства, подключённого по USB, запрос парольной фразы пропускается — физический доступ и так позволяет выполнить сброс к заводским настройкам кнопкой.';

  @override
  String bfBondListTitle(int used, int capacity) {
    return 'Сопряжённые SKAPP  ($used/$capacity)';
  }

  @override
  String get bfBondListEmpty => 'Пока нет сопряжённых узлов.';

  @override
  String get bfBondListBadgeThisPhone => 'Этот телефон';

  @override
  String get bfBondListBadgeActiveSession => 'Активный сеанс';

  @override
  String bfBondListRowSubtitle(String shortPid, String date) {
    return '#$shortPid · сопряжено: $date';
  }

  @override
  String get bfBondListRemoveTooltip => 'Удалить этот узел';

  @override
  String get bfBondListRemoveTitle => 'Удалить узел?';

  @override
  String get bfBondListRemoveSelfBody =>
      'Вы удаляете привязку этого телефона. Если подтвердите, сеанс прервётся; чтобы снова связаться с устройством, потребуется коротко нажать кнопку и заново выполнить сопряжение.';

  @override
  String bfBondListRemoveOtherBody(String label, int slot) {
    return '«$label» (слот $slot) удаляется с устройства. Этому SKAPP потребуется коротко нажать кнопку и заново сопрячься для восстановления связи.';
  }

  @override
  String bfBondListSlotRemoved(int slot) {
    return 'Слот $slot удалён';
  }

  @override
  String bfBondListFetchError(String error) {
    return 'Сбой bond.list: $error';
  }

  @override
  String get bfSettingsSectionSecurity => 'БЕЗОПАСНОСТЬ';

  @override
  String get bfSettingsPassphraseTitle => 'Парольная фраза устройства';

  @override
  String get bfSettingsBondListTitle => 'Сопряжённые SKAPP';

  @override
  String get bfSettingsPassphraseSubtitleAlways =>
      'Активна, при каждом подключении';

  @override
  String get bfSettingsPassphraseSubtitlePairing => 'Активна, при сопряжении';

  @override
  String get bfSettingsPassphraseSubtitleOff => 'Активна, применение отключено';

  @override
  String bfSettingsBondsSubtitle(int count, int capacity) {
    return 'Сопряжённых узлов: $count / $capacity';
  }

  @override
  String get skapiHowItWorksTitle => 'Как это работает';

  @override
  String skapiHowItWorksBody(String deviceName) {
    return 'Когда ваше устройство SmartKraft (например, $deviceName) сталкивается с событием — окончание таймера, нажатие кнопки или срабатывание датчика — оно отправляет небольшую команду на ваш компьютер. Компьютер получает эту команду и выполняет выбранный вами скрипт.';
  }

  @override
  String get skapiHowItWorksFlowDeviceLabel => 'Устройство SmartKraft';

  @override
  String get skapiHowItWorksFlowDeviceSub =>
      'например, Blocking Focus, инициирует событие';

  @override
  String get skapiHowItWorksFlowComputerLabel => 'Компьютер';

  @override
  String get skapiHowItWorksFlowComputerSub =>
      'SKAPP получает команду, скрипт выполняется';

  @override
  String get skapiHowItWorksFoot =>
      'SKAPP должен быть запущен на вашем компьютере. Весь трафик остаётся в сети Wi-Fi, подключение к интернету не требуется, и никакие данные не покидают ваш дом.';

  @override
  String get skapiPlatformGroupsHeader => 'Категории действий';

  @override
  String skapiPlatformGroupsLoadError(String error) {
    return 'Не удалось загрузить группы: $error';
  }

  @override
  String get skapiPlatformEmptyTitle => 'Здесь пока нет скриптов';

  @override
  String get skapiPlatformEmptyBody =>
      'Скрипты для этой платформы ещё в пути. Загляните после следующего обновления SKAPP.';

  @override
  String skapiGroupScriptsLoadError(String error) {
    return 'Не удалось загрузить скрипты: $error';
  }

  @override
  String skapiScriptDetailLoadError(String error) {
    return 'Не удалось загрузить этот скрипт: $error';
  }

  @override
  String get skapiBindScreenTitle => 'Привязать к действию';

  @override
  String get skapiBindScreenSubtitle =>
      'Автоматически выполнять этот скрипт при срабатывании события устройства.';

  @override
  String get skapiBindFieldDeviceLabel => 'Устройство';

  @override
  String get skapiBindFieldDeviceHint =>
      'Выберите, какое сопряжённое устройство будет запускать этот скрипт.';

  @override
  String get skapiBindFieldDeviceEmpty =>
      'Пока нет сопряжённых устройств. Сначала сопрягите устройство на вкладке «Устройства».';

  @override
  String get skapiBindFieldEventLabel => 'Событие';

  @override
  String get skapiBindFieldEventHint =>
      'Устройство генерирует это событие; при этом выполняется скрипт.';

  @override
  String get skapiBindEventTimerStarted => 'Таймер запущен';

  @override
  String get skapiBindEventTimerExpired => 'Таймер истёк';

  @override
  String get skapiBindEventFaceChanged => 'Грань куба изменена';

  @override
  String get skapiBindEventButtonPressed => 'Кнопка нажата';

  @override
  String get skapiBindEventButtonHeld => 'Кнопка удержана';

  @override
  String get skapiBindEventBatteryLow => 'Низкий заряд';

  @override
  String get skapiBindEventBatteryLockout => 'Блокировка из-за разряда';

  @override
  String get skapiBindEventPowerStateChanged => 'Изменено состояние питания';

  @override
  String get skapiBindEventPairingSuccess => 'Сопряжение успешно';

  @override
  String get skapiBindEventApiSent => 'API-вызов отправлен';

  @override
  String get skapiBindParamsHeader => 'Переопределение параметров';

  @override
  String get skapiBindParamsHint =>
      'Оставьте пустым, чтобы сохранить значения скрипта по умолчанию. Эти значения отправляются при каждом срабатывании привязки.';

  @override
  String get skapiBindButtonSave => 'Сохранить привязку';

  @override
  String get skapiBindButtonDelete => 'Удалить привязку';

  @override
  String get skapiBindButtonCancel => 'Отмена';

  @override
  String get skapiBindButtonEnable => 'Включить';

  @override
  String get skapiBindButtonDisable => 'Выключить';

  @override
  String get skapiBindStatusEnabled => 'Активна';

  @override
  String get skapiBindStatusDisabled => 'Приостановлена';

  @override
  String get skapiBindSavedToast => 'Привязка сохранена';

  @override
  String get skapiBindDeletedToast => 'Привязка удалена';

  @override
  String skapiBindBadgeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count привязок',
      one: '1 привязка',
    );
    return '$_temp0';
  }

  @override
  String get skapiBindNoPairedDeviceWarning =>
      'Сначала сопрягите устройство, чтобы создавать привязки.';

  @override
  String skapiBindTriggeredDesktopToast(String script) {
    return 'Запущено: $script';
  }

  @override
  String skapiBindTriggeredMobileToast(String event) {
    return 'Привязка сработала ($event); выполнение появится в Фазе K.';
  }

  @override
  String skapiBindLoadError(String error) {
    return 'Не удалось загрузить привязки: $error';
  }

  @override
  String get skapiBindListSectionTitle => 'Привязки этого скрипта';

  @override
  String get skapiBindListEmpty =>
      'Пока нет привязок. Нажмите «Привязать к действию», чтобы создать одну.';

  @override
  String get skapiBindNewButton => 'Новая привязка';

  @override
  String get skapiBasicSettingsTitle => 'Настройки';

  @override
  String get skapiBasicEmptyParams =>
      'Этому скрипту не нужны настройки. Нажмите «Запустить».';

  @override
  String get skapiBasicUnitSeconds => 'секунд';

  @override
  String get skapiBasicConvHalfMinute => 'полминуты';

  @override
  String get skapiBasicConvLessThanMinute => 'меньше минуты';

  @override
  String skapiBasicConvMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count минут',
      one: '1 минута',
    );
    return '$_temp0';
  }

  @override
  String skapiBasicConvHoursMinutes(int hours, int minutes) {
    return '$hours ч $minutes мин';
  }

  @override
  String skapiBasicConvHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count часов',
      one: '1 час',
    );
    return '$_temp0';
  }

  @override
  String get skapiBasicConvImmediate => 'запускается сразу';

  @override
  String skapiBasicConvAfter(String time) {
    return 'через $time';
  }

  @override
  String get skapiBasicPrerunSectionTitle => 'Задержка перед запуском';

  @override
  String get skapiBasicPrerunAddCta => 'Добавить задержку перед запуском';

  @override
  String get skapiBasicPrerunLabel =>
      'Подождать столько секунд перед запуском скрипта';

  @override
  String get skapiBasicPrerunHelp =>
      'Полезно, чтобы сначала показать уведомление или связать действия в цепочку. Значение по умолчанию 0 означает немедленный запуск.';

  @override
  String get skapiBasicPrerunRemove => 'Убрать задержку';

  @override
  String get skapiBasicListAddPlaceholder => '+ добавить';

  @override
  String get skapiRunSheetTitle => 'Запустить скрипт';

  @override
  String get skapiRunSheetStatusRunning => 'Выполняется';

  @override
  String get skapiRunSheetStatusOk => 'Готово';

  @override
  String get skapiRunSheetStatusError => 'Не удалось';

  @override
  String skapiRunSheetExitCode(int code) {
    return 'Код выхода: $code';
  }

  @override
  String get skapiRunSheetCancel => 'Отмена';

  @override
  String get skapiRunSheetClose => 'Закрыть';

  @override
  String get skapiRunSheetCopyOutput => 'Копировать вывод';

  @override
  String get skapiRunSheetCopiedDone => 'Скопировано';

  @override
  String get skapiRunSheetEmptyOutput => 'Ожидание вывода...';

  @override
  String get skapiRunSheetDismissConfirmTitle =>
      'Остановить выполнение скрипта?';

  @override
  String get skapiRunSheetDismissConfirmBody =>
      'Скрипт ещё выполняется. Закрытие этого окна отменит его.';

  @override
  String get skapiRunSheetDismissConfirmStay => 'Продолжить выполнение';

  @override
  String get skapiRunSheetDismissConfirmStop => 'Отмена';

  @override
  String get skapiRunErrorPowerShellMissing =>
      'PowerShell не найден в этой системе.';

  @override
  String skapiRunErrorTempWrite(String error) {
    return 'Не удалось записать скрипт во временную папку: $error';
  }

  @override
  String skapiRunErrorSpawn(String error) {
    return 'Не удалось запустить PowerShell: $error';
  }

  @override
  String skapiRunDurationMs(int ms) {
    return 'Заняло $ms мс';
  }

  @override
  String get skapiCopiedToClipboard => 'Скопировано';

  @override
  String get skapiFavouriteAddTooltip => 'Добавить в избранное';

  @override
  String get skapiFavouriteRemoveTooltip => 'Убрать из избранного';

  @override
  String skapiGroupAppBarSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count скриптов',
      one: '1 скрипт',
    );
    return '$_temp0';
  }

  @override
  String get skapiPlatformScreenCategoriesTitle => 'Категории действий';

  @override
  String skapiPlatformScreenCategoriesSub(int groups, int scripts) {
    return '$groups групп · всего скриптов: $scripts';
  }

  @override
  String get skapiGroupScriptsHeader => 'Скрипты';

  @override
  String skapiGroupScriptsCount(int count) {
    return '$count скриптов';
  }

  @override
  String skapiGroupItemCount(int count) {
    return '$count скриптов';
  }

  @override
  String get skapiGroupPowerTitle => 'Управление питанием';

  @override
  String get skapiGroupPowerDesc =>
      'Скрипты в этой группе блокируют, усыпляют, переводят в гибернацию или выключают компьютер. Они полезны, когда устройство SmartKraft сигнализирует об окончании сеанса концентрации или обнаруживает длительное бездействие, а вы хотите, чтобы компьютер отреагировал соответственно.';

  @override
  String get skapiGroupPowerFoot =>
      'Типичное применение: блокировка, когда вы встаёте, гибернация в конце дня, отложенное выключение после долгого простоя.';

  @override
  String get skapiScriptLockTitle => 'Заблокировать компьютер';

  @override
  String get skapiScriptLockSummaryWhat =>
      'Немедленно блокирует Windows и возвращает к экрану входа. Открытые приложения продолжают работать.';

  @override
  String get skapiScriptLockSummaryHow =>
      'Вызывает функцию Win32 LockWorkStation из user32. Эквивалентно нажатию Win+L.';

  @override
  String get skapiScriptHibernateTitle => 'Гибернация';

  @override
  String get skapiScriptHibernateSummaryWhat =>
      'Сохраняет текущий сеанс на диск и выключает компьютер. При возобновлении возвращает к месту, где вы остановились, даже без батареи.';

  @override
  String get skapiScriptHibernateSummaryHow =>
      'Запускает встроенный shutdown.exe с флагом /h. Гибернация должна быть включена в настройках электропитания Windows; если нет, Windows переходит в спящий режим.';

  @override
  String get skapiScriptHibernateNote =>
      'Если гибернация отсутствует в вашей системе, выполните один раз powercfg /hibernate on из консоли администратора.';

  @override
  String get skapiScriptHibernateParamDelayLabel => 'задержка';

  @override
  String get skapiScriptHibernateParamDelayHint =>
      'Секунды ожидания перед гибернацией, на случай, если сначала должно появиться уведомление устройства.';

  @override
  String get skapiScriptSleepTitle => 'Спящий режим';

  @override
  String get skapiScriptSleepSummaryWhat =>
      'Переводит компьютер в спящий режим (S3) с сохранением в ОЗУ. Возобновление быстрое, но в спящем режиме расходуется немного заряда.';

  @override
  String get skapiScriptSleepSummaryHow =>
      'Вызывает System.Windows.Forms.Application.SetSuspendState с PowerState.Suspend. ОС может задержать переход, если активный процесс блокирует переход в простой.';

  @override
  String get skapiScriptSleepParamDelayLabel => 'задержка';

  @override
  String get skapiScriptSleepParamDelayHint =>
      'Секунды ожидания перед переходом в спящий режим.';

  @override
  String get skapiScriptShutdownTitle => 'Выключение';

  @override
  String get skapiScriptShutdownSummaryWhat =>
      'Инициирует корректное выключение Windows. Открытым приложениям предлагается сохранить данные и закрыться.';

  @override
  String get skapiScriptShutdownSummaryHow =>
      'Запускает встроенный shutdown.exe /s. При включённом параметре «принудительно» добавляется /f, чтобы завершить не отвечающие приложения.';

  @override
  String get skapiScriptShutdownNote =>
      'Ненулевая задержка даёт пользователю время отменить выключение через shutdown /a в терминале.';

  @override
  String get skapiScriptShutdownParamDelayLabel => 'задержка';

  @override
  String get skapiScriptShutdownParamDelayHint =>
      'Секунды, которые Windows ждёт перед выключением. По умолчанию 30; выберите 0 для немедленного выключения.';

  @override
  String get skapiScriptShutdownParamForceLabel => 'принудительно';

  @override
  String get skapiScriptShutdownParamForceHint =>
      'Закрывает приложения, не реагирующие на сигнал выключения. Несохранённая работа в них может быть потеряна.';

  @override
  String get skapiGroupDisplayAudioTitle => 'Экран, изображение и звук';

  @override
  String get skapiGroupDisplayAudioDesc =>
      'Скрипты в этой группе управляют экраном и звуком: яркость, громкость, отключение звука и воспроизведение мультимедиа. Они полезны, когда устройство SmartKraft хочет приглушить экран во время перерыва или поставить музыку на паузу, когда вы встаёте.';

  @override
  String get skapiGroupDisplayAudioFoot =>
      'Типичное применение: приглушить экран во время перерыва, отключить звук при блокировке, ставить Spotify на паузу, когда устройство не фиксирует активности.';

  @override
  String get skapiScriptBrightnessTitle => 'Задать яркость';

  @override
  String get skapiScriptBrightnessSummaryWhat =>
      'Устанавливает яркость внутреннего дисплея в процентах от 0 до 100.';

  @override
  String get skapiScriptBrightnessSummaryHow =>
      'Вызывает WMI WmiMonitorBrightnessMethods.WmiSetBrightness с запрошенным уровнем. Реагируют только ноутбуки, планшеты и встроенные панели; внешние мониторы DDC/CI на этом пути не поддерживаются.';

  @override
  String get skapiScriptBrightnessNote =>
      'Внешние мониторы не изменятся. В конфигурациях с несколькими мониторами реагирует только панель, сообщающая яркость через WMI.';

  @override
  String get skapiScriptBrightnessParamLevelLabel => 'уровень';

  @override
  String get skapiScriptBrightnessParamLevelHint =>
      'Процент яркости (0-100). Меньшие значения тусклее. 70 — комфортное значение по умолчанию при обычном освещении.';

  @override
  String get skapiScriptBrightnessParamTimeoutLabel => 'тайм-аут';

  @override
  String get skapiScriptBrightnessParamTimeoutHint =>
      'Секунды, отведённые на изменение яркости. ОС плавно меняет её в этом окне.';

  @override
  String get skapiScriptMuteToggleTitle => 'Переключить отключение звука';

  @override
  String get skapiScriptMuteToggleSummaryWhat =>
      'Переключает общесистемное отключение звука. Активное мультимедиа продолжает воспроизводиться, но вы его не слышите.';

  @override
  String get skapiScriptMuteToggleSummaryHow =>
      'Отправляет виртуальную клавишу VK_VOLUME_MUTE — тот же путь, что использует Windows при нажатии клавиши отключения звука на клавиатуре. Без прав администратора и зависимости от COM.';

  @override
  String get skapiScriptMuteToggleParamModeLabel => 'режим';

  @override
  String get skapiScriptMuteToggleParamModeHint =>
      'toggle / on / off. Через простое нажатие клавиши применяется только toggle; on и off принимаются для совместимости в будущем.';

  @override
  String get skapiScriptVolumeSetTitle => 'Задать громкость';

  @override
  String get skapiScriptVolumeSetSummaryWhat =>
      'Устанавливает общую громкость системы на точный уровень от 0 до 100.';

  @override
  String get skapiScriptVolumeSetSummaryHow =>
      'Вызывает Core Audio IAudioEndpointVolume.SetMasterVolumeLevelScalar через встроенный C# COM-интероп. Нацелено на устройство воспроизведения по умолчанию.';

  @override
  String get skapiScriptVolumeSetNote =>
      'Уровень 2: работает на стандартных компьютерах с Windows 10/11. Урезанные установки могут не предоставлять COM-интерфейс; конечные точки отдельных приложений на этом пути не затрагиваются.';

  @override
  String get skapiScriptVolumeSetParamLevelLabel => 'уровень';

  @override
  String get skapiScriptVolumeSetParamLevelHint =>
      'Процент громкости (0-100). 0 убавляет до нуля, не включая режим «без звука»; 50 — комфортное значение по умолчанию.';

  @override
  String get skapiScriptMediaKeyTitle => 'Медиаклавиша';

  @override
  String get skapiScriptMediaKeySummaryWhat =>
      'Имитирует нажатие медиаклавиши: воспроизведение/пауза, далее, назад или стоп. Действует на то приложение, которое сейчас владеет медиасеансом.';

  @override
  String get skapiScriptMediaKeySummaryHow =>
      'Отправляет VK_MEDIA_PLAY_PAUSE / VK_MEDIA_NEXT_TRACK / VK_MEDIA_PREV_TRACK / VK_MEDIA_STOP через keybd_event. Windows маршрутизирует нажатие через System Media Transport Controls.';

  @override
  String get skapiScriptMediaKeyNote =>
      'Уровень 2: нужен активный медиасеанс. Если ничего не воспроизводится или активное приложение не регистрируется в SMTC, нажатие тихо игнорируется.';

  @override
  String get skapiScriptMediaKeyParamKeyLabel => 'клавиша';

  @override
  String get skapiScriptMediaKeyParamKeyHint =>
      'play-pause / next / previous / stop. По умолчанию play-pause.';

  @override
  String get skapiGroupWindowAppTitle => 'Окна и приложения';

  @override
  String get skapiGroupWindowAppDesc =>
      'Скрипты в этой группе управляют окнами и приложениями: сворачивают, выводят на передний план, корректно закрывают или принудительно завершают процессы. Они помогают держать рабочее пространство в порядке, когда устройство SmartKraft хочет, чтобы компьютер сменил контекст.';

  @override
  String get skapiGroupWindowAppFoot =>
      'Типичное применение: свернуть всё в начале сеанса концентрации, закрыть браузер по окончании работы, завершить зависшее приложение по команде.';

  @override
  String get skapiScriptMinimizeWindowTitle => 'Свернуть окно';

  @override
  String get skapiScriptMinimizeWindowSummaryWhat =>
      'Сворачивает определённое окно по имени процесса. Пустое имя процесса нацелено на окно, которое сейчас в фокусе.';

  @override
  String get skapiScriptMinimizeWindowSummaryHow =>
      'Находит первое подходящее главное окно через Get-Process и вызывает user32 ShowWindow с SW_MINIMIZE.';

  @override
  String get skapiScriptMinimizeWindowNote =>
      'Если запущено несколько экземпляров, сворачивается только первое подходящее окно. Используйте имя процесса без суффикса .exe.';

  @override
  String get skapiScriptMinimizeWindowParamProcessLabel => 'имя процесса';

  @override
  String get skapiScriptMinimizeWindowParamProcessHint =>
      'Имя процесса без .exe (chrome, code, winword). Пусто — нацелено на активное окно.';

  @override
  String get skapiScriptCloseWindowTitle => 'Закрыть окно';

  @override
  String get skapiScriptCloseWindowSummaryWhat =>
      'Отправляет окну запрос на корректное закрытие, чтобы приложение могло показать собственный диалог «сохранить изменения?».';

  @override
  String get skapiScriptCloseWindowSummaryHow =>
      'Отправляет WM_CLOSE через user32 SendMessage. Тот же эффект, что и нажатие пользователем кнопки X. Пустое имя процесса нацелено на активное окно.';

  @override
  String get skapiScriptCloseWindowNote =>
      'Приложения с несохранённой работой покажут собственный диалог. Скрипт не ждёт и не завершает зависшие приложения.';

  @override
  String get skapiScriptCloseWindowParamProcessLabel => 'имя процесса';

  @override
  String get skapiScriptCloseWindowParamProcessHint =>
      'Имя процесса без .exe. Пусто — нацелено на активное окно.';

  @override
  String get skapiScriptKillAppTitle => 'Принудительно завершить приложение';

  @override
  String get skapiScriptKillAppSummaryWhat =>
      'Завершает каждый экземпляр процесса. Сначала пробует WM_CLOSE, затем TerminateProcess, если приложение всё ещё работает после тайм-аута.';

  @override
  String get skapiScriptKillAppSummaryHow =>
      'Отправляет WM_CLOSE каждому главному окну, ждёт заданный тайм-аут, затем выполняет Stop-Process с -Force для всего, что ещё работает.';

  @override
  String get skapiScriptKillAppNote =>
      'Несохранённая работа в не отвечающих приложениях будет потеряна при принудительном завершении. Используйте preKillSave для приложений-редакторов, реагирующих на Ctrl+S.';

  @override
  String get skapiScriptKillAppParamProcessLabel => 'имя процесса';

  @override
  String get skapiScriptKillAppParamProcessHint =>
      'Имя процесса без .exe. Завершаются все запущенные экземпляры.';

  @override
  String get skapiScriptKillAppParamTimeoutLabel => 'тайм-аут';

  @override
  String get skapiScriptKillAppParamTimeoutHint =>
      'Секунды ожидания между WM_CLOSE и принудительным завершением. Большие значения дают приложению больше времени на сохранение.';

  @override
  String get skapiScriptKillAppParamPreKillSaveLabel => 'preKillSave';

  @override
  String get skapiScriptKillAppParamPreKillSaveHint =>
      'Отправляет Ctrl+S активному окну перед закрытием. Полезно для редакторов, но не действует на приложения, игнорирующие Ctrl+S.';

  @override
  String get skapiScriptLaunchAppTitle => 'Запустить приложение';

  @override
  String get skapiScriptLaunchAppSummaryWhat =>
      'Запускает исполняемый файл, открывает URL или открывает документ обработчиком по умолчанию.';

  @override
  String get skapiScriptLaunchAppSummaryHow =>
      'Вызывает PowerShell Start-Process с путём и необязательным списком аргументов. Путь может быть .exe, полным путём к файлу или URL.';

  @override
  String get skapiScriptLaunchAppNote =>
      'Пути с пробелами допускаются. Используйте URL вида https://example.com, чтобы открыть браузер по умолчанию.';

  @override
  String get skapiScriptLaunchAppParamPathLabel => 'путь';

  @override
  String get skapiScriptLaunchAppParamPathHint =>
      'Исполняемый файл, полный путь к файлу или URL. notepad / C:\\\\tools\\\\my.exe / https://example.com.';

  @override
  String get skapiScriptLaunchAppParamArgsLabel => 'аргументы';

  @override
  String get skapiScriptLaunchAppParamArgsHint =>
      'Аргументы, передаваемые исполняемому файлу. Пусто — без аргументов.';

  @override
  String get skappListenerCardTitle => 'HTTP-слушатель SKAPP';

  @override
  String skappListenerCardSubtitleRunning(int port) {
    return 'Работает на порту $port';
  }

  @override
  String get skappListenerCardSubtitleStopped => 'Остановлен';

  @override
  String get skappListenerCardSubtitleUnsupported =>
      'Эта платформа не может размещать слушатель.';

  @override
  String get skappListenerCardEnableSwitch => 'Включить слушатель';

  @override
  String get skappListenerCardSecurityNote =>
      'Слушатель принимает подключения только в вашей локальной сети и требует Bearer-токен. Обычный HTTP, не открывайте его в публичный интернет.';

  @override
  String get settingsLanVisibleTitle => 'Видим в LAN';

  @override
  String get settingsLanVisibleSubtitle =>
      'Когда выключено, слушатель привязывается только к localhost. Сопряжённые устройства BF не смогут достучаться до этого ПК.';

  @override
  String get settingsLanVisibleWarnBfBreaks =>
      'Отключение этого нарушает цепочку вебхуков BF. Используйте только в доверенной или тестовой среде.';

  @override
  String get settingsLanVisibleAutoReopenedSnack =>
      'Видимость в LAN снова включена, чтобы устройства BF могли достучаться до этого ПК.';

  @override
  String get skapiRunRemoteDeveloperModeDisabled =>
      'На целевом ПК отключён режим разработчика, поэтому удалённое выполнение скриптов там недоступно.';

  @override
  String get skappPeerPairingManualUuidConfirmLabel =>
      'Код подтверждения (последние 4 символа UUID)';

  @override
  String get skappPeerPairingManualUuidConfirmHint =>
      'Прочитайте 4-символьный код, показанный на экране сопряжения ПК.';

  @override
  String get skappPeerPairingManualUuidConfirmError =>
      'Код не совпадает с последними 4 символами UUID. Проверьте экран ПК.';

  @override
  String get skappListenerCardUuidLast4Label => 'Код подтверждения сопряжения';

  @override
  String get skappListenerCardUuidLast4Hint =>
      'Введите эти 4 символа на экране ручного сопряжения телефона.';

  @override
  String get settingsPeerTokensTitle => 'Выданные токены узлов';

  @override
  String get settingsPeerTokensSubtitle =>
      'Мобильные узлы, сопряжённые с этим ПК. Отзовите любую запись, чтобы завершить её сеанс, не затрагивая остальные.';

  @override
  String get settingsPeerTokensEmpty => 'Пока нет сопряжённых узлов.';

  @override
  String settingsPeerTokensIssuedAt(String when) {
    return 'Сопряжено $when';
  }

  @override
  String settingsPeerTokensLastUsed(String when) {
    return 'Последнее использование $when';
  }

  @override
  String get settingsPeerTokensRevokeButton => 'Отозвать';

  @override
  String get settingsPeerTokensRevokeConfirmTitle => 'Отозвать этот узел?';

  @override
  String get settingsPeerTokensRevokeConfirmBody =>
      'Сеанс узла будет немедленно завершён, и для доступа к этому ПК ему придётся сопрячься заново.';

  @override
  String get settingsPeerTokensRevokeConfirmCancel => 'Отмена';

  @override
  String get settingsPeerTokensRevokeConfirmAction => 'Отозвать';

  @override
  String settingsPeerTokensRevokedToast(String name) {
    return 'Узел $name отозван';
  }

  @override
  String get skappListenerCardRotateCertButton => 'Сменить TLS-сертификат';

  @override
  String get skappListenerCardRotateCertConfirmTitle => 'Сменить сертификат?';

  @override
  String get skappListenerCardRotateCertConfirmBody =>
      'Будет создан новый самоподписанный TLS-сертификат. Каждый ранее сопряжённый узел не пройдёт рукопожатие, пока не сопряжётся заново.';

  @override
  String get skappListenerCardRotateCertConfirmCancel => 'Отмена';

  @override
  String get skappListenerCardRotateCertConfirmAction => 'Сменить';

  @override
  String get skappListenerCardRotateCertDoneSnack =>
      'TLS-сертификат сменён. Сопрягите заново каждое устройство.';

  @override
  String get skappListenerCardCertFingerprintLabel => 'Отпечаток TLS';

  @override
  String skappListenerCardErrorPortInUse(int port) {
    return 'Порт $port уже занят. Выберите другой порт в разделе «Сетевая идентификация».';
  }

  @override
  String skappListenerCardErrorGeneric(String error) {
    return 'Не удалось запустить слушатель: $error';
  }

  @override
  String get skappPeerPairingTitle => 'Сопрячь настольный SKAPP';

  @override
  String get skappPeerPairingSubtitle =>
      'Отсканируйте QR, показанный в настройках настольного SKAPP, или вставьте код сопряжения вручную.';

  @override
  String get skappPeerPairingTabScan => 'Сканировать QR';

  @override
  String get skappPeerPairingTabManual => 'Вручную';

  @override
  String get skappPeerPairingScanHint =>
      'Наведите камеру на QR, показанный в Настольном SKAPP > Настройки > HTTP-слушатель SKAPP.';

  @override
  String get skappPeerPairingScanCameraDeniedTitle =>
      'Требуется разрешение камеры';

  @override
  String get skappPeerPairingScanCameraDeniedBody =>
      'Разрешите доступ к камере в настройках телефона, чтобы отсканировать QR сопряжения. Также можно ввести код вручную.';

  @override
  String get skappPeerPairingManualHostLabel => 'IP или имя хоста ПК';

  @override
  String get skappPeerPairingManualPortLabel => 'Порт';

  @override
  String get skappPeerPairingManualTokenLabel => 'Bearer-токен';

  @override
  String get skappPeerPairingManualUuidLabel => 'UUID ПК';

  @override
  String get skappPeerPairingManualNameLabel => 'Отображаемое имя';

  @override
  String get skappPeerPairingManualSubmit => 'Сопрячь';

  @override
  String skappPeerPairingSavedToast(String name) {
    return 'Сопряжено с $name';
  }

  @override
  String skappPeerPairingFailedToast(String reason) {
    return 'Сопряжение не удалось: $reason';
  }

  @override
  String get skappPeerPairingShowQrTitle => 'Сопрячь телефон с этим ПК';

  @override
  String get skappPeerPairingShowQrBody =>
      'Откройте SKAPP на телефоне, перейдите в SKAPI > Настройки > Сопрячь ПК и отсканируйте этот QR. QR содержит Bearer-токен, относитесь к нему как к паролю.';

  @override
  String get skappPeerPairingShowQrCloseButton => 'Готово';

  @override
  String get skappPeerListEmpty =>
      'Пока нет сопряжённых ПК. Сопрягите один, чтобы запускать скрипты с этого телефона.';

  @override
  String get skappPeerListSectionTitle => 'Сопряжённые настольные SKAPP';

  @override
  String get skappPeerStatusOnline => 'В сети';

  @override
  String get skappPeerStatusOffline => 'Не в сети';

  @override
  String skappPeerStatusLastSeen(String when) {
    return 'Последний раз в сети $when';
  }

  @override
  String get skappPeerRemoveTooltip => 'Удалить сопряжённый ПК';

  @override
  String get skappPeerRemoveConfirmTitle => 'Удалить сопряжение?';

  @override
  String skappPeerRemoveConfirmBody(String name) {
    return 'Скрипты, запускаемые с этого телефона, больше не будут выполняться на $name, пока вы не сопряжётесь заново.';
  }

  @override
  String get skappPeerScanRefreshTooltip => 'Обновить список узлов';

  @override
  String skapiRunRemoteSheetTitle(String peerName) {
    return 'Удалённый запуск на $peerName';
  }

  @override
  String get skapiRunRemoteConnecting => 'Подключение к ПК...';

  @override
  String get skapiRunRemoteOfflineError =>
      'Сопряжённый ПК не в сети. Попробуйте обновить список узлов или проверьте слушатель ПК.';

  @override
  String get skapiRunRemoteUnauthorizedError =>
      'Bearer-токен отклонён. Возможно, токен ПК сменился. Сопрягите заново в настройках.';

  @override
  String skapiRunRemoteHttpError(String reason) {
    return 'Сбой удалённого запуска: $reason';
  }

  @override
  String get skapiRunMobileNoPeerTitle => 'Нет сопряжённого ПК';

  @override
  String get skapiRunMobileNoPeerBody =>
      'Сопрягите настольный SKAPP в настройках, чтобы запускать скрипты с этого телефона.';

  @override
  String get skapiRunMobileNoPeerCta => 'Открыть настройки';

  @override
  String get skapiRunRemoteNotWhitelisted =>
      'Этот скрипт не отмечен как пригодный для удалённого запуска. Запустите его прямо на ПК.';

  @override
  String get skapiRunRemoteNoPeerHint =>
      'Сопрягите настольный SKAPP в настройках, чтобы запускать скрипты с этого телефона.';

  @override
  String get skapiRunRemoteNoPeerAction => 'Открыть настройки';

  @override
  String get skappPeerPickerTitle => 'На какой компьютер отправить?';

  @override
  String get skappPeerPickerSubtitle =>
      'Выберите сопряжённый настольный SKAPP, который должен выполнить этот скрипт.';

  @override
  String get skappPeerPickerOfflineReason => 'Не в сети';

  @override
  String get skappPeerPickerDevModeOffReason => 'Режим разработчика выключен';

  @override
  String get skappPeerPickerEmpty => 'Нет сопряжённых ПК для выбора.';

  @override
  String get skapiRunRemoteCancelButton => 'Отмена';

  @override
  String get skapiRunRemoteCancelledNote => 'Запуск отменён';

  @override
  String skapiRunRemoteTooManyRuns(int running, int limit) {
    return 'На этом ПК уже выполняется $running скриптов (максимум $limit). Дождитесь завершения одного из них.';
  }

  @override
  String get skappPeerHealthDevModeBadge => 'Реж. разраб.';

  @override
  String get remoteRunActivityCardTitle => 'Удалённые запуски';

  @override
  String get remoteRunActivityCardSubtitle =>
      'Недавние запуски скриптов, которые сопряжённые мобильные узлы попросили выполнить этот ПК.';

  @override
  String get remoteRunActivityCardEmpty => 'Пока нет удалённых запусков.';

  @override
  String get remoteRunActivityCardClear => 'Очистить историю';

  @override
  String remoteRunActivityRowOk(int exitCode, int durationMs) {
    return 'выход $exitCode · $durationMs мс';
  }

  @override
  String get remoteRunActivityRowCancelled => 'отменено';

  @override
  String remoteRunActivityRowRejected(String reason) {
    return 'отклонено · $reason';
  }

  @override
  String get mobileTriggerCardTitle => 'Триггер';

  @override
  String get mobileTriggerCardSubtitle =>
      'Отправьте событие касания на сопряжённый настольный SKAPP. Любая привязка, ожидающая это событие, запустит свой скрипт на том ПК.';

  @override
  String get mobileTriggerCardSendButton => 'Отправить касание';

  @override
  String get mobileTriggerCardSending => 'Отправка...';

  @override
  String mobileTriggerSentToast(String name) {
    return 'Касание отправлено на $name';
  }

  @override
  String get skapiBindEventMobileTap => 'Касание с телефона';

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
  String get msHomeScreenTitle => 'Мобильный узел';

  @override
  String get msHomeScreenNotFound => 'Этот мобильный узел больше не сопряжён.';

  @override
  String get msHomeScreenEventsHeader => 'Доступные события';

  @override
  String msHomeScreenBindingsHeader(int count) {
    return 'Привязки ($count)';
  }

  @override
  String get msHomeScreenBindingsEmpty =>
      'Пока нет привязок. Используйте SKAPI → скрипт → Привязать к действию, чтобы связать событие касания со скриптом.';

  @override
  String get msHomeScreenHint =>
      'Телефоны не выполняют скрипты. Они генерируют события-триггеры, которые этот ПК привязывает к скриптам.';

  @override
  String msHomeScreenPairedAt(String date) {
    return 'Сопряжено $date';
  }

  @override
  String get skapiGroupNotifyTitle => 'Уведомления и диалоги';

  @override
  String get skapiGroupNotifyDesc =>
      'Скрипты в этой группе обращаются к пользователю напрямую: показывают всплывающее уведомление, модальный диалог или ждут ответа «да/нет». Используйте их, когда событие устройства SmartKraft требует, чтобы человек перед экраном подтвердил или принял решение.';

  @override
  String get skapiGroupNotifyFoot =>
      'Типичное применение: диалог перед разрушительным действием, всплывающее уведомление как мягкое напоминание, диалог с тайм-аутом для автоматического продолжения.';

  @override
  String get skapiScriptDialogTitle => 'Показать диалог';

  @override
  String get skapiScriptDialogSummaryWhat =>
      'Показывает модальное окно Windows MessageBox и возвращает выбор пользователя (ok / cancel / yes / no / timeout).';

  @override
  String get skapiScriptDialogSummaryHow =>
      'Вызывает System.Windows.Forms.MessageBox в дочернем runspace, чтобы скрипт мог сопоставить диалог с необязательным тайм-аутом. Выбранное значение пишется в stdout, чтобы вызывающая сторона могла ветвиться.';

  @override
  String get skapiScriptDialogNote =>
      'stdout — это ответ пользователя в нижнем регистре. timeout=0 ждёт бесконечно.';

  @override
  String get skapiScriptDialogParamTitleLabel => 'заголовок';

  @override
  String get skapiScriptDialogParamTitleHint =>
      'Заголовок окна, показываемый в окне сообщения.';

  @override
  String get skapiScriptDialogParamBodyLabel => 'текст';

  @override
  String get skapiScriptDialogParamBodyHint =>
      'Вопрос или сообщение, показываемые пользователю.';

  @override
  String get skapiScriptDialogParamButtonsLabel => 'кнопки';

  @override
  String get skapiScriptDialogParamButtonsHint =>
      'ok / ok_cancel / yes_no / yes_no_cancel. По умолчанию ok_cancel.';

  @override
  String get skapiScriptDialogParamTimeoutLabel => 'тайм-аут';

  @override
  String get skapiScriptDialogParamTimeoutHint =>
      'Секунды ожидания перед автоматическим возвратом значения «timeout». 0 означает ждать бесконечно.';

  @override
  String get skapiScriptToastTitle => 'Показать уведомление';

  @override
  String get skapiScriptToastSummaryWhat =>
      'Показывает всплывающее уведомление Windows с заголовком и текстом. Выезжает из правого нижнего угла и попадает в Центр уведомлений.';

  @override
  String get skapiScriptToastSummaryHow =>
      'Формирует XML-полезную нагрузку ToastNotification и передаёт её WinRT ToastNotificationManager под настроенным AppUserModelID.';

  @override
  String get skapiScriptToastNote =>
      'Уровень 2: для самого чистого UX требуется Windows 10+ и зарегистрированный AppUserModelID. AUMID по умолчанию помещает уведомление в Центре уведомлений под PowerShell.';

  @override
  String get skapiScriptToastParamTitleLabel => 'заголовок';

  @override
  String get skapiScriptToastParamTitleHint =>
      'Жирная первая строка уведомления.';

  @override
  String get skapiScriptToastParamBodyLabel => 'текст';

  @override
  String get skapiScriptToastParamBodyHint =>
      'Меньшая вторая строка. Необязательно.';

  @override
  String get skapiScriptToastParamAumidLabel => 'aumid';

  @override
  String get skapiScriptToastParamAumidHint =>
      'App User Model ID, под которым появляется уведомление. По умолчанию возвращается к PowerShell.';

  @override
  String get skapiGroupVisualBreakTitle => 'Визуальный перерыв';

  @override
  String get skapiGroupVisualBreakDesc =>
      'Мягкие визуальные сигналы, отвлекающие пользователя от напряжённой работы: приглушить экран, перейти в оттенки серого, найти курсор или показать рабочий стол. Эффекты этой группы обратимы и никогда не блокируют ввод жёстко.';

  @override
  String get skapiGroupVisualBreakFoot =>
      'Типичное применение: приглушить экран в начале перерыва, режим оттенков серого для ночного чтения, поиск курсора в конфигурациях с несколькими мониторами.';

  @override
  String get skapiScriptShowDesktopTitle => 'Показать рабочий стол';

  @override
  String get skapiScriptShowDesktopSummaryWhat =>
      'Переключает «показать рабочий стол». То же, что дважды нажать Win+D.';

  @override
  String get skapiScriptShowDesktopSummaryHow =>
      'Вызывает Shell.Application.ToggleDesktop через COM. Повторный запуск восстанавливает прежнее расположение окон.';

  @override
  String get skapiScriptFadeScreenTitle => 'Затухание экрана';

  @override
  String get skapiScriptFadeScreenSummaryWhat =>
      'Плавно меняет яркость внутреннего дисплея от текущего уровня к целевому за несколько секунд.';

  @override
  String get skapiScriptFadeScreenSummaryHow =>
      'Считывает текущую яркость через WMI WmiMonitorBrightness, затем линейными шагами меняет WmiSetBrightness к цели, чтобы изменение было плавным.';

  @override
  String get skapiScriptFadeScreenNote =>
      'Уровень 2: яркость по WMI работает только на внутренних панелях. Внешние мониторы на этом пути не реагируют.';

  @override
  String get skapiScriptFadeScreenParamTargetLabel => 'цель';

  @override
  String get skapiScriptFadeScreenParamTargetHint =>
      'Итоговый процент яркости (0-100).';

  @override
  String get skapiScriptFadeScreenParamDurationLabel => 'длительность';

  @override
  String get skapiScriptFadeScreenParamDurationHint =>
      'Секунды, за которые происходит затухание. Скрипт использует десять шагов яркости в секунду.';

  @override
  String get skapiScriptGrayscaleTitle => 'Фильтр оттенков серого';

  @override
  String get skapiScriptGrayscaleSummaryWhat =>
      'Включает или выключает режим оттенков серого в цветовых фильтрах Windows.';

  @override
  String get skapiScriptGrayscaleSummaryHow =>
      'Записывает ключи реестра ColorFiltering, затем отправляет Win+Ctrl+C, чтобы Windows применила изменение сразу без выхода из системы.';

  @override
  String get skapiScriptGrayscaleNote =>
      'Уровень 2: для мгновенного переключения требуется включённый параметр Настройки > Специальные возможности > Цветовые фильтры > «Разрешить горячую клавишу».';

  @override
  String get skapiScriptGrayscaleParamOnLabel => 'вкл';

  @override
  String get skapiScriptGrayscaleParamOnHint =>
      'true — включить оттенки серого, false — выключить.';

  @override
  String get skapiScriptGrayscaleParamDurationLabel => 'длительность';

  @override
  String get skapiScriptGrayscaleParamDurationHint =>
      '0 — просто переключить. >0 — автоматически вернуться к цвету через заданное число секунд. Идеально для визуальных перерывов.';

  @override
  String get skapiScriptFindMouseShakeTitle => 'Найти курсор';

  @override
  String get skapiScriptFindMouseShakeSummaryWhat =>
      'Покачивает курсор по небольшому кругу, чтобы привлечь к нему взгляд. По окончании анимации курсор возвращается в исходную точку.';

  @override
  String get skapiScriptFindMouseShakeSummaryHow =>
      'Считывает текущую позицию курсора через GetCursorPos, затем циклически вызывает SetCursorPos по кругу заданного радиуса. Полезно для конфигураций с несколькими мониторами и 4K.';

  @override
  String get skapiScriptFindMouseShakeNote =>
      'Уровень 2: SetCursorPos может блокироваться программами специальных возможностей, а поведение различается в сеансах удалённого рабочего стола.';

  @override
  String get skapiScriptFindMouseShakeParamRadiusLabel => 'радиус';

  @override
  String get skapiScriptFindMouseShakeParamRadiusHint =>
      'Пиксели, на которые курсор удаляется от исходной точки во время цикла. Больше — заметнее.';

  @override
  String get skapiScriptFindMouseShakeParamLoopsLabel => 'циклы';

  @override
  String get skapiScriptFindMouseShakeParamLoopsHint =>
      'Сколько полных кругов нарисовать перед остановкой.';

  @override
  String get skapiGroupProgramsTitle => 'Управление конкретными программами';

  @override
  String get skapiGroupProgramsDesc =>
      'Целевые скрипты для конкретных приложений и браузеров: корректное сохранение и закрытие, завершение нескольких экземпляров, очистка по браузеру. Удобно, когда устройство SmartKraft хочет свернуть определённый рабочий процесс, не закрывая весь рабочий стол.';

  @override
  String get skapiGroupProgramsFoot =>
      'Типичное применение: сохранить и закрыть все редакторы перед сном, закрыть все браузеры в конце дня, точечная очистка одного семейства процессов.';

  @override
  String get skapiScriptCloseWithSaveTitle => 'Сохранить и закрыть приложение';

  @override
  String get skapiScriptCloseWithSaveSummaryWhat =>
      'Отправляет Ctrl+S целевому приложению, чтобы запустить его собственное сохранение, ждёт, затем корректно закрывает окно.';

  @override
  String get skapiScriptCloseWithSaveSummaryHow =>
      'Выводит на передний план каждый запущенный экземпляр, отправляет Ctrl+S через SendKeys, ждёт заданную паузу, затем отправляет WM_CLOSE, чтобы приложение могло подтвердить или завершить сохранение.';

  @override
  String get skapiScriptCloseWithSaveNote =>
      'Уровень 2: полагается на то, что приложение трактует Ctrl+S как «сохранить». Некоторые чаты / веб-приложения трактуют это иначе. Проверьте на тех приложениях, что используете.';

  @override
  String get skapiScriptCloseWithSaveParamProcessLabel => 'имя процесса';

  @override
  String get skapiScriptCloseWithSaveParamProcessHint =>
      'Имя процесса без .exe (winword, excel, code, photoshop). Все запущенные экземпляры сохраняются и закрываются.';

  @override
  String get skapiScriptCloseWithSaveParamWaitLabel => 'ожидание';

  @override
  String get skapiScriptCloseWithSaveParamWaitHint =>
      'Секунды ожидания между Ctrl+S и сигналом закрытия, чтобы приложение завершило сохранение.';

  @override
  String get skapiScriptCloseAllInstancesTitle => 'Закрыть все экземпляры';

  @override
  String get skapiScriptCloseAllInstancesSummaryWhat =>
      'Отправляет запрос на корректное закрытие каждому видимому окну процесса. Каждый экземпляр может показать собственный диалог сохранения.';

  @override
  String get skapiScriptCloseAllInstancesSummaryHow =>
      'Перебирает подходящие процессы через Get-Process и отправляет WM_CLOSE главному окну каждого. Без принудительного завершения.';

  @override
  String get skapiScriptCloseAllInstancesParamProcessLabel => 'имя процесса';

  @override
  String get skapiScriptCloseAllInstancesParamProcessHint =>
      'Имя процесса без .exe. Соответствует всем экземплярам.';

  @override
  String get skapiScriptBrowserCloseAllTitle => 'Закрыть все браузеры';

  @override
  String get skapiScriptBrowserCloseAllSummaryWhat =>
      'Корректно закрывает все запущенные популярные браузеры (Chrome, Edge, Firefox, Brave, Vivaldi, Opera).';

  @override
  String get skapiScriptBrowserCloseAllSummaryHow =>
      'Перебирает известные имена процессов браузеров и отправляет WM_CLOSE главному окну каждого. Современные браузеры сохраняют сеанс, если включено «восстанавливать вкладки при следующем запуске».';

  @override
  String get skapiScriptBrowserCloseAllNote =>
      'Принудительное завершение не используется. Чтобы также стереть сеанс, используйте kill-app по каждому браузеру.';

  @override
  String get skapiTierBadgeExperimental => 'Экспериментально';

  @override
  String get skapiTierBadgeExperimentalTooltip =>
      'Этот скрипт зависит от API Windows, который может вести себя ненадёжно на разных машинах. Проверьте его, прежде чем полагаться на него.';

  @override
  String get skapiTierBadgeBlocked => 'Скоро';

  @override
  String get skapiTierBadgeBlockedTooltip =>
      'Этот скрипт входит в запланированную библиотеку, но ещё не реализован.';

  @override
  String get skapiGroupSaveWorkTitle => 'Сохранение работы';

  @override
  String get skapiGroupSaveWorkDesc =>
      'Скрипты в этой группе сохраняют открытую работу на диск перед перерывом или неожиданным выключением. Когда устройство SmartKraft инициирует перерыв, выбранный скрипт автоматически сохраняет ваш файл в Word, Excel, VS Code или любом другом редакторе, чтобы даже при засыпании, выключении компьютера или выполнении другой команды ваша работа осталась в сохранности.';

  @override
  String get skapiGroupSaveWorkFoot =>
      'Типичное применение: автосохранение в начале перерыва, резервное сохранение документа при предупреждении о низком заряде или сохранение всего одной кнопкой.';

  @override
  String get skapiScriptSaveActiveWindowTitle => 'Сохранить активное окно';

  @override
  String get skapiScriptSaveActiveWindowSummaryWhat =>
      'Отправляет виртуальное Ctrl+S тому окну Windows, которое сейчас в фокусе, запуская собственное «сохранение» этого приложения.';

  @override
  String get skapiScriptSaveActiveWindowSummaryHow =>
      'Сначала получает дескриптор активного окна и записывает его заголовок. Затем отправляет Ctrl+S через SendKeys. Word сохраняет по текущему пути, VS Code пишет файл. Если появляется диалог «Сохранить как», скрипт ждёт ручного подтверждения пользователем.';

  @override
  String get skapiScriptSaveActiveWindowParamTimeoutLabel => 'тайм-аут';

  @override
  String get skapiScriptSaveActiveWindowParamTimeoutHint =>
      'Секунды ожидания после отправки нажатия, чтобы у приложения было время записать файл.';

  @override
  String get skapiScriptSaveActiveWindowParamVerboseLabel => 'подробный вывод';

  @override
  String get skapiScriptSaveAllOpenTitle => 'Сохранить все открытые документы';

  @override
  String get skapiScriptSaveAllOpenSummaryWhat =>
      'Перебирает белый список запущенных редакторов и просит каждый сохранить открытые документы.';

  @override
  String get skapiScriptSaveAllOpenSummaryHow =>
      'Для каждого найденного процесса из белого списка выводит на передний план главное окно, отправляет Ctrl+S, затем ждёт заданный для приложения тайм-аут перед переходом к следующему. Незапущенные приложения тихо пропускаются, если не включён подробный режим.';

  @override
  String get skapiScriptSaveAllOpenNote =>
      'Белый список по умолчанию: Word, Excel, PowerPoint и VS Code. Измените параметр apps, чтобы добавить свои.';

  @override
  String get skapiScriptSaveAllOpenParamAppsLabel => 'приложения';

  @override
  String get skapiScriptSaveAllOpenParamAppsHint =>
      'Имена процессов (без .exe), которым отправить сохранение. Порядок важен: ранние записи обрабатываются первыми.';

  @override
  String get skapiScriptSaveAllOpenParamTimeoutLabel =>
      'тайм-аут на приложение';

  @override
  String get skapiScriptSaveAllOpenParamVerboseLabel => 'подробный вывод';

  @override
  String get skapiScriptAutosaveTriggerTitle => 'Запустить автосохранение';

  @override
  String get skapiScriptAutosaveTriggerSummaryWhat =>
      'За один проход рассылает команду сохранения Windows каждому видимому окну верхнего уровня.';

  @override
  String get skapiScriptAutosaveTriggerSummaryHow =>
      'Перечисляет видимые окна, затем отправляет каждому WM_COMMAND со стандартным идентификатором сохранения. Приложения, прослушивающие это сообщение, реагируют так, будто вы нажали «Сохранить» в меню «Файл». Быстрее, чем Ctrl+S по каждому окну, но несколько приложений игнорируют рассылку.';

  @override
  String get skapiScriptAutosaveTriggerNote =>
      'Используйте, когда хотите сбросить все редакторы сразу и не против, что небольшое число приложений может не отреагировать. Сочетайте с save-all-open для более полного охвата.';

  @override
  String get skapiScriptAutosaveTriggerParamDelayLabel => 'задержка';

  @override
  String get skapiScriptAutosaveTriggerParamDelayHint =>
      'Секунды ожидания перед рассылкой, полезно, когда сначала должно появиться уведомление устройства о перерыве.';

  @override
  String get skapiScriptAutosaveTriggerParamVerboseLabel => 'подробный вывод';

  @override
  String get skapiScriptDetailSummaryWhatLabel => 'Что делает:';

  @override
  String get skapiScriptDetailSummaryHowLabel => 'Как работает:';

  @override
  String get skapiScriptDetailOriginalSectionTitle => 'Оригинальный скрипт';

  @override
  String get skapiScriptDetailOriginalSectionSub =>
      'только для чтения · английский';

  @override
  String get skapiScriptDetailEditingSectionTitle => 'Правки';

  @override
  String get skapiScriptDetailEditingNotYet => 'Пока нет правок';

  @override
  String get skapiScriptDetailEditingNotYetSub =>
      'Создайте копию на этом устройстве, не меняя оригинал.';

  @override
  String get skapiScriptDetailEditingModified => 'Изменено';

  @override
  String skapiScriptDetailEditingModifiedSub(String date) {
    return 'Последнее изменение $date.';
  }

  @override
  String get skapiScriptDetailEditingOutdated => 'Библиотека обновлена';

  @override
  String get skapiScriptDetailEditingOutdatedSub =>
      'Оригинал был изменён обновлением приложения. Сравните или сбросьте.';

  @override
  String get skapiScriptDetailParamWarnTitle =>
      'Проверьте параметры перед запуском';

  @override
  String get skapiScriptDetailParamWarnHint =>
      'Чтобы изменить эти значения, используйте «Изменить». Параметры задаются в блоке param() скрипта.';

  @override
  String get skapiScriptDetailNotesTitle => 'Примечания';

  @override
  String get skapiScriptDetailButtonRun => 'Запустить';

  @override
  String get skapiScriptDetailButtonBindAction => 'Привязать к действию';

  @override
  String get skapiScriptDetailButtonEdit => 'Изменить';

  @override
  String get skapiScriptDetailButtonView => 'Просмотр';

  @override
  String get skapiScriptDetailButtonReset => 'Сбросить';

  @override
  String get skapiScriptDetailButtonCompare => 'Сравнить';

  @override
  String get skapiScriptCopyButton => 'Копировать';

  @override
  String get skapiScriptCopyButtonDone => 'Скопировано';

  @override
  String get skapiScriptSelectButton => 'Выбрать';

  @override
  String get skapiEditorTitle => 'Изменить';

  @override
  String skapiEditorHint(String scriptId) {
    return '$scriptId · Вы редактируете копию на этом устройстве. Оригинальная версия из библиотеки не изменяется. «Сбросить» всегда восстанавливает оригинал.';
  }

  @override
  String get skapiEditorStatusBarTitle => 'POWERSHELL · UTF-8';

  @override
  String get skapiEditorStatusModified => '● Изменено';

  @override
  String get skapiEditorStatusUnmodified => 'Без изменений';

  @override
  String skapiEditorFootCursor(int line, int column) {
    return 'Строка $line · Столбец $column';
  }

  @override
  String get skapiEditorFootSaveLabel => 'Сохранить';

  @override
  String skapiEditorDiffLineCount(int count) {
    return 'Изменена $count строка';
  }

  @override
  String skapiEditorDiffLinesCount(int count) {
    return 'Изменено строк: $count';
  }

  @override
  String get skapiEditorDiffCompareLink => 'Сравнить с оригиналом';

  @override
  String get skapiEditorButtonReset => 'Сбросить';

  @override
  String get skapiEditorButtonSave => 'Сохранить';

  @override
  String get skapiEditorAfterSaveNote =>
      'После сохранения «Запустить» выполнит изменённую версию.';

  @override
  String get skapiLinuxDistroHeading => 'Выберите семейство дистрибутива';

  @override
  String get skapiLinuxDistroSubtitle =>
      'Скрипты Linux различаются между семействами на базе Debian (apt, .deb) и на базе Arch (pacman). Выберите то, что соответствует вашей машине.';

  @override
  String get skapiLinuxDistroDebianLabel => 'На базе Debian';

  @override
  String get skapiLinuxDistroDebianSub =>
      'Debian, Ubuntu, Mint, Pop!_OS, Elementary, Kali, MX, Zorin';

  @override
  String get skapiLinuxDistroArchLabel => 'На базе Arch';

  @override
  String get skapiLinuxDistroArchSub =>
      'Arch, Manjaro, EndeavourOS, Garuda (появится позже)';

  @override
  String get skapiNewActionNoDevicesTitle => 'Сначала сопрягите устройство';

  @override
  String get skapiNewActionNoDevicesBody =>
      'Для создания действия на устройстве нужно хотя бы одно сопряжённое устройство SmartKraft (пока BF).';

  @override
  String get skapiNewActionNoDevicesCta => 'Открыть «Устройства»';

  @override
  String get skapiNewActionPickDeviceTitle => 'Выберите устройство';

  @override
  String get skapiNewActionPickDeviceSubtitle =>
      'На каком устройстве должно жить это действие?';

  @override
  String get skapiUserNewTitle => 'Новый скрипт';

  @override
  String get skapiUserEditTitle => 'Изменить скрипт';

  @override
  String get skapiUserTitleLabel => 'Название';

  @override
  String get skapiUserTitleHint => 'например, Утренняя рутина';

  @override
  String get skapiUserDescLabel => 'Описание';

  @override
  String get skapiUserDescHint => 'Что делает этот скрипт?';

  @override
  String get skapiUserPlatformLabel => 'Платформа';

  @override
  String get skapiUserCodeLabel => 'Код';

  @override
  String get skapiUserCodeHint => '# Ваш код PowerShell здесь';

  @override
  String get skapiUserSaveCta => 'Сохранить';

  @override
  String get skapiUserValidationEmpty =>
      'Название и код не могут быть пустыми.';

  @override
  String get skapiUserSavedSnack => 'Скрипт сохранён';

  @override
  String get skapiUserSectionHeading => 'Мои скрипты';

  @override
  String skapiUserSectionSub(int count) {
    return '$count скриптов';
  }

  @override
  String get skapiUserEmptyHint =>
      'Пока нет ваших скриптов. Создайте один кнопкой «Новое действие» вверху справа.';

  @override
  String get skapiUserDetailCodeHeading => 'Код';

  @override
  String get skapiUserEditCta => 'Изменить';

  @override
  String get skapiUserDeleteConfirmTitle => 'Удалить скрипт?';

  @override
  String skapiUserDeleteConfirmBody(String name) {
    return '$name будет удалён без возможности восстановления.';
  }

  @override
  String get skapiUserDeletedSnack => 'Скрипт удалён';

  @override
  String get skapiUserRunCta => 'Запустить';

  @override
  String get skapiUserRunUnsupported =>
      'Запуск скриптов возможен только на ПК.';

  @override
  String get skapiUserRunOutputTitle => 'Вывод запуска';

  @override
  String skapiUserRunDone(int code) {
    return 'Завершено (выход $code)';
  }

  @override
  String get skapiLocalScriptsSubheading => 'Локальные скрипты';

  @override
  String get skapiOnDeviceApiSubheading => 'API на устройстве';

  @override
  String get skapiOnDeviceApiLoadError => 'Не удалось прочитать конечные точки';

  @override
  String get skapiOnDeviceApiRowHint =>
      'Нажмите любую строку, чтобы открыть редактор';

  @override
  String get commonLoading => 'Загрузка...';

  @override
  String get skapiApiTemplateSectionHeader => 'Шаблоны';

  @override
  String skapiApiTemplateSectionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count шаблонов',
      one: '1 шаблон',
    );
    return '$_temp0';
  }

  @override
  String get skapiApiTemplateUploadCta => 'Загрузить на устройство';

  @override
  String get skapiApiTemplateUploadHint =>
      'Загрузка записывает этот шаблон в один из 5 слотов USER API устройства. Устройство запускает его по собственному триггеру (BF: окончание отсчёта).';

  @override
  String get skapiApiTemplatePreviewTitle => 'Предпросмотр конечной точки';

  @override
  String get skapiApiTemplatePreviewType => 'Тип';

  @override
  String get skapiApiTemplatePreviewMethod => 'Метод';

  @override
  String get skapiApiTemplatePreviewUrl => 'URL';

  @override
  String get skapiApiTemplatePreviewAuth => 'Аутентификация';

  @override
  String get skapiApiTemplatePreviewHeader => 'Заголовок';

  @override
  String get skapiApiTemplatePreviewContentType => 'Content-Type';

  @override
  String get skapiApiTemplatePreviewPayload => 'Полезная нагрузка';

  @override
  String get skapiApiTemplatePreviewDelay => 'Задержка';

  @override
  String get skapiOtherCategoryHeading => 'Выберите категорию устройства';

  @override
  String get skapiOtherCategorySubtitle =>
      'Шаблоны загружаются на сопряжённое устройство и запускаются по его собственному триггеру (без участия ноутбука).';

  @override
  String get skapiOtherSyndimmSub => 'Умный диммер SmartKraft';

  @override
  String get skapiOtherLebensspurSub => 'Трекер активности SmartKraft';

  @override
  String get skapiOtherBlockingfocusSub => 'Таймер концентрации SmartKraft';

  @override
  String get skapiOtherIotSub =>
      'Сторонние IoT-вебхуки (IFTTT, Home Assistant, обычный REST)';

  @override
  String get skapiOtherServerSub =>
      'Самостоятельно размещённые HTTP-приёмники (n8n, Node-RED, свои)';

  @override
  String get skapiCategoryComingSoon => 'Шаблоны скоро появятся';

  @override
  String get skapiScriptLockSummaryHowLxDebian =>
      'Вызывает loginctl lock-session для текущего XDG_SESSION_ID; при отсутствии loginctl переходит к xdg-screensaver lock.';

  @override
  String get skapiScriptHibernateSummaryHowLxDebian =>
      'Вызывает systemctl hibernate. Необязательная задержка усыпляет на заданное число секунд перед переходом.';

  @override
  String get skapiScriptHibernateNoteLxDebian =>
      'Гибернацию нужно настроить (swap >= ОЗУ и параметр ядра resume=). В системах, где это не сделано, systemd-logind переходит в спящий режим.';

  @override
  String get skapiScriptSleepSummaryHowLxDebian =>
      'Вызывает systemctl suspend. Ядро может задержать переход, если активный ингибитор блокирует переход в простой.';

  @override
  String get skapiScriptShutdownSummaryHowLxDebian =>
      'Планирует корректное выключение через /sbin/shutdown -h +N (минуты). При отсутствии shutdown переходит к systemctl poweroff после заданной задержки.';

  @override
  String get skapiScriptShutdownNoteLxDebian =>
      '/sbin/shutdown принимает только минуты; значения меньше 60 округляются до 1 минуты. Другие вошедшие пользователи видят сообщение wall во время отсчёта.';

  @override
  String get skapiScriptShutdownParamForceHintLxDebian =>
      'Завершает сеанс пользователя перед выключением, чтобы пропустить 90-секундный период ожидания SIGTERM.';

  @override
  String get skapiScriptBrightnessSummaryHowLxDebian =>
      'Устанавливает яркость подсветки внутреннего дисплея через brightnessctl set N% (предпочтительно) или light -S N в качестве запасного варианта. Оба пишут в /sys/class/backlight.';

  @override
  String get skapiScriptBrightnessNoteLxDebian =>
      'brightnessctl работает без sudo, когда пользователь входит в группу video, что является значением по умолчанию после установки в большинстве конфигураций Debian. Внешние мониторы по DDC требуют ddcutil и здесь не обрабатываются.';

  @override
  String get skapiScriptMuteToggleSummaryHowLxDebian =>
      'Переключает или задаёт отключение звука основного приёмника через wpctl (PipeWire в Debian 12+) с запасным pactl для конфигураций PulseAudio.';

  @override
  String get skapiScriptVolumeSetSummaryHowLxDebian =>
      'Устанавливает громкость основного приёмника на уровень 0-100 через wpctl set-volume (PipeWire) или pactl set-sink-volume (PulseAudio).';

  @override
  String get skapiScriptVolumeSetNoteLxDebian =>
      'И PipeWire, и PulseAudio изначально предоставляют громкость по приложениям, поэтому на Linux этот скрипт уровня 1. Вывод выше 100% ограничивается для согласованности с другими платформами.';

  @override
  String get skapiScriptMediaKeySummaryHowLxDebian =>
      'Отправляет действие медиаклавиши через playerctl, который использует MPRIS для связи с приложением, владеющим сеансом (Spotify, Firefox, VLC, mpv, Rhythmbox).';

  @override
  String get skapiScriptMediaKeyNoteLxDebian =>
      'Если не запущено ни одно медиаприложение с поддержкой MPRIS, команда ничего не делает. Установите поддержку MPRIS для приложения, если известный плеер не реагирует.';

  @override
  String get skapiScriptMinimizeWindowSummaryHowLxDebian =>
      'Пустое processName сворачивает активное окно через xdotool. Иначе выбирает первое окно, чей WM_CLASS совпадает, и сворачивает его.';

  @override
  String get skapiScriptMinimizeWindowNoteLxDebian =>
      'Только X11. Сопоставление WM_CLASS чувствительно к регистру и зависит от того, как приложение себя объявило; при сомнениях проверьте xprop WM_CLASS.';

  @override
  String get skapiScriptMinimizeWindowParamProcessHintLxDebian =>
      'Имя экземпляра WM_CLASS (например: firefox, code, gnome-terminal-server). Пусто — нацелено на активное окно.';

  @override
  String get skapiScriptCloseWindowSummaryHowLxDebian =>
      'Отправляет WM_DELETE_WINDOW через wmctrl -x -c (по WM_CLASS) с запасным вариантом по заголовку. Эквивалентно нажатию кнопки X; приложение может показать собственный диалог сохранения.';

  @override
  String get skapiScriptCloseWindowNoteLxDebian =>
      'Только X11. Для Wayland предпочтительнее kill-app, использующий сигналы вместо оконного протокола.';

  @override
  String get skapiScriptCloseWindowParamProcessHintLxDebian =>
      'Имя экземпляра WM_CLASS; пусто — закрывает активное окно. В качестве запасного варианта используется совпадение по подстроке заголовка.';

  @override
  String get skapiScriptKillAppSummaryHowLxDebian =>
      'pkill -TERM -x по точному имени comm, ждёт заданный тайм-аут, затем pkill -KILL для всего, что ещё работает. Необязательный preKillSave сначала выводит окно на передний план и отправляет Ctrl+S (только X11).';

  @override
  String get skapiScriptKillAppNoteLxDebian =>
      'Имена comm в Linux ограничены ядром 15 символами. Используйте точные короткие имена: firefox (не firefox-esr-bin), code, soffice.bin.';

  @override
  String get skapiScriptKillAppParamProcessHintLxDebian =>
      'Точное имя comm (лимит ядра 15 символов). Используйте pgrep -l, чтобы проверить видимое имя.';

  @override
  String get skapiScriptKillAppParamPreKillSaveHintLxDebian =>
      'Отправить Ctrl+S окну приложения перед SIGTERM. Требует xdotool и X11; на Wayland игнорируется.';

  @override
  String get skapiScriptLaunchAppSummaryHowLxDebian =>
      'Умная диспетчеризация: .desktop -> gtk-launch, реальный путь к файлу -> exec, всё остальное -> xdg-open, наконец поиск в PATH. Дочерний процесс отвязывается через setsid, чтобы SKAPP не блокировался.';

  @override
  String get skapiScriptLaunchAppNoteLxDebian =>
      'args разбивается по пробелам. Аргументы с кавычками не поддерживаются; для сложных командных строк используйте скрипт-обёртку.';

  @override
  String get skapiScriptLaunchAppParamPathHintLxDebian =>
      'Имя бинарного файла в PATH, абсолютный путь, файл .desktop, URL или путь к файлу. xdg-open обрабатывает типы MIME.';

  @override
  String get skapiScriptDialogSummaryHowLxDebian =>
      'Открывает модальный диалог через zenity (GTK) с запасным kdialog (KDE). Пишет в stdout одно из ok / cancel / yes / no / timeout.';

  @override
  String get skapiScriptDialogNoteLxDebian =>
      'Установка: sudo apt install zenity. У пользователей KDE Plasma вместо него может быть kdialog. Без любого из них скрипт завершается с кодом 2.';

  @override
  String get skapiScriptToastSummaryHowLxDebian =>
      'Отправляет уведомление рабочего стола через notify-send (libnotify). Уровень 1, потому что libnotify-bin предустановлен на каждом современном рабочем столе Debian.';

  @override
  String get skapiScriptToastNoteLxDebian =>
      'icon принимает имена тем значков Freedesktop (dialog-information, dialog-warning, dialog-error). duration в секундах; 0 оставляет уведомление до закрытия.';

  @override
  String get skapiScriptToastParamIconLabelLxDebian => 'Значок';

  @override
  String get skapiScriptToastParamIconHintLxDebian =>
      'Имя значка Freedesktop, например: dialog-information, dialog-warning, dialog-error.';

  @override
  String get skapiScriptToastParamDurationLabelLxDebian => 'Длительность';

  @override
  String get skapiScriptToastParamDurationHintLxDebian =>
      'Автоматически закрыть через столько секунд. 0 означает, что уведомление остаётся, пока пользователь не закроет его.';

  @override
  String get skapiScriptShowDesktopSummaryHowLxDebian =>
      'Считывает состояние show-desktop по EWMH через wmctrl -m, затем переключает его через wmctrl -k. Повторяет семантику Win+D на X11.';

  @override
  String get skapiScriptShowDesktopNoteLxDebian =>
      'Только X11. Эквиваленты для Wayland зависят от композитора (Sway, Hyprland, расширения GNOME Shell).';

  @override
  String get skapiScriptFadeScreenSummaryHowLxDebian =>
      'Линейно меняет яркость подсветки внутреннего дисплея от текущей к целевой за заданную длительность через brightnessctl шагами по 10 в секунду.';

  @override
  String get skapiScriptFadeScreenNoteLxDebian =>
      'Только внутренние панели. Внешние мониторы по DDC требуют ddcutil и здесь не обрабатываются. Уровень 2, потому что чтение текущей подсветки зависит от видимости /sys/class/backlight.';

  @override
  String get skapiScriptGrayscaleSummaryHowLxDebian =>
      'Переключает ключ насыщенности цвета у лупы специальных возможностей GNOME (0.0 — оттенки серого, 1.0 — цвет) через gsettings, без расширений.';

  @override
  String get skapiScriptGrayscaleNoteLxDebian =>
      'Только GNOME / Unity. У KDE Plasma и XFCE нет эквивалентного системного пути; на этих рабочих столах скрипт завершается с кодом 3 вместо тихого бездействия.';

  @override
  String get skapiScriptFindMouseShakeSummaryHowLxDebian =>
      'Считывает позицию курсора через xdotool getmouselocation, затем рисует круг вокруг неё заданное число циклов, используя координаты cos/sin, вычисленные через awk.';

  @override
  String get skapiScriptFindMouseShakeNoteLxDebian =>
      'Только X11. Wayland блокирует синтетическое движение указателя на уровне протокола (граница безопасности), поэтому скрипт завершается с кодом 3.';

  @override
  String get skapiScriptCloseWithSaveSummaryHowLxDebian =>
      'Для каждого видимого окна, совпадающего по WM_CLASS: активировать, Ctrl+S, подождать, затем отправить WM_DELETE_WINDOW через wmctrl. Только X11.';

  @override
  String get skapiScriptCloseWithSaveNoteLxDebian =>
      'Уровень 2: инъекция клавиши Ctrl+S зависит от локали и фокуса; предсказуемо ведут себя только истинные семантики сохранения. Чаты или веб-приложения могут привязывать Ctrl+S к чему-то другому.';

  @override
  String get skapiScriptCloseWithSaveParamProcessHintLxDebian =>
      'Имя экземпляра WM_CLASS (см. xprop WM_CLASS). Обязательно.';

  @override
  String get skapiScriptCloseAllInstancesSummaryHowLxDebian =>
      'Отправляет SIGTERM каждому запущенному процессу, совпадающему по точному имени comm. Каждое приложение само обрабатывает завершение (и может показать собственный диалог сохранения).';

  @override
  String get skapiScriptCloseAllInstancesParamProcessHintLxDebian =>
      'Точное имя comm, как показывает pgrep -l. Обязательно.';

  @override
  String get skapiScriptBrowserCloseAllSummaryHowLxDebian =>
      'Перебирает список бинарных файлов браузеров Debian (firefox, firefox-esr, chromium, google-chrome, brave, vivaldi-bin, opera) и отправляет SIGTERM каждому запущенному экземпляру.';

  @override
  String get skapiScriptBrowserCloseAllNoteLxDebian =>
      'Браузеры сохраняют сеанс, если включено «восстанавливать вкладки при следующем запуске», поэтому это скорее мягкое «выключить экран», чем действие с потерей данных.';

  @override
  String get skapiScriptSaveActiveWindowSummaryHowLxDebian =>
      'Отправляет Ctrl+S активному окну через xdotool key --clearmodifiers. Только X11.';

  @override
  String get skapiScriptSaveActiveWindowNoteLxDebian =>
      'Wayland блокирует синтетическую инъекцию клавиш на уровне протокола. Используйте запасной autosave-trigger или полагайтесь на собственное автосохранение приложения.';

  @override
  String get skapiScriptSaveAllOpenSummaryHowLxDebian =>
      'Перебирает список приложений, находит видимые окна каждого, поочерёдно активирует их и отправляет Ctrl+S с паузами между ними.';

  @override
  String get skapiScriptSaveAllOpenNoteLxDebian =>
      'Список приложений по умолчанию охватывает LibreOffice (soffice.bin), VS Code (code), gedit и kate. Передайте --apps \"name1,name2\" для переопределения. Только X11.';

  @override
  String get skapiScriptSaveAllOpenParamAppsHintLxDebian =>
      'Имена comm через запятую, например: soffice.bin,code,gedit.';

  @override
  String get skapiScriptAutosaveTriggerSummaryHowLxDebian =>
      'Перебирает каждое видимое окно верхнего уровня через wmctrl -l, поочерёдно активирует их и отправляет Ctrl+S. В X11 нет пути рассылки WIN WM_COMMAND, поэтому запасной вариант — фокус по каждому окну.';

  @override
  String get skapiScriptAutosaveTriggerNoteLxDebian =>
      'Уровень 2: зависит от того, что активное приложение трактует Ctrl+S как «сохранить». Большинство редакторов так и делают; чаты могут истолковать иначе. Только X11.';

  @override
  String get commonReadFailed => 'не удалось прочитать';

  @override
  String get commonUnknown => 'неизвестно';

  @override
  String get commonComingSoon => 'скоро';

  @override
  String get commonDismiss => 'Закрыть';

  @override
  String bootstrapBannerError(String error) {
    return 'Не удалось прочитать с устройства: $error';
  }

  @override
  String get bootstrapBannerRetry => 'Повторить';

  @override
  String get bfApiChainAuthNone => 'Нет';

  @override
  String get bfApiChainAuthBearer => 'Bearer-токен';

  @override
  String get bfApiChainAuthBasic => 'Basic-аутентификация';

  @override
  String get bfApiChainAuthHeader => 'Свой заголовок';

  @override
  String bfApiChainMasterError(String error) {
    return 'Мастер: $error';
  }

  @override
  String get bfApiChainChainStarted => 'Цепочка запущена';

  @override
  String bfApiChainChainError(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get bfApiChainSaveDialogTitle => 'Сохранить конечную точку?';

  @override
  String bfApiChainSaveDialogBody(String name) {
    return '«$name» будет сохранена на устройстве. Это обновит область пользовательских данных.';
  }

  @override
  String get bfApiChainSaveDialogConfirm => 'Сохранить';

  @override
  String bfApiChainSavedToast(String name) {
    return '«$name» сохранена';
  }

  @override
  String bfApiChainSaveFailed(String error) {
    return 'Не удалось сохранить: $error';
  }

  @override
  String get bfApiChainDeleteDialogTitle => 'Удалить?';

  @override
  String bfApiChainDeleteDialogBody(String name) {
    return 'Конечная точка «$name» будет удалена с устройства. Это действие нельзя отменить.';
  }

  @override
  String get bfApiChainDeleteDialogConfirm => 'Удалить';

  @override
  String bfApiChainDeletedToast(String name) {
    return '«$name» удалена';
  }

  @override
  String bfApiChainDeleteFailed(String error) {
    return 'Не удалось удалить: $error';
  }

  @override
  String bfApiChainTestNoReply(String name) {
    return '«$name» нет ответа (тайм-аут 15 с)';
  }

  @override
  String bfApiChainTestSuccess(String name, String httpSuffix) {
    return '«$name» успешно$httpSuffix';
  }

  @override
  String bfApiChainTestFailure(String name, String error, String httpSuffix) {
    return '«$name» ошибка: $error$httpSuffix';
  }

  @override
  String bfApiChainTestTriggerFailed(String error) {
    return 'Не удалось запустить: $error';
  }

  @override
  String get bfApiChainNewEndpointName => 'Новая конечная точка';

  @override
  String get bfApiChainEmptyTitle => 'Конечные точки ещё не зарегистрированы';

  @override
  String get bfApiChainEmptyBody =>
      'Используйте карточку «Добавить конечную точку» ниже, чтобы определить новый HTTP-вызов (например, вебхук IFTTT, ваш собственный сервер, пауза Spotify).';

  @override
  String get bfApiChainSystemSectionTitle =>
      'Автоматически (сопряжённые SKAPP)';

  @override
  String get bfApiChainSystemSectionSubtitle =>
      'Когда вы привязываете скрипт через SKAPI, для каждого компьютера автоматически открывается слот. По окончании отсчёта подписанный вебхук уходит к SKAPP на том компьютере.';

  @override
  String get bfApiChainUserSectionTitle => 'Вручную (IoT-устройства)';

  @override
  String get bfApiChainUserSectionSubtitle =>
      'Добавляйте сторонние URL (Shelly, Home Assistant, IFTTT) вручную. По окончании отсчёта этот список срабатывает первым, по порядку.';

  @override
  String get bfApiChainMasterToggleLabel => 'Триггер активен';

  @override
  String get bfApiChainMasterOnSubtitle =>
      'Мастер включён: цепочка срабатывает по триггерам устройства';

  @override
  String get bfApiChainMasterOffSubtitle =>
      'Мастер выключен: ни одна конечная точка не будет вызвана';

  @override
  String get bfApiChainFieldNameLabel => 'Имя';

  @override
  String get bfApiChainTypeLabel => 'Тип';

  @override
  String get bfApiChainEventOrApplet => 'Событие / апплет';

  @override
  String get bfApiChainMethodLabel => 'Метод';

  @override
  String get bfApiChainDelayLabel => 'Ждать после (0-300 с)';

  @override
  String get bfApiChainDelayUnit => 'с';

  @override
  String get bfApiChainAdvancedHide => 'Скрыть дополнительные параметры';

  @override
  String get bfApiChainAdvancedShow => 'Дополнительные параметры';

  @override
  String get bfApiChainAuthLabel => 'Аутентификация';

  @override
  String bfApiChainCurrentTokenHint(String masked) {
    return 'Текущий токен: $masked (введите новое значение ниже, чтобы обновить)';
  }

  @override
  String get bfApiChainNewTokenLabel =>
      'Новый токен (оставьте пустым, чтобы сохранить)';

  @override
  String get bfApiChainContentTypeLabel => 'Content-Type';

  @override
  String get bfApiChainSaveCta => 'Сохранить';

  @override
  String get bfApiChainDeleteCta => 'Удалить';

  @override
  String get bfApiChainTestCta => 'Тест';

  @override
  String get bfApiChainAddCardLabel => 'Добавить новую конечную точку';

  @override
  String bfApiChainSavedDelaySeconds(int count) {
    return 'ожидание $count с';
  }

  @override
  String get bfApiChainNotSaved => 'не сохранено';

  @override
  String bfApiChainSystemRowSignedTooltip(String peer, int delay) {
    return 'узел $peer…  ·  задержка $delay с  ·  подписано (HMAC)';
  }

  @override
  String get bfApiChainTestEndpointTooltip => 'Проверить эту конечную точку';

  @override
  String get bfLogsBufferEmpty => 'Буфер журнала устройства пуст.';

  @override
  String get bfLogsUnsupported =>
      'Устройство не поддерживает журналы в этой прошивке.';

  @override
  String get deviceLogsNoClockBanner =>
      'Часы устройства не установлены; метки времени показаны как секунды с момента загрузки.';

  @override
  String get deviceLogsTruncatedHint =>
      '(вывод усечён, попробуйте меньший лимит или более высокий уровень важности)';

  @override
  String get bfEventsTimerRunning => 'Отсчёт начат';

  @override
  String get bfEventsTimerPaused => 'Отсчёт приостановлен';

  @override
  String get bfEventsTimerIdle => 'Отсчёт сброшен';

  @override
  String get bfEventsTimerCooldown => 'Перерыв';

  @override
  String get bfEventsTimerExpired => 'Отсчёт завершён';

  @override
  String bfEventsFaceChanged(String from, String to) {
    return 'Грань изменена: $from → $to';
  }

  @override
  String bfEventsApiTriggered(String type) {
    return '$type запущен';
  }

  @override
  String get bfEventsApiTriggeredFallback => 'API запущен';

  @override
  String bfEventsBatteryLevel(int percent) {
    return 'Уровень заряда: %$percent';
  }

  @override
  String get bfEventsDeviceRestarted => 'Устройство перезапущено';

  @override
  String skapiManifestLoadingRetry(String platform, String scriptId) {
    return 'Загружается манифест $platform/$scriptId, повторите через мгновение';
  }

  @override
  String get skapiListenerOffMobileTitle =>
      'Это устройство не может выполнять скрипты ПК';

  @override
  String get skapiListenerOffDesktopTitle => 'HTTP-слушатель SKAPP выключен';

  @override
  String get skapiListenerOffMobileBody =>
      'По окончании отсчёта скрипты будут выполняться на Windows / macOS / Linux. SKAPP должен быть открыт, а слушатель — активен. Этот телефон — лишь сторона настройки; выполнение происходит на ПК.';

  @override
  String skapiListenerOffDesktopBody(String lastErrorSuffix) {
    return 'BF отправит вебхук, но его никто не поймает, потому что слушатель выключен. Откройте Настройки → HTTP-слушатель SKAPP.$lastErrorSuffix';
  }

  @override
  String get skapiSyncBadgeWriting => 'Запись на BF…';

  @override
  String get skapiSyncBadgeWritten => 'Сохранено на BF';

  @override
  String get skapiSyncBadgeFailed => 'Не удалось записать на BF';

  @override
  String skapiSyncBadgeFirmwareCodeTooltip(String code) {
    return 'Код прошивки: $code';
  }

  @override
  String get syncErrUnknownCommand =>
      'Старая прошивка на устройстве. Прошейте новую прошивку';

  @override
  String get syncErrNotAuthenticated =>
      'Сеанс устройства не авторизован (возможно, нужно сопрячься заново)';

  @override
  String get syncErrNotFound => 'На устройстве нет записи о сопряжении';

  @override
  String get syncErrInternal => 'Возможно, все 8 слотов SYSTEM заняты';

  @override
  String get syncErrUnknown => 'неизвестная ошибка';

  @override
  String get syncErrTimeout => 'Устройство не ответило (не в сети?)';

  @override
  String get syncErrNoBond => 'Нет сопряжения с этим устройством';

  @override
  String get syncErrConnect => 'Не удалось подключиться к устройству';

  @override
  String get discoveryFilterShowAll => 'Показать все устройства';

  @override
  String get discoveryFilterOnlySmartKraft => 'Только SmartKraft';

  @override
  String discoveryScanningWithCount(int count, String tail) {
    return 'Сканирование… найдено устройств: $count$tail';
  }

  @override
  String discoveryFoundCountWithTail(int count, String tail) {
    return 'Найдено устройств: $count$tail';
  }

  @override
  String discoveryFilterOff(int visible, int sk, String tail) {
    return 'Фильтр выключен · показано устройств: $visible ($sk SmartKraft$tail)';
  }

  @override
  String discoveryMdnsTail(int count) {
    return ' + $count в сети';
  }

  @override
  String get discoveryWifiOnlySnack =>
      'Это устройство сейчас видно только по Wi-Fi. Сопряжение по Wi-Fi пока не активно, коротко нажмите кнопку устройства, чтобы открыть окно сопряжения. Как только оно станет видно и по BLE, эта строка станет доступной для сопряжения.';

  @override
  String get discoveryBadgePairable => 'Доступно для сопряжения';

  @override
  String get discoveryBadgeBonded => 'Сопряжено с другим SKAPP';

  @override
  String get pairingTitleConnecting => 'Подключение';

  @override
  String get pairingTitleReconnecting => 'Переподключение';

  @override
  String get pairingMutualAuthHmacSubtitle => 'Запрос-ответ HMAC';

  @override
  String pairingBleConnectFailed(String error) {
    return 'Не удалось подключиться по BLE.\n\nРешение: коротко нажмите кнопку устройства, чтобы открыть 60-секундное окно сопряжения, затем нажмите «Повторить».\n\nПодробности: $error';
  }

  @override
  String get pairingGattServiceMissing => 'Служба SKAPP не найдена';

  @override
  String get pairingGattCmdRxMissing => 'Отсутствует характеристика cmd_rx';

  @override
  String get pairingGattEventTxMissing => 'Отсутствует характеристика event_tx';

  @override
  String pairingGattDiscoveryFailed(String error) {
    return 'Сбой обнаружения GATT: $error';
  }

  @override
  String pairingKeySendFailed(String error) {
    return 'Не удалось отправить ключ: $error';
  }

  @override
  String pairingDeviceNoReply(int seconds) {
    return 'Устройство не ответило ($seconds с).';
  }

  @override
  String pairingDeviceRejected(String error) {
    return 'Устройство отклонило: $error';
  }

  @override
  String get pairingInvalidReplyMissingPub =>
      'Некорректный ответ устройства (отсутствует our_pub).';

  @override
  String pairingHexDecodeFailed(String error) {
    return 'Ошибка hex-декодирования our_pub: $error';
  }

  @override
  String get pairingRetryButton => 'Повторить';

  @override
  String pairingReconnectTransient(String error) {
    return 'Не удалось связаться с устройством; существующее сопряжение сохранено.\n\nУбедитесь, что устройство включено и находится в зоне действия, затем нажмите «Повторить».\n\nПодробности: $error';
  }

  @override
  String get pairingRecoveryTitle => 'Обновить сопряжение';

  @override
  String get pairingRecoveryBody =>
      'Устройство не распознаёт текущее сопряжение. Чтобы начать новое, нажмите кнопку сопряжения устройства, чтобы открыть 60-секундное окно, затем нажмите «Продолжить».';

  @override
  String get pairingRecoveryContinue => 'Продолжить';

  @override
  String get pairingRecoveryCancelled =>
      'Обновление сопряжения отменено. Старое сопряжение сохранено; нажмите «Повторить», чтобы попытаться подключиться позже.';

  @override
  String get pairingRenewBondButton => 'Обновить сопряжение';

  @override
  String wifiPasswordConnectionRejected(String error) {
    return 'Подключение отклонено: $error';
  }

  @override
  String get wifiPasswordTimeout => 'Устройство не ответило (тайм-аут).';

  @override
  String wifiScanRejected(String error) {
    return 'Устройство отклонило wifi.scan: $error\n\nВозможно, модуль Wi-Fi устройства не запустился; попробуйте перезагрузку.';
  }

  @override
  String wifiScanUnexpectedReply(String data) {
    return 'Неожиданный ответ wifi.scan: $data';
  }

  @override
  String wifiScanTimeout(String error) {
    return 'Устройство не ответило (тайм-аут: $error).\n\nПодойдите ближе к устройству, коротко нажмите его кнопку (чтобы запустить вещание) и повторите.';
  }

  @override
  String wifiScanConnectionError(String error) {
    return 'Ошибка подключения: $error';
  }

  @override
  String get wifiScanHeaderHelp =>
      'Ниже показаны сети Wi-Fi, которые видит **устройство** (а не сети телефона). Выберите сеть, к которой должно подключиться устройство; пароль запрашивается на следующем шаге.';

  @override
  String get wifiScanAuthOpen => 'Открытая';

  @override
  String get wifiScanAuthEncrypted => 'Зашифрованная';

  @override
  String get wifiSuccessSyncing => 'Синхронизация времени…';

  @override
  String get wifiSuccessFetchingInfo => 'Получение сведений об устройстве…';

  @override
  String get wifiSuccessPreparingUi => 'Подготовка интерфейса устройства…';

  @override
  String wifiSuccessManifestRejected(String error) {
    return 'device.manifest отклонён ($error). Возможно, старая прошивка; для BF должен быть загружен sk_baseline.c.';
  }

  @override
  String get wifiSuccessTapToContinue => 'Нажмите, чтобы продолжить…';

  @override
  String get deviceHomeUnsupportedTitle => 'Неподдерживаемое устройство';

  @override
  String deviceHomeUnsupportedBody(String name) {
    return 'У $name нет экрана устройства в этой версии SKAPP. Когда добавится новое семейство устройств, этот экран появится автоматически.';
  }

  @override
  String get lsPairingUnpairTitle => 'Отвязать это приложение';

  @override
  String get lsPairingUnpairBody =>
      'Устройство забудет привязку этого приложения. Потребуется заново выполнить сопряжение (удержание кнопки 3 с + выбор в «Устройствах»).';

  @override
  String get skYakindaBadgeDefault => 'скоро';

  @override
  String get skapiScriptPulseBrightnessTitle => 'Пульсация яркости';

  @override
  String get skapiScriptPulseBrightnessSummaryWhat =>
      'Модулирует яркость внутреннего дисплея по плавной косинусоиде между 100% и нижней границей, повторяя заданное число раз. В конце восстанавливается исходная яркость пользователя.';

  @override
  String get skapiScriptPulseBrightnessSummaryHow =>
      'Считывает текущую яркость через WMI, затем записывает выборку яркости 20 раз в секунду по косинусоиде. При выходе всегда восстанавливает сохранённый оригинал.';

  @override
  String get skapiScriptPulseBrightnessNote =>
      'Только внутренние панели (ноутбуки, планшеты). Внешние мониторы DDC/CI не реагируют на этот путь WMI.';

  @override
  String get skapiScriptPulseBrightnessParamPeriodLabel => 'период';

  @override
  String get skapiScriptPulseBrightnessParamPeriodHint =>
      'Секунды на один полный цикл ярко -> тускло -> ярко. Около 2 ощущается как чёткая пульсация без резкости.';

  @override
  String get skapiScriptPulseBrightnessParamLowPercentLabel => 'нижний %';

  @override
  String get skapiScriptPulseBrightnessParamLowPercentHint =>
      'Тусклый край пульсации, в процентах от полной яркости. Меньшие числа делают пульсацию заметнее.';

  @override
  String get skapiScriptPulseBrightnessParamCyclesLabel => 'циклы';

  @override
  String get skapiScriptPulseBrightnessParamCyclesHint =>
      'Сколько полных циклов пульсации выполнить перед выходом.';

  @override
  String get skapiScriptBlurTimedTitle => 'Размытый перерыв';

  @override
  String get skapiScriptBlurTimedSummaryWhat =>
      'Закрывает экран полноэкранной полупрозрачной завесой поверх всех окон на заданное число секунд. По центру показывается обратный отсчёт.';

  @override
  String get skapiScriptBlurTimedSummaryHow =>
      'Открывает безрамочное окно WPF с AllowsTransparency и сплошной цветовой заливкой заданной прозрачности. Таймер диспетчера ведёт отсчёт; окно закрывается само, когда таймер достигает нуля.';

  @override
  String get skapiScriptBlurTimedNote =>
      'Прагматичное промежуточное решение: реальное гауссово размытие рабочего стола требует помощника C++/Win2D, который появится позже. Сплошная завеса тем временем создаёт похожее ощущение «не могу сосредоточиться на экране, пора сделать перерыв».';

  @override
  String get skapiScriptBlurTimedParamDurationLabel => 'длительность';

  @override
  String get skapiScriptBlurTimedParamDurationHint =>
      'Секунды, в течение которых завеса остаётся, прежде чем закрыться автоматически.';

  @override
  String get skapiScriptBlurTimedParamOpacityLabel => 'непрозрачность';

  @override
  String get skapiScriptBlurTimedParamOpacityHint =>
      'Непрозрачность завесы от 0.0 (невидима) до 1.0 (сплошная). Около 0.55 ещё пропускает рабочий стол достаточно, чтобы он ощущался завешенным, а не полностью затемнённым.';

  @override
  String get skapiScriptBlurTimedParamColorLabel => 'цвет';

  @override
  String get skapiScriptBlurTimedParamColorHint =>
      'Цвет завесы в hex #RRGGBB. По умолчанию палитровый чёрный #0A0A0A; более светлые кремовые тона ощущаются спокойнее.';

  @override
  String get skapiScriptBlockingFocusTitle => 'Blocking Focus';

  @override
  String get skapiScriptBlockingFocusSummaryWhat =>
      'Составной механизм концентрации: сохраняет все открытые документы Office и VS Code, затем открывает полноэкранное окно обратного отсчёта поверх всех окон без кнопки закрытия, при этом курсор мыши непрерывно движется по кругу. Когда таймер достигает нуля, всё отменяется автоматически.';

  @override
  String get skapiScriptBlockingFocusSummaryHow =>
      'Три фазы выполняются одна за другой: (1) фаза сохранения вызывает Office COM и VS Code CLI; (2) параллельный runspace ведёт курсор по кругу, пока не сработает синхронизированный флаг остановки; (3) окно STA WPF показывает заголовок и обратный отсчёт. Блок finally восстанавливает исходную позицию курсора и сворачивает оба runspace.';

  @override
  String get skapiScriptBlockingFocusNote =>
      'Мягкий режим: Esc и Alt+F4 НЕ блокируются. Пользователь всегда может выйти через Диспетчер задач. Строгий режим с глобальными перехватчиками клавиатуры будет отдельным скриптом.';

  @override
  String get skapiScriptBlockingFocusParamDurationLabel => 'длительность';

  @override
  String get skapiScriptBlockingFocusParamDurationHint =>
      'Секунды, в течение которых длится блокировка. Обратный отсчёт идёт до 00:00, затем всё восстанавливается.';

  @override
  String get skapiScriptBlockingFocusParamTitleLabel => 'заголовок';

  @override
  String get skapiScriptBlockingFocusParamTitleHint =>
      'Текст по центру полноэкранного окна. Держите его коротким — по умолчанию «Blocking Focus».';

  @override
  String get skapiScriptBlockingFocusParamShakeRadiusLabel => 'радиус движения';

  @override
  String get skapiScriptBlockingFocusParamShakeRadiusHint =>
      'Пиксели, на которые курсор удаляется от исходной точки во время цикла. Большие круги сильнее требуют внимания.';

  @override
  String get skapiScriptBlockingFocusParamEnableSaveLabel =>
      'сохранять при старте';

  @override
  String get skapiScriptBlockingFocusParamEnableSaveHint =>
      'Выполнить фазу сохранения Office + VS Code перед блокировкой. Отключите, когда нет состояния документов, которое нужно защитить.';

  @override
  String get trayFirstHideToast =>
      'SKAPP продолжает работать в фоне. Найдите его в системном трее; правый клик для выхода.';

  @override
  String devicesOfflineTapHint(String name) {
    return '$name не в сети.';
  }

  @override
  String skapiNewActionDeviceOffline(String name) {
    return '$name не в сети. Подключите устройство к сети, чтобы создать новое действие.';
  }

  @override
  String get bfApiChainRefreshDirtyTitle => 'Несохранённые изменения';

  @override
  String get bfApiChainRefreshDirtyBody =>
      'Обновление загрузит с устройства актуальный список конечных точек и отбросит черновик, который вы ещё не сохранили.';

  @override
  String get bfApiChainRefreshDirtyConfirm => 'Всё равно обновить';

  @override
  String get skapiApiEditorTitle => 'API на устройстве';

  @override
  String get lsCommonReadFailed => 'Не удалось прочитать';

  @override
  String lsCommonFailedWith(String err) {
    return 'Сбой: $err';
  }

  @override
  String get lsVacationStatusOff => 'Выкл';

  @override
  String lsVacationStatusUntil(String date) {
    return 'До $date';
  }

  @override
  String get lsVacationDaysValidationError => 'Дней должно быть от 1 до 60';

  @override
  String lsVacationStartedSnack(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Отпуск начат · $days дней',
      one: 'Отпуск начат · 1 день',
    );
    return '$_temp0';
  }

  @override
  String get lsVacationCancelledSnack => 'Отпуск отменён';

  @override
  String lsVacationActiveUntilFmt(String date) {
    return 'Активно до $date';
  }

  @override
  String get lsVacationResumeHint =>
      'Отсчёт возобновится по окончании отпуска.';

  @override
  String get lsVacationCancellingButton => 'Отмена…';

  @override
  String get lsVacationCancelButton => 'Отменить отпуск';

  @override
  String get lsVacationDaysLabel => 'Дней';

  @override
  String get lsVacationDaysHint =>
      'Приостанавливает отсчёт на указанное число дней (от 1 до 60).';

  @override
  String get lsVacationStartingButton => 'Запуск…';

  @override
  String get lsVacationStartButton => 'Начать отпуск';

  @override
  String get lsCommonSavingButton => 'Сохранение…';

  @override
  String get lsCommonSaveButton => 'Сохранить';

  @override
  String lsCommonSaveFailedWith(String err) {
    return 'Не удалось сохранить: $err';
  }

  @override
  String get lsDurationValueValidationError =>
      'Значение должно быть от 1 до 60';

  @override
  String get lsDurationAlarmsValidationError =>
      'Число сигналов должно быть от 0 до 10';

  @override
  String get lsDurationConfiguredSnack => 'Таймер настроен';

  @override
  String lsDurationUnitMinute(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value минут',
      one: '1 минута',
    );
    return '$_temp0';
  }

  @override
  String lsDurationUnitHour(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value часов',
      one: '1 час',
    );
    return '$_temp0';
  }

  @override
  String lsDurationUnitDay(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value дней',
      one: '1 день',
    );
    return '$_temp0';
  }

  @override
  String lsDurationAlarmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сигналов',
      one: '1 сигнал',
    );
    return '$_temp0';
  }

  @override
  String get lsDurationUnitLabel => 'Единица';

  @override
  String get lsDurationUnitMinutesPlural => 'минут';

  @override
  String get lsDurationUnitHoursPlural => 'часов';

  @override
  String get lsDurationUnitDaysPlural => 'дней';

  @override
  String get lsDurationValueLabel => 'Значение';

  @override
  String get lsDurationValueHint => 'от 1 до 60';

  @override
  String get lsDurationAlarmCountLabel => 'Число сигналов';

  @override
  String get lsDurationAlarmCountHint =>
      'Сигналы срабатывают от конца назад, с интервалом в одну единицу.';

  @override
  String get lsSmtpStatusNotConfigured => 'Не настроено';

  @override
  String get lsSmtpHostRequired => 'Требуется хост';

  @override
  String get lsSmtpPortValidationError => 'Порт должен быть от 1 до 65535';

  @override
  String get lsSmtpSenderRequired => 'Требуется адрес отправителя';

  @override
  String get lsSmtpFieldHost => 'Хост';

  @override
  String get lsSmtpFieldPort => 'Порт';

  @override
  String get lsSmtpFieldSender => 'Отправитель';

  @override
  String get lsSmtpFieldKey => 'Ключ';

  @override
  String lsSmtpSaveHaltedOn(String err) {
    return 'Сохранение остановлено на $err';
  }

  @override
  String get lsSmtpSavedSnack => 'SMTP сохранён';

  @override
  String get lsSmtpTestSentSnack => 'Тестовое письмо отправлено';

  @override
  String lsSmtpTestFailedWith(String err) {
    return 'Тест не пройден: $err';
  }

  @override
  String get lsSmtpUrlCopiedSnack => 'URL скопирован в буфер обмена';

  @override
  String get lsSmtpApiKeyPlaceholder => 'Пароль приложения Gmail / ключ API';

  @override
  String get lsSmtpServerLabel => 'Сервер';

  @override
  String get lsSmtpApiKeyLabel => 'Ключ API';

  @override
  String get lsSmtpApiKeyHint =>
      'Оставьте пустым, чтобы сохранить текущий ключ.';

  @override
  String get lsSmtpAppPasswordHelpLink =>
      'Как получить пароль приложения Gmail';

  @override
  String get lsSmtpSendingButton => 'Отправка…';

  @override
  String get lsSmtpSendTestButton => 'Отправить тест';

  @override
  String get lsReminderMailRecipientValidation =>
      'Получатель должен быть похож на адрес эл. почты';

  @override
  String get lsReminderMailSavedSnack => 'Напоминание сохранено локально';

  @override
  String get lsReminderMailRecipientFirstSnack => 'Сначала укажите получателя';

  @override
  String get lsReminderMailTestOkSnack =>
      'Тест SMTP пройден, учётные данные доходят до сервера';

  @override
  String lsReminderMailTestFailedWith(String err) {
    return 'Тест SMTP не пройден: $err';
  }

  @override
  String get lsReminderMailRecipientLabel => 'Эл. почта получателя';

  @override
  String get lsReminderMailSubjectLabel => 'Тема';

  @override
  String get lsReminderMailBodyLabel => 'Текст';

  @override
  String get lsReminderMailBodyHint => 'Ваш отсчёт скоро сработает...';

  @override
  String get lsReminderMailActiveLabel => 'Активно';

  @override
  String get lsReminderMailFootnote =>
      'Сохранено локально на этом устройстве. Тестовая отправка лишь проверяет доступность SMTP-сервера; автозапуск по timer.alarm ожидает поддержки прошивки.';

  @override
  String get lsResetApiStatusDisabled => 'Отключено';

  @override
  String lsResetApiStatusEnabledPort(int port) {
    return 'Включено · порт $port';
  }

  @override
  String get lsResetApiRegenDialogTitle => 'Сгенерировать ключ API заново?';

  @override
  String get lsResetApiRegenDialogBody =>
      'Это сделает текущий ключ недействительным. Любой вызывающий, использующий прежний ключ, будет отклонён, пока вы его не обновите. Продолжить?';

  @override
  String get lsResetApiRegenConfirm => 'Сгенерировать заново';

  @override
  String get lsResetApiKeyRegeneratedSnack => 'Ключ сгенерирован заново';

  @override
  String get lsResetApiEnabledLabel => 'Включено';

  @override
  String get lsResetApiEnabledHint =>
      'Когда включено, HTTP GET к URL конечной точки с подходящим ключом сбрасывает отсчёт.';

  @override
  String get lsResetApiEndpointUrlLabel => 'URL конечной точки';

  @override
  String get lsResetApiUrlNotAvailable => '(недоступно)';

  @override
  String get lsResetApiCopyUrlTooltip => 'Копировать URL';

  @override
  String get lsResetApiKeyLabel => 'Ключ API';

  @override
  String get lsResetApiKeyNotSet => '(не задан)';

  @override
  String get lsResetApiExampleLabel => 'Пример';

  @override
  String get lsResetApiRegenerateButton => 'Сгенерировать ключ заново';

  @override
  String get lsAlarmApiUrlValidation =>
      'URL должен начинаться с http:// или https://';

  @override
  String get lsAlarmApiHeadersValidation =>
      'Поле заголовков должно быть корректным JSON';

  @override
  String get lsAlarmApiSaveDialogTitle => 'Сохранить конечную точку вебхука?';

  @override
  String lsAlarmApiSaveDialogBody(String name, String url) {
    return 'Сохраняет `$name` на устройстве с указанием на:\n$url';
  }

  @override
  String get lsAlarmApiSavedSnack => 'Вебхук сохранён';

  @override
  String get lsAlarmApiDisabledSnack => 'Вебхук отключён';

  @override
  String get lsAlarmApiTestQueuedSnack =>
      'Тест поставлен в очередь, следите за вышестоящим сервисом';

  @override
  String lsAlarmApiTestFailedWith(String err) {
    return 'Тест не пройден: $err';
  }

  @override
  String get lsAlarmApiRemoveDialogTitle => 'Удалить вебхук?';

  @override
  String lsAlarmApiRemoveDialogBody(String name) {
    return 'Удаляет `$name` с устройства. Локальная конфигурация сохраняется.';
  }

  @override
  String get lsAlarmApiRemoveButton => 'Удалить';

  @override
  String lsAlarmApiRemoveFailedWith(String err) {
    return 'Не удалось удалить: $err';
  }

  @override
  String get lsAlarmApiConfiguredStatus => 'Настроено';

  @override
  String lsAlarmApiConfiguredHost(String host) {
    return 'Настроено · $host';
  }

  @override
  String get lsAlarmApiUrlLabel => 'URL';

  @override
  String get lsAlarmApiMethodLabel => 'HTTP-метод';

  @override
  String get lsAlarmApiHeadersLabel => 'Заголовки (JSON, необязательно)';

  @override
  String get lsAlarmApiHeadersHint =>
      'Объект JSON с необязательными заголовками. Сохраняется локально; прошивка применяет при срабатывании.';

  @override
  String get lsAlarmApiBodyTemplateLabel => 'Шаблон тела (JSON)';

  @override
  String get lsAlarmApiBodyTemplateHint =>
      'Заполнители device и remaining_sec подставляются в момент срабатывания.';

  @override
  String get lsAlarmApiBearerLabel => 'Bearer-токен (необязательно)';

  @override
  String get lsAlarmApiFootnote =>
      'Подписчик прошивки на событие timer.alarm ожидается. Эта конфигурация сохраняет конечную точку; она не сработает автоматически до следующего обновления прошивки.';

  @override
  String lsRelaySummarySeconds(int seconds) {
    return '$seconds с';
  }

  @override
  String lsRelaySummaryMinutes(int minutes) {
    return '$minutes мин';
  }

  @override
  String get lsRelayModePulse => 'импульс';

  @override
  String get lsRelayModeSteady => 'постоянно';

  @override
  String lsRelaySummaryFmt(int gpio, String duration, String mode) {
    return 'GPIO $gpio · $duration $mode';
  }

  @override
  String get lsRelayGpioValidation => 'GPIO должен быть от 0 до 30';

  @override
  String get lsRelayDurationValidation =>
      'Длительность должна быть от 1 до 3600 секунд';

  @override
  String get lsRelayPulseValidation =>
      'Полупериод импульса должен быть от 1 до 60';

  @override
  String lsRelayCmdFailedWith(String cmd, String err) {
    return 'Сбой $cmd: $err';
  }

  @override
  String get lsRelayConfiguredSnack => 'Реле настроено';

  @override
  String get lsRelayFireAbortedSnack => 'Срабатывание прервано';

  @override
  String get lsRelayForcedIdleSnack => 'Реле принудительно отключено';

  @override
  String get lsRelayGpioLabel => 'Вывод GPIO';

  @override
  String get lsRelayGpioHint =>
      'Допустимый вывод ESP32-C6; по умолчанию 19 = D8';

  @override
  String get lsRelayInvertLabel => 'Инвертировать полярность';

  @override
  String get lsRelayStartDelayLabel => 'Задержка старта';

  @override
  String lsRelayStartDelayHint(int sec) {
    return '$sec с до активации реле';
  }

  @override
  String get lsRelayActiveDurationLabel => 'Длительность активности';

  @override
  String get lsRelayUnitSeconds => 'Секунды';

  @override
  String get lsRelayUnitMinutes => 'Минуты';

  @override
  String get lsRelayPulseModeLabel => 'Режим импульса';

  @override
  String get lsRelayPulseModeHint =>
      'Вкл = полупериод 1 с. «Свой» позволяет задать полупериод.';

  @override
  String get lsRelayHalfCycleLabel => 'Полупериод, секунды';

  @override
  String get lsRelayFiringButton => 'Срабатывание…';

  @override
  String get lsRelayTestRelayButton => 'Проверить реле';

  @override
  String get lsRelayAbortButton => 'Прервать';

  @override
  String get lsRelayForceOffButton => 'Принудительно выкл';

  @override
  String get lsRelayPulseOff => 'Выкл';

  @override
  String get lsRelayPulseOn => 'Вкл';

  @override
  String get lsRelayPulseCustom => 'Свой';

  @override
  String get lsRelayPhaseActiveBadge => 'активно';

  @override
  String lsRelayPhaseLine(String phase, String elapsed) {
    return 'Фаза: $phase$elapsed';
  }

  @override
  String get lsTelegramTokenRequired => 'Требуется токен бота';

  @override
  String get lsTelegramChatRequired => 'Требуется ID чата';

  @override
  String get lsTelegramSaveDialogTitle => 'Сохранить конечную точку Telegram?';

  @override
  String lsTelegramSaveDialogBody(String name) {
    return 'Сохраняет `$name` на устройстве. Токен отправляется в URL.';
  }

  @override
  String get lsTelegramSavedSnack => 'Конечная точка Telegram сохранена';

  @override
  String get lsTelegramDisabledSnack => 'Конечная точка Telegram отключена';

  @override
  String get lsTelegramTestQueuedSnack =>
      'Тест поставлен в очередь, следите за чатом Telegram';

  @override
  String get lsTelegramRemoveDialogTitle => 'Удалить конечную точку Telegram?';

  @override
  String get lsTelegramBotConfiguredStatus => 'Бот настроен';

  @override
  String get lsTelegramBotTokenLabel => 'Токен бота';

  @override
  String get lsTelegramBotTokenHint =>
      'Получите его у @BotFather (выглядит как 1234567:AAH...).';

  @override
  String get lsTelegramChatIdLabel => 'ID чата';

  @override
  String get lsTelegramChatIdHint =>
      'Числовой id (-100...) или имя канала @channel.';

  @override
  String get lsTelegramMessageTemplateLabel => 'Шаблон сообщения';

  @override
  String get lsTelegramMessageHint => 'LebensSpur: сработал сигнал.';

  @override
  String get lsLsApiUrlRequired => 'Требуется URL';

  @override
  String get lsLsApiUpdatedSnack => 'Вебхук обновлён';

  @override
  String get lsLsApiSavedSnack => 'Вебхук сохранён';

  @override
  String get lsLsApiSaveFirstSnack => 'Сначала сохраните вебхук';

  @override
  String get lsLsApiTestQueuedSnack =>
      'Тест поставлен в очередь, проверьте приёмник';

  @override
  String get lsLsApiRemoveDialogBody =>
      'Вебхук LS будет удалён с устройства. Отсчёт больше не будет его запускать.';

  @override
  String get lsLsApiRemovedSnack => 'Вебхук удалён';

  @override
  String get lsLsApiConfirmCriticalTitle => 'Подтвердите критическое изменение';

  @override
  String lsLsApiConfirmCriticalBody(String cmd, int ttlSec) {
    return 'Устройство просит подтвердить:\n  $cmd\n\nЭтот токен истекает через $ttlSec с.';
  }

  @override
  String get lsLsApiConfirmButton => 'Подтвердить';

  @override
  String lsLsApiActiveSlot(String name) {
    return 'Активно · слот «$name»';
  }

  @override
  String lsLsApiActiveWithToken(String name, String token) {
    return 'Активно · слот «$name» · токен $token';
  }

  @override
  String get lsLsApiUrlHint =>
      'Срабатывает при timer.triggered. Рекомендуется https://.';

  @override
  String get lsLsApiHeadersLabel => 'Заголовки (JSON)';

  @override
  String get lsLsApiHeadersHint =>
      'Дополнительно: пока не подключено через CLI. Зарезервировано для будущего выпуска.';

  @override
  String get lsLsApiBodyTemplateHint =>
      'Отправляется как тестовая полезная нагрузка. Заполнитель device заменяется на стороне сервера.';

  @override
  String lsLsApiBearerHintExisting(String token) {
    return 'Сейчас задано: $token. Оставьте пустым, чтобы сохранить, или вставьте новое значение, чтобы перезаписать.';
  }

  @override
  String get lsLsApiBearerHintEmpty =>
      'Отправляется как `Authorization: Bearer <token>`.';

  @override
  String get lsLsApiUpdateButton => 'Обновить';

  @override
  String lsMailGroupsStatusFmt(int count, int max, int recipients) {
    return '$count из $max · всего получателей: $recipients';
  }

  @override
  String lsMailGroupsReadFailedWith(String err) {
    return 'Не удалось прочитать: $err';
  }

  @override
  String get lsMailGroupsNameValidation =>
      'Имя должно быть от 1 до 47 символов';

  @override
  String get lsMailGroupsNameSaved => 'Имя сохранено';

  @override
  String get lsMailGroupsSubjectValidation =>
      'Тема должна быть не более 127 символов';

  @override
  String get lsMailGroupsSubjectSaved => 'Тема сохранена';

  @override
  String get lsMailGroupsBodyValidation =>
      'Текст должен быть не более 511 символов';

  @override
  String get lsMailGroupsBodySaved => 'Текст сохранён';

  @override
  String get lsMailGroupsEmailValidation =>
      'Введите корректный адрес эл. почты';

  @override
  String lsMailGroupsMaxReached(int max) {
    return 'Максимум $max групп';
  }

  @override
  String get lsMailGroupsNameEmpty => 'Имя не может быть пустым';

  @override
  String get lsMailGroupsCreatedSnack => 'Группа создана';

  @override
  String lsMailGroupsCreateFailedWith(String err) {
    return 'Не удалось создать: $err';
  }

  @override
  String get lsMailGroupsDeleteDialogTitle => 'Удалить группу?';

  @override
  String get lsMailGroupsDeleteDialogBody =>
      'Это удалит группу и всех её получателей на устройстве.';

  @override
  String get lsMailGroupsDeleteConfirm => 'Удалить';

  @override
  String get lsMailGroupsDeletedSnack => 'Группа удалена';

  @override
  String lsMailGroupsDefaultName(int n) {
    return 'Группа $n';
  }

  @override
  String get lsMailGroupsNewGroupTitle => 'Новая почтовая группа';

  @override
  String get lsMailGroupsGroupNameLabel => 'Имя группы';

  @override
  String get lsMailGroupsCreateConfirm => 'Создать';

  @override
  String get lsMailGroupsEmptyHint =>
      'Пока нет групп. Создайте одну, чтобы отправлять почту при срабатывании таймера.';

  @override
  String get lsMailGroupsWorkingButton => 'Выполнение…';

  @override
  String get lsMailGroupsCreateNewButton => '+ Создать новую группу';

  @override
  String lsMailGroupsHeaderCount(int count, int max) {
    return 'Настроено групп: $count из $max';
  }

  @override
  String lsMailGroupsHeaderTotalRecipients(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'всего $count получателей',
      one: 'всего 1 получатель',
    );
    return '· $_temp0';
  }

  @override
  String get lsMailGroupsUnnamed => '(без имени)';

  @override
  String lsMailGroupsRowSummary(int count, String state) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count получателей',
      one: '1 получатель',
    );
    return '$_temp0 · $state';
  }

  @override
  String get lsMailGroupsEnabled => 'включено';

  @override
  String get lsMailGroupsDisabled => 'отключено';

  @override
  String get lsMailGroupsNameLabel => 'Имя';

  @override
  String get lsMailGroupsSubjectLabel => 'Тема';

  @override
  String get lsMailGroupsSaveBodyButton => 'Сохранить текст';

  @override
  String get lsMailGroupsDeleteGroupButton => 'Удалить группу';

  @override
  String lsMailGroupsRecipientsHeader(int count) {
    return 'Получатели ($count)';
  }

  @override
  String get lsMailGroupsNoRecipients => 'Пока нет получателей.';

  @override
  String get lsMailGroupsAddRecipientButton => 'Добавить';

  @override
  String get lsHomeStatusLoading => 'Загрузка…';

  @override
  String get lsHomeLogsTooltip => 'Журналы';

  @override
  String get lsHomeClusterConfiguration => 'КОНФИГУРАЦИЯ';

  @override
  String get lsHomeClusterTriggerActions => 'ДЕЙСТВИЯ-ТРИГГЕРЫ';

  @override
  String get lsHomeClusterEarlyWarning => 'РАННЕЕ ПРЕДУПРЕЖДЕНИЕ';

  @override
  String get lsHomeSectionDurationTitle => 'Длительность и сигналы';

  @override
  String get lsHomeSectionVacationTitle => 'Режим отпуска';

  @override
  String get lsHomeSectionSmtpTitle => 'Настройка почты (SMTP)';

  @override
  String get lsHomeSectionResetApiTitle => 'Конечная точка Reset API';

  @override
  String get lsHomeSectionMailGroupsTitle => 'Почтовые группы';

  @override
  String get lsHomeSectionRelayTitle => 'Реле';

  @override
  String get lsHomeSectionLsApiTitle => 'Вебхук LS API';

  @override
  String get lsHomeSectionTelegramTitle => 'Telegram';

  @override
  String get lsHomeSectionReminderMailTitle => 'Письмо-напоминание';

  @override
  String get lsHomeSectionAlarmApiTitle => 'Вебхук Alarm API';

  @override
  String get lsHomeStateInactive => 'НЕАКТИВНО';

  @override
  String get lsHomeStateRemaining => 'ОСТАЛОСЬ';

  @override
  String get lsHomeStateVacation => 'ОТПУСК';

  @override
  String get lsHomeStateTriggered => 'СРАБОТАЛО';

  @override
  String get lsHomeChipBle => 'BLE';

  @override
  String get lsHomeChipMail => 'Почта';

  @override
  String get lsHomeEarlyWarningPendingNote =>
      'Действия раннего предупреждения срабатывают по timer.alarm. Подписчик прошивки ожидается; эти конфигурации сохраняются, но пока не сработают автоматически.';

  @override
  String get settingsDiagnosticsTitle => 'Диагностика';

  @override
  String get settingsDiagnosticsSubtitle => 'Журналы для отладки проблем';

  @override
  String get diagnosticsCopyLogs => 'Копировать журналы';

  @override
  String get diagnosticsOpenFolder => 'Открыть папку';

  @override
  String get diagnosticsOpenFolderFailed =>
      'Не удалось открыть папку журналов.';

  @override
  String get diagnosticsShareLogs => 'Поделиться журналами';

  @override
  String get diagnosticsClearLogs => 'Очистить журналы';

  @override
  String get diagnosticsCopied => 'Журналы скопированы в буфер обмена';

  @override
  String get diagnosticsCleared => 'Журналы очищены';

  @override
  String get aboutPrivacyLabel => 'Политика конфиденциальности';

  @override
  String get updateChecking => 'Проверка обновлений…';

  @override
  String get updateUpToDate => 'У вас установлена последняя версия';

  @override
  String get updateCheckFailed => 'Не удалось проверить обновления';

  @override
  String get updateAvailableTitle => 'Доступно обновление';

  @override
  String updateAvailableBody(String version, String current) {
    return 'Доступна новая версия ($version). У вас установлена $current.';
  }

  @override
  String get updateDownloadAction => 'Загрузить';

  @override
  String get updateLater => 'Позже';
}
