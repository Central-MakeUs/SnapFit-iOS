//
//  MyPageInteractor.swift
//  SnapFit
//
//  Created by 정정욱 on 8/12/24.
//  
//
import Foundation
import Combine

protocol MyPageBusinessLogic {
    func load(request: MyPage.LoadMyPage.Request)
    func logoutFromKakao()
    func cancelmembership()
}

final class MyPageInteractor {
    typealias Request = MyPage.LoadMyPage.Request
    typealias Response = MyPage.LoadMyPage.Response
    var presenter: MyPagePresentationLogic?
    
    private let authWorker: AuthWorkingLogic
    // 추가: `cancellables` 프로퍼티 선언
    private var cancellables = Set<AnyCancellable>()
    
    init(authWorker: AuthWorkingLogic) {
        self.authWorker = authWorker
    }
    
    
    func logoutFromKakao() {
            print("MyPageInteractor logoutFromKakao")
            authWorker.logoutFromKakao { [weak self] result in
                guard let self = self else { return } // self가 nil일 경우 종료
                
                switch result {
                case .success:
                    // 카카오 로그아웃 성공 후 SnapFit 서버 로그아웃 처리
                    self.authWorker.socialLogoutSnapfitServer()
                        .sink { completion in
                            switch completion {
                            case .finished:
                                print("SnapFit server logout completed")
                            case .failure(let apiError):
                                print("SnapFit server logout failed: \(apiError)")
                                // 서버 로그아웃 실패 시 프레젠터에 실패 전달
                                //self?.presenter?.presentLogoutFailure(error: apiError)
                            }
                        } receiveValue: { success in
                            // 서버 로그아웃 성공 시 프레젠터에 성공 전달
                            //self?.presenter?.presentKakaoLogoutSuccess()
                        }
                        .store(in: &self.cancellables)
                    
                case .failure(let error):
                    // 카카오 로그아웃 실패 시에도 SnapFit 서버 로그아웃 처리
                    self.authWorker.socialLogoutSnapfitServer()
                        .sink { completion in
                            switch completion {
                            case .finished:
                                print("SnapFit server logout completed")
                            case .failure(let apiError):
                                print("SnapFit server logout failed: \(apiError)")
                                // 서버 로그아웃 실패 시 프레젠터에 실패 전달
                                //self.presenter?.presentLogoutFailure(error: apiError)
                            }
                        } receiveValue: { success in
                            // 서버 로그아웃 성공 시 프레젠터에 카카오 로그아웃 실패 전달
                            //self.presenter?.presentKakaoLogoutFailure(error: error)
                        }
                        .store(in: &self.cancellables)
                }
            }
        }
    
    
    func cancelmembership() {
            // 사용자 계정 삭제 작업 시작
        print("MyPageInteractor cancelmembership")
            authWorker.deleteUserAccount()
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        // 계정 삭제 완료
                        print("Cancel membership 성공")
                        //self?.presenter?.presentCancelMembershipSuccess()
                    case .failure(let error):
                        // 계정 삭제 실패
                        print("Cancel membership failed: \(error)")
                        //self?.presenter?.presentCancelMembershipFailure(error: error)
                    }
                } receiveValue: { success in
                    // 성공 여부 처리 (여기서는 결과가 항상 true임을 가정)
                    if success {
                        print("User account has been successfully deleted.")
                    }
                }
                .store(in: &cancellables)
        }
    
}

extension MyPageInteractor: MyPageBusinessLogic {
    func load(request: Request) {
        // presenter?.present(response:  Response)
    }
}
