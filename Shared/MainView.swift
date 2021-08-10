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
    @State private var thetitle: String = "提醒下你"
    @State private var thebody: String = "是时候提肛了喔"
    @State private var isOn: Bool = true
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date()
    @State private var allways: Bool = true
    @State private var interval:Int = 30
    
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
        
        print("\(startTime)")
        print("\(endTime)")
        print("\(allways)")
        print("\(interval)")
        let uuidString = UUID().uuidString
        let content = UNMutableNotificationContent()
        content.title = thetitle
        content.body = thebody
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current

        let trigger = UNCalendarNotificationTrigger(
                 dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)

        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if error != nil {
                // Handle any errors.
                print("Time Interval Notification scheduled error: \(error)")

            }
        }
    }
    
    var body: some View {
        if Settings.isAuthNotification {
            VStack {
                Text("Granted!")
                    .background(Color.green)
            }
        } else {
            VStack {
                Text("Not Granted")
                    .background(Color.red)
            }
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
                        DatePicker(selection: $startTime, displayedComponents: .hourAndMinute, label: { /*@START_MENU_TOKEN@*/Text("Date")/*@END_MENU_TOKEN@*/ })
                            .fixedSize()
                        Text("-")
                        DatePicker(selection: $endTime, displayedComponents: .hourAndMinute, label:{})
                            .fixedSize()
                    }
                }
            }
            HStack {
                Text("每")
                Stepper(value: $interval, in: 0...360) {
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
