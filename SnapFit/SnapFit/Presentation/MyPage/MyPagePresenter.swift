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
    func presentKakaoLogoutSuccess()
}

final class MyPagePresenter {
    typealias Response = MyPage.LoadMyPage.Response
    typealias ViewModel = MyPage.LoadMyPage.ViewModel
    var view: MyPageDisplayLogic?
}

extension MyPagePresenter: MyPagePresentationLogic {
    func present(response: Response) {
    //    view?.display(viewModel: viewModel)
    }
    
    
    func presentKakaoLogoutSuccess() {
//        let viewModel = Login.LoadLogin.ViewModel(success: true, message: "Kakao logout successful", oauthToken: "")
//        view?.display(viewModel: viewModel)
    }
    
}
