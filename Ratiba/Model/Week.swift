//
//  Week.swift
//  Ratiba
//
//  Created by ian robert blair on 2023/1/6.
//

import Foundation

class Week:ObservableObject {
    @Published var date:Date
    @Published var days:[Day]?
    
    init(day: Date) {
        self.date = day
    }
}

