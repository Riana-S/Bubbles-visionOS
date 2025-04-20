//
//  BubblesApp.swift
//  Bubbles
//
//  Created by Riana Santos on 4/20/25.
//

import SwiftUI

@main
struct BubblesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
