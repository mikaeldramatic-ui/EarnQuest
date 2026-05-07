//
//  ChildView.swift
//  EarnQuest
//
//  Created by Mikael Engvall on 2026-04-30.
//

import SwiftUI

struct ChildView: View {
    
    @ObservedObject var authViewModel: AuthViewModel
    @StateObject private var choreViewModel: ChoreViewModel
    
    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
        
        _choreViewModel = StateObject(
            wrappedValue: ChoreViewModel(
                userId: authViewModel.currentProfile?.uid ?? ""
            )
        )
    }
    
    var body: some View {
        
        NavigationStack {
            AppBackground {
                VStack(spacing: 24) {
                    
                    Text("Välkommen \(authViewModel.currentProfile?.displayName ?? "")")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    NavigationLink {
                        
                        ChoreListView(authViewModel: authViewModel)
                    } label: {
                        
                        DashboardCard(backgroundColor: AppColors.infoCard) {
                            
                            VStack(alignment: .leading, spacing: 12) {
                                
                                if choreViewModel.visibleChores.isEmpty {
                                    
                                    Text(
                                        "Du har inga pågående sysslor"
                                    )
                                    .font(.headline)
                                    
                                } else {
                                    Text(
                                        "Du har pågående sysslor"
                                    )
                                    .font(.headline)
                                }
                
                                Divider()
                                
                                if choreViewModel.visibleChores.isEmpty {
                                    
                                    Text("Inga nya sysslor")
                                        .font(.title3)
                                        .fontWeight(.medium)
                                        .foregroundColor(.gray)
                                } else {
                                    
                                    Text("\(choreViewModel.visibleChores.count) nya väntar")
                                        .font(.title3)
                                        .fontWeight(.medium)
                                }
                                
                                if let latestChore = choreViewModel.visibleChores.first {

                                    Text("Senaste syssla: \(latestChore.title)")
                                        .font(.caption)
                                        .foregroundColor(.gray)

                                } else {
                                    Text("Inga nya aktiviteter")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                        }
                    }
                    .foregroundColor(.black)
                    
                    HStack(spacing: 16) {
                        NavigationLink {
                            CompletedChoresView(authViewModel: authViewModel)
                        } label: {
                            DashboardCard(
                                backgroundColor: AppColors.actionCard
                            ) {
                                
                                VStack(spacing: 12) {
                                    
                                    Image(systemName: "square.and.pencil")
                                        .font(.largeTitle)
                                    
                                    Text("Se avklarade sysslor")
                                        .fontWeight(.medium)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 140)
                            }
                        }
                        .foregroundColor(.black)
                        
                        NavigationLink {
                            
                            WeeklySummaryView(userId: authViewModel.currentProfile?.uid ?? "")
                            
                        } label: {
                            
                            DashboardCard(
                                backgroundColor: AppColors.infoCard2
                            ) {
                                
                                VStack(spacing: 12) {
                                    
                                    Image(systemName: "chart.bar.fill")
                                        .font(.largeTitle)
                                    
                                    Text("Statistik")
                                        .fontWeight(.medium)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 140)
                            }
                        }
                        .foregroundColor(.black)
                    }
                    
                    
                    Spacer()
                    
                    Button {
                        authViewModel.signOut()
                        
                    } label: {
                        
                        Text("Logga ut")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppColors.logout)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 40)
                
                .onAppear {
                    choreViewModel.fetchChores()
                }
            }
        }
    }
}


#Preview {
    
    let authViewModel: AuthViewModel = {
        
        let viewModel = AuthViewModel()
        
        viewModel.currentProfile = UserProfile(
            uid: "previewChild",
            email: "admin@example.com",
            displayName: "Child",
            role: .child,
            familyId: "family_1"
        )
        
        return viewModel
    }()
    
    return ChildView(authViewModel: authViewModel)
}
