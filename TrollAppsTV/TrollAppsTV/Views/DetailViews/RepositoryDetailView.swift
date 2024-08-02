//
//  RepositoryDetailView.swift
//  TrollAppsTV
//
//  Created by Bonnie on 7/30/24.
//

import SwiftUI

struct RepositoryDetailView: View {
    let repository: Repository
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Apps")) {
                    ForEach(repository.apps) { app in
                        NavigationLink(destination: AppDetailView(app: app)) {
                            HStack(alignment: .center, spacing: 10) {
                                // App Icon
                                let width: CGFloat = 100 // Adjust this width to your desired value
                                let height = width * (768 / 1280) // Calculating height to maintain the 5:3 aspect ratio

                                if #available(tvOS 15.0, *) {
                                    AsyncImage(url: URL(string: app.iconURL)) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: width, height: height)
                                            .clipShape(RoundedRectangle(cornerRadius: 16))
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: width, height: height)
                                    }
                                } else {
                                    CustomAsyncImage(url: URL(string: app.iconURL)!) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: width, height: height)
                                            .clipShape(RoundedRectangle(cornerRadius: 16))
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: width, height: height)
                                    }
                                }
                                
                                // App Details
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(app.name)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    Text(app.subtitle)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(repository.name)
    }
}

struct RepositoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryDetailView(repository: Repository(
            name: "Test Repo",
            subtitle: "A Test Repo",
            description: "This is a test repo description.",
            iconURL: "https://example.com/icon.png",
            headerURL: "https://example.com/header.png",
            website: "https://example.com",
            tintColor: "#F54F32",
            featuredApps: [],
            apps: [],
            news: []
        ))
    }
}
