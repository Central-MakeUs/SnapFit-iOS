//
//  AppInfoLabel.swift
//  SnapFit
//
//  Created by 정정욱 on 7/21/24.
//

import SwiftUI

struct AppInfoLabel: View {
    
    // property
    let labelText: String
    
    var body: some View {
        HStack {
            Text(labelText.uppercased())
                .fontWeight(.bold)
            

           
        } //: HSTACKt
    }
}

//struct ApplInfoLabel_Previews: PreviewProvider {
//    static var previews: some View {
//        AppInfoLabel(labelText: "ApplInfoHead", labelImage: "gear")
//    }
//}

