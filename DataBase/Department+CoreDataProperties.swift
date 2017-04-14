//
//  Department+CoreDataProperties.swift
//  EKeeper
//
//  Created by limeng on 2017/4/14.
//  Copyright © 2017年 limeng. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Department {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Department> {
        return NSFetchRequest<Department>(entityName: "Department");
    }

    @NSManaged public var departmentName: String?
    @NSManaged public var departmentID: String?
    @NSManaged public var demo: String?

}
