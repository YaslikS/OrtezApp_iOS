import UIKit

class FreeModeViewController: UIViewController {
    
    private lazy var leftBarButtonItem: UIBarButtonItem = {
        let closeBtnImage = UIImage(named: "close_light")?.withRenderingMode(.alwaysOriginal)
        let barButtonItem = UIBarButtonItem(image: closeBtnImage, style: .plain, target: self, action: #selector(tappedCloseButton))
        return barButtonItem
    }()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var barTintColor = AppTheme.white
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 14.0, *) {
        } else {
            navigationController?.navigationBar.isTranslucent = false
            barTintColor = navigationController?.navigationBar.barTintColor ?? AppTheme.white
            navigationController?.navigationBar.barTintColor = AppTheme.Program.freeModeBackground
        }
 
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if #available(iOS 14.0, *) {
        } else {
            navigationController?.navigationBar.isTranslucent = true
            navigationController?.navigationBar.barTintColor = barTintColor
        }
        
        UIApplication.shared.statusBarStyle = .default
    }
    
    private func setUI() {
        navigationItem.leftBarButtonItem = leftBarButtonItem
        view.backgroundColor = AppTheme.Program.freeModeBackground
        imageView.image = UIImage(named: "device_free_mode")
        
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        messageLabel.textColor = AppTheme.white
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .left
        messageLabel.text = AppStrings.ProgramsList.useInfo
    }
    
    @objc private func tappedCloseButton(_ sender: UIButton) {
        returnBackViewController()
    }
}
