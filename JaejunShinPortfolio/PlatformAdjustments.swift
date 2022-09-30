//
//  PlatformAdjustments.swift
//  JaejunShinPortfolio
//
//  Created by Jaejun Shin on 29/9/2022.
//

import SwiftUI

typealias ImageButtonStyle = BorderlessButtonStyle

extension Notification.Name {
    static let willResignActive = UIApplication.willResignActiveNotification
}

struct StackNavigationView<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        NavigationView(content: content)
            .navigationViewStyle(.stack)
    }
}
