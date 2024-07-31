//
//  AlertManager.swift
//  TrollApps
//
//  Created by Cleopatra on 2023-12-12.
//

import SwiftUI
import Combine

struct ErrorMessage: Hashable {
    var title: String
    var body: String
}

struct FunctionStatus: Hashable {
    var error : Bool
    var message : ErrorMessage?
}

class AlertManager: ObservableObject {
    @Published var isAlertPresented = false
    @Published var alertTitle = Text("")
    @Published var alertBody = Text("")
    @Published var showButtons = true
    @Published var showBody = true
    @Published var canAnimate = true
    @Published var showIPADetails = true
    @Published var IPAUUID = UUID()

    private var cancellables: Set<AnyCancellable> = []
}

struct AlertManagerView: View {
    
    @EnvironmentObject var alertManager: AlertManager

    var body: some View {
        ZStack {
            if alertManager.isAlertPresented {
                Color.black
                    .ignoresSafeArea()
                    .opacity(0.1)
                VStack(alignment: .center) {
                    if alertManager.showIPADetails {
                        Text("Details Here")
                            .bold()
                    } else {
                        alertManager.alertTitle
                            .bold()

                        if alertManager.showBody || alertManager.showButtons {
                            Divider()
                                .opacity(0.1)
                        }
                        
                        if alertManager.showBody {
                            alertManager.alertBody
                        }
                    }

                    if alertManager.showButtons {
                        if #available(tvOS 16.0, *) {
                            VStack {
                                Divider()
                                
                                Text("OK")
                                    .bold()
                                
                                    .frame(maxWidth: 270)
                                    .padding(.vertical, 6)
                            }
                            .background(
                                Color(.darkGray)
                                    .opacity(0.1)
                            )
                            .onTapGesture {
                                withAnimation {
                                    alertManager.isAlertPresented = false
                                }
                            }
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                }
                .padding(.horizontal, 5)
                .padding(.vertical)
                .frame(maxWidth: 300)
                .background(
                    Color(.darkGray)
                        .cornerRadius(16)
                        .opacity(0.95)
                        .blur(radius: 0.5))
            }
        }
        .opacity(alertManager.isAlertPresented ? 1 : 0.25)
        .animation(.spring().speed(2), value: alertManager.isAlertPresented)
    }
}
