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
        NavigationView {
            Form {
                Section(footer: Text("Respringing your device may help if an app isn't appearing on your home screen right away.")) {
                    Button(action: {
                        Respring()
                    }) {
                        HStack {
                            Image(systemName: "progress.indicator")
                            Text("Respring Device")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                Section(footer: Text("Clearing TrollApps's temporary folder may help if app downloads/installs are failing.")) {
                    if #available(tvOS 15.0, *) {
                        Button(role: .destructive, action: {
                            clearTrollAppsFolder()
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Clear Temp Folder")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    } else {
                        Button(action: {
                            clearTrollAppsFolder()
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Clear Temp Folder")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                
                Section(footer: Text("Reset default sources if you deleted the original sources provided by TrollApps and wish to get them back.")) {
                    Button(action: {
                        if deleteDefaultSourcesFile() {
                            print("resetting default sources")
                            showingAlert = true
                        }
                    }) {
                        HStack {
                            Image(systemName: "wrench")
                            Text("Reset Default Sources")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
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
            .navigationTitle("Settings")
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
