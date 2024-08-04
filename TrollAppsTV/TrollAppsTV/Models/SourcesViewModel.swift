//
//  SourcesViewModel.swift
//  TrollAppsTV
//
//  Created by Bonnie on 7/30/24.
//


import Foundation
import Combine

class SourcesViewModel: ObservableObject {
    @Published var sources: [Source] = []
    @Published var repositories: [Repository] = []
    private var cancellables = Set<AnyCancellable>()
    private var loadedRepositoryURLs: Set<String> = []
    
    private let userSourcesFilePath = "/private/var/mobile/.TrollApps/.userSources"
    
    init() {
        if !doesDefaultSourcesFileExist() {
            setDefaultSources()
            print("Initialized default sources.")
        }
        loadSourcesFromFile()
    }
    
    func setDefaultSources() {
        let demoURL1 = "https://raw.githubusercontent.com/TheResonanceTeam/.default-sources/main/tvOS/ResonanceTeamTV.json"
        let demoURL2 = "https://raw.githubusercontent.com/TheResonanceTeam/.default-sources/main/tvOS/UnofficialMojangArchive.json"
        
        sources.append(Source(url: demoURL1))
        sources.append(Source(url: demoURL2))
        
        //fetchRepository(from: demoURL1)
        //fetchRepository(from: demoURL2)
        
        saveSourcesToFile()
        createDefaultSourcesFile()
    }

    func addSource(url: String) {
        print("Adding source with URL: \(url)")
        sources.append(Source(url: url))
        fetchRepository(from: url)
        saveSourcesToFile()
    }
    
    func removeSource(at index: Int) {
        guard index < sources.count else { return }
        sources.remove(at: index)
        repositories.remove(at: index)
        saveSourcesToFile()
    }
    
    private func fetchRepository(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
            
        if loadedRepositoryURLs.contains(urlString) {
            print("Repository already loaded for URL: \(urlString)")
            return
        }
            
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Repository.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching repository: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] repository in
                print("Fetched repository: \(repository.name)")
                self?.repositories.append(repository)
                self?.loadedRepositoryURLs.insert(urlString)
            })
            .store(in: &cancellables)
    }
    
    func loadSourcesFromFile() {
        guard FileManager.default.fileExists(atPath: userSourcesFilePath),
              let fileContents = try? String(contentsOfFile: userSourcesFilePath) else {
            print("Could not read sources file")
            return
        }
        
        //  make absolutely sure we don't add any duplicates, and that we remove any deleted repos before reloading
        repositories.removeAll()
        loadedRepositoryURLs.removeAll()
        
        let urls = fileContents.split(separator: "\n").map { String($0) }
        sources = urls.map { Source(url: $0) }
        
        for url in urls {
            fetchRepository(from: url)
        }
    }
    
    private func saveSourcesToFile() {
        let urls = sources.map { $0.url }.joined(separator: "\n")
        do {
            try urls.write(toFile: userSourcesFilePath, atomically: true, encoding: .utf8)
        } catch {
            print("Error saving sources to file: \(error)")
        }
    }
}
