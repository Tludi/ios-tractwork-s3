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
    let date = Date()
    var currentStatus: Bool = false
    
    // DA objects
    //***********
    var workdayCount = 0
    let todaysWorkDate = Date()
    var todaysWorkday = Workday()
    
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
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    
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
            todaysWorkday.totalHoursWorked = 0
        }
        timePunchTable.reloadData()
    }
    

    //**** Buttons
    //************
    @IBOutlet weak var silverTimeButtonRing: UIImageView!
    @IBOutlet weak var timePunchButtonOutlet: UIButton!
    @IBAction func timePunchButton(_ sender: UIButton) {
        let newTimePunch = TimePunch()
        let todaysTimePunches = todaysWorkday.timePunches
        let realm = try! Realm()
        
        try! realm.write {
            currentStatus = !currentStatus
            newTimePunch.id = NSUUID().uuidString
            newTimePunch.punchTime = Date()
            newTimePunch.status = currentStatus
            
            todaysTimePunches.append(newTimePunch)
            
        }
        print("\(todaysTimePunches.count) timePunches")
        timePunchTable.reloadData()
        activateToday()
        //    counter += 1
        //    totalTimeLabel.text = "\(counter):00"
        calculateTotalTime(timePunches: todaysTimePunches, workday: todaysWorkday)
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
        
        testLabel.text = "\(date)"

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
        
        
        //**** process current workday and timepunches
        //********************************************
        let workday = DA_Workday()
        todaysWorkday = workday.retrieveTodaysWorkday()
        totalTimeLabel.text = "\(todaysWorkday.totalHoursWorked)"
        
        let timePunches = todaysWorkday.timePunches
        
        if timePunches.count == 0 {
            currentStatus = false
        } else {
            currentStatus = timePunches.last!.status
        }
        
    }
    
    
    //**** TableView processing
    //*************************
    //*************************
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let weekDays = try! Realm().objects(Workday.self) // need to limit for this week
        
        if tableView == timePunchTable {
            let todaysTimePunches = todaysWorkday.timePunches
            return todaysTimePunches.count
        } else if tableView == weekTable {
            return weekDays.count
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todaysTimePunches = todaysWorkday.timePunches
        let weekDays = try! Realm().objects(Workday.self) // need to limit for this week
        
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
            cell.timePunchLabel.text = "\(timePunch.punchTime!.toString(.custom("hh:mm")))"
            //        cell.timePunchLabel.text = "Hello"
            
            return cell
            
            
            //*** Week Tab  ***//
        } else if tableView == weekTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "weekHoursCell") as! WeekHoursTableViewCell
            //        print ("pressed week")
            //        print(weekDays.count)
            let workday = weekDays[indexPath.row]
            cell.weekHoursLabel.text = workday.dayDate!.toString(.custom("dd MMM YYYY"))
            cell.totalHoursLabel.text = workday.totalHoursWorked.getHourAndMinuteOutput(total: workday.totalHoursWorked)
            cell.dayNameLabel.text = workday.dayDate?.toString(.custom("EEEE"))
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "notUsed")
            return cell!
        }
    }

    



}

