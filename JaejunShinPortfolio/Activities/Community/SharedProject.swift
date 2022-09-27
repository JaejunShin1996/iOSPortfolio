//
//  SharedProject.swift
//  JaejunShinPortfolio
//
//  Created by Jaejun Shin on 21/9/2022.
//

import Foundation

struct SharedProject: Identifiable {
    let id: String
    let title: String
    let detail: String
    let owner: String
    let closed: Bool

    static let example: SharedProject =
    SharedProject(id: "1", title: "Example", detail: "Detail", owner: "JaejunShin", closed: false)
}
