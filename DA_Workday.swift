//
//  DA_Workday.swift
//  tractwork
//
//  Created by manatee on 9/19/16.
//  Copyright © 2016 diligentagility. All rights reserved.
//

import Foundation
import RealmSwift

class DA_Workday {
    let realm = try! Realm()
    let date = DA_Date()
    
    var id = "1"
    var dayDate: Date? = nil
    var project = "General Work"
    var totalHoursWorked = 8
    var worker = "Milo"
    
    let allWorkdays = try! Realm().objects(Workday.self)
    
    func retrieveTodaysWorkday() -> Workday {
        var workday = Workday()
        if thereAreAnyWorkdays() {
            workday = checkForTodaysWorkday()
        } else {
            workday = createTodaysWorkday()
        }
        return workday
    }
    
    func thereAreAnyWorkdays() -> Bool {
        if allWorkdays.count == 0 {
            print("no workdays (thereAreAnyWorkdays())")
            return false
        } else {
            print("workdays exist (thereAreAnyWorkdays())")
            return true
        }
    }
    
    func checkForTodaysWorkday() -> Workday{
        let todaysWorkday = DA_Workday()
        var workday = Workday()
        
        for i in 0 ..< allWorkdays.count {
            workday = allWorkdays[i]
            if workday.dayDate!.isToday() {
                print("Workday from DB - \(workday.id)")
                todaysWorkday.id = workday.id
                print("Workday copy to use - \(todaysWorkday.id)")
                todaysWorkday.dayDate = workday.dayDate
                
            } else {
                print("creating workday (checkForTodaysWorkday())")
                todaysWorkday.createTodaysWorkday()
            }
        }
        
        print("workday exists (checkForTodaysWorkday())")
        return workday
    }
    
    
    
    func createTodaysWorkday() -> Workday {
        let newWorkday = Workday()
        //    let todaysWorkday = DA_Workday()
        newWorkday.id = NSUUID().uuidString
        newWorkday.dayDate = Date()
        
        try! realm.write() {
            self.realm.add(newWorkday)
        }
        print("created workday (createTodaysWorkday()")
        //    print("\(allWorkdays.count) workdays" )
        //    todaysWorkday.id = newWorkday.id
        //    print("new Todays workday id \(todaysWorkday.id)")
        //    
        //    todaysWorkday.dayDate = newWorkday.dayDate
        return newWorkday
        
    }
}
