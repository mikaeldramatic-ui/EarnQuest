//
//  ChoreViewModel.swift
//  EarnQuest
//
//  Created by Mikael Engvall on 2026-04-28.
//
import SwiftUI
import Combine

final class ChoreViewModel: ObservableObject {
    private let userId: String
    
    init (userId: String) {
        self.userId = userId
    }
    
    @Published var chores: [Chore] = []
    @Published var completedToday: Set<String> = []
    @Published var selectedChoreIDs: Set<String> = []

    private let service = FirestoreService()

    var visibleChores: [Chore] {
        chores.filter { !completedToday.contains($0.id) }
    }

    func fetchChores(completion: (() -> Void)? = nil) {
        service.getChores { chores in
                DispatchQueue.main.async {
                    self.chores = chores
                    completion?()
                }
            }
        }
    
    func toogleChore(chore: Chore) {
        if selectedChoreIDs.contains(chore.id) {
            selectedChoreIDs.remove(chore.id)
        } else {
            selectedChoreIDs.insert(chore.id)
        }
    }
    
    func submitChores() {
        completedToday.formUnion(selectedChoreIDs)
        selectedChoreIDs.removeAll()
        
    }
}

