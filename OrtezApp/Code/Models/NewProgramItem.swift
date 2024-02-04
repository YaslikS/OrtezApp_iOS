import UIKit

enum NewProgramItemType {
    case generation
    case frequencyAm
    case power
    case frequency
    case intensity
    case durationMin
}




struct NewProgramItem {
    var name: String
    var type: NewProgramItemType
}
