import UIKit
import Combine

class OptionsViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var deviceButton: UIButton!
    
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var devicesView: UIView!
    @IBOutlet weak var constraintDeviceViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintModalHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintTableViewBottom: NSLayoutConstraint!
    
    private lazy var devicesNotConnectedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = AppTheme.black
        label.textAlignment = .center
        label.text = AppStrings.Options.devicesNotConnected
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var connectButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = AppTheme.Button.backgroundColor
        button.setTitle(AppStrings.connectBtnText, for: .normal)
        button.setTitleParams(color: AppTheme.Button.titleColor, highlightedColor: AppTheme.Button.highlightedTitleColor, fontSize: 17, fontWeight: .semibold)
        button.layer.cornerRadius = AppTheme.Button.cornerRadius
        button.addTarget(self, action: #selector(tappedConnectButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var myDevicesTitleView: ModalTitleView = {
        let title = AppStrings.Device.myDevices
        let didTap: (() -> ()) = {}
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: myDevicesTitleViewHeight)
        
        let view = ModalTitleView(frame: frame, title: title, didTap: didTap)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: collectionViewSideMargin, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.headerReferenceSize = CGSize(width: 0, height: 0)
        layout.footerReferenceSize = CGSize(width: 0, height: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = AppTheme.white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(OptionsDeviceCollectionCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var safeAreaInsets: UIEdgeInsets = .zero
    private let devicesViewNotConnectedHeight: CGFloat = 114
    private let devicesViewConnectedHeight: CGFloat = 144
    private let heightTableViewRow: CGFloat = 48
    private let heightModalNotConnected: CGFloat = 370
    private let heightModalConnected: CGFloat = 400
    private let marginBottomModal: CGFloat = 10
    private let marginBottomBtn: CGFloat = 16
    private let myDevicesTitleViewHeight: CGFloat = 20
    private let collectionViewMarginTop: CGFloat = 24
    private let collectionViewSideMargin: CGFloat = 16
    private var collectionViewHeight: CGFloat = 0
    
    private var optionsItems: [OptionsItem] = [
        OptionsItem(name: AppStrings.Options.writeDevelopers, image: "mail_icon", type: .writeDevelopers),
        OptionsItem(name: AppStrings.Options.showDevicesPreview, image: "store_icon", type: .showDevicesPreview),
        OptionsItem(name: AppStrings.Options.contraindications, image: "warning_icon", type: .contraindications),
        OptionsItem(name: AppStrings.Options.deviceManager, image: "bluetooth_icon", type: .deviceManager),
        OptionsItem(name: AppStrings.Options.aboutApp, image: "info_icon", type: .aboutApp)
    ]
    
    private var devicesItems: [Device] = []
    
    private var deviceManager: DeviceManagerProtocol?
    private var activeDevice: Device?
    
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            safeAreaInsets = UIApplication.shared.delegate?.window??.safeAreaInsets ?? .zero
        }
        
        deviceManager = DeviceManager.shared
        deviceManager?.fetchUserDeviceList()
        
        setUI()
        setBindings()
        addVersionLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    private func addVersionLabel() {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = AppTheme.lightGray
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        {
            label.text = "ПО" + version + " " + "(\(build))"
        }
        
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        let constaints =
        [
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -20)
        ]
        view.addConstraints(constaints)
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
        
        // TableView
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.isScrollEnabled = false
        tableView.register(OptionsTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setBindings() {
        deviceManager?.userDeviceListPublisher
            .sink(receiveValue: { [weak self] userDeviceList in
                self?.devicesItems = userDeviceList
                self?.setDevicesView()
                self?.collectionView.reloadData()
            }).store(in: &cancellable)
        
        deviceManager?.activeDevicePublisher
            .sink(receiveValue: { [weak self] device in
                self?.collectionView.reloadData()
                
                if self?.activeDevice != nil && device == nil {
                    self?.openDevicesConnectionLost()
                } else {
                    self?.activeDevice = device
                }
            }).store(in: &cancellable)
    }
    
    private func setDeviceButton() {
        let btnImage = UIImage(named: "device_menu")?.withRenderingMode(.alwaysOriginal)
        deviceButton.setImage(btnImage, for: .normal)
        deviceButton.addTarget(self, action: #selector(tappedDeviceSettingsButton), for: .touchUpInside)
    }
    
    @objc private func tappedDeviceSettingsButton(_ sender: UIButton) {
        if let activeDevice = deviceManager?.activeDevice {
            openProgramsList()
        } else {
            openDevicesNotConnected()
        }
    }
    
    private func setDevicesView() {
        let marginBottom = safeAreaInsets.bottom > 0 ? safeAreaInsets.bottom : marginBottomModal
        constraintTableViewBottom.constant = marginBottom
        
        if devicesItems.isEmpty {
            constraintDeviceViewHeight.constant = devicesViewNotConnectedHeight
            constraintModalHeight.constant = heightModalNotConnected + marginBottom
            setDevicesNotConnectedView()
        } else {
            constraintDeviceViewHeight.constant = devicesViewConnectedHeight
            constraintModalHeight.constant = heightModalConnected + marginBottom
            collectionViewHeight = devicesViewConnectedHeight - myDevicesTitleViewHeight - collectionViewMarginTop
            
            setDevicesConnectedView()
        }
    }
    
    private func setDevicesNotConnectedView() {
        devicesView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        [
            devicesNotConnectedLabel,
            connectButton,
        ].forEach {
            devicesView.addSubview($0)
        }
        
        // Constraints
        devicesNotConnectedLabel.topAnchor.constraint(equalTo: devicesView.topAnchor, constant: 24).isActive = true
        devicesNotConnectedLabel.leadingAnchor.constraint(equalTo: devicesView.leadingAnchor, constant: 24).isActive = true
        devicesNotConnectedLabel.trailingAnchor.constraint(equalTo: devicesView.trailingAnchor, constant: -24).isActive = true
        devicesNotConnectedLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        connectButton.topAnchor.constraint(equalTo: devicesNotConnectedLabel.bottomAnchor, constant: 24).isActive = true
        connectButton.leadingAnchor.constraint(equalTo: devicesView.leadingAnchor, constant: 16).isActive = true
        connectButton.trailingAnchor.constraint(equalTo: devicesView.trailingAnchor, constant: -16).isActive = true
        connectButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    private func setDevicesConnectedView() {
        devicesView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        [
            myDevicesTitleView,
            collectionView
        ].forEach {
            devicesView.addSubview($0)
        }
        
        myDevicesTitleView.topAnchor.constraint(equalTo: devicesView.topAnchor, constant: 24).isActive = true
        myDevicesTitleView.leadingAnchor.constraint(equalTo: devicesView.leadingAnchor, constant: 0).isActive = true
        myDevicesTitleView.trailingAnchor.constraint(equalTo: devicesView.trailingAnchor, constant: 0).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: myDevicesTitleView.bottomAnchor, constant: collectionViewMarginTop).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: devicesView.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: devicesView.trailingAnchor, constant: 0).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight).isActive = true
    }
    
    @objc private func tappedConnectButton(_ sender: UIButton) {
        openConnectingDevice()
    }
    
    private func openConnectingDevice() {
        let connectingDeviceViewController = ConnectingDeviceViewController(nibName: String(describing: ConnectingDeviceViewController.self), bundle: nil)
        guard let navigationController = navigationController as? CustomNavigationController else { return }
        navigationController.openViewController(viewController: connectingDeviceViewController, animated: true)
    }
    
    private func openDevicesConnectionLost() {
        let lostDeviceMac = activeDevice?.mac ?? ""
        let devicesConnectionLost = DevicesConnectionLostViewController(nibName: String(describing: DevicesConnectionLostViewController.self), bundle: nil, lostDeviceMac: lostDeviceMac)
        setRootViewController(viewController: devicesConnectionLost, animation: true)
    }
    
    private func handleTapItem(item: OptionsItem) {
        var nextViewController: UIViewController
        
        switch item.type {
        case .writeDevelopers:
            return
        case .showDevicesPreview:
            nextViewController = DevicesPreviewViewController(nibName: String(describing: DevicesPreviewViewController.self), bundle: nil)
        case .contraindications:
            nextViewController = ContraindicationsViewController(nibName: String(describing: ContraindicationsViewController.self), bundle: nil, isFromOptions: true)
        case .deviceManager:
            nextViewController = DeviceManagerViewController(nibName: String(describing: DeviceManagerViewController.self), bundle: nil)
        case .aboutApp:
            nextViewController = InformationViewController(nibName: String(describing: InformationViewController.self), bundle: nil)
        }
        
        guard let navigationController = navigationController as? CustomNavigationController else { return }
        navigationController.openViewController(viewController: nextViewController, animated: true)
    }
    
    private func openDevicesNotConnected() {
        let devicesNotConnectedViewController = DevicesNotConnectedViewController(nibName: String(describing: DevicesNotConnectedViewController.self), bundle: nil)
        setRootViewController(viewController: devicesNotConnectedViewController)
    }
    
    private func openProgramsList() {
        let programsListViewController = ProgramsListViewController(nibName: String(describing: ProgramsListViewController.self), bundle: nil)
        guard let navigationController = navigationController as? CustomNavigationController else { return }
        navigationController.popViewController(animated: true)
//        setRootViewController(viewController: programsListViewController, animation: true)
    }
}

// MARK: UITableViewDelegate
extension OptionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableview: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightTableViewRow
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? OptionsTableViewCell else { return UITableViewCell() }
        let isLast = (optionsItems.count - 1) == indexPath.row
        cell.set(item: optionsItems[indexPath.row], isLast: isLast)
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = optionsItems[sourceIndexPath.row]
        optionsItems.remove(at: sourceIndexPath.row)
        optionsItems.insert(item, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            optionsItems.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleTapItem(item: optionsItems[indexPath.row])
    }
}

// MARK: UICollectionViewDelegate
extension OptionsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width - (collectionViewSideMargin * 3)
        return CGSize(width: width, height: collectionViewHeight)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return devicesItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? OptionsDeviceCollectionCell else { return UICollectionViewCell() }
        
        let device = devicesItems[indexPath.row]
        var isOnline = false
        if let activeDevice = deviceManager?.activeDevice, activeDevice.mac == device.mac {
            isOnline = true
        }
        
        cell.set(device: devicesItems[indexPath.row], deviceImageViewSize: collectionViewHeight, isOnline: isOnline)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = DeviceStatusViewController(nibName: String(describing: DeviceStatusViewController.self), bundle: nil, device: devicesItems[indexPath.row])
        navigationController?.pushViewController(viewController, animated: true)
    }
}
