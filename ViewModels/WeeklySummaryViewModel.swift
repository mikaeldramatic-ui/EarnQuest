//
//  WeeklySummaryViewModel.swift
//  EarnQuest
//
//  Created by Mikael Engvall on 2026-05-05.
//
import Combine
import Foundation

final class WeeklySummaryViewModel : ObservableObject {
    
    @Published var totalEarnings: Int = 0
    private let userId: String
    
    private let service = FirestoreService()
    
    init(userId: String) {
        self.userId = userId
    }
    
    func fetchWeeklyEarnings(chores: [Chore]) {
        service.getCompletions { completions in
        
            let calendar = Calendar.current
            let today = Date()
            
            guard let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: today) else {
                return
            }
            
            let filteredCompletions = completions.filter {
                $0.date >= sevenDaysAgo
            }
            
            var total = 0
            
            for completion in filteredCompletions {
                if let chore = chores.first(where: { $0.id == completion.choreId }) {
                    total += chore.dailyReward
                }
            }
            
            DispatchQueue.main.async {
                self.totalEarnings = total
            }
        }
    }
}

