import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    var destinationCoordinate: CLLocationCoordinate2D
    @State private var region: MKCoordinateRegion
    @State private var directions: [MKRoute] = []
    @State private var showDirections = false
    @State private var navigationActive = false
    @StateObject private var locationManager = LocationManager()
    @State private var remainingTime: String = ""
    @State private var hasArrived = false
    
    init(destinationCoordinate: CLLocationCoordinate2D) {
        self.destinationCoordinate = destinationCoordinate
        self._region = State(initialValue: MKCoordinateRegion(
            center: destinationCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Group {
                    if let firstRoute = directions.first {
                        CustomMapView(
                            region: $region,
                            annotations: [
                                MapMarkerAnnotation(coordinate: locationManager.location ?? CLLocationCoordinate2D(latitude: 36.01403091416389, longitude: 129.32595552359552), isCurrentLocation: true),
                                MapMarkerAnnotation(coordinate: destinationCoordinate, isCurrentLocation: false)
                            ],
                            route: firstRoute.polyline
                        )
                    } else {
                        CustomMapView(
                            region: $region,
                            annotations: [
                                MapMarkerAnnotation(coordinate: locationManager.location ?? CLLocationCoordinate2D(latitude: 36.01403091416389, longitude: 129.32595552359552), isCurrentLocation: true),
                                MapMarkerAnnotation(coordinate: destinationCoordinate, isCurrentLocation: false)
                            ],
                            route: nil
                        )
                    }
                }
                .onAppear {
                    calculateDirections()
                }
                
                if showDirections {
                    HStack {
                        VStack {
                            Text("남은 시간: ")
                                .font(.custom("Cafe24SsurroundairOTF", size: 14))
                                .foregroundColor(.primary)
                            Text(remainingTime)
                                .font(.custom("Cafe24SsurroundairOTF", size: 26))
                                .foregroundColor(.gam)
                                .bold()
                        }
                        .padding(.horizontal)
                        if hasArrived {
                            Button(action: {
                                navigationActive = true
                            }) {
                                Text("도착")
                                    .font(.custom("Cafe24SsurroundairOTF", size: 24))
                                    .bold()
                                    .padding()
                                    .background(Color.gam)
                                    .foregroundColor(.white)
                                    .cornerRadius(25) // 끝이 둥근 직사각형 모양
                                    .frame(height: 50)
                            }
                        } else {
                            Button(action: {
                                startNavigation()
                            }) {
                                Text("길 안내 시작")
                                    .font(.custom("Cafe24SsurroundairOTF", size: 24))
                                    .bold()
                                    .padding()
                                    .background(Color.gam)
                                    .foregroundColor(.white)
                                    .cornerRadius(25) // 끝이 둥근 직사각형 모양
                                    .frame(height: 50)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $navigationActive) {
                UghView()
            }
        }
    }
    
    private func calculateDirections() {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: locationManager.location ?? CLLocationCoordinate2D(latitude: 36.01403091416389, longitude: 129.32595552359552)))
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
            updateRemainingTime()
        }
    }
    
    private func startNavigation() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            guard let currentLocation = locationManager.location else { return }
            let currentMapItem = MKMapItem(placemark: MKPlacemark(coordinate: currentLocation))
            let destinationMapItem = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
            
            let request = MKDirections.Request()
            request.source = currentMapItem
            request.destination = destinationMapItem
            request.transportType = .walking
            
            let directions = MKDirections(request: request)
            directions.calculate { response, error in
                guard let route = response?.routes.first else {
                    print("경로를 찾을 수 없음: \(error?.localizedDescription ?? "알 수 없는 오류")")
                    return
                }
                self.directions = [route]
                self.region.center = currentLocation
                updateRemainingTime()
                
                if currentLocation.latitude == destinationCoordinate.latitude && currentLocation.longitude == destinationCoordinate.longitude {
                    timer.invalidate()
                    hasArrived = true
                    print("도착했습니다.")
                }
            }
        }
    }
    
    private func updateRemainingTime() {
        guard let route = directions.first else { return }
        let travelTime = Int(route.expectedTravelTime / 60)
        remainingTime = "\(travelTime)분"
    }
}
