import UIKit

enum OptionsItemType {
    case writeDevelopers
    case showDevicesPreview
    case contraindications
    case deviceManager
    case aboutApp
}

struct OptionsItem {
    var name: String
    var image: String
    var type: OptionsItemType
}
