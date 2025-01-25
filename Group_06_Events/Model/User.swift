//
//  User.swift
//  Group_06_Events
//
//  Created by Darren Eddy on 2024-03-11.
//
import Foundation

class User: Codable, Identifiable {
    
    var id: String
    var email: String
    var name: String
    var favourites: [Event]
    var friends: [User]
    var gender: Gender // New property for gender
    
    // Enum to represent gender options
    enum Gender: String, Codable {
        case male
        case female
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, email, name, favourites, friends, gender
    }
    
    init(id: String, email: String, name: String, gender: Gender) {
        self.id = id
        self.email = email
        self.name = name
        self.gender = gender // Initialize gender
        self.favourites = [Event]()
        self.friends = [User]()
    }
    
    // Implement the required initializer from Decoder
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.email = try container.decode(String.self, forKey: .email)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.gender = try container.decode(Gender.self, forKey: .gender) // Decode gender
        self.favourites = try container.decode([Event].self, forKey: .favourites)
        self.friends = try container.decode([User].self, forKey: .friends)
    }
    
    static func generateRandomPassword() -> String {
        let chars = "ABCDEFGHJKLMNOPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz00112233445566778899"
        let len = 8
        let rndPswd = String((0..<len).compactMap { _ in chars.randomElement() })
        return rndPswd
    }
}

