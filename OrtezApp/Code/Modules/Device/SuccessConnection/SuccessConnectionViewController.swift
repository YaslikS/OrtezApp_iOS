import UIKit
import CoreData

class SuccessConnectionViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    let deviceMac: String
    
    private var deviceManager: DeviceManagerProtocol?
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, deviceMac: String) {
        self.deviceMac = deviceMac
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BluetoothManager.shared.powerToNil()
        deviceManager = DeviceManager.shared
        
        setUI()
        checkDeviceInStorage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setUI() {
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        messageLabel.textColor = AppTheme.black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.text = AppStrings.Device.successConnect
    }
    
    private func checkDeviceInStorage() {
        
        let device = deviceManager?.checkExistDeviceInList(deviceMac: deviceMac)
        BluetoothManager.shared.powerToNil()
        if device != nil {
            deviceManager?.setActiveDevice(deviceMac: deviceMac)
//            openProgramsList()
            openElectrodeList()
        } else {
            delayOpenSetDeviceName()
        }
    }
    
    private func delayOpenSetDeviceName() {
        DispatchQueue.main.asyncAfter(deadline: .now() + DeviceSettings.Constants.delaySetDeviceNameAfterSuccessConnect) {
            self.openSetDeviceName()
        }
    }
    
    private func openSetDeviceName() {
        guard let deviceManager = deviceManager else { return }
        let setDeviceNameViewController = SetDeviceNameViewController(nibName: String(describing: SetDeviceNameViewController.self), bundle: nil, deviceManager: deviceManager, deviceMac: deviceMac)
        guard let navigationController = navigationController as? CustomNavigationController else { return }
        navigationController.openViewController(viewController: setDeviceNameViewController, animated: true)
    }
    
    private func openElectrodeList(){
        NSLog("SuccessConnectionViewController : openElectrodeList")
        let electrodeListViewController = ElectrodeListViewController(nibName: String(describing: ElectrodeListViewController.self), bundle: nil)
        setRootViewController(viewController: electrodeListViewController)
//        guard let navigationController = navigationController as? CustomNavigationController else { return }
//        navigationController.openViewController(viewController: electrodeListViewController, animated: true)
    }
    
//    private func openProgramsList() {
//        let programsListViewController = ProgramsListViewController(nibName: String(describing: ProgramsListViewController.self), bundle: nil)
//        guard let navigationController = navigationController as? CustomNavigationController else { return }
//        navigationController.openViewController(viewController: programsListViewController, animated: true)
//    }
}
