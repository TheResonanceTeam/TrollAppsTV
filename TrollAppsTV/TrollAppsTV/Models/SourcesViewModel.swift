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

    init() {
        setDefaultSources()
    }
    
    func setDefaultSources() {
        let demoURL1 = "https://raw.githubusercontent.com/TheResonanceTeam/.default-sources/main/tvOS/ResonanceTeamTV.json"
        let demoURL2 = "https://raw.githubusercontent.com/TheResonanceTeam/.default-sources/main/tvOS/UnofficialMojangArchive.json"
        
        sources.append(Source(url: demoURL1))
        sources.append(Source(url: demoURL2))
        
        fetchRepository(from: demoURL1)
        fetchRepository(from: demoURL2)
    }

    func addSource(url: String) {
        let newSource = Source(url: url)
        sources.append(newSource)
        fetchRepository(from: url)
    }
    
    func removeSource(at index: Int) {
        guard index < sources.count else { return }
        sources.remove(at: index)
        repositories.remove(at: index)
    }

    func fetchRepository(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
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
                self?.repositories.append(repository)
            })
            .store(in: &cancellables)
    }
}