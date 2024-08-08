//
//  AppInfoContent.swift
//  SnapFit
//
//  Created by 정정욱 on 7/21/24.
//

import SwiftUI

struct AppInfoContent: View {
    
    // property
    var name: String

    var linkLabel: String? = nil
    var linkDestination: String? = nil
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                // Conditional NavigationLink
                if name == "상품관리" {
                    NavigationLink(destination: ProductManagementView().navigationBarBackButtonHidden(true)) {
                        Text(name)
                            .foregroundColor(.black)
                            .font(.system(size: 14))
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                } else if name == "예약관리" {
                    NavigationLink(destination: ReservationManagementView().navigationBarBackButtonHidden(true)) {
                        Text(name)
                            .foregroundColor(.black)
                            .font(.system(size: 14))
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                } else if name == "로그아웃" {
                    Text(name)
                        .foregroundColor(Color(.systemGray))
                        .font(.system(size: 14))
                    Spacer()
                    Image(systemName: "chevron.right")
                } else if name == "탈퇴하기" {
                    Text(name)
                        .foregroundColor(Color(.systemGray))
                        .font(.system(size: 14))
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                
                else {
                    Text(name)
                        .foregroundColor(.black)
                        .font(.system(size: 14))
                    Spacer()
                    Image(systemName: "chevron.right")
                }

                // Link condition
                if let linkLabel = linkLabel, let linkDestination = linkDestination {
                    Link(destination: URL(string: "https://\(linkDestination)")!) {
                        Spacer()
                        Text(linkLabel)
                            .fontWeight(.bold)
                            .foregroundColor(.accentColor)
                    }
                    Image(systemName: "arrow.up.right.square").foregroundColor(.accentColor)
                } else {
                    EmptyView()
                }
            } //: HSTACK
                
            Spacer()
            
            Divider()
        } //: VSTACK
        .frame(height: 68)
    }
}


struct AppInfoLabel: View {
    
    // property
    let labelText: String
    
    var body: some View {
        HStack(alignment: .lastTextBaseline){
            Rectangle()
                .frame(width: 16, height: 2)
            Text(labelText)
                .font(.system(size: 16))
                .fontWeight(.bold)
        }
    }
    
}

#Preview {
    Group {
        AppInfoContent(name: "Sample2")
        AppInfoContent(name: "Sample2")
        AppInfoContent(name: "로그아웃")
        AppInfoContent(name: "탈퇴하기")
    }
}
