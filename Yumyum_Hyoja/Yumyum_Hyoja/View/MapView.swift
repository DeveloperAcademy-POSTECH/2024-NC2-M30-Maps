//
//  MapView.swift
//  Yumyum_Hyoja
//
//  Created by 박고운 on 6/17/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    var destinationCoordinate: CLLocationCoordinate2D
    // destinationCoordinate 변수는 목적지의 좌표를 저장
    @State private var region: MKCoordinateRegion
    // region은 지도의 현재 영역
    @State private var directions: [MKRoute] = []
    // directions는 계산된 경로를 저장
    @State private var showDirections = false
    // showDirections는 경로 정보 표시 여부를 제어
    @State private var navigationActive = false
    // navigationActive는 NavigationLink 활성화 여부 제어
    
    init(destinationCoordinate: CLLocationCoordinate2D) {
        // 초기화 메서드 init은 목적지 좌표를 받아 region의 초기 값을 설정
        self.destinationCoordinate = destinationCoordinate
        self._region = State(initialValue: MKCoordinateRegion(
            center: destinationCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, annotationItems: [MapAnnotation(coordinate: destinationCoordinate)]) { location in
                MapMarker(coordinate: location.coordinate, tint: .red)
                
            }
            // Map 뷰를 표시. 지도는 region을 바인딩하여 중심 좌표와 확대/축소 범위를 제어
            // annotationItems를 사용하여 목적지 위치에 마커를 표시
            .onAppear {
                calculateDirections()
            }
            // onAppear 수식어는 뷰가 나타날 때 calculateDirections() 메서드를 호출하여 경로를 계산
            
            if showDirections {
                HStack {
                    VStack {
                        Text("걸어서 앞으로: ")
                            .font(.headline)
                            .foregroundColor(.primary)
                            + Text(" \(formattedTravelTime())")
                        // showDirections가 true인 경우 예상 도보 시간을 텍스트로 표시하고, 도착 버튼을 추가
                                .font(.title) // 원하는 글꼴 크기로 설정
                                .foregroundColor(.gam) // 원하는 색상으로 설정
                                .bold() // 필요에 따라 굵게 설정
                            
                    } 
                    .padding()
                    Button(action: {
                        navigationActive = true
                        // 도착 버튼을 누르면 navigationActive가 true로 설정되어 NavigationLink가 활성화
                    }) {
                        Text("도착")
                            .padding()
                            .background(Color.gam)
                            .foregroundColor(.white)
                            .clipShape(Circle()) // 버튼 모양을 동그랗게 설정
                    }
                }
                .padding()
            }
        }
        .navigationBarTitle("", displayMode: .inline) 
        // 네비게이션 바 제목 숨기기
         .navigationBarBackButtonHidden(true) 
        // "< Back" 버튼 숨기기
        .background(
            NavigationLink(destination: UghView(), isActive: $navigationActive) {
                EmptyView()
            }
            // NavigationLink는 navigationActive 상태를 바인딩하여 UghView로 네비게이션
        )
    }
    
    private func calculateDirections() {
        // calculateDirections() 메서드는 경로를 계산
        let request = MKDirections.Request()
        
        // MKDirections.Request 객체를 생성하고 출발지와 목적지를 설정
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 36.01403091416389, longitude: 129.32595552359552)))
        // request.source는 출발지 좌표를 설정
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
        // request.destination은 목적지 좌표를 설정
        request.transportType = .walking
        // request.transportType은 이동 수단을 도보로 설정
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            // MKDirections 객체를 생성하고 calculate 메서드를 호출하여 경로를 계산
            guard let route = response?.routes.first else {
                print("경로를 찾을 수 없음: \(error?.localizedDescription ?? "알 수 없는 오류")")
                return
            }
            self.directions = [route]
            self.showDirections = true
            
            // response에서 첫 번째 경로를 가져와 directions 배열에 저장하고, showDirections를 true로 설정하여 경로 정보를 표시
            
        }
    }
    
    private func formattedTravelTime() -> String {
        // formattedTravelTime() 메서드는 예상 도보 시간을 분 단위로 계산하여 문자열로 반환
        guard let route = directions.first else { return "" }
        let travelTime = Int(route.expectedTravelTime / 60)
        return "\(travelTime)분"
        // directions 배열의 첫 번째 경로를 가져와 예상 이동 시간을 계산
        // expectedTravelTime은 초 단위로 제공되므로 60으로 나누어 분 단위로 변환
        // 변환된 시간을 문자열로 반환
    }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView(destinationCoordinate: CLLocationCoordinate2D(latitude: 36.0083109245033, longitude: 129.331608703121))
//    }
//}
