//
//  ContentView.swift
//  EarnQuest
//
//  Created by Mikael Engvall on 2026-04-27.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ChoreViewModel()
    
    var body: some View {
        List(viewModel.chores, id: \.id) {chore in
            Text(chore.title)
            Text("\(chore.dailyReward) kr")
        }
        .onAppear {
            viewModel.fetchChores()
        }
    }
}

#Preview {
    ContentView()
}
