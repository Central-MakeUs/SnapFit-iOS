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
    @Published var navigationPath = NavigationPath()
}
