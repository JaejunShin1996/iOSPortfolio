//
//  SKProduct-LocalisedPrice.swift
//  JaejunShinPortfolio
//
//  Created by Jaejun Shin on 13/9/2022.
//

import Foundation
import StoreKit

extension SKProduct {
    var localisedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
