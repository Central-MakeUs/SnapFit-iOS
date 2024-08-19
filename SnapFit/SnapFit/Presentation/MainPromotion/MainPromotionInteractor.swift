//
//  MainPromotionInteractor.swift
//  SnapFit
//
//  Created by 정정욱 on 8/14/24.
//
//
import Foundation
import Combine

protocol MainPromotionBusinessLogic: ProductBusinessLogic{
    
    
    // MARK: - 유저 정보 가져오기
    func fetchUserDetails()
    
    // MARK: - 상품 정보 가져오기
    
    func fetchProductAll(request : MainPromotion.LoadMainPromotion.Request)
    func fetchPostDetailById(request: MainPromotion.LoadDetailProduct.Request)
    func fetchProductsForMaker(request: MainPromotion.LoadDetailProduct.ProductsForMakerRequest)
    func fetchVibes()
    
    // MARK: - 상품 예약관련
    func makeReservation(request: MainPromotion.ReservationProduct.Request)
    func fetchUserReservations(request: MainPromotion.LoadMainPromotion.Request)
    func fetchReservationDetail(request: MainPromotion.CheckReservationDetailProduct.Request)
    
    // 상품 찜하기, 취소
    func likePost(request: MainPromotion.Like.Request)
    func unlikePost(request: MainPromotion.Like.Request)
}

final class MainPromotionInteractor {
    
    
    typealias Request = MainPromotion.LoadMainPromotion.Request
    typealias Response = MainPromotion.LoadMainPromotion.Response
    var presenter: MainPromotionPresentationLogic?
    
    private let productWorker: ProductWorkingLogic
    
    init(productWorker: ProductWorkingLogic) {
        self.productWorker = productWorker
    }
    
    
    private var cancellables = Set<AnyCancellable>()  // Combine 구독 관리를 위한 Set
    
    
}

extension MainPromotionInteractor: MainPromotionBusinessLogic {
    
    func fetchUserDetails() {
        // 서버에서 사용자 정보를 가져옵니다.
        productWorker.fetchUserDetails()
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

    
    
    func fetchProductAll(request: MainPromotion.LoadMainPromotion.Request) {
        productWorker.fetchProductsFromServer(limit: request.limit, offset: request.offset)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break // 성공적으로 완료됨
                case .failure(let error):
                    print("상품 조회 실패")
                    self?.presenter?.presentFetchProductAllFailure(error: error)
                }
            } receiveValue: { [weak self] products in
                print("상품 조회 성공")
                // Response 객체 생성
                let response = MainPromotion.LoadMainPromotion.Response(products: products)
                // Presenter에 전달
                self?.presenter?.presentFetchProductAllSuccess(response: response)
            }
            .store(in: &cancellables) // cancellables는 클래스 내에서 선언된 Set<AnyCancellable>
    }
    
    func fetchPostDetailById(request: MainPromotion.LoadDetailProduct.Request) {
        productWorker.fetchPostDetailById(postId: request.id)
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
                let response = MainPromotion.LoadDetailProduct.Response(productDetail: productDetail)
                // Presenter에 전달
                self?.presenter?.presentFetchPostDetailByIdSuccess(response: response)
            }
            .store(in: &cancellables) // cancellables는 클래스 내에서 선언된 Set<AnyCancellable>
    }
    
    // 작가가 등록한 상품 가져오기
    func fetchProductsForMaker(request: MainPromotion.LoadDetailProduct.ProductsForMakerRequest) {
        productWorker.fetchProductsForMaker(userId: request.makerid, limit: request.limit, offset: request.offset)
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
                let response = MainPromotion.LoadDetailProduct.ProductsForMakerResponse(products: products)
                // Presenter에 전달
                self?.presenter?.presentFetchProductsForMakerSuccess(response: response)
            }
            .store(in: &cancellables) // cancellables는 클래스 내에서 선언된 Set<AnyCancellable>
    }
    
    // 분위기 정보 가져오기
    func fetchVibes() {
        productWorker.fetchVibes()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.presenter?.presentVibesFetchFailure(error)
                case .finished:
                    break
                }
            }, receiveValue: { vibes in
                self.presenter?.presentVibes(vibes)
            })
            .store(in: &cancellables)
    }
    
    
    // MARK: - 상품 예약관련
    func makeReservation(request: MainPromotion.ReservationProduct.Request) {
        productWorker.makeReservation(reservation: request.reservationRequest)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break // 성공적으로 완료됨
                case .failure(let error):
                    // 에러 발생 시
                    print("상품 예약 실패: \(error.localizedDescription)")
                    let response = MainPromotion.ReservationProduct.Response(reservationSuccess: false)
                    self?.presenter?.presentReservationFailure(error: error)
                }
            } receiveValue: { [weak self] response in
                // 성공적으로 응답을 받을 때
                print("상품 예약 성공: \(response)")
                let reservationResponse = MainPromotion.ReservationProduct.Response(
                    reservationSuccess: true,
                    reservationDetails: response // 응답 데이터를 추가로 전달할 수 있음
                )
                self?.presenter?.presentReservationSuccess(response: reservationResponse)
            }
            .store(in: &cancellables) // cancellables는 클래스 내에서 선언된 Set<AnyCancellable>
    }
    
    
    // 유저 예약내역 리스트
    func fetchUserReservations(request: MainPromotion.LoadMainPromotion.Request) {
        productWorker.fetchUserReservations(limit: request.limit, offset: request.offset)
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
    
    // 예약 상세내역 조회
    func fetchReservationDetail(request: MainPromotion.CheckReservationDetailProduct.Request) {
        productWorker.fetchReservationDetail(id: request.selectedReservationId)
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
            productWorker.likePost(postId: request.postId)
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
            productWorker.unlikePost(postId: request.postId)
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
