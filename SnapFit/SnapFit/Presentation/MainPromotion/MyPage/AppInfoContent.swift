//
//  AppInfoContent.swift
//  SnapFit
//
//  Created by 정정욱 on 7/21/24.
//

import SwiftUI

struct AppInfoContent: View {
    
    // property
    var name: String

    var linkLabel: String? = nil
    var linkDestination: String? = nil
    
    var body: some View {
        VStack {
            Divider()
                .padding(.vertical, 5)
            
            HStack {
                Text(name)
                    .foregroundColor(.black)
                    .font(.system(size: 14))
                Spacer()
                
                Image(systemName: "chevron.right")
                // Condition
                if (linkLabel != nil && linkDestination != nil) {
                    // 2. LinkLabel, LinkDestination 이 있는 겨우
                    Link(
                        destination: URL(string: "https://\(linkDestination!)")!) {
                            // label
                            
                            Spacer()
                            
                            Text(linkLabel!)
                                .fontWeight(.bold)
                                .foregroundColor(.accentColor)
                        } //: LINK
                    Image(systemName: "arrow.up.right.square").foregroundColor(.accentColor)
                } else {
                    // 3. 아무것도 없을때
                    EmptyView()
                }
            } //: HSTACK
        } //: VSTACK
    }
}



struct AppInfoLabel: View {
    
    // property
    let labelText: String
    
    var body: some View {
        HStack {
            Text(labelText)
                .font(.system(size: 16))
                .fontWeight(.bold)
            

           
        } //: HSTACKt
    }
}


#Preview {
    Group {
        AppInfoContent(name: "Sample2")
    }
}
