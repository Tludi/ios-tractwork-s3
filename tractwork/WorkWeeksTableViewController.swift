//
//  WorkWeeksTableViewController.swift
//  tractwork
//
//  Created by manatee on 10/24/16.
//  Copyright © 2016 diligentagility. All rights reserved.
//

import UIKit
import RealmSwift
import PDFGenerator


class WorkWeeksTableViewController: UITableViewController {
    let realm = try! Realm()
    let workWeeks = try! Realm().objects(WorkWeek.self)
    
    
    @IBOutlet var workdayTable: UITableView!
    
//    @IBAction func printButton(_ sender: UIBarButtonItem) {
//        let printController = UIPrintInteractionController.shared
//        let printInfo = UIPrintInfo(dictionary: nil)
//        printInfo.jobName = "test Print"
//        printInfo.outputType = .general
//        
//        printController.printInfo = printInfo
//        printController.printFormatter = UIViewPrintFormatter()
//        
//        let formatter = UIViewPrintFormatter()
////        formatter.
////        let formatter = UIMarkupTextPrintFormatter(markupText: "hello test printer")
//        formatter.perPageContentInsets = UIEdgeInsetsMake(72, 72, 72, 72)
//        printController.printFormatter = formatter
//        
//        printController.present(animated: true, completionHandler: nil)
//        
//    }
    
    @IBAction func pdfRecords(_ sender: AnyObject) {
//        if let workTable = self.tableView {
//            let report = Report()
//            let data = report.PDFWithScrollView(scrollView: workTable)
//            let manager = PDFManager()
//            manager.writeData(data: data)
//            
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "com.diligentagility.pdf-saved"), object: nil)
//            
//        }
        let fileFolder =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let destination = URL(fileURLWithPath: fileFolder.appending("/tractwork.pdf"))
        
        
        
        generatePDF(destination: destination)
        openPDFViewer(fileFolder.appending("/tractwork.pdf"))
    }
    
    func generatePDF(destination: URL) {
        do {
            let data = try PDFGenerator.generated(by: [workdayTable])
            try data.write(to: destination, options: .atomic)
        } catch (let error) {
            print(error)
        }
        
        do {
            try PDFGenerator.generate([workdayTable], to: destination)
        } catch (let error) {
            print(error)
        }
        
    }
    
    fileprivate func openPDFViewer(_ pdfPath: String) {
        let url = URL(fileURLWithPath: pdfPath)
        let storyboard = UIStoryboard(name: "PDFPreviewVC", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! PDFPreviewVC
        vc.setupWithURL(url)
        present(vc, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Week \(workWeeks[section].weekNumber)"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return workWeeks.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        return workWeeks[section].workdays.count
        
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workWeekCell", for: indexPath)

        cell.textLabel?.text = workWeeks[indexPath.section].workdays[indexPath.row].dayDate.toString()

        return cell
    }

    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
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

}
