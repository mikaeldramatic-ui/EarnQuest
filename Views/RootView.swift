//
//  Root​View.swift
//  EarnQuest
//
//  Created by Mikael Engvall on 2026-04-29.
//

import SwiftUI

struct RootView: View {
    
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        if authViewModel.isLoading {
            ProgressView("Laddar...")
        } else if authViewModel.currentUser == nil {
            Text("Visa LoginView här")
        } else if let profile = authViewModel.currentProfile {
            switch profile.role {
            case .admin:
                Text("Visa AdminView här")
            case .child:
                ContentView()
            }
        }
        else {
            ProgressView("Laddar profil...")
        }
        
    }
}
