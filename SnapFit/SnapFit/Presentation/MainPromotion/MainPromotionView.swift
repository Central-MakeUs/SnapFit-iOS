//
//  MainPromotionView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/17/24.
//  
//
import SwiftUI

protocol MainPromotionDisplayLogic {
    func display(viewModel: MainPromotion.LoadMainPromotion.ViewModel)
}

extension MainPromotionView: MainPromotionDisplayLogic {
    func display(viewModel: MainPromotion.LoadMainPromotion.ViewModel) {}
    func fetch() {}
}

struct MainPromotionView: View {
    var interactor: MainPromotionBusinessLogic?
    
    @ObservedObject var MainPromotion = MainPromotionDataStore()
    
    var body: some View {
        VStack {
            Text("Hello World")
        }
        .task {
            fetch()
        }
    }
}

struct MainPromotionView_Previews: PreviewProvider {
    static var previews: some View {
        return MainPromotionView()
    }
}
