//
//  PokeSpereEndPoint.swift
//  PokeSpeareSDK
//
//  Created by Vinod Shabadi on 15/01/21.
//  Copyright © 2021 True Layer. All rights reserved.
//

import Foundation

enum NetworkEnvironment {
    case qa
    case production
    case staging
}

enum PokeSpeareApi {
    case pokemonList
    case pokemonDescription(name: String)
    case pokemonSprite(name: String)
    case shakespeareDescription(description :String)
}

extension PokeSpeareApi: EndPointType {
    
    var environmentBaseURL : String {
        switch self {
        case .pokemonList,
             .pokemonDescription,
             .pokemonSprite:
            switch NetworkManager.environment {
            case .production,
                 .qa,
                 .staging:
                return "https://pokeapi.co/api/v2/"
            }
        case .shakespeareDescription:
            switch NetworkManager.environment {
            case .production,
                 .qa,
                 .staging:
                return "https://api.funtranslations.com/translate/shakespeare.json"
            }
        }
    }

    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }

    var path: String {
        switch self {
        case .pokemonDescription(let name):
            return "pokemon-species/\(name.lowercased())"
        case .pokemonSprite(let name):
            return "pokemon/\(name.lowercased())"
        case .shakespeareDescription:
            return ""
        case .pokemonList:
            return "pokemon"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .pokemonList,
             .pokemonDescription,
             .pokemonSprite:
            return .get
        case .shakespeareDescription:
            return .post
        }
    }

    var task: HTTPTask {
        //limit=2000&offset=0
        switch self {
        case .pokemonList:
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["limit": 2000, "offset":0])
        case .pokemonDescription,
             .pokemonSprite:
            return .request
        case .shakespeareDescription(let description):
            return .requestParametersAndHeaders(bodyParameters: ["text": description], bodyEncoding: .urlAndJsonEncoding, urlParameters: nil, additionHeaders: ["X-Funtranslations-Api-Secret":"<api_key>"])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
