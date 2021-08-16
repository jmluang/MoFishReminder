//
//  DarkLightSelecter.swift
//  FishTouchReminder
//
//  Created by luang on 2021/8/16.
//

import SwiftUI

struct DarkLightSelecter: View {
    @State var isDark: Bool
    var body: some View {
        #if os(iOS)
        Button(action: { isDark.toggle() }) {
            myIcon(isDark: $isDark)
        }.padding()
        #else
        Toggle(isOn: $isDark) {
            myIcon(isDark: $isDark)
        }
        .padding()
        #endif
    }
}

struct DarkLightSelecter_Previews: PreviewProvider {
    static var previews: some View {
        DarkLightSelecter(isDark: false)
        DarkLightSelecter(isDark: true)
    }
}

struct myIcon: View {
    @Binding var isDark : Bool
    
    var body: some View {
        Image(systemName: isDark ? "sun.min.fill" : "moon.fill")
            .font(.system(size: 16))
            .foregroundColor(isDark ? .black : .white)
            .padding()
            .background(Color.primary)
            .clipShape(Circle())
    }
}
