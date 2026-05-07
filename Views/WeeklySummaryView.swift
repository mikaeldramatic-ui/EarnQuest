//
//  WeeklySummaryView.swift
//  EarnQuest
//
//  Created by Mikael Engvall on 2026-05-05.
//
import SwiftUI
import Charts


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
                        
                        VStack(spacing: 16) {
                            
                            Image(systemName: "flame.fill")
                                .font(.system(size: 42))
                                .foregroundColor(.orange)
                            
                            Text("\(viewModel.streak) dagar")
                                .font(.system(size: 42, weight: .bold))
                            
                            Text("Nuvarande streak")
                                .font(.headline)
                            
                            Text(
                                viewModel.streak == 0
                                ? "Ingen aktiv streak"
                                : "Fortsätt så här!"
                            )
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        }
                        .padding()
                    }
                    .frame(height: 260)
                    
                    DashboardCard(backgroundColor: AppColors.actionCard) {
                        VStack(alignment: .leading, spacing: 16) {

                            Text("Veckoöversikt")
                                .font(.headline)
                            
                            Chart(viewModel.weeklyChartData) { item in
                            
                                BarMark(
                                    x: .value("Dag", item.day),
                                    y: .value("Kr", item.amount)
                                )
                            }
                            .frame(height: 220)
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

