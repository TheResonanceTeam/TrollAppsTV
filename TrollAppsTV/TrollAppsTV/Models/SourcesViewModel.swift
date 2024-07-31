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
        // Initialize with an existing URL for testing
        let testURL = "https://raw.githubusercontent.com/Bonnie39/trollappstv.testrepo/main/repo.json"
        sources.append(Source(url: testURL))
        fetchRepository(from: testURL)
    }

    func addSource(url: String) {
        let newSource = Source(url: url)
        sources.append(newSource)
        fetchRepository(from: url)
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
