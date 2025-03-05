//
//  PokeDexWidget.swift
//  PokeDexWidget
//
//  Created by Ahmed Siddique on 05/03/2025.
//

import WidgetKit
import SwiftUI
import CoreData

struct Provider: AppIntentTimelineProvider {
    var randomPokemon:Pokemon {
        var results:[Pokemon] = []
        do{
            results = try PersistenceController.shared.container.viewContext.fetch(Pokemon.fetchRequest())
        } catch{
            print("Couldn't fetch \(error)")
        }
        
        if let randomPokemon = results.randomElement(){
            return randomPokemon
        }
        return PersistenceController.previewPokemon
    }
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry.placeholder
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry.placeholder
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .second, value: hourOffset * 5, to: currentDate)!
            
            let entryPokemon = randomPokemon
          
            let entry = SimpleEntry(
                date: entryDate,
                name:entryPokemon.name!,
                types:entryPokemon.types!,
                sprite: entryPokemon.spriteImage
            )
            entries.append(entry)
        }
        
        return Timeline(entries: entries, policy: .atEnd)
    }
    
    //    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
    //        // Generate a list containing the contexts this widget is relevant in.
    //    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let name: String
    let types: [String]
    let sprite: Image
    
    static var placeholder: SimpleEntry{
        SimpleEntry(
            date: .now,
            name: "bulbasaur",
            types: ["grass", "poison"],
            sprite: Image(.bulbasaur)
        )
    }
    
    static var placeholder2: SimpleEntry{
        SimpleEntry(
            date: .now,
            name: "mew",
            types: ["psychic"],
            sprite: Image(.mew)
        )
    }
    
}

struct PokeDexWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetSize

    var entry: Provider.Entry
    
    var pokeImage: some View {
        entry.sprite
            .interpolation(.none)
            .resizable()
            .scaledToFit()
            .shadow(color: .black, radius: 6)
    }
    
    var typesView: some View{
        ForEach(entry.types, id: \.self){ type in
            Text(type.capitalized)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.black)
                .padding(.horizontal,13)
                .padding(.vertical, 5)
                .background(Color(type.capitalized))
                .clipShape(.capsule)
                .shadow(radius: 3)
        }
        
    }
    
    var body: some View {
        switch widgetSize{
        case .systemMedium:
            VStack {
                HStack{
                    pokeImage
                    Spacer()
                    VStack(alignment: .leading){
                        Text(entry.name.capitalized)
                            .font(.title)
                            .padding(.vertical,1)
                        
                        HStack{
                             
                        }
                    }.layoutPriority(1)
                }
                
            }
        case .systemLarge:
            ZStack {
                pokeImage
                VStack(alignment: .leading){
                    Text(entry.name.capitalized)
                        .font(.largeTitle)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                    
                    Spacer()
                    
                    HStack{
                        Spacer()
                        
                        typesView
                    }
                }
                
            }
        default:
            VStack {
                pokeImage
            }
        }
        
    }
}

struct PokeDexWidget: Widget {
    
    let kind: String = "PokeDexWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            if #available(iOS 17.0, *){
                PokeDexWidgetEntryView(entry: entry)
                    .foregroundStyle(.black)
                    .containerBackground(Color(entry.types[0].capitalized), for: .widget)
            }else{
                PokeDexWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
            
        }.configurationDisplayName("Pokemon")
            .description("See a random Pokemon")
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    PokeDexWidget()
} timeline: {
    SimpleEntry.placeholder
    SimpleEntry.placeholder2
}

#Preview(as: .systemMedium) {
    PokeDexWidget()
} timeline: {
    SimpleEntry.placeholder
    SimpleEntry.placeholder2
}
#Preview(as: .systemLarge) {
    PokeDexWidget()
} timeline: {
    SimpleEntry.placeholder
    SimpleEntry.placeholder2
}
