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
        fourWeekNavBox.backgroundColor = darkGreyNavColor
        fourWeekButtonLabel.setTitleColor(lightGreyNavColor, for: .normal)
        timePunchStack.isHidden = false
        weekTable.isHidden = true
        timePunchTable.reloadData()
    }
    
    func pullTimePunchTimes(timePunches: List<TimePunch>) -> [Date?] {
        let timePunches = timePunches
        var pulledTimes = [Date?]()
        for time in timePunches {
            pulledTimes.append(time.punchTime)
        }
        return pulledTimes // as NSDate Array
    }
    
    func convertNSDateToHourAndMin(timesToConvert: [NSDate?]) -> [Double] {
        var hoursMinutesArray = [Double]()
        let timesToConvert = timesToConvert
        for time in timesToConvert {
            let hour = Double(NSCalendar.current.component(.hour, from: time! as Date))
            let minute = Double(NSCalendar.current.component(.minute, from: time! as Date))/60
            let hoursMinutes = hour + minute
            hoursMinutesArray.append(hoursMinutes)
        }
        return hoursMinutesArray
    }
    
    
    func sortArraybyTwos(array0: [Double]) -> [[Double]] {
        var myArray = array0
        let now = NSDate()
        let hour = Double(NSCalendar.current.component(.hour, from: now as Date))
        let minute = Double(NSCalendar.current.component(.minute, from: now as Date))/60
        let currentTime = hour + minute    // Need to change to current time
        //    let fillerPunch = Double(now.hour() + (now.minute()*0.001))
        print("\(currentTime) now")
        if myArray.count % 2 != 0 {
            myArray.append(currentTime)
        }
        let partitionedArray = myArray.partitionBy(2)
        print("partitioned array \(partitionedArray)")
        return partitionedArray
    }
    
    func calculateTotalTime(timePunches: List<TimePunch>, workday: Workday) {
        // Start Counter for total time for the day
        var totalCounter = 0.00
        // put the dayDate (NSDate?) for each day and put in array
        let pulledTimes = pullTimePunchTimes(timePunches: timePunches) // [NSDate?]
        // Convert NSDate? array to Double (hr.min) array
        let convertedTimes = convertNSDateToHourAndMin(pulledTimes) // [Double]
        // partition Double array into pairs
        let partitionedTimes = sortArraybyTwos(convertedTimes) // [[Double]]
        // get difference in each in/out punches and add to total
        for bit in partitionedTimes {
            let difference = bit[1] - bit[0]
            totalCounter += difference
            print("totalcounter \(totalCounter)")
        }
        
        let realm = try! Realm()
        try! realm.write() {
            workday.totalHoursWorked = totalCounter
        }
        
        totalTimeLabel.text = totalCounter.getHourAndMinuteOutput(totalCounter)
    }
}
