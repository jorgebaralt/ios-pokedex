//
//  Pokemon.swift
//  pokedex
//
//  Created by Jorge Baralt on 11/19/18.
//  Copyright © 2018 Jorge Baralt. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon{
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _pokemonURL: String!
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil{
            _type = "nil"
        }
        return _type
    }
    
    var nextEvolutionText: String{
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var defense: String{
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    
    var name: String{
        return _name
    }
    
    var pokedexId: Int{
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete){
        Alamofire.request(_pokemonURL).responseJSON{ response in
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                if let weigth = dict["weight"] as? Int{
                    self._weight = "\(weigth)"
                }
                if let height = dict["height"] as? Int{
                    self._height = "\(height)"
                }
                if let stats = dict["stats"] as? [Dictionary<String, AnyObject>]{
                    //def = 3
                    if let defense = stats[3]["base_stat"] as? Int{
                        self._defense = "\(defense)";
                    }
                    //att = 4
                    if let attack = stats[4]["base_stat"] as? Int {
                        self._attack = "\(attack)"
                    }
                }
                
                if let types = dict["types"] as? [Dictionary<String,AnyObject>] , types.count > 0{
                    if let type = types[0]["type"] as? Dictionary<String,AnyObject>{
                        if let name = type["name"]{
                            self._type = name.capitalized
                        }
                        
                    }
                    if types.count > 1 {
                        for x in 1..<types.count{
                            if let type = types[x]["type"] as? Dictionary<String,AnyObject>{
                                if let name = type["name"]{
                                    self._type += "/" + name.capitalized
                                }
                                
                            }
                        }
                    }
                    
                } else {
                    self._type = ""
                }

            }
            completed()
        }
    }
}
