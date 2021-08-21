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
        VStack {
            HStack {
                VStack {
                    Text(task.Repeat ? "重复" : "不重复")
                        .foregroundColor(.gray)
                    HStack {
                        Text("\(task.Interval) Mins")
                            .font(.title)
                    }
                }.padding()
                Spacer()
                VStack {
                    Text(task.NextTriggertime!)
                    Text(task.CountDownString!)
                }.padding()
            }
        }
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView(task: Task(Title: "title", Body: "body", Interval: 60, Repeat: true, CreateTime: Date(), NextTriggertime: "nextTriggerTime", CountDownString: "0:02"))
    }
}
