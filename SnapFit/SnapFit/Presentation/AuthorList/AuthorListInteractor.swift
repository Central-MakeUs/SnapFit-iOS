//
//  AuthorListInteractor.swift
//  SnapFit
//
//  Created by 정정욱 on 8/15/24.
//

import Foundation
import Combine

protocol AuthorListBusinessLogic: ProductBusinessLogic {
    //func load(request: MainPromotion.LoadMainPromotion.Request)
    func fetchProductAll(request : MainPromotion.LoadMainPromotion.Request)
    func fetchPostDetailById(request: MainPromotion.LoadDetailProduct.Request)
    func fetchProductsForMaker(request: MainPromotion.LoadDetailProduct.ProductsForMakerRequest)
    

    func fetchProductsFromServerWithFilter(request: MainPromotion.LoadMainPromotion.VibesRequest)
    
}

final class AuthorListInteractor {
    
    
    typealias Request = MainPromotion.LoadMainPromotion.Request
    typealias Response = MainPromotion.LoadMainPromotion.Response
    
    var presenter: AuthorListPresentationLogic?
    
    private let productWorker: ProductWorkingLogic
    
    init(productWorker: ProductWorkingLogic) {
        self.productWorker = productWorker
    }
    
    
    private var cancellables = Set<AnyCancellable>()  // Combine 구독 관리를 위한 Set
    
  
}

extension AuthorListInteractor: AuthorListBusinessLogic {

    
    func load(request: Request) {
        // presenter?.present(response:  Response)
    }
    
    
    func fetchProductAll(request: MainPromotion.LoadMainPromotion.Request) {
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
                let response = MainPromotion.LoadMainPromotion.Response(products: products)
                // Presenter에 전달
                self?.presenter?.presentFetchProductSuccess(response: response)
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
    
    func fetchProductsFromServerWithFilter(request: MainPromotion.LoadMainPromotion.VibesRequest) {
        productWorker.fetchProductsFromServerWithFilter(vibes: request.vibes, limit: 10, offset: 0)
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
                let response = MainPromotion.LoadMainPromotion.Response(products: products)
                // Presenter에 전달
                self?.presenter?.presentFetchProductSuccess(response: response)
            }
            .store(in: &cancellables) // cancellables는 클래스 내에서 선언된 Set<AnyCancellable>
    }
}
