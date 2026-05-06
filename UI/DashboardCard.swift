//
//  DashboardCard.swift
//  EarnQuest
//
//  Created by Mikael Engvall on 2026-05-06.
//

import SwiftUI

struct DashboardCard<Content: View>: View {
    let content: Content
    var backgroundColor: Color
    
    init(backgroundColor: Color, @ViewBuilder content: () -> Content) {
        self.backgroundColor = backgroundColor
        self.content = content()
    }
    
    var body : some View {
        content
            .frame(maxWidth: .infinity, minHeight: 120)
            .padding()
            .background(backgroundColor)
            .cornerRadius(16)
    }
}
