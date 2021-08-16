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
    @State private var isDark: Bool = false
    @State private var thetitle: String = "提醒下你"
    @State private var thebody: String = "是时候提肛了喔"
    @State private var isOn: Bool = true
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date()
    @State private var allways: Bool = true
    @State private var interval:Int = 1
    
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
        let task = Task(Id: UUID().uuidString, Title: thetitle, Body: thebody, Interval: interval, Repeat: true)
        
        createNotification(task: task)
        
        getNotificationList()
    }
    
    func createNotification(task: Task) {
        
        print(task)
        let content = UNMutableNotificationContent()
        content.title = task.Title
        content.body = task.Body
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(task.Interval * 60), repeats: task.Repeat)
        let request = UNNotificationRequest(identifier: task.Id, content: content, trigger: trigger)

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
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print(request)
                let id = request.identifier
                print(id)
                guard let trigger = request.trigger as? UNTimeIntervalNotificationTrigger else {return}
                print(trigger)
                let nextTimeTrigger = trigger.nextTriggerDate()
                print(nextTimeTrigger!)
                print(formatter.string(from: nextTimeTrigger!))
            }
        })
    }
    
    func clearAllNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    var body: some View {
        HStack {
            Text(Settings.isAuthNotification ? "Granted!" : "Not Granted")
                .background(Settings.isAuthNotification ? Color.green : Color.red)
                .padding()
            Spacer(minLength: 0)
            DarkLightSelecter(isDark: isDark)
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
                        .background(Color.white)
                        .font(Font.system(size: 22))
                        .fixedSize()
                }
                Text("分钟")
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
        }.onAppear(perform: settingDate)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(AuthSettings())
    }
}
