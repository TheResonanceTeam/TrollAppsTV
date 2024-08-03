//
//  DownloadManager.swift
//  TrollApps // TrollAppsTV
//
//  Created by Cleopatra on 2023-12-17.
//  Modified for tvOS by Bonnie on 2024-07-31
//

import SwiftUI

class DownloadDelegate: NSObject, ObservableObject, URLSessionDownloadDelegate {
    //var queueItem: QueueItem
    var appUrl: String
    var isTrollAppsUpdate: Bool
    //var completion: (FunctionStatus) -> Void
    //var queueManager: QueueManager

    init(appUrl: String, isTrollAppsUpdate: Bool) {
        //self.queueItem = queueItem
        //self.completion = completion
        //self.queueManager = queueManager
        self.appUrl = appUrl
        self.isTrollAppsUpdate = isTrollAppsUpdate
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            print("ATTEMPTING TO DOWNLOAD .IPA FILE")
            let destinationFolderURL = URL(fileURLWithPath: "/private/var/mobile/.TrollApps/tmp/")
            let IPAPathURL = destinationFolderURL
                //.appendingPathComponent(queueItem.id.uuidString)
                .appendingPathExtension("install.ipa")
            
            try FileManager.default.createDirectory(at: destinationFolderURL, withIntermediateDirectories: true, attributes: nil)

            try FileManager.default.moveItem(at: location, to: URL(fileURLWithPath: IPAPathURL.path))
            
            print("ATTEMPTING TO INSTALL APP")
            
            InstallIPA(isTrollAppsUpdate: isTrollAppsUpdate)
                        
            DispatchQueue.main.async {
                //self.queueManager.updateQueueItemProgress(itemID: self.queueItem.id, progress: 100)
            }
            //completion(FunctionStatus(error: false))
        } catch {
            print(error)
            //completion(FunctionStatus(error: true, message: ErrorMessage(title: "ERROR_MOVING_IPA_FILE", body: error.localizedDescription)))
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let percentComplete = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            //self.queueManager.updateQueueItemProgress(itemID: self.queueItem.id, progress: percentComplete * 100)
        }
    }
}

func downloadIPA(_ appUrl: String, isTrollAppsUpdate: Bool) {
    print("DOWNLOAD REQUEST STARTED")

    let downloadDelegate = DownloadDelegate(appUrl: appUrl, isTrollAppsUpdate: isTrollAppsUpdate)

    guard let url = URL(string: appUrl) else {
        //completion(FunctionStatus(error: true, message: ErrorMessage(title: "INVALID_DOWNLOAD_URL", body: "LIKELY_A_REPO_ISSUE")))
        return
    }
    
    print("INITIATING DOWNLOAD TASK")

    let downloadTask = URLSession(configuration: .default, delegate: downloadDelegate, delegateQueue: nil).downloadTask(with: url)
    downloadTask.resume()
}
