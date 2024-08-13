//
//  MyPageView.swift
//  SnapFit
//
//  Created by 정정욱 on 8/12/24.
//  
//
import SwiftUI

protocol MyPageDisplayLogic {
    func display(viewModel: MyPage.LoadMyPage.ViewModel)
}

extension MyPageView: MyPageDisplayLogic {
    func display(viewModel: MyPage.LoadMyPage.ViewModel) {}
    func fetch() {}
}

struct MyPageView: View {
    var interactor: MyPageBusinessLogic?
    
    @ObservedObject var MyPage = MyPageDataStore()
    
    var body: some View {
        VStack {
            Text("Hello World")
        }
        .task {
            fetch()
        }
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        return MyPageView()
    }
}
