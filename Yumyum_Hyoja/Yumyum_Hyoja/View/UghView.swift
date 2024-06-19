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
            LottieView(filename: "UghAnimationFileName") // 적절한 애니메이션 파일 이름으로 대체해주세요.
        }
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
