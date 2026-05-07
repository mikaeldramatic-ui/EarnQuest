//
//  ChoreListView.swift
//  EarnQuest
//
//  Created by Mikael Engvall on 2026-05-06.
//

import SwiftUI

struct ChoreListView: View {
    
    @ObservedObject var authViewModel: AuthViewModel
    @StateObject private var viewModel: ChoreViewModel
    
    private var isChild: Bool {
        authViewModel.currentProfile?.role == .child
    }
    
    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
        
        _viewModel = StateObject(
            wrappedValue: ChoreViewModel(
                userId: authViewModel.currentProfile?.uid ?? ""
            )
        )
    }
    
    init(authViewModel: AuthViewModel, viewModel: ChoreViewModel) {
        self.authViewModel = authViewModel
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        NavigationStack {
            AppBackground {
                VStack(spacing: 24) {

                    Text("Pågående sysslor")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(AppColors.actionCard)
                        
                        
                        VStack(spacing: 24) {
                            HStack {
                                
                                Text("Sysslor")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                
                                Spacer()
                                
                                if isChild {
                                    Button {
                                        viewModel.submitChores()
                                        
                                    } label: {
                                        
                                        Text("Klart")
                                            .padding(.horizontal, 18)
                                            .padding(.vertical, 10)
                                            .background(Color.white)
                                            .foregroundColor(.black)
                                            .cornerRadius(20)
                                    }
                                }
                            }
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(AppColors.infoCard)
                                
                                if viewModel.visibleChores.isEmpty {
                                    
                                    VStack(spacing: 16) {
                                        Image(systemName: "checkmark.seal.fill")
                                            .font(.system(size: 60))
                                            .foregroundColor(.green)
                                        
                                        Text("Alla sysslor är klara!")
                                            .font(.title3)
                                            .fontWeight(.medium)
                                        
                                        Text("Bra jobbat 🎉")
                                            .foregroundColor(.gray)
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    
                                } else {
                                    
                                    VStack(spacing: 16) {
                                        
                                        ScrollView {
                                            VStack(spacing: 12) {
                                                
                                                ForEach(
                                                    viewModel.visibleChores,
                                                    id: \.id
                                                ) { chore in
                                                    
                                                    VStack(spacing: 12) {
                                                        
                                                        HStack {
                                                            
                                                            VStack(
                                                                alignment: .leading,
                                                                spacing: 4
                                                            ) {
                                                                
                                                                Text(chore.title)
                                                                    .font(.headline)
                                                                
                                                                Text("\(chore.dailyReward) kr")
                                                                    .foregroundColor(.gray)
                                                            }
                                                            
                                                            Spacer()
                                                            
                                                            Image(
                                                                systemName:
                                                                    viewModel.selectedChoreIDs.contains(chore.id)
                                                                ? "checkmark.circle.fill"
                                                                : "circle"
                                                            )
                                                            .font(.title2)
                                                            .foregroundColor(
                                                                isChild
                                                                ? (
                                                                    viewModel.selectedChoreIDs.contains(chore.id)
                                                                    ? .green
                                                                    : .gray
                                                                )
                                                                : .gray
                                                            )
                                                            .onTapGesture {
                                                                
                                                                if isChild {
                                                                    viewModel.toogleChore(
                                                                        chore: chore
                                                                    )
                                                                }
                                                            }
                                                        }
                                                        
                                                        Divider()
                                                    }
                                                }
                                            }
                                            .padding()
                                        }
                                        .background(Color.white)
                                        .cornerRadius(24)
                                        
                                        Divider()
                                        
                                        HStack {
                                            
                                            Text("Totalt:")
                                                .fontWeight(.bold)
                                            
                                            Spacer()
                                            
                                            Text(
                                                "\(viewModel.visibleChores.reduce(0) { $0 + $1.dailyReward }) kr"
                                            )
                                            .fontWeight(.bold)
                                        }
                                        .padding(.horizontal)
                                    }
                                    .padding()
                                }
                            }
                            .frame(maxHeight: 450)
                        }
                        .padding()
                    }
                    
                    Spacer(minLength: 0)
                    
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
                .padding(.top, 30)
            }
            .onAppear {
                viewModel.fetchChores()
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

    return ChoreListView(
        authViewModel: authViewModel,
        viewModel: {
            let vm = ChoreViewModel(userId: "previewUser")
            
            vm.chores = [
                Chore(
                    id: "1",
                    title: "Plocka upp kläder",
                    dailyReward: 3
                ),
                
                Chore(
                    id: "2",
                    title: "Bädda sängen",
                    dailyReward: 5
                )
            ]
            
            return vm
        }()
    )
}
