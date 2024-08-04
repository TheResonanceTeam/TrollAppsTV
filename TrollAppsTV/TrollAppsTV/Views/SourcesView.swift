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
    @State private var showingAlert = false
    @State private var isTextFieldFocused = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Repositories")) {
                        ForEach(viewModel.repositories) { repository in
                            HStack {
                                NavigationLink(destination: RepositoryDetailView(repository: repository)) {
                                    HStack(alignment: .center, spacing: 10) {
                                        if let iconURL = URL(string: repository.iconURL) {
                                            if #available(tvOS 15.0, *) {
                                                AsyncImage(url: iconURL) { image in
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
                                                CustomAsyncImage(url: iconURL) { image in
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
                                        }

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
                                .contextMenu {
                                    if #available(tvOS 15.0, *) {
                                        Button(role: .destructive) {
                                            if let index = viewModel.repositories.firstIndex(where: { $0.id == repository.id }) {
                                                viewModel.removeSource(at: index)
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    } else {
                                        Button() {
                                            if let index = viewModel.repositories.firstIndex(where: { $0.id == repository.id }) {
                                                viewModel.removeSource(at: index)
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                                .foregroundColor(.red)
                                        }
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
                        saveNewSourceToFile(newUrl: newURL)
                        viewModel.loadSourcesFromFile()
                        newURL = ""
                        showingAlert = true
                    }) {
                        Image(systemName: "plus.circle")
                        Text("Add URL")
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Source Added"), message: Text("The source has been added successfully."), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
    private func saveNewSourceToFile(newUrl: String) {
        let userSourcesFilePath = "/private/var/mobile/.TrollApps/.userSources"
        var currentContents = (try? String(contentsOfFile: userSourcesFilePath)) ?? ""
        currentContents += "\(newUrl)\n"
        do {
            try currentContents.write(toFile: userSourcesFilePath, atomically: true, encoding: .utf8)
        } catch {
            print("Error saving new source to file: \(error)")
        }
    }
}

struct SourcesView_Previews: PreviewProvider {
    static var previews: some View {
        SourcesView()
    }
}
