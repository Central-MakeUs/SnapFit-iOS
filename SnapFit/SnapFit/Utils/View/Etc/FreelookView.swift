//
//  FreelookView.swift
//  SnapFit
//
//  Created by 정정욱 on 8/23/24.
//

import SwiftUI
import Combine

struct FreelookView: View {
    @State private var selectedTab: Int = -1
    @State private var stack = NavigationPath()
    @State private var showAlert = false // 로그인 필요 알림 표시 여부
    @State private var isLoggedIn = false // 로그인 상태 관리
    @State private var products: [ProductInfo] = [] // 서버에서 불러온 상품 리스트 저장
    @State private var cancellables = Set<AnyCancellable>() // Combine의 cancellable들을 저장
    
    // 두 개의 열을 가진 그리드 설정
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
    ]
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { geometry in
                 let spacing: CGFloat = geometry.size.width * 0.02 // 화면 크기에 따라 간격을 조정
                 let itemWidth: CGFloat = (geometry.size.width - (spacing * 3)) / 2 // 두 개의 열을 화면 너비에 맞춰 계산
                 
                 VStack {
                     HStack {
                         Image("mainSnapFitLogo")
                             .resizable()
                             .frame(width: 91.18, height: 20)
                         Spacer()
                     }
                     .padding(.horizontal)
                     
                     ScrollView(.vertical, showsIndicators: false) {
                         LazyVGrid(columns: [
                             GridItem(.flexible(), spacing: spacing),
                             GridItem(.flexible(), spacing: spacing)
                         ], spacing: spacing) {
                             ForEach(products.sorted(by: { $0.id < $1.id }), id: \.id) { product in
                                 Button(action: {
                                     handleProductSelection(product)
                                 }) {
                                     MiddleCardView(isLiked: .constant(product.like ?? false), product: product)
                                         .frame(width: itemWidth, height: itemWidth * 1.85) // 카드 비율 조정
                                         .padding(2)
                                 }
                                 .buttonStyle(PlainButtonStyle())  // 기본 버튼 스타일 제거
                             }
                         }
                         .padding(.horizontal, spacing) // 좌우 패딩을 간격과 맞춰 조정
                         .padding(.bottom)
                     }
                 }
                 .toolbar {
                     ToolbarItem(placement: .navigationBarLeading) {
                         Button(action: {
                             dismiss()
                         }) {
                             Image(systemName: "chevron.left")
                                 .foregroundColor(.black)
                         }
                     }
                     
                     ToolbarItem(placement: .principal) {
                         Text("미리보기")
                             .font(.headline)
                             .foregroundColor(.black)
                     }
                 }
                 .onAppear {
                     loadInitialData()
                 }
                 .alert(isPresented: $showAlert) {
                     Alert(
                         title: Text("로그인이 필요합니다"),
                         message: Text("이 기능을 사용하려면 로그인이 필요합니다."),
                         dismissButton: .default(Text("확인"))
                     )
                 }
             }
         }
         
    
    // 상품을 선택했을 때 로그인 상태를 확인하고 알림을 띄우는 메서드
    func handleProductSelection(_ product: ProductInfo) {
        // 로그인 여부와 상관없이 알림을 표시하도록 수정
        showAlert = true
    }
    
    // 초기 데이터 로드
    func loadInitialData() {
        fetchProductsFromServer()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error loading products: \(error)")
                }
            }, receiveValue: { productResponse in
                self.products = productResponse.data // 받아온 상품 데이터로 업데이트
            })
            .store(in: &cancellables)
        
        // 여기서 로그인 상태 확인 (예: 토큰 유무로 판단)
        isLoggedIn = checkLoginStatus()
    }
    
    // 서버에서 상품 데이터를 가져오는 메서드
    func fetchProductsFromServer(limit: Int = 10, offset: Int = 0) -> AnyPublisher<Product, ApiError> {
        guard let accessToken = getAccessToken() else {
            return Fail(error: ApiError.invalidRefreshToken).eraseToAnyPublisher()
        }
        
        let urlString = "http://34.47.94.218/snapfit/posts/all?limit=\(limit)&offset=\(offset)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "accept")
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, urlResponse: URLResponse) -> Data in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    throw ApiError.unknown(nil)
                }
                
                switch httpResponse.statusCode {
                case 400...404:
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                    let message = errorResponse?.message ?? "Bad Request"
                    let errorCode = errorResponse?.errorCode ?? 0
                    throw ApiError.badRequest(message: message, errorCode: errorCode)
                case 401:
                    throw ApiError.invalidRefreshToken
                default:
                    if !(200...299).contains(httpResponse.statusCode) {
                        throw ApiError.badStatus(code: httpResponse.statusCode)
                    }
                }
                
                return data
            }
            .decode(type: Product.self, decoder: JSONDecoder())
            .mapError { error in
                if let apiError = error as? ApiError {
                    return apiError
                }
                if let _ = error as? DecodingError {
                    return ApiError.decodingError
                }
                return ApiError.unknown(error)
            }
            .eraseToAnyPublisher()
    }
    
    // 로그인 상태 확인 (임의의 로직)
    func checkLoginStatus() -> Bool {
        // 실제로는 사용자 인증 정보나 토큰 저장소에서 가져오는 로직을 구현
        // 예: UserDefaults 또는 Keychain을 통해
        return getAccessToken() != nil
    }
    
    // Access Token을 가져오는 메서드
    func getAccessToken() -> String? {
        // 실제로는 사용자 인증 정보나 토큰 저장소에서 가져오는 로직을 구현
        // 예: UserDefaults 또는 Keychain을 통해
        let fixedToken = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOjMyLCJyb2xlIjpbIlJPTEVfVVNFUiJdLCJpYXQiOjE3MjQ5MTM1OTgsImV4cCI6MTcyNjk4NzE5OH0.iDQAzUU1pQYzSMQL24JzUbudh-GrqATkLmeta2gViJ4"
        
        return fixedToken
    }
}


#Preview {
    FreelookView()
}
