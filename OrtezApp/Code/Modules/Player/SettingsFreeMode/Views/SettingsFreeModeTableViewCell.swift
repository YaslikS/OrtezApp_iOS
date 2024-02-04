import UIKit

protocol SettingsFreeModeTableViewCellDelegate: AnyObject {
    func updateEnable(type: FreeModeItemType, enable: Bool)
    func updateSegmentedValue(type: FreeModeItemType, value: Int)
}

class SettingsFreeModeTableViewCell: UITableViewCell {
    
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
    
    private lazy var segmentedSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = AppTheme.separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let items = ["1:1", "3:1", "5:1"]
        
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.backgroundColor = AppTheme.SegmentedControl.backgroundColor
        segmentedControl.addTarget(self, action: #selector(segmentDidChange), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = AppTheme.separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    weak var delegate: SettingsFreeModeTableViewCellDelegate?
    private var type: FreeModeItemType?
    
    func set(item: FreeModeItem, enable: Bool) {
        self.type = item.type
        nameLabel.text = item.name
        enableSwitch.isOn = enable
        setUI(needSetSwitch: true, needSetSegmentedControl: false)
    }
    
    func set(item: FreeModeItem, enable: Bool, value: Int) {
        self.type = item.type
        nameLabel.text = item.name
        enableSwitch.isOn = enable
        
        var needSetSegmentedControl: Bool
        if item.type == .frequencyAm && enable {
            needSetSegmentedControl = true
            segmentedControl.selectedSegmentIndex = value
        } else {
            needSetSegmentedControl = false
        }
        
        setUI(needSetSwitch: true, needSetSegmentedControl: needSetSegmentedControl)
    }
    
    func set(item: FreeModeItem, value: Int) {
        self.type = item.type
        nameLabel.text = item.name
        setUI(needSetSwitch: false, needSetSegmentedControl: false)
    }
    
    private func setUI(needSetSwitch: Bool, needSetSegmentedControl: Bool) {
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
        if needSetSegmentedControl {
            contentView.addSubview(segmentedSeparatorView)
            contentView.addSubview(segmentedControl)
        }
        
        setConstraints(needSetSwitch: needSetSwitch, needSetSegmentedControl: needSetSegmentedControl)
    }
    
    private func setConstraints(needSetSwitch: Bool, needSetSegmentedControl: Bool) {
        
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        
        if needSetSwitch {
            enableSwitch.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
            enableSwitch.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 16).isActive = true
            enableSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        }
        
        if needSetSegmentedControl {
            segmentedSeparatorView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12).isActive = true
            segmentedSeparatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
            segmentedSeparatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
            segmentedSeparatorView.heightAnchor.constraint(equalToConstant: 0.55).isActive = true
            
            segmentedControl.topAnchor.constraint(equalTo: segmentedSeparatorView.bottomAnchor, constant: 6).isActive = true
            segmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
            segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
            
            separatorView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8).isActive = true
        } else {
            separatorView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12).isActive = true
        }
        
        separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 0.55).isActive = true
    }
    
    @objc private func switchDidChange(_ sender: UISwitch) {
        guard let type = type else { return }
        delegate?.updateEnable(type: type, enable: sender.isOn)
    }
    
    @objc private func segmentDidChange(_ segmentedControl: UISegmentedControl) {
        guard let type = type else { return }
        delegate?.updateSegmentedValue(type: type, value: segmentedControl.selectedSegmentIndex)
    }
    
}
