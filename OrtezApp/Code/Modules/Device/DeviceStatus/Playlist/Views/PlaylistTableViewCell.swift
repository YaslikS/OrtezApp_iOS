import UIKit

class PlaylistTableViewCell: UITableViewCell {
    
    static let cellId = "PlaylistTableViewCell"
    
    private lazy var stageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = AppTheme.black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = AppTheme.black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = AppTheme.black
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = AppTheme.separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func set(item: StageListItem) {
        selectionStyle = .none
        stageLabel.text = "\(AppStrings.ProgramsList.stage) \(item.num)"
        nameLabel.text = item.comment
        timeLabel.text = fetchTime(duration: item.duration)
        setUI()
    }
    
    private func setUI() {
        [
            stageLabel,
            nameLabel,
            timeLabel,
            separatorView
        ].forEach {
            contentView.addSubview($0)
        }
        
        setConstraints()
    }
    
    private func setConstraints() {
        stageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        stageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        stageLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stageLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: stageLabel.trailingAnchor, constant: 16).isActive = true
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        
        timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        timeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: nameLabel.trailingAnchor, constant: 16).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        timeLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        timeLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 0.55).isActive = true
    }
    
    private func fetchTime(duration: Int) -> String {
        let durationSeconds = duration / 1000
        
        let minutes = durationSeconds / 60
        let seconds = durationSeconds - minutes * 60
        
        let showMinutes = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        let showSeconds = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        return "\(showMinutes):\(showSeconds)"
    }
    
}
