//
//  StatHelper.swift
//  OrtezApp
//
//  Created by Maxim Vekovenko on 09.06.2022.
//

import UIKit
import YandexMobileMetrica

enum EventsName: String {
    case sessionStart     = "session_start"
    case deviceActivated  = "device_activated"
    case deviceDeleted    = "device_deleted"
    case runCustomProgram = "run_custom_program" // Количество запусков программ пользователя
    case run_free_go      = "run_free_go"        // Количество запусков свободного режима
}

enum ParamsName: String {
    case macAddress = "mac_address"
    case amMode     = "АМ_mode"
    case fmMode     = "FМ_mode"
    case freq       = "freq"
    case amModeVal  = "Am_type"
    case intensity  = "Intensity"
    case time       = "Time"
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

class StatHelper {
    
    static func startAppEvents() {
        sendEventName(EventsName.sessionStart, params: nil)
    }
    
    static func deviceActivated(macAddress: String) {
        sendEventName(EventsName.deviceActivated, params: [ParamsName.macAddress.rawValue: macAddress])
    }
    
    static func deviceDeleted(macAddress: String) {
        sendEventName(EventsName.deviceDeleted, params: [ParamsName.macAddress.rawValue: macAddress])
    }
    
    static func runDeviceProgram(_ eventName: String) {
        sendEventName(eventName, params: nil)
    }
    
    static func runCustomOrFreeProgram(_ eventName: EventsName, amMode: Bool, fmMode: Bool,
                                       freq: Int, amModeVal: Int, intensity: Int, time: Int) {
        guard eventName == .run_free_go || eventName == .runCustomProgram else {
            print("StatHelper:runCustomOrFreeProgram: Not free/custom program received!")
            return
        }
        let params: [String : Any] = [
            ParamsName.amMode.rawValue:     amMode,
            ParamsName.fmMode.rawValue:     fmMode,
            ParamsName.freq.rawValue:       freq,
            ParamsName.amModeVal.rawValue:  amModeVal.amMode,
            ParamsName.intensity.rawValue:  intensity - 1,
            ParamsName.time.rawValue:       time
        ]
        sendEventName(eventName, params: params)
    }
    
    static private func sendEventName(_ name: EventsName, params: [String:Any]?) {
        sendEventName(name.rawValue, params: params)
    }
    
    static private func sendEventName(_ name: String, params: [String:Any]?) {
        YMMYandexMetrica.reportEvent(name, parameters: params, onFailure: { (error) in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
