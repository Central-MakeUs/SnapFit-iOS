//
//  MyProfileEdit.swift
//  SnapFit
//
//  Created by 정정욱 on 7/24/24.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct MyProfileEdit: View {
    @Environment(\.presentationMode) var presentationMode // Environment variable to dismiss the view
    
    @ObservedObject var viewModel : ProfileViewModel
    
    @State private var inputText: String = ""
    @State private var isConfirmButtonEnabled = false
    
    @State private var tags: [String] = []
    @State private var newTag: String = ""
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                // Spacer로 위쪽 여백을 만듦
                Spacer(minLength: 40)
                
                PhotosPicker(selection: $viewModel.selectedItem) {
                    if let profileImage = viewModel.profileImage {
                        profileImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 86, height: 86)
                            .clipShape(Circle())
                    } else {
                        Image("profile")
                            .resizable()
                            .frame(width: 86, height: 86)
                            .foregroundStyle(Color(.systemGray4))
                    }
                    
                }
                .padding()
                
                Spacer(minLength: 20) // 여백을 추가하여 텍스트와 텍스트 필드 사이에 공간을 만듦
                
                VStack(alignment: .leading) {
                    Text("닉네임")
                        .font(.title3)
                        .bold()
                    
                    TextField("닉네임을 작성해주세요", text: $inputText)
                        .padding(15) // 내부 콘텐츠에 패딩을 추가하여 높이 조절
                        .background(Color.white)
                        .cornerRadius(10)
                        .font(.headline)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        ) // 테두리를 추가하여 텍스트 필드 스타일 유지
                        .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
                        .onChange(of: inputText) { newValue in
                            isConfirmButtonEnabled = newValue.count >= 3
                        }
                }
                .padding(.top, 20) // 위쪽 여백을 추가하여 텍스트 필드가 PhotosPicker와 떨어지게 함
                
                
                
                // Tags Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("분위기")
                        .font(.headline)
                        .padding(.top, 20)
                    
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
                
                
                Spacer(minLength: 180)
                
                Button(action: {
                    // 버튼 액션
                   
                }) {
                    Text("저장하기")
                        .font(.headline)
                        .bold()
                        .foregroundColor(Color.white)
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 65)
                        .background(Color.black)
                        .cornerRadius(5)
                }
                
            }
            .padding(.horizontal) // 좌우 여백을 추가하여 전체 뷰의 여백을 조정
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
                Text("프로필 수정")
                    .font(.headline)
                    .foregroundColor(.black)
            }
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
    MyProfileEdit(viewModel: ProfileViewModel())
}