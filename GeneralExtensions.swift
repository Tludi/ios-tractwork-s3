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
        let min = Int(total.1)
        
        let totalTimeText = "\(hr):\(min)"
        print("\(totalTimeText) hours calculated")
        return totalTimeText
    }
}
