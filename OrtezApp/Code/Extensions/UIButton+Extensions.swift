import UIKit

extension UIButton {
    func setTitleParams(color: UIColor, highlightedColor: UIColor, fontSize: CGFloat, fontWeight: UIFont.Weight) {
        self.setTitleColor(color, for: .normal)
        self.setTitleColor(highlightedColor, for: .highlighted)
        self.titleLabel?.textColor = color
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
    }
}
