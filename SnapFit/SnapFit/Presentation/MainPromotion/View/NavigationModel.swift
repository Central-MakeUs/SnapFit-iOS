//
//  NavigationModel.swift
//  SnapFit
//
//  Created by 정정욱 on 8/11/24.
//

import SwiftUI


enum NavigationDestination: Hashable {
    case authorDetail
    case authorReservation
    case authorReservationReceptionView
}

class NavigationModel: ObservableObject {
    @Published var navigationPath: [NavigationDestination] = []

    // 네비게이션 경로에 열거형 값을 추가하는 메소드
    func append(_ value: NavigationDestination) {
        navigationPath.append(value)
    }
    
    // 네비게이션 경로에서 마지막 값을 제거하는 메소드
    func pop() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }
    
    // 네비게이션 경로를 초기화하는 메소드
    func resetNavigation() {
        navigationPath.removeAll()
    }
}
