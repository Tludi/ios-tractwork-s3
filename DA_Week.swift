//
//  DA_Week.swift
//  tractwork
//
//  Created by manatee on 9/28/16.
//  Copyright © 2016 diligentagility. All rights reserved.
//

import Foundation


func getDaysOfCurrentWeek() -> [Date] {
    let startOfTheWeek = Date().dateAtStartOfWeek()
    var daysOfTheWeek = [Date]()
    for i in 0...6 {
        daysOfTheWeek.append(startOfTheWeek.dateByAddingDays(i))
    }
    return daysOfTheWeek
}
