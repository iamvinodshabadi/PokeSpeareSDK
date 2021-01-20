//
//  PokemonDetails.swift
//  PokeSpeareSDK
//
//  Created by Vinod Shabadi on 15/01/21.
//  Copyright © 2021 True Layer. All rights reserved.
//

import Foundation

struct PokemonDescription: Decodable {
    let name: String?
    let description: String?
    
    enum PokemonDescriptionKeys: String, CodingKey {
        case contents
        case flavor_text_entries
        case flavor_text
        case name = "text"
        case description = "translated"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PokemonDescriptionKeys.self)
        let flavourText = try? container.decode([FlavourText].self, forKey: .flavor_text_entries)
        name = try? container.decode(String.self, forKey: .name)
        description = flavourText?.first(where: { (flavour) -> Bool in
            flavour.language?.name == "en"
            })?.flavoutText
    }
}

struct FlavourText: Codable {
    let flavoutText: String?
    let language: LanguageText?
    enum FlavourTextKeys: String, CodingKey {
        case flavoutText = "flavor_text"
        case language
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FlavourTextKeys.self)
        flavoutText = try? container.decode(String.self, forKey: .flavoutText)
        language = try? container.decode(LanguageText.self, forKey: .language)
    }
}

struct LanguageText: Codable {
    let name: String?
}

struct PokemonSprite: Decodable {
    let name: String?
    let spriteUrl: String?

    enum PokemonSpriteKeys: String, CodingKey {
        case sprites
        case name
        case spriteUrl = "back_default"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PokemonSpriteKeys.self)
        let dataContainer = try container.nestedContainer(keyedBy: PokemonSpriteKeys.self, forKey: .sprites)
        name = try? container.decode(String.self, forKey: .name)
        spriteUrl = try? dataContainer.decode(String.self, forKey: .spriteUrl)
    }

}

struct Pokemon: Codable {
    let name: String?
}

struct PokemonListResponse: Codable {
    let results: [Pokemon]?
    enum PokemonListResponseKey: String, CodingKey {
        case results
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PokemonListResponseKey.self)
        results = try? container.decode([Pokemon].self, forKey: .results)
    }
}

struct ShakespeareanDescription: Decodable {
    let plainDescription: String?
    let description: String?
    
    enum ShakespeareanDescriptionKeys: String, CodingKey {
        case contents
        case plainDescription = "text"
        case description = "translated"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ShakespeareanDescriptionKeys.self)
        let dataContainer = try container.nestedContainer(keyedBy: ShakespeareanDescriptionKeys.self, forKey: .contents)
        plainDescription = try? dataContainer.decode(String.self, forKey: .plainDescription)
        description = try? dataContainer.decode(String.self, forKey: .description)
    }
}
