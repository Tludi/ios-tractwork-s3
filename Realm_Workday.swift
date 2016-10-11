//
//  Workday.swift
//  tractwork
//
//  Created by manatee on 9/19/16.
//  Copyright © 2016 diligentagility. All rights reserved.
//
// RealmSwift Models


import Foundation
import RealmSwift

class WorkWeek: Object {
    dynamic var id = ""
    dynamic var weekYear = Int()
    dynamic var weekNumber = Int()
    dynamic var startOfWeek = Date()
    dynamic var endOfWeek = Date()
    dynamic var totalWeekMinutes = Int()
    let workdays = List<Workday>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    let dayNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
}

class Workday: Object {
    dynamic var id = ""
    dynamic var dayDate = Date()
    dynamic var project = "general work"
    dynamic var totalHoursWorked = "0:00"
    dynamic var worker = "milo"
    dynamic var currentStatus = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    let timePunches = List<TimePunch>()
    
    let projects = List<Project>()
    
}

class TimePunchPair: Object {
    
}


class TimePunch: Object {
    dynamic var id = ""
    dynamic var punchTime = Date()
    dynamic var status = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var timePunchWorkday = LinkingObjects(fromType: Workday.self, property: "timePunches")
}



class Project: Object {
    dynamic var id = ""
    dynamic var projectName = "general work"
    dynamic var projectExternalID = "project ID"
    dynamic var locationAddress = "1234 happy drive"
    dynamic var locationCity = "Portland"
    dynamic var locationState = "Oregon"
    dynamic var locationZIP = "12345"
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var workdayProject = LinkingObjects(fromType: Workday.self, property: "projects")
    
}
