//
//  DevicesData.swift
//  OrtezApp
//
//  Created by Artem Denis on 09.05.2022.
//

import Foundation

enum DataTypes: String {
    case devices
    case programs
    case electrodes
}

enum EnDataTypes: String {
    case devices_en
    case programs_en
    case electrodes_en
}

protocol DevicesDataProtocol {
    func fetchData()
    func fetchDeviceTypeTitle(btCode: Int) -> String
    func fetchPrograms(btCode: Int, electrode: Int) -> [ProgramListItem]
    func shareElectrodes() -> [ElectrodesListItem]
}

class DevicesData: DevicesDataProtocol {
    
    private var deviceList: DeviceList!
    private var programList: ProgramList!
    private var electrodesList: ElectrodesList!
    private var deviceTypes = [String: String]()
    private var devicePrograms = [String: [Int]]()
    private var defaultDeviceTypes: DeviceListItem?
    
    static let shared: DevicesDataProtocol = DevicesData()
    private init() {}
    
    func fetchData() {
        if NSLocale.current.languageCode == "ru" {
            fetchDevices()
            fetchElectrodes()
            fetchPrograms()
        }else {
            fetchEnDevices()
            fetchEnElectrodes()
            fetchEnPrograms()
        }
    }
    
    func fetchDeviceTypeTitle(btCode: Int) -> String {
        
        if let deviceType = deviceTypes["\(btCode)"] {
            return deviceType
        } else if let defaultDeviceTypes = defaultDeviceTypes {
            return defaultDeviceTypes.title
        }
        
        return AppStrings.Device.typeNotFound
        
    }
    
    func fetchPrograms(btCode: Int, electrode: Int) -> [ProgramListItem] {
        if let programs = devicePrograms["\(btCode)"] {
            var programsForDevice = [ProgramListItem]()
            for program in programList.programs {
                if programs.contains(program.id) {
                    programsForDevice.append(program)
                }
            }
            
            var programsForElectrode = [ProgramListItem]()
            for item in programsForDevice {
                if item.electrode == electrode {
                    programsForElectrode.append(item)
                }
            }
            
            return programsForElectrode
        }
        return []
    }
    
    func shareElectrodes() -> [ElectrodesListItem] {
        var electrodeListItems = [ElectrodesListItem]()
        for electrode in electrodesList.electrodes {
            electrodeListItems.append(electrode)
        }
        return electrodeListItems
    }
    
    private func fetchDevices() {
        deviceList = fetchData(type: .devices)!
        
        for device in deviceList.devices {
            deviceTypes["\(device.btCode)"] = device.title
            devicePrograms["\(device.btCode)"] = device.programs
            
            if device.btCode == DeviceSettings.Constants.defaultDeviceBtCode {
                defaultDeviceTypes = device
            }
        }
    }
    
    private func fetchPrograms() {
        programList = fetchData(type: .programs)!
    }
    
    private func fetchElectrodes() {
        electrodesList = fetchData(type: .electrodes)!
    }
    
    private func fetchEnElectrodes() {
        electrodesList = fetchENData(type: .electrodes_en)!
    }
    
    private func fetchEnDevices() {
        deviceList = fetchENData(type: .devices_en)!
        
        for device in deviceList.devices {
            deviceTypes["\(device.btCode)"] = device.title
            devicePrograms["\(device.btCode)"] = device.programs
            
            if device.btCode == DeviceSettings.Constants.defaultDeviceBtCode {
                defaultDeviceTypes = device
            }
        }
    }
    
    private func fetchEnPrograms() {
        programList = fetchENData(type: .programs_en)!
    }
    
    private func fetchData<T: Decodable>(type: DataTypes) -> T? {
        
        if let path = Bundle.main.path(forResource: type.rawValue, ofType: "json") {
            do {
                print(path)
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let list = try decoder.decode(T.self, from: data)
                return list
                
            } catch {
                debugPrint("error: \(error)")
            }
        }
        
        return nil
        
    }
    
    private func fetchENData<T: Decodable>(type: EnDataTypes) -> T? {
        
        if let path = Bundle.main.path(forResource: type.rawValue, ofType: "json") {
            do {
                
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let list = try decoder.decode(T.self, from: data)
                return list
                
            } catch {
                debugPrint("error: \(error)")
            }
        }
        
        return nil
        
    }
    
}
