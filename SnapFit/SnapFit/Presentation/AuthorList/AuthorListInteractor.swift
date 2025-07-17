//
//  AuthorListInteractor.swift
//  SnapFit
//
//  Created by 정정욱 on 8/15/24.
//

import Foundation
import Combine

protocol AuthorListBusinessLogic: ProductUseCase {
    
    // MARK: - 상품 호출관련
    func fetchProductAll(request : MainPromotionUseCase.LoadMainPromotion.Request)
    func fetchPostDetailById(request: MainPromotionUseCase.LoadDetailProduct.Request)
    func fetchProductsForMaker(request: MainPromotionUseCase.LoadDetailProduct.ProductsForMakerRequest)
    func fetchProductsFromServerWithFilter(request: MainPromotionUseCase.LoadMainPromotion.VibesRequest)
    
    

    // MARK: - 상품 예약관련
    func makeReservation(request: MainPromotionUseCase.ReservationProduct.Request)
    func fetchUserReservations(request: MainPromotionUseCase.LoadMainPromotion.Request)
    func fetchReservationDetail(request: MainPromotionUseCase.CheckReservationDetailProduct.Request)
    func deleteReservation(request: MainPromotionUseCase.DeleteReservationProduct.Request)
    
    // 상품 찜하기, 취소
    func likePost(request: MainPromotionUseCase.Like.Request)
    func unlikePost(request: MainPromotionUseCase.Like.Request)
}

final class AuthorListInteractor {
    
    
    typealias Request = MainPromotionUseCase.LoadMainPromotion.Request
    typealias Response = MainPromotionUseCase.LoadMainPromotion.Response
    
    var presenter: AuthorListPresentationLogic?
    
    private let productWorker: ProductWorkingLogic
    
    init(productWorker: ProductWorkingLogic) {
        self.productWorker = productWorker
    }
    
    
    private var cancellables = Set<AnyCancellable>()  // Combine 구독 관리를 위한 Set
    
  
}

extension AuthorListInteractor: AuthorListBusinessLogic {
    
    
    func fetchProductAll(request: MainPromotionUseCase.LoadMainPromotion.Request) {
        productWorker.fetchProductsFromServer(limit: request.limit, offset: request.offset)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break // 성공적으로 완료됨
                case .failure(let error):
                    print("상품 조회 실패")
                    self?.presenter?.presentFetchProductFailure(error: error)
                }
            } receiveValue: { [weak self] products in
                print("상품 조회 성공")
                // Response 객체 생성
                let response = MainPromotionUseCase.LoadMainPromotion.Response(products: products)
                // Presenter에 전달
                self?.presenter?.presentFetchProductSuccess(response: response)
            }
            .store(in: &cancellables) // cancellables는 클래스 내에서 선언된 Set<AnyCancellable>
    }
        
    func fetchPostDetailById(request: MainPromotionUseCase.LoadDetailProduct.Request) {
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
                let response = MainPromotionUseCase.LoadDetailProduct.Response(productDetail: productDetail)
                // Presenter에 전달
                self?.presenter?.presentFetchPostDetailByIdSuccess(response: response)
            }
            .store(in: &cancellables) // cancellables는 클래스 내에서 선언된 Set<AnyCancellable>
    }
    
    func fetchProductsForMaker(request: MainPromotionUseCase.LoadDetailProduct.ProductsForMakerRequest) {
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
                let response = MainPromotionUseCase.LoadDetailProduct.ProductsForMakerResponse(products: products)
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
    
    func fetchProductsFromServerWithFilter(request: MainPromotionUseCase.LoadMainPromotion.VibesRequest) {
        productWorker.fetchProductsFromServerWithFilter(vibes: request.vibes, limit: 30, offset: 0)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break // 성공적으로 완료됨
                case .failure(let error):
                    print("필터 조회 실패")
                    self?.presenter?.presentFetchProductFailure(error: error)
                }
            } receiveValue: { [weak self] products in
                print("필터 조회 성공")
                // Response 객체 생성
                let response = MainPromotionUseCase.LoadMainPromotion.Response(products: products)
                // Presenter에 전달
                self?.presenter?.presentFetchProductSuccess(response: response)
            }
            .store(in: &cancellables) // cancellables는 클래스 내에서 선언된 Set<AnyCancellable>
    }
    
    
    
    // MARK: - 상품 예약관련
    func makeReservation(request: MainPromotionUseCase.ReservationProduct.Request) {
        productWorker.makeReservation(reservation: request.reservationRequest)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break // 성공적으로 완료됨
                case .failure(let error):
                    // 에러 발생 시
                    print("상품 예약 실패: \(error.localizedDescription)")
                    let response = MainPromotionUseCase.ReservationProduct.Response(reservationSuccess: false)
                    self?.presenter?.presentReservationFailure(error: error)
                }
            } receiveValue: { [weak self] response in
                // 성공적으로 응답을 받을 때
                print("상품 예약 성공: \(response)")
                let reservationResponse = MainPromotionUseCase.ReservationProduct.Response(
                    reservationSuccess: true,
                    reservationDetails: response // 응답 데이터를 추가로 전달할 수 있음
                )
                self?.presenter?.presentReservationSuccess(response: reservationResponse)
            }
            .store(in: &cancellables) // cancellables는 클래스 내에서 선언된 Set<AnyCancellable>
    }

    
    // 유저 예약내역 리스트
    func fetchUserReservations(request: MainPromotionUseCase.LoadMainPromotion.Request) {
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
                let response = MainPromotionUseCase.CheckReservationProducts.Response(reservationSuccess: true, reservationProducts: products)
                self?.presenter?.presentFetchUserReservationsSuccess(response: response)
            }
            .store(in: &cancellables)
    }
    
    // 예약 상세내역 조회
    func fetchReservationDetail(request: MainPromotionUseCase.CheckReservationDetailProduct.Request) {
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
                let response = MainPromotionUseCase.CheckReservationDetailProduct.Response(reservationDetail: product)
                self?.presenter?.presentFetchReservationDetailSuccess(response: response)
            }
            .store(in: &cancellables)

    }
    
    // 예약 내역 취소
    func deleteReservation(request: MainPromotionUseCase.DeleteReservationProduct.Request) {
        productWorker.deleteReservation(id: request.selectedReservationId, message: request.message)
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
        func unlikePost(request: MainPromotionUseCase.Like.Request) {
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
