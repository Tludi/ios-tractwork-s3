//
//  ViewController.swift
//  tractwork
//
//  Created by manatee on 9/18/16.
//  Copyright © 2016 diligentagility. All rights reserved.
//  PDF Branch

import UIKit
import RealmSwift

class TimeCardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let realm = try! Realm()
    var currentStatus = Bool()
    let todaysDate = Date()
    
    
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
    let lightBlueNavColor = UIColor(red: 66.0/255.0, green: 165.0/255.0, blue: 245.0/255.0, alpha: 0.9)
    
    //**** Labels
    //***********
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var currentStatusLabel: UILabel!
    
    //*** Views
    //*********
    @IBOutlet weak var tablesContainerView: UIView!
    @IBOutlet weak var workdayHeaderView: UIView!
    @IBOutlet weak var weekHeaderView: UIView!
    @IBOutlet weak var allWeeksHeaderView: UIView!
    
    
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
    
    
    //*** Main Time Punch Button
    //**************************
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
//        print("total minutes for this week \(workweek.totalWeekMinutes)")
        
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
        todayButtonLabel.setTitleColor(lightBlueNavColor, for: .normal)
        weekNavBox.backgroundColor = lightGreyNavColor2
        weekButtonLabel.setTitleColor(darkGreyNavColor, for: .normal)
        fourWeekNavBox.backgroundColor = darkGreyNavColor2
        fourWeekButtonLabel.setTitleColor(lightBlueNavColor, for: .normal)
        timePunchStack.isHidden = true
        weekTable.isHidden = false
        fourWeekTable.isHidden = true
        workdayHeaderView.isHidden = true
        weekHeaderView.isHidden = false
        allWeeksHeaderView.isHidden = true
        weekTable.reloadData()
    }
    
    //**** 4 Week Nav Tab
    @IBOutlet weak var fourWeekNavBox: UIView!
    @IBOutlet weak var fourWeekButtonLabel: UIButton!
    @IBAction func fourWeekButton(_ sender: UIButton) {
        todayNavBox.backgroundColor = darkGreyNavColor2
        todayButtonLabel.setTitleColor(lightBlueNavColor, for: .normal)
        weekNavBox.backgroundColor = darkGreyNavColor2
        weekButtonLabel.setTitleColor(lightBlueNavColor, for: .normal)
        fourWeekNavBox.backgroundColor = lightGreyNavColor2
        fourWeekButtonLabel.setTitleColor(darkGreyNavColor, for: .normal)
        timePunchStack.isHidden = true
        weekTable.isHidden = true
        fourWeekTable.isHidden = false
        workdayHeaderView.isHidden = true
        weekHeaderView.isHidden = true
        allWeeksHeaderView.isHidden = false
        fourWeekTable.reloadData()
    }
    
    
    
    
    //**** Start UIView processing
    //****************************
    //****************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //**** process current workday and timepunches
        //********************************************
//        let realm = try! Realm()
//        let workweeks = realm.objects(WorkWeek.self)
//        print("\(workweeks.count) workweeks in database")
        
        //*** get or create current workweek with workdays
        //************************************************
        let workweek = getWorkweek(todaysDate: todaysDate)
        let workday = getWorkday(workweek: workweek, todaysDate: todaysDate)
        
 
        //**** get current in/out status
        currentStatus = workday.currentStatus
        switch currentStatus {
        case true:
            currentStatusLabel.text = "status is punched in."
            timePunchButtonOutlet.setImage(#imageLiteral(resourceName: "outbutton"), for: [])
        case false:
            currentStatusLabel.text = "status is punched out."
            timePunchButtonOutlet.setImage(#imageLiteral(resourceName: "inbutton"), for: [])
            
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let workweek = getWorkweek(todaysDate: todaysDate)
        let workday = getWorkday(workweek: workweek, todaysDate: todaysDate)
        
        if tableView == timePunchTable {
            return returnTimePunchPairsForTable(workday: workday).count
        } else if tableView == weekTable {
            return 7
        } else {
            return getLastFourWorkweeks().count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let workweek = getWorkweek(todaysDate: todaysDate)
        let workday = getWorkday(workweek: workweek, todaysDate: todaysDate)
        let lastFourWeeks = getLastFourWorkweeks()
        let currentWorkWeek = WorkWeek()
        var timePunchPairs = returnTimePunchPairsForTable(workday: workday)
        
        //*** TimePunch tab for workday
        //*****************************
        if tableView == timePunchTable {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "timePunchCell") as! TimePunchTableViewCell
            
            // get timePunchPair for each cell
            let timePunchPair = timePunchPairs[indexPath.row]

            //*** Display and hide cell details based on number of punches in a pair of timePunches
            if timePunchPair.count == 2 {
                cell.inLabel.text = timePunchPair[0].punchTime.toString(.custom("h:mm"))
                cell.outLabel.text = timePunchPair[1].punchTime.toString(.custom("h:mm"))
                cell.punchPairTime.text = returnPairTimeDifference(timeIn: timePunchPair[0], timeOut: timePunchPair[1])
                cell.inRing.isHidden = false
                cell.inLabel.isHidden = false
                cell.outRing.isHidden = false
                cell.outLabel.isHidden = false
            } else if timePunchPair.count == 1 {
                cell.inLabel.text = timePunchPair[0].punchTime.toString(.custom("h:mm"))
                cell.outLabel.text = " "
                cell.punchPairTime.text = "Working"
                cell.inRing.isHidden = false
                cell.inLabel.isHidden = false
                cell.outRing.isHidden = true
                cell.outLabel.isHidden = true
            } else {
                cell.punchPairTime.text = "No Punches for today"
                cell.inRing.isHidden = true
                cell.inLabel.isHidden = true
                cell.outRing.isHidden = true
                cell.outLabel.isHidden = true
            }
            
            cell.inRing.image = UIImage(named: "INRing")
            cell.outRing.image = UIImage(named: "OutRing")
            
            return cell
            
            
        //*** TimePunch Tab for current Week
        //**********************************
        } else if tableView == weekTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "weekHoursCell") as! WeekHoursTableViewCell

            cell.weekHoursLabel.text = "\(workweek.workdays[indexPath.row].dayDate.toString(.custom("MM/dd")))"
            cell.totalHoursLabel.text = "\(workweek.workdays[indexPath.row].totalHoursWorked)"
            cell.dayNameLabel.text = currentWorkWeek.dayNames[indexPath.row]
            return cell
            
        //*** TimePunch Tab for all weeks
        //*******************************
        } else if tableView == fourWeekTable {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "fourWeekCell") as! FourWeekTableViewCell
            cell.tintColor = UIColor.darkGray
            cell.startDateLabel.text = "\(lastFourWeeks[indexPath.row].startOfWeek.toString(.custom("MM/dd/yyyy")))"
            cell.endDateLabel.text = "\(lastFourWeeks[indexPath.row].endOfWeek.toString(.custom("MM/dd/yyyy")))"
            cell.totalHoursLabel.text = returnWeekHoursAndMinutes(week: lastFourWeeks[indexPath.row])
            cell.weekNumber.text = String(lastFourWeeks[indexPath.row].weekNumber)
            
            return cell
            
            
            //*** Default base for tabs (not used) ***//
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "notUsed")
            return cell!
        }
    }
    
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == fourWeekTable {
            if tableView.cellForRow(at: indexPath) != nil {
                let cell = tableView.cellForRow(at: indexPath)
                self.performSegue(withIdentifier: "showWeekSegue", sender: cell)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWeekSegue" {
            if let destintionController = segue.destination as? WeekTableViewController {
                if let indexPath = self.fourWeekTable.indexPathForSelectedRow {
                    let lastFourWeeks = getLastFourWorkweeks()
                    let workweek = lastFourWeeks[indexPath.row]
                    destintionController.passedWeek = workweek
                }

                let testText = "test text"
                
                destintionController.testText = testText
            }
        }
    }


}

