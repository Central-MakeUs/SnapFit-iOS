//
//  TermsView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/14/24.
//

import SwiftUI

struct TermsView: View {
    @State private var isAllAgreed = false // 전체동의 토글 상태
    @State private var isTermsAgreed = false // 이용약관 동의 토글 상태
    @State private var isPrivacyPolicyAgreed = false // 개인정보 처리 방침 동의 토글 상태
    @State private var isMarketingAgreed = false // 광고성 정보 수신 및 마케팅 활용 동의 토글 상태
    @State private var isConfirmButtonEnabled = false // 확인 버튼 활성화 상태
    
    @Environment(\.presentationMode) var presentationMode // Environment variable to dismiss the view
    @ObservedObject var viewModel: LoginViewModel
    var interactor: LoginBusinessLogic?
    
    var body: some View {
        VStack(alignment: .leading) {
            
            VStack {
                Text("스냅핏 서비스 이용약관에\n동의해주세요.")
                    .font(.title2)
                    .bold()
                    .padding(.bottom)
                    .padding(.top, 50)
                
                Text("서비스 시작 및 가입을 위해 먼저\n가입 및 정보 제공에 동의해 주세요.")
                    .font(.subheadline)
                    .foregroundColor(Color(.systemGray))
                    
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 88, trailing: 20))
          
    
            
            Group {
                Button {
                    let newValue = !isAllAgreed
                    isAllAgreed = newValue
                    isTermsAgreed = newValue
                    isPrivacyPolicyAgreed = newValue
                    isMarketingAgreed = newValue
                    updateConfirmButtonState() // 확인 버튼 활성화 상태 업데이트
                } label: {
                    HStack(spacing: 20) {
                        Image(isAllAgreed ? "Terms2" : "Terms")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 20, height: 30)
                            .padding(.leading, 5)
                        
                        Text("전체동의(선택 정보 포함)")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(isAllAgreed ? .white : Color(.systemGray))
                        
                        Spacer()
                    }
                    .padding()
                    .frame(height: 48)
                    .background(isAllAgreed ? .black : Color(.systemGray4))
                    .cornerRadius(5)
                }
                
                
                TermsToggleButton(
                    isAgreed: $isTermsAgreed,
                    title: "이용약관 동의",
                    isRequired: true,
                    url: URL(string: "https://mixolydian-beef-6a0.notion.site/3b731e9f5880466e9df899bf30a66cfb?pvs=4")!
                ) {
                    updateAllAgreed() // 전체 동의 상태 업데이트
                    updateConfirmButtonState() // 확인 버튼 활성화 상태 업데이트
                }
                
                TermsToggleButton(
                    isAgreed: $isPrivacyPolicyAgreed,
                    title: "개인정보 처리 방침 동의",
                    isRequired: true,
                    url: URL(string: "https://example.com/privacy")!
                ) {
                    updateAllAgreed() // 전체 동의 상태 업데이트
                    updateConfirmButtonState() // 확인 버튼 활성화 상태 업데이트
                }
                
                TermsToggleButton(
                    isAgreed: $isMarketingAgreed,
                    title: "광고성 정보 수신 및 마케팅 활용 동의",
                    isRequired: false,
                    url: URL(string: "https://example.com/marketing")!
                ) {
                    updateAllAgreed() // 전체 동의 상태 업데이트
                    updateConfirmButtonState() // 확인 버튼 활성화 상태 업데이트
                }
                
                
            }
            .padding(.horizontal)
            
            Spacer()
            
            // 기존의 Button 대신 NavigationLink를 직접 사용
            NavigationLink(destination: NicknameSettingsView(viewModel: viewModel, interactor: interactor).navigationBarBackButtonHidden(true)) {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(isConfirmButtonEnabled ? Color.black : Color(.systemGray4))
                        .frame(height: 48)
                    
                    HStack(spacing: 20) {
                        Spacer()
                        
                        Text("다음")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(isConfirmButtonEnabled ? .white : Color(.systemGray))
                        
                        Spacer()
                    }
                }
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 40, trailing: 20))
            .disabled(!isConfirmButtonEnabled)
            
         
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
    
    private func updateAllAgreed() {
        // 전체 동의 상태는 개별 동의 상태에 따라 업데이트
        isAllAgreed = isTermsAgreed && isPrivacyPolicyAgreed && isMarketingAgreed
    }
    
    private func updateConfirmButtonState() {
        // 확인 버튼 활성화 상태는 개별 동의 상태에 따라 결정
        isConfirmButtonEnabled = isTermsAgreed && isPrivacyPolicyAgreed
    }
}

struct TermsToggleButton: View {
    @Binding var isAgreed: Bool
    let title: String
    let isRequired: Bool
    let url: URL
    let action: () -> Void
    
    @State private var isShowingSheet = false
    
    var body: some View {
        Button {
            isAgreed.toggle()
            action()
        } label: {
            HStack(spacing: 20) {
                Image(isAgreed ? "Terms3" : "Terms")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 20, height: 30)
                    .padding(.leading, 5)
                
                if isRequired {
                    Text("[필수] \(title)")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(isAgreed ? .black : Color(.systemGray2))
                } else {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("[선택] 광고성 정보 수신 및")
                        Text("마케팅 활용 동의")
                    }
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(isAgreed ? .black : Color(.systemGray2))
                }
                
                Spacer()
                
                Button {
                    isShowingSheet.toggle()
                } label: {
                    Text("더보기")
                        .font(.subheadline)
                        .foregroundColor(isAgreed ? .black : Color(.systemGray2))
                        .underline()
                }
                .padding(.trailing, 5)
            }
            .padding()
            .frame(height: 48)
        }
        .frame(width: UIScreen.main.bounds.width * 0.9)
        .cornerRadius(2)
        .sheet(isPresented: $isShowingSheet) {
            WebView(url: url)
        }
    }
}

#Preview {
    TermsView(viewModel: LoginViewModel())
}
