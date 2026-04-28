//
//  UserProfile.swift
//  EarnQuest
//
//  Created by Mikael Engvall on 2026-04-28.
//

import Foundation

enum Role {
    case admin
    case child
}

struct UserProfile {
    let uid: String
    let email: String
    let displayName: String
    let role: Role
    let familyId: String
}
