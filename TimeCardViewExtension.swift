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
//        weekButtonLabel.setTitleColor(lightGreyNavColor, for: .normal)
        weekButtonLabel.setTitleColor(lightBlueNavColor, for: .normal)
        fourWeekNavBox.backgroundColor = darkGreyNavColor2
        fourWeekButtonLabel.setTitleColor(lightBlueNavColor, for: .normal)
        
        //*** set initial colors and status for tables
        //********************************************
        timePunchStack.backgroundColor = tableColor2
        timePunchTable.backgroundColor = tableColor2
        totalTimeView.backgroundColor = tableColor2
        
        weekTable.backgroundColor = tableColor2
        weekTable.isHidden = true
        
        fourWeekTable.backgroundColor = tableColor2
        fourWeekTable.isHidden = true
        workdayHeaderView.isHidden = false
        weekHeaderView.isHidden = true
        allWeeksHeaderView.isHidden = true
        
    }
    
    func activateToday() {
        //**** change colors of tables and tabs
        //**** and showing/hiding tables
        //**** when selecting the today tab or
        //**** selecting the clock in/out button
        //**************************************
        todayNavBox.backgroundColor = lightGreyNavColor2
        todayButtonLabel.setTitleColor(darkGreyNavColor, for: .normal)
        todayButtonLabel.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12.0)
        weekNavBox.backgroundColor = darkGreyNavColor2
        weekButtonLabel.setTitleColor(lightBlueNavColor, for: .normal)
        fourWeekNavBox.backgroundColor = darkGreyNavColor2
        fourWeekButtonLabel.setTitleColor(lightBlueNavColor, for: .normal)
        timePunchStack.isHidden = false
        weekTable.isHidden = true
        fourWeekTable.isHidden = true
        workdayHeaderView.isHidden = false
        weekHeaderView.isHidden = true
        allWeeksHeaderView.isHidden = true
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
        // Get all workweeks then drop the first test workweek
        let workweeks = realm.objects(WorkWeek.self).dropFirst()
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
//        print(pulledTimes)

        // 2. partition Double array into pairs
        let partitionedTimes:[[Date]] = sortArrayInPairs(arrayToSort: pulledTimes) // [[Double]]
        // 3. get difference in each in/out punches and add to total
        let totalTime = addTimeDifferenceFromPairs(partitionedTimes: partitionedTimes, workday: workday)
        
        // 4. update Workday.totalTime
        let workweek = getWorkweek(todaysDate: workday.dayDate.dateAtStartOfWeek())
        
        let realm = try! Realm()
        try! realm.write() {
            workday.totalHoursWorked = totalTime
            workweek.totalWeekMinutes = calculateTotalWeekTime(workweek: workweek)
        }
    }
    
    //**** Get PunchTimes for workday
    func pullTimePunchTimes(timePunches: List<TimePunch>) -> [Date] {
        let timePunches = timePunches
        var pulledTimes = [Date]()
        for time in timePunches {
            pulledTimes.append(time.punchTime)
        }
//        print("\(pulledTimes) - pullTimePunchTimes Double Array")
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
//        print("partitioned array \(partitionedArray)")
        return partitionedArray
    }
    
    //**** get difference of partitioned pairs and output totalTime in String()
    func addTimeDifferenceFromPairs(partitionedTimes:[[Date]], workday: Workday) -> String {
        var totalTime = String()
        var runningTime = Int()
//        let workweek = getWorkweek(todaysDate: workday.dayDate)
//        var workweekTime = workweek.totalWeekMinutes
        
        for pair in partitionedTimes {
            //*** get difference in pair in total minutes
            runningTime += pair[0].minutesBeforeDate(pair[1])
//            workweekTime += runningTime
        }
        
        //*** update current workdays total time in minutes
        let realm = try! Realm()
        try! realm.write {
            workday.totalWorkdayMinutes = runningTime
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
    
    func calculateTotalWeekTime(workweek: WorkWeek) -> Int {
        let workdays = workweek.workdays
        var totalWeekMinutes = Int()
        for day in workdays {
            let dayMinutes = day.totalWorkdayMinutes
            totalWeekMinutes += dayMinutes
        }
        print("total minutes for week - \(totalWeekMinutes)")
        return totalWeekMinutes
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
    
    // sort timepunches in pairs for each cell
    func returnTimePunchPairsForTable(workday: Workday) -> [[TimePunch]] {
        let pulledTimePunches = workday.timePunches
        //        let sortedTimePunches:[[List<TimePunch>]] = pulledTimePunches.partitionArray(subSet: 2)
        
        func partitionPunches(punches: List<TimePunch>, subSet:Int) -> [[TimePunch]] {
            var pair = [TimePunch]()
            var timePunchPairs = [[TimePunch]]()
            
            for punch in punches {
                if pair.count >= subSet {
                    timePunchPairs.append(pair)
                    pair.removeAll()
                }
                if pair.count < subSet {
                    pair.append(punch)
                }
            }
            timePunchPairs.append(pair)
            return timePunchPairs
        }
        let pairedTimePunches = partitionPunches(punches: pulledTimePunches, subSet: 2)
        
        return pairedTimePunches.reversed()
    }
    
    func returnPairTimeDifference(timeIn: TimePunch, timeOut: TimePunch) -> String {
        var timeDifference = String()
        let runningTime = timeIn.punchTime.minutesBeforeDate(timeOut.punchTime)

        timeDifference = convertHoursAndMinutesToString(minutes: runningTime)
        return timeDifference
    }
    
    //*** convert mintutes to hours and mintutes
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
    
    
    func returnWeekHoursAndMinutes(week: WorkWeek) -> String {
        let weekTime: String = convertHoursAndMinutesToString(minutes: week.totalWeekMinutes)
        return weekTime
    }
}
