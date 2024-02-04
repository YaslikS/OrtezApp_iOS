
import UIKit
import CoreData
import Combine

protocol DeviceManagerProtocol {
    var userDeviceList: [Device] { get }
    var userDeviceListPublisher: Published<[Device]>.Publisher { get }
    var activeDevice: Device? { get set}
    var activeDevicePublisher: Published<Device?>.Publisher { get }
    func fetchUserDeviceList()
    func appendDeviceInList(device: Device, isSetActiveDevice: Bool)
    func updateDeviceInList(index: Int, device: Device)
    func updateDeviceInList(device: Device)
    func updateActiveDevice(device: Device)
    func checkExistDeviceInList(index: Int) -> Device?
    func checkExistDeviceInList(deviceMac: String) -> Device?
    func removeDeviceFromList(index: Int)
    func removeDeviceFromList(deviceMac: String)
    func setActiveDevice(index: Int)
    func setActiveDevice(deviceMac: String)
}

class DeviceManager: DeviceManagerProtocol {
    
    @Published var userDeviceList: [Device] = []
    var userDeviceListPublisher: Published<[Device]>.Publisher { $userDeviceList }
    
    @Published var activeDevice: Device?
    var activeDevicePublisher: Published<Device?>.Publisher { $activeDevice }
    
    static let shared: DeviceManagerProtocol = DeviceManager()
    private init() {}
    
    func fetchUserDeviceList() {
        userDeviceList.removeAll()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: UserDevices.self))
        
        do {
            let fetchResult = try managedContext.fetch(fetchRequest) as? [UserDevices]
            if let resultDevices = fetchResult {
                if resultDevices.count > 0 {
                    for item in resultDevices {
                        guard let device = item.toDevice() else { continue }
                        userDeviceList.append(device)
                        
                        if let activeDevice = activeDevice, device.mac == activeDevice.mac {
                            self.activeDevice = device
                        }
                    }
                }
            }
        } catch _ as NSError {
        }
    }
    
    func appendDeviceInList(device: Device, isSetActiveDevice: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.managedObjectContext
        let userDevices = UserDevices(context: managedContext)
        
        userDevices.name = device.name
        userDevices.information = device.information
        userDevices.mac = device.mac
        userDevices.image = device.image
        userDevices.battery = Int16(device.battery)
        
        let userDevicesStatus = UserDevicesStatus(context: managedContext)
        userDevicesStatus.device = userDevices
        
        if let status = device.status {
            userDevicesStatus.code = status.code
            userDevicesStatus.firmwareNumber = Int16(status.firmwareNumber)
            userDevicesStatus.powerFirst = Int16(status.powerFirst)
            userDevicesStatus.powerSecond = Int16(status.powerSecond)
            userDevicesStatus.rssi = Int16(status.rssi)
            userDevicesStatus.type = status.type
        }
        userDevices.status = userDevicesStatus
        
        do {
            try managedContext.save()
            fetchUserDeviceList()
            
            if isSetActiveDevice {
                setActiveDevice(deviceMac: device.mac)
            }
        }
        catch {
            debugPrint("Error add: \(error.localizedDescription)")
        }
    }
    
    func updateDeviceInList(index: Int, device: Device) {
        guard userDeviceList.indices.contains(index) else { return }
        updateDeviceInList(device: device)
    }
    
    func updateDeviceInList(device: Device) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: UserDevices.self))
        fetchRequest.predicate = NSPredicate(format: "mac == %@", device.mac)
        
        do {
            let fetchResult = try managedContext.fetch(fetchRequest) as? [UserDevices]
            if let resultDevices = fetchResult {
                if resultDevices.count > 0, let userDevices = resultDevices.first {
                    do {
                        userDevices.setValue(device.name, forKey: "name")
                        userDevices.setValue(device.information, forKey: "information")
                        userDevices.setValue(device.mac, forKey: "mac")
                        userDevices.setValue(device.image, forKey: "image")
                        userDevices.setValue(Int16(device.battery), forKey: "battery")
                        
                        // DevicesStatus
                        let userDevicesStatus = UserDevicesStatus(context: managedContext)
                        userDevicesStatus.device = userDevices
                        
                        if let status = device.status {
                            userDevicesStatus.code = status.code
                            userDevicesStatus.firmwareNumber = Int16(status.firmwareNumber)
                            userDevicesStatus.powerFirst = Int16(status.powerFirst)
                            userDevicesStatus.powerSecond = Int16(status.powerSecond)
                            userDevicesStatus.rssi = Int16(status.rssi)
                            userDevicesStatus.type = status.type
                        }
                        userDevices.setValue(userDevicesStatus, forKey: "status")
                        
                        try managedContext.save()
                        fetchUserDeviceList()
                        
                    } catch let error as NSError {
                        debugPrint("Error update: \(error.localizedDescription)")
                    }
                }
            }
        } catch {
            debugPrint("Error update: \(error.localizedDescription)")
        }
    }
    
    func updateActiveDevice(device: Device) {
        guard let activeDevice = activeDevice, let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: UserDevices.self))
        fetchRequest.predicate = NSPredicate(format: "mac == %@", activeDevice.mac)
        
        do {
            let fetchResult = try managedContext.fetch(fetchRequest) as? [UserDevices]
            if let resultDevices = fetchResult {
                if resultDevices.count > 0, let userDevices = resultDevices.first {
                    do {
                        
                        if let name = device.name {
                            userDevices.setValue(name, forKey: "name")
                        }
                        if let information = device.information {
                            userDevices.setValue(information, forKey: "information")
                        }
                        if let image = device.image {
                            userDevices.setValue(image, forKey: "image")
                        }
                        userDevices.setValue(Int16(device.battery), forKey: "battery")
                        
                        // DevicesStatus
                        let userDevicesStatus = UserDevicesStatus(context: managedContext)
                        userDevicesStatus.device = userDevices
                        
                        if let status = device.status {
                            userDevicesStatus.code = status.code
                            userDevicesStatus.firmwareNumber = Int16(status.firmwareNumber)
                            userDevicesStatus.powerFirst = Int16(status.powerFirst)
                            userDevicesStatus.powerSecond = Int16(status.powerSecond)
                            userDevicesStatus.rssi = Int16(status.rssi)
                            userDevicesStatus.type = status.type
                        }
                        userDevices.setValue(userDevicesStatus, forKey: "status")
                        
                        try managedContext.save()
                        fetchUserDeviceList()
                        
                    } catch let error as NSError {
                        debugPrint("Error update: \(error.localizedDescription)")
                    }
                }
            }
        } catch {
            debugPrint("Error update: \(error.localizedDescription)")
        }
    }
    
    func checkExistDeviceInList(index: Int) -> Device? {
        guard userDeviceList.indices.contains(index) else { return nil }
        let device = checkExistDeviceInList(deviceMac: userDeviceList[index].mac)
        return device
    }
    
    func checkExistDeviceInList(deviceMac: String) -> Device? {
        fetchUserDeviceList()
        guard !userDeviceList.isEmpty else { return nil }
        let device = userDeviceList.filter{ $0.mac == deviceMac }.first
        return device
    }
    
    func removeDeviceFromList(index: Int) {
        guard userDeviceList.indices.contains(index) else { return }
        StatHelper.deviceDeleted(macAddress: userDeviceList[index].mac)
        removeDeviceFromList(deviceMac: userDeviceList[index].mac)
    }
    
    func removeDeviceFromList(deviceMac: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: UserDevices.self))
        fetchRequest.predicate = NSPredicate(format: "mac == %@", deviceMac)
        
        do {
            let fetchResult = try managedContext.fetch(fetchRequest) as? [UserDevices]
            if let resultDevices = fetchResult {
                if resultDevices.count > 0, let device = resultDevices.first {
                    do {
                        managedContext.delete(device)
                        try managedContext.save()
                        fetchUserDeviceList()
                    } catch let error as NSError {
                        debugPrint("Error removing: \(error.localizedDescription)")
                    }
                }
            }
        } catch _ as NSError {
        }
    }
    
    func setActiveDevice(index: Int) {
        guard userDeviceList.indices.contains(index) else { return }
        setActiveDevice(deviceMac: userDeviceList[index].mac)
    }
    
    func setActiveDevice(deviceMac: String) {
        fetchUserDeviceList()
        guard !userDeviceList.isEmpty else { return }
        let device = userDeviceList.filter{ $0.mac == deviceMac }.first
        activeDevice = device
    }
    
}
