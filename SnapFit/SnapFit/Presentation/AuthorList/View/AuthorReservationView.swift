//
//  AuthorReservationView.swift
//  SnapFit
//
//  Created by 정정욱 on 8/3/24.
//
import SwiftUI

import SwiftUI

struct AuthorReservationView: View {
    @State private var selectedTab: Int = 0
    @State var locationText: String = ""
    @State var emailText: String = ""
    @State var phoneText: String = ""
    @State private var counter: Int = 1
    @State private var selectedDate: Date = Date()
    
    @State private var selectedTime: String = ""
    @State private var selectedPrice: Int = 0
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var mainPromotionViewModel: MainPromotionViewModel
    var productInteractor: ProductUseCase?
    @Binding var stack: NavigationPath
    
    private let horizontalPadding: CGFloat = 16

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        ProductSection(mainPromotionViewModel: mainPromotionViewModel)
                        OptionSection(mainPromotionViewModel: mainPromotionViewModel, selectedTime: $selectedTime, selectedPrice: $selectedPrice)
                        LocationSection(locationText: $locationText)
                        DateTimeSection(selectedDate: $selectedDate)
                        PeopleSection(counter: $counter, mainPromotionViewModel: mainPromotionViewModel)
                        EmailSection(emailText: $emailText)
                        PhoneSection(phoneText: $phoneText)
                        SubmitButton(stack: $stack, productInteractor: productInteractor, isFormComplete: isFormComplete, mainPromotionViewModel: mainPromotionViewModel)
                    }
                    .padding(.bottom, 32)
                    .frame(maxWidth: .infinity) // 화면 폭에 맞게 조정
                }
                .padding(.horizontal, horizontalPadding) // ScrollView의 좌우 여백
            }
            .frame(width: geometry.size.width) // 전체 프레임 폭 설정
            .contentShape(Rectangle())
            .onTapGesture {
                hideKeyboard()
            }
        }
        .onChange(of: locationText) { _ in updateReservationRequest() }
        .onChange(of: selectedDate) { _ in updateReservationRequest() }
        .onChange(of: emailText) { _ in updateReservationRequest() }
        .onChange(of: phoneText) { _ in updateReservationRequest() }
        .onChange(of: counter) { _ in updateReservationRequest() }
        .onChange(of: selectedTime) { _ in updateReservationRequest() }
        .onChange(of: selectedPrice) { _ in updateReservationRequest() }
        .onChange(of: mainPromotionViewModel.reservationSuccess ?? false) { success in
            if success {
                stack.append("AuthorReservationReceptionView")
                mainPromotionViewModel.resetReservationSuccess() // 예약 성공 후 값 리셋
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
                .hidden()
                
            }
            ToolbarItem(placement: .principal) {
                Text("예약")
                    .font(.headline)
                    .foregroundColor(.black)
            }
        }
    }
    
    private func updateReservationRequest() {
        guard let productDetail = mainPromotionViewModel.productDetail,
              let makerId = productDetail.maker?.id,
              let personPrice = mainPromotionViewModel.productDetail?.personPrice else {
            print("상품 세부 정보가 없습니다")
            return
        }
        
        let totalPrice = selectedPrice
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let formattedDate = dateFormatter.string(from: selectedDate)
        
        mainPromotionViewModel.reservationRequest = ReservationRequest(
            email: emailText,
            phoneNumber: phoneText,
            postId: productDetail.id,
            makerId: makerId,
            minutes: selectedTimeInMinutes(),
            price: totalPrice,
            person: counter,
            personPrice: personPrice,
            reservationLocation: locationText,
            reservationTime: formattedDate
        )
    }

    private func selectedTimeInMinutes() -> Int {
        guard let selectedMinutes = Int(selectedTime.replacingOccurrences(of: "분", with: "")) else {
            return 0
        }
        return selectedMinutes
    }
    
    private var isFormComplete: Bool {
        let isDateValid = selectedDate > Date()
        let isEmailValid = isValidEmail(emailText)
        let isPhoneValid = isValidPhone(phoneText)
        let isLocationValid = !locationText.isEmpty
        let isCounterValid = counter > 0
        let formComplete = isLocationValid && isDateValid && isEmailValid && isPhoneValid && isCounterValid
        return formComplete
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

    private func isValidPhone(_ phone: String) -> Bool {
        let phoneDigits = phone.filter { $0.isNumber } // 숫자만 필터링
        return phoneDigits.count == 11 // 숫자가 11자리인지 확인
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct ProductSection: View {
    @ObservedObject var mainPromotionViewModel: MainPromotionViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            SectionHeaderView(title: "주문상품")
                .padding(.bottom, 16)
            
            if let productDetail = mainPromotionViewModel.productDetail {
                ReservationCardView(productDetail: productDetail)
                    .padding(.horizontal)
                    .padding(.bottom, 32)
            } else {
                Text("상품 정보를 불러올 수 없습니다.")
                    .font(.callout)
                    .foregroundColor(Color(.systemGray2))
                    .padding(.horizontal)
                    .padding(.bottom, 32)
            }
            
            CustomDividerView()
        }
    }
}

struct OptionSection: View {
    @ObservedObject var mainPromotionViewModel: MainPromotionViewModel
    @Binding var selectedTime: String
    @Binding var selectedPrice: Int

    var body: some View {
        VStack(alignment: .leading) {
            SectionHeaderView(title: "옵션")
                .padding(.bottom, 27)

            if let prices = mainPromotionViewModel.productDetail?.prices {
                AccordionView(selectedTime: $selectedTime, selectedPrice: $selectedPrice, timeOptions: prices)
                    .padding(.horizontal)
                    .padding(.bottom, 32)
            } else {
                Text("가격 정보가 없습니다.")
                    .font(.callout)
                    .foregroundColor(Color(.systemGray2))
                    .padding(.horizontal)
                    .padding(.bottom, 32)
            }
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
    @Binding var selectedDate: Date
    @State private var showingDatePicker = false // DatePicker 표시 여부
    
    var body: some View {
        VStack(alignment: .leading) {
            SectionHeaderView(title: "원하는 날짜와 시간을 선택해주세요", showRequired: true)
                .padding(.bottom, 27)
            
            Button(action: {
                showingDatePicker.toggle() // 버튼 클릭 시 시트 표시
            }) {
                HStack {
                    Text("날짜와 시간 선택")
                        .font(.callout)
                        .foregroundColor(.black) // 텍스트 색상을 검정색으로 변경
                    Spacer()
                    Text(dateFormatter.string(from: selectedDate))
                        .font(.callout)
                        .foregroundColor(.black) // 텍스트 색상을 검정색으로 변경
                }
                .padding()
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                )
            }
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
        .sheet(isPresented: $showingDatePicker) {
            DatePickerView(selectedDate: $selectedDate, isPresented: $showingDatePicker)
                .environment(\.locale, Locale(identifier: "ko_KR")) // 한국어 로케일 설정
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ko_KR") // 한국어 로케일 설정
        return formatter
    }
}

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            Text("날짜와 시간을 선택하세요")
                .font(.headline)
                .padding()
                .foregroundColor(.black) // 텍스트 색상을 검정색으로 변경
            
            DatePicker(
                "날짜와 시간 선택",
                selection: $selectedDate,
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(GraphicalDatePickerStyle()) // 달력 스타일 사용
            .labelsHidden()
            .padding()
            
            Button("확인") {
                isPresented = false
            }
            .padding()
            .foregroundColor(.black) // 버튼 텍스트 색상을 검정색으로 변경
        }
        .presentationDetents([.medium, .large]) // 시트 높이 설정
    }
}

struct PeopleSection: View {
    @Binding var counter: Int
    @ObservedObject var mainPromotionViewModel: MainPromotionViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            SectionHeaderView(title: "인원을 선택해주세요")
                .padding(.bottom, 16)
            VStack(alignment:.leading) {
                Text("2인 이상 1인당 \(mainPromotionViewModel.productDetail?.personPrice ?? 0)원 추가") // 여기에서 personPrice를 사용합니다.
                    .font(.callout)
                    .foregroundColor(Color(.systemGray2))
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
            TextField("010********", text: $phoneText)
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
    @Binding var stack: NavigationPath
    var productInteractor: ProductUseCase?
    let isFormComplete: Bool
    @ObservedObject var mainPromotionViewModel: MainPromotionViewModel

    @State private var isSubmitting = false
    
    var body: some View {
        Button(action: submitAction) {
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
            .background(isFormComplete ? Color.black : Color.gray)
            .cornerRadius(5)
            .padding(.horizontal, 16) // 버튼의 좌우 여백
            .padding(.bottom, 32)
        }
        .disabled(!isFormComplete || isSubmitting) // 버튼 비활성화
    }
    
    private func submitAction() {
        guard isFormComplete, !isSubmitting else { return }
        isSubmitting = true
        
        // 예약 요청을 서버에 보내기
        if let reservationRequest = mainPromotionViewModel.reservationRequest {
            productInteractor?.makeReservation(request: MainPromotionUseCase.ReservationProduct.Request(reservationRequest: reservationRequest))
            isSubmitting = false // 요청 후 상태를 리셋
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

