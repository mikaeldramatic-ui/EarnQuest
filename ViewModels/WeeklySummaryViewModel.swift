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
    @Published var streak: Int = 0
    @Published var weeklyChartData: [DailyEarning] = []
    private let userId: String
    
    private let service = FirestoreService()
    
    init(userId: String) {
        self.userId = userId
    }
    
    func fetchWeeklyEarnings(chores: [Chore]) {
        service.getCompletions(userId: userId) { completions in
        
            let calendar = Calendar.current
            let today = Date()
            
            guard let sevenDaysAgo = calendar.date(
                byAdding: .day,
                value: -7,
                to: today
            ) else {
                return
            }
            
            let filteredCompletions = completions.filter {
                $0.date >= sevenDaysAgo
            }
            
            var total = 0

            for completion in filteredCompletions {
                total += completion.dailyReward
            }
            
            DispatchQueue.main.async {
                self.totalEarnings = total
            }
            
            self.calculateStreak(
                completions: completions
            )
            
            self.generateChartData(
                completions: filteredCompletions
            )
        }
    }
    
    func calculateStreak(completions: [Completion]) {
        
        let calendar = Calendar.current
        
        let completionDates = Set(
            completions.map {
                calendar.startOfDay(for: $0.date)
            }
        )
        
        var currentDate = calendar.startOfDay(for: Date())
        
        var currentStreak = 0
        
        while completionDates.contains(currentDate) {
            
            currentStreak += 1
            
            guard let previousDay = calendar.date(
                byAdding: .day,
                value: -1,
                to: currentDate
            ) else {
                break
            }
            
            currentDate = previousDay
        }
        
        DispatchQueue.main.async {
            self.streak = currentStreak
        }
        
    }
        
        func generateChartData(completions: [Completion]) {
            let calendar = Calendar.current
            let grouped = Dictionary(grouping: completions) {
                calendar.startOfDay(for: $0.date)
            }
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "sv_SE")
            formatter.dateFormat = "EEE"
            
            let chartData = grouped.map { date, completions in
                
                DailyEarning(
                    day: formatter.string(from: date),
                    amount: completions.reduce(0) {
                        $0 + $1.dailyReward
                    }
                )
            }
            .sorted { $0.day < $1.day }
            
            DispatchQueue.main.async {
                self.weeklyChartData = chartData
            }
        }
    }


