//
//  EditTimePunchViewController.swift
//  tractwork
//
//  Created by Timothy Ludi on 11/16/16.
//  Copyright © 2016 diligentagility. All rights reserved.
//

import UIKit
import RealmSwift

class EditTimePunchViewController: UIViewController {

    var passedTimePunch = TimePunch()
    let realm = try! Realm()

    
  
    @IBOutlet weak var timePunchPickerOutlet: UIDatePicker!

    @IBAction func timePunchPicker(_ sender: UIDatePicker) {

    }
    
    @IBOutlet weak var testLabel: UILabel!
    @IBAction func backButton(_ sender: UIButton) {
//        let realm = try! Realm()
        let updatedTime = timePunchPickerOutlet.date
        print(updatedTime)
//        try! realm.write {
//            passedTimePunch.punchTime = updatedTime
//            
//        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        let timePunches = realm.objects(TimePunch.self)
        print("first Time Punch")
        print(timePunches.last!)
        print("passed Time Punch")
        print(passedTimePunch)
        
//        let date = passedTimePunch.punchTime
        let date = Date().adjust(.hour, offset: -4)
        timePunchPickerOutlet.date = (timePunches.last?.punchTime)!

        
        
        testLabel.text = "\(passedTimePunch.punchTime)"
//        timeTextField.placeholder = "\(passedTimePunch.punchTime.toString(.custom("h:mm")))"
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
