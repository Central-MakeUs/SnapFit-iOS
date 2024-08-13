import SwiftUI
import _AuthenticationServices_SwiftUI

// View가 Presenter로부터 받는 정보를 정의하는 프로토콜
protocol LoginDisplayLogic {
    func display(viewModel: Login.LoadLogin.LoginPresentationViewModel)
    func displayVibes(viewModel: Login.LoadLogin.VibesPresentationViewModel)
}

// 로그인 화면을 정의하는 View
struct LoginView: View, LoginDisplayLogic {
    
    @ObservedObject var loginviewModel: LoginViewModel  // 로그인 관련 상태를 관리하는 ViewModel
    @ObservedObject var navigationModel: LoginNavigationModel  // 네비게이션 상태를 관리하는 모델
    
    var interactor: LoginBusinessLogic?  // Interactor와의 통신을 위한 참조
    
    // Presenter가 제공한 로그인 ViewModel을 기반으로 UI 업데이트
    func display(viewModel: Login.LoadLogin.LoginPresentationViewModel) {
        // 상태 업데이트가 메인 스레드에서 이루어지도록 보장
        DispatchQueue.main.async {
            // 로그인 후 화면 이동을 위한 목적지 결정
            let destination = viewModel.membershipRequired ? "termsView" : "splashAndTabView"
            
            // 소셜 로그인 타입에 따라 로그인 상태 업데이트
            switch viewModel.socialLoginType {
            case "kakao":
                if viewModel.membershipRequired {
                    // 카카오 로그인 상태 업데이트
                    self.loginviewModel.social = viewModel.socialLoginType
                    self.loginviewModel.isKakaoLogin = true
                    self.loginviewModel.oauthToken = viewModel.oauthToken ?? ""
                    self.loginviewModel.kakaoAccessToken = viewModel.kakaoAccessToken ?? ""
                    print("Kakao login failed verification kakaoAccessToken \(viewModel.kakaoAccessToken ?? "")")
                } else {
                    print("Kakao login successful")
                }
                
            case "apple":
                if viewModel.membershipRequired {
                    // 애플 로그인 상태 업데이트
                    self.loginviewModel.social = viewModel.socialLoginType
                    self.loginviewModel.isAppleLoggedIn = true
                    self.loginviewModel.oauthToken = viewModel.oauthToken ?? ""
                    self.loginviewModel.kakaoAccessToken = viewModel.kakaoAccessToken ?? ""
                    print("Apple login failed verification \(viewModel.oauthToken ?? "")")
                } else {
                    print("Apple login successful")
                }
                
            default:
                print("Unsupported social login type")  // 지원하지 않는 로그인 타입 처리
            }
            
            // 네비게이션 목적지로 이동
            navigationModel.navigationPath.append(destination)
        }
    }
    
    // Presenter가 제공한 분위기 ViewModel을 기반으로 UI 업데이트
    func displayVibes(viewModel: Login.LoadLogin.VibesPresentationViewModel) {
        DispatchQueue.main.async {
            // 분위기 상태 업데이트
            self.loginviewModel.vibes = viewModel.vibes
        }
    }
    
    var body: some View {
        NavigationStack(path: $navigationModel.navigationPath) {
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    Spacer().frame(height: 148)
                    
                    Group {
                        Image("appLogo")  // 앱 로고
                            .resizable()
                            .scaledToFill()
                            .frame(width: 155, height: 63)
                            .padding(.bottom, 24)
                        
                        Text("당신의 아름다운 순간을 담다.")
                            .font(.callout)
                            .foregroundColor(Color("LoginFontColor"))
                    }
                    .font(.title3)
                    
                    Spacer()
                    
                    // 로그인 버튼 그룹
                    LoginViewGroup(interactor: interactor)
                    
                    Spacer().frame(height: 32)
                }
                .padding(.horizontal, 16)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(
                    ZStack {
                        Color.black.ignoresSafeArea()  // 배경 색상
                        Image("LoginImages")  // 배경 이미지
                            .resizable()
                            .scaledToFit()
                            .frame(width: 211, height: 426)
                            .position(x: geometry.size.width - 16 - 211 / 2, y: 224 + 426 / 2)
                    }
                )
            }
            .navigationDestination(for: String.self) { destination in
                // 네비게이션 목적지에 따라 View를 설정
                switch destination {
                case "termsView":
                    TermsView(interactor: interactor)
                        .environmentObject(loginviewModel)
                        .environmentObject(navigationModel)
                        .navigationBarBackButtonHidden(true)
                case "NicknameSettingsView":
                    NicknameSettingsView(interactor: interactor)
                        .environmentObject(loginviewModel)
                        .environmentObject(navigationModel)
                        .navigationBarBackButtonHidden(true)
                case "GridSelectionView":
                    GridSelectionView(columnsCount: 2, interactor: interactor)
                        .environmentObject(loginviewModel)
                        .environmentObject(navigationModel)
                        .navigationBarBackButtonHidden(true)
                case "splashAndTabView":
                    SplashAndTabView()
                        .navigationBarBackButtonHidden(true)
          
                default:
                    EmptyView()  // 기본적으로 아무것도 표시하지 않음
                }
            }
            .navigationBarBackButtonHidden(true)
            .ignoresSafeArea()
        }
        .environmentObject(loginviewModel)  // ViewModel 제공
        .environmentObject(navigationModel)  // 네비게이션 모델 제공
    }
}

// 로그인 버튼 및 로그인 관련 UI를 정의하는 구조체
private struct LoginViewGroup: View {
    var interactor: LoginBusinessLogic?
    @EnvironmentObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Image("LoginDscription")  // 로그인 설명 이미지
                .resizable()
                .scaledToFill()
                .frame(width: 178, height: 22)
                .overlay {
                    HStack {
                        Image("LoginDscriptionLogo")  // 설명 로고
                            .resizable()
                            .scaledToFill()
                            .frame(width: 10, height: 10)
                        
                        Text("3초만에 빠른 로그인")  // 설명 텍스트
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                    .offset(y: -7)
                }
            
            // 카카오 로그인 버튼
            Button {
                interactor?.loginWithKakao()  // 카카오 로그인 처리
            } label: {
                HStack(spacing: 70) {
                    Image("kakaoButton")  // 카카오 버튼 이미지
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                        .padding(.leading)
                    
                    Text("카카오로 계속하기")  // 버튼 텍스트
                        .font(.system(size: 15))
                        .bold()
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                .padding()
                .background(Color.yellow)  // 버튼 배경 색상
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
            .cornerRadius(10)
            
            // 애플 로그인 버튼
            SignInWithAppleButton(
                onRequest: { request in interactor?.loginWithApple(request: request) },
                onCompletion: { result in interactor?.completeAppleLogin(result: result) }
            )
            .overlay {
                HStack(spacing: 70) {
                    Image("AppleButton")  // 애플 버튼 이미지
                        .resizable()
                        .scaledToFill()
                        .frame(width: 24, height: 24)
                        .padding(.leading)
                    
                    Text("Apple로 계속하기")  // 버튼 텍스트
                        .font(.system(size: 15))
                        .bold()
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                .padding()
                .background(Color.white)  // 버튼 배경 색상
                .allowsHitTesting(false)  // 버튼 클릭 무시 설정
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
            .cornerRadius(10)
            .padding(.bottom, 40)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loginviewModel: LoginViewModel(), navigationModel: LoginNavigationModel())
            .environmentObject(LoginNavigationModel())  // Preview를 위한 네비게이션 모델 제공
    }
}
