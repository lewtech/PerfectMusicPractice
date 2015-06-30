//
//  Record.swift
//  PerfectPianoPractice
//
//  Created by Lew Flauta on 6/30/15.
//  Copyright (c) 2015 lew flauta. All rights reserved.
//

import Foundation
import CoreData

class Record: NSManagedObject {

    @NSManaged var day: String
    @NSManaged var isCompleted: NSNumber
    @NSManaged var name: String
    @NSManaged var time: NSNumber
    @NSManaged var url: String
    @NSManaged var uuid: String
    @NSManaged var sortPriority: NSNumber

}
