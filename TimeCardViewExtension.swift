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
    
    //*** Steps
    //*** 1. pullTimePunchTimes() -> all TimePunch.punchTimes into pulledTimes:[Date?]
    //*** 2. convertDateToHourAndMin() -> pulledTimes:[Date?] into convertedTimes:[Double]
    //*** 3. sortArrayInPairs() -> convertedTimes:[Double] into partitionedTimes:[[Double]]
    //*** 4. get the difference for partitionedTimes:[[Double]] and add to totalTime:Double
    
    func calculateTotalTime(timePunches: List<TimePunch>, workday: Workday) {
        // Start Counter for total time for the day
//        var totalTime = 0.00
        // 1. put the dayDate (Date?) for each day and put in array
        let pulledTimes:[Date?] = pullTimePunchTimes(timePunches: timePunches) // [Date?]
        // 2. Convert NSDate? array to Double (hr.min) array
        let convertedTimes:[Double] = convertDateToHourAndMin(timesToConvert: pulledTimes) // [Double]
        // 3. partition Double array into pairs
        let partitionedTimes:[[Double]] = sortArrayInPairs(arrayToSort: convertedTimes) // [[Double]]
        // get difference in each in/out punches and add to total
        let totalTime = roundTimes(arrayToSort: partitionedTimes, toNearest: 0.01)
        print("\(totalTime) - Total time - calculateTotalTime()")
        let realm = try! Realm()
        try! realm.write() {
            workday.totalHoursWorked = totalTime
        }
    }
    
    func pullTimePunchTimes(timePunches: List<TimePunch>) -> [Date?] {
        let timePunches = timePunches
        var pulledTimes = [Date?]()
        for time in timePunches {
            pulledTimes.append(time.punchTime)
        }
        return pulledTimes // as Date? Array
    }
    
    func convertDateToHourAndMin(timesToConvert: [Date?]) -> [Double] {
        var hoursMinutesArray = [Double]()
        let timesToConvert = timesToConvert
        for time in timesToConvert {
            let hour = Double(NSCalendar.current.component(.hour, from: time! as Date))
            let minute = Double(NSCalendar.current.component(.minute, from: time! as Date))/60
//            minute = round(minute / 0.01) * 0.01
//            print("\(minute) minutes formatted - convertDateToHourAndMin()")
            let hoursMinutes = hour + minute
//            print("\(hoursMinutes) - hours + minuts time - convertDateToHourAndMin()")
            hoursMinutesArray.append(hoursMinutes)
            print("\(hoursMinutesArray) - hours/minuts array - convertDateToHourAndMin()")
        }
        return hoursMinutesArray
    }
    
    
    func sortArrayInPairs(arrayToSort: [Double]) -> [[Double]] {
        var arrayToSort = arrayToSort
        let now = NSDate()
        let hour = Double(NSCalendar.current.component(.hour, from: now as Date))
        let minute = Double(NSCalendar.current.component(.minute, from: now as Date))/60
        let currentTime = hour + minute    // Need to change to current time
        //    let fillerPunch = Double(now.hour() + (now.minute()*0.001))
        print("\(currentTime) now - from sortArrayInPairs()")
        
        if arrayToSort.isOdd() {
            arrayToSort.append(currentTime)
        }
        
        let partitionedArray:[[Double]] = arrayToSort.partitionArray(subSet: 2)
        print("partitioned array \(partitionedArray)")
        return partitionedArray
    }
    
    func roundTimes(arrayToSort: [[Double]], toNearest: Double) -> Double {
        var totalTime = 0.00
        for time in arrayToSort {
            let difference = time[1] - time[0]
            totalTime += difference
            print("totalTime \(totalTime)")
        }
        return round(totalTime / toNearest) * toNearest
    }
    
    func createNewTimePunch(workday: Workday) {
        let newTimePunch = TimePunch()
        let todaysTimePunches = todaysWorkday.timePunches
        let realm = try! Realm()
        
        try! realm.write {
            newTimePunch.id = NSUUID().uuidString
            newTimePunch.punchTime = Date()
            newTimePunch.status = currentStatus
            
            todaysTimePunches.append(newTimePunch)
            
        }
    }
    
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
