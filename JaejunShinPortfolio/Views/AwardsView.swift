//
//  AwardsView.swift
//  JaejunShinPortfolio
//
//  Created by Jaejun Shin on 18/8/2022.
//

import SwiftUI

struct AwardsView: View {
    static let tag = "Awards"
    
    var gridColums: [GridItem] {
        [GridItem(.adaptive(minimum: 100, maximum: 100))]
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridColums) {
                    ForEach(Award.allAwards) { award in
                        Button {
                            //
                        } label: {
                            Image(systemName: award.image)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 100, height: 100)
                                .foregroundColor(Color.secondary.opacity(0.5))
                        }
                    }
                }
            }
            .navigationTitle("Awards")
        }
    }
}

struct AwardsView_Previews: PreviewProvider {
    static var previews: some View {
        AwardsView()
    }
}
