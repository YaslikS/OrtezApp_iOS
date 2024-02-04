import UIKit

struct AppTheme {
    
    static let clear = UIColor.clear
    static let black = UIColor.black
    static let mediumBlack = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
    static let lightBlack = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    static let white = UIColor.white
    static let lightPurple = #colorLiteral(red: 0.6509803922, green: 0.6705882353, blue: 0.7490196078, alpha: 0.1)
    static let lightGray = #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 0.7215686275, alpha: 1)
    static let gentleGray = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
    static let gray = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
    static let green = #colorLiteral(red: 0.4352941176, green: 0.7176470588, blue: 0.262745098, alpha: 1)
    static let red = #colorLiteral(red: 0.8196078431, green: 0.2156862745, blue: 0.1921568627, alpha: 1)
    static let grass = #colorLiteral(red: 0.6078431373, green: 0.7764705882, blue: 0.2352941176, alpha: 1)
    static let foliage = #colorLiteral(red: 0.8745098039, green: 0.7294117647, blue: 0.3529411765, alpha: 1)
    static let yellow = #colorLiteral(red: 0.9789120555, green: 0.9354223609, blue: 0.7327638268, alpha: 1)
    static let darkBlue = #colorLiteral(red: 0.1294117647, green: 0.2117647059, blue: 0.368627451, alpha: 1)
    static let separator = #colorLiteral(red: 0.7764705882, green: 0.7764705882, blue: 0.7843137255, alpha: 1)
    static let freeMode = #colorLiteral(red: 0.6862745098, green: 0.8, blue: 0.9490196078, alpha: 1)
    
    struct NavigationBar {
        static let tintColor = #colorLiteral(red: 0.1697039306, green: 0.2803536952, blue: 0.4446052611, alpha: 1)
    }
    
    struct Button {
        static let backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.2117647059, blue: 0.368627451, alpha: 1)
        static let titleColor = AppTheme.white
        static let highlightedTitleColor = AppTheme.white.withAlphaComponent(0.7)
        static let cornerRadius: CGFloat = 24
    }
    
    struct SecondButton {
        static let titleColor = #colorLiteral(red: 0.1294117647, green: 0.2117647059, blue: 0.368627451, alpha: 1)
        static let highlightedTitleColor = titleColor.withAlphaComponent(0.7)
    }
    
    struct SegmentedControl {
        static let backgroundColor = #colorLiteral(red: 0.9468019605, green: 0.946900785, blue: 0.9499631524, alpha: 1)
    }
    
    struct TextField {
        static let backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9411764706, alpha: 1)
        static let textColor = #colorLiteral(red: 0.5137254902, green: 0.5176470588, blue: 0.5294117647, alpha: 1)
        static let cornerRadius: CGFloat = 10
    }
    
    struct Modal {
        static let cornerRadius: CGFloat = 24
        static let cornerRadiusSmall: CGFloat = 13
        static let cornerRadiusConfirm: CGFloat = 14
        static let confirmFormBackground = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8862745098, alpha: 1)
        static let cornerRadiusConfirmForm: CGFloat = 10
    }
    
    struct Player {
        static let backgroundDeviceBarButtonItem = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.05)
        static let backgroundPower = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)
        static let cornerRadiusMessage: CGFloat = 10
        static let messageBackground = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1)
    }
    
    struct Program {
        static let freeModeBackground = #colorLiteral(red: 0.06274509804, green: 0.1254901961, blue: 0.2470588235, alpha: 1)
    }
    
}
