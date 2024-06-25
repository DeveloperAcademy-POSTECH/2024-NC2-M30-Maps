import SwiftUI
import MapKit
import CoreLocation
import Foundation

struct LocationMapView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var searchText = ""
    @State private var searchedAddress: String? = nil
    @State private var showLottieView = false
    @State private var selectedCoordinate: HashableCoordinate? = nil
    @State private var searchedCoordinate: CLLocationCoordinate2D? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("출발지 검색하기", text: $searchText, onCommit: {
                    if searchText.isEmpty {
                        if let currentLocation = locationManager.location {
                            selectedCoordinate = HashableCoordinate(currentLocation)
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
                    CustomMapView(region: $region, annotations: locationAnnotations(currentLocation: currentLocation), route: nil)
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
                            .font(.custom("Cafe24SsurroundairOTF", size: 16))
                            .padding()
                        Button(action: {
                            selectedCoordinate = HashableCoordinate(region.center)
                            showLottieView = true
                            print("출발지가 설정되었습니다: \(address)")
                        }) {
                            Text("출발지로 설정")
                                .font(.custom("Cafe24SsurroundairOTF", size: 24))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.main)
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
                NavigationLink(
                    value: selectedCoordinate,
                    label: {
                        EmptyView()
                    }
                )
                .hidden()
            )
            .navigationDestination(isPresented: $showLottieView) {
                if let selectedCoordinate = selectedCoordinate {
                    RandomView(coordinate: selectedCoordinate.coordinate)
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
    
    private func locationAnnotations(currentLocation: CLLocationCoordinate2D) -> [MapMarkerAnnotation] {
        var annotations = [MapMarkerAnnotation]()
        annotations.append(MapMarkerAnnotation(coordinate: currentLocation, isCurrentLocation: true))
        if let coordinate = searchedCoordinate {
            annotations.append(MapMarkerAnnotation(coordinate: coordinate, isCurrentLocation: false))
        }
        return annotations
    }
}
