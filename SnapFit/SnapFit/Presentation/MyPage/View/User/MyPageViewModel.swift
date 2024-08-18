//
//  MyPageViewModel.swift
//  SnapFit
//
//  Created by 정정욱 on 8/18/24.
//

import SwiftUI
import _PhotosUI_SwiftUI
import PhotosUI


class MyPageViewModel: NSObject, ObservableObject {
    
    // 사용자 조회 관련
    @Published var userDetails: UserDetailsResponse?
    @Published var userCounts: UserCountCombinedResponse?

    // 사용자 프로필 관련
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
    
    
    //예약 내역, 상세 정보 조회
    @Published var selectedReservationId: Int? // 어떤 예약 상품을 조회 할건지
    @Published var reservationproducts: [ReservationData] = [] // 예약 내역 확인하기
    @Published var reservationproductDetail : ReservationDetailsResponse? // 상세 조회 데이터
    
    init(reservationproductDetails: ReservationDetailsResponse? = nil) {
        self.reservationproductDetail = reservationproductDetails
    }
    
}
