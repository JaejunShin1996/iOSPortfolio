//
//  CloudError.swift
//  JaejunShinPortfolio
//
//  Created by Jaejun Shin on 23/9/2022.
//

import SwiftUI

struct CloudError: Identifiable, ExpressibleByStringInterpolation {
    var id: String { message }
    var message: String

    var localizedMessage: LocalizedStringKey {
        LocalizedStringKey(message)
    }

    init(stringLiteral value: String) {
        self.message = value
    }
}
