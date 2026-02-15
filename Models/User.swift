// User.swift
// This file defines the User data model.

import Foundation

struct User {
    var id: String
    var name: String
    var email: String
    var createdAt: Date
    
    init(id: String, name: String, email: String, createdAt: Date) {
        self.id = id
        self.name = name
        self.email = email
        self.createdAt = createdAt
    }
}