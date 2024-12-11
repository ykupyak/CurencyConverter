//
//  Currency.swift
//  Currency Converter
//
//  Created by Yaroslav Kupyak on 11.12.2024.
//

struct Currency: Codable, Equatable {
    let code: String
    let name: String
    
    var displayName: String {
        return "\(code) (\(name))"
    }
}
