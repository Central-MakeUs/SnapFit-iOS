import SwiftUI
import _AuthenticationServices_SwiftUI

// Presenter에서 전달 받을 기능들을 정의 UI 업데이트 관련
protocol LoginDisplayLogic {
    func display(viewModel: Login.LoadLogin.ViewModel)
}

struct LoginView: View, LoginDisplayLogic {
    
    @ObservedObject var viewModel: LoginViewModel
    var interactor: LoginBusinessLogic?
    @State private var stack = NavigationPath() // 초기 설정
    
    // 실제 프리젠터에서 값을 받아 뷰를 업데이트하는 로직
    func display(viewModel: Login.LoadLogin.ViewModel) {
        // Reset or update UI elements based on the social login type
        switch viewModel.socialLoginType {
        case "kakao":
            if viewModel.userVerification == false {
                self.viewModel.social = "kakao"
                self.viewModel.isKakaoLogin = true
                self.viewModel.oauthToken = viewModel.oauthToken ?? ""
                print("Kakao login failed verification\(viewModel.oauthToken ?? "")")
                
            } else {
                print("Kakao login successful ")
            }
            
        case "apple":
            if viewModel.userVerification {
                self.viewModel.social = "apple"
                self.viewModel.isAppleLoggedIn = true
                self.viewModel.oauthToken = viewModel.oauthToken ?? ""
                print("Apple login successful with token: \(viewModel.oauthToken ?? "")")
            } else {
                print("Apple login failed verification")
            }
            
        default:
            print("Unsupported social login type")
        }
        
        // Navigate to SnapFitTabView if userVerification is true
        if viewModel.userVerification {
            self.viewModel.destination = .snapFitTabView
        } else {
            self.viewModel.destination = .termsView
        }
        self.viewModel.shouldNavigate.toggle()
        
    }
    
    
    
    var body: some View {
        NavigationStack(path: $stack) {
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    Spacer().frame(height: 110)
                    
                    Group {
                        Image("appLogo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 141.33, height: 38.12)
                            .padding(.bottom, 10)
                        
                        Text("나에게 맞는 사진을 만날 수 있는,")
                        Text("스냅핏에 오신걸 환영합니다!")
                    }
                    .foregroundColor(.white)
                    .font(.title3)
                    .padding(.trailing, 80)
                    
                    Spacer()
                    
                    LoginViewGroup(interactor: interactor, viewModel: viewModel)
                    
                    Spacer().frame(height: 110)
                }
                .padding(.horizontal, 15)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(
                    Image("splash")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                )
            }
            .navigationDestination(isPresented: $viewModel.shouldNavigate) {
                switch viewModel.destination {
                case .termsView:
                    TermsView(viewModel: viewModel, interactor: interactor)
                        .navigationBarBackButtonHidden(true)
                case .snapFitTabView:
                    SnapFitTabView()
                        .navigationBarBackButtonHidden(true)
                }
            }     .navigationBarBackButtonHidden(true)
            
                .ignoresSafeArea()
                .task {
                    // View가 로드될 때 초기 작업을 실행할 수 있음
                    // interactor?.load(request: Login.LoadLogin.Request())
                }
                .onAppear {
                    // View가 나타날 때 실행할 작업
                    // interactor?.load(request: Login.LoadLogin.Request())
                }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

private struct LoginViewGroup: View {
    private var interactor: LoginBusinessLogic?
    @ObservedObject var viewModel: LoginViewModel
    
    init(interactor: LoginBusinessLogic?, viewModel: LoginViewModel) {
        self.interactor = interactor
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        VStack(spacing: 20) {
            Image("LoginDscription")
                .resizable()
                .scaledToFill()
                .frame(width: 178, height: 22)
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
                interactor?.loginWithKakao() // Kakao 로그인 처리
                
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
            
            if viewModel.isKakaoLogin {
                Button {
                    interactor?.logoutFromKakao() // Kakao 로그아웃 처리
                } label: {
                    Text("카카오 로그아웃")
                }
            }
            
            SignInWithAppleButton(
                onRequest: { request in interactor?.handleAppleLogin(request: request) },
                onCompletion: { result in interactor?.handleAppleLoginCompletion(result: result) }
            )
            .overlay {
                HStack(spacing: 70) {
                    Image("AppleButton")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                        .padding(.leading)
                    
                    Text("Apple로 계속하기")
                        .font(.system(size: 15))
                        .bold()
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding()
                .background(Color.black)
                .allowsHitTesting(false)
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
            .cornerRadius(10)
            
            if viewModel.isAppleLoggedIn {
                Button {
                    //interactor?.handleAppleLogout() // Apple 로그아웃 처리
                } label: {
                    Text("애플 로그아웃")
                }
            }
            
            Button {
                // 둘러보기 액션 처리
            } label: {
                Text("둘러보기")
                    .font(.system(size: 15))
                    .foregroundColor(Color(white: 0.7))
                    .underline()
            }
        }
    }
}

private struct AppleSigninButton: View {
    var body: some View {
        SignInWithAppleButton(
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                switch result {
                case .success(let authResults):
                    print("Apple Login Successful")
                    switch authResults.credential {
                    case let appleIDCredential as ASAuthorizationAppleIDCredential:
                        // Apple ID Credential에서 필요한 정보를 추출
                        let userIdentifier = appleIDCredential.user
                        let fullName = appleIDCredential.fullName
                        let name = (fullName?.familyName ?? "") + (fullName?.givenName ?? "")
                        let email = appleIDCredential.email
                        let identityToken = String(data: appleIDCredential.identityToken!, encoding: .utf8)
                        let authorizationCode = String(data: appleIDCredential.authorizationCode!, encoding: .utf8)
                    default:
                        break
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    print("error")
                }
            }
        )
        .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
        .cornerRadius(5)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        return LoginView(viewModel: LoginViewModel(), interactor: nil)
    }
}
