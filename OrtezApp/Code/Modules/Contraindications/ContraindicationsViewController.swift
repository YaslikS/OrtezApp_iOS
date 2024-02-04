import UIKit

class ContraindicationsViewController: UIViewController {
    
    @IBOutlet weak var warningImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var subLabelsView: UIView!
    @IBOutlet weak var understandButton: UIButton!
    @IBOutlet weak var constraintUnderstandButtonHeight: NSLayoutConstraint!
    
    private lazy var pregnancyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = AppTheme.black
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = AppStrings.Contraindications.pregnancy
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var herniaLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = AppTheme.black
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = AppStrings.Contraindications.hernia
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var headLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = AppTheme.black
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = AppStrings.Contraindications.head
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var epilepsyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = AppTheme.black
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = AppStrings.Contraindications.epilepsy
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var injuryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = AppTheme.black
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = AppStrings.Contraindications.injury
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var ischemiaLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = AppTheme.black
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = AppStrings.Contraindications.ischemia
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var skinDiseaseLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = AppTheme.black
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = AppStrings.Contraindications.skinDisease
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var isFromOptions: Bool
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, isFromOptions: Bool) {
        self.isFromOptions = isFromOptions
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        UserSettings.shared.setContraindicationsShown()
    }
    
    private func setUI() {
        warningImageView.image = UIImage(named: "warning")
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = AppTheme.black
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.text = AppStrings.Contraindications.title
        
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        messageLabel.textColor = AppTheme.black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .left
        messageLabel.text = AppStrings.Contraindications.infoText
        
        if !isFromOptions {
            understandButton.backgroundColor = AppTheme.Button.backgroundColor
            understandButton.setTitle(AppStrings.Contraindications.understand, for: .normal)
            understandButton.setTitleParams(color: AppTheme.Button.titleColor, highlightedColor: AppTheme.Button.highlightedTitleColor, fontSize: 17, fontWeight: .semibold)
            understandButton.layer.cornerRadius = AppTheme.Button.cornerRadius
            understandButton.addTarget(self, action: #selector(tappedUnderstandButton), for: .touchUpInside)
        } else {
            understandButton.isHidden = true
            constraintUnderstandButtonHeight.constant = 0
        }
        
        setSubLabels()
    }
    
    private func setSubLabels() {
        [
            pregnancyLabel,
            herniaLabel,
            headLabel,
            epilepsyLabel,
            injuryLabel,
            ischemiaLabel,
            skinDiseaseLabel,
        ].forEach {
            subLabelsView.addSubview($0)
        }
        
        // Constraints
        pregnancyLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 12).isActive = true
        pregnancyLabel.leadingAnchor.constraint(equalTo: subLabelsView.leadingAnchor, constant: 0).isActive = true
        pregnancyLabel.trailingAnchor.constraint(equalTo: subLabelsView.trailingAnchor, constant: 0).isActive = true
        
        herniaLabel.topAnchor.constraint(equalTo: pregnancyLabel.bottomAnchor, constant: 12).isActive = true
        herniaLabel.leadingAnchor.constraint(equalTo: subLabelsView.leadingAnchor, constant: 0).isActive = true
        herniaLabel.trailingAnchor.constraint(equalTo: subLabelsView.trailingAnchor, constant: 0).isActive = true
        
        headLabel.topAnchor.constraint(equalTo: herniaLabel.bottomAnchor, constant: 12).isActive = true
        headLabel.leadingAnchor.constraint(equalTo: subLabelsView.leadingAnchor, constant: 0).isActive = true
        headLabel.trailingAnchor.constraint(equalTo: subLabelsView.trailingAnchor, constant: 0).isActive = true
        
        epilepsyLabel.topAnchor.constraint(equalTo: headLabel.bottomAnchor, constant: 12).isActive = true
        epilepsyLabel.leadingAnchor.constraint(equalTo: subLabelsView.leadingAnchor, constant: 0).isActive = true
        epilepsyLabel.trailingAnchor.constraint(equalTo: subLabelsView.trailingAnchor, constant: 0).isActive = true
        
        injuryLabel.topAnchor.constraint(equalTo: epilepsyLabel.bottomAnchor, constant: 12).isActive = true
        injuryLabel.leadingAnchor.constraint(equalTo: subLabelsView.leadingAnchor, constant: 0).isActive = true
        injuryLabel.trailingAnchor.constraint(equalTo: subLabelsView.trailingAnchor, constant: 0).isActive = true
        
        ischemiaLabel.topAnchor.constraint(equalTo: injuryLabel.bottomAnchor, constant: 12).isActive = true
        ischemiaLabel.leadingAnchor.constraint(equalTo: subLabelsView.leadingAnchor, constant: 0).isActive = true
        ischemiaLabel.trailingAnchor.constraint(equalTo: subLabelsView.trailingAnchor, constant: 0).isActive = true
        
        skinDiseaseLabel.topAnchor.constraint(equalTo: ischemiaLabel.bottomAnchor, constant: 12).isActive = true
        skinDiseaseLabel.leadingAnchor.constraint(equalTo: subLabelsView.leadingAnchor, constant: 0).isActive = true
        skinDiseaseLabel.trailingAnchor.constraint(equalTo: subLabelsView.trailingAnchor, constant: 0).isActive = true
        skinDiseaseLabel.bottomAnchor.constraint(equalTo: subLabelsView.bottomAnchor, constant: 0).isActive = true
    }

    @objc private func tappedUnderstandButton(_ sender: UIButton) {
        if !isFromOptions {
            openAskConnectDevice()
        }
    }
    
    private func openAskConnectDevice() {
        let askConnectDeviceViewController = AskConnectDeviceViewController(nibName: String(describing: AskConnectDeviceViewController.self), bundle: nil)
        guard let navigationController = navigationController as? CustomNavigationController else { return }
        navigationController.openViewController(viewController: askConnectDeviceViewController, animated: true)
    }
}
