//
//  SplashView.swift
//  Yumyum_Hyoja
//
//  Created by 박고운 on 6/17/24.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
//        ZStack {
//            Color.blue
//                .edgesIgnoringSafeArea(.all)
//            
//            VStack {
//                Image(systemName: "star.fill")
//                    .font(.system(size: 100))
//                    .foregroundColor(.white)
//                Text("스플래시 화면")
//                    .font(.title)
//                    .foregroundColor(.white)
//            }
//        }
        Image("Nsplash")
            .resizable()
            .scaledToFill()
    }
    
}

#Preview {
    SplashView()
}
