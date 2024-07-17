//
//  BTSecureField.swift
//  SwiftUI Boilerplate
//
//  Created by Ian Argyle on 7/9/24.
//

import SwiftUI

struct BTSecureField: View {
    @Binding var text: String
    @Binding var errorMessage: String
    let placeholder: String
    
    init(
        text: Binding<String>,
        errorMessage: Binding<String> = .constant(""),
        placeholder: String = ""
    ) {
        self._text = text
        self._errorMessage = errorMessage
        self.placeholder = placeholder
    }
    
    var body: some View {
        VStack {
            SecureField(placeholder, text: $text)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(!errorMessage.isEmpty ? Color.red : Color.gray)
                )
                .disableAutocorrection(true)
                .autocapitalization(.none)
                
            if !errorMessage.isEmpty {
                HStack {
                    Text(errorMessage)
                        .foregroundColor(Color.red)
                    Spacer()
                }
            }
        }
    }
}

struct BTSecureField_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var text: String = ""
        @State var errorMessage: String = ""
        
        var body: some View {
            BTSecureField(text: $text, errorMessage: $errorMessage, placeholder: "Test Placeholder")
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
    }
}
