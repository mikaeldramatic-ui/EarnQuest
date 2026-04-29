//
//  Auth​View​Model.swift
//  EarnQuest
//
//  Created by Mikael Engvall on 2026-04-28.
//
import Combine
import Foundation
import FirebaseAuth
import FirebaseFirestore


class AuthViewModel: ObservableObject {
    private let db = Firestore.firestore()
    
    @Published var currentUser: User?
    @Published var currentProfile: UserProfile?
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    func signIn(email: String, password: String) {
        isLoading = true
        errorMessage = ""
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                guard let user = result?.user else {
                    self.errorMessage = "Kunde inte hämta användaren."
                    return
                }

                self.currentUser = user
                self.fetchUserProfile(uid: user.uid)
            }
        }
    }
    
    func fetchUserProfile(uid: String) {
        errorMessage = ""
        
        db.collection("users").document(uid).getDocument { snapshot, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                guard let data = snapshot?.data() else {
                    self.errorMessage = "Kunde inte hitta användarprofilen."
                    return
                }
                
                guard
                    let email = data["email"] as? String,
                    let displayName = data["displayName"] as? String,
                    let roleString = data["role"] as? String,
                    let familyId = data["familyId"] as? String
                else {
                    self.errorMessage = "Användarprofilen saknar data."
                    return
                }
                
                let role: Role
                
                switch roleString {
                case "admin":
                    role = .admin
                case "child":
                    role = .child
                default:
                    self.errorMessage = "Ogiltig användarroll."
                    return
                }
                
                let profile = UserProfile(
                    uid: uid,
                    email: email,
                    displayName: displayName,
                    role: role,
                    familyId: familyId
                )
                
                self.currentProfile = profile
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            currentUser = nil
            currentProfile = nil
            errorMessage = ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
