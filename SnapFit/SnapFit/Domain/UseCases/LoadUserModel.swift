//
//  LoadUserModel.swift
//  SnapFit
//
//  Created by 정정욱 on 8/19/24.
//

import Foundation

enum LoadUserDetails {
      struct Request {
          // 요청에 필요한 정보가 있다면 여기에 정의
      }

      struct Response {
          let userDetails: UserDetailsResponse
      }

      struct ViewModel {
          let userDetails: UserDetailsResponse
      }
}
