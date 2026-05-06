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
        
        NavigationStack {
            AppBackground {
                VStack(spacing: 24) {
                    
                    Text("Veckostatistik")
                        .font(.largeTitle)
                        .fontWeight(.bold)
    
                    DashboardCard(backgroundColor: AppColors.infoCard) {
                        VStack(spacing: 16) {
                            
                            Text("Veckopeng")
                                .font(.headline)
                            
                            Text("\(viewModel.totalEarnings) kr")
                                .font(.system(size: 52, weight: .bold))
                            
                            Text("Intjänat senaste 7 dagarna")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                        .padding()
                    }

                    DashboardCard(backgroundColor: AppColors.infoCard2) {
                        VStack(spacing: 12) {
                            
                            Image(systemName: "star.fill")
                                .font(.largeTitle)
                                .foregroundColor(.yellow)
                            
                            
                            Text("Bra jobbat!")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            
                            Text(
                                "Du har gjort klart flera sysslor denna vecka."
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                        }
                        .padding()
                    }
                    
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 40)
            }
            .onAppear {
                
                choreViewModel.fetchChores()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    
                    viewModel.fetchWeeklyEarnings(
                        chores: choreViewModel.chores
                    )
                }
            }
        }
    }
    }

#Preview {
    WeeklySummaryView(userId: "previewUser")
}

