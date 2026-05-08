import SwiftUI

struct CreateChoreView: View {
    
    @ObservedObject var authViewModel: AuthViewModel
    
    private let service = FirestoreService()
    
    @State private var draftChores: [(title: String, reward: Int)] = []
    
    @State private var title = ""
    @State private var dailyReward = ""
    @State private var childName = "Barnet"
    
    var body: some View {
        
        NavigationStack {
            
            AppBackground {
                
                VStack(spacing: 24) {
                    
                    // TITLE
                    Text("Skapa sysslor")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    DashboardCard(backgroundColor: AppColors.infoCard) {
                        
                        VStack(spacing: 16) {
                            
                            TextField("Titel på syssla", text: $title)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            TextField("Daglig belöning", text: $dailyReward)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                            
                            
                            Button {
                                
                                guard let reward = Int(dailyReward) else {
                                    return
                                }
                                
                                draftChores.append((
                                    title: title,
                                    reward: reward
                                ))
                                
                                title = ""
                                dailyReward = ""
                                
                            } label: {
                                
                                Text("Lägg till syssla")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(AppColors.actionCard)
                                    .foregroundColor(.black)
                                    .cornerRadius(12)
                            }
                            .disabled(
                                title.isEmpty ||
                                dailyReward.isEmpty
                            )
                        }
                        .padding()
                    }
                    
                    DashboardCard(backgroundColor: AppColors.infoCard2) {
                        
                        VStack(alignment: .leading, spacing: 12) {
                            
                            Text("Pågående lista")
                                .font(.headline)
                            
                            
                            if draftChores.isEmpty {
                                
                                Text("Inga sysslor tillagda ännu")
                                    .foregroundColor(.gray)
                                
                            } else {
                                
                                ForEach(draftChores.indices, id: \.self) { index in
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(draftChores[index].title)
                                                .fontWeight(.medium)
                                            
                                            Text("\(draftChores[index].reward) kr")
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        Button {
                                            
                                            draftChores.remove(at: index)
                                            
                                            
                                            
                                        } label: {
                                            
                                            
                                            
                                            Image(systemName: "trash.fill")
                                            
                                                .foregroundColor(.red)
                                            
                                        }
                                        
                                    }
                                    
                                    
                                    
                                    Divider()
                                    
                                }
                                
                                
                                HStack {
                                    
                                    Text("Totalt:")
                                        .fontWeight(.bold)
                                    
                                    Spacer()
                                    
                                    Text(
                                        "\(draftChores.reduce(0) { $0 + $1.reward }) kr"
                                    )
                                    .fontWeight(.bold)
                                }
                            }
                        }
                        .padding()
                    }
                    
                    Button {
                        
                        for chore in draftChores {
                            
                            service.addChore(
                                title: chore.title,
                                dailyReward: chore.reward
                            )
                        }
                        
#if targetEnvironment(simulator)
                        NotificationManager.shared.scheduleNow(
                            title: "Nya sysslor",
                            body: "\(childName) har fått \(draftChores.count) nya sysslor."
                        )
#endif
                        
                        draftChores.removeAll()
                        
                    } label: {
                        
                        Text("Skicka lista")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppColors.actionCard)
                            .foregroundColor(.black)
                            .cornerRadius(12)
                    }
                    .disabled(draftChores.isEmpty)
                    
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 40)
                
                .onAppear {
                    service.getChildUser {child in
                    
                        DispatchQueue.main.async {
                            childName = child?.displayName ?? "Barnet"
                        }
                    }
                }
            }
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
    
    return CreateChoreView(authViewModel: authViewModel)
}
