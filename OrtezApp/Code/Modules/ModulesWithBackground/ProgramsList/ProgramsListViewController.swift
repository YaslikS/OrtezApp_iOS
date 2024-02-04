import UIKit
import Combine
import CoreData

class ProgramsListViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var deviceButton: UIButton!
    
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintModalHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintTableViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var onlineIconImageView: UIImageView!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var batteryLabel: UILabel!
    @IBOutlet weak var batteryIconImageView: UIImageView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var titleView: UIView!
    
    private var safeAreaInsets: UIEdgeInsets = .zero
    
    private var deviceManager: DeviceManagerProtocol?
    private var activeDevice: Device?
    
    private var items: [ProgramListItem] = []
    private var newPrograms: [ProgramListItem] = []
    
    private let heightModal: CGFloat = 548
    private let marginBottomModal: CGFloat = 10
    
    private var cancellable = Set<AnyCancellable>()
    private let notify = NotificationCenter.default
    
    private var bool: Bool = true
    private var index: IndexPath?
    
    private var electrode: Int? = nil
    private var electrodeName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            safeAreaInsets = UIApplication.shared.delegate?.window??.safeAreaInsets ?? .zero
        }
        
        electrode = UserDefault().getElectrode()
        electrodeName = UserDefault().getElectrodeName()
        
        deviceManager = DeviceManager.shared
        activeDevice = deviceManager?.activeDevice
        
        setUI()
        setBindings()
        notify.addObserver(self, selector: #selector(openUserSettings), name: NSNotification.Name(rawValue: "user"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    deinit {
        notify.removeObserver(self, name: NSNotification.Name(rawValue: "user"), object: nil)
    }
    
    @IBAction func infoTapped(_ sender: Any) {
        let vc = InfoViewController()
        guard let navigationController = navigationController as? CustomNavigationController else { return }
        navigationController.openViewController(viewController: vc, animated: true)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        guard let navigationController = navigationController as? CustomNavigationController else { return }
        navigationController.popViewController(animated: true)
    }
    
    private func setBindings() {
        deviceManager?.activeDevicePublisher
            .sink(receiveValue: { [weak self] device in
                guard let self = self else { return }
                if self.activeDevice != nil && device == nil {
                    self.openDevicesConnectionLost()
                } else {
                    self.activeDevice = device
                    self.setDeviceInfo(device: device)
                    if self.bool {
                        self.setProgramItems(device: device)
                    }
                }
            }).store(in: &cancellable)
    }
    
    private func setUI() {
        view.backgroundColor = AppTheme.yellow
        backgroundImageView.image = UIImage(named: "woman_background")
        backgroundImageView.contentMode = .top
        
        setDeviceButton()
        
        modalView.backgroundColor = AppTheme.white
        modalView.layer.cornerRadius = AppTheme.Modal.cornerRadius
        modalView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        modalView.layer.masksToBounds = true
        
        if let batteryIcon = UIImage(named: "battery_80") {
            batteryIconImageView.image = batteryIcon
        }
        
        deviceNameLabel.textColor = AppTheme.black
        deviceNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        deviceNameLabel.numberOfLines = 0
        
        batteryLabel.textColor = AppTheme.gray
        batteryLabel.textAlignment = .right
        batteryLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        borderView.backgroundColor = AppTheme.separator
        
        setDeviceInfo(device: activeDevice)
        setTitleView()
        
        // TableView
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.alwaysBounceVertical = false
        tableView.register(ProgramsListTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        let marginBottom = safeAreaInsets.bottom > 0 ? safeAreaInsets.bottom : marginBottomModal
        constraintTableViewBottom.constant = marginBottom
        constraintModalHeight.constant = heightModal + marginBottom
    }
    
    private func getBatteryImageName(batteryLevel: Int) -> String {
        switch batteryLevel {
        case 0:
            return "battery_0"
        case 1...20:
            return "battery_20"
        case 21...40:
            return "battery_40"
        case 41...80:
            return "battery_80"
        default:
            return "battery_100"
        }
    }
    
    private func setDeviceInfo(device: Device?) {
        if let device = device {
            
            if let onlineIcon = UIImage(named: "online_icon") {
                onlineIconImageView.image = onlineIcon
            }
            deviceNameLabel.text = device.name
            batteryLabel.text = "\(device.battery)%"
            
            if let batteryIcon = UIImage(named: getBatteryImageName(batteryLevel: device.battery)) {
                batteryIconImageView.image = batteryIcon
            }
        } else {
            if let offlineIcon = UIImage(named: "offline_icon") {
                onlineIconImageView.image = offlineIcon
            }
        }
    }
    
    private func setProgramItems(device: Device?) {
        
        let freeMode = ProgramListItem(id: 5, title: AppStrings.ProgramsList.freeModeTitle, description: AppStrings.ProgramsList.freeModeDescription, file: "", icon: AppStrings.ProgramsList.freeModeIconName, electrode: 1, stage: [])
        // correct when devise arrived
        let stat = "99"
        guard let device = device, let status = device.status, let btCode = Int(stat) else {
            items = [freeMode]
            tableView.reloadData()
            return
        }
        var newPrograms = DevicesData.shared.fetchPrograms(btCode: btCode, electrode: electrode!)
        // free mode
        newPrograms.append(freeMode)
        
        if newPrograms != items {
            items = newPrograms
            self.newPrograms = items
            self.bool = !self.bool
            tableView.reloadData()
        }
        
        UserDefault.shared.programs.forEach { program in
            items.insert(program, at: 0)
        }
    }

    @objc private func openUserSettings() {
        guard let device = activeDevice else { return }
        let settings = NewProgramSettings(generation: false, frequencyAm: false, frequencyAmValue: 2, power: 1, frequency: 15, intensity: 1, durationMin: 1)
        let vc = NewProgramViewController(nibName: String(describing: NewProgramViewController.self), bundle: nil, settings: settings, device: device, state: .manual)
        vc.delegate = self
        guard let navigationController = navigationController as? CustomNavigationController else { return }
        navigationController.openViewController(viewController: vc, animated: true)
    }
    
    private func addNewProgramm(title: String, description: String, stage: StageListItem) {
        let newProgramm = ProgramListItem(id: -1, title: title, description: description, file: "", icon: "", electrode: 1, stage: [stage])
        items.insert(newProgramm, at: 0)
        UserDefault.shared.saveProgramm(program: newProgramm)
        tableView.reloadData()
    }
    
    private func replace(title: String, description: String, stage: StageListItem, idexPath: IndexPath) {
        guard let index = index?.row else { return }
        let newProgramm = ProgramListItem(id: -1, title: title, description: description, file: "", icon: "", electrode: 1, stage: [stage])
        UserDefault.shared.updateProgramm(oldProgram: items[index], newProgram: newProgramm)
        items[index] = newProgramm
        tableView.reloadData()
    }
    
    private func setDeviceButton() {
        let btnImage = UIImage(named: "device_settings")?.withRenderingMode(.alwaysOriginal)
        deviceButton.setImage(btnImage, for: .normal)
        deviceButton.addTarget(self, action: #selector(tappedDeviceSettingsButton), for: .touchUpInside)
    }
    
    @objc private func tappedDeviceSettingsButton(_ sender: UIButton) {
        openOptions()
    }
    
    private func openOptions() {
        //  TODO:   поменять логику перехода на экран
        let optionsViewController = OptionsViewController(nibName: String(describing: OptionsViewController.self), bundle: nil)
        guard let navigationController = navigationController as? CustomNavigationController else { return }
        navigationController.openViewController(viewController: optionsViewController, animated: true)
//        setRootViewController(viewController: optionsViewController, animation: true)
    }
    
    func openProgramsList(index: Int){
        let programsListViewController = ProgramsListViewController(nibName: String(describing: ProgramsListViewController.self), bundle: nil)
        guard let navigationController = navigationController as? CustomNavigationController else { return }
        navigationController.openViewController(viewController: programsListViewController, animated: true)
    }
    
    private func openDevicesConnectionLost() {
        let lostDeviceMac = activeDevice?.mac ?? ""
        let devicesConnectionLost = DevicesConnectionLostViewController(nibName: String(describing: DevicesConnectionLostViewController.self), bundle: nil, lostDeviceMac: lostDeviceMac)
        setRootViewController(viewController: devicesConnectionLost, animation: true)
    }
    
    private func setTitleView() {
        let title = AppStrings.ProgramsList.title + " \(AppStrings.ProgramsList.forWord) \(electrodeName)"
        let didTap: (() -> ()) = {}
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: titleView.bounds.height)
        
        let modalTitleView = ModalTitleView(frame: frame, title: title, didTap: didTap)
        modalTitleView.didTap()
        titleView.addSubview(modalTitleView)
    }
    
    private func showConfirmSaveNewProgram() {
        let confirmModalViewController = ConfirmModalViewController(nibName: String(describing: ConfirmModalViewController.self), bundle: nil, state: .newFreeProgram, cancelAction: {}, saveAction: {})
        openModalViewController(viewController: confirmModalViewController)
    }
    
    private func openReplace(item: ProgramListItem?) {
        guard let device = activeDevice else { return }
        guard let item = item else {
            let settings = NewProgramSettings(generation: false, frequencyAm: false, frequencyAmValue: 2, power: 1, frequency: 15, intensity: 1, durationMin: 1)
            let vc = NewProgramViewController(nibName: String(describing: NewProgramViewController.self), bundle: nil, settings: settings, device: device, state: .freeMode)
            vc.delegate = self
            guard let navigationController = navigationController as? CustomNavigationController else { return }
            navigationController.openViewController(viewController: vc, animated: true)
            return
        }
        let settings = NewProgramSettings(generation: item.stage.first?.generation ?? false, frequencyAm: item.stage.first!.am, frequencyAmValue: item.stage.first!.amMode, power: item.stage.first!.power, frequency: item.stage.first!.frequency, intensity: item.stage.first!.intensivity, durationMin: item.stage.first!.duration/60000)
        let vc = NewProgramViewController(nibName: String(describing: NewProgramViewController.self), bundle: nil, settings: settings, device: device, state: .replace)
        vc.delegate = self
        guard let navigationController = navigationController as? CustomNavigationController else { return }
        navigationController.openViewController(viewController: vc, animated: true)
    }
    
    private func handleTapItem(program: ProgramListItem) {
        guard let device = activeDevice else { return }
        let playlistViewController = PlaylistViewController(nibName: String(describing: PlaylistViewController.self), bundle: nil, device: device, program: program)
        guard let navigationController = navigationController as? CustomNavigationController else { return }
        navigationController.openViewController(viewController: playlistViewController, animated: true)
    }
    
}

// MARK: UITableViewDelegate
extension ProgramsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableview: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ProgramsListTableViewCell else { return UITableViewCell() }
        let isLast = (items.count - 1) == indexPath.row
        cell.set(item: items[indexPath.row], isLast: isLast)
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint)
    -> UIContextMenuConfiguration? {
        guard let item = self.items[safe: indexPath.row] else { return nil}
        
        let result = !self.newPrograms.contains(where: {$0.title == item.title})
        if result {
            self.index = indexPath
            let identifier = "\(index ?? IndexPath())" as NSString
            let menu = UIContextMenuConfiguration(
                identifier: identifier,
                previewProvider: nil) { _ in
                    let editAction = UIAction(
                        title: AppStrings.replace,
                        image: UIImage(named: "ic_replace")) { _ in
                            self.openReplace(item: item)
                        }
                    let removeAction = UIAction(
                        title: AppStrings.remove,
                        image: UIImage(named: "ic_delete"),
                        attributes: .destructive) {[weak self] _ in
                            guard let self = self else { return }
                            let alert = UIAlertController(title:"\(AppStrings.ProgramsList.removeProgram) \(item.title)? ", message: nil, preferredStyle: .alert)
                            
                            let cancelAction = UIAlertAction(title: AppStrings.cancelBtnText, style: .default, handler: { _ in })
                            cancelAction.setValue(AppTheme.darkBlue, forKey: "titleTextColor")
                            alert.addAction(cancelAction)
                            
                            let yesAction = UIAlertAction(title: AppStrings.yes, style: .default, handler: { [weak self] _ in
                                guard let self = self else { return }
                                self.items.remove(at: indexPath.row)
                                UserDefault.shared.removeProgramm(program: item)
                                tableView.reloadData()
                            })
                            yesAction.setValue(AppTheme.darkBlue, forKey: "titleTextColor")
                            alert.addAction(yesAction)
                            
                            self.present(alert, animated: true, completion: nil)
                        }
                    return UIMenu(title: "", image: nil, children: [editAction, removeAction])
                }
            return menu
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = items[sourceIndexPath.row]
        items.remove(at: sourceIndexPath.row)
        items.insert(item, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == items.count - 1{
            openReplace(item: nil)
        } else {
            handleTapItem(program: items[indexPath.row])
        }
    }
}

extension ProgramsListViewController: UserSettingsDelegate {
    func replaceProgram(stage: StageListItem) {
        self.alert(programName: items[index?.row ?? 0].title, programDescription: items[index?.row ?? 0].description) {title, description in
            guard let index = self.index else {return }
            self.replace(title: title, description: description, stage: stage, idexPath: index)
        }
    }
    
    func addProgram(stage: StageListItem) {
        self.alert {title, description in
            self.addNewProgramm(title: title, description: description, stage: stage)
        }
    }
}
