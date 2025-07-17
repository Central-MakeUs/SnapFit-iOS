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
    func presentFetchUserDetailsSuccess(response: LoadUserUseCase.Response)
    func presentFetchUserDetailsFailure(error: ApiError)
    
    func presentFetchCountsSuccess(response: LoadUserUseCase.CountResponse)
    func presentFetchCountsFailure(error: ApiError)
        
    func present(response: MyPageUseCase.LoadMyPage.Response)
    func presentLogoutFailure(error: ApiError)
    func presentLogoutSuccess()
    
    func presentCancelMembershipSuccess()
    func presentCancelMembershipFailure(error: ApiError)

    
    // MARK: - 상품 예약관련
    
    // 유저 예약 내역 리스트 조회
    func presentFetchUserReservationsFailure(error: ApiError)
    func presentFetchUserReservationsSuccess(response : MainPromotionUseCase.CheckReservationProducts.Response)
    
    // 유저 예약 내역 리스트 단일 조회
    func presentFetchReservationDetailSuccess(response: MainPromotionUseCase.CheckReservationDetailProduct.Response)
    func presentFetchReservationDetailFailure(error: ApiError)
    
    // 유저 예약 내역 취소
    func presentDeleteReservationSuccess(response: MainPromotionUseCase.DeleteReservationProduct.Response)
    func presentDeleteReservationFailure(error: ApiError)
    
    // 유저 찜 내역 리스트 조회
    func presentFetchUserLikesFailure(error: ApiError)
    func presentFetchUserLikesSuccess(response: MainPromotionUseCase.Like.LikeListResponse)
    
    // 유저 찜한 상품 보기
    func presentFetchPostDetailByIdSuccess(response: MainPromotionUseCase.LoadDetailProduct.Response)
    func presentFetchPostDetailByIdFailure(error: ApiError)
    
    func presentFetchProductsForMakerSuccess(response: MainPromotionUseCase.LoadDetailProduct.ProductsForMakerResponse)
    func presentFetchProductsForMakerFailure(error: ApiError)
    
    
    // MARK: - 메이커 관련
    func presentFetchMakerProductsFailure(error: ApiError)
    func presentFetchMakerProductsSuccess(response: MakerUseCases.LoadProducts.ProductsForMakerResponse)
    
    func presentVibes(response : MakerUseCases.LoadVibeAndLocation.VibesResponse)
    func presentVibesFetchFailure(_ error: ApiError)
    
    func presentLocations(response : MakerUseCases.LoadVibeAndLocation.LocationsResponse)
    func presentLocationsFetchFailure(_ error: ApiError)
    
    func presentImageFetchFailure(error: ApiError)
    func presentImageURLs(response: MakerUseCases.RequestMakerImage.ImageURLResponse)
    func presentProductPostFailure(error: ApiError)
    func presentProductPostSuccess(response: MakerUseCases.RequestMakerProduct.productResponse)
    
    func presentFetchMakerReservationsSuccess(response: MakerUseCases.LoadReservation.Response)
    func presentFetchMakerReservationsFailure(error: ApiError)
    
}

final class MyPagePresenter {
    typealias Response = MyPageUseCase.LoadMyPage.Response
    typealias ViewModel = MyPageUseCase.LoadMyPage.ViewModel
    var view: MyPageDisplayLogic?
}

extension MyPagePresenter: MyPagePresentationLogic {

    
   
    // 사용자 탈퇴후 로그인뷰 보이게
    func presentCancelMembershipSuccess() {
        let viewModel = MyPageUseCase.LoadMyPage.ViewModel(logOut: true)
        view?.display(viewModel: viewModel)
    }
    
    func presentCancelMembershipFailure(error: ApiError) {
        print("Error 사용자 탈퇴 실패: \(error)")
    }
    
    
    // MARK: - 사용자 조회 관련
    
    func presentFetchUserDetailsSuccess(response: LoadUserUseCase.Response) {
        let viewModel = LoadUserUseCase.ViewModel(userDetails: response.userDetails)
        // View에 전달
        view?.displayUserDetails(viewModel: viewModel)

    }
    
    func presentFetchUserDetailsFailure(error: ApiError) {
        print("Error 사용자 데이터 조회 실패: \(error)")
    }
    
    
    // 카운트 관련
    func presentFetchCountsSuccess(response: LoadUserUseCase.CountResponse) {
        // CombineResponse의 데이터를 뷰에 전달
        let viewModel = LoadUserUseCase.CountViewModel(userCount: response.userCount)
        view?.displayCounts(viewModel: viewModel)
    }
    
    func presentFetchCountsFailure(error: ApiError) {
        // 에러를 뷰에 전달
        print("Error 사용자 좋아요, 찜 카운트 조회 실패: \(error)")
    }

    func presentLogoutSuccess() {
        
        print("로그아웃 성공")
        let viewModel = MyPageUseCase.LoadMyPage.ViewModel(logOut: true)
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

    func presentFetchUserReservationsSuccess(response: MainPromotionUseCase.CheckReservationProducts.Response) {
      
        let viewModel = MainPromotionUseCase.CheckReservationProducts.ViewModel(reservationSuccess: response.reservationSuccess, reservationProducts: response.reservationProducts)
        // View에 전달
        view?.displayFetchUserReservation(viewModel: viewModel)
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
    
    
    
    // MARK: - 유저 찜 내역 조회
    func presentFetchUserLikesFailure(error: ApiError) {
        print("Error occurred: \(error)")
    }

    func presentFetchUserLikesSuccess(response: MainPromotionUseCase.Like.LikeListResponse) {
      
        let viewModel = MainPromotionUseCase.Like.LikeListViewModel(likeProducts: response.likeProducts)
        // View에 전달
        view?.displayFetchUserLikeProduct(viewModel: viewModel)
    }
    
    
    func presentFetchPostDetailByIdSuccess(response: MainPromotionUseCase.LoadDetailProduct.Response) {
        let viewModel = MainPromotionUseCase.LoadDetailProduct.ViewModel(productDetail: response.productDetail)
        // View에 전달
        view?.displayDetail(viewModel: viewModel)
    }
    
    func presentFetchPostDetailByIdFailure(error: ApiError) {
        print("Error occurred: \(error)")
    }
    
    
    
    func presentFetchProductsForMakerSuccess(response: MainPromotionUseCase.LoadDetailProduct.ProductsForMakerResponse) {
        let viewModel = MainPromotionUseCase.LoadDetailProduct.ProductsForMakerViewModel(products: response.products)
        view?.displayDetailProductsForMaker(viewModel: viewModel)
    }
    
    func presentFetchProductsForMakerFailure(error: ApiError) {
        print("작가 등록한 상품 Error occurred: \(error)")
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
    
    
    
    // MARK: - 메이커 관련
    func presentFetchMakerProductsFailure(error: ApiError) {
        print("Error 메이커 상품 리스트 조회: \(error)")
    }
    
    func presentFetchMakerProductsSuccess(response: MakerUseCases.LoadProducts.ProductsForMakerResponse) {
        let viewModel = MakerUseCases.LoadProducts.ProductsForMakerViewModel(products: response.products)
        // View에 전달
        view?.displayFetchMakerProducts(viewModel: viewModel)
    }
    
    // 분위기 정보를 View에 전달
    func presentVibes(response : MakerUseCases.LoadVibeAndLocation.VibesResponse) {
        let viewModel = MakerUseCases.LoadVibeAndLocation.VibesViewModel(vibes: response.vibes)
        view?.displayVibes(viewModel: viewModel)
    }
    
    // 분위기 정보를 가져오는 데 실패했을 때 View에 에러를 전달
    func presentVibesFetchFailure(_ error: ApiError) {
        print("Error fetching vibes: \(error)")  // 실제 앱에서는 UI에 에러를 표시해야 함
    }

    
    func presentLocations(response : MakerUseCases.LoadVibeAndLocation.LocationsResponse) {
        let viewModel = MakerUseCases.LoadVibeAndLocation.LocationsViewModel(locations: response.locations)
        view?.displayLocations(viewModel: viewModel)
    }
    
    func presentLocationsFetchFailure(_ error: ApiError) {
        print("Error fetching Locations: \(error)")  // 실제 앱에서는 UI에 에러를 표시해야 함
    }
    
 
    func presentImageFetchFailure(error: ApiError) {
        print("Error 이미지 업로드 실패 : \(error)")
    }
    
    func presentImageURLs(response: MakerUseCases.RequestMakerImage.ImageURLResponse) {
        print("이미지 업로드 성공")
        let viewModel = MakerUseCases.RequestMakerImage.ImageURLViewModel(Images: response.Images)
        view?.displayPostImages(viewModel: viewModel)
    }
    
    func presentProductPostFailure(error: ApiError) {
        print("Error 상품 업로드 실패 : \(error)")
    }
    
    func presentProductPostSuccess(response: MakerUseCases.RequestMakerProduct.productResponse) {
        print("상품 업로드 성공")
        print("response \(response.product)")
    }
    
    
    func presentFetchMakerReservationsSuccess(response: MakerUseCases.LoadReservation.Response) {
        let viewModel = MakerUseCases.LoadReservation.ViewModel(products: response.products)
        // View에 전달
        view?.displayFetchMakerReservations(viewModel: viewModel)
    }
    
    func presentFetchMakerReservationsFailure(error: ApiError) {
      
        print("Error 메이커 예약내역 조회 실패 : \(error)")
    }
  
}
