//
//  AccordionView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/25/24.
//

import SwiftUI

struct AccordionView: View {
    @Binding var selectedTime: String
    @Binding var selectedPrice: Int
    @State private var isExpanded = false

    let timeOptions: [Price]

    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(selectedTime.isEmpty ? "시간을 선택해주세요" : selectedTime)
                        .foregroundStyle(Color(.systemGray2))
                        .font(.callout)
                    
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                )
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(timeOptions, id: \.min) { time in
                        Button(action: {
                            withAnimation {
                                selectedTime = "\(time.min ?? 0)분"
                                selectedPrice = time.price ?? 0
                                isExpanded = false
                            }
                        }) {
                            Text("\(time.min ?? 0)분")
                                .foregroundColor(.black)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Divider()
                    }
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.top, 5)
            }
        }
    }
}
