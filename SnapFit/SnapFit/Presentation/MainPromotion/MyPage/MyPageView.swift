//
//  MyPageView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/21/24.
//

import SwiftUI
import PhotosUI

struct MyPageView: View {
    @StateObject var viewModel = ProfileViewModel()
    @State var stack = NavigationPath() // 초기 설정
    
    var body: some View {
        NavigationStack(path: $stack) {
            ScrollView {
                VStack(alignment: .leading){
                    ZStack {
                        Rectangle()
                            .foregroundColor(.black)
                            .frame(width: .infinity, height: 168)
                            .overlay {
                                Image("profile")
                                    .resizable()
                                    .frame(width: 86, height: 86)
                                    .foregroundStyle(Color(.systemGray4))
                                    .offset(x: -130, y: 81)
                            }
                        
                        Button(action: {
                            // 예약 내역 버튼 액션
                        }) {
                            NavigationLink(destination: MyProfileEdit(viewModel : viewModel).navigationBarBackButtonHidden(true)) {
                                
                                Image(systemName: "pencil.line")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24)
                                    .foregroundColor(.white)
                            }
                            
                        }
                        .offset(x: 160, y: -50)
                     
                    }
                   
                    
                    Group {
                        Text("한소희")
                            .font(.title3)
                            .padding(.top, 40)
                        
                        HStack(spacing: 8) {
                            Image("profileLogo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                            
                            Text("러블리")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 10) // 세로 패딩을 줄임
                        .padding(.horizontal, 10) // 가로 패딩을 줄임
                        //.background(Color("profileLabelColor"))
                        .background(Color(.black))
                        .cornerRadius(5)
                    }
                    .padding(.horizontal)
                    
                    
                }
                
                
                HStack(spacing: 0) {
                    Button(action: {
                        // 예약 내역 버튼 액션
                    }) {
                        NavigationLink(destination: ReservationView().navigationBarBackButtonHidden(true)) {
                            
                            VStack(alignment: .leading) {
                                
                                Spacer()
                                
                                Text("예약 내역")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .padding(.bottom, 5)
                                
                                Text("0")
                                    .foregroundColor(.black)
                                
                                Spacer()
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: 108)
                        .background(Color.white)
                    }
                    
                    Divider()
                        .frame(width: 1)
                        .background(Color.gray.opacity(0.3))
                    
                    Button(action: {
                        // 찜한 내역 버튼 액션
                    }) {
                        NavigationLink(destination: DibsView().navigationBarBackButtonHidden(true)) {
                            
                            VStack(alignment: .leading) {
                                
                                Spacer()
                                
                                Text("찜한 내역")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .padding(.bottom, 5)
                                
                                Text("0")
                                    .foregroundColor(.black)
                                
                                Spacer()
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: 108)
                        .background(Color.white)
                    }
                }
                .frame(height: 108)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                
                
                GroupBox {
                    // content
                    AppInfoContent(name: "사진작가로 전환")
                    AppInfoContent(name: "상품관리")
                    AppInfoContent(name: "예약관리")
                    
                    //AppInfoContent(name: "Github", linkLabel: "Go to Repository", linkDestination: "github.com/jacobkosmart/endangered-animals-kr-app")
                } label: {
                    AppInfoLabel(labelText: "메이커 관리")
                }//: GROUPBOX
                .backgroundStyle(Color.white) // 배경색을 흰색으로 변경
                
                
                GroupBox {
                    // content
                    AppInfoContent(name: "고객센터")
                    AppInfoContent(name: "이용약관")
                } label: {
                    AppInfoLabel(labelText: "SnapFit 설정")
                }//: GROUPBOX
                .backgroundStyle(Color.white) // 배경색을 흰색으로 변경
                
                
                
                
                Spacer()
                
                
            }
        }
        .accentColor(.black) // 내비게이션 링크 색상을 검정색으로 변경
        .ignoresSafeArea(.container, edges: .top)
    }
    
}

class ProfileViewModel: ObservableObject {
    
    @Published var selectedItem: PhotosPickerItem? {
        didSet { Task { try await loadImage() } }
    }
    
    @Published var profileImage: Image?
    
    // 이미지 선택후 호출됨 변환하여 사진으로 만드는 메서드
    func loadImage() async throws {
        guard let item = selectedItem else { return }
        
        guard let imageData = try await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: imageData) else { return }
        self.profileImage = Image(uiImage: uiImage)
    }
}


#Preview {
    MyPageView()
}