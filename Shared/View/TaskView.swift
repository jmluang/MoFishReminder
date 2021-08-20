//
//  TaskView.swift
//  FishTouchReminder
//
//  Created by luang on 2021/8/19.
//

import SwiftUI

struct TaskView: View {
    var task : Task
    var body: some View {
        Text(task.NextTriggertime!)
        Text(task.CountDownString!)
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView(task: Task(Title: "title", Body: "body", Interval: 60, Repeat: true, CreateTime: Date(), NextTriggertime: "nextTriggerTime"))
    }
}
