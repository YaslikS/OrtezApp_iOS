import UIKit

class PlaylistViewController: UIViewController {
    
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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var regulateImageView: UIImageView!
    @IBOutlet weak var regulateLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    private let device: Device
    private let program: ProgramListItem
    private var items: [StageListItem] = []
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, device: Device, program: ProgramListItem) {
        self.device = device
        self.program = program
        self.items = program.stage
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
        title = program.title
        
        let batteryImage = UIImage(named: getBatteryImageName(batteryLevel: device.battery))?.withRenderingMode(.alwaysOriginal)
        let batteryBarButtonItem = UIBarButtonItem(image: batteryImage, style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItems = [batteryBarButtonItem, deviceBarButtonItem]
        
        // TableView
        tableView.bounces = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.register(PlaylistTableViewCell.self, forCellReuseIdentifier: PlaylistTableViewCell.cellId)
        tableView.delegate = self
        tableView.dataSource = self

        regulateImageView.image = UIImage(named: "regulate_icon")
        
        regulateLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        regulateLabel.textColor = AppTheme.black
        regulateLabel.numberOfLines = 0
        regulateLabel.textAlignment = .left
        regulateLabel.text = AppStrings.ProgramsList.regulateText
        
        startButton.backgroundColor = AppTheme.Button.backgroundColor
        startButton.setTitle(AppStrings.startBtnText, for: .normal)
        startButton.setTitleParams(color: AppTheme.Button.titleColor, highlightedColor: AppTheme.Button.highlightedTitleColor, fontSize: 17, fontWeight: .semibold)
        startButton.layer.cornerRadius = AppTheme.Button.cornerRadius
        startButton.addTarget(self, action: #selector(tappedStartButton), for: .touchUpInside)
    }
    
    private func getBatteryImageName(batteryLevel: Int) -> String {
        switch batteryLevel {
        case 0:
            return "battery_0"
        case 1...20:
            return "battery_20"
        case 21...40:
            return "battery_40"
        case 41...80:
            return "battery_80"
        default:
            return "battery_100"
        }
    }
    
    @objc private func tappedStartButton(_ sender: UIButton) {
        openPlayer()
    }
    
    private func openPlayer() {
        let playerViewController = PlayerViewController(nibName: String(describing: PlayerViewController.self),
                                                        bundle: nil,
                                                        device: device,
                                                        program: program,
                                                        setState: .standart)
        guard let navigationController = navigationController as? CustomNavigationController else { return }
        navigationController.openViewController(viewController: playerViewController, animated: true)
    }
}

// MARK: UITableViewDelegate
extension PlaylistViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableview: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let deviceImageView = UIImageView()
        deviceImageView.image = UIImage(named: "device1_full")
        deviceImageView.translatesAutoresizingMaskIntoConstraints = false

        let messageLabel = UILabel()
        messageLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        messageLabel.textColor = AppTheme.gray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .left
        messageLabel.text = AppStrings.ProgramsList.useAsInPhoto
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        headerView.addSubview(deviceImageView)
        headerView.addSubview(messageLabel)
        
        let width = UIScreen.main.bounds.width
        
        deviceImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 0).isActive = true
        deviceImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 0).isActive = true
        deviceImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: 0).isActive = true
        deviceImageView.heightAnchor.constraint(equalToConstant: width).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: deviceImageView.bottomAnchor, constant: 20).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -4).isActive = true

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistTableViewCell.cellId, for: indexPath) as? PlaylistTableViewCell else { return UITableViewCell() }
        cell.set(item: items[indexPath.row])
        return cell
    }
}


