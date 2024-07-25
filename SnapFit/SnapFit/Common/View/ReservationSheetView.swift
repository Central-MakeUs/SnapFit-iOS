//
//  ReservationSheetView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/25/24.
//

import SwiftUI

struct ReservationSheetView : View {
    
    @Binding var selectedReason: ReservationInfoView.Reason?
    @Binding var showSheet: Bool
    @Binding var showAlert: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Spacer()
            
            Text("정말로 예약을 취소하실건가요?\n이유를 알려주세요")
                .font(.title3)
                .bold()
                
            
            CheckButton(title: "사진작가와 연락이 안돼요", isSelected: selectedReason == .contactIssue) {
                if selectedReason == .contactIssue {
                    selectedReason = nil
                } else {
                    selectedReason = .contactIssue
                }
            }
        
            
            CheckButton(title: "잘못 눌렀어요", isSelected: selectedReason == .wrongSelection) {
                if selectedReason == .wrongSelection {
                    selectedReason = nil
                } else {
                    selectedReason = .wrongSelection
                }
            }
            .padding(.bottom)
            
            Button(action: {
                // 버튼 액션
                showSheet = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    showAlert.toggle()
                }
            }) {
                Text("예약취소")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(Color.white)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 65)
                    .background(Color.black)
                    .cornerRadius(5)
            }
            
            Spacer()
        }
    }
}


struct ReservationConfirmSheetView : View {
    
    @Binding var selectedReason: ReservationConfirmView.Reason?
    @Binding var showSheet: Bool
    @Binding var showAlert: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Spacer()
            
            Text("예약을 취소하려는\n이유를 알려주세요")
                .font(.title3)
                .bold()
                
            
            CheckButton(title: "예약자가 입력한 시간이 불가능해요", isSelected: selectedReason == .contactIssue) {
                if selectedReason == .contactIssue {
                    selectedReason = nil
                } else {
                    selectedReason = .contactIssue
                }
            }
        
            
            CheckButton(title: "예약작가 입력한 위치에 갈 수 없어요", isSelected: selectedReason == .wrongSelection) {
                if selectedReason == .wrongSelection {
                    selectedReason = nil
                } else {
                    selectedReason = .wrongSelection
                }
            }
            .padding(.bottom)
            
            Button(action: {
                // 버튼 액션
                showSheet = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    showAlert.toggle()
                }
            }) {
                Text("예약취소")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(Color.white)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 65)
                    .background(Color.black)
                    .cornerRadius(5)
            }
            
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



//@Binding 속성은 부모 뷰에서 전달된 바인딩 값이 있어야 합니다. 따라서, 
//#Preview에서 직접 Binding을 만들 수는 없으므로, .constant를 사용하여 값을 전달해야 합니다.
struct ReservationSheetView_Previews: PreviewProvider {
    static var previews: some View {
        // 'contactIssue' 값을 적절한 'Reason' 열거형 값으로 설정해야 합니다.
        ReservationConfirmSheetView(
            selectedReason: .constant(.contactIssue), // Binding을 Constant로 설정
            showSheet: .constant(true),
            showAlert: .constant(true)
        )
    }
}
