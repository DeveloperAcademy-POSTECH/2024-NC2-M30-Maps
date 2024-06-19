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
    var completion: (() -> Void)?
    
    class Coordinator: NSObject {
        var animationView: LottieAnimationView?
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView()
        let animationView = LottieAnimationView(name: filename)
        animationView.contentMode = .scaleAspectFit
        animationView.play { (finished) in
            if finished {
                completion?()
            }
        }
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<LottieView>) {}
}

//struct LottieView_Previews: PreviewProvider {
//    static var previews: some View {
//        LottieView(filename: "Animation-test", completion: {})
//    }
//}
