//
//  Model.swift
//  dictionary
//
//  Created by Bekpayev Dias on 19.08.2023.
//

import Foundation

struct TranslationResponse: Codable {
    let def: [Definition]
}

struct Definition: Codable {
    let tr: [Translation]
}

struct Translation: Codable {
    let text: String
}
