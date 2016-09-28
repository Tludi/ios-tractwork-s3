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
        todayButtonLabel.setTitleColor(darkGreyNavColor2, for: .normal)
        weekNavBox.backgroundColor = darkGreyNavColor2
        weekButtonLabel.setTitleColor(lightGreyNavColor2, for: .normal)
        fourWeekNavBox.backgroundColor = darkGreyNavColor2
        fourWeekButtonLabel.setTitleColor(lightGreyNavColor2, for: .normal)
        
        //*** set initial colors and status for tables
        //********************************************
        timePunchStack.backgroundColor = tableColor
        timePunchTable.backgroundColor = tableColor
        totalTimeView.backgroundColor = tableColor
        
        weekTable.backgroundColor = tableColor
        weekTable.isHidden = true
        
    }
    
    func activateToday() {
        //**** change colors of tables and tabs
        //**** and showing/hiding tables
        //**** when selecting the today tab or
        //**** selecting the clock in/out button
        //**************************************
        todayNavBox.backgroundColor = lightGreyNavColor2
        todayButtonLabel.setTitleColor(darkGreyNavColor2, for: .normal)
        weekNavBox.backgroundColor = darkGreyNavColor2
        weekButtonLabel.setTitleColor(lightGreyNavColor2, for: .normal)
        fourWeekNavBox.backgroundColor = darkGreyNavColor2
        fourWeekButtonLabel.setTitleColor(lightGreyNavColor2, for: .normal)
        timePunchStack.isHidden = false
        weekTable.isHidden = true
        timePunchTable.reloadData()
    }
    
    
    
    func createNewTimePunch(workday: Workday) {
        let newTimePunch = TimePunch()
        let todaysTimePunches = todaysWorkday.timePunches
        let realm = try! Realm()
        
        try! realm.write {
            newTimePunch.id = NSUUID().uuidString
            newTimePunch.punchTime = Date()
            print("\(newTimePunch.punchTime) - createNewPunch")
            newTimePunch.status = currentStatus
            
            todaysTimePunches.append(newTimePunch)
            
        }
    }
    
    
    //*** Steps
    //*** 1. pullTimePunchTimes() -> all TimePunch.punchTimes into pulledTimes:[Date?]
    //*** 2. convertDateToHourAndMin() -> pulledTimes:[Date?] into convertedTimes:[Double]
    //*** 3. sortArrayInPairs() -> convertedTimes:[Double] into partitionedTimes:[[Double]]
    //*** 4. get the difference for partitionedTimes:[[Double]] and add to totalTime:Double
    
    func calculateTotalTime(workday: Workday) {
        // Start Counter for total time for the day
//        var totalTime = 0.00
        // 1. put the dayDate (Date?) for each day and put in array
        let pulledTimes:[Date] = pullTimePunchTimes(timePunches: workday.timePunches) // [Double]
        print(pulledTimes)
        
        // 2. Convert NSDate? array to Double (hr.min) array
//        let convertedTimes:[Double] = convertDateToHourAndMin(timesToConvert: pulledTimes) // [Double]
        // 3. partition Double array into pairs
        let partitionedTimes:[[Date]] = sortArrayInPairs(arrayToSort: pulledTimes) // [[Double]]
        // get difference in each in/out punches and add to total
        let totalTime = addTimeDifferenceFromPairs(partitionedTimes: partitionedTimes)
//        let totalTime = roundTimes(arrayToSort: partitionedTimes, toNearest: 0.01)
//        print("\(totalTime) - Total time - calculateTotalTime()")
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
    
    //**** returns an array of pairs inside parent array
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
    
    func addTimeDifferenceFromPairs(partitionedTimes:[[Date]]) -> String {
        var totalTime = String()
        var runningTime = Int()
        for pair in partitionedTimes {
            runningTime += pair[0].minutesBeforeDate(pair[1])
        }
        
        func minutesToHoursMinutes (minutes: Int) -> (Int, Int) {
            return (minutes / 60, minutes % 60)
        }
        
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
    
    
//    func roundTimes(arrayToSort: [[Date]], toNearest: Double) -> String {
//        var totalTime = String()
//        
//        for time in arrayToSort {
//            let difference = time[1] - time[0]
//            let roundedDifference = round(difference)
//            totalTime += roundedDifference
//            print("totalTime \(totalTime)")
//        }
//        return totalTime
//    }

    
    func setCurrentStatus(status: Bool) {
        switch status {
        case true:
            currentStatusLabel.text = "status is punched in."
            print("status is punched in.")
            timePunchButtonOutlet.setImage(#imageLiteral(resourceName: "OutRedButton"), for: [])
        case false:
            currentStatusLabel.text = "status is punched out."
            print("status is punched out.")
            timePunchButtonOutlet.setImage(#imageLiteral(resourceName: "InGreenButton"), for: [])
        }
    }
    
}
