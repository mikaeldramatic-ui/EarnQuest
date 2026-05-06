//
//  AppBackground.swift
//  EarnQuest
//
//  Created by Mikael Engvall on 2026-05-06.
//

import SwiftUI

struct AppBackground<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            Color.blue.opacity(0.6)
                .ignoresSafeArea()
            
            content
        }
    }
}
