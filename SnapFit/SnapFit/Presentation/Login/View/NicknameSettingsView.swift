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
    @Environment(\.presentationMode) var presentationMode // Environment variable to dismiss the view
    
    @EnvironmentObject var viewModel: LoginViewModel
    var interactor: LoginBusinessLogic?
    @State private var shouldNavigate = false
    
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
            
            TextField("8자 이내 닉네임을 작성해주세요", text: $inputText)
                .padding(15) // 내부 콘텐츠에 패딩을 추가하여 높이 조절
                .frame(height: 48)
                .background(Color.white)
                .cornerRadius(5)
                .font(.callout)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(inputText.count > 8 ? Color.red : Color.gray, lineWidth: 1)
                ) // 테두리를 추가하여 텍스트 필드 스타일 유지
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
                .onChange(of: inputText) { newValue in
                    isConfirmButtonEnabled = newValue.count >= 3 && newValue.count <= 8
                }
            
            if inputText.count > 8 {
                Text("닉네임은 3자에서 8자 사이로 작성해주세요.")
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
            
            Button {
                // Action for "확인"
                viewModel.nickName = inputText
                shouldNavigate.toggle()
            } label: {
                HStack(spacing: 20) {
                    Spacer()
                    Text("다음")
                        .font(.callout)
                        .bold()
                        .foregroundColor(isConfirmButtonEnabled ? Color(.white) : Color(.systemGray))
                    Spacer()
                }
                .padding()
                .frame(height: 48)
                .background(isConfirmButtonEnabled ? Color(.black) : Color(.systemGray4))
                .cornerRadius(5)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 40, trailing: 20))
            }
            .disabled(!isConfirmButtonEnabled)
        }
        .navigationDestination(isPresented: $shouldNavigate) {
            GridSelectionView(columnsCount: 2, interactor: interactor)
                .navigationBarBackButtonHidden(true)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
        }
    }
}

#Preview {
    NicknameSettingsView()
        .environmentObject(LoginViewModel())
}
