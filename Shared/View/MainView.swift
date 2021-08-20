//
//  MainView.swift
//  FishTouchReminder
//
//  Created by luang on 2021/8/5.
//

import SwiftUI
import UserNotifications

struct MainView: View {
    @EnvironmentObject var Settings: AuthSettings
    @EnvironmentObject var Theme: SystemTheme
    @State private var thetitle: String = "提醒下你"
    @State private var thebody: String = "是时候提肛了喔"
    @State private var isOn: Bool = true
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date()
    @State private var allways: Bool = true
    @State private var interval:Int = 20
    @State var receiver = Timer.publish(every: 1, on: .current, in: .default).autoconnect()
    @State private var tasks: [Task] = []
    
    func settingDate() {
        var components = DateComponents()
        components.hour = 8
        components.minute = 0
        startTime = Calendar.current.date(from: components) ?? Date()
        components.hour = 18
        endTime = Calendar.current.date(from: components) ?? Date()
    }
    
    func notificationAction() {
        if !isOn {
            return
        }
        
        let task = Task(Title: thetitle, Body: thebody, Interval: interval, Repeat: true, CreateTime: Date())
        createNotification(task: task)
    }
    
    func createNotification(task: Task) {
        
        let content = UNMutableNotificationContent()
        content.title = task.Title
        content.body = task.Body
        content.userInfo["create_time"] = task.CreateTime
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(task.Interval * 60), repeats: task.Repeat)
        let request = UNNotificationRequest(identifier: task.id.uuidString, content: content, trigger: trigger)

        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if error != nil {
                // Handle any errors.
                print("Time Interval Notification scheduled error: \(String(describing: error))")
            }
        }
    }
    
    func getNotificationList() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getPendingNotificationRequests(completionHandler: { requests in
            guard requests.count > 0 else {
                tasks.removeAll()
                if !isOn {
                    return
                }
                return
            }
            
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
            formatter.locale = Locale(identifier: "zh_CN")
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium
            
            for request in requests {
//                print(request)
//                let id = request.identifier
                guard let trigger = request.trigger as? UNTimeIntervalNotificationTrigger else { continue }
                let nextTriggerDate = trigger.nextTriggerDate()
                guard let create_time = request.content.userInfo["create_time"] as? Date else { continue }
//                print(create_time)
                
                let interval = nextTriggerDate!.timeIntervalSince(create_time) - trigger.timeInterval
                
                let count_down = trigger.timeInterval - interval.truncatingRemainder(dividingBy: trigger.timeInterval)
//                print(count_down.stringTime(false))
                
                var current = Date()
                current.addTimeInterval(count_down)
//                print(current.description(with: Locale(identifier: "ZH_CN")))

                let t = Task(id: UUID(uuidString: request.identifier)!, Title: request.content.title, Body: request.content.body, Interval: Int(trigger.timeInterval), Repeat: trigger.repeats, CreateTime: create_time, NextTriggertime: formatter.string(from: current), CountDownString: count_down.stringTime(false))
                let index = tasks.indexOf(task: t)
                if index == -1 {
                    tasks.append(t)
                } else {
                    DispatchQueue.main.async {
                        tasks[index].CountDownString = t.CountDownString
                        tasks[index].NextTriggertime = t.NextTriggertime
                    }
                }
            }
        })
    }
    
    func clearAllNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        tasks.removeAll()
    }
    
    var body: some View {
        HStack {
            Text(Settings.isAuthNotification ? "Granted!" : "Not Granted")
                .background(Settings.isAuthNotification ? Color.green : Color.red)
                .padding()
            Spacer(minLength: 0)
            DarkLightSelecter().environmentObject(Theme)
        }
        VStack {
            Spacer()
            HStack {
                Spacer()
                Group{
                    Text("标题:")
                    .padding(.leading)
                    TextField(thetitle, text: $thetitle)
                    .frame(width: 260, height: nil)
                }
                    .font(Font.system(size: 18, design: .default))
                Spacer()
            }
            
            HStack {
                Spacer()
                Group{
                    Text("内容:")
                    .padding(.leading)
                    TextField(thebody, text: $thebody)
                    .frame(width: 260, height: nil)
                }
                    .font(Font.system(size: 18, design: .default))
                Spacer()
            }
            HStack {
                Toggle(isOn: $allways) {
                    Text("全天")
                }
                if !allways {
                    Group() {
                        DatePicker(selection: $startTime, displayedComponents: .hourAndMinute, label: {})
                            .fixedSize()
                        Text("-")
                        DatePicker(selection: $endTime, displayedComponents: .hourAndMinute, label:{})
                            .fixedSize()
                    }
                }
            }
            HStack {
                Text("每")
                Stepper(value: $interval, in: 1...360) {
                    Text("\(interval)")
                        .font(Font.system(size: 22))
                        .foregroundColor(Theme.isDark ? Color.white : Color.black)
                        .fixedSize()
                }
                Text("分钟")
            }
            Spacer()
            HStack {
//                Text("下次提醒时间：")
//                Text("\(nextTriggerTime)")
                List(tasks, id: \.id) { task in
                    TaskView(task: task)
                }
            }
            Spacer()
            HStack {
                Toggle(isOn: $isOn) {
                    Text("是否开启")
                }
                Button(action: notificationAction) {
                    Text("测试提醒")
                }
                Button(action: clearAllNotification) {
                    Text("reset")
                }
            }
            Spacer()
        }
        .onAppear(perform: settingDate)
        .onReceive(receiver, perform: { _ in
            getNotificationList()
            print("on receiver")
        })
    }
}

struct MainView_Previews: PreviewProvider {
    
    static var previews: some View {
        MainView().environmentObject(AuthSettings()).environmentObject(SystemTheme(isDark: true))
        MainView().environmentObject(AuthSettings()).environmentObject(SystemTheme(isDark: false))
    }
}
