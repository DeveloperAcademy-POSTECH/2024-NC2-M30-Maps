//
//  CustomMapMarkerView.swift
//  Yumyum_Hyoja
//
//  Created by 박고운 on 6/20/24.
//

import Foundation
import SwiftUI

struct CustomMapMarkerView: View {
    var body: some View {
        VStack(spacing: 0) {
            Image("Hyorang")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .font(.headline)
//                .foregroundColor(.white)
                .padding(6)
//                .background(accentColor)
                .cornerRadius(36)
            
        }
    }
}
