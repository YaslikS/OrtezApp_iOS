import UIKit
import Combine

class DeviceManagerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let heightTableViewRow: CGFloat = 48
    private var isEditableRows = false
    
    private var items: [Device] = []
    
    private var deviceManager: DeviceManagerProtocol?
    
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deviceManager = DeviceManager.shared
        deviceManager?.fetchUserDeviceList()
        
        setUI()
        updateRightBarButton()
        setBindings()
    }
    
    private func setUI() {
        title = AppStrings.Device.deviceManager
        
        // TableView
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.register(DeviceManagerTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setBindings() {
        deviceManager?.userDeviceListPublisher
            .sink(receiveValue: { [weak self] userDeviceList in
                self?.items = userDeviceList
                self?.tableView.reloadData()
            }).store(in: &cancellable)
    }
    
    private func updateRightBarButton() {
        var rightBarButtonItem: UIBarButtonItem
        
        if isEditableRows {
            rightBarButtonItem = UIBarButtonItem(title: AppStrings.ready, style: .plain, target: self, action: #selector(tappedRightBarButton))
        } else {
            rightBarButtonItem = UIBarButtonItem(title: AppStrings.Device.editDeviceListShort, style: .plain, target: self, action: #selector(tappedRightBarButton))
        }
        
        rightBarButtonItem.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold),
            NSAttributedString.Key.foregroundColor: AppTheme.darkBlue
        ], for: .normal)
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc private func tappedRightBarButton(_ sender: UIButton) {
        isEditableRows = !isEditableRows
        tableView.isEditing = isEditableRows
        updateRightBarButton()
    }
    
    private func handleTapItem(item: Device) {
        let deviceStatusViewController = DeviceStatusViewController(nibName: String(describing: DeviceStatusViewController.self), bundle: nil, device: item)
        guard let navigationController = navigationController as? CustomNavigationController else { return }
        navigationController.openViewController(viewController: deviceStatusViewController, animated: true)
    }
}

// MARK: UITableViewDelegate
extension DeviceManagerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableview: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightTableViewRow
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DeviceManagerTableViewCell else { return UITableViewCell() }
        cell.set(device: items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = items[sourceIndexPath.row]
        items.remove(at: sourceIndexPath.row)
        items.insert(item, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deviceManager?.removeDeviceFromList(index: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleTapItem(item: items[indexPath.row])
    }
}


