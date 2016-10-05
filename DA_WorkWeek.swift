//
//  DA_Week.swift
//  tractwork
//
//  Created by manatee on 9/28/16.
//  Copyright © 2016 diligentagility. All rights reserved.
//

import Foundation
import RealmSwift

class currentWorkweek {
    var day = Date()
    var workday = Workday()
    let dayNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var weekDates = [Date]()
    
}

extension WorkWeek {
    
    func setCurrentWorkWeek(workweeks: Results<WorkWeek>, workdate: Date) -> WorkWeek {
        var workweek = WorkWeek()
        let workWeekNumber = workdate.week() // number of the week of the year
        let lastRecordedWeek = workweeks.last
        
        
        //*** check if current work week exists
        //*** NEED TO CHECK AGAINST CURRENT YEAR - WorkWeek.weekYear
        //*** NOT JUST THE WEEK NUMBER
        if lastRecordedWeek?.weekNumber == workWeekNumber {
            workweek = lastRecordedWeek!
            print("workweek exists")
        } else {
            print("no work week")
            workweek = createWorkWeek(workdate: workdate)
            createWorkdaysForWorkWeek(workweek: workweek)
            print("created workdays for new workweek")
        }
//        print("workweek function")
        return workweek
    }
}

func createWorkWeek(workdate: Date) -> WorkWeek{
    let realm = try! Realm()

    let workweek = WorkWeek()
    try! realm.write {
        workweek.id = NSUUID().uuidString
        workweek.weekNumber = workdate.week()
        workweek.weekYear = workdate.year()
        workweek.startOfWeek = workdate.dateAtStartOfWeek()
        realm.add(workweek)
        print(workweek)
    }
    print("made it to createWorkWeek")
    return workweek
}

func createWorkdaysForWorkWeek(workweek: WorkWeek) {
    let realm = try! Realm()
    //*** create a workday for each day of the week
    for i in 0...6 {
        let workday = Workday()
        try! realm.write {
            workday.id = NSUUID().uuidString
            workday.dayDate = workweek.startOfWeek.dateByAddingDays(i)
            workweek.workdays.append(workday)
        }
    }
    print("\(workweek.workdays.count) workdays - createWorkWeek()")
}


//func getDatesOfCurrentWeek(date: Date) -> [Date] {
//    let startOfTheWeek = Date().dateAtStartOfWeek()
//    var datesOfTheWeek = [Date]()
//    for i in 0...6 {
//        datesOfTheWeek.append(startOfTheWeek.dateByAddingDays(i))
//    }
//    return datesOfTheWeek
//}
//
//func getWorkdaysForCurrentWeekday(thisWeeksDays:[Date]) -> [Date] {
//    let realm = try! Realm()
//    var workdays = [Date]()
//    var thisWeeksDBWorkday = [Date]()
//    let dbWorkdays = realm.objects(Workday.self)
//    
//    for day in thisWeeksDays {
//        workdays.append(day)
//    }
//    for db in dbWorkdays {
//        thisWeeksDBWorkday.append(db.dayDate)
//    }
//    
//    let result = arrayOfCommonElements(array1: workdays, array2: thisWeeksDBWorkday)
//    
//    print("\(thisWeeksDBWorkday.count) - actual workdays")
//    print("\(workdays.count) - days of this week")
//    print("\(result.count) - shared workdays with this week")
//    return workdays
//}
//
//func getDataForWeekdayOfWeek(workday: Workday, weekdays: [Date]) -> Date {
//    var today = Date()
//    for day in weekdays {
//        if day == workday.dayDate {
//            today = day
//        } else {
//            print("no days")
//        }
//    }
//    return today
//}
//
//func arrayOfCommonElements (array1: [Date], array2: [Date]) -> [Date]  {
//    var returnArray = [Date]()
//    for item1 in array1 {
//        for item2 in array2 {
//            if item1.day() == item2.day() {
//                returnArray.append(item1)
//            }
//        }
//    }
//    return returnArray
//}
