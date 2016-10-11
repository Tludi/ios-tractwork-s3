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
    let darkGreyNavColor2 = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.7)
    let darkGreyNavColor3 = UIColor(red: 38.0/255.0, green: 50.0/255.0, blue: 56.0/255.0, alpha: 0.95)
    let lightGreyNavColor = UIColor(red: 136.0/255.0, green: 166.0/255.0, blue: 173.0/255.0, alpha: 0.95)
    let lightGreyNavColor2 = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.9)
    let lightGreyNavColor3 = UIColor(red:144.0/255.0, green: 164.0/255.0, blue: 174.0/255.0, alpha: 0.95)
    let tableColorlt = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 0.8)
    let tableColor = UIColor(red: 38.0/255.0, green: 50.0/255.0, blue: 56.0/255.0, alpha: 0.8)
    let tableColor2 = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.5)
    
    //**** Labels
    //***********
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var currentStatusLabel: UILabel!
    
    //*** Views
    //*********
    @IBOutlet weak var tablesContainerView: UIView!
    
    
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
    @IBOutlet weak var deleteTodaysTimePunches: UIButton!
    @IBAction func deleteTodaysTimePunches(_ sender: UIButton) {
        let workweek = getWorkweek(todaysDate: todaysDate)
        let workday = getWorkday(workweek: workweek, todaysDate: todaysDate)
        let todaysTimePunches = workday.timePunches
        let realm = try! Realm()
        try! realm.write {
            realm.delete(todaysTimePunches)
            workday.totalHoursWorked = "0:00"
            workday.currentStatus = false
        }
        timePunchTable.reloadData()
    }
    
    @IBOutlet weak var silverTimeButtonRing: UIImageView!
    @IBOutlet weak var timePunchButtonOutlet: UIButton!
    
    @IBAction func timePunchButton(_ sender: UIButton) {
        activateToday()
        let workweek = getWorkweek(todaysDate: todaysDate)
        let workday = getWorkday(workweek: workweek, todaysDate: todaysDate)

        currentStatus = workday.currentStatus
        let newStatus = !currentStatus
        
        createNewTimePunch(workday: workday, newStatus: newStatus)
        //*** set current workday status to new status
        setWorkdayStatus(workday: workday, newStatus: newStatus)
        setCurrentStatusImages(status: newStatus)
        
        timePunchTable.reloadData()
 
        calculateTotalTime(workday: workday)
        totalTimeLabel.text = "\(workday.totalHoursWorked)"
        
    }
    
    
    
    //**** Tables
    //***********
    @IBOutlet weak var timePunchStack: UIStackView!
    @IBOutlet weak var timePunchTable: UITableView!
    @IBOutlet weak var totalTimeView: UIView!
    @IBOutlet weak var weekTable: UITableView!
    @IBOutlet weak var fourWeekTable: UITableView!
    
    
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
        todayButtonLabel.setTitleColor(lightGreyNavColor, for: .normal)
        weekNavBox.backgroundColor = lightGreyNavColor2
        weekButtonLabel.setTitleColor(darkGreyNavColor, for: .normal)
        fourWeekNavBox.backgroundColor = darkGreyNavColor2
        fourWeekButtonLabel.setTitleColor(lightGreyNavColor, for: .normal)
        timePunchStack.isHidden = true
        weekTable.isHidden = false
        fourWeekTable.isHidden = true
        weekTable.reloadData()
    }
    
    //**** 4 Week Nav Tab
    @IBOutlet weak var fourWeekNavBox: UIView!
    @IBOutlet weak var fourWeekButtonLabel: UIButton!
    @IBAction func fourWeekButton(_ sender: UIButton) {
        todayNavBox.backgroundColor = darkGreyNavColor2
        todayButtonLabel.setTitleColor(lightGreyNavColor, for: .normal)
        weekNavBox.backgroundColor = darkGreyNavColor2
        weekButtonLabel.setTitleColor(lightGreyNavColor, for: .normal)
        fourWeekNavBox.backgroundColor = lightGreyNavColor2
        fourWeekButtonLabel.setTitleColor(darkGreyNavColor, for: .normal)
        timePunchStack.isHidden = true
        weekTable.isHidden = true
        fourWeekTable.isHidden = false
        fourWeekTable.reloadData()
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
        
//        var workday = Workday()
        let workday = getWorkday(workweek: workweek, todaysDate: todaysDate)
        
//        let weekday = workday.dayDate.weekday() - 1 // - 1 for getting from array
//        print(workweek.dayNames[weekday])
//        print(workday.dayDate.toString(.custom("EEEE")))
        
 
        //**** get current in/out status
        currentStatus = workday.currentStatus
        switch currentStatus {
        case true:
            currentStatusLabel.text = "status is punched in."
        case false:
            currentStatusLabel.text = "status is punched out."
        }

        //**** Set labels
        dateLabel.text = todaysDate.toString(.custom("MMMM dd, yyyy"))
        totalTimeLabel.text = "\(workday.totalHoursWorked)"
        
        setBaseColors() // set base colors of tables and navbar tabs
        
        
        //*** Style container view holding tables and tabs
        tablesContainerView.layer.cornerRadius = 20
        tablesContainerView.layer.masksToBounds = true
        
        //**** Set Navbar background to clear
        //***********************************
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        //**** Register custom cell nibs
        //******************************
        timePunchTable.register(UINib(nibName: "TimePunchTableViewCell", bundle: nil), forCellReuseIdentifier: "timePunchCell")
        weekTable.register(UINib(nibName: "WeekHoursTableViewCell", bundle: nil), forCellReuseIdentifier: "weekHoursCell")
        fourWeekTable.register(UINib(nibName: "FourWeekTableViewCell", bundle: nil), forCellReuseIdentifier: "fourWeekCell")
        weekTable.register(UINib(nibName: "weekHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "WeekHeader")
        
        
    }
    

    
    //**** TableView processing
    //*************************
    //*************************
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "test"
//    }
//    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let workweek = getWorkweek(todaysDate: todaysDate)
        let workday = getWorkday(workweek: workweek, todaysDate: todaysDate)
        
        if tableView == timePunchTable {
            return workday.timePunches.count
        } else if tableView == weekTable {
            return 7
        } else {
//            return 4
            return getLastFourWorkweeks().count
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = weekTable.dequeueReusableHeaderFooterView(withIdentifier: "WeekHeader")
//        header.titleLabel.text = "hello"
//        
//        return header
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let workweek = getWorkweek(todaysDate: todaysDate)
        let workday = getWorkday(workweek: workweek, todaysDate: todaysDate)
        let todaysTimePunches = workday.timePunches.sorted(byProperty: "punchTime", ascending: false)
        let lastFourWeeks = getLastFourWorkweeks()
        

        let currentWorkWeek = WorkWeek()
        if tableView == timePunchTable {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "timePunchCell") as! TimePunchTableViewCell
            
            let timePunch = todaysTimePunches[indexPath.row]

            if timePunch.status {
                cell.statusLabel.text = "IN"
                cell.statusColorImage.image = UIImage(named: "smGreenCircle")
            } else {
                cell.statusLabel.text = "OUT"
                cell.statusColorImage.image = UIImage(named: "smRedCircle")
            }
            //        timePunchLabel.text = timePunch.punchTime
            cell.timePunchLabel.text = timePunch.punchTime.toString(.custom("hh:mm a"))
//            cell.timePunchLabel.text = "placeholder"
            //        cell.timePunchLabel.text = "Hello"
            
            return cell
            
            
            //*** Week Tab  ***//
        } else if tableView == weekTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "weekHoursCell") as! WeekHoursTableViewCell

            //        print ("pressed week")
            //        print(weekDays.count)
//            let workday = weekDays[indexPath.row]
//            getWorkdaysForCurrentWeekday(thisWeeksDays: thisWeeksDays)

            cell.weekHoursLabel.text = ("\(workweek.workdays[indexPath.row].dayDate.day())")
//            cell.weekHoursLabel.text = "placeholder"
            cell.totalHoursLabel.text = "\(workweek.workdays[indexPath.row].totalHoursWorked)"
            cell.dayNameLabel.text = currentWorkWeek.dayNames[indexPath.row]
            return cell
            
            //*** Four Week Tab ***//
        } else if tableView == fourWeekTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "fourWeekCell") as! FourWeekTableViewCell
            
            cell.startDateLabel.text = "\(lastFourWeeks[indexPath.row].startOfWeek.toString(.custom("MM/dd/yyyy")))"
            cell.endDateLabel.text = "\(lastFourWeeks[indexPath.row].endOfWeek.toString(.custom("MM/dd/yyyy")))"
            cell.totalHoursLabel.text = "\(lastFourWeeks[indexPath.row].totalWeekMinutes)"
//            cell.testLabel.text = "test text"
            print(getLastFourWorkweeks().count)
            return cell
            
            //*** Default base ***//
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "notUsed")
            return cell!
        }
    }

//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//    }
//    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        // Delete timePunch functions
//        if tableView == timePunchTable {
//            let workweek = getWorkweek(todaysDate: todaysDate)
//            let workday = getWorkday(workweek: workweek, todaysDate: todaysDate)
//            
//            let deleteTimePunchAction = UITableViewRowAction(style: .normal, title: "Delete") { (action:UITableViewRowAction, indexPath:IndexPath) -> Void in
//            
//
//                print("delete action")
//                let deleteAlert = UIAlertController(title: "Confirm Delete", message: "Selected TimePunch Will be DELETED!", preferredStyle: .alert)
//
//                deleteAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction) in
//                    try! self.realm.write {
//                        let selectedTimePunch = workday.timePunches[indexPath.row]
//                        self.realm.delete(selectedTimePunch)
//                    }
//                    tableView.deleteRows(at: [indexPath], with: .fade)
//                }))
//                deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction) in
//                    return
//                }))
//                self.present(deleteAlert, animated: true, completion: nil)
//        
//            }
//            return [deleteTimePunchAction]
//        }
//    }


}

