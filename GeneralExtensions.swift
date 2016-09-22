//
//  GeneralExtensions.swift
//  tractwork
//
//  Created by manatee on 9/19/16.
//  Copyright © 2016 diligentagility. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
//    mutating func roundToPlaces(places:Int) -> Double {
//        let divisor = pow(10.0, Double(places))
//        return round(self * divisor) / divisor
//    }
    
    func getHourAndMinuteOutput(total: Double) -> String {
        // split total time into whole and decimal to convert to minutes
        let total = modf(total)
        let hr = Int(total.0)
//        let min = Int(total.1.roundToPlaces(places: 2)*60)
        let min = Int(total.1)*60
        
        let totalTimeText = "\(hr):\(min)"
        print("\(totalTimeText) hours calculated")
        return totalTimeText
    }
}

extension Array {
    // partition array by subSet amount
    func partitionArray<T>(subSet:Int) -> [[T]] {
        var pair = [T]()
        var timePunchPairs = [[T]]()
        
        for punch in self {
            if pair.count >= subSet {
                timePunchPairs.append(pair)
                pair.removeAll()
            }
            if pair.count < subSet {
                pair.append(punch as! T)
            }
        }
        timePunchPairs.append(pair)
        return timePunchPairs
    }
    
    // check if Array has even count
    func isEven() -> Bool {
        return self.count % 2 == 0
    }
    
    // check if Array has odd count
    func isOdd() -> Bool {
        return self.count % 2 != 0
    }
    
}
