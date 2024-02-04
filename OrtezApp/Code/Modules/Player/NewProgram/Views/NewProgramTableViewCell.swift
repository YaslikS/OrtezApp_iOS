import UIKit

protocol NewProgramTableViewCellDelegate: AnyObject {
    func updateEnable(type: NewProgramItemType, enable: Bool)
}

class NewProgramTableViewCell: UITableViewCell {
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = AppTheme.black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var enableSwitch: UISwitch = {
        let enableSwitch = UISwitch()
        enableSwitch.onTintColor = AppTheme.darkBlue
        enableSwitch.addTarget(self, action: #selector(switchDidChange), for: .valueChanged)
        enableSwitch.translatesAutoresizingMaskIntoConstraints = false
        return enableSwitch
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = AppTheme.separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    weak var delegate: NewProgramTableViewCellDelegate?
    private var type: NewProgramItemType?
    
    func set(item: NewProgramItem, enable: Bool) {
        self.type = item.type
        nameLabel.text = item.name
        enableSwitch.isOn = enable
        setUI(needSetSwitch: true)
    }
    
    func set(item: NewProgramItem, value: Int) {
        self.type = item.type
        nameLabel.text = item.name
        setUI(needSetSwitch: false)
    }
    
    private func setUI(needSetSwitch: Bool) {
        selectionStyle = .none
        
        contentView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        [
            nameLabel,
            separatorView
        ].forEach {
            contentView.addSubview($0)
        }
        
        if needSetSwitch {
            contentView.addSubview(enableSwitch)
        }
        
        setConstraints(needSetSwitch: needSetSwitch)
    }
    
    private func setConstraints(needSetSwitch: Bool) {
        
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        
        if needSetSwitch {
            enableSwitch.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
            enableSwitch.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 16).isActive = true
            enableSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        }
        
        separatorView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 0.55).isActive = true
    }
    
    @objc private func switchDidChange(_ sender: UISwitch) {
        guard let type = type else { return }
        delegate?.updateEnable(type: type, enable: sender.isOn)
    }
    
}
