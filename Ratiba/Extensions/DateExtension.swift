//
//  DateExtension.swift
//  Ratiba
//
//  Created by ian robert blair on 2023/1/6.
//

import Foundation

extension Date {
    var startOfDay:Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay:Date {
        var component = DateComponents()
        component.day = 1
        component.second = -1
        return Calendar.current.date(byAdding: component, to: startOfDay)!
    }
    
}
