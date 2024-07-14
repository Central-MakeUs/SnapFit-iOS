//
//  LoginInteractor.swift
//  SnapFit
//
//  Created by 정정욱 on 7/14/24.
//  
//
import Foundation

protocol LoginBusinessLogic {
    func load(request: Login.LoadLogin.Request)
}

final class LoginInteractor {
    typealias Request = Login.LoadLogin.Request
    typealias Response = Login.LoadLogin.Response
    var presenter: LoginPresentationLogic?
}

extension LoginInteractor: LoginBusinessLogic {
    func load(request: Request) {
        // presenter?.present(response:  Response)
    }
}
