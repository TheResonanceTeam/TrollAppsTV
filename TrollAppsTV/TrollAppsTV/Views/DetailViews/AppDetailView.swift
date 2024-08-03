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
    @State private var showingAlert = false
    @State private var downloadAlertMessage: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ZStack(alignment: .bottom) {
                    if #available(tvOS 15.0, *) {
                        AsyncImage(url: URL(string: app.headerURL)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 620)
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
                                .frame(height: 620)
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
                        .padding(.top, 10)

                    HStack(alignment: .top) {
                        if(app.bundleName != "TrollAppsTV.app") {   //  app is NOT trollapps
                            if(isAppInstalled(bundleName: app.bundleName)) {
                                Button("OPEN") {
                                    if(openApplicationWithBundleID(app.bundleIdentifier)) {
                                        print("OPENING APP")
                                    }
                                }
                            } else {
                                if #available(tvOS 15.0, *) {
                                    Button("GET") {
                                        if let firstVersion = app.versions.first {
                                            print("CALLING DOWNLOADIPA AND SHOWING INIT ALERT")
                                            downloadIPA(firstVersion.downloadURL, isTrollAppsUpdate: false)
                                            showingAlert = true
                                        }
                                    }
                                    .alert("Started download:" + app.name, isPresented: $showingAlert) {
                                        Button("OK", role: .cancel) { }
                                    }
                                    .padding(.leading)
                                } else {
                                    Button("GET") {
                                        if let firstVersion = app.versions.first {
                                            print("CALLING DOWNLOADIPA AND SHOWING INIT ALERT")
                                            downloadIPA(firstVersion.downloadURL, isTrollAppsUpdate: false)
                                            downloadAlertMessage = "Started download: " + app.name
                                            showingAlert = true
                                        }
                                    }
                                    .alert(isPresented: $showingAlert) {
                                        Alert(
                                            title: Text(downloadAlertMessage),
                                            message: Text("Please wait...")
                                        )
                                    }
                                }
                            }
                        } else {    //  app IS trollapps
                            if(isNewVersionAvailable(for: app)) {
                                if #available(tvOS 15.0, *) {
                                    Button("GET") {
                                        if let firstVersion = app.versions.first {
                                            print("CALLING DOWNLOADIPA AND SHOWING INIT ALERT")
                                            downloadIPA(firstVersion.downloadURL, isTrollAppsUpdate: true)
                                            showingAlert = true
                                        }
                                    }
                                    .alert("Started download:" + app.name, isPresented: $showingAlert) {
                                        Button("OK", role: .cancel) { }
                                    }
                                    .padding(.leading)
                                } else {
                                    Button("GET") {
                                        if let firstVersion = app.versions.first {
                                            print("CALLING DOWNLOADIPA AND SHOWING INIT ALERT")
                                            downloadIPA(firstVersion.downloadURL, isTrollAppsUpdate: true)
                                            downloadAlertMessage = "Started download: " + app.name
                                            showingAlert = true
                                        }
                                    }
                                    .alert(isPresented: $showingAlert) {
                                        Alert(
                                            title: Text(downloadAlertMessage),
                                            message: Text("Please wait...")
                                        )
                                    }
                                }
                            } else {
                                Button("OWNED") {}.disabled(true)
                            }
                        }
                        
                        
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
            .padding(.bottom)
        }
        .edgesIgnoringSafeArea(.all)
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
