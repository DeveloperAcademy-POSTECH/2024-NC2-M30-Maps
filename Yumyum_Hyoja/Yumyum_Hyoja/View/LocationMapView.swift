import SwiftUI
import MapKit
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?
    // manager: CLLocationManager의 인스턴스. 위치 정보를 요청하고 업데이트
    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    // init(): 초기화 시 CLLocationManagerDelegate를 설정하고, 위치 권한을 요청하며, 위치 업데이트를 시작
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.location = location.coordinate
        }
    }
// locationManager(_:didUpdateLocations:): 위치가 업데이트될 때 호출. 첫 번째 위치를 location에 저장
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
// locationManager(_:didFailWithError:): 위치 업데이트가 실패할 때 호출
    func requestLocation() {
        manager.requestLocation()
    }
}
// requestLocation(): 한 번의 위치 요청을 수행
struct MapAnnotation: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}
// coordinate: 주석의 위치를 나타내는 좌표

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
//locationManager: LocationManager의 인스턴스를 생성
//region: 지도의 현재 영역을 정의
//searchText: 검색 창에 입력된 텍스트를 저장
//searchedAddress: 검색된 주소를 저장
//showLottieView: 네비게이션 링크 활성화 여부를 제어
//selectedCoordinate: 선택된 출발지 좌표를 저장
//searchedCoordinate: 검색된 좌표를 저장
    
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
// CustomMapView: 사용자의 현재 위치 또는 검색된 위치를 보여주는 지도 뷰
//  ProgressView: 위치 정보를 가져오는 중일 때 표시
                
                if let address = searchedAddress {
                    VStack {
                        Text(address)
                            .font(.custom("Cafe24SsurroundairOTF", size: 16))
                            .padding()
                        Button(action: {
                            selectedCoordinate = region.center
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
    // NavigationLink: showLottieView가 true일 때 RandomView로 네비게이션

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
//query: 사용자가 입력한 검색어.
//MKLocalSearch: 검색 요청을 수행하는 객체.
//response: 검색 결과를 처리
    
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
// annotations: 현재 위치와 검색된 위치를 저장하는 배열


