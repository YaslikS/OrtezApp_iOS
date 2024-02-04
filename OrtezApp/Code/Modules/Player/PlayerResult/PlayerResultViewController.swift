import UIKit
import MKMagneticProgress

class PlayerResultViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var durationView: MKMagneticProgress!
    @IBOutlet weak var durationValueLabel: UILabel!
    @IBOutlet weak var durationValueInfoLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var maxView: MKMagneticProgress!
    @IBOutlet weak var maxValueLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    
    @IBOutlet weak var mediumView: MKMagneticProgress!
    @IBOutlet weak var mediumValueLabel: UILabel!
    @IBOutlet weak var mediumLabel: UILabel!
        
    private lazy var leftBarButtonItem: UIBarButtonItem = {
        let closeBtnImage = UIImage(named: "close_dark")?.withRenderingMode(.alwaysOriginal)
        let barButtonItem = UIBarButtonItem(image: closeBtnImage, style: .plain, target: self, action: #selector(tappedCloseButton))
        return barButtonItem
    }()
    
    private var char: SessionCharachteristic?
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, char: SessionCharachteristic?) {
        super.init(nibName: nil, bundle: nil)
        self.char = char
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = AppTheme.black
        titleLabel.textAlignment = .center
        titleLabel.text = AppStrings.Player.resultTitle
        
        setDurationView(percent: 1)
        setMaxView(percent: (char?.maxPower)!)
        setMediumView(percent: (char?.midPOwer)!)
        
        durationLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        durationLabel.textColor = AppTheme.black
        durationLabel.textAlignment = .center
        durationLabel.text = AppStrings.PlayerSettings.duration
        
        maxLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        maxLabel.textColor = AppTheme.black
        maxLabel.textAlignment = .center
        maxLabel.numberOfLines = 0
        maxLabel.text = AppStrings.Player.maxPowerStats
        
        mediumLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        mediumLabel.textColor = AppTheme.black
        mediumLabel.textAlignment = .center
        mediumLabel.numberOfLines = 0
        mediumLabel.text = AppStrings.Player.mediumPowerStats
    }
    
    private func setDurationView(percent: CGFloat) {
        durationView.setProgress(progress: percent, animated: true)
        
        durationView.progressShapeColor = AppTheme.grass
        durationView.backgroundShapeColor = AppTheme.gentleGray
        durationView.percentColor = AppTheme.black

        durationView.lineWidth = 10
        durationView.lineCap = .square
        durationView.percentLabelFormat = ""
        
        durationValueLabel.font = UIFont.systemFont(ofSize: 36, weight: .regular)
        durationValueLabel.textColor = AppTheme.black
        durationValueLabel.textAlignment = .center
        durationValueLabel.text = char?.sessionTime
        
        durationValueInfoLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        durationValueInfoLabel.textColor = AppTheme.black
        durationValueInfoLabel.textAlignment = .center
        durationValueInfoLabel.text = AppStrings.Player.minutes
    }
    
    private func setMaxView(percent: CGFloat) {
        maxView.setProgress(progress: CGFloat(percent / 100), animated: true)
        
        maxView.progressShapeColor = AppTheme.foliage
        maxView.backgroundShapeColor = AppTheme.gentleGray
        maxView.percentColor = AppTheme.black

        maxView.lineWidth = 7
        maxView.lineCap = .square
        maxView.percentLabelFormat = ""
        
        maxValueLabel.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        maxValueLabel.textColor = AppTheme.black
        maxValueLabel.textAlignment = .center
        maxValueLabel.text = "\(Int(percent))%"
    }
    
    private func setMediumView(percent: CGFloat) {
        mediumView.setProgress(progress: CGFloat(percent / 100), animated: true)
        
        mediumView.progressShapeColor = AppTheme.grass
        mediumView.backgroundShapeColor = AppTheme.gentleGray
        mediumView.percentColor = AppTheme.black

        mediumView.lineWidth = 7
        mediumView.lineCap = .square
        mediumView.percentLabelFormat = ""
        
        mediumValueLabel.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        mediumValueLabel.textColor = AppTheme.black
        mediumValueLabel.textAlignment = .center
        mediumValueLabel.text = "\(Int(percent))%"
    }
    
    @objc private func tappedCloseButton(_ sender: UIButton) {
        returnBackViewController()
    }

    @objc private func tappedClearSettingsButton(_ sender: UIButton) {
    }
}
