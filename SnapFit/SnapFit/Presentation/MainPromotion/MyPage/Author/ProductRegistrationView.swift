//
//  ProductRegistrationView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/25/24.
//

import SwiftUI

struct ProductRegistrationView: View {
    @Environment(\.presentationMode) var presentationMode // Environment variable to dismiss the view
    @State private var inputText: String = ""
    @State private var priceText: String = ""
    @State private var additionalPriceText: String = ""
    @State private var isConfirmButtonEnabled = false
    @State private var selectedSnap: String = "indoor"
    
    
    
    @State private var descriptionText: String = ""
    private let maxCharacterLimit = 500
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                
                Group{
                    Text("제목")
                        .font(.title3)
                        .bold()
                        .padding(.bottom)
                    
                    TextField("제목을 작성해주세요", text: $inputText)
                        .padding(15) // 내부 콘텐츠에 패딩을 추가하여 높이 조절
                        .background(Color.white)
                        .cornerRadius(10)
                        .font(.headline)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        ) // 테두리를 추가하여 텍스트 필드 스타일 유지
                        .onChange(of: inputText) { newValue in
                            isConfirmButtonEnabled = newValue.count >= 3
                        }
                        .padding(.bottom, 30)
                    
                    
                    SelectPhotosView()
                        .padding(.bottom, 30)
                }
                
                Text("스튜디오 유무")
                    .font(.title3)
                    .bold()
                    .padding(.bottom)
                
                Group{
                    HStack {
                        Button(action: {
                            selectedSnap = "indoor"
                        }) {
                            Text("실내스냅")
                                .foregroundColor(selectedSnap == "indoor" ? Color.white : Color(.gray))
                                .frame(width: 114, height: 53)
                                .background(selectedSnap == "indoor" ? Color.black : Color(.systemGray6))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                        }
                        
                        // Outdoor Snap Button
                        Button(action: {
                            selectedSnap = "outdoor"
                        }) {
                            Text("야외스냅")
                                .foregroundColor(selectedSnap == "outdoor" ? Color.white : Color(.gray))
                                .frame(width: 114, height: 53)
                                .background(selectedSnap == "outdoor" ? Color.black : Color(.systemGray6))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                        }
                        
                    }
                }
                .padding(.bottom, 30)
                
                Text("분위기")
                    .font(.title3)
                    .bold()
                    .padding(.bottom)
                
                MoodSelectionView()
                    .padding(.bottom, 30)
                
                Text("옵션")
                    .font(.title3)
                    .bold()
                    .padding(.bottom)
                
                Group {
                    VStack(spacing: 20){
                        AccordionView()
                        
                        TextField("가격", text: $priceText)
                            .padding(15) // 내부 콘텐츠에 패딩을 추가하여 높이 조절
                            .background(Color.white)
                            .cornerRadius(10)
                            .font(.headline)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                            ) // 테두리를 추가하여 텍스트 필드 스타일 유지
                            .padding(.bottom, 30)
                    }
                }
                
                Text("인원 추가 비용")
                    .font(.title3)
                    .bold()
                    .padding(.bottom)
                
                TextField("가격", text: $additionalPriceText)
                    .padding(15) // 내부 콘텐츠에 패딩을 추가하여 높이 조절
                    .background(Color.white)
                    .cornerRadius(10)
                    .font(.headline)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    ) // 테두리를 추가하여 텍스트 필드 스타일 유지
                    .padding(.bottom, 30)
                
                
                Text("설명")
                    .font(.title3)
                    .bold()
                    .padding(.bottom)
                
                // TexEditor 여러줄 - 긴글 의 text 를 입력할때 사용
                TextEditor(text: $descriptionText)
                    .frame(height: 214) // 크기 설정
                    .colorMultiply(Color.gray.opacity(0.5))
                    .cornerRadius(10)
                    .onChange(of: descriptionText) { newValue in
                        if descriptionText.count > maxCharacterLimit {
                            descriptionText = String(inputText.prefix(maxCharacterLimit))
                        }
                    }
                    .foregroundColor(.black) // 텍스트 색상 검정으로 설정
                
                HStack {
                    Spacer()
                    Text("\(descriptionText.count)/\(maxCharacterLimit)")
                        .foregroundColor(.gray)
                        .padding(.trailing, 16)
                }
                .padding(.bottom, 20)
                
                CustomDividerView()
                    .padding(.bottom)
                
                Text("위치")
                    .font(.title3)
                    .bold()
                    .padding(.bottom)
                
                HStack{
                    Button {
                        // Action for "확인"
                        // 서버랑 액션이 들어갈듯
                    } label: {
                        HStack(spacing: 20) {
                            NavigationLink(destination: GridSelectionView(columnsCount: 3, moods: [
                                "전체","강남구", "강동구", "강북구", "강서구", "관악구", "광진구", "구로구", "금천구",
                                "노원구", "도봉구", "동대문구", "동작구", "마포구", "서대문구", "서초구", "성동구",
                                "성북구", "송파구", "양천구", "영등포구", "용산구", "은평구", "종로구", "중구", "중랑구"
                            ]).navigationBarBackButtonHidden(true)) {
                                Image(systemName: "plus")
                                    .foregroundColor(.black)
                                    .frame(width: 114, height: 53)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                            }                        }
                    }
                    
                }
                .padding(.bottom, 30) // 추가 여백
                
                
                
                // Save Button as footer
                NavigationLink(destination: ProductRegistrationView().navigationBarBackButtonHidden(true)) {
                    Text("등록하기")
                        .font(.headline)
                        .bold()
                        .foregroundColor(Color.white)
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 65)
                        .background(Color.black)
                        .cornerRadius(5)
                    
                        .padding(.bottom, 20) // 추가 여백
                }
                
                
            }
            
            
        }
        .padding(.horizontal)
        
        
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
                Text("상품등록")
                    .font(.headline)
                    .foregroundColor(.black)
            }
        }
    }
}

#Preview {
    ProductRegistrationView()
}
