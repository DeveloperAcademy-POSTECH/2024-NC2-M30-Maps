import SwiftUI
import AVFoundation

struct UghView: View {
    @State private var player: AVAudioPlayer?
    @Environment(\.presentationMode) var presentationMode // 환경 변수를 사용하여 현재 뷰를 닫기 위해 사용
    @State private var navigationBackActive = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack(alignment: .topTrailing) {
                    Image("ending")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white)
                        .onAppear {
                            print("UghView appeared")
                            playSound()
                        }
                    
                    NavigationLink(destination: LocationMapView(), isActive: $navigationBackActive) {
                        Button(action: {
                            navigationBackActive = true
                        }) {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.black)
                                .padding()
                        }
                    }
                    .padding()
                    
                    
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
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
