//
//  SelectPhotosView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/25/24.
//

import SwiftUI
import PhotosUI
import Photos

struct SelectPhotosView: View {
    @State var selectedItems: [PhotosPickerItem] = []
    @Binding var imageData: [Data?] // 바인딩으로 데이터를 상위로 전달
    @State var selectImage: Bool = false
    @State var showPermissionAlert: Bool = false
    @State var selectedItemsCounts: Int = 0
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    PhotosPicker(
                        selection: $selectedItems,
                        maxSelectionCount: 8,
                        matching: .images
                    ) {
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color(.white))
                                .frame(width: 70, height: 70)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.gray, lineWidth: 1)
                                ) // 테두리를 추가하여 텍스트 필드 스타일 유지
                            VStack(spacing: 0){
                                Spacer()
                                Image(systemName:"camera")
                                    .frame(width: 40, height: 30)
                                    .foregroundColor(.gray)
                                HStack(spacing: 0){
                                    Text("\(selectedItemsCounts)")
                                        .foregroundColor(.gray)
                                    Text("/8")
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                        }
                    }
                    
                    if selectImage == true {
                        HStack(spacing: 10) {
                            ForEach(imageData.indices, id: \.self) { index in
                                if let data = imageData[index], let uiimage = UIImage(data: data) {
                                    Image(uiImage: uiimage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 70, height: 70)
                                        .clipped() // 이미지를 프레임에 맞추어 잘라냄
                                        .cornerRadius(5)
                                        .padding(.leading, 10)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        .onAppear(perform: {
            selectedItems = []
        })
        .onChange(of: selectedItems) { newValue in
            DispatchQueue.main.async {
                imageData.removeAll()
                selectedItemsCounts = 0
            }
            for (index, item) in selectedItems.enumerated() {
                item.loadTransferable(type: Data.self) { result in
                    switch result {
                    case .success(let data):
                        DispatchQueue.main.async {
                            if let data = data {
                                imageData.append(data)
                                print("사진 \(index+1) 업로드 완료")
                                selectedItemsCounts += 1
                                selectImage = true
                            }
                        }
                    case .failure(let failure):
                        print("에러: \(failure)")
                    }
                }
            }
        }
    }
}

struct SelectPhotos_Previews: PreviewProvider {
    static var previews: some View {
        SelectPhotosView(imageData: .constant([]))
    }
}






//struct SelectPhotos_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectPhotosView()
//    }
//}
