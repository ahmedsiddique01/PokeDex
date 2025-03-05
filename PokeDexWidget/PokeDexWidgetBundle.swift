//
//  PokeDexWidgetBundle.swift
//  PokeDexWidget
//
//  Created by Ahmed Siddique on 05/03/2025.
//

import WidgetKit
import SwiftUI

@main
struct PokeDexWidgetBundle: WidgetBundle {
    var body: some Widget {
        PokeDexWidget()
        PokeDexWidgetControl()
        PokeDexWidgetLiveActivity()
    }
}
