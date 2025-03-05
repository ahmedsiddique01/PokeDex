//
//  PokeDexWidgetLiveActivity.swift
//  PokeDexWidget
//
//  Created by Ahmed Siddique on 05/03/2025.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct PokeDexWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct PokeDexWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PokeDexWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension PokeDexWidgetAttributes {
    fileprivate static var preview: PokeDexWidgetAttributes {
        PokeDexWidgetAttributes(name: "World")
    }
}

extension PokeDexWidgetAttributes.ContentState {
    fileprivate static var smiley: PokeDexWidgetAttributes.ContentState {
        PokeDexWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: PokeDexWidgetAttributes.ContentState {
         PokeDexWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: PokeDexWidgetAttributes.preview) {
   PokeDexWidgetLiveActivity()
} contentStates: {
    PokeDexWidgetAttributes.ContentState.smiley
    PokeDexWidgetAttributes.ContentState.starEyes
}
