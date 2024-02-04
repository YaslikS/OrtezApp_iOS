import UIKit

enum PlayerSettingsState {
    case freeMode
    case standart
}

class PlayerSettingsViewController: UIViewController {
    
    @IBOutlet weak var clearView: UIView!
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintModalHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintTableViewBottom: NSLayoutConstraint!
    
    private let heightTableViewRow: CGFloat = 48
    private let heightModal: CGFloat = 338
    private let marginBottomModal: CGFloat = 10
    private var safeAreaInsets: UIEdgeInsets = .zero
    private var program: ProgramListItem
    private var state: PlayerSettingsState
    private var currentIndex: Int = 0
    var closure: (()->())?
    
    private var items: [TableDefaultItem] = []
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, program: ProgramListItem, state: PlayerSettingsState, index: Int) {
        self.currentIndex = index
        self.program = program
        self.state = state
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let program = self.program.stage[currentIndex]
        print(program)

        if program.am {
            self.items =  [
                TableDefaultItem(name: AppStrings.PlayerSettings.modulation, value: "AM"),
                TableDefaultItem(name: AppStrings.PlayerSettings.mode, value: program.amMode.amMode),
                TableDefaultItem(name: AppStrings.PlayerSettings.frequency, value: "\(String(program.frequency)) \(AppStrings.PlayerSettings.hz)"),
                TableDefaultItem(name: AppStrings.PlayerSettings.intensity, value: String(program.intensivity)),
                TableDefaultItem(name: AppStrings.PlayerSettings.recommendation, value: String(program.power))
            ]
        } else if program.fm {
            self.items =  [
                TableDefaultItem(name: AppStrings.PlayerSettings.modulation, value: "FM"),
                TableDefaultItem(name: AppStrings.PlayerSettings.intensity, value: String(program.intensivity)),
                TableDefaultItem(name: AppStrings.PlayerSettings.recommendation, value: String(program.power))
            ]
              } else {
                  self.items = [
                    TableDefaultItem(name: AppStrings.PlayerSettings.modulation, value: AppStrings.PlayerSettings.continuous),
                    TableDefaultItem(name: AppStrings.PlayerSettings.frequency, value: "\(String(program.frequency)) \(AppStrings.PlayerSettings.hz)"),
                    TableDefaultItem(name: AppStrings.PlayerSettings.intensity, value: String(program.intensivity)),
                    TableDefaultItem(name: AppStrings.PlayerSettings.recommendation, value: String(program.power))
                  ]
              }
        
        
        if state != .freeMode {
            self.items.insert(TableDefaultItem(name: AppStrings.PlayerSettings.duration, value: Int(program.duration.msToSeconds).prepareLeftTime), at: 3)
        }
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
    
    private func setUI() {
        title = AppStrings.DeviceStatus.title
        
        modalView.backgroundColor = AppTheme.white
        modalView.layer.cornerRadius = AppTheme.Modal.cornerRadiusSmall
        modalView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        modalView.layer.masksToBounds = true
        
        let marginBottom = safeAreaInsets.bottom > 0 ? safeAreaInsets.bottom : marginBottomModal
        constraintTableViewBottom.constant = marginBottom
        constraintModalHeight.constant = heightModal + marginBottom
        
        
        
        // titleLabel
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = AppTheme.black
        titleLabel.textAlignment = .center
        titleLabel.text = AppStrings.PlayerSettings.title
        
        closeButton.setImage(UIImage(named: "close_dark"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        
        // TableView
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.register(PlayerSettingsTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc private func closeModal() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 0.0;
        }, completion: { (finished: Bool) in
            if (finished) {
                self.view.removeFromSuperview()
            }
        });
        closure!()
    }
}

// MARK: UITableViewDelegate
extension PlayerSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableview: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightTableViewRow
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PlayerSettingsTableViewCell else { return UITableViewCell() }
        cell.set(item: items[indexPath.row])
        return cell
    }
}


