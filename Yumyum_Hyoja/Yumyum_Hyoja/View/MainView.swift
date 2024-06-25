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
                LocationMapView()
            } else {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                showMainView = true
                            }
                        }
                    }
            }
        }
    }
}
