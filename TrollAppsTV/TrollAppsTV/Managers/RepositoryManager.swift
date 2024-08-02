//
//  RepoManager.swift
//  TrollApps
//
//  Created by Cleopatra on 2023-12-02.
//

import SwiftUI

let decoder = JSONDecoder()

class RepositoryManager: ObservableObject {
    /*@AppStorage("repos") var RepoList: [String] = [
        "https://raw.githubusercontent.com/TheResonanceTeam/.default-sources/main/haxi0_2.0.json",
        "https://raw.githubusercontent.com/TheResonanceTeam/.default-sources/main/BonnieRepo_2.0.json",
        "https://raw.githubusercontent.com/TheResonanceTeam/.default-sources/main/ResonanceTeamRepo.json"
    ]*/
    //@Published var ReposData: [RepoMemory] = []
    //@Published var BadRepos: [BadRepoMemory] = []
    //@Published var InstalledApps = GetApps()
    
    @Published var hasFetchedRepos: Bool = false
    @Published var hasFinishedFetchingRepos: Bool = false
    
    @Published var isInstallingApp = false
    @Published var isDownloadingApp = false
    
    /*func IsAppInstalled(_ BundleID: String) -> Bool {
        let installedApps = InstalledApps
        return installedApps.contains { $0.id == BundleID }
    }
    
    func showUpdateButton(version1: String, BundleID: String) -> Int32 {
            let installedApps = InstalledApps
            if let installedApp = installedApps.first(where: { $0.id == BundleID }) {
                if (installedApp.version == version1) {
                    return 0
                } else {
                    return 0
                }
            } else {
                return 0
            }
        }*/
}
