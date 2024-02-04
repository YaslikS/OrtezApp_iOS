import UIKit

class AskConnectDeviceViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        messageLabel.textAlignment = .center
        messageLabel.text = AppStrings.Device.connectInfo
        
        continueButton.backgroundColor = AppTheme.Button.backgroundColor
        continueButton.setTitle(AppStrings.continueBtnText, for: .normal)
        continueButton.setTitleParams(color: AppTheme.Button.titleColor, highlightedColor: AppTheme.Button.highlightedTitleColor, fontSize: 17, fontWeight: .semibold)
        continueButton.layer.cornerRadius = AppTheme.Button.cornerRadius
        continueButton.addTarget(self, action: #selector(tappedContinueButton), for: .touchUpInside)
        
        skipButton.setTitle(AppStrings.skipBtnText, for: .normal)
        skipButton.setTitleParams(color: AppTheme.SecondButton.titleColor, highlightedColor: AppTheme.SecondButton.highlightedTitleColor, fontSize: 14, fontWeight: .semibold)
        skipButton.addTarget(self, action: #selector(tappedSkipButton), for: .touchUpInside)
    }
    
    @objc private func tappedContinueButton(_ sender: UIButton) {
        openConnectingDevice()
    }
    
    @objc private func tappedSkipButton(_ sender: UIButton) {
        openDevicesNotConnected()
    }
    
    private func openConnectingDevice() {
        let connectingDeviceViewController = ConnectingDeviceViewController(nibName: String(describing: ConnectingDeviceViewController.self), bundle: nil)
        guard let navigationController = navigationController as? CustomNavigationController else { return }
        navigationController.openViewController(viewController: connectingDeviceViewController, animated: true)
    }
    
    private func openDevicesNotConnected() {
        let devicesNotConnectedViewController = DevicesNotConnectedViewController(nibName: String(describing: DevicesNotConnectedViewController.self), bundle: nil)
        guard let navigationController = navigationController as? CustomNavigationController else { return }
        navigationController.openViewController(viewController: devicesNotConnectedViewController, animated: true)
    }
}
