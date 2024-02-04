//
//  Float + Extension.swift
//  OrtezApp
//
//  Created by Александр Александрович on 18.08.2022.
//

import Foundation

extension Float {
    var value: Int {
        switch self {
        case 51: return 15
        case 102: return 30
        case 153: return 60
        case 204: return 90
        case 255: return 120
        case 306: return 180
        case 350: return 350
        default:
            break
        }
        return 0
    }
    
    var stepToSlider: Float {
        switch self {
        case 0: return 0
        case 1: return 63
        case 2: return 123
        case 3: return 183
        case 4: return 243
        case 5: return 304
        case 6: return 350
        default:
            return 350
        }
    }
    
    var stepToFrequency: Int {
        switch self {
        case 0: return 15
        case 1: return 30
        case 2: return 60
        case 3: return 90
        case 4: return 120
        case 5: return 180
        case 6: return 350
        default:
            return 350
        }
    }
    
    var frequencyToStep: Float {
        switch self {
        case 15: return 0
        case 30: return 1
        case 60: return 2
        case 90: return 3
        case 120: return 4
        case 180: return 5
        case 350: return 6
        default:
            return 6
        }
    }
    
    var durationSteps: Float {
        switch self {
        case 1: return 1
        case 2: return 1.8
        case 3: return 2.9
        case 4: return 3.95
        case 5: return 5.05
        case 6: return 6.1
        case 7: return 7.2
        case 8: return 8
        default:
            return 0
        }
    }
    
    var durationFromStep: Int {
        switch self {
        case 1: return 1
        case 2: return 3
        case 3: return 5
        case 4: return 10
        case 5: return 15
        case 6: return 20
        case 7: return 25
        case 8: return 30
        default:
            return 0
        }
    }
    
    var stepsFromDuration: Float {
        switch self {
        case 1:  return 1
        case 3:  return 1.8
        case 5:  return 2.9
        case 10: return 3.95
        case 15: return 5.05
        case 20: return 6.1
        case 25: return 7.2
        case 30: return 8
        default:
            return 0
        }
    }
}
