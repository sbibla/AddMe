//
//  CustomModifiers.swift
//  MultiplyMe
//
//  Created by Saar Bibla on 6/4/24.
//


import SwiftUI

struct StandardButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(.bordered)
            .tint(.brandPrimary)
            .controlSize(.large)
    }
}
