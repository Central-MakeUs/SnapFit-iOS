//
//  AccordionView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/25/24.
//

import SwiftUI

struct AccordionView: View {
    @State private var isExpanded = false
    @State private var selectedTime: String = "시간을 선택해주세요"
    
    let timeOptions = ["30분", "1시간", "1시간 30분", "2시간", "2시간 30분", "3시간"]
    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(selectedTime)
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(timeOptions, id: \.self) { time in
                        VStack{
                            Button(action: {
                                withAnimation {
                                    selectedTime = time
                                    isExpanded = false
                                }
                            }) {
                                Text(time)
                                    .foregroundColor(.black)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                            }
                            Divider()
                        }
                        
                    }
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.top, 5)
            }
        }
 
    }
}

struct AccordionView_Previews: PreviewProvider {
    static var previews: some View {
        AccordionView()
    }
}

