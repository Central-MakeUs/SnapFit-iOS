//
//  ReusableGridSelectionView.swift
//  SnapFit
//
//  Created by 정정욱 on 8/22/24.
//

import SwiftUI

struct ReusableGridSelectionView: View {
    @Binding var isPresented: Bool
    @Binding var selectedItems: [String] // 선택된 아이템을 바인딩할 배열
    let title: String
    let maxSelectionCount: Int = 2 // 최대 선택 가능 수
    let items: [String] // 항목 리스트
    
    @State private var selectedIndices: Set<Int> = []
    @State private var showAlert = false
    
    let columnsCount: Int
    var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 6, alignment: nil), count: columnsCount)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .bold()
                .padding(.bottom, 10)
                .padding(.top, 20)
                .padding(.horizontal)
            
            Text("최대 \(maxSelectionCount)개까지 선택이 가능합니다.")
                .font(.subheadline)
                .foregroundColor(Color(.systemGray))
                .padding(.horizontal)
                .padding(.bottom, 20)
            
            ScrollView {
                LazyVGrid(columns: columns, alignment: .center, spacing: 19) {
                    ForEach(items.indices, id: \.self) { index in
                        Button {
                            if selectedIndices.contains(index) {
                                selectedIndices.remove(index)
                            } else if selectedIndices.count < maxSelectionCount {
                                selectedIndices.insert(index)
                            } else {
                                showAlert = true
                            }
                        } label: {
                            Text(items[index])
                                .foregroundColor(selectedIndices.contains(index) ? Color.white : Color.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .background(selectedIndices.contains(index) ? Color.black : Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                        }
                    }
                }
                .padding()
            }
            
            Spacer()
            
            Button(action: {
                // Confirm 버튼을 누르면 선택된 항목 반영
                selectedItems = selectedIndices.map { items[$0] }
                isPresented = false // Sheet 닫기
            }) {
                HStack(spacing: 20) {
                    Spacer()
                    Text("확인")
                        .font(.callout)
                        .bold()
                        .foregroundColor(selectedIndices.count > 0 ? Color.white : Color(.systemGray))
                    Spacer()
                }
                .padding()
                .frame(height: 48)
                .background(selectedIndices.count > 0 ? Color(.black) : Color(.systemGray4))
                .cornerRadius(5)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
            }
            .disabled(selectedIndices.count == 0)
        }
        .overlay(
            ZStack {
                if showAlert {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    
                    CustomAlertView(isPresented: $showAlert, message: "최대 \(maxSelectionCount)개까지 \n선택이 가능합니다.") {
                        showAlert = false
                    }
                    .frame(width: 300)
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2.5)
                }
            }
        )
    }
}
