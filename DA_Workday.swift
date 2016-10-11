//
//  DA_Workday.swift
//  tractwork
//
//  Created by manatee on 9/19/16.
//  Copyright © 2016 diligentagility. All rights reserved.
//

import Foundation
import RealmSwift

extension Workday {
    
    func setCurrentWorkDay(workweek: WorkWeek, workdate: Date) -> Workday {
        var workday = Workday()
        let workdays = workweek.workdays
        for day in workdays {
            if day.dayDate.weekday() == workdate.weekday() {
                workday = day
            }
        }
        print("from setCurrentWorkday()")
        return workday
    }
    
    
    
    func getWorkdayStatus(workday: Workday) -> Bool {
        let status = workday.currentStatus
        return status
    }
    

}

