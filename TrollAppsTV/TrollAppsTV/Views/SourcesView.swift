//
//  SourcesView.swift
//  TrollAppsTV
//
//  Created by Bonnie on 7/30/24.
//

import SwiftUI

struct SourcesView: View {
    @StateObject private var viewModel = SourcesViewModel()
    @State private var newURL: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Repositories")) {
                        ForEach(viewModel.repositories) { repository in
                            NavigationLink(destination: RepositoryDetailView(repository: repository)) {
                                HStack(alignment: .center, spacing: 10) {
                                    // Repository Icon
                                    if #available(tvOS 15.0, *) {
                                        AsyncImage(url: URL(string: repository.iconURL)) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 84, height: 84)
                                                .clipShape(Circle())
                                        } placeholder: {
                                            ProgressView()
                                                .frame(width: 84, height: 84)
                                        }
                                    } else {
                                        CustomAsyncImage(url: URL(string: repository.iconURL)!) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 84, height: 84)
                                                .clipShape(Circle())
                                        } placeholder: {
                                            ProgressView()
                                                .frame(width: 84, height: 84)
                                        }
                                    }

                                    // Repository Details
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(repository.name)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        
                                        Text(repository.subtitle)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Sources")
                
                HStack {
                    TextField("Enter URL", text: $newURL)
                        .padding()
                        .cornerRadius(8)
                    
                    Button(action: {
                        guard !newURL.isEmpty else { return }
                        viewModel.addSource(url: newURL)
                        newURL = ""
                    }) {
                        Text("Add URL")
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
        }
    }
}

struct SourcesView_Previews: PreviewProvider {
    static var previews: some View {
        SourcesView()
    }
}
