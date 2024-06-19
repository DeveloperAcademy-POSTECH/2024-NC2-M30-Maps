//
//  RandomView.swift
//  Yumyum_Hyoja
//
//  Created by 박고운 on 6/17/24.
//

import SwiftUI
import CoreLocation

struct RandomView: View {
    var coordinate: CLLocationCoordinate2D?
    // coordinate 변수는 선택된 좌표를 저장
    @State private var selectedCard: (name: String, view: AnyView, location: CLLocationCoordinate2D)?
    // selectedCard: 선택된 카드의 이름, 뷰, 위치를 저장
    @State private var showCard = false
    // showCard: 카드 표시 여부
    @State private var showMapView = false
    // showMapView: 지도 뷰 표시 여부
    @State private var showLottieView = true
    // showLottieView: Lottie 애니메이션 표시 여부, 초기 로딩 시에도 LottieView를 표시
    @State private var navigateToMapView = false
    // navigateToMapView: 지도 뷰로의 네비게이션 여부

    var body: some View {
        ZStack {
            Color.main // 메인 색상을 전체 화면 배경색으로 설정
                .edgesIgnoringSafeArea(.all) // Safe Area를 무시하고 전체 화면을 채우도록 설정
            
            
            VStack {
                if showLottieView {
                    LottieView(filename: "middle")
                    // showLottieView가 true일 때 LottieView를 표시
                        .edgesIgnoringSafeArea(.all)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                // Lottie 애니메이션이 2초 동안 재생된 후 showLottieView를 false로 설정하고, 랜덤 카드를 선택하여 표시
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
                        //  showLottieView가 false일 때 선택된 카드가 있으면 이를 표시
                        // RandomCardView는 선택된 카드의 위치
                            .padding()
                        
                        HStack {
                            Button(action: {
                                showLottieView = true
                                // Lottie 애니메이션을 다시 표시, 카드 표시를 숨김
                                withAnimation {
                                    showCard = false
                                }
                            }) {
                                Image(systemName: "gobackward")
                                    .padding()
                                    .background(Color.gry)
                                    .foregroundColor(.black)
                                    .cornerRadius(8)
                            }
                            .padding()
                            
                            Button(action: {
                                navigateToMapView = true
                                //  "길안내 시작" 버튼으로, navigateToMapView를 true로 설정하여 지도 뷰로 네비게이션
                            }) {
                                Text("길안내 시작")
                                    .padding()
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
                // onChange(of:showCard)는 showCard가 변경될 때 랜덤 카드를 다시 선택
            }
            
            .navigationBarTitle("", displayMode: .inline)
            // 네비게이션 바 제목 숨기기
            .navigationBarBackButtonHidden(true)
            // "< Back" 버튼 숨기기
            .onAppear {
                // 초기 로딩 시 LottieView를 표시한 후 랜덤 카드 선택
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    // onAppear는 뷰가 나타날 때 Lottie 애니메이션을 표시하고, 2초 후 랜덤 카드를 선택하여 표시
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
        // selectRandomCard() 메서드는 카드 배열에서 무작위로 하나의 카드를 선택
        let cards = [
            ("SuniCardView", CLLocationCoordinate2D(latitude: 36.0079529582591, longitude: 129.329425672387)),
            ("HongunSpotCardView", CLLocationCoordinate2D(latitude: 36.0079529582591, longitude: 129.329425672387)),
            ("DeoksuPastaCardView", CLLocationCoordinate2D(latitude: 36.0079529582591, longitude: 129.329425672387)),
            ("SeaweedKimbapCardView", CLLocationCoordinate2D(latitude: 36.0079529582591, longitude: 129.329425672387))
        ]
        // 카드 배열은 각각의 카드 이름과 위치를 포함
        if let card = cards.randomElement() {
            selectedCard = (card.0, AnyView(RandomCardView(destinationCoordinate: card.1)), card.1)
            // randomElement() 메서드를 사용하여 무작위로 카드를 선택하고, selectedCard에 저장
        }
    }
}

//struct RandomView_Previews: PreviewProvider {
//    static var previews: some View {
//        RandomView(coordinate: CLLocationCoordinate2D(latitude: 36.0079529582591, longitude: 129.329425672387))
//    }
//}
