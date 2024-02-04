import UIKit

class SettingsFreeModeViewController: UIViewController {
    
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var closeMessageButton: UIButton!
    @IBOutlet weak var constraintMessageViewMarginTop: NSLayoutConstraint!
    @IBOutlet weak var constraintMessageLabelwMarginTop: NSLayoutConstraint!
    @IBOutlet weak var constraintMessageLabelwMarginBottom: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    private var items: [FreeModeItem] = [
        FreeModeItem(name: AppStrings.ProgramsList.freeModeGeneration, type: .generation),
        FreeModeItem(name: AppStrings.ProgramsList.freeModeFrequencyAm, type: .frequencyAm),
        FreeModeItem(name: AppStrings.ProgramsList.freeModeFrequencyFm, type: .frequencyFm),
        FreeModeItem(name: AppStrings.ProgramsList.freeModePower, type: .power),
        FreeModeItem(name: AppStrings.ProgramsList.freeModeFrequency, type: .frequency),
        FreeModeItem(name: AppStrings.ProgramsList.freeModeIntensity, type: .intensity),
    ]
    
    private var settings: FreeModeSettings
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, settings: FreeModeSettings) {
        self.settings = settings
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
        title = AppStrings.ProgramsList.freeMode
        
        messageView.backgroundColor = AppTheme.Player.messageBackground
        messageView.layer.cornerRadius = AppTheme.Player.cornerRadiusMessage
        
        messageLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        messageLabel.textColor = AppTheme.black
        messageLabel.numberOfLines = 0
        messageLabel.text = AppStrings.ProgramsList.freeModeMessage
        
        let btnImage = UIImage(named: "close_message")?.withRenderingMode(.alwaysOriginal)
        closeMessageButton.setImage(btnImage, for: .normal)
        closeMessageButton.addTarget(self, action: #selector(tappedCloseMessageButton), for: .touchUpInside)
        
        // TableView
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.register(SettingsFreeModeTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(SettingsFreeModeTableViewSliderCell.self, forCellReuseIdentifier: "sliderCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        startButton.backgroundColor = AppTheme.Button.backgroundColor
        startButton.setTitle(AppStrings.start, for: .normal)
        startButton.setTitleParams(color: AppTheme.Button.titleColor, highlightedColor: AppTheme.Button.highlightedTitleColor, fontSize: 17, fontWeight: .semibold)
        startButton.layer.cornerRadius = AppTheme.Button.cornerRadius
        startButton.addTarget(self, action: #selector(tappedStartButton), for: .touchUpInside)
        
        clearButton.setTitle(AppStrings.ProgramsList.clearSettings, for: .normal)
        clearButton.setTitleParams(color: AppTheme.SecondButton.titleColor, highlightedColor: AppTheme.SecondButton.highlightedTitleColor, fontSize: 14, fontWeight: .semibold)
        clearButton.addTarget(self, action: #selector(tappedClearButton), for: .touchUpInside)
    }
    
    @objc private func tappedCloseMessageButton(_ sender: UIButton) {
        constraintMessageViewMarginTop.constant = 0
        constraintMessageLabelwMarginTop.constant = 0
        constraintMessageLabelwMarginBottom.constant = 0
        messageLabel.text = ""
        messageLabel.isHidden = true
        closeMessageButton.isHidden = true
    }
    
    @objc private func tappedStartButton(_ sender: UIButton) {
        openFreeMode()
    }
    
    @objc private func tappedClearButton(_ sender: UIButton) {
        confirmClear()
    }
    
    private func openFreeMode() {
        let freeModeViewController = FreeModeViewController(nibName: String(describing: FreeModeViewController.self), bundle: nil)
        guard let navigationController = navigationController as? CustomNavigationController else { return }
        navigationController.openViewController(viewController: freeModeViewController, animated: true)
    }
    
    private func clearSettings() {
        settings.generation = false
        settings.frequencyAm = false
        settings.frequencyAmValue = 2
        settings.frequencyFm = false
        settings.power = 0
        settings.frequency = 15
        settings.intensity = 1
        tableView.reloadData()
    }
    
    private func confirmClear() {
        let alert = UIAlertController(title: AppStrings.ProgramsList.freeModeConfirmClear, message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: AppStrings.cancelBtnText, style: .default, handler: { _ in })
        cancelAction.setValue(AppTheme.darkBlue, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        
        let yesAction = UIAlertAction(title: AppStrings.yes, style: .default, handler: { [weak self] _ in
            self?.clearSettings()
        })
        yesAction.setValue(AppTheme.darkBlue, forKey: "titleTextColor")
        alert.addAction(yesAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: UITableViewDelegate
extension SettingsFreeModeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableview: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if items[indexPath.row].type == .generation || items[indexPath.row].type == .frequencyAm || items[indexPath.row].type == .frequencyFm {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SettingsFreeModeTableViewCell else { return UITableViewCell() }
            
            switch items[indexPath.row].type {
            case .generation:
                cell.set(item: items[indexPath.row], enable: settings.generation)
            case .frequencyAm:
                cell.set(item: items[indexPath.row], enable: settings.frequencyAm, value: settings.frequencyAmValue)
            case .frequencyFm:
                cell.set(item: items[indexPath.row], enable: settings.frequencyFm)
            default:
                return UITableViewCell()
            }
            
            cell.delegate = self
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "sliderCell", for: indexPath) as? SettingsFreeModeTableViewSliderCell else { return UITableViewCell() }
            
            switch items[indexPath.row].type {
            case .power:
                cell.set(item: items[indexPath.row], value: settings.power)
            case .frequency:
                cell.set(item: items[indexPath.row], value: settings.frequency)
            case .intensity:
                cell.set(item: items[indexPath.row], value: settings.intensity)
            default:
                return UITableViewCell()
            }
            
            cell.delegate = self
            return cell
            
        }
    }
}

// MARK: SettingsFreeModeTableViewCellDelegate
extension SettingsFreeModeViewController: SettingsFreeModeTableViewCellDelegate {
    
    func updateEnable(type: FreeModeItemType, enable: Bool) {
        
        switch type {
        case .generation:
            settings.generation = enable
        case .frequencyAm:
            settings.frequencyAm = enable
            if !enable {
                settings.frequencyAmValue = 2
            }
            tableView.reloadData()
        case .frequencyFm:
            settings.frequencyFm = enable
        default:
            break
        }
        
    }
    
    func updateSegmentedValue(type: FreeModeItemType, value: Int) {
        guard type == .frequencyAm else { return }
        settings.frequencyAmValue = value
    }
    
}

// MARK: SettingsFreeModeTableViewSliderCellDelegate
extension SettingsFreeModeViewController: SettingsFreeModeTableViewSliderCellDelegate {
    
    func updateSliderValue(type: FreeModeItemType, value: Int) {
        
        switch type {
        case .power:
            settings.power = value
        case .frequency:
            settings.frequency = value
        case .intensity:
            settings.intensity = value
        default:
            break
        }
        
    }
    
}
