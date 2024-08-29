//
//  ProductRegistrationView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/25/24.
//
import SwiftUI
import Combine


struct ProductRegistrationView: View {
    var mypageInteractor: MyPageBusinessLogic?
    @ObservedObject var myPageViewModel: MyPageViewModel
    @Binding var stack: NavigationPath
    
    @State private var inputText: String = ""
    @State private var priceText: String = ""
    @State private var additionalPriceText: String = ""
    @State private var isConfirmButtonEnabled = false
    @State private var selectedSnap: String = "indoor"
    @State private var descriptionText: String = ""
    @State private var selectedImageData: [Data?] = []
    @State private var selectedMoods: [String] = []
    @State private var selectedLocations: [String] = []
    @State private var timePriceOptions: [(selectedTime: PostPrice, selectedPrice: Int)] = []
    private let maxCharacterLimit = 500
    
    @State private var isUploading: Bool = false
    @State private var cancellables = Set<AnyCancellable>()
    @State private var uploadedImageURLs: [String] = []
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                TitleSection(inputText: $inputText, isConfirmButtonEnabled: $isConfirmButtonEnabled, validateForm: validateForm)
                PhotosSection(selectedImageData: $selectedImageData, validateForm: validateForm)
                DescriptionSection(descriptionText: $descriptionText, maxCharacterLimit: maxCharacterLimit, validateForm: validateForm)
                SnapSelectionSection(selectedSnap: $selectedSnap, validateForm: validateForm)
                MoodSection(selectedMoods: $selectedMoods, validateForm: validateForm, myPageViewModel: myPageViewModel)
                LocationSection(selectedLocations: $selectedLocations, validateForm: validateForm, myPageViewModel: myPageViewModel)
                OptionSection(timePriceOptions: $timePriceOptions, validateForm: validateForm)
                AdditionalCostSection(additionalPriceText: $additionalPriceText, validateForm: validateForm)
                
                ReserveButton(
                    myPageViewModel: myPageViewModel, selectedImageData: $selectedImageData,
                    mypageInteractor: mypageInteractor,
                    selectedMoods: selectedMoods,
                    selectedLocations: selectedLocations,
                    titleText: inputText,
                    descriptionText: descriptionText,
                    priceText: priceText,
                    additionalPriceText: additionalPriceText,
                    selectedSnap: selectedSnap,
                    timePriceOptions: timePriceOptions,
                    studio: selectedSnap == "indoor",
                    isUploading: $isUploading,
                    cancellables: $cancellables,
                    isConfirmButtonEnabled: $isConfirmButtonEnabled
                )
            }
        }
        .onAppear {
            mypageInteractor?.fetchVibes()
            mypageInteractor?.fetchLocations()
            validateForm() // 초기 로드 시 폼 유효성 검사
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    stack.removeLast()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
                .hidden()
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
    
    private func validateForm() {
        isConfirmButtonEnabled = !inputText.isEmpty &&
                                 inputText.count <= 18 &&
                                 !descriptionText.isEmpty &&
                                 descriptionText.count <= maxCharacterLimit &&
                                 !selectedImageData.isEmpty &&
                                 !selectedMoods.isEmpty &&
                                 !selectedLocations.isEmpty &&
                                 !timePriceOptions.isEmpty &&
                                 timePriceOptions.allSatisfy { $0.selectedPrice > 0 } &&
                                 (Int(additionalPriceText) ?? 0) >= 0
    }
    
    private struct TitleSection: View {
        @Binding var inputText: String
        @Binding var isConfirmButtonEnabled: Bool
        var validateForm: () -> Void
        
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
                    .onChange(of: inputText) { _ in
                        validateForm()
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
        @Binding var selectedImageData: [Data?]
        var validateForm: () -> Void
        
        var body: some View {
            SectionHeaderView(title: "사진")
                .padding(.bottom, 20)
            SelectPhotosView(imageData: $selectedImageData)
                .padding(.bottom, 24)
                .padding(.horizontal, 16)
                .onChange(of: selectedImageData) { _ in
                    validateForm()
                }
        }
    }
    
    private struct DescriptionSection: View {
        @Binding var descriptionText: String
        let maxCharacterLimit: Int
        var validateForm: () -> Void
        
        var body: some View {
            SectionHeaderView(title: "설명")
                .padding(.bottom, 20)
            VStack {
                TextEditor(text: $descriptionText)
                    .frame(height: 214)
                    .colorMultiply(Color("MainBoxbBackColor"))
                    .cornerRadius(10)
                    .onChange(of: descriptionText) { _ in
                        if descriptionText.count > maxCharacterLimit {
                            descriptionText = String(descriptionText.prefix(maxCharacterLimit))
                        }
                        validateForm()
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
        var validateForm: () -> Void
        
        var body: some View {
            SectionHeaderView(title: "스튜디오 유무")
                .padding(.bottom, 16)
            HStack {
                Button(action: {
                    selectedSnap = "indoor"
                    validateForm()
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
                    validateForm()
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
    
    private struct MoodSection: View {
        @State private var showMoodSelection = false
        @Binding var selectedMoods: [String]
        var validateForm: () -> Void
        
        @ObservedObject var myPageViewModel: MyPageViewModel
        
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
    
    private struct LocationSection: View {
        @State private var showLocationSelection = false
        @Binding var selectedLocations: [String]
        var validateForm: () -> Void
        
        @ObservedObject var myPageViewModel: MyPageViewModel
        
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
                
                if !selectedLocations.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(selectedLocations, id: \.self) { location in
                                Text(location)
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
                    items: myPageViewModel.locations.map { $0.adminName ?? "" },
                    columnsCount: 3
                )
            }
            .onChange(of: selectedLocations) { _ in
                validateForm()
            }
        }
    }
    
    private struct OptionSection: View {
        @Binding var timePriceOptions: [(selectedTime: PostPrice, selectedPrice: Int)]
        var validateForm: () -> Void
        
        var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                SectionHeaderView(title: "가격 옵션")
                    .padding(.bottom, 16)
                
                ForEach(timePriceOptions.indices, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 10) {
                        PostAccordionView(
                            selectedTime: $timePriceOptions[index].selectedTime,
                            timeOptions: [
                                PostPrice(minutes: 30, price: 0),
                                PostPrice(minutes: 60, price: 0),
                                PostPrice(minutes: 90, price: 0),
                                PostPrice(minutes: 120, price: 0),
                                PostPrice(minutes: 150, price: 0),
                                PostPrice(minutes: 180, price: 0)
                            ]
                        )
                        
                        HStack {
                            TextField(
                                "가격 입력",
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
                            .onChange(of: timePriceOptions[index].selectedPrice) { _ in
                                validateForm()
                            }
                            
                            if timePriceOptions[index].selectedPrice == 0 {
                                Text("가격을 입력하세요")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                
                Button(action: {
                    timePriceOptions.append((selectedTime: PostPrice(minutes: 0, price: 0), selectedPrice: 0))
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
                        .padding(.bottom, 20)
                }
                .padding(.horizontal, 16)
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.bottom, 20)
      
 
        }
    }
    
    private struct AdditionalCostSection: View {
        @Binding var additionalPriceText: String
        var validateForm: () -> Void
        
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
                .onChange(of: additionalPriceText) { _ in
                    validateForm()
                }
        }
    }
    
    private struct ReserveButton: View {
        @ObservedObject var myPageViewModel: MyPageViewModel
        @Binding var selectedImageData: [Data?]
        var mypageInteractor: MyPageBusinessLogic?
        
        var selectedMoods: [String]
        var selectedLocations: [String]
        var titleText: String
        var descriptionText: String
        var priceText: String
        var additionalPriceText: String
        var selectedSnap: String
        var timePriceOptions: [(selectedTime: PostPrice, selectedPrice: Int)]
        var studio: Bool
        
        @Binding var isUploading: Bool
        @Binding var cancellables: Set<AnyCancellable>
        @Binding var isConfirmButtonEnabled: Bool
        
        var body: some View {
            Button(action: {
                if isConfirmButtonEnabled {
                    isUploading = true
                    
                    let validImageData = selectedImageData.compactMap { $0 }
                    
                    mypageInteractor?.getImages(request: MakerUseCases.RequestMakerImage.ImageURLRequest(Images: validImageData))
                    
                    myPageViewModel.$postImages
                        .sink { imageURLs in
                            if !imageURLs.isEmpty {
                                let thumbnail = imageURLs.first ?? "example-thumbnail-url"
                                let imageNames = imageURLs
                                
                                let prices = timePriceOptions.map { timePriceOption in
                                    let minutes = timePriceOption.selectedTime.minutes
                                    let price = timePriceOption.selectedPrice
                                    return MakerProductRequest.Price(
                                        min: minutes,
                                        price: price
                                    )
                                }
                                
                                let request = MakerProductRequest(
                                    vibes: selectedMoods,
                                    locations: selectedLocations,
                                    imageNames: imageNames,
                                    thumbnail: thumbnail,
                                    title: titleText,
                                    desc: descriptionText,
                                    prices: prices,
                                    personPrice: Int(additionalPriceText) ?? 0,
                                    studio: selectedSnap == "indoor"
                                )
                                
                                mypageInteractor?.postProduct(request: MakerUseCases.RequestMakerProduct.productRequest(product: request))
                                
                                isUploading = false
                            }
                        }
                        .store(in: &cancellables)
                }
            }) {
                HStack(spacing: 20) {
                    Spacer()
                    Text("등록하기")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .frame(height: 48)
                .background(isConfirmButtonEnabled ? (isUploading ? Color.gray : Color.black) : Color.gray)
                .cornerRadius(5)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
            }
            .disabled(!isConfirmButtonEnabled || isUploading)
        }
    }
}

