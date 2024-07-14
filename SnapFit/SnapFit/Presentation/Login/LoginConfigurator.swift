//
//  LoginConfigurator.swift
//  SnapFit
//
//  Created by 정정욱 on 7/14/24.
//  
//
import SwiftUI

extension LoginView {
    func configureView() -> some View {
        var view = self
        let interactor = LoginInteractor()
        let presenter = LoginPresenter()
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.view = view
        return view
    }
}
