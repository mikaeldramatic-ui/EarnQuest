//
//  SignUpView.swift
//  EarnQuest
//
//  Created by Mikael Engvall on 2026-04-30.
//

import SwiftUI

struct SignUpView: View {
    
    @ObservedObject var authViewModel: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var displayName = ""
    @State private var confirmPassword = ""
    
    @State private var selectedRole: Role = .child
    
    var isFormValid: Bool {
        !displayName.isEmpty &&
        !email.isEmpty &&
        !password.isEmpty &&
        password == confirmPassword
    }
    
    var body: some View {
        
        NavigationStack {
            
            AppBackground {
                
                VStack(spacing: 24) {
                    
                    DashboardCard(backgroundColor: AppColors.infoCard) {
                        VStack(spacing: 16) {
                            
                            Text("Skapa konto")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            TextField("Namn", text: $displayName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            TextField("E-post", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                            
                            SecureField("Lösenord", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            SecureField("Bekräfta lösenord", text: $confirmPassword)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                
                            VStack(alignment: .leading, spacing: 12) {
                                
                                Text("Välj roll")
                                    .fontWeight(.medium)
                                
                                HStack(spacing: 16) {
                                    
                                    Button {
                                        selectedRole = .admin
                                        
                                    } label: {
                                        Text("Vuxen")
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(
                                                selectedRole == .admin
                                                ? AppColors.actionCard
                                                : Color.white.opacity(0.7)
                                            )
                                            .foregroundColor(.black)
                                            .cornerRadius(12)
                                    }
                                    
                                    
                                    Button {
                                        selectedRole = .child
                                        
                                    } label: {
                                        Text("Barn")
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(
                                                selectedRole == .child
                                                ? AppColors.actionCard
                                                : Color.white.opacity(0.7)
                                            )
                                            .foregroundColor(.black)
                                            .cornerRadius(12)
                                    }
                                }
                            }
                            .padding(.top, 8)
                            
                            
                            // ERROR MESSAGE
                            if !authViewModel.errorMessage.isEmpty {
                                Text(authViewModel.errorMessage)
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                            
                            
                            // CREATE ACCOUNT BUTTON
                            Button {
                                
                                authViewModel.signUp(
                                    email: email,
                                    password: password,
                                    displayName: displayName,
                                    role: selectedRole
                                )
                                
                            } label: {
                                
                                Text(
                                    authViewModel.isLoading
                                    ? "Laddar..."
                                    : "Skapa konto"
                                )
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppColors.infoCard2)
                                .foregroundColor(.black)
                                .cornerRadius(12)
                            }
                            .disabled(
                                !isFormValid ||
                                authViewModel.isLoading
                            )
                        }
                        .padding()
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 60)
            }
        }
    }
}

#Preview {
    let authViewModel = AuthViewModel()
    SignUpView(authViewModel: authViewModel)
}
