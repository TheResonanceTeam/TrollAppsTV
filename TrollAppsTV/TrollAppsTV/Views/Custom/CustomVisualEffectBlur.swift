//
//  CustomVisualEffectBlur.swift
//  TrollAppsTV
//
//  Created by Bonnie on 7/30/24.
//

import SwiftUI

struct VisualEffectBlur<Content: View>: View {
    var blurStyle: UIBlurEffect.Style
    @ViewBuilder var content: Content

    var body: some View {
        ZStack {
            VisualEffectView(blurStyle: blurStyle)
            content
        }
        .compositingGroup()
    }
}

struct VisualEffectView: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
