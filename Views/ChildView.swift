//
//  ChildView.swift
//  EarnQuest
//
//  Created by Mikael Engvall on 2026-04-30.
//

import SwiftUI

struct ChildView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @StateObject private var viewModel: ChoreViewModel
    
    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
        _viewModel = StateObject(
            wrappedValue: ChoreViewModel(userId: authViewModel.currentProfile?.uid ?? "")
        )
    }
    
    init(authViewModel: AuthViewModel, viewModel: ChoreViewModel) {
        self.authViewModel = authViewModel
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                List(viewModel.visibleChores, id: \.id) { chore in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(chore.title)
                            Text("\(chore.dailyReward) kr")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Image(systemName: viewModel.selectedChoreIDs.contains(chore.id) ? "checkmark.circle.fill" : "circle")
                            .onTapGesture {
                                viewModel.toogleChore(chore: chore)
                            }
                    }
                }
                
                Divider()
                
                Button("Logga ut") {
                    authViewModel.signOut()
                }
                .padding()
            }
            .navigationTitle("Chores")
            .toolbar {
                Button("Klar") {
                    viewModel.submitChores()
                }
            }
                .onAppear {
                    if viewModel.chores.isEmpty {
                        viewModel.fetchChores()
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

    let choreViewModel = ChoreViewModel(userId: "previewUser")
    choreViewModel.chores = [
        Chore(id: "1", title: "Plocka upp kläder", dailyReward: 3),
        Chore(id: "2", title: "Bädda sängen", dailyReward: 5)
    ]

    return ChildView(authViewModel: authViewModel, viewModel: choreViewModel)
}
