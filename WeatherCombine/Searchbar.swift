//
//  Searchbar.swift
//  WeatherCombine
//
//  Created by Marco Alonso on 20/10/24.
//

import Foundation
import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var onSearch: () -> Void
    
    var body: some View {
        HStack {
            TextField("Search city...", text: $text)
                .padding(.leading, 10)
                .frame(height: 40)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            Button(action: {
                onSearch()
            }) {
                Image(systemName: "magnifyingglass")
                    .padding(.trailing, 10)
            }
            .frame(height: 40)
            .background(Color.blue)
            .cornerRadius(8)
            .foregroundColor(.white)
        }
        .padding()
    }
}
