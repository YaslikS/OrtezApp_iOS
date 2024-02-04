import UIKit

class DeviceManagerTableViewCell: UITableViewCell {
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = AppTheme.black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var macLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = AppTheme.gray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var rightIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "right_arrow")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = AppTheme.separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func set(device: Device) {
        selectionStyle = .none
        nameLabel.text = device.name ?? ""
        setUI()
    }
    
    private func setUI() {
        contentView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        [
            nameLabel,
            macLabel,
            rightIconImageView,
            separatorView
        ].forEach {
            contentView.addSubview($0)
        }
        
        setConstraints()
    }
    
    private func setConstraints() {
        
        nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        nameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        nameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        macLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        macLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 16).isActive = true
        macLabel.trailingAnchor.constraint(equalTo: rightIconImageView.leadingAnchor, constant: -16).isActive = true
        macLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        macLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        rightIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        rightIconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        rightIconImageView.widthAnchor.constraint(equalToConstant: 7).isActive = true
        rightIconImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 0.55).isActive = true
    }
    
}
