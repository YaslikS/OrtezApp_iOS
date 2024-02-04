
import UIKit

class OptionsTableViewCell: UITableViewCell {
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = AppTheme.black
        label.textAlignment = .left
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
    
    private var isLast = false
    
    func set(item: OptionsItem, isLast: Bool) {
        self.isLast = isLast
        selectionStyle = .none
        nameLabel.text = item.name
        
        if let image = UIImage(named: item.image) {
            iconImageView.image = image
        }
        
        setUI()
    }
    
    private func setUI() {
        [
            iconImageView,
            nameLabel,
            rightIconImageView
        ].forEach {
            contentView.addSubview($0)
        }
        
        if !isLast {
            contentView.addSubview(separatorView)
        }
        
        setConstraints()
    }
    
    private func setConstraints() {
        
        iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16).isActive = true
        
        rightIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        rightIconImageView.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8).isActive = true
        rightIconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        rightIconImageView.widthAnchor.constraint(equalToConstant: 7).isActive = true
        rightIconImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        if !isLast {
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
            separatorView.heightAnchor.constraint(equalToConstant: 0.55).isActive = true
        }
    }
    
}
