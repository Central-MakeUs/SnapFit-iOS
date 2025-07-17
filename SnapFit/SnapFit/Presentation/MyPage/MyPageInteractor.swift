//
//  MyPageInteractor.swift
//  SnapFit
//
//  Created by 정정욱 on 8/12/24.
//
//
import Foundation
import Combine

protocol MyPageBusinessLogic {
    
    // MARK: - 유저 정보 가져오기
    func fetchUserDetails()
    func fetchCounts()
    
    // 로그아웃, 회원 탈퇴 관련
    func serviceLogout()
    func cancelmembership()
    
    // MARK: - 상품 예약관련
    func fetchUserReservations(request: MainPromotionUseCase.LoadMainPromotion.Request)
    func fetchReservationDetail(request: MainPromotionUseCase.CheckReservationDetailProduct.Request)
    func deleteReservation(request: MainPromotionUseCase.DeleteReservationProduct.Request)
    
    // 상품 찜하기, 취소
    func likePost(request: MainPromotionUseCase.Like.Request)
    func unlikePost(request: MainPromotionUseCase.Like.Request)
    func fetchPostDetailById(request: MainPromotionUseCase.LoadDetailProduct.Request)
    func fetchProductsForMaker(request: MainPromotionUseCase.LoadDetailProduct.ProductsForMakerRequest)
    
    // MARK: - 메이커 관련
    func fetchMakerPosts(request: MakerUseCases.LoadProducts.ProductsForMakerRequest)
    func fetchVibes()
    func fetchLocations()
    func getImages(request: MakerUseCases.RequestMakerImage.ImageURLRequest)
    func postProduct(request: MakerUseCases.RequestMakerProduct.productRequest)
    func fetchUserLikes(request: MainPromotionUseCase.Like.LikeListRequest)
    func fetchMakerReservations(request: MakerUseCases.LoadReservation.Request)
}




final class MyPageInteractor: MyPageBusinessLogic {

    
    
    typealias Request = MyPageUseCase.LoadMyPage.Request
    typealias Response = MyPageUseCase.LoadMyPage.Response
    var presenter: MyPagePresentationLogic?
    
    private let myPageWorker: MyPageWorkingLogic
    private let authWorker: AuthWorkingLogic
    private var cancellables = Set<AnyCancellable>()
    
    init(myPageWorker: MyPageWorkingLogic, authWorker: AuthWorkingLogic) {
        self.myPageWorker = myPageWorker
        self.authWorker = authWorker
    }
    
    func fetchUserDetails() {
        // 서버에서 사용자 정보를 가져옵니다.
        myPageWorker.fetchUserDetails()
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break // 성공적으로 완료됨
                case .failure(let error):
                    print("사용자 정보 조회 실패: \(error)")
                    self?.presenter?.presentFetchUserDetailsFailure(error: error)
                }
            } receiveValue: { [weak self] userDetails in
                print("사용자 정보 조회 성공")
                // Response 객체 생성
                let response = LoadUserUseCase.Response(userDetails: userDetails)
                // Presenter에 전달
                self?.presenter?.presentFetchUserDetailsSuccess(response: response)
            }
            .store(in: &cancellables) // cancellables는 클래스 내에서 선언된 Set<AnyCancellable>
    }
    
    
    func fetchCounts() {
        // 병렬로 API 호출 수행
        let likeCountPublisher = myPageWorker.fetchLikeCount()
        let reservationCountPublisher = myPageWorker.fetchReservationCount()
        
        Publishers.Zip(likeCountPublisher, reservationCountPublisher)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("API 호출 실패: \(error)")
                    self?.presenter?.presentFetchCountsFailure(error: error)
                }
            } receiveValue: { [weak self] likeCountResponse, reservationCountResponse in
                // CombinedResponse 객체 생성
                let response = LoadUserUseCase.CountResponse(userCount: UserCountCombinedResponse(
                    likeCount: likeCountResponse.count,
                    reservationCount: reservationCountResponse.count
                ))
                // Presenter에 전달
                self?.presenter?.presentFetchCountsSuccess(response: response)
            }
            .store(in: &cancellables)
    }
    
    
    func serviceLogout() {
        print("MyPageInteractor logoutFromKakao")
        authWorker.logoutFromKakao { [weak self] result in
            guard let self = self else { return } // self가 nil일 경우 종료
            
            switch result {
            case .success:
                // 카카오 로그아웃 성공 후 SnapFit 서버 로그아웃 처리
                self.authWorker.socialLogoutSnapfitServer()
                    .sink { completion in
                        switch completion {
                        case .finished:
                            print("SnapFit server logout completed")
                        case .failure(let apiError):
                            // 서버 로그아웃 실패 시 프레젠터에 실패 전달
                            self.presenter?.presentLogoutFailure(error: apiError)
                        }
                    } receiveValue: { success in
                        // 서버 로그아웃 성공 시 프레젠터에 성공 전달
                        self.presenter?.presentLogoutSuccess()
                    }
                    .store(in: &self.cancellables)
                
            case .failure(let error):
                // 카카오 로그아웃 실패 시에도 SnapFit 서버 로그아웃 처리 애플이 따로 로그아웃이 없기 때문임
                self.authWorker.socialLogoutSnapfitServer()
                    .sink { completion in
                        switch completion {
                        case .finished:
                            print("SnapFit server logout completed")
                        case .failure(let apiError):
                            // 서버 로그아웃 실패 시 프레젠터에 실패 전달
                            self.presenter?.presentLogoutFailure(error: apiError)
                        }
                    } receiveValue: { success in
                        // 서버 로그아웃 성공 시 프레젠터에 카카오 로그아웃 실패 전달
                        self.presenter?.presentLogoutSuccess()
                    }
                    .store(in: &self.cancellables)
            }
        }
    }
    
    
    func cancelmembership() {
        // 사용자 계정 삭제 작업 시작
        print("MyPageInteractor cancelmembership")
        authWorker.deleteUserAccount()
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    // 계정 삭제 완료
                    print("Cancel membership 성공")
                case .failure(let error):
                    // 계정 삭제 실패
                    print("Cancel membership failed: \(error)")
                    self?.presenter?.presentCancelMembershipFailure(error: error)
                }
            } receiveValue: { success in
                // 성공 여부 처리 (여기서는 결과가 항상 true임을 가정)
                if success {
                    print("User account has been successfully deleted.")
                    self.presenter?.presentCancelMembershipSuccess()
                }
            }
            .store(in: &cancellables)
    }
    
    // 유저 예약내역 리스트
    func fetchUserReservations(request: MainPromotionUseCase.LoadMainPromotion.Request) {
        myPageWorker.fetchUserReservations(limit: request.limit, offset: request.offset)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("유저 예약 내역 로드 실패: \(error.localizedDescription)")
                    self?.presenter?.presentFetchUserReservationsFailure(error: error)
                }
            } receiveValue: { [weak self] products in
                print("유저 예약 내역 로드 성공: \(products)")
                let response = MainPromotionUseCase.CheckReservationProducts.Response(reservationSuccess: true, reservationProducts: products)
                self?.presenter?.presentFetchUserReservationsSuccess(response: response)
            }
            .store(in: &cancellables)
    }
    
    // 유저 찜 리스트
    func fetchUserLikes(request: MainPromotionUseCase.Like.LikeListRequest) {
        myPageWorker.fetchUserLikes(limit: request.limit, offset: request.offset)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("유저 찜 내역 로드 실패: \(error.localizedDescription)")
                    self?.presenter?.presentFetchUserLikesFailure(error: error)
                }
            } receiveValue: { [weak self] products in
                print("유저 찜 내역 로드 성공: \(products)")
                let response = MainPromotionUseCase.Like.LikeListResponse(likeProducts: products)
                self?.presenter?.presentFetchUserLikesSuccess(response: response)
            }
            .store(in: &cancellables)
    }
    
    // 찜 상품 보기
    func fetchPostDetailById(request: MainPromotionUseCase.LoadDetailProduct.Request) {
        myPageWorker.fetchPostDetailById(postId: request.id)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break // 성공적으로 완료됨
                case .failure(let error):
                    print("상품 디테일 조회 실패")
                    self?.presenter?.presentFetchPostDetailByIdFailure(error: error)
                }
            } receiveValue: { [weak self] productDetail in
                print("상품 조회 성공")
                // Response 객체 생성
                let response = MainPromotionUseCase.LoadDetailProduct.Response(productDetail: productDetail)
                // Presenter에 전달
                self?.presenter?.presentFetchPostDetailByIdSuccess(response: response)
            }
            .store(in: &cancellables) // cancellables는 클래스 내에서 선언된 Set<AnyCancellable>
    }
    
    func fetchProductsForMaker(request: MainPromotionUseCase.LoadDetailProduct.ProductsForMakerRequest) {
        myPageWorker.fetchProductsForMaker(userId: request.makerid, limit: request.limit, offset: request.offset)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break // 성공적으로 완료됨
                case .failure(let error):
                    print("작가 등록한 상품 조회 실패")
                    self?.presenter?.presentFetchProductsForMakerFailure(error: error)
                }
            } receiveValue: { [weak self] products in
                print("작가 등록한 상품 조회 성공")
                // Response 객체 생성
                let response = MainPromotionUseCase.LoadDetailProduct.ProductsForMakerResponse(products: products)
                // Presenter에 전달
                self?.presenter?.presentFetchProductsForMakerSuccess(response: response)
            }
            .store(in: &cancellables) // cancellables는 클래스 내에서 선언된 Set<AnyCancellable>
    }
    
    
    
    // 상세내역 조회
    func fetchReservationDetail(request: MainPromotionUseCase.CheckReservationDetailProduct.Request) {
        myPageWorker.fetchReservationDetail(id: request.selectedReservationId)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("예약 상세내역 조회 실패 : \(error.localizedDescription)")
                    self?.presenter?.presentFetchReservationDetailFailure(error: error)
                }
            } receiveValue: { [weak self] product in
                print("예약 상세내역 조회 성공 : \(product)")
                let response = MainPromotionUseCase.CheckReservationDetailProduct.Response(reservationDetail: product)
                self?.presenter?.presentFetchReservationDetailSuccess(response: response)
            }
            .store(in: &cancellables)
        
    }
    
    // 예약 내역 취소
    func deleteReservation(request: MainPromotionUseCase.DeleteReservationProduct.Request) {
        myPageWorker.deleteReservation(id: request.selectedReservationId, message: request.message)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("예약 상세내역 조회 실패 : \(error.localizedDescription)")
                    self?.presenter?.presentDeleteReservationFailure(error: error)
                }
            } receiveValue: { [weak self] success in
                print("예약 상세내역 조회 성공 : \(success)")
                let response = MainPromotionUseCase.DeleteReservationProduct.Response(deleteReservationSuccess: success)
                self?.presenter?.presentDeleteReservationSuccess(response: response)
            }
            .store(in: &cancellables)
    }
    
    // 좋아요 요청
    func likePost(request: MainPromotionUseCase.Like.Request) {
        myPageWorker.likePost(postId: request.postId)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("좋아요 실패: \(error.localizedDescription)")
                    //self?.presenter?.presentLikePostFailure(error: error)
                }
            } receiveValue: { [weak self] response in
                print("좋아요 성공: \(response)")
                //self?.presenter?.presentLikePostSuccess(response: response)
            }
            .store(in: &cancellables)
    }
    
    // 좋아요 취소 요청
    func unlikePost(request: MainPromotionUseCase.Like.Request) {
        myPageWorker.unlikePost(postId: request.postId)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("좋아요 취소 실패: \(error.localizedDescription)")
                    //self?.presenter?.presentUnlikePostFailure(error: error)
                }
            } receiveValue: { [weak self] response in
                print("좋아요 취소 성공: \(response)")
                //self?.presenter?.presentUnlikePostSuccess(response: response)
            }
            .store(in: &cancellables)
    }
    
    
    
    // MARK: - 메이커 관련 기능
    
    // 메이커 상품 조회
    func fetchMakerPosts(request: MakerUseCases.LoadProducts.ProductsForMakerRequest) {
        myPageWorker.fetchMakerPosts(userId: request.makerid, limit: request.limit, offset: request.offset)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("메이커 상품리스트 로드 실패: \(error.localizedDescription)")
                    self?.presenter?.presentFetchMakerProductsFailure(error: error)
                }
            } receiveValue: { [weak self] products in
                print("메이커 상품리스트 로드 성공: \(products)")
                let response = MakerUseCases.LoadProducts.ProductsForMakerResponse(products: products)
                self?.presenter?.presentFetchMakerProductsSuccess(response: response)
            }
            .store(in: &cancellables)
    }
    
    // 분위기 정보 가져오기
    func fetchVibes() {
        myPageWorker.fetchVibes()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.presenter?.presentVibesFetchFailure(error)
                case .finished:
                    break
                }
            }, receiveValue: { vibes in
                let response = MakerUseCases.LoadVibeAndLocation.VibesResponse(vibes: vibes)
                self.presenter?.presentVibes(response:response)
            })
            .store(in: &cancellables)
    }
    
    // 위치 정보 가져오기
    func fetchLocations() {
        myPageWorker.fetchLocations()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.presenter?.presentLocationsFetchFailure(error)
                case .finished:
                    break
                }
            }, receiveValue: { locations in
                let response = MakerUseCases.LoadVibeAndLocation.LocationsResponse(locations: locations)
                self.presenter?.presentLocations(response: response)
            })
            .store(in: &cancellables)
    }
    

    // MARK: - 이미지 URL 가져오기
    func getImages(request: MakerUseCases.RequestMakerImage.ImageURLRequest) {
        fetchAllImagePaths(count: request.Images.count, ext: "png", maxRetries: 8)
            .flatMap { [self] fileInfos -> AnyPublisher<[String], ApiError> in
                return myPageWorker.uploadImages(fileInfos: fileInfos, images: request.Images)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.presenter?.presentImageFetchFailure(error: error)
                case .finished:
                    break
                }
            }, receiveValue: { filePaths in
                let response = MakerUseCases.RequestMakerImage.ImageURLResponse(Images: filePaths)
                self.presenter?.presentImageURLs(response: response)
            })
            .store(in: &cancellables)
    }


    private func fetchAllImagePaths(count: Int, ext: String, maxRetries: Int) -> AnyPublisher<[ImageInfoResponse.FileInfo], ApiError> {
        // 파일 경로 요청
        let initialPublisher = myPageWorker.fetchImagePaths(ext: ext)
        
        return initialPublisher
            .flatMap { fileInfos -> AnyPublisher<[ImageInfoResponse.FileInfo], ApiError> in
                if fileInfos.count >= count {
                    // 필요한 개수만큼 경로가 준비된 경우, 반환
                    return Just(fileInfos.prefix(count).toArray())
                        .setFailureType(to: ApiError.self)
                        .eraseToAnyPublisher()
                } else if maxRetries > 0 {
                    // 부족한 파일 경로가 있을 경우, 추가로 호출하여 부족한 수만큼 재시도
                    let remainingCount = count - fileInfos.count
                    return self.fetchAllImagePaths(count: remainingCount, ext: ext, maxRetries: maxRetries - 1)
                        .map { additionalFileInfos in
                            return fileInfos + additionalFileInfos
                        }
                        .eraseToAnyPublisher()
                } else {
                    // 재시도 횟수 초과 시 에러 반환
                    return Fail(error: ApiError.invalidImageCount).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }





    
    
    // 상품 등록
    func postProduct(request: MakerUseCases.RequestMakerProduct.productRequest) {
        print("상품 \(request)")
        myPageWorker.postProduct(request: request.product)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.presenter?.presentProductPostFailure(error: error)
                case .finished:
                    break
                }
            }, receiveValue: { productResponse in
                let response = MakerUseCases.RequestMakerProduct.productResponse(product: productResponse)
                self.presenter?.presentProductPostSuccess(response: response)
            })
            .store(in: &cancellables)
    }
    
    
    // 메이커 예약내역 리스트
    func fetchMakerReservations(request: MakerUseCases.LoadReservation.Request) {
        myPageWorker.fetchMakerReservations(limit: request.limit, offset: request.offset)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("메이커 예약 내역 로드 실패: \(error.localizedDescription)")
                    self?.presenter?.presentFetchMakerReservationsFailure(error: error)
                }
            } receiveValue: { [weak self] products in
                print("메이커 예약 내역 로드 성공: \(products)")
                let response = MakerUseCases.LoadReservation.Response(products: products)
                self?.presenter?.presentFetchMakerReservationsSuccess(response: response)
            }
            .store(in: &cancellables)
    }
    
  
}

// Helper extension to convert ArraySlice to Array
extension ArraySlice {
    func toArray() -> [Element] {
        return Array(self)
    }
}
