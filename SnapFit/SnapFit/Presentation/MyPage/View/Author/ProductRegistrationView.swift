//
//  ProductRegistrationView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/25/24.
//
import SwiftUI

struct ProductRegistrationView: View {
    @Environment(\.presentationMode) var presentationMode
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
                TitleSection(inputText: $inputText, isConfirmButtonEnabled: $isConfirmButtonEnabled)
                PhotosSection()
                DescriptionSection(descriptionText: $descriptionText, maxCharacterLimit: maxCharacterLimit)
                SnapSelectionSection(selectedSnap: $selectedSnap)
                MoodSection()
                LocationSection()
                OptionSection(priceText: $priceText)
                AdditionalCostSection(additionalPriceText: $additionalPriceText)
                ReserveButton()
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
                Text("상품등록")
                    .font(.headline)
                    .foregroundColor(.black)
            }
        }
    }
    
    // 서브뷰를 아래에 정의합니다.
    
    private struct TitleSection: View {
        @Binding var inputText: String
        @Binding var isConfirmButtonEnabled: Bool
        
        var body: some View {
            SectionHeaderView(title: "제목")
                .padding(.bottom, 20)
            VStack(spacing: 0) {
                TextField("제목을 작성해주세요", text: $inputText)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(5)
                    .font(.callout)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .onChange(of: inputText) { newValue in
                        isConfirmButtonEnabled = newValue.count >= 18
                    }
                    .frame(height: 48)
                    .padding(.bottom, 8)
                
                HStack {
                    Spacer()
                    Text("\(inputText.count)/18")
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 16)
        }
    }
    
    private struct PhotosSection: View {
        var body: some View {
            SectionHeaderView(title: "사진")
                .padding(.bottom, 20)
            SelectPhotosView()
                .padding(.bottom, 24)
                .padding(.horizontal, 16)
        }
    }
    
    private struct DescriptionSection: View {
        @Binding var descriptionText: String
        let maxCharacterLimit: Int
        
        var body: some View {
            SectionHeaderView(title: "설명")
                .padding(.bottom, 20)
            VStack {
                TextEditor(text: $descriptionText)
                    .frame(height: 214)
                    .colorMultiply(Color("MainBoxbBackColor"))
                    .cornerRadius(10)
                    .onChange(of: descriptionText) { newValue in
                        if descriptionText.count > maxCharacterLimit {
                            descriptionText = String(descriptionText.prefix(maxCharacterLimit))
                        }
                    }
                    .foregroundColor(.black)
                
                HStack {
                    Spacer()
                    Text("\(descriptionText.count)/\(maxCharacterLimit)")
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 16)
        }
    }
    
    private struct SnapSelectionSection: View {
        @Binding var selectedSnap: String
        
        var body: some View {
            SectionHeaderView(title: "스튜디오 유무")
                .padding(.bottom, 16)
            HStack {
                Button(action: {
                    selectedSnap = "indoor"
                }) {
                    Text("실내스냅")
                        .font(.callout)
                        .foregroundColor(selectedSnap == "indoor" ? Color.white : Color(.gray))
                        .frame(width: 114, height: 53)
                        .background(selectedSnap == "indoor" ? Color.black : Color(.systemGray6))
                        .cornerRadius(5)
                }
                
                Button(action: {
                    selectedSnap = "outdoor"
                }) {
                    HStack {
                        Text("야외스냅")
                            .font(.callout)
                            .foregroundColor(selectedSnap == "outdoor" ? Color.white : Color(.gray))
                        if selectedSnap != "outdoor" {
                            Image("addButtonImage")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    }
                    .frame(width: 114, height: 53)
                    .background(selectedSnap == "outdoor" ? Color.black : Color(.systemGray6))
                    .cornerRadius(5)
                }
            }
            .padding(.bottom, 30)
            .padding(.horizontal, 16)
        }
    }
    
    private struct MoodSection: View {
        var body: some View {
            SectionHeaderView(title: "분위기")
                .padding(.bottom, 16)
            Button(action: {}) {
                Image("addButtonImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .frame(width: 114, height: 53)
            .background(Color(.systemGray6))
            .cornerRadius(5)
            .padding(.bottom, 24)
            .padding(.horizontal, 16)
        }
    }
    
    private struct LocationSection: View {
        var body: some View {
            SectionHeaderView(title: "위치")
                .padding(.bottom, 16)
            Button {
                // Action for "확인"
                // 서버랑 액션이 들어갈듯
            } label: {
                HStack(spacing: 20) {
                    NavigationLink(destination: GridSelectionView(columnsCount: 3).navigationBarBackButtonHidden(true)) {
                        Image("addButtonImage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                }
            }
            .frame(width: 114, height: 53)
            .background(Color(.systemGray6))
            .cornerRadius(5)
            .padding(.bottom, 24)
            .padding(.horizontal, 16)
        }
    }
    
    private struct OptionSection: View {
        @Binding var priceText: String
        
        var body: some View {
            SectionHeaderView(title: "옵션")
                .padding(.bottom, 16)
            VStack(spacing: 20) {
                AccordionView()
                    .frame(maxWidth: .infinity) // 유동적인 너비를 설정
                
                TextField("가격", text: $priceText)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(5)
                    .font(.callout)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .frame(height: 48)
                    .padding(.bottom, 30)
            }
            .padding(.horizontal, 16)
        }
    }
    
    private struct AdditionalCostSection: View {
        @Binding var additionalPriceText: String
        
        var body: some View {
            SectionHeaderView(title: "인원 추가 비용")
                .padding(.bottom, 16)
            TextField("가격", text: $additionalPriceText)
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(Color.white)
                .cornerRadius(5)
                .font(.callout)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .frame(height: 48)
                .padding(.horizontal)
                .padding(.bottom, 24)
        }
    }
    
    private struct ReserveButton: View {
        var body: some View {
            NavigationLink(destination: AuthorReservationView().navigationBarBackButtonHidden(true)) {
                HStack(spacing: 20) {
                    Spacer()
                    Text("예약하기")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .frame(height: 48)
                .background(Color.black)
                .cornerRadius(5)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 20))
            }
        }
    }
}

#Preview {
    ProductRegistrationView()
}
