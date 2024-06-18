//
//  TestLottie.swift
//  Yumyum_Hyoja
//
//  Created by 박고운 on 6/17/24.
//
import Foundation
import SwiftUI
import Lottie
import UIKit

// 로티 애니메이션 뷰
struct LottieView: UIViewRepresentable {
    
//    var name : String
//    var loopMode: LottieLoopMode
//    
//    // 간단하게 View로 JSON 파일 이름으로 애니메이션을 실행합니다.
//    init(jsonName: String = "", loopMode : LottieLoopMode = .loop){
//        self.name = jsonName
//        self.loopMode = loopMode
//    }
    
    typealias UIViewType = UIView

    var filename: String
    //var loopMode: LottieLoopMode = .loop
    class Coordinator: NSObject {
        var animationView: LottieAnimationView?
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView()
        
        let animationView = LottieAnimationView(name: filename)
        // AspectFit으로 적절한 크기의 에니매이션을 불러옵니다.
        animationView.contentMode = .scaleAspectFit
        // 애니메이션은 기본으로 Loop합니다.
//        animationView.loopMode = loopMode
                // 애니메이션을 재생합니다
        animationView.play()
        // 백그라운드에서 재생이 멈추는 오류를 잡습니다
        
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        //레이아웃의 높이와 넓이의 제약
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<LottieView>) {
    }
}
