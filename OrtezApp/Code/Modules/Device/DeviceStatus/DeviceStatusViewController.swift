import UIKit

class DeviceStatusViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let heightTableViewRow: CGFloat = 48
    
    private let device: Device
    private var items: [TableDefaultItem] = []
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, device: Device) {
        self.device = device
        if let status = device.status {
            items = [
                TableDefaultItem(name: AppStrings.DeviceStatus.code, value: status.code),
                TableDefaultItem(name: AppStrings.DeviceStatus.firmwareNumber, value: "\(status.firmwareNumber)"),
                TableDefaultItem(name: AppStrings.DeviceStatus.battery, value: "\(device.battery)%"),
                TableDefaultItem(name: AppStrings.DeviceStatus.rssi, value: "\(status.rssi)dB"),
                TableDefaultItem(name: AppStrings.DeviceStatus.type, value: status.type),
                TableDefaultItem(name: AppStrings.DeviceStatus.powerFirst, value: "\(status.powerFirst)"),
                TableDefaultItem(name: AppStrings.DeviceStatus.powerSecond, value: "\(status.powerSecond)"),
            ]
        }
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
        title = AppStrings.DeviceStatus.title
        
        let btnImage = UIImage(named: getBatteryImageName(batteryLevel: device.battery))?.withRenderingMode(.alwaysOriginal)
        let rightBarButtonItem = UIBarButtonItem(image: btnImage, style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        // TableView
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.register(DeviceStatusTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
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
}

// MARK: UITableViewDelegate
extension DeviceStatusViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DeviceStatusTableViewCell else { return UITableViewCell() }
        cell.set(item: items[indexPath.row])
        return cell
    }
}


