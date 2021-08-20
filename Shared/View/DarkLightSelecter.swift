//
//  DarkLightSelecter.swift
//  FishTouchReminder
//
//  Created by luang on 2021/8/16.
//

import SwiftUI

struct DarkLightSelecter: View {
    @EnvironmentObject var theme : SystemTheme
    var body: some View {
        #if os(iOS)
        Button(action: { theme.isDark.toggle() }) {
            myIcon(isDark: $isDark)
        }.padding()
        #else
        Toggle(isOn: Binding(get: {
            return theme.isDark
        }, set: { (value) in
            theme.isDark = value
        })) {
            myIcon().environmentObject(theme)
        }
        .padding()
        #endif
    }
}

struct DarkLightSelecter_Previews: PreviewProvider {
    static var previews: some View {
        DarkLightSelecter().environmentObject(SystemTheme(isDark: false))
        DarkLightSelecter().environmentObject(SystemTheme(isDark: true))
    }
}

struct myIcon: View {
    @EnvironmentObject var theme : SystemTheme
    
    var body: some View {
        Image(systemName: theme.isDark ? "sun.min.fill" : "moon.fill")
            .font(.system(size: 16))
            .foregroundColor(theme.isDark ? .black : .white)
            .padding()
            .background(Color.primary)
            .clipShape(Circle())
    }
}
