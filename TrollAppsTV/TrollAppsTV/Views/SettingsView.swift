//
//  SettingsView.swift
//  TrollAppsTV
//
//  Created by Bonnie on 7/30/24.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SourcesViewModel
    
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
            Button() {
                viewModel.setDefaultSources()
            } label: {
                Image(systemName: "wrench")
                Text("Reset default sources")
            }
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SourcesViewModel())
    }
}

func Respring() {
    guard let window = UIApplication.shared.windows.first else { return }; while true { window.snapshotView(afterScreenUpdates: false) }
}
