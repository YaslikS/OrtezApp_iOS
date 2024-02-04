import UIKit

class DevicesPreviewCollectionCell: UICollectionViewCell {
    
    var isOddItem = false
    var widthImageCell: CGFloat = 0
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = AppTheme.black
        label.textAlignment = .left
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
    
    func set(device: DevicePreview, isOddItem: Bool, widthImageCell: CGFloat) {
        self.isOddItem = isOddItem
        self.widthImageCell = widthImageCell
        
        imageView.image = UIImage(named: device.image)
        nameLabel.text = device.name
        descriptionLabel.text = device.description
        setUI()
    }
    
    private func setUI() {
        [
            imageView,
            nameLabel,
            descriptionLabel
        ].forEach {
            contentView.addSubview($0)
        }
        
        setConstraints()
    }
    
    private func setConstraints() {
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: isOddItem ? 30 : 0).isActive = true
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: widthImageCell).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: widthImageCell * 1.23).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 14).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
