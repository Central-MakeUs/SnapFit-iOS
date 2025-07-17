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
    func presentFetchUserDetailsSuccess(response: LoadUserUseCase.Response)
    func presentFetchUserDetailsFailure(error: ApiError)
    
    
    
    // MARK: - 상품 조회관련

    func presentFetchProductAllSuccess(response : MainPromotionUseCase.LoadMainPromotion.Response)
    func presentFetchProductAllFailure(error: ApiError)
    
    func presentFetchPostDetailByIdSuccess(response: MainPromotionUseCase.LoadDetailProduct.Response)
    func presentFetchPostDetailByIdFailure(error: ApiError)
    
    func presentFetchProductsForMakerSuccess(response: MainPromotionUseCase.LoadDetailProduct.ProductsForMakerResponse)
    func presentFetchProductsForMakerFailure(error: ApiError)
    
    func presentVibes(_ vibes: [Vibe])
    func presentVibesFetchFailure(_ error: ApiError)
    
    // MARK: - 상품 예약관련
    func presentReservationFailure(error: ApiError)
    func presentReservationSuccess(response: MainPromotionUseCase.ReservationProduct.Response)
    
    // 유저 예약 내역 리스트 조회
    func presentFetchUserReservationsFailure(error: ApiError)
    func presentFetchUserReservationsSuccess(response : MainPromotionUseCase.CheckReservationProducts.Response)
    
    // 유저 예약 내역 리스트 단일 조회
    func presentFetchReservationDetailSuccess(response: MainPromotionUseCase.CheckReservationDetailProduct.Response)
    func presentFetchReservationDetailFailure(error: ApiError)

    // 유저 예약 내역 취소
    func presentDeleteReservationSuccess(response: MainPromotionUseCase.DeleteReservationProduct.Response)
    func presentDeleteReservationFailure(error: ApiError)
    
    
}



class MainPromotionPresenter: MainPromotionPresentationLogic {
    
    var view: MainPromotionDisplayLogic?
    
    // MARK: - 사용자 조회 관련
    
    func presentFetchUserDetailsSuccess(response: LoadUserUseCase.Response) {
        let viewModel = LoadUserUseCase.ViewModel(userDetails: response.userDetails)
        // View에 전달
        view?.displayUserDetails(viewModel: viewModel)

    }
    
    func presentFetchUserDetailsFailure(error: ApiError) {
        print("Error 사용자 데이터 조회 실패: \(error)")
    }
    
    // MARK: - 상품 조회 관련
    
    func presentFetchProductAllSuccess(response : MainPromotionUseCase.LoadMainPromotion.Response) {
        // Response를 ViewModel로 변환
                let viewModel = MainPromotionUseCase.LoadMainPromotion.ViewModel(products: response.products)
                // View에 전달
                view?.display(viewModel: viewModel)
    }
    
    func presentFetchProductAllFailure(error: ApiError) {
        print("Error occurred: \(error)")
    }
    
    
    func presentFetchPostDetailByIdSuccess(response: MainPromotionUseCase.LoadDetailProduct.Response) {
        let viewModel = MainPromotionUseCase.LoadDetailProduct.ViewModel(productDetail: response.productDetail)
        // View에 전달
        view?.displayDetail(viewModel: viewModel)
    }
    
    func presentFetchPostDetailByIdFailure(error: ApiError) {
        print("Error occurred: \(error)")
    }
    
    
    // 작가 등록 상품 조회
    func presentFetchProductsForMakerSuccess(response: MainPromotionUseCase.LoadDetailProduct.ProductsForMakerResponse) {
        let viewModel = MainPromotionUseCase.LoadDetailProduct.ProductsForMakerViewModel(products: response.products)
        view?.displayDetailProductsForMaker(viewModel: viewModel)
    }
    
    func presentFetchProductsForMakerFailure(error: ApiError) {
        print("작가 등록한 상품 Error occurred: \(error)")
    }
    
    
    // 분위기 정보를 View에 전달
    func presentVibes(_ vibes: [Vibe]) {
        let viewModel = MainPromotionUseCase.LoadMainPromotion.VibesPresentationViewModel(vibes: vibes)
        view?.displayVibes(viewModel: viewModel)
    }
    
    // 분위기 정보를 가져오는 데 실패했을 때 View에 에러를 전달
    func presentVibesFetchFailure(_ error: ApiError) {
        print("Error fetching vibes: \(error)")  // 실제 앱에서는 UI에 에러를 표시해야 함
    }

    
    // MARK: - 상품예약 관련
    
    func presentReservationSuccess(response: MainPromotionUseCase.ReservationProduct.Response) {
        // ViewModel에 예약 성공 여부와 예약 상세 정보를 포함
        let viewModel = MainPromotionUseCase.ReservationProduct.ViewModel(
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

    func presentFetchUserReservationsSuccess(response: MainPromotionUseCase.CheckReservationProducts.Response) {
      
        let viewModel = MainPromotionUseCase.CheckReservationProducts.ViewModel(reservationSuccess: response.reservationSuccess, reservationProducts: response.reservationProducts)
        // View에 전달
        view?.displayFetchUserReservation(viewModel: viewModel)
    }
    
    // 유저 예약 내역 리스트 단일 조회
    func presentFetchReservationDetailSuccess(response: MainPromotionUseCase.CheckReservationDetailProduct.Response) {
        let viewModel = MainPromotionUseCase.CheckReservationDetailProduct.ViewModel(reservationDetail: response.reservationDetail)
        // View에 전달
        view?.displayFetchUserReservationDetail(viewModel: viewModel)
    }
    
    
    func presentFetchReservationDetailFailure(error: ApiError)
    {
        print("Error 유저 예약 내역 리스트 단일 조회: \(error)")
    }
    
    // MARK: - 유저 예약 취소
    func presentDeleteReservationSuccess(response: MainPromotionUseCase.DeleteReservationProduct.Response) {
        let viewModel = MainPromotionUseCase.DeleteReservationProduct.ViewModel(deleteReservationSuccess: response.deleteReservationSuccess)
        // View에 전달
        view?.displayDeleteUserReservation(viewModel: viewModel)
    }
    
    func presentDeleteReservationFailure(error: ApiError) {
        print("예약 취소 실패 : \(error)")
    }
    
    
    
}

