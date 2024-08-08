//
//  ReservationManagementView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/25/24.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct ReservationManagementView: View {
    
    @Environment(\.presentationMode) var presentationMode // Environment variable to dismiss the view
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 6, alignment: nil),
    ]
    
    
    var body: some View {
        
        ScrollView {
            LazyVGrid(
                columns: columns, // 3열
                alignment: .center,
                spacing: 6){
                    ForEach(0..<2) { index in
                        NavigationLink(destination: ReservationConfirmView().navigationBarBackButtonHidden(true)) {
                            ReservationInfoCardView()
                                .frame(width: 390, height: 163)
                        }
                        Divider()
                    }
                }
        } // :1번
        .padding(.horizontal)
        
        
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("예약관리")
                    .font(.headline)
                    .foregroundColor(.black)
            }
        }
    }
    
}

#Preview {
    ReservationManagementView()
}
