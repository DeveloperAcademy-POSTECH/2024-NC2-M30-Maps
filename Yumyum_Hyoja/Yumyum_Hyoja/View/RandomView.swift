import SwiftUI
import CoreLocation

struct RandomView: View {
    var coordinate: CLLocationCoordinate2D?
  // coordinate: 출발지 좌표
    @State private var selectedCard: (name: String, view: AnyView, location: CLLocationCoordinate2D)?
    @State private var showCard = false
    @State private var showMapView = false
    @State private var showLottieView = true
    @State private var navigateToMapView = false
    @State private var lottieFilename = "middle"
 // selectedCard: 선택된 카드의 정보를 저장하는 튜플로, 카드의 이름, 뷰, 그리고 좌표를 포함.
//showCard: 카드를 표시할지 여부를 제어하는 상태.
//showMapView: 지도를 표시할지 여부를 제어하는 상태.
//showLottieView: Lottie 애니메이션을 표시할지 여부를 제어하는 상태.
//navigateToMapView: 네비게이션 링크를 활성화할지 여부를 제어하는 상태.
//lottieFilename: 표시할 Lottie 애니메이션 파일의 이름을 나타내는 상태    
    
    var body: some View {
        ZStack {
            Color.main
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if showLottieView {
                    LottieView(filename: lottieFilename)
                        .edgesIgnoringSafeArea(.all)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showLottieView = false
                                    selectRandomCard()
                                    showCard = true
                                }
                            }
                        }
                } else {
                    if let selectedCard = selectedCard {
                        RandomCardView(destinationCoordinate: selectedCard.location)
                            .padding()
                        // showLottieView가 true일 때 Lottie 애니메이션을 표시. 애니메이션이 끝나면 카드 선택과 표시를 처리
                        // selectedCard가 존재할 때 RandomCardView를 표시
                        HStack {
                            Button(action: {
                                withAnimation {
                                    showLottieView = true
                                    lottieFilename = "middle"
                                    showCard = false
                                }
                            }) {
                                Image(systemName: "arrow.clockwise")
                                    .padding()
                                    .background(Color.gry)
                                    .foregroundColor(.black)
                                    .font(.custom("Cafe24SsurroundairOTF", size: 24))
                                    .bold()
                                    .cornerRadius(8)
                            }
                            .padding()
                            
                            Button(action: {
                                showLottieView = true
                                lottieFilename = "runhyo"
                                withAnimation {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        navigateToMapView = true
                                    }
                                }
                            }) {
                                Text("길안내 시작")
                                    .padding()
                                    .font(.custom("Cafe24SsurroundairOTF", size: 24))
                                    .background(Color.gam)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .padding()
                            .background(
                                NavigationLink(destination: MapView(destinationCoordinate: selectedCard.location), isActive: $navigateToMapView) {
                                    EmptyView()
                                }
                                .hidden()
                            )
                        }
                    }
                }
            }
            .onChange(of: showCard) { newValue in
                if newValue {
                    selectRandomCard()
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showLottieView = false
                        selectRandomCard()
                        showCard = true
                    }
                }
            }
        }
    }
    
    private func selectRandomCard() {
        let cards = [
            ("순이", CLLocationCoordinate2D(latitude: 36.0079529582591, longitude: 129.329425672387)),
            ("홍운반점", CLLocationCoordinate2D(latitude: 36.0087180836111, longitude: 129.332544437547)),
            ("덕수파스타", CLLocationCoordinate2D(latitude: 36.007853673717, longitude: 129.330398930981)),
            ("김고미김밥", CLLocationCoordinate2D(latitude: 36.0080964116588, longitude: 129.330458752437))
        ]
        if let card = cards.randomElement() {
            selectedCard = (card.0, AnyView(RandomCardView(destinationCoordinate: card.1)), card.1)
        }
    }
}
// 카드 목록에서 무작위로 하나를 선택하여 selectedCard에 저장
