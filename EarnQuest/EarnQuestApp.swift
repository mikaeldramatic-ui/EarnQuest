//
//  EarnQuestApp.swift
//  EarnQuest
//
//  Created by Mikael Engvall on 2026-04-27.
//
import Firebase
import SwiftUI

@main
struct EarnQuestApp: App {
    
    init () {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
