//
//  PerfectPianoPractice.swift
//  PerfectPianoPractice
//
//  Created by Lew Flauta on 6/5/15.
//  Copyright (c) 2015 lew flauta. All rights reserved.
//

import Foundation
import CoreData

class PerfectPianoPractice: NSManagedObject {

    @NSManaged var day: String
    @NSManaged var name: String
    @NSManaged var time: NSNumber
    @NSManaged var url: String
    @NSManaged var isCompleted: NSNumber

}
