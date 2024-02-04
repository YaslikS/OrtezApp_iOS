import UIKit
import Combine
import CoreData

class ElectrodeListViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
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

    private var electrodesList: [ElectrodesListItem] = []

    private let heightModal: CGFloat = 548
    private let marginBottomModal: CGFloat = 10

    private var cancellable = Set<AnyCancellable>()
    private let notify = NotificationCenter.default

    private var bool: Bool = true
    private var index: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            safeAreaInsets = UIApplication.shared.delegate?.window??.safeAreaInsets ?? .zero
        }

        deviceManager = DeviceManager.shared
        activeDevice = deviceManager?.activeDevice

        setUI()
        setBindings()
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
        tableView.register(ElectrodesListTableViewCell.self, forCellReuseIdentifier: "cell")
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
//            print("!!!!!device:")
//            print(device.status?.powerFirst)
//            print(device.status?.powerSecond)
//            print(device.status?.firmwareNumber ?? "")
//            let firNum = String(device.status?.firmwareNumber ?? 0, radix: 2)
//            print(pad(string: firNum, toSize: 8))
            
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
    
    func pad(string : String, toSize: Int) -> String {
      var padded = string
      for _ in 0..<(toSize - string.count) {
        padded = "0" + padded
      }
      return padded
    }

    private func setProgramItems(device: Device?) {
        let stat = "99"
        guard let device = device, let status = device.status, let btCode = Int(stat) else {
            tableView.reloadData()
            return
        }
        electrodesList = DevicesData.shared.shareElectrodes()
        tableView.reloadData()
    }

    @objc private func tappedDeviceSettingsButton(_ sender: UIButton) {
        openOptions()
    }

    private func openOptions() {
        let optionsViewController = OptionsViewController(nibName: String(describing: OptionsViewController.self), bundle: nil)
        setRootViewController(viewController: optionsViewController, animation: true)
    }

    private func openDevicesConnectionLost() {
        let lostDeviceMac = activeDevice?.mac ?? ""
        let devicesConnectionLost = DevicesConnectionLostViewController(nibName: String(describing: DevicesConnectionLostViewController.self), bundle: nil, lostDeviceMac: lostDeviceMac)
        setRootViewController(viewController: devicesConnectionLost, animation: true)
    }

    private func setTitleView() {
        let title = AppStrings.ProgramsList.titleEl
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
}

// MARK: UITableViewDelegate
extension ElectrodeListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableview: UITableView, numberOfRowsInSection section: Int) -> Int {
        return electrodesList.count
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ElectrodesListTableViewCell else { return UITableViewCell() }
        let isLast = (electrodesList.count - 1) == indexPath.row
        cell.set(item: electrodesList[indexPath.row], isLast: isLast)
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = electrodesList[sourceIndexPath.row]
        electrodesList.remove(at: sourceIndexPath.row)
        electrodesList.insert(item, at: destinationIndexPath.row)
    }
    
    func openProgramsList(index: Int){        
        let programsListViewController = ProgramsListViewController(nibName: String(describing: ProgramsListViewController.self), bundle: nil)
        guard let navigationController = navigationController as? CustomNavigationController else { return }
        navigationController.openViewController(viewController: programsListViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefault().saveElectrode(electrode: electrodesList[indexPath.row].id)
        UserDefault().saveElectrodeName(electrodeName: electrodesList[indexPath.row].name)
        openProgramsList(index: indexPath.row)
    }
}
