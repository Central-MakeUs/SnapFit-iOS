//
//  MyPagePresenter.swift
//  SnapFit
//
//  Created by 정정욱 on 8/12/24.
//  
//
import Foundation

protocol MyPagePresentationLogic {
    func present(response: MyPage.LoadMyPage.Response)
    func presentLogoutFailure(error: ApiError)
    func presentLogoutSuccess()
    
    // MARK: - 상품 예약관련
    
    // 유저 예약 내역 리스트 조회
    func presentFetchUserReservationsFailure(error: ApiError)
    func presentFetchUserReservationsSuccess(response : MainPromotion.CheckReservationProducts.Response)
    
    // 유저 예약 내역 리스트 단일 조회
    func presentFetchReservationDetailSuccess(response: MainPromotion.CheckReservationDetailProduct.Response)
    func presentFetchReservationDetailFailure(error: ApiError)

    
}

final class MyPagePresenter {
    typealias Response = MyPage.LoadMyPage.Response
    typealias ViewModel = MyPage.LoadMyPage.ViewModel
    var view: MyPageDisplayLogic?
}

extension MyPagePresenter: MyPagePresentationLogic {

    func presentLogoutSuccess() {
        
        print("로그아웃 성공")
        let viewModel = MyPage.LoadMyPage.ViewModel(logOut: true)
        view?.display(viewModel: viewModel)
    }
    
    func presentLogoutFailure(error: ApiError) {
        print("로그아웃 실패 \(error)")
    }
    
    func present(response: Response) {
    //    view?.display(viewModel: viewModel)
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
