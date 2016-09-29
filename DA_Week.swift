//
//  DA_Week.swift
//  tractwork
//
//  Created by manatee on 9/28/16.
//  Copyright © 2016 diligentagility. All rights reserved.
//

import Foundation
import RealmSwift


func getDaysOfCurrentWeek() -> [Date] {
    let startOfTheWeek = Date().dateAtStartOfWeek()
    var daysOfTheWeek = [Date]()
    for i in 0...6 {
        daysOfTheWeek.append(startOfTheWeek.dateByAddingDays(i))
    }
    return daysOfTheWeek
}

func getWorkdaysForCurrentWeekday(thisWeeksDays:[Date]) -> [Date] {
    let realm = try! Realm()
    var workdays = [Date]()
    var thisWeeksDBWorkday = [Date]()
    let dbWorkdays = realm.objects(Workday.self)
    
    for day in thisWeeksDays {
        workdays.append(day)
    }
    for db in dbWorkdays {
        thisWeeksDBWorkday.append(db.dayDate)
    }
    
    let result = arrayOfCommonElements(array1: workdays, array2: thisWeeksDBWorkday)
    
    print("\(thisWeeksDBWorkday.count) - actual workdays")
    print("\(workdays.count) - days of this week")
    print("\(result.count) - shared workdays with this week")
    return workdays
}

func getDataForWeekdayOfWeek(workday: Workday, weekdays: [Date]) -> Date {
    var today = Date()
    for day in weekdays {
        if day == workday.dayDate {
            today = day
        } else {
            print("no days")
        }
    }
    return today
}

func arrayOfCommonElements (array1: [Date], array2: [Date]) -> [Date]  {
    var returnArray = [Date]()
    for item1 in array1 {
        for item2 in array2 {
            if item1.day() == item2.day() {
                returnArray.append(item1)
            }
        }
    }
    return returnArray
}
