import UIKit

class ModalTitleView: UIView {
    
    private let notify = NotificationCenter.default
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = AppTheme.gray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    private lazy var plusButton: UIButton = {
//        let imageView = UIButton()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
    
    let title: String
    let didTap: (() -> ())
    
    init(frame: CGRect, title: String, didTap: @escaping (() -> ())) {
        self.title = title
        self.didTap = didTap
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setUI()
    }
    
    private func setUI() {
        titleLabel.text = title.uppercased()
        
//        if let icon = UIImage(named: "add") {
//            plusButton.setImage(icon, for: .normal)
//        }
        
        [
            titleLabel,
//            plusButton
        ].forEach {
            self.addSubview($0)
        }
        
//        plusButton.addTarget(self, action: #selector(titleViewTapped), for: .touchUpInside)
        
        setConstraints()
    }
    
    private func setConstraints() {
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        
//        plusButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        plusButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16).isActive = true
//        plusButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
//        plusButton.widthAnchor.constraint(equalToConstant: 46).isActive = true
//        plusButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
    }
    
    @objc private func titleViewTapped() {
        notify.post(name: NSNotification.Name(rawValue: "user"),
                    object: nil)
        didTap()
    }
    
}
