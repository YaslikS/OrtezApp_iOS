import UIKit

protocol ModalDeviceListDelegate: AnyObject {
    func modalDidClose()
    func connectDevice(index: Int)
}

class ModalDeviceListViewController: UIViewController {
    
    @IBOutlet weak var clearView: UIView!
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var constraintModalHeight: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintTableViewMarginBottom: NSLayoutConstraint!
    
    private var safeAreaInsets: UIEdgeInsets = .zero
    private let heightModal: CGFloat = 236
    private let marginBottomModal: CGFloat = 10
    
    private var items: [Device]
    private let heightTableViewRow: CGFloat = 56
    
    weak var delegate: ModalDeviceListDelegate?
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, items: [Device]) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
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
        view.backgroundColor = AppTheme.black.withAlphaComponent(0.2)
        
        modalView.backgroundColor = AppTheme.white
        modalView.layer.cornerRadius = AppTheme.Modal.cornerRadius
        modalView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let marginBottom = safeAreaInsets.bottom > 0 ? safeAreaInsets.bottom : marginBottomModal
        constraintModalHeight.constant = heightModal + marginBottom
        
        let tapClearView = UITapGestureRecognizer(target: self, action: #selector(closeModal))
        clearView.isUserInteractionEnabled = true
        clearView.addGestureRecognizer(tapClearView)
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = AppTheme.black
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        titleLabel.text = AppStrings.Device.shoulderJoint
        
        // TableView
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.register(DeviceTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        constraintTableViewMarginBottom.constant = marginBottom
    }
    
    @objc private func closeModal() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion: { (finished: Bool) in
            if (finished) {
                self.delegate?.modalDidClose()
                self.view.removeFromSuperview()
            }
        });
    }
    
    private func handleTapItem(index: Int) {
        delegate?.connectDevice(index: index)
        closeModal()
    }
    
    func updateDeviceList(items: [Device]) {
        self.items = items
        tableView.reloadData()
    }
}

// MARK: UITableViewDelegate
extension ModalDeviceListViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DeviceTableViewCell else { return UITableViewCell() }
        cell.set(device: items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleTapItem(index: indexPath.row)
    }
}

