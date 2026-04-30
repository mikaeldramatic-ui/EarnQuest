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
        VStack {
            Spacer()
            
            Text("Skapa konto")
                .font(.headline)
            
        VStack(spacing: 16) {
            
            TextField("Namn:", text: $displayName)
            TextField("Email:", text: $email)
            SecureField("Lösenord:", text: $password)
            SecureField("Bekräfta Lösenord:", text: $confirmPassword)
            
        }
        
            VStack (alignment: .leading, spacing: 12) {
                Text("Välj roll:")
                
                Button{
                    selectedRole = .admin
                } label: {
                    HStack {
                        Image(systemName: selectedRole == .admin ? "checkmark.circle.fill" :
                                "circle")
                        Text("Admin")
                        Spacer()
                    }
                }
                
                Button{
                    selectedRole = .child
                } label: {
                    HStack {
                        Image(systemName: selectedRole == .child ? "checkmark.circle.fill" :
                                "circle")
                        Text("Child")
                        Spacer()
                    }
                }
            }
            .padding(.top, 24)
            
            Spacer()
            
            Button("Skapa konto") {
                
            }
            .disabled(!isFormValid)
        }
        .padding()
    }
}

#Preview {
    let authViewModel = AuthViewModel()
    SignUpView(authViewModel: authViewModel)
}
