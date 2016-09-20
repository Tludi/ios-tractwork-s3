//
//  TimeCardViewExtension.swift
//  tractwork
//
//  Created by manatee on 9/19/16.
//  Copyright © 2016 diligentagility. All rights reserved.
//

import Foundation

extension TimeCardViewController {
    
    func setBaseColors() {
        //*** set initial colors for nav tabs
        //***********************************
        todayNavBox.backgroundColor = lightGreyNavColor
        todayButtonLabel.setTitleColor(darkGreyNavColor, for: .normal)
        weekNavBox.backgroundColor = darkGreyNavColor
        weekButtonLabel.setTitleColor(lightGreyNavColor, for: .normal)
        fourWeekNavBox.backgroundColor = darkGreyNavColor
        fourWeekButtonLabel.setTitleColor(lightGreyNavColor, for: .normal)
        
        //*** set initial colors and status for tables
        //********************************************
        timePunchStack.backgroundColor = tableColor
        timePunchTable.backgroundColor = tableColor
        totalTimeView.backgroundColor = tableColor
        
        weekTable.backgroundColor = tableColor
        weekTable.isHidden = true
        
    }
    
    func activateToday() {
        //**** change colors of tables and tabs
        //**** and showing/hiding tables
        //**** when selecting the today tab or
        //**** selecting the clock in/out button
        //**************************************
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
}
