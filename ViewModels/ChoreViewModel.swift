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
    
    private let service = FirestoreService()
    
    func fetchChores() {
        service.getChores { chores in
            DispatchQueue.main.async {
                self.chores = chores
                
            }
        }
    }
}
