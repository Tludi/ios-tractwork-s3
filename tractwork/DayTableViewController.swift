//
//  ReportsTableViewController.swift
//  tractwork
//
//  Created by manatee on 10/27/16.
//  Copyright © 2016 diligentagility. All rights reserved.
//

import UIKit
import RealmSwift


class DayTableViewController: UITableViewController, UIDocumentInteractionControllerDelegate {
    var passedDay = Workday()
    
    @IBOutlet var dayTable: UITableView!
//    func updatePaths(notification: Notification?) {
//        let manager = PDFManager()
//        
//        self.PDFPaths = manager.filesInDocumentsDirectory()
//        
//        self.tableView.reloadData()
//    }
//    
//    var PDFPaths: [String] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let notificationName = Notification.Name("com.diligentagility.pdf-saved")
//        NotificationCenter.default.addObserver(self, selector: #selector(updatePaths), name: notificationName, object: nil)
//
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
//    }

    override func viewDidLoad() {
        dayTable.register(UINib(nibName: "TimePunchTableViewCell", bundle: nil), forCellReuseIdentifier: "timePunchCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return returnTimePunchPairsForTable(workday: passedDay).count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timePunchCell", for: indexPath)
        
        if tableView == dayTable {
            let timePunchPairs = returnTimePunchPairsForTable(workday: passedDay)
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
        }

        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        if indexPath.row < self.PDFPaths.count {
//            
//            
//            let path = self.PDFPaths[self.PDFPaths.startIndex.advanced(by: indexPath.row)]
//            
//            let manager = PDFManager()
//            let fullPath = "\(manager.documentsDirectory())/\(path)"
//            
//            let url = URL(fileURLWithPath: fullPath)
//            
//            let interactionController = UIDocumentInteractionController(url: url)
//            interactionController.delegate = self
//            
//            if interactionController.presentPreview(animated: true) {
//                print("Presented preview.")
//            }
//            else
//            {
//                print("Did not present preview.")
//            }
//        }
//        
//    }
    
    
//    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
//        return self
//    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
}
