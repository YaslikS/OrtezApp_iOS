//import UIKit
//
//class MainViewController: UIViewController {
//
//    @IBOutlet weak var tableView: UITableView!
//    
//    private enum MenuItem {
//        case contraindications
//        case askConnectDevice
//        case needConnectDevice
//        case connectingDevice
//        case devicesNotFound
//        case connectionError
//        case connectionSuccess
//        case setDeviceName
//        case devicesNotConnected
//        case programsList
//        case devicesPreview
//        case connectionLost
//        case info
//        case deviceManager
//        case optionsWithoutDevice
//        case optionsWithDevice
//        case deviceStatus
//        case programPlaylist
//        case player
//        case playerSettings
//        case playerReturnPause
//        case playerResult
//        case settingsFreeModeChm
//        case settingsFreeModeAm
//        case freeMode
//        case newProgram
//        case saveNewFreeProgramConfirm
//        
//        var value: String {
//            var result: String
//            
//            switch self {
//            case .contraindications:
//                result = AppStrings.Main.contraindications
//            case .askConnectDevice:
//                result = AppStrings.Main.askConnectDevice
//            case .needConnectDevice:
//                result = AppStrings.Main.needConnectDevice
//            case .connectingDevice:
//                result = AppStrings.Main.connectingDevice
//            case .devicesNotFound:
//                result = AppStrings.Main.devicesNotFound
//            case .connectionError:
//                result = AppStrings.Main.connectionError
//            case .connectionSuccess:
//                result = AppStrings.Main.connectionSuccess
//            case .setDeviceName:
//                result = AppStrings.Main.setDeviceName
//            case .devicesNotConnected:
//                result = AppStrings.Main.devicesNotConnected
//            case .programsList:
//                result = AppStrings.Main.programsList
//            case .devicesPreview:
//                result = AppStrings.Main.devicesPreview
//            case .connectionLost:
//                result = AppStrings.Main.connectionLost
//            case .info:
//                result = AppStrings.Main.info
//            case .deviceManager:
//                result = AppStrings.Main.deviceManager
//            case .optionsWithoutDevice:
//                result = AppStrings.Main.optionsWithoutDevice
//            case .optionsWithDevice:
//                result = AppStrings.Main.optionsWithDevice
//            case .deviceStatus:
//                result = AppStrings.Main.deviceStatus
//            case .programPlaylist:
//                result = AppStrings.Main.programPlaylist
//            case .player:
//                result = AppStrings.Main.player
//            case .playerSettings:
//                result = AppStrings.Main.playerSettings
//            case .playerReturnPause:
//                result = AppStrings.Main.playerReturnPause
//            case .playerResult:
//                result = AppStrings.Main.playerResult
//            case .settingsFreeModeChm:
//                result = AppStrings.Main.settingsFreeModeChm
//            case .settingsFreeModeAm:
//                result = AppStrings.Main.settingsFreeModeAm
//            case .freeMode:
//                result = AppStrings.Main.freeMode
//            case .newProgram:
//                result = AppStrings.Main.newProgram
//            case .saveNewFreeProgramConfirm:
//                result = AppStrings.Main.saveNewFreeProgramConfirm
//            }
//            
//            return result
//        }
//    }
//    
//    private let items: [MenuItem] = [
//        .contraindications,
//        .askConnectDevice,
//        .needConnectDevice,
//        .connectingDevice,
//        .devicesNotFound,
//        .connectionError,
//        .connectionSuccess,
//        .setDeviceName,
//        .devicesNotConnected,
//        .programsList,
//        .devicesPreview,
//        .connectionLost,
//        .info,
//        .deviceManager,
//        .optionsWithoutDevice,
//        .optionsWithDevice,
//        .deviceStatus,
//        .programPlaylist,
//        .player,
//        .playerSettings,
//        .playerReturnPause,
//        .playerResult,
//        .settingsFreeModeChm,
//        .settingsFreeModeAm,
//        .freeMode,
//        .newProgram,
//        .saveNewFreeProgramConfirm,
//    ]
//    private let heightTableViewRow: CGFloat = 48
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setUI()
//    }
//    
//    private func setUI() {
//        if let appName = Bundle.main.infoDictionary!["CFBundleName"] as? String {
//            self.title = appName
//        }
//        
//        // TableView
//        tableView.contentInsetAdjustmentBehavior = .never
//        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        if #available(iOS 15.0, *) {
//            tableView.sectionHeaderTopPadding = 0
//        }
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        tableView.delegate = self
//        tableView.dataSource = self
//    }
//    
//    private func handleTapItem(item: MenuItem) {
//        var nextViewController: UIViewController
//        
//        switch item {
//        case .contraindications:
//            nextViewController = ContraindicationsViewController(nibName: String(describing: ContraindicationsViewController.self), bundle: nil, isFromOptions: false)
//        case .askConnectDevice:
//            nextViewController = AskConnectDeviceViewController(nibName: String(describing: AskConnectDeviceViewController.self), bundle: nil)
//        case .needConnectDevice:
//            nextViewController = NeedConnectDeviceViewController(nibName: String(describing: NeedConnectDeviceViewController.self), bundle: nil)
//        case .connectingDevice:
//            nextViewController = ConnectingDeviceViewController(nibName: String(describing: ConnectingDeviceViewController.self), bundle: nil)
//        case .devicesNotFound:
//            nextViewController = ConnectionErrorViewController(nibName: String(describing: ConnectionErrorViewController.self), bundle: nil, state: ConnectionErrorViewController.State.devicesNotFound, fromLostConnect: false)
//        case .connectionError:
//            nextViewController = ConnectionErrorViewController(nibName: String(describing: ConnectionErrorViewController.self), bundle: nil, state: ConnectionErrorViewController.State.connectionError, fromLostConnect: false)
//        case .connectionSuccess:
//            nextViewController = SuccessConnectionViewController(nibName: String(describing: SuccessConnectionViewController.self), bundle: nil, deviceMac: "12345")
//        case .setDeviceName:
//            nextViewController = SetDeviceNameViewController(nibName: String(describing: SetDeviceNameViewController.self), bundle: nil, deviceManager: DeviceManager.shared, deviceMac: "12345")
//        case .devicesNotConnected:
//            nextViewController = DevicesNotConnectedViewController(nibName: String(describing: DevicesNotConnectedViewController.self), bundle: nil)
//        case .programsList:
//            nextViewController = ProgramsListViewController(nibName: String(describing: ProgramsListViewController.self), bundle: nil)
//        case .devicesPreview:
//            nextViewController = DevicesPreviewViewController(nibName: String(describing: DevicesPreviewViewController.self), bundle: nil)
//        case .connectionLost:
//            nextViewController = DevicesConnectionLostViewController(nibName: String(describing: DevicesConnectionLostViewController.self), bundle: nil, lostDeviceMac: "")
//        case .info:
//            nextViewController = InformationViewController(nibName: String(describing: InformationViewController.self), bundle: nil)
//        case .deviceManager:
//            nextViewController = DeviceManagerViewController(nibName: String(describing: DeviceManagerViewController.self), bundle: nil)
//        case .optionsWithoutDevice:
//            nextViewController = OptionsViewController(nibName: String(describing: OptionsViewController.self), bundle: nil)
//        case .optionsWithDevice:
//            nextViewController = OptionsViewController(nibName: String(describing: OptionsViewController.self), bundle: nil)
//        case .deviceStatus:
//            let deviceStatus = DeviceStatus(code: "1212-1212", firmwareNumber: 65, rssi: -60, type: "Коленный", powerFirst: 12, powerSecond: 10)
//            let device = Device(name: "Устройство 2", mac: "00:AB:CD:EF:11:22", battery: 80, status: deviceStatus)
//            nextViewController = DeviceStatusViewController(nibName: String(describing: DeviceStatusViewController.self), bundle: nil, device: device)
//        case .player:
//            let device = Device(name: "ОРТЕЗ-1", mac: "00:AB:CD:EF:11:22", battery: 80)
//            //nextViewController = PlayerViewController(nibName: String(describing: PlayerViewController.self), bundle: nil, device: device)
//            nextViewController = UIViewController()
//        case .playerReturnPause:
//            //nextViewController = PlayerReturnPauseViewController(nibName: String(describing: PlayerReturnPauseViewController.self), bundle: nil)
//            nextViewController = UIViewController()
//            return
//        case .programPlaylist:
//            let device = Device(name: "ОРТЕЗ-1", mac: "00:AB:CD:EF:11:22", battery: 80)
//            let program = ProgramListItem(id: 1, title: AppStrings.ProgramsList.freeModeTitle, description: AppStrings.ProgramsList.freeModeDescription, file: "", icon: AppStrings.ProgramsList.freeModeIconName, stage: [])
//            nextViewController = PlaylistViewController(nibName: String(describing: PlaylistViewController.self), bundle: nil, device: device, program: program)
//        case .playerResult:
//            nextViewController = PlayerResultViewController(nibName: String(describing: PlayerResultViewController.self), bundle: nil, charachteristic: SessionCharachteristic(maxPower: 80, midPOwer: 30, sessionTime: "5:00"))
//        case .freeMode:
//            nextViewController = FreeModeViewController(nibName: String(describing: FreeModeViewController.self), bundle: nil)
//        case .saveNewFreeProgramConfirm:
//            nextViewController = ProgramsListViewController(nibName: String(describing: ProgramsListViewController.self), bundle: nil)
//        case .settingsFreeModeChm:
//            let settings = FreeModeSettings(generation: false, frequencyAm: false, frequencyAmValue: 2, frequencyFm: true, power: 60, frequency: 1, intensity: 1)
//            nextViewController = SettingsFreeModeViewController(nibName: String(describing: SettingsFreeModeViewController.self), bundle: nil, settings: settings)
//        case .settingsFreeModeAm:
//            let settings = FreeModeSettings(generation: false, frequencyAm: true, frequencyAmValue: 2, frequencyFm: true, power: 60, frequency: 1, intensity: 1)
//            nextViewController = SettingsFreeModeViewController(nibName: String(describing: SettingsFreeModeViewController.self), bundle: nil, settings: settings)
//        case .newProgram:
//            let settings = NewProgramSettings(generation: false, frequencyAm: false, frequencyAmValue: 2, power: 60, frequency: 1, intensity: 1, durationMin: 1)
//            let device = Device(name: "ОРТЕЗ-1", mac: "00:AB:CD:EF:11:22", battery: 80)
//            nextViewController = NewProgramViewController(nibName: String(describing: NewProgramViewController.self), bundle: nil, settings: settings, device: device, state: .manual)
//        case .playerSettings:
//            break
//        }
//    }
//}
//
//// MARK: UITableViewDelegate
//extension MainViewController: UITableViewDataSource, UITableViewDelegate {
//    
//    func tableView(_ tableview: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return items.count
//    }
//    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return heightTableViewRow
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = items[indexPath.row].value
//        cell.textLabel?.numberOfLines = 0
//        cell.selectionStyle = .none
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        handleTapItem(item: items[indexPath.row])
//    }
//}
