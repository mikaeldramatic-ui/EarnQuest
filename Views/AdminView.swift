import SwiftUI

struct AdminView: View {
    @ObservedObject var authViewModel: AuthViewModel
    private let service = FirestoreService()
    
    @State private var draftChores: [(title: String, reward: Int)] = []
    @State private var title = ""
    @State private var dailyReward = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                Text("Skapa chores")
                    .font(.headline)
                
                TextField("Titel på chore", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Daglig belöning", text: $dailyReward)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                
                Button("Lägg till chore") {
                    guard let reward = Int(dailyReward) else { return }
                    
                    draftChores.append((title: title, reward: reward))
                    
                    title = ""
                    dailyReward = ""
                }
                .disabled(title.isEmpty || dailyReward.isEmpty)
                
                if !draftChores.isEmpty {
                    List {
                        ForEach(draftChores.indices, id: \.self) { index in
                            HStack {
                                Text(draftChores[index].title)
                                Spacer()
                                Text("\(draftChores[index].reward) kr")
                            }
                        }
                        .onDelete { indexSet in
                            draftChores.remove(atOffsets: indexSet)
                        }
                    }
                    .frame(height: 200)
                }
                
                Button("Skicka alla chores") {
                    for chore in draftChores {
                        service.addChore(
                            title: chore.title,
                            dailyReward: chore.reward
                        )
                    }
                    
#if targetEnvironment(simulator)
                    NotificationManager.shared.scheduleNow(
                        title: "Nya sysslor",
                        body: "Du har fått \(draftChores.count) nya sysslor."
                    )
#endif
                    
                    draftChores.removeAll()
                }
                .disabled(draftChores.isEmpty)
                
                Spacer()
                
                Divider()
                
                Button("Logga ut") {
                    authViewModel.signOut()
                }
                .padding()
            }
            .padding()
            .navigationTitle("Admin")
        }
    }
}

#Preview {
    let authViewModel: AuthViewModel = {
        let viewModel = AuthViewModel()
        viewModel.currentProfile = UserProfile(
            uid: "previewAdmin",
            email: "admin@example.com",
            displayName: "Admin",
            role: .admin,
            familyId: "family_1"
        )
        return viewModel
    }()

    AdminView(authViewModel: authViewModel)
}
