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
    
    

    
}
