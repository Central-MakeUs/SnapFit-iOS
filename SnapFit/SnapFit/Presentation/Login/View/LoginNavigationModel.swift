//
//  LoginNavigationModel.swift
//  SnapFit
//
//  Created by 정정욱 on 8/13/24.
//


import SwiftUI

class LoginNavigationModel: ObservableObject {
    @Published var navigationPath = NavigationPath()
    
    func append(_ value: String) {
        navigationPath.append(value)
    }
    
    func pop() {
        navigationPath.removeLast()
    }
    
    func resetNavigation() {
        navigationPath.removeLast(navigationPath.count)
    }
}
