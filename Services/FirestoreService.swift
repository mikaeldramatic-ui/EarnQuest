//
//  FirestoreService.swift
//  EarnQuest
//
//  Created by Mikael Engvall on 2026-04-27.
//
import FirebaseFirestore
import Foundation

class FirestoreService {
    private let db = Firestore.firestore()
    
    func getChores(completion: @escaping ([Chore]) -> Void) {
        db.collection("chores").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                completion([])
                return
            }
            var chores: [Chore] = []
            for document in documents {
                let data = document.data()
                
                let title = data["title"] as? String ?? ""
                let dailyReward = data["dailyReward"] as? Int ?? 0
                
                let chore = Chore(
                    
                    id: document.documentID,
                    title: title,
                    dailyReward: dailyReward
                )
                chores.append(chore)
            }
            completion(chores)
            
        }
    }
    
    func saveCompletion(choreId: String, userId: String) {
        let data: [String: Any] = [
            "choreId": choreId,
            "userId": userId,
            "date": Date()
        ]
        db.collection("completions").addDocument(data: data)
    }
}
