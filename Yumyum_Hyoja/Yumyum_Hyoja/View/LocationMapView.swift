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
    //'LocationManager'로 현재 위치 정보 관리, 'CLLocationManagerDelegate'로 위치 업데이트 및 오류 처리
    private let manager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?
    // @Published를 사용하여 location 변수 선언. 이 값이 변경될 때마다 뷰가 자동으로 업데이트됨
    override init() {
        // 초기화 메서드 init()에서 CLLocationManager의 권한 요청, 위치 업데이트를 시작
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // locationManager(_:didUpdateLocations:) 메서드는 위치가 업데이트될 때 호출, 첫 번째 위치를 location 변수에 저장
        if let location = locations.first {
            self.location = location.coordinate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) 
    // locationManager(_:didFailWithError:) 메서드는 위치 업데이트 실패 시 호출
    {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
    
    func requestLocation() {
        manager.requestLocation()
        // requestLocation() 메서드는 위치를 요청
    }
}

struct MapAnnotation: Identifiable {
    // MapAnnotation 구조체는 지도의 마커. Identifiable 프로토콜을 채택하여 고유한 식별자를 가짐
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    // coordinate 변수는 마커의 위치
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
                // 텍스트 필드에 둥근 테두리 스타일을 적용
                .padding()
                
                if let currentLocation = locationManager.location {
                    
                    // 현재 위치를 가져와 지도의 중심 설정. 현재 위치가 없으면 로딩 표시기를 보여줌.
                    Map(coordinateRegion: $region, annotationItems: locationAnnotations()) { location in
                        MapMarker(coordinate: location.coordinate, tint: .red)
                    }
                    // 지도 표시. coordinateRegion을 바인딩하여 지도 중심과 확대/축소 범위를 제어. annotationItems를 사용하여 지도에 마커를 표시
                    .onAppear {
                        region.center = currentLocation
                        // onAppear 클로저에서 region.center를 현재 위치로 설정
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    // 지도의 크기를 최대화
                } else {
                    ProgressView("위치 정보를 가져오는 중...")
                        .padding()
                        .onAppear {
                            locationManager.requestLocation()
                        }
                    // 현재 위치가 없으면 ProgressView를 표시. onAppear 클로저에서 위치를 요청
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
                        // 검색된 주소가 있으면 해당 주소와 출발지로 설정할 수 있는 버튼 표시
                        // Button 클릭 시 selectedCoordinate에 현재 지도의 중심 좌표를 저장, showLottieView를 true로 설정
                        .padding()
                        .background(Color.main)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        // 버튼 스타일을 설정: 배경색, 텍스트 색상, 테두리 모서리를 둥글게.
                    }
                    .padding()
                }
                
                Spacer() 
                // NavigationLink를 화면 하단에 고정하기 위한 공간 확보
            }
            
            .background(
                NavigationLink(destination: RandomView(coordinate: selectedCoordinate), isActive: $showLottieView) {
                    EmptyView()
                }
                // Lottie 애니메이션이 표시된 후 RandomView로 전환. selectedCoordinate를 RandomView에 전달
            )
        }
        .navigationViewStyle(StackNavigationViewStyle()) 
        // NavigationView 스타일을 StackNavigationViewStyle로 설정하여 제목을 숨김
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        
    }
    
    private func searchForLocation(query: String) {
        // 사용자가 입력한 검색어를 기반으로 위치를 검색
        let request = MKLocalSearch.Request()
        // 객체를 생성, 검색어를 설정
        request.naturalLanguageQuery = query
        let search = MKLocalSearch(request: request)
        // 객체를 생성 검색을 시작
        search.start { response, error in
            if let response = response, let item = response.mapItems.first {
                self.searchedAddress = item.placemark.title
                self.region.center = item.placemark.coordinate
            } else {
                print("검색 결과를 찾을 수 없습니다: \(error?.localizedDescription ?? "알 수 없는 오류")")
                // 검색 결과를 처리하여 첫 번째 항목의 주소와 좌표를 저장. 오류가 발생하면 오류 메시지를 출력
            }
        }
    }
    
    private func locationAnnotations() -> [MapAnnotation] {
        // locationAnnotations() 메서드는 지도에 표시할 마커 목록 반환
        var annotations = [MapAnnotation]()
        if let location = locationManager.location {
            annotations.append(MapAnnotation(coordinate: location))
        }
        // 현재 위치가 있으면 이를 마커로 추가
        if let address = searchedAddress {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address) { (placemarks, error) in
                if let placemarks = placemarks, let location = placemarks.first?.location {
                    annotations.append(MapAnnotation(coordinate: location.coordinate))
                    // 검색된 주소가 있으면 이를 지오코딩하여 위치를 얻고 마커로 추가
                }
            }
        }
        return annotations
        // 마커 목록을 반환
    }
}

//struct LocationMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocationMapView()
//    }
//}
