import Foundation

extension Int {
    var prepareCurrentime: String {
        switch self {
        case 0...9:
             return "0:0\(self)"
        case 10...59:
            return "0:\(self)"
        default:
            let minutes = self / 60
            let seconds = self % 60
            if seconds >= 10 {
                return"\(minutes):\(seconds)"
            }
            return "\(minutes):0\(seconds)"
        }
    }
    
    var prepareLeftTime: String {
        let minutes = self/60
        let seconds = self % 60
        if minutes == 0 && seconds < 10 {
            return "0:0\(seconds)"
        }
        if minutes == 0 && seconds > 10 {
            return "0:\(seconds)"
        }
        if seconds < 10 {
            return "\(minutes):0\(seconds)"
        }
        else {
            return "\(minutes):\(seconds)"
        }
    }
    
    var msToSeconds: Double { Double(self) / 1000 }
    
    var amMode: String {
        switch self {
        case 1:
            return "3:1"
        case 2:
            return "5:1"
        case 3,0:
            return "1:1"
        default:
            return ""
        }
    }
}
