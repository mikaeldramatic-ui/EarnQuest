//
//  AdminView.swift
//  EarnQuest
//
//  Created by Mikael Engvall on 2026-04-29.
//

import SwiftUI

struct AdminView: View {
    @ObservedObject var authViewModel: AuthViewModel
    private let service = FirestoreService()
    
    @State private var title = ""
    @State private var dailyReward = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Skapa en chore")
                    .font(.headline)

                TextField("Titel på chore", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Daglig belöning", text: $dailyReward)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                
                Button("Spara chore") {
                    guard let reward = Int(dailyReward) else {
                        return
                    }
                    service.addChore(title: title, dailyReward: reward)
                    title = ""
                    dailyReward = ""
                    
                }
                .disabled(title.isEmpty || dailyReward.isEmpty)
            }
            .navigationTitle("Admin")
            .toolbar {
                Button("Logga ut") {
                    authViewModel.signOut()
                }
            }
        }
            
    }
        
}
