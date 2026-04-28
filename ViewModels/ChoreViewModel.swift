//
//  ChoreViewModel.swift
//  EarnQuest
//
//  Created by Mikael Engvall on 2026-04-28.
//
import SwiftUI
import Combine

class ChoreViewModel: ObservableObject {
    private let userId = "testUser"

    @Published var chores: [Chore] = []
    @Published var completedToday: Set<String> = []
    @Published var selectedChoreIDs: Set<String> = []

    private let service = FirestoreService()

    var visibleChores: [Chore] {
        chores.filter { !completedToday.contains($0.id) }
    }

    func fetchChores() {
        service.getChores { chores in
            self.service.getCompletedChoreIDs(userId: self.userId) { completedChoreIDs in
                DispatchQueue.main.async {
                    self.chores = chores
                    self.completedToday = completedChoreIDs
                }
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
        for choreID in selectedChoreIDs {
            service.saveCompletion(choreId: choreID, userId: userId)
        }

        completedToday.formUnion(selectedChoreIDs)
        selectedChoreIDs.removeAll()
    }
}
