//
//  ViewController.swift
//  tractwork
//
//  Created by manatee on 9/18/16.
//  Copyright © 2016 diligentagility. All rights reserved.
//

import UIKit
import RealmSwift

class TimeCardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let realm = try! Realm()
    var currentStatus = Bool()
    let todaysDate = Date()
    
    // DA objects
    //***********
//    var workdayCount = 0
//    let todaysWorkDate = Date()
//    var todaysWorkday = Workday()
//    var currentWorkWeek = WorkWeek()
    
    
    // App colors
    //***********
    let darkGreyNavColor = UIColor(red: 6.0/255.0, green: 60.0/255.0, blue: 54.0/255.0, alpha: 0.95)
    let darkGreyNavColor2 = UIColor(red: 38.0/255.0, green: 50.0/255.0, blue: 56.0/255.0, alpha: 0.95)
    let lightGreyNavColor = UIColor(red: 136.0/255.0, green: 166.0/255.0, blue: 173.0/255.0, alpha: 0.95)
    let lightGreyNavColor2 = UIColor(red:144.0/255.0, green: 164.0/255.0, blue: 174.0/255.0, alpha: 0.95)
    let tableColorlt = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 0.8)
    let tableColor = UIColor(red: 38.0/255.0, green: 50.0/255.0, blue: 56.0/255.0, alpha: 0.8)
    
    //**** Labels
    //***********
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var currentStatusLabel: UILabel!
    
    
    //**** Tab Bar Buttons
    //********************
    @IBAction func clearWorkDays(_ sender: UIBarButtonItem) {
//        let realm = try! Realm()
//        let workdays = try! Realm().objects(Workday.self)
//        try! realm.write {
//            realm.delete(workdays)
//        }
//        weekTable.reloadData()
    }
    
    @IBAction func clearTimePunches(_ sender: UIBarButtonItem) {
//        let realm = try! Realm()
//        let timePunches = todaysWorkday.timePunches
//        try! realm.write {
//            realm.delete(timePunches)
//            todaysWorkday.totalHoursWorked = "0:00"
//        }
//        timePunchTable.reloadData()
    }
    

    //**** Buttons
    //************
    @IBOutlet weak var silverTimeButtonRing: UIImageView!
    @IBOutlet weak var timePunchButtonOutlet: UIButton!
    @IBAction func timePunchButton(_ sender: UIButton) {
        activateToday()
        try! realm.write {
            realm.deleteAll()
        }
        print("cleared database of all objects")
//        currentStatus = !currentStatus
//
//        
//        createNewTimePunch(workday: todaysWorkday)
//        setCurrentStatus(status: currentStatus)
////        let todaysTimePunches = todaysWorkday.timePunches
//
//        
//        timePunchTable.reloadData()
//        //    counter += 1
//        //    totalTimeLabel.text = "\(counter):00"
//        calculateTotalTime(workday: todaysWorkday)
//        totalTimeLabel.text = "\(todaysWorkday.totalHoursWorked)"
////        currentStatusLabel.text = "\(currentStatus)"
        
    }
    
    
    
    //**** Tables
    //***********
    @IBOutlet weak var timePunchStack: UIStackView!
    @IBOutlet weak var timePunchTable: UITableView!
    @IBOutlet weak var totalTimeView: UIView!
 
    @IBOutlet weak var weekTable: UITableView!
    
    
    //**** Tables Nav Bar
    //*******************
    
    //**** Today Nav Tab
    @IBOutlet weak var todayNavBox: UIView!
    @IBOutlet weak var todayButtonLabel: UIButton!
    @IBAction func todayButton(_ sender: UIButton) {
        activateToday()
    }
    
    //**** Week Nav Tab
    @IBOutlet weak var weekNavBox: UIView!
    @IBOutlet weak var weekButtonLabel: UIButton!
    @IBAction func weekButton(_ sender: UIButton) {
        todayNavBox.backgroundColor = darkGreyNavColor2
        todayButtonLabel.setTitleColor(lightGreyNavColor2, for: .normal)
        weekNavBox.backgroundColor = lightGreyNavColor2
        weekButtonLabel.setTitleColor(darkGreyNavColor2, for: .normal)
        fourWeekNavBox.backgroundColor = darkGreyNavColor2
        fourWeekButtonLabel.setTitleColor(lightGreyNavColor2, for: .normal)
        timePunchStack.isHidden = true
        weekTable.isHidden = false
        weekTable.reloadData()
    }
    
    //**** 4 Week Nav Tab
    @IBOutlet weak var fourWeekNavBox: UIView!
    @IBOutlet weak var fourWeekButtonLabel: UIButton!
    @IBAction func fourWeekButton(_ sender: UIButton) {
        todayNavBox.backgroundColor = darkGreyNavColor
        todayButtonLabel.setTitleColor(lightGreyNavColor, for: .normal)
        weekNavBox.backgroundColor = darkGreyNavColor
        weekButtonLabel.setTitleColor(lightGreyNavColor, for: .normal)
        fourWeekNavBox.backgroundColor = lightGreyNavColor
        fourWeekButtonLabel.setTitleColor(darkGreyNavColor, for: .normal)
    }
    
    
    
    
    //**** Start UIView processing
    //****************************
    //****************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //**** process current workday and timepunches
        //********************************************
        let realm = try! Realm()
        let workweeks = realm.objects(WorkWeek.self)
        print("\(workweeks.count) workweeks in database")
        
        
        //*** get or create current workweek with workdays
        //************************************************
        let workweek = getWorkweek(todaysDate: todaysDate)
        
        var workday = Workday()
        workday = workday.setCurrentWorkDay(workweek: workweek, workdate: Date())
        let weekday = workday.dayDate.weekday() - 1 // - 1 for getting from array
        print(workweek.dayNames[weekday])
        print(workday.dayDate.toString(.custom("EEEE")))
        
        
//        print(currentWorkWeek.weekYear)
        //        todaysWorkday = realm.objects(Workday.self).last!
//        todaysWorkday = workday.retrieveTodaysWorkday()
//        let todaysDate = Date()
        
//        let todaysDate = todaysWorkday.dayDate.toString(.custom("MMMM dd, yyyy"))
 
        //**** get current in/out status
//        currentStatus = todaysWorkday.currentStatus
        
        
        switch currentStatus {
        case true:
            currentStatusLabel.text = "status is punched in."
        case false:
            currentStatusLabel.text = "status is punched out."
        }

        //**** Set labels
        dateLabel.text = "\(Date())"
//        totalTimeLabel.text = "\(todaysWorkday.totalHoursWorked)"
        
        
        setBaseColors() // set base colors of tables and navbar tabs
        
        //**** Set Navbar background to clear
        //***********************************
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        //**** Register custom cell nibs
        //******************************
        timePunchTable.register(UINib(nibName: "TimePunchTableViewCell", bundle: nil), forCellReuseIdentifier: "timePunchCell")
        weekTable.register(UINib(nibName: "WeekHoursTableViewCell", bundle: nil), forCellReuseIdentifier: "weekHoursCell")
        
        
        
    }
    

    
    //**** TableView processing
    //*************************
    //*************************
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let workweek = getWorkweek(todaysDate: todaysDate)
        let workday = getWorkday(workweek: workweek, todaysDate: todaysDate)
        
        if tableView == timePunchTable {
            return workday.timePunches.count
        } else if tableView == weekTable {
            return 7
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let todaysTimePunches = todaysWorkday.timePunches.sorted(byProperty: "punchTime", ascending: false)
        let workweeks = try! Realm().objects(WorkWeek.self)
//        let weekDays = try! Realm().objects(Workday.self) // need to limit for this week
//        let thisWeeksDays = getDatesOfCurrentWeek(date: todaysWorkDate)
        let currentWorkWeek = WorkWeek()
        if tableView == timePunchTable {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "timePunchCell") as! TimePunchTableViewCell
            
//            let timePunch = todaysTimePunches[indexPath.row]
//            
//            if timePunch.status {
//                cell.statusLabel.text = "IN"
//                cell.statusColorImage.image = UIImage(named: "smGreenCircle")
//            } else {
//                cell.statusLabel.text = "OUT"
//                cell.statusColorImage.image = UIImage(named: "smRedCircle")
//            }
            //        timePunchLabel.text = timePunch.punchTime
//            cell.timePunchLabel.text = timePunch.punchTime.toString(.custom("hh:mm a"))
            cell.timePunchLabel.text = "placeholder"
            //        cell.timePunchLabel.text = "Hello"
            
            return cell
            
            
            //*** Week Tab  ***//
        } else if tableView == weekTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "weekHoursCell") as! WeekHoursTableViewCell
            var workweek = WorkWeek()
            workweek = workweek.setCurrentWorkWeek(workweeks: workweeks, workdate: Date())
            //        print ("pressed week")
            //        print(weekDays.count)
//            let workday = weekDays[indexPath.row]
//            getWorkdaysForCurrentWeekday(thisWeeksDays: thisWeeksDays)
            cell.weekHoursLabel.text = ("\(workweek.workdays[indexPath.row].dayDate.day())")
//            cell.weekHoursLabel.text = "placeholder"
//            cell.totalHoursLabel.text = "\(workday.totalHoursWorked)"
            cell.dayNameLabel.text = currentWorkWeek.dayNames[indexPath.row]
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "notUsed")
            return cell!
        }
    }

    



}

