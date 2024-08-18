//
//  MainPromotionPresenter.swift
//  SnapFit
//
//  Created by 정정욱 on 8/14/24.
//  
//
import Foundation

protocol MainPromotionPresentationLogic {
    
    
    // MARK: - 사용자 조회관련
    func presentFetchUserDetailsSuccess(response: LoadUserDetails.Response)
    func presentFetchUserDetailsFailure(error: ApiError)
    
    
    
    // MARK: - 상품 조회관련

    func presentFetchProductAllSuccess(response : MainPromotion.LoadMainPromotion.Response)
    func presentFetchProductAllFailure(error: ApiError)
    
    func presentFetchPostDetailByIdSuccess(response: MainPromotion.LoadDetailProduct.Response)
    func presentFetchPostDetailByIdFailure(error: ApiError)
    
    func presentFetchProductsForMakerSuccess(response: MainPromotion.LoadDetailProduct.ProductsForMakerResponse)
    func presentFetchProductsForMakerFailure(error: ApiError)
    
    func presentVibes(_ vibes: [Vibe])
    func presentVibesFetchFailure(_ error: ApiError)
    
    // MARK: - 상품 예약관련
    func presentReservationFailure(error: ApiError)
    func presentReservationSuccess(response: MainPromotion.ReservationProduct.Response)
    
    // 유저 예약 내역 리스트 조회
    func presentFetchUserReservationsFailure(error: ApiError)
    func presentFetchUserReservationsSuccess(response : MainPromotion.CheckReservationProducts.Response)
    
    // 유저 예약 내역 리스트 단일 조회
    func presentFetchReservationDetailSuccess(response: MainPromotion.CheckReservationDetailProduct.Response)
    func presentFetchReservationDetailFailure(error: ApiError)

    
}



class MainPromotionPresenter: MainPromotionPresentationLogic {
    
    var view: MainPromotionDisplayLogic?
    
    // MARK: - 사용자 조회 관련
    
    func presentFetchUserDetailsSuccess(response: LoadUserDetails.Response) {
        let viewModel = LoadUserDetails.ViewModel(userDetails: response.userDetails)
        // View에 전달
        view?.displayUserDetails(viewModel: viewModel)

    }
    
    func presentFetchUserDetailsFailure(error: ApiError) {
        print("Error 사용자 데이터 조회 실패: \(error)")
    }
    
    // MARK: - 상품 조회 관련
    
    func presentFetchProductAllSuccess(response : MainPromotion.LoadMainPromotion.Response) {
        // Response를 ViewModel로 변환
                let viewModel = MainPromotion.LoadMainPromotion.ViewModel(products: response.products)
                // View에 전달
                view?.display(viewModel: viewModel)
    }
    
    func presentFetchProductAllFailure(error: ApiError) {
        print("Error occurred: \(error)")
    }
    
    
    func presentFetchPostDetailByIdSuccess(response: MainPromotion.LoadDetailProduct.Response) {
        let viewModel = MainPromotion.LoadDetailProduct.ViewModel(productDetail: response.productDetail)
        // View에 전달
        view?.displayDetail(viewModel: viewModel)
    }
    
    func presentFetchPostDetailByIdFailure(error: ApiError) {
        print("Error occurred: \(error)")
    }
    
    
    // 작가 등록 상품 조회
    func presentFetchProductsForMakerSuccess(response: MainPromotion.LoadDetailProduct.ProductsForMakerResponse) {
        let viewModel = MainPromotion.LoadDetailProduct.ProductsForMakerViewModel(products: response.products)
        view?.displayDetailProductsForMaker(viewModel: viewModel)
    }
    
    func presentFetchProductsForMakerFailure(error: ApiError) {
        print("작가 등록한 상품 Error occurred: \(error)")
    }
    
    
    // 분위기 정보를 View에 전달
    func presentVibes(_ vibes: [Vibe]) {
        let viewModel = MainPromotion.LoadMainPromotion.VibesPresentationViewModel(vibes: vibes)
        view?.displayVibes(viewModel: viewModel)
    }
    
    // 분위기 정보를 가져오는 데 실패했을 때 View에 에러를 전달
    func presentVibesFetchFailure(_ error: ApiError) {
        print("Error fetching vibes: \(error)")  // 실제 앱에서는 UI에 에러를 표시해야 함
    }

    
    // MARK: - 상품예약 관련
    
    func presentReservationSuccess(response: MainPromotion.ReservationProduct.Response) {
        // ViewModel에 예약 성공 여부와 예약 상세 정보를 포함
        let viewModel = MainPromotion.ReservationProduct.ViewModel(
            reservationSuccess: response.reservationSuccess,
            reservationDetails: response.reservationDetails // 추가된 예약 상세 정보
        )
        
        // 뷰에 성공적인 예약을 표시
        view?.displayReservationSuccess(viewModel: viewModel)
    }


    func presentReservationFailure(error: ApiError) {
        print("presentReservationFailure: \(error)")
    }
    
    
    
    // MARK: - 유저 예약 내역 조회
    func presentFetchUserReservationsFailure(error: ApiError) {
        print("Error occurred: \(error)")
    }

    func presentFetchUserReservationsSuccess(response: MainPromotion.CheckReservationProducts.Response) {
      
        let viewModel = MainPromotion.CheckReservationProducts.ViewModel(reservationSuccess: response.reservationSuccess, reservationProducts: response.reservationProducts)
        // View에 전달
        view?.displayFetchUserReservation(viewModel: viewModel)
    }
    
    // 유저 예약 내역 리스트 단일 조회
    func presentFetchReservationDetailSuccess(response: MainPromotion.CheckReservationDetailProduct.Response) {
        let viewModel = MainPromotion.CheckReservationDetailProduct.ViewModel(reservationDetail: response.reservationDetail)
        // View에 전달
        view?.displayFetchUserReservationDetail(viewModel: viewModel)
    }
    
    
    func presentFetchReservationDetailFailure(error: ApiError)
    {
        print("Error 유저 예약 내역 리스트 단일 조회: \(error)")
    }
    
    
}

