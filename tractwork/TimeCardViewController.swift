//
//  ViewController.swift
//  tractwork
//
//  Created by manatee on 9/18/16.
//  Copyright © 2016 diligentagility. All rights reserved.
//

import UIKit
import RealmSwift

class TimeCardViewController: UIViewController {
    let date = Date()
    var currentStatus: Bool = false
    
    // DA objects
    //***********
    var workdayCount = 0
    let todaysWorkDate = Date()
    let todaysWorkday = Workday()
    
    // App colors
    //***********
    let darkGreyNavColor = UIColor(red: 6.0/255.0, green: 60.0/255.0, blue: 54.0/255.0, alpha: 0.95)
    let lightGreyNavColor = UIColor(red: 136.0/255.0, green: 166.0/255.0, blue: 173.0/255.0, alpha: 0.95)
    let tableColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)

    //**** Labels
    //***********
    @IBOutlet weak var testLabel: UILabel!
    
    
    //**** Tab Bar Buttons
    //********************
    @IBAction func clearWorkDays(_ sender: UIBarButtonItem) {
        let realm = try! Realm()
        let workdays = try! Realm().objects(Workday.self)
        try! realm.write {
            realm.delete(workdays)
        }
        // weekTable.reloadData()
    }
    
    @IBAction func clearTimePunches(_ sender: UIBarButtonItem) {
        let realm = try! Realm()
        let timePunches = todaysWorkday.timePunches
        try! realm.write {
            realm.delete(timePunches)
            todaysWorkday.totalHoursWorked = 0
        }
        // timePunchTable.reloadData()
    }
    
    @IBAction func toggleTables(_ sender: UIBarButtonItem) {
        if timePunchStack.isHidden {
            timePunchStack.isHidden = false
        } else {
            timePunchStack.isHidden = true
        }
        
        if weekTable.isHidden {
            weekTable.isHidden = false
        } else {
            weekTable.isHidden = true
        }
        timePunchStack.reloadInputViews()
        weekTable.reloadData()
        
    }

    //**** Buttons
    //************
    
    
    
    //**** Tables
    //***********
    @IBOutlet weak var timePunchTable: UITableView!
    @IBOutlet weak var weekTable: UITableView!
 

    @IBOutlet weak var timePunchStack: UIStackView!
    @IBOutlet weak var totalTimeView: UIView!
    
    
    //**** Table Nav Bar
    //******************
    
    //**** Today Nav Tab
    @IBOutlet weak var todayNavBox: UIView!
    @IBOutlet weak var todayButtonLabel: UIButton!
    @IBAction func todayButton(_ sender: UIButton) {
        activateToday()
    }
    
    func activateToday() {
        todayNavBox.backgroundColor = lightGreyNavColor
        todayButtonLabel.setTitleColor(darkGreyNavColor, for: .normal)
        weekNavBox.backgroundColor = darkGreyNavColor
        weekButtonLabel.setTitleColor(lightGreyNavColor, for: .normal)
        fourWeekNavBox.backgroundColor = darkGreyNavColor
        fourWeekButtonLabel.setTitleColor(lightGreyNavColor, for: .normal)
        timePunchStack.isHidden = false
        weekTable.isHidden = true
        timePunchTable.reloadData()
    }
    
    //**** Week Nav Tab
    @IBOutlet weak var weekNavBox: UIView!
    @IBOutlet weak var weekButtonLabel: UIButton!
    @IBAction func weekButton(_ sender: UIButton) {
        todayNavBox.backgroundColor = darkGreyNavColor
        todayButtonLabel.setTitleColor(lightGreyNavColor, for: .normal)
        weekNavBox.backgroundColor = lightGreyNavColor
        weekButtonLabel.setTitleColor(darkGreyNavColor, for: .normal)
        fourWeekNavBox.backgroundColor = darkGreyNavColor
        fourWeekButtonLabel.setTitleColor(lightGreyNavColor, for: .normal)
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        testLabel.text = "\(date)"

        setBaseColors()
        

        
        //**** Set Navbar background to clear
        //***********************************
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
    }
    
    func setBaseColors() {
        //*** set initial colors for nav tabs
        //***********************************
        todayNavBox.backgroundColor = lightGreyNavColor
        todayButtonLabel.setTitleColor(darkGreyNavColor, for: .normal)
        weekNavBox.backgroundColor = darkGreyNavColor
        weekButtonLabel.setTitleColor(lightGreyNavColor, for: .normal)
        fourWeekNavBox.backgroundColor = darkGreyNavColor
        fourWeekButtonLabel.setTitleColor(lightGreyNavColor, for: .normal)
        
        //*** set initial colors for tables
        //*********************************
        timePunchStack.backgroundColor = tableColor
        
        timePunchTable.backgroundColor = tableColor
        totalTimeView.backgroundColor = tableColor
        
        weekTable.backgroundColor = tableColor
        weekTable.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

