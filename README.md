

# SnapFit iOS
스냅핏 - SnapFit은 사용자가 추구하는 분위기에 맞게 스냅 사진 작가를 매칭하고, 작가분들의 다양한 상품을 판매할 수 있는 이커머스 앱입니다. 
SnapFit는 클린 아키텍처와 VIP(VIPER) 패턴을 기반으로 설계되어 있습니다.  
아키텍처의 각 계층은 명확하게 분리되어 있으며, 의존성 주입과 SOLID 원칙을 적극적으로 적용하여 유지보수성과 확장성을 극대화하였습니다.

---

## 🏛️ 아키텍처 개요

### Clean Architecture
- **Domain, Data, Presentation, App, Utils** 등으로 계층 분리
- 각 계층은 명확한 책임을 가지며, 상위 계층이 하위 계층에 의존하지 않도록 설계

### VIP (VIPER) 패턴
- **View, Interactor, Presenter**로 구성
- 각 화면(Feature)별로 독립적인 VIP 모듈을 구성하여, 테스트 용이성과 코드 재사용성을 높임

---

## 📁 폴더 구조

```
SnapFit/
  App/              # 앱 진입점, AppDelegate, SceneDelegate, 리소스 관리
  Data/             # 네트워크, API, 데이터 소스, DTO, Repository
    Network/        # API 통신, Worker 등
    Repositories/   # API 요청/응답 모델, 공통 모델
      Request/      # API Request DTO
      Response/     # API Response DTO
      Model/        # 공통 데이터 모델 (ex. Token, Product 등)
  Domain/           # 비즈니스 로직, UseCase
    UseCases/       # 각 도메인별 UseCase (ex. LoginUseCase.swift)
  Presentation/     # UI, VIP 모듈(View, Interactor, Presenter)
    Login/          # 로그인 관련 VIP 모듈
    MainPromotion/  # 메인 프로모션 관련 VIP 모듈
    MyPage/         # 마이페이지 관련 VIP 모듈
    AuthorList/     # 작가 리스트 관련 VIP 모듈
    ...             # 기타 화면별 폴더
  Utils/            # 공통 유틸리티, 커스텀 뷰
    View/           # 공통 SwiftUI View
      Common/       # 공통 UI 컴포넌트
      Card/         # 카드형 UI
      Reservation/  # 예약 관련 UI
      Image/        # 이미지 관련 UI
      Alert/        # 알림/시트 UI
      Etc/          # 기타
  Preview Content/  # Xcode 프리뷰 리소스
```

---

## 🧩 VIP 패턴 설명

- **View**: 사용자 인터페이스, 사용자 입력을 Presenter로 전달
- **Interactor**: 비즈니스 로직, UseCase 호출, 데이터 가공
- **Presenter**: View와 Interactor 중계, ViewModel 생성 및 전달

각 화면별로 `View`, `Interactor`, `Presenter`, `Configurator` 등으로 구성되어 있습니다.

---

## 🔗 의존성 주입(Dependency Injection)

SnapFit은 **프로토콜 기반 의존성 주입**을 적극적으로 활용합니다.  
각 Interactor는 필요한 Worker(또는 UseCase 등)를 **프로토콜 타입**으로 선언하고,  
생성자(Initializer)에서 주입받아 사용합니다.

### 예시 코드

```swift
// 1. Worker 프로토콜 정의
protocol ProductWorkingLogic {
    // 예시 메서드
    func fetchProducts() -> AnyPublisher<[Product], Error>
}

// 2. 실제 구현체
final class ProductWorker: ProductWorkingLogic {
    func fetchProducts() -> AnyPublisher<[Product], Error> {
        // 네트워크 통신 구현
    }
}

// 3. Interactor에서 프로토콜 타입으로 의존성 선언 및 주입
final class AuthorListInteractor {
    var presenter: AuthorListPresentationLogic?
    private let productWorker: ProductWorkingLogic

    init(productWorker: ProductWorkingLogic) {
        self.productWorker = productWorker
    }

    // ...
}
```

### 장점
- **테스트 용이**: Mock 객체를 주입하여 단위 테스트 가능
- **유연성**: 실제 구현체 교체가 쉬움 (ex. 실서버/테스트서버, Mock 등)
- **SOLID 원칙 준수**: 구현이 아닌 추상(프로토콜)에 의존

---

## 🗂️ 각 계층 역할 (Data 계층 상세)

| 계층         | 역할 설명                                                                 |
|--------------|--------------------------------------------------------------------------|
| App/         | 앱 진입점, 라이프사이클, 글로벌 리소스 관리                               |
| Data/        | 외부 데이터 소스(API, DB 등)와의 통신, DTO, Worker                       |
| Domain/      | 비즈니스 로직, UseCase, 엔티티                                           |
| Presentation/| UI, VIP 모듈, 화면별 View/Interactor/Presenter                           |
| Utils/       | 공통 유틸리티, 커스텀 뷰, 재사용 가능한 컴포넌트                          |

---

### 📡 Data 계층 구조 및 통신 흐름

```
Data/
  Network/
    AuthWorker.swift
    MyPageWorker.swift
    ProductWorker.swift
    ApiError.swift
    ...
  Repositories/
    Request/
    Response/
    Model/
```

- **Worker**  
  - `Network/` 폴더 내에 위치  
  - 실제 API 통신(네트워크 요청/응답)을 담당  
  - 예: `AuthWorker`, `ProductWorker`, `MyPageWorker` 등  
  - 각 Worker는 API 호출, 응답 파싱, 에러 처리 등의 로우레벨 네트워크 로직을 캡슐화

- **Repository**  
  - `Repositories/` 폴더 내에 위치  
  - API 요청/응답에 사용되는 DTO(Request/Response), 공통 모델(Model) 등 포함

---

### 🔄 데이터 흐름 (SnapFit 구조)

1. **Presentation 계층**에서 사용자의 액션 발생 (ex. 버튼 클릭)
2. **Interactor**가 **Worker**를 직접 소유하고, Worker의 메서드를 호출하여 데이터 요청
3. **Worker**가 네트워크 요청을 보내고, 응답을 받아 Interactor에 전달
4. **Interactor**는 받은 데이터를 가공하거나, 필요한 경우 UseCase/Entity로 변환
5. **Interactor → Presenter → View**로 데이터가 전달되어 UI 갱신

---

### 💡 예시 코드 (SnapFit 구조)

```swift
// Presentation/Login/LoginInteractor.swift
class LoginInteractor {
    let worker = AuthWorker()
    func login(id: String, pw: String) {
        worker.requestLogin(id: id, pw: pw) { result in
            // 결과 처리 및 Presenter로 전달
        }
    }
}

// Data/Network/AuthWorker.swift
class AuthWorker {
    func requestLogin(id: String, pw: String, completion: @escaping (Result<LoginResponse, ApiError>) -> Void) {
        // 실제 네트워크 통신 코드
    }
}
```

---

### 📌 정리

- **Interactor가 Worker를 직접 소유**하고, 필요한 데이터를 Worker를 통해 가져옵니다.
- Repository 계층은 DTO 및 공통 모델 관리에 집중하며, 데이터 가공/통신은 Worker가 담당합니다.
- 이 구조는 VIP 패턴에서 흔히 사용되며, 각 계층의 책임이 명확하게 분리됩니다.


## 📝 네이밍 및 구조 규칙

- **UseCase**: 모든 비즈니스 로직 파일은 `~UseCase.swift`로 통일
- **Request/Response/Model**: API 통신용 DTO는 역할별로 폴더 분리
- **VIP 모듈**: 각 화면별로 View, Interactor, Presenter, Configurator, ViewModel 등으로 구성

---

## 🛠️ 주요 기술 스택

- Swift, SwiftUI
- Clean Architecture, VIP(VIPER) 패턴
- Kakao SDK (소셜 로그인 등)
- Combine, MVVM 일부 적용

---

## 💡 기여 및 협업

- 새로운 기능 추가 시, 반드시 계층 구조와 네이밍 규칙을 준수해 주세요.
- 공통 컴포넌트는 Utils/View 하위에 기능별로 분류해 주세요.
- 비즈니스 로직은 Domain/UseCases에, 데이터 모델은 Data/Repositories/Model에 위치시켜 주세요.

---



# SnapFit 상세 소개
<img width="1920" alt="KakaoTalk_Photo_2024-07-19-23-03-58" src="https://github.com/user-attachments/assets/d91c1c62-28a1-4b51-8116-0ba1dfa5d376">
<br>

### 나에게 딱 맞는 사진을 찾아보세요! <br>원하는 분위기의 사진을 촬영할 수 있어요 일상 속 특별한 순간들을 기록하세요.
```
SnapFit은 유저와 사진작가를 매칭하여 분위기 맞춤형 프로필/스냅 사진을 촬영할 수 있는 O2O 플랫폼입니다. 
스냅 시장은 점점 성장 중이지만 현재 스냅사진을 예약하는 과정에서 가격 불투명성과 예약 과정의 복잡함이 발생하고 있습니다. 
스냅핏은 가격 제공과 포트폴리오의 다양성, 예약 시스템, 타 작가와의 비교를 통해 스냅사진 예약을 편안하게 만들어줍니다.
```

## Marketability
![IMG_8049 2](https://github.com/user-attachments/assets/532325b7-8103-4812-9b16-19c80f7654f3)

## Brand Core Value
![IMG_8049 2](https://github.com/user-attachments/assets/9e23b16c-dd8e-45ee-b86e-467a6ca36a51)


## Details

<img width="1920" alt="썸네일 (PT보고용)" src="https://github.com/user-attachments/assets/a1e6c41e-5e7a-4fcf-9306-7e8c21b5ac37">

<img width="1920" alt="23" src="https://github.com/user-attachments/assets/d81f3797-7ea0-4b38-9ce5-6a14758fdf7f">

<img width="1920" alt="21" src="https://github.com/user-attachments/assets/bb89310d-62e4-4e93-9d07-0ba7da0060b3">


<img width="1920" alt="25" src="https://github.com/user-attachments/assets/a8002045-fe7b-4b6d-8951-f7ed3015a2c7">

<img width="1920" alt="27" src="https://github.com/user-attachments/assets/de85164e-e6ac-4024-8788-72f74dd0551a">

<img width="1920" alt="29" src="https://github.com/user-attachments/assets/2724a5af-3112-469b-b8c4-4241d9f230cd">

<img width="1920" alt="31" src="https://github.com/user-attachments/assets/b09752fd-4c02-4d23-b4ca-a60a098e51ed">

<img width="1920" alt="33" src="https://github.com/user-attachments/assets/5a4ee4f1-e3be-4115-9224-dd2bbf85f0d4">

<img width="1920" alt="35" src="https://github.com/user-attachments/assets/0824a00d-5c06-4a55-9b7c-5500fee3c0c4">

<img width="1920" alt="37" src="https://github.com/user-attachments/assets/25da0be0-68a7-431c-b538-6384b1152d0f">

<img width="1920" alt="39" src="https://github.com/user-attachments/assets/ef2d347f-2a27-43fe-b2e7-50cc0ee4ddcb">

<img width="1920" alt="41" src="https://github.com/user-attachments/assets/36a21600-9adf-4948-8ea4-a2596621ec69">

<img width="1920" alt="43" src="https://github.com/user-attachments/assets/f833bc81-d6e9-47d3-9e1d-121cfa5159dc">

<img width="1920" alt="45" src="https://github.com/user-attachments/assets/f432adef-5f73-460a-aaf1-7ac2ac149010">


## App Store and Join
  - [SnapFit : App Store](https://apps.apple.com/kr/app/snapfit/id6642695481)<br>
  - [SnapFit : Join](https://forms.gle/TCh3fswz3aRtey4o6)
