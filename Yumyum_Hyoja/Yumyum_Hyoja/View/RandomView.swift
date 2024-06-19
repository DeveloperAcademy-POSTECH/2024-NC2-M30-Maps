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
    @State var showRandomView = false
    @State private var navigateToMapView = false

    var body: some View {
        NavigationView {
            VStack {
                
                if showRandomView{
                    if let selectedCard = selectedCard {
                        RandomCardView(destinationCoordinate: selectedCard.location)
//                        selectedCard.view
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
                else {
                    ZStack {
                        LottieView(filename: "middle")
                            .onAppear {
                    //            if coordinate != nil {
                                    selectRandomCard()
                                    showCard = true
                    //            }
                            }
                    }
                    .onAppear {
                        // 스플래시 화면이 나타날 때 애니메이션과 함께 showMainView를 true로 전환
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                             0.5초의 지연 시간을 주고, 클로저 내에서 showMainView를 true로 설정
                            withAnimation {
                                showRandomView = true
                                // showMainView가 true일 때만 해당 블록이 실행되므로, 스플래시 화면이 완전히 사라진 후에 메인 콘텐츠가 표시됩니다.
                            }
                        }
                    }
                }
            }
            .onChange(of: showCard) { newValue in
                if newValue {
                    selectRandomCard()
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

    struct RandomView_Previews: PreviewProvider {
        static var previews: some View {
            RandomView(coordinate: CLLocationCoordinate2D(latitude: 36.0079529582591, longitude: 129.329425672387))
        }
    }
