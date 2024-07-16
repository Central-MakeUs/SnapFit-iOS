//
//  NicknameSettingsView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/16/24.
//

import SwiftUI

struct NicknameSettingsView: View {
   
    @State private var inputText: String = ""
    @State private var isConfirmButtonEnabled = false
   
    var body: some View {
        VStack(alignment: .leading) {
            
            Group {
                Text("스냅핏에 오신 걸 환영합니다!\n닉네임을 설정해주세요.")
                    .font(.title2)
                    .bold()
                    .padding(.bottom)
                    .padding(.top, 50)
                
            }
            .padding(.horizontal)

          
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

            Spacer()
           
            Button {
                // Action for "확인"
            } label: {
                HStack(spacing: 20) {
                    Spacer()
                     
                    Text("다음")
                        .font(.system(size: 20))
                        .bold()
                        .foregroundColor(isConfirmButtonEnabled ? Color(.white) : Color(.systemGray))

                    Spacer()
                }
                .padding()
                .background(isConfirmButtonEnabled ? Color(.black) : Color(.systemGray4))
                .cornerRadius(10)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
            }
            .disabled(!isConfirmButtonEnabled)
            // true일 때는 뷰가 비활성화되고, false일 때는 뷰가 활성화
        }
    }

}



#Preview {
    NicknameSettingsView()
}
