import UIKit

protocol NewProgramTableViewSegmentedControlCellDelegate: AnyObject {
    func updateEnable(enable: Bool, value: Int)
}

class NewProgramTableViewSegmentedControlCell: UITableViewCell {
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = AppTheme.black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let items = ["AM", "FM"]
        
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.backgroundColor = AppTheme.SegmentedControl.backgroundColor
        segmentedControl.addTarget(self, action: #selector(segmentDidChange), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private lazy var segmentedModeSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = AppTheme.separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var segmentedModeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = AppTheme.black
        label.textAlignment = .left
        label.text = AppStrings.ProgramsList.modeAm
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var segmentedModeControl: UISegmentedControl = {
        let items = ["1:1", "3:1", "5:1"]
        
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.backgroundColor = AppTheme.SegmentedControl.backgroundColor
        segmentedControl.addTarget(self, action: #selector(segmentModeDidChange), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = AppTheme.separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    weak var delegate: NewProgramTableViewSegmentedControlCellDelegate?
    
    func set(item: NewProgramItem, enable: Bool, value: Int) {
        let fm = "\(item.name) \(AppStrings.ProgramsList.fm)"
        let am = "\(item.name) \(AppStrings.ProgramsList.am) "
        nameLabel.text = enable ? am : fm
        segmentedControl.selectedSegmentIndex = enable ? 0 : 1
        
        var needSetSegmentedModeControl: Bool
        if enable {
            needSetSegmentedModeControl = true
            segmentedModeControl.selectedSegmentIndex = value
        } else {
            needSetSegmentedModeControl = false
        }
        
        setUI(needSetSegmentedModeControl: needSetSegmentedModeControl)
    }
    
    private func setUI(needSetSegmentedModeControl: Bool) {
        selectionStyle = .none
        
        contentView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        [
            nameLabel,
            segmentedControl,
            separatorView
        ].forEach {
            contentView.addSubview($0)
        }
        
        if needSetSegmentedModeControl {
            contentView.addSubview(segmentedModeSeparatorView)
            contentView.addSubview(segmentedModeLabel)
            contentView.addSubview(segmentedModeControl)
        }
        
        setConstraints(needSetSegmentedModeControl: needSetSegmentedModeControl)
    }
    
    private func setConstraints(needSetSegmentedModeControl: Bool) {
        
        nameLabel.centerYAnchor.constraint(equalTo: segmentedControl.centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        
        segmentedControl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 16).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        segmentedControl.widthAnchor.constraint(equalToConstant: 160).isActive = true
        
        if needSetSegmentedModeControl {
            segmentedModeSeparatorView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 12).isActive = true
            segmentedModeSeparatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
            segmentedModeSeparatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
            segmentedModeSeparatorView.heightAnchor.constraint(equalToConstant: 0.55).isActive = true
            
            segmentedModeLabel.topAnchor.constraint(equalTo: segmentedModeSeparatorView.bottomAnchor, constant: 10).isActive = true
            segmentedModeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
            segmentedModeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
            
            segmentedModeControl.topAnchor.constraint(equalTo: segmentedModeLabel.bottomAnchor, constant: 10).isActive = true
            segmentedModeControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
            segmentedModeControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
            
            separatorView.topAnchor.constraint(equalTo: segmentedModeControl.bottomAnchor, constant: 8).isActive = true
        } else {
            separatorView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 12).isActive = true
        }
        
        separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 0.55).isActive = true
    }
    
    @objc private func segmentDidChange(_ segmentedControl: UISegmentedControl) {
        let enable = segmentedControl.selectedSegmentIndex == 0
        let segmentedModeValue = segmentedModeControl.selectedSegmentIndex != -1 ? segmentedModeControl.selectedSegmentIndex : 2
        var value: Int
        
        if enable {
            value = segmentedModeValue
        } else {
            segmentedModeControl.selectedSegmentIndex = 2
            value = 2
        }
        
        delegate?.updateEnable(enable: enable, value: value)
    }
    
    @objc private func segmentModeDidChange(_ segmentedControl: UISegmentedControl) {
        delegate?.updateEnable(enable: true, value: segmentedModeControl.selectedSegmentIndex)
    }
    
}
