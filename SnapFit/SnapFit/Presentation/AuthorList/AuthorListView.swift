//
//  AuthorListView.swift
//  SnapFit
//
//  Created by 정정욱 on 8/15/24.
//  
//
import SwiftUI

protocol AuthorListDisplayLogic {
    func display(viewModel: AuthorList.LoadAuthorList.ViewModel)
}

extension AuthorListView: AuthorListDisplayLogic {
    func display(viewModel: AuthorList.LoadAuthorList.ViewModel) {}
    func fetch() {}
}

struct AuthorListView: View {
    var interactor: AuthorListBusinessLogic?
    
    @ObservedObject var AuthorList = AuthorListDataStore()
    
    var body: some View {
        VStack {
            Text("Hello World")
        }
        .task {
            fetch()
        }
    }
}

struct AuthorListView_Previews: PreviewProvider {
    static var previews: some View {
        return AuthorListView()
    }
}
