////
////  Event.swift
////  Group_06_Events
////
////  Created by Darren Eddy on 2024-03-11.
////

import Foundation

struct Events: Codable,Hashable {
    let events :[Event]
    enum CodingKeys:String,CodingKey{ case events }
}

struct Event: Codable,Hashable{
    var id: Int
    let venue: Venue
    let title: String
    let datetime_utc : String
    let description: String
    let performers: [Performer]
   
    enum CodingKeys:String, CodingKey {
        case id,venue,title,description,datetime_utc,performers
    }
    }

struct Performer:Codable,Hashable {
    let image : String
    
    enum CodingKeys:String, CodingKey {
        case image
    }
}

struct Location:Codable,Hashable {
    let lat, lon: Double
}

struct Venue:Codable,Hashable {
    var id: Int
    let state: String
    let name: String
    let location: Location
    let address: String?
    let country: String
    let city: String
    
    enum CodingKeys:String, CodingKey {
        case id,state,name,location,address,country,city
    }

}

struct VenueAnnotation: Identifiable {
    let id: Int
    let venue: Venue
}
