//
//  ContentView.swift
//  TrollAppsTV
//
//  Created by Bonnie on 7/29/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            //FeaturedView()
            //    .tabItem {
            //        Label("Featured", systemImage: "star.fill")
            //   }
            SourcesView()
                .tabItem {
                    Label("Sources", systemImage: "globe")
                }
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            SettingsView(viewModel: SourcesViewModel())
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

