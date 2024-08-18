import SwiftUI
import PhotosUI


// 프로토콜 정의
protocol MyPageDisplayLogic {
    func display(viewModel: MyPage.LoadMyPage.ViewModel)
}

extension MyPageView: MyPageDisplayLogic {
    func display(viewModel: MyPage.LoadMyPage.ViewModel) {
        // 로그아웃 성공 여부 확인
        if viewModel.logOut {
            print("로그아웃 성공")
            // 로그아웃 후 로그인 화면 표시
            withAnimation {
                loginVM.showLoginModal = true
            }
        }
    }

    func fetch() {}
}

struct MyPageView: View {
    @StateObject var viewModel = ProfileViewModel()
    var myPageInteractor: MyPageBusinessLogic?
    @State var stack = NavigationPath()
    
    // 로그아웃 이후 로그인 관리를 위한 뷰 모델
    @StateObject var loginVM = LoginViewModel()
    @StateObject var loginNaviModel = LoginNavigationModel()
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationStack(path: $stack) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    ProfileHeaderView(viewModel: viewModel)
                    
                    UserInfoView()
                        .padding(.horizontal)
                    
                    NavigationButtonsView(stack: $stack)
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
                    MyProfileEdit(viewModel: viewModel)
                        .navigationBarBackButtonHidden(true)
//                case "ReservationView":
//                    ReservationView()
//                        .navigationBarBackButtonHidden(true)
//                case "ReservationInfoView" :
//                    ReservationInfoView().navigationBarBackButtonHidden(true)
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
        .fullScreenCover(isPresented: $loginVM.showLoginModal) {
            LoginView(loginviewModel: loginVM, navigationModel: loginNaviModel)
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
            checkForSavedTokens()
        }
        .onChange(of: isLoggedIn) { newValue in
            if !newValue {
                loginVM.showLoginModal = true
            }
        }
    }
    
    private func checkForSavedTokens() {
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken"),
           let refreshToken = UserDefaults.standard.string(forKey: "refreshToken"),
           !accessToken.isEmpty, !refreshToken.isEmpty {
            isLoggedIn = true
            loginVM.showLoginModal = false
        } else {
            isLoggedIn = false
            loginVM.showLoginModal = true
        }
    }
}

// 프로필 헤더 뷰
struct ProfileHeaderView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
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
            
            Image("SnapFitMainLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 117.78, height: 44.17)
                .offset(x: 0, y: 20)
            
            
            
            NavigationLink(value: "MyProfileEdit"){
                Image("editicon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
            }
            
            .offset(x: 160, y: -30)
        }
    }
}

// 사용자 정보 뷰
struct UserInfoView: View {
    var body: some View {
        Group {
            Text("한소희")
                .font(.title3)
                .padding(.top, 40)
            
            StarImageLabel(text: "귀여운")
            
        }
    }
}

// 네비게이션 버튼 뷰
struct NavigationButtonsView: View {
    @Binding var stack: NavigationPath // 바인딩을 통해 전달받음
    
    var body: some View {
        HStack(spacing: 0) {
            NavigationLink(value: "ReservationView") {
                NavigationButtonLabel(title: "예약 내역", count: "0")
            }
            
            Divider()
                .frame(width: 1)
                .background(Color.gray.opacity(0.3))
            
            NavigationLink(value: "DibsView") {
                NavigationButtonLabel(title: "찜한 내역", count: "0")
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


// 뷰 모델
class ProfileViewModel: ObservableObject {
    @Published var selectedItem: PhotosPickerItem? {
        didSet { Task { try await loadImage() } }
    }
    
    @Published var profileImage: Image?
    
    // 이미지 선택후 호출됨 변환하여 사진으로 만드는 메서드
    func loadImage() async throws {
        guard let item = selectedItem else { return }
        guard let imageData = try await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: imageData) else { return }
        self.profileImage = Image(uiImage: uiImage)
    }
}

#Preview {
    MyPageView()
}
