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
                VStack(alignment: .leading) {
                    Text("每")
                        .foregroundColor(Color.primary)
                        .font(.system(size: 12))
                    Text("\(task.Interval.toString(.Hour, .Minute))")
                            .font(.largeTitle)
                    Text(task.Repeat ? "重复" : "不重复")
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                }.padding()
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text(task.NextTriggertime!)
                        .font(.largeTitle)
                    Text(task.CountDownString!)
                        .foregroundColor(Color.primary)
                        .font(.system(size: 14))
                }.padding()
            }
            Divider()
        }
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView(task: Task(Title: "title", Body: "body", Interval: TimeInterval(20 * 60), Repeat: true, CreateTime: Date(), NextTriggertime: "nextTriggerTime", CountDownString: "0:02"))
    }
}
