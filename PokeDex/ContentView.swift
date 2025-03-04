//
//  ContentView.swift
//  PokeDex
//
//  Created by Ahmed Siddique on 05/03/2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    
    @FetchRequest<Pokemon>(
        sortDescriptors: [], animation: .default
    ) private var all
    
    @FetchRequest<Pokemon>(
        sortDescriptors: [SortDescriptor(\.id)], animation: .default
    ) private var pokedex
    
    let fetcher = FetchService()
    
    @State private var searchText = ""
    @State private var filterByFavorite = false
    
    private var dynamicPredicate: NSPredicate {
        
        var predicate: [NSPredicate] = []
        
        if !searchText.isEmpty {
            predicate.append(NSPredicate(format: "name CONTAINS[c] %@", searchText))
        }
        
        if filterByFavorite{
            predicate.append(NSPredicate(format: "favorite == %d",true))
        }
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicate)
    }
    
    
    var body: some View {
        if all.isEmpty {
            ContentUnavailableView{
                Label("No Pokemon", image: .nopokemon)
            } description: {
                Text("There aren't any Pokemon.\nFetch some Pokemon to get started!")
            } actions: {
                Button("Fetch Pokemon", systemImage: "antenna.radiowaves.left.and.right"){
                    getPokemon(from: 1)
                }.buttonStyle(.borderedProminent)
            }
        }
        else{
            NavigationStack{
                List{
                    Section{
                        ForEach(pokedex){pokemon in
                            NavigationLink(value: pokemon){
                                AsyncImage(url: pokemon.sprite){image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 100, height: 100)
                               
                                VStack(alignment: .leading){
                                    HStack{
                                        Text(pokemon.name!.capitalized)
                                            .fontWeight(.bold)
                                        if pokemon.favorite{
                                            Image(systemName: "star.fill")
                                                .foregroundStyle(.yellow)
                                        }
                                    }
                                    HStack{
                                        ForEach(pokemon.types!, id: \.self){type in
                                            Text(type.capitalized)
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(.black)
                                                .padding(.horizontal,13)
                                                .padding(.vertical, 5)
                                                .background(Color(type.capitalized))
                                                .clipShape(.capsule)
                                        }
                                    }
                                }
                            }.swipeActions(edge: .leading){
                                Button(pokemon.favorite ? "Remove from Favorites" : "Add to Favorites", systemImage: "star"){
                                    pokemon.favorite.toggle()
                                    do{
                                        try viewContext.save()
                                    } catch{
                                        print(error)
                                    }
                                }.tint(pokemon.favorite ? .gray : .yellow)
                            }
                            
                            
                        }
                    } footer:{
                        if all.count < 151 {
                            ContentUnavailableView{
                                Label("Missing Pokemon", image: .nopokemon)
                            } description: {
                                Text("The fetch was interrupted!\nFetch the rest of the Pokemon.")
                            } actions: {
                                Button("Fetch Pokemon", systemImage: "antenna.radiowaves.left.and.right"){
                                    getPokemon(from: pokedex.count + 1)
                                }.buttonStyle(.borderedProminent)
                            }
                        }
                    }
                }.navigationTitle("Pokedex")
                    .searchable(text: $searchText, prompt: "Find a Pokemon")
                    .onChange(of: searchText){
                        pokedex.nsPredicate = dynamicPredicate
                    }
                    .onChange(of: filterByFavorite){
                        pokedex.nsPredicate = dynamicPredicate
                    }
                    .autocorrectionDisabled()
                    .navigationDestination(for: Pokemon.self){pokemon in
                        Text(pokemon.name ?? "No name")
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button{
                                filterByFavorite.toggle()
                            } label:{
                                Label("Filter by Favorites", systemImage: filterByFavorite ? "star.fill" : "star")
                            }.tint(.yellow)
                        }
                    }
            }
        }
    }
    
    
    private func getPokemon(from id: Int) {
        Task {
            for i in id..<152 {
                do{
                    let fetchedPokemon = try await fetcher.fetchPokemon(i)
                    
                    let pokemon = Pokemon(context: viewContext)
                    
                    pokemon.id = fetchedPokemon.id
                    pokemon.name = fetchedPokemon.name
                    pokemon.speed = fetchedPokemon.speed
                    pokemon.attack = fetchedPokemon.attack
                    pokemon.defense = fetchedPokemon.defense
                    pokemon.types = fetchedPokemon.types
                    pokemon.hp = fetchedPokemon.hp
                    pokemon.sprite = fetchedPokemon.sprite
                    pokemon.shiny = fetchedPokemon.shiny
                    pokemon.specialAttack = fetchedPokemon.specialAttack
                    pokemon.specialDefense = fetchedPokemon.specialDefense
                    try viewContext.save()
                } catch{
                    print(error)
                }
                
            }
        }
    }
    
}


#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
