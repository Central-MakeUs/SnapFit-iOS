import SwiftUI

struct GridSelectionView: View {
    
    @State private var isConfirmButtonEnabled = false
    @State private var selectedItems: Set<Int> = []
    @State private var showAlert = false
    @State private var navigateToSnapFitTabView = false // 상태 변수 추가
    
   
    let columnsCount: Int
    var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 6, alignment: nil), count: columnsCount)
        /*
         Array(repeating:count:):

         repeating: GridItem(.flexible(), spacing: 6, alignment: nil): 이 GridItem을 반복합니다.
         count: columnsCount: columnsCount 변수가 지정한 수만큼 반복합니다. 예제에서는 columnsCount가 2이므로 GridItem을 2번 반복합니다.
         */
    }
    
    let moods: [String]
    
    @Environment(\.presentationMode) var presentationMode // Environment variable to dismiss the view
    
    @ObservedObject var viewModel: LoginViewModel
    var interactor: LoginBusinessLogic?
    
    
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
                                    viewModel.moods.removeAll { $0 as! String == moods[index] }
                                } else if selectedItems.count < 2 {
                                    selectedItems.insert(index)
                                    viewModel.moods.append(moods[index])
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
            
            
            NavigationLink(destination: SplashAndTabView().navigationBarBackButtonHidden(), isActive: $navigateToSnapFitTabView) {
                EmptyView()
            }
            
            Button {
                // Action for "다음"
                /*
                 💁 API 통신 작업 들어가야함 (사용자 닉네임,선택한 분위기 데이터 및 토큰 값 전송)
                 */
                // Action for "시작하기"
            
                interactor?.registerSnapFitUser(request: Login.LoadLogin.Request(
                    social: viewModel.social,
                    nickName: viewModel.nickName,
                    isMarketing: viewModel.isMarketing,
                    oauthToken: viewModel.oauthToken,
                    moods: viewModel.moods
                ))
                
                // 상태 변수 업데이트
                navigateToSnapFitTabView = true
            } label: {
                HStack(spacing: 20) {
                    Spacer()
                    Text("시작하기")
                        .font(.callout)
                        .bold()
                        .foregroundColor(isConfirmButtonEnabled ? Color(.white) : Color(.systemGray))
                    Spacer()
                }
                .padding()
                .frame(height: 48)
                .background(isConfirmButtonEnabled ? Color(.black) : Color(.systemGray4))
                .cornerRadius(5)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 40, trailing: 20))
            }
            .disabled(!isConfirmButtonEnabled)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
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
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2.5)
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
        GridSelectionView(columnsCount: 2, moods: ["분위기 1", "분위기 2", "분위기 3", "분위기 4", "분위기 5", "분위기 6", "분위기 7", "분위기 8", "분위기 9", "분위기 10", "분위기 11", "분위기 12", "분위기 13", "분위기 14", "분위기 15", "분위기 16", "분위기 17", "분위기 18", "분위기 19", "분위기 20"], viewModel: LoginViewModel(), interactor: nil)
    }
}

