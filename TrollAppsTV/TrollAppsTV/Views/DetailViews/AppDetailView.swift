//
//  AppDetailView.swift
//  TrollAppsTV
//
//  Created by Bonnie on 7/30/24.
//

import SwiftUI

struct AppDetailView: View {
    let app: App
    @State private var isOwned: Bool = false // State to manage "GET" button text

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Header Image Section
                ZStack(alignment: .bottom) {
                    if #available(tvOS 15.0, *) {
                        AsyncImage(url: URL(string: app.headerURL)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 620) // Adjust the height as needed
                                .clipped()
                        } placeholder: {
                            ProgressView()
                                .frame(height: 620)
                        }
                    } else {
                        CustomAsyncImage(url: URL(string: app.headerURL)!) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 620) // Adjust the height as needed
                                .clipped()
                        } placeholder: {
                            ProgressView()
                                .frame(height: 620)
                        }
                    }

                    // Blur effect at the bottom of the header image
                    VisualEffectBlur(blurStyle: .dark) {}
                        .mask(LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.8)]), startPoint: .top, endPoint: .bottom))
                }
                .frame(height: 620) // Set the frame height for the header image

                // Content: Title, Button, and Description
                VStack(alignment: .leading, spacing: 10) {
                    Text(app.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.leading)
                        .padding(.top, 10) // Ensure there's some top padding

                    HStack(alignment: .top) {
                        Button(action: {
                            isOwned.toggle()
                        }) {
                            Text(isOwned ? "OWNED" : "GET")
                                .fontWeight(.bold)
                                .padding()
                                .frame(height: 44)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.leading)

                        VStack(alignment: .leading, spacing: 10) {
                            if #available(tvOS 15.0, *) {
                                Text(app.localizedDescription)
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(.black)
                                    .cornerRadius(16)
                                    .padding(.horizontal)
                            } else {
                                Text(app.localizedDescription)
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .padding()
                                    .cornerRadius(16)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.top, 10)
                }
                .padding(.top, 10)
                .padding(20)
            }
            .padding(.bottom) // Ensure the scroll view's content doesn't get cut off
        }
        .edgesIgnoringSafeArea(.all) // Ensure the scroll view content extends to the edges
    }
}

struct ScreenshotCell: View {
    let imageURL: String

    var body: some View {
        if #available(tvOS 15.0, *) {
            AsyncImage(url: URL(string: imageURL)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .shadow(radius: 5)
            } placeholder: {
                ProgressView()
                    .frame(width: 300, height: 200)
            }
        } else {
            CustomAsyncImage(url: URL(string: imageURL)!) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .shadow(radius: 5)
            } placeholder: {
                ProgressView()
                    .frame(width: 300, height: 200)
            }
        }
    }
}

struct AppDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AppDetailView(app: App(
            name: "Sample App",
            bundleIdentifier: "com.example.sample",
            developerName: "Example Dev",
            subtitle: "Sample App Subtitle",
            localizedDescription: "This is a description of the Sample App.",
            iconURL: "https://example.com/app-icon.png",
            headerURL: "https://raw.githubusercontent.com/Bonnie39/trollappstv.testrepo/main/assets/com.mojang.minecraftappletv.keyart.png",
            tintColor: "#FF0000",
            screenshotURLs: [
                "https://example.com/screenshot1.png",
                "https://example.com/screenshot2.png"
            ],
            versions: [],
            appPermissions: [:]
        ))
    }
}
