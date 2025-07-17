//
//  ReservationRequest.swift
//  SnapFit
//
//  Created by 정정욱 on 8/16/24.
//

import Foundation

struct ReservationRequest: Codable {
    var email: String
    var phoneNumber: String
    var postId: Int
    var makerId: Int
    var minutes: Int
    var price: Int
    var person: Int
    var personPrice: Int
    var reservationLocation: String
    var reservationTime: String  // ISO 8601 형식의 시간 문자열

    // 생성자 (필요에 따라 기본값을 설정할 수 있음)
    init(email: String, phoneNumber: String, postId: Int, makerId: Int, minutes: Int, price: Int, person: Int, personPrice: Int, reservationLocation: String, reservationTime: String) {
        self.email = email
        self.phoneNumber = phoneNumber
        self.postId = postId
        self.makerId = makerId
        self.minutes = minutes
        self.price = price
        self.person = person
        self.personPrice = personPrice
        self.reservationLocation = reservationLocation
        self.reservationTime = reservationTime
    }
}
