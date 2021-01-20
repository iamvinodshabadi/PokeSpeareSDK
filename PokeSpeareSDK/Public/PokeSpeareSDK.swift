//
//  PokeSpeareSDK.swift
//  PokeSpeareSDK
//
//  Created by Vinod Shabadi on 16/01/21.
//  Copyright © 2021 True Layer. All rights reserved.
//

import Foundation
import UIKit

public class PokeSpeareSDK {
    public static let instance = PokeSpeareSDK()
    private init(){}
    private var pokemonList: [Pokemon]?
    private let networkManager = NetworkManager()
    func descriptionOfPokemon(_ name: String,
                                     _ completionHandler:
        @escaping (_ description: PokemonDescriptionModel?, _ error: Error?) -> Void) {
        networkManager.getPokemonDescription(name) { (description, error) in
            var model: PokemonDescriptionModel?
            if error == nil {
                model = PokemonDescriptionModel(name: name, description: description?.description)
            }
            completionHandler(model, error)
        }
    }

    func spriteOfPokemon(_ name: String,
                                 _ completionHandler:
    @escaping (_ description: PokemonSpriteModel?, _ error: Error?) -> Void) {
        networkManager.getPokemonSprite(name) { (sprite, error) in
            var model: PokemonSpriteModel?
            if error == nil {
                model = PokemonSpriteModel(name: name, spriteUrl: sprite?.spriteUrl)
            }
            completionHandler(model, error)
        }
    }

    public func displayPokemonDetails(_ description: String?, _ sprite: UIImage?) {
    }

    public func searchPokemon(_ name: String, _ completion: @escaping(PokeSpeareModel?, Error?)-> Void) {
        
        var model: PokemonDescriptionModel?
        self.networkManager.getShakespeareanDescription(name) { (shakesDescription, error) in
            if error == nil {
                model = PokemonDescriptionModel(name: name, description: shakesDescription?.description)
            }
            print("model")
            print(model)
        }
        return
        
        if pokemonList == nil {
            networkManager.getPokemonList("") { [weak self] (list, error) in
                self?.pokemonList = list?.results
                print("list is here")
                self?.searchForName(name, completion)
                
            }
        } else {
            searchForName(name, completion)
        }
    }

    func searchForName(_ name: String, _ completion: @escaping(PokeSpeareModel?, Error?)-> Void) {
        if let pokemon = pokemonList?.filter({ (pokemon) -> Bool in
            pokemon.name?.lowercased() == name.lowercased()
        }).first,
            let name = pokemon.name {
            print("now call two apis")
            let group = DispatchGroup()
            let queue = DispatchQueue(label: "com.truelayer.app.queue", attributes: .concurrent)
            
            var model: PokemonDescriptionModel?
            group.enter()
            print("entering 1")
            queue.async {
                self.networkManager.getPokemonDescription(name) { (description, error) in
                    let text = description?.description ?? ""
                    let test = String(text.filter { !" \n\t\r".contains($0) })

                    self.networkManager.getShakespeareanDescription(test) { (shakesDescription, error) in
                        if error == nil {
                            model = PokemonDescriptionModel(name: name, description: shakesDescription?.description)
                        }
                        print("leaving 1")
                        print(model)
                        group.leave()
                    }
                }
            }
            var spriteModel: PokemonSpriteModel?
            group.enter()
            print("entering 2")
            queue.async {
                self.networkManager.getPokemonSprite(name) { (sprite, error) in
                    if error == nil {
                        spriteModel = PokemonSpriteModel(name: name, spriteUrl: sprite?.spriteUrl)
                    }
                    print(spriteModel)
                    print("leaving 2")
                    group.leave()
                }
            }


            queue.async {
                group.wait()
                let pokeSpeareModel = PokeSpeareModel(spriteUrl: spriteModel?.spriteUrl,
                                                      description: model?.description)
                completion(pokeSpeareModel, nil)
            }


        } else {
            completion(nil, nil)
        }
    }
}
