//
//  UghView.swift
//  Yumyum_Hyoja
//
//  Created by 박고운 on 6/17/24.
//

import SwiftUI
import AVFoundation

struct UghView: View {
    @State private var player: AVAudioPlayer?
    
    var body: some View {
        VStack {
            Image("Ending")
                .resizable() // 이미지 크기 조정 가능하도록 resizable() 적용
                            .scaledToFill() // 이미지가 채우도록 scaledToFill() 적용
                            .edgesIgnoringSafeArea(.all) // Safe Area를 무시하고 이미지를 화면 전체에 채우도록 설정
                            .frame(maxWidth: .infinity, maxHeight: .infinity) // 최대 크기로 확장
 //                           .clipped() // 이미지가 프레임을 벗어나는 것을 클립하여 보호
//            LottieView(filename: "Animation-test") // 적절한 애니메이션 파일 이름으로 대체해주세요.
        }
        .navigationBarTitle("", displayMode: .inline) // 네비게이션 바 제목 숨기기
                    .navigationBarBackButtonHidden(true) // "< Back" 버튼 숨기기
        .onAppear {
            playSound()
        }
    }
    
    private func playSound() {
        if let url = Bundle.main.url(forResource: "ugh_sound", withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
            } catch {
                print("오디오 재생 오류: \(error.localizedDescription)")
            }
        }
    }
}

struct UghView_Previews: PreviewProvider {
    static var previews: some View {
        UghView()
    }
}
