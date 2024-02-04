import Foundation

class UserSettings {
    
    private enum Keys {
        static let isContraindicationsShown = "isContraindicationsShown"
        static let isPlayerModeActive = "isPlayerModeActive"
    }
    
    static let shared = UserSettings()
    
    private init() {}
    
    var isContraindicationsShown: Bool {
        UserDefaults.standard.bool(forKey: Keys.isContraindicationsShown)
    }
    
    func setContraindicationsShown() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: Keys.isContraindicationsShown)
        userDefaults.synchronize()
    }
    
    var isPlayerModeActive: Bool {
        UserDefaults.standard.bool(forKey: Keys.isPlayerModeActive)
    }
    
    func setPlayerModeActive(value: Bool) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: Keys.isPlayerModeActive)
        userDefaults.synchronize()
    }
    
    
}
