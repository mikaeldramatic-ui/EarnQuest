import SwiftUI

struct AdminView: View {
    
    @ObservedObject var authViewModel: AuthViewModel
    @StateObject private var choreViewModel: ChoreViewModel
    @State private var childName = "Barnet"
    
    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
        
        _choreViewModel = StateObject(
            wrappedValue: ChoreViewModel(
                userId: authViewModel.currentProfile?.uid ?? ""
            )
        )
    }
    
    var body: some View {
        
        NavigationStack {
            AppBackground {
                VStack(spacing: 24) {
                    
                    Text("Admin Vy")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    NavigationLink {
                        
                        ChoreListView(authViewModel: authViewModel)
                        
                    } label: {
                        
                        DashboardCard(backgroundColor: AppColors.infoCard) {
                            
                            VStack(alignment: .leading, spacing: 12) {
                                
                                Text(
                                    choreViewModel.visibleChores.isEmpty
                                    ? "\(childName) har inga pågående sysslor"
                                    : "\(childName) har pågående sysslor"
                                )
                                .font(.headline)
                                
                                Divider()
                                
                                if choreViewModel.visibleChores.isEmpty {
                                    
                                    Text("Inga nya sysslor")
                                        .font(.title3)
                                        .fontWeight(.medium)
                                        .foregroundColor(.gray)

                                } else if choreViewModel.visibleChores.count == 1 {
                                    
                                    Text("1 ny syssla")
                                        .font(.title3)
                                        .fontWeight(.medium)

                                } else {
                                    
                                    Text("\(choreViewModel.visibleChores.count) nya sysslor")
                                        .font(.title3)
                                        .fontWeight(.medium)
                                }
                                
                                if let latestChore = choreViewModel.visibleChores.first {

                                                Text("Senaste syssla: \(latestChore.title)")
                                                    .font(.caption)
                                                    .foregroundColor(.gray)

                                            } else {

                                                Text("Inga nya aktiviteter")
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding()
                                    }
                                }
                                .foregroundColor(.black)
                        
                        HStack(spacing: 16) {
                            NavigationLink {
                                
                                CreateChoreView(authViewModel: authViewModel)
                            } label: {
                                DashboardCard(
                                    backgroundColor: AppColors.actionCard
                                ) {
                                    
                                    VStack(spacing: 12) {
                                        
                                        Image(systemName: "square.and.pencil")
                                            .font(.largeTitle)
                                        
                                        Text("Skapa sysslor")
                                            .fontWeight(.medium)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 140)
                                }
                            }
                            .foregroundColor(.black)
                            
                            NavigationLink {
                                
                                WeeklySummaryView(userId: "testUser")
                                
                            } label: {
                                
                                DashboardCard(
                                    backgroundColor: AppColors.infoCard2
                                ) {
                                    
                                    VStack(spacing: 12) {
                                        
                                        Image(systemName: "chart.bar.fill")
                                            .font(.largeTitle)
                                        
                                        Text("Statistik")
                                            .fontWeight(.medium)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 140)
                                }
                            }
                            .foregroundColor(.black)
                        }
                        
                        
                        Spacer()
                        
                        Button {
                            authViewModel.signOut()
                            
                        } label: {
                            
                            Text("Logga ut")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppColors.logout)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 40)
                }
            .onAppear {
                choreViewModel.fetchChores()

                FirestoreService().getChildUser { child in

                    DispatchQueue.main.async {
                        childName = child?.displayName ?? "Barnet"
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
        
        return AdminView(authViewModel: authViewModel)
    }
    

