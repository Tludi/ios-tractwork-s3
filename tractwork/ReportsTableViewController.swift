//
//  ReportsTableViewController.swift
//  tractwork
//
//  Created by manatee on 10/27/16.
//  Copyright © 2016 diligentagility. All rights reserved.
//

import UIKit

class ReportsTableViewController: UITableViewController, UIDocumentInteractionControllerDelegate {
    func updatePaths(notification: Notification?) {
        let manager = PDFManager()
        
        self.PDFPaths = manager.filesInDocumentsDirectory()
        
        self.tableView.reloadData()
    }
    
    var PDFPaths: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationName = Notification.Name("com.diligentagility.pdf-saved")
        NotificationCenter.default.addObserver(self, selector: #selector(updatePaths), name: notificationName, object: nil)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.updatePaths(notification: nil)
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
        return self.PDFPaths.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath)
        
        if indexPath.row < self.PDFPaths.count {
            let index = self.PDFPaths.startIndex.advanced(by: indexPath.row)
            let path = self.PDFPaths[index]
            
            cell.textLabel?.text = path.components(separatedBy: "/").last
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row < self.PDFPaths.count {
            
            
            let path = self.PDFPaths[self.PDFPaths.startIndex.advanced(by: indexPath.row)]
            
            let manager = PDFManager()
            let fullPath = "\(manager.documentsDirectory())/\(path)"
            
            let url = URL(fileURLWithPath: fullPath)
            
            let interactionController = UIDocumentInteractionController(url: url)
            interactionController.delegate = self
            
            if interactionController.presentPreview(animated: true) {
                print("Presented preview.")
            }
            else
            {
                print("Did not present preview.")
            }
        }
        
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
