import UIKit

enum FreeModeItemType {
    case generation
    case frequencyAm
    case frequencyFm
    case power
    case frequency
    case intensity
}

struct FreeModeItem {
    var name: String
    var type: FreeModeItemType
}
