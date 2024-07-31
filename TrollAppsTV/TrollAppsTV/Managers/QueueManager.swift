//
//  QueueManager.swift
//  TrollApps
//
//  Created by Cleopatra on 2023-12-16.
//

import SwiftUI

enum ActionType: String, Decodable, Equatable, Hashable {
    case download
    case install
    case uninstall
    case finished
}

struct QueueItem: Equatable, Hashable {
    var id = UUID()
    
    var action: ActionType
    
    var icon: String
    var name: String
    
    var bundleIdentifier: String?
    var downloadURL: String?
    
    var progress : Double = 0
    
    var error :Bool = false
    var message : ErrorMessage = ErrorMessage(title: "", body: "")
    
    var queued = false
}


class QueueManager: ObservableObject {
    @Published var queue : [QueueItem] = []
    @Published var isProcessing : Bool = false
    @Published var hasFinished : Bool = false
    @Published var promptInstall : Bool = false

    @Published var canClose : Bool = true

    func addQueueItem(item: QueueItem) {
        queue.append(item)
    }
    
    func removeQueueItem(itemID: UUID) {
        if let index = queue.firstIndex(where: { $0.id == itemID }) {
            queue.remove(at: index)
        }
    }
    
    func removeQueueItem(bundleIdentifier: String) {
        if let index = queue.firstIndex(where: { $0.bundleIdentifier == bundleIdentifier }) {
            queue.remove(at: index)
        }
    }
    
    func hasQueueItem(bundleIdentifier: String) -> Bool {
        return queue.contains { $0.bundleIdentifier == bundleIdentifier }
    }
    
    func updateQueueItemProgress(itemID: UUID, progress: Double) {
        if let index = queue.firstIndex(where: { $0.id == itemID }) {
            queue[index].progress = progress
        }
    }
    
    func getQueueItem(bundleIdentifier: String) -> QueueItem? {
        if let index = queue.firstIndex(where: { $0.bundleIdentifier == bundleIdentifier }) {
            return queue[index]
        }
        
        return nil
    }
}
