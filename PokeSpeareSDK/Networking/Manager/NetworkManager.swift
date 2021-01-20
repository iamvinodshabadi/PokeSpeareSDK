//
//  NetworkManager.swift
//  PokeSpeareSDK
//
//  Created by Vinod Shabadi on 15/01/21.
//  Copyright © 2021 True Layer. All rights reserved.
//

import Foundation

enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success
    case failure(String)
}

struct NetworkManager {
    static let environment : NetworkEnvironment = .production
    static let MovieAPIKey = ""
    let router = Router<PokeSpeareApi>()

    func getPokemonList(_ searchString: String,_ completionHanlder:@escaping (PokemonListResponse?, Error?) -> Void ) {
        print("request")
        router.request(.pokemonList) { (data, response, error) in
            print("response")
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    print("success")
                    guard let responseData = data else {
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(PokemonListResponse.self, from: responseData)
                        completionHanlder(apiResponse, nil)
                    }catch {
                        print(error)
                    }
                case .failure: break
                }
            }
        }
    }

    func getPokemonSprite(_ name: String, _ completion: @escaping (_ sprite: PokemonSprite?, _ error: Error?) -> Void) {
        router.request(.pokemonSprite(name: name)) { (data, response, error) in
            if error != nil {
                completion(nil, nil)
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, error)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(PokemonSprite.self, from: responseData)
                        completion(apiResponse,nil)
                    }catch {
                        print(error)
                        completion(nil, error)
                    }
                case .failure:
                    completion(nil, error)
                }
            }
        }
    }

    func getPokemonDescription(_ name: String, _ completion: @escaping (_ sprite: PokemonDescription?, _ error: Error?) -> Void) {
        router.request(.pokemonDescription(name: name)) { (data, response, error) in
            if error != nil {
                completion(nil, nil)
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, error)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(PokemonDescription.self, from: responseData)
                        completion(apiResponse, nil)
                    }catch {
                        print(error)
                        completion(nil, error)
                    }
                case .failure:
                    completion(nil, error)
                }
            }
        }
    }

    func getShakespeareanDescription(_ text: String, _ completion: @escaping (_ sprite: ShakespeareanDescription?, _ error: Error?) -> Void) {
        router.request(.shakespeareDescription(description: text)) { (data, response, error) in
            if error != nil {
                completion(nil, nil)
            }
            print(error)
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, error)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(ShakespeareanDescription.self, from: responseData)
                        completion(apiResponse, nil)
                    }catch {
                        print(error)
                        completion(nil, error)
                    }
                case .failure:
                    completion(nil, error)
                }
            }
        }
    }

    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
