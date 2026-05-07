//
//  DailyEarning.swift
//  EarnQuest
//
//  Created by Mikael Engvall on 2026-05-07.
//

import Foundation

struct DailyEarning: Identifiable {
    
    let id = UUID()
    let day: String
    let amount: Int
}
