import UIKit

extension UserDevicesStatus {
    
    func toDeviceStatus() -> DeviceStatus? {
        guard let code = self.code, let type = self.type else { return nil }
        let firmwareNumber = Int(self.firmwareNumber)
        let rssi = Int(self.rssi)
        let powerFirst = Int(self.powerFirst)
        let powerSecond = Int(self.powerSecond)
        let program = Int(self.program)
        
        let deviceStatus = DeviceStatus(code: code, firmwareNumber: firmwareNumber, rssi: rssi, type: type, powerFirst: powerFirst, powerSecond: powerSecond, program: program)
        
        return deviceStatus
    }
    
}
