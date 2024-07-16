import SwiftUI

struct GridSelectionView: View {
    
    @State private var isConfirmButtonEnabled = false
    @State private var selectedItems: Set<Int> = []
    @State private var showAlert = false
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 6, alignment: nil),
        GridItem(.flexible(), spacing: 6, alignment: nil),
    ]
    
    let moods: [String]
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Group {
                Text("어느 분위기의\n사진 촬영을 원하시나요?")
                    .font(.title2)
                    .bold()
                    .padding(.bottom)
                    .padding(.top, 50)
                
                Text("최대 2개까지 선택이 가능합니다.")
                    .font(.subheadline)
                    .foregroundColor(Color(.systemGray))
                    .padding(.bottom)
            }
            .padding(.horizontal)
            
            ScrollView {
                LazyVGrid(
                    columns: columns,
                    alignment: .center,
                    spacing: 19) {
                        ForEach(moods.indices, id: \.self) { index in
                            Button {
                                if selectedItems.contains(index) {
                                    selectedItems.remove(index)
                                } else if selectedItems.count < 2 {
                                    selectedItems.insert(index)
                                } else {
                                    showAlert = true
                                }
                                isConfirmButtonEnabled = selectedItems.count > 0
                            } label: {
                                Text(moods[index])
                                    .foregroundColor(selectedItems.contains(index) ? Color.white : Color.black)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 60)
                                    .background(selectedItems.contains(index) ? Color.black : Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal)
            }
            Spacer()
            
            Button {
                // Action for "다음"
            } label: {
                HStack(spacing: 20) {
                    Spacer()
                    
                    Text("다음")
                        .font(.system(size: 20))
                        .bold()
                        .foregroundColor(isConfirmButtonEnabled ? Color(.white) : Color(.systemGray))
                    
                    Spacer()
                }
                .padding()
                .background(isConfirmButtonEnabled ? Color(.black) : Color(.systemGray4))
                .cornerRadius(10)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
            }
            .disabled(!isConfirmButtonEnabled)
        }
        .overlay(
            ZStack {
                if showAlert {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    
                    CustomAlertView(isPresented: $showAlert, message: "최대 2개까지 \n선택이 가능합니다.") {
                        showAlert = false
                    }
                    .frame(width: 300)
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                    // 해당 View를 화면의 정중앙에 위치
                }
            }
        )
    }
}

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

struct GridSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        GridSelectionView(moods: ["분위기 1", "분위기 2", "분위기 3", "분위기 4", "분위기 5", "분위기 6", "분위기 7", "분위기 8", "분위기 9", "분위기 10", "분위기 11", "분위기 12", "분위기 13", "분위기 14", "분위기 15", "분위기 16", "분위기 17", "분위기 18", "분위기 19", "분위기 20"])
    }
}
