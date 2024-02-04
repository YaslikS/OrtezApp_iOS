import Foundation

class DeviceSettings {
    
    enum Constants {
        static let deviceNamePrefix = "BG"
        static let devicesPlaceholderImageName = "device1"
        static let searchDeviceInterval: Double = 60
        static let connectionDeviceInterval: Double = 30
        static let delaySetDeviceNameAfterSuccessConnect: Double = 2
        static let defaultDeviceBtCode = 99
    }
    
    enum ValueIndexes {
        static let codeFirst = 1
        static let codeSecond = 2
        static let battery = 3
        static let firmwareNumber = 4
        static let powerFirst = 5
        static let powerSecond = 6
        static let programNumber = 13
    }
    
    enum HeaderType: UInt8 {
        case powerFirst = 0x91
        case powerSecond = 0x92
        //аварийной сброс мощности байт 1
        case resetPowerToOne = 0xBE
        case resetAllSettingsAfterСommunicationBreak = 0xBB
        // Режимы амплитудной модуляции, 00 Режим неприрывной модуляции,
        case amplitudeGenerationMode = 0xA1
        // Значение частот, 07 Режим частотной модуляции
        case frequencyMode = 0xA2
        // Значение интенсивности
        case IntensivityMode = 0xA3
        case durationBetweenImpulse = 0xBA
        case freqencyLower = 0xBD
        case currentProgramNumber = 0xBF
    }
    
    enum HeaderCaption: UInt8 {
        var rawValue: UInt8 {
            switch self {
            case .frequency30Ghz,.modulation3to1, .Intensivity2:
                return 0x01
            case .resetPower, .afterResetDontChangeSettings, .frequency15Ghz, .continuousMode, .Intensivity1:
                return 0x00
            case .resetPowerToOneCaption:
                return 0x55
            case .resetAllSettingsAfterСommunicationBreakCaption:
                return 0x5B
            case .frequency60Ghz, .modulation5to1, .Intensivity3:
                return 0x02
            case .frequency90Ghz, .modulation1to1, .Intensivity4:
                return 0x03
            case .frequency120Ghz:
                return 0x04
            case .frequency180Ghz:
                return 0x05
            case .frequency350Ghz:
                return 0x06
            case .frequency_modulation:
                return 0x07
            }
        }
        
        case resetPower
        //  Аварийный сброс мощности байт 2
        case resetPowerToOneCaption
        //  После обрыва связи сбросить настройки
        case resetAllSettingsAfterСommunicationBreakCaption
        //  После обрыва связи не менять настройки
        case afterResetDontChangeSettings
        // частоты
        case frequency15Ghz
        case frequency30Ghz
        case frequency60Ghz
        case frequency90Ghz
        case frequency120Ghz
        case frequency180Ghz
        case frequency350Ghz
        case frequency_modulation
        //модуляции
        case continuousMode
        case modulation3to1
        case modulation5to1
        case modulation1to1
        // интенсивность
        case Intensivity1
        case Intensivity2
        case Intensivity3
        case Intensivity4
        
     //   case amplitudeGenerationMode = 0xA2 //6. Значение частот, 7. Режим частотной модуляции 8. Значение интенсивности
    }
    
    enum ColliderType: UInt8 {
        case Hero = 0b1
        case GoblinOrBoss = 0b10
        case Projectile = 0b100
        case Wall = 0b1000
        case Cave = 0b10000
    }
    
    enum CommandsForBT4 {
        //изменение мощности посылаемое на бт4 первый канал
        static func ChangePowerFirstChannel(data: Int) -> Data {
            let data = UInt8(data)
            return Data([HeaderType.powerFirst.rawValue,data])
        }
        //изменение мощности посылаемое на бт4 второй канал
        static func ChangePowerSecondChannel(data: Int) -> Data {
            let data = UInt8(data)
            return Data([HeaderType.powerSecond.rawValue,data])
        }
        //обнуление показателей мощности по 1 каналу
        static func powerToStartFirstChannel() -> Data {
            return Data([HeaderType.powerFirst.rawValue,HeaderCaption.resetPower.rawValue])
        }
        //обнуление показателя мощности по 2 каналу
        static func powerToStartSecondChannel() -> Data {
            return Data([HeaderType.powerSecond.rawValue,HeaderCaption.resetPower.rawValue])
        }
        //сохранение всех настроек после разрыва связи
        static func saveBT4Settings() -> Data {
            return Data([HeaderType.resetAllSettingsAfterСommunicationBreak.rawValue,HeaderCaption.afterResetDontChangeSettings.rawValue])
        }
        //изменение частоты
        static func changeFrequency(frequency: Int) -> Data {
            switch frequency {
            case 15:
                return Data([HeaderType.frequencyMode.rawValue,HeaderCaption.frequency15Ghz.rawValue])
            case 30:
                return Data([HeaderType.frequencyMode.rawValue,HeaderCaption.frequency30Ghz.rawValue])
            case 60:
                return Data([HeaderType.frequencyMode.rawValue,HeaderCaption.frequency60Ghz.rawValue])
            case 90:
                return Data([HeaderType.frequencyMode.rawValue,HeaderCaption.frequency90Ghz.rawValue])
            case 120:
                return Data([HeaderType.frequencyMode.rawValue,HeaderCaption.frequency120Ghz.rawValue])
            case 180:
                return Data([HeaderType.frequencyMode.rawValue,HeaderCaption.frequency180Ghz.rawValue])
            case 350:
                return Data([HeaderType.frequencyMode.rawValue,HeaderCaption.frequency350Ghz.rawValue])
            default:
                return Data()
            }
        }
        //переключение модуляции на FM
        static func changeFModulation() -> Data {
            return Data([HeaderType.frequencyMode.rawValue,HeaderCaption.frequency_modulation.rawValue])
        }
        //переключение модуляции на AM
        static func changeAmModulation(am: Int) -> Data {
            switch am {
            case 1:
                return Data([HeaderType.amplitudeGenerationMode.rawValue,HeaderCaption.modulation3to1.rawValue])
            case 2:
                return Data([HeaderType.amplitudeGenerationMode.rawValue,HeaderCaption.modulation5to1.rawValue])
            case 0, 3:
                return Data([HeaderType.amplitudeGenerationMode.rawValue,HeaderCaption.modulation1to1.rawValue])
            default:
                return Data()
            }
        }
        //неприрывная модуляция
        static func solidModulation() -> Data {
            return Data([HeaderType.amplitudeGenerationMode.rawValue,HeaderCaption.continuousMode.rawValue])
        }
        //изменение чувствительности
        static func changeIntensivity(intensivity: Int) -> Data {
            switch intensivity {
            case 1:
                return Data([HeaderType.IntensivityMode.rawValue,HeaderCaption.Intensivity1.rawValue])
            case 2:
                return Data([HeaderType.IntensivityMode.rawValue,HeaderCaption.Intensivity2.rawValue])
            case 3:
                return Data([HeaderType.IntensivityMode.rawValue,HeaderCaption.Intensivity3.rawValue])
            case 4:
                return Data([HeaderType.IntensivityMode.rawValue,HeaderCaption.Intensivity4.rawValue])
            default:
                return Data()
            }
        }
    }
    
    static let shared = DeviceSettings()
}
