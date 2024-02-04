import UIKit

class ConnectionErrorViewController: UIViewController {
    
    enum State {
        case devicesNotFound
        case connectionError
    }
    
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    private let state: State
    private let fromLostConnect: Bool
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, state: State, fromLostConnect: Bool) {
        self.state = state
        self.fromLostConnect = fromLostConnect
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        setMessageLabel()
        repeatButton.addTarget(self, action: #selector(tappedRepeatButton), for: .touchUpInside)
        
        cancelButton.setTitle(AppStrings.cancelBtnText, for: .normal)
        cancelButton.setTitleParams(color: AppTheme.SecondButton.titleColor, highlightedColor: AppTheme.SecondButton.highlightedTitleColor, fontSize: 14, fontWeight: .semibold)
        cancelButton.addTarget(self, action: #selector(tappedCancelButton), for: .touchUpInside)
    }
    
    private func setMessageLabel() {
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        messageLabel.textColor = AppTheme.black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        switch state {
        case .devicesNotFound:
            messageLabel.text = AppStrings.Device.devicesNotFound
        case .connectionError:
            messageLabel.text = AppStrings.Device.connectionProblem
        }
    }
    
    @objc private func tappedRepeatButton(_ sender: UIButton) {
        returnBackViewController()
    }
    
    @objc private func tappedCancelButton(_ sender: UIButton) {
        if !fromLostConnect {
            returnBackBeforeConnectionScreen()
        } else {
            openDevicesNotConnected()
        }
    }
    
    private func returnBackBeforeConnectionScreen() {
        let controllers = navigationController?.viewControllers ?? []
        if controllers.isEmpty {
            returnBackViewController()
        } else {
            
            var needRemove = false
            var newControllersList = [UIViewController]()
            let currentController: UIViewController = controllers.last!
            
            controllers.forEach {
                if $0 is ConnectingDeviceViewController {
                    needRemove = true
                }
                if !needRemove {
                    newControllersList.append($0)
                }
            }
            
            newControllersList.append(currentController)
            navigationController?.viewControllers = newControllersList
            returnBackViewController()
            
        }
    }
    
    private func openDevicesNotConnected() {
        let devicesNotConnected = DevicesNotConnectedViewController(nibName: String(describing: DevicesNotConnectedViewController.self), bundle: nil)
        setRootViewController(viewController: devicesNotConnected, animation: true)
    }
}
