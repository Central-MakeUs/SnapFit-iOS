//
//  MoodsLabel.swift
//  SnapFit
//
//  Created by 정정욱 on 7/31/24.
//

import SwiftUI

struct MoodsLabel: View {
    var text: String
    var bigCardViewType: Bool = false
    
    var body: some View {
//        Text(text)
//            .font(.caption)
//            .bold()
//            .foregroundColor(Color("labelFontColor"))
//            .padding(.vertical, 5)
//            .padding(.horizontal, 15)
//            .background(bigCardViewType ? Color("labelBackColor").opacity(0.3) : Color("InOutLableBackColor"))
//            .cornerRadius(5)
        
        Text(text)
            .font(.caption)
            .foregroundColor(Color(.black))
            .padding(.vertical, 5)
            .padding(.horizontal, 15)
            .background(bigCardViewType ? Color("MainBoxbBackColor").opacity(0.3) : Color("InOutLableBackColor"))
            .cornerRadius(2)
    }
}


#Preview {
    VStack {
        MoodsLabel(text: "시크", bigCardViewType: true)
        MoodsLabel(text: "시크")
    }
    .previewLayout(.sizeThatFits)
}



// 실내스냅 표시 라벨
struct DeteailInOutLabel: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.caption)
            .bold()
            .foregroundColor(Color(.white)) // 폰트 색상
            .padding(.vertical, 6) // 세로 패딩을 줄임
            .padding(.horizontal, 10) // 가로 패딩을 줄임
            .background(Color("InOutLableFontColor")) // 배경색
            .cornerRadius(2)
    }
}


// Custom Shape for specific corners
struct RoundedCornersShape: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


// 실내스냅 표시 라벨 (카드뷰)
struct InOutLabel: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.caption)
            .bold()
            .foregroundColor(Color(.white)) // 폰트 색상
            .padding(.vertical, 6) // 세로 패딩을 줄임
            .padding(.horizontal, 10) // 가로 패딩을 줄임
            .background(Color("InOutLableFontColor")) // 배경색
            .clipShape(RoundedCornersShape(radius: 5, corners: [.topLeft, .bottomRight])) // 특정 코너에만 반경 적용
    }
}

// 취소된 상품 표시 라벨 (카드뷰)
struct CancelLabel: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.caption)
            .bold()
            .foregroundColor(Color(.white)) // 폰트 색상
            .padding(.vertical, 6) // 세로 패딩을 줄임
            .padding(.horizontal, 10) // 가로 패딩을 줄임
            .background(Color(.red)) // 배경색
            .clipShape(RoundedCornersShape(radius: 5, corners: [.topLeft, .bottomRight])) // 특정 코너에만 반경 적용
    }
}

struct StarImageLabel: View {
    var text: String
    
    var body: some View {
        
        HStack(spacing: 8) {
            Image("starLabel")
                .resizable()
                .scaledToFit()
                .frame(width: 14, height: 14)
            
            Text(text)
                .font(.caption)
                .bold()
                .foregroundColor(.white)
        }
        .padding(.vertical, 6) // 세로 패딩을 줄임
        .padding(.horizontal, 10) // 가로 패딩을 줄임
        //.background(Color("profileLabelColor"))
        .background(Color(.black))
        .cornerRadius(5)
    
    }
}


struct InOutLabel_Previews: PreviewProvider {
    static var previews: some View {
        InOutLabel(text: "야외스냅")
            .previewLayout(.sizeThatFits) // 프리뷰에서 크기 맞춤
    }
}

struct StarImageLabel_Previews: PreviewProvider {
    static var previews: some View {
        StarImageLabel(text: "서울 용산구")
            .previewLayout(.sizeThatFits) // 프리뷰에서 크기 맞춤
    }
}
