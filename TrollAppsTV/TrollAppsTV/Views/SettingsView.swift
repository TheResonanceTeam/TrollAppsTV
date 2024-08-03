//
//  SettingsView.swift
//  TrollAppsTV
//
//  Created by Bonnie on 7/30/24.
//

import SwiftUI

struct SettingsView: View {
    @State private var showingAlert = false
    
    var body: some View {
        VStack {
            //  respring device
            if #available(tvOS 15.0, *) {
                Button() {
                    Respring()
                } label: {
                    Image(systemName: "progress.indicator") //  somehow they didn't add this icon until tvOS 18...
                    Text("Respring")
                }
            } else {
                Button() {
                    Respring()
                } label: {
                    Image(systemName: "arrow.clockwise")
                    Text("Respring")
                }
            }
            
            //  clear the temp folder
            if #available(tvOS 15.0, *) {
                Button(role: .destructive) {
                    clearTrollAppsFolder()
                } label: {
                    Image(systemName: "trash")
                    Text("Clear temp folder")
                }
            } else {
                Button() {
                    clearTrollAppsFolder()
                } label: {
                    Image(systemName: "trash")
                    Text("Clear temp folder")
                }
            }
            
            //  reset default sources incase user accidentally deletes them
            Button(action: {
                if deleteDefaultSourcesFile() {
                    print("resetting default sources")
                    showingAlert = true
                }
            }) {
                Image(systemName: "wrench")
                Text("Reset default sources")
            }
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Reset Default Sources"),
                    message: Text("Default sources have been reset. The app will now close."),
                    dismissButton: .default(Text("Okay")) {
                        closeTrollApps()
                    }
                )
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

func Respring() {
    guard let window = UIApplication.shared.windows.first else { return }; while true { window.snapshotView(afterScreenUpdates: false) }
}
