//
//  LoginView.swift
//  EarnQuest
//
//  Created by Mikael Engvall on 2026-04-29.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            AppBackground {
                VStack {
                    
                    DashboardCard(backgroundColor: AppColors.actionCard) {
                        VStack(spacing: 24) {
                            Text("EarnQuest")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            TextField("E-post", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                            
                            
                            SecureField("Lösenord", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            
                            if !authViewModel.errorMessage.isEmpty {
                                Text(authViewModel.errorMessage)
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                            
                            Button {
                                authViewModel.signIn(email: email, password: password)
                            } label: {
                                Text("Logga in")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(AppColors.infoCard)
                                    .cornerRadius(12)
                                    .foregroundColor(.black)
                            }
                            .disabled(authViewModel.isLoading || email.isEmpty || password.isEmpty)
                        }
                        .padding()
                    }
                    Spacer()
                    
                    DashboardCard(backgroundColor: AppColors.infoCard2) {
                        VStack(spacing: 8) {
                            Text("Har du inget konto?")
                            NavigationLink("Skapa konto") {
                                SignUpView(authViewModel: authViewModel)
                            }
                            .foregroundColor(.black)
                        }
                        .padding()
                    }
                    
                }
            }
        }
    }
}

#Preview {
    let authViewModel = AuthViewModel()
    LoginView(authViewModel: authViewModel)
}

