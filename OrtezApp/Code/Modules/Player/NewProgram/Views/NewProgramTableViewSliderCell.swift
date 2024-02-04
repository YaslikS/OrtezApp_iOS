import UIKit

protocol NewProgramTableViewSliderCellDelegate: AnyObject {
    func updateSliderValue(type: NewProgramItemType, value: Int)
}

class NewProgramTableViewSliderCell: UITableViewCell {
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = AppTheme.black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var percentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = AppTheme.gray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var startStepBorder: UIView = {
        let view = UIView()
        view.backgroundColor = AppTheme.separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var finishStepBorder: UIView = {
        let view = UIView()
        view.backgroundColor = AppTheme.separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var startLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = AppTheme.gray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var finishLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = AppTheme.gray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.tintColor = AppTheme.darkBlue
        slider.addTarget(self, action: #selector(sliderDidChange), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    var stepBordersList: [(border: UIView, label: UILabel)] = []
    
    weak var delegate: NewProgramTableViewSliderCellDelegate?
    private var type: NewProgramItemType?
    
    func set(item: NewProgramItem, value: Int) {
        self.type = item.type
        nameLabel.text = item.name
        
        let needSetPercentLabel = item.type == .power
        let needSetStartFinishStepBorder = item.type != .power
        setUI(needSetPercentLabel: needSetPercentLabel, needSetStartFinishStepBorder: needSetStartFinishStepBorder)
        if item.type != .power {
            slider.tintColor = AppTheme.darkBlue
        }
        switch item.type {
        case .power:
            setPowerSliderColor(value)
            slider.minimumValue = 0
            slider.maximumValue = 100
            startLabel.text = "0%"
            finishLabel.text = "100%"
            percentLabel.text = "\(value)%"
        case .frequency:
            slider.minimumValue = 15
            slider.maximumValue = 350
            startLabel.text = "15"
            finishLabel.text = "350"
            slider.value = getSliderValue(frequencyValue: value)
            return
        case .intensity:
            slider.minimumValue = 1
            slider.maximumValue = 4
            startLabel.text = "1"
            finishLabel.text = "4"
        case .durationMin:
            slider.minimumValue = 1
            slider.maximumValue = 8
            startLabel.text = "1"
            finishLabel.text = "30"
            slider.value = Float(value).stepsFromDuration
            return
        default:
            break
        }
        slider.value = Float(value)
    }
    
    private func setUI(needSetPercentLabel: Bool, needSetStartFinishStepBorder: Bool) {
        selectionStyle = .none
        
        contentView.subviews.forEach {
            $0.removeFromSuperview()
        }
        stepBordersList = []
        
        if needSetStartFinishStepBorder {
            contentView.addSubview(startStepBorder)
            contentView.addSubview(finishStepBorder)
        }
        
        if let type = type {
            if type == .frequency {
                setStepBorders(count: 7)
            } else if type == .intensity {
                setStepBorders(count: 4)
            } else if type == .durationMin {
                setStepBorders(count: 8)
            }
        }
        
        [
            nameLabel,
            slider,
            startLabel,
            finishLabel
        ].forEach {
            contentView.addSubview($0)
        }
        
        if needSetPercentLabel {
            contentView.addSubview(percentLabel)
        }
        
        setConstraints(needSetPercentLabel: needSetPercentLabel, needSetStartFinishStepBorder: needSetStartFinishStepBorder)
    }
    
    private func setConstraints(needSetPercentLabel: Bool, needSetStartFinishStepBorder: Bool) {
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        
        if needSetPercentLabel {
            percentLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
            percentLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 16).isActive = true
            percentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        } else {
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        }
        
        slider.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12).isActive = true
        slider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        slider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        
        if needSetStartFinishStepBorder {
            startStepBorder.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: -12).isActive = true
            startStepBorder.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 17).isActive = true
            startStepBorder.widthAnchor.constraint(equalToConstant: 1).isActive = true
            startStepBorder.heightAnchor.constraint(equalToConstant: 8).isActive = true
            
            finishStepBorder.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: -12).isActive = true
            finishStepBorder.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -17).isActive = true
            finishStepBorder.widthAnchor.constraint(equalToConstant: 1).isActive = true
            finishStepBorder.heightAnchor.constraint(equalToConstant: 8).isActive = true
            
            startLabel.topAnchor.constraint(equalTo: startStepBorder.bottomAnchor, constant: 8).isActive = true
            finishLabel.topAnchor.constraint(equalTo: finishStepBorder.bottomAnchor, constant: 8).isActive = true
        } else {
            startLabel.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 3).isActive = true
            finishLabel.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 3).isActive = true
        }
        
        startLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        startLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4).isActive = true
        
        finishLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        finishLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4).isActive = true
        
        if let type = type, (type == .frequency || type == .intensity || type == .durationMin) {
            setStepBordersConstraints()
        }
        
    }
    
    private func setStepBorders(count: Int) {
        
        for i in 0...count - 1 {
            guard i > 0 && i < (count - 1) else { continue }
            
            let stepBorder: UIView = {
                let view = UIView()
                view.backgroundColor = AppTheme.separator
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            
            let stepLabel: UILabel = {
                let label = UILabel()
                label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
                label.textColor = AppTheme.gray
                label.textAlignment = .left
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }()
            
            if let type = type {
                if type == .frequency {
                  
                    var stepValue = ""
                    if i == 1 {
                        stepValue = "30"
                    } else if i == 2 {
                        stepValue = "60"
                    } else if i == 3 {
                        stepValue = "90"
                    } else if i == 4 {
                        stepValue = "120"
                    } else if i == 5 {
                        stepValue = "180"
                    }
                    stepLabel.text = stepValue
                    
                } else if type == .intensity {
                    stepLabel.text = "\(i + 1)"
                } else if type == .durationMin {
                    let dict = [1:3, 2:5, 3:10, 4:15, 5:20, 6:25]
                    stepLabel.text = dict[i]?.description
                }
            }
            
            contentView.addSubview(stepBorder)
            contentView.addSubview(stepLabel)
            
            stepBordersList.append((border: stepBorder, label: stepLabel))
            
        }
    }
    
    private func setStepBordersConstraints() {
        guard !stepBordersList.isEmpty else { return }
        
        let count = !stepBordersList.isEmpty ? stepBordersList.count + 2 : 0
        
        var currentOffset: CGFloat = 16
        let needStepBorders: CGFloat = CGFloat(count - 1)
        let leftOffset = (UIScreen.main.bounds.width - 32) / needStepBorders
        
        for item in stepBordersList {
            
            currentOffset += leftOffset
            
            item.border.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: -12).isActive = true
            item.border.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: currentOffset).isActive = true
            item.border.widthAnchor.constraint(equalToConstant: 1).isActive = true
            item.border.heightAnchor.constraint(equalToConstant: 8).isActive = true
            
            item.label.topAnchor.constraint(equalTo: item.border.bottomAnchor, constant: 8).isActive = true
            item.label.centerXAnchor.constraint(equalTo: item.border.centerXAnchor).isActive = true
        }
    }
    
    private func setPowerSliderColor(_ value: Int) {
        if value < 11 {
            slider.tintColor = AppTheme.green
        } else {
            slider.tintColor = AppTheme.red
        }
    }
    
    @objc private func sliderDidChange(_ sender: UISlider!) {
        guard let type = type else { return }
        var value = Int(lroundf(slider.value))
        sender.value = Float(value)
        if type == .frequency  {
            let oneStepValue = (slider.maximumValue - slider.minimumValue) / 6
            let numberOfStep = Int(lroundf(slider.value / oneStepValue))
            
            value = Float(numberOfStep).stepToFrequency
            sender.value = Float(numberOfStep).stepToSlider
        } else if type == .power {
            percentLabel.text = "\(value)%"
            setPowerSliderColor(value)
        } else if type == .durationMin {
            let numberOfStep = Float(lroundf(slider.value))
            sender.value = numberOfStep.durationSteps
            value = numberOfStep.durationFromStep
        }
        
        delegate?.updateSliderValue(type: type, value: value)
    }
    
    private func getSliderValue(frequencyValue: Int) -> Float {
        let numberOfSteps = Float(frequencyValue).frequencyToStep
        let oneStepValue = (slider.maximumValue - slider.minimumValue) / 6
        return Float(numberOfSteps) * oneStepValue + slider.minimumValue
    }
}
