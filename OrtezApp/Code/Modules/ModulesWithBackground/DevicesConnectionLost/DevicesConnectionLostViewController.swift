import UIKit

class DevicesConnectionLostViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var deviceButton: UIButton!
    
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var constraintModalHeight: NSLayoutConstraint!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var constraintConnectBtnMarginBottom: NSLayoutConstraint!
    
    private var safeAreaInsets: UIEdgeInsets = .zero
    private let heightModal: CGFloat = 376
    private let marginBottomModal: CGFloat = 10
    private let marginBottomBtn: CGFloat = 16
    
    private let lostDeviceMac: String
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, lostDeviceMac: String) {
        self.lostDeviceMac = lostDeviceMac
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            safeAreaInsets = UIApplication.shared.delegate?.window??.safeAreaInsets ?? .zero
        }
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
        if UserSettings.shared.isPlayerModeActive {
//            let vc = ConnectionLostViewController()
//            vc.modalPresentationStyle = .fullScreen
//            vc.typeOfView = .lostConnection
//            self.present(vc, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
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
        
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        messageLabel.textColor = AppTheme.black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.text = AppStrings.Device.devicesConnectionLost
        
        connectButton.backgroundColor = AppTheme.Button.backgroundColor
        connectButton.setTitle(AppStrings.connectBtnText, for: .normal)
        connectButton.setTitleParams(color: AppTheme.Button.titleColor, highlightedColor: AppTheme.Button.highlightedTitleColor, fontSize: 17, fontWeight: .semibold)
        connectButton.layer.cornerRadius = AppTheme.Button.cornerRadius
        connectButton.addTarget(self, action: #selector(tappedConnectButton), for: .touchUpInside)
        
        let marginBottom = safeAreaInsets.bottom > 0 ? (safeAreaInsets.bottom + marginBottomBtn) : marginBottomModal
        constraintModalHeight.constant = heightModal + marginBottom
        constraintConnectBtnMarginBottom.constant = marginBottom
    }
    
    private func setDeviceButton() {
        let btnImage = UIImage(named: "device_settings")?.withRenderingMode(.alwaysOriginal)
        deviceButton.setImage(btnImage, for: .normal)
        deviceButton.addTarget(self, action: #selector(tappedDeviceSettingsButton), for: .touchUpInside)
    }
    
    @objc private func tappedDeviceSettingsButton(_ sender: UIButton) {
        openOptions()
    }
    
    @objc private func tappedConnectButton(_ sender: UIButton) {
        openConnectingDevice()
    }
    
    private func openConnectingDevice() {
        let connectingDeviceViewController = ConnectingDeviceViewController(nibName: String(describing: ConnectingDeviceViewController.self), bundle: nil, lostDeviceMac: lostDeviceMac)
        guard let navigationController = navigationController as? CustomNavigationController else { return }
        navigationController.openViewController(viewController: connectingDeviceViewController, animated: true)
    }
    
    private func openOptions() {
        let optionsViewController = OptionsViewController(nibName: String(describing: OptionsViewController.self), bundle: nil)
        setRootViewController(viewController: optionsViewController, animation: true)
    }
}
