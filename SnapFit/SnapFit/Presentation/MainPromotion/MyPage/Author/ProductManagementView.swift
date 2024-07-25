//
//  ProductManagementView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/25/24.
//

import SwiftUI

struct ProductManagementView: View {
    
    
    @Environment(\.presentationMode) var presentationMode // Environment variable to dismiss the view
    
    // columns 의 갯수를 2개로 설정
    let columns: [GridItem] = [
        //GridItem을 담을 수 있는 배열 생성
        // .flexible : 크기를 화면 프레임에 유연하게 늘렸다 줄었다 할 수 있게 설정
        GridItem(.flexible(), spacing: 6, alignment: nil),
        GridItem(.flexible(), spacing: 6, alignment: nil),
    ]
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    
                    Text("등록된 상품")
                        .font(.title3)
                        .bold()
                        .padding(.bottom)
                    
                    
                    // 상품 탭의 내용
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(0..<2, id: \.self) { item in
                                CardView(sizeType: .middle)
                                    .frame(width: 174, height: 322)
                                    .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
                            }
                        }
                    }
                 
                    .padding(.bottom)
                    
                    
                    
                    
                }
                .padding(.horizontal) // 좌우 여백을 추가하여 전체 뷰의 여백을 조정
            }
            
            // Save Button as footer
            Button(action: {
                // 버튼 액션
            }) {
                NavigationLink(destination: ProductRegistrationView().navigationBarBackButtonHidden(true)) {
                    Text("상품 등록하기")
                        .font(.headline)
                        .bold()
                        .foregroundColor(Color.white)
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 65)
                        .background(Color.black)
                        .cornerRadius(5)
                        .padding(.horizontal)
                        .padding(.bottom, 20) // 추가 여백
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("상품관리")
                    .font(.headline)
                    .foregroundColor(.black)
            }
        }
    }
    
    
    
}

#Preview {
    ProductManagementView()
}
