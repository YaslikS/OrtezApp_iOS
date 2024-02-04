import UIKit

extension UserDevices {
    
    func toDevice() -> Device? {
        guard let mac = self.mac else { return nil }
        let battery = Int(self.battery)
        let status = self.status?.toDeviceStatus()
        let device = Device(name: self.name, information: self.information, mac: mac, battery: battery, image: self.image, status: status)
        return device
    }
    
}
