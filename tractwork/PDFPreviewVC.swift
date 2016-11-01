//
//  PDFPreviewVC.swift
//  tractwork
//
//  Created by manatee on 10/28/16.
//  Copyright © 2016 diligentagility. All rights reserved.
//

import Foundation

import UIKit


class PDFPreviewVC: UIViewController, UIDocumentInteractionControllerDelegate {
    @IBAction func printButton(_ sender: AnyObject) {
//        let printController = UIPrintInteractionController.shared
//        let printInfo = UIPrintInfo(dictionary: nil)
//        printInfo.jobName = "test Print"
//        printInfo.outputType = .general
//        
//        printController.printInfo = printInfo
//        printController.printFormatter = UIViewPrintFormatter()
//        
//        let formatter = UIViewPrintFormatter()
//        //        formatter.
//        //        let formatter = UIMarkupTextPrintFormatter(markupText: "hello test printer")
//        formatter.perPageContentInsets = UIEdgeInsetsMake(72, 72, 72, 72)
//        printController.printFormatter = formatter
//        
//        printController.present(animated: true, completionHandler: nil)
        
        let activityViewController = UIActivityViewController(activityItems: ["tractwork report", url], applicationActivities: nil)
        if let popoverPresentationController = activityViewController.popoverPresentationController{
            popoverPresentationController.barButtonItem = (sender as! UIBarButtonItem)
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBOutlet fileprivate weak var webView: UIWebView!
    var url: URL!
    override func viewDidLoad() {
        super.viewDidLoad()
        let req = NSMutableURLRequest(url: url)
        req.timeoutInterval = 60.0
        req.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        webView.scalesPageToFit = true
        webView.loadRequest(req as URLRequest)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc @IBAction fileprivate func close(_ sender: AnyObject!) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupWithURL(_ url: URL) {
        self.url = url
    }
    
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
}
