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
                                
                                Rectangle()
                                    .cornerRadius(20)
                                    .frame(width: 80, height: 80)
                                    .foregroundStyle(Color(red: 0.9, green: 0.9, blue: 0.94))
                                    .overlay {
                                        Image(systemName: "arrow.clockwise")
                                            .font(.title)
                                            .padding()
                                            .foregroundColor(.black)
                                    }
                                    
                            }
                            .padding(.leading, 40)
                            
                            Button(action: {
                                showLottieView = true
                                lottieFilename = "runhyo"
                                withAnimation {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        navigateToMapView = true
                                    }
                                }
                            }) {
                                
                                Rectangle()
                                    .cornerRadius(20)
                                    .frame(width: 273, height: 80)
                                    .foregroundStyle(Color(red: 1, green: 0.5, blue: 0.3))
                                    .overlay {
                                        Text("길안내 시작")
                                            .font(.custom("Cafe24SsurroundairOTF", size: 24))
                                            .foregroundColor(.white)
                                    }
                            }
                            .padding(.trailing, 40)
                            .background(
                                NavigationLink(destination: MapView(destinationCoordinate: selectedCard.location), isActive: $navigateToMapView) {
                                    EmptyView()
                                }
                                .hidden()
                            )
                        }
                        .padding(.top, 40)
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

struct RandomView_Previews: PreviewProvider {
    static var previews: some View {
        RandomView()
    }
}
