//
//  TermsView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/14/24.
//

import SwiftUI



import SwiftUI

struct TermsView: View {
    @State private var isAllAgreed = false // 전체동의 토글 상태
    @State private var isTermsAgreed = false // 이용약관 동의 토글 상태
    @State private var isPrivacyPolicyAgreed = false // 개인정보 처리 방침 동의 토글 상태
    @State private var isMarketingAgreed = false // 광고성 정보 수신 및 마케팅 활용 동의 토글 상태
    @State private var isConfirmButtonEnabled = false // 확인 버튼 활성화 상태

    var body: some View {
        VStack(alignment: .leading) {
            
            Group {
                Text("스냅핏 서비스 이용약관에\n동의해주세요.")
                    .font(.title2)
                    .bold()
                    .padding(.bottom)
                    .padding(.top, 50)
                
                Text("서비스 시작 및 가입을 위해 먼저\n가입 및 정보 제공에 동의해 주세요.")
                    .font(.subheadline)
                    .foregroundColor(Color(.systemGray))
                    .padding(.bottom)
            }
            .padding(.horizontal)

            
            Group {
                Button {
                    isAllAgreed.toggle()
                    isTermsAgreed = isAllAgreed
                    isPrivacyPolicyAgreed = isAllAgreed
                    isMarketingAgreed = isAllAgreed
                    updateConfirmButtonState()
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
                            .foregroundColor(isAllAgreed ? Color(.white) : Color(.systemGray))

                        Spacer()
                    }
                    .padding()
                    .background(isAllAgreed ? Color(.black) : Color(.systemGray4))
                    .cornerRadius(5)
                }

                TermsToggleButton(
                    isAgreed: $isTermsAgreed,
                    title: "이용약관 동의",
                    isRequired: true,
                    url: URL(string: "https://mixolydian-beef-6a0.notion.site/3b731e9f5880466e9df899bf30a66cfb?pvs=4")!
                ) {
                    updateAllAgreed()
                    updateConfirmButtonState()
                }

                TermsToggleButton(
                    isAgreed: $isPrivacyPolicyAgreed,
                    title: "개인정보 처리 방침 동의",
                    isRequired: true,
                    url: URL(string: "https://example.com/privacy")!
                ) {
                    updateAllAgreed()
                    updateConfirmButtonState()
                }

                TermsToggleButton(
                    isAgreed: $isMarketingAgreed,
                    title: "광고성 정보 수신 및 마케팅 활용 동의",
                    isRequired: false,
                    url: URL(string: "https://example.com/marketing")!
                ) {
                    updateAllAgreed()
                    updateConfirmButtonState()
                }
                
                Spacer()
                
               
            }
            .padding(.horizontal)
           
            
            Button {
                // Action for "확인"
            } label: {
                HStack(spacing: 20) {
                    Spacer()
                     
                    Text("다음")
                        .font(.headline)
                        .bold()
                        .foregroundColor(isConfirmButtonEnabled ? Color(.white) : Color(.systemGray))

                    Spacer()
                }
                .padding()
                .background(isConfirmButtonEnabled ? Color(.black) : Color(.systemGray4))
            
            }
        }
    }

    private func updateAllAgreed() {
        isAllAgreed = isTermsAgreed && isPrivacyPolicyAgreed && isMarketingAgreed
    }

    private func updateConfirmButtonState() {
        isConfirmButtonEnabled = (isTermsAgreed && isPrivacyPolicyAgreed) || (isTermsAgreed && isPrivacyPolicyAgreed && isMarketingAgreed)
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
                        .foregroundColor(isAgreed ? Color(.black) : Color(.systemGray2))
                } else {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("[선택] 광고성 정보 수신 및")
                        Text("마케팅 활용 동의")
                    }
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(isAgreed ? Color(.black) : Color(.systemGray2))
                }

                Spacer()

                Button {
                    isShowingSheet.toggle()
                } label: {
                    Text("더보기")
                        .font(.subheadline)
                        .foregroundColor(isAgreed ? Color(.black) : Color(.systemGray2))
                        .underline()
                }
                .padding(.trailing, 5)
            }
            .padding()
        }
        .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
        .cornerRadius(2)
        .sheet(isPresented: $isShowingSheet) {
            WebView(url: url)
        }
    }
}

#Preview {
    TermsView()
}
