import SwiftUI
import _PhotosUI_SwiftUI

struct MyProfileEdit: View {
    @Environment(\.presentationMode) var presentationMode // Environment variable to dismiss the view
    @ObservedObject var viewModel: MyPageViewModel
    @State private var inputText: String = ""
    @State private var isConfirmButtonEnabled = false

    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Spacer(minLength: 40)
                    ProfileImagePicker(viewModel: viewModel)
                    Spacer(minLength: 20)
                    NicknameSection(inputText: $inputText, isConfirmButtonEnabled: $isConfirmButtonEnabled)
                    Spacer(minLength: 20)
                    MoodSection()
                    Spacer(minLength: 180)
                }
            }
            SaveButton()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
                .hidden()
            }
            ToolbarItem(placement: .principal) {
                Text("프로필 수정")
                    .font(.headline)
                    .foregroundColor(.black)
            }
        }
    }
}

// 프로필 이미지 선택 섹션
struct ProfileImagePicker: View {
    @ObservedObject var viewModel: MyPageViewModel
    
    var body: some View {
        PhotosPicker(selection: $viewModel.selectedItem) {
            if let profileImage = viewModel.profileImage {
                profileImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 86, height: 86)
                    .clipShape(Circle())
            } else {
                Image("profile")
                    .resizable()
                    .frame(width: 86, height: 86)
                    .foregroundStyle(Color(.systemGray4))
            }
        }
        .padding()
    }
}

// 닉네임 섹션
struct NicknameSection: View {
    @Binding var inputText: String
    @Binding var isConfirmButtonEnabled: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            SectionHeaderView(title: "닉네임")
                .padding(.bottom, 20)
            
            TextField("8자 이내 닉네임을 작성해주세요", text: $inputText)
                .padding(15)
                .background(Color.white)
                .frame(height: 48)
                .cornerRadius(5)
                .font(.headline)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .onChange(of: inputText) { newValue in
                    isConfirmButtonEnabled = newValue.count >= 3
                }
                .padding(.horizontal)
        }
        .padding(.bottom, 40)
    }
}

// 분위기 섹션
struct MoodSection: View {
    var body: some View {
        VStack(alignment: .leading) {
            SectionHeaderView(title: "분위기")
                .padding(.bottom, 20)
            
            MoodSelectionView()
                .padding(.horizontal)
        }
    }
}


// 저장 버튼 뷰
struct SaveButton: View {
    var body: some View {
        Button(action: {
            // 버튼 액션
        }) {
            Text("저장하기")
                .font(.headline)
                .bold()
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(Color.black)
                .cornerRadius(5)
                .padding(.horizontal)
                .padding(.bottom, 20)
        }
    }
}

#Preview {
    MyProfileEdit(viewModel: MyPageViewModel())
}
