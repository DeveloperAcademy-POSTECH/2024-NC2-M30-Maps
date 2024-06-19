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
    
    @State private var cards: [(name: String, view: AnyView, location: CLLocationCoordinate2D)] = [
        ("SuniCardView", AnyView(SuniCardView()), CLLocationCoordinate2D(latitude: 36.0079529582591, longitude: 129.329425672387)),
        ("HongunSpotCardView", AnyView(HongunSpotCardView()), CLLocationCoordinate2D(latitude: 36.0079529582591, longitude: 129.329425672387)),
        ("DeoksuPastaCardView", AnyView(DeoksuPastaCardView()), CLLocationCoordinate2D(latitude: 36.0079529582591, longitude: 129.329425672387)),
        ("SeaweedKimbapCardView", AnyView(SeaweedKimbapCardView()), CLLocationCoordinate2D(latitude: 36.0079529582591, longitude: 129.329425672387))
        // 다른 카드들도 추가할 수 있음
    ]
    @State private var selectedCard: (name: String, view: AnyView, location: CLLocationCoordinate2D)?
    @State private var showCard = false
    @State private var showMapView = false

    var body: some View {
        NavigationView {
            VStack {
                if let selectedCard = selectedCard {
                    selectedCard.view
                        .padding()
                    
                    HStack {
                        Button(action: {
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
                        
//                        NavigationLink(destination: MapView(location: selectedCard.location)) {
//                            Text("길안내 시작")
//                                .padding()
//                                .background(Color.green)
//                                .foregroundColor(.white)
//                                .cornerRadius(8)
//                        }
                        .padding()
                    }
                } else {
                    ZStack {
                        LottieView(filename: "Animation - test")
                    }
                }
            }
            .onChange(of: showCard) { newValue in
                if newValue {
                    selectRandomCard()
                }
            }
        }
        .onAppear {
            if coordinate != nil {
                selectRandomCard()
                showCard = true
            }
        }
    }
    
    private func selectRandomCard() {
        if let card = cards.first(where: { $0.location == coordinate }) {
            selectedCard = card
        }
    }
}

//struct RandomView_Previews: PreviewProvider {
//    static var previews: some View {
//        RandomView(coordinate: nil) // 좌표를 전달하도록 수정
//    }
//}
