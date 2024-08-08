//
//  AuthorReservationReceptionView.swift
//  SnapFit
//
//  Created by 정정욱 on 8/5/24.
//

import SwiftUI

struct AuthorReservationReceptionView: View {
    @State private var selectedTab: Int = 0
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    
                    Group {
                        Text("예약이 접수되었습니다.")
                            .font(.title)
                            .bold()
                            .padding(.top, 24)
                            .padding(.bottom, 24)
                        Text("적어주신 연락처로\n작가가 연락드릴 예정입니다.")
                            .font(.callout)
                            .foregroundColor(Color(.systemGray))
                            .padding(.bottom, 48)
                    }
                    .padding(.horizontal)
                    
                  
                    CustomDividerView()
                    
                    ProductSection()
                        .padding(.bottom, 40)
                    
                    VStack(alignment: .leading, spacing: 24) {
                        Group {
                            InfoRow(label: "옵션", value: "30분 스냅")
                            InfoRow(label: "위치", value: "홍대")
                            InfoRow(label: "예약일시", value: "24.02.22(목) 오후 5:00")
                            InfoRow(label: "인원", value: "성인 1명")
                            InfoRow(label: "이메일", value: "snap@naver.com")
                        }
                        .padding(.horizontal)
                    }
                    .frame(width: .infinity, height: 196)
                    .padding(.bottom, 16)
                    
                    NavigationLink(destination: ReservationView().navigationBarBackButtonHidden(true)) {
                        HStack(spacing: 20) {
                            Spacer()
                            Text("예약내역 보러가기")
                                .font(.headline)
                                .bold()
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding()
                        .frame(height: 48)
                        .background(Color.black)
                        .cornerRadius(5)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    }
                }
            }
            .padding(.bottom)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
        }
    }
}

#Preview {
    AuthorReservationReceptionView()
}
