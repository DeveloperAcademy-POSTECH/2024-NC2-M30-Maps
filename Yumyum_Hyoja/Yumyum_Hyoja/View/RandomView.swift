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

    @State private var selectedCard: (name: String, view: AnyView, location: CLLocationCoordinate2D)?
    @State private var showCard = false
    @State private var showMapView = false
    @State private var showLottieView = true // 초기 로딩 시에도 LottieView를 표시
    @State private var navigateToMapView = false

    var body: some View {
        VStack {
            if showLottieView {
                LottieView(filename: "middle")
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
                    
                    HStack {
                        Button(action: {
                            showLottieView = true
                            withAnimation {
                                showCard = false
                            }
                        }) {
                            Image(systemName: "gobackward")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding()
                        
                        Button(action: {
                            navigateToMapView = true
                        }) {
                            Text("길안내 시작")
                                .padding()
                                .background(Color.green)
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
        .navigationBarTitle("", displayMode: .inline) // 네비게이션 바 제목 숨기기
                    .navigationBarBackButtonHidden(true) // "< Back" 버튼 숨기기
        .onAppear {
            // 초기 로딩 시 LottieView를 표시한 후 랜덤 카드 선택
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showLottieView = false
                    selectRandomCard()
                    showCard = true
                }
            }
        }
    }
    
    private func selectRandomCard() {
        let cards = [
            ("SuniCardView", CLLocationCoordinate2D(latitude: 36.0079529582591, longitude: 129.329425672387)),
            ("HongunSpotCardView", CLLocationCoordinate2D(latitude: 36.0079529582591, longitude: 129.329425672387)),
            ("DeoksuPastaCardView", CLLocationCoordinate2D(latitude: 36.0079529582591, longitude: 129.329425672387)),
            ("SeaweedKimbapCardView", CLLocationCoordinate2D(latitude: 36.0079529582591, longitude: 129.329425672387))
        ]
        if let card = cards.randomElement() {
            selectedCard = (card.0, AnyView(RandomCardView(destinationCoordinate: card.1)), card.1)
        }
    }
}

//struct RandomView_Previews: PreviewProvider {
//    static var previews: some View {
//        RandomView(coordinate: CLLocationCoordinate2D(latitude: 36.0079529582591, longitude: 129.329425672387))
//    }
//}
