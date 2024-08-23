import SwiftUI
import _AuthenticationServices_SwiftUI

// View가 Presenter로부터 받는 정보를 정의하는 프로토콜
protocol LoginDisplayLogic {
    func display(viewModel: Login.LoadLogin.LoginPresentationViewModel)
    func displayVibes(viewModel: Login.LoadLogin.VibesPresentationViewModel)
}

// 로그인 화면을 정의하는 View
struct LoginView: View, LoginDisplayLogic {
    
    @ObservedObject var loginviewModel: LoginViewModel
    @ObservedObject var navigationModel: LoginNavigationModel
    var interactor: LoginBusinessLogic?

    func display(viewModel: Login.LoadLogin.LoginPresentationViewModel) {
        DispatchQueue.main.async {
            var destination = ""
            if viewModel.membershipRequired == true {
                destination = "termsView"
                navigationModel.navigationPath.append(destination)
            } else {
                loginviewModel.showLoginModal = false
            }
            switch viewModel.socialLoginType {
            case "kakao":
                if viewModel.membershipRequired {
                    self.loginviewModel.social = viewModel.socialLoginType
                    self.loginviewModel.isKakaoLogin = true
                    self.loginviewModel.oauthToken = viewModel.oauthToken ?? ""
                    self.loginviewModel.socialAccessToken = viewModel.socialAccessToken ?? ""
                    print("Kakao login failed verification kakaoAccessToken \(viewModel.socialAccessToken ?? "")")
                } else {
                    print("Kakao login successful")
                    loginviewModel.showLoginModal = false
                }
            case "apple":
                if viewModel.membershipRequired {
                    self.loginviewModel.social = viewModel.socialLoginType
                    self.loginviewModel.isAppleLoggedIn = true
                    self.loginviewModel.oauthToken = viewModel.oauthToken ?? ""
                    self.loginviewModel.socialAccessToken = viewModel.socialAccessToken ?? ""
                    print("Apple login failed verification \(viewModel.oauthToken ?? "")")
                } else {
                    print("Apple login successful")
                    loginviewModel.showLoginModal = false
                }
            default:
                print("Unsupported social login type")
            }
        }
    }

    func displayVibes(viewModel: Login.LoadLogin.VibesPresentationViewModel) {
        DispatchQueue.main.async {
            self.loginviewModel.vibes = viewModel.vibes
        }
    }

    var body: some View {
        NavigationStack(path: $navigationModel.navigationPath) {
            GeometryReader { geometry in
                ZStack {
                    Image("LoginBack")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .ignoresSafeArea()
                    
                    VStack(alignment: .leading) {
                        Spacer().frame(height: geometry.size.height * 0.14)
                        
                        Group {
                            Image("appLogo")
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
                        
                        LoginViewGroup(interactor: interactor)
                        
                        Spacer().frame(height: geometry.size.height * 0.03)
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.horizontal, 16)
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .navigationDestination(for: String.self) { destination in
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
                case "FreelookView":
                    FreelookView() // FreelookView를 네비게이션 링크로 표시
                        .navigationBarBackButtonHidden(true)
                default:
                    EmptyView()
                }
            }
            .navigationBarBackButtonHidden(true)
            .ignoresSafeArea()        }
        .environmentObject(loginviewModel)
        .environmentObject(navigationModel)
    }
}


// 로그인 버튼 및 로그인 관련 UI를 정의하는 구조체
private struct LoginViewGroup: View {
    var interactor: LoginBusinessLogic?
    @EnvironmentObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Image("LoginDscription")
                .resizable()
                .scaledToFill()
                .frame(width: 178, height: 12)
                .overlay {
                    HStack {
                        Image("LoginDscriptionLogo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 10, height: 10)
                        
                        Text("3초만에 빠른 로그인")
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                    .offset(y: -7)
                }
            
            Button {
                interactor?.loginWithKakao()
            } label: {
                HStack(spacing: 70) {
                    Image("kakaoButton")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                        .padding(.leading)
                    
                    Text("카카오로 계속하기")
                        .font(.system(size: 15))
                        .bold()
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                .padding()
                .background(Color.yellow)
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
            .cornerRadius(10)
            
            SignInWithAppleButton(
                onRequest: { request in interactor?.loginWithApple(request: request) },
                onCompletion: { result in interactor?.completeAppleLogin(result: result) }
            )
            .overlay {
                HStack(spacing: 70) {
                    Image("AppleButton")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 24, height: 24)
                        .padding(.leading)
                    
                    Text("Apple로 계속하기")
                        .font(.system(size: 15))
                        .bold()
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .allowsHitTesting(false)
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
            .cornerRadius(10)
            
            NavigationLink(value: "FreelookView") {
                Text("둘러보기")
                    .font(.system(size: 15))
                    .foregroundColor(Color(white: 0.7))
                    .underline()
            }
            .padding(.bottom, 20)
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loginviewModel: LoginViewModel(), navigationModel: LoginNavigationModel())
            .environmentObject(LoginNavigationModel())  // Preview를 위한 네비게이션 모델 제공
    }
}
