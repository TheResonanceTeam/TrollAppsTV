//
//  Models.swift
//  TrollAppsTV
//
//  Created by Bonnie on 7/30/24.
//

import Foundation

// Model for an app's version
struct AppVersion: Identifiable, Codable {
    let id = UUID()
    let version: String
    let date: String
    let localizedDescription: String
    let downloadURL: String
    let size: Int
}

struct App: Identifiable, Codable {
    let id = UUID()
    let name: String
    let bundleIdentifier: String
    let bundleName: String
    let developerName: String
    let subtitle: String
    let localizedDescription: String
    let iconURL: String
    let headerURL: String
    let tintColor: String
    let screenshotURLs: [String]
    let versions: [AppVersion]
    let appPermissions: [String: String]
}

// Model for the repository
struct Repository: Identifiable, Codable {
    let id = UUID()
    let name: String
    let subtitle: String
    let description: String
    let iconURL: String
    let headerURL: String?
    let website: String
    let tintColor: String
    let featuredApps: [String]
    let apps: [TrollAppsTV.App]
    let news: [String]
}

struct Source: Identifiable, Codable {
    let id = UUID()
    let url: String
}
