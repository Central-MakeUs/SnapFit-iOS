//
//  PostAccordionView.swift
//  SnapFit
//
//  Created by 정정욱 on 8/22/24.
//

import SwiftUI

struct PostAccordionView: View {
    @Binding var selectedTime: String
    @State private var isExpanded = false

    let timeOptions: [PostPrice] // 시간 옵션

    var body: some View {
        VStack(alignment: .leading) {
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
                    ForEach(timeOptions, id: \.time) { option in
                        Button(action: {
                            withAnimation {
                                selectedTime = option.time
                                // 가격은 사용자가 직접 입력하도록 초기화
                                isExpanded = false
                            }
                        }) {
                            Text(option.time)
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
