import UIKit

class PlayerReturnPauseViewController: UIViewController {
    
    @IBOutlet weak var warningImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    private let device: Device
    private let program: ProgramListItem
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, device: Device, program: ProgramListItem) {
        self.device = device
        self.program = program
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        view.backgroundColor = AppTheme.yellow
        warningImageView.image = UIImage(named: "warning_black")
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = AppTheme.black
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.text = AppStrings.Player.returnPauseTitle
        
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        messageLabel.textColor = AppTheme.black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.text = AppStrings.Player.returnPauseMessage
        
        continueButton.backgroundColor = AppTheme.black
        continueButton.setTitle(AppStrings.continueBtnText, for: .normal)
        continueButton.setTitleParams(color: AppTheme.Button.titleColor, highlightedColor: AppTheme.Button.highlightedTitleColor, fontSize: 17, fontWeight: .semibold)
        continueButton.layer.cornerRadius = AppTheme.Button.cornerRadius
        continueButton.addTarget(self, action: #selector(tappedContinueButton), for: .touchUpInside)
    }

    @objc private func tappedContinueButton(_ sender: UIButton) {
        openPlayer()
    }
    
    private func openPlayer() {
        let programmViewController = ProgramsListViewController()
        guard let window = AppDelegate.shared.window?.rootViewController else { return }
        window.setRootViewController(viewController: programmViewController, animation: true)
    }
}
