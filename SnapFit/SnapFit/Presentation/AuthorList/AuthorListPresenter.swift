//
//  AuthorListPresenter.swift
//  SnapFit
//
//  Created by 정정욱 on 8/15/24.
//  
//
import Foundation

protocol AuthorListPresentationLogic {
    func present(response: AuthorList.LoadAuthorList.Response)
}

final class AuthorListPresenter {
    typealias Response = AuthorList.LoadAuthorList.Response
    typealias ViewModel = AuthorList.LoadAuthorList.ViewModel
    var view: AuthorListDisplayLogic?
}

extension AuthorListPresenter: AuthorListPresentationLogic {
    func present(response: Response) {
    //    view?.display(viewModel: viewModel)
    }
}