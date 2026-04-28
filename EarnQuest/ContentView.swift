//
//  ContentView.swift
//  EarnQuest
//
//  Created by Mikael Engvall on 2026-04-27.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ChoreViewModel()
    
    init(viewModel: ChoreViewModel = ChoreViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            List(viewModel.visibleChores, id: \.id) { chore in
                HStack {
                    VStack(alignment: .leading) {
                        Text(chore.title)
                        Text("\(chore.dailyReward) kr")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Image(systemName: viewModel.selectedChoreIDs.contains(chore.id) ? "checkmark.circle.fill" : "circle")
                        .onTapGesture {
                            viewModel.toogleChore(chore: chore)
                        }
                }
            }
            .navigationTitle("Chores")
            .toolbar {
                Button("Klar") {
                    viewModel.submitChores()
                }
            }
            .onAppear {
                if viewModel.chores.isEmpty {
                    viewModel.fetchChores()
                }
            }
        }
    }
}

#Preview {
    let vm = ChoreViewModel()
    vm.chores = [
        Chore(id: "1", title: "Plocka upp kläder", dailyReward: 3),
        Chore(id: "2", title: "Bädda sängen", dailyReward: 5)
    ]
    
    return ContentView(viewModel: vm)
}
