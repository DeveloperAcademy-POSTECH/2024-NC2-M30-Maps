//
//  SplashView.swift
//  Yumyum_Hyoja
//
//  Created by 박고운 on 6/17/24.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        Image("Nsplash")
            .resizable() // 이미지가 부모 뷰의 레이아웃에 맞게 크기 조정
            .scaledToFill() // 이미지를 뷰의 크기에 맞게 확대 또는 축소
    }
    
}


