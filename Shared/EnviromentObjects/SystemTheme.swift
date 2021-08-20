//
//  SystemTheme.swift
//  FishTouchReminder
//
//  Created by luang on 2021/8/17.
//

import Foundation

class SystemTheme: ObservableObject {
    @Published var isDark : Bool
    
    init(isDark dark: Bool) {
        self.isDark = dark
    }
}
