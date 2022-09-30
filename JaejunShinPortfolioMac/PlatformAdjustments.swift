//
//  PlatformAdjustments.swift
//  JaejunShinPortfolioMac
//
//  Created by Jaejun Shin on 29/9/2022.
//

import CloudKit
import SwiftUI

typealias InsetGroupedListStyle = DefaultListStyle
typealias ImageButtonStyle = BorderlessButtonStyle
typealias MacOnlySpacer = Spacer

extension Notification.Name {
    static let willResignActive = NSApplication.willResignActiveNotification
}

struct StackNavigationView<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
    }
}

extension Section where Parent: View, Content: View, Footer: View {
    func disableCollapsing() -> some View {
        self.collapsible(false)
    }
}

extension View {
    func macOnlyPadding() -> some View {
        self.padding()
    }
}

extension CKContainer {
    static func `default`() -> CKContainer {
        return CKContainer(identifier: "iCloud.com.jaejunshin.JaejunShinPortfolio")
    }
}
