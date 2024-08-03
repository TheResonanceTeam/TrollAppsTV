//
//  InstallManager.swift
//  TrollApps // TrollAppsTV
//
//  Created by Cleopatra on 2023-12-18.
//  Modified for tvOS by Bonnie on 2024-07-31
//

import Combine
import SwiftUI

func InstallIPA(isTrollAppsUpdate: Bool) {
    print("INSTALL PROCESS STARTED")
        
    let destinationFolderURL = URL(fileURLWithPath: "/private/var/mobile/.TrollApps/tmp/")
    let IPAPathURL = destinationFolderURL
        //.appendingPathComponent(itemID.uuidString)
        .appendingPathExtension("install.ipa")
        
    if !FileManager.default.fileExists(atPath: IPAPathURL.path) {
        //completion(FunctionStatus(error: true, message: ErrorMessage(title: "FNF \(IPAPathURL.path)", body: "File does not exist")))
        print("ERROR: IPA PATH DOES NOT EXIST")
        return
    } else if let trollStoreApp = findTrollStoreApp() {
        let trollstoreHelperPath = trollStoreApp + "/trollstorehelper"
        let returnCode = spawnRoot(trollstoreHelperPath, ["install", IPAPathURL.path])
        
        if(isTrollAppsUpdate) {
            closeTrollApps()
        }
        
        if(returnCode != 0) {
            //completion(FunctionStatus(error: true, message: ErrorMessage(title: "FAILED_TO_INSTALL", body: "INSTALLATION_RETURNED_ERROR \(returnCode)")))
            print("ERROR: FAILED TO INSTALL APP. returnCode: " + String(returnCode))
            return
        } else {
            NotificationCenter.default.post(name: Notification.Name("ApplicationsChanged"), object: nil)
            PassthroughSubject<Void, Never>().send()
            
            if FileManager.default.fileExists(atPath: IPAPathURL.path) {
                do {
                    try FileManager.default.removeItem(atPath: IPAPathURL.path)
                    //completion(FunctionStatus(error: false))
                    print("FINISHED! CLEARING TEMP FOLDER")
                    clearTrollAppsFolder()
                    return
                } catch {
                    //completion(FunctionStatus(error: true, message: ErrorMessage(title: "ERROR_REMOVING_IPA_FILE_AFTER_INSTALL", body: "LIKELY_A_PERMS_ISSUE")))
                    print("ERROR: UNABLE TO REMOVE IPA FILE AFTER INSTALL, LIKELY A PERMS ISSUE")
                    return
                }
            } else {
                //completion(FunctionStatus(error: true, message: ErrorMessage(title: "MISSING_DOWNLOADED_IPA", body: "")))
                print("DOWNLOADED IPA WAS MISSING")
                return
            }
        }
    } else {
        print("UNABLE TO LOCATE TROLLSTOREHELPER, ENSURE TROLLSTORE IS INSTALLED")
        //completion(FunctionStatus(error: true, message: ErrorMessage(title: "TROLLSTORE_NOT_FOUND", body: "TROLLSTORE_IS_REQUIRED")))
        return
    }
}

func findTrollStoreApp() -> String? {
    let applicationDir = "/private/var/containers/Bundle/Application/"
    let fileManager = FileManager.default
    do {
        let folders = try fileManager.contentsOfDirectory(atPath: applicationDir)
        for folder in folders {
            let appPath = applicationDir + folder + "/TrollStore.app"
            if fileManager.fileExists(atPath: appPath) {
                return appPath
            }
        }
    } catch {
        print("Error reading contents of application directory: \(error)")
    }
    return nil
}

func DeleteIPA(_ itemID: UUID) -> Bool {
    let destinationFolderURL = URL(fileURLWithPath: "/var/mobile/.TrollApps/tmp/")
    let IPAPathURL = destinationFolderURL
        .appendingPathComponent(itemID.uuidString)
        .appendingPathExtension(".ipa")
    
    if !FileManager.default.fileExists(atPath: IPAPathURL.path) {
        return false
    } else {
        do {
            try FileManager.default.removeItem(atPath: IPAPathURL.path)
            return true
        } catch {
            return false
        }
    }
}
