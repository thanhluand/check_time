//
//  HomeViewModel.swift
//  Time Check
//
//  Created by Dang Luan on 2024/08/05.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var timeCheckedes: [TimeChecked] = []
    
    func checkData(startTime: Int16, endTime: Int16, checkTime: Int16) {
        var result = false
        if(startTime == endTime && startTime == checkTime) {
            result = true
        } else if (startTime < endTime){
            result = checkTime >= startTime && checkTime < endTime
        } else {
            result = checkTime >= startTime || checkTime < endTime
        }
        
        addTimeChecked(startTime: startTime, endTime: endTime, checkTime: checkTime, result: result)
    }
    
    func getAllTimeCheckeds() {
        timeCheckedes =  CoreDataManager.shared.getAllTimeCheckeds().sorted( by: { $0.createdAt.timeIntervalSince1970 > $1.createdAt.timeIntervalSince1970 })
    }
    
    private func addTimeChecked(startTime: Int16, endTime: Int16, checkTime: Int16, result: Bool) {
        CoreDataManager.shared.addTimeChecked(startTime: startTime, endTime: endTime, checkTime: checkTime, result: result)
        getAllTimeCheckeds()
    }
    
    private func updateTimeChecked() {
        CoreDataManager.shared.saveContext()
        getAllTimeCheckeds()
    }
    
    private func deleteTimeChecked(timeChecked: TimeChecked) {
        CoreDataManager.shared.deleteTimeChecked(data: timeChecked)
        getAllTimeCheckeds()
    }
}
