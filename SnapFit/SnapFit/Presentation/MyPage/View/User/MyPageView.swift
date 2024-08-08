import SwiftUI
import PhotosUI

// 메인 MyPageView
struct MyPageView: View {
    @StateObject var viewModel = ProfileViewModel()
    @State var stack = NavigationPath() // 초기 설정
    
    var body: some View {
        NavigationStack(path: $stack) {
            ScrollView {
                VStack(alignment: .leading) {
                    ProfileHeaderView(viewModel: viewModel)
                    
                    UserInfoView()
                        .padding(.horizontal)
                    
                    NavigationButtonsView()
                        .padding(.bottom, 32)
                    GroupBoxViews()
                   
                    Spacer()
                        .frame(height: 40)
                    
                    Spacer()
                }
            }
            .ignoresSafeArea(.container, edges: .top)
        }
        .accentColor(.black) // 내비게이션 링크 색상을 검정색으로 변경
    }
}

// 프로필 헤더 뷰
struct ProfileHeaderView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .frame(width: .infinity, height: 168)
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
            
            Button(action: {
                // 예약 내역 버튼 액션
            }) {
                NavigationLink(destination: MyProfileEdit(viewModel: viewModel).navigationBarBackButtonHidden(true)) {
                    Image("editicon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                }
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
    var body: some View {
        HStack(spacing: 0) {
            NavigationButton(destination: ReservationView()
                             , title: "예약 내역", count: "0")
            
            Divider()
                .frame(width: 1)
                .background(Color.gray.opacity(0.3))
            
            NavigationButton(destination: DibsView(), title: "찜한 내역", count: "0")
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

// 네비게이션 버튼 커스텀 뷰
struct NavigationButton<Destination: View>: View {
    let destination: Destination
    let title: String
    let count: String
    
    var body: some View {
        Button(action: {}) {
            NavigationLink(destination: destination.navigationBarBackButtonHidden(true)) {
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
            }
            .frame(maxWidth: .infinity, maxHeight: 108)
            .background(Color.white)
          
        }
    }
}

// 그룹 박스 뷰
struct GroupBoxViews: View {
    var body: some View {
        
        SectionHeaderView(title: "메이커 관리")
            .padding(.bottom, 16)
        Group {
            AppInfoContent(name: "사진작가로 전환")
         
            AppInfoContent(name: "상품관리")
        
            AppInfoContent(name: "예약관리")
                .padding(.bottom, 24)
                
        }
        .backgroundStyle(Color.white) // 배경색을 흰색으로 변경
        .padding(.horizontal, 16)
       
        SectionHeaderView(title: "SnapFit 설정")
        Group{
            AppInfoContent(name: "고객센터")
            AppInfoContent(name: "이용약관")
            AppInfoContent(name: "로그아웃")
            AppInfoContent(name: "탈퇴하기")
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
