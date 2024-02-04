//
//  BluetoothManager.swift
//  OrtezApp
//
//  Created by Artem Denis on 14.04.2022.
//

import CoreBluetooth

protocol BluetoothManagerSearchListDelegate: AnyObject {
    func showOpenBluetoothSettings()
    func appendDeviceToList(peripheral: CBPeripheral)
    func returnBackViewController()
    func openConnectionError(state: ConnectionErrorViewController.State)
    func clearData()
    func openSuccessConnection(deviceMac: String)
}

protocol ConnectDeviceProtocol {
    var deviceManager: DeviceManagerProtocol? { get set }
    var searchTimerAction: (() -> ())? { get set }
    var searchListDelegate: BluetoothManagerSearchListDelegate? { get set }
    func startSearchDevices(autoConnectDeviceList: [String])
    func startSearchLostDevice(lostDeviceMac: String)
    func stopSearchDevices()
    func extendSearchDevices()
//    func isPoweredOff() -> Bool
    func changerPower(settings: Settings, data: Int)
    func powerToNil()
    func saveSettings()
    func changeIntensivity(data: Int)
    func changeFrequency(data: Int)
    func changeAmModulation(data: Int)
    func solidModualtion()
    func changeFM()
    func connectDevice(peripheral: CBPeripheral)
}

enum Settings {
    case plusPower
    case minusPower
}

class BluetoothManager: NSObject, ConnectDeviceProtocol {
    static let shared: ConnectDeviceProtocol = BluetoothManager()
    
    var deviceManager: DeviceManagerProtocol?
    var searchTimerAction: (() -> ())?
    private var manager: CBCentralManager?
    private var searchTimer: Timer?
    var autoConnectDeviceList: [String] = []
    var lostDeviceMac = ""
    var selectedDevicePeripheral: CBPeripheral?
    var characteristic: CBCharacteristic?
    private var selectRSSI: Int = 0
    private var connectPeripheralTimer: Timer?
    
    weak var searchListDelegate: BluetoothManagerSearchListDelegate?
    
    private override init() {
        super.init()
    }
    
    deinit {
        disconnectDevice()
        stopSearchDevices()
    }
    
    func stopSearchDevices() {
        manager?.stopScan()
        searchTimer?.invalidate()
        searchTimer = nil
        connectPeripheralTimer?.invalidate()
        connectPeripheralTimer = nil
        searchListDelegate?.clearData()
    }
    
    func startSearchDevices(autoConnectDeviceList: [String]) {
        self.autoConnectDeviceList = autoConnectDeviceList
        checkBluetoothPermission()
    }
    
    func startSearchLostDevice(lostDeviceMac: String) {
        self.lostDeviceMac = lostDeviceMac
        checkBluetoothPermission()
    }
    
    func connectDevice(peripheral: CBPeripheral) {
        disconnectDevice()
        selectedDevicePeripheral = peripheral
        stopSearchDevices()
        
        connectPeripheralTimer = Timer.scheduledTimer(withTimeInterval: DeviceSettings.Constants.connectionDeviceInterval, repeats: true) { [weak self] _ in
            self?.stopConnectDevice()
        }
        
        selectedDevicePeripheral?.delegate = self
        manager?.connect(selectedDevicePeripheral!, options: nil)
    }
    
    func disconnectDevice() {
        deviceManager?.activeDevice = nil
        lostDeviceMac = ""
        guard let selectedDevicePeripheral = selectedDevicePeripheral else { return }
        manager?.cancelPeripheralConnection(selectedDevicePeripheral)
        self.selectedDevicePeripheral = nil
        self.selectRSSI = 0
    }
    
    func extendSearchDevices() {
        searchTimer?.invalidate()
        searchTimer = nil
        startSearchTimer()
    }

//    func isPoweredOff() -> Bool {
//        guard let char = characteristic, let data = char.value else { return false }
//        let bytes = [UInt8](data)
//        let arrayHex = bytesToHex(array: bytes)
//        let arrayInt = arrayHex.map { UInt64($0, radix: 16) }.compactMap { $0 }
//        let powerFirst = Int(arrayInt[DeviceSettings.ValueIndexes.powerFirst])
//        let powerSecond = Int(arrayInt[DeviceSettings.ValueIndexes.powerSecond])
//
//        if powerFirst <= 1 && powerSecond <= 1 {
//            return true
//        }
//        return false
//    }
    
    func changerPower(settings: Settings, data: Int) {
        guard let peripheral = selectedDevicePeripheral, let char = characteristic else { return }
        switch settings {
        case .plusPower:
            printDataForDrop(DeviceSettings.CommandsForBT4.ChangePowerSecondChannel(data: data))
            printDataForDrop(DeviceSettings.CommandsForBT4.ChangePowerFirstChannel(data: data))
            peripheral.writeValue(DeviceSettings.CommandsForBT4.ChangePowerSecondChannel(data: data), for: char, type: .withResponse)
            peripheral.writeValue(DeviceSettings.CommandsForBT4.ChangePowerFirstChannel(data: data), for: char, type: .withResponse)
        case .minusPower:
            printDataForDrop(DeviceSettings.CommandsForBT4.ChangePowerSecondChannel(data: data))
            printDataForDrop(DeviceSettings.CommandsForBT4.ChangePowerFirstChannel(data: data))
            peripheral.writeValue(DeviceSettings.CommandsForBT4.ChangePowerSecondChannel(data: data), for: char, type: .withResponse)
            peripheral.writeValue(DeviceSettings.CommandsForBT4.ChangePowerFirstChannel(data: data), for: char, type: .withResponse)
        }
    }
    
    func changeIntensivity(data: Int) {
        guard let peripheral = selectedDevicePeripheral, let char = characteristic else { return }
        printDataForDrop(DeviceSettings.CommandsForBT4.changeIntensivity(intensivity: data))
        peripheral.writeValue(DeviceSettings.CommandsForBT4.changeIntensivity(intensivity: data), for: char,type: .withResponse)
    }
    
    func changeFrequency(data: Int) {
        guard let peripheral = selectedDevicePeripheral, let char = characteristic else { return }
        printDataForDrop(DeviceSettings.CommandsForBT4.changeFrequency(frequency: data))
        peripheral.writeValue(DeviceSettings.CommandsForBT4.changeFrequency(frequency: data), for: char,type: .withResponse)
    }
    
    func changeAmModulation(data: Int) {
        guard let peripheral = selectedDevicePeripheral, let char = characteristic else { return }
        printDataForDrop(DeviceSettings.CommandsForBT4.changeAmModulation(am: data))
        peripheral.writeValue(DeviceSettings.CommandsForBT4.changeAmModulation(am: data), for: char,type: .withResponse)
    }
    
    func changeFM() {
        guard let peripheral = selectedDevicePeripheral, let char = characteristic else { return }
        printDataForDrop(DeviceSettings.CommandsForBT4.changeFModulation())
        peripheral.writeValue(DeviceSettings.CommandsForBT4.changeFModulation(), for: char,type: .withResponse)
    }
    
    func solidModualtion() {
        guard let peripheral = selectedDevicePeripheral, let char = characteristic else { return }
        printDataForDrop(DeviceSettings.CommandsForBT4.solidModulation())
        peripheral.writeValue(DeviceSettings.CommandsForBT4.solidModulation(), for: char,type: .withResponse)
    }
    
    func powerToNil() {
        guard let peripheral = selectedDevicePeripheral, let char = characteristic else { return }
        printDataForDrop(DeviceSettings.CommandsForBT4.powerToStartFirstChannel())
        printDataForDrop(DeviceSettings.CommandsForBT4.powerToStartSecondChannel())
        peripheral.writeValue(DeviceSettings.CommandsForBT4.powerToStartFirstChannel(),
                              for: char,type: .withResponse)
        peripheral.writeValue(DeviceSettings.CommandsForBT4.powerToStartSecondChannel(),
                              for: char,type: .withResponse)
    }
    
    func saveSettings() {
        guard let peripheral = selectedDevicePeripheral, let char = characteristic else { return }
        printDataForDrop(DeviceSettings.CommandsForBT4.saveBT4Settings())
        peripheral.writeValue(DeviceSettings.CommandsForBT4.saveBT4Settings(), for: char, type: .withResponse)
    }
    
    func printDataForDrop(_ data: Data){
//        print("Per drop: ")
//        print(data as NSData)
    }
    
    private func checkBluetoothPermission() {
        
        if #available(iOS 13.0, *) {
            var btAuthorization: CBManagerAuthorization?
            
            if #available(iOS 13.1, *) {
                btAuthorization = CBCentralManager.authorization
            }
            if #available(iOS 13.0, *) {
                btAuthorization = CBCentralManager().authorization
            }
            
            if btAuthorization == nil {
                btAuthorization = .notDetermined
            }
            
            if btAuthorization == .allowedAlways {
                manager = CBCentralManager(delegate: self, queue: nil)
            } else if btAuthorization == .notDetermined {
                manager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
            } else {
                searchListDelegate?.showOpenBluetoothSettings()
            }
            
        } else {
            manager = CBCentralManager(delegate: self, queue: nil)
        }
    }
    
    private func startSearchTimer() {
        searchTimer = Timer.scheduledTimer(withTimeInterval: DeviceSettings.Constants.searchDeviceInterval, repeats: true) { [weak self] _ in
            self?.searchTimerAction?()
            self?.searchTimer?.invalidate()
            self?.searchTimer = nil
        }
    }
    
    private func stopConnectDevice() {
        if let selectedDevicePeripheral = selectedDevicePeripheral {
            manager?.cancelPeripheralConnection(selectedDevicePeripheral)
        }
        connectPeripheralTimer?.invalidate()
        connectPeripheralTimer = nil
        self.selectedDevicePeripheral = nil
        self.selectRSSI = 0
        self.autoConnectDeviceList = []
        self.lostDeviceMac = ""
        searchListDelegate?.openConnectionError(state: .connectionError)
    }
    
    private func bytesToHex(array: [UInt8]) -> [String] {
        var hexArray: [String] = []
        var count = array.count
        for byte in array
        {
            hexArray.append(String(format:"%02X", byte))
            count = count - 1
        }
        return hexArray
    }
}

extension BluetoothManager: CBCentralManagerDelegate {
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if !lostDeviceMac.isEmpty && lostDeviceMac == peripheral.identifier.uuidString {
            connectDevice(peripheral: peripheral)
        } else {
        
            if !autoConnectDeviceList.isEmpty, autoConnectDeviceList.contains(peripheral.identifier.uuidString) {
                connectDevice(peripheral: peripheral)
            } else {
                searchListDelegate?.appendDeviceToList(peripheral: peripheral)
            }
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state != .poweredOn {
            searchListDelegate?.returnBackViewController()
        } else {
            stopSearchDevices()
            manager?.scanForPeripherals(withServices: nil, options: nil)
            startSearchTimer()
        }
    }
}

extension BluetoothManager: CBPeripheralDelegate {
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectPeripheralTimer?.invalidate()
        connectPeripheralTimer = nil
        lostDeviceMac = ""
        selectedDevicePeripheral?.delegate = self
        selectedDevicePeripheral?.readRSSI()
        selectedDevicePeripheral?.discoverServices(nil)
        let deviceMac = peripheral.identifier.uuidString
        searchListDelegate?.openSuccessConnection(deviceMac: deviceMac)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        deviceManager?.activeDevice = nil
        selectedDevicePeripheral = nil
        selectRSSI = 0
        lostDeviceMac = ""
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        deviceManager?.activeDevice = nil
      stopConnectDevice()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        if let servicePeripheral = peripheral.services {
            for service in servicePeripheral {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {

        if let characteristList = service.characteristics {

            for characterist in characteristList {
                if characterist.properties.contains(.notify) {
                    self.characteristic = characterist
                    selectedDevicePeripheral?.setNotifyValue(true, for: characterist)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        selectRSSI = Int(truncating: RSSI)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        guard let data = characteristic.value else { return }
        let bytes = [UInt8](data)
        let arrayHex = bytesToHex(array: bytes)
//        print("From a drop: ")
//        print(arrayHex)
        let arrayInt = arrayHex.map { UInt64($0, radix: 16) }.compactMap { $0 }
//        print(arrayInt)
        let batteryValue = arrayInt[DeviceSettings.ValueIndexes.battery]
        var battery = 0
        if batteryValue >= 101 && batteryValue < 102 {
            battery = 10
        } else if batteryValue >= 103 && batteryValue < 107 {
            battery = 20
        } else if batteryValue >= 108 && batteryValue < 112 {
            battery = 40
        } else if batteryValue >= 113 && batteryValue < 119 {
            battery = 80
        } else if batteryValue >= 120 && batteryValue < 127 {
            battery = 100
        }
        
        let codeFirst = Int(arrayHex[DeviceSettings.ValueIndexes.codeFirst], radix: 16)!
        let codeSecond = Int(arrayHex[DeviceSettings.ValueIndexes.codeSecond], radix: 16)! * Int("FF", radix: 16)!
        let btCode = codeFirst + codeSecond
        let code = "\(btCode)"
        
        let firmwareNumber = Int(arrayInt[DeviceSettings.ValueIndexes.firmwareNumber])
        let powerFirst = Int(arrayInt[DeviceSettings.ValueIndexes.powerFirst])
        let powerSecond = Int(arrayInt[DeviceSettings.ValueIndexes.powerSecond])
        let type = DevicesData.shared.fetchDeviceTypeTitle(btCode: btCode)
        let program = Int(arrayInt[DeviceSettings.ValueIndexes.programNumber])

        guard let mac = selectedDevicePeripheral?.identifier.uuidString else { return }
        let deviceStatus = DeviceStatus(code: code, firmwareNumber: firmwareNumber, rssi: selectRSSI, type: type, powerFirst: powerFirst, powerSecond: powerSecond, program: program)
        let device = Device(name: nil, information: nil, mac: mac, battery: battery, image: nil, status: deviceStatus)
        deviceManager?.updateActiveDevice(device: device)
    }
}
