import Foundation

struct ElectrodesList: Codable {
    let electrodes: [ElectrodesListItem]
}

struct ElectrodesListItem: Equatable, Codable {
    
    let id: Int
    let name: String
    let icon: String
    
    static func == (lhs: ElectrodesListItem, rhs: ElectrodesListItem) -> Bool {
        lhs.id   == rhs.id    &&
        lhs.name == rhs.name  &&
        lhs.icon == rhs.icon
    }
    
}
