import SwiftUI
import MapKit
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.location = location.coordinate
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }

    func requestLocation() {
        manager.requestLocation()
    }
}

struct MapAnnotation: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct LocationMapView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var searchText = ""
    @State private var searchedAddress: String? = nil
    @State private var showLottieView = false
    @State private var selectedCoordinate: CLLocationCoordinate2D? = nil
    @State private var searchedCoordinate: CLLocationCoordinate2D? = nil

    var body: some View {
        NavigationView {
            VStack {
                TextField("출발지 검색하기", text: $searchText, onCommit: {
                    if searchText.isEmpty {
                        if let currentLocation = locationManager.location {
                            selectedCoordinate = currentLocation
                            showLottieView = true
                            print("현재 위치에서 출발합니다: \(currentLocation)")
                        }
                    } else {
                        searchForLocation(query: searchText)
                    }
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

                if let currentLocation = locationManager.location {
                    CustomMapView(region: $region, annotations: locationAnnotations(), isDestinationMapView: false)
                        .onAppear {
                            region.center = currentLocation
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ProgressView("위치 정보를 가져오는 중...")
                        .padding()
                        .onAppear {
                            locationManager.requestLocation()
                        }
                }

                if let address = searchedAddress {
                    VStack {
                        Text(address)
                            .padding()
                        Button(action: {
                            selectedCoordinate = region.center
                            showLottieView = true
                            print("출발지가 설정되었습니다: \(address)")
                        }) {
                            Text("출발로 설정")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding()
                    }
                    .padding()
                }

                Spacer()
            }
            .background(
                NavigationLink(destination: RandomView(coordinate: selectedCoordinate), isActive: $showLottieView) {
                    EmptyView()
                }
            )
            .navigationBarHidden(true) // 네비게이션 바 숨김
        }
        .navigationViewStyle(StackNavigationViewStyle()) 
        // NavigationView 스타일을 StackNavigationViewStyle로 설정하여 제목을 숨김
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
    }

    private func searchForLocation(query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let response = response, let item = response.mapItems.first {
                self.searchedAddress = item.placemark.title
                self.searchedCoordinate = item.placemark.coordinate
                self.region.center = item.placemark.coordinate
            } else {
                print("검색 결과를 찾을 수 없습니다: \(error?.localizedDescription ?? "알 수 없는 오류")")
            }
        }
    }

    private func locationAnnotations() -> [MapAnnotation] {
        var annotations = [MapAnnotation]()
        if let location = locationManager.location {
            annotations.append(MapAnnotation(coordinate: location))
        }
        if let coordinate = searchedCoordinate {
            annotations.append(MapAnnotation(coordinate: coordinate))
        }
        return annotations
    }
}



//struct LocationMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocationMapView()
//    }
//}
