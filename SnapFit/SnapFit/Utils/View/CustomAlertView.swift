//
//  CustomAlertView.swift
//  SnapFit
//
//  Created by 정정욱 on 8/12/24.
//

import SwiftUI

struct CustomAlertView: View {
    @Binding var isPresented: Bool
    let message: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("알림")
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundColor(Color(.systemGray))
                .multilineTextAlignment(.center)
            Button(action: {
                action()
            }) {
                Text("확인")
                    .bold()
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

