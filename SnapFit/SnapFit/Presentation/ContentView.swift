//
//  ContentView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/9/24.
//

import SwiftUI
import _AuthenticationServices_SwiftUI

struct ContentView: View {
    
    @StateObject var loginVM = LoginViewModel()
    var body: some View {
        VStack {
            LoginView(loginviewModel: loginVM).configureView()
        }

    }
}



 
#Preview {
    ContentView()
}
