//
//  MainView.swift
//  Yumyum_Hyoja
//
//  Created by 박고운 on 6/17/24.
//

import SwiftUI

struct MainView: View {
    @State private var showMainView = false
    
    var body: some View {
        ZStack {
            if showMainView {
                // 메인 콘텐츠나 이후의 뷰들을 여기에 작성합니다.
                
            } else {
                SplashView()
                    .onAppear {
                        // 스플래시 화면이 나타날 때 애니메이션과 함께 showMainView를 true로 전환
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            // 0.5초의 지연 시간을 주고, 클로저 내에서 showMainView를 true로 설정
                            withAnimation {
                                showMainView = true
                                // showMainView가 true일 때만 해당 블록이 실행되므로, 스플래시 화면이 완전히 사라진 후에 메인 콘텐츠가 표시됩니다.
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    MainView()
}
