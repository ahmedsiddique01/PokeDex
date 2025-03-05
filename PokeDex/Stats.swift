//
//  Stats.swift
//  PokeDex
//
//  Created by Ahmed Siddique on 05/03/2025.
//

import SwiftUI
import Charts

struct Stats: View {
    let pokemon:Pokemon
    
    var body: some View {
       
        Chart(pokemon.stats){stat in
            BarMark(x: .value("Value", stat.value),
                    y: .value("Value", stat.name)
            ).annotation(position: .trailing){
                Text("\(stat.value)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.top, -5)
            }
        }
        .frame(height: 200)
        .padding([.horizontal, .bottom])
        .foregroundColor(pokemon.typeColor)
        .chartXScale(domain: 0...pokemon.highestStat.value+10)
    }
}

#Preview {
    Stats(pokemon: PersistenceController.previewPokemon)
}
