//
//  MyTimeInterval.swift
//  FishTouchReminder
//
//  Created by luang on 2021/8/18.
//

import Foundation

extension TimeInterval {
    enum FormatType{
        case Hour
        case Minute
        case Second
        case MilliSecond
    }
    
    private var milliseconds: Int {
        return Int((truncatingRemainder(dividingBy: 1)) * 1000)
    }
    
    private var seconds: Int {
        return Int(self) % 60
    }

    private var minutes: Int {
        return (Int(self) / 60 ) % 60
    }

    private var hours: Int {
        return Int(self) / 3600
    }
    
    func toString(_ types: FormatType...) -> String {
        var formated_string = ""
        for t in types {
            switch t {
            case .Hour:
                if self.hours > 0 {
                    formated_string += "\(self.hours)h"
                }
                break
            case .Minute:
                if self.minutes > 0 {
                    formated_string += " \(self.minutes)m"
                }
                break
            case .Second:
                if self.seconds > 0 {
                    formated_string += " \(self.seconds)s"
                }
                break
            case .MilliSecond:
                formated_string += " \(self.milliseconds)ms"
                break
            }
        }
        
        return formated_string
    }
    
    func stringTime(_ showMicrotime: Bool) -> String {
        if hours != 0 {
            return "\(hours)h \(minutes)m \(seconds)s"
        } else if minutes != 0 {
            return "\(minutes)m \(seconds)s"
        } else if milliseconds != 0 && showMicrotime {
            return "\(seconds)s \(milliseconds)ms"
        } else {
            return "\(seconds)s"
        }
    }

    func toHourAndSecond() -> String {
        let time = NSInteger(self)

//        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)

        return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    }
}
