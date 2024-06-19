//
//  TestLottie.swift
//  Yumyum_Hyoja
//
//  Created by 박고운 on 6/17/24.
//
import SwiftUI
import Lottie
import UIKit

struct LottieView: UIViewRepresentable {
    typealias UIViewType = UIView

    var filename: String
    // filename 변수는 Lottie 애니메이션 파일의 이름을 저장
    var completion: (() -> Void)?
    // completion 변수는 애니메이션이 끝났을 때 실행할 클로저를 저장
    
    class Coordinator: NSObject {
        var animationView: LottieAnimationView?
        // Coordinator 클래스는 NSObject를 상속받아 Lottie 애니메이션 뷰 관리
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
        // akeCoordinator() 메서드는 Coordinator 객체를 생성 반환
    }
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView()
        let animationView = LottieAnimationView(name: filename)
        // LottieAnimationView 객체를 생성, 파일 이름을 사용하여 애니메이션을 로드
        animationView.contentMode = .scaleAspectFit
        // contentMode를 .scaleAspectFit으로 설정하여 애니메이션이 뷰에 맞게 조정
        animationView.play { (finished) in
            if finished {
                completion?()
            }
            // play 메서드를 호출하여 애니메이션을 재생. 애니메이션이 끝나면 completion 클로저를 실행
        }
        animationView.translatesAutoresizingMaskIntoConstraints = false
        // translatesAutoresizingMaskIntoConstraints를 false로 설정하여 자동 제약 조건을 비활성화
        view.addSubview(animationView)
        // UIView에 animationView를 서브뷰로 추가
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        // 제약 조건을 설정하여 animationView의 높이와 너비가 UIView와 같도록 함
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<LottieView>) {}
    // updateUIView(_:context:) 메서드는 UIView가 업데이트될 때 호출. 현재 구현에서는 특별한 업데이트가 필요하지 않으므로 비워둠
}

//struct LottieView_Previews: PreviewProvider {
//    static var previews: some View {
//        LottieView(filename: "Animation-test", completion: {})
//    }
//}
