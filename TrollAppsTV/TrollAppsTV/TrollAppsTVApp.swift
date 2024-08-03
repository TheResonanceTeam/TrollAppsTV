//
//  TrollAppsTVApp.swift
//  TrollAppsTV
//
//  Created by Bonnie on 7/29/24.
//

import SwiftUI

@main
struct TrollAppsTVApp: SwiftUI.App {
    
    init() {
        clearTrollAppsFolder()
        findAndSetTrollAppsTVVersion(version: "0.9")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
