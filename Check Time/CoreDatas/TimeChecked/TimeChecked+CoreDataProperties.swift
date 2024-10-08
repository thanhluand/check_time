//
//  TimeChecked+CoreDataProperties.swift
//  Check Time
//
//  Created by Dang Luan on 2024/09/19.
//
//

import Foundation
import CoreData


extension TimeChecked {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TimeChecked> {
        return NSFetchRequest<TimeChecked>(entityName: "TimeChecked")
    }

    @NSManaged public var startTime: Int16
    @NSManaged public var endTime: Int16
    @NSManaged public var checkTime: Int16
    @NSManaged public var result: Bool
    @NSManaged public var id: UUID
    @NSManaged public var createdAt: Date

}

extension TimeChecked : Identifiable {

}
