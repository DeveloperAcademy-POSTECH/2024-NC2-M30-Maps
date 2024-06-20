import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    var destinationCoordinate: CLLocationCoordinate2D
    @State private var region: MKCoordinateRegion
    @State private var directions: [MKRoute] = []
    @State private var showDirections = false
    @State private var navigationActive = false

    init(destinationCoordinate: CLLocationCoordinate2D) {
        self.destinationCoordinate = destinationCoordinate
        self._region = State(initialValue: MKCoordinateRegion(
            center: destinationCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }

    var body: some View {
        NavigationView { // NavigationView로 래핑
            ZStack {
                Map(coordinateRegion: $region, annotationItems: [MapAnnotation(coordinate: destinationCoordinate)]) { location in
                    MapMarker(coordinate: location.coordinate, tint: .red)
                }
                .onAppear {
                    calculateDirections()
                }

                VStack {
                    Spacer()
                    
                    ZStack {
                        Rectangle()
                            .foregroundStyle(.white)
                            .frame(width: 361, height: 120)
                            .cornerRadius(20)
                            .shadow(radius: 10)
                        
                        if showDirections {
                            HStack {
                                VStack {
                                    HStack {
                                        Text("걸어서 앞으로")
                                            .font(.custom("Cafe24SsurroundairOTF", size: 12))
                                            .padding(.horizontal, 14)
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        Text(" \(formattedTravelTime())")
                                            .font(.custom("Cafe24SsurroundairOTF", size: 36))
                                            .foregroundStyle(Color(red: 1, green: 0.5, blue: 0.3))
                                        Spacer()
                                    }
                                }
                                
                                NavigationLink(destination: UghView(), isActive: $navigationActive) {
                                    Button(action: {
                                        navigationActive = true
                                    }) {
                                        Circle()
                                            .frame(width: 80, height: 80)
                                            .foregroundStyle(Color(red: 1, green: 0.5, blue: 0.3))
                                            .overlay {
                                                Text("도착")
                                                    .font(.custom("Cafe24SsurroundairOTF", size: 20))
                                                    .foregroundColor(.white)
                                            }
                                    }
                                }
                            }
                            .padding(.horizontal, 14)
                        }
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
            .navigationBarTitle("back", displayMode: .inline)
            .ignoresSafeArea()
        }
    }

    private func calculateDirections() {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 36.01403091416389, longitude: 129.32595552359552)))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
        request.transportType = .walking

        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let route = response?.routes.first else {
                print("경로를 찾을 수 없음: \(error?.localizedDescription ?? "알 수 없는 오류")")
                return
            }
            self.directions = [route]
            self.showDirections = true
        }
    }

    private func formattedTravelTime() -> String {
        guard let route = directions.first else { return "" }
        let travelTime = Int(route.expectedTravelTime / 60)
        return "\(travelTime)분"
    }
}
