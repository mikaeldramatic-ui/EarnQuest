import SwiftUI

struct AdminView: View {
    
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        
        NavigationStack {
            AppBackground {
                VStack(spacing: 24) {
                    
                    Text("Admin Vy")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    DashboardCard(backgroundColor: AppColors.infoCard) {
                        
                        VStack(alignment: .leading, spacing: 12) {
                            
                            Text("Childs pågående sysslor")
                                .font(.headline)
                            
                            Divider()
                            
                            Text("2 sysslor väntar")
                            
                            Text("Senaste aktivitet: Städat badrum")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    }
                    
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
