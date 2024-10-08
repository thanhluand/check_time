//
//  TimeChecked+Manager.swift
//  Check Time
//
//  Created by Dang Luan on 2024/09/19.
//

import CoreData

extension CoreDataManager {
    func getAllTimeCheckeds() -> [TimeChecked] {
        let request = NSFetchRequest<TimeChecked>(entityName: "TimeChecked")

        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
    }
    
    func addTimeChecked(startTime: Int16, endTime: Int16, checkTime: Int16, result: Bool) {
        let data = TimeChecked(context: viewContext)

        data.id = UUID()
        data.startTime = startTime
        data.endTime = endTime
        data.checkTime = checkTime
        data.result = result
        data.createdAt = Date()
        saveContext()
    }
    
    func deleteTimeChecked(data: TimeChecked) {
        viewContext.delete(data)
        saveContext()
    }
}
