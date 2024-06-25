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
        NavigationStack {
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
                                        .background(Color.gam)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                                .padding()
                            }
                        }
                    }
                }
                .onChange(of: showCard) {
                    selectRandomCard()
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
                .navigationDestination(isPresented: $navigateToMapView) {
                    if let selectedCard = selectedCard {
                        MapView(destinationCoordinate: selectedCard.location)
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
