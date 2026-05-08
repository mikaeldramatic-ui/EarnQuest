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
    private let userName: String
    
    init (userId: String, userName: String = "Barnet") {
        self.userId = userId
        self.userName = userName
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
                
                self.service.getCompletedChoreIDs(
                    userId: self.userId
                ) { completedIDs in
                    
                    DispatchQueue.main.async {
                        self.completedToday = completedIDs
                        
                        completion?()
                    }
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
        
        for chore in chores where selectedChoreIDs.contains(chore.id) {
            
            service.saveCompletion(
                chore: chore,
                userId: userId
            )
            
            service.deleteChore(
                choreId: chore.id
            )
        }
        
        
        
        chores.removeAll { chore in
            selectedChoreIDs.contains(chore.id)
        }
        
#if targetEnvironment(simulator)
        
        NotificationManager.shared.scheduleNow(
            title: "Sysslor klara",
            body: "\(userName) har slutfört \(selectedChoreIDs.count) syssla/sysslor."
        )
        
#endif
        
        selectedChoreIDs.removeAll()
    }
}

