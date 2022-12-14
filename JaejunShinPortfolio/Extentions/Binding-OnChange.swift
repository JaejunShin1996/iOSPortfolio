//
//  Binding-OnChange.swift
//  JaejunShinPortfolio
//
//  Created by Jaejun Shin on 14/8/2022.
//

import SwiftUI

// This extension helps update data as soon as users change values.
extension Binding {
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }
}
