//
//  FetchedPokemon.swift
//  PokeDex
//
//  Created by Ahmed Siddique on 05/03/2025.
//

import Foundation

struct FetchedPokemon:Decodable{
    let id:Int16
    let name:String
    let types:[String]
    let hp:Int16
    let specialAttack:Int16
    let specialDefense:Int16
    let speed:Int16
    let attack:Int16
    let defense:Int16
    let spriteURL:URL
    let shinyURL:URL
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case stats
        case types
        case sprites
        
        enum TypeDictionaryKeys: String, CodingKey {
            case type
            
            enum TypeKeys: String, CodingKey {
                case name
            }
        }
        
        enum StatDictionaryKeys: String, CodingKey {
            case baseStat
        }
        
        enum SpriteKeys: String, CodingKey {
            case spriteURL = "frontDefault"
            case shinyURL = "frontShiny"
        }
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int16.self, forKey: .id)
        
        name = try container.decode(String.self, forKey: .name)
        
        var decodedTypes:[String] = []
        var typesContainer = try container.nestedUnkeyedContainer(forKey: .types)
        
        while !typesContainer.isAtEnd {
            let typesDictionaryContainer = try typesContainer.nestedContainer(keyedBy: CodingKeys.TypeDictionaryKeys.self)
            let typeContainer = try typesDictionaryContainer.nestedContainer(keyedBy: CodingKeys.TypeDictionaryKeys.TypeKeys.self, forKey: .type)
            let type = try typeContainer.decode(String.self, forKey: .name)
            decodedTypes.append(type)
        }
        
        if decodedTypes.count == 2 && decodedTypes[0] == "normal"{
            decodedTypes.swapAt(0, 1)
        }
        
        types = decodedTypes
        
        var decodedStat: [Int16] = []
        var statsContainer = try container.nestedUnkeyedContainer(forKey: .stats)
        
        while !statsContainer.isAtEnd {
            let statsDictionaryContainer = try statsContainer.nestedContainer(keyedBy: CodingKeys.StatDictionaryKeys.self)
            let stat = try statsDictionaryContainer.decode(Int16.self, forKey: .baseStat)
            decodedStat.append(stat)
        }
        
        hp = decodedStat[0]
        attack = decodedStat[1]
        defense = decodedStat[2]
        specialAttack = decodedStat[3]
        specialDefense = decodedStat[4]
        speed = decodedStat[5]
        
        let spriteContainer = try container.nestedContainer(keyedBy: CodingKeys.SpriteKeys.self, forKey: .sprites)
        
        spriteURL = try spriteContainer.decode(URL.self, forKey: .spriteURL)
        shinyURL = try spriteContainer.decode(URL.self, forKey: .shinyURL)
    }
}
