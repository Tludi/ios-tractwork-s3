//
//  Reports.swift
//  tractwork
//
//  Created by manatee on 10/26/16.
//  Copyright © 2016 diligentagility. All rights reserved.
//

import Foundation
import UIKit

class Report: NSObject {

    func PDFWithScrollView(scrollView: UIScrollView) -> NSData {
        let outputData = NSMutableData()
        
        let pageDimensions = scrollView.bounds
        let pageSize = pageDimensions.size
        let totalSize = scrollView.contentSize
        
        let numberOfPagesThatFitHorizontally = Int(ceil(totalSize.width / pageSize.width))
        let numberOfPagesThatFitVertically = Int(ceil(totalSize.height / pageSize.height))
        
        UIGraphicsBeginPDFContextToData(outputData, pageDimensions, nil)
        
        let savedContentOffset = scrollView.contentOffset
        let savedContentInset = scrollView.contentInset
        
        scrollView.contentInset = UIEdgeInsets.zero
        
        if let context = UIGraphicsGetCurrentContext() {
            for indexHorizontal in 0 ..< numberOfPagesThatFitHorizontally {
                for indexVertical in 0 ..< numberOfPagesThatFitVertically {
                    UIGraphicsBeginPDFPage()
                    
                    let offsetHorizontal = CGFloat(indexHorizontal) * pageSize.width
                    let offsetVertical = CGFloat(indexVertical) * pageSize.height
                    
                    scrollView.contentOffset = CGPoint(x: offsetHorizontal, y: offsetVertical)
                    context.translateBy(x: -offsetHorizontal, y: -offsetVertical)
                    
                    scrollView.layer.render(in: context)
                }
            }
        }
        
        UIGraphicsEndPDFContext()
        
        scrollView.contentInset = savedContentInset
        scrollView.contentOffset = savedContentOffset
        
        
        return outputData
    }
    
    
    
}
