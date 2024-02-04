import UIKit

class DeviceTableViewCell: UITableViewCell {
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bluetooth")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = AppTheme.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func set(device: Device) {
        selectionStyle = .none
        nameLabel.text = device.name ?? device.mac
        setUI()
    }
    
    private func setUI() {
        [
            iconImageView,
            nameLabel,
        ].forEach {
            contentView.addSubview($0)
        }
        
        setConstraints()
    }
    
    private func setConstraints() {
        iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 21).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 13).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: 40).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -21).isActive = true
    }
    
}
