//
//  AuthorListInteractor.swift
//  SnapFit
//
//  Created by 정정욱 on 8/15/24.
//  
//
import Foundation

protocol AuthorListBusinessLogic {
    func load(request: AuthorList.LoadAuthorList.Request)
}

final class AuthorListInteractor {
    typealias Request = AuthorList.LoadAuthorList.Request
    typealias Response = AuthorList.LoadAuthorList.Response
    var presenter: AuthorListPresentationLogic?
}

extension AuthorListInteractor: AuthorListBusinessLogic {
    func load(request: Request) {
        // presenter?.present(response:  Response)
    }
}
