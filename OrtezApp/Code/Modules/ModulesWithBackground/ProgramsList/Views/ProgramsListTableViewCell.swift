
import UIKit

class ProgramsListTableViewCell: UITableViewCell {
    private lazy var bodyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var iconBodyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
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
    
    private var isLast = false
    
    func set(item: ProgramListItem, isLast: Bool) {
        nameLabel.text = item.title
        descriptionLabel.text = item.description
        
        let iconName = fetchIconName(fileName: item.icon)
        if let image = UIImage(named: iconName) {
            iconImageView.image = image
        }
        if item.icon == "" {
            iconImageView.image = UIImage(named: "ic_user")
        }
        
        setUI()
    }
    
    private func setUI() {
        selectionStyle = .none
        // remove old
       
        if iconImageView.image == UIImage(named: "ic_free") {
                self.bodyView.backgroundColor = AppTheme.lightPurple
                self.bodyView.layer.cornerRadius = 10
            }
       
        
        iconBodyView.addSubview(iconImageView)
        [
            iconBodyView,
            nameLabel,
            descriptionLabel
        ].forEach {
            bodyView.addSubview($0)
        }
        
        contentView.addSubview(bodyView)
        setConstraints()
    }
    
    private func setConstraints() {
        bodyView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        bodyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        bodyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        bodyView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        
        iconBodyView.topAnchor.constraint(equalTo: bodyView.topAnchor, constant: 11).isActive = true
        iconBodyView.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor, constant: 11).isActive = true
        iconBodyView.widthAnchor.constraint(equalToConstant: 42).isActive = true
        iconBodyView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        iconImageView.topAnchor.constraint(equalTo: iconBodyView.topAnchor, constant: 0).isActive = true
        iconImageView.leadingAnchor.constraint(equalTo: iconBodyView.leadingAnchor, constant: 0).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: bodyView.topAnchor, constant: 11).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: iconBodyView.trailingAnchor, constant: 11).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor, constant: -11).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: iconBodyView.trailingAnchor, constant: 11).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor, constant: -11).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: -24).isActive = true
    }
    
    private func fetchIconName(fileName: String) -> String {
        return fileName.replacingOccurrences(of: ".png", with: "")
    }
    
}
