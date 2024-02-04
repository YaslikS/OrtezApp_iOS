import UIKit

struct AppStrings {
    

    static let continueBtnText = "continue_btn_text".localized
    static let skipBtnText = "skip_btn_text".localized
    static let cancelBtnText = "cancel_btn_text".localized
    static let acceptBtnText = "accept_btn_text".localized
    static let connectBtnText = "connect_btn_text".localized
    static let startBtnText = "start_btn_text".localized
    static let ready = "ready".localized
    static let save = "save".localized
    static let start = "start".localized
    static let close = "close".localized
    static let yes = "yes".localized
    static let ok = "Хорошо"
    static let replace = "Редактировать"
    static let description = "Описание"
    static let remove = "Удалить"
    static let programm = "Моя новая программа"
    static let done = "Готово"
    static let user = "Методика пользователя"
    static let first = "Нажмите + для создания методики воздействия с индивидуальными настройками"
    static let second = "Протестируйте методику не выходя из режима настроек, нажав кнопку “Протестировать”."
    static let third = "Для редактирования настроек созданной методики нажмите и удерживайте ее карточку до появления выпадающего меню. Выберите в меню пункт “Редактирование”."
    static let fourth = "Для полного удаления созданной методики нажмите и удерживайте ее карточку до появления выпадающего меню. Выберите в меню пункт “Удалить”."
    struct Urls {
        static let ortezURL = "https://www.ortez.ru/"
    }
    
    struct Keys {
        static let yaMetrica = "6eb7f800-f680-43d1-8e70-0c0098fc9319"
    }
    
    // MARK: Device strings
    struct Device {
        static let connectInfo = "connect_info".localized
        static let deviceSearching = "device_searching".localized
        static let shoulderJoint = "shoulder_joint".localized
        static let devicesNotFound = "devices_not_found".localized
        static let connectionProblem = "connection_problem".localized
        static let successConnect = "success_connect".localized
        static let setDeviceName = "set_device_name".localized
        static let deviceNameExample = "device_name_example".localized
        static let deviceNamePlaceholder = "device_name_placeholder".localized
        static let deviceNameEmptyMessage = "device_name_empty_message".localized
        static let devicesNotConnectToBGSTitle = "devices_not_connect_to_BGS_title".localized
        static let devicesNotConnectToBGSMessage = "devices_not_connect_to_BGS_message".localized
        static let devicesConnectionLost = "devices_connection_lost".localized
        static let deviceManager = "device_manager".localized
        static let editDeviceListShort = "edit_device_list_short".localized
        static let devicesPreview = "devices_preview".localized
        static let devicesPreviewTextLink = "devices_preview_text_link".localized
        static let myDevices = "my_devices".localized
        static let needAccessBluetooth = "need_access_bluetooth".localized
        static let openBluetoothSettings = "open_bluetooth_settings".localized
        static let devicesNotConnected = "devices_not_connected".localized
        static let typeNotFound = "type_not_found".localized
    }
    
    // MARK: Screens strings
    struct Main {
        static let contraindications =  "contraindications".localized
        static let askConnectDevice = "ask_connect_device".localized
        static let needConnectDevice = "need_connect_cevice".localized
        static let connectingDevice =  "connecting_device".localized
        static let devicesNotFound = "devices_not_found".localized
        static let connectionError = "connection_error".localized
        static let connectionSuccess = "connection_success".localized
        static let setDeviceName = "set_device_name".localized
        static let devicesNotConnected = "devices_not_connected".localized
        static let programsList = "programs_list".localized
        static let devicesPreview = "devices_preview".localized
        static let connectionLost = "connection_lost".localized
        static let info =  "info".localized
        static let deviceManager = "device_manager".localized
        static let optionsWithoutDevice = "options_without_device".localized
        static let optionsWithDevice = "options_with_device".localized
        static let deviceStatus =  "device_status".localized
        static let programPlaylist =   "program_playlist".localized
        static let player = "player".localized
        static let playerSettings =  "player_settings".localized
        static let playerReturnPause = "player_return_pause".localized
        static let playerResult = "player_result".localized
        
        static let settingsFreeModeChm = "settings_free_mode_chm".localized
        static let settingsFreeModeAm =  "settings_free_mode_am".localized
        static let freeMode = "free_mode".localized
        static let newProgram = "new_program".localized
        static let saveNewFreeProgramConfirm = "save_new_free_program_confirm".localized
    }

    struct Contraindications {
        static let title = "title".localized
        static let infoText = "info_text".localized
        static let pregnancy = "pregnancy".localized
        static let hernia = "hernia".localized
        static let head = "head" .localized
        static let epilepsy = "epilepsy" .localized
        static let injury = "injury".localized
        static let ischemia = "ischemia".localized
        static let skinDisease = "skin_disease".localized
        static let understand = "understand".localized
    }
    
    struct Information {
        static let message = "message".localized
    }
    
    struct DevicesPreview {
        static let nameDevice1 = "name_device1".localized
        static let descriptionDevice1 = "description_device1".localized
        static let nameDevice2 = "name_device2".localized
        static let descriptionDevice2 = "description_device2".localized
        static let nameDevice3 = "name_device3".localized
        static let descriptionDevice3 = "description_device3".localized
        static let nameDevice4 = "name_device4".localized
        static let descriptionDevice4 = "description_device4".localized
    }
    
    struct Options {
        static let writeDevelopers = "write_developers".localized
        static let showDevicesPreview = "show_dvices_preview".localized
        static let contraindications = "contraindications_title".localized
        static let deviceManager = "device_manager".localized
        static let aboutApp = "about_app".localized
        static let devicesNotConnected = "devices_not_connected_info".localized
    }
    
    struct ProgramsList {
        static let power = "Мощность не может быть равно 0"
        static let freemodeInfo = "Теперь устройство само по себе"
        static let forWord = "forWord".localized
        static let title = "title_programms".localized
        static let titleEl = "title_electrodes".localized
        static let freeModeTitle = "free_mode_title".localized
        static let freeModeDescription = "free_mode_description".localized
        static let freeModeIconName = "ic_free"
        static let useAsInPhoto = "use_as_in_photo".localized
        static let regulateText = "regulate_text".localized
        static let stage = "stage".localized
        static let useInfo = "use_info".localized
        static let saveNewProgram = "save_new_program".localized
        static let newProgramBaseName = "new_program_base_name".localized
        static let description = "description".localized
        static let freeMode =  "free_mode".localized
        static let clearSettings =  "clear_settings".localized
        static let freeModeMessage = "free_mode_message".localized
        static let freeModeGeneration = "free_mode_generation".localized
        static let freeModeFrequencyAm =  "free_mode_frequency_am".localized
        static let freeModeFrequencyFm = "free_mode_frequency_fm" .localized
        static let freeModePower =  "free_mode_power".localized
        static let freeModeFrequency = "free_mode_frequency" .localized
        static let freeModeIntensity = "free_mode_intensity".localized
        static let freeModeConfirmClear = "free_mode_confirm_clear".localized
        static let newProgramDurationMin =  "new_program_duration_min".localized
        static let newProgramTesting = "new_program_Testing".localized
        static let modulationAm =  "modulation_am".localized
        static let modeAm = "mode_am".localized
        static let saveTheUserProgramm = "Сохранить программу"
        static let removeProgram = "Вы действительно хотите удалить"
        static let am = "(AM)"
        static let fm = "(FM)"
        static let userProgramm = "Программа пользователя"
        static let bigPowerAlertTitle   = "Attention".localized
        static let bigPowerAlertMessage = "bigPower".localized
    }

    
    struct DeviceStatus {
        static let title = "device_status_title" .localized
        static let code = "code_BGS".localized
        static let firmwareNumber = "firmware_number" .localized
        static let battery = "battery".localized
        static let rssi = "rssi".localized
        static let type = "type".localized
        static let powerFirst = "power_first".localized
        static let powerSecond = "power_second".localized
    }
    
    struct Player {
        static let messagePause = "message_pause".localized
        static let timeLeft = "time_left".localized
        static let minutes = "minutes".localized
        static let returnPauseTitle = "return_pause_title".localized
        static let returnPauseMessage = "return_pause_message".localized
        static let resultTitle = "result_title".localized
        static let clearSettingsButton = "clear_settings_button".localized
        static let maxPowerStats = "max_power_stats".localized
        static let mediumPowerStats =  "medium_power_stats".localized
        static let test = "Проверка настроек пользовательской программы"
        static let freeMode = "Соединение с утройством может быть разорвано, но сброс настроек не произойдет"
        static let leftTime = "5:00"
        static let startTime = "0:00"
    }

    struct PlayerSettings {
        static let title = "current_stage_settings_title".localized
        static let modulation = "modulation".localized
        static let mode = "mode".localized
        static let frequency = "frequency".localized
        static let intensity = "intensity".localized
        static let duration = "duration".localized
        static let recommendation = "recommendation".localized
        static let hz = "hz".localized
        static let continuous = "continuous".localized
    }
    
}
