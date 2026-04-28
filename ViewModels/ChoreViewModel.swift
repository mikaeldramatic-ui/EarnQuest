//
//  ChoreViewModel.swift
//  EarnQuest
//
//  Created by Mikael Engvall on 2026-04-28.
//
import SwiftUI
import Combine

class ChoreViewModel: ObservableObject {
    
    @Published var chores: [Chore] = []
    @Published var completedToday: Set<String> = []
    
    private let service = FirestoreService()
    
    func fetchChores() {
        service.getChores { chores in
            DispatchQueue.main.async {
                self.chores = chores
                
            }
        }
    }
    
    func completeChore(chore: Chore) {
        completedToday.insert(chore.id)
        service.saveCompletion(choreId: chore.id, userId: "testUser")
    }
}
