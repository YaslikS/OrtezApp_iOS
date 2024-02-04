import UIKit
import CoreBluetooth

class ConnectingDeviceViewController: UIViewController {
    
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    private lazy var animationBorder: CAShapeLayer = {
        let animationBorder = CAShapeLayer()
        animationBorder.fillColor = AppTheme.clear.cgColor
        animationBorder.strokeColor = AppTheme.green.cgColor
        animationBorder.lineWidth = 3
        animationBorder.frame = animationView.bounds
        animationBorder.cornerRadius = animationView.bounds.width / 2
        animationBorder.masksToBounds = true
        animationBorder.fillColor = nil
        animationBorder.strokeEnd = 0.0
        animationBorder.path = UIBezierPath(ovalIn: animationView.bounds).cgPath
        return animationBorder
    }()
    
    var modalDeviceListViewController: ModalDeviceListViewController?
    var deviceList: [Device] = []
    var devicePeripheralList: [CBPeripheral] = []
    var isModalDeviceListShown = false
    
    private var bluetoothManager: ConnectDeviceProtocol?
    var searchTimerAction: (() -> ())?
    
    private let lostDeviceMac: String
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, lostDeviceMac: String = "") {
        self.lostDeviceMac = lostDeviceMac
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTimerAction = {
            if self.isModalDeviceListShown {
                self.bluetoothManager?.extendSearchDevices()
            } else {
                self.bluetoothManager?.stopSearchDevices()
                self.openConnectionError(state: .devicesNotFound)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        bluetoothManager?.stopSearchDevices()
        setUI()
       
        bluetoothManager = BluetoothManager.shared
        bluetoothManager?.deviceManager = DeviceManager.shared
        bluetoothManager?.searchTimerAction = searchTimerAction
        bluetoothManager?.searchListDelegate = self
        
        if lostDeviceMac.isEmpty {
            bluetoothManager?.startSearchDevices(autoConnectDeviceList: [])
        } else {
            bluetoothManager?.startSearchLostDevice(lostDeviceMac: lostDeviceMac)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bluetoothManager?.stopSearchDevices()
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setUI() {
        setCircleView()
        setAnimationCircleView()
        
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        messageLabel.textColor = AppTheme.black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.text = AppStrings.Device.deviceSearching
        
        cancelButton.setTitle(AppStrings.cancelBtnText, for: .normal)
        cancelButton.setTitleParams(color: AppTheme.SecondButton.titleColor, highlightedColor: AppTheme.SecondButton.highlightedTitleColor, fontSize: 14, fontWeight: .semibold)
        cancelButton.addTarget(self, action: #selector(tappedCancelButton), for: .touchUpInside)
        
    }
    
    private func setCircleView() {
        let border = CAShapeLayer()
        border.strokeColor = AppTheme.lightGray.cgColor
        border.lineDashPattern = [1, 2]
        border.lineWidth = 3
        border.frame = animationView.bounds
        border.cornerRadius = animationView.bounds.width / 2
        border.masksToBounds = true
        border.fillColor = nil
        border.path = UIBezierPath(ovalIn: animationView.bounds).cgPath
        animationView.layer.addSublayer(border)
    }
    
    private func setAnimationCircleView() {
        animationView.layer.addSublayer(animationBorder)
        startAnimation(duration: 1.5)
    }
    
    private func startAnimation(duration: TimeInterval) {
        let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = 1
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1
        
        let strokeStartAniamtion = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAniamtion.fromValue = -1
        strokeStartAniamtion.toValue = 1
        
        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration = (duration - 1 * duration * 0.1)
        strokeAnimationGroup.timingFunction = CAMediaTimingFunction(name: .easeOut)
        strokeAnimationGroup.fillMode = .forwards
        strokeAnimationGroup.isRemovedOnCompletion = false
        strokeAnimationGroup.animations = [strokeStartAniamtion, strokeEndAnimation]
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = duration
        animationGroup.repeatCount = Float.infinity
        animationGroup.animations = [animation, strokeAnimationGroup]
        animationBorder.add(animationGroup, forKey: "animationGroup")
    }
    
    private func showModalDeviceList() {
        isModalDeviceListShown = true
        
        modalDeviceListViewController = ModalDeviceListViewController(nibName: String(describing: ModalDeviceListViewController.self), bundle: nil, items: deviceList)
        modalDeviceListViewController?.delegate = self
        openModalViewController(viewController: modalDeviceListViewController!)
    }
    
    @objc private func tappedCancelButton(_ sender: UIButton) {
        returnBackViewController()
    }
    
}

extension ConnectingDeviceViewController: BluetoothManagerSearchListDelegate {
    
    func showOpenBluetoothSettings() {
        
        let alert = UIAlertController(title: AppStrings.Device.needAccessBluetooth, message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: AppStrings.cancelBtnText, style: .default, handler: { [weak self] _ in
            self?.returnBackViewController()
        })
        cancelAction.setValue(AppTheme.darkBlue, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        
        let trueAction = UIAlertAction(title: AppStrings.Device.openBluetoothSettings, style: .default, handler: { [weak self] _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
            self?.returnBackViewController()
        })
        trueAction.setValue(AppTheme.darkBlue, forKey: "titleTextColor")
        alert.addAction(trueAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func appendDeviceToList(peripheral: CBPeripheral) {
        guard let name = peripheral.name, name.hasPrefix(DeviceSettings.Constants.deviceNamePrefix) else { return }
        let mac = peripheral.identifier.uuidString
        let device = Device(name: name, mac: mac, battery: 0)
        
        let isDeviceExist = !deviceList.filter { $0.mac == device.mac}.isEmpty
        if !isDeviceExist {
           
            deviceList.append(device)
            devicePeripheralList.append(peripheral)

            if isModalDeviceListShown {
                modalDeviceListViewController?.updateDeviceList(items: deviceList)
            } else {
                showModalDeviceList()
            }
        } else {
            if !isModalDeviceListShown {
                showModalDeviceList()
            }
        }
    }
    
    func openConnectionError(state: ConnectionErrorViewController.State) {
        let fromLostConnect = lostDeviceMac.isEmpty ? false : true
        let connectionErrorViewController = ConnectionErrorViewController(nibName: String(describing: ConnectionErrorViewController.self), bundle: nil, state: state, fromLostConnect: fromLostConnect)
        guard let navigationController = navigationController as? CustomNavigationController else { return }
        navigationController.openViewController(viewController: connectionErrorViewController, animated: true)
    }
    
    func clearData() {
        isModalDeviceListShown = false
        modalDeviceListViewController = nil
        deviceList.removeAll()
        devicePeripheralList.removeAll()
    }
    
    func openSuccessConnection(deviceMac: String) {
        let successConnectionViewController = SuccessConnectionViewController(nibName: String(describing: SuccessConnectionViewController.self), bundle: nil, deviceMac: deviceMac)
        guard let navigationController = navigationController as? CustomNavigationController else { return }
        navigationController.openViewController(viewController: successConnectionViewController, animated: true)
    }
    
}

extension ConnectingDeviceViewController: ModalDeviceListDelegate {
    
    func modalDidClose() {
        isModalDeviceListShown = false
        modalDeviceListViewController = nil
    }
    
    func connectDevice(index: Int) {
        guard devicePeripheralList.indices.contains(index), deviceList.indices.contains(index) else { return }
        bluetoothManager?.connectDevice(peripheral: devicePeripheralList[index])
    }
    
}
