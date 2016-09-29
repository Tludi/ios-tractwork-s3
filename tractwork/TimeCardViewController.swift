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
    
    
    // DA objects
    //***********
    var workdayCount = 0
    let todaysWorkDate = Date()
    var todaysWorkday = Workday()
    var currentStatus = Bool()
    
    
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
        let realm = try! Realm()
        let workdays = try! Realm().objects(Workday.self)
        try! realm.write {
            realm.delete(workdays)
        }
        weekTable.reloadData()
    }
    
    @IBAction func clearTimePunches(_ sender: UIBarButtonItem) {
        let realm = try! Realm()
        let timePunches = todaysWorkday.timePunches
        try! realm.write {
            realm.delete(timePunches)
            todaysWorkday.totalHoursWorked = "0:00"
        }
        timePunchTable.reloadData()
    }
    

    //**** Buttons
    //************
    @IBOutlet weak var silverTimeButtonRing: UIImageView!
    @IBOutlet weak var timePunchButtonOutlet: UIButton!
    @IBAction func timePunchButton(_ sender: UIButton) {
        activateToday()
        currentStatus = !currentStatus

        
        createNewTimePunch(workday: todaysWorkday)
        setCurrentStatus(status: currentStatus)
//        let todaysTimePunches = todaysWorkday.timePunches

        
        timePunchTable.reloadData()
        //    counter += 1
        //    totalTimeLabel.text = "\(counter):00"
        calculateTotalTime(workday: todaysWorkday)
        totalTimeLabel.text = "\(todaysWorkday.totalHoursWorked)"
//        currentStatusLabel.text = "\(currentStatus)"
        
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
        let workday = DA_Workday()
        todaysWorkday = workday.retrieveTodaysWorkday()
        let todaysDate = todaysWorkday.dayDate.toString(.custom("MMMM dd, yyyy"))
        
        //**** get current in/out status
        currentStatus = todaysWorkday.currentStatus
        
        switch currentStatus {
        case true:
            currentStatusLabel.text = "status is punched in."
        case false:
            currentStatusLabel.text = "status is punched out."
        }

        //**** Set labels
        dateLabel.text = todaysDate
        totalTimeLabel.text = "\(todaysWorkday.totalHoursWorked)"
        
        
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
        let thisWeeksDays = getDaysOfCurrentWeek()
        
//        let weekDays = try! Realm().objects(Workday.self) // need to limit for this week
        
        if tableView == timePunchTable {
            let todaysTimePunches = todaysWorkday.timePunches
            return todaysTimePunches.count
        } else if tableView == weekTable {
            return thisWeeksDays.count
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todaysTimePunches = todaysWorkday.timePunches.sorted(byProperty: "punchTime", ascending: false)
//        let weekDays = try! Realm().objects(Workday.self) // need to limit for this week
        let thisWeeksDays = getDaysOfCurrentWeek()
        
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
            //        cell.timePunchLabel.text = "Hello"
            
            return cell
            
            
            //*** Week Tab  ***//
        } else if tableView == weekTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "weekHoursCell") as! WeekHoursTableViewCell
            //        print ("pressed week")
            //        print(weekDays.count)
//            let workday = weekDays[indexPath.row]
            getWorkdaysForCurrentWeekday(thisWeeksDays: thisWeeksDays)
            cell.weekHoursLabel.text = String(thisWeeksDays[indexPath.row].day())
//            cell.totalHoursLabel.text = "\(workday.totalHoursWorked)"
            cell.dayNameLabel.text = thisWeeksDays[indexPath.row].weekdayToString()
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "notUsed")
            return cell!
        }
    }

    



}

