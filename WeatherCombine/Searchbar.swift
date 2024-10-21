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
            TextField("Search city... ", text: $text)
                .padding(.leading, 10)
                .frame(height: 40)
                .foregroundStyle(.white)
            Button(action: {
                onSearch()
                text = ""
            }) {
                Image(systemName: "magnifyingglass")
                    .padding(6)
            }
            .padding(.leading, -20)
            .frame(width: 40, height: 40)
            
            .cornerRadius(8)
            .foregroundColor(.white)
        }
        
        .background(Color(.systemGray3))
        .cornerRadius(20)
        .padding()
    }
}

#Preview {
    SearchBar(text: .constant("Morelia")) {
        print("")
    }
}
