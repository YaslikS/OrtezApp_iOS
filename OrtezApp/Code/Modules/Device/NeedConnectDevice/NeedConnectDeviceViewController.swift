import UIKit

class NeedConnectDeviceViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
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
    }
    
    @objc private func tappedContinueButton(_ sender: UIButton) {
        openConnectingDevice()
    }
    
    private func openConnectingDevice() {
        let connectingDeviceViewController = ConnectingDeviceViewController(nibName: String(describing: ConnectingDeviceViewController.self), bundle: nil)
        guard let navigationController = navigationController as? CustomNavigationController else { return }
        navigationController.openViewController(viewController: connectingDeviceViewController, animated: true)
    }
}
