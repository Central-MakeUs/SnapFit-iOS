//
//  MainPromotionInteractor.swift
//  SnapFit
//
//  Created by 정정욱 on 8/14/24.
//  
//
import Foundation
import Combine

protocol MainPromotionBusinessLogic {
    //func load(request: MainPromotion.LoadMainPromotion.Request)
    func fetchProductAll(request : MainPromotion.LoadMainPromotion.Request)
   
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
    
}
