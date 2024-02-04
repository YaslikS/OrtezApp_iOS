import Foundation

class UserDefault {
    
    static let shared = UserDefault()
    
    enum SettingKeys : String {
        case program
    }
    let defaults = UserDefaults.standard
    let programKey = SettingKeys.program.rawValue
    var programs : [ProgramListItem] {
        get {
            if let data = defaults.value(forKey: programKey) as? Data {
                return try! PropertyListDecoder().decode([ProgramListItem].self, from: data)
            }
            else {
                return [ProgramListItem]()
            }
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.set(data,forKey: programKey)
            }
        }
    }
    
    func saveElectrode(electrode: Int){
        UserDefaults.standard.set(electrode, forKey: "electrode")
    }
    
    func getElectrode() -> Int{
        return UserDefaults.standard.integer(forKey: "electrode")
    }
    
    func saveElectrodeName(electrodeName: String){
        UserDefaults.standard.set(electrodeName, forKey: "electrodeName")
    }
    
    func getElectrodeName() -> String{
        return UserDefaults.standard.string(forKey: "electrodeName") ?? ""
    }
    
    func saveProgramm(program: ProgramListItem)  {
        programs.append(program)
    }
    
    func updateProgramm(oldProgram: ProgramListItem, newProgram: ProgramListItem)  {
        if let oldIndex = programs.firstIndex(of: oldProgram) {
            programs[oldIndex] = newProgram
        }
    }
    
    func removeProgramm(program: ProgramListItem) {
        programs.removeAll(where: {$0 == program})
    }
}
