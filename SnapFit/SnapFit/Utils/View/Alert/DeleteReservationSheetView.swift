//
//  ReservationSheetView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/25/24.
//

import SwiftUI



enum Reason: String {
    case contactIssue = "사진작가와 연락이 안돼요"
    case wrongSelection = "잘못 눌렀어요"
    
    var description: String {
        return self.rawValue
    }
}

struct DeleteReservationSheetView: View {
    
    // 기본값으로 사용할 변수 (뷰모델이 없을 때)
    var isPhotographer: Bool = false
    
    @Binding var selectedReason: Reason?
    @Binding var showSheet: Bool
    @Binding var showAlert: Bool
    
    

    
    // 취소 버튼 클릭 시 호출할 클로저
    var onConfirm: (String) -> Void = { _ in }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Spacer()
            
            Text("정말로 예약을 취소하실건가요?\n이유를 알려주세요")
                .font(.title3)
                .bold()
            
            // myPageViewModel이 있으면 photographer 상태를 사용, 없으면 기본값 사용
            if isPhotographer {
                
                CheckButton(title: "예약자가 입력한 시간이 불가능해요", isSelected: selectedReason == .contactIssue) {
                    selectedReason = selectedReason == .contactIssue ? nil : .contactIssue
                }
                
                CheckButton(title: "예약자가 입력한 위치에 갈 수 없어요", isSelected: selectedReason == .wrongSelection) {
                    selectedReason = selectedReason == .wrongSelection ? nil : .wrongSelection
                }
                .padding(.bottom)
            } else {
                // 일반 사용자일 때
                CheckButton(title: "사진작가와 연락이 안돼요", isSelected: selectedReason == .contactIssue) {
                    selectedReason = selectedReason == .contactIssue ? nil : .contactIssue
                }
                
                CheckButton(title: "잘못 눌렀어요", isSelected: selectedReason == .wrongSelection) {
                    selectedReason = selectedReason == .wrongSelection ? nil : .wrongSelection
                }
                .padding(.bottom)
            }
            
            Button(action: {
                showSheet = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    let reasonMessage = selectedReason?.description ?? ""
                    onConfirm(reasonMessage)
                }
            }) {
                Text("예약취소")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(Color.white)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background(selectedReason != nil ? Color.black : Color.gray)  // 선택 여부에 따라 배경색 변경
                    .cornerRadius(5)
            }
            .disabled(selectedReason == nil)
            
            Spacer()
        }
    }
}

struct CheckButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .foregroundColor(.black)
                Text(title)
                    .foregroundColor(.black)
            }
        }
    }
}




//struct ReservationConfirmSheetView : View {
//
//    @Binding var selectedReason: ReservationConfirmView.Reason?
//    @Binding var showSheet: Bool
//    @Binding var showAlert: Bool
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 20) {
//
//            Spacer()
//
//            Text("예약을 취소하려는\n이유를 알려주세요")
//                .font(.title3)
//                .bold()
//
//
//            CheckButton(title: "예약자가 입력한 시간이 불가능해요", isSelected: selectedReason == .contactIssue) {
//                if selectedReason == .contactIssue {
//                    selectedReason = nil
//                } else {
//                    selectedReason = .contactIssue
//                }
//            }
//
//
//            CheckButton(title: "예약작가 입력한 위치에 갈 수 없어요", isSelected: selectedReason == .wrongSelection) {
//                if selectedReason == .wrongSelection {
//                    selectedReason = nil
//                } else {
//                    selectedReason = .wrongSelection
//                }
//            }
//            .padding(.bottom)
//
//            Button(action: {
//                // 버튼 액션
//                showSheet = false
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                    showAlert.toggle()
//                }
//            }) {
//                Text("예약취소")
//                    .font(.subheadline)
//                    .bold()
//                    .foregroundColor(Color.white)
//                    .padding()
//                    .frame(maxWidth: .infinity, minHeight: 48)
//                    .background(Color.black)
//                    .cornerRadius(5)
//            }
//
//            Spacer()
//        }
//    }
//}
//
//




//@Binding 속성은 부모 뷰에서 전달된 바인딩 값이 있어야 합니다. 따라서,
//#Preview에서 직접 Binding을 만들 수는 없으므로, .constant를 사용하여 값을 전달해야 합니다.
//struct ReservationSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        // 'contactIssue' 값을 적절한 'Reason' 열거형 값으로 설정해야 합니다.
//        ReservationConfirmSheetView(
//            selectedReason: .constant(.contactIssue), // Binding을 Constant로 설정
//            showSheet: .constant(true),
//            showAlert: .constant(true)
//        )
//    }
//}
