//
//  PokemonModels.swift
//  PokeSpeareSDK
//
//  Created by Vinod Shabadi on 17/01/21.
//  Copyright © 2021 True Layer. All rights reserved.
//

import Foundation
struct PokemonDescriptionModel {
    public let name: String?
    public let description: String?
}

struct PokemonSpriteModel {
    public let name: String?
    public let spriteUrl: String?
}

struct ShakespearenDescriptionModel {
    public let text: String?
    public let description: String?
}

public struct PokeSpeareModel {
    public let spriteUrl: String?
    public let description: String?
}
