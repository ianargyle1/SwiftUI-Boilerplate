//
//  BTButton.swift
//  SwiftUI Boilerplate
//
//  Created by Ian Argyle on 7/8/24.
//

import SwiftUI

struct BTButton: View {
    let title: String
    let background: Color
    let disabledBackground: Color
    let forground: Color
    let radius: CGFloat
    let fullWidth: Bool
    let action: () -> Void
    
    @Binding var disabled: Bool
    
    init(
        title: String,
        background: Color = .blue,
        disabledBackground: Color = .gray,
        foreground: Color = .white,
        radius: CGFloat = 10,
        fullWidth: Bool = false,
        action: @escaping () -> Void,
        disabled: Binding<Bool> = .constant(false)
    ) {
        self.title = title
        self.background = background
        self.disabledBackground = disabledBackground
        self.forground = foreground
        self.radius = radius
        self.fullWidth = fullWidth
        self.action = action
        self._disabled = disabled
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: fullWidth ? .infinity : nil)
                .bold()
                .padding()
                .foregroundColor(forground)
                .background(disabled ? disabledBackground : background)
                .cornerRadius(radius)
            
          }
        .disabled(disabled)
    }
}

#Preview {
    BTButton(title: "Test") {}
}
