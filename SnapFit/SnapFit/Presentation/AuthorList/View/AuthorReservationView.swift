//
//  AuthorReservationView.swift
//  SnapFit
//
//  Created by 정정욱 on 8/3/24.
//

import SwiftUI

struct AuthorReservationView: View {
    @State private var selectedTab: Int = 0
    
    @State var locationText: String = ""
    @State var dateText: String = ""
    @State var emailText: String = ""
    @State var phoneText: String = ""
    
    @State private var counter: Int = 0
    
    @EnvironmentObject var navigationModel: NavigationModel // EnvironmentObject로 NavigationModel을 사용
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    ProductSection()
                    OptionSection()
                    LocationSection(locationText: $locationText)
                    DateTimeSection(dateText: $dateText)
                    PeopleSection(counter: $counter)
                    EmailSection(emailText: $emailText)
                    PhoneSection(phoneText: $phoneText)
                    SubmitButton()
                }
            }
            .padding(.bottom)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    // 뒤로 가기 버튼을 사용하여 네비게이션 경로를 관리
                    navigationModel.navigationPath.removeLast()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("예약")
                    .font(.headline)
                    .foregroundColor(.black)
            }
        }
    }
}

struct ProductSection: View {
    var body: some View {
        VStack(alignment: .leading) {
            SectionHeaderView(title: "주문상품")
                .padding(.bottom, 16)
            ReservationCardView()
                .padding(.horizontal)
                .padding(.bottom, 32)
            CustomDividerView()
        }
    }
}

struct OptionSection: View {
    var body: some View {
        VStack(alignment: .leading) {
            SectionHeaderView(title: "옵션")
                .padding(.bottom, 27)
            AccordionView()
                .padding(.horizontal)
                .padding(.bottom, 32)
        }
    }
}


struct LocationSection: View {
    @Binding var locationText: String
    
    var body: some View {
        VStack(alignment: .leading) {
            SectionHeaderView(title: "원하시는 위치를 적어주세요", showRequired: true)
                .padding(.bottom, 27)
            TextField("메이커와 상담후 장소 변경이 가능해요", text: $locationText)
                .font(.callout)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding(.horizontal)
                .padding(.bottom, 32)
        }
    }
}

struct DateTimeSection: View {
    @Binding var dateText: String
    
    var body: some View {
        VStack(alignment: .leading) {
            SectionHeaderView(title: "원하는 날짜와 시간을 적어주세요", showRequired: true)
                .padding(.bottom, 27)
            TextField("00월 00일 00시", text: $dateText)
                .font(.callout)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding(.horizontal)
                .padding(.bottom, 32)
        }
    }
}


struct PeopleSection: View {
    @Binding var counter: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            SectionHeaderView(title: "인원을 선택해주세요")
                .padding(.bottom, 16)
            VStack(alignment:.leading) {
                Text("2인 이상 1인당 17,000원 추가")
                    .font(.callout)
                    .foregroundStyle(Color(.systemGray2))
                    .padding(.leading, 17.5)
                    .padding(.bottom, 24)
                
                HStack(spacing: 23) {
                    Spacer()
                    Text("성인")
                    Button(action: {
                        if counter > 0 {
                            counter -= 1
                        }
                    }) {
                        Image(systemName: "minus")
                            .foregroundColor(Color(.systemGray))
                            .frame(width: 24, height: 24)
                            .background(Circle().fill(Color.white))
                            .overlay(
                                Circle()
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Text("\(counter)")
                        .padding(.horizontal, 20)
                    
                    Button(action: {
                        counter += 1
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                            .background(Circle().fill(Color.black))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.trailing, 17.5)
                }
            }
            .padding(.bottom, 32)
        }
    }
}

struct PhoneSection: View {
    @Binding var phoneText: String
    
    var body: some View {
        VStack(alignment: .leading) {
            SectionHeaderView(title: "연락 받을 전화번호를 적어주세요", showRequired: true)
                .padding(.bottom, 24)
            TextField("010 - **** - ****", text: $phoneText)
                .font(.callout)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding(.horizontal)
                .padding(.bottom, 32)
        }
    }
}

struct SubmitButton: View {
    
    @EnvironmentObject var navigationModel: NavigationModel // EnvironmentObject로 NavigationModel을 사용
    
    var body: some View {
        
        Button(action: {
            navigationModel.navigationPath.append("AuthorReservationReceptionView")
        }) {
            HStack(spacing: 20) {
                Spacer()
                Text("예약하기")
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
            .frame(height: 48)
            .background(Color.black)
            .cornerRadius(5)
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 32, trailing: 16))
        }

    }
}

struct EmailSection: View {
    @Binding var emailText: String
    
    var body: some View {
        VStack(alignment: .leading) {
            SectionHeaderView(title: "연락 받을 이메일을 적어주세요", showRequired: true)
                .padding(.bottom, 24)
            TextField("이메일 주소", text: $emailText)
                .font(.callout)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding(.horizontal)
                .padding(.bottom, 32)
        }
    }
}

#Preview {
    AuthorReservationView()
}
