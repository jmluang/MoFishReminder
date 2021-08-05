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
    @State private var thetitle = "提醒下你"
    @State private var thebody = "是时候提肛了喔"
    @State private var isOn = true
    
    func notificationAction() {
        if !isOn {
            return
        }
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
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(AuthSettings())
    }
}
