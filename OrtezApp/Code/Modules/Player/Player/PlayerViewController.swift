import UIKit
import Combine

class PlayerViewController: UIViewController {
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var halfPercentLabel: UILabel!
    @IBOutlet weak var halfStepView: UIView!
    @IBOutlet weak var backgroundPowerView: UIView!
    @IBOutlet weak var valuePowerView: UIView!
    @IBOutlet weak var constraintValuePowerViewWidth: NSLayoutConstraint!
    @IBOutlet weak var zeroPowerLabel: UILabel!
    @IBOutlet weak var valuePowerLabel: UILabel!
    
    @IBOutlet weak var powerControlView: UIView!
    @IBOutlet weak var powerControlStackView: UIStackView!
    @IBOutlet weak var powerControlPlusView: UIView!
    @IBOutlet weak var powerControlPlusImageView: UIImageView!
    @IBOutlet weak var powerControlMinusView: UIView!
    @IBOutlet weak var powerControlMinusImageView: UIImageView!
    @IBOutlet weak var constraintPowerControlViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var leftTimeMessageLabel: UILabel!
    @IBOutlet weak var progressTimeStackView: UIStackView!
    @IBOutlet weak var valueProgressTimeView: UIView!
    @IBOutlet weak var constraintValueProgressTimeViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var sectorProgressTimeView: UIView!
    @IBOutlet weak var halfstepLeadingAnchor: NSLayoutConstraint!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var leftTimeLabel: UILabel!
    
    @IBOutlet weak var playerControlBtn: UIButton!
    
    private var tapGesturePlus: UITapGestureRecognizer?
    private var tapGestureMinus: UITapGestureRecognizer?
    private var maxValuePowerViewWidth: CGFloat = 0
    private var maxValueTimerViewWidth: CGFloat = 0
    
    private var state: State = .active
    private let bluetoothManager = BluetoothManager.shared
    private var setState: Controller!
    private var currentPower: CGFloat = 0
    private var powerFinish: CGFloat = 0
    private let powerStep: CGFloat = 1
    private var currentStageIndex = 0
    private var timerProgress: Timer? = Timer()
    private var timerTime: Timer? = Timer()
//    private var timerChechingPoweredOff: Timer? = Timer()
    private var timerPower: Timer? = Timer()
    private var timerPause: Timer? = Timer()
    private var percent: CGFloat = 0
    private var leftTime: String?
    private var currentTime: String?
    private var finishTime: String!
    private var power: [CGFloat] = []
    
    private var cancellable = Set<AnyCancellable>()
    private var deviceManager: DeviceManagerProtocol?
    private var activeDevice: Device?
    
    private let device: Device
    private let program: ProgramListItem
    var flag: Bool = true
    weak var delegate: PlayerDelegate?
    
    private lazy var leftBarButtonItem: UIBarButtonItem = {
        let closeBtnImage = UIImage(named: "close_dark")?.withRenderingMode(.alwaysOriginal)
        let barButtonItem = UIBarButtonItem(image: closeBtnImage, style: .plain, target: self, action: #selector(tappedCloseButton))
        return barButtonItem
    }()
    
    private lazy var deviceBarButtonItem: UIBarButtonItem = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 76, height: 24))
        button.backgroundColor = AppTheme.Player.backgroundDeviceBarButtonItem
        button.layer.cornerRadius = 10
        
        if let onlineIcon = UIImage(named: "online_icon") {
            button.setImage(onlineIcon, for: .normal)
            button.setImage(onlineIcon, for: .highlighted)
        }
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 12)
        
        button.setTitle(device.name, for: .normal)
        button.setTitleColor(AppTheme.lightBlack, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 8)
        
        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem
    }()
    
    private lazy var infoBarButtonItem: UIBarButtonItem = {
        let infoBtnImage = UIImage(named: "player_info_icon")?.withRenderingMode(.alwaysOriginal)
        let barButtonItem = UIBarButtonItem(image: infoBtnImage, style: .plain, target: self, action: #selector(tappedInfoBarButton))
        return barButtonItem
    }()
    
    init(nibName nibNameOrNil: String?,
         bundle nibBundleOrNil: Bundle?,
         device: Device,
         program: ProgramListItem,
         setState: Controller )
    {
        self.device = device
        self.program = program
        self.setState = setState
        super.init(nibName: nil, bundle: nil)
        guard let startPower = program.stage.first?.startPower,
              let power = program.stage.first?.power else  { return }
        self.currentPower = CGFloat(startPower)
        self.powerFinish = CGFloat(power)
        self.finishTime = Int(program.stage.map {$0.duration}.reduce(0, +).msToSeconds).prepareLeftTime
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(enterActiveMode), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pauseBackGround), name: UIApplication.didEnterBackgroundNotification, object: nil)
        UIApplication.shared.isIdleTimerDisabled = true
        
        deviceManager = DeviceManager.shared
        activeDevice = deviceManager?.activeDevice
        
        sendStatsEvent()
        setUI()
        setBindings()
//        scheduleCheckingDeviceIsNotPoweredOff()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setPowerControlView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    //MARK: -Public Methods
    
    @objc func pauseBackGround() {
        state = .active
        handleTappedPlayControl()
    }
    
    //MARK: -Private Methods
    
    private func setBindings() {
        deviceManager?.activeDevicePublisher
            .sink(receiveValue: { [weak self] device in
                guard let self = self else { return }
                if self.activeDevice != nil && device == nil {
                    self.openDevicesConnectionLost()
                } else {
                    checkFirmwareNumber(device: device)
                }
            }).store(in: &cancellable)
    }
    
    private func checkFirmwareNumber(device: Device?){
        print(device?.status!.firmwareNumber)
        let firNum = String((device?.status!.firmwareNumber)!, radix: 2)
        print(pad(string: firNum, toSize: 8))
        
        let mask = 128  //  10000000
        let res = (device?.status!.firmwareNumber)! & mask
        if res == 128 {
            print(res)
            tappedPlayControlButton(playerControlBtn)
        }
    }
    
    private func pad(string : String, toSize: Int) -> String {
      var padded = string
      for _ in 0..<(toSize - string.count) {
        padded = "0" + padded
      }
      return padded
    }

    private func openDevicesConnectionLost() {
        let lostDeviceMac = activeDevice?.mac ?? ""
        let devicesConnectionLost = DevicesConnectionLostViewController(nibName: String(describing: DevicesConnectionLostViewController.self), bundle: nil, lostDeviceMac: lostDeviceMac)
        setRootViewController(viewController: devicesConnectionLost, animation: true)
    }
    
    @objc private func enterActiveMode() {
        state = .pause
        handleTappedPlayControl()
    }
    
    private func sendStatsEvent() {
        guard let stage = program.stage.first else {
            return
        }
        switch setState {
        case .freeModeTest, .manual, .none:
            break
        case .standart where program.id == -1: // CustomProgram
            StatHelper.runCustomOrFreeProgram(.runCustomProgram, amMode: stage.am, fmMode: stage.fm, freq: stage.frequency, amModeVal: stage.amMode, intensity: stage.intensivity, time: stage.duration / 60000)
        case .standart:
            guard let eventName = program.statsTitle else {
                debugPrint("The device program id: \(program.id) doesn't have statsTitle!")
                return
            }
            StatHelper.runDeviceProgram(eventName)
        case .freeMode:
            StatHelper.runCustomOrFreeProgram(.run_free_go, amMode: stage.am, fmMode: stage.fm, freq: stage.frequency, amModeVal: stage.amMode, intensity: stage.intensivity, time: stage.duration / 60000)
        }
    }
    
    private func openPlayerSettings() {
            switch setState! {
            case .freeModeTest, .freeMode:
                let playerSettingsViewController = PlayerSettingsViewController(nibName: String(describing: PlayerSettingsViewController.self), bundle: nil, program: self.program, state: .freeMode, index: currentStageIndex)
                openModalViewController(viewController: playerSettingsViewController)
                playerSettingsViewController.closure = {
                    self.infoBarButtonItem.isEnabled = true
                }
            case .manual, .standart:
                let playerSettingsViewController = PlayerSettingsViewController(nibName: String(describing: PlayerSettingsViewController.self), bundle: nil, program: self.program, state: .standart, index: currentStageIndex)
                openModalViewController(viewController: playerSettingsViewController)
                playerSettingsViewController.closure = {
                    self.infoBarButtonItem.isEnabled = true
                }
                self.infoBarButtonItem.isEnabled = false
            }
    }
    
    private func tappedAnimation(view: UIView, _ completion: @escaping () -> Void) {
        view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.05,
                       delay: 0,
                       options: .curveLinear,
                       animations: {
            view.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveLinear,
                           animations: {
                view.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }) { _ in
                view.isUserInteractionEnabled = true
                completion()
            }
        }
    }
    
    private func longPause() {
        self.timerPause = Timer.scheduledTimer(withTimeInterval: 120, repeats: true) {[weak self] block in
            guard let self = self else {
                return
            }
            if self.state == .pause {
                self.goToPause()
                block.invalidate()
                self.timerPower = nil
            } else {
                block.invalidate()
                self.timerPause = nil
            }
        }
    }

    private func setMessage() {
        
        switch setState! {
            
        case .freeModeTest:
            messageLabel.text = AppStrings.Player.test
        case .standart, .manual:
            message()
        case .freeMode:
            messageLabel.text = AppStrings.Player.freeMode
        }
    }
    
    private func changeSettingsOnBT4() {
        let currentProgram = program.stage[currentStageIndex]
        let generation = currentProgram.generation ?? false
        let frequency = currentProgram.frequency
        let am = currentProgram.am
        let amMode = currentProgram.amMode
        let intensivity = currentProgram.intensivity
        let fm = currentProgram.fm
        
        if am == false && fm == true {
            bluetoothManager.changeFM()
            bluetoothManager.changeIntensivity(data: intensivity)
        } else if generation {
            bluetoothManager.changeFrequency(data: frequency)
            bluetoothManager.solidModualtion()
            bluetoothManager.changeIntensivity(data: intensivity)
        } else {
            bluetoothManager.changeFrequency(data: frequency)
            bluetoothManager.changeAmModulation(data: amMode)
            bluetoothManager.changeIntensivity(data: intensivity)
        }
    }
    
    private func setArrangedViewsInStack() {
        for view in progressTimeStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        let alltime = program.stage.map {$0.duration}.reduce(0, +).msToSeconds
        let count = program.stage.count
        let actualWidth = maxValueTimerViewWidth - progressTimeStackView.spacing * CGFloat(count - 2)
        let widthForOneSecond = actualWidth / alltime
        for value in 0..<count {
            let view = UIView()
            let widthForOneSector = CGFloat(program.stage[value].duration.msToSeconds) * CGFloat(widthForOneSecond)
            progressTimeStackView.addArrangedSubview(view)
            view.backgroundColor = .black
            view.alpha = 0.2
            NSLayoutConstraint.activate([
                view.heightAnchor.constraint(equalToConstant: progressTimeStackView.frame.height),
                view.widthAnchor.constraint(equalToConstant: widthForOneSector)
            ])
        }
    }
    
    private func message() {
        switch state {
            
        case .active:
            if !program.stage.isEmpty && program.stage.indices.contains(currentStageIndex) {
                messageLabel.text = program.stage[currentStageIndex].comment
            } else {
                messageLabel.text = ""
            }
        case .pause:
            messageLabel.text = AppStrings.Player.messagePause
        }
    }
    
    private func setPowerControlView() {
        halfstepLeadingAnchor.constant = ((backgroundPowerView.bounds.width - 5) / 100) * powerFinish
        let powerControlPlusViewHeight = self.powerControlPlusView.bounds.height
        let powerControlViewWidth = powerControlPlusViewHeight + 48
        self.constraintPowerControlViewWidth.constant = powerControlViewWidth
        self.powerControlView.layer.cornerRadius = powerControlViewWidth / 2
        self.powerControlPlusView.layer.cornerRadius = powerControlPlusViewHeight / 2
        self.powerControlMinusView.layer.cornerRadius = powerControlPlusViewHeight / 2
    }
    
    private func setControlBtnImage() {
        var playerControlBtnImage: UIImage?
        switch state {
        case .active:
            playerControlBtnImage = UIImage(named: "pause_icon")?.withRenderingMode(.alwaysOriginal)
        case .pause:
            playerControlBtnImage = UIImage(named: "play_icon")?.withRenderingMode(.alwaysOriginal)
        }
        playerControlBtn.setImage(playerControlBtnImage, for: .normal)
    }
    
    private func setPowerValue(power: CGFloat) {
        if power == 0 {
            BluetoothManager.shared.powerToNil()
        }
        var width: CGFloat = (maxValuePowerViewWidth) / 100 * power
        
        width = max(min(width, maxValuePowerViewWidth), 0)
        
        let value = "\(Int(power))%"
        if width > 20 {
            zeroPowerLabel.text = ""
            zeroPowerLabel.isHidden = true
            
            valuePowerLabel.text = value
            valuePowerLabel.isHidden = false
        } else {
            valuePowerLabel.text = ""
            valuePowerLabel.isHidden = true
            
            zeroPowerLabel.text = value
            zeroPowerLabel.isHidden = false
        }
        constraintValuePowerViewWidth.constant = width
        self.currentPower = power
    }
    
    private func setToCurrentPower() {
        self.timerPower = Timer.scheduledTimer(withTimeInterval: 0.75, repeats: true, block: {[weak self] block in
            guard let self = self else { return }
            if self.powerFinish < self.currentPower {
                self.currentPower -= self.powerStep
            } else {
                self.currentPower += self.powerStep
            }
            self.setPowerValue(power: self.currentPower)
            self.power.append(self.currentPower)
            BluetoothManager.shared.changerPower(settings: .plusPower, data: Int(self.currentPower))
            if self.currentPower == self.powerFinish {
                self.timerPower = nil
                self.tapGesturePlus?.isEnabled = true
                self.tapGestureMinus?.isEnabled = true
                block.invalidate()
            }
        })
    }
    
    private func setValueProgressTimeUI() {
        switch state {
        case .active:
            valueProgressTimeView.backgroundColor = AppTheme.black
        case .pause:
            if let pausePattern = UIImage(named: "pause_pattern") {
                valueProgressTimeView.backgroundColor = UIColor(patternImage: pausePattern)
            }
        }
    }
    
//    private func stopIfDeviceIsPoweredOff() {
//        if currentPower > 1 && bluetoothManager.isPoweredOff() {
//            if setState == .freeMode || setState == .freeModeTest {
//                closePlayer()
//            } else {
//                handleTappedPlayControl()
//            }
//        }
//    }
    
//    private func scheduleCheckingDeviceIsNotPoweredOff () {
//        self.timerChechingPoweredOff = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {[weak self] _ in
//            self?.stopIfDeviceIsPoweredOff()
//        }
//    }
    
    private func setProgressTime(currentTime: String, leftTime: String) {
        var timeToLeft = leftTime
        var leftSeconds = 0
        currentTimeLabel.text = currentTime
        let timeFinish = self.finishTime.components(separatedBy: ":")
        leftTimeLabel.text = finishTime
        self.leftTimeMessageLabel.text = "\(AppStrings.Player.timeLeft) \(leftTime)"
        self.timerTime = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] block in
            guard let self = self else { return }
            let leftTimeArray = timeToLeft.components(separatedBy: ":")
            if !leftTimeArray.isEmpty {
                guard let left = Int(leftTimeArray[0]), let right = Int(leftTimeArray[1]) else { return }
                guard let leftTime = Int(String(timeFinish[safe: 0]!)) else { return }
                guard let leftsec = Int(String(timeFinish[safe: 1]!)) else { return }
                leftSeconds = left * 60 + right
                let current = (leftTime * 60 + leftsec) - leftSeconds + 1
                if Double(current) == self.program.stage.sum(index: self.currentStageIndex) {
                    self.currentStageIndex += 1
                    if self.currentStageIndex <= self.program.stage.count - 1 {
                        let program = self.program.stage[self.currentStageIndex]
                        self.powerFinish = CGFloat(program.power)
                        self.halfPercentLabel.text = "\(Int(self.powerFinish))%"
                        self.setPowerValue(power: CGFloat(program.startPower))
                        self.timerPower?.invalidate()
                        self.setToCurrentPower()
                        
                        self.setPowerControlView()
                        self.changeSettingsOnBT4()
                        self.message()
                    }
                }
                leftSeconds -= 1
                let minutes = leftSeconds/60
                let seconds = leftSeconds % 60
                self.leftTime = leftSeconds.prepareLeftTime
                self.currentTime = current.prepareCurrentime
                
                guard let currentTime = self.currentTime, let lefTtime = self.leftTime else { return }
                
                self.currentTimeLabel.text = "\(currentTime)"
                self.leftTimeMessageLabel.text = "\(AppStrings.Player.timeLeft) \(lefTtime)"
                timeToLeft = "\(minutes):\(seconds)"
            }
        })
        
        let limiter = 0.01
        guard let minutes = (Double(String(timeFinish[safe: 0]!))) else { return }
        guard let seconds = Double(String(timeFinish[safe: 1]!)) else { return }
        let persentLeft = CGFloat(100/((minutes * 60 + seconds) / limiter))
        self.timerProgress = Timer.scheduledTimer(withTimeInterval: limiter, repeats: true) {[weak self] block in
            guard let self = self else { return }
            self.percent += persentLeft
            
            var width: CGFloat = self.maxValueTimerViewWidth / 100 * self.percent
            if width < 0 {
                width = 0
            }
            if width >= self.maxValueTimerViewWidth {
                width = self.maxValueTimerViewWidth
                if self.finishTime == self.currentTime {
                    if self.setState == .manual {
                        BluetoothManager.shared.saveSettings()
                    }
                    self.stopTimer()
                    BluetoothManager.shared.powerToNil()
                    self.openResult()
                    UIApplication.shared.isIdleTimerDisabled = false
                }
            }
            self.constraintValueProgressTimeViewWidth.constant = width
        }
    }
    
    private func stopTimer() {
        switch state {
        case .active:
            UIApplication.shared.isIdleTimerDisabled = false
            self.timerProgress?.invalidate()
            self.timerTime?.invalidate()
//            self.timerChechingPoweredOff?.invalidate()
            self.timerPower?.invalidate()
            self.timerPower = nil
            self.timerTime = nil
//            self.timerChechingPoweredOff = nil
            self.timerProgress = nil
        case .pause:
            self.timerPause?.invalidate()
            UIApplication.shared.isIdleTimerDisabled = true
            self.timerPause = nil
            guard let currentTime = self.currentTime, let lefTtime = self.leftTime else { return }
            if self.setState != .freeMode {
                setProgressTime(currentTime: currentTime, leftTime: lefTtime)
//                scheduleCheckingDeviceIsNotPoweredOff()
            }
        }
    }
    
    private func goToPause() {
        let pauseViewController = PlayerReturnPauseViewController(nibName: String(describing: PlayerReturnPauseViewController.self), bundle: nil, device: device, program: program)
        guard let navigationController = navigationController as? CustomNavigationController else { return }
        navigationController.openViewController(viewController: pauseViewController, animated: true)
    }
    
    private func openResult() {
        let charachteristic = SessionCharachteristic(maxPower: self.power.max,
                                                     midPOwer: self.power.average,
                                                     sessionTime: self.finishTime)
        let resultViewController = PlayerResultViewController(nibName: String(describing: PlayerResultViewController.self), bundle: nil, char: charachteristic)
        guard let navigationController = navigationController as? CustomNavigationController else { return }
        navigationController.openViewController(viewController: resultViewController, animated: true)
    }
    
    private func openPlayer() {
        let programmViewController = ProgramsListViewController()
        setRootViewController(viewController: programmViewController)
    }
    
    private func handleTappedPlayControl() {
        guard setState != .freeMode else {
            return
        }
        stopTimer()
        switch state {
        case .active:
            state = .pause
            leftTimeMessageLabel.isHidden = true
            longPause()
            setPowerValue(power: 0)
            self.tapGesturePlus?.isEnabled = true
            self.tapGestureMinus?.isEnabled = true
        case .pause:
            state = .active
            leftTimeMessageLabel.isHidden = true
            longPause()
            setToCurrentPower()
        }
        setMessage()
        setValueProgressTimeUI()
        setControlBtnImage()
    }
    
    private func freeMode() {
        leftTimeLabel.isHidden = true
        leftTimeMessageLabel.isHidden = true
        valuePowerLabel.isHidden = true
        progressTimeStackView.isHidden = true
        valueProgressTimeView.isHidden = true
        currentTimeLabel.isHidden = true
        playerControlBtn.isUserInteractionEnabled = false
        playerControlBtn.isHidden = true
    }
    
    private func alert() {
        let alert = UIAlertController(title:"\(AppStrings.ProgramsList.freemodeInfo) ", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: AppStrings.ok, style: .default, handler: { _ in
            self.openPlayer()
        })
        cancelAction.setValue(AppTheme.darkBlue, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
//    private func closePlayer() {
//        stopTimer()
//        BluetoothManager.shared.powerToNil()
//        delegate?.returnPower(power: Int(powerFinish))
//        navigationController?.popViewController(animated: true)
//    }
    
    @objc private func tappedCloseButton(_ sender: UIButton) {
        UIApplication.shared.isIdleTimerDisabled = false
        if setState == .freeMode {
            alert()
        } else {
          stopTimer()
          BluetoothManager.shared.powerToNil()
          delegate?.returnPower(power: Int(powerFinish))
          navigationController?.popViewController(animated: true)    
        }
    }
    
    @objc private func tappedPlayControlButton(_ sender: UIButton) {
        handleTappedPlayControl()
    }
    
    @objc private func tappedInfoBarButton(_ sender: UIButton) {
        openPlayerSettings()
    }
    
    @objc private func plusTapped() {
        tappedAnimation(view: powerControlPlusView) {
            let width = self.halfstepLeadingAnchor.constant
            let backgroundWidth = self.backgroundPowerView.bounds.width
            if width < backgroundWidth && self.powerFinish < 100 {
                self.powerFinish += 1
                self.halfstepLeadingAnchor.constant += 1
                self.halfPercentLabel.text = "\(Int(self.powerFinish))%"
            }
            if self.state == .active {
                if self.timerPower == nil {
                    self.setToCurrentPower()
                }
            }
        }
    }
    
    @objc private func minusViewTapped() {
        tappedAnimation(view: powerControlMinusView) {
            let width = self.halfstepLeadingAnchor.constant
            if width >= 1 && self.powerFinish >= 1  {
                self.powerFinish -= 1
                self.halfstepLeadingAnchor.constant -= 1
                self.halfPercentLabel.text = "\(Int(self.powerFinish))%"
                if self.currentPower >= self.powerFinish {
                    self.timerPower?.invalidate()
                    self.timerPower = nil
                    self.setPowerValue(power: self.powerFinish)
                    if self.state == .active {
                        BluetoothManager.shared.changerPower(settings: .plusPower, data: Int(self.currentPower))
                    }
                }
            }
        }
    }
}

//MARK: -SetUI-
extension PlayerViewController {
    private func setUI() {
        
        constraintValuePowerViewWidth.constant = 1
        guard let power = program.stage.first?.power else { return }
        maxValueTimerViewWidth = UIScreen.main.bounds.width - 32
        maxValuePowerViewWidth = UIScreen.main.bounds.width - 54
        
        view.backgroundColor = AppTheme.yellow
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItems = [infoBarButtonItem, deviceBarButtonItem]
        
        messageLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        messageLabel.textColor = AppTheme.lightBlack
        messageLabel.numberOfLines = 0
        messageLabel.sizeToFit()
        messageLabel.textAlignment = .center
        setMessage()
        
        halfPercentLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        halfPercentLabel.textColor = AppTheme.black
        halfPercentLabel.textAlignment = .center
        halfPercentLabel.text = "\(power)%"
        
        zeroPowerLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        zeroPowerLabel.textColor = AppTheme.mediumBlack
        zeroPowerLabel.textAlignment = .left
        
        valuePowerLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        valuePowerLabel.textColor = AppTheme.mediumBlack
        valuePowerLabel.textAlignment = .right
        
        halfStepView.backgroundColor = AppTheme.Player.backgroundPower
        
        backgroundPowerView.layer.cornerRadius = 8
        backgroundPowerView.backgroundColor = AppTheme.Player.backgroundPower
        
        valuePowerView.layer.cornerRadius = 8
        valuePowerView.backgroundColor = AppTheme.black
        
        setPowerValue(power: currentPower)
        if currentPower != powerFinish {
            setToCurrentPower()
        }
        self.power.append(currentPower)
        
        powerControlView.backgroundColor = AppTheme.Player.backgroundPower
        powerControlPlusView.backgroundColor = AppTheme.white
        powerControlMinusView.backgroundColor = AppTheme.white
        
        powerControlPlusImageView.image = UIImage(named: "plus_icon")
        powerControlMinusImageView.image = UIImage(named: "minus_icon")
        
        tapGesturePlus = UITapGestureRecognizer(target: self, action: #selector(plusTapped))
        powerControlPlusView.isUserInteractionEnabled = true
        powerControlPlusView.addGestureRecognizer(tapGesturePlus!)
        
        tapGestureMinus = UITapGestureRecognizer(target: self, action: #selector(minusViewTapped))
        powerControlMinusView.isUserInteractionEnabled = true
        powerControlMinusView.addGestureRecognizer(tapGestureMinus!)
        
        leftTimeMessageLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        leftTimeMessageLabel.textColor = AppTheme.lightBlack
        leftTimeMessageLabel.textAlignment = .center
        
        for view in progressTimeStackView.subviews {
            view.backgroundColor = AppTheme.Player.backgroundPower
        }
        
        progressTimeStackView.layer.cornerRadius = 2
        progressTimeStackView.layer.masksToBounds = true
        
        valueProgressTimeView.layer.cornerRadius = 2
        setValueProgressTimeUI()
        
        currentTimeLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        currentTimeLabel.textColor = AppTheme.lightBlack
        currentTimeLabel.textAlignment = .left
        
        leftTimeLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        leftTimeLabel.textColor = AppTheme.lightBlack
        leftTimeLabel.textAlignment = .right
        switch setState! {
        case .freeModeTest:
            freeMode()
        case .freeMode:
            freeMode()
            view.backgroundColor = AppTheme.freeMode
        case .manual, .standart:
            setProgressTime(currentTime: "0:00", leftTime: self.finishTime)
        }
        setArrangedViewsInStack()
        changeSettingsOnBT4()
        setControlBtnImage()
        playerControlBtn.addTarget(self, action: #selector(tappedPlayControlButton), for: .touchUpInside)
    }
}

