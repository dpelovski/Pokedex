//
//  Pokemon.swift
//  Pokedex
//
//  Created by Damian Pelovski on 3/20/17.
//  Copyright © 2017 Damian Pelovski. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    //fields for all the things we need from the JSON that we get through the poke api
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: String!
    
    var nextEvolutionLevel: String {
        if self._nextEvolutionLevel == nil {
            self._nextEvolutionLevel = ""
        }
        
        return self._nextEvolutionLevel
    }
    
    var nextEvolutionId: String {
        if self._nextEvolutionId == nil {
            self._nextEvolutionId = ""
        }
        
        return self._nextEvolutionId
    }
    
    var nextEvolutionName: String {
        if self._nextEvolutionName == nil {
            self._nextEvolutionName = ""
        }
        
        return self._nextEvolutionName
    }
    
    var description: String {
        if self._description == nil {
            self._description = ""
        }
        return self._description
    }
    
    var type: String {
        if self._type == nil {
            self._type = ""
        }
        return self._type
    }
    
    var defense: String {
        
        if self._defense == nil {
            self._defense = ""
        }
        return _defense
    }
    
    var height: String {
        if self._height == nil {
            self._height = ""
        }
        return self._height
    }
    
    var weight: String {
        
        if self._weight == nil {
            self._weight = ""
        }
        return _weight
    }

    
    var attack: String {
        
        if self._attack == nil {
            self._attack = ""
        }
        return _attack
    }

    
    var nextEvolutionText: String {
        
        if self._nextEvolutionTxt == nil {
            self._nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    var name: String {
        
        return _name
    }
    
    var pokedexId: Int {
        
        return _pokedexId
    }
    
    //we initiliaze every pokemon with his name and pokedex id, so we can create a specific URL for it later
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)"
        
    }

    //the model handles the data
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        
        Alamofire.request(self._pokemonURL).responseJSON { (response) in
            
            if let dict = response.result.value as? [String: Any] {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = String(attack)
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = String(defense)
                }
                
                if let types = dict["types"] as? [[String: String]] , types.count > 0 {
                    
                    if let name = types[0]["name"] {
                        
                        self._type = name.capitalized
                    }
                    
                    
                    if types.count > 1 {
                        for x in 1..<types.count {
                            
                            if let name = types[x]["name"]{
                                self._type! += "/\(name.capitalized)"
                            }
                            
                        }
                    }                    
                } else {
                    self._type = ""
                }
                
                if let info = dict["descriptions"] as? [[String:String]] , info.count > 0 {
                    
                    if let url = info[0]["resource_uri"] {
                        
                        
                        Alamofire.request("\(URL_BASE)\(url)").responseJSON { (response) in
                            
                            if let descDict = response.result.value as? [String:Any] {
                                
                                if let description = descDict["description"] as? String {
                                    self._description = description
                                }
                            }
                            
                          completed()
                        }
                    }
                } else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [[String:Any]], evolutions.count > 0 {
                    
                    if let nextEvolution = evolutions[0]["to"] as? String {
                        print(nextEvolution)
                        
                        if !nextEvolution.contains("mega") {
                            
                        self._nextEvolutionName = nextEvolution
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                                self._nextEvolutionId = nextEvoId
                                
                                if let lvlExists = evolutions[0]["level"] {
                                    
                                    if let lvl = lvlExists as? Int {
                                        self._nextEvolutionLevel = String(lvl)
                                    }
                                    
                                } else {
                                    self._nextEvolutionLevel = ""
                                }
                            }
                        }
                        
                    }
                    
                }
                
                
            }
            completed()
        }
        
    }
    
}












