import Foundation
import UIKit

extension Array {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Array where Element == CGFloat {
    var min: CGFloat? {
        guard self.count >= 1 else {
            return nil
        }
        var min = self[0]
        self.forEach{
            if $0 < min {
                min = $0
            }
        }
        return min
    }
    
    var max: CGFloat? {
        guard self.count >= 1 else {
            return nil
        }
        var max = self[0]
        self.forEach{
            if $0 > max {
                max = $0
            }
        }
        return max
    }
    
    var average: CGFloat? {
        guard self.count >= 1 else {
            return nil
        }
        guard let max = self.max, let min = self.min else {
            return nil
        }
        return (max + min)/2
    }
}

extension Array where Element == StageListItem {
    func sum(index: Int) -> Double {
        var sum: Double = 0
        for index in 0...index{
            if index != self.count - 1 {
                sum += self[index].duration.msToSeconds
            }
        }
        return sum
    }
}
