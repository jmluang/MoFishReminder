//
//  Task.swift
//  FishTouchReminder
//
//  Created by luang on 2021/8/11.
//

import Foundation

struct Task : Equatable, Hashable, Identifiable {
    var id: UUID = UUID()
    var Title: String
    var Body: String
    var Interval: Int
    var Repeat: Bool
    var CreateTime: Date
    var NextTriggertime: String?
    var CountDownString: String?
}

extension Task {
    mutating func updateTime(NextTriggerTime nt: String, CountDownString cd: String) {
        self.NextTriggertime = nt
        self.CountDownString = cd
    }
}

extension Array where Element == Task {    
    /**
        return the exists element of the array, if not exists, return -1
     */
    func indexOf(task: Task) -> Int {
        for index in self.indices {
            if self[index].id == task.id {
                return index
            }
        }
        
        return -1
    }
}
