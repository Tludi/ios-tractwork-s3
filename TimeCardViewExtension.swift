//
//  TimeCardViewExtension.swift
//  tractwork
//
//  Created by manatee on 9/19/16.
//  Copyright © 2016 diligentagility. All rights reserved.
//

import Foundation
import RealmSwift

extension TimeCardViewController {
    
    func setBaseColors() {
        //*** set initial colors for nav tabs
        //***********************************
        todayNavBox.backgroundColor = lightGreyNavColor2
        todayButtonLabel.setTitleColor(darkGreyNavColor, for: .normal)
        weekNavBox.backgroundColor = darkGreyNavColor2
        weekButtonLabel.setTitleColor(lightGreyNavColor, for: .normal)
        fourWeekNavBox.backgroundColor = darkGreyNavColor2
        fourWeekButtonLabel.setTitleColor(lightGreyNavColor, for: .normal)
        
        //*** set initial colors and status for tables
        //********************************************
        timePunchStack.backgroundColor = tableColor2
        timePunchTable.backgroundColor = tableColor2
        totalTimeView.backgroundColor = tableColor2
        
        weekTable.backgroundColor = tableColor2
        weekTable.isHidden = true
        
        fourWeekTable.backgroundColor = tableColor2
        fourWeekTable.isHidden = true
        
    }
    
    func activateToday() {
        //**** change colors of tables and tabs
        //**** and showing/hiding tables
        //**** when selecting the today tab or
        //**** selecting the clock in/out button
        //**************************************
        todayNavBox.backgroundColor = lightGreyNavColor2
        todayButtonLabel.setTitleColor(darkGreyNavColor, for: .normal)
        weekNavBox.backgroundColor = darkGreyNavColor2
        weekButtonLabel.setTitleColor(lightGreyNavColor, for: .normal)
        fourWeekNavBox.backgroundColor = darkGreyNavColor2
        fourWeekButtonLabel.setTitleColor(lightGreyNavColor, for: .normal)
        timePunchStack.isHidden = false
        weekTable.isHidden = true
        fourWeekTable.isHidden = true
        timePunchTable.reloadData()
    }
    
    //*** Get current WorkWeek
    func getWorkweek(todaysDate: Date) -> WorkWeek {
        let realm = try! Realm()
        let workweeks = realm.objects(WorkWeek.self)
        let todaysDate = Date()
        var workweek = WorkWeek()
        workweek = workweek.setCurrentWorkWeek(workweeks: workweeks, workdate: todaysDate)
        return workweek
    }
    
    //*** Get current Workday
    func getWorkday(workweek: WorkWeek, todaysDate: Date) -> Workday {
        var workday = Workday()
        workday = workday.setCurrentWorkDay(workweek: workweek, workdate: todaysDate)
        return workday
    }
    
    //*** Get last four workweeks
    func getLastFourWorkweeks() -> [WorkWeek] {
        let realm = try! Realm()
        let workweeks = realm.objects(WorkWeek.self)
        var lastFourWeeks = [WorkWeek]()
        if workweeks.count >= 4 {
            for i in 0..<4 {
                let week = workweeks[i]
                lastFourWeeks.append(week)
            }
        } else {
            for week in workweeks {
                lastFourWeeks.append(week)
            }
        }
        
        return lastFourWeeks
    }
    
    
    
    //*** Creates a new timePunch
    func createNewTimePunch(workday: Workday, newStatus: Bool ) {
        let newTimePunch = TimePunch()
        let todaysTimePunches = workday.timePunches
        let realm = try! Realm()
        
        try! realm.write {
            newTimePunch.id = NSUUID().uuidString
            newTimePunch.punchTime = Date()
            print("\(newTimePunch.punchTime) - createNewPunch")
            newTimePunch.status = newStatus
            
            todaysTimePunches.append(newTimePunch)
            
        }
    }
    
    func setWorkdayStatus(workday: Workday, newStatus: Bool ){
        let realm = try! Realm()
        try! realm.write {
            workday.currentStatus = newStatus
        }
    }
    
    
    //*** Steps
    //*** 1. pullTimePunchTimes() -> Workday.TimePunch.punchTimes into pulledTimes:[Date]
    //*** 2. sortArrayInPairs() -> convertedTimes:[Double] into partitionedTimes:[[Date]]
    //*** 3. get the difference for partitionedTimes:[[Double]] and add to runningTime:Int then output to totalTime:String
    //*** 4. update Workday.totalTime:String
    
    func calculateTotalTime(workday: Workday) {
        // 1. get the dayDate:(Date) for each punchtime for workday and put in array
        let pulledTimes:[Date] = pullTimePunchTimes(timePunches: workday.timePunches) // [Double]
        print(pulledTimes)

        // 2. partition Double array into pairs
        let partitionedTimes:[[Date]] = sortArrayInPairs(arrayToSort: pulledTimes) // [[Double]]
        // 3. get difference in each in/out punches and add to total
        let totalTime = addTimeDifferenceFromPairs(partitionedTimes: partitionedTimes, workday: workday)
        
        // 4. update Workday.totalTime
        let realm = try! Realm()
        try! realm.write() {
            workday.totalHoursWorked = totalTime
        }
    }
    
    //**** Get PunchTimes for workday
    func pullTimePunchTimes(timePunches: List<TimePunch>) -> [Date] {
        let timePunches = timePunches
        var pulledTimes = [Date]()
        for time in timePunches {
            pulledTimes.append(time.punchTime)
        }
        print("\(pulledTimes) - pullTimePunchTimes Double Array")
        return pulledTimes // as Double Array
    }
    
    //**** returns an array of timepunch pairs inside parent array
    func sortArrayInPairs(arrayToSort: [Date]) -> [[Date]] {
        var arrayToSort = arrayToSort
        let now = Date()
        
        if arrayToSort.isOdd() {
            arrayToSort.append(now)
        }
        
        let partitionedArray:[[Date]] = arrayToSort.partitionArray(subSet: 2)
        print("partitioned array \(partitionedArray)")
        return partitionedArray
    }
    
    //**** get difference of partitioned pairs and output totalTime in String()
    func addTimeDifferenceFromPairs(partitionedTimes:[[Date]], workday: Workday) -> String {
        var totalTime = String()
        var runningTime = Int()
        let workweek = getWorkweek(todaysDate: workday.dayDate)
        var workweekTime = workweek.totalWeekMinutes
        
        for pair in partitionedTimes {
            //*** get difference in pair in total minutes
            runningTime += pair[0].minutesBeforeDate(pair[1])
            workweekTime += runningTime
        }
        
        //*** update current weeks total times
        let realm = try! Realm()
        try! realm.write {
            workweek.totalWeekMinutes = workweekTime
        }
        
        //*** convert total minutes:Int into (hours:Int ,minutes:Int)
        func minutesToHoursMinutes (minutes: Int) -> (Int, Int) {
            return (minutes / 60, minutes % 60)
        }
        
        //*** output (hours:Int, minutes:Int) to String
        func convertHoursAndMinutesToString (minutes: Int) -> String{
            let (h, m) = minutesToHoursMinutes(minutes: minutes)
            var result = String()
            if m < 10 {
                result = "\(h):0\(m)"
            } else {
                result = "\(h):\(m)"
            }
            return result
        }
        totalTime = convertHoursAndMinutesToString(minutes: runningTime)
        return totalTime
    }
    
    func calculateTotalWeekTime() {
        let workweek = getWorkweek(todaysDate: todaysDate)
        let workdays = workweek.workdays
        var totalWeekHours = Double()
        for day in workdays {
            let dayHours = Double(day.totalHoursWorked)
            totalWeekHours += dayHours!  // only works if string format is 0.0
        }
    }

    
    
    //**** set images and status of IN/OUT for timepunch
    func setCurrentStatusImages(status: Bool) {
        switch status {
        case true:
            currentStatusLabel.text = "status is punched in."
            print("status is punched in.")
            timePunchButtonOutlet.setImage(#imageLiteral(resourceName: "outbutton"), for: [])
        case false:
            currentStatusLabel.text = "status is punched out."
            print("status is punched out.")
            timePunchButtonOutlet.setImage(#imageLiteral(resourceName: "inbutton"), for: [])
        }
    }
    
}
