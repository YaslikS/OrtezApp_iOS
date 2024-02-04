import UIKit

class SetDeviceNameViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var deviceNameExampleLabel: UILabel!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var constraintContentBottomMargin: NSLayoutConstraint!
    
    private let contentBottomMargin: CGFloat = 4
    
    var deviceManager: DeviceManagerProtocol
    let deviceMac: String
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, deviceManager: DeviceManagerProtocol, deviceMac: String) {
        self.deviceManager = deviceManager
        self.deviceMac = deviceMac
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setUI()
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
        messageLabel.textAlignment = .left
        messageLabel.text = AppStrings.Device.setDeviceName
        
        deviceNameExampleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        deviceNameExampleLabel.textColor = AppTheme.gray
        deviceNameExampleLabel.numberOfLines = 0
        deviceNameExampleLabel.textAlignment = .left
        deviceNameExampleLabel.text = AppStrings.Device.deviceNameExample
        
        nameView.backgroundColor = AppTheme.TextField.backgroundColor
        nameView.layer.cornerRadius = AppTheme.TextField.cornerRadius
        
        nameTextField.textColor = AppTheme.TextField.textColor
        nameTextField.font = UIFont.systemFont(ofSize: 17)
        setPlaceholderName()
        nameTextField.delegate = self
        nameTextField.becomeFirstResponder()
        
        acceptButton.backgroundColor = AppTheme.Button.backgroundColor
        acceptButton.setTitle(AppStrings.acceptBtnText, for: .normal)
        acceptButton.setTitleParams(color: AppTheme.Button.titleColor, highlightedColor: AppTheme.Button.highlightedTitleColor, fontSize: 17, fontWeight: .semibold)
        acceptButton.layer.cornerRadius = AppTheme.Button.cornerRadius
        acceptButton.addTarget(self, action: #selector(tappedAcceptButton), for: .touchUpInside)
        
        skipButton.setTitle(AppStrings.skipBtnText, for: .normal)
        skipButton.setTitleParams(color: AppTheme.SecondButton.titleColor, highlightedColor: AppTheme.SecondButton.highlightedTitleColor, fontSize: 14, fontWeight: .semibold)
        skipButton.addTarget(self, action: #selector(tappedSkipButton), for: .touchUpInside)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            constraintContentBottomMargin.constant = contentBottomMargin + keyboardSize.height
        } else {
            constraintContentBottomMargin.constant = contentBottomMargin
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        constraintContentBottomMargin.constant = contentBottomMargin
    }
    
    private func setPlaceholderName() {
        nameTextField.text = AppStrings.Device.deviceNamePlaceholder
    }
    
    private func showEmptyNameAlert() {
        let alert = UIAlertController(title: AppStrings.Device.deviceNameEmptyMessage, message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: AppStrings.close, style: .default, handler: { _ in })
        cancelAction.setValue(AppTheme.darkBlue, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func prepareSaveDevice() {
        if !(nameTextField.text?.isEmpty ?? false) {
            saveDevice()
        } else {
            showEmptyNameAlert()
        }
    }
    
    private func getDevice() -> Device? {
        let resultDevice = deviceManager.checkExistDeviceInList(deviceMac: self.deviceMac)
        guard let device = resultDevice else { return nil }
        return device
    }
    
    @objc private func tappedAcceptButton(_ sender: UIButton) {
        prepareSaveDevice()
    }
    
    @objc private func tappedSkipButton(_ sender: UIButton) {
        setPlaceholderName()
        saveDevice()
    }
        
    private func saveDevice() {
        guard let name = nameTextField.text else { return }
        let activeDevice = getDevice()
        let device = Device(name: name, information: activeDevice?.information,
                            mac: deviceMac,
                            battery: activeDevice?.battery ?? 0,
                            image: activeDevice?.image,
                            status: activeDevice?.status)
        deviceManager.appendDeviceInList(device: device, isSetActiveDevice: true)
        StatHelper.deviceActivated(macAddress: deviceMac)
//        openProgramsList()
        openElectrodeList()
    }
    
    private func openElectrodeList(){
        NSLog("SuccessConnectionViewController : openElectrodeList")
        let electrodeListViewController = ElectrodeListViewController(nibName: String(describing: ElectrodeListViewController.self), bundle: nil)
        guard let navigationController = navigationController as? CustomNavigationController else { return }
        navigationController.openViewController(viewController: electrodeListViewController, animated: true)
    }
    
    private func openProgramsList() {
        let programsListViewController = ProgramsListViewController(nibName: String(describing: ProgramsListViewController.self), bundle: nil)
        guard let navigationController = navigationController as? CustomNavigationController else { return }
        navigationController.openViewController(viewController: programsListViewController, animated: true)
    }
}

// MARK: UITextFieldDelegate
extension SetDeviceNameViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        prepareSaveDevice()
        return true
    }
    
}
