import XCTest
import Combine
@testable import SnapFit
import AuthenticationServices


// Command + U 를 사용해서 모든 테스트 클래스를 실행한다.

// Mock AuthWorker
//class MockAuthWorker: AuthWorkingLogic {
//    
//    // 메서드 호출 여부를 확인하기 위한 변수들
//    var createUserCalled = false
//    var handleKakaoLoginCalled = false
//    var handleKakaoLogoutCalled = false
//    var handleAppleLoginCalled = false
//    var handleAppleLoginCompletionCalled = false
//    var handleAppleLogoutCalled = false
//    
//    // 메서드가 반환할 응답을 설정하는 변수들
//    var createUserResponse: Result<Tokens, ApiError>?
//    var handleKakaoLoginResponse: Result<String, Error>?
//    var handleKakaoLogoutResponse: Result<Void, Error>?
//    var handleAppleLoginCompletionResponse: Result<ASAuthorizationAppleIDCredential, Error>?
//    var handleAppleLogoutResponse: Result<Void, Error>?
//
//    // createUser 메서드를 모킹하여 테스트용 응답을 반환
//    func createUser(request: Login.LoadLogin.Request) -> AnyPublisher<Tokens, ApiError> {
//        createUserCalled = true
//        return createUserResponse?.publisher.eraseToAnyPublisher() ?? Fail(error: ApiError.unknown(nil)).eraseToAnyPublisher()
//    }
//    
//    // handleKakaoLogin 메서드를 모킹하여 테스트용 응답을 반환
//    func handleKakaoLogin(completion: @escaping (Result<String, Error>) -> Void) {
//        handleKakaoLoginCalled = true
//        completion(handleKakaoLoginResponse ?? .failure(NSError(domain: "", code: -1, userInfo: nil)))
//    }
//    
//    // handleKakaoLogout 메서드를 모킹하여 테스트용 응답을 반환
//    func handleKakaoLogout(completion: @escaping (Result<Void, Error>) -> Void) {
//        handleKakaoLogoutCalled = true
//        completion(handleKakaoLogoutResponse ?? .failure(NSError(domain: "", code: -1, userInfo: nil)))
//    }
//    
//    // handleAppleLogin 메서드를 모킹
//    func handleAppleLogin(request: ASAuthorizationAppleIDRequest) {
//        handleAppleLoginCalled = true
//    }
//    
//    // handleAppleLoginCompletion 메서드를 모킹하여 테스트용 응답을 반환
//    func handleAppleLoginCompletion(result: Result<ASAuthorization, Error>, completion: @escaping (Result<ASAuthorizationAppleIDCredential, Error>) -> Void) {
//        handleAppleLoginCompletionCalled = true
//        completion(handleAppleLoginCompletionResponse ?? .failure(NSError(domain: "", code: -1, userInfo: nil)))
//    }
//    
//    // handleAppleLogout 메서드를 모킹하여 테스트용 응답을 반환
//    func handleAppleLogout(completion: @escaping (Result<Void, Error>) -> Void) {
//        handleAppleLogoutCalled = true
//        completion(handleAppleLogoutResponse ?? .failure(NSError(domain: "", code: -1, userInfo: nil)))
//    }
//    
//    func userKakaoLogin(request: SnapFit.Login.LoadLogin.Request) -> AnyPublisher<SnapFit.Tokens, SnapFit.ApiError> {
//        
//    }
//}
//
//// Mock Presenter
//class MockLoginPresenter: LoginPresentationLogic {
//    // 메서드 호출 여부를 확인하기 위한 변수들
//    var presentKakaoLoginSuccessCalled = false
//    var presentKakaoLoginFailureCalled = false
//    var presentKakaoLogoutSuccessCalled = false
//    var presentAppleLoginSuccessCalled = false
//    var presentAppleLoginFailureCalled = false
//    var presentAppleLogoutSuccessCalled = false
//    var presentAppleLogoutFailureCalled = false
//    var presentUserCreatedCalled = false
//    var presentUserCreationFailedCalled = false
//    
//    // 메서드 호출 시 전달되는 데이터를 확인하기 위한 변수들
//    var kakaoLoginSuccessToken: String?
//    var kakaoLoginFailureError: Error?
//    var userCreatedResponse: Login.LoadLogin.Response?
//    var userCreationFailedError: ApiError?
//    var appleLoginSuccessCredential: ASAuthorizationAppleIDCredential?
//    var appleLoginFailureError: Error?
//    var appleLogoutSuccessCalled = false
//    var appleLogoutFailureError: Error?
//
//    // 카카오 로그인 성공을 프레젠트하는 메서드 모킹
//    func presentKakaoLoginSuccess(_ oauthToken: String) {
//        presentKakaoLoginSuccessCalled = true
//        kakaoLoginSuccessToken = oauthToken
//    }
//    
//    // 카카오 로그인 실패를 프레젠트하는 메서드 모킹
//    func presentKakaoLoginFailure(_ error: Error) {
//        presentKakaoLoginFailureCalled = true
//        kakaoLoginFailureError = error
//    }
//    
//    // 카카오 로그아웃 성공을 프레젠트하는 메서드 모킹
//    func presentKakaoLogoutSuccess() {
//        presentKakaoLogoutSuccessCalled = true
//    }
//    
//    // 애플 로그인 성공을 프레젠트하는 메서드 모킹
//    func presentAppleLoginSuccess(_ credential: ASAuthorizationAppleIDCredential) {
//        presentAppleLoginSuccessCalled = true
//        appleLoginSuccessCredential = credential
//    }
//    
//    // 애플 로그인 실패를 프레젠트하는 메서드 모킹
//    func presentAppleLoginFailure(_ error: Error) {
//        presentAppleLoginFailureCalled = true
//        appleLoginFailureError = error
//    }
//    
//    // 애플 로그아웃 성공을 프레젠트하는 메서드 모킹
//    func presentAppleLogoutSuccess() {
//        presentAppleLogoutSuccessCalled = true
//        appleLogoutSuccessCalled = true
//    }
//    
//    // 애플 로그아웃 실패를 프레젠트하는 메서드 모킹
//    func presentAppleLogoutFailure(_ error: Error) {
//        presentAppleLogoutFailureCalled = true
//        appleLogoutFailureError = error
//    }
//    
//    // 사용자 생성 성공을 프레젠트하는 메서드 모킹
//    func presentUserCreated(_ response: Login.LoadLogin.Response) {
//        presentUserCreatedCalled = true
//        userCreatedResponse = response
//    }
//    
//    // 사용자 생성 실패를 프레젠트하는 메서드 모킹
//    func presentUserCreationFailed(_ error: ApiError) {
//        presentUserCreationFailedCalled = true
//        userCreationFailedError = error
//    }
//}
//
//// LoginInteractorTests 클래스
//class LoginInteractorTests: XCTestCase {
//    // 테스트 대상 객체와 모킹 객체들, 그리고 Combine의 취소 가능 객체를 위한 집합
//    var interactor: LoginInteractor!
//    var mockWorker: MockAuthWorker!
//    var mockPresenter: MockLoginPresenter!
//    var cancellables: Set<AnyCancellable>!
//
//    // 각 테스트 케이스가 시작되기 전에 호출되어 초기 설정을 수행
//    override func setUp() {
//        super.setUp()
//        mockWorker = MockAuthWorker()
//        mockPresenter = MockLoginPresenter()
//        interactor = LoginInteractor(authWorker: mockWorker)
//        interactor.presenter = mockPresenter
//        cancellables = Set<AnyCancellable>()
//    }
//
//    // 각 테스트 케이스가 종료된 후 호출되어 리소스를 정리
//    override func tearDown() {
//        interactor = nil
//        mockWorker = nil
//        mockPresenter = nil
//        cancellables = nil
//        super.tearDown()
//    }
//
//    // 사용자 생성 성공 테스트
//    func testUserCreatedSuccess() {
//        // Given: 성공적인 응답을 반환하도록 MockWorker 설정
//        let tokens = Tokens(accessToken: "mockAccessToken", refreshToken: "mockRefreshToken")
//        mockWorker.createUserResponse = .success(tokens)
//        
//        // 사용자 생성 요청 객체 생성
//        let request = Login.LoadLogin.Request(
//            social: "kakao",
//            nickName: "TestUser",
//            isMarketing: true,
//            oauthToken: "mockOauthToken", moods: <#[String]#>
//        )
//        
//        // When: userCreated 메서드 호출
//        let expectation = self.expectation(description: "UserCreated")
//        interactor.userCreated(request: request)
//        
//        // 1초 후 기대치를 충족시킴
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            expectation.fulfill()
//        }
//        
//        // 2초 내에 기대치가 충족되는지 확인
//        waitForExpectations(timeout: 2.0, handler: nil)
//        
//        // Then: 올바른 메서드 호출 여부와 UserDefaults 값 확인
//        XCTAssertTrue(mockWorker.createUserCalled, "createUser should be called on the worker.")
//        XCTAssertTrue(mockPresenter.presentUserCreatedCalled, "presentUserCreated should be called on the presenter.")
//        XCTAssertEqual(UserDefaults.standard.string(forKey: "accessToken"), tokens.accessToken)
//        XCTAssertEqual(UserDefaults.standard.string(forKey: "refreshToken"), tokens.refreshToken)
//    }
//
//    // 사용자 생성 실패 테스트
//    func testUserCreatedFailure() {
//        // Given: 실패 응답을 반환하도록 MockWorker 설정
//        mockWorker.createUserResponse = .failure(.unknown(nil))
//        
//        // 사용자 생성 요청 객체 생성
//        let request = Login.LoadLogin.Request(
//            social: "kakao",
//            nickName: "TestUser",
//            isMarketing: true,
//            oauthToken: "mockOauthToken", moods: <#[String]#>
//        )
//        
//        // When: userCreated 메서드 호출
//        let expectation = self.expectation(description: "UserCreatedFailure")
//        interactor.userCreated(request: request)
//        
//        // 1초 후 기대치를 충족시킴
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            expectation.fulfill()
//        }
//        
//        // 2초 내에 기대치가 충족되는지 확인
//        waitForExpectations(timeout: 2.0, handler: nil)
//        
//        // Then: 올바른 메서드 호출 여부와 프레젠터 호출 여부 확인
//        XCTAssertTrue(mockWorker.createUserCalled, "createUser should be called on the worker.")
//        XCTAssertTrue(mockPresenter.presentUserCreationFailedCalled, "presentUserCreationFailed should be called on the presenter.")
//    }
//
//    // 카카오 로그인 성공 테스트
//    func testHandleKakaoLoginSuccess() {
//        // Given: 성공적인 응답을 반환하도록 MockWorker 설정
//        mockWorker.handleKakaoLoginResponse = .success("mockAccessToken")
//        
//        // When: handleKakaoLogin 메서드 호출
//        interactor.handleKakaoLogin()
//        
//        // Then: 올바른 메서드 호출 여부와 프레젠터 호출 여부 확인
//        XCTAssertTrue(mockWorker.handleKakaoLoginCalled, "handleKakaoLogin should be called on the worker.")
//        XCTAssertTrue(mockPresenter.presentKakaoLoginSuccessCalled, "presentKakaoLoginSuccess should be called on the presenter.")
//        XCTAssertEqual(mockPresenter.kakaoLoginSuccessToken, "mockAccessToken")
//    }
//
//    // 카카오 로그인 실패 테스트
//    func testHandleKakaoLoginFailure() {
//        // Given: 실패 응답을 반환하도록 MockWorker 설정
//        mockWorker.handleKakaoLoginResponse = .failure(NSError(domain: "", code: -1, userInfo: nil))
//        
//        // When: handleKakaoLogin 메서드 호출
//        interactor.handleKakaoLogin()
//        
//        // Then: 올바른 메서드 호출 여부와 프레젠터 호출 여부 확인
//        XCTAssertTrue(mockWorker.handleKakaoLoginCalled, "handleKakaoLogin should be called on the worker.")
//        XCTAssertTrue(mockPresenter.presentKakaoLoginFailureCalled, "presentKakaoLoginFailure should be called on the presenter.")
//        XCTAssertNotNil(mockPresenter.kakaoLoginFailureError)
//    }
//
//    // 카카오 로그아웃 성공 테스트
//    func testHandleKakaoLogoutSuccess() {
//        // Given: 성공적인 응답을 반환하도록 MockWorker 설정
//        mockWorker.handleKakaoLogoutResponse = .success(())
//        
//        // When: handleKakaoLogout 메서드 호출
//        interactor.handleKakaoLogout()
//        
//        // Then: 올바른 메서드 호출 여부와 프레젠터 호출 여부 확인
//        XCTAssertTrue(mockWorker.handleKakaoLogoutCalled, "handleKakaoLogout should be called on the worker.")
//        XCTAssertTrue(mockPresenter.presentKakaoLogoutSuccessCalled, "presentKakaoLogoutSuccess should be called on the presenter.")
//    }
//
//    // 카카오 로그아웃 실패 테스트
//    func testHandleKakaoLogoutFailure() {
//        // Given: 실패 응답을 반환하도록 MockWorker 설정
//        mockWorker.handleKakaoLogoutResponse = .failure(NSError(domain: "", code: -1, userInfo: nil))
//        
//        // When: handleKakaoLogout 메서드 호출
//        interactor.handleKakaoLogout()
//        
//        // Then: 올바른 메서드 호출 여부와 프레젠터 호출 여부 확인
//        XCTAssertTrue(mockWorker.handleKakaoLogoutCalled, "handleKakaoLogout should be called on the worker.")
//        XCTAssertTrue(mockPresenter.presentKakaoLoginFailureCalled, "presentKakaoLoginFailure should be called on the presenter.")
//        XCTAssertNotNil(mockPresenter.kakaoLoginFailureError)
//    }
//}
