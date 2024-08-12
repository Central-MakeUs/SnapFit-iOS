//
//  NavigationModel.swift
//  SnapFit
//
//  Created by 정정욱 on 8/11/24.
//

import SwiftUI

class NavigationModel: ObservableObject {
    @Published var navigationPath = NavigationPath()
    
    func resetNavigation() {
        navigationPath.removeLast(navigationPath.count)
    }
}
