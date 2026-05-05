//
//  WeeklySummaryView.swift
//  EarnQuest
//
//  Created by Mikael Engvall on 2026-05-05.
//
import SwiftUI

@MainActor
struct WeeklySummaryView: View {
    let userId: String
    
    @ObservedObject private var viewModel: WeeklySummaryViewModel
    @ObservedObject private var choreViewModel: ChoreViewModel
    
    
    init (userId: String) {
        self.userId = userId
        _viewModel = ObservedObject(wrappedValue: WeeklySummaryViewModel(userId: userId))
        _choreViewModel = ObservedObject(wrappedValue: ChoreViewModel(userId: userId))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Veckopeng")
                .font(.title)
            
            Text("\(viewModel.totalEarnings) kr")
                .font(.largeTitle)
                .bold()
            
            Spacer()
        }
        .onAppear {
            choreViewModel.fetchChores {
                viewModel.fetchWeeklyEarnings(chores: choreViewModel.chores)
            }
            }
        }
    }

#Preview {
    WeeklySummaryView(userId: "previewUser")
}

