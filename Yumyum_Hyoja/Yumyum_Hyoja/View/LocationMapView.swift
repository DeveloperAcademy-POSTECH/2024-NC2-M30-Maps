//
//  LocationMapView.swift
//  Yumyum_Hyoja
//
//  Created by 박고운 on 6/17/24.
//

// https://velog.io/@j_aion/SwiftUI-UberClone-MapView
// https://codekodo.tistory.com/210
// https://developer.apple.com/videos/play/wwdc2023/10043/

import SwiftUI
import MapKit
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    //현재 위치 정보 관리, 위치 업데이트 및 오류 처리
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
    // 지도에 표시할 위치 정보를 담는 구조체
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct LocationMapView: View {
    //지도와 검색 기능을 제공하는 메인 뷰
    @StateObject private var locationManager = LocationManager()
    // LocationManager 클래스의 인스턴스를 생성하고 상태로 관리. 위치 업데이트를 수신하여 UI를 업데이트
    @State private var region = MKCoordinateRegion(
        // 지도의 표시 영역 정의
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // 초기 지도 중심 좌표 (샌프란시스코 기준)
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        // 확대/축소 범위를 정의
    )
    @State private var searchText = ""
    // 사용자가 입력한 검색어 저장
    @State private var searchedAddress: String? = nil
    // 검색된 주소를 저장
    @State private var showLottieView = false
    // Lottie 애니메이션을 표시할지를 결정하는 상태
    @State private var selectedCoordinate: CLLocationCoordinate2D? = nil
    // 사용자가 선택한 위치 좌표를 저장

    
    var body: some View {
        NavigationView {
            VStack {
                TextField("출발지 검색하기", text: $searchText, onCommit: {
                    searchForLocation(query: searchText)
                })
                //사용자가 출발지를 입력하는 텍스트 필드. 사용자가 입력을 완료하면 searchForLocation(query:) 메서드가 호출
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
                if let currentLocation = locationManager.location {
                    
                    // 현재 위치를 가져와 지도의 중심 설정. 현재 위치가 없으면 로딩 표시기를 보여줌.
                    Map(coordinateRegion: $region, annotationItems: locationAnnotations()) { location in
                        MapMarker(coordinate: location.coordinate, tint: .red)
                    }
                    // 지도 표시. coordinateRegion을 바인딩하여 지도 중심과 확대/축소 범위를 제어. annotationItems를 사용하여 지도에 마커를 표시
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
                        Button("출발지로 설정") {
                            selectedCoordinate = region.center
                            showLottieView = true
                            print("출발지가 설정되었습니다: \(address)")
                        }
                        // 사용자가 출발지를 설정할 수 있는 버튼. 버튼을 클릭하면 선택한 위치가 저장, Lottie 애니메이션이 표시
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding()
                }
                
                Spacer() // NavigationLink를 화면 하단에 고정하기 위한 공간 확보
            }
            
            .background(
                NavigationLink(destination: RandomView(coordinate: selectedCoordinate), isActive: $showLottieView) {
                    EmptyView()
                }
                // Lottie 애니메이션이 표시된 후 RandomView로 전환. selectedCoordinate를 RandomView에 전달합니다.
            )
        }
        .navigationViewStyle(StackNavigationViewStyle()) // NavigationView 스타일을 StackNavigationViewStyle로 설정하여 제목을 숨김
    }
    
    private func searchForLocation(query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        let search = MKLocalSearch(request: request)
        
        search.start { response, error in
            if let response = response, let item = response.mapItems.first {
                self.searchedAddress = item.placemark.title
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
        if let address = searchedAddress {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address) { (placemarks, error) in
                if let placemarks = placemarks, let location = placemarks.first?.location {
                    annotations.append(MapAnnotation(coordinate: location.coordinate))
                }
            }
        }
        return annotations
    }
}

//struct LocationMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocationMapView()
//    }
//}
