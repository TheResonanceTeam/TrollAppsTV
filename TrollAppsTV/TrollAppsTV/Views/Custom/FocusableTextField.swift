//
//  FocusableTextField.swift
//  TrollAppsTV
//
//  Created by Bonnie on 8/3/24.
//

import SwiftUI

struct FocusableTextField: UIViewRepresentable {
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: FocusableTextField
        
        init(parent: FocusableTextField) {
            self.parent = parent
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            parent.isFocusedBinding?.wrappedValue = true
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            parent.isFocusedBinding?.wrappedValue = false
        }
    }
    
    @Binding var text: String
    var placeholder: String
    var isFocusedBinding: Binding<Bool>?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.text = text
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
}
