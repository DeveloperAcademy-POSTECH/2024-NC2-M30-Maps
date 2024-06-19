//
//  MainView.swift
//  Yumyum_Hyoja
//
//  Created by 박고운 on 6/17/24.
//

import SwiftUI

struct MainView: View {
    @State private var showMainView = false
    // @State는 View 내에서 상태를 관리. showMainView 값이 변경될 때마다 자동으로 View를 업데이트
    // 초기에 showMainView는 false로 설정, 메인 콘텐츠인 LocationMapView가 아직 보이지 않음
    
    var body: some View {
        ZStack {
            if showMainView {
                LocationMapView()
                
            } else {
                SplashView()
                    .onAppear {
                        // 스플래시 화면이 나타날 때 애니메이션과 함께 showMainView를 true로 전환
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                             0.5초의 지연 시간을 주고, 클로저 내에서 showMainView를 true로 설정
                            withAnimation {
                                // 뷰 계층 구조의 변경을 애니메이션화 함.
                                showMainView = true
                                // showMainView가 true일 때만 해당 블록이 실행, 자동으로 SplashView에서 LocationMapView로 전환
                            }
                        }
                    }
            }
        }
    }
}

//#Preview {
//    MainView()
//}
