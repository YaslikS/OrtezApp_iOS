import UIKit

protocol UserSettingsDelegate: AnyObject {
    func addProgram(stage: StageListItem)
    func replaceProgram(stage: StageListItem)
}

enum NewProgramState {
    case replace
    case manual
    case freeMode
}

class NewProgramViewController: UIViewController {
    
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var closeMessageButton: UIButton!
    @IBOutlet weak var constraintMessageViewMarginTop: NSLayoutConstraint!
    @IBOutlet weak var constraintMessageLabelwMarginTop: NSLayoutConstraint!
    @IBOutlet weak var constraintMessageLabelwMarginBottom: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var testButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    private var defaultItems: [NewProgramItem] = [
        NewProgramItem(name: AppStrings.ProgramsList.freeModeGeneration, type: .generation),
        NewProgramItem(name: AppStrings.ProgramsList.modulationAm, type: .frequencyAm),
        NewProgramItem(name: AppStrings.ProgramsList.freeModePower, type: .power),
        NewProgramItem(name: AppStrings.ProgramsList.freeModeIntensity, type: .intensity),
        NewProgramItem(name: AppStrings.ProgramsList.newProgramDurationMin, type: .durationMin),
    ]
    
    private var frequencyAmItems: [NewProgramItem] = [
        NewProgramItem(name: AppStrings.ProgramsList.freeModeGeneration, type: .generation),
        NewProgramItem(name: AppStrings.ProgramsList.modulationAm, type: .frequencyAm),
        NewProgramItem(name: AppStrings.ProgramsList.freeModePower, type: .power),
        NewProgramItem(name: AppStrings.ProgramsList.freeModeFrequency, type: .frequency),
        NewProgramItem(name: AppStrings.ProgramsList.freeModeIntensity, type: .intensity),
        NewProgramItem(name: AppStrings.ProgramsList.newProgramDurationMin, type: .durationMin),
    ]
    
    private var generationItems: [NewProgramItem] = [
        NewProgramItem(name: AppStrings.ProgramsList.freeModeGeneration, type: .generation),
        NewProgramItem(name: AppStrings.ProgramsList.freeModePower, type: .power),
        NewProgramItem(name: AppStrings.ProgramsList.freeModeFrequency, type: .frequency),
        NewProgramItem(name: AppStrings.ProgramsList.freeModeIntensity, type: .intensity),
        NewProgramItem(name: AppStrings.ProgramsList.newProgramDurationMin, type: .durationMin),
    ]
    
    private var items: [NewProgramItem] = []
    private var settings: NewProgramSettings
    private let device: Device?
    private var state: NewProgramState!
    private var bigPowerAlertShown = false
    weak var delegate: UserSettingsDelegate?
    
    init(nibName nibNameOrNil: String?,
         bundle nibBundleOrNil: Bundle?,
         settings: NewProgramSettings,
         device: Device,
         state: NewProgramState)
    {
        self.settings = settings
        self.device = device
        self.state = state
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
        if state != .freeMode {
            configureNavigation()
            title = AppStrings.ProgramsList.newProgramBaseName
        } else {
            title = AppStrings.ProgramsList.freeMode
        }
        
        messageView.backgroundColor = AppTheme.Player.messageBackground
        messageView.layer.cornerRadius = AppTheme.Player.cornerRadiusMessage
        let tap = UITapGestureRecognizer(target: self, action: #selector(openInformationScreen))
        messageView.addGestureRecognizer(tap)
        
        messageLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        messageLabel.textColor = AppTheme.black
        messageLabel.numberOfLines = 0
        messageLabel.text = AppStrings.ProgramsList.freeModeMessage
        
        let btnImage = UIImage(named: "close_message")?.withRenderingMode(.alwaysOriginal)
        closeMessageButton.setImage(btnImage, for: .normal)
        closeMessageButton.addTarget(self, action: #selector(tappedCloseMessageButton), for: .touchUpInside)
        
        // TableView
        if settings.generation {
            items = generationItems
        } else if settings.frequencyAm {
            items = frequencyAmItems
        } else {
            items = defaultItems
        }
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.register(NewProgramTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(NewProgramTableViewSliderCell.self, forCellReuseIdentifier: "sliderCell")
        tableView.register(NewProgramTableViewSegmentedControlCell.self, forCellReuseIdentifier: "segmentedCell")
        tableView.delegate = self
        tableView.dataSource = self
        if state != .freeMode {
            startButton.backgroundColor = AppTheme.Button.backgroundColor
            startButton.setTitle(AppStrings.ProgramsList.newProgramTesting, for: .normal)
            startButton.setTitleParams(color: AppTheme.Button.titleColor, highlightedColor: AppTheme.Button.highlightedTitleColor, fontSize: 17, fontWeight: .semibold)
            startButton.layer.cornerRadius = AppTheme.Button.cornerRadius
            startButton.addTarget(self, action: #selector(tappedStartButton), for: .touchUpInside)
            
            testButton.isHidden = true
        } else {
            startButton.backgroundColor = AppTheme.Button.backgroundColor
            startButton.setTitle(AppStrings.start, for: .normal)
            startButton.setTitleParams(color: AppTheme.Button.titleColor, highlightedColor: AppTheme.Button.highlightedTitleColor, fontSize: 17, fontWeight: .semibold)
            startButton.layer.cornerRadius = AppTheme.Button.cornerRadius
            startButton.addTarget(self, action: #selector(tappedStartButton), for: .touchUpInside)
            
            testButton.backgroundColor = AppTheme.gentleGray
            testButton.setTitle(AppStrings.ProgramsList.newProgramTesting, for: .normal)
            testButton.setTitleParams(color: AppTheme.Button.backgroundColor, highlightedColor: AppTheme.Button.highlightedTitleColor, fontSize: 17, fontWeight: .semibold)
            testButton.layer.cornerRadius = AppTheme.Button.cornerRadius
            testButton.addTarget(self, action: #selector(testTapped), for: .touchUpInside)
        }
        
        clearButton.setTitle(AppStrings.ProgramsList.clearSettings, for: .normal)
        clearButton.setTitleParams(color: AppTheme.SecondButton.titleColor, highlightedColor: AppTheme.SecondButton.highlightedTitleColor, fontSize: 14, fontWeight: .semibold)
        clearButton.addTarget(self, action: #selector(tappedClearButton), for: .touchUpInside)
    }
    
    @objc private func openInformationScreen() {
        let viewController = InformationViewController(nibName: String(describing: InformationViewController.self), bundle: nil)
        viewController.title = AppStrings.Main.info
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func openProgrammList() {
        navigationController?.popViewController(animated: true)
    }
    
    private func getAllSettings() -> StageListItem {
        StageListItem(num: 1,
                      generation: settings.generation,
                      duration: settings.durationMin * 60 * 1000,
                      startPower: 1 ,
                      power: settings.power,
                      frequency: settings.frequency,
                      am: settings.frequencyAm,
                      amMode: settings.frequencyAmValue,
                      intensivity: settings.intensity,
                      fm: (!settings.frequencyAm && !settings.generation),
                      comment: AppStrings.ProgramsList.userProgramm)
    }
    
    private func getAllUserSettings() -> NewProgramSettings {
        NewProgramSettings(generation: settings.generation,
                           frequencyAm: settings.frequencyAm,
                           frequencyAmValue: settings.frequencyAmValue,
                           power: settings.power,
                           frequency: settings.frequency,
                           intensity: settings.intensity,
                           durationMin: settings.durationMin)
    }
    
    private func clearSettings() {
        settings.generation = false
        settings.frequencyAm = false
        settings.frequencyAmValue = 2
        settings.power = 1
        settings.frequency = 15
        settings.intensity = 1
        settings.durationMin = 1
        tableView.reloadData()
    }
    
    private func configureNavigation() {
        let rightButton = UIBarButtonItem(title: AppStrings.done,
                                          style: .plain,
                                          target: self  ,
                                          action: #selector(doneTapped))
        let font = UIFont.systemFont(ofSize: 17, weight: .bold)
        let attribute = [NSAttributedString.Key.font: font]
        rightButton.setTitleTextAttributes(attribute, for: .normal)
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func openPlayer(setState: Controller) {
        guard let device = self.device else { return }
        let stage = getAllSettings()
        let program = ProgramListItem(id: 1, title: AppStrings.ProgramsList.userProgramm, description: "", file: "", icon: "", electrode: 1, stage: [stage])
        let playerViewController = PlayerViewController(nibName: String(describing: PlayerViewController.self),
                                                        bundle: nil,
                                                        device: device,
                                                        program: program,
                                                        setState: setState)
        guard let navigationController = navigationController as? CustomNavigationController else { return }
        navigationController.openViewController(viewController: playerViewController, animated: true)
        playerViewController.delegate = self
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
    
    @objc private func tappedCloseMessageButton(_ sender: UIButton) {
        constraintMessageViewMarginTop.constant = 0
        constraintMessageLabelwMarginTop.constant = 0
        constraintMessageLabelwMarginBottom.constant = 0
        messageLabel.text = ""
        messageLabel.isHidden = true
        closeMessageButton.isHidden = true
    }
    
    @objc private func tappedStartButton(_ sender: UIButton) {
        if settings.power != 0 {
            switch state! {
            case .replace:
                openPlayer(setState: .manual)
            case .manual:
                openPlayer(setState: .manual)
            case .freeMode:
                BluetoothManager.shared.saveSettings()
                openPlayer(setState: .freeMode)
            }
        } else {
            alert()
        }
    }
    
    @objc private func testTapped(_ sender: UIButton) {
        if settings.power != 0 {
            openPlayer(setState: .freeModeTest)
        } else {
            alert()
        }
    }
    
    private func alert() {
        let alert = UIAlertController(title:"\(AppStrings.ProgramsList.power) ", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: AppStrings.ok, style: .default, handler: { _ in })
        cancelAction.setValue(AppTheme.darkBlue, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func tappedClearButton(_ sender: UIButton) {
        confirmClear()
    }
    
    @objc private func doneTapped() {
        let stage = getAllSettings()
        
        switch state! {
        case .replace:
            delegate?.replaceProgram(stage: stage)
        case .manual:
            delegate?.addProgram(stage: stage)
        default:
            break
        }
        
        openProgrammList()
    }
}

// MARK: UITableViewDelegate
extension NewProgramViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        
        if items[indexPath.row].type == .generation {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NewProgramTableViewCell else { return UITableViewCell() }
            
            cell.set(item: items[indexPath.row], enable: settings.generation)
            cell.delegate = self
            return cell
            
        } else if items[indexPath.row].type == .frequencyAm {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "segmentedCell", for: indexPath) as? NewProgramTableViewSegmentedControlCell else { return UITableViewCell() }
            
            cell.set(item: items[indexPath.row], enable: settings.frequencyAm, value: settings.frequencyAmValue)
            cell.delegate = self
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "sliderCell", for: indexPath) as? NewProgramTableViewSliderCell else { return UITableViewCell() }
                if state != .freeMode {
                    switch items[indexPath.row].type {
                    case .power:
                        cell.set(item: items[indexPath.row], value: settings.power)
                    case .frequency:
                        cell.set(item: items[indexPath.row], value: settings.frequency)
                    case .intensity:
                        cell.set(item: items[indexPath.row], value: settings.intensity)
                    case .durationMin:
                        cell.set(item: items[indexPath.row], value: settings.durationMin)
                    default:
                        return UITableViewCell()
                    }
                } else {
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
                }
           
            cell.delegate = self
            return cell
        }
    }
}

// MARK: NewProgramTableViewCellDelegate
extension NewProgramViewController: NewProgramTableViewCellDelegate {
    func updateEnable(type: NewProgramItemType, enable: Bool) {
        
        switch type {
        case .generation:
            settings.generation = enable
            
            if enable {
                items = generationItems
            } else {
                settings.frequencyAm = false
                settings.frequencyAmValue = 2
                items = defaultItems
            }
        case .frequencyAm:
            settings.frequencyAm = enable
            
            if enable {
                items = frequencyAmItems
            } else {
                items = defaultItems
            }
        default:
            break
        }
        tableView.reloadData()
    }
}

// MARK: NewProgramTableViewSliderCellDelegate
extension NewProgramViewController: NewProgramTableViewSliderCellDelegate {
    func updateSliderValue(type: NewProgramItemType, value: Int) {
        
        switch type {
        case .power:
            if value > 10 && !bigPowerAlertShown {
                showAlert(title: AppStrings.ProgramsList.bigPowerAlertTitle,
                          message: AppStrings.ProgramsList.bigPowerAlertMessage)
                bigPowerAlertShown = true  // don't show again while the VC is alive
            }
            settings.power = value
        case .frequency:
            settings.frequency = value
        case .intensity:
            settings.intensity = value
        case .durationMin:
            settings.durationMin = value
        default:
            break
        }
    }
}

// MARK: NewProgramTableViewSegmentedControlCellDelegate
extension NewProgramViewController: NewProgramTableViewSegmentedControlCellDelegate {
    func updateEnable(enable: Bool, value: Int) {
        settings.frequencyAm = enable
        settings.frequencyAmValue = enable ? value : 2
        
        if enable {
            items = frequencyAmItems
        } else {
            items = defaultItems
        }
        
        tableView.reloadData()
    }
}

extension NewProgramViewController: PlayerDelegate {
    func returnPower(power: Int) {
        settings.power = power
        tableView.reloadData()
    }
}
