import UIKit

class OptionsDeviceCollectionCell: UICollectionViewCell {
    
    private lazy var bodyView: UIView = {
        let view = UIView()
        view.backgroundColor = AppTheme.white
        view.layer.cornerRadius = 6
        view.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        view.layer.shadowColor = AppTheme.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .firstBaseline
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var onlineIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var deviceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = AppTheme.black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = AppTheme.gray
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var batteryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = AppTheme.gray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var batteryIconImageView: UIImageView = {
        let imageView = UIImageView()
        
        if let batteryIcon = UIImage(named: "battery_80") {
            imageView.image = batteryIcon
        }
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var deviceImageViewSize: CGFloat = 0
    
    func set(device: Device, deviceImageViewSize: CGFloat, isOnline: Bool) {
        self.deviceImageViewSize = deviceImageViewSize
        
        if let deviceImage = device.image {
            deviceImageView.image = UIImage(named: deviceImage)
        }
        
        if let batteryIcon = UIImage(named: getBatteryImageName(batteryLevel: device.battery)) {
            batteryIconImageView.image = batteryIcon
        }
        
        nameLabel.text = device.name
        descriptionLabel.text = device.information
        batteryLabel.text = "\(device.battery)%"
        setUI(isOnline: isOnline)
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
    
    private func setUI(isOnline: Bool) {
        
        contentView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        if isOnline {
            if let onlineIcon = UIImage(named: "online_icon") {
                onlineIconImageView.image = onlineIcon
            }
        } else {
            if let offlineIcon = UIImage(named: "offline_icon") {
                onlineIconImageView.image = offlineIcon
            }
        }
        
        [
            onlineIconImageView,
            nameLabel,
            batteryLabel,
            batteryIconImageView
        ].forEach {
            headerStackView.addArrangedSubview($0)
        }
        
        [
            deviceImageView,
            headerStackView,
            descriptionLabel
        ].forEach {
            bodyView.addSubview($0)
        }
        contentView.addSubview(bodyView)
        
        setConstraints()
    }
    
    private func setConstraints() {
        bodyView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3).isActive = true
        bodyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3).isActive = true
        bodyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        bodyView.heightAnchor.constraint(equalToConstant: deviceImageViewSize - 6).isActive = true
        
        deviceImageView.topAnchor.constraint(equalTo: bodyView.topAnchor, constant: 0).isActive = true
        deviceImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        deviceImageView.widthAnchor.constraint(equalToConstant: deviceImageViewSize - 3).isActive = true
        deviceImageView.bottomAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: 0).isActive = true

        headerStackView.topAnchor.constraint(equalTo: bodyView.topAnchor, constant: 16).isActive = true
        headerStackView.leadingAnchor.constraint(equalTo: deviceImageView.trailingAnchor, constant: 16).isActive = true
        headerStackView.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor, constant: -16).isActive = true
        
        onlineIconImageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        onlineIconImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        batteryLabel.widthAnchor.constraint(equalToConstant: 32).isActive = true
        batteryLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        batteryIconImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        batteryIconImageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 4).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: deviceImageView.trailingAnchor, constant: 16).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor, constant: -16).isActive = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
