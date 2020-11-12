//
//  SportsModel.swift
//  LiveMatches
//
//  Created by Serxhio Gugo on 10/1/20.
//


import Foundation

// MARK: - SportsModel
struct SportsModel: Codable {
    
    let popular: [Popular]
    let sports: [Sports]
    
    static let defaultSportsModel = SportsModel(popular: popularDefault, sports: sportsDefault)
    static let popularDefault = [Popular(id: "0900", sportID: "N/A", title: "N/A", icon: "N/A")]
    static let sportsDefault = [Sports(id: "0900", sportID: "N/A", title: "N/A", icon: "N/A")]
}

struct Sports: Codable, Hashable {
    let id: String
    let sportID: String?
    let title, icon: String

    enum CodingKeys: String, CodingKey {
        case id
        case sportID = "sportId"
        case title, icon
    }
}

// MARK: - Popular
struct Popular: Codable, Hashable {
    let id: String
    let sportID: String?
    let title, icon: String

    enum CodingKeys: String, CodingKey {
        case id
        case sportID = "sportId"
        case title, icon
    }
    
    static let `default` = Popular(id: "0900", sportID: "N/A", title: "N/A", icon: "N/A")
}
