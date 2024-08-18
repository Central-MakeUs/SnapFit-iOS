import SwiftUI
import PhotosUI


// 프로토콜 정의
protocol MyPageDisplayLogic {
    
    
    // MARK: - 사용자 조회관련
    func displayUserDetails(viewModel: LoadUserDetails.ViewModel)
    func displayCounts(viewModel: LoadUserDetails.CountViewModel)
    func display(viewModel: MyPage.LoadMyPage.ViewModel)
    
    // MARK: - 상품 예약관련
    func displayFetchUserReservation(viewModel: MainPromotion.CheckReservationProducts.ViewModel)
    func displayFetchUserReservationDetail(viewModel: MainPromotion.CheckReservationDetailProduct.ViewModel) 
}



extension MyPageView: MyPageDisplayLogic {

    
    func displayUserDetails(viewModel: LoadUserDetails.ViewModel) {
        DispatchQueue.main.async {
            myPageViewModel.userDetails = viewModel.userDetails
            print("myPageViewModel.userDetails \( myPageViewModel.userDetails)")
        }
    }

    func displayCounts(viewModel: LoadUserDetails.CountViewModel) {
        DispatchQueue.main.async {
            myPageViewModel.userCounts = viewModel.userCount
            print("myPageViewModel.userCount \( myPageViewModel.userCounts)")
        }
    }
    
    
    func display(viewModel: MyPage.LoadMyPage.ViewModel) {
        // 로그아웃 성공 여부 확인
        if viewModel.logOut {
            print("로그아웃 성공")
            // 로그아웃 후 로그인 화면 표시
            withAnimation {
                loginViewModel.showLoginModal = true
            }
        }
    }

    
    // 유저 예약내역 리스트 조회
    func displayFetchUserReservation(viewModel: MainPromotion.CheckReservationProducts.ViewModel) {
        DispatchQueue.main.async {
            // 옵셔널 처리: data가 nil일 경우 빈 배열로 초기화
            myPageViewModel.reservationproducts = viewModel.reservationProducts?.data ?? []

            // 디버그 로그: 업데이트된 reservationproducts를 출력
            print("authorListViewModel.reservationproducts: \(myPageViewModel.reservationproducts)")
        }
    }
    
    // 유저 예약내역 단일 조회
    func displayFetchUserReservationDetail(viewModel: MainPromotion.CheckReservationDetailProduct.ViewModel) {
        DispatchQueue.main.async {
            // 옵셔널 처리: data가 nil일 경우 빈 배열로 초기화
            myPageViewModel.reservationproductDetail = viewModel.reservationDetail

            // 디버그 로그: 업데이트된 reservationproducts를 출력
            print("authorListViewModel.reservationproductDetail: \(myPageViewModel.reservationproductDetail)")
        }
    }
    
}

struct MyPageView: View {
    
    @ObservedObject var myPageViewModel: MyPageViewModel
    var myPageInteractor: MyPageBusinessLogic?
    @State var stack = NavigationPath()
    
    // 로그아웃 이후 로그인 관리를 위한 뷰 모델
 
    @StateObject var loginViewModel = LoginViewModel()
    @StateObject var loginNaviModel = LoginNavigationModel()
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationStack(path: $stack) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    ProfileHeaderView(viewModel: myPageViewModel)
                                   
                    UserInfoView(viewModel: myPageViewModel)
                        .padding(.horizontal)
                    
                    NavigationButtonsView(viewModel: myPageViewModel, stack: $stack)
                        .padding(.bottom, 32)
                    
                    GroupBoxViews(myPageInteractor: myPageInteractor)
                    
                    Spacer()
                        .frame(height: 40)
                    
                    Spacer()
                }
            }
            .navigationDestination(for: String.self) { viewName in
                switch viewName {
                case "MyProfileEdit":
                    MyProfileEdit(viewModel: myPageViewModel)
                        .navigationBarBackButtonHidden(true)
                case "ReservationView" :
                    MyPageReservationView(mypageInteractor: myPageInteractor,stack: $stack)
                        .navigationBarBackButtonHidden(true)
                        .environmentObject(myPageViewModel)
                    
                case "ReservationInfoView" :
                    MyPageReservationInfoView(mypageInteractor: myPageInteractor, stack: $stack)
                        .navigationBarBackButtonHidden(true)
                        .environmentObject(myPageViewModel)
                case "DibsView":
                    DibsView()
                        .navigationBarBackButtonHidden(true)
                case "SnapFitTabView":
                    SnapFitTabView()
                        .navigationBarBackButtonHidden(true)
                default:
                    SnapFitTabView()
                }
            }
            .navigationBarHidden(true)
            .ignoresSafeArea(.container, edges: .top)
            .accentColor(.black)
        }
        .fullScreenCover(isPresented: $loginViewModel.showLoginModal) {
            LoginView(loginviewModel: loginViewModel, navigationModel: loginNaviModel)
                .configureView()
                .onDisappear {
                    // 로그인 화면이 닫힐 때 토큰을 다시 확인
                    DispatchQueue.main.async {
                        checkForSavedTokens()
                    }
                }
        }
        .onAppear {
            // 화면이 보일 때 토큰을 확인하여 로그인 상태 업데이트
            DispatchQueue.main.async {
                myPageInteractor?.fetchUserDetails()
                myPageInteractor?.fetchCounts()
            }
            checkForSavedTokens()
        }
        .onChange(of: isLoggedIn) { newValue in
            if !newValue {
                loginViewModel.showLoginModal = true
            }
        }
    }
    
    private func checkForSavedTokens() {
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken"),
           let refreshToken = UserDefaults.standard.string(forKey: "refreshToken"),
           !accessToken.isEmpty, !refreshToken.isEmpty {
            isLoggedIn = true
            loginViewModel.showLoginModal = false
        } else {
            isLoggedIn = false
            loginViewModel.showLoginModal = true
        }
    }
}

// 프로필 헤더 뷰
struct ProfileHeaderView: View {
    @ObservedObject var viewModel: MyPageViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .frame(height: 168)  // 높이를 명확히 설정
                .overlay {
                    Image("starBigLogo")
                        .resizable()
                        .frame(width: 86, height: 86)
                        .foregroundStyle(Color(.systemGray4))
                        .offset(x: -130, y: 81)
                }
            
            if let profileUrl = viewModel.userDetails?.profile, let url = URL(string: profileUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        // Placeholder image while loading
                        ProgressView()
                            .frame(width: 117.78, height: 44.17)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 117.78, height: 44.17)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    case .failure:
                        // Placeholder image in case of failure
                        Image("defaultProfileLogo") // Make sure to add a default image in your assets
                            .resizable()
                            .scaledToFit()
                            .frame(width: 117.78, height: 44.17)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    @unknown default:
                        EmptyView()
                    }
                }
                .offset(x: 0, y: 20)
            } else {
                Image("SnapFitMainLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 117.78, height: 44.17)
                    .offset(x: 0, y: 20)
            }
            
            
            // 💁 심사 이후 다시 구현
//            NavigationLink(value: "MyProfileEdit"){
//                Image("editicon")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 24, height: 24)
//                    .foregroundColor(.white)
//            }
//            .offset(x: 160, y: -30)
        }
    }
}


// 사용자 정보 뷰
struct UserInfoView: View {
    @ObservedObject var viewModel: MyPageViewModel
    
    var body: some View {
        Group {
            if let user = viewModel.userDetails {
                Text(user.nickName ?? "사용자 이름")
                    .font(.title3)
                    .padding(.top, 40)
                
                StarImageLabel(text: user.vibes?.first?.name ?? "기본")
            } else {
                // 기본 값 처리
                Text("사용자 이름")
                    .font(.title3)
                    .padding(.top, 40)
                
                StarImageLabel(text: "기본")
            }
        }
    }
}


// 네비게이션 버튼 뷰
struct NavigationButtonsView: View {
    @ObservedObject var viewModel: MyPageViewModel
    @Binding var stack: NavigationPath // 바인딩을 통해 전달받음
    
    var body: some View {
        HStack(spacing: 0) {
            NavigationLink(value: "ReservationView") {
                NavigationButtonLabel(title: "예약 내역", count: String(viewModel.userCounts?.likeCount ?? 0))
            }
            
            Divider()
                .frame(width: 1)
                .background(Color.gray.opacity(0.3))
            
            NavigationLink(value: "DibsView") {
                NavigationButtonLabel(title: "찜한 내역", count: String(viewModel.userCounts?.reservationCount ?? 0))
            }
        }
        .frame(height: 108)
        .background(Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}

struct NavigationButtonLabel: View {
    let title: String
    let count: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
                .padding(.bottom, 5)
            
            Text(count)
                .foregroundColor(.black)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: 108)
        .background(Color.white)
    }
}

// 그룹 박스 뷰
struct GroupBoxViews: View {
    var myPageInteractor: MyPageBusinessLogic?
    
    var body: some View {
        
        
        SectionHeaderView(title: "메이커 관리")
            .padding(.bottom, 16)
        Group {
            AppInfoContent(name: "사진작가로 전환", linkDestination: "https://forms.gle/n4yN5jRrz1cPycaJA")
            
            AppInfoContent(name: "상품관리", canNavigate: false)  // Modify as needed
            AppInfoContent(name: "예약관리", canNavigate: false)   // Modify as needed
            
                .padding(.bottom, 24)
            
        }
        .backgroundStyle(Color.white) // 배경색을 흰색으로 변경
        .padding(.horizontal, 16)
        
        SectionHeaderView(title: "SnapFit 설정")
        Group{
            AppInfoContent(name: "고객센터", linkDestination: "https://docs.google.com/forms/d/e/1FAIpQLSekyp-tBMhi2GDOX49X7DWpaXCu7MLNFGQ5scuL_en5AhBSnQ/viewform")
            AppInfoContent(name: "이용약관", linkDestination: "https://mixolydian-beef-6a0.notion.site/04cb97bab76c40d68aa17475c6e53172?pvs=4")
            AppInfoContent(name: "로그아웃", interactor: myPageInteractor)
            AppInfoContent(name: "탈퇴하기", interactor: myPageInteractor)
        }
        .backgroundStyle(Color.white) // 배경색을 흰색으로 변경
        .padding(.horizontal, 16)
    }
}


