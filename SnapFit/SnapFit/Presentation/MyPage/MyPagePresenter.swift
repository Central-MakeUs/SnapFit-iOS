//
//  MyPagePresenter.swift
//  SnapFit
//
//  Created by 정정욱 on 8/12/24.
//  
//
import Foundation

protocol MyPagePresentationLogic {
    
    // MARK: - 사용자 조회 관련
    func presentFetchUserDetailsSuccess(response: LoadUserDetails.Response)
    func presentFetchUserDetailsFailure(error: ApiError)
    
    func presentFetchCountsSuccess(response: LoadUserDetails.CountResponse)
    func presentFetchCountsFailure(error: ApiError)
        
    func present(response: MyPage.LoadMyPage.Response)
    func presentLogoutFailure(error: ApiError)
    func presentLogoutSuccess()
    
    func presentCancelMembershipSuccess()
    func presentCancelMembershipFailure(error: ApiError)

    
    // MARK: - 상품 예약관련
    
    // 유저 예약 내역 리스트 조회
    func presentFetchUserReservationsFailure(error: ApiError)
    func presentFetchUserReservationsSuccess(response : MainPromotion.CheckReservationProducts.Response)
    
    // 유저 예약 내역 리스트 단일 조회
    func presentFetchReservationDetailSuccess(response: MainPromotion.CheckReservationDetailProduct.Response)
    func presentFetchReservationDetailFailure(error: ApiError)
    
    // 유저 찜 내역 리스트 조회
    func presentFetchUserLikesFailure(error: ApiError)
    func presentFetchUserLikesSuccess(response: MainPromotion.CheckReservationProducts.Response)
    
  
    
}

final class MyPagePresenter {
    typealias Response = MyPage.LoadMyPage.Response
    typealias ViewModel = MyPage.LoadMyPage.ViewModel
    var view: MyPageDisplayLogic?
}

extension MyPagePresenter: MyPagePresentationLogic {
  
    // 사용자 탈퇴후 로그인뷰 보이게
    func presentCancelMembershipSuccess() {
        let viewModel = MyPage.LoadMyPage.ViewModel(logOut: true)
        view?.display(viewModel: viewModel)
    }
    
    func presentCancelMembershipFailure(error: ApiError) {
        print("Error 사용자 탈퇴 실패: \(error)")
    }
    
    
    // MARK: - 사용자 조회 관련
    
    func presentFetchUserDetailsSuccess(response: LoadUserDetails.Response) {
        let viewModel = LoadUserDetails.ViewModel(userDetails: response.userDetails)
        // View에 전달
        view?.displayUserDetails(viewModel: viewModel)

    }
    
    func presentFetchUserDetailsFailure(error: ApiError) {
        print("Error 사용자 데이터 조회 실패: \(error)")
    }
    
    
    // 카운트 관련
    func presentFetchCountsSuccess(response: LoadUserDetails.CountResponse) {
        // CombineResponse의 데이터를 뷰에 전달
        let viewModel = LoadUserDetails.CountViewModel(userCount: response.userCount)
        view?.displayCounts(viewModel: viewModel)
    }
    
    func presentFetchCountsFailure(error: ApiError) {
        // 에러를 뷰에 전달
        print("Error 사용자 좋아요, 찜 카운트 조회 실패: \(error)")
    }

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
    
    // MARK: - 유저 찜 내역 조회
    func presentFetchUserLikesFailure(error: ApiError) {
        print("Error occurred: \(error)")
    }

    func presentFetchUserLikesSuccess(response: MainPromotion.CheckReservationProducts.Response) {
      
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
