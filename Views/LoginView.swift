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
            VStack {
                Spacer()
                
                VStack(spacing: 16) {
                    Text("Logga in")
                        .font(.title)
                    
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
                    
                    Button("Logga in") {
                        authViewModel.signIn(email: email, password: password)
                    }
                    .disabled(authViewModel.isLoading || email.isEmpty || password.isEmpty)
                    .padding()
                    
                }
                .padding()
                
                Spacer()
                
                VStack(spacing: 8) {
                    Text("Har du inget konto?")
                    NavigationLink("Skapa konto") {
                        SignUpView(authViewModel: authViewModel)
                        
                    }
                }
            }
            .padding()
        }
    }
}


#Preview {
    let authViewModel = AuthViewModel()
    LoginView(authViewModel: authViewModel)
}
