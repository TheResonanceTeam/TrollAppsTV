//
//  CustomAsyncImage.swift
//  TrollAppsTV
//
//  Created by Bonnie on 7/31/24.
//

import SwiftUI
import Combine

// ImageLoader class
class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private var cancellable: AnyCancellable?

    func loadImage(from url: URL) {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0 }
    }

    func cancel() {
        cancellable?.cancel()
    }
}

// CustomAsyncImage view
struct CustomAsyncImage<Content: View, Placeholder: View>: View {
    @StateObject private var loader = ImageLoader()
    let url: URL
    let content: (Image) -> Content
    let placeholder: () -> Placeholder

    init(url: URL, @ViewBuilder content: @escaping (Image) -> Content, @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }

    var body: some View {
        Group {
            if let uiImage = loader.image {
                content(Image(uiImage: uiImage))
            } else {
                placeholder()
                    .onAppear {
                        loader.loadImage(from: url)
                    }
                    .onDisappear {
                        loader.cancel()
                    }
            }
        }
    }
}
