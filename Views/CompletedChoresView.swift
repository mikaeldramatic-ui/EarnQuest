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
    
    var body: some View {
        
        NavigationStack {
            AppBackground {
                VStack(spacing: 24) {
                    
                    Text("Klara sysslor")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(completions) {completion in
                                
                                DashboardCard(
                                    backgroundColor: AppColors.infoCard
                                ) {
                                    HStack {
                                        
                                        VStack(
                                            alignment: .leading,
                                            spacing: 8
                                        ) {
                                            
                                            Text("Chore ID:")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                            
                                            Text(completion.choreId)
                                                .font(.headline)
                                        }
                                        Spacer()
                                        
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                            .font(.title2)
                                    }
                                    .padding()
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


