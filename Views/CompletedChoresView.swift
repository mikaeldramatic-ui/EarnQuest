//
//  CompletedChoresView.swift
//  EarnQuest
//
//  Created by Mikael Engvall on 2026-05-06.
//

import SwiftUI

struct CompletedChoresView: View {
    
    @ObservedObject var authViewModel: AuthViewModel
    @State private var completions: [Completion] = []
    
    private let service = FirestoreService()
    
    private var groupedCompletions: [String: [Completion]] {
        
        Dictionary(grouping: completions) { completion in
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            
            return formatter.string(from: completion.date)
        }
    }
    
    var body: some View {
        
        NavigationStack {
            AppBackground {
                VStack(spacing: 24) {
                    Text("Klara sysslor")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(
                                groupedCompletions.keys.sorted(by: >),
                                id: \.self
                            ) { dateKey in
                                if let completionsForDay = groupedCompletions[dateKey] {
                                    
                                    DashboardCard(
                                        backgroundColor: AppColors.infoCard
                                    ) {
                                        VStack(
                                            alignment: .leading,
                                            spacing: 16
                                        ) {
                                            
                                            Text(dateKey)
                                                .font(.headline)
                                            
                                            Divider()
                                            
                                            ForEach(completionsForDay) { completion in
                                                
                                                VStack(spacing: 12) {
                                                    
                                                    HStack {
                                                        
                                                        VStack(
                                                            alignment: .leading,
                                                            spacing: 4
                                                        ) {
                                                            
                                                            Text(completion.title)
                                                                .font(.headline)
                                                            
                                                            Text(
                                                                "\(completion.dailyReward) kr"
                                                            )
                                                            .foregroundColor(.gray)
                                                        }
                                                        
                                                        Spacer()
                                                        
                                                        Image(
                                                            systemName: "checkmark.circle.fill"
                                                        )
                                                        .foregroundColor(.green)
                                                        .font(.title2)
                                                    }
                                                    
                                                    Divider()
                                                }
                                            }
                                        }
                                        .padding()
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 30)
            }
            .onAppear {
                service.getCompletions(
                    userId: authViewModel.currentProfile?.uid ?? ""
                ) { completions in
                    
                    DispatchQueue.main.async {
                        self.completions = completions
                    }
                }
            }
        }
    }
}

#Preview {
    
    let authViewModel = AuthViewModel()
    
    authViewModel.currentProfile = UserProfile(
        uid: "previewUser",
        email: "child@example.com",
        displayName: "Micke",
        role: .child,
        familyId: "family_1"
    )
    
    return CompletedChoresView(
        authViewModel: authViewModel
    )
}


