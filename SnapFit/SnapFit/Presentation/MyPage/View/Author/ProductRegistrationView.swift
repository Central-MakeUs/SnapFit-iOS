//
//  ProductRegistrationView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/25/24.
//
import SwiftUI
import Combine

// ProductRegistrationView 수정
struct ProductRegistrationView: View {
    var mypageInteractor: MyPageBusinessLogic?
    @EnvironmentObject var myPageViewModel: MyPageViewModel
    @Binding var stack: NavigationPath
    
    @State private var inputText: String = ""
    @State private var priceText: String = ""
    @State private var additionalPriceText: String = ""
    @State private var isConfirmButtonEnabled = false
    @State private var selectedSnap: String = "indoor"
    @State private var descriptionText: String = ""
    @State private var selectedImageData: [Data?] = []   // 선택된 이미지 데이터를 저장할 배열 (Data?)
    @State private var selectedMoods: [String] = []
    @State private var selectedLocations: [String] = []
    @State private var timePriceOptions: [(selectedTime: String, selectedPrice: Int)] = []
    
    private let maxCharacterLimit = 500
    
    @State private var isUploading: Bool = false // 업로드 중인지 상태 체크
    @State private var cancellables = Set<AnyCancellable>() // Combine 구독을 관리하기 위한 cancellables
    @State private var uploadedImageURLs: [String] = [] // 업로드된 이미지 URL 저장
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                TitleSection(inputText: $inputText, isConfirmButtonEnabled: $isConfirmButtonEnabled)
                PhotosSection(selectedImageData: $selectedImageData) // 이미지 데이터를 전달
                DescriptionSection(descriptionText: $descriptionText, maxCharacterLimit: maxCharacterLimit)
                SnapSelectionSection(selectedSnap: $selectedSnap)
                MoodSection(selectedMoods: $selectedMoods)
                LocationSection(selectedLocations: $selectedLocations)
                OptionSection(timePriceOptions: $timePriceOptions)
                AdditionalCostSection(additionalPriceText: $additionalPriceText)
                
                ReserveButton(
                    selectedImageData: $selectedImageData,
                    mypageInteractor: mypageInteractor,
                    selectedMoods: selectedMoods,
                    selectedLocations: selectedLocations,
                    titleText: inputText,
                    descriptionText: descriptionText,
                    priceText: priceText,
                    additionalPriceText: additionalPriceText,
                    selectedSnap: selectedSnap,
                    timePriceOptions: timePriceOptions,
                    studio: selectedSnap == "indoor"
                )

            }
        }
        .onAppear {
            mypageInteractor?.fetchVibes()
            mypageInteractor?.fetchLocations()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    stack.removeLast()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("상품등록")
                    .font(.headline)
                    .foregroundColor(.black)
            }
        }
        .alert(isPresented: $isUploading) {
            Alert(title: Text("업로드 중..."), message: Text("상품을 등록하는 중입니다. 잠시만 기다려주세요."), dismissButton: .default(Text("확인")))
        }
    }
    
    
    private struct TitleSection: View {
        @Binding var inputText: String
        @Binding var isConfirmButtonEnabled: Bool
        
        var body: some View {
            SectionHeaderView(title: "제목")
                .padding(.bottom, 20)
            VStack(spacing: 0) {
                TextField("제목을 작성해주세요", text: $inputText)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(5)
                    .font(.callout)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .onChange(of: inputText) { newValue in
                        isConfirmButtonEnabled = newValue.count >= 18
                    }
                    .frame(height: 48)
                    .padding(.bottom, 8)
                
                HStack {
                    Spacer()
                    Text("\(inputText.count)/18")
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 16)
        }
    }
    
    private struct PhotosSection: View {
        @Binding var selectedImageData: [Data?] // 상위에서 전달받은 이미지 데이터
        
        var body: some View {
            SectionHeaderView(title: "사진")
                .padding(.bottom, 20)
            SelectPhotosView(imageData: $selectedImageData) // 이미지 데이터 바인딩
                .padding(.bottom, 24)
                .padding(.horizontal, 16)
        }
    }
    
    private struct DescriptionSection: View {
        @Binding var descriptionText: String
        let maxCharacterLimit: Int
        
        var body: some View {
            SectionHeaderView(title: "설명")
                .padding(.bottom, 20)
            VStack {
                TextEditor(text: $descriptionText)
                    .frame(height: 214)
                    .colorMultiply(Color("MainBoxbBackColor"))
                    .cornerRadius(10)
                    .onChange(of: descriptionText) { newValue in
                        if descriptionText.count > maxCharacterLimit {
                            descriptionText = String(descriptionText.prefix(maxCharacterLimit))
                        }
                    }
                    .foregroundColor(.black)
                
                HStack {
                    Spacer()
                    Text("\(descriptionText.count)/\(maxCharacterLimit)")
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 16)
        }
    }
    
    private struct SnapSelectionSection: View {
        @Binding var selectedSnap: String
        
        var body: some View {
            SectionHeaderView(title: "스튜디오 유무")
                .padding(.bottom, 16)
            HStack {
                Button(action: {
                    selectedSnap = "indoor"
                }) {
                    Text("실내스냅")
                        .font(.callout)
                        .foregroundColor(selectedSnap == "indoor" ? Color.white : Color(.gray))
                        .frame(width: 114, height: 53)
                        .background(selectedSnap == "indoor" ? Color.black : Color(.systemGray6))
                        .cornerRadius(5)
                }
                
                Button(action: {
                    selectedSnap = "outdoor"
                }) {
                    Text("야외스냅")
                        .font(.callout)
                        .foregroundColor(selectedSnap == "outdoor" ? Color.white : Color(.gray))
                        .frame(width: 114, height: 53)
                        .background(selectedSnap == "outdoor" ? Color.black : Color(.systemGray6))
                        .cornerRadius(5)
                }
            }
            .padding(.bottom, 30)
            .padding(.horizontal, 16)
        }
    }
    
    
    struct MoodSection: View {
        @State private var showMoodSelection = false
        @Binding var selectedMoods: [String]
        @EnvironmentObject var myPageViewModel: MyPageViewModel // Mood 리스트 가져오기 위해 사용
        
        var body: some View {
            SectionHeaderView(title: "분위기")
                .padding(.bottom, 16)
            
            HStack {
                Button(action: {
                    showMoodSelection = true
                }) {
                    Image("addButtonImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
                .frame(width: 114, height: 53)
                .background(Color(.systemGray6))
                .cornerRadius(5)
                
                // 선택된 분위기들 표시
                if !selectedMoods.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(selectedMoods, id: \.self) { mood in
                                Text(mood)
                                    .font(.callout)
                                    .frame(width: 114, height: 53)
                                    .foregroundColor(Color.white)
                                    .background(Color.black)
                                    .cornerRadius(5)
                            }
                        }
                    }
                }
                
            }
            .padding(.bottom, 24)
            .padding(.horizontal, 16)
            .sheet(isPresented: $showMoodSelection) {
                ReusableGridSelectionView(
                    isPresented: $showMoodSelection,
                    selectedItems: $selectedMoods,
                    title: "어느 분위기의 사진을 원하시나요?",
                    items: myPageViewModel.vibes.map { $0.name ?? "" }, // 분위기 리스트 전달
                    columnsCount: 2
                )
            }
        }
    }
    
    
    struct LocationSection: View {
        @State private var showLocationSelection = false
        @Binding var selectedLocations: [String]
        @EnvironmentObject var myPageViewModel: MyPageViewModel // Location 리스트 가져오기 위해 사용
        
        var body: some View {
            SectionHeaderView(title: "위치")
                .padding(.bottom, 16)
            
            HStack {
                Button(action: {
                    showLocationSelection = true
                }) {
                    Image("addButtonImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
                .frame(width: 114, height: 53)
                .background(Color(.systemGray6))
                .cornerRadius(5)
                
                // 현재 선택된 장소 표시
                if !selectedLocations.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(selectedLocations, id: \.self) { mood in
                                Text(mood)
                                    .font(.callout)
                                    .frame(width: 114, height: 53)
                                    .foregroundColor(Color.white)
                                    .background(Color.black)
                                    .cornerRadius(5)
                            }
                        }
                    }
                }
                
                
            }
            .padding(.bottom, 24)
            .padding(.horizontal, 16)
            .sheet(isPresented: $showLocationSelection) {
                ReusableGridSelectionView(
                    isPresented: $showLocationSelection,
                    selectedItems: $selectedLocations,
                    title: "어디에서 촬영을 원하시나요?",
                    items: myPageViewModel.locations.map { $0.adminName ?? "" }, // 위치 리스트 전달
                    columnsCount: 3
                )
            }
        }
    }
    
    
    private struct OptionSection: View {
        @Binding var timePriceOptions: [(selectedTime: String, selectedPrice: Int)]
        
        var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                SectionHeaderView(title: "옵션")
                    .padding(.bottom, 16)
                
                // 분으로 나눠서처리
                ForEach(timePriceOptions.indices, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 10) {
                        PostAccordionView(
                            selectedTime: $timePriceOptions[index].selectedTime,
                            timeOptions: [
                                PostPrice(time: "30분"),
                                PostPrice(time: "1시간"),
                                PostPrice(time: "2시간"),
                                PostPrice(time: "3시간")
                            ]
                        )
                        
                        // 가격 입력 필드
                        HStack {
                            TextField(
                                "가격 입력", // 항상 표시되는 플레이스홀더
                                value: $timePriceOptions[index].selectedPrice,
                                format: .number
                            )
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .padding(.top, 10)
                            
                            if timePriceOptions[index].selectedPrice == 0 {
                                Text("가격을 입력하세요")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                }
                
                Button(action: {
                    timePriceOptions.append((selectedTime: "", selectedPrice: 0))
                }) {
                    Text("옵션 추가")
                        .font(.headline)
                        .bold()
                        .foregroundColor(Color.white)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: 48)
                        .background(Color.black)
                        .cornerRadius(5)
                        .padding(.horizontal)
                        .padding(.bottom, 20) // 추가 여백
                }
                .buttonStyle(PlainButtonStyle())  // 기본 스타일 제거
            }
            .padding(.bottom, 20)
            .padding(.horizontal, 16)
        }
    }
    
    
    
    private struct AdditionalCostSection: View {
        @Binding var additionalPriceText: String
        
        var body: some View {
            SectionHeaderView(title: "인원 추가 비용")
                .padding(.bottom, 16)
            TextField("가격", text: $additionalPriceText)
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(Color.white)
                .cornerRadius(5)
                .font(.callout)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .frame(height: 48)
                .padding(.horizontal)
                .padding(.bottom, 24)
        }
    }
    
    private struct ReserveButton: View {
        @EnvironmentObject var myPageViewModel: MyPageViewModel
        @State private var isUploading = false
        @Binding var selectedImageData: [Data?]  // Bindings for uploaded image URLs
        var mypageInteractor: MyPageBusinessLogic?
        
        var selectedMoods: [String]
        var selectedLocations: [String]
        var titleText: String
        var descriptionText: String
        var priceText: String
        var additionalPriceText: String
        var selectedSnap: String
        var timePriceOptions: [(selectedTime: String, selectedPrice: Int)]
        var studio: Bool
        
        var body: some View {
            Button(action: {
                isUploading = true
                
           
                let validImageData = selectedImageData.compactMap { $0 }
           
                mypageInteractor?.getImages(request: MakerUseCases.RequestMakerImage.ImageURLRequest(Images: validImageData))
                
                // Convert timePriceOptions to MakerProductRequest.Price format
                /*
                let prices = timePriceOptions.map { timePriceOption in
                    MakerProductRequest.Price(
                        min: Int(timePriceOption.selectedTime.components(separatedBy: " ")[0]) ?? 0,
                        price: timePriceOption.selectedPrice
                    )
                }
                
                // Create MakerProductRequest
                let request = MakerProductRequest(
                    vibes: selectedMoods,
                    locations: selectedLocations,
                    imageNames: ["example-image-url"],  // Use a valid URL or placeholder
                    thumbnail: "example-thumbnail-url", // Use a valid URL or placeholder
                    title: titleText,
                    desc: descriptionText,
                    prices: [
                           SnapFit.MakerProductRequest.Price(min: 0, price: 30),
                           SnapFit.MakerProductRequest.Price(min: 0, price: 10000)
                       ],
                    personPrice: Int(additionalPriceText) ?? 0,
                    studio: selectedSnap == "indoor" // Check for indoor studio
                )
                
                // Post product request
                mypageInteractor?.postProduct(request: MakerUseCases.RequestMakerProduct.productRequest(product: request))
                 */
             
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
                .background(isUploading ? Color.gray : Color.black)
                .cornerRadius(5)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 20))
            }
            .disabled(isUploading)
        }
    }
    
    
}


// Preview
struct ProductRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        ProductRegistrationView(
            stack: .constant(NavigationPath())
        )
        .environmentObject(MyPageViewModel())
    }
}


//#Preview {
//    ProductRegistrationView()
//}
