//
//  MoodSelectionView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/25/24.
//

import SwiftUI

struct MoodSelectionView: View {
    
    @State private var tags: [String] = []
    @State private var newTag: String = ""
    
    var body: some View {
        // Tags Section
        VStack(alignment: .leading, spacing: 10) {
         
            
            // Tag Display
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(tags, id: \.self) { tag in
                        Text(tag)
                            .font(.subheadline)
                            .padding(8)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(.horizontal)
            }
            
            
            // Tag Input
            HStack {
                TextField("분위기 입력", text: $newTag)
                    .padding(15)
                    .background(Color.white)
                    .cornerRadius(10)
                    .font(.headline)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding(.trailing, 8)
                
                Button(action: {
                    addTag()
                }) {
                    Image(systemName: "plus")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(10)
                        .background(Color.white)
                        .clipShape(Circle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal)
        }
    }
    private func addTag() {
        let trimmedTag = newTag.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedTag.isEmpty && !tags.contains(trimmedTag) {
            tags.append(trimmedTag)
            newTag = ""
        }
    }
}

#Preview {
    MoodSelectionView()
}
