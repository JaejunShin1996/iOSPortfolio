//
//  PlatformAdjustments.swift
//  JaejunShinPortfolioMac
//
//  Created by Jaejun Shin on 29/9/2022.
//

import SwiftUI

typealias InsetGroupedListStyle = SidebarListStyle
typealias ImageButtonStyle = BorderlessButtonStyle

extension Notification.Name {
    static let willResignActive = NSApplication.willResignActiveNotification
}

struct StackNavigationView<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
    }
}
