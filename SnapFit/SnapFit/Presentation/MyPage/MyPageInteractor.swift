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
    func fetchUserReservations(request: MainPromotion.LoadMainPromotion.Request)
    func fetchReservationDetail(request: MainPromotion.CheckReservationDetailProduct.Request)
    func fetchUserLikes(request: MainPromotion.LoadMainPromotion.Request)

    // 상품 찜하기, 취소
    func likePost(request: MainPromotion.Like.Request)
    func unlikePost(request: MainPromotion.Like.Request)
}




final class MyPageInteractor: MyPageBusinessLogic {
    
    typealias Request = MyPage.LoadMyPage.Request
    typealias Response = MyPage.LoadMyPage.Response
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
                let response = LoadUserDetails.Response(userDetails: userDetails)
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
                let response = LoadUserDetails.CountResponse(userCount: UserCountCombinedResponse(
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
    func fetchUserReservations(request: MainPromotion.LoadMainPromotion.Request) {
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
                let response = MainPromotion.CheckReservationProducts.Response(reservationSuccess: true, reservationProducts: products)
                self?.presenter?.presentFetchUserReservationsSuccess(response: response)
            }
            .store(in: &cancellables)
    }
    
    // 유저 찜 리스트
    func fetchUserLikes(request: MainPromotion.LoadMainPromotion.Request) {
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
                let response = MainPromotion.CheckReservationProducts.Response(reservationSuccess: true, reservationProducts: products)
                self?.presenter?.presentFetchUserLikesSuccess(response: response)
            }
            .store(in: &cancellables)
    }
    
    
    
    // 상세내역 조회
    func fetchReservationDetail(request: MainPromotion.CheckReservationDetailProduct.Request) {
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
                let response = MainPromotion.CheckReservationDetailProduct.Response(reservationDetail: product)
                self?.presenter?.presentFetchReservationDetailSuccess(response: response)
            }
            .store(in: &cancellables)

    }
    
    // 좋아요 요청
        func likePost(request: MainPromotion.Like.Request) {
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
        func unlikePost(request: MainPromotion.Like.Request) {
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
    
   
}

