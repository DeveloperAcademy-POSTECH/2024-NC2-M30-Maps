import SwiftUI
import CoreLocation

struct RandomView: View {
    var coordinate: CLLocationCoordinate2D?
    
    @State private var selectedCard: (name: String, view: AnyView, location: CLLocationCoordinate2D)?
    @State private var showCard = false
    @State private var showMapView = false
    @State private var showLottieView = true
    @State private var navigateToMapView = false
    @State private var lottieFilename = "middle"
    
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
                                    .background(Color.orange)
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
            ("홍운반점", CLLocationCoordinate2D(latitude: 36.0079529582591, longitude: 129.329425672387)),
            ("덕수파스타", CLLocationCoordinate2D(latitude: 36.0079529582591, longitude: 129.329425672387)),
            ("김고미김밥", CLLocationCoordinate2D(latitude: 36.0079529582591, longitude: 129.329425672387))
        ]
        if let card = cards.randomElement() {
            selectedCard = (card.0, AnyView(RandomCardView(destinationCoordinate: card.1)), card.1)
        }
    }
}
