//
//  AppUtil.swift
//  TrollAppsTV
//
//  Created by Bonnie on 7/31/24.
//

import Combine

struct BundledApp: Identifiable, Hashable {
    let id: String
    var name: String
    var version: String
    var isTrollStore: Bool
    var icon: UIImage
}

private func applicationIconImage() -> Int32 {
    return UIDevice.current.userInterfaceIdiom == .pad ? 8 : 10
}

/*func GetApps() -> [BundledApp] {
    var apps: [BundledApp] = []
    
    for app in LSApplicationWorkspace().allInstalledApplications() as! [LSApplicationProxy] {
        let appDict = NSDictionary(contentsOfFile: "\(app.bundleURL.path)/Info.plist")
        
        let parentDirectory = app.bundleURL.deletingLastPathComponent()
        let filePath = parentDirectory.appendingPathComponent("_TrollStore")
        let fileExists = FileManager.default.fileExists(atPath: filePath.path)
        
        let bundleID = (appDict?.value(forKey: "CFBundleIdentifier") ?? "Unknown") as! String
        
        
        let icon = UIImage._applicationIconImage(forBundleIdentifier: bundleID, format: applicationIconImage(), scale: UIScreen.main.scale) as! UIImage
        
        
        let bundledApp = BundledApp(
            id: bundleID,
            name: (
                appDict?.value(forKey: "CFBundleDisplayName") ??
                appDict?.value(forKey: "CFBundleName") ??
                appDict?.value(forKey: "CFBundleExecutable") ??
                "Unknown"
            ) as! String,
            version: (
                appDict?.value(forKey: "CFBundleShortVersionString") ??
                "Unknown"
            ) as! String,
            isTrollStore: fileExists,
            icon: icon
        )
        apps.append(bundledApp)
    }
    return apps
}

func OpenApp(_ BundleID: String) {
    guard let obj = objc_getClass("LSApplicationWorkspace") as? NSObject else { return }
    let workspace = obj.perform(Selector(("defaultWorkspace")))?.takeUnretainedValue() as? NSObject
    workspace?.perform(Selector(("openApplicationWithBundleID:")), with: BundleID)
}*/

func clearTrollAppsFolder() {
    let trollAppsFolderURL = URL(fileURLWithPath: "/private/var/mobile/.TrollApps/")
    let tempIpaFileURL = URL(fileURLWithPath: "/private/var/mobile/.TrollApps/tmp.install.ipa")
    
    do {
        // Check and delete the .TrollApps folder
        if FileManager.default.fileExists(atPath: trollAppsFolderURL.path) {
            try FileManager.default.removeItem(at: trollAppsFolderURL)
            print("Successfully deleted .TrollApps folder and its contents.")
        } else {
            print(".TrollApps folder does not exist.")
        }
        
        // Check and delete the tmp.install.ipa file
        if FileManager.default.fileExists(atPath: tempIpaFileURL.path) {
            try FileManager.default.removeItem(at: tempIpaFileURL)
            print("Successfully deleted tmp.install.ipa file.")
        } else {
            print("tmp.install.ipa file does not exist.")
        }
        
        //  once more just in case :3
        try FileManager.default.removeItem(at: trollAppsFolderURL)
        try FileManager.default.removeItem(at: tempIpaFileURL)
    } catch {
        print("Error deleting .TrollApps folder or tmp.install.ipa file: \(error.localizedDescription)")
    }
}

func findAndSetTrollAppsTVVersion(version: String) {
    let applicationDir = "/private/var/containers/Bundle/Application/"
    let fileManager = FileManager.default
    
    do {
        let folders = try fileManager.contentsOfDirectory(atPath: applicationDir)
        for folder in folders {
            let appPath = applicationDir + folder + "/TrollAppsTV.app"
            if fileManager.fileExists(atPath: appPath) {
                let versionFilePath = appPath + "/.currentversion"
                do {
                    try version.write(toFile: versionFilePath, atomically: true, encoding: .utf8)
                    print("Successfully wrote version \(version) to .currentversion file.")
                } catch {
                    print("Error writing to .currentversion file: \(error.localizedDescription)")
                }
                return
            }
        }
        print("TrollAppsTV.app not found.")
    } catch {
        print("Error reading contents of application directory: \(error)")
    }
}

func isAppInstalled(bundleName: String) -> Bool {
    let applicationDir = "/private/var/containers/Bundle/Application/"
    let fileManager = FileManager.default
    
    do {
        let folders = try fileManager.contentsOfDirectory(atPath: applicationDir)
        for folder in folders {
            let appPath = applicationDir + folder + "/" + bundleName
            if fileManager.fileExists(atPath: appPath) {
                return true
            }
        }
        print("\(bundleName) not found.")
    } catch {
        print("Error reading contents of application directory: \(error)")
    }
    return false
}

func isNewVersionAvailable(for app: TrollAppsTV.App) -> Bool {
    let applicationDir = "/private/var/containers/Bundle/Application/"
    let fileManager = FileManager.default
    
    // Get the latest version from the repo
    guard let latestAppVersion = app.versions.first else {
        print("No versions available in the repo.")
        return false
    }
    
    do {
        let folders = try fileManager.contentsOfDirectory(atPath: applicationDir)
        for folder in folders {
            let appPath = applicationDir + folder + "/" + app.bundleName
            let versionFilePath = appPath + "/.currentversion"
            
            if fileManager.fileExists(atPath: appPath) {
                // Read the currently installed version
                if fileManager.fileExists(atPath: versionFilePath) {
                    let currentVersion = try String(contentsOfFile: versionFilePath, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    // Compare versions
                    if !isVersion(currentVersion, greaterThanOrEqualTo: latestAppVersion.version) {
                        return true
                    }
                } else {
                    return true
                }
            }
        }
    } catch {
        print("Error reading contents of application directory: \(error)")
    }
    
    return false
}

func isVersion(_ version1: String, greaterThanOrEqualTo version2: String) -> Bool {
    let version1Components = version1.split(separator: ".").compactMap { Int($0) }
    let version2Components = version2.split(separator: ".").compactMap { Int($0) }
    
    for (v1, v2) in zip(version1Components, version2Components) {
        if v1 > v2 {
            return true
        } else if v1 < v2 {
            return false
        }
    }
    return version1Components.count >= version2Components.count
}

func updateTrollApps(for app: TrollAppsTV.App) {
    let versionToDownload = app.versions.first
    let downloadURL = versionToDownload?.downloadURL

    if let downloadURL = downloadURL,
        let url = URL(string: downloadURL.replacingOccurrences(of: "apple-magnifier://install?url=", with: "")),
        UIApplication.shared.canOpenURL(url) {
            
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                exit(0)
            }
        })
    }
}