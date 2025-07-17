import SwiftUI
import PhotosUI


// 프로토콜 정의
protocol MyPageDisplayLogic {
    
    
    // MARK: - 사용자 조회관련
    func displayUserDetails(viewModel: LoadUserUseCase.ViewModel)
    func displayCounts(viewModel: LoadUserUseCase.CountViewModel)
    func display(viewModel: MyPageUseCase.LoadMyPage.ViewModel)
    
    // MARK: - 상품 예약관련
    func displayFetchUserReservation(viewModel: MainPromotionUseCase.CheckReservationProducts.ViewModel)
    func displayFetchUserReservationDetail(viewModel: MainPromotionUseCase.CheckReservationDetailProduct.ViewModel) 
    func displayDeleteUserReservation(viewModel: MainPromotionUseCase.DeleteReservationProduct.ViewModel)

   
    // MARK: - 메이커 관련
    func displayFetchMakerProducts(viewModel: MakerUseCases.LoadProducts.ProductsForMakerViewModel)
    func displayVibes(viewModel: MakerUseCases.LoadVibeAndLocation.VibesViewModel)
    func displayLocations(viewModel: MakerUseCases.LoadVibeAndLocation.LocationsViewModel)
    func displayPostImages(viewModel: MakerUseCases.RequestMakerImage.ImageURLViewModel)
 
    // 좋아요
    func displayFetchUserLikeProduct(viewModel: MainPromotionUseCase.Like.LikeListViewModel)
    func displayDetail(viewModel: MainPromotionUseCase.LoadDetailProduct.ViewModel)
    func displayDetailProductsForMaker(viewModel: MainPromotionUseCase.LoadDetailProduct.ProductsForMakerViewModel)
    func displayFetchMakerReservations(viewModel: MakerUseCases.LoadReservation.ViewModel)
}



extension MyPageView: MyPageDisplayLogic {
    

    
    func displayUserDetails(viewModel: LoadUserUseCase.ViewModel) {
        DispatchQueue.main.async {
            myPageViewModel.userDetails = viewModel.userDetails
            print("myPageViewModel.userDetails \( myPageViewModel.userDetails)")
        }
    }

    func displayCounts(viewModel: LoadUserUseCase.CountViewModel) {
        DispatchQueue.main.async {
            myPageViewModel.userCounts = viewModel.userCount
            print("myPageViewModel.userCount \( myPageViewModel.userCounts)")
        }
    }
    
    
    func display(viewModel: MyPageUseCase.LoadMyPage.ViewModel) {
        // 로그아웃 성공 여부 확인
        if viewModel.logOut {
            print("로그아웃 성공")
            // 로그아웃 후 로그인 화면 표시
            DispatchQueue.main.async {
                loginViewModel.showLoginModal = true
                // 로그인 상태를 false로 변경하여 UI 갱신
                isLoggedIn = false
            }
        }
    }

    
    // 유저 예약내역 리스트 조회
    func displayFetchUserReservation(viewModel: MainPromotionUseCase.CheckReservationProducts.ViewModel) {
        DispatchQueue.main.async {
            // 데이터를 불러오기 전에 기존 데이터를 초기화하여 중복을 방지
            myPageViewModel.reservationproducts.removeAll()

            // 옵셔널 처리: data가 nil일 경우 빈 배열로 초기화 후 id로 정렬
            myPageViewModel.reservationproducts = (viewModel.reservationProducts?.data ?? []).sorted(by: {
                ($0.id ?? Int.min) < ($1.id ?? Int.min)
            })

            // 디버그 로그: 업데이트된 reservationproducts를 출력
            // print("myPageViewModel.reservationproducts: \(myPageViewModel.reservationproducts)")
        }
    }

    
    
    // 유저 예약 삭제
    func displayDeleteUserReservation(viewModel: MainPromotionUseCase.DeleteReservationProduct.ViewModel) {
        DispatchQueue.main.async {
            myPageViewModel.deleteReservationSuccess = viewModel.deleteReservationSuccess
            print("myPageViewModel.deleteReservationSuccess \(myPageViewModel.deleteReservationSuccess)")
        }
    }
    

    
    // 유저 예약내역 단일 조회
    func displayFetchUserReservationDetail(viewModel: MainPromotionUseCase.CheckReservationDetailProduct.ViewModel) {
        DispatchQueue.main.async {
            // 옵셔널 처리: data가 nil일 경우 빈 배열로 초기화
            myPageViewModel.reservationproductDetail = viewModel.reservationDetail

            // 디버그 로그: 업데이트된 reservationproducts를 출력
            print("myPageViewModel.reservationproductDetail: \(myPageViewModel.reservationproductDetail)")
        }
    }
    
    // 찜관련
    func displayFetchUserLikeProduct(viewModel: MainPromotionUseCase.Like.LikeListViewModel) {
        DispatchQueue.main.async {
            myPageViewModel.likeProducts = viewModel.likeProducts.data
            print("찜 리스트 \(myPageViewModel.likeProducts)")
        }
    }
    
    func displayDetail(viewModel: MainPromotionUseCase.LoadDetailProduct.ViewModel) {
        DispatchQueue.main.async {
            myPageViewModel.productDetail = viewModel.productDetail
            print("찜 상품 상세 \( myPageViewModel.productDetail)")
        }
    }
    
    func displayDetailProductsForMaker(viewModel: MainPromotionUseCase.LoadDetailProduct.ProductsForMakerViewModel) {
        DispatchQueue.main.async {
            myPageViewModel.productDetailAuthorProducts = viewModel.products.data
            print("찜 상품 작가 사진 \( myPageViewModel.productDetailAuthorProducts)")
        }
    }
    
    // MARK: - 메이커 관련
    // 상품 조회
    
    func displayFetchMakerProducts(viewModel: MakerUseCases.LoadProducts.ProductsForMakerViewModel) {
        DispatchQueue.main.async {
            // 옵셔널 처리: data가 nil일 경우 빈 배열로 초기화
            myPageViewModel.makerProductlist = viewModel.products

            // 디버그 로그: 업데이트된 reservationproducts를 출력
            print("myPageViewModel.makerProductlist: \(myPageViewModel.makerProductlist)")
        }
    }
    
    func displayVibes(viewModel: MakerUseCases.LoadVibeAndLocation.VibesViewModel) {
        DispatchQueue.main.async {
            // 분위기 상태 업데이트
            myPageViewModel.vibes = viewModel.vibes
            print("myPageViewModel.vibes \(myPageViewModel.vibes)")
        }
    }
    
    func displayLocations(viewModel: MakerUseCases.LoadVibeAndLocation.LocationsViewModel) {
        DispatchQueue.main.async {
            // 분위기 상태 업데이트
            myPageViewModel.locations = viewModel.locations
            print("myPageViewModel.locations \(myPageViewModel.locations)")
        }
    }
    
    
    func displayPostImages(viewModel: MakerUseCases.RequestMakerImage.ImageURLViewModel) {
        DispatchQueue.main.async {
            myPageViewModel.postImages = viewModel.Images
            print("MyPage 뷰까지 전달 등록이미지 \(myPageViewModel.postImages)")
        }
    }
    
    func displayFetchMakerReservations(viewModel: MakerUseCases.LoadReservation.ViewModel) {
        DispatchQueue.main.async {
            myPageViewModel.makerReservationproducts = viewModel.products.data ?? []
            
            print("MyPage 메이커 예약 리스트 \(myPageViewModel.makerReservationproducts)")
        }
    }
    
}



struct MyPageView: View {
    @ObservedObject var myPageViewModel: MyPageViewModel
    var myPageInteractor: MyPageBusinessLogic?
    @State var stack = NavigationPath()
    
    @ObservedObject var loginViewModel: LoginViewModel
    @ObservedObject var loginNaviModel: LoginNavigationModel
    @State private var isLoggedIn: Bool = false

    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var confirmAction: () -> Void = {}
    @State private var cancelAction: () -> Void = {}

    var body: some View {
        ZStack {

            NavigationStack(path: $stack) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        ProfileHeaderView(viewModel: myPageViewModel)
                        
                        UserInfoView(viewModel: myPageViewModel)
                            .padding(.horizontal)
                        
                        NavigationButtonsView(viewModel: myPageViewModel, stack: $stack)
                            .padding(.bottom, 32)
                        
                        GroupBoxViews(myPageViewModel: myPageViewModel, myPageInteractor: myPageInteractor, stack: $stack, showAlert: $showAlert, alertMessage: $alertMessage, confirmAction: $confirmAction, cancelAction: $cancelAction)
                        
                        Spacer()
                            .frame(height: 40)
                        
                        Spacer()
                    }
                }
                .navigationDestination(for: String.self) { viewName in
                    switch viewName {
                    case "MyProfileEdit":
                        MyProfileEdit(viewModel: myPageViewModel)
                            //.navigationBarBackButtonHidden(true)
                    case "ReservationView" :
                        MyPageReservationView(mypageInteractor: myPageInteractor, myPageViewModel: myPageViewModel, stack: $stack)
                            //.navigationBarBackButtonHidden(true)
                      
                    case "ReservationManagementView" :
                        ReservationManagementView(mypageInteractor: myPageInteractor, myPageViewModel: myPageViewModel, stack: $stack)
                            //.navigationBarBackButtonHidden(true)
                    
                        
                    case "ReservationInfoView" :
                        MyPageReservationInfoView(mypageInteractor: myPageInteractor, myPageViewModel: myPageViewModel, stack: $stack)
                            //.navigationBarBackButtonHidden(true)
                       
                        
                    case "DibsView":
                        DibsView(mypageInteractor: myPageInteractor, myPageViewModel: myPageViewModel, stack: $stack)
                            //.navigationBarBackButtonHidden(true)
                            
                    case "MyPageAuthorDetailView":
                        MyPageAuthorDetailView(myPageViewModel: myPageViewModel, myPageInteractor: myPageInteractor, stack: $stack)
                            //.navigationBarBackButtonHidden(true)
                           
    
                    case "ProductManagementView":
                        ProductManagementView(mypageInteractor: myPageInteractor, myPageViewModel: myPageViewModel, stack: $stack)
                            //.navigationBarBackButtonHidden(true)
                           
                    case "ProductRegistrationView":
                        ProductRegistrationView(mypageInteractor: myPageInteractor, myPageViewModel: myPageViewModel, stack: $stack)
                            //.navigationBarBackButtonHidden(true)
                        
                    default:
                        EmptyView()
                        //SnapFitTabView()
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
                        DispatchQueue.main.async {
                            checkForSavedTokens()
                        }
                    }
            }
            .onAppear {
                DispatchQueue.main.async {
                    myPageInteractor?.fetchUserDetails()
                    myPageInteractor?.fetchCounts()
                    // 예약 내역 불러오기
                    myPageInteractor?.fetchUserLikes(request: MainPromotionUseCase.Like.LikeListRequest(limit: 50, offset: 0))
                }
                checkForSavedTokens()
            }
            .onChange(of: isLoggedIn) { newValue in
                if !newValue {
                    DispatchQueue.main.async {
                        loginViewModel.showLoginModal = true
                    }
                }
            }

            // Alert overlay
            Group {
                if showAlert {
                    ZStack {
                        // Blurred Background for alert
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                showAlert = false
                            }
                        
                        MyPageCustomAlertView(
                            isPresented: $showAlert,
                            message: alertMessage,
                            confirmAction: confirmAction,
                            cancelAction: cancelAction
                        )
                        .frame(width: 300)
                        .background(Color.white)
                        .cornerRadius(10)
                        .transition(.opacity)
                        .zIndex(1)
                    }
                }
            }
            .animation(.easeInOut, value: showAlert)
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
            DispatchQueue.main.async {
                loginViewModel.showLoginModal = true
            }
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
            NavigationLink(value: "MyProfileEdit"){
                Image("editicon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
            }
            .hidden()
            .offset(x: 160, y: -30)
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


// 일반 사용자 네비게이션 버튼 뷰
struct NavigationButtonsView: View {
    @ObservedObject var viewModel: MyPageViewModel
    @Binding var stack: NavigationPath // 바인딩을 통해 전달받음
    
    var body: some View {
        HStack(spacing: 0) {
            NavigationLink(value: "ReservationView") {
                NavigationButtonLabel(title: "예약 내역", count: String(viewModel.userCounts?.reservationCount ?? 0))
            }
            
            Divider()
                .frame(width: 1)
                .background(Color.gray.opacity(0.3))
            
            NavigationLink(value: "DibsView") {
                NavigationButtonLabel(title: "찜한 내역", count: String(viewModel.userCounts?.likeCount ?? 0))
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
    @ObservedObject var myPageViewModel: MyPageViewModel
    var myPageInteractor: MyPageBusinessLogic?
    @Binding var stack: NavigationPath
    
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    @Binding var confirmAction: () -> Void
    @Binding var cancelAction: () -> Void
    
    var body: some View {
        VStack {
            SectionHeaderView(title: "메이커 관리")
                .padding(.bottom, 16)
            
            Group {
                AppInfoContent(
                    name: "사진작가로 전환",
                    linkDestination: "https://forms.gle/n4yN5jRrz1cPycaJA"
                )
                
                // 상품관리 버튼
                Button(action: {
                    handleButtonAction(
                        userHasPermission: myPageViewModel.userDetails?.photographer == true,
                        navigateTo: "ProductManagementView",
                        alertMessage: "메이커 권한이 없습니다."
                    )
                }) {
                    MakerButtonContent(title: "상품관리")
                }
              
                // 예약관리 버튼
                Button(action: {
                    handleButtonAction(
                        userHasPermission: myPageViewModel.userDetails?.photographer == true,
                        navigateTo: "ReservationManagementView",
                        alertMessage: "메이커 권한이 없습니다."
                    )
                }) {
                    MakerButtonContent(title: "예약관리")
                }
                .padding(.bottom, 24)
            }
            .backgroundStyle(Color.white)
            .padding(.horizontal, 16)
         
            SectionHeaderView(title: "SnapFit 설정")
            
            VStack {
                AppInfoContent(
                    name: "고객센터",
                    linkDestination: "https://docs.google.com/forms/d/e/1FAIpQLSekyp-tBMhi2GDOX49X7DWpaXCu7MLNFGQ5scuL_en5AhBSnQ/viewform"
                )
                AppInfoContent(
                    name: "이용약관",
                    linkDestination: "https://mixolydian-beef-6a0.notion.site/04cb97bab76c40d68aa17475c6e53172?pvs=4"
                )
                AppInfoContent(
                    name: "로그아웃",
                    interactor: myPageInteractor,
                    onButtonPress: {
                        prepareAlert(
                            message: "로그아웃 하시겠습니까?",
                            confirmAction: { myPageInteractor?.serviceLogout() },
                            cancelAction: { showAlert = false }
                        )
                    }
                )
                AppInfoContent(
                    name: "탈퇴하기",
                    interactor: myPageInteractor,
                    onButtonPress: {
                        prepareAlert(
                            message: "정말 탈퇴하시겠습니까?\n스냅핏과의 추억이 모두 사라집니다!",
                            confirmAction: { myPageInteractor?.cancelmembership() },
                            cancelAction: { showAlert = false }
                        )
                    }
                )
            }
            .background(Color.white)
            .padding(.horizontal, 16)
        }
    }
    
    private func handleButtonAction(userHasPermission: Bool, navigateTo: String, alertMessage: String) {
        if userHasPermission {
            stack.append(navigateTo)
        } else {
            prepareAlert(message: alertMessage, confirmAction: {}, cancelAction: { showAlert = false })
        }
    }
    
    private func prepareAlert(message: String, confirmAction: @escaping () -> Void, cancelAction: @escaping () -> Void) {
        self.alertMessage = message
        self.confirmAction = confirmAction
        self.cancelAction = cancelAction
        self.showAlert = true
    }
}




struct MakerButtonContent: View {
    var title: String
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text(title)
                    .foregroundColor(.black)
                    .font(.system(size: 14))
                Spacer()
                Image(systemName: "chevron.right")
            }
            Spacer()
            Divider()
        }
        .frame(height: 68)
    }

}

